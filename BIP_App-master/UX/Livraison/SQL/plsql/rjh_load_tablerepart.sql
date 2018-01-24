-- Chargement des tables de répartition 
--
-- Equipe BIP 
--
-- Crée le __/__/2005 par JMA
--
-- 01/02/2006 DDI : Prise en compte du type de table de répartition (P ou A)
-- 31/07/2006 DDI : Suppression du message informatif 21038 ("La ligne BIP est affectée à une autre table de répartition")
--                  Car une ligne T9 peut appartenir à plsrs tables de répartition. 
-- 15/02/2007 VINATIER: Ajout du message d'erreur pour les lignes T9 ou le DPG de la ligne et de la table de répartition
--			sont différent
-- 18/04/2007 VINATIER: prise en compte du code DP des table de répartition au lieu du DPG 
--*************************************************************************************************************
--
-- Attention le nom du package ne peut etre le nom
-- de la table...


CREATE OR REPLACE PACKAGE PACK_RJH_LOAD_TR AS

   -- Définition curseur sur la table RJH_TABREPART

   TYPE LoadTableRepart_ViewType IS RECORD ( codchr RJH_CHARGEMENT.CODCHR%TYPE,
   								 		     codrep RJH_CHARGEMENT.CODREP%TYPE,
   							 		   	 	 moisrep RJH_CHARGEMENT.MOISREP%TYPE,
										 	 fichier RJH_CHARGEMENT.FICHIER%TYPE,
										 	 statut RJH_CHARGEMENT.STATUT%TYPE,
										 	 datechg RJH_CHARGEMENT.DATECHG%TYPE
									       );

   TYPE load_tablerepartCurType_Char IS REF CURSOR RETURN LoadTableRepart_ViewType;

-- ----------------------------------------------------------------------
-- Procédure qui insert un nouveau chargement de table de répartition
-- ----------------------------------------------------------------------
   PROCEDURE insert_table ( p_codrep      	IN  RJH_CHARGEMENT.CODREP%TYPE,
				  		  	p_moisrep     	IN  VARCHAR2,
                            p_fichier     	IN  RJH_CHARGEMENT.FICHIER%TYPE,
                           	p_userid     	IN  VARCHAR2,
				  		  	p_moisfin     	IN  VARCHAR2,
                            p_nbcurseur  	OUT INTEGER,
                            p_message    	OUT VARCHAR2,
                            p_codchr    	OUT VARCHAR2
                          );

-- ----------------------------------------------------------------------
-- Procédure qui modifie le statut d'un nouveau chargement
-- ----------------------------------------------------------------------
   PROCEDURE modifier_statut ( p_codchr     IN  VARCHAR2,
				  		  	   p_statut     IN  VARCHAR2,
                               p_nbcurseur  OUT INTEGER,
                               p_message    OUT VARCHAR2
                             );

-- ----------------------------------------------------------------------------------
-- Procédure qui insert une nouvelle erreur de chargement de table de répartition
-- ----------------------------------------------------------------------------------
   PROCEDURE insert_erreur ( p_codchr      	IN  RJH_CHARGEMENT.CODCHR%TYPE,
				  		  	p_numligne     	IN  NUMBER,
                            p_ligne     	IN  VARCHAR2,
                           	p_erreur     	IN  VARCHAR2,
                            p_nbcurseur  	OUT INTEGER,
                            p_message    	OUT VARCHAR2
                          );

-- ----------------------------------------------------------------------
-- Procédure qui controle qu'une ligne du fichier chargé est conforme
-- ----------------------------------------------------------------------
   PROCEDURE test_ligne_rjh ( p_codrep      IN  RJH_CHARGEMENT.CODREP%TYPE,
				  		  	  p_moisrep     IN  VARCHAR2,
                              p_codcamo     IN  VARCHAR2,
                           	  p_pid     	IN  VARCHAR2,
                              p_nbcurseur  	OUT INTEGER,
                              p_message    	OUT VARCHAR2,
                              p_info    	OUT VARCHAR2,
                              p_erreur    	OUT VARCHAR2
                            );

