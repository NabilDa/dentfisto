package com.dentfisto.dao;

import com.dentfisto.model.Facture;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FactureDAO {

    public Facture findById(int id) {
        String sql = "SELECT * FROM facture WHERE id = ?";
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

    public Facture findByConsultationId(int consultationId) {
        String sql = "SELECT * FROM facture WHERE consultationId = ?";
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

    public List<Facture> findAll() {
        List<Facture> list = new ArrayList<>();
        String sql = "SELECT * FROM facture";
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

    public boolean save(Facture f) {
        String sql = "INSERT INTO facture (montantTotal, cheminPdf, dateFacturation, consultationId) VALUES (?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setDouble(1, f.getMontantTotal());
            stmt.setString(2, f.getCheminPdf());
            stmt.setDate(3, Date.valueOf(f.getDateFacturation()));
            stmt.setInt(4, f.getConsultationId());
            int rows = stmt.executeUpdate();
            if (rows > 0) {
                try (ResultSet keys = stmt.getGeneratedKeys()) {
                    if (keys.next()) f.setId(keys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(Facture f) {
        String sql = "UPDATE facture SET montantTotal = ?, cheminPdf = ?, dateFacturation = ?, consultationId = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setDouble(1, f.getMontantTotal());
            stmt.setString(2, f.getCheminPdf());
            stmt.setDate(3, Date.valueOf(f.getDateFacturation()));
            stmt.setInt(4, f.getConsultationId());
            stmt.setInt(5, f.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM facture WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Facture mapRow(ResultSet rs) throws SQLException {
        Facture f = new Facture();
        f.setId(rs.getInt("id"));
        f.setMontantTotal(rs.getDouble("montantTotal"));
        f.setCheminPdf(rs.getString("cheminPdf"));
        f.setDateFacturation(rs.getDate("dateFacturation").toLocalDate());
        f.setConsultationId(rs.getInt("consultationId"));
        return f;
    }
}
