
// ───────────────────────────────────────────────────────────────────────
// FILE 2: AppointmentStatusServlet.java
// URL:    POST /dentist/appointments/status
// Body:   application/x-www-form-urlencoded: id=1&status=en_cours[&ordSkipped=true]
// ───────────────────────────────────────────────────────────────────────
package com.dentfisto.servlet;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/dentist/appointments/status")
public class appointmentStatusServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        resp.setContentType("application/json;charset=UTF-8");

        String idStr = req.getParameter("id");
        String status = req.getParameter("status");
        String ordSkipped = req.getParameter("ordSkipped"); // "true" if ordonnance was skipped

        if (idStr == null || idStr.isBlank() || status == null || status.isBlank()) {
            resp.setStatus(400);
            resp.getWriter().write("{\"error\":\"id and status are required\"}");
            return;
        }

        int id = Integer.parseInt(idStr.trim());

        // TODO: validate allowed statuses
        // String[] allowed = {"en_attente","en_cours","termine","annule","confirme"};

        // TODO: DB update
        // String sql = "UPDATE rendez_vous SET statut=?, ordonnance_a_faire=? WHERE
        // id=?";
        // PreparedStatement ps = conn.prepareStatement(sql);
        // ps.setString(1, status);
        // ps.setBoolean(2, "true".equals(ordSkipped));
        // ps.setInt(3, id);
        // ps.executeUpdate();

        System.out.println("[STATUS] RV #" + id + " → " + status
                + ("true".equals(ordSkipped) ? " (ord skipped)" : ""));

        resp.getWriter().write("{\"success\":true,\"id\":" + id
                + ",\"status\":\"" + status + "\"}");
    }
}
