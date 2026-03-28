

// ───────────────────────────────────────────────────────────────────────
// FILE 7: PatientUpdateServlet.java
// URL:    POST /dentist/patients/update
// Body:   JSON { id, firstName, lastName, phone, dob, blood, allergies, address }
// ───────────────────────────────────────────────────────────────────────
package com.dentfisto.servlet.dentist;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;

@WebServlet("/dentist/patients/update")
public class PatientUpdateServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        req.setCharacterEncoding("UTF-8");
        String body = readBody(req);
        System.out.println("[PATIENT UPDATE] " + body);

        // TODO: parse and validate all fields server-side, then:
        // UPDATE patient
        // SET prenom=?, nom=?, telephone=?, date_naissance=?,
        //     groupe_sanguin=?, allergies=?, adresse=?
        // WHERE id=? AND dentiste_id=?   ← security: always filter by session dentiste

        resp.getWriter().write("{\"success\":true}");
    }

    private String readBody(HttpServletRequest req) throws IOException {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader r = req.getReader()) {
            String line;
            while ((line = r.readLine()) != null) sb.append(line);
        }
        return sb.toString();
    }
}


            sigCell.setPaddingTop(8);
            sigCell.setHorizontalAlignment(Element.ALIGN_CENTER);
            sigCell.addElement(new Paragraph("Signature & Cachet du Praticien", smallFont));
            sigTable.addCell(sigCell);

            doc.add(sigTable);

            // ── Footer ──
            doc.add(new Paragraph("\n"));
            Paragraph footer = new Paragraph(
                "Document généré par DentFisto – " + LocalDate.now().format(FR_DATE), smallFont);
            footer.setAlignment(Element.ALIGN_CENTER);
            doc.add(footer);

            doc.close();

            // TODO: also save ordonnance to DB:
            // INSERT INTO ordonnance (rv_id, patient_id, dentiste_id, medicaments_json,
            //                        chemin_pdf, date_generation)
            // VALUES (?, ?, ?, ?, ?, NOW())

        } catch (DocumentException ex) {
            throw new IOException("PDF generation failed: " + ex.getMessage(), ex);
        }
    }

    // ── Minimal JSON helpers (replace with Gson in production) ──

    private String extractJson(String json, String key) {
        String search = "\"" + key + "\":\"";
        int start = json.indexOf(search);
        if (start < 0) return null;
        start += search.length();
        int end = json.indexOf("\"", start);
        return end > start ? json.substring(start, end) : null;
    }

    private List<String> extractJsonArray(String json, String key) {
        List<String> result = new ArrayList<>();
        String search = "\"" + key + "\":[";
        int start = json.indexOf(search);
        if (start < 0) return result;
        start += search.length();
        int end = json.indexOf("]", start);
        if (end < 0) return result;
        String arr = json.substring(start, end);
        for (String item : arr.split(",")) {
            String clean = item.trim().replaceAll("^\"|\"$", "");
            if (!clean.isBlank()) result.add(clean);
        }
        return result;
    }

    private String readBody(HttpServletRequest req) throws IOException {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader r = req.getReader()) {
            String line;
            while ((line = r.readLine()) != null) sb.append(line);
        }
        return sb.toString();
    }
}