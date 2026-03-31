package com.dentfisto.servlet;

import com.dentfisto.dao.StatsDAO;
import com.dentfisto.dao.UtilisateurDAO;
import com.dentfisto.model.Utilisateur;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/admin/")
public class AdminDashboardServlet extends HttpServlet {

    private final UtilisateurDAO userDAO = new UtilisateurDAO();
    private final StatsDAO statsDAO = new StatsDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Utilisateur user = (Utilisateur) req.getSession().getAttribute("user");
        if (user == null) { resp.sendRedirect(req.getContextPath() + "/login-admin.jsp"); return; }

        List<Utilisateur> allUsers = userDAO.findAll();
        req.setAttribute("dentistes", allUsers.stream().filter(u -> "DENTISTE".equals(u.getRole())).collect(Collectors.toList()));
        req.setAttribute("assistantes", allUsers.stream().filter(u -> "ASSISTANTE".equals(u.getRole())).collect(Collectors.toList()));
        req.setAttribute("userName", user.getLogin());

        // Statistics
        Map<String, Object> kpis = statsDAO.getClinicKPIs();
        req.setAttribute("totalPatients", kpis.get("totalPatients"));
        req.setAttribute("totalRdv", kpis.get("totalRdv"));
        req.setAttribute("totalRevenue", kpis.get("totalRevenue"));
        req.setAttribute("totalConsultations", kpis.get("totalConsultations"));

        Map<String, Object> metrics = statsDAO.getAppointmentMetrics();
        req.setAttribute("rdvTermine", metrics.getOrDefault("rdvTermine", 0));
        req.setAttribute("rdvAnnule", metrics.getOrDefault("rdvAnnule", 0));
        req.setAttribute("rdvNonHonore", metrics.getOrDefault("rdvNonHonore", 0));
        req.setAttribute("tauxAnnulation", metrics.getOrDefault("tauxAnnulation", 0.0));
        req.setAttribute("tauxNonHonore", metrics.getOrDefault("tauxNonHonore", 0.0));

        List<Map<String, Object>> revenue = statsDAO.getRevenueByDentist();
        req.setAttribute("revenueByDentist", revenue);

        req.getRequestDispatcher("/admin/index.jsp").forward(req, resp);
    }
}
