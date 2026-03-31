package com.dentfisto.servlet;

import com.dentfisto.dao.OrdonnanceDAO;
import com.dentfisto.dao.ConsultationDAO;
import com.dentfisto.dao.RendezVousDAO;
import com.dentfisto.dao.PatientDAO;
import com.dentfisto.model.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/dentist/ordonnance")
public class OrdonnanceServlet extends HttpServlet {

    private final OrdonnanceDAO ordDAO = new OrdonnanceDAO();
    private final ConsultationDAO consultDAO = new ConsultationDAO();
    private final RendezVousDAO rdvDAO = new RendezVousDAO();
    private final PatientDAO patientDAO = new PatientDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String consultIdStr = req.getParameter("consultationId");
        String rdvIdStr = req.getParameter("rdvId");

        // Support both consultationId and rdvId parameters
        int consultationId = -1;
        if (consultIdStr != null) {
            consultationId = Integer.parseInt(consultIdStr);
        } else if (rdvIdStr != null) {
            // Look up consultation from rdvId
            Consultation cFromRdv = consultDAO.getConsultationParRdv(Integer.parseInt(rdvIdStr));
            if (cFromRdv != null) {
                consultationId = cFromRdv.getId();
            }
        }

        if (consultationId == -1) { resp.sendRedirect(req.getContextPath() + "/dentist/"); return; }

        Consultation consultation = consultDAO.getById(consultationId);
        if (consultation == null) { resp.sendRedirect(req.getContextPath() + "/dentist/"); return; }

        RendezVous rdv = rdvDAO.getByIdWithPatient(consultation.getRdvId());
        Patient patient = rdv != null ? patientDAO.getById(rdv.getPatientId()) : null;
        Ordonnance existing = ordDAO.getByConsultationId(consultationId);

        req.setAttribute("rdv", rdv);
        req.setAttribute("consultation", consultation);
        req.setAttribute("patient", patient);
        req.setAttribute("ordonnance", existing);
        req.setAttribute("showOrdonnance", true);

        // Fetch user data so the dashboard doesn't look empty when in ordonnance view
        Utilisateur user = (Utilisateur) req.getSession().getAttribute("user");
        if (user != null) {
            req.setAttribute("rdvList", rdvDAO.getTodayByDentistOrdered(user.getId()));
            req.setAttribute("actes", new com.dentfisto.dao.ActeDAO().getAllActes());
        }

        req.getRequestDispatcher("/dentist/index.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int consultationId = Integer.parseInt(req.getParameter("consultationId"));
        String medications = req.getParameter("medications"); // comma-separated medication list

        // Save ordonnance with medications stored in cheminPdf field as text
        Ordonnance ord = new Ordonnance();
        ord.setConsultationId(consultationId);
        ord.setCheminPdf(medications != null ? medications : "");

        ordDAO.sauvegarderOrdonnance(ord);

        resp.sendRedirect(req.getContextPath() + "/dentist/");
    }
}
