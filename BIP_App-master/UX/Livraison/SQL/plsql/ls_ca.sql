-- pack_liste_CA PL/SQL
--
-- BPO
-- Créé le 23/05/2007
-- Le 17/07/2007 par BPO : Fiche 532 : Restriction d'affichage des CA uniquement facturables
-- Le 28/01/2008 par EVI : Fiche 532
-- Le 02/04/2008 par EVI : Fiche 532
--****************************************************************************
--
--
-- Attention le nom du package ne peut etre le nom
-- de la table...

CREATE OR REPLACE PACKAGE PACK_LISTE_CA AS

TYPE CentreActivite_ListeViewType IS RECORD( clef				VARCHAR2(10),
 				     		  	 		     libelle 			VARCHAR2(60)
                                            );

TYPE centreActivite_listeCurType IS REF CURSOR RETURN CentreActivite_ListeViewType;

PROCEDURE LISTER_CA(p_codcamo IN varchar,
		  			--p_codcamo IN CENTRE_ACTIVITE.CODCAMO%TYPE,
	  		        p_curseur IN OUT centreActivite_listeCurType
		  		    );

END PACK_LISTE_CA;
/


CREATE OR REPLACE PACKAGE BODY     PACK_LISTE_CA AS

PROCEDURE LISTER_CA(p_codcamo IN varchar,
		  			--p_codcamo IN CENTRE_ACTIVITE.CODCAMO%TYPE,
		  		    p_curseur IN OUT centreActivite_listeCurType
		  		    ) IS
BEGIN
    OPEN p_curseur FOR
		 /* Valeur des différents états pris par un CA :
		  0 - Entité soumise à toute facturation interne
		  1 - Entité soumise à toute facturation interne
		  2 - Entité exonérée de la FI Gestion du personnel
		  3 - Entitée exonérée de toute FI
		  4 - Entité exonérée des FI Gest Pers & Taxe Pro*/
		SELECT DISTINCT
	   	 	TO_CHAR(ca.CODCAMO, 'FM00000') CODCAMO,
	   		DECODE(ca.CODCAMO, 0, '00000 - A RENSEIGNER ...',
			(TO_CHAR(ca.CODCAMO, 'FM00000')
			 || ' - '
			 || ca.CLIBCA
			 || ' -- Etat : '
			 || NVL(TO_CHAR(ca.CDFAIN), ' '))) LIBELLE
		FROM CENTRE_ACTIVITE ca
		WHERE ca.CDATEFERM IS NULL
		AND (ca.CDFAIN IS NULL
        OR ca.CDFAIN !='3')
		ORDER BY CODCAMO;

END LISTER_CA;

END PACK_LISTE_CA;
/


