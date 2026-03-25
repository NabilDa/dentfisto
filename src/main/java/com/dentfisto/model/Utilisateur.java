package com.dentfisto.model;

public class Utilisateur {
    private int id;
    private String login;
    private String motDePasse;
    private String role; // "ADMINISTRATEUR", "DENTISTE", "ASSISTANTE"

    // Constructeur par défaut
    public Utilisateur() {}

    // Constructeur avec paramètres
    public Utilisateur(int id, String login, String motDePasse, String role) {
        this.id = id;
        this.login = login;
        this.motDePasse = motDePasse;
        this.role = role;
    }

    // Getters et Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getLogin() { return login; }
    public void setLogin(String login) { this.login = login; }

    public String getMotDePasse() { return motDePasse; }
    public void setMotDePasse(String motDePasse) { this.motDePasse = motDePasse; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
}