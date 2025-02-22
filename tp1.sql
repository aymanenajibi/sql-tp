-- 1. Affichage des bases de données disponibles
SHOW DATABASES;

-- 2. Choisir et utiliser la base de données 'sql-tp'
USE `sql-tp`;

-- 3. Création de la table 'stagiaires' si elle n'existe pas déjà
CREATE TABLE IF NOT EXISTS stagiaires (
    matricule INT AUTO_INCREMENT PRIMARY KEY, -- 3.1 Identifiant unique et auto-incrémenté
    nom VARCHAR(50) NOT NULL,                 -- 3.2 Nom du stagiaire (obligatoire)
    prenom VARCHAR(50) NOT NULL,              -- 3.3 Prénom du stagiaire (obligatoire)
    date_naissance DATE NOT NULL,             -- 3.4 Date de naissance (obligatoire)
    adresse VARCHAR(255) NOT NULL,            -- 3.5 Adresse du stagiaire (obligatoire)
    ville VARCHAR(10) DEFAULT 'Temara'        -- 3.6 Ville avec valeur par défaut 'Temara'
);

-- 4. Insertion de stagiaires dans la table 'stagiaires'
INSERT INTO stagiaires (nom, prenom, date_naissance, adresse, ville)
VALUES ('Najibi', 'Aymane', '2004-02-03', 'El ghazali', 'Temara');

INSERT INTO stagiaires (nom, prenom, date_naissance, adresse, ville)
VALUES ('JANATY', 'Wiam', '2003-02-03', 'tit', 'Temara');

INSERT INTO stagiaires (nom, prenom, date_naissance, adresse, ville)
VALUES ('L3arbi', 'Arbaz', '2002-02-03', 'S7RA', 'Ain atique');

-- 5. Création d'une procédure pour récupérer un stagiaire par son ID
DELIMITER // 
CREATE PROCEDURE getStagInfo(IN id INT) 
BEGIN
    SELECT * FROM stagiaires WHERE matricule = id; -- 5.1 Récupérer un stagiaire spécifique
END //
DELIMITER ;

-- 6. Appel de la procédure pour récupérer le stagiaire avec l'ID 2
CALL getStagInfo(2);

-- 7. Suppression de la procédure après son utilisation
DROP PROCEDURE IF EXISTS getStagInfo;

-- 8. Affichage des tables existantes dans la base de données
SHOW TABLES;

-- 9. Description de la structure de la table 'stagiaires'
DESCRIBE stagiaires;

-- 10. Suppression de la table 'stagiaires' si elle existe
DROP TABLE IF EXISTS stagiaires;

-- 11. Création d'une procédure pour ajouter un stagiaire
DELIMITER //
CREATE PROCEDURE AddS(
    IN p_nom VARCHAR(50), 
    IN p_prenom VARCHAR(50), 
    IN p_date_naissance DATE, 
    IN p_adresse VARCHAR(255), 
    IN p_ville VARCHAR(10)
) 
BEGIN
    INSERT INTO stagiaires (nom, prenom, date_naissance, adresse, ville)
    VALUES (p_nom, p_prenom, p_date_naissance, p_adresse, p_ville);
END //
DELIMITER ;

-- 12. Affichage des stagiaires enregistrés
SELECT * FROM stagiaires;

-- 13. Suppression d'un stagiaire spécifique
DELETE FROM stagiaires WHERE matricule = 1;

-- 14. Désactivation du mode sécurisé pour permettre les suppressions globales
SET SQL_SAFE_UPDATES = 0;

-- 15. Suppression de toutes les données dans la table 'stagiaires'
DELETE FROM stagiaires;

-- 16. Réactivation du mode sécurisé
SET SQL_SAFE_UPDATES = 1;

-- 17. Création d'une procédure pour supprimer un stagiaire par son ID
DELIMITER //
CREATE PROCEDURE deleteStagiaire(IN id INT)
BEGIN
    DELETE FROM stagiaires WHERE matricule = id;
END //
DELIMITER ;

-- 18. Création d'une procédure pour modifier la date de naissance d'un stagiaire
DELIMITER //
CREATE PROCEDURE updateDateNaissance(IN id INT, IN new_date DATE)
BEGIN
    UPDATE stagiaires SET date_naissance = new_date WHERE matricule = id;
END //
DELIMITER ;

-- 19. Création d'une procédure pour compter les stagiaires par ville
DELIMITER //
CREATE PROCEDURE countStagiairesByCity(IN city_name VARCHAR(10))
BEGIN
    SELECT COUNT(*) AS total_stagiaires FROM stagiaires WHERE ville = city_name;
END //
DELIMITER ;

-- 20. Création d'une procédure pour afficher la ville ayant le plus de stagiaires
DELIMITER //
CREATE PROCEDURE cityWithMostStagiaires()
BEGIN
    SELECT ville, COUNT(*) AS total_stagiaires
    FROM stagiaires
    GROUP BY ville
    ORDER BY total_stagiaires DESC
    LIMIT 1;
END //
DELIMITER ;

-- 21. Suppression et recréation de la base 'gestion_stagiaires'
DROP DATABASE IF EXISTS gestion_stagiaires;
CREATE DATABASE gestion_stagiaires;
USE gestion_stagiaires;

-- 22. Création de la table 'stagiaires'
CREATE TABLE stagiaires (
    matricule INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    date_naissance DATE NOT NULL,
    ville VARCHAR(50) NOT NULL
);

-- 23. Insertion de données de test
INSERT INTO stagiaires (nom, prenom, date_naissance, ville) VALUES
('Dupont', 'Jean', '2000-05-10', 'Paris'),
('Martin', 'Sophie', '1999-07-20', 'Lyon'),
('Durand', 'Paul', '1998-12-15', 'Marseille');

-- 24. Sélection des stagiaires
SELECT * FROM stagiaires;

-- 25. Création d'une procédure pour ajouter un stagiaire
DELIMITER //
CREATE PROCEDURE addStagiaire(IN nom VARCHAR(50), IN prenom VARCHAR(50), IN date_naissance DATE, IN ville VARCHAR(50))
BEGIN
    INSERT INTO stagiaires (nom, prenom, date_naissance, ville) VALUES (nom, prenom, date_naissance, ville);
END //
DELIMITER ;

-- 26. Création d'une fonction pour calculer l'âge d'un stagiaire
DELIMITER //
CREATE FUNCTION getAge(id INT) RETURNS INT DETERMINISTIC
BEGIN
    DECLARE age INT;
    SELECT TIMESTAMPDIFF(YEAR, date_naissance, CURDATE()) INTO age FROM stagiaires WHERE matricule = id;
    RETURN age;
END //
DELIMITER ;

-- 27. Création d'un déclencheur pour vérifier la validité de la date de naissance
DELIMITER //
CREATE TRIGGER check_date_naissance BEFORE INSERT ON stagiaires
FOR EACH ROW
BEGIN
    IF NEW.date_naissance > CURDATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La date de naissance ne peut pas être dans le futur !';
    END IF;
END //
DELIMITER ;

-- 28. Création d'une transaction pour supprimer tous les stagiaires
DELIMITER //
CREATE PROCEDURE deleteAllStagiaires()
BEGIN
    START TRANSACTION;
    DELETE FROM stagiaires;
    IF (SELECT COUNT(*) FROM stagiaires) > 0 THEN
        ROLLBACK;
        SELECT 'Erreur : suppression annulée' AS message;
    ELSE
        COMMIT;
        SELECT 'Tous les stagiaires ont été supprimés' AS message;
    END IF;
END //
DELIMITER ;
