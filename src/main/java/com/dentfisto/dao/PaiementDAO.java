package com.dentfisto.dao;

import com.dentfisto.model.Paiement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class PaiementDAO {

    private static final String SQL_INSERT_PAIEMENT = 
        "INSERT INTO paiement (modeReglement, factureId) VALUES (?, ?)";

    /**
     * Ajoute un paiement supplémentaire à une facture existante.
     */
    public boolean ajouterPaiement(Paiement paiement) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_INSERT_PAIEMENT)) {

            stmt.setString(1, paiement.getModeReglement());
            stmt.setInt(2, paiement.getFactureId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Erreur lors de l'enregistrement du paiement : " + e.getMessage());
            return false;
        }
    }
}