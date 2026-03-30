package com.dentfisto.dao;

import com.dentfisto.model.Acte;
import com.dentfisto.model.Consultation;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ConsultationDAO {

    private static final String SQL_GET_PAR_RDV = "SELECT * FROM consultation WHERE rdvId = ?";
    
    private static final String SQL_UPDATE_CONSULTATION = 
        "UPDATE consultation SET diagnostic = ?, observations = ? WHERE id = ?";
        
    private static final String SQL_INSERT_ACTE = 
        "INSERT INTO consultationActe (consultationId, acteId) VALUES (?, ?)";

    private static final String SQL_DELETE_ACTES =
        "DELETE FROM consultationActe WHERE consultationId = ?";

    private static final String SQL_GET_BY_DOSSIER =
        "SELECT c.*, r.dateRdv, r.heureDebut, r.motif " +
        "FROM consultation c JOIN rendezVous r ON c.rdvId = r.id " +
        "WHERE c.dossierId = ? ORDER BY r.dateRdv DESC";

    private static final String SQL_GET_ACTES_FOR_CONSULTATION =
        "SELECT a.* FROM acte a JOIN consultationActe ca ON a.id = ca.acteId WHERE ca.consultationId = ?";

    private static final String SQL_GET_BY_ID =
        "SELECT * FROM consultation WHERE id = ?";

    public Consultation getConsultationParRdv(int rdvId) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_GET_PAR_RDV)) {
             
            stmt.setInt(1, rdvId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur récupération consultation : " + e.getMessage());
        }
        return null;
    }

    public Consultation getById(int id) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_GET_BY_ID)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            System.err.println("Erreur getById consultation : " + e.getMessage());
        }
        return null;
    }

    public boolean sauvegarderConsultation(Consultation consultation) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Update diagnostic and observations
            try (PreparedStatement stmtUpdate = conn.prepareStatement(SQL_UPDATE_CONSULTATION)) {
                stmtUpdate.setString(1, consultation.getDiagnostic());
                stmtUpdate.setString(2, consultation.getObservations());
                stmtUpdate.setInt(3, consultation.getId());
                stmtUpdate.executeUpdate();
            }

            // Clear existing actes then re-insert
            try (PreparedStatement stmtDel = conn.prepareStatement(SQL_DELETE_ACTES)) {
                stmtDel.setInt(1, consultation.getId());
                stmtDel.executeUpdate();
            }

            if (consultation.getActesRealises() != null && !consultation.getActesRealises().isEmpty()) {
                try (PreparedStatement stmtActe = conn.prepareStatement(SQL_INSERT_ACTE)) {
                    for (Acte acte : consultation.getActesRealises()) {
                        stmtActe.setInt(1, consultation.getId());
                        stmtActe.setInt(2, acte.getId());
                        stmtActe.executeUpdate();
                    }
                }
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            System.err.println("Erreur, annulation de la sauvegarde (Rollback) : " + e.getMessage());
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            return false;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    }

    /**
     * Get all consultations for a dossier (consultation history).
     */
    public List<Consultation> getConsultationsByDossier(int dossierId) {
        List<Consultation> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_GET_BY_DOSSIER)) {

            stmt.setInt(1, dossierId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Consultation c = mapRow(rs);
                    // extra fields from JOIN
                    try { c.setDateConsultation(rs.getDate("dateRdv").toLocalDate()); } catch (Exception ignored) {}
                    try { c.setHeureConsultation(rs.getTime("heureDebut").toLocalTime()); } catch (Exception ignored) {}
                    try { c.setMotifRdv(rs.getString("motif")); } catch (Exception ignored) {}
                    list.add(c);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur getConsultationsByDossier : " + e.getMessage());
        }
        return list;
    }

    /**
     * Load actes for a specific consultation.
     */
    public List<Acte> getActesForConsultation(int consultationId) {
        List<Acte> actes = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_GET_ACTES_FOR_CONSULTATION)) {

            stmt.setInt(1, consultationId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Acte a = new Acte();
                    a.setId(rs.getInt("id"));
                    a.setCode(rs.getString("code"));
                    a.setNom(rs.getString("nom"));
                    a.setTarifBase(rs.getDouble("tarifBase"));
                    actes.add(a);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur getActesForConsultation : " + e.getMessage());
        }
        return actes;
    }

    private Consultation mapRow(ResultSet rs) throws SQLException {
        Consultation c = new Consultation();
        c.setId(rs.getInt("id"));
        c.setDiagnostic(rs.getString("diagnostic"));
        c.setObservations(rs.getString("observations"));
        c.setRdvId(rs.getInt("rdvId"));
        c.setDossierId(rs.getInt("dossierId"));
        return c;
    }
}