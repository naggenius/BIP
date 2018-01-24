-- pack_liste_reestimes PL/SQL
-- 
-- Equipe SOPRA
-- Créé le 08/03/1999
-- Modifié le 27/11/2000 par NCM : Trier par code MO(clicode) puis par ligne bip 
-- Modifié le 10/06/2003 par Pierre JOSSE : migration RTFE et modif du format des code DPG
--            17/07/2003 par NBM : suppression de p_oder,p_pidinf,p_pidsup
--            24/08/2004 par PJO : refonte de l'interface des budgets
--            16/06/2005 par JMA : ajout filtre Client et application
--	      07/07/2005 par BAA : ajout les differents ordre de tri 
--				   et la procedure lister_total_reestimes qui calcule les totales
-- Modifié le 07/03/2006 par BAA : ajout l'ordre de tri par libelle application	
-- Modifié le 16/05/2006 par BAA : Modiffié l'ordre de tri code client -> Ligne Bip	
-- Modifié le 21/06/2006 par PPR : ajout l'ordre de tri par libelle application , ligne BIP
-- 11/06/2007 JAL : Fiche 556 exclusion lignes BIP type 9
-- 12/08/2008 EVI : Fiche 650 ajout code projet
-- 27/08/2009   YNA: TD 822 (lot 7.3) trace des modifications des budgets
-- 28/09/2009   ABA: TD 822 (lot 7.3) trace des modifications des budgets
-- 24/04/2012   RBO : HPPM 31739 (pour livraison 8.4) Enrichissement traçabilité du Réeestimé et d'Arbitré
--**************************************************************************************************

CREATE OR REPLACE PACKAGE     pack_liste_reestimes AS

   TYPE reestimes_ListeViewType IS RECORD(CLICODE    ligne_bip.clicode%TYPE,
					  PID        ligne_bip.pid%TYPE,
					  TYPE       ligne_bip.typproj%TYPE,
                                          PNOM       ligne_bip.pnom%TYPE,
                                          FLAGLOCK   VARCHAR2(20),
                                          CODSG      VARCHAR2(20),
                                          XCUSAG0    VARCHAR2(20),
                                          XBNMONT    VARCHAR2(20),
                                          PREESANCOU VARCHAR2(20),
                                          ICPI       ligne_bip.ICPI%TYPE,
                                          --YNI
                                          REDATE    VARCHAR2(20),
                                          UREESTIME VARCHAR2(20),
                                          REESCOMM BUDGET.reescomm%TYPE
                                          --Fin YNI
                                          );

   TYPE reestimes_listeCurType IS REF CURSOR RETURN reestimes_ListeViewType;

   TYPE reestimes_TotalListeViewType IS RECORD(XCUSAG0    VARCHAR2(20),
                                               XBNMONT    VARCHAR2(20),
                                               PREESANCOU VARCHAR2(20)
                                               );

   TYPE reestimes_totallisteCurType IS REF CURSOR RETURN reestimes_TotalListeViewType;


   PROCEDURE lister_reestimes(p_codsg   IN VARCHAR2,
					 		  p_clicode    IN VARCHAR2,
   							  p_airt       IN VARCHAR2,
                              p_userid  IN VARCHAR2,
							  p_ordre_tri IN VARCHAR2,
                              p_curseur IN OUT reestimes_listeCurType
                             );



   PROCEDURE lister_total_reestimes(p_codsg   IN VARCHAR2,
					 		 	    p_clicode    IN VARCHAR2,
   							        p_airt       IN VARCHAR2,
                                    p_userid  IN VARCHAR2,
									p_ordre_tri IN VARCHAR2,
                                    p_curseur IN OUT reestimes_totallisteCurType
                                   );

END pack_liste_reestimes;
/


CREATE OR REPLACE PACKAGE BODY     Pack_Liste_Reestimes AS

PROCEDURE lister_reestimes(p_codsg   IN VARCHAR2,
					 		  p_clicode    IN VARCHAR2,
   							  p_airt       IN VARCHAR2,
                              p_userid  IN VARCHAR2,
							  p_ordre_tri IN VARCHAR2,
                              p_curseur IN OUT reestimes_listeCurType
                             ) IS

      -- codsg et un varchar2 pour les cas XXX**** et XXXXX**
      l_codsg	VARCHAR2(10);
      l_perime	VARCHAR2(1000);
      l_annee	NUMBER(4);


