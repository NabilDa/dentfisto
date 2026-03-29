package com.dentfisto.dao;

import com.dentfisto.model.Patient;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class PatientDAO {

    // --- CONSTANTES SQL ---
    private static final String SQL_INSERT_PATIENT = 
        "INSERT INTO patient (nom, prenom, dateNaissance, sexe, adresse, telephone, " +
        "cnssMutuelle, antecedentsMedicaux, allergieCritique, responsableLegalNom, responsableLegalTel) " +
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
    private static final String SQL_RECHERCHE_PAR_NOM_TEL = 
        "SELECT * FROM patient WHERE nom LIKE ? AND telephone = ?";

    /**
     * Insère un nouveau patient dans la base de données.
     */
    public boolean ajouterPatient(Patient patient) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_INSERT_PATIENT)) {

            // Champs obligatoires
            stmt.setString(1, patient.getNom());
            stmt.setString(2, patient.getPrenom());
            stmt.setDate(3, Date.valueOf(patient.getDateNaissance())); // Conversion LocalDate vers java.sql.Date
            stmt.setString(4, patient.getSexe());
            stmt.setString(5, patient.getAdresse());
            stmt.setString(6, patient.getTelephone());
            
            // Champs optionnels (peuvent être null)
            stmt.setString(7, patient.getCnssMutuelle());
            stmt.setString(8, patient.getAntecedentsMedicaux());
            stmt.setString(9, patient.getAllergieCritique());
            stmt.setString(10, patient.getResponsableLegalNom());
            stmt.setString(11, patient.getResponsableLegalTel());

            int lignesAffectees = stmt.executeUpdate();
            return lignesAffectees > 0; // Retourne true si l'insertion a réussi

        } catch (SQLException e) {
            // C'est ici que l'on va attraper les erreurs générées par vos Triggers MySQL (ex: SQLSTATE '45000')
            System.err.println("Erreur SQL lors de l'ajout du patient : " + e.getMessage());
            return false;
        }
    }

    /**
     * Recherche un patient via son nom et son téléphone.
     */
    public Patient rechercherPatient(String nom, String telephone) {
        Patient patient = null;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_RECHERCHE_PAR_NOM_TEL)) {

            // Utilisation de LIKE pour le nom afin d'être un peu plus flexible sur la saisie
            stmt.setString(1, "%" + nom + "%"); 
            stmt.setString(2, telephone);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    patient = new Patient();
                    patient.setId(rs.getInt("id"));
                    patient.setNom(rs.getString("nom"));
                    patient.setPrenom(rs.getString("prenom"));
                    patient.setDateNaissance(rs.getDate("dateNaissance").toLocalDate());
                    patient.setSexe(rs.getString("sexe"));
                    patient.setAdresse(rs.getString("adresse"));
                    patient.setTelephone(rs.getString("telephone"));
                    patient.setCnssMutuelle(rs.getString("cnssMutuelle"));
                    patient.setAntecedentsMedicaux(rs.getString("antecedentsMedicaux"));
                    patient.setAllergieCritique(rs.getString("allergieCritique"));
                    patient.setResponsableLegalNom(rs.getString("responsableLegalNom"));
                    patient.setResponsableLegalTel(rs.getString("responsableLegalTel"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur lors de la recherche du patient : " + e.getMessage());
        }

        return patient;
    }
}