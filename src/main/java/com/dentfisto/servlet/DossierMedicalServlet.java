package com.dentfisto.servlet;

import com.dentfisto.dao.*;
import com.dentfisto.model.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/dentist/dossier")
public class DossierMedicalServlet extends HttpServlet {

    private final PatientDAO patientDAO = new PatientDAO();
    private final DossierMedicalDAO dossierDAO = new DossierMedicalDAO();
    private final ConsultationDAO consultDAO = new ConsultationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String patientIdStr = req.getParameter("patientId");
        if (patientIdStr == null) {
            resp.sendRedirect(req.getContextPath() + "/dentist/");
            return;
        }

        int patientId = Integer.parseInt(patientIdStr);
        Patient patient = patientDAO.getById(patientId);
        DossierMedical dossier = dossierDAO.getDossierComplet(patientId);

        List<Consultation> consultations = null;
        if (dossier != null) {
            consultations = consultDAO.getConsultationsByDossier(dossier.getId());
            // Load actes for each consultation
            for (Consultation c : consultations) {
                c.getActesRealises().addAll(consultDAO.getActesForConsultation(c.getId()));
            }
        }

        req.setAttribute("patient", patient);
        req.setAttribute("dossier", dossier);
        req.setAttribute("consultations", consultations);
        req.setAttribute("showDossier", true);

        // Fetch user data so the dashboard doesn't look empty when in dossier view
        Utilisateur user = (Utilisateur) req.getSession().getAttribute("user");
        if (user != null) {
            req.setAttribute("rdvList", new RendezVousDAO().getTodayByDentistOrdered(user.getId()));
            req.setAttribute("actes", new ActeDAO().getAllActes());
        }

        req.getRequestDispatcher("/dentist/index.jsp").forward(req, resp);
    }
}
