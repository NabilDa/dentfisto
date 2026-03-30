package com.dentfisto.dao;

import com.dentfisto.model.Patient;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PatientDAO {

    private static final String SQL_INSERT_PATIENT = 
        "INSERT INTO patient (nom, prenom, dateNaissance, sexe, adresse, telephone, " +
        "cnssMutuelle, antecedentsMedicaux, allergieCritique, responsableLegalNom, responsableLegalTel) " +
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
    private static final String SQL_RECHERCHE_PAR_NOM_TEL = 
        "SELECT * FROM patient WHERE nom LIKE ? AND telephone = ?";

    private static final String SQL_GET_BY_ID =
        "SELECT * FROM patient WHERE id = ?";



    private static final String SQL_UPDATE =
        "UPDATE patient SET nom=?, prenom=?, dateNaissance=?, sexe=?, adresse=?, telephone=?, " +
        "cnssMutuelle=?, antecedentsMedicaux=?, allergieCritique=?, responsableLegalNom=?, responsableLegalTel=? " +
        "WHERE id=?";

    private static final String SQL_ALL =
        "SELECT * FROM patient ORDER BY nom ASC";

    public boolean ajouterPatient(Patient patient) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_INSERT_PATIENT)) {

            stmt.setString(1, patient.getNom());
            stmt.setString(2, patient.getPrenom());
            stmt.setDate(3, Date.valueOf(patient.getDateNaissance()));
            stmt.setString(4, patient.getSexe());
            stmt.setString(5, patient.getAdresse());
            stmt.setString(6, patient.getTelephone());
            stmt.setString(7, patient.getCnssMutuelle());
            stmt.setString(8, patient.getAntecedentsMedicaux());
            stmt.setString(9, patient.getAllergieCritique());
            stmt.setString(10, patient.getResponsableLegalNom());
            stmt.setString(11, patient.getResponsableLegalTel());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de l'ajout du patient : " + e.getMessage());
            return false;
        }
    }

    public Patient rechercherPatient(String nom, String telephone) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_RECHERCHE_PAR_NOM_TEL)) {

            stmt.setString(1, "%" + nom + "%"); 
            stmt.setString(2, telephone);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            System.err.println("Erreur lors de la recherche du patient : " + e.getMessage());
        }
        return null;
    }

    public Patient getById(int id) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_GET_BY_ID)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            System.err.println("Erreur getById patient : " + e.getMessage());
        }
        return null;
    }

    public List<Patient> searchByNameAndPhone(String nom, String tel) {
        List<Patient> list = new ArrayList<>();
        String sql = "SELECT * FROM patient WHERE (nom LIKE ? OR prenom LIKE ?) AND telephone LIKE ? ORDER BY nom ASC LIMIT 50";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            String likeNom = "%" + nom + "%";
            String likeTel = "%" + tel + "%";
            
            stmt.setString(1, likeNom);
            stmt.setString(2, likeNom);
            stmt.setString(3, likeTel);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("Erreur searchByNameAndPhone : " + e.getMessage());
        }
        return list;
    }

    public boolean update(Patient p) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_UPDATE)) {

            stmt.setString(1, p.getNom());
            stmt.setString(2, p.getPrenom());
            stmt.setDate(3, Date.valueOf(p.getDateNaissance()));
            stmt.setString(4, p.getSexe());
            stmt.setString(5, p.getAdresse());
            stmt.setString(6, p.getTelephone());
            stmt.setString(7, p.getCnssMutuelle());
            stmt.setString(8, p.getAntecedentsMedicaux());
            stmt.setString(9, p.getAllergieCritique());
            stmt.setString(10, p.getResponsableLegalNom());
            stmt.setString(11, p.getResponsableLegalTel());
            stmt.setInt(12, p.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Erreur update patient : " + e.getMessage());
            return false;
        }
    }

    public List<Patient> getAll() {
        List<Patient> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_ALL);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("Erreur getAll patients : " + e.getMessage());
        }
        return list;
    }

    private Patient mapRow(ResultSet rs) throws SQLException {
        Patient p = new Patient();
        p.setId(rs.getInt("id"));
        p.setNom(rs.getString("nom"));
        p.setPrenom(rs.getString("prenom"));
        p.setDateNaissance(rs.getDate("dateNaissance").toLocalDate());
        p.setSexe(rs.getString("sexe"));
        p.setAdresse(rs.getString("adresse"));
        p.setTelephone(rs.getString("telephone"));
        p.setCnssMutuelle(rs.getString("cnssMutuelle"));
        p.setAntecedentsMedicaux(rs.getString("antecedentsMedicaux"));
        p.setAllergieCritique(rs.getString("allergieCritique"));
        p.setResponsableLegalNom(rs.getString("responsableLegalNom"));
        p.setResponsableLegalTel(rs.getString("responsableLegalTel"));
        return p;
    }
}