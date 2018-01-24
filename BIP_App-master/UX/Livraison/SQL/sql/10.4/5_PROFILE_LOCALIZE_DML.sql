/*
 * 
 * New Error messages for PROFIL_LOCALIZE
 * */

set define off;
Insert into MESSAGE (ID_MSG,LIMSG) values (21310,'Aucun Profil Localis� ne correspond � vos crit�res');
Insert into MESSAGE (ID_MSG,LIMSG) values (21311,'Ce code existe d�j� comme Profil de FI ou Profil DomFonc : veuillez en choisir un autre !');
Insert into MESSAGE (ID_MSG,LIMSG) values (21312,'Ce Profil Localis� avec cette date d''effet existe d�j�!');
Insert into MESSAGE (ID_MSG,LIMSG) values (21313,'Ce code existe d�j� : veuillez en choisir un autre !');
Insert into MESSAGE (ID_MSG,LIMSG) values (21314,'Le Profil Localis� avec la date d''effet indiqu�e n''existe pas : veuillez corriger');
Insert into MESSAGE (ID_MSG,LIMSG) values (21315,'Code Profil Localize : %s1 -- Libell� : %s2 -- Date effet : %s3');
Insert into MESSAGE (ID_MSG,LIMSG) values (21316,'La r�f�rence de demande est absente, inexistante ou incompatible avec la ligne');
Insert into MESSAGE (ID_MSG,LIMSG) values (21317,'Profil Localis� %s1 avec date d''effet %s2 supprim�');
Insert into MESSAGE (ID_MSG,LIMSG) values (21318,'Profil Localis� %s1 avec date d''effet %s2 cr��');
Insert into MESSAGE (ID_MSG,LIMSG) values (21319,'Profil Localis� %s1 avec date d''effet %s2 modifi�');
Insert into MESSAGE (ID_MSG,LIMSG) values (21320,'Ce code existe d�j� comme un autre type de Profil pour la FI: veuillez en choisir un autre');
Insert into MESSAGE (ID_MSG,LIMSG) values (21321,'Un profil Localize par d�faut existe d�j� pour la date d''effet %s1 et la Direction %s2');

COMMIT;