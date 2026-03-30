package com.dentfisto.model;

import java.time.LocalDate;
import java.time.LocalTime;

public class RendezVous {
    private int id;
    private LocalDate dateRdv;
    private LocalTime heureDebut;
    private LocalTime heureFin;
    private String motif;
    private String notesInternes;
    private String statut; 
    private int patientId;
    private int dentisteId;

    // Transient fields populated by JOIN queries
    private String patientNom;
    private String patientPrenom;
    private String patientTel;

    public RendezVous() {}

    // Getters et Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public LocalDate getDateRdv() { return dateRdv; }
    public void setDateRdv(LocalDate dateRdv) { this.dateRdv = dateRdv; }

    public LocalTime getHeureDebut() { return heureDebut; }
    public void setHeureDebut(LocalTime heureDebut) { this.heureDebut = heureDebut; }

    public LocalTime getHeureFin() { return heureFin; }
    public void setHeureFin(LocalTime heureFin) { this.heureFin = heureFin; }

    public String getMotif() { return motif; }
    public void setMotif(String motif) { this.motif = motif; }

    public String getNotesInternes() { return notesInternes; }
    public void setNotesInternes(String notesInternes) { this.notesInternes = notesInternes; }

    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }

    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }

    public int getDentisteId() { return dentisteId; }
    public void setDentisteId(int dentisteId) { this.dentisteId = dentisteId; }

    // Transient patient fields
    public String getPatientNom() { return patientNom; }
    public void setPatientNom(String patientNom) { this.patientNom = patientNom; }

    public String getPatientPrenom() { return patientPrenom; }
    public void setPatientPrenom(String patientPrenom) { this.patientPrenom = patientPrenom; }

    public String getPatientTel() { return patientTel; }
    public void setPatientTel(String patientTel) { this.patientTel = patientTel; }

    /** Helper: full patient display name */
    public String getPatientFullName() {
        if (patientNom != null && patientPrenom != null) return patientNom + " " + patientPrenom;
        if (patientNom != null) return patientNom;
        return "";
    }
}