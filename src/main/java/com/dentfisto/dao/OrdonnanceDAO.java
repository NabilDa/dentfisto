package com.dentfisto.dao;

import com.dentfisto.model.Ordonnance;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrdonnanceDAO {

    public Ordonnance findById(int id) {
        String sql = "SELECT * FROM ordonnance WHERE id = ?";
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

    public Ordonnance findByConsultationId(int consultationId) {
        String sql = "SELECT * FROM ordonnance WHERE consultationId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, consultationId);
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

    public List<Ordonnance> findAll() {
        List<Ordonnance> list = new ArrayList<>();
        String sql = "SELECT * FROM ordonnance";
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

    public boolean save(Ordonnance o) {
        String sql = "INSERT INTO ordonnance (cheminPdf, consultationId) VALUES (?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, o.getCheminPdf());
            stmt.setInt(2, o.getConsultationId());
            int rows = stmt.executeUpdate();
            if (rows > 0) {
                try (ResultSet keys = stmt.getGeneratedKeys()) {
                    if (keys.next()) o.setId(keys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(Ordonnance o) {
        String sql = "UPDATE ordonnance SET cheminPdf = ?, consultationId = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, o.getCheminPdf());
            stmt.setInt(2, o.getConsultationId());
            stmt.setInt(3, o.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM ordonnance WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Ordonnance mapRow(ResultSet rs) throws SQLException {
        Ordonnance o = new Ordonnance();
        o.setId(rs.getInt("id"));
        o.setCheminPdf(rs.getString("cheminPdf"));
        o.setConsultationId(rs.getInt("consultationId"));
        return o;
    }
}
