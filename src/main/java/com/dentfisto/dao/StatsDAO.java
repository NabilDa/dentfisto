package com.dentfisto.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * DAO for admin statistics: revenue per dentist, appointment metrics, clinic KPIs.
 */
public class StatsDAO {

    /**
     * Returns overall clinic KPIs:
     * totalPatients, totalRdv, totalRevenue, totalConsultations
     */
    public Map<String, Object> getClinicKPIs() {
        Map<String, Object> kpis = new HashMap<>();
        kpis.put("totalPatients", 0);
        kpis.put("totalRdv", 0);
        kpis.put("totalRevenue", 0.0);
        kpis.put("totalConsultations", 0);

        try (Connection conn = DBConnection.getConnection()) {
            // Total patients
            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery("SELECT COUNT(*) AS cnt FROM patient")) {
                if (rs.next()) kpis.put("totalPatients", rs.getInt("cnt"));
            }

            // Total RDVs
            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery("SELECT COUNT(*) AS cnt FROM rendezVous")) {
                if (rs.next()) kpis.put("totalRdv", rs.getInt("cnt"));
            }

            // Total revenue
            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery("SELECT IFNULL(SUM(montantTotal), 0) AS total FROM facture")) {
                if (rs.next()) kpis.put("totalRevenue", rs.getDouble("total"));
            }

            // Total consultations
            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery("SELECT COUNT(*) AS cnt FROM consultation")) {
                if (rs.next()) kpis.put("totalConsultations", rs.getInt("cnt"));
            }
        } catch (SQLException e) {
            System.err.println("Erreur getClinicKPIs: " + e.getMessage());
        }
        return kpis;
    }

    /**
     * Returns appointment metrics:
     * totalRdv, rdvTermine, rdvAnnule, rdvNonHonore, rdvPlanifie, tauxAnnulation, tauxNonHonore
     */
    public Map<String, Object> getAppointmentMetrics() {
        Map<String, Object> metrics = new HashMap<>();
        String sql = "SELECT " +
                "COUNT(*) AS total, " +
                "SUM(CASE WHEN statut = 'TERMINE' THEN 1 ELSE 0 END) AS termine, " +
                "SUM(CASE WHEN statut = 'ANNULE' THEN 1 ELSE 0 END) AS annule, " +
                "SUM(CASE WHEN statut = 'NON_HONORE' THEN 1 ELSE 0 END) AS nonHonore, " +
                "SUM(CASE WHEN statut = 'PLANIFIE' THEN 1 ELSE 0 END) AS planifie, " +
                "SUM(CASE WHEN statut = 'EN_COURS' THEN 1 ELSE 0 END) AS enCours, " +
                "SUM(CASE WHEN statut = 'EN_SALLE_D_ATTENTE' THEN 1 ELSE 0 END) AS enAttente " +
                "FROM rendezVous";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                int total = rs.getInt("total");
                int annule = rs.getInt("annule");
                int nonHonore = rs.getInt("nonHonore");

                metrics.put("totalRdv", total);
                metrics.put("rdvTermine", rs.getInt("termine"));
                metrics.put("rdvAnnule", annule);
                metrics.put("rdvNonHonore", nonHonore);
                metrics.put("rdvPlanifie", rs.getInt("planifie"));
                metrics.put("rdvEnCours", rs.getInt("enCours"));
                metrics.put("rdvEnAttente", rs.getInt("enAttente"));
                metrics.put("tauxAnnulation", total > 0 ? Math.round((annule * 100.0 / total) * 100.0) / 100.0 : 0.0);
                metrics.put("tauxNonHonore", total > 0 ? Math.round((nonHonore * 100.0 / total) * 100.0) / 100.0 : 0.0);
            }
        } catch (SQLException e) {
            System.err.println("Erreur getAppointmentMetrics: " + e.getMessage());
        }
        return metrics;
    }

    /**
     * Revenue per dentist.
     * Returns a list of maps with: dentisteId, dentisteLogin, totalRdv, rdvAnnule, chiffreAffaires
     */
    public List<Map<String, Object>> getRevenueByDentist() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT u.id AS dentisteId, u.login AS dentisteLogin, " +
                "COUNT(r.id) AS totalRdv, " +
                "SUM(CASE WHEN r.statut = 'ANNULE' THEN 1 ELSE 0 END) AS rdvAnnule, " +
                "SUM(CASE WHEN r.statut = 'NON_HONORE' THEN 1 ELSE 0 END) AS rdvNonHonore, " +
                "SUM(CASE WHEN r.statut = 'TERMINE' THEN 1 ELSE 0 END) AS rdvTermine, " +
                "IFNULL(( " +
                "  SELECT SUM(f.montantTotal) FROM facture f " +
                "  JOIN consultation c ON f.consultationId = c.id " +
                "  JOIN rendezVous rv ON c.rdvId = rv.id " +
                "  WHERE rv.dentisteId = u.id " +
                "), 0) AS chiffreAffaires " +
                "FROM utilisateur u " +
                "LEFT JOIN rendezVous r ON r.dentisteId = u.id " +
                "WHERE u.role = 'DENTISTE' " +
                "GROUP BY u.id, u.login " +
                "ORDER BY chiffreAffaires DESC";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("dentisteId", rs.getInt("dentisteId"));
                row.put("dentisteLogin", rs.getString("dentisteLogin"));
                row.put("totalRdv", rs.getInt("totalRdv"));
                row.put("rdvAnnule", rs.getInt("rdvAnnule"));
                row.put("rdvNonHonore", rs.getInt("rdvNonHonore"));
                row.put("rdvTermine", rs.getInt("rdvTermine"));
                row.put("chiffreAffaires", rs.getDouble("chiffreAffaires"));
                list.add(row);
            }
        } catch (SQLException e) {
            System.err.println("Erreur getRevenueByDentist: " + e.getMessage());
        }
        return list;
    }
}
