USE dentFistoDB;

-- Utilisateurs (l'équipe Backend gérera le hash bcrypt plus tard @Nabil @Ismail)
INSERT IGNORE INTO utilisateur (id, login, motDePasse, role) VALUES 
(1, 'admin', 'password123', 'ADMINISTRATEUR'),
(2, 'dentist', 'password123', 'DENTISTE'),
(3, 'assistant', 'password123', 'ASSISTANT');

-- Actes médicaux
INSERT IGNORE INTO acte (id, code, nom, tarifBase) VALUES 
(1, 'CON', 'Consultation de contrôle', 200.00),
(2, 'DET', 'Détartrage', 350.00),
(3, 'EXT', 'Extraction dentaire simple', 400.00);

INSERT INTO paiement (id, modeReglement, factureId) VALUES 
(1, 'ESPECES', 1);
