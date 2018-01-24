-- pack_liste_proposes PL/SQL
-- 
-- Créé le 29/03/2001 par NBM
-- Modifié le 05/08/2003 par NBM : suppression de  p_pidinf ,p_pidsup  ,p_order  
-- Modifié le 24/08/2004 par PJO : refonte de l'interface des budgets
-- Modifié le 07/07/2005 par BAA : ajout les differents ordre de tri 
--				   et la procedure lister_total_reestimes qui calcule les totales
-- Modifié le 07/03/2006 par BAA : ajout l'ordre de tri par libelle application*
-- Modifié le 16/05/2006 par BAA : Modiffié l'ordre de tri code client -> Ligne Bip
-- Modifié le 21/06/2006 par PPR : ajout l'ordre de tri par libelle application , ligne BIP
-- 11/06/2007 JAL : Fiche 556 exclusion lignes BIP type 9
-- 22/08/2008 EVI: TD 637 ajout du code projet et rallonge rnom
-- 27/08/2009   YNA: TD 822 (lot 7.3) trace des modifications des budgets
-- 30/05/2012  BSA : qc 1391
--****************************************************************************************************


CREATE OR REPLACE PACKAGE     pack_liste_proposes AS

   TYPE proposes_ListeViewType IS RECORD(CLICODE    	ligne_bip.clicode%TYPE,
					 PID        	ligne_bip.pid%TYPE,
                                         TYPE       	ligne_bip.typproj%TYPE,
                                         PNOM       	ligne_bip.pnom%TYPE,
                                         CODSG      	VARCHAR2(20),
                                         LIB_CODSG	VARCHAR2(30),
                                         BPMONTME    	VARCHAR2(20),
                                         BPMONTMO    	VARCHAR2(20),
                                         FLAGLOCK	VARCHAR2(20),
                                         ICPI       ligne_bip.ICPI%TYPE,
                                         --YNI ajout des attributs a modifier
                                         BPDATE VARCHAR2(30),
                                         UBPMONTME VARCHAR2(30),
                                         BPMEDATE VARCHAR2(30),
                                         UBPMONTMO VARCHAR2(30),
                                         ISPERIMMO CHAR(1),
                                         ISPERIMME CHAR(1)
                                         );

   TYPE proposes_listeCurType IS REF CURSOR RETURN proposes_ListeViewType;


   TYPE proposes_TotalListeViewType IS RECORD(BPMONTME    VARCHAR2(20),
                                              BPMONTMO    VARCHAR2(20)
                                             );

   TYPE proposes_totallisteCurType IS REF CURSOR RETURN proposes_TotalListeViewType;


   PROCEDURE lister_proposes( p_codsg   IN VARCHAR2,
   							  p_clicode IN VARCHAR2,
   							  p_airt 	IN VARCHAR2,
							  p_annee   IN VARCHAR2,
                              p_userid  IN VARCHAR2,
							  p_ordre_tri IN VARCHAR2,
                              p_curseur IN OUT proposes_listeCurType
                             );



	 PROCEDURE lister_total_proposes(p_codsg   IN VARCHAR2,
					 		 	     p_clicode    IN VARCHAR2,
   							         p_airt       IN VARCHAR2,
									 p_annee   IN VARCHAR2,
                                     p_userid  IN VARCHAR2,
                                     p_curseur IN OUT proposes_totallisteCurType
                                     );

END pack_liste_proposes;
/


