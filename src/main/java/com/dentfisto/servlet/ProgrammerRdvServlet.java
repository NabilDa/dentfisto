package com.dentfisto.servlet;

import com.dentfisto.dao.PatientDAO;
import com.dentfisto.dao.RendezVousDAO;
import com.dentfisto.dao.UtilisateurDAO;
import com.dentfisto.model.Patient;
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

@WebServlet("/assistant/programmer-rdv")
public class ProgrammerRdvServlet extends HttpServlet {

    private final UtilisateurDAO utilisateurDAO = new UtilisateurDAO();
    private final PatientDAO patientDAO = new PatientDAO();
    private final RendezVousDAO rdvDAO = new RendezVousDAO();

    // ── GET ───────────────────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (req.getSession().getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login-assistant.jsp");
            return;
        }

        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();
        String action = req.getParameter("action");

        // ── List all dentists ─────────────────────────────────────────────
        if ("dentistes".equals(action)) {
            List<Utilisateur> all = utilisateurDAO.findAll();
            StringBuilder sb = new StringBuilder("[");
            boolean first = true;
            for (Utilisateur u : all) {
                if ("DENTISTE".equals(u.getRole())) {
                    if (!first)
                        sb.append(",");
                    sb.append("{\"id\":").append(u.getId())
                            .append(",\"login\":\"").append(escJson(u.getLogin())).append("\"}");
                    first = false;
                }
            }
            sb.append("]");
            out.print(sb);

            // ── Booked slots for a dentist on a date ─────────────────────────
        } else if ("creneaux".equals(action)) {
            String dateStr = req.getParameter("date");
            String dentisteStr = req.getParameter("dentisteId");
            if (dateStr == null || dentisteStr == null || dentisteStr.trim().isEmpty()) {
                out.print("[]");
                return;
            }
            try {
                int dentisteId = Integer.parseInt(dentisteStr.trim());
                LocalDate date = LocalDate.parse(dateStr.trim());
                List<RendezVous> rdvs = rdvDAO.getPlanningDentiste(dentisteId, date);
                StringBuilder sb = new StringBuilder("[");
                boolean first = true;
                for (RendezVous r : rdvs) {
                    if ("ANNULE".equals(r.getStatut()) || "NON_HONORE".equals(r.getStatut()))
                        continue;
                    if (!first)
                        sb.append(",");
                    sb.append("{\"debut\":\"").append(r.getHeureDebut())
                            .append("\",\"fin\":\"").append(r.getHeureFin()).append("\"}");
                    first = false;
                }
                sb.append("]");
                out.print(sb);
            } catch (Exception e) {
                out.print("[]");
            }

            // ── Single RDV for the edit modal ────────────────────────────────
        } else if ("getRdv".equals(action)) {
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
                StringBuilder sb = new StringBuilder("{");
                sb.append("\"id\":").append(rdv.getId()).append(",");
                sb.append("\"dateRdv\":\"").append(rdv.getDateRdv()).append("\",");
                sb.append("\"heureDebut\":\"").append(rdv.getHeureDebut()).append("\",");
                sb.append("\"heureFin\":\"").append(rdv.getHeureFin()).append("\",");
                sb.append("\"motif\":\"").append(escJson(rdv.getMotif())).append("\",");
                sb.append("\"statut\":\"").append(escJson(rdv.getStatut())).append("\",");
                String notes = rdv.getNotesInternes() != null ? rdv.getNotesInternes() : "";
                sb.append("\"notes\":\"").append(escJson(notes)).append("\"");
                sb.append("}");
                out.print(sb);
            } catch (Exception e) {
                out.print("{\"error\":\"" + escJson(e.getMessage()) + "\"}");
            }

            // ── Search patients by name (tel optional) ────────────────────────
        } else if ("searchPatient".equals(action)) {
            String nom = req.getParameter("nom");
            String tel = req.getParameter("tel");
            if (nom == null || nom.trim().isEmpty()) {
                out.print("{\"results\":[]}");
                return;
            }
            List<Patient> patients = patientDAO.searchByNameAndPhone(
                    nom.trim(), tel == null ? "" : tel.trim());
            StringBuilder sb = new StringBuilder("{\"results\":[");
            boolean first = true;
            for (Patient p : patients) {
                if (!first)
                    sb.append(",");
                sb.append("{\"id\":").append(p.getId())
                        .append(",\"nom\":\"").append(escJson(p.getNom())).append("\"")
                        .append(",\"prenom\":\"").append(escJson(p.getPrenom())).append("\"")
                        .append(",\"tel\":\"").append(escJson(p.getTelephone())).append("\"}");
                first = false;
            }
            sb.append("]}");
            out.print(sb);

        } else {
            resp.setStatus(400);
            out.print("{\"error\":\"action inconnue\"}");
        }
    }

    // ── POST ──────────────────────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (req.getSession().getAttribute("user") == null) {
            resp.setStatus(401);
            return;
        }

        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        try {
            int patientId = 0;
            String patientIdParam = req.getParameter("patientId");

            if (patientIdParam != null && !patientIdParam.trim().isEmpty()) {
                patientId = Integer.parseInt(patientIdParam.trim());
            } else {
                String nom = trim(req.getParameter("nouveauNom"));
                String prenom = trim(req.getParameter("nouveauPrenom"));
                String tel = trim(req.getParameter("nouveauTel"));
                if (nom.isEmpty() || prenom.isEmpty() || tel.isEmpty()) {
                    out.print("{\"success\":false,\"message\":\"Informations patient manquantes.\"}");
                    return;
                }
                Patient p = new Patient();
                p.setNom(nom);
                p.setPrenom(prenom);
                p.setTelephone(tel);
                p.setDateNaissance(LocalDate.of(2000, 1, 1));
                p.setSexe("H");
                p.setAdresse("\u2014");
                if (!patientDAO.ajouterPatient(p)) {
                    out.print("{\"success\":false,\"message\":\"Impossible d'ajouter le patient.\"}");
                    return;
                }
                Patient saved = patientDAO.rechercherPatient(nom, tel);
                if (saved == null) {
                    out.print("{\"success\":false,\"message\":\"Patient ajout\u00e9 mais introuvable.\"}");
                    return;
                }
                patientId = saved.getId();
            }

            String dateStr = trim(req.getParameter("dateRdv"));
            String heureStr = trim(req.getParameter("heureDebut"));
            String dentisteStr = trim(req.getParameter("dentisteId"));
            String motif = trim(req.getParameter("motif"));
            String notes = trim(req.getParameter("notesInternes"));

            if (dateStr.isEmpty() || heureStr.isEmpty() || dentisteStr.isEmpty() || motif.isEmpty()) {
                out.print("{\"success\":false,\"message\":\"Champs obligatoires manquants.\"}");
                return;
            }

            LocalDate date = LocalDate.parse(dateStr);
            LocalTime heureDebut = LocalTime.parse(heureStr);
            LocalTime heureFin = heureDebut.plusMinutes(45);
            int dentisteId = Integer.parseInt(dentisteStr);

            RendezVous rdv = new RendezVous();
            rdv.setDateRdv(date);
            rdv.setHeureDebut(heureDebut);
            rdv.setHeureFin(heureFin);
            rdv.setMotif(motif);
            rdv.setNotesInternes(notes.isEmpty() ? null : notes);
            rdv.setStatut("PLANIFIE");
            rdv.setPatientId(patientId);
            rdv.setDentisteId(dentisteId);

            if (!rdvDAO.ajouterRendezVous(rdv)) {
                out.print("{\"success\":false,\"message\":\"Impossible d'enregistrer le RDV (conflit horaire ?).\"}");
                return;
            }

            Patient patient = patientDAO.getById(patientId);
            Utilisateur dentiste = utilisateurDAO.findById(dentisteId);

            StringBuilder sb = new StringBuilder("{\"success\":true");
            sb.append(",\"patientNom\":\"").append(escJson(patient != null ? patient.getNom() : "")).append("\"");
            sb.append(",\"patientPrenom\":\"").append(escJson(patient != null ? patient.getPrenom() : "")).append("\"");
            sb.append(",\"patientTel\":\"").append(escJson(patient != null ? patient.getTelephone() : "")).append("\"");
            sb.append(",\"dentiste\":\"").append(escJson(dentiste != null ? dentiste.getLogin() : "")).append("\"");
            sb.append(",\"dateRdv\":\"").append(dateStr).append("\"");
            sb.append(",\"heureDebut\":\"").append(heureDebut).append("\"");
            sb.append(",\"heureFin\":\"").append(heureFin).append("\"");
            sb.append(",\"motif\":\"").append(escJson(motif)).append("\"");
            sb.append(",\"notes\":\"").append(escJson(notes)).append("\"");
            sb.append("}");
            out.print(sb);

        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\":false,\"message\":\"Erreur serveur : " + escJson(e.getMessage()) + "\"}");
        }
    }

    // ── Helpers ───────────────────────────────────────────────────────────
    private static String trim(String s) {
        return s == null ? "" : s.trim();
    }

    private static String escJson(String s) {
        if (s == null)
            return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }
}
