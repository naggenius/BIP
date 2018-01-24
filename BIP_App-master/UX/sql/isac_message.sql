-- APPLICATION ISAC
-- -------------------------------------
-- Cr�ation des messages d'erreur
-- -------------------------------------
DELETE ISAC_MESSAGE
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20001, 'Vous ne pouvez pas modifier le num�ro d''%s1 qui existe d�j�.')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20002, '%s1 supprim�e')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20003, 'Mauvaise cl� pour la ligne BIP %s1')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20004, 'La sous-t�che a d�j� �t� affect�e � cette ressource')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20005, 'Aucune sous-t�che pour cette ressource')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20006, 'Une seule �tape ES pour ce projet de type ABSENCE')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20007, 'Etape ES obligatoire pour ce projet de type ABSENCE')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20008, 'Une seule �tape %s1 pour la ligne BIP %s2')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20009, 'Choisissez un autre type d''�tape ')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20010, 'Type de sous-t�che incorrect pour la ligne BIP.\n Entrez un autre type de sous-t�che')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20011, 'Le code %s1 n''est pas un code ligne BIP.\n Entrez un autre type de sous-t�che')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20012, 'La sous-t�che %s1 a �t� affect�e � la ressource %s2')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20013, 'Code chef de pojet %s1 inexistant')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20014, 'D�finir la structure de la ligne BIP avant de proc�der � l''affectation')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20015, '99 �tapes maximum par ligne BIP')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20016, '99 t�ches maximum par �tape')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20017, '99 sous-t�ches maximum par t�che')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20018, 'La structure de la ligne %s1 n''est pas vide. Op�ration annul�e')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20019, 'Sous-traitance interdite : la ligne %s1 est ferm�e depuis plus d''un mois')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20020, 'Modification interdite : la ligne %s1 est ferm�e depuis plus d''un mois')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20021, 'Suppression interdite : la ligne %s1 est ferm�e depuis plus d''un mois')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20022, 'Modification interdite : la t�che contient une sous-t�che pointant vers une ligne ferm�e')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20023, 'Modification interdite : l''�tape contient une sous-t�che pointant vers une ligne ferm�e')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20024, 'Suppression interdite : la t�che contient une sous-t�che pointant vers une ligne ferm�e')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20025, 'Suppression interdite : l''�tape contient une sous-t�che pointant vers une ligne ferm�e')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20026, 'Suppression d''affectation � la sous-t�che de type FF%s1 impossible :\n la ligne %s1 est ferm�e depuis plus d''un mois')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20027, 'Suppression d''affectation � la sous-t�che impossible :\n la ligne %s1 est ferm�e depuis plus d''un mois')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20028, 'Suppression interdite : la sous-t�che contient du consomm�.\n Il faut d''abord supprimer le consomm�')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20029, 'Suppression interdite : la t�che contient une sous-t�che avec du consomm�.\n Il faut d''abord supprimer le consomm�')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20030, 'Suppression interdite : l''�tape contient une sous-t�che avec du consomm�.\n Il faut d''abord supprimer le consomm�')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20031, 'Suppression d''affectation � la sous-t�che impossible : il y a du consomm� sur l''ann�e courante')
/
COMMIT
/
SELECT COUNT(*) FROM ISAC_MESSAGE
/


