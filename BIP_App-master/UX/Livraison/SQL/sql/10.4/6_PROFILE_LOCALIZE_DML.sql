/*
 * 
 * Bug fix for BIP-295
 * */


UPDATE MESSAGE SET LIMSG  ='Code Profil Localis� : %s1 -- Libell� : %s2 -- Date effet : %s3' WHERE ID_MSG = '21315';
UPDATE MESSAGE SET LIMSG  ='Un Profil localis� par d�faut existe d�j� pour la date d''effet %s1 et la Direction %s2' WHERE ID_MSG = '21321';
COMMIT;