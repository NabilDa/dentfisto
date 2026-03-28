package com.dentfisto.servlet;

import com.dentfisto.dao.UtilisateurDAO;
import com.dentfisto.model.Utilisateur;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Handles login from all three role-specific login pages.
 * Each page sends login, password, and a hidden "role" field
 * matching the DB ENUM: ADMINISTRATEUR, DENTISTE, ASSISTANTE.
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UtilisateurDAO utilisateurDAO = new UtilisateurDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String login = req.getParameter("username");
        String password = req.getParameter("password");
        String role = req.getParameter("role");

        if (login == null || password == null || role == null) {
            resp.sendRedirect(getLoginPage(role) + "?error=missing");
            return;
        }

        role = role.toUpperCase();
        Utilisateur user = utilisateurDAO.findByLogin(login);

        if (user != null && user.getMotDePasse().equals(password) && user.getRole().equals(role)) {
            HttpSession session = req.getSession();
            session.setAttribute("user", user);
            session.setMaxInactiveInterval(30 * 60); // 30 minutes

            switch (role) {
                case "ADMINISTRATEUR" -> resp.sendRedirect(req.getContextPath() + "/admin/");
                case "DENTISTE" -> resp.sendRedirect(req.getContextPath() + "/dentist/");
                case "ASSISTANTE" -> resp.sendRedirect(req.getContextPath() + "/assistant/");
                default -> resp.sendRedirect(req.getContextPath() + "/");
            }
        } else {
            resp.sendRedirect(getLoginPage(role) + "?error=invalid");
        }
    }

    /**
     * Returns the login page path for a given role.
     */
    private String getLoginPage(String role) {
        if (role == null)
            return "login-admin.jsp";
        return switch (role.toUpperCase()) {
            case "DENTISTE" -> "login-dentist.jsp";
            case "ASSISTANTE" -> "login-assistant.jsp";
            default -> "login-admin.jsp";
        };
    }
}
