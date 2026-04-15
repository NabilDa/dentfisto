package com.dentfisto.servlet;

import com.dentfisto.dao.UtilisateurDAO;
import com.dentfisto.model.Utilisateur;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Handles admin CRUD operations for staff (dentists & assistants).
 * URL patterns:
 *   POST /admin/users/add     — create new user
 *   GET  /admin/users/delete  — delete user by id
 *   POST /admin/users/update  — update user login/password
 */
@WebServlet({"/admin/users/add", "/admin/users/delete", "/admin/users/update"})
public class AdminUserServlet extends HttpServlet {

    private final UtilisateurDAO userDAO = new UtilisateurDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getServletPath();

        if ("/admin/users/add".equals(path)) {
            handleAdd(req, resp);
        } else if ("/admin/users/update".equals(path)) {
            handleUpdate(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getServletPath();

        if ("/admin/users/delete".equals(path)) {
            handleDelete(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/");
        }
    }

    private void handleAdd(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String login = req.getParameter("login");
        String password = req.getParameter("password");
        String role = req.getParameter("role");

        if (login != null && password != null && role != null
                && !login.trim().isEmpty() && !password.trim().isEmpty()) {
            Utilisateur u = new Utilisateur();
            u.setLogin(login.trim());
            u.setMotDePasse(password.trim());
            u.setRole(role.trim());
            userDAO.save(u);
        }
        resp.sendRedirect(req.getContextPath() + "/admin/");
    }

    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idStr = req.getParameter("id");
        String login = req.getParameter("login");
        String password = req.getParameter("password");

        if (idStr != null && login != null && !login.trim().isEmpty()) {
            try {
                int id = Integer.parseInt(idStr);
                Utilisateur existing = userDAO.findById(id);
                if (existing != null) {
                    existing.setLogin(login.trim());
                    // Only update password if a new one was provided
                    if (password != null && !password.trim().isEmpty()) {
                        existing.setMotDePasse(password.trim());
                    }
                    userDAO.update(existing);
                }
            } catch (NumberFormatException e) {
                System.err.println("Invalid user ID for update: " + idStr);
            }
        }
        resp.sendRedirect(req.getContextPath() + "/admin/");
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idStr = req.getParameter("id");
        if (idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                userDAO.delete(id);
            } catch (NumberFormatException e) {
                System.err.println("Invalid user ID for delete: " + idStr);
            }
        }
        resp.sendRedirect(req.getContextPath() + "/admin/");
    }
}
