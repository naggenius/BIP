-- pack_multi_ca PL/SQL
-- 
-- Créé le 01/12/2004 par PJO
--
-- Modifié par DDI le 08/03/2006 : Fiche 372. Se baser sur moismens à la place de datdebex pour le controle des CA facturables.
-- Le 07/08/2006 par DDI  : Fiche 451 : Amélioration des messages sur les CA fermés.
-- Modifié par PPR le 12/10/2006 : Remet dedans la fiche 404
-- Modifié par ABA le 01/11/2010 : fiche 827
--*******************************************************************
--

CREATE OR REPLACE PACKAGE pack_multi_ca AS

FUNCTION str_multi_ca 		(p_string     IN  VARCHAR2,
                           	 p_occurence  IN  NUMBER
                          	 ) return VARCHAR2;

PROCEDURE select_multi_ca  	 (	p_pid		IN  ligne_bip.pid%TYPE,
                               		p_userid       	IN  VARCHAR2,
                               		p_pnom		OUT ligne_bip.pnom%TYPE,
                               		p_anneeEx	OUT VARCHAR2,
                               		p_nbpages	OUT VARCHAR2,
                               		p_numpage 	OUT VARCHAR2,
                               		p_nbcurseur	OUT INTEGER,
                               		p_message	OUT VARCHAR2
                             		 );

PROCEDURE update_multi_ca(  	p_string    IN  VARCHAR2,
				p_pid	    IN  VARCHAR2,
                              	p_userid    IN  VARCHAR2,
                              	p_message   OUT VARCHAR2
                             );

PROCEDURE verif_multi_ca(     p_codcamo   IN  VARCHAR2,
			      p_datdeb	  IN  VARCHAR2,
			      p_clicode	  IN  VARCHAR2,
                              p_userid    IN  VARCHAR2,
                              p_libca	  OUT centre_activite.clibrca%TYPE,
                              p_clilib    OUT client_mo.clilib%TYPE,
                              p_message   OUT VARCHAR2
                             );

PROCEDURE verif_edition_multi_ca  (	p_pid		IN  ligne_bip.pid%TYPE,
					p_codsg		IN  VARCHAR2,
                               		p_userid       	IN  VARCHAR2,
                               		p_message	OUT VARCHAR2
                             		 );


END pack_multi_ca;
/


CREATE OR REPLACE PACKAGE BODY     pack_multi_ca AS

   FUNCTION str_multi_ca (p_string     IN  VARCHAR2,
                          p_occurence  IN  NUMBER
                          ) return VARCHAR2 IS
   pos1 NUMBER(6);
   pos2 NUMBER(6);
   str  VARCHAR2(111);

   BEGIN

      pos1 := INSTR(p_string,';',1,p_occurence);
      pos2 := INSTR(p_string,';',1,p_occurence+1);

      IF pos2 != 1 THEN
         str := SUBSTR( p_string, pos1+1, pos2-pos1-1);
         return str;
      ELSE
         return '1';
      END IF;

   END str_multi_ca;

PROCEDURE select_multi_ca  (	p_pid		IN  ligne_bip.pid%TYPE,
                               	p_userid       	IN  VARCHAR2,
                               	p_pnom		OUT ligne_bip.pnom%TYPE,
                               	p_anneeEx	OUT VARCHAR2,
                               	p_nbpages	OUT VARCHAR2,
                               	p_numpage 	OUT VARCHAR2,
                               	p_nbcurseur	OUT INTEGER,
                               	p_message	OUT VARCHAR2
                              	) IS

    -- Nombre de lignes maxi par pages
    NB_LIGNES_PAGES	NUMBER(2)	:= 10;
    -- clé CodCAMO pour indiquer la facturation multi-ca
    CODCAMO_MULTI	VARCHAR2(6)	:= '77777';
    l_msg		VARCHAR2(1024);
    l_nbpages		NUMBER(5);
    l_codcamo		VARCHAR2(6);
    l_codsg 		ligne_bip.codsg%TYPE;
    l_habilitation 	VARCHAR2(10);

    BEGIN
      p_numpage := 'NumPage#1';

      -- Année d'exercice
      SELECT TO_CHAR(datdebex, 'YYYY') INTO p_anneeEx
      FROM datdebex WHERE ROWNUM < 2;

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour
      p_nbcurseur := 1;
      p_message := '';

      -- On vérifie que le PID demandé existe
      -- Et on vérifie que le CODCAMO de la ligne BIP est bien renseigné à CODCAMO_MULTI
      BEGIN
      	SELECT TO_CHAR(codcamo), pnom INTO l_codcamo, p_pnom
      	FROM ligne_bip WHERE pid=p_pid;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
        	pack_global.recuperer_message(20504, '%s1', p_pid, 'pid', l_msg);
	        raise_application_error(-20504, l_msg);
	WHEN OTHERS THEN
		-- Message d'alerte Problème inconnu
	      	raise_application_error(-20997, SQLERRM);
      END;
      IF l_codcamo<>CODCAMO_MULTI THEN
      	pack_global.recuperer_message(20142, '%s1', p_pid, 'pid', l_msg);
	raise_application_error(-20142, l_msg);
      END IF;

      --
      -- On vérifie que l'utilisateur est habilité au PID demandé
      SELECT codsg INTO l_codsg
      FROM   ligne_bip
      WHERE  pid = p_pid;
      l_habilitation := pack_habilitation.fhabili_me(l_codsg, p_userid);
      IF l_habilitation='faux' THEN
        -- Vous n'etes pas autorise a modifier cette ligne BIP, son DPG est
	pack_global.recuperer_message(20365, '%s1',  'modifier cette ligne BIP, son DPG est '||l_codsg, 'PID', l_msg);
        raise_application_error(-20365, l_msg);
      END IF;

      -- On compte le nombre de lignes
      SELECT count(*) INTO l_nbpages
      FROM repartition_ligne WHERE pid=p_pid;

      l_nbpages := CEIL(l_nbpages/NB_LIGNES_PAGES);
      p_nbpages := 'NbPages#'|| l_nbpages;


    END select_multi_ca;


