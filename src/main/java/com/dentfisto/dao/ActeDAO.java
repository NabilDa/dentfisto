package com.dentfisto.dao;

import com.dentfisto.model.Acte;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ActeDAO {

    public Acte findById(int id) {
        String sql = "SELECT * FROM acte WHERE id = ?";
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

    public Acte findByCode(String code) {
        String sql = "SELECT * FROM acte WHERE code = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, code);
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

    public List<Acte> findAll() {
        List<Acte> list = new ArrayList<>();
        String sql = "SELECT * FROM acte";
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

    public boolean save(Acte a) {
        String sql = "INSERT INTO acte (code, nom, tarifBase) VALUES (?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, a.getCode());
            stmt.setString(2, a.getNom());
            stmt.setDouble(3, a.getTarifBase());
            int rows = stmt.executeUpdate();
            if (rows > 0) {
                try (ResultSet keys = stmt.getGeneratedKeys()) {
                    if (keys.next()) a.setId(keys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(Acte a) {
        String sql = "UPDATE acte SET code = ?, nom = ?, tarifBase = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, a.getCode());
            stmt.setString(2, a.getNom());
            stmt.setDouble(3, a.getTarifBase());
            stmt.setInt(4, a.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM acte WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Acte mapRow(ResultSet rs) throws SQLException {
        Acte a = new Acte();
        a.setId(rs.getInt("id"));
        a.setCode(rs.getString("code"));
        a.setNom(rs.getString("nom"));
        a.setTarifBase(rs.getDouble("tarifBase"));
        return a;
    }
}
