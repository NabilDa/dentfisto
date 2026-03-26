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
}