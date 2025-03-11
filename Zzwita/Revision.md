# Révision MySQL : Fonctions, Triggers, et Syntaxes

## Les Fonctions MySQL

Les fonctions MySQL permettent d'effectuer des calculs, de manipuler des chaînes de caractères, des dates, et d'autres opérations sur les données. Elles peuvent être prédéfinies ou définies par l'utilisateur (UDF).

### 1. Fonctions Prédéfinies

#### 1.1 Fonctions Scalaires
Elles opèrent sur une seule valeur et retournent un résultat.

- **Mathématiques** : `ROUND()`, `ABS()`, `CEIL()`
- **Chaînes de caractères** : `UPPER()`, `LOWER()`, `CONCAT()`
- **Dates & Heures** : `NOW()`, `DATEDIFF()`, `DATE_FORMAT()`
- **Conversion** : `CAST()`, `CONVERT()`

#### 1.2 Fonctions d'Agrégation
Elles renvoient une valeur pour un ensemble de lignes, souvent utilisées avec `GROUP BY`.

- `SUM()` : Somme d'une colonne numérique
- `AVG()` : Moyenne
- `COUNT()` : Nombre de lignes
- `MAX()` / `MIN()` : Valeur maximale et minimale

#### 1.3 Fonctions Définies par l'Utilisateur (UDF)
Permettent de créer des fonctions personnalisées avec `CREATE FUNCTION`.

### 2. Fonctions MySQL les Plus Utilisées

#### 2.1 Fonctions Mathématiques
- `ABS(x)` : Valeur absolue de x
- `ROUND(x, d)` : Arrondit x à d décimales
- `CEIL(x)` : Arrondit x vers le haut
- `FLOOR(x)` : Arrondit x vers le bas

#### 2.2 Fonctions de Chaînes de Caractères
- `LENGTH(str)` : Longueur de str en octets
- `UPPER(str)` : Convertit str en majuscules
- `LOWER(str)` : Convertit str en minuscules
- `LEFT(str, nombre)` : Retourne les (n) premiers caracteres de la chaine str
- `CONCAT(s1, s2, ...)` : Concatène des chaînes
- `SUBSTRING(str, start, length)` : Extrait une une partie d'une chaîne de caractères , start : (n) la position de depart de l'extraction et length le nombre de caractere a extraire 
- `REPLACE(str, old, new)` : Remplace old par new dans str

#### 2.3 Fonctions sur les Dates & Heures
- `NOW()` : Date et heure actuelles
- `CURDATE()` : Date actuelle
- `YEAR(date)` : Année d'une date
- `MONTHNAME(date)` : Nom du mois
- `DATEDIFF(d1, d2)` : Différence entre d1 et d2
- `TIMESTAMPDIFF(unit, datetime1, datetime2)` : Différence entre deux dates/heures
- `DATE_ADD(date, INTERVAL interval_expr unit)` : Ajouter à une date

#### 2.4 Fonctions Conditionnelles et Logiques
- `IF(condition, val1, val2)` : Renvoie val1 si la condition est vraie, sinon val2
- `CASE WHEN ... THEN ... ELSE ... END` : Structure conditionnelle
- `COALESCE(val1, val2, ...)` : Renvoie la première valeur non NULL

### 3. Création de Fonctions Personnalisées

Exemple : Fonction pour calculer un salaire net après impôt

```sql
DELIMITER $$
CREATE FUNCTION calcul_salaire_net(salaire_brut DECIMAL(10,2)) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
 DECLARE taux_impot DECIMAL(10,2);
 SET taux_impot = 0.2; -- 20% d'impôt
 RETURN salaire_brut * (1 - taux_impot);
END $$
DELIMITER ;
```

Utilisation de la fonction :

```sql
SELECT calcul_salaire_net(5000); -- Résultat : 4000.00
```

### 4. Différence entre Fonction et Procédure Stockée

| Caractéristique | Fonction (CREATE FUNCTION) | Procédure Stockée (CREATE PROCEDURE) |
|-----------------|----------------------------|--------------------------------------|
| Retourne une valeur ? | Oui (avec RETURN) | Non (utilise OUT pour renvoyer des valeurs) |
| Utilisable dans une requête SQL ? | Oui (SELECT ma_fonction()) | Non (CALL ma_procedure()) |
| Peut modifier des tables ? | Non (lecture seule) | Oui (insertion, mise à jour, suppression) |
| Exécution | SELECT | CALL |

## Les Triggers en MySQL

