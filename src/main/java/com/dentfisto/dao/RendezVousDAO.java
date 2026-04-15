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

    private static final String SQL_INSERT_RDV = 
        "INSERT INTO rendezVous (dateRdv, heureDebut, heureFin, motif, notesInternes, statut, patientId, dentisteId) " +
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
    private static final String SQL_UPDATE_STATUT = 
        "UPDATE rendezVous SET statut = ? WHERE id = ?";
        
    private static final String SQL_PLANNING_DENTISTE = 
        "SELECT * FROM rendezVous WHERE dentisteId = ? AND dateRdv = ? ORDER BY heureDebut ASC";

    private static final String SQL_TODAY_ORDERED =
        "SELECT r.*, p.nom AS pNom, p.prenom AS pPrenom, p.telephone AS pTel " +
        "FROM rendezVous r JOIN patient p ON r.patientId = p.id " +
        "WHERE r.dentisteId = ? AND r.dateRdv = ? " +
        "ORDER BY FIELD(r.statut, 'EN_SALLE_D_ATTENTE','EN_COURS','PLANIFIE','TERMINE','ANNULE','NON_HONORE'), r.heureDebut ASC";

    private static final String SQL_TODAY_ALL =
        "SELECT r.*, p.nom AS pNom, p.prenom AS pPrenom, p.telephone AS pTel " +
        "FROM rendezVous r JOIN patient p ON r.patientId = p.id " +
        "WHERE r.dateRdv = ? " +
        "ORDER BY FIELD(r.statut, 'EN_SALLE_D_ATTENTE','EN_COURS','PLANIFIE','TERMINE','ANNULE','NON_HONORE'), r.heureDebut ASC";

    private static final String SQL_WEEK_ORDERED =
        "SELECT r.*, p.nom AS pNom, p.prenom AS pPrenom, p.telephone AS pTel " +
        "FROM rendezVous r JOIN patient p ON r.patientId = p.id " +
        "WHERE r.dentisteId = ? AND r.dateRdv >= ? AND r.dateRdv <= ? " +
        "ORDER BY r.dateRdv ASC, r.heureDebut ASC";

    private static final String SQL_WEEK_ALL =
        "SELECT r.*, p.nom AS pNom, p.prenom AS pPrenom, p.telephone AS pTel " +
        "FROM rendezVous r JOIN patient p ON r.patientId = p.id " +
        "WHERE r.dateRdv >= ? AND r.dateRdv <= ? " +
        "ORDER BY r.dateRdv ASC, r.heureDebut ASC";

    private static final String SQL_GET_BY_ID =
        "SELECT r.*, p.nom AS pNom, p.prenom AS pPrenom, p.telephone AS pTel " +
        "FROM rendezVous r JOIN patient p ON r.patientId = p.id WHERE r.id = ?";



    private static final String SQL_UPDATE_RDV =
        "UPDATE rendezVous SET dateRdv=?, heureDebut=?, heureFin=?, motif=?, notesInternes=?, statut=? WHERE id=?";

    private static final String SQL_UPDATE_RDV_FULL =
        "UPDATE rendezVous SET dateRdv=?, heureDebut=?, heureFin=?, motif=?, notesInternes=?, statut=?, dentisteId=? WHERE id=?";

    /**
     * Ajoute un nouveau rendez-vous.
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
                    planning.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur lors de la récupération du planning : " + e.getMessage());
        }
        return planning;
    }

    /**
     * Today's RDVs for a dentist, ordered by status priority (waiting first).
     */
    public List<RendezVous> getTodayByDentistOrdered(int dentisteId) {
        List<RendezVous> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_TODAY_ORDERED)) {

            stmt.setInt(1, dentisteId);
            stmt.setDate(2, Date.valueOf(LocalDate.now()));
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    RendezVous rdv = mapRow(rs);
                    rdv.setPatientNom(rs.getString("pNom"));
                    rdv.setPatientPrenom(rs.getString("pPrenom"));
                    rdv.setPatientTel(rs.getString("pTel"));
                    list.add(rdv);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur getTodayByDentistOrdered : " + e.getMessage());
        }
        return list;
    }

    /**
     * Today's RDVs for all dentists (used by assistant), ordered by status priority.
     */
    public List<RendezVous> getTodayAllOrdered() {
        List<RendezVous> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_TODAY_ALL)) {

            stmt.setDate(1, Date.valueOf(LocalDate.now()));
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    RendezVous rdv = mapRow(rs);
                    rdv.setPatientNom(rs.getString("pNom"));
                    rdv.setPatientPrenom(rs.getString("pPrenom"));
                    rdv.setPatientTel(rs.getString("pTel"));
                    list.add(rdv);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur getTodayAllOrdered : " + e.getMessage());
        }
        return list;
    }

    /**
     * Week's RDVs for a specific dentist.
     */
    public List<RendezVous> getWeekByDentistOrdered(int dentisteId) {
        List<RendezVous> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_WEEK_ORDERED)) {

            stmt.setInt(1, dentisteId);
            LocalDate today = LocalDate.now();
            int dayOfWeek = today.getDayOfWeek().getValue(); // 1=Monday...
            LocalDate startOfWeek = today.minusDays(dayOfWeek - 1);
            LocalDate endOfWeek = startOfWeek.plusDays(6);
            
            stmt.setDate(2, Date.valueOf(startOfWeek));
            stmt.setDate(3, Date.valueOf(endOfWeek));
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    RendezVous rdv = mapRow(rs);
                    rdv.setPatientNom(rs.getString("pNom"));
                    rdv.setPatientPrenom(rs.getString("pPrenom"));
                    rdv.setPatientTel(rs.getString("pTel"));
                    list.add(rdv);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur getWeekByDentistOrdered : " + e.getMessage());
        }
        return list;
    }

    /**
     * Week's RDVs for all dentists (assistant).
     */
    public List<RendezVous> getWeekAllOrdered() {
        List<RendezVous> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_WEEK_ALL)) {

            LocalDate today = LocalDate.now();
            int dayOfWeek = today.getDayOfWeek().getValue();
            LocalDate startOfWeek = today.minusDays(dayOfWeek - 1);
            LocalDate endOfWeek = startOfWeek.plusDays(6);
            
            stmt.setDate(1, Date.valueOf(startOfWeek));
            stmt.setDate(2, Date.valueOf(endOfWeek));
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    RendezVous rdv = mapRow(rs);
                    rdv.setPatientNom(rs.getString("pNom"));
                    rdv.setPatientPrenom(rs.getString("pPrenom"));
                    rdv.setPatientTel(rs.getString("pTel"));
                    list.add(rdv);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur getWeekAllOrdered : " + e.getMessage());
        }
        return list;
    }

    /**
     * Rolling 7 days (today + 6 days) for all dentists (assistant rolling calendar).
     */
    public List<RendezVous> getRolling7DaysAllOrdered() {
        List<RendezVous> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_WEEK_ALL)) {

            LocalDate today = LocalDate.now();
            LocalDate endDate = today.plusDays(6);

            stmt.setDate(1, Date.valueOf(today));
            stmt.setDate(2, Date.valueOf(endDate));
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    RendezVous rdv = mapRow(rs);
                    rdv.setPatientNom(rs.getString("pNom"));
                    rdv.setPatientPrenom(rs.getString("pPrenom"));
                    rdv.setPatientTel(rs.getString("pTel"));
                    list.add(rdv);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur getRolling7DaysAllOrdered : " + e.getMessage());
        }
        return list;
    }

    /**
     * Fetch a single RDV by ID with patient info.
     */
    public RendezVous getByIdWithPatient(int id) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_GET_BY_ID)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    RendezVous rdv = mapRow(rs);
                    rdv.setPatientNom(rs.getString("pNom"));
                    rdv.setPatientPrenom(rs.getString("pPrenom"));
                    rdv.setPatientTel(rs.getString("pTel"));
                    return rdv;
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur getByIdWithPatient : " + e.getMessage());
        }
        return null;
    }

    /**
     * Search RDVs by patient name or phone.
     */
    public List<RendezVous> searchByPatientNameAndPhone(String nom, String tel) {
        List<RendezVous> list = new ArrayList<>();
        String sql = "SELECT r.*, p.nom AS pNom, p.prenom AS pPrenom, p.telephone AS pTel " +
                     "FROM rendezVous r JOIN patient p ON r.patientId = p.id " +
                     "WHERE (p.nom LIKE ? OR p.prenom LIKE ?) AND p.telephone LIKE ? " +
                     "ORDER BY r.dateRdv DESC, r.heureDebut ASC LIMIT 50";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            String likeNom = "%" + nom + "%";
            String likeTel = "%" + tel + "%";

            stmt.setString(1, likeNom);
            stmt.setString(2, likeNom);
            stmt.setString(3, likeTel);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    RendezVous rdv = mapRow(rs);
                    rdv.setPatientNom(rs.getString("pNom"));
                    rdv.setPatientPrenom(rs.getString("pPrenom"));
                    rdv.setPatientTel(rs.getString("pTel"));
                    list.add(rdv);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur searchByPatientNameAndPhone : " + e.getMessage());
        }
        return list;
    }

    /**
     * Update RDV details (date, time, motif).
     */
    public boolean updateRendezVous(RendezVous rdv) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_UPDATE_RDV)) {

            stmt.setDate(1, Date.valueOf(rdv.getDateRdv()));
            stmt.setTime(2, Time.valueOf(rdv.getHeureDebut()));
            stmt.setTime(3, Time.valueOf(rdv.getHeureFin()));
            stmt.setString(4, rdv.getMotif());
            stmt.setString(5, rdv.getNotesInternes());
            stmt.setString(6, rdv.getStatut());
            stmt.setInt(7, rdv.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Erreur updateRendezVous : " + e.getMessage());
            return false;
        }
    }

    /**
     * Update RDV details including dentisteId (for assistant full edit).
     */
    public boolean updateRendezVousFull(RendezVous rdv) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_UPDATE_RDV_FULL)) {

            stmt.setDate(1, Date.valueOf(rdv.getDateRdv()));
            stmt.setTime(2, Time.valueOf(rdv.getHeureDebut()));
            stmt.setTime(3, Time.valueOf(rdv.getHeureFin()));
            stmt.setString(4, rdv.getMotif());
            stmt.setString(5, rdv.getNotesInternes());
            stmt.setString(6, rdv.getStatut());
            stmt.setInt(7, rdv.getDentisteId());
            stmt.setInt(8, rdv.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Erreur updateRendezVousFull : " + e.getMessage());
            return false;
        }
    }

    private RendezVous mapRow(ResultSet rs) throws SQLException {
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
        return rdv;
    }
}