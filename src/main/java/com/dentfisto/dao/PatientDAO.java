package com.dentfisto.dao;

import com.dentfisto.model.Patient;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PatientDAO {

    public Patient findById(int id) {
        String sql = "SELECT * FROM patient WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Patient> findAll() {
        List<Patient> list = new ArrayList<>();
        String sql = "SELECT * FROM patient";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean save(Patient p) {
        String sql = "INSERT INTO patient (nom, prenom, dateNaissance, sexe, adresse, telephone, "
                   + "cnssMutuelle, antecedentsMedicaux, allergieCritique, responsableLegalNom, responsableLegalTel) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

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
            int rows = stmt.executeUpdate();
            if (rows > 0) {
                try (ResultSet keys = stmt.getGeneratedKeys()) {
                    if (keys.next()) p.setId(keys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(Patient p) {
        String sql = "UPDATE patient SET nom = ?, prenom = ?, dateNaissance = ?, sexe = ?, adresse = ?, "
                   + "telephone = ?, cnssMutuelle = ?, antecedentsMedicaux = ?, allergieCritique = ?, "
                   + "responsableLegalNom = ?, responsableLegalTel = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

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
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM patient WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
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
