package com.dentfisto.servlet;

import com.dentfisto.dao.UserDAO;
import com.dentfisto.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * Handles login from all three role-specific login pages.
 * Each page sends username, password, and a hidden "role" field.
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String role     = req.getParameter("role");

        if (username == null || password == null || role == null) {
            resp.sendRedirect(getLoginPage(role) + "?error=missing");
            return;
        }

        role = role.toUpperCase();
        String passwordHash = sha256(password);
        User user = userDAO.findByUsernameAndRole(username, role);

        if (user != null && user.getPasswordHash().equals(passwordHash)) {
            HttpSession session = req.getSession();
            session.setAttribute("user", user);
            session.setMaxInactiveInterval(30 * 60); // 30 minutes

            switch (role) {
                case "ADMIN"     -> resp.sendRedirect(req.getContextPath() + "/admin/");
                case "DENTIST"   -> resp.sendRedirect(req.getContextPath() + "/dentist/");
                case "ASSISTANT" -> resp.sendRedirect(req.getContextPath() + "/assistant/");
                default          -> resp.sendRedirect(req.getContextPath() + "/");
            }
        } else {
            resp.sendRedirect(getLoginPage(role) + "?error=invalid");
        }
    }

    /**
     * Returns the login page path for a given role.
     */
    private String getLoginPage(String role) {
        if (role == null) return "login-admin.jsp";
        return switch (role.toUpperCase()) {
            case "DENTIST"   -> "login-dentist.jsp";
            case "ASSISTANT" -> "login-assistant.jsp";
            default          -> "login-admin.jsp";
        };
    }

    /**
     * Hashes a string with SHA-256.
     */
    private String sha256(String input) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(input.getBytes(StandardCharsets.UTF_8));
            StringBuilder hex = new StringBuilder();
            for (byte b : hash) {
                hex.append(String.format("%02x", b));
            }
            return hex.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 not available", e);
        }
    }
}