Un trigger (ou déclencheur) est un ensemble d’actions qui s’exécutent automatiquement lorsqu’un événement spécifique (`INSERT`, `UPDATE`, ou `DELETE`) est effectué sur une table.

### 1. Création d'un Trigger

La syntaxe générale pour créer un trigger est :

```sql
CREATE TRIGGER nom_du_trigger
BEFORE | AFTER INSERT | UPDATE | DELETE
ON nom_de_la_table
FOR EACH ROW
BEGIN
 -- Instructions SQL à exécuter
END;
```

- **BEFORE** : Exécute le trigger avant l'action.
- **AFTER** : Exécute le trigger après l'action.
- **FOR EACH ROW** : S'applique à chaque ligne affectée.
- **NEW.colonne** : Utilisé pour `INSERT` et `UPDATE` pour référencer la nouvelle valeur.
- **OLD.colonne** : Utilisé pour `UPDATE` et `DELETE` pour référencer l'ancienne valeur.

### 2. Suppression d’un Trigger

Pour supprimer un trigger :

```sql
DROP TRIGGER IF EXISTS nom_du_trigger;
```

### 3. Voir la Liste des Triggers

Pour afficher tous les triggers d'une base de données :

```sql
SHOW TRIGGERS FROM nom_de_la_base;
```

### 4. Exercices sur les Triggers

#### Exercice 1 : Journaliser les insertions dans une table logs

```sql
CREATE TABLE logs (
 id INT AUTO_INCREMENT PRIMARY KEY,
 action VARCHAR(255),
 date_action TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TRIGGER trigger_insert_utilisateur
AFTER INSERT ON utilisateurs
FOR EACH ROW
BEGIN
 INSERT INTO logs (action)
 VALUES (CONCAT('Nouvel utilisateur ajouté : ', NEW.nom));
END;
```

#### Exercice 2 : Empêcher la suppression d’un utilisateur spécifique

#### Exercice 3 : Mise à jour automatique d'un stock

```sql
CREATE TRIGGER trg_ApresAchatProduit
AFTER INSERT ON Achat
FOR EACH ROW
BEGIN
 UPDATE Produits
 SET stock = stock + NEW.quantite
 WHERE id = NEW.id_produit;
END;
```

#### Exercice 4 : Sauvegarder les anciennes valeurs avant une mise à jour

```sql
CREATE TABLE historique_salaire (
 id INT AUTO_INCREMENT PRIMARY KEY,
 employe_id INT,
 ancien_salaire DECIMAL(10,2),
 date_changement TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TRIGGER trg_AvantMiseAJourSalaire
BEFORE UPDATE ON Employes
FOR EACH ROW
BEGIN
 INSERT INTO historique_salaire (employe_id, ancien_salaire)
 VALUES (OLD.id, OLD.salaire);
END;
```

#### Exercice 5 : Audit des suppressions

```sql
CREATE TRIGGER trg_AfterDeleteEmploye
AFTER DELETE ON Employes
FOR EACH ROW
BEGIN
 INSERT INTO Log_Employes (id_employe, action)
 VALUES (OLD.id, 'Suppression');
END;
```

#### Exercice 6 : Contrôle des augmentations de salaire

```sql
CREATE TRIGGER trg_AvantMiseAJourSalaire
BEFORE UPDATE ON Employes
FOR EACH ROW
BEGIN
 IF NEW.salaire > OLD.salaire * 1.10 THEN
 SIGNAL SQLSTATE '45000'
 SET MESSAGE_TEXT = 'Augmentation de salaire supérieure à 10 % non autorisée';
 END IF;
END;
```

#### Exercice 7 : Vérification de l'âge minimum

```sql
CREATE TRIGGER trg_AvantInsertionEmploye
BEFORE INSERT ON Employes
FOR EACH ROW
BEGIN
 IF TIMESTAMPDIFF(YEAR, NEW.date_naissance, CURDATE()) < 18 THEN
 SIGNAL SQLSTATE '45000'
 SET MESSAGE_TEXT = 'L\'employé doit avoir au moins 18 ans';
 END IF;
END;
```

#### Exercice 8 : Historique des suppressions

```sql
CREATE TRIGGER trg_ApresSuppressionEmploye
AFTER DELETE ON Employes
FOR EACH ROW
BEGIN
 INSERT INTO Archive_Employes (id_employe, nom, salaire, date_suppression)
 VALUES (OLD.id, OLD.nom, OLD.salaire, NOW());
END;
```

