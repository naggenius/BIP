-- pack_isac_copie  PL/SQL
--
-- QUI       	QUAND       	QUOI
-- -------------------------------------------
--  NBM	26/09/2003	création 
--  PJO 05/03/2004	Modification sur 4 carcatères des PID
--  BAA 13/09/2005      Ajout de l'argument affecter pour affecter les ressources ou ne pas les affectés
--  BAA 15/09/2005      Ajout des procedures lister_ident1, lister_ident2 et insert_affectation 
--  BAA 22/11/2005      Corriger la procedure lister_ident2
--  BAA 30/12/2005      Optimisation des requêtes
--  CMA 14/01/2011      852 option de déplacement des consommés
--  CMA 08/02/2011      852 suppression des consommés copiés après copie
--  CMA 08/02/2011		852 Déplacement des consommés à partir du mois de l'année en cours dans tous les cas
--  CMA 09/02/2011      852 Pas de déplacement des consommés entre la date de mensuelle définitive de décembre et la clôture annuelle
--  CMA 11/02/2011		852 Ajout de logs lors du déplacement des consommés
-- Modifié  14/11/2011  ABA   QC 1283
-- Attention le nom du package ne peut etre le nom
-- de la table...

CREATE OR REPLACE PACKAGE     Pack_Isac_Copie AS


TYPE RefCurTyp IS REF CURSOR;

--*********************************************************************
-- Liste des lignes à copier : elles ont au moins une étape
-- *******************************************************************
   PROCEDURE lister_pid1( p_userid  IN VARCHAR2,
                          p_curseur IN OUT RefCurTyp
                             );
--*********************************************************************
-- Liste des lignes à renseigner : elles n'ont aucune étape
-- *******************************************************************
   PROCEDURE lister_pid2( p_userid  IN VARCHAR2,
                          p_curseur IN OUT RefCurTyp
                             );
--********************************************************************************************************************
-- Procédure de copie de la structure d'une ligne BIP vers une autre ligne BIP qui n'a aucune structure
-- paramètres : 	- p_pid1 : ligne BIP à copier
--			- p_pid2 : ligne BIP qui doît être renseigné
-- *******************************************************************************************************************
	PROCEDURE insert_struct ( p_pid1 	    IN LIGNE_BIP.pid%TYPE,
				              p_pid2     	IN LIGNE_BIP.pid%TYPE,
				  			  p_userid     	IN  VARCHAR2,
				  			  p_affecter    IN VARCHAR2,
                              p_mois        IN VARCHAR2,
                              p_message    	OUT VARCHAR2
                            );



--*********************************************************************
-- Liste des ressources origines
-- *******************************************************************
   PROCEDURE lister_ident1( p_userid  IN VARCHAR2,
                            p_curseur IN OUT RefCurTyp
                          );
--*********************************************************************
-- Liste des ressources déstinations
-- *******************************************************************
   PROCEDURE lister_ident2( p_userid  IN VARCHAR2,
                            p_curseur IN OUT RefCurTyp
                          );

--********************************************************************************************************************
-- Procédure de copie les affectations d'une ressource à une autre ressource
-- paramètres : 	- p_pid1 : ressource origine
--			        - p_pid2 : ressource déstination
-- *******************************************************************************************************************
PROCEDURE insert_affectation ( 	p_ident1     IN RESSOURCE.ident%TYPE,
							    p_ident2 	 IN RESSOURCE.ident%TYPE,
							    p_userid     IN  VARCHAR2,
							    p_message    OUT VARCHAR2
                              );





END Pack_Isac_Copie;
/


create or replace PACKAGE BODY     Pack_Isac_Copie AS
--*********************************************************************
-- Liste des lignes à copier : elles ont au moins une étape
-- *******************************************************************
   PROCEDURE lister_pid1(  p_userid  IN     VARCHAR2,
                           p_curseur IN OUT RefCurTyp
                             ) IS
l_lst_chefs_projets VARCHAR2(4000);-- PPM 63485 : augmenter la taille à 4000
req                               VARCHAR2(8000);-- PPM 63485 : augmenter la taille à 2000 + 4000 des chefs projets

