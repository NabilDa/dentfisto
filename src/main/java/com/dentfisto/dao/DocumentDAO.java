package com.dentfisto.dao;

import com.dentfisto.model.Document;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DocumentDAO {

    // --- CONSTANTES SQL ---
    private static final String SQL_INSERT_DOCUMENT = 
        "INSERT INTO document (type, dateImportation, cheminAcces, dossierId) VALUES (?, ?, ?, ?)";
        
    private static final String SQL_GET_DOCUMENT_BY_ID = 
        "SELECT * FROM document WHERE id = ?";
        
    private static final String SQL_DELETE_DOCUMENT = 
        "DELETE FROM document WHERE id = ?";

    /**
     * Ajoute un nouveau document (radiographie, compte-rendu, etc.) au dossier médical.
     */
    public boolean ajouterDocument(Document document) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_INSERT_DOCUMENT)) {

            stmt.setString(1, document.getType());
            stmt.setDate(2, Date.valueOf(document.getDateImportation()));
            stmt.setString(3, document.getCheminAcces());
            stmt.setInt(4, document.getDossierId());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Erreur lors de l'ajout du document : " + e.getMessage());
            return false;
        }
    }

    /**
     * Récupère un document spécifique via son ID (Très utile pour créer un lien de téléchargement ou d'affichage).
     */
    public Document getDocumentById(int id) {
        Document document = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_GET_DOCUMENT_BY_ID)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    document = new Document();
                    document.setId(rs.getInt("id"));
                    document.setType(rs.getString("type"));
                    document.setDateImportation(rs.getDate("dateImportation").toLocalDate());
                    document.setCheminAcces(rs.getString("cheminAcces"));
                    document.setDossierId(rs.getInt("dossierId"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur lors de la récupération du document : " + e.getMessage());
        }
        return document;
    }

    /**
     * Supprime un document (si le dentiste a importé le mauvais fichier par erreur).
     */
    public boolean supprimerDocument(int id) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_DELETE_DOCUMENT)) {

            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Erreur lors de la suppression du document : " + e.getMessage());
            return false;
        }
    }
}