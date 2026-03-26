USE dentFistoDB;

DELIMITER //

-- T1 : Contrôles à l'insertion d'un patient
CREATE TRIGGER trg_patient_before_insert
BEFORE INSERT ON patient
FOR EACH ROW
BEGIN
    DECLARE v_count INT;
    DECLARE v_age INT;

    SELECT COUNT(*) INTO v_count FROM patient;
    IF v_count >= 100 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Erreur : La limite de 100 patients pour la migration initiale est atteinte.';
    END IF;

    SET v_age = TIMESTAMPDIFF(YEAR, NEW.dateNaissance, CURDATE());
    IF v_age <= 0 OR v_age >= 120 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Erreur : L''âge du patient doit être strictement supérieur à 0 et inférieur à 120 ans.';
    END IF;

    IF v_age < 18 AND (NEW.responsableLegalNom IS NULL OR NEW.responsableLegalTel IS NULL 
                       OR NEW.responsableLegalNom = '' OR NEW.responsableLegalTel = '') THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Erreur : Pour un mineur, le responsable légal est obligatoire.';
    END IF;
END //

-- T2 : Contrôles à la modification d'un patient
CREATE TRIGGER trg_patient_before_update
BEFORE UPDATE ON patient
FOR EACH ROW
BEGIN
    DECLARE v_age INT;
    SET v_age = TIMESTAMPDIFF(YEAR, NEW.dateNaissance, CURDATE());
    
    IF v_age <= 0 OR v_age >= 120 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Erreur : L''âge du patient doit être strictement supérieur à 0 et inférieur à 120 ans.';
    END IF;

    IF v_age < 18 AND (NEW.responsableLegalNom IS NULL OR NEW.responsableLegalTel IS NULL 
                       OR NEW.responsableLegalNom = '' OR NEW.responsableLegalTel = '') THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Erreur : Pour un mineur, le responsable légal est obligatoire.';
    END IF;
END //

-- T3 : Contrôle des horaires et des chevauchements de RDV
CREATE TRIGGER trg_rdv_before_insert
BEFORE INSERT ON rendezVous
FOR EACH ROW
BEGIN
    DECLARE v_chevauchement INT;

    IF NOT ((NEW.heureDebut >= '09:00:00' AND NEW.heureFin <= '12:00:00') OR 
            (NEW.heureDebut >= '14:00:00' AND NEW.heureFin <= '19:00:00')) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Erreur : Le rendez-vous doit être dans les horaires (09h-12h ou 14h-19h).';
    END IF;

    SELECT COUNT(*) INTO v_chevauchement 
    FROM rendezVous 
    WHERE dentisteId = NEW.dentisteId 
      AND dateRdv = NEW.dateRdv 
      AND statut NOT IN ('ANNULE', 'NON_HONORE')
      AND (NEW.heureDebut < heureFin AND NEW.heureFin > heureDebut);
      
    IF v_chevauchement > 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Erreur : Ce dentiste a déjà un rendez-vous sur ce créneau.';
    END IF;
END //

-- T4 : Ouverture automatique d'une consultation
CREATE TRIGGER trg_rdv_after_update
AFTER UPDATE ON rendezVous
FOR EACH ROW
BEGIN
    DECLARE v_dossierId INT;
    
    IF NEW.statut = 'EN_COURS' AND OLD.statut != 'EN_COURS' THEN
        SELECT id INTO v_dossierId FROM dossierMedical WHERE patientId = NEW.patientId;
        INSERT INTO consultation (rdvId, dossierId) VALUES (NEW.id, v_dossierId);
    END IF;
END //

-- F1 : Calcul automatique de la facture
CREATE FUNCTION calculerMontantFacture(p_consultationId INT) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE v_total DECIMAL(10,2);
    
    SELECT IFNULL(SUM(a.tarifBase), 0) INTO v_total
    FROM consultationActe ca
    JOIN acte a ON ca.acteId = a.id
    WHERE ca.consultationId = p_consultationId;
    
    RETURN v_total;
END //

-- P1 : Statistiques pour le Dashboard Administrateur
CREATE PROCEDURE genererStatsDentiste(IN p_dentisteId INT)
BEGIN
    DECLARE v_totalRdv INT;
    DECLARE v_rdvAnnules INT;
    DECLARE v_tauxAnnulation DECIMAL(5,2);
    DECLARE v_chiffreAffaires DECIMAL(10,2);

    SELECT COUNT(*), SUM(CASE WHEN statut = 'ANNULE' THEN 1 ELSE 0 END) 
    INTO v_totalRdv, v_rdvAnnules
    FROM rendezVous WHERE dentisteId = p_dentisteId;

    IF v_totalRdv > 0 THEN
        SET v_tauxAnnulation = (v_rdvAnnules / v_totalRdv) * 100;
    ELSE
        SET v_tauxAnnulation = 0;
    END IF;

    SELECT IFNULL(SUM(f.montantTotal), 0) INTO v_chiffreAffaires
    FROM facture f
    JOIN consultation c ON f.consultationId = c.id
    JOIN rendezVous r ON c.rdvId = r.id
    WHERE r.dentisteId = p_dentisteId;

    SELECT 
        v_totalRdv AS Total_RDV, 
        v_rdvAnnules AS RDV_Annules, 
        v_tauxAnnulation AS Pourcentage_Annulation, 
        v_chiffreAffaires AS Chiffre_Affaires_Total;
END //

DELIMITER ;
