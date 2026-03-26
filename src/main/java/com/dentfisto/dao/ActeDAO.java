package com.dentfisto.dao;

import com.dentfisto.model.Acte;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ActeDAO {

    // --- CONSTANTES SQL ---
    private static final String SQL_GET_ALL = "SELECT * FROM acte";
    private static final String SQL_INSERT_ACTE = "INSERT INTO acte (code, nom, tarifBase) VALUES (?, ?, ?)";

    /**
     * Récupère tout le catalogue des actes médicaux.
     */
    public List<Acte> getAllActes() {
        List<Acte> catalogue = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_GET_ALL);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Acte acte = new Acte();
                acte.setId(rs.getInt("id"));
                acte.setCode(rs.getString("code"));
                acte.setNom(rs.getString("nom"));
                acte.setTarifBase(rs.getDouble("tarifBase"));
                catalogue.add(acte);
            }
        } catch (SQLException e) {
            System.err.println("Erreur lors de la récupération des actes : " + e.getMessage());
        }
        return catalogue;
    }

    /**
     * Permet à l'administrateur d'ajouter un nouvel acte au catalogue.
     */
    public boolean ajouterActe(Acte acte) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_INSERT_ACTE)) {

            stmt.setString(1, acte.getCode());
            stmt.setString(2, acte.getNom());
            stmt.setDouble(3, acte.getTarifBase());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Erreur lors de l'ajout de l'acte : " + e.getMessage());
            return false;
        }
    }
}