package com.dentfisto.dao;

import com.dentfisto.model.Document;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DocumentDAO {

    public Document findById(int id) {
        String sql = "SELECT * FROM document WHERE id = ?";
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

    public List<Document> findByDossierId(int dossierId) {
        List<Document> list = new ArrayList<>();
        String sql = "SELECT * FROM document WHERE dossierId = ?";
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

    public List<Document> findAll() {
        List<Document> list = new ArrayList<>();
        String sql = "SELECT * FROM document";
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

    public boolean save(Document doc) {
        String sql = "INSERT INTO document (type, dateImportation, cheminAcces, dossierId) VALUES (?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, doc.getType());
            stmt.setDate(2, Date.valueOf(doc.getDateImportation()));
            stmt.setString(3, doc.getCheminAcces());
            stmt.setInt(4, doc.getDossierId());
            int rows = stmt.executeUpdate();
            if (rows > 0) {
                try (ResultSet keys = stmt.getGeneratedKeys()) {
                    if (keys.next()) doc.setId(keys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(Document doc) {
        String sql = "UPDATE document SET type = ?, dateImportation = ?, cheminAcces = ?, dossierId = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, doc.getType());
            stmt.setDate(2, Date.valueOf(doc.getDateImportation()));
            stmt.setString(3, doc.getCheminAcces());
            stmt.setInt(4, doc.getDossierId());
            stmt.setInt(5, doc.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM document WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Document mapRow(ResultSet rs) throws SQLException {
        Document doc = new Document();
        doc.setId(rs.getInt("id"));
        doc.setType(rs.getString("type"));
        doc.setDateImportation(rs.getDate("dateImportation").toLocalDate());
        doc.setCheminAcces(rs.getString("cheminAcces"));
        doc.setDossierId(rs.getInt("dossierId"));
        return doc;
    }
}