## Structures de Base du Langage Procédural MySQL

### 1. Déclaration et Utilisation des Variables

- **Variables locales** : `DECLARE nom_variable TYPE [DEFAULT valeur];`
- **Variables de session** : `SET @nom_variable = valeur;`

### 2. Structures de Contrôle

#### a) Conditions (IF, CASE)

- **IF...THEN...ELSE** :

```sql
IF condition THEN
 -- instructions
ELSEIF autre_condition THEN
 -- autres instructions
ELSE
 -- instructions par défaut
END IF;
```

- **CASE** :

```sql
CASE expression
 WHEN valeur1 THEN instructions
 WHEN valeur2 THEN instructions
 ELSE instructions_par_defaut
END CASE;
```

#### b) Boucles : LOOP, WHILE, REPEAT

- **LOOP** :

```sql
nom_boucle: LOOP
 -- instructions
 IF condition THEN LEAVE nom_boucle; END IF;
END LOOP;
```

- **WHILE** :

```sql
nom_boucle: WHILE condition DO
 -- instructions
END WHILE;
```

- **REPEAT** :

```sql
nom_boucle: REPEAT
 -- instructions
UNTIL condition END REPEAT;
```

### 3. Création de Procédures Stockées

- **Créer une procédure** :

```sql
DELIMITER //
CREATE PROCEDURE nom_procedure()
BEGIN
 -- instructions
END //
DELIMITER ;
```

- **Exécuter une procédure** :

```sql
CALL nom_procedure();
```

- **Procédure avec Paramètres** :

```sql
DELIMITER //
CREATE PROCEDURE AjouterEtudiant(IN nom VARCHAR(50), IN age INT)
BEGIN
 INSERT INTO etudiants (nom, age) VALUES (nom, age);
END //
DELIMITER ;
```

- **Procédure avec un paramètre de sortie** :

```sql
DELIMITER //
CREATE PROCEDURE GetNombreEtudiants(OUT total INT)
BEGIN
 SELECT COUNT(*) INTO total FROM etudiants;
END //
DELIMITER ;
```

### 4. Création de Fonctions

- **Créer une fonction** :

```sql
DELIMITER //
CREATE FUNCTION nom_fonction(param1 TYPE) RETURNS TYPE
DETERMINISTIC
BEGIN
 DECLARE resultat TYPE;
 -- Calcul du résultat
 RETURN resultat;
END //
DELIMITER ;
```

- **Appel d'une fonction** :

```sql
SELECT nom_fonction();
```

### 5. Triggers : Déclencheurs

- **Créer un trigger avant insertion** :

```sql
DELIMITER //
CREATE TRIGGER nom_trigger BEFORE INSERT ON nom_table
FOR EACH ROW
BEGIN
 -- instructions
END //
DELIMITER ;
```

- **Créer un trigger après insertion** :

```sql
DELIMITER //
CREATE TRIGGER AfterInsertEtudiant
AFTER INSERT ON etudiants
FOR EACH ROW
BEGIN
 INSERT INTO logs (action, date_log) VALUES ('Nouvel étudiant ajouté', NOW());
END //
DELIMITER ;
```

### 6. Cursors : Parcourir des résultats ligne par ligne

- **Déclaration d’un Cursor** :

```sql
DECLARE nom_cursor CURSOR FOR requête;
```

- **Utilisation d’un Cursor** :

```sql
DELIMITER //
CREATE PROCEDURE ListerEtudiants()
BEGIN
 DECLARE done INT DEFAULT FALSE;
 DECLARE etu_nom VARCHAR(50);
 DECLARE cur CURSOR FOR SELECT nom FROM etudiants;
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
 OPEN cur;
 boucle: LOOP
 FETCH cur INTO etu_nom;
 IF done THEN LEAVE boucle; END IF;
 SELECT etu_nom;
 END LOOP;
 CLOSE cur;
END //
DELIMITER ;
```

### 7. Gestion des Exceptions en MySQL (Handlers et Erreurs)

- **Déclaration d'un Gestionnaire d'Exception** :

```sql
DECLARE CONTINUE HANDLER FOR condition_erreur instruction;
```

- **Exemple de Gestion des Erreurs avec CONTINUE** :

```sql
DELIMITER //
CREATE PROCEDURE AjouterEtudiant(nom VARCHAR(50), age INT)
BEGIN
 DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
 BEGIN
 SELECT 'Erreur lors de l’insertion !' AS Message;
 END;
 INSERT INTO etudiants (nom, age) VALUES (nom, age);
END //
DELIMITER ;
```

