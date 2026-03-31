USE dentFistoDB;

-- Utilisateurs (l'équipe Backend gérera le hash bcrypt plus tard @Nabil @Ismail)
INSERT IGNORE INTO utilisateur (id, login, motDePasse, role) VALUES 
(1, 'admin', 'password123', 'ADMINISTRATEUR'),
(2, 'dentist1', 'password123', 'DENTISTE'),
(3, 'assistant1', 'password123', 'ASSISTANTE'),
(4, 'Sultanos', 'password123', 'DENTISTE'),
(5, 'nabil', 'password123', 'DENTISTE');

-- Actes médicaux
INSERT IGNORE INTO acte (id, code, nom, tarifBase) VALUES 
(1, 'CON', 'Consultation de contrôle', 200.00),
(2, 'DET', 'Détartrage', 350.00),
(3, 'EXT', 'Extraction dentaire simple', 400.00);

-- Patients
INSERT INTO patient (id, nom, prenom, dateNaissance, sexe, adresse, telephone) VALUES 
(1, 'Alaoui', 'Karim', '1985-05-15', 'H', '12 Rue des Lilas, Fès', '0600112233');

INSERT INTO patient (id, nom, prenom, dateNaissance, sexe, adresse, telephone, responsableLegalNom, responsableLegalTel) VALUES 
(2, 'Chraibi', 'Sami', '2015-08-10', 'H', 'Quartier Andalous, Fès', '0600778899', 'Chraibi Ahmed', '0611223344');

-- Dossiers Médicaux
INSERT INTO dossierMedical (id, numeroReference, dateCreation, patientId) VALUES 
(1, 'DM-2026-001', CURDATE(), 1),
(2, 'DM-2026-002', CURDATE(), 2);

-- Rendez-vous
INSERT INTO rendezVous (id, dateRdv, heureDebut, heureFin, motif, statut, patientId, dentisteId) VALUES 
(1, CURDATE(), '09:00:00', '09:45:00', 'Contrôle annuel', 'PLANIFIE', 1, 4),
(2, CURDATE(), '10:00:00', '11:00:00', 'Urgence', 'EN_SALLE_D_ATTENTE', 2, 4);

-- Consultations (Pour le RDV terminé)
INSERT INTO consultation (id, diagnostic, observations, rdvId, dossierId) VALUES 
(1, 'Denture saine', 'RAS', 1, 1);

-- Actes liés à la consultation
INSERT INTO consultationActe (consultationId, acteId) VALUES 
(1, 1);

-- Facture et Paiement
INSERT INTO facture (id, montantTotal, cheminPdf, dateFacturation, consultationId) VALUES 
(1, 200.00, '/uploads/factures/fac_1.pdf', CURDATE(), 1);

INSERT INTO paiement (id, modeReglement, factureId) VALUES 
(1, 'ESPECES', 1);