-- -----------------------------------------------------------------------------------
-- Procédure qui supprime le détail d'une table de répartition pour un mois donné
-- -----------------------------------------------------------------------------------
   PROCEDURE delete_detail ( p_codrep    IN  RJH_TABREPART_DETAIL.CODREP%TYPE,
                             p_moisrep   IN  VARCHAR2,
                          	 p_aff_msg   IN  VARCHAR2,
							 p_typtab    IN  VARCHAR2,
                             p_nbcurseur OUT INTEGER,
                             p_message   OUT VARCHAR2
                           );


-- ----------------------------------------------------------------------
-- Procédure qui insert une ligne dans la table DETAIL
-- ----------------------------------------------------------------------
   PROCEDURE insert_detail ( p_codrep      	IN  RJH_TABREPART_DETAIL.CODREP%TYPE,
				  		  	 p_moisrep     	IN  VARCHAR2,
                             p_pid     	    IN  RJH_TABREPART_DETAIL.PID%TYPE,
                           	 p_taux     	IN  VARCHAR2,
                           	 p_liblignerep  IN  RJH_TABREPART_DETAIL.LIBLIGNEREP%TYPE,
							 p_typtab       IN  VARCHAR2,
							 p_moisfin     	IN  VARCHAR2,
                             p_nbcurseur  	OUT INTEGER,
                             p_message    	OUT VARCHAR2
                           );


-- ----------------------------------------------------------------------
-- Procédure qui duplique le dernier mois saisi
-- ----------------------------------------------------------------------
   PROCEDURE dupliquer_detail ( p_codrep      	IN  RJH_TABREPART_DETAIL.CODREP%TYPE,
				  		  	    p_moisrep     	IN  VARCHAR2,
                                p_nbcurseur  	OUT INTEGER,
                                p_message    	OUT VARCHAR2
                              );

-- ----------------------------------------------------------------------
-- Procédure qui recherche l'exercice courant
-- ----------------------------------------------------------------------
   PROCEDURE get_exercice (  p_nbcurseur  	OUT INTEGER,
                             p_message    	OUT VARCHAR2,
                             p_exercice    	OUT INTEGER
                           );

END PACK_RJH_LOAD_TR;
/
CREATE OR REPLACE PACKAGE BODY PACK_RJH_LOAD_TR AS

-- ----------------------------------------------------------------------
-- Procédure qui insert un nouveau chargement de table de répartition
-- ----------------------------------------------------------------------
PROCEDURE insert_table ( p_codrep      	IN  RJH_CHARGEMENT.CODREP%TYPE,
				  		 p_moisrep     	IN  VARCHAR2,
                         p_fichier     	IN  RJH_CHARGEMENT.FICHIER%TYPE,
                         p_userid     	IN  VARCHAR2,
						 p_moisfin      IN  VARCHAR2,
                         p_nbcurseur  	OUT INTEGER,
                         p_message    	OUT VARCHAR2,
                         p_codchr    	OUT VARCHAR2
                       ) IS
     l_msg 		   VARCHAR2(1024);
	 l_next_codchr NUMBER;
	 l_idarpege    VARCHAR2(20);
BEGIN

    -- Positionner le nb de curseurs ==> 0
    -- Initialiser le message retour
    p_nbcurseur := 0;
    p_message := '';
	l_idarpege := PACK_GLOBAL.lire_globaldata(p_userid).idarpege;

	BEGIN
		select nvl(max(codchr),0)+1
		  into l_next_codchr
		  from RJH_CHARGEMENT;

   	    INSERT INTO RJH_CHARGEMENT (
			   codchr,
	    	   codrep,
 			   moisrep,
 			   fichier,
 			   statut,
			   datechg,
			   userid,
			   moisfin)
        VALUES (
		   	   l_next_codchr,
		   	   p_codrep,
		   	   to_date(p_moisrep,'mm/yyyy'),
		   	   p_fichier,
			   0,
			   sysdate(),
			   l_idarpege,
			   to_date(p_moisfin,'mm/yyyy'));

		p_codchr := to_char(l_next_codchr);
    EXCEPTION
      	WHEN DUP_VAL_ON_INDEX THEN
		    pack_global.recuperer_message( 20008, '%s1', 'chargement '||l_next_codchr, NULL, l_msg);
            raise_application_error( -20008, l_msg );
        WHEN OTHERS THEN
            raise_application_error( -20997, SQLERRM);
    END;