- **Exemple avec EXIT pour Stopper l'Exécution** :

```sql
DELIMITER //
CREATE PROCEDURE AjouterEtudiantSafe(nom VARCHAR(50), age INT)
BEGIN
 DECLARE EXIT HANDLER FOR SQLEXCEPTION
 BEGIN
 SELECT 'Erreur critique, arrêt de la procédure !' AS Message;
 END;
 INSERT INTO etudiants (nom, age) VALUES (nom, age);
 SELECT 'Ajout réussi !' AS Message;
END //
DELIMITER ;
```

- **Gestion des Erreurs Spécifiques** :

```sql
DELIMITER //
CREATE PROCEDURE AjouterEtudiantUnique(nom VARCHAR(50), age INT)
BEGIN
 DECLARE EXIT HANDLER FOR 1062
 BEGIN
 SELECT 'Erreur : Cet étudiant existe déjà !' AS Message;
 END;
 INSERT INTO etudiants (nom, age) VALUES (nom, age);
END //
DELIMITER ;
```

- **Gestion des Erreurs dans une Boucle** :

```sql
DELIMITER //
CREATE PROCEDURE BoucleEtudiants()
BEGIN
 DECLARE i INT DEFAULT 1;
 DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
 BEGIN
 SELECT CONCAT('Erreur lors de l’insertion de l’étudiant ', i) AS Message;
 END;
 boucle: WHILE i <= 5 DO
 INSERT INTO etudiants (nom, age) VALUES (CONCAT('Etudiant', i), 20);
 SET i = i + 1;
 END WHILE;
END //
DELIMITER ;
```

- **Gestion des Erreurs avec NOT FOUND (Pour les Cursors)** :

```sql
DELIMITER //
CREATE PROCEDURE ListerEtudiants()
BEGIN
 DECLARE done INT DEFAULT FALSE;
 DECLARE etu_nom VARCHAR(50);
 DECLARE cur CURSOR FOR SELECT nom FROM etudiants;
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
 OPEN cur;
 boucle: LOOP
 FETCH cur INTO etu_nom;
 IF done THEN LEAVE boucle; END IF;
 SELECT etu_nom;
 END LOOP;
 CLOSE cur;
END //
DELIMITER ;
```

## Syntaxes MySQL : Exercices

### Exercice 1 : Insérer 10 employés avec une boucle WHILE

```sql
DELIMITER //
CREATE PROCEDURE InsererEmployes()
BEGIN
 DECLARE i INT DEFAULT 1;
 WHILE i <= 10 DO
 INSERT INTO employe (nom, adresse, dateEmbauche, nbEnfants)
 VALUES (CONCAT('Employe', i), 'Adresse', CURDATE(), FLOOR(RAND() * 4));
 SET i = i + 1;
 END WHILE;
END //
DELIMITER ;
```

### Exercice 2 : Lister les employés avec un CURSOR

```sql
DELIMITER //
CREATE PROCEDURE ListerEmployes()
BEGIN
 DECLARE done INT DEFAULT FALSE;
 DECLARE emp_nom VARCHAR(100);
 DECLARE cur CURSOR FOR SELECT nom FROM employe;
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
 OPEN cur;
 boucle: LOOP
 FETCH cur INTO emp_nom;
 IF done THEN LEAVE boucle; END IF;
 SELECT emp_nom;
 END LOOP;
 CLOSE cur;
END //
DELIMITER ;
```

### Exercice 3 : Augmenter le nombre d’enfants des employés avec un LOOP

```sql
DELIMITER //
CREATE PROCEDURE AugmenterNbEnfants()
BEGIN
 DECLARE done INT DEFAULT FALSE;
 DECLARE emp_id INT;
 DECLARE emp_nbEnfants INT;
 DECLARE cur CURSOR FOR SELECT num, nbEnfants FROM employe WHERE nbEnfants < 2;
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
 OPEN cur;
 boucle: LOOP
 FETCH cur INTO emp_id, emp_nbEnfants;
 IF done THEN LEAVE boucle; END IF;
 UPDATE employe SET nbEnfants = nbEnfants + 1 WHERE num = emp_id;
 END LOOP;
 CLOSE cur;
END //
DELIMITER ;
```

### Exercice 4 : Supprimer les employés embauchés avant une certaine date

