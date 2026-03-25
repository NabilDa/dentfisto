package com.dentfisto.model;

import java.time.LocalDate;

public class Patient {
    private int id;
    private String nom;
    private String prenom;
    private LocalDate dateNaissance;
    private String sexe;
    private String adresse;
    private String telephone;
    
    // Champs optionnels
    private String cnssMutuelle;
    private String antecedentsMedicaux;
    private String allergieCritique;
    private String responsableLegalNom;
    private String responsableLegalTel;

    public Patient() {}

    // Getters et Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getPrenom() { return prenom; }
    public void setPrenom(String prenom) { this.prenom = prenom; }

    public LocalDate getDateNaissance() { return dateNaissance; }
    public void setDateNaissance(LocalDate dateNaissance) { this.dateNaissance = dateNaissance; }

    public String getSexe() { return sexe; }
    public void setSexe(String sexe) { this.sexe = sexe; }

    public String getAdresse() { return adresse; }
    public void setAdresse(String adresse) { this.adresse = adresse; }

    public String getTelephone() { return telephone; }
    public void setTelephone(String telephone) { this.telephone = telephone; }

    public String getCnssMutuelle() { return cnssMutuelle; }
    public void setCnssMutuelle(String cnssMutuelle) { this.cnssMutuelle = cnssMutuelle; }

    public String getAntecedentsMedicaux() { return antecedentsMedicaux; }
    public void setAntecedentsMedicaux(String antecedentsMedicaux) { this.antecedentsMedicaux = antecedentsMedicaux; }

    public String getAllergieCritique() { return allergieCritique; }
    public void setAllergieCritique(String allergieCritique) { this.allergieCritique = allergieCritique; }

    public String getResponsableLegalNom() { return responsableLegalNom; }
    public void setResponsableLegalNom(String responsableLegalNom) { this.responsableLegalNom = responsableLegalNom; }

    public String getResponsableLegalTel() { return responsableLegalTel; }
    public void setResponsableLegalTel(String responsableLegalTel) { this.responsableLegalTel = responsableLegalTel; }
}