BEGIN
   	-- Récupérer le périmètre de l'utilisateur
   	l_perime := Pack_Global.lire_globaldata(p_userid).perime ;

	SELECT TO_NUMBER(TO_CHAR (DATDEBEX, 'YYYY'))
	INTO l_annee
	FROM DATDEBEX
	WHERE ROWNUM < 2;


    IF (p_codsg = '*******') THEN
        OPEN p_curseur FOR
        	SELECT RTRIM(LTRIM(lb.clicode)) 	AS CLICODE,
		      	   lb.pid	 		AS PID,
		      	   RTRIM(LTRIM(lb.typproj))	AS TYPE,
                   SUBSTR(lb.pnom,1,30) 	AS PNOM,
                   TO_CHAR(budg.flaglock) 		AS FLAGLOCK,
                   TO_CHAR(lb.codsg, 'FM0000000') 	AS CODSG,
                   TO_CHAR(conso.cusag, 'FM9999999990D00') 	AS XCUSAG0,
                   TO_CHAR(budg.anmont, 'FM9999999990D00') 	AS XBNMONT,
                   TO_CHAR(budg.reestime,'FM9999999990D00') 	AS PREESANCOU,
                   lb.ICPI as ICPI,
                   --YNI
                   to_char(budg.redate,'DD/MM/YYYY') as REDATE,
                   budg.ureestime as UREESTIME,
                   -- HPPM_31739
                   budg.reescomm as REESCOMM
                   --Fin YNI
                   
              FROM LIGNE_BIP lb, CONSOMME conso, BUDGET budg, vue_dpg_perime vdp, APPLICATION ap
             WHERE conso.pid(+) = lb.pid
	     	   AND budg.pid(+) = lb.pid
	     	   AND lb.TYPPROJ != '9'
	     	   AND conso.annee(+) = l_annee
	     	   AND budg.annee(+) = l_annee
	     	   AND ((lb.adatestatut IS NULL) OR (TO_NUMBER(TO_CHAR(lb.adatestatut,'YYYY')) >= l_annee))
               AND lb.codsg = vdp.codsg
               AND INSTR(l_perime, vdp.codbddpg) > 0
			   AND (p_airt IS NULL OR p_airt = lb.AIRT)
			   AND (p_clicode IS NULL OR p_clicode = lb.CLICODE)
	       AND ap.AIRT=lb.AIRT
			   ORDER BY DECODE(p_ordre_tri,'1',lb.clicode,'2',lb.pid,'3',lb.pnom,'4',ap.ALIBEL,'5',ap.ALIBEL),
			   	                        DECODE(p_ordre_tri,'1', lb.pid,'4', lb.typproj,'5', lb.pid),
			                            DECODE(p_ordre_tri,'4', lb.pid);

    ELSE
      	-- On formatte l_codsg QC 1281
        l_codsg := REPLACE(LPAD(p_codsg, 7, '0'),'*','%');

        OPEN p_curseur FOR
            SELECT RTRIM(LTRIM(lb.clicode))	AS CLICODE,
		      	   lb.pid 			AS PID,
		      	   RTRIM(LTRIM(lb.typproj))	AS TYPE,
                   SUBSTR(lb.pnom,1,30) 	AS PNOM,
                   TO_CHAR(budg.flaglock) 		AS FLAGLOCK,
                   TO_CHAR(lb.codsg, 'FM0000000') 	AS CODSG,
                   TO_CHAR(conso.cusag, 'FM9999999990D00') 	AS XCUSAG0,
                   TO_CHAR(budg.anmont, 'FM9999999990D00') 	AS XBNMONT,
                   TO_CHAR(budg.reestime,'FM9999999990D00') 	AS PREESANCOU,
                   lb.ICPI as ICPI,
                   --YNI
                   to_char(budg.redate,'DD/MM/YYYY') as REDATE,
                   budg.ureestime as UREESTIME,
                   --Fin YNI
                   -- HPPM_31739
                   budg.reescomm as REESCOMM
              FROM LIGNE_BIP lb,CONSOMME conso,BUDGET budg, APPLICATION ap, vue_dpg_perime vdp
             WHERE conso.pid(+) = lb.pid
               AND budg.pid(+) = lb.pid
                AND lb.TYPPROJ != '9'
                AND lb.codsg = vdp.codsg
                AND INSTR(l_perime, vdp.codbddpg) > 0
	     	   AND conso.annee(+) = l_annee
	     	   AND budg.annee(+) = l_annee
	     	   AND TO_CHAR(lb.codsg, 'FM0000000') LIKE l_codsg
	     	   AND ((lb.adatestatut IS NULL) OR (TO_NUMBER(TO_CHAR(lb.adatestatut,'YYYY')) >= l_annee))
			   AND (p_airt IS NULL OR p_airt = lb.AIRT)
			   AND (p_clicode IS NULL OR p_clicode = lb.CLICODE)
		AND ap.AIRT=lb.AIRT
			   ORDER BY DECODE(p_ordre_tri,'1',lb.clicode,'2',lb.pid,'3',lb.pnom,'4',ap.ALIBEL,'5',ap.ALIBEL),
			   	                        DECODE(p_ordre_tri,'1', lb.pid,'4', lb.typproj,'5', lb.pid),
			                            DECODE(p_ordre_tri,'4', lb.pid);

    END IF;

END lister_reestimes;