CREATE OR REPLACE PACKAGE BODY     Pack_Liste_Proposes AS
PROCEDURE lister_proposes( p_codsg   IN VARCHAR2,
						   p_clicode IN VARCHAR2,
						   p_airt 	 IN VARCHAR2,
			     		   p_annee   IN VARCHAR2,
                           p_userid  IN VARCHAR2,
						   p_ordre_tri IN VARCHAR2,
                           p_curseur IN OUT proposes_listeCurType
                          ) IS

   -- codsg et un varchar2 pour les cas XX**** et XXXX**
      l_codsg	VARCHAR2(10);
      l_msg	VARCHAR2(1024);
      l_perime	VARCHAR2(1000);
      l_perimo	VARCHAR2(1000);
      l_menu VARCHAR2(25);


   BEGIN
       -- Récupérer les périmètres de l'utilisateur
      l_perime := Pack_Global.lire_globaldata(p_userid).perime ;


      l_menu := pack_global.lire_globaldata(p_userid).menutil;

		if('MO'=l_menu)then
			l_perimo := pack_global.lire_globaldata(p_userid).perimcli;
		else
			l_perimo := pack_global.lire_globaldata(p_userid).perimo;
		end if;

      -- Si c'est un code ME = *******
      IF (p_codsg IS NOT NULL) AND (p_codsg = '*******') THEN
      	BEGIN
             -- On récupère les lignes correspondante
	     OPEN p_curseur FOR
	     SELECT 		RTRIM(LTRIM(bip.clicode)) 	AS CLICODE,
		      		bip.pid 			AS PID,
		      		RTRIM(LTRIM(bip.typproj))	AS TYPE,
                      		SUBSTR(bip.pnom,1,30) 		AS PNOM,
                      		TO_CHAR(bip.codsg, 'FM0000000') AS CODSG,
                      		si.sigdep || '/' || si.sigpole	AS LIB_CODSG,
                      		TO_CHAR(budg.bpmontme, 'FM9999999990D00') AS BPMONTME,
                      		TO_CHAR(budg.bpmontmo, 'FM9999999990D00') AS BPMONTMO,
                        	TO_CHAR(budg.flaglock) 		AS FLAGLOCK,
                          bip.ICPI AS ICPI,
                          --YNI
                          to_char(budg.bpdate,'DD/MM/YYYY') AS BPDATE,
                      		budg.ubpmontme AS UBPMONTME,
                          to_char(budg.bpmedate,'DD/MM/YYYY') AS BPMEDATE,
                      		budg.ubpmontmo AS UBPMONTMO,
                          --YNI
                          -- BSA
                          pack_habilitation.isPerimMo(bip.clicode,l_perimo) ISPERIMMO,
                          pack_habilitation.isDpgMe(bip.codsg,l_perime) ISPERIMME
                          -- BSA
             FROM   BUDGET budg, LIGNE_BIP bip, vue_dpg_perime vdp, STRUCT_INFO si, APPLICATION ap
             WHERE  bip.codsg = si.codsg
              AND  bip.TYPPROJ != '9'
               AND  budg.annee(+) = TO_NUMBER(p_annee)
               AND  budg.pid (+)= bip.pid
               AND  ((bip.adatestatut IS NULL) OR (TO_NUMBER(TO_CHAR(bip.adatestatut,'YYYY') ) >= TO_NUMBER(p_annee)))
               AND  bip.codsg = vdp.codsg
               AND  INSTR(l_perime, vdp.codbddpg) > 0
			   AND (p_airt IS NULL OR p_airt = bip.AIRT)
			   AND (p_clicode IS NULL OR p_clicode = bip.CLICODE)
               AND ap.AIRT=bip.AIRT
			   ORDER BY DECODE(p_ordre_tri,'1',bip.clicode,'2',bip.pid,'3',bip.pnom,'4',ap.ALIBEL,'5',ap.ALIBEL),
			   	                        DECODE(p_ordre_tri,'1', bip.pid,'4', bip.typproj,'5', bip.pid),
			                            DECODE(p_ordre_tri,'4', bip.pid);

      	EXCEPTION
           WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message( 20373 , '%s1', p_codsg, 'codsg', l_msg);
               RAISE_APPLICATION_ERROR(-20373 , l_msg);

           WHEN OTHERS THEN
             RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      	END;


     -- Si c'est un code ME != *******
     ELSIF (p_codsg IS NOT NULL) THEN
      	BEGIN

            -- On formatte l_codsg
            l_codsg := REPLACE(LPAD(p_codsg, 7, '0'),'*','%');

             -- On récupère les lignes correspondante
	     OPEN p_curseur FOR
	     SELECT 		RTRIM(LTRIM(bip.clicode)) 	AS CLICODE,
		      		bip.pid 			AS PID,
		      		RTRIM(LTRIM(bip.typproj))	AS TYPE,
                      		SUBSTR(bip.pnom,1,30) 		AS PNOM,
                      		TO_CHAR(bip.codsg, 'FM0000000') AS CODSG,
                      		si.sigdep || '/' || si.sigpole	AS LIB_CODSG,
                      		TO_CHAR(budg.bpmontme, 'FM9999999990D00') AS BPMONTME,
                      		TO_CHAR(budg.bpmontmo, 'FM9999999990D00') AS BPMONTMO,
                      		TO_CHAR(budg.flaglock) 		AS FLAGLOCK,
                          bip.ICPI AS ICPI,
                          --YNI
                         to_char(budg.bpdate,'DD/MM/YYYY') AS BPDATE,
                      		budg.ubpmontme AS UBPMONTME,
                          to_char(budg.bpmedate,'DD/MM/YYYY') AS BPMEDATE,
                      		budg.ubpmontmo AS UBPMONTMO,
                          --YNI
                          -- BSA
                          pack_habilitation.isPerimMo(bip.clicode,l_perimo) ISPERIMMO,
                          pack_habilitation.isDpgMe(bip.codsg,l_perime) ISPERIMME
                          -- BSA
             FROM   BUDGET budg, LIGNE_BIP bip, STRUCT_INFO si, APPLICATION ap, vue_dpg_perime vdp
             WHERE  bip.codsg = si.codsg
               AND  bip.TYPPROJ != '9'
               AND  bip.codsg = vdp.codsg
               AND  INSTR(l_perime, vdp.codbddpg) > 0

               AND  TO_CHAR(bip.codsg, 'FM0000000') LIKE l_codsg
               AND  budg.annee(+) = TO_NUMBER(p_annee)
               AND  budg.pid (+)= bip.pid
               AND  ((bip.adatestatut IS NULL) OR (TO_NUMBER(TO_CHAR(bip.adatestatut,'YYYY') ) >= TO_NUMBER(p_annee)))
			   AND (p_airt IS NULL OR p_airt = bip.AIRT)
			   AND (p_clicode IS NULL OR p_clicode = bip.CLICODE)
             AND ap.AIRT=bip.AIRT
			   ORDER BY DECODE(p_ordre_tri,'1',bip.clicode,'2',bip.pid,'3',bip.pnom,'4',ap.ALIBEL,'5',ap.ALIBEL),
			   	                        DECODE(p_ordre_tri,'1', bip.pid,'4', bip.typproj,'5', bip.pid),
			                            DECODE(p_ordre_tri,'4', bip.pid);

      	EXCEPTION
           WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message( 20373 , '%s1', p_codsg, 'codsg', l_msg);
               RAISE_APPLICATION_ERROR(-20373 , l_msg);

           WHEN OTHERS THEN
             RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      	END;
     END IF;


      -- Si c'est un code MO = *****
	  -- JMAS 13/06/2005 : ajout de la condition "AND (p_codsg IS NULL)" pour différencier "Mes Lignes" de "Lignes Clients"
      IF (p_clicode IS NOT NULL) AND (p_clicode = '*****') AND (p_codsg IS NULL) THEN
      	BEGIN
             -- On récupère les lignes correspondante
	     OPEN p_curseur FOR
	     SELECT 		RTRIM(LTRIM(bip.clicode)) 	AS CLICODE,
		      		bip.pid 			AS PID,
		      		RTRIM(LTRIM(bip.typproj))	AS TYPE,
                      		SUBSTR(bip.pnom,1,30) 		AS PNOM,
                      		TO_CHAR(bip.codsg, 'FM0000000') AS CODSG,
                      		si.sigdep || '/' || si.sigpole	AS LIB_CODSG,
                      		TO_CHAR(budg.bpmontme, 'FM9999999990D00') AS BPMONTME,
                      		TO_CHAR(budg.bpmontmo, 'FM9999999990D00') AS BPMONTMO,
                      		TO_CHAR(budg.flaglock) 		AS FLAGLOCK,
                          bip.ICPI AS ICPI,
                          --YNI
                          to_char(budg.bpdate,'DD/MM/YYYY') AS BPDATE,
                      		budg.ubpmontme AS UBPMONTME,
                          to_char(budg.bpmedate,'DD/MM/YYYY') AS BPMEDATE,
                      		budg.ubpmontmo AS UBPMONTMO,
                          --YNI
                          -- BSA
                          pack_habilitation.isPerimMo(bip.clicode,l_perimo) ISPERIMMO,
                          pack_habilitation.isDpgMe(bip.codsg,l_perime) ISPERIMME
                          -- BSA                          
             FROM   BUDGET budg, LIGNE_BIP bip, vue_clicode_perimo vcp, STRUCT_INFO si, APPLICATION ap
             WHERE  bip.codsg = si.codsg
              AND  bip.TYPPROJ != '9'
               AND  budg.annee(+) = TO_NUMBER(p_annee)
               AND  budg.pid (+)= bip.pid
               AND  ((bip.adatestatut IS NULL) OR (TO_NUMBER(TO_CHAR(bip.adatestatut,'YYYY') ) >= TO_NUMBER(p_annee)))
               AND  bip.clicode = vcp.clicode
               AND  INSTR(l_perimo, vcp.bdclicode) > 0
			   AND (p_airt IS NULL OR p_airt = bip.AIRT)
 	     AND ap.AIRT=bip.AIRT
			   ORDER BY DECODE(p_ordre_tri,'1',bip.clicode,'2',bip.pid,'3',bip.pnom,'4',ap.ALIBEL,'5',ap.ALIBEL),
			   	                        DECODE(p_ordre_tri,'1', bip.pid,'4', bip.typproj,'5', bip.pid),
			                            DECODE(p_ordre_tri,'4', bip.pid);

      	EXCEPTION
           WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message( 20373 , '%s1', p_clicode, 'clicode', l_msg);
               RAISE_APPLICATION_ERROR(-20373 , l_msg);

           WHEN OTHERS THEN
             RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      	END;


     -- Si c'est un code MO != *****
	 -- JMAS 13/06/2005 : ajout de la condition "AND (p_codsg IS NULL)" pour différencier "Mes Lignes" de "Lignes Clients"
     ELSIF (p_clicode IS NOT NULL) AND (p_codsg IS NULL) THEN
      	BEGIN
             -- On récupère les lignes correspondante
	     OPEN p_curseur FOR
	     SELECT 		RTRIM(LTRIM(bip.clicode)) 	AS CLICODE,
		      		bip.pid 			AS PID,
		      		RTRIM(LTRIM(bip.typproj))	AS TYPE,
                      		SUBSTR(bip.pnom,1,30) 		AS PNOM,
                      		TO_CHAR(bip.codsg, 'FM0000000') AS CODSG,
                      		si.sigdep || '/' || si.sigpole	AS LIB_CODSG,
                      		TO_CHAR(budg.bpmontme, 'FM9999999990D00') AS BPMONTME,
                      		TO_CHAR(budg.bpmontmo, 'FM9999999990D00') AS BPMONTMO,
                      		TO_CHAR(budg.flaglock) 		AS FLAGLOCK,
                          bip.ICPI AS ICPI,
                          --YNI
                     to_char(budg.bpdate,'DD/MM/YYYY') AS BPDATE,
                      		budg.ubpmontme AS UBPMONTME,
                          to_char(budg.bpmedate,'DD/MM/YYYY') AS BPMEDATE,
                      		budg.ubpmontmo AS UBPMONTMO,
                          --YNI
                          -- BSA
                          pack_habilitation.isPerimMo(bip.clicode,l_perimo) ISPERIMMO,
                          pack_habilitation.isDpgMe(bip.codsg,l_perime) ISPERIMME
                          -- BSA                          
             FROM   BUDGET budg, LIGNE_BIP bip, STRUCT_INFO si, APPLICATION ap
             WHERE  bip.codsg = si.codsg
               AND  bip.TYPPROJ != '9'
               AND  bip.clicode  = p_clicode
               AND  budg.annee(+) = TO_NUMBER(p_annee)
               AND  budg.pid (+)= bip.pid
               AND  ((bip.adatestatut IS NULL) OR (TO_NUMBER(TO_CHAR(bip.adatestatut,'YYYY') ) >= TO_NUMBER(p_annee)))
			   AND (p_airt IS NULL OR p_airt = bip.AIRT)
	    AND ap.AIRT=bip.AIRT
			   ORDER BY DECODE(p_ordre_tri,'1',bip.clicode,'2',bip.pid,'3',bip.pnom,'4',ap.ALIBEL,'5',ap.ALIBEL),
			   	                        DECODE(p_ordre_tri,'1', bip.pid,'4', bip.typproj,'5', bip.pid),
			                            DECODE(p_ordre_tri,'4', bip.pid);

      	EXCEPTION
           WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message( 20373 , '%s1', p_clicode, 'clicode', l_msg);
               RAISE_APPLICATION_ERROR(-20373 , l_msg);

           WHEN OTHERS THEN
             RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      	END;
     END IF;
  END lister_proposes;




  PROCEDURE lister_total_proposes( p_codsg   IN VARCHAR2,
						   p_clicode IN VARCHAR2,
						   p_airt 	 IN VARCHAR2,
			     		   p_annee   IN VARCHAR2,
                           p_userid  IN VARCHAR2,
                           p_curseur IN OUT proposes_totallisteCurType
                          ) IS

   -- codsg et un varchar2 pour les cas XX**** et XXXX**
      l_codsg	VARCHAR2(10);
      l_msg	VARCHAR2(1024);
      l_perime	VARCHAR2(1000);
      l_perimo	VARCHAR2(1000);
      l_menu VARCHAR2(25);


   BEGIN
       -- Récupérer les périmètres de l'utilisateur
      l_perime := Pack_Global.lire_globaldata(p_userid).perime ;

      l_menu := pack_global.lire_globaldata(p_userid).menutil;

		if('MO'=l_menu)then
			l_perimo := pack_global.lire_globaldata(p_userid).perimcli;
		else
			l_perimo := pack_global.lire_globaldata(p_userid).perimo;
		end if;


      -- Si c'est un code ME = *******
      IF (p_codsg IS NOT NULL) AND (p_codsg = '*******') THEN
      	BEGIN
             -- On récupère les lignes correspondante
	     OPEN p_curseur FOR
	     SELECT 	TO_CHAR(SUM(budg.bpmontme),'FM9999999990D00') AS BPMONTME,
                    TO_CHAR(SUM(budg.bpmontmo),'FM9999999990D00') AS BPMONTMO
             FROM   BUDGET budg, LIGNE_BIP bip, vue_dpg_perime vdp, STRUCT_INFO si
             WHERE  bip.codsg = si.codsg
              AND  bip.TYPPROJ != '9'
               AND  budg.annee(+) = TO_NUMBER(p_annee)
               AND  budg.pid (+)= bip.pid
               AND  ((bip.adatestatut IS NULL) OR (TO_NUMBER(TO_CHAR(bip.adatestatut,'YYYY') ) >= TO_NUMBER(p_annee)))
               AND  bip.codsg = vdp.codsg
               AND  INSTR(l_perime, vdp.codbddpg) > 0
			   AND (p_airt IS NULL OR p_airt = bip.AIRT)
			   AND (p_clicode IS NULL OR p_clicode = bip.CLICODE)
             ORDER BY   bip.clicode ||bip.pid ;

      	EXCEPTION
           WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message( 20373 , '%s1', p_codsg, 'codsg', l_msg);
               RAISE_APPLICATION_ERROR(-20373 , l_msg);

           WHEN OTHERS THEN
             RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      	END;


     -- Si c'est un code ME != *******
     ELSIF (p_codsg IS NOT NULL) THEN
      	BEGIN
      	     -- On formatte l_codsg
	     IF SUBSTR(LPAD(p_codsg, 7, '0'),4,4) = '****' THEN
			l_codsg :=SUBSTR(LPAD(p_codsg, 7, '0'),1,3)||'%';
	     ELSIF SUBSTR(LPAD(p_codsg, 7, '0'),6,2) = '**' THEN
			l_codsg :=SUBSTR(LPAD(p_codsg, 7, '0'),1,5)||'%';
	     ELSIF SUBSTR(LPAD(p_codsg, 7, '0'),6,2) != '**' THEN
			l_codsg :=LPAD(p_codsg, 7, '0');
	     END IF;

             -- On récupère les lignes correspondante
	     OPEN p_curseur FOR
	     SELECT 	TO_CHAR(SUM(budg.bpmontme), 'FM9999999990D00') AS BPMONTME,
                    TO_CHAR(SUM(budg.bpmontmo), 'FM9999999990D00') AS BPMONTMO
             FROM   BUDGET budg, LIGNE_BIP bip, STRUCT_INFO si
             WHERE  bip.codsg = si.codsg
               AND bip.TYPPROJ != '9'
               AND  TO_CHAR(bip.codsg, 'FM0000000') LIKE l_codsg
               AND  budg.annee(+) = TO_NUMBER(p_annee)
               AND  budg.pid (+)= bip.pid
               AND  ((bip.adatestatut IS NULL) OR (TO_NUMBER(TO_CHAR(bip.adatestatut,'YYYY') ) >= TO_NUMBER(p_annee)))
			   AND (p_airt IS NULL OR p_airt = bip.AIRT)
			   AND (p_clicode IS NULL OR p_clicode = bip.CLICODE)
             ORDER BY   bip.clicode ||bip.pid ;

      	EXCEPTION
           WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message( 20373 , '%s1', p_codsg, 'codsg', l_msg);
               RAISE_APPLICATION_ERROR(-20373 , l_msg);

           WHEN OTHERS THEN
             RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      	END;
     END IF;


      -- Si c'est un code MO = *****
	  -- JMAS 13/06/2005 : ajout de la condition "AND (p_codsg IS NULL)" pour différencier "Mes Lignes" de "Lignes Clients"
      IF (p_clicode IS NOT NULL) AND (p_clicode = '*****') AND (p_codsg IS NULL) THEN
      	BEGIN
             -- On récupère les lignes correspondante
	     OPEN p_curseur FOR
	     SELECT 	TO_CHAR(SUM(budg.bpmontme), 'FM9999999990D00') AS BPMONTME,
                    TO_CHAR(SUM(budg.bpmontmo), 'FM9999999990D00') AS BPMONTMO
             FROM   BUDGET budg, LIGNE_BIP bip, vue_clicode_perimo vcp, STRUCT_INFO si
             WHERE  bip.codsg = si.codsg
               AND  bip.TYPPROJ != '9'
               AND  budg.annee(+) = TO_NUMBER(p_annee)
               AND  budg.pid (+)= bip.pid
               AND  ((bip.adatestatut IS NULL) OR (TO_NUMBER(TO_CHAR(bip.adatestatut,'YYYY') ) >= TO_NUMBER(p_annee)))
               AND  bip.clicode = vcp.clicode
               AND  INSTR(l_perimo, vcp.bdclicode) > 0
			   AND (p_airt IS NULL OR p_airt = bip.AIRT)
             ORDER BY   bip.clicode ||bip.pid ;

      	EXCEPTION
           WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message( 20373 , '%s1', p_clicode, 'clicode', l_msg);
               RAISE_APPLICATION_ERROR(-20373 , l_msg);

           WHEN OTHERS THEN
             RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      	END;


     -- Si c'est un code MO != *****
	 -- JMAS 13/06/2005 : ajout de la condition "AND (p_codsg IS NULL)" pour différencier "Mes Lignes" de "Lignes Clients"
     ELSIF (p_clicode IS NOT NULL) AND (p_codsg IS NULL) THEN
      	BEGIN
             -- On récupère les lignes correspondante
	     OPEN p_curseur FOR
	     SELECT 	TO_CHAR(SUM(budg.bpmontme), 'FM9999999990D00') AS BPMONTME,
                    TO_CHAR(SUM(budg.bpmontmo), 'FM9999999990D00') AS BPMONTMO
             FROM   BUDGET budg, LIGNE_BIP bip, STRUCT_INFO si
             WHERE  bip.codsg = si.codsg
               AND  bip.TYPPROJ != '9'
               AND  bip.clicode  = p_clicode
               AND  budg.annee(+) = TO_NUMBER(p_annee)
               AND  budg.pid (+)= bip.pid
               AND  ((bip.adatestatut IS NULL) OR (TO_NUMBER(TO_CHAR(bip.adatestatut,'YYYY') ) >= TO_NUMBER(p_annee)))
			   AND (p_airt IS NULL OR p_airt = bip.AIRT)
             ORDER BY   bip.clicode ||bip.pid ;

      	EXCEPTION
           WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message( 20373 , '%s1', p_clicode, 'clicode', l_msg);
               RAISE_APPLICATION_ERROR(-20373 , l_msg);

           WHEN OTHERS THEN
             RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      	END;
     END IF;
  END lister_total_proposes;



END Pack_Liste_Proposes;
/