```sql
DELIMITER //
CREATE PROCEDURE SupprimerAnciensEmployes()
BEGIN
 DELETE FROM employe WHERE dateEmbauche < '2020-01-01';
END //
DELIMITER ;
```

### Exercice 5 : Générer une prime en fonction du nombre d’enfants

```sql
DELIMITER //
CREATE PROCEDURE CalculerPrime()
BEGIN
 SELECT nom, nbEnfants, 100 * nbEnfants AS prime FROM employe;
END //
DELIMITER ;
```

### Exercice 6 : Ajouter une colonne salaire et l'initialiser avec une boucle

```sql
ALTER TABLE employe ADD COLUMN salaire INT;

DELIMITER //
CREATE PROCEDURE InitialiserSalaires()
BEGIN
 DECLARE done INT DEFAULT FALSE;
 DECLARE emp_id INT;
 DECLARE emp_nbEnfants INT;
 DECLARE cur CURSOR FOR SELECT num, nbEnfants FROM employe;
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
 OPEN cur;
 boucle: LOOP
 FETCH cur INTO emp_id, emp_nbEnfants;
 IF done THEN LEAVE boucle; END IF;
 UPDATE employe SET salaire = 3000 + (500 * emp_nbEnfants) WHERE num = emp_id;
 END LOOP;
 CLOSE cur;
END //
DELIMITER ;
```

### Exercice 7 : Augmenter les salaires avec une boucle WHILE

```sql
DELIMITER //
CREATE PROCEDURE AugmenterSalaires()
BEGIN
 DECLARE done INT DEFAULT FALSE;
 DECLARE emp_id INT;
 DECLARE emp_salaire INT;
 DECLARE cur CURSOR FOR SELECT num, salaire FROM employe;
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
 OPEN cur;
 boucle: LOOP
 FETCH cur INTO emp_id, emp_salaire;
 IF done THEN LEAVE boucle; END IF;
 UPDATE employe SET salaire = salaire * 1.10 WHERE num = emp_id;
 END LOOP;
 CLOSE cur;
END //
DELIMITER ;
```

### Exercice 8 : Vérifier si un employé existe avant de l'ajouter

```sql
DELIMITER //
CREATE PROCEDURE AjouterEmploye(IN p_nom VARCHAR(100), IN p_adresse VARCHAR(255), IN p_dateEmbauche DATE, IN p_nbEnfants INT)
BEGIN
 DECLARE emp_count INT;
 SELECT COUNT(*) INTO emp_count FROM employe WHERE nom = p_nom;
 IF emp_count = 0 THEN
 INSERT INTO employe (nom, adresse, dateEmbauche, nbEnfants)
 VALUES (p_nom, p_adresse, p_dateEmbauche, p_nbEnfants);
 ELSE
 SELECT 'Employé déjà existant !' AS Message;
 END IF;
END //
DELIMITER ;
```

### Exercice 9 : Donner un bonus aux employés embauchés avant une certaine date

```sql
DELIMITER //
CREATE PROCEDURE BonusAnciensEmployes()
BEGIN
 UPDATE employe SET salaire = salaire + 1000 WHERE dateEmbauche < '2020-01-01';
END //
DELIMITER ;
```

### Exercice 10 : Calculer le total des salaires et l'afficher

```sql
DELIMITER //
CREATE PROCEDURE TotalSalaires(OUT total INT)
BEGIN
 SELECT SUM(salaire) INTO total FROM employe;
END //
DELIMITER ;
```

### Exercice 11 : Lister les employés qui ont plus d'enfants que la moyenne

```sql
DELIMITER //
CREATE PROCEDURE EmployesNbEnfantsSupMoyenne()
BEGIN
 SELECT nom, nbEnfants FROM employe
 WHERE nbEnfants > (SELECT AVG(nbEnfants) FROM employe);
END //
DELIMITER ;
```

### Exercice 12 : Supprimer les employés sans enfants avec une boucle

```sql
DELIMITER //
CREATE PROCEDURE SupprimerEmployesSansEnfants()
BEGIN
 DELETE FROM employe WHERE nbEnfants = 0;
END //
DELIMITER ;
```

## Conclusion

Les fonctions, triggers, et procédures stockées en MySQL sont des outils puissants pour manipuler et automatiser les opérations sur les données. Les fonctions permettent de simplifier les calculs et les transformations de données, tandis que les triggers automatisent les actions en réponse à des événements spécifiques. Les procédures stockées offrent une manière structurée d'encapsuler des opérations complexes, ce qui facilite la maintenance et la réutilisation du code.