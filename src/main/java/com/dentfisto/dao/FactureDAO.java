package com.dentfisto.dao;

import com.dentfisto.model.Facture;
import com.dentfisto.model.Paiement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class FactureDAO {

    // --- CONSTANTES SQL ---
    // Appel de la fonction MySQL que vous avez créée
    private static final String SQL_CALCULER_MONTANT = "SELECT calculerMontantFacture(?) AS total";
    
    private static final String SQL_INSERT_FACTURE = 
        "INSERT INTO facture (montantTotal, cheminPdf, dateFacturation, consultationId) VALUES (?, ?, ?, ?)";
        
    private static final String SQL_INSERT_PAIEMENT = 
        "INSERT INTO paiement (modeReglement, factureId) VALUES (?, ?)";

    /**
     * Génère une facture et enregistre le paiement initial dans une TRANSACTION ACID.
     */
    public boolean genererFactureEtPayer(Facture facture, Paiement paiement) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            
            // 1. DÉMARRAGE DE LA TRANSACTION
            conn.setAutoCommit(false); 

            // 2. Calculer le montant exact via la base de données
            double montantCalcule = 0;
            try (PreparedStatement stmtCalcul = conn.prepareStatement(SQL_CALCULER_MONTANT)) {
                stmtCalcul.setInt(1, facture.getConsultationId());
                try (ResultSet rs = stmtCalcul.executeQuery()) {
                    if (rs.next()) {
                        montantCalcule = rs.getDouble("total");
                    }
                }
            }
            
            // Si le montant est 0, on peut décider d'annuler ou de continuer (selon les règles du cabinet)
            facture.setMontantTotal(montantCalcule);

            // 3. Insérer la facture et récupérer son ID généré (AUTO_INCREMENT)
            int factureIdGenere = -1;
            try (PreparedStatement stmtFacture = conn.prepareStatement(SQL_INSERT_FACTURE, Statement.RETURN_GENERATED_KEYS)) {
                stmtFacture.setDouble(1, facture.getMontantTotal());
                stmtFacture.setString(2, facture.getCheminPdf());
                stmtFacture.setDate(3, Date.valueOf(facture.getDateFacturation()));
                stmtFacture.setInt(4, facture.getConsultationId());
                
                stmtFacture.executeUpdate();
                
                try (ResultSet generatedKeys = stmtFacture.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        factureIdGenere = generatedKeys.getInt(1);
                    } else {
                        throw new SQLException("Échec de la création de la facture, aucun ID obtenu.");
                    }
                }
            }

            // 4. Lier et insérer le paiement
            paiement.setFactureId(factureIdGenere);
            try (PreparedStatement stmtPaiement = conn.prepareStatement(SQL_INSERT_PAIEMENT)) {
                stmtPaiement.setString(1, paiement.getModeReglement());
                stmtPaiement.setInt(2, paiement.getFactureId());
                stmtPaiement.executeUpdate();
            }

            // 5. VALIDATION DE LA TRANSACTION
            conn.commit();
            return true;

        } catch (SQLException e) {
            System.err.println("Erreur de transaction, annulation (Rollback) : " + e.getMessage());
            if (conn != null) {
                try {
                    // EN CAS D'ERREUR : On annule tout !
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            return false;
        } finally {
            // 6. Rétablir le mode normal (AutoCommit) pour les prochaines requêtes
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}