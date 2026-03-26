package com.dentfisto.dao;

import com.dentfisto.model.RendezVous;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RendezVousDAO {

    public RendezVous findById(int id) {
        String sql = "SELECT * FROM rendezVous WHERE id = ?";
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

    public List<RendezVous> findAll() {
        List<RendezVous> list = new ArrayList<>();
        String sql = "SELECT * FROM rendezVous";
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

    public List<RendezVous> findByPatientId(int patientId) {
        List<RendezVous> list = new ArrayList<>();
        String sql = "SELECT * FROM rendezVous WHERE patientId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, patientId);
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

    public List<RendezVous> findByDentisteId(int dentisteId) {
        List<RendezVous> list = new ArrayList<>();
        String sql = "SELECT * FROM rendezVous WHERE dentisteId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, dentisteId);
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

    public boolean save(RendezVous r) {
        String sql = "INSERT INTO rendezVous (dateRdv, heureDebut, heureFin, motif, notesInternes, statut, patientId, dentisteId) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setDate(1, Date.valueOf(r.getDateRdv()));
            stmt.setTime(2, Time.valueOf(r.getHeureDebut()));
            stmt.setTime(3, Time.valueOf(r.getHeureFin()));
            stmt.setString(4, r.getMotif());
            stmt.setString(5, r.getNotesInternes());
            stmt.setString(6, r.getStatut());
            stmt.setInt(7, r.getPatientId());
            stmt.setInt(8, r.getDentisteId());
            int rows = stmt.executeUpdate();
            if (rows > 0) {
                try (ResultSet keys = stmt.getGeneratedKeys()) {
                    if (keys.next()) r.setId(keys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(RendezVous r) {
        String sql = "UPDATE rendezVous SET dateRdv = ?, heureDebut = ?, heureFin = ?, motif = ?, "
                   + "notesInternes = ?, statut = ?, patientId = ?, dentisteId = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setDate(1, Date.valueOf(r.getDateRdv()));
            stmt.setTime(2, Time.valueOf(r.getHeureDebut()));
            stmt.setTime(3, Time.valueOf(r.getHeureFin()));
            stmt.setString(4, r.getMotif());
            stmt.setString(5, r.getNotesInternes());
            stmt.setString(6, r.getStatut());
            stmt.setInt(7, r.getPatientId());
            stmt.setInt(8, r.getDentisteId());
            stmt.setInt(9, r.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM rendezVous WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private RendezVous mapRow(ResultSet rs) throws SQLException {
        RendezVous r = new RendezVous();
        r.setId(rs.getInt("id"));
        r.setDateRdv(rs.getDate("dateRdv").toLocalDate());
        r.setHeureDebut(rs.getTime("heureDebut").toLocalTime());
        r.setHeureFin(rs.getTime("heureFin").toLocalTime());
        r.setMotif(rs.getString("motif"));
        r.setNotesInternes(rs.getString("notesInternes"));
        r.setStatut(rs.getString("statut"));
        r.setPatientId(rs.getInt("patientId"));
        r.setDentisteId(rs.getInt("dentisteId"));
        return r;
    }
}
