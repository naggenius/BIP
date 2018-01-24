-- APPLICATION ISAC
-- -------------------------------------
-- Création des messages d'erreur
-- -------------------------------------
DELETE ISAC_MESSAGE
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20001, 'Vous ne pouvez pas modifier le numéro d''%s1 qui existe déjà.')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20002, '%s1 supprimée')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20003, 'Mauvaise clé pour la ligne BIP %s1')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20004, 'La sous-tâche a déjà été affectée à cette ressource')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20005, 'Aucune sous-tâche pour cette ressource')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20006, 'Une seule étape ES pour ce projet de type ABSENCE')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20007, 'Etape ES obligatoire pour ce projet de type ABSENCE')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20008, 'Une seule étape %s1 pour la ligne BIP %s2')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20009, 'Choisissez un autre type d''étape ')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20010, 'Type de sous-tâche incorrect pour la ligne BIP.\n Entrez un autre type de sous-tâche')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20011, 'Le code %s1 n''est pas un code ligne BIP.\n Entrez un autre type de sous-tâche')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20012, 'La sous-tâche %s1 a été affectée à la ressource %s2')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20013, 'Code chef de pojet %s1 inexistant')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20014, 'Définir la structure de la ligne BIP avant de procéder à l''affectation')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20015, '99 étapes maximum par ligne BIP')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20016, '99 tâches maximum par étape')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20017, '99 sous-tâches maximum par tâche')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20018, 'La structure de la ligne %s1 n''est pas vide. Opération annulée')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20019, 'Sous-traitance interdite : la ligne %s1 est fermée depuis plus d''un mois')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20020, 'Modification interdite : la ligne %s1 est fermée depuis plus d''un mois')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20021, 'Suppression interdite : la ligne %s1 est fermée depuis plus d''un mois')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20022, 'Modification interdite : la tâche contient une sous-tâche pointant vers une ligne fermée')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20023, 'Modification interdite : l''étape contient une sous-tâche pointant vers une ligne fermée')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20024, 'Suppression interdite : la tâche contient une sous-tâche pointant vers une ligne fermée')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20025, 'Suppression interdite : l''étape contient une sous-tâche pointant vers une ligne fermée')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20026, 'Suppression d''affectation à la sous-tâche de type FF%s1 impossible :\n la ligne %s1 est fermée depuis plus d''un mois')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20027, 'Suppression d''affectation à la sous-tâche impossible :\n la ligne %s1 est fermée depuis plus d''un mois')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20028, 'Suppression interdite : la sous-tâche contient du consommé.\n Il faut d''abord supprimer le consommé')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20029, 'Suppression interdite : la tâche contient une sous-tâche avec du consommé.\n Il faut d''abord supprimer le consommé')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20030, 'Suppression interdite : l''étape contient une sous-tâche avec du consommé.\n Il faut d''abord supprimer le consommé')
/
INSERT INTO ISAC_MESSAGE (ID_MSG, LIMSG)
VALUES( 20031, 'Suppression d''affectation à la sous-tâche impossible : il y a du consommé sur l''année courante')
/
COMMIT
/
SELECT COUNT(*) FROM ISAC_MESSAGE
/


