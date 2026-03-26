package com.dentfisto.dao;

import com.dentfisto.model.DossierMedical;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DossierMedicalDAO {

    public DossierMedical findById(int id) {
        String sql = "SELECT * FROM dossierMedical WHERE id = ?";
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

    public DossierMedical findByNumeroReference(String numeroReference) {
        String sql = "SELECT * FROM dossierMedical WHERE numeroReference = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, numeroReference);
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

    public DossierMedical findByPatientId(int patientId) {
        String sql = "SELECT * FROM dossierMedical WHERE patientId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, patientId);
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

    public List<DossierMedical> findAll() {
        List<DossierMedical> list = new ArrayList<>();
        String sql = "SELECT * FROM dossierMedical";
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

    public boolean save(DossierMedical dm) {
        String sql = "INSERT INTO dossierMedical (numeroReference, dateCreation, patientId) VALUES (?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, dm.getNumeroReference());
            stmt.setDate(2, Date.valueOf(dm.getDateCreation()));
            stmt.setInt(3, dm.getPatientId());
            int rows = stmt.executeUpdate();
            if (rows > 0) {
                try (ResultSet keys = stmt.getGeneratedKeys()) {
                    if (keys.next()) dm.setId(keys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(DossierMedical dm) {
        String sql = "UPDATE dossierMedical SET numeroReference = ?, dateCreation = ?, patientId = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, dm.getNumeroReference());
            stmt.setDate(2, Date.valueOf(dm.getDateCreation()));
            stmt.setInt(3, dm.getPatientId());
            stmt.setInt(4, dm.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM dossierMedical WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private DossierMedical mapRow(ResultSet rs) throws SQLException {
        DossierMedical dm = new DossierMedical();
        dm.setId(rs.getInt("id"));
        dm.setNumeroReference(rs.getString("numeroReference"));
        dm.setDateCreation(rs.getDate("dateCreation").toLocalDate());
        dm.setPatientId(rs.getInt("patientId"));
        return dm;
    }
}
