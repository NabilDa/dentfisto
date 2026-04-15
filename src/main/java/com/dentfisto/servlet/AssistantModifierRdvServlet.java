package com.dentfisto.servlet;

import com.dentfisto.dao.RendezVousDAO;
import com.dentfisto.dao.UtilisateurDAO;
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
import java.util.List;

/**
 * POST /assistant/modifier-rdv-full
 * Updates ALL fields of a rendez-vous including dentisteId.
 * This is separate from the dentist-facing ModifierRdvServlet.
 *
 * GET  /assistant/modifier-rdv-full?action=getRdvFull&id=X
 * Returns all RDV data including dentisteId and list of dentistes.
 */
@WebServlet("/assistant/modifier-rdv-full")
public class AssistantModifierRdvServlet extends HttpServlet {

    private final RendezVousDAO rdvDAO = new RendezVousDAO();
    private final UtilisateurDAO utilisateurDAO = new UtilisateurDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Utilisateur user = (Utilisateur) req.getSession().getAttribute("user");
        if (user == null) { resp.setStatus(401); return; }

        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        String action = req.getParameter("action");

        if ("getRdvFull".equals(action)) {
            String idStr = req.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                out.print("{\"error\":\"id manquant\"}");
                return;
            }
            try {
                int rdvId = Integer.parseInt(idStr.trim());
                RendezVous rdv = rdvDAO.getByIdWithPatient(rdvId);
                if (rdv == null) {
                    out.print("{\"error\":\"RDV introuvable\"}");
                    return;
                }

                // Get all dentists for dropdown
                List<Utilisateur> all = utilisateurDAO.findAll();

                StringBuilder sb = new StringBuilder("{");
                sb.append("\"id\":").append(rdv.getId()).append(",");
                sb.append("\"dateRdv\":\"").append(rdv.getDateRdv()).append("\",");
                sb.append("\"heureDebut\":\"").append(rdv.getHeureDebut()).append("\",");
                sb.append("\"heureFin\":\"").append(rdv.getHeureFin()).append("\",");
                sb.append("\"motif\":\"").append(escJson(rdv.getMotif())).append("\",");
                sb.append("\"statut\":\"").append(escJson(rdv.getStatut())).append("\",");
                sb.append("\"dentisteId\":").append(rdv.getDentisteId()).append(",");
                sb.append("\"patientId\":").append(rdv.getPatientId()).append(",");
                String notes = rdv.getNotesInternes() != null ? rdv.getNotesInternes() : "";
                sb.append("\"notes\":\"").append(escJson(notes)).append("\",");
                sb.append("\"patientNom\":\"").append(escJson(rdv.getPatientNom())).append("\",");
                sb.append("\"patientPrenom\":\"").append(escJson(rdv.getPatientPrenom())).append("\",");
                sb.append("\"patientTel\":\"").append(escJson(rdv.getPatientTel())).append("\",");

                // Include dentist list
                sb.append("\"dentistes\":[");
                boolean first = true;
                for (Utilisateur u : all) {
                    if ("DENTISTE".equals(u.getRole())) {
                        if (!first) sb.append(",");
                        sb.append("{\"id\":").append(u.getId())
                          .append(",\"login\":\"").append(escJson(u.getLogin())).append("\"}");
                        first = false;
                    }
                }
                sb.append("]}");
                out.print(sb);
            } catch (Exception e) {
                out.print("{\"error\":\"" + escJson(e.getMessage()) + "\"}");
            }
        } else {
            resp.setStatus(400);
            out.print("{\"error\":\"action inconnue\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Utilisateur user = (Utilisateur) req.getSession().getAttribute("user");
        if (user == null) { resp.setStatus(401); return; }

        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        try {
            int    rdvId      = Integer.parseInt(req.getParameter("rdvId").trim());
            String dateS      = req.getParameter("dateRdv").trim();
            String heureS     = req.getParameter("heureDebut").trim();
            String motif      = req.getParameter("motif").trim();
            String statut     = req.getParameter("statut").trim();
            String dentisteStr = req.getParameter("dentisteId").trim();
            String notes      = req.getParameter("notesInternes");

            if (dateS.isEmpty() || heureS.isEmpty() || motif.isEmpty() || dentisteStr.isEmpty()) {
                out.print("{\"success\":false,\"message\":\"Champs obligatoires manquants.\"}");
                return;
            }

            LocalDate  date       = LocalDate.parse(dateS);
            LocalTime  heureDebut = LocalTime.parse(heureS);
            LocalTime  heureFin   = heureDebut.plusMinutes(60);
            int dentisteId        = Integer.parseInt(dentisteStr);

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
            existing.setDentisteId(dentisteId);
            existing.setNotesInternes(notes != null && !notes.trim().isEmpty() ? notes.trim() : null);

            boolean ok = rdvDAO.updateRendezVousFull(existing);
            out.print(ok ? "{\"success\":true}" : "{\"success\":false,\"message\":\"Échec de la mise à jour.\"}");

        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\":false,\"message\":\"Erreur serveur : " + escJson(e.getMessage()) + "\"}");
        }
    }

    private static String escJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }
}