BEGIN
        l_lst_chefs_projets := Pack_Global.lire_globaldata(p_userid).chefprojet;


				 req := ' SELECT pid,pid||'' - ''||l.pnom   '
		         || '	FROM LIGNE_BIP l, DATDEBEX d  '
		         || '	WHERE  l.pcpi IN ('|| l_lst_chefs_projets ||')  '
	          	 || '   AND pid IN (SELECT pid FROM ISAC_ETAPE WHERE pid=l.pid) '
				 || '   AND (adatestatut > ADD_MONTHS(d.moismens,-1) OR adatestatut IS NULL ) '
				 || '	ORDER BY 1 ';


 OPEN p_curseur FOR   req;

END lister_pid1;

--*********************************************************************
-- Liste des lignes à renseigner : elles n'ont aucune étape
-- *******************************************************************
   PROCEDURE lister_pid2( 	p_userid  IN     VARCHAR2,
                                p_curseur IN OUT RefCurTyp
                             ) IS
l_lst_chefs_projets VARCHAR2(4000);-- PPM 63485 : augmenter la taille à 4000
req                               VARCHAR2(8000);-- PPM 63485 : augmenter la taille à 2000 + 4000 des chefs projets

BEGIN
        l_lst_chefs_projets := Pack_Global.lire_globaldata(p_userid).chefprojet;


		 req := ' SELECT pid,pid||'' - ''||l.pnom   '
		         || '	FROM LIGNE_BIP l, DATDEBEX d  '
		         || '	WHERE  l.pcpi IN ('|| l_lst_chefs_projets ||')  '
	          	 || '   AND pid NOT IN (SELECT pid FROM ISAC_ETAPE WHERE pid=l.pid) '
				 || '   AND (adatestatut > ADD_MONTHS(d.moismens,-1) OR adatestatut IS  NULL ) '
				 || '	ORDER BY 1 ';


        OPEN p_curseur FOR   req;


END lister_pid2;


--********************************************************************************************************************
-- Procédure de copie de la structure d'une ligne BIP vers une autre ligne BIP qui n'a aucune structure
-- paramètres : 	- p_pid1 : ligne BIP à copier
--			- p_pid2 : ligne BIP qui doît être renseigné
-- *******************************************************************************************************************
PROCEDURE insert_struct ( 	p_pid1       IN LIGNE_BIP.pid%TYPE,
							p_pid2 	     IN LIGNE_BIP.pid%TYPE,
							p_userid     IN  VARCHAR2,
							p_affecter   IN VARCHAR2,
                            p_mois       IN VARCHAR2,
                            p_message    OUT VARCHAR2
                        )  IS
