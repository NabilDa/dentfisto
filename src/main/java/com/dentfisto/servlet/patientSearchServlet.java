

// ───────────────────────────────────────────────────────────────────────
// FILE 6: PatientSearchServlet.java
// URL:    GET /dentist/patients/search?q=<name_or_phone>
// ───────────────────────────────────────────────────────────────────────
package com.dentfisto.servlet.dentist;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/dentist/patients/search")
public class PatientSearchServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        String q = req.getParameter("q");

        if (q == null || q.isBlank()) {
            resp.setStatus(400);
            resp.getWriter().write("[]");
            return;
        }

        // TODO: SELECT id, prenom, nom, telephone, date_naissance, groupe_sanguin,
        //              allergies, adresse,
        //              TIMESTAMPDIFF(YEAR, date_naissance, CURDATE()) AS age
        //       FROM patient
        //       WHERE (nom LIKE ? OR prenom LIKE ? OR telephone LIKE ?)
        //         AND dentiste_id = ?
        //       LIMIT 10

        resp.getWriter().write(
            "[{\"id\":1,\"firstName\":\"Khalid\",\"lastName\":\"Amrani\"," +
            "\"phone\":\"06 61 23 45 67\",\"age\":34,\"blood\":\"A+\"," +
            "\"allergies\":\"P\\u00e9nicilline\",\"dob\":\"15/03/1991\"," +
            "\"address\":\"12 Rue des Roses, Casablanca\"}," +
            "{\"id\":2,\"firstName\":\"Fatima\",\"lastName\":\"Benali\"," +
            "\"phone\":\"06 72 34 56 78\",\"age\":27,\"blood\":\"O+\"," +
            "\"allergies\":\"\",\"dob\":\"02/07/1998\"," +
            "\"address\":\"5 Av Hassan II, Rabat\"}]"
        );
    }
}

