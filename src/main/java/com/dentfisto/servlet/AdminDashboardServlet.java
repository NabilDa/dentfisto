package com.dentfisto.servlet;

import com.dentfisto.dao.ActeDAO;
import com.dentfisto.dao.UtilisateurDAO;
import com.dentfisto.model.Utilisateur;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/admin/")
public class AdminDashboardServlet extends HttpServlet {

    private final UtilisateurDAO userDAO = new UtilisateurDAO();
    private final ActeDAO acteDAO = new ActeDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Utilisateur user = (Utilisateur) req.getSession().getAttribute("user");
        if (user == null) { resp.sendRedirect(req.getContextPath() + "/login-admin.jsp"); return; }

        List<Utilisateur> allUsers = userDAO.findAll();
        req.setAttribute("dentistes", allUsers.stream().filter(u -> "DENTISTE".equals(u.getRole())).collect(Collectors.toList()));
        req.setAttribute("assistantes", allUsers.stream().filter(u -> "ASSISTANTE".equals(u.getRole())).collect(Collectors.toList()));
        req.setAttribute("actes", acteDAO.getAllActes());
        req.setAttribute("userName", user.getLogin());

        req.getRequestDispatcher("/admin/index.jsp").forward(req, resp);
    }
}
