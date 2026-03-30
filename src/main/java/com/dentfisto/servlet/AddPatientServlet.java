package com.dentfisto.servlet;


import com.dentfisto.dao.DBConnection;
import com.dentfisto.model.Patient;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.time.LocalDate;

@WebServlet("/assistant/ajouter-patient")
public class AddPatientServlet extends HttpServlet {



    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        // Retrieve and build patient
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
        
        // By default, assume no responsible adult, unless it's a minor (which the trigger handles)
        // But for this simple implementation we just try to insert and generate a Dossier.
        
        boolean success = false;
        
        // We will do custom insert block to retrieve generated id
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                "INSERT INTO patient (nom, prenom, dateNaissance, sexe, adresse, telephone, cnssMutuelle) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)", Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, patient.getNom());
            stmt.setString(2, patient.getPrenom());
            stmt.setDate(3, java.sql.Date.valueOf(patient.getDateNaissance()));
            stmt.setString(4, patient.getSexe());
            stmt.setString(5, patient.getAdresse());
            stmt.setString(6, patient.getTelephone());
            stmt.setString(7, patient.getCnssMutuelle());

            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int newId = generatedKeys.getInt(1);
                        // Now automatically create a Dossier Medical
                        String dossierRef = "DM-" + java.time.Year.now().getValue() + "-" + String.format("%04d", newId);
                        try (PreparedStatement stmtDossier = conn.prepareStatement(
                            "INSERT INTO dossierMedical (numeroReference, dateCreation, patientId) VALUES (?, CURDATE(), ?)")) {
                            stmtDossier.setString(1, dossierRef);
                            stmtDossier.setInt(2, newId);
                            stmtDossier.executeUpdate();
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
            // in a real app, redirect with error
            resp.sendRedirect(req.getContextPath() + "/assistant/?error=addpatient");
        }
    }
}
