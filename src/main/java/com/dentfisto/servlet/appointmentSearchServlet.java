

// ───────────────────────────────────────────────────────────────────────
// FILE 3: AppointmentSearchServlet.java
// URL:    GET /dentist/appointments/search?q=<name_or_phone_or_rvid:N>
// ───────────────────────────────────────────────────────────────────────
package com.dentfisto.servlet.dentist;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/dentist/appointments/search")
public class AppointmentSearchServlet extends HttpServlet {

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

        // Special case: called from consultation page with "rvid:N"
        if (q.startsWith("rvid:")) {
            int rvId = Integer.parseInt(q.substring(5));
            // TODO: SELECT rv.*, p.prenom, p.nom, p.id AS patient_id
            //       FROM rendez_vous rv JOIN patient p ON rv.patient_id=p.id WHERE rv.id=?
            resp.getWriter().write(
                "{\"id\":" + rvId + ",\"patientId\":101," +
                "\"patientName\":\"Khalid Amrani\"," +
                "\"phone\":\"06 61 23 45 67\"," +
                "\"date\":\"28/06/2025\",\"time\":\"09:00\"," +
                "\"type\":\"D\\u00e9tartrage\"," +
                "\"status\":\"en_cours\",\"statusLabel\":\"En cours\"," +
                "\"ordonnanceSkipped\":false}"
            );
            return;
        }

        // TODO: SELECT rv.id, rv.date_rv, rv.heure, rv.type, rv.statut, rv.ordonnance_a_faire,
        //              p.prenom, p.nom, p.telephone
        //       FROM rendez_vous rv JOIN patient p ON rv.patient_id=p.id
        //       WHERE (p.nom LIKE ? OR p.telephone LIKE ?)
        //         AND rv.dentiste_id=?
        //       ORDER BY rv.date_rv DESC LIMIT 1

        resp.getWriter().write(
            "{\"id\":1,\"patientId\":101," +
            "\"patientName\":\"" + q + " (demo)\"," +
            "\"phone\":\"06 61 23 45 67\"," +
            "\"date\":\"28/06/2025\",\"time\":\"09:00\"," +
            "\"type\":\"D\\u00e9tartrage\"," +
            "\"status\":\"confirme\",\"statusLabel\":\"Confirm\\u00e9\"," +
            "\"ordonnanceSkipped\":false}"
        );
    }
}

