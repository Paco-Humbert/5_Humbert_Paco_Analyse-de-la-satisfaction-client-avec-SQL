# Analyse de la satisfaction client — SQL & SQLite

**Projet 5 — Parcours Business Intelligence Analyst | OpenClassrooms**

## Présentation

Ce projet porte sur l'analyse des retours clients de **BestMarket**, une entreprise fictive utilisée dans le cadre de la formation OpenClassrooms.

L'objectif est de structurer et d'exploiter les données de satisfaction client afin de fournir au service client et à la direction des indicateurs fiables pour orienter leurs décisions.

L'étude repose sur l'utilisation de SQL, d'une base relationnelle SQLite et de méthodes de contrôle de la qualité des données.

## Objectifs métier

- Centraliser les retours clients issus de différents canaux.
- Contrôler la cohérence et la qualité des données.
- Analyser les notes et les recommandations des clients.
- Comparer la satisfaction selon les magasins, les produits et les sources de feedback.
- Calculer et suivre le Net Promoter Score (NPS).
- Proposer des axes d'amélioration de l'expérience client.

## Technologies et méthodes

| Technologie / méthode | Utilisation |
|---|---|
| SQL | Requêtes, jointures, agrégations et calculs d'indicateurs |
| SQLite | Stockage et interrogation des données relationnelles |
| Contrôles qualité | Détection des doublons, valeurs manquantes et incohérences |
| Modélisation relationnelle | Organisation des tables et relations |
| Excel | Dictionnaire de données |
| PowerPoint | Restitution des analyses et recommandations |

## Modèle de données

La base de données s'organise autour de trois tables principales :

- `retour_client` : informations relatives aux avis et retours clients.
- `produit` : référentiel des produits.
- `ref_magasin` : référentiel des magasins.

Le schéma relationnel est disponible dans le dossier `documentation`.

## Travaux réalisés

### 1. Analyse des besoins

Formalisation des attentes du service client et de la direction à travers un document d'expression des besoins.

Définition des indicateurs attendus et des exigences de qualité.

### 2. Structuration et documentation

Étude du modèle relationnel, des tables, de leurs relations et des champs nécessaires à l'analyse.

Production d'un dictionnaire de données et d'un schéma de la base.

### 3. Contrôle de la qualité des données

Travail sur les contrôles suivants :

- Recherche des doublons.
- Identification des valeurs NULL.
- Vérification des incohérences.
- Contrôle des relations entre les tables et des clés étrangères orphelines.

### 4. Analyses SQL et indicateurs métier

Les analyses portent notamment sur :

- La répartition des retours clients par source.
- Les notes moyennes par magasin.
- La comparaison des catégories et typologies de produits.
- La satisfaction liée au service après-vente.
- Le NPS global et par source.

**Règle de calcul du NPS :**

NPS = % de promoteurs − % de détracteurs

- Promoteurs : notes de 9 à 10.
- Passifs : notes de 7 à 8.
- Détracteurs : notes de 0 à 6.

### 5. Restitution des résultats

Présentation des résultats et formulation de recommandations métier :

- Renforcer le suivi du service après-vente.
- Surveiller les magasins dont la satisfaction est inférieure à la moyenne.
- Mettre en place un suivi mensuel du NPS.
- Développer des actions de fidélisation ciblées.

## Livrables

Le dépôt regroupe les scripts SQL, le modèle de données et les documents associés au projet.

| Livrable | Objectif |
|---|---|
| Expression des besoins | Formaliser les attentes métier |
| Base et scripts SQL | Structurer et analyser les données |
| Dictionnaire de données | Documenter les champs et leur utilisation |
| Schéma relationnel | Comprendre l'organisation des données |
| Présentation finale | Restituer les analyses et recommandations |

## Compétences développées

**Business Intelligence :** analyse des besoins, indicateurs métier, NPS, restitution décisionnelle.

**SQL et gestion des données :** interrogation de bases relationnelles, jointures, agrégations, vérifications de cohérence.

**Qualité et documentation :** contrôle des données, schéma relationnel et dictionnaire de données.

## Limites et perspectives

Ce projet est une étude réalisée dans un cadre pédagogique.

Les améliorations envisageables comprennent :

- L'automatisation des contrôles qualité.
- L'ajout de tests reproductibles.
- La mise en place de tableaux de bord interactifs.
- La création d'un pipeline d'intégration des données.

Ces évolutions constituent des perspectives techniques et ne sont pas présentées comme déjà réalisées.

---

**Projet académique réalisé dans le cadre du parcours Business Intelligence Analyst d'OpenClassrooms.**

