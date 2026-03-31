package com.dentfisto.servlet;

import com.dentfisto.dao.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.time.LocalDate;

/**
 * Receives a JSON array of patient objects and bulk-inserts them.
 * POST /assistant/importer-patients
 * Body: data=[{"nom":"...","prenom":"...","telephone":"...","dateNaissance":"...","sexe":"...","adresse":"..."},...]
 * Returns: {"success":true,"imported":N,"skipped":M}
 */
@WebServlet("/assistant/importer-patients")
public class ImporterPatientsServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (req.getSession().getAttribute("user") == null) {
            resp.setStatus(401); return;
        }

        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        String rawData = req.getParameter("data");
        if (rawData == null || rawData.trim().isEmpty()) {
            out.print("{\"success\":false,\"message\":\"Aucune donnée reçue.\"}");
            return;
        }

        // Simple JSON array parser (no Gson needed)
        // Expected: [{"nom":"x","prenom":"y","telephone":"z","dateNaissance":"d","sexe":"s","adresse":"a"},...]
        int imported = 0, skipped = 0;

        // Strip outer brackets
        String inner = rawData.trim();
        if (inner.startsWith("[")) inner = inner.substring(1);
        if (inner.endsWith("]")) inner = inner.substring(0, inner.length()-1);

        // Split by object boundaries
        String[] objects = inner.split("\\},\\s*\\{");

        String sql = "INSERT IGNORE INTO patient (nom, prenom, telephone, dateNaissance, sexe, adresse) VALUES (?,?,?,?,?,?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            for (String obj : objects) {
                try {
                    obj = obj.replace("{","").replace("}","");
                    String nom          = extractJson(obj, "nom");
                    String prenom       = extractJson(obj, "prenom");
                    String telephone    = extractJson(obj, "telephone");
                    String dateStr      = extractJson(obj, "dateNaissance");
                    String sexe         = extractJson(obj, "sexe");
                    String adresse      = extractJson(obj, "adresse");

                    if (nom.isEmpty() || prenom.isEmpty() || telephone.isEmpty()) { skipped++; continue; }

                    LocalDate dob;
                    try { dob = LocalDate.parse(dateStr.isEmpty() ? "1900-01-01" : dateStr); }
                    catch (Exception e) { dob = LocalDate.of(1900,1,1); }

                    if (sexe.isEmpty()) sexe = "H";
                    if (adresse.isEmpty()) adresse = "—";

                    stmt.setString(1, nom);
                    stmt.setString(2, prenom);
                    stmt.setString(3, telephone);
                    stmt.setDate(4, Date.valueOf(dob));
                    stmt.setString(5, sexe);
                    stmt.setString(6, adresse);

                    int rows = stmt.executeUpdate();
                    if (rows > 0) {
                        // Auto-create dossier
                        try (ResultSet keys = stmt.getGeneratedKeys()) {
                            if (keys.next()) {
                                int newId = keys.getInt(1);
                                String ref = "DM-" + java.time.Year.now().getValue() + "-" + String.format("%04d", newId);
                                try (PreparedStatement sd = conn.prepareStatement(
                                    "INSERT IGNORE INTO dossierMedical (numeroReference, dateCreation, patientId) VALUES (?,CURDATE(),?)")) {
                                    sd.setString(1, ref); sd.setInt(2, newId); sd.executeUpdate();
                                }
                            }
                        }
                        imported++;
                    } else {
                        skipped++; // IGNORE hit a duplicate
                    }
                } catch (Exception e) {
                    skipped++;
                    System.err.println("Import row error: " + e.getMessage());
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.print("{\"success\":false,\"message\":\"Erreur base de données : " + e.getMessage().replace("\"","'") + "\"}");
            return;
        }

        out.print("{\"success\":true,\"imported\":" + imported + ",\"skipped\":" + skipped + "}");
    }

    /** Extract a string value from a flat JSON object string. */
    private static String extractJson(String obj, String key) {
        String search = "\"" + key + "\"";
        int idx = obj.indexOf(search);
        if (idx < 0) return "";
        int colon = obj.indexOf(":", idx + search.length());
        if (colon < 0) return "";
        String rest = obj.substring(colon+1).trim();
        if (rest.startsWith("\"")) {
            int end = rest.indexOf("\"", 1);
            return end > 0 ? rest.substring(1, end) : "";
        }
        // number/boolean
        int end = rest.indexOf(",");
        return end > 0 ? rest.substring(0, end).trim() : rest.trim();
    }
}
