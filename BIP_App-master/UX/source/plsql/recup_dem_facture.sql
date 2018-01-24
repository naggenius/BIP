CREATE OR REPLACE PACKAGE Pack_Recup_Dem_Facture AS
/******************************************************************************
   NAME:       PACK_DEM_REJET
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        16/10/2006             1. Created this package.
******************************************************************************/
TYPE rejet_dem_fact_ViewType IS RECORD (  NUM_CHARG    DEMAT_REJETS.NUM_CHARG%TYPE,
										  CODE_ERR     DEMAT_REJETS.CODE_ERR%TYPE,
										  EMETTEUR     DEMAT_REJETS.EMETTEUR%TYPE,
										  DATE_FIC     DEMAT_REJETS.DATE_FIC%TYPE,
										  NUMORD       DEMAT_REJETS.NUMORD%TYPE,
										  REF_SG       DEMAT_REJETS.REF_SG%TYPE,
										  SIREN        DEMAT_REJETS.SIREN%TYPE,
										  TYPFACT      DEMAT_REJETS.TYPFACT%TYPE,
										  NUMFACT      DEMAT_REJETS.NUMFACT%TYPE,
										  DATFACT      DEMAT_REJETS.DATFACT%TYPE,
										  NUMCONT      DEMAT_REJETS.NUMCONT%TYPE,
										  RIB          DEMAT_REJETS.RIB%TYPE,
										  MONTHT       DEMAT_REJETS.MONTHT%TYPE,
										  MONTTTC      DEMAT_REJETS.MONTTTC%TYPE,
										  MONTTVA      DEMAT_REJETS.MONTTVA%TYPE,
										  DATPREST1    DEMAT_REJETS.DATPREST1%TYPE,
										  NOM_PRENOM1  DEMAT_REJETS.NOM_PRENOM1%TYPE,
										  MONTHT1      DEMAT_REJETS.MONTHT1%TYPE,
										  DATPREST2    DEMAT_REJETS.DATPREST2%TYPE,
										  NOM_PRENOM2  DEMAT_REJETS.NOM_PRENOM2%TYPE,
										  MONTHT2      DEMAT_REJETS.MONTHT2%TYPE,
										  DATPREST3    DEMAT_REJETS.DATPREST3%TYPE,
										  NOM_PRENOM3  DEMAT_REJETS.NOM_PRENOM3%TYPE,
										  MONTHT3      DEMAT_REJETS.MONTHT3%TYPE,
										  DATPREST4    DEMAT_REJETS.DATPREST4%TYPE,
										  NOM_PRENOM4  DEMAT_REJETS.NOM_PRENOM4%TYPE,
										  MONTHT4      DEMAT_REJETS.MONTHT4%TYPE,
										  DATPREST5    DEMAT_REJETS.DATPREST5%TYPE,
										  NOM_PRENOM5  DEMAT_REJETS.NOM_PRENOM5%TYPE,
										  MONTHT5      DEMAT_REJETS.MONTHT5%TYPE,
										  DATPREST6    DEMAT_REJETS.DATPREST6%TYPE,
										  NOM_PRENOM6  DEMAT_REJETS.NOM_PRENOM6%TYPE,
										  MONTHT6      DEMAT_REJETS.MONTHT6%TYPE,
										  DATPREST7    DEMAT_REJETS.DATPREST7%TYPE,
										  NOM_PRENOM7  DEMAT_REJETS.NOM_PRENOM7%TYPE,
										  MONTHT7      DEMAT_REJETS.MONTHT7%TYPE,
										  DATPREST8    DEMAT_REJETS.DATPREST8%TYPE,
										  NOM_PRENOM8  DEMAT_REJETS.NOM_PRENOM8%TYPE,
  			   				  			  MONTHT8      DEMAT_REJETS.MONTHT8%TYPE,
										  LIB_ERR      DEMAT_MESSAGE.LIB_ERR%TYPE,
										  NBPREST 	DEMAT_REJETS.NBPREST%TYPE,
										  NUM_CHAMPS_ERR DEMAT_REJETS.NUM_CHAMPS_ERR%TYPE

				             );

TYPE rejet_dem_fact_listeCurType IS REF CURSOR RETURN rejet_dem_fact_ViewType;


PROCEDURE lister_facture_rejet( p_numlot 	IN VARCHAR2,
		  						s_curseur 	IN OUT rejet_dem_fact_listeCurType ) ;

