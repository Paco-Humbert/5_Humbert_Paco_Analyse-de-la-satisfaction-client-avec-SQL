
-- P5 BestMarket | 03 - Analyses métier
-- Analyse de la satisfaction client avec SQLite
-- Requêtes Q1 à Q17 du projet OpenClassrooms
-- Toutes les requêtes sont en lecture seule.

-- =====================================================
-- Q1. Catégories de retours et volume livraison
-- =====================================================

SELECT DISTINCT libelle_categorie
FROM retour_client
ORDER BY libelle_categorie;

SELECT COUNT(*) AS nb_livraisons
FROM retour_client
WHERE libelle_categorie = 'livraison';


-- =====================================================
-- Q2. Notes des produits TV provenant des réseaux sociaux
-- =====================================================

SELECT rc.note AS note_client
FROM retour_client AS rc
JOIN produit AS p
    ON rc.cle_produit = p.cle_produit
WHERE rc.libelle_source = 'réseaux sociaux'
  AND p.titre_produit = 'TV'
ORDER BY note_client DESC;


-- =====================================================
-- Q3. Note moyenne par typologie de produit
-- =====================================================

SELECT
    p.typologie_produit,
    ROUND(AVG(rc.note), 2) AS note_moyenne
FROM retour_client AS rc
JOIN produit AS p
    ON rc.cle_produit = p.cle_produit
GROUP BY p.typologie_produit
ORDER BY note_moyenne DESC;


-- =====================================================
-- Q4. Top 5 des magasins selon la note moyenne
-- =====================================================

SELECT
    r.ref_magasin,
    m.libelle_de_commune,
    ROUND(AVG(r.note), 2) AS note_moyenne
FROM retour_client AS r
JOIN ref_magasin AS m
    ON r.ref_magasin = m.ref_magasin
GROUP BY
    r.ref_magasin,
    m.libelle_de_commune
ORDER BY note_moyenne DESC
LIMIT 5;


-- =====================================================
-- Q5. Magasins avec plus de 12 retours drive
-- =====================================================

SELECT
    r.ref_magasin,
    m.libelle_de_commune,
    COUNT(*) AS nb_feedback
FROM retour_client AS r
JOIN ref_magasin AS m
    ON r.ref_magasin = m.ref_magasin
WHERE r.libelle_categorie = 'drive'
GROUP BY
    r.ref_magasin,
    m.libelle_de_commune
HAVING COUNT(*) > 12;


-- =====================================================
-- Q6. Satisfaction moyenne par département
-- =====================================================

SELECT
    m.departement,
    ROUND(AVG(r.note), 2) AS note_moyenne
FROM retour_client AS r
JOIN ref_magasin AS m
    ON r.ref_magasin = m.ref_magasin
GROUP BY m.departement
ORDER BY note_moyenne DESC;


-- =====================================================
-- Q7. Satisfaction SAV par typologie de produit
-- =====================================================

SELECT
    p.typologie_produit,
    ROUND(AVG(r.note), 2) AS note_moyenne_sav
FROM retour_client AS r
JOIN produit AS p
    ON r.cle_produit = p.cle_produit
WHERE r.libelle_categorie = 'service après-vente'
GROUP BY p.typologie_produit
ORDER BY note_moyenne_sav DESC;


-- =====================================================
-- Q8. Note moyenne des produits Boissons
-- =====================================================

SELECT
    ROUND(AVG(r.note), 2) AS note_moyenne_boissons
FROM retour_client AS r
JOIN produit AS p
    ON r.cle_produit = p.cle_produit
WHERE p.titre_produit LIKE '%Boissons%';


-- =====================================================
-- Q9. Satisfaction selon le jour de la semaine
-- Catégorie : expérience en magasin
-- =====================================================

SELECT
    CASE strftime('%w', date_achat)
        WHEN '0' THEN 'Dimanche'
        WHEN '1' THEN 'Lundi'
        WHEN '2' THEN 'Mardi'
        WHEN '3' THEN 'Mercredi'
        WHEN '4' THEN 'Jeudi'
        WHEN '5' THEN 'Vendredi'
        WHEN '6' THEN 'Samedi'
    END AS jour,
    ROUND(AVG(note), 2) AS note_moyenne
FROM retour_client
WHERE libelle_categorie = 'expérience en magasin'
GROUP BY strftime('%w', date_achat)
ORDER BY note_moyenne DESC;


