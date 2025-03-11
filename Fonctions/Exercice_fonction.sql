-- Active: 1740235929669@@127.0.0.1@3308@sql-tp

-- *                             FONCTIONS SCALAIRES 

--*                 FONCTIONS DE MANIPULATION DES CHAINES DE CARACTERES 


-- Creation table employes (nom VARCHAR(50), prenom VARCHAR(50), email VARCHAR(100), salaire DECIMAL(10,2), date_embauche DATE)
CREATE TABLE employes (
 id INT PRIMARY KEY AUTO_INCREMENT,
 nom VARCHAR(50),
 prenom VARCHAR(50),
 email VARCHAR(100),
 salaire DECIMAL(10,2),
 date_embauche DATE
);


--  1. Afficher le prénom de chaque employé en majuscules
--  UPPER(str) : Convertit str en majuscules
SELECT UPPER(prenom) FROM employes;


--  2. Afficher l'email de chaque employé sans le caractère @gmail.com
--  REPLACE(str , old , new) : Remplace old par new dans str
SELECT REPLACE(email, '@gmail.com', '') FROM employes;


--  3. Afficher la longueur des noms de famille 
--  LENGTH(str) : Retourne la longueur de la chaîne str en octets
SELECT LENGTH(nom) FROM employes;


--  4. Afficher les trois premières lettres du prénom de chaque employé 
-- SUBSTRING(str, start, length) : Extrait une partie de chaine de Caracteres
SELECT SUBSTRING (prenom , 1 , 3) FROM employes;


--  5. Concaténer le prénom et le nom en une seule colonne sous le format : "Nom, Prénom". 
--  CONCAT(str1, str2, ...) : Concatène les chaînes str1, str2, ...
SELECT CONCAT(nom, ', ', prenom) FROM employes;

-- 6 
-- LOWER(str) : Convertit str en miniscules 
SELECT LOWER(prenom) FROM employes;



--*             FONCTIONS DE MANIPULATION DES NOMBRES MATHEMATIQUES 


--  Creation table produits (nom VARCHAR(50), prix DECIMAL(10,2), stock INT)
CREATE TABLE produits (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(50),
    prix DECIMAL(10 , 2),
    stock INT
);


--  1. Arrondir les prix à l'entier le plus proche
--  ROUND(x) : Arrondit x à l'entier le plus proche
SELECT ROUND(prix) FROM produits;


--  2. Affiche le prix le plus bas et le plus élevé
--  MIN(x) : Retourne la valeur minimale de x
--  MAX(x) : Retourne la valeur maximale de x
SELECT MIN(prix), MAX(prix) FROM produits;


--  3. Augmenter tous les prix de 10%
--  ROUND(x, d) : Arrondit x à d décimales près 
SELECT ROUND(prix * 1.1, 2) FROM produits;


--  4. Afficher la valeur absolue de la différence entre le prix minimum et maximum
--  ABS(x) : Retourne la valeur absolue de x
SELECT ABS(MAX(prix) - MIN(prix)) FROM produits;


--  5. Calculer le prix moyen des produits
--  AVG(x) : Retourne la moyenne de x
SELECT AVG(prix) FROM produits;



--*             FONCTIONS DE MANIPULATION DES DATES 


--  Creation table commandes id INT PRIMARY KEY AUTO_INCREMENT, date_commande DATE, client VARCHAR(50)
CREATE TABLE commandes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    client VARCHAR(50),
    date_commande DATE
);


--  1. Afficher l'année de chaque commande
--  YEAR(date) : Retourne l'année de la date
SELECT YEAR(date_commande) FROM commandes;


--  2. Afficher le jour de la semaine de chaque commande
--  DAYNAME(date) : Retourne le nom du jour de la semaine de la date
SELECT DAYNAME(date_commande) FROM commandes;


--  3. Afficher le nombre de jours entre la commande et aujourd'hui
--  DATEDIFF(date1, date2) : Retourne le nombre de jours entre date1 et date2
SELECT DATEDIFF(CURDATE(), date_commande) FROM commandes;


--  4. Ajouter 15 jours à la date de chaque commande pour simuler la date de livraison
--  DATE_ADD(date, INTERVAL expr unit) : Ajoute expr unit à la date
SELECT DATE_ADD(date_commande, INTERVAL 15 DAY) FROM commandes;


--  5. Afficher toutes les commandes passées en janvier 2025
-- YEAR(str) : extrait l'année, MONTH(str) : extrait le mois, WHERE et AND : filtrent les résultats  
SELECT * FROM commandes WHERE YEAR(date_commande) = 2025 AND MONTH(date_commande) = 1;
