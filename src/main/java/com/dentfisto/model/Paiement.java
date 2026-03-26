package com.dentfisto.model;

public class Paiement {
    private int id;
    private String modeReglement; // "ESPECES", "CARTE_BANCAIRE", "CHEQUE"
    private int factureId;

    public Paiement() {}

    // Getters et Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getModeReglement() { return modeReglement; }
    public void setModeReglement(String modeReglement) { this.modeReglement = modeReglement; }

    public int getFactureId() { return factureId; }
    public void setFactureId(int factureId) { this.factureId = factureId; }
}