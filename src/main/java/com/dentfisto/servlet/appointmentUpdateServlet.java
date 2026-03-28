

// ───────────────────────────────────────────────────────────────────────
// FILE 4: AppointmentUpdateServlet.java
// URL:    POST /dentist/appointments/update
// Body:   JSON { id, date, time, type }
// ───────────────────────────────────────────────────────────────────────
package com.dentfisto.servlet.dentist;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;

@WebServlet("/dentist/appointments/update")
public class AppointmentUpdateServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        req.setCharacterEncoding("UTF-8");
        String body = readBody(req);
        System.out.println("[RV UPDATE] " + body);

        // TODO: parse JSON with Gson/Jackson, then:
        // UPDATE rendez_vous SET date_rv=?, heure=?, type=? WHERE id=?

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

