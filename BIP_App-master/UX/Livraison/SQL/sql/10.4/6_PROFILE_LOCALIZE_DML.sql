/*
 * 
 * Bug fix for BIP-295
 * */


UPDATE MESSAGE SET LIMSG  ='Code Profil Localisé : %s1 -- Libellé : %s2 -- Date effet : %s3' WHERE ID_MSG = '21315';
UPDATE MESSAGE SET LIMSG  ='Un Profil localisé par défaut existe déjà pour la date d''effet %s1 et la Direction %s2' WHERE ID_MSG = '21321';
COMMIT;