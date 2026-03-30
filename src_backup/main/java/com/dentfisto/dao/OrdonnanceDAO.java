package com.dentfisto.dao;

import com.dentfisto.model.Ordonnance;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class OrdonnanceDAO {

    private static final String SQL_INSERT_ORDONNANCE = 
        "INSERT INTO ordonnance (cheminPdf, consultationId) VALUES (?, ?)";

    /**
     * Enregistre l'ordonnance générée à la fin d'une consultation.
     */
    public boolean sauvegarderOrdonnance(Ordonnance ordonnance) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_INSERT_ORDONNANCE)) {

            stmt.setString(1, ordonnance.getCheminPdf());
            stmt.setInt(2, ordonnance.getConsultationId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Erreur lors de la sauvegarde de l'ordonnance : " + e.getMessage());
            return false;
        }
    }
}