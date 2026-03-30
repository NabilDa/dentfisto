package com.dentfisto.servlet;

import com.dentfisto.dao.PatientDAO;
import com.dentfisto.dao.RendezVousDAO;
import com.dentfisto.dao.DossierMedicalDAO;
import com.dentfisto.dao.ConsultationDAO;
import com.dentfisto.model.Patient;
import com.dentfisto.model.RendezVous;
import com.dentfisto.model.DossierMedical;
import com.dentfisto.model.Consultation;
import com.dentfisto.model.Acte;
import com.dentfisto.model.Document;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/api/search")
public class SearchServlet extends HttpServlet {

    private final PatientDAO patientDAO = new PatientDAO();
    private final RendezVousDAO rdvDAO = new RendezVousDAO();
    private final DossierMedicalDAO dossierDAO = new DossierMedicalDAO();
    private final ConsultationDAO consultDAO = new ConsultationDAO();

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
                json.append("]}");
            }
            json.append("]");
        } else {
            json.append("\"dossier\":null,\"consultations\":[]");
        }

        json.append("}");
        out.write(json.toString());
    }

    private String esc(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
