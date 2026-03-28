
// ───────────────────────────────────────────────────────────────────────
// FILE 5: ConsultationSaveServlet.java
// URL:    POST /dentist/consultation/save
// Body:   JSON { rvId, patientId, diagnostic, observations, note, acts[], documents[] }
// ───────────────────────────────────────────────────────────────────────
package com.dentfisto.servlet;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;

@WebServlet("/dentist/consultation/save")
public class consultationSaveServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        req.setCharacterEncoding("UTF-8");
        String body = readBody(req);
        System.out.println("[CONSULTATION SAVE] " + body);

        // TODO: parse JSON with Gson/Jackson, then:
        //
        // 1. INSERT INTO consultation (rv_id, patient_id, dentiste_id, diagnostic,
        // observations, note, date_creation)
        // VALUES (?,?,?,?,?,?,NOW())
        //
        // 2. For each act:
        // INSERT INTO acte_consultation (consultation_id, libelle) VALUES (?,?)
        //
        // 3. For each document:
        // INSERT INTO document_medical (consultation_id, patient_id, nom_fichier,
        // type_document, chemin_fichier, date_import)
        // VALUES (?,?,?,?,?,NOW())
        //
        // 4. UPDATE rendez_vous SET statut='termine' WHERE id=?

        resp.getWriter().write("{\"success\":true,\"consultationId\":42}");
    }

    private String readBody(HttpServletRequest req) throws IOException {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader r = req.getReader()) {
            String line;
            while ((line = r.readLine()) != null)
                sb.append(line);
        }
        return sb.toString();
    }
}
