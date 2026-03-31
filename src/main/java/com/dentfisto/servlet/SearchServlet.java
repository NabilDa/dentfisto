package com.dentfisto.servlet;

import com.dentfisto.dao.PatientDAO;
import com.dentfisto.dao.RendezVousDAO;
import com.dentfisto.dao.DossierMedicalDAO;
import com.dentfisto.dao.ConsultationDAO;
import com.dentfisto.dao.OrdonnanceDAO;
import com.dentfisto.model.Patient;
import com.dentfisto.model.RendezVous;
import com.dentfisto.model.DossierMedical;
import com.dentfisto.model.Consultation;
import com.dentfisto.model.Acte;
import com.dentfisto.model.Document;
import com.dentfisto.model.Ordonnance;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@WebServlet("/api/search")
public class SearchServlet extends HttpServlet {

    private final PatientDAO patientDAO = new PatientDAO();
    private final RendezVousDAO rdvDAO = new RendezVousDAO();
    private final DossierMedicalDAO dossierDAO = new DossierMedicalDAO();
    private final ConsultationDAO consultDAO = new ConsultationDAO();
    private final OrdonnanceDAO ordDAO = new OrdonnanceDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json;charset=UTF-8");
        String type = req.getParameter("type");

        // Patient detail endpoint: /api/search?type=patientDetail&id=X
        if ("patientDetail".equals(type)) {
            handlePatientDetail(req, resp);
            return;
        }

        // RDV detail endpoint: /api/search?type=rdvDetail&id=X
        if ("rdvDetail".equals(type)) {
            handleRdvDetail(req, resp);
            return;
        }

        String nom = req.getParameter("nom");
        String tel = req.getParameter("tel");

        if (nom == null || tel == null || nom.trim().isEmpty() || tel.trim().isEmpty()) {
            resp.getWriter().write("{\"results\":[]}");
            return;
        }

        PrintWriter out = resp.getWriter();
        StringBuilder json = new StringBuilder("{\"results\":[");

        if ("rdv".equals(type)) {
            List<RendezVous> rdvs = rdvDAO.searchByPatientNameAndPhone(nom.trim(), tel.trim());
            for (int i = 0; i < rdvs.size(); i++) {
                RendezVous r = rdvs.get(i);
                if (i > 0) json.append(",");
                json.append("{")
                    .append("\"id\":").append(r.getId()).append(",")
                    .append("\"patient\":\"").append(esc(r.getPatientFullName())).append("\",")
                    .append("\"tel\":\"").append(esc(r.getPatientTel())).append("\",")
                    .append("\"date\":\"").append(r.getDateRdv()).append("\",")
                    .append("\"heure\":\"").append(r.getHeureDebut()).append("\",")
                    .append("\"motif\":\"").append(esc(r.getMotif())).append("\",")
                    .append("\"statut\":\"").append(esc(r.getStatut())).append("\",")
                    .append("\"patientId\":").append(r.getPatientId())
                    .append("}");
            }
        } else {
            List<Patient> patients = patientDAO.searchByNameAndPhone(nom.trim(), tel.trim());
            for (int i = 0; i < patients.size(); i++) {
                Patient p = patients.get(i);
                if (i > 0) json.append(",");
                json.append("{")
                    .append("\"id\":").append(p.getId()).append(",")
                    .append("\"nom\":\"").append(esc(p.getNom())).append("\",")
                    .append("\"prenom\":\"").append(esc(p.getPrenom())).append("\",")
                    .append("\"tel\":\"").append(esc(p.getTelephone())).append("\",")
                    .append("\"sexe\":\"").append(esc(p.getSexe())).append("\",")
                    .append("\"dateNaissance\":\"").append(p.getDateNaissance()).append("\"")
                    .append("}");
            }
        }

