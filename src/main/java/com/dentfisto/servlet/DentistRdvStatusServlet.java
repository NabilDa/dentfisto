package com.dentfisto.servlet;

import com.dentfisto.dao.RendezVousDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/dentist/rdv/status")
public class DentistRdvStatusServlet extends HttpServlet {

    private final RendezVousDAO rdvDAO = new RendezVousDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idStr = req.getParameter("rdvId");
        String status = req.getParameter("status");

        if (idStr == null || status == null) {
            resp.sendRedirect(req.getContextPath() + "/dentist/");
            return;
        }

        int rdvId = Integer.parseInt(idStr);
        rdvDAO.modifierStatut(rdvId, status);

        // If status changed to EN_COURS, redirect to consultation page
        if ("EN_COURS".equals(status)) {
            resp.sendRedirect(req.getContextPath() + "/dentist/consultation?rdvId=" + rdvId);
        } else {
            resp.sendRedirect(req.getContextPath() + "/dentist/");
        }
    }
}