PROCEDURE update_multi_ca(	p_string    IN  VARCHAR2,
				p_pid	    IN  VARCHAR2,
                              	p_userid    IN  VARCHAR2,
                              	p_message   OUT VARCHAR2
                             ) IS

   l_msg    VARCHAR2(10000);
   l_cpt    NUMBER(7);

   l_datdeb  	  VARCHAR2(7);
   l_datdeb_faux  VARCHAR2(7);
   l_taux_faux	repartition_ligne.tauxrep%TYPE;
   l_codcamo 	repartition_ligne.codcamo%TYPE;
   l_clicode 	repartition_ligne.clicode%TYPE;
   l_tauxrep 	repartition_ligne.tauxrep%TYPE;

   l_idarpege	VARCHAR2(60);
   v_clicode 	repartition_ligne.clicode%TYPE;
   v_tauxrep 	repartition_ligne.tauxrep%TYPE;

   BEGIN
      -- Initialiser le message retour
      p_message   := '';
      l_cpt       := 1;
      l_datdeb_faux := '';

  	  l_idarpege := pack_global.lire_globaldata(p_userid).idarpege;

      WHILE l_cpt != 0 LOOP
         l_datdeb  	:= pack_multi_ca.str_multi_ca(p_string,l_cpt);
       	 l_codcamo 	:= TO_NUMBER(pack_multi_ca.str_multi_ca(p_string,l_cpt+1));
       	 l_clicode	:= pack_multi_ca.str_multi_ca(p_string,l_cpt+2);
       	 l_tauxrep 	:= TO_NUMBER(pack_multi_ca.str_multi_ca(p_string,l_cpt+3));


	 -- Si une ligne est retournée
         IF l_datdeb != '0' THEN

            -- Si le taux est égal à 0, on supprime la ligne de la table
            IF l_tauxrep=0 THEN
            	DELETE repartition_ligne
            	WHERE PID=p_pid
            	  AND datdeb = TO_DATE(l_datdeb, 'MM/YYYY')
            	  AND codcamo = l_codcamo;

            	 Pack_Ligne_Bip.maj_ligne_bip_logs(p_pid, l_idarpege, l_codcamo||' CA payeur', l_codcamo, null, 'Suppression CA (multi CA)');

            ELSE
            	BEGIN
					select clicode, tauxrep into v_clicode, v_tauxrep from repartition_ligne
			    	WHERE pid = p_pid
			    	AND datdeb = TO_DATE(l_datdeb, 'MM/YYYY')
			    	AND codcamo = l_codcamo;
				EXCEPTION
				    WHEN NO_DATA_FOUND then
						-- C'est normal si on est en création
						null;
					WHEN OTHERS THEN
						-- Message d'erreur inconnu
						raise_application_error(-20997, SQLERRM);
				END;

	         	UPDATE repartition_ligne
	         	SET clicode = l_clicode,
	         	    tauxrep = l_tauxrep
		    	WHERE pid = p_pid
		    	AND datdeb = TO_DATE(l_datdeb, 'MM/YYYY')
		    	AND codcamo = l_codcamo;

				IF (SQL%NOTFOUND) AND (l_tauxrep > 0) THEN
		    		INSERT INTO repartition_ligne (pid, codcamo, clicode, tauxrep, datdeb)
		    		VALUES (p_pid, l_codcamo, l_clicode, l_tauxrep, TO_DATE(l_datdeb, 'MM/YYYY'));
				    Pack_Ligne_Bip.maj_ligne_bip_logs(p_pid, l_idarpege, l_codcamo||' CA payeur', null, l_codcamo, 'Création CA payeur(multi CA):'||l_datdeb);
				    Pack_Ligne_Bip.maj_ligne_bip_logs(p_pid, l_idarpege, l_codcamo||' Code client', null, l_clicode, 'Création CA payeur(multi CA):'||l_codcamo||' '||l_datdeb);
				    Pack_Ligne_Bip.maj_ligne_bip_logs(p_pid, l_idarpege, l_codcamo||' Taux répartition', null, l_tauxrep, 'Création CA payeur(multi CA):'||l_codcamo||' '||l_datdeb);
				ELSE
					if (nvl(v_clicode,'NULL') != nvl(l_clicode,'NULL')) then
					    Pack_Ligne_Bip.maj_ligne_bip_logs(p_pid, l_idarpege, l_codcamo||' Code client', v_clicode, l_clicode, 'Modif code client(multi CA):'||l_codcamo||' '||l_datdeb);
					end if;
					if (v_tauxrep != l_tauxrep) then
					    Pack_Ligne_Bip.maj_ligne_bip_logs(p_pid, l_idarpege, l_codcamo||' Taux répartition', v_tauxrep, l_tauxrep, 'Modif taux rép(multi CA):'||l_codcamo||' '||l_datdeb);
					end if;
		    	END IF;
	    END IF;
            l_cpt := l_cpt + 4;

         ELSE
            l_cpt :=0;
         END IF;
      END LOOP;

      -- Vérif qu'il reste au moins une ligne de données afin d'éviter la disparition de consommés
      BEGIN
      	SELECT 		TO_CHAR(rl.datdeb, 'MM/YYYY') INTO l_datdeb
      	FROM 		repartition_ligne rl
      	WHERE 		pid = p_pid
      	  AND		ROWNUM < 2;
      EXCEPTION
      	WHEN NO_DATA_FOUND THEN
		-- Les lignes ont voulues être supprimées : Interdit
		pack_global.recuperer_message(20264, '%s1', 'd''exercice', NULL, p_message);
		raise_application_error(-20264, p_message);
	WHEN OTHERS THEN
		-- Message d'erreur inconnu
		raise_application_error(-20997, SQLERRM);
      END;


      -- Mise à jour de datfin : c'est la date datdeb minimale qui est supérieure à datdeb de la ligne
      UPDATE repartition_ligne l
      SET l.datfin = (SELECT MIN(rl.datdeb) FROM repartition_ligne rl WHERE rl.datdeb > l.datdeb AND rl.pid = p_pid)
      WHERE pid = p_pid;

      -- Vérification que tous les taux sont à 100%
      BEGIN
      	SELECT 		TO_CHAR(rl.datdeb, 'MM/YYYY'), st.somme_taux INTO l_datdeb_faux, l_taux_faux
      	FROM 		repartition_ligne rl,
      			(SELECT   rl1.pid, rl1.datdeb, SUM(rl1.tauxrep) AS somme_taux
      			 FROM     repartition_ligne rl1
      			 WHERE    rl1.pid=p_pid
      			 GROUP BY rl1.pid, rl1.datdeb
      			) st
      	WHERE 		rl.pid = st.pid
      	  AND 		rl.datdeb = st.datdeb
      	  AND 		st.somme_taux <> 100
      	  AND		ROWNUM < 2;
      EXCEPTION
      	WHEN NO_DATA_FOUND THEN
		-- C'est normal, tout va bien, on valide
		pack_global.recuperer_message(20977, '%s1', 'Nouveaux taux de répartition', NULL, p_message);
	WHEN OTHERS THEN
		-- Message d'erreur inconnu
		raise_application_error(-20997, SQLERRM);
      END;

      -- Si il y a un taux <> 100%, on envoie un message
      IF (l_datdeb_faux IS NOT NULL) THEN
        pack_global.recuperer_message(20264, '%s1', l_datdeb_faux, '%s2', l_taux_faux, NULL, p_message);
	raise_application_error(-20264, p_message);
      END IF;

   END update_multi_ca;

