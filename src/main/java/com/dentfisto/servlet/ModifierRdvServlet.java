package com.dentfisto.servlet;

import com.dentfisto.dao.RendezVousDAO;
import com.dentfisto.model.RendezVous;
import com.dentfisto.model.Utilisateur;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.time.LocalTime;

/**
 * POST /assistant/modifier-rdv
 * Updates all editable fields of a rendez-vous.
 */
@WebServlet("/assistant/modifier-rdv")
public class ModifierRdvServlet extends HttpServlet {

    private final RendezVousDAO rdvDAO = new RendezVousDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Utilisateur user = (Utilisateur) req.getSession().getAttribute("user");
        if (user == null) { resp.setStatus(401); return; }

        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        try {
            int    rdvId  = Integer.parseInt(req.getParameter("rdvId").trim());
            String dateS  = req.getParameter("dateRdv").trim();
            String heureS = req.getParameter("heureDebut").trim();
            String motif  = req.getParameter("motif").trim();
            String statut = req.getParameter("statut").trim();
            String notes  = req.getParameter("notesInternes");

            if (dateS.isEmpty() || heureS.isEmpty() || motif.isEmpty()) {
                out.print("{\"success\":false,\"message\":\"Champs obligatoires manquants.\"}");
                return;
            }

            LocalDate  date       = LocalDate.parse(dateS);
            LocalTime  heureDebut = LocalTime.parse(heureS);
            LocalTime  heureFin   = heureDebut.plusMinutes(45);

            // Fetch existing to preserve patientId and dentisteId
            RendezVous existing = rdvDAO.getByIdWithPatient(rdvId);
            if (existing == null) {
                out.print("{\"success\":false,\"message\":\"RDV introuvable.\"}");
                return;
            }

            existing.setDateRdv(date);
            existing.setHeureDebut(heureDebut);
            existing.setHeureFin(heureFin);
            existing.setMotif(motif);
            existing.setStatut(statut);
            existing.setNotesInternes(notes != null && !notes.trim().isEmpty() ? notes.trim() : null);

            boolean ok = rdvDAO.updateRendezVous(existing);
            out.print(ok ? "{\"success\":true}" : "{\"success\":false,\"message\":\"Échec de la mise à jour.\"}");

        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\":false,\"message\":\"Erreur serveur : " + e.getMessage().replace("\"","'") + "\"}");
        }
    }
}