TYPE charg_dem_fact_ViewType IS RECORD (  NUMFACT  FACTURE.NUMFACT%TYPE,
								TYPFACT FACTURE.TYPFACT%TYPE,
								REF_SG FACTURE.REF_SG%TYPE,
								NUM_SMS FACTURE.NUM_SMS%TYPE  ,
								FCODUSER FACTURE.FCODUSER%TYPE ,
								FMONTHT FACTURE.FMONTHT%TYPE,
								FMONTTTC FACTURE.FMONTTTC%TYPE,
								FTVA FACTURE.FTVA%TYPE,
								FMOIACOMPTA FACTURE.FMOIACOMPTA%TYPE,
								FCODCOMPTA FACTURE.FCODCOMPTA%TYPE,
								FCENTREFRAIS FACTURE.FCENTREFRAIS%TYPE,
								NUMCONT FACTURE.NUMCONT%TYPE,
								CAV FACTURE.CAV%TYPE,
								FSTATUT1 FACTURE.FSTATUT1%TYPE,
								fstatut2 FACTURE.fstatut2%TYPE,
								SOCFACT FACTURE.SOCFACT%TYPE,
								LLIBANALYT FACTURE.LLIBANALYT%TYPE,
								DATFACT FACTURE.DATFACT%TYPE,
								FENRCOMPTA FACTURE.FENRCOMPTA%TYPE ,
								FDATSAI FACTURE.FDATSAI%TYPE,
								FDATMAJ FACTURE.FDATMAJ%TYPE,
								FACCSEC FACTURE.FACCSEC%TYPE ,
								FDATRECEP FACTURE.FDATRECEP%TYPE,
							    FDEPPOLE  FACTURE.FDEPPOLE%TYPE
				             );

TYPE charg_dem_fact_listeCurType IS REF CURSOR RETURN charg_dem_fact_ViewType;


PROCEDURE lister_facture_charg( p_numlot 	IN VARCHAR2,
		     			     s_curseur 	IN OUT charg_dem_fact_listeCurType) ;


TYPE rapport_dem_fact_ViewType IS RECORD (   NUM_CHARG   DEMAT_CHARGEMENT.NUM_CHARG%TYPE	,
	 						   	  		     NOM_FICHIER   DEMAT_CHARGEMENT.NOM_FICHIER%TYPE	,
                                             DATE_CHARG  DEMAT_CHARGEMENT.DATE_CHARG%TYPE,
                                             USERID      DEMAT_CHARGEMENT.USERID%TYPE,
                                             NB_INTEG     DEMAT_CHARGEMENT.NB_INTEG%TYPE,
                                             NB_REJET    DEMAT_CHARGEMENT.NB_REJET%TYPE,
									         NB_TOTAL    DEMAT_CHARGEMENT.NB_TOTAL%TYPE	        );


TYPE rapport_dem_fact_listeCurType IS REF CURSOR RETURN rapport_dem_fact_ViewType;


PROCEDURE lister_rapport_charg( datedebut 	IN DATE,datefin 	IN DATE,
		    					s_curseur 	IN OUT rapport_dem_fact_listeCurType ) ;

PROCEDURE get_num_charg (p_userid IN VARCHAR2, p_nomfichier IN VARCHAR2, p_nbreenreg IN VARCHAR2,p_num_charg		OUT	DEMAT_CHARGEMENT.num_charg%TYPE,
		  		    	p_message		OUT 	VARCHAR2);

PROCEDURE update_nbre_enreg  (p_numcharg IN VARCHAR2, p_nbrelignes IN VARCHAR2,
		  		    	p_message		OUT 	VARCHAR2);

END Pack_Recup_Dem_Facture;
/
CREATE OR REPLACE PACKAGE BODY Pack_Recup_Dem_Facture AS
/******************************************************************************
   NAME:       PACK_DEM_FACTURE_REJET
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        16/10/2006             1. Created this package body.
******************************************************************************/

--*************************************************************************************************
-- Procédure lister_facture_rejet
--
-- Sélectionne la liste les factures rejetées
--
-- ************************************************************************************************
PROCEDURE lister_facture_rejet( p_numlot 	IN VARCHAR2,
   			     s_curseur 	IN OUT rejet_dem_fact_listeCurType
                            ) IS
l_msg           VARCHAR2(1024);

