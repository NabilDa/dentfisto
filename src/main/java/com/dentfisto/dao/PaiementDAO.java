package com.dentfisto.dao;

import com.dentfisto.model.Paiement;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PaiementDAO {

    public Paiement findById(int id) {
        String sql = "SELECT * FROM paiement WHERE id = ?";
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

    public List<Paiement> findByFactureId(int factureId) {
        List<Paiement> list = new ArrayList<>();
        String sql = "SELECT * FROM paiement WHERE factureId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, factureId);
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

    public List<Paiement> findAll() {
        List<Paiement> list = new ArrayList<>();
        String sql = "SELECT * FROM paiement";
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

    public boolean save(Paiement p) {
        String sql = "INSERT INTO paiement (modeReglement, factureId) VALUES (?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, p.getModeReglement());
            stmt.setInt(2, p.getFactureId());
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

    public boolean update(Paiement p) {
        String sql = "UPDATE paiement SET modeReglement = ?, factureId = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, p.getModeReglement());
            stmt.setInt(2, p.getFactureId());
            stmt.setInt(3, p.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM paiement WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Paiement mapRow(ResultSet rs) throws SQLException {
        Paiement p = new Paiement();
        p.setId(rs.getInt("id"));
        p.setModeReglement(rs.getString("modeReglement"));
        p.setFactureId(rs.getInt("factureId"));
        return p;
    }
}
