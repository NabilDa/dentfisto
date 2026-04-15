package com.dentfisto.servlet;

import com.dentfisto.dao.StatsDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

/**
 * Returns JSON statistics for the admin dashboard.
 * GET /admin/api/stats
 */
@WebServlet("/admin/api/stats")
public class AdminStatsServlet extends HttpServlet {

    private final StatsDAO statsDAO = new StatsDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        Map<String, Object> kpis = statsDAO.getClinicKPIs();
        Map<String, Object> metrics = statsDAO.getAppointmentMetrics();
        List<Map<String, Object>> revenue = statsDAO.getRevenueByDentist();

        StringBuilder json = new StringBuilder("{");

        // KPIs
        json.append("\"kpis\":{");
        json.append("\"totalPatients\":").append(kpis.get("totalPatients")).append(",");
        json.append("\"totalRdv\":").append(kpis.get("totalRdv")).append(",");
        json.append("\"totalRevenue\":").append(kpis.get("totalRevenue")).append(",");
        json.append("\"totalConsultations\":").append(kpis.get("totalConsultations"));
        json.append("},");

        // Appointment metrics
        json.append("\"metrics\":{");
        json.append("\"totalRdv\":").append(metrics.getOrDefault("totalRdv", 0)).append(",");
        json.append("\"rdvTermine\":").append(metrics.getOrDefault("rdvTermine", 0)).append(",");
        json.append("\"rdvAnnule\":").append(metrics.getOrDefault("rdvAnnule", 0)).append(",");
        json.append("\"rdvNonHonore\":").append(metrics.getOrDefault("rdvNonHonore", 0)).append(",");
        json.append("\"rdvPlanifie\":").append(metrics.getOrDefault("rdvPlanifie", 0)).append(",");
        json.append("\"rdvEnCours\":").append(metrics.getOrDefault("rdvEnCours", 0)).append(",");
        json.append("\"rdvEnAttente\":").append(metrics.getOrDefault("rdvEnAttente", 0)).append(",");
        json.append("\"tauxAnnulation\":").append(metrics.getOrDefault("tauxAnnulation", 0.0)).append(",");
        json.append("\"tauxNonHonore\":").append(metrics.getOrDefault("tauxNonHonore", 0.0));
        json.append("},");

        // Revenue by dentist
        json.append("\"revenue\":[");
        for (int i = 0; i < revenue.size(); i++) {
            Map<String, Object> row = revenue.get(i);
            if (i > 0) json.append(",");
            json.append("{");
            json.append("\"dentisteId\":").append(row.get("dentisteId")).append(",");
            json.append("\"dentisteLogin\":\"").append(escapeJson(String.valueOf(row.get("dentisteLogin")))).append("\",");
            json.append("\"totalRdv\":").append(row.get("totalRdv")).append(",");
            json.append("\"rdvAnnule\":").append(row.get("rdvAnnule")).append(",");
            json.append("\"rdvNonHonore\":").append(row.get("rdvNonHonore")).append(",");
            json.append("\"rdvTermine\":").append(row.get("rdvTermine")).append(",");
            json.append("\"chiffreAffaires\":").append(row.get("chiffreAffaires"));
            json.append("}");
        }
        json.append("]");

        json.append("}");
        out.print(json.toString());
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "");
    }
}