PROCEDURE verif_multi_ca     (p_codcamo   IN  VARCHAR2,
			      p_datdeb	  IN  VARCHAR2,
                              p_clicode	  IN  VARCHAR2,
                              p_userid    IN  VARCHAR2,
                              p_libca	  OUT centre_activite.clibrca%TYPE,
                              p_clilib    OUT client_mo.clilib%TYPE,
                              p_message   OUT VARCHAR2
                             ) IS

   l_datdebex	datdebex.datdebex%TYPE;
   l_test 	CHAR(1) ;
 l_cdateferm centre_activite.CDATEFERM%TYPE;
 l_cdfain    centre_activite.CDFAIN%TYPE;
 p_clitopf  CHAR(1);

 l_moismens  datdebex.moismens%TYPE;

   BEGIN
     BEGIN
     	-- Vérif CA existe
   	SELECT clibrca INTO p_libca
   	FROM centre_activite
   	WHERE codcamo = TO_NUMBER(p_codcamo);
     EXCEPTION
     	WHEN NO_DATA_FOUND THEN
   	  -- CODCAMO inconnu!
     	  pack_global.recuperer_message(20754, NULL, NULL, 'CODCAMO', p_message);
     	WHEN OTHERS THEN
	  -- Message d'alerte Problème inconnu
	  raise_application_error(-20997, SQLERRM);
     END;


     -- Vérif sur la date saisie
     SELECT datdebex INTO l_datdebex
     FROM datdebex;
     IF TO_DATE(p_datdeb, 'MM/YYYY') < ADD_MONTHS(l_datdebex, -1) THEN
     	  -- Interdit de faire des saisies sur l'exercice antérieur
     	  pack_global.recuperer_message(20313, NULL, NULL, 'DATDEB', p_message);
     END IF;

     -- Retourne le code client
     BEGIN
	     	-- Vérif clicode existe et ouvert 
	   	SELECT clilib, clitopf INTO p_clilib, p_clitopf
	   	FROM client_mo
	   	WHERE clicode = p_clicode;
        
        IF p_clitopf = 'F' THEN
             -- Client fermé 
	   	  pack_global.recuperer_message(20253,'%s1', p_clicode, 'CLICODE', p_message);
        END IF;
         
        
        
        EXCEPTION
	     	WHEN NO_DATA_FOUND THEN
	   	  -- Client inconnu
	   	  pack_global.recuperer_message(4, '%s1', p_clicode, 'CLICODE', p_message);
	     	WHEN OTHERS THEN
		  -- Message d'alerte Problème inconnu
		  raise_application_error(-20997, SQLERRM);
	  END;
    

     -- centre_activite fermé ou non facturable
  	BEGIN
		 SELECT 	c.CDATEFERM, c.CDFAIN, d.moismens INTO l_cdateferm, l_cdfain, l_moismens
		 FROM 	centre_activite c, datdebex d
		 WHERE	c.codcamo=TO_NUMBER(p_codcamo);
		 EXCEPTION
		 WHEN NO_DATA_FOUND THEN
		 		pack_global.recuperer_message( 20986, NULL, NULL, NULL, p_message);

    	 WHEN OTHERS THEN
    	 	  	RAISE_APPLICATION_ERROR( -20997, SQLERRM);
	END;
	BEGIN
		 IF ((l_cdateferm is not null) AND (l_cdateferm < l_moismens) )THEN
		 	pack_global.recuperer_message( 20985, NULL, NULL, NULL, p_message);

		 ELSE
		 	IF (l_cdfain=3) THEN
		 	   pack_global.recuperer_message( 20984, NULL, NULL, NULL, p_message);




		 	END IF;
		 END IF;
	END;



   END verif_multi_ca;

