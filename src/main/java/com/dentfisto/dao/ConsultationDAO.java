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

    // --- CONSTANTES SQL ---
    // Récupérer la consultation vide générée par le Trigger
    private static final String SQL_GET_PAR_RDV = "SELECT * FROM consultation WHERE rdvId = ?";
    
    // Mettre à jour avec le diagnostic du dentiste
    private static final String SQL_UPDATE_CONSULTATION = 
        "UPDATE consultation SET diagnostic = ?, observations = ? WHERE id = ?";
        
    // Insérer dans la table de liaison Many-to-Many
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

    /**
     * Récupère la consultation associée à un rendez-vous spécifique.
     */
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

    /**
     * Sauvegarde la fin de la consultation (Diagnostic + Liste des actes) dans une Transaction.
     * Met également à jour les actes en supprimant les anciens avant d'insérer les nouveaux.
     */
    public boolean sauvegarderConsultation(Consultation consultation) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // 1. Début de la transaction

            // 2. Mettre à jour le diagnostic et les observations
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

            // 3. Insérer tous les actes réalisés (Parcours de la List<Acte>)
            if (consultation.getActesRealises() != null && !consultation.getActesRealises().isEmpty()) {
                try (PreparedStatement stmtActe = conn.prepareStatement(SQL_INSERT_ACTE)) {
                    for (Acte acte : consultation.getActesRealises()) {
                        stmtActe.setInt(1, consultation.getId());
                        stmtActe.setInt(2, acte.getId());
                        stmtActe.executeUpdate(); // On exécute l'insertion pour chaque acte
                    }
                }
            }

            conn.commit(); // 4. Validation si tout s'est bien passé
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