        json.append("]}");
        out.write(json.toString());
    }

    /**
     * Returns full patient details + dossier + consultations as JSON.
     * URL: /api/search?type=patientDetail&id=123
     */
    private void handlePatientDetail(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String idStr = req.getParameter("id");
        PrintWriter out = resp.getWriter();

        if (idStr == null || idStr.trim().isEmpty()) {
            out.write("{\"error\":\"ID manquant\"}");
            return;
        }

        int patientId;
        try { patientId = Integer.parseInt(idStr.trim()); }
        catch (NumberFormatException e) { out.write("{\"error\":\"ID invalide\"}"); return; }

        Patient p = patientDAO.getById(patientId);
        if (p == null) { out.write("{\"error\":\"Patient introuvable\"}"); return; }

        StringBuilder json = new StringBuilder("{");
        // Patient info
        json.append("\"id\":").append(p.getId()).append(",");
        json.append("\"nom\":\"").append(esc(p.getNom())).append("\",");
        json.append("\"prenom\":\"").append(esc(p.getPrenom())).append("\",");
        json.append("\"tel\":\"").append(esc(p.getTelephone())).append("\",");
        json.append("\"sexe\":\"").append(esc(p.getSexe())).append("\",");
        json.append("\"dateNaissance\":\"").append(p.getDateNaissance()).append("\",");
        json.append("\"adresse\":\"").append(esc(p.getAdresse())).append("\",");
        json.append("\"cnssMutuelle\":\"").append(esc(p.getCnssMutuelle())).append("\",");
        json.append("\"antecedents\":\"").append(esc(p.getAntecedentsMedicaux())).append("\",");
        json.append("\"allergie\":\"").append(esc(p.getAllergieCritique())).append("\",");
        json.append("\"responsableNom\":\"").append(esc(p.getResponsableLegalNom())).append("\",");
        json.append("\"responsableTel\":\"").append(esc(p.getResponsableLegalTel())).append("\",");

        // Dossier médical
        DossierMedical dossier = dossierDAO.getDossierComplet(patientId);
        if (dossier != null) {
            json.append("\"dossier\":{");
            json.append("\"id\":").append(dossier.getId()).append(",");
            json.append("\"ref\":\"").append(esc(dossier.getNumeroReference())).append("\",");
            json.append("\"dateCreation\":\"").append(dossier.getDateCreation()).append("\",");

            // Documents
            json.append("\"documents\":[");
            List<Document> docs = dossier.getDocumentsAnnexes();
            for (int i = 0; i < docs.size(); i++) {
                Document d = docs.get(i);
                if (i > 0) json.append(",");
                json.append("{\"type\":\"").append(esc(d.getType())).append("\",");
                json.append("\"date\":\"").append(d.getDateImportation()).append("\",");
                json.append("\"chemin\":\"").append(esc(d.getCheminAcces())).append("\"}");
            }
            json.append("]},");

            // Consultations
            json.append("\"consultations\":[");
            List<Consultation> consults = consultDAO.getConsultationsByDossier(dossier.getId());
            for (int i = 0; i < consults.size(); i++) {
                Consultation c = consults.get(i);
                // Load actes for this consultation
                List<Acte> actes = consultDAO.getActesForConsultation(c.getId());
                if (i > 0) json.append(",");
                json.append("{");
                json.append("\"id\":").append(c.getId()).append(",");
                json.append("\"diagnostic\":\"").append(esc(c.getDiagnostic())).append("\",");
                json.append("\"observations\":\"").append(esc(c.getObservations())).append("\",");
                json.append("\"date\":\"").append(c.getDateConsultation() != null ? c.getDateConsultation() : "").append("\",");
                json.append("\"heure\":\"").append(c.getHeureConsultation() != null ? c.getHeureConsultation() : "").append("\",");
                json.append("\"motif\":\"").append(esc(c.getMotifRdv())).append("\",");
                json.append("\"actes\":[");
                for (int j = 0; j < actes.size(); j++) {
                    if (j > 0) json.append(",");
                    json.append("{\"nom\":\"").append(esc(actes.get(j).getNom())).append("\",");
                    json.append("\"tarif\":").append(actes.get(j).getTarifBase()).append("}");
                }
                json.append("],");

                // Load ordonnance (medications) for this consultation
                Ordonnance ord = ordDAO.getByConsultationId(c.getId());
                json.append("\"medicaments\":[");
                if (ord != null && ord.getCheminPdf() != null && !ord.getCheminPdf().trim().isEmpty()) {
                    String[] meds = ord.getCheminPdf().split("\\|\\|\\|");
                    for (int m = 0; m < meds.length; m++) {
                        if (m > 0) json.append(",");
                        json.append("\"").append(esc(meds[m].trim())).append("\"");
                    }
                }
                json.append("]}");
            }
            json.append("]");
        } else {
            json.append("\"dossier\":null,\"consultations\":[]");
        }

        json.append("}");
        out.write(json.toString());
    }

    /**
     * Returns a single RDV's full details as JSON.
     * URL: /api/search?type=rdvDetail&id=123
     */
    private void handleRdvDetail(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String idStr = req.getParameter("id");
        PrintWriter out = resp.getWriter();

        if (idStr == null || idStr.trim().isEmpty()) {
            out.write("{\"error\":\"ID manquant\"}");
            return;
        }

        int rdvId;
        try { rdvId = Integer.parseInt(idStr.trim()); }
        catch (NumberFormatException e) { out.write("{\"error\":\"ID invalide\"}"); return; }

        RendezVous r = rdvDAO.getByIdWithPatient(rdvId);
        if (r == null) { out.write("{\"error\":\"RDV introuvable\"}"); return; }

        StringBuilder json = new StringBuilder("{");
        json.append("\"id\":").append(r.getId()).append(",");
        json.append("\"patient\":\"").append(esc(r.getPatientFullName())).append("\",");
        json.append("\"patientId\":").append(r.getPatientId()).append(",");
        json.append("\"tel\":\"").append(esc(r.getPatientTel())).append("\",");
        json.append("\"date\":\"").append(r.getDateRdv()).append("\",");
        json.append("\"heureDebut\":\"").append(r.getHeureDebut()).append("\",");
        json.append("\"heureFin\":\"").append(r.getHeureFin()).append("\",");
        json.append("\"motif\":\"").append(esc(r.getMotif())).append("\",");
        json.append("\"notes\":\"").append(esc(r.getNotesInternes())).append("\",");
        json.append("\"statut\":\"").append(esc(r.getStatut())).append("\",");
        json.append("\"dentisteId\":").append(r.getDentisteId());
        json.append("}");
        out.write(json.toString());
    }

    /**
     * Handles PUT requests for updating patient or RDV data.
     */
    @Override
    protected void doPut(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json;charset=UTF-8");
        String type = req.getParameter("type");
        PrintWriter out = resp.getWriter();

        // Read JSON body
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = req.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) sb.append(line);
        }
        String body = sb.toString();

        if ("updatePatient".equals(type)) {
            handleUpdatePatient(body, out);
        } else if ("updateRdv".equals(type)) {
            handleUpdateRdv(body, out);
        } else if ("cancelRdv".equals(type)) {
            handleCancelRdv(body, out);
        } else {
            out.write("{\"error\":\"Type inconnu\"}");
        }
    }

    private void handleUpdatePatient(String body, PrintWriter out) {
        try {
            int id = getJsonInt(body, "id");
            Patient p = patientDAO.getById(id);
            if (p == null) { out.write("{\"error\":\"Patient introuvable\"}"); return; }

            p.setNom(getJsonString(body, "nom"));
            p.setPrenom(getJsonString(body, "prenom"));
            p.setDateNaissance(LocalDate.parse(getJsonString(body, "dateNaissance")));
            p.setSexe(getJsonString(body, "sexe"));
            p.setAdresse(getJsonString(body, "adresse"));
            p.setTelephone(getJsonString(body, "telephone"));
            p.setCnssMutuelle(getJsonString(body, "cnssMutuelle"));
            p.setAntecedentsMedicaux(getJsonString(body, "antecedents"));
            p.setAllergieCritique(getJsonString(body, "allergie"));
            p.setResponsableLegalNom(getJsonString(body, "responsableNom"));
            p.setResponsableLegalTel(getJsonString(body, "responsableTel"));

            boolean ok = patientDAO.update(p);
            out.write(ok ? "{\"success\":true}" : "{\"error\":\"Échec de la mise à jour\"}");
        } catch (Exception e) {
            out.write("{\"error\":\"" + esc(e.getMessage()) + "\"}");
        }
    }

    private void handleUpdateRdv(String body, PrintWriter out) {
        try {
            int id = getJsonInt(body, "id");
            RendezVous r = rdvDAO.getByIdWithPatient(id);
            if (r == null) { out.write("{\"error\":\"RDV introuvable\"}"); return; }

            r.setDateRdv(LocalDate.parse(getJsonString(body, "date")));
            r.setHeureDebut(LocalTime.parse(getJsonString(body, "heureDebut")));
            r.setHeureFin(LocalTime.parse(getJsonString(body, "heureFin")));
            r.setMotif(getJsonString(body, "motif"));
            r.setNotesInternes(getJsonString(body, "notes"));
            r.setStatut(getJsonString(body, "statut"));

            boolean ok = rdvDAO.updateRendezVous(r);
            out.write(ok ? "{\"success\":true}" : "{\"error\":\"Échec de la mise à jour\"}");
        } catch (Exception e) {
            out.write("{\"error\":\"" + esc(e.getMessage()) + "\"}");
        }
    }

    private void handleCancelRdv(String body, PrintWriter out) {
        try {
            int id = getJsonInt(body, "id");
            boolean ok = rdvDAO.modifierStatut(id, "ANNULE");
            out.write(ok ? "{\"success\":true}" : "{\"error\":\"Échec de l'annulation\"}");
        } catch (Exception e) {
            out.write("{\"error\":\"" + esc(e.getMessage()) + "\"}");
        }
    }

    /* ── Simple JSON helpers (no library dependency) ── */

    private String getJsonString(String json, String key) {
        String search = "\"" + key + "\":\"";
        int start = json.indexOf(search);
        if (start == -1) return "";
        start += search.length();
        int end = json.indexOf("\"", start);
        while (end > 0 && json.charAt(end - 1) == '\\') {
            end = json.indexOf("\"", end + 1);
        }
        if (end == -1) return "";
        return json.substring(start, end).replace("\\\"", "\"").replace("\\\\", "\\");
    }

    private int getJsonInt(String json, String key) {
        String search = "\"" + key + "\":";
        int start = json.indexOf(search);
        if (start == -1) return 0;
        start += search.length();
        int end = start;
        while (end < json.length() && (Character.isDigit(json.charAt(end)) || json.charAt(end) == '-')) {
            end++;
        }
        return Integer.parseInt(json.substring(start, end));
    }

    private String esc(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