l_exist NUMBER(1);
l_annee NUMBER(4);
l_dmensuelle DATE;
l_dcloture DATE;
l_user VARCHAR2(60);
BEGIN
    l_user:=pack_global.LIRE_GLOBALDATA(p_userid).idarpege;

    --Dans le cas d'une copie avec déplacement des consommés
    -- On vérifie que l'on est pas dans la période de neutralisation
    -- C'est-à-dire entre la mensuelle définitive de décembre et la clôture annuelle
	BEGIN
    IF (p_affecter = 'AVEC') THEN
        SELECT  c.cmensuelle INTO l_dmensuelle
        FROM CALENDRIER c
        WHERE c.calanmois = to_date('12/'||to_char(to_number(to_char(SYSDATE,'YYYY'))-1),'MM/YYYY');

        SELECT  c.ccloture INTO l_dcloture
        FROM CALENDRIER c
        WHERE c.calanmois = to_date('01/'||to_char(to_number(to_char(SYSDATE,'YYYY'))),'MM/YYYY');

    	IF (l_dmensuelle is not null and l_dcloture is not null and to_date(to_char(SYSDATE,'DD/MM/YYYY'),'DD/MM/YYYY') > l_dmensuelle AND to_date(to_char(SYSDATE,'DD/MM/YYYY'),'DD/MM/YYYY') <= l_dcloture) THEN
    		--Période de neutralisation. Opération annulée
    		Pack_Isac.recuperer_message(20033, NULL,NULL, NULL,p_message);
                   	RAISE_APPLICATION_ERROR( -20033,p_message);
    	END IF;

    END IF;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN NULL;

	END;

	--On teste si la ligne à remplir n'a bien aucune structure
	BEGIN
	SELECT  DISTINCT 1 INTO l_exist
	FROM ISAC_ETAPE
	WHERE pid=p_pid2;

	IF (l_exist=1) THEN
		--La structure de la ligne %s1 n'est pas vide. Opération annulée
		Pack_Isac.recuperer_message(20018, '%s1',p_pid2, NULL,p_message);
               	RAISE_APPLICATION_ERROR( -20018,p_message);
	END IF;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN NULL;

	END;

	--copier les étapes de la ligne vers une ligne vide
	INSERT INTO ISAC_ETAPE ( ETAPE,
				 PID ,
				 ECET,
 				 LIBETAPE,
				 TYPETAPE,
 				 FLAGLOCK,
                 JEU     )
	(SELECT  SEQ_ETAPE.NEXTVAL,
		p_pid2,
		ecet,
		libetape,
		typetape,
		0,
        jeu
	FROM ISAC_ETAPE WHERE pid=p_pid1);

	--copier les tâches de la ligne vers une ligne vide
	INSERT INTO ISAC_TACHE (TACHE,
				PID,
				ETAPE  ,
				ACTA ,
				LIBTACHE,
				FLAGLOCK)
	(SELECT  SEQ_TACHE.NEXTVAL,
		e2.pid,
		e2.ETAPE,
		t1.acta,
		t1.libtache,
		0
	FROM ISAC_TACHE t1, ISAC_ETAPE e1, ISAC_ETAPE e2
	 WHERE t1.ETAPE=e1.ETAPE
	AND e1.ecet=e2.ecet
	AND t1.pid=p_pid1
	AND e2.pid=p_pid2);

	--copier les sous-tâches de la ligne vers une ligne vide
	INSERT INTO ISAC_SOUS_TACHE (   SOUS_TACHE,
 					PID ,
 					ETAPE,
 					TACHE ,
 					ACST   ,
 					ASNOM ,
 					AIST   ,
 					ASTA    ,
 					ADEB   ,
 					AFIN   ,
 					ANDE ,
 					ANFI  ,
 					ADUR ,
 					FLAGLOCK       )
	(SELECT  SEQ_SOUS_TACHE.NEXTVAL,
		t2.pid,
		t2.ETAPE,
		t2.TACHE,
		st1.acst,
		asnom,
		aist,
		asta,
		adeb,
		afin,
		ande,
		anfi,
		adur,
		0
	FROM 	ISAC_SOUS_TACHE st1,
		 ISAC_TACHE t1, ISAC_TACHE t2 ,
		ISAC_ETAPE e1, ISAC_ETAPE e2
	WHERE e1.ecet=e2.ecet
		AND e1.ETAPE=t1.ETAPE
		AND e2.ETAPE=t2.ETAPE
		AND t1.acta=t2.acta
		AND st1.TACHE= t1.TACHE
		AND st1.pid=p_pid1
		AND t2.pid=p_pid2);

	--copier les affectations de la ligne vers une ligne vide
	--affceter des ressources est OUI

	IF(p_affecter = 'OUI' OR p_affecter = 'AVEC')THEN

	     INSERT INTO ISAC_AFFECTATION (	SOUS_TACHE,
					 				  	IDENT,
									    PID,
										ETAPE,
										TACHE
									  )
		(SELECT  st2.sous_tache,
		       a1.ident,
		       st2.pid,
			   st2.ETAPE,
			   st2.TACHE
	    FROM ISAC_AFFECTATION a1,
		     ISAC_SOUS_TACHE st1, ISAC_SOUS_TACHE st2,
			 ISAC_TACHE t1, ISAC_TACHE t2 ,
			 ISAC_ETAPE e1, ISAC_ETAPE e2
	   WHERE  e1.ecet=e2.ecet
		      AND e1.ETAPE=t1.ETAPE
			  AND e2.ETAPE=t2.ETAPE
			  AND t1.acta=t2.acta
			  AND st1.TACHE= t1.TACHE
			  AND st2.TACHE=t2.TACHE
			  AND st1.acst=st2.acst
			  AND a1.sous_tache=st1.sous_tache
			  AND a1.pid=st1.pid
			  AND a1.pid=p_pid1
			  AND st2.pid=p_pid2);
	END IF;

    IF(p_affecter = 'AVEC')THEN


         IF(TO_NUMBER(p_mois)>TO_NUMBER(TO_CHAR(SYSDATE,'MM')))THEN
            l_annee := TO_CHAR(TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-1);
         ELSE
            l_annee := TO_CHAR(SYSDATE,'YYYY');
         END IF;
	     INSERT INTO ISAC_CONSOMME ( IDENT,
                                     SOUS_TACHE,
                                     CDEB,
                                     CUSAG,
         							 PID,
									 ETAPE,
									 TACHE
									)
		(SELECT a2.ident,
               st2.sous_tache,
		       c1.cdeb,
               c1.cusag,
		       st2.pid,
			   st2.ETAPE,
			   st2.TACHE
	    FROM ISAC_CONSOMME c1,
             ISAC_AFFECTATION a1, ISAC_AFFECTATION a2,
		     ISAC_SOUS_TACHE st1, ISAC_SOUS_TACHE st2,
			 ISAC_TACHE t1, ISAC_TACHE t2 ,
			 ISAC_ETAPE e1, ISAC_ETAPE e2
	   WHERE  e1.ecet=e2.ecet
		      AND e1.ETAPE=t1.ETAPE
			  AND e2.ETAPE=t2.ETAPE
			  AND t1.acta=t2.acta
			  AND st1.TACHE= t1.TACHE
			  AND st2.TACHE=t2.TACHE
			  AND st1.acst=st2.acst
			  AND a1.sous_tache=st1.sous_tache
              AND a2.sous_tache=st2.sous_tache
              AND a1.ident = a2.ident
              AND c1.sous_tache = a1.sous_tache
              AND c1.ident = a1.ident
			  AND a1.pid=p_pid1
			  AND a2.pid=p_pid2
              AND to_number(to_char(c1.cdeb,'MM'))>=TO_NUMBER(p_mois));

        DELETE FROM ISAC_CONSOMME c1
        WHERE c1.pid=p_pid1
           AND to_number(to_char(c1.cdeb,'MM'))>=TO_NUMBER(p_mois);

           pack_ligne_bip.MAJ_LIGNE_BIP_LOGS(p_pid1,l_user,'Consommés','des conso sont présents','des conso sont supprimés','Déplacement des consommés à compter du mois '||LPAD(p_mois,2,'0')||',vers la ligne '||p_pid2);
           pack_ligne_bip.MAJ_LIGNE_BIP_LOGS(p_pid2,l_user,'Consommés','pas de conso présents','des conso sont créés','Déplacement des consommés à compter du mois '||LPAD(p_mois,2,'0')||',en provenance de la ligne '||p_pid1);

	END IF;

	COMMIT;
          p_message:='Structure copiée';
