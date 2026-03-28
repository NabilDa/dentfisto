
// ───────────────────────────────────────────────────────────────────────
// FILE 8: DossierSearchServlet.java
// URL:    GET /dentist/dossier/search?q=<name_or_phone>
// ───────────────────────────────────────────────────────────────────────
package com.dentfisto.servlet;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/dentist/dossier/search")
public class dossierSearchServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        String q = req.getParameter("q");

        if (q == null || q.isBlank()) {
            resp.setStatus(400);
            resp.getWriter().write("{\"error\":\"query required\"}");
            return;
        }

        // TODO: Full dossier query:
        //
        // Step 1 – find patient
        // SELECT * FROM patient WHERE (nom LIKE ? OR telephone LIKE ?) AND
        // dentiste_id=? LIMIT 1
        //
        // Step 2 – get consultations
        // SELECT c.id, c.date_creation, rv.type, c.diagnostic, c.observations, c.note
        // FROM consultation c JOIN rendez_vous rv ON rv.id = c.rv_id
        // WHERE c.patient_id = ? ORDER BY c.date_creation DESC
        //
        // Step 3 – get actes per consultation
        // SELECT consultation_id, libelle FROM acte_consultation WHERE consultation_id
        // IN (...)
        //
        // Step 4 – get documents per consultation
        // SELECT consultation_id, nom_fichier, type_document, date_import
        // FROM document_medical WHERE patient_id = ?
        //
        // Assemble into JSON.

        resp.getWriter().write(
                "{\"id\":1,\"firstName\":\"Khalid\",\"lastName\":\"Amrani\"," +
                        "\"age\":34,\"phone\":\"06 61 23 45 67\",\"dob\":\"15/03/1991\"," +
                        "\"blood\":\"A+\",\"allergies\":\"P\\u00e9nicilline\"," +
                        "\"address\":\"12 Rue des Roses, Casablanca\",\"lastVisit\":\"20/05/2025\"," +
                        "\"consultations\":[" +
                        "{\"date\":\"20/05/2025\",\"type\":\"Contr\\u00f4le\"," +
                        "\"diagnostic\":\"Carie l\\u00e9g\\u00e8re dent 36\"," +
                        "\"acts\":[\"Obturation composite\"]," +
                        "\"note\":\"Hygi\\u00e8ne bucco-dentaire satisfaisante.\"," +
                        "\"docs\":[{\"name\":\"Photo_dent36.jpg\",\"type\":\"Image\",\"importDate\":\"20/05/2025\"}]},"
                        +
                        "{\"date\":\"10/01/2025\",\"type\":\"D\\u00e9tartrage\"," +
                        "\"diagnostic\":\"Tartre mod\\u00e9r\\u00e9 g\\u00e9n\\u00e9ralis\\u00e9\"," +
                        "\"acts\":[\"D\\u00e9tartrage ultrason\",\"Polissage\"]," +
                        "\"note\":\"Conseils hygi\\u00e8ne donn\\u00e9s.\"," +
                        "\"docs\":[{\"name\":\"Radio_panoramique.pdf\",\"type\":\"PDF\",\"importDate\":\"10/01/2025\"}]}"
                        +
                        "]," +
                        "\"documents\":[" +
                        "{\"name\":\"Radio_panoramique.pdf\",\"type\":\"PDF\",\"importDate\":\"10/01/2025\"}," +
                        "{\"name\":\"Consentement_eclaire.pdf\",\"type\":\"PDF\",\"importDate\":\"15/03/2025\"}" +
                        "]}");
    }
}
