package com.dentfisto.model;

import java.time.LocalDate;

public class Document {
    private int id;
    private String type;
    private LocalDate dateImportation;
    private String cheminAcces;
    private int dossierId;

    public Document() {}

    // Getters et Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public LocalDate getDateImportation() { return dateImportation; }
    public void setDateImportation(LocalDate dateImportation) { this.dateImportation = dateImportation; }

    public String getCheminAcces() { return cheminAcces; }
    public void setCheminAcces(String cheminAcces) { this.cheminAcces = cheminAcces; }

    public int getDossierId() { return dossierId; }
    public void setDossierId(int dossierId) { this.dossierId = dossierId; }
}