EXCEPTION
	WHEN OTHERS THEN
		ROLLBACK;
		RAISE_APPLICATION_ERROR( -20997, SQLERRM);

END insert_struct;




--*********************************************************************
-- Liste des ressources origines
-- *******************************************************************
PROCEDURE lister_ident1(  p_userid  IN     VARCHAR2,
                           p_curseur IN OUT RefCurTyp
                             ) IS
l_lst_chefs_projets VARCHAR2(8000);--- PPM 63485 : augmenter la taille à 4000
req                               VARCHAR2(10000);-- PPM 63485 : augmenter la taille à 2000 + 4000 des chefs projets
BEGIN

	l_lst_chefs_projets := Pack_Global.lire_globaldata(p_userid).chefprojet;


		 req := ' SELECT  DISTINCT TO_CHAR(r.ident) ,r.rnom||'' ''||r.rprenom||'' - ''||r.ident LIB  '
		         || '	FROM SITU_RESS_FULL f, RESSOURCE r, ISAC_AFFECTATION ia  '
		         || '	WHERE f.ident=ia.ident  '
		         || '	 AND r.ident=f.ident  '
				 || '	AND ( f.cpident IN ('|| l_lst_chefs_projets ||')  '
	             || '	 OR f.ident IN ('|| l_lst_chefs_projets ||') )  '
		         || '	AND f.type_situ=''N'' '
		         || '	ORDER BY LIB		';


 OPEN p_curseur FOR   req;