END insert_table;



-- ----------------------------------------------------------------------
-- Procédure qui modifie le statut d'un nouveau chargement
-- ----------------------------------------------------------------------
PROCEDURE modifier_statut ( p_codchr     IN  VARCHAR2,
				  		  	p_statut     IN  VARCHAR2,
                            p_nbcurseur  OUT INTEGER,
                            p_message    OUT VARCHAR2
                          ) IS
BEGIN

    -- Positionner le nb de curseurs ==> 0
    -- Initialiser le message retour
    p_nbcurseur := 0;
    p_message := '';

	update RJH_CHARGEMENT
	   set statut = to_number(p_statut)
	 where codchr = to_number(p_codchr);

END modifier_statut;




-- ----------------------------------------------------------------------------------
-- Procédure qui insert une nouvelle erreur de chargement de table de répartition
-- ----------------------------------------------------------------------------------
PROCEDURE insert_erreur ( p_codchr      IN  RJH_CHARGEMENT.CODCHR%TYPE,
				  		  p_numligne    IN  NUMBER,
                          p_ligne     	IN  VARCHAR2,
                          p_erreur     	IN  VARCHAR2,
                          p_nbcurseur  	OUT INTEGER,
                          p_message    	OUT VARCHAR2
                        ) IS
     l_msg 		   VARCHAR2(1024);
BEGIN

    -- Positionner le nb de curseurs ==> 0
    -- Initialiser le message retour
    p_nbcurseur := 0;
    p_message := '';

	BEGIN
   	    INSERT INTO RJH_CHARG_ERREUR (
			   codchr,
	    	   numligne,
 			   txtligne,
 			   liberr)
        VALUES (
		   	   p_codchr,
		   	   p_numligne,
		   	   p_ligne,
		   	   p_erreur);

    EXCEPTION
      	WHEN DUP_VAL_ON_INDEX THEN
		    pack_global.recuperer_message( 20008, '%s1', 'chargement ', NULL, l_msg);
            raise_application_error( -20008, l_msg );
        WHEN OTHERS THEN
            raise_application_error( -20997, SQLERRM);
    END;

END insert_erreur;






-- ----------------------------------------------------------------------
-- Procédure qui control qu'une ligne du fichier chargé est conforme
-- ----------------------------------------------------------------------
PROCEDURE test_ligne_rjh ( p_codrep      IN  RJH_CHARGEMENT.CODREP%TYPE,
				  		   p_moisrep     IN  VARCHAR2,
                           p_codcamo     IN  VARCHAR2,
                           p_pid     	 IN  VARCHAR2,
                           p_nbcurseur   OUT INTEGER,
                           p_message     OUT VARCHAR2,
                           p_info    	 OUT VARCHAR2,
                           p_erreur    	 OUT VARCHAR2
                         ) IS
     l_msg 		      VARCHAR2(1024);
     l_nb_lign_in_tab NUMBER;
	 l_pid            LIGNE_BIP.PID%TYPE;
	 l_codrep         LIGNE_BIP.CODREP%TYPE;
	 l_typproj        LIGNE_BIP.TYPPROJ%TYPE;
	 l_codcamo        LIGNE_BIP.CODCAMO%TYPE;
	 l_topfer         LIGNE_BIP.TOPFER%TYPE;
	 l_datedebut      LIGNE_BIP.PDATDEBPRE%TYPE;
	 l_cdateferm      CENTRE_ACTIVITE.CDATEFERM%TYPE;
	 l_codsg 		  LIGNE_BIP.CODSG%TYPE;
	 r_coddeppole	  RJH_TABREPART.CODDEPPOLE%TYPE;

