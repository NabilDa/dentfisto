package com.dentfisto.dao;

import com.dentfisto.model.Ordonnance;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class OrdonnanceDAO {

    private static final String SQL_INSERT_ORDONNANCE = 
        "INSERT INTO ordonnance (cheminPdf, consultationId) VALUES (?, ?)";

    private static final String SQL_GET_BY_CONSULTATION =
        "SELECT * FROM ordonnance WHERE consultationId = ?";

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

    public Ordonnance getByConsultationId(int consultationId) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_GET_BY_CONSULTATION)) {

            stmt.setInt(1, consultationId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Ordonnance o = new Ordonnance();
                    o.setId(rs.getInt("id"));
                    o.setCheminPdf(rs.getString("cheminPdf"));
                    o.setConsultationId(rs.getInt("consultationId"));
                    return o;
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur getByConsultationId : " + e.getMessage());
        }
        return null;
    }
}