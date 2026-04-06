package com.dentfisto.servlet;

import com.dentfisto.util.EmailUtil;
import com.dentfisto.model.Utilisateur;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

/**
 * POST /assistant/send-email
 * 
 * Params:
 *   - email: recipient address
 *   - subject: email subject
 *   - htmlBody: HTML content
 *   - type: "facture" or "confirmation"
 *
 * This servlet is used as a generic email sender for both:
 *   1) Facture PDF (without payment method) after billing
 *   2) RDV confirmation details after creating an appointment
 */
@WebServlet("/assistant/send-email")
public class SendEmailServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Utilisateur user = (Utilisateur) req.getSession().getAttribute("user");
        if (user == null) { resp.setStatus(401); return; }

        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        String email   = req.getParameter("email");
        String subject = req.getParameter("subject");
        String htmlBody = req.getParameter("htmlBody");

        if (email == null || email.trim().isEmpty()) {
            out.print("{\"success\":false,\"message\":\"Adresse email manquante.\"}");
            return;
        }
        if (subject == null || subject.trim().isEmpty()) {
            out.print("{\"success\":false,\"message\":\"Sujet manquant.\"}");
            return;
        }
        if (htmlBody == null || htmlBody.trim().isEmpty()) {
            out.print("{\"success\":false,\"message\":\"Contenu email manquant.\"}");
            return;
        }

        // Basic email format validation
        if (!email.trim().matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$")) {
            out.print("{\"success\":false,\"message\":\"Format d'email invalide.\"}");
            return;
        }

        boolean sent = EmailUtil.sendEmail(email.trim(), subject.trim(), htmlBody);
        if (sent) {
            out.print("{\"success\":true,\"message\":\"Email envoyé avec succès.\"}");
        } else {
            out.print("{\"success\":false,\"message\":\"Échec de l'envoi. Vérifiez l'adresse email.\"}");
        }
    }
}
