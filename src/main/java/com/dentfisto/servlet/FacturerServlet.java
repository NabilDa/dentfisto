package com.dentfisto.servlet;

import com.dentfisto.dao.ConsultationDAO;
import com.dentfisto.dao.DBConnection;
import com.dentfisto.dao.FactureDAO;
import com.dentfisto.dao.PatientDAO;
import com.dentfisto.dao.RendezVousDAO;
import com.dentfisto.dao.UtilisateurDAO;
import com.dentfisto.model.Acte;
import com.dentfisto.model.Consultation;
import com.dentfisto.model.Facture;
import com.dentfisto.model.Paiement;
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
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.util.List;

/**
 * GET  /assistant/facturer?action=getActes&rdvId=X
 *      Returns: {actes:[{code,nom,tarif}], total, dentiste, patientNom, patientPrenom, patientTel}
 *
 * POST /assistant/facturer
 *      Params: rdvId, modeReglement
 *      Saves facture + paiement in DB, returns full data for PDF generation.
 */
@WebServlet("/assistant/facturer")
public class FacturerServlet extends HttpServlet {

    private final RendezVousDAO    rdvDAO         = new RendezVousDAO();
    private final ConsultationDAO  consultationDAO = new ConsultationDAO();
    private final PatientDAO       patientDAO     = new PatientDAO();
    private final UtilisateurDAO   utilisateurDAO = new UtilisateurDAO();
    private final FactureDAO       factureDAO     = new FactureDAO();

    // ── GET ───────────────────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (req.getSession().getAttribute("user") == null) { resp.setStatus(401); return; }

        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        String rdvIdStr = req.getParameter("rdvId");
        if (rdvIdStr == null || rdvIdStr.trim().isEmpty()) {
            out.print("{\"error\":\"rdvId manquant\"}");
            return;
        }

