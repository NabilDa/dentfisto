package com.dentfisto.model;

import java.util.ArrayList;
import java.util.List;

public class Consultation {
    private int id;
    private String diagnostic;
    private String observations;
    private int rdvId;
    private int dossierId;

    private List<Acte> actesRealises;
    private Ordonnance ordonnance;
    private Facture facture;

    public Consultation() {
        this.actesRealises = new ArrayList<>();
    }

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

    public Ordonnance getOrdonnance() { return ordonnance; }
    public void setOrdonnance(Ordonnance ordonnance) { this.ordonnance = ordonnance; }

    public Facture getFacture() { return facture; }
    public void setFacture(Facture facture) { this.facture = facture; }

    public List<Acte> getActesRealises() { 
        return actesRealises; 
    }
    
    public void addActe(Acte acte) {
        this.actesRealises.add(acte);
    }
}
