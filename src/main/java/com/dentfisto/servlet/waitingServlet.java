// ═══════════════════════════════════════════════════════════════════════
//  DentFisto – Dentist Servlets
//  Package: com.dentfisto.servlet.dentist
//  Each class goes in its own .java file. All shown here for reference.
//
//  Maven dependency for OpenPDF:
//  <dependency>
//    <groupId>com.github.librepdf</groupId>
//    <artifactId>openpdf</artifactId>
//    <version>1.3.30</version>
//  </dependency>
// ═══════════════════════════════════════════════════════════════════════

// ───────────────────────────────────────────────────────────────────────
// FILE 1: WaitingServlet.java
// URL:    GET /dentist/waiting
// ───────────────────────────────────────────────────────────────────────
package com.dentfisto.servlet;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/dentist/waiting")
public class waitingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        resp.setHeader("Cache-Control", "no-cache");

        // TODO: replace with real DB query
        // int dentisteId = (int) req.getSession().getAttribute("dentisteId");
        // SELECT rv.id, p.prenom, p.nom, rv.heure, rv.type
        // FROM rendez_vous rv
        // JOIN patient p ON rv.patient_id = p.id
        // WHERE rv.statut = 'en_attente'
        // AND DATE(rv.date_rv) = CURDATE()
        // AND rv.dentiste_id = ?
        // LIMIT 1

        // DEMO: simulate a waiting patient
        boolean hasWaiting = true;

        if (hasWaiting) {
            resp.getWriter().write(
                    "{\"hasWaiting\":true," +
                            "\"rvId\":1," +
                            "\"patientId\":101," +
                            "\"patientName\":\"Khalid Amrani\"," +
                            "\"type\":\"D\\u00e9tartrage\"," +
                            "\"time\":\"09:00\"}");
        } else {
            resp.getWriter().write("{\"hasWaiting\":false}");
        }
    }
}
