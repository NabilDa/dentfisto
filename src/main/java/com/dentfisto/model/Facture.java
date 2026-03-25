package com.dentfisto.model;

import java.time.LocalDate;

public class Facture {
    private int id;
    private double montantTotal;
    private String cheminPdf;
    private LocalDate dateFacturation;
    private int consultationId;

    public Facture() {}

    // Getters et Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public double getMontantTotal() { return montantTotal; }
    public void setMontantTotal(double montantTotal) { this.montantTotal = montantTotal; }

    public String getCheminPdf() { return cheminPdf; }
    public void setCheminPdf(String cheminPdf) { this.cheminPdf = cheminPdf; }

    public LocalDate getDateFacturation() { return dateFacturation; }
    public void setDateFacturation(LocalDate dateFacturation) { this.dateFacturation = dateFacturation; }

    public int getConsultationId() { return consultationId; }
    public void setConsultationId(int consultationId) { this.consultationId = consultationId; }
}