package com.dentfisto.model;

public class Acte {
    private int id;
    private String code;
    private String nom;
    private double tarifBase;

    public Acte() {}

    // Getters et Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public double getTarifBase() { return tarifBase; }
    public void setTarifBase(double tarifBase) { this.tarifBase = tarifBase; }
}