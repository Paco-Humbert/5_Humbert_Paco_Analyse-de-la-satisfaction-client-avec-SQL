
-- P5 BestMarket | 02 - Contrôles qualité
-- Projet OpenClassrooms BI Analyst
-- Toutes les requêtes sont en lecture seule.

-- =====================================================
-- 1. Vérification de la structure des tables
-- =====================================================

PRAGMA table_info(produit);
PRAGMA table_info(retour_client);
PRAGMA table_info(ref_magasin);

-- =====================================================
-- 2. Volumétrie des tables
-- =====================================================

SELECT 'produit' AS nom_table,
       COUNT(*) AS nb_lignes
FROM produit

UNION ALL

SELECT 'retour_client',
       COUNT(*)
FROM retour_client

UNION ALL

SELECT 'ref_magasin',
       COUNT(*)
FROM ref_magasin;

-- =====================================================
-- 3. Détection des doublons sur les identifiants
-- Résultat attendu : aucune ligne
-- =====================================================

SELECT cle_retour_client,
       COUNT(*) AS occurrences
FROM retour_client
GROUP BY cle_retour_client
HAVING COUNT(*) > 1;

SELECT cle_produit,
       COUNT(*) AS occurrences
FROM produit
GROUP BY cle_produit
HAVING COUNT(*) > 1;

SELECT ref_magasin,
       COUNT(*) AS occurrences
FROM ref_magasin
GROUP BY ref_magasin
HAVING COUNT(*) > 1;

-- =====================================================
-- 4. Recherche des valeurs NULL
-- =====================================================

SELECT *
FROM retour_client
WHERE cle_produit IS NULL
   OR ref_magasin IS NULL
   OR note IS NULL;

SELECT *
FROM produit
WHERE cle_produit IS NULL;

SELECT *
FROM ref_magasin
WHERE ref_magasin IS NULL;

-- =====================================================
-- 5. Vérification des références orphelines
-- =====================================================

-- Retours associés à un produit absent du référentiel
SELECT rc.*
FROM retour_client AS rc
LEFT JOIN produit AS p
    ON rc.cle_produit = p.cle_produit
WHERE p.cle_produit IS NULL;

-- Retours associés à un magasin absent du référentiel
SELECT rc.*
FROM retour_client AS rc
LEFT JOIN ref_magasin AS rm
    ON rc.ref_magasin = rm.ref_magasin
WHERE rm.ref_magasin IS NULL;

-- =====================================================
-- 6. Validation des notes de satisfaction
-- Les notes doivent être comprises entre 0 et 10.
-- =====================================================

SELECT *
FROM retour_client
WHERE note < 0
   OR note > 10;

-- =====================================================
-- 7. Contrôle du codage des recommandations
-- Vérifier la présence des valeurs 0 et 1.
-- =====================================================

SELECT recommandation,
       COUNT(*) AS nb_retours
FROM retour_client
GROUP BY recommandation
ORDER BY recommandation;
