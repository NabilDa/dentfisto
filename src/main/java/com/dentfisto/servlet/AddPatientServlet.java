package com.dentfisto.servlet;

import com.dentfisto.dao.DBConnection;
import com.dentfisto.model.Patient;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.*;
import java.time.LocalDate;

@WebServlet("/assistant/ajouter-patient")
public class AddPatientServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Patient patient = new Patient();
        patient.setNom(req.getParameter("nom"));
        patient.setPrenom(req.getParameter("prenom"));
        patient.setTelephone(req.getParameter("telephone"));

        String dateStr = req.getParameter("dateNaissance");
        if (dateStr != null && !dateStr.isEmpty()) {
            patient.setDateNaissance(LocalDate.parse(dateStr));
        }

        patient.setSexe(req.getParameter("sexe"));
        patient.setAdresse(req.getParameter("adresse"));
        patient.setCnssMutuelle(req.getParameter("cnssMutuelle"));

        // Responsable légal (for minors)
        String responsableNom = req.getParameter("responsableLegalNom");
        String responsableTel = req.getParameter("responsableLegalTel");
        if (responsableNom != null && !responsableNom.trim().isEmpty()) {
            patient.setResponsableLegalNom(responsableNom.trim());
        }
        if (responsableTel != null && !responsableTel.trim().isEmpty()) {
            patient.setResponsableLegalTel(responsableTel.trim());
        }

        boolean success = false;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                "INSERT INTO patient (nom, prenom, dateNaissance, sexe, adresse, telephone, cnssMutuelle, responsableLegalNom, responsableLegalTel) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, patient.getNom());
            stmt.setString(2, patient.getPrenom());
            stmt.setDate(3, Date.valueOf(patient.getDateNaissance()));
            stmt.setString(4, patient.getSexe());
            stmt.setString(5, patient.getAdresse());
            stmt.setString(6, patient.getTelephone());
            stmt.setString(7, patient.getCnssMutuelle());
            stmt.setString(8, patient.getResponsableLegalNom());
            stmt.setString(9, patient.getResponsableLegalTel());

            int rows = stmt.executeUpdate();
            if (rows > 0) {
                try (ResultSet keys = stmt.getGeneratedKeys()) {
                    if (keys.next()) {
                        int newId = keys.getInt(1);
                        String dossierRef = "DM-" + java.time.Year.now().getValue() + "-" + String.format("%04d", newId);
                        try (PreparedStatement stmtD = conn.prepareStatement(
                            "INSERT INTO dossierMedical (numeroReference, dateCreation, patientId) VALUES (?, CURDATE(), ?)")) {
                            stmtD.setString(1, dossierRef);
                            stmtD.setInt(2, newId);
                            stmtD.executeUpdate();
                        }
                        success = true;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (success) {
            resp.sendRedirect(req.getContextPath() + "/assistant/");
        } else {
            resp.sendRedirect(req.getContextPath() + "/assistant/?error=addpatient");
        }
    }
}