        try {
            int rdvId = Integer.parseInt(rdvIdStr.trim());

            // Get RDV → consultation → actes
            RendezVous rdv = rdvDAO.getByIdWithPatient(rdvId);
            if (rdv == null) { out.print("{\"error\":\"RDV introuvable\"}"); return; }

            Consultation consultation = consultationDAO.getConsultationParRdv(rdvId);
            if (consultation == null) { out.print("{\"error\":\"Consultation introuvable\"}"); return; }

            List<Acte> actes = consultationDAO.getActesForConsultation(consultation.getId());

            Patient     patient  = patientDAO.getById(rdv.getPatientId());
            Utilisateur dentiste = utilisateurDAO.findById(rdv.getDentisteId());

            double total = 0;
            for (Acte a : actes) total += a.getTarifBase();

            StringBuilder sb = new StringBuilder("{");
            sb.append("\"total\":").append(String.format("%.2f", total)).append(",");
            sb.append("\"dentiste\":\"").append(escJson(dentiste != null ? dentiste.getLogin() : "")).append("\",");
            sb.append("\"patientNom\":\"").append(escJson(patient != null ? patient.getNom() : "")).append("\",");
            sb.append("\"patientPrenom\":\"").append(escJson(patient != null ? patient.getPrenom() : "")).append("\",");
            sb.append("\"patientTel\":\"").append(escJson(patient != null ? patient.getTelephone() : "")).append("\",");
            sb.append("\"actes\":[");
            for (int i = 0; i < actes.size(); i++) {
                if (i > 0) sb.append(",");
                Acte a = actes.get(i);
                sb.append("{\"code\":\"").append(escJson(a.getCode())).append("\"")
                  .append(",\"nom\":\"").append(escJson(a.getNom())).append("\"")
                  .append(",\"tarif\":").append(String.format("%.2f", a.getTarifBase()))
                  .append("}");
            }
            sb.append("]}");
            out.print(sb);

        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"error\":\"" + escJson(e.getMessage()) + "\"}");
        }
    }

    // ── POST ──────────────────────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (req.getSession().getAttribute("user") == null) { resp.setStatus(401); return; }

        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        try {
            String rdvIdStr  = req.getParameter("rdvId");
            String modeRegl  = req.getParameter("modeReglement");

            if (rdvIdStr == null || modeRegl == null || rdvIdStr.trim().isEmpty() || modeRegl.trim().isEmpty()) {
                out.print("{\"success\":false,\"message\":\"Param\u00e8tres manquants.\"}");
                return;
            }

            // Validate modeReglement
            String mode = modeRegl.trim();
            if (!"ESPECES".equals(mode) && !"CHEQUE".equals(mode) && !"CARTE_BANCAIRE".equals(mode)) {
                out.print("{\"success\":false,\"message\":\"Mode de r\u00e8glement invalide.\"}");
                return;
            }

            int rdvId = Integer.parseInt(rdvIdStr.trim());

            RendezVous rdv = rdvDAO.getByIdWithPatient(rdvId);
            if (rdv == null) { out.print("{\"success\":false,\"message\":\"RDV introuvable.\"}"); return; }

            Consultation consultation = consultationDAO.getConsultationParRdv(rdvId);
            if (consultation == null) { out.print("{\"success\":false,\"message\":\"Consultation introuvable. Le dentiste doit d'abord ouvrir la consultation.\"}"); return; }

            // Check no facture already exists for this consultation
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement check = conn.prepareStatement(
                     "SELECT id FROM facture WHERE consultationId = ?")) {
                check.setInt(1, consultation.getId());
                try (ResultSet rs = check.executeQuery()) {
                    if (rs.next()) {
                        out.print("{\"success\":false,\"message\":\"Une facture existe d\u00e9j\u00e0 pour ce rendez-vous.\"}");
                        return;
                    }
                }
            }

            // Build facture object — FactureDAO will calculate the total via MySQL function
            Facture facture = new Facture();
            facture.setConsultationId(consultation.getId());
            facture.setDateFacturation(LocalDate.now());
            facture.setCheminPdf("/uploads/factures/fac_rdv_" + rdvId + ".pdf"); // logical path

            Paiement paiement = new Paiement();
            paiement.setModeReglement(mode);

            boolean saved = factureDAO.genererFactureEtPayer(facture, paiement);
            if (!saved) {
                out.print("{\"success\":false,\"message\":\"Erreur lors de l'enregistrement de la facture.\"}");
                return;
            }

            // Fetch saved facture id
            int factureId = -1;
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(
                     "SELECT id, montantTotal FROM facture WHERE consultationId = ?")) {
                stmt.setInt(1, consultation.getId());
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        factureId = rs.getInt("id");
                        facture.setMontantTotal(rs.getDouble("montantTotal"));
                    }
                }
            }

            // Fetch actes for PDF
            List<Acte> actes = consultationDAO.getActesForConsultation(consultation.getId());
            Patient     patient  = patientDAO.getById(rdv.getPatientId());
            Utilisateur dentiste = utilisateurDAO.findById(rdv.getDentisteId());

            // Build response
            StringBuilder sb = new StringBuilder("{\"success\":true");
            sb.append(",\"factureId\":").append(factureId);
            sb.append(",\"total\":").append(String.format("%.2f", facture.getMontantTotal()));
            sb.append(",\"dentiste\":\"").append(escJson(dentiste != null ? dentiste.getLogin() : "")).append("\"");
            sb.append(",\"patientNom\":\"").append(escJson(patient != null ? patient.getNom() : "")).append("\"");
            sb.append(",\"patientPrenom\":\"").append(escJson(patient != null ? patient.getPrenom() : "")).append("\"");
            sb.append(",\"patientTel\":\"").append(escJson(patient != null ? patient.getTelephone() : "")).append("\"");
            sb.append(",\"actes\":[");
            for (int i = 0; i < actes.size(); i++) {
                if (i > 0) sb.append(",");
                Acte a = actes.get(i);
                sb.append("{\"code\":\"").append(escJson(a.getCode())).append("\"")
                  .append(",\"nom\":\"").append(escJson(a.getNom())).append("\"")
                  .append(",\"tarif\":").append(String.format("%.2f", a.getTarifBase()))
                  .append("}");
            }
            sb.append("]}");
            out.print(sb);

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
