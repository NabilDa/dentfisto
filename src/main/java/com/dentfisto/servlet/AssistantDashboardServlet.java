package com.dentfisto.servlet;

import com.dentfisto.dao.RendezVousDAO;
import com.dentfisto.model.Utilisateur;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/assistant/")
public class AssistantDashboardServlet extends HttpServlet {

    private final RendezVousDAO rdvDAO = new RendezVousDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Utilisateur user = (Utilisateur) req.getSession().getAttribute("user");
        if (user == null) { resp.sendRedirect(req.getContextPath() + "/login-assistant.jsp"); return; }

        req.setAttribute("rdvList", rdvDAO.getTodayAllOrdered());
        req.setAttribute("rdvWeekList", rdvDAO.getWeekAllOrdered());
        req.setAttribute("userName", user.getLogin());

        req.getRequestDispatcher("/assistant/index.jsp").forward(req, resp);
    }
}
