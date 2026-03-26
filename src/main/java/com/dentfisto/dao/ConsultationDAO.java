package com.dentfisto.dao;

import com.dentfisto.model.Consultation;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ConsultationDAO {

    public Consultation findById(int id) {
        String sql = "SELECT * FROM consultation WHERE id = ?";
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

    public Consultation findByRdvId(int rdvId) {
        String sql = "SELECT * FROM consultation WHERE rdvId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, rdvId);
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

    public List<Consultation> findByDossierId(int dossierId) {
        List<Consultation> list = new ArrayList<>();
        String sql = "SELECT * FROM consultation WHERE dossierId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, dossierId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Consultation> findAll() {
        List<Consultation> list = new ArrayList<>();
        String sql = "SELECT * FROM consultation";
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

    public boolean save(Consultation c) {
        String sql = "INSERT INTO consultation (diagnostic, observations, rdvId, dossierId) VALUES (?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, c.getDiagnostic());
            stmt.setString(2, c.getObservations());
            stmt.setInt(3, c.getRdvId());
            stmt.setInt(4, c.getDossierId());
            int rows = stmt.executeUpdate();
            if (rows > 0) {
                try (ResultSet keys = stmt.getGeneratedKeys()) {
                    if (keys.next()) c.setId(keys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(Consultation c) {
        String sql = "UPDATE consultation SET diagnostic = ?, observations = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, c.getDiagnostic());
            stmt.setString(2, c.getObservations());
            stmt.setInt(3, c.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM consultation WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // --- consultationActe join table ---

    public boolean addActe(int consultationId, int acteId) {
        String sql = "INSERT INTO consultationActe (consultationId, acteId) VALUES (?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, consultationId);
            stmt.setInt(2, acteId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean removeActe(int consultationId, int acteId) {
        String sql = "DELETE FROM consultationActe WHERE consultationId = ? AND acteId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, consultationId);
            stmt.setInt(2, acteId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Integer> findActeIdsByConsultationId(int consultationId) {
        List<Integer> ids = new ArrayList<>();
        String sql = "SELECT acteId FROM consultationActe WHERE consultationId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, consultationId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ids.add(rs.getInt("acteId"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ids;
    }

    private Consultation mapRow(ResultSet rs) throws SQLException {
        Consultation c = new Consultation();
        c.setId(rs.getInt("id"));
        c.setDiagnostic(rs.getString("diagnostic"));
        c.setObservations(rs.getString("observations"));
        c.setRdvId(rs.getInt("rdvId"));
        c.setDossierId(rs.getInt("dossierId"));
        return c;
    }
}