PROCEDURE lister_total_reestimes(p_codsg   IN VARCHAR2,
					 		     p_clicode    IN VARCHAR2,
   							     p_airt       IN VARCHAR2,
                                 p_userid  IN VARCHAR2,
								 p_ordre_tri IN VARCHAR2,
                                 p_curseur IN OUT reestimes_totallisteCurType
                                 ) IS

      -- codsg et un varchar2 pour les cas XXX**** et XXXXX**
      l_codsg	VARCHAR2(10);
      l_perime	VARCHAR2(1000);
      l_annee	NUMBER(4);

BEGIN
   	-- Récupérer le périmètre de l'utilisateur
   	l_perime := Pack_Global.lire_globaldata(p_userid).perime ;

	SELECT TO_NUMBER(TO_CHAR (DATDEBEX, 'YYYY'))
	INTO l_annee
	FROM DATDEBEX
	WHERE ROWNUM < 2;

    IF (p_codsg = '*******') THEN
        OPEN p_curseur FOR
        	SELECT TO_CHAR(SUM(conso.cusag),'FM9999999990D00') 	AS XCUSAG0,
			       TO_CHAR(SUM(budg.anmont),'FM9999999990D00') 	AS XBNMONT,
			       TO_CHAR(SUM(budg.reestime),'FM9999999990D00') 	AS PREESANCOU
              FROM LIGNE_BIP lb, CONSOMME conso, BUDGET budg, vue_dpg_perime vdp
             WHERE conso.pid(+) = lb.pid
	     	   AND budg.pid(+) = lb.pid
	     	   AND lb.TYPPROJ != '9'
	     	   AND conso.annee(+) = l_annee
	     	   AND budg.annee(+) = l_annee
	     	   AND ((lb.adatestatut IS NULL) OR (TO_NUMBER(TO_CHAR(lb.adatestatut,'YYYY')) >= l_annee))
               AND lb.codsg = vdp.codsg
               AND INSTR(l_perime, vdp.codbddpg) > 0
			   AND (p_airt IS NULL OR p_airt = lb.AIRT)
			   AND (p_clicode IS NULL OR p_clicode = lb.CLICODE)
	        ORDER BY DECODE(p_ordre_tri,'1',lb.clicode,'2',lb.pid,'3',lb.pnom),
			   	                     DECODE(p_ordre_tri,'1', lb.pid,'4', lb.typproj),
			                         DECODE(p_ordre_tri,'4', lb.pid);

    ELSE
      	-- On formatte l_codsg QC 1281
        l_codsg := REPLACE(LPAD(p_codsg, 7, '0'),'*','%');
/*
	    IF SUBSTR(LPAD(p_codsg, 7, '0'),4,4) = '****' THEN
			l_codsg :=SUBSTR(LPAD(p_codsg, 7, '0'),1,3)||'%';
	    ELSIF SUBSTR(LPAD(p_codsg, 7, '0'),6,2) = '**' THEN
			l_codsg :=SUBSTR(LPAD(p_codsg, 7, '0'),1,5)||'%';
	    ELSIF SUBSTR(LPAD(p_codsg, 7, '0'),6,2) != '**' THEN
			l_codsg :=LPAD(p_codsg, 7, '0');
	    END IF;
*/
        OPEN p_curseur FOR
             SELECT TO_CHAR(SUM(conso.cusag),'FM9999999990D00') 	AS XCUSAG0,
			        TO_CHAR(SUM(budg.anmont),'FM9999999990D00') 	AS XBNMONT,
			        TO_CHAR(SUM(budg.reestime),'FM9999999990D00') 	AS PREESANCOU
		     FROM LIGNE_BIP lb,CONSOMME conso,BUDGET budg
             WHERE conso.pid(+) = lb.pid
               AND budg.pid(+) = lb.pid
               AND lb.TYPPROJ != '9'
	     	   AND conso.annee(+) = l_annee
	     	   AND budg.annee(+) = l_annee
	     	   AND TO_CHAR(lb.codsg, 'FM0000000') LIKE l_codsg
	     	   AND ((lb.adatestatut IS NULL) OR (TO_NUMBER(TO_CHAR(lb.adatestatut,'YYYY')) >= l_annee))
			   AND (p_airt IS NULL OR p_airt = lb.AIRT)
			   AND (p_clicode IS NULL OR p_clicode = lb.CLICODE)
			   ORDER BY DECODE(p_ordre_tri,'1',lb.clicode,'2',lb.pid,'3',lb.pnom),
			   	                     DECODE(p_ordre_tri,'1', lb.pid,'4', lb.typproj),
			                         DECODE(p_ordre_tri,'4', lb.pid);
	        -- ORDER BY DECODE(p_ordre_tri,'1',lb.clicode,'2',lb.pid,'3',lb.pnom) , lb.airt, lb.typproj, lb.pid;


    END IF;

END lister_total_reestimes;

END Pack_Liste_Reestimes;
/