END lister_ident1;

--*********************************************************************
-- Liste des ressources déstinations
-- *******************************************************************
PROCEDURE lister_ident2( 	p_userid  IN     VARCHAR2,
                                p_curseur IN OUT RefCurTyp
                             ) IS
l_lst_chefs_projets VARCHAR2(8000);-- PPM 63485 : augmenter la taille à 4000
req                               VARCHAR2(10000);-- PPM 63485 : augmenter la taille à 2000 + 4000 des chefs projets
BEGIN

	l_lst_chefs_projets := Pack_Global.lire_globaldata(p_userid).chefprojet;

	 req := ' SELECT  DISTINCT TO_CHAR(r.ident) ,r.rnom||'' ''||r.rprenom||'' - ''||r.ident LIB  '
		         || '	FROM SITU_RESS_FULL f, RESSOURCE r, DATDEBEX d  '
		         || '	WHERE  r.ident=f.ident  '
				 || '  AND (TRUNC(f.datsitu,''YEAR'') <=TRUNC(d.DATDEBEX,''YEAR'') OR f.datsitu IS NULL)  '
		         || '  AND (TRUNC(f.datdep,''YEAR'') >=TRUNC(d.DATDEBEX,''YEAR'') OR f.datdep IS NULL)  '
				 || '	AND ( f.cpident IN ('|| l_lst_chefs_projets ||')  '
	             || '	 OR f.ident IN ('|| l_lst_chefs_projets ||') )  '
		         || '	AND f.type_situ=''N'' '
		         || '	ORDER BY LIB		';


		 OPEN p_curseur FOR   req;

END lister_ident2;



--********************************************************************************************************************
-- Procédure de copie les affectations d'une ressource à une autre ressource
-- paramètres : 	- p_ident1 : ressource origine
--			        - p_ident2 : ressource déstination
-- *******************************************************************************************************************
PROCEDURE insert_affectation ( 	p_ident1     IN RESSOURCE.ident%TYPE,
							    p_ident2 	 IN RESSOURCE.ident%TYPE,
							    p_userid     IN  VARCHAR2,
							    p_message    OUT VARCHAR2
                              ) IS
l_lst_chefs_projets VARCHAR2(4000);-- PPM 63485 : augmenter la taille à 4000

BEGIN
        l_lst_chefs_projets := Pack_Global.lire_globaldata(p_userid).chefprojet;

	  INSERT INTO ISAC_AFFECTATION (	SOUS_TACHE,
					 				  	IDENT,
									    PID,
										ETAPE,
										TACHE
									)
		(SELECT 	ia.sous_tache,
		            p_ident2,
		            ia.pid,
		  			ia.ETAPE,
					ia.TACHE
		FROM ISAC_AFFECTATION ia
		WHERE ia.ident=p_ident1
		--On affect que des sous taches non affectées
		AND NOT EXISTS (SELECT 1 FROM ISAC_AFFECTATION
		         WHERE ident=p_ident2 AND sous_tache=ia.sous_tache)
	    --uniquement les lignes bip dans isac_etape et
		--leurs chef de projet est le même que l'utilisateur
		AND ia.pid IN ( SELECT l.pid
					    FROM LIGNE_BIP l, ISAC_ETAPE e , DATDEBEX d
					    WHERE INSTR(l_lst_chefs_projets,TO_CHAR(l.pcpi, 'FM00000')) > 0
					    AND l.pid=e.pid
					    AND ( l.adatestatut IS NULL
					       OR l.adatestatut > ADD_MONTHS(d.moismens,-1))
					   )


		);

	COMMIT;
          p_message:='Affectation effectuée';
EXCEPTION
	WHEN OTHERS THEN
		ROLLBACK;
		RAISE_APPLICATION_ERROR( -20997, SQLERRM);


END insert_affectation;



END Pack_Isac_Copie;
/
