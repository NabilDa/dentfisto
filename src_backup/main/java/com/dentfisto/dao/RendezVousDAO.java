package com.dentfisto.dao;

import com.dentfisto.model.RendezVous;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class RendezVousDAO {

    // --- CONSTANTES SQL ---
    private static final String SQL_INSERT_RDV = 
        "INSERT INTO rendezVous (dateRdv, heureDebut, heureFin, motif, notesInternes, statut, patientId, dentisteId) " +
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
    private static final String SQL_UPDATE_STATUT = 
        "UPDATE rendezVous SET statut = ? WHERE id = ?";
        
    private static final String SQL_PLANNING_DENTISTE = 
        "SELECT * FROM rendezVous WHERE dentisteId = ? AND dateRdv = ? ORDER BY heureDebut ASC";

    /**
     * Ajoute un nouveau rendez-vous. 
     * (Les Triggers MySQL bloqueront l'insertion en cas de chevauchement ou d'horaires invalides).
     */
    public boolean ajouterRendezVous(RendezVous rdv) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_INSERT_RDV)) {

            stmt.setDate(1, Date.valueOf(rdv.getDateRdv()));
            stmt.setTime(2, Time.valueOf(rdv.getHeureDebut()));
            stmt.setTime(3, Time.valueOf(rdv.getHeureFin()));
            stmt.setString(4, rdv.getMotif());
            stmt.setString(5, rdv.getNotesInternes());
            stmt.setString(6, rdv.getStatut());
            stmt.setInt(7, rdv.getPatientId());
            stmt.setInt(8, rdv.getDentisteId());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Erreur SQL (horaire invalide ou conflit) : " + e.getMessage());
            return false;
        }
    }

    /**
     * Modifie le statut d'un rendez-vous.
     */
    public boolean modifierStatut(int idRdv, String nouveauStatut) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_UPDATE_STATUT)) {

            stmt.setString(1, nouveauStatut);
            stmt.setInt(2, idRdv);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Erreur lors de la modification du statut : " + e.getMessage());
            return false;
        }
    }

    /**
     * Récupère le planning d'un dentiste pour une journée spécifique.
     */
    public List<RendezVous> getPlanningDentiste(int dentisteId, LocalDate date) {
        List<RendezVous> planning = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_PLANNING_DENTISTE)) {

            stmt.setInt(1, dentisteId);
            stmt.setDate(2, Date.valueOf(date));

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    RendezVous rdv = new RendezVous();
                    rdv.setId(rs.getInt("id"));
                    rdv.setDateRdv(rs.getDate("dateRdv").toLocalDate());
                    rdv.setHeureDebut(rs.getTime("heureDebut").toLocalTime());
                    rdv.setHeureFin(rs.getTime("heureFin").toLocalTime());
                    rdv.setMotif(rs.getString("motif"));
                    rdv.setNotesInternes(rs.getString("notesInternes"));
                    rdv.setStatut(rs.getString("statut"));
                    rdv.setPatientId(rs.getInt("patientId"));
                    rdv.setDentisteId(rs.getInt("dentisteId"));
                    
                    planning.add(rdv);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur lors de la récupération du planning : " + e.getMessage());
        }
        return planning;
    }
}