-- ==========================================
-- 1. BASE DE DONNÉES ET UTILISATEUR
-- ==========================================
CREATE DATABASE IF NOT EXISTS dentFistoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE dentFistoDB;

CREATE USER IF NOT EXISTS 'sgcdAppUser'@'%' IDENTIFIED BY 'motdepasse_securise';
GRANT ALL PRIVILEGES ON dentFistoDB.* TO 'sgcdAppUser'@'%';

-- ==========================================
-- 2. RÔLES ET PRIVILÈGES
-- ==========================================
CREATE ROLE 'roleAssistante', 'roleDentiste', 'roleAdministrateur';

-- ==========================================
-- 3. TABLES (Entités métier)
-- ==========================================
CREATE TABLE utilisateur (
    id INT AUTO_INCREMENT PRIMARY KEY,
    login VARCHAR(50) UNIQUE NOT NULL,
    motDePasse VARCHAR(255) NOT NULL,
    role ENUM('ADMINISTRATEUR', 'DENTISTE', 'ASSISTANTE') NOT NULL
);

CREATE TABLE patient (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    dateNaissance DATE NOT NULL,
    sexe ENUM('H', 'F') NOT NULL,
    adresse VARCHAR(255) NOT NULL,
    telephone VARCHAR(20) NOT NULL,
    cnssMutuelle VARCHAR(50) NULL,
    antecedentsMedicaux TEXT NULL,
    allergieCritique VARCHAR(255) NULL,
    responsableLegalNom VARCHAR(100) NULL,
    responsableLegalTel VARCHAR(20) NULL,
    CONSTRAINT ukPatient UNIQUE (nom, dateNaissance)
);

CREATE TABLE dossierMedical (
    id INT AUTO_INCREMENT PRIMARY KEY,
    numeroReference VARCHAR(50) UNIQUE NOT NULL,
    dateCreation DATE NOT NULL,
    patientId INT UNIQUE NOT NULL,
    FOREIGN KEY (patientId) REFERENCES patient(id) ON DELETE CASCADE
);

CREATE TABLE rendezVous (
    id INT AUTO_INCREMENT PRIMARY KEY,
    dateRdv DATE NOT NULL,
    heureDebut TIME NOT NULL,
    heureFin TIME NOT NULL,
    motif VARCHAR(100) NOT NULL,
    notesInternes TEXT NULL,
    statut ENUM('PLANIFIE', 'ANNULE', 'NON_HONORE', 'EN_SALLE_D_ATTENTE', 'EN_COURS', 'TERMINE') DEFAULT 'PLANIFIE',
    patientId INT NOT NULL,
    dentisteId INT NOT NULL,
    FOREIGN KEY (patientId) REFERENCES patient(id),
    FOREIGN KEY (dentisteId) REFERENCES utilisateur(id)
);

CREATE TABLE consultation (
    id INT AUTO_INCREMENT PRIMARY KEY,
    diagnostic TEXT NULL,
    observations TEXT NULL,
    rdvId INT UNIQUE NOT NULL,
    dossierId INT NOT NULL,
    FOREIGN KEY (rdvId) REFERENCES rendezVous(id),
    FOREIGN KEY (dossierId) REFERENCES dossierMedical(id)
);

CREATE TABLE acte (
    id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(20) UNIQUE NOT NULL,
    nom VARCHAR(100) NOT NULL,
    tarifBase DECIMAL(10, 2) NOT NULL
);

CREATE TABLE consultationActe (
    consultationId INT NOT NULL,
    acteId INT NOT NULL,
    PRIMARY KEY (consultationId, acteId),
    FOREIGN KEY (consultationId) REFERENCES consultation(id) ON DELETE CASCADE,
    FOREIGN KEY (acteId) REFERENCES acte(id)
);

CREATE TABLE document (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(50) NOT NULL,
    dateImportation DATE NOT NULL,
    cheminAcces VARCHAR(255) NOT NULL,
    dossierId INT NOT NULL,
    FOREIGN KEY (dossierId) REFERENCES dossierMedical(id) ON DELETE CASCADE
);

CREATE TABLE ordonnance (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cheminPdf VARCHAR(255) NOT NULL,
    consultationId INT UNIQUE NOT NULL,
    FOREIGN KEY (consultationId) REFERENCES consultation(id) ON DELETE CASCADE
);

CREATE TABLE facture (
    id INT AUTO_INCREMENT PRIMARY KEY,
    montantTotal DECIMAL(10, 2) NOT NULL,
    cheminPdf VARCHAR(255) NOT NULL,
    dateFacturation DATE NOT NULL,
    consultationId INT UNIQUE NOT NULL,
    FOREIGN KEY (consultationId) REFERENCES consultation(id)
);

CREATE TABLE paiement (
    id INT AUTO_INCREMENT PRIMARY KEY,
    modeReglement ENUM('ESPECES', 'CARTE_BANCAIRE', 'CHEQUE') NOT NULL,
    factureId INT NOT NULL,
    FOREIGN KEY (factureId) REFERENCES facture(id) ON DELETE CASCADE
);

-- ==========================================
-- 4. ATTRIBUTION DES PRIVILÈGES
-- ==========================================

-- Privilèges Assistante
GRANT SELECT, INSERT, UPDATE ON dentFistoDB.rendezVous TO 'roleAssistante';
GRANT SELECT ON dentFistoDB.utilisateur TO 'roleAssistante'; 
GRANT SELECT, INSERT, UPDATE ON dentFistoDB.patient TO 'roleAssistante';
GRANT SELECT, INSERT, UPDATE ON dentFistoDB.dossierMedical TO 'roleAssistante';
GRANT SELECT, INSERT, UPDATE ON dentFistoDB.facture TO 'roleAssistante';
GRANT SELECT, INSERT, UPDATE ON dentFistoDB.paiement TO 'roleAssistante';
GRANT SELECT ON dentFistoDB.consultation TO 'roleAssistante'; 
GRANT SELECT ON dentFistoDB.consultationActe TO 'roleAssistante'; 
GRANT SELECT ON dentFistoDB.acte TO 'roleAssistante'; 

-- Privilèges Dentiste
GRANT SELECT, UPDATE ON dentFistoDB.patient TO 'roleDentiste';
GRANT SELECT ON dentFistoDB.dossierMedical TO 'roleDentiste';
GRANT SELECT, UPDATE ON dentFistoDB.rendezVous TO 'roleDentiste';
GRANT SELECT, INSERT, UPDATE ON dentFistoDB.consultation TO 'roleDentiste';
GRANT SELECT, INSERT, UPDATE ON dentFistoDB.consultationActe TO 'roleDentiste';
GRANT SELECT ON dentFistoDB.acte TO 'roleDentiste'; 
GRANT SELECT, INSERT ON dentFistoDB.document TO 'roleDentiste';
GRANT SELECT, INSERT ON dentFistoDB.ordonnance TO 'roleDentiste';

-- Privilèges Administrateur
GRANT SELECT, INSERT, UPDATE, DELETE ON dentFistoDB.utilisateur TO 'roleAdministrateur';
GRANT SELECT ON dentFistoDB.* TO 'roleAdministrateur';
GRANT SELECT, INSERT, UPDATE, DELETE ON dentFistoDB.acte TO 'roleAdministrateur';