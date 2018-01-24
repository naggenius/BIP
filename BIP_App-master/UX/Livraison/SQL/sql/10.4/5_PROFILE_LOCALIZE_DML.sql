/*
 * 
 * New Error messages for PROFIL_LOCALIZE
 * */

set define off;
Insert into MESSAGE (ID_MSG,LIMSG) values (21310,'Aucun Profil Localisé ne correspond à vos critères');
Insert into MESSAGE (ID_MSG,LIMSG) values (21311,'Ce code existe déjà comme Profil de FI ou Profil DomFonc : veuillez en choisir un autre !');
Insert into MESSAGE (ID_MSG,LIMSG) values (21312,'Ce Profil Localisé avec cette date d''effet existe déjà!');
Insert into MESSAGE (ID_MSG,LIMSG) values (21313,'Ce code existe déjà : veuillez en choisir un autre !');
Insert into MESSAGE (ID_MSG,LIMSG) values (21314,'Le Profil Localisé avec la date d''effet indiquée n''existe pas : veuillez corriger');
Insert into MESSAGE (ID_MSG,LIMSG) values (21315,'Code Profil Localize : %s1 -- Libellé : %s2 -- Date effet : %s3');
Insert into MESSAGE (ID_MSG,LIMSG) values (21316,'La référence de demande est absente, inexistante ou incompatible avec la ligne');
Insert into MESSAGE (ID_MSG,LIMSG) values (21317,'Profil Localisé %s1 avec date d''effet %s2 supprimé');
Insert into MESSAGE (ID_MSG,LIMSG) values (21318,'Profil Localisé %s1 avec date d''effet %s2 créé');
Insert into MESSAGE (ID_MSG,LIMSG) values (21319,'Profil Localisé %s1 avec date d''effet %s2 modifié');
Insert into MESSAGE (ID_MSG,LIMSG) values (21320,'Ce code existe déjà comme un autre type de Profil pour la FI: veuillez en choisir un autre');
Insert into MESSAGE (ID_MSG,LIMSG) values (21321,'Un profil Localize par défaut existe déjà pour la date d''effet %s1 et la Direction %s2');

COMMIT;