BEGIN
   	BEGIN

	OPEN s_curseur  FOR

            SELECT TO_CHAR(rej.num_charg,'FM09999') AS NUM_CHARG,
                  TO_CHAR(rej.code_err,'FM099') AS CODE_ERR,
				   RPAD(rej.emetteur ,6,' ') AS EMETTEUR,
				   RPAD(rej.date_fic ,12,' ') AS DATE_FIC,
				   LPAD(rej.numord ,4,'0')AS NUMORD,
				   LPAD(rej.ref_sg ,12,'0') AS REF_SG,
				   LPAD(rej.siren ,9,'0') AS SIREN,
				   RPAD(rej.typfact,1,' ') AS TYPFACT,
				   RPAD(rej.numfact, 15,' ') AS NUMFACT,
				   RPAD(rej.datfact , 8,' ') AS DATFACT,
				   RPAD(rej.numcont ,20,' ') AS NUMCONT,
				   RPAD(rej.rib ,23,' ') AS RIB,
				   LPAD(TO_NUMBER(rej.montht) ,10,'0') AS MONTHT,
				   LPAD(TO_NUMBER(rej.montttc) ,10,'0') AS MONTTTC,
				   LPAD(TO_NUMBER(rej.monttva) ,10,'0') AS MONTTVA,
				   RPAD(rej.datprest1, 4,' ') AS DATPREST1,
				   RPAD(rej.nom_prenom1, 32,' ')AS NOM_PRENOM1,
				   LPAD(TO_NUMBER(rej.montht1) , 10,'0')AS MONTHT1,
				   RPAD(rej.datprest2 , 4,' ')AS DATPREST2,
				   RPAD(rej.nom_prenom2 , 32,' ')AS NOM_PRENOM2,
				   LPAD(TO_NUMBER(rej.montht2) , 10,'0')AS MONTHT2,
				   RPAD(rej.datprest3 , 4,' ')AS DATPREST3,
				   RPAD(rej.nom_prenom3 , 32,' ')AS NOM_PRENOM3,
				   LPAD(TO_NUMBER(rej.montht3), 10,'0')AS MONTHT3,
				   RPAD(rej.datprest4 , 4,' ')AS DATPREST4,
				   RPAD(rej.nom_prenom4 , 32,' ')AS NOM_PRENOM4,
				   LPAD(TO_NUMBER(rej.montht4) , 10,'0')AS MONTHT4,
				   RPAD(rej.datprest5 , 4,' ')AS DATPREST5,
				   RPAD(rej.nom_prenom5 , 32,' ')AS NOM_PRENOM5,
				   LPAD(TO_NUMBER(rej.montht5) , 10,'0')AS MONTHT5,
				   RPAD(rej.datprest6, 4,' ')AS DATPREST6,
				   RPAD(rej.nom_prenom6, 32,' ')AS NOM_PRENOM6,
				   LPAD(TO_NUMBER(rej.montht6) , 10,'0')AS MONTHT6,
				   RPAD(rej.datprest7, 4,' ')AS DATPREST7,
				   RPAD(rej.nom_prenom7 , 32,' ')AS NOM_PRENOM7,
				   LPAD(TO_NUMBER(rej.montht7) , 10,'0')AS MONTHT7,
				   RPAD(rej.datprest8 , 4,' ')AS DATPREST8,
				   RPAD(rej.nom_prenom8 , 32,' ')AS NOM_PRENOM8,
				   LPAD(TO_NUMBER(rej.montht8) , 10,'0')AS MONTHT8,
                   msg.LIB_ERR AS LIB_ERR,
				   nbprest,
				   NUM_CHAMPS_ERR
           	 FROM DEMAT_REJETS rej,DEMAT_MESSAGE msg
			 WHERE
			 (	rej.NUM_CHARG=TO_NUMBER( p_numlot)
			  AND msg.CODE_ERR=rej.CODE_ERR)

			  ORDER BY TO_NUMBER(rej.NUMORD) ;
   	EXCEPTION
	    WHEN NO_DATA_FOUND THEN
	           Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
		     RAISE_APPLICATION_ERROR( -20849,  l_msg);

		WHEN OTHERS THEN
   		    RAISE_APPLICATION_ERROR( -20997, SQLERRM);
	END;
END lister_facture_rejet;



--*************************************************************************************************
-- Procédure lister_facture_charg
--
-- Sélectionne la liste les factures chargées
--
-- ************************************************************************************************
PROCEDURE lister_facture_charg( p_numlot 	IN VARCHAR2,
   			     s_curseur 	IN OUT charg_dem_fact_listeCurType
                            ) IS
