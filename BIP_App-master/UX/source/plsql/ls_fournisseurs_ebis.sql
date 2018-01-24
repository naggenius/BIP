-- pack_liste_fournisseur_ebis PL/SQL
--
-- BPI
-- Créé le 30/04/2007
-- JAL 14/01/2008 : supression doublons dus au SIREN table AGENCE
--****************************************************************************
--
--
-- Attention le nom du package ne peut etre le nom
-- de la table...

CREATE OR REPLACE PACKAGE PACK_LISTE_FOURNISSEUR_EBIS AS


   TYPE Fournisseur_ListeViewType IS RECORD( clef				VARCHAR2(60),
					     		  	 		 libelle 			VARCHAR2(60)
                                            );
   
   TYPE fournisseurEbis_listeCurType IS REF CURSOR RETURN Fournisseur_ListeViewType;

   PROCEDURE LISTER_FOURNISSEUR_EBIS( p_soccode IN EBIS_FOURNISSEURS.SOCCODE%TYPE,
		  		                      p_curseur IN OUT fournisseurEbis_listeCurType
		  		                    );   
				
END PACK_LISTE_FOURNISSEUR_EBIS;
/




CREATE OR REPLACE PACKAGE BODY PACK_LISTE_FOURNISSEUR_EBIS AS


PROCEDURE LISTER_FOURNISSEUR_EBIS ( p_soccode IN EBIS_FOURNISSEURS.SOCCODE%TYPE,
		                            p_curseur IN OUT fournisseurEbis_listeCurType
                                  ) IS
BEGIN

     OPEN p_curseur FOR
	 	/*  SELECT 
		  		 (e.SOCCODE || ';' || 
	   			  e.PERIMETRE || ';' ||
	   			  e.REFERENTIEL || ';' ||	
	              e.CODE_FOURNISSEUR_EBIS) AS clef,
				 (rpad(e.CODE_FOURNISSEUR_EBIS, 15, ' ') || ' ' ||
	              rpad(a.SOCFLIB, 25, ' ') || ' ' ||
				  rpad(e.PERIMETRE, 5, ' ') || ' ' ||
				  rpad(e.REFERENTIEL, 5, ' ')) AS libelle_liste	
          FROM EBIS_FOURNISSEURS e, AGENCE a
          WHERE a.SOCCODE = e.SOCCODE
		  AND e.SOCCODE = p_soccode
		  AND e.SIREN = a.SIREN
		  ORDER BY e.CODE_FOURNISSEUR_EBIS ASC 
		  ;*/ 
		  
		 SELECT  
		  		 (e.SOCCODE || ';' ||
	   			  e.PERIMETRE || ';' ||
	   			  e.REFERENTIEL || ';' ||
	            		  e.CODE_FOURNISSEUR_EBIS) AS clef,
				 (RPAD(e.CODE_FOURNISSEUR_EBIS, 15, ' ') || ' ' || 
				  RPAD(e.PERIMETRE, 5, ' ') || ' ' ||
				  RPAD(e.REFERENTIEL, 5, ' ')) AS libelle_liste
	          FROM EBIS_FOURNISSEURS e 
	          WHERE  
			  e.SOCCODE = p_soccode
			  ORDER BY e.CODE_FOURNISSEUR_EBIS ASC ; 
			  

END LISTER_FOURNISSEUR_EBIS;

END PACK_LISTE_FOURNISSEUR_EBIS;
/



