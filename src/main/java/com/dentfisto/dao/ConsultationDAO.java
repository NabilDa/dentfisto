package com.dentfisto.dao;

import com.dentfisto.model.Acte;
import com.dentfisto.model.Consultation;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

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

    /**
     * Récupère la consultation associée à un rendez-vous spécifique.
     */
    public Consultation getConsultationParRdv(int rdvId) {
        Consultation consultation = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_GET_PAR_RDV)) {
             
            stmt.setInt(1, rdvId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    consultation = new Consultation();
                    consultation.setId(rs.getInt("id"));
                    consultation.setDiagnostic(rs.getString("diagnostic"));
                    consultation.setObservations(rs.getString("observations"));
                    consultation.setRdvId(rs.getInt("rdvId"));
                    consultation.setDossierId(rs.getInt("dossierId"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur récupération consultation : " + e.getMessage());
        }
        return consultation;
    }

    /**
     * Sauvegarde la fin de la consultation (Diagnostic + Liste des actes) dans une Transaction.
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
                try { conn.setAutoCommit(true); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    }
}