l_msg           VARCHAR2(1024);
BEGIN
   	BEGIN

	OPEN s_curseur  FOR

           SELECT TYPFACT,
		   		  NUMFACT,
				  REF_SG,
				  NUM_SMS,
				  FCODUSER,
		   		  FMONTHT,
				  FMONTTTC,
				  FTVA,
				  FMOIACOMPTA,
				  FCODCOMPTA,
				  FCENTREFRAIS,
				  NUMCONT,
				  cav,
				  FSTATUT1,
				  fstatut2,
				  SOCFACT,
				  LLIBANALYT,
				  DATFACT,
				  FENRCOMPTA ,
				  FDATSAI,
				  FDATMAJ,
				  FACCSEC,
				  FDATRECEP,
				  FDEPPOLE
           	 FROM FACTURE
			 WHERE
			 (	NUM_CHARG= TO_NUMBER(p_numlot)
			)

			  ORDER BY NUMFACT ;
   	EXCEPTION
	    WHEN NO_DATA_FOUND THEN
	           Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
		     RAISE_APPLICATION_ERROR( -20849,  l_msg);

		WHEN OTHERS THEN
   		    RAISE_APPLICATION_ERROR( -20997, SQLERRM);
	END;



END lister_facture_charg;

PROCEDURE lister_rapport_charg( datedebut 	IN DATE,datefin 	IN DATE,
   			     s_curseur 	IN OUT rapport_dem_fact_listeCurType
                            )
							IS
l_msg           VARCHAR2(1024);

BEGIN
   	BEGIN
	OPEN s_curseur  FOR
           SELECT  NUM_CHARG,
		    NOM_FICHIER,
		     TO_CHAR(DATE_CHARG ,'DD/MM/YYYY HH24:MI:SS'),
			 USERID,
 			 NB_INTEG,
			 NB_REJET,
			 NB_TOTAL
 		   FROM DEMAT_CHARGEMENT
		   ORDER BY DATE_CHARG DESC ;
   	EXCEPTION
	    WHEN NO_DATA_FOUND THEN
	           Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
		     RAISE_APPLICATION_ERROR( -20849,  l_msg);

		WHEN OTHERS THEN
   		    RAISE_APPLICATION_ERROR( -20997, SQLERRM);
	END;
END lister_rapport_charg;

PROCEDURE get_num_charg (p_userid IN VARCHAR2, p_nomfichier IN VARCHAR2, p_nbreenreg IN VARCHAR2, p_num_charg		OUT	DEMAT_CHARGEMENT.num_charg%TYPE,
			    	p_message		OUT 	VARCHAR2
			    	) IS

l_count NUMBER;

BEGIN

   	SELECT 	COUNT(num_charg) INTO l_count
	FROM 	DEMAT_CHARGEMENT;

	IF(l_count=0)THEN
	       p_num_charg := 0;
	ELSE
	    -- On recherche de lib dans la table entite_structure
	    SELECT 	MAX(NVL(num_charg,0)) + 1  INTO p_num_charg
	     FROM 	DEMAT_CHARGEMENT;
	END IF;


   INSERT INTO DEMAT_CHARGEMENT ( NUM_CHARG,NOM_FICHIER,DATE_CHARG,USERID, NB_INTEG,NB_REJET, NB_TOTAL ) VALUES ( TO_NUMBER(p_num_charg),p_nomfichier, SYSDATE,p_userid,0,0,TO_NUMBER(p_nbreenreg));

    COMMIT;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		Pack_Global.recuperer_message( 2007, NULL, NULL, NULL, p_message);

	WHEN OTHERS THEN
		RAISE_APPLICATION_ERROR( -20997, SQLERRM);
END get_num_charg ;

PROCEDURE update_nbre_enreg  (p_numcharg IN VARCHAR2, p_nbrelignes IN VARCHAR2,
		  		    	p_message		OUT 	VARCHAR2)IS
BEGIN

   	UPDATE DEMAT_CHARGEMENT SET NB_TOTAL = TO_NUMBER(p_nbrelignes) WHERE NUM_CHARG= TO_NUMBER(p_numcharg);
	
    COMMIT;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		Pack_Global.recuperer_message( 2007, NULL, NULL, NULL, p_message);

	WHEN OTHERS THEN
		RAISE_APPLICATION_ERROR( -20997, SQLERRM);
END update_nbre_enreg;

END Pack_Recup_Dem_Facture;
/
