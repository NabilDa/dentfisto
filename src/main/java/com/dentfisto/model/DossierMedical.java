package com.dentfisto.model;

import java.time.LocalDate;

public class DossierMedical {
    private int id;
    private String numeroReference;
    private LocalDate dateCreation;
    private int patientId;

    private List<Consultation> consultations;
    private List<Document> documentsAnnexes;

    public DossierMedical() {}

    // Getters et Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNumeroReference() { return numeroReference; }
    public void setNumeroReference(String numeroReference) { this.numeroReference = numeroReference; }

    public LocalDate getDateCreation() { return dateCreation; }
    public void setDateCreation(LocalDate dateCreation) { this.dateCreation = dateCreation; }

    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }

    public List<Consultation> getConsultations() {
        return consultations;
    }

    public List<Document> getDocumentsAnnexes() {
        return documentsAnnexes;
    }
}