PROCEDURE verif_edition_multi_ca  (p_pid		IN  ligne_bip.pid%TYPE,
				p_codsg		IN  VARCHAR2,
                               	p_userid       	IN  VARCHAR2,
                               	p_message	OUT VARCHAR2
                              	) IS

    l_habilitation 	VARCHAR2(10);
    l_msg		VARCHAR2(1024);

    -- Variables créées pour pouvoir utiliser la fonction select_multi_ca
    --    elles n'ont pas d'autre utilité
    l_numpage 		VARCHAR2(10);
    l_nbpages 		VARCHAR2(10);
    l_pnom 		ligne_bip.pnom%TYPE;
    l_anneeEx 		VARCHAR2(10);
    l_nbcurseur 	INTEGER ;


    BEGIN

	if ( p_pid is null or p_pid ='' ) THEN

	-- Edition Multi-CA par DPG

		-- Vérifie si l'utilisateur est habilité au DPG
	      	pack_habilitation.verif_habili_me(p_codsg, p_userid,l_msg);


	else

	-- Edition Multi-CA par Ligne BIP

	-- Appel de la fonction de controle Edition Multi-CA par ligne BIP
	select_multi_ca  (	p_pid		,
                               	p_userid       	,
                               	l_pnom		,
                               	l_anneeEx	,
                               	l_nbpages	,
                               	l_numpage 	,
                               	l_nbcurseur	,
                               	p_message	);


	end if ;


    END verif_edition_multi_ca;



END pack_multi_ca;
/
