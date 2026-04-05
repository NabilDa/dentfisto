USE dentFistoDB;

-- Utilisateurs (l'équipe Backend gérera le hash bcrypt plus tard @Nabil @Ismail)
INSERT IGNORE INTO utilisateur (id, login, motDePasse, role) VALUES 
(1, 'admin', 'password123', 'ADMINISTRATEUR'),
