package com.dentfisto.dao;

import com.dentfisto.model.Document;
import com.dentfisto.model.DossierMedical;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DossierMedicalDAO {

    // --- CONSTANTES SQL ---
    private static final String SQL_GET_DOSSIER_BY_PATIENT = "SELECT * FROM dossierMedical WHERE patientId = ?";
    private static final String SQL_GET_DOCUMENTS = "SELECT * FROM document WHERE dossierId = ?";
    private static final String SQL_INSERT_DOCUMENT = 
        "INSERT INTO document (type, dateImportation, cheminAcces, dossierId) VALUES (?, ?, ?, ?)";

    /**
     * Récupère le dossier médical complet d'un patient, incluant ses documents.
     */
    public DossierMedical getDossierComplet(int patientId) {
        DossierMedical dossier = null;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmtDossier = conn.prepareStatement(SQL_GET_DOSSIER_BY_PATIENT)) {

            stmtDossier.setInt(1, patientId);
            try (ResultSet rsDossier = stmtDossier.executeQuery()) {
                if (rsDossier.next()) {
                    dossier = new DossierMedical();
                    dossier.setId(rsDossier.getInt("id"));
                    dossier.setNumeroReference(rsDossier.getString("numeroReference"));
                    dossier.setDateCreation(rsDossier.getDate("dateCreation").toLocalDate());
                    dossier.setPatientId(rsDossier.getInt("patientId"));

                    // Maintenant que l'on a le dossier, on va chercher ses documents pour remplir sa liste
                    try (PreparedStatement stmtDocs = conn.prepareStatement(SQL_GET_DOCUMENTS)) {
                        stmtDocs.setInt(1, dossier.getId());
                        try (ResultSet rsDocs = stmtDocs.executeQuery()) {
                            while (rsDocs.next()) {
                                Document doc = new Document();
                                doc.setId(rsDocs.getInt("id"));
                                doc.setType(rsDocs.getString("type"));
                                doc.setDateImportation(rsDocs.getDate("dateImportation").toLocalDate());
                                doc.setCheminAcces(rsDocs.getString("cheminAcces"));
                                doc.setDossierId(rsDocs.getInt("dossierId"));
                                
                                // Ajout dans la boîte (la liste du modèle)
                                dossier.getDocumentsAnnexes().add(doc);
                            }
                        }
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur lors de la récupération du dossier : " + e.getMessage());
        }
        return dossier;
    }

    /**
     * Ajoute un nouveau document (radiographie, analyse, etc.) au dossier.
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
     * Creates a new dossierMedical for a patient if one doesn't exist.
     * Returns the created DossierMedical, or null on failure.
     */
    public DossierMedical creerDossier(int patientId) {
        String ref = "DM-" + java.time.LocalDate.now().getYear() + "-" + String.format("%03d", patientId);
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                     "INSERT INTO dossierMedical (numeroReference, dateCreation, patientId) VALUES (?, CURDATE(), ?)",
                     PreparedStatement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, ref);
            stmt.setInt(2, patientId);
            stmt.executeUpdate();

            try (ResultSet keys = stmt.getGeneratedKeys()) {
                if (keys.next()) {
                    DossierMedical d = new DossierMedical();
                    d.setId(keys.getInt(1));
                    d.setNumeroReference(ref);
                    d.setDateCreation(java.time.LocalDate.now());
                    d.setPatientId(patientId);
                    return d;
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur création dossier médical : " + e.getMessage());
        }
        return null;
    }
}