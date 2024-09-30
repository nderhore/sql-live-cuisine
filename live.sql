DROP TABLE IF EXISTS Ingredient_Recette;
DROP TABLE IF EXISTS Commande_Recette;
DROP TABLE IF EXISTS Ingredient;
DROP TABLE IF EXISTS Recette;
DROP TABLE IF EXISTS Stock;

#### 1. Creation des tables
CREATE TABLE IF NOT EXISTS Ingredient(
    ingredient_id INT AUTO_INCREMENT PRIMARY KEY,
    quantite INT NOT NULL,
    nom VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS Recette(
    recette_id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    instruction VARCHAR(255) NOT NULL,
    prix FLOAT
);

CREATE TABLE IF NOT EXISTS Commande(
    commande_id INT AUTO_INCREMENT PRIMARY KEY,
    date_commande DATETIME
);

CREATE TABLE IF NOT EXISTS Ingredient_Recette(
    ingredient_id INT,
    recette_id INT,
    quantite FLOAT,
    unit VARCHAR(2),
    FOREIGN KEY (ingredient_id) REFERENCES Ingredient(ingredient_id),
    FOREIGN KEY (recette_id) REFERENCES Recette(recette_id),
    PRIMARY KEY (ingredient_id,recette_id)
);

CREATE TABLE IF NOT EXISTS Commande_Recette(
    recette_id INT,
    commande_id INT,
    quantite INT,
    FOREIGN KEY (recette_id) REFERENCES Recette(recette_id),
    FOREIGN KEY (commande_id) REFERENCES Commande(commande_id),
    PRIMARY KEY (recette_id,commande_id)
);

CREATE TABLE IF NOT EXISTS Stock(
    ingredient_id INT PRIMARY KEY,
    quantite_disponible FLOAT,
    FOREIGN KEY (ingredient_id) REFERENCES Ingredient(ingredient_id)
);


-- Insérer des données dans la table Ingredient
INSERT INTO Ingredient (quantite, nom) VALUES
(1000, 'Farine'),
(500, 'Sucre'),
(200, 'Oeufs'),
(300, 'Lait'),
(250, 'Beurre'),
(100, 'Sel'),
(150, 'Levure'),
(400, 'Chocolat'),
(1000, 'pomme de terre');

-- Insérer des données dans la table Recette
INSERT INTO Recette (nom, instruction, prix) VALUES
('Gâteau', 'Mélanger les ingrédients et cuire au four', 5.00),
('Pain', 'Pétrir la pâte et cuire au four', 2.50),
('Gâteau au Chocolat', 'Ajouter du chocolat et cuire au four', 6.00),
('Crêpes', 'Mélanger et cuire à la poêle', 3.00),
('Cookies', 'Mélanger et cuire au four', 4.00),
('Frites', 'Coupez et mettez dans la friteuse avec du gras de boeuf', 1.00);

-- Insérer des données dans la table Commande
INSERT INTO Commande (date_commande) VALUES
('2024-10-01 10:00:00'),
('2024-10-02 12:30:00'),
('2024-10-03 15:45:00'),
('2024-10-04 11:15:00'),
('2024-10-05 14:00:00');

-- Insérer des données dans la table Ingredient_Recette
INSERT INTO Ingredient_Recette (ingredient_id, recette_id, quantite, unit) VALUES
(1, 1, 200, 'g'),   -- Farine pour Gâteau
(2, 1, 100, 'g'),   -- Sucre pour Gâteau
(3, 1, 2, 'pc'),    -- Oeufs pour Gâteau
(5, 1, 50, 'g'),    -- Beurre pour Gâteau
(4, 1, 100, 'ml'),  -- Lait pour Gâteau

(1, 2, 300, 'g'),   -- Farine pour Pain
(7, 2, 5, 'g'),     -- Levure pour Pain
(6, 2, 5, 'g'),     -- Sel pour Pain

(1, 3, 200, 'g'),   -- Farine pour Gâteau au Chocolat
(2, 3, 100, 'g'),   -- Sucre pour Gâteau au Chocolat
(3, 3, 2, 'pc'),    -- Oeufs pour Gâteau au Chocolat
(5, 3, 50, 'g'),    -- Beurre pour Gâteau au Chocolat
(4, 3, 100, 'ml'),  -- Lait pour Gâteau au Chocolat
(8, 3, 100, 'g'),   -- Chocolat pour Gâteau au Chocolat

(1, 4, 150, 'g'),   -- Farine pour Crêpes
(4, 4, 200, 'ml'),  -- Lait pour Crêpes
(3, 4, 2, 'pc'),    -- Oeufs pour Crêpes
(2, 4, 50, 'g'),    -- Sucre pour Crêpes

(1, 5, 200, 'g'),   -- Farine pour Cookies
(2, 5, 100, 'g'),   -- Sucre pour Cookies
(5, 5, 100, 'g'),   -- Beurre pour Cookies
(8, 5, 50, 'g');    -- Chocolat pour Cookies

-- Insérer des données dans la table Commande_Recette
INSERT INTO Commande_Recette (recette_id, commande_id, quantite) VALUES
(1, 1, 2),  -- 2 Gâteaux dans la Commande 1
(2, 1, 1),  -- 1 Pain dans la Commande 1

(3, 2, 1),  -- 1 Gâteau au Chocolat dans la Commande 2

(4, 3, 3),  -- 3 Crêpes dans la Commande 3

(5, 4, 2),  -- 2 Cookies dans la Commande 4
(2, 4, 1),  -- 1 Pain dans la Commande 4

(1, 5, 1),  -- 1 Gâteau dans la Commande 5
(4, 5, 2);  -- 2 Crêpes dans la Commande 5

SELECT * FROM Ingredient_Recette;
SELECT * FROM Ingredient;

# je veux afficher le nombre d'ingrédient, par recette
SELECT Recette.nom , Ingredient.nom, Ingredient_Recette.quantite, Ingredient_Recette.unit
FROM Ingredient_Recette
JOIN Ingredient on Ingredient.ingredient_id = Ingredient_Recette.ingredient_id #2
JOIN Recette on Recette.recette_id = Ingredient_Recette.recette_id #2
ORDER BY Recette.nom;

SELECT Recette.nom, COUNT(*) as nb_ingredient
FROM Ingredient_Recette
JOIN Ingredient on Ingredient.ingredient_id = Ingredient_Recette.ingredient_id #2
JOIN Recette on Recette.recette_id = Ingredient_Recette.recette_id #2
GROUP BY Recette.nom;

SELECT * FROM Commande_Recette;

#calculer le prix total par commande
#1. ou sont stockés les prix ? Recette => Jointure
#2. =SOMME(prix de la recette * quantite)
SELECT cr.commande_id AS id_commande,
       SUM(r.prix * cr.quantite) AS prix_commande
FROM Commande_Recette cr
INNER JOIN Recette r ON cr.recette_id = r.recette_id
GROUP BY cr.commande_id;

#Quantite total commandé pour chaque recette
#Nom de la recette , quantite total commandé
SELECT r.nom, SUM (cr.quantite) AS 'nb_commander'
FROM Commande_Recette cr
INNER JOIN Recette r ON cr.recette_id = r.recette_id
group by r.recette_id;

# Total des ventes par recette
# nom de la recette , total des ventes ( euros)
EXPLAIN SELECT r.nom, SUM(cr.quantite * r.prix) AS 'nb_prix_total'
FROM Commande_Recette cr
INNER JOIN Recette r ON cr.recette_id = r.recette_id
group by r.recette_id;

SELECT * FROM Recette;

# je veux mettre à jour tous les prix, je veux rajouter 10%
UPDATE Recette SET prix=prix*1.1;

# je veux le prix moyen des recettes
SELECT AVG(prix) AS 'prix moyen des recettes'
FROM Recette;

# je veux les recettes dont le prix est supérieur à 5 euros
EXPLAIN SELECT * FROM Recette WHERE prix > 5;

# Index
CREATE INDEX idx_prix ON Recette(prix);


# Transaction : tout ou rien

## Un client souhaite commander 2 unités de Gateau au chocolat et 1 unité de Pain
    # => Pour chaque ingrédients nécessaire aux recettes commandées, déduire la quantité du stock

SELECT * FROM Commande;

BEGIN;
DROP TEMPORARY TABLE IF EXISTS tmp_ing_quantite;

#1. Insertion de la commande et récupération de mon ID
INSERT INTO Commande(date_commande) VALUES (NOW());
SET @commande_id = LAST_INSERT_ID();

#2. Inserer les recettes commandées
INSERT INTO Commande_Recette(commande_id,recette_id,quantite) VALUES
                                                                  (@commande_id,3,2), -- 2 Gateaux au chocolat
                                                                  (@commande_id,2,1); -- 1 Pain
#3. Calcul des ingrédients necessaire
CREATE TEMPORARY TABLE tmp_ing_quantite AS
SELECT ir.ingredient_id, SUM(ir.quantite * CR.quantite) AS quantite_necessaire
FROM Ingredient_Recette ir
JOIN Commande_Recette CR
WHERE commande_id = @commande_id
GROUP BY ir.ingredient_id;

#4. Verification du stock : rechercher les ingrédients dont le stock est insuffisant
SELECT tiq.ingredient_id
FROM tmp_ing_quantite tiq
JOIN Stock s ON s.ingredient_id = tiq.ingredient_id
WHERE s.quantite_disponible >= tiq.quantite_necessaire;

COMMIT;

SELECT * FROM Commande;

CREATE VIEW view_recette AS SELECT * FROM Recette;
SELECT * FROM view_recette;
UPDATE view_recette SET prix = prix+1;
SELECT * FROM view_recette;

UPDATE Recette SET prix = prix+1;
SELECT * FROM Recette;




