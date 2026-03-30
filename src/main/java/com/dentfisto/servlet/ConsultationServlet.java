package com.dentfisto.servlet;

import com.dentfisto.dao.*;
import com.dentfisto.model.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/dentist/consultation")
public class ConsultationServlet extends HttpServlet {

    private final ConsultationDAO consultDAO = new ConsultationDAO();
    private final RendezVousDAO rdvDAO = new RendezVousDAO();
    private final PatientDAO patientDAO = new PatientDAO();
    private final DossierMedicalDAO dossierDAO = new DossierMedicalDAO();
    private final ActeDAO acteDAO = new ActeDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String rdvIdStr = req.getParameter("rdvId");
        if (rdvIdStr == null) { resp.sendRedirect(req.getContextPath() + "/dentist/"); return; }

        int rdvId = Integer.parseInt(rdvIdStr);
        RendezVous rdv = rdvDAO.getByIdWithPatient(rdvId);
        if (rdv == null) { resp.sendRedirect(req.getContextPath() + "/dentist/"); return; }

        Consultation consultation = consultDAO.getConsultationParRdv(rdvId);
        Patient patient = patientDAO.getById(rdv.getPatientId());
        DossierMedical dossier = dossierDAO.getDossierComplet(rdv.getPatientId());

        // Load existing actes for this consultation
        if (consultation != null) {
            consultation.getActesRealises().addAll(consultDAO.getActesForConsultation(consultation.getId()));
        }

        req.setAttribute("rdv", rdv);
        req.setAttribute("consultation", consultation);
        req.setAttribute("patient", patient);
        req.setAttribute("dossier", dossier);
        req.setAttribute("catalogueActes", acteDAO.getAllActes());

        // Fetch user data so the dashboard doesn't look empty when in consultation view
        Utilisateur user = (Utilisateur) req.getSession().getAttribute("user");
        if (user != null) {
            req.setAttribute("rdvList", rdvDAO.getTodayByDentistOrdered(user.getId()));
            req.setAttribute("actes", req.getAttribute("catalogueActes"));
        }

        req.getRequestDispatcher("/dentist/index.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int consultationId = Integer.parseInt(req.getParameter("consultationId"));
        int rdvId = Integer.parseInt(req.getParameter("rdvId"));
        String diagnostic = req.getParameter("diagnostic");
        String observations = req.getParameter("observations");
        String[] acteIds = req.getParameterValues("acteIds");

        Consultation consultation = consultDAO.getById(consultationId);
        if (consultation == null) { resp.sendRedirect(req.getContextPath() + "/dentist/"); return; }

        consultation.setDiagnostic(diagnostic);
        consultation.setObservations(observations);

        // Add selected actes
        if (acteIds != null) {
            for (String aid : acteIds) {
                Acte a = new Acte();
                a.setId(Integer.parseInt(aid));
                consultation.addActe(a);
            }
        }

        consultDAO.sauvegarderConsultation(consultation);

        // Save document if provided
        String docType = req.getParameter("docType");
        String docDate = req.getParameter("docDate");
        String docPath = req.getParameter("docPath");
        if (docType != null && !docType.trim().isEmpty()
                && docPath != null && !docPath.trim().isEmpty()) {
            RendezVous rdvObj = rdvDAO.getByIdWithPatient(rdvId);
            if (rdvObj != null) {
                DossierMedical dossier = dossierDAO.getDossierComplet(rdvObj.getPatientId());
                if (dossier != null) {
                    Document doc = new Document();
                    doc.setType(docType.trim());
                    doc.setCheminAcces(docPath.trim());
                    if (docDate != null && !docDate.trim().isEmpty()) {
                        doc.setDateImportation(java.time.LocalDate.parse(docDate.trim()));
                    } else {
                        doc.setDateImportation(java.time.LocalDate.now());
                    }
                    doc.setDossierId(dossier.getId());
                    dossierDAO.ajouterDocument(doc);
                }
            }
        }

        // Set RDV status to TERMINE
        rdvDAO.modifierStatut(rdvId, "TERMINE");

        // Check if user wants to generate ordonnance
        String genOrd = req.getParameter("generateOrdonnance");
        if ("true".equals(genOrd)) {
            resp.sendRedirect(req.getContextPath() + "/dentist/ordonnance?consultationId=" + consultationId + "&rdvId=" + rdvId);
        } else {
            resp.sendRedirect(req.getContextPath() + "/dentist/");
        }
    }
}