BEGIN

    -- Positionner le nb de curseurs ==> 0
    -- Initialiser le message retour
    p_nbcurseur := 0;
    p_message   := '';
	p_info      := 'false';
	p_erreur    := 'false';


	-- --------------------------------
	--    Test existance ligne BIP
	-- --------------------------------
	BEGIN
	    SELECT PID, CODREP, TYPPROJ, CODCAMO, TOPFER, l.PDATDEBPRE, CODSG
		  INTO l_pid, l_codrep, l_typproj, l_codcamo, l_topfer, l_datedebut, l_codsg
		  FROM LIGNE_BIP l
		 WHERE l.pid = p_pid;

		-- Test sur le type de la ligne
		if (l_typproj!=9) then
		    pack_global.recuperer_message( 21037, null, null, NULL, l_msg);
			if (length(p_message)>0) then
			    p_message := p_message || '</li><li>';
			end if;
			p_message := p_message || l_msg;
			p_erreur := 'true';
		end if;

		-- Test si la ligne BIP est fermé
		if (l_topfer <> 'N') then
		    pack_global.recuperer_message( 20371, '%s1', p_pid, NULL, l_msg);
			if (length(p_message)>0) then
			    p_message := p_message || '</li><li>';
			end if;
			p_message := p_message || l_msg;
			p_erreur := 'true';
		end if;

		-- Test si la ligne BIP est ouverte
		if (l_datedebut > to_date(p_moisrep,'mm/yyyy') ) then
		    pack_global.recuperer_message( 21041, null, null, NULL, l_msg);
			if (length(p_message)>0) then
			    p_message := p_message || '</li><li>';
			end if;
			p_message := p_message || l_msg;
			p_info := 'true';
		end if;

		/* Fiche TD456.
		-- Test si la ligne BIP n'est pas déjà dans une autre table de répartition
		BEGIN
		    SELECT count(*)
			  INTO l_nb_lign_in_tab
			  FROM RJH_TABREPART_DETAIL d
			 WHERE d.PID     = p_pid
			   AND d.CODREP != p_codrep
			   AND d.MOISREP = to_date(p_moisrep, 'mm/yyyy');

			if (l_nb_lign_in_tab>0) then
			    pack_global.recuperer_message( 21038, '%s1', l_codrep, NULL, l_msg);
				if (length(p_message)>0) then
				    p_message := p_message || '</li><li>';
				end if;
				p_message := p_message || l_msg;
				p_info := 'true';
			end if;
		END;
		*/

		--Fiche TD531.
		-- Comparaison du code DSG de la ligne Bip et du code DP de la table de répartition
		BEGIN
		    SELECT coddeppole
			  INTO r_coddeppole
			  FROM RJH_TABREPART r
			 WHERE r.CODREP= p_codrep;
			 
			 IF length(l_codsg)=7 THEN l_codsg:=SUBSTR(l_codsg,1,5);
						   ELSE l_codsg:=SUBSTR(l_codsg,1,4);
			 END IF;
			 
			if (l_codsg!=r_coddeppole) then
			    pack_global.recuperer_message( 20994, '%s1', l_pid, NULL, l_msg);
				if (length(p_message)>0) then
				    p_message := p_message || '</li><li>';
				end if;
				p_message := p_message || l_msg;
				p_info := 'true';
			end if;
		END;


		-- Test CA fichier = CA ligne BIP
		if (to_char(l_codcamo) <> p_codcamo) then
		    pack_global.recuperer_message( 21040, null, null, NULL, l_msg);
			if (length(p_message)>0) then
			    p_message := p_message || '</li><li>';
			end if;
			p_message := p_message || l_msg;
			p_info := 'true';
		end if;


		BEGIN
		    SELECT cdateferm
			  INTO l_cdateferm
			  FROM CENTRE_ACTIVITE c
			 WHERE c.CODCAMO = p_codcamo;

			-- Test sur le type de la ligne
			if (to_date(p_moisrep,'mm/yyyy') > l_cdateferm) then
			    pack_global.recuperer_message( 21039, null, null, NULL, l_msg);
				if (length(p_message)>0) then
				    p_message := p_message || '</li><li>';
				end if;
				p_message := p_message || l_msg;
				p_info := 'true';
			end if;

	    EXCEPTION
	      	WHEN NO_DATA_FOUND THEN
			    pack_global.recuperer_message( 21034, '%s1', 'centre d''activité', NULL, l_msg);
				if (length(p_message)>0) then
				    p_message := p_message || '</li><li>';
				end if;
				p_message := p_message || l_msg;
				p_erreur := 'true';
	            return;
	        WHEN OTHERS THEN
	            raise_application_error( -20997, SQLERRM);
	    END;

    EXCEPTION
      	WHEN NO_DATA_FOUND THEN
		    pack_global.recuperer_message( 21034, '%s1', 'ligne BIP', NULL, l_msg);
			if (length(p_message)>0) then
			    p_message := p_message || '</li><li>';
			end if;
			p_message := p_message || l_msg;
			p_erreur := 'true';
            return;
        WHEN OTHERS THEN
            raise_application_error( -20997, SQLERRM);
    END;