-- =====================================================
-- Q10. Évolution mensuelle du volume des retours SAV
-- =====================================================

SELECT
    strftime('%Y-%m', date_achat) AS mois,
    COUNT(*) AS nb_retours
FROM retour_client
WHERE libelle_categorie = 'service après-vente'
GROUP BY strftime('%Y-%m', date_achat)
ORDER BY nb_retours DESC;

-- Variante : mois ayant le plus grand volume de retours.
-- Il ne s'agit pas nécessairement du mois le plus récent.

SELECT
    strftime('%Y-%m', date_achat) AS mois,
    COUNT(*) AS nb_retours
FROM retour_client
WHERE libelle_categorie = 'service après-vente'
GROUP BY strftime('%Y-%m', date_achat)
ORDER BY nb_retours DESC
LIMIT 1;


-- =====================================================
-- Q11. Calcul du taux de recommandation
-- La valeur 1 représente une recommandation positive.
-- =====================================================

SELECT
    ROUND(
        100.0 * SUM(
            CASE
                WHEN recommandation = '1' THEN 1
                ELSE 0
            END
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS taux_recommandation
FROM retour_client;


-- =====================================================
-- Q12. Magasins sous la moyenne générale
-- =====================================================

SELECT
    r.ref_magasin,
    m.libelle_de_commune,
    ROUND(AVG(r.note), 2) AS note_moyenne_magasin
FROM retour_client AS r
JOIN ref_magasin AS m
    ON r.ref_magasin = m.ref_magasin
GROUP BY
    r.ref_magasin,
    m.libelle_de_commune
HAVING AVG(r.note) < (
    SELECT AVG(note)
    FROM retour_client
);


-- =====================================================
-- Q13. Typologies en progression entre T1 et T2 2021
-- =====================================================

SELECT
    p.typologie_produit,

    ROUND(AVG(
        CASE
            WHEN strftime('%m', r.date_achat)
                 IN ('01', '02', '03')
            THEN r.note
        END
    ), 2) AS moyenne_T1,

    ROUND(AVG(
        CASE
            WHEN strftime('%m', r.date_achat)
                 IN ('04', '05', '06')
            THEN r.note
        END
    ), 2) AS moyenne_T2

FROM retour_client AS r
JOIN produit AS p
    ON r.cle_produit = p.cle_produit
WHERE strftime('%Y', r.date_achat) = '2021'
GROUP BY p.typologie_produit
HAVING moyenne_T2 > moyenne_T1;


-- =====================================================
-- Q14. Calcul du Net Promoter Score global
--
-- Promoteurs : notes 9-10
-- Passifs    : notes 7-8
-- Détracteurs: notes 0-6
--
-- NPS = % promoteurs - % détracteurs
-- =====================================================

SELECT
    ROUND(
        100.0 * SUM(
            CASE WHEN note >= 9 THEN 1 ELSE 0 END
        ) / NULLIF(COUNT(*), 0)

        -

        100.0 * SUM(
            CASE WHEN note <= 6 THEN 1 ELSE 0 END
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS NPS
FROM retour_client;


-- =====================================================
-- Q15. NPS par source de feedback
-- =====================================================

SELECT
    libelle_source,

    ROUND(
        100.0 * SUM(
            CASE WHEN note >= 9 THEN 1 ELSE 0 END
        ) / NULLIF(COUNT(*), 0)

        -

        100.0 * SUM(
            CASE WHEN note <= 6 THEN 1 ELSE 0 END
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS NPS

FROM retour_client
GROUP BY libelle_source
ORDER BY NPS DESC;


-- =====================================================
-- Q16. Répartition des retours clients par source
-- =====================================================

SELECT
    libelle_source,
    COUNT(*) AS nb_retours
FROM retour_client
GROUP BY libelle_source
ORDER BY nb_retours DESC;


-- =====================================================
-- Q17. Top 5 des magasins en volume de retours
-- =====================================================

SELECT
    r.ref_magasin,
    m.libelle_de_commune,
    COUNT(*) AS nb_feedbacks
FROM retour_client AS r
JOIN ref_magasin AS m
    ON r.ref_magasin = m.ref_magasin
GROUP BY
    r.ref_magasin,
    m.libelle_de_commune
ORDER BY nb_feedbacks DESC
LIMIT 5;
