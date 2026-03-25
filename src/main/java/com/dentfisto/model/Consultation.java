package com.dentfisto.model;

public class Consultation {
    private int id;
    private String diagnostic;
    private String observations;
    private int rdvId;
    private int dossierId;

    public Consultation() {}

    // Getters et Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getDiagnostic() { return diagnostic; }
    public void setDiagnostic(String diagnostic) { this.diagnostic = diagnostic; }

    public String getObservations() { return observations; }
    public void setObservations(String observations) { this.observations = observations; }

    public int getRdvId() { return rdvId; }
    public void setRdvId(int rdvId) { this.rdvId = rdvId; }

    public int getDossierId() { return dossierId; }
    public void setDossierId(int dossierId) { this.dossierId = dossierId; }
}