END test_ligne_rjh;




-- -----------------------------------------------------------------------------------
-- Procédure qui supprime le détail d'une table de répartition pour un mois donné
-- -----------------------------------------------------------------------------------
PROCEDURE delete_detail ( p_codrep    IN  RJH_TABREPART_DETAIL.CODREP%TYPE,
                          p_moisrep   IN  VARCHAR2,
                          p_aff_msg   IN  VARCHAR2,
						  p_typtab    IN  VARCHAR2,
                          p_nbcurseur OUT INTEGER,
                          p_message   OUT VARCHAR2
                        ) IS
	l_msg VARCHAR2(1024);
    referential_integrity EXCEPTION;
    PRAGMA EXCEPTION_INIT(referential_integrity, -2292);
BEGIN

    -- Positionner le nb de curseurs ==> 0
    -- Initialiser le message retour
    p_nbcurseur := 0;
    p_message := '';

	BEGIN
		-- suppression de la table DETAIL
	    DELETE FROM RJH_TABREPART_DETAIL
		 WHERE codrep = p_codrep
		   AND moisrep = to_date(p_moisrep, 'mm/yyyy')
		   AND typtab = p_typtab;

		if (p_aff_msg='OUI') then
	        pack_global.recuperer_message( 20007, '%s1', 'La table de répartition de type '||p_typtab||' pour le mois de '||p_moisrep||' a été ', NULL, l_msg);
			p_message := l_msg;
		end if;

    EXCEPTION
		WHEN referential_integrity THEN
            -- habiller le msg erreur
            pack_global.recuperation_integrite(-2292);
		WHEN OTHERS THEN
		    raise_application_error( -20997, SQLERRM);
    END;

END delete_detail;



-- ----------------------------------------------------------------------
-- Procédure qui insert une ligne dans la table DETAIL
-- ----------------------------------------------------------------------
PROCEDURE insert_detail ( p_codrep      	IN  RJH_TABREPART_DETAIL.CODREP%TYPE,
				  		  p_moisrep     	IN  VARCHAR2,
                          p_pid     	    IN  RJH_TABREPART_DETAIL.PID%TYPE,
                          p_taux     	    IN  VARCHAR2,
                          p_liblignerep     IN  RJH_TABREPART_DETAIL.LIBLIGNEREP%TYPE,
						  p_typtab          IN  VARCHAR2,
						  p_moisfin     	IN  VARCHAR2,
                          p_nbcurseur  	    OUT INTEGER,
                          p_message    	    OUT VARCHAR2
                       ) IS
     l_msg 		   VARCHAR2(1024);
	 l_next_codchr NUMBER;
	 l_idarpege    VARCHAR2(20);
	 l_annee       VARCHAR2(5);
	 l_numdeb      NUMBER;
	 l_numfin	   NUMBER;
BEGIN

    -- Positionner le nb de curseurs ==> 0
    -- Initialiser le message retour
    p_nbcurseur := 0;
    p_message := '';
	l_annee   := substr(p_moisrep,3,5);
	l_numdeb  := to_number(substr(p_moisrep,1,2));
	l_numfin  := to_number(substr(p_moisfin,1,2));
	DBMS_OUTPUT.put_line('NUMDEB: '||l_numdeb);
	DBMS_OUTPUT.put_line('NUMFIN: '||l_numFIN);
	BEGIN

	FOR i IN l_numdeb..l_numfin LOOP

		BEGIN

   	    INSERT INTO RJH_TABREPART_DETAIL (
			   codrep,
	    	   moisrep,
 			   pid,
 			   tauxrep,
 			   liblignerep,
			   typtab)
        VALUES (
		   	   p_codrep,
		   	   to_date( (lpad(to_char(i),2,0)|| l_annee),'mm/yyyy'),
		   	   p_pid,
			   to_number(p_taux),
			   p_liblignerep,
			   p_typtab);

		EXCEPTION
      	WHEN DUP_VAL_ON_INDEX THEN
			UPDATE RJH_TABREPART_DETAIL SET tauxrep=to_number(p_taux),
				   						    liblignerep=p_liblignerep
				   						WHERE
											codrep=p_codrep
	    	   							and	moisrep = to_date( (lpad(to_char(i),2,0)|| l_annee),'mm/yyyy')
 			   							and	pid = p_pid
										and	typtab = p_typtab;

	--	    pack_global.recuperer_message( 20009, '%s1', p_pid, NULL, l_msg);
	--		p_message := l_msg;

		WHEN OTHERS THEN
            raise_application_error( -20997, SQLERRM);

		END;
	END LOOP;

    END;

END insert_detail;



-- ----------------------------------------------------------------------
-- Procédure qui duplique le dernier mois saisi
-- ----------------------------------------------------------------------
PROCEDURE dupliquer_detail ( p_codrep      	IN  RJH_TABREPART_DETAIL.CODREP%TYPE,
				  		  	 p_moisrep     	IN  VARCHAR2,
                             p_nbcurseur  	OUT INTEGER,
                             p_message    	OUT VARCHAR2
                           ) IS
     l_msg 		   VARCHAR2(1024);
	 l_nb_enr      NUMBER;
	 l_last_month  DATE;
BEGIN

    -- Positionner le nb de curseurs ==> 0
    -- Initialiser le message retour
    p_nbcurseur := 0;
    p_message := '';

	BEGIN
	    SELECT count(*)
		  INTO l_nb_enr
		  FROM RJH_TABREPART_DETAIL
		 WHERE codrep = p_codrep
		   AND moisrep = to_date(p_moisrep, 'mm/yyyy');

		if (l_nb_enr>0) then
			-- Le mois sélectionné est déjà chargé, veuillez d'abord le supprimer
			pack_global.recuperer_message( 20028, NULL, NULL, NULL, l_msg);
	        raise_application_error( -20028, l_msg );
		end if;

	END;

	BEGIN
	    SELECT max(moisrep)
		  INTO l_last_month
		  FROM RJH_TABREPART_DETAIL
		 WHERE codrep = p_codrep;

		if (l_last_month is null) then
		    pack_global.recuperer_message( 20010, NULL, NULL, NULL, l_msg);
            raise_application_error( -20010, l_msg );
		end if;

		BEGIN

	   	    INSERT INTO RJH_TABREPART_DETAIL (
				   codrep,
		    	   moisrep,
	 			   pid,
	 			   tauxrep,
	 			   liblignerep)
			SELECT p_codrep,
			   	   to_date(p_moisrep,'mm/yyyy'),
			   	   pid,
				   tauxrep,
				   liblignerep
			  FROM RJH_TABREPART_DETAIL
			 WHERE codrep = p_codrep
			   AND moisrep = l_last_month;

	    EXCEPTION
	        WHEN OTHERS THEN
	            raise_application_error( -20997, SQLERRM);
	    END;

    EXCEPTION
      	WHEN NO_DATA_FOUND THEN
		    pack_global.recuperer_message( 20010, NULL, NULL, NULL, l_msg);
            raise_application_error( -20010, l_msg );
        WHEN OTHERS THEN
            raise_application_error( -20997, SQLERRM);
    END;

END dupliquer_detail;



-- ----------------------------------------------------------------------
-- Procédure qui recherche l'exercice courant
-- ----------------------------------------------------------------------
PROCEDURE get_exercice ( p_nbcurseur  	OUT INTEGER,
                         p_message    	OUT VARCHAR2,
                         p_exercice    	OUT INTEGER
                       ) IS
	l_annee NUMBER;
BEGIN

	SELECT to_number(to_char(DATDEBEX,'yyyy'))
	  INTO l_annee
	  FROM DATDEBEX;

    p_exercice := l_annee;

EXCEPTION
   	WHEN NO_DATA_FOUND THEN
		p_message := 'Année de l''exercice inconnu.';
    WHEN OTHERS THEN
        raise_application_error( -20997, SQLERRM);

END get_exercice;



END PACK_RJH_LOAD_TR;
/
