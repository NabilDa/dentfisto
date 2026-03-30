package com.dentfisto.servlet;

import com.dentfisto.dao.ActeDAO;
import com.dentfisto.dao.RendezVousDAO;
import com.dentfisto.model.Utilisateur;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/dentist/")
public class DentistDashboardServlet extends HttpServlet {

    private final RendezVousDAO rdvDAO = new RendezVousDAO();
    private final ActeDAO acteDAO = new ActeDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Utilisateur user = (Utilisateur) req.getSession().getAttribute("user");
        if (user == null) { resp.sendRedirect(req.getContextPath() + "/login-dentist.jsp"); return; }

        req.setAttribute("rdvList", rdvDAO.getTodayByDentistOrdered(user.getId()));
        req.setAttribute("rdvWeekList", rdvDAO.getWeekByDentistOrdered(user.getId()));
        req.setAttribute("actes", acteDAO.getAllActes());
        req.setAttribute("userName", user.getLogin());

        req.getRequestDispatcher("/dentist/index.jsp").forward(req, resp);
    }
}
