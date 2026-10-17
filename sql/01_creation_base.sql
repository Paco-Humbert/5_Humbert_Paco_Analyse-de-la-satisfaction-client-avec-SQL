-- P5 BestMarket | 01 - Création de la structure SQLite
-- Schéma issu de CustomerDataFeedback.db (types et colonnes d'origine).
-- Non destructif : aucune suppression ni insertion de données.
-- À utiliser sur une nouvelle base vide ; ne remplace pas le script
-- CustomerDataFeedback.sql (chargement complet des données).

CREATE TABLE IF NOT EXISTS produit (cle_produit INT PRIMARY KEY, typologie_produit CHAR (50), titre_produit CHAR (50));

CREATE TABLE IF NOT EXISTS retour_client (cle_retour_client INT PRIMARY KEY, note INT, cle_produit INT, ref_magasin INT, date_achat DATE, libelle_source CHAR (50), libelle_categorie CHAR (50), recommandation CHAR);

CREATE TABLE IF NOT EXISTS ref_magasin (
    ref_magasin INTEGER PRIMARY KEY,
    departement CHAR(3),
    departement_commune INTEGER,
    libelle_de_commune CHAR(50),
    population INTEGER,
    geo_point_2d CHAR(100)
);

