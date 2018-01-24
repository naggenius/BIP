-- pack_client_mo PL/SQL
--
-- Equipe SOPRA 
--
-- créé le 05/10/1998
-- Modifié le 8/08/2003 par NBM : suppression de la concaténation pour le clidom
-- 30/11/2004 : EGR : Fiche 93 - modification des codes MO
-- 19/05/2005 : PPR : Autorise les CA de niveau > 0
-- 25/10/2006 : PPR : Ajout Top DIVA

-- Attention le nom du package ne peut etre le nom
-- de la table...

CREATE OR REPLACE PACKAGE pack_client_mo AS

   -- Définition curseur sur la table des clients

   --TYPE client_moCurType IS REF CURSOR RETURN client_mo%ROWTYPE;
   TYPE listeClientMo IS RECORD (	clicode		client_mo.clicode%TYPE,
	                                filcode		client_mo.filcode%TYPE,
	                                clilib		client_mo.clilib%TYPE,
	                                clisigle	client_mo.clisigle%TYPE,
									clidir		client_mo.clidir%TYPE,                                
									clidep		client_mo.clidep%TYPE,
									clipol		client_mo.clipol%TYPE,
									codcamo		client_mo.codcamo%TYPE,
									libcodcamo	centre_activite.clibca%TYPE,
	                                clitopf		client_mo.clitopf%TYPE,
	                               	top_diva	client_mo.top_diva%TYPE,
	                                flaglock	client_mo.flaglock%TYPE);
	TYPE client_moCurType IS REF CURSOR RETURN listeClientMo;
	

   PROCEDURE insert_client_mo ( p_clicode   IN  client_mo.clicode%TYPE,
                                p_filcode   IN  client_mo.filcode%TYPE,
								p_clidir    IN	client_mo.clidir%TYPE,                                
								p_clidep	IN  client_mo.clidep%TYPE,
								p_clipol	IN  client_mo.clipol%TYPE,
								p_codcamo	IN	client_mo.codcamo%TYPE,
                                p_clilib    IN  client_mo.clilib%TYPE,
                                p_clisigle  IN  client_mo.clisigle%TYPE,
                                p_top_diva  IN  client_mo.top_diva%TYPE,
                                p_clitopf   IN  client_mo.clitopf%TYPE,
								p_userid    IN  VARCHAR2,
                                p_nbcurseur 	OUT INTEGER,
                                p_message	OUT VARCHAR2
                              );

   PROCEDURE update_client_mo ( p_clicode   IN  client_mo.clicode%TYPE,
                                p_filcode   IN  client_mo.filcode%TYPE,
								p_clidir    IN	client_mo.clidir%TYPE,                                
                                p_clidep	IN  client_mo.clidep%TYPE,
								p_clipol	IN  client_mo.clipol%TYPE,
								p_codcamo	IN	client_mo.codcamo%TYPE,
                                p_clilib    IN  client_mo.clilib%TYPE,
                                p_clisigle  IN  client_mo.clisigle%TYPE,
                                p_top_diva  IN  client_mo.top_diva%TYPE,
                                p_clitopf   IN  client_mo.clitopf%TYPE,
                                p_flaglock  IN  NUMBER,
                                p_userid    IN  VARCHAR2,
                                p_nbcurseur	OUT INTEGER,
                                p_message	OUT VARCHAR2
                              );

   PROCEDURE delete_client_mo ( p_clicode   IN  client_mo.clicode%TYPE,
								p_clilib    IN  client_mo.clilib%TYPE,
                                p_flaglock  IN  NUMBER,
                                p_userid    IN  VARCHAR2,
                                p_nbcurseur	OUT INTEGER,
                                p_message	OUT VARCHAR2
                              );

   PROCEDURE select_client_mo ( p_clicode       IN client_mo.clicode%TYPE,
                                p_userid        IN VARCHAR2,
                                p_curClient_mo  IN OUT client_moCurType,
                                p_nbcurseur	   OUT INTEGER,
                                p_message	   OUT VARCHAR2
                              );

END pack_client_mo;
/

CREATE OR REPLACE PACKAGE BODY pack_client_mo AS 

   PROCEDURE insert_client_mo ( p_clicode   IN  client_mo.clicode%TYPE,
                                p_filcode   IN  client_mo.filcode%TYPE,
								p_clidir    IN	client_mo.clidir%TYPE,                                
                                p_clidep	IN  client_mo.clidep%TYPE,
								p_clipol	IN  client_mo.clipol%TYPE,
								p_codcamo	IN	client_mo.codcamo%TYPE,
                                p_clilib    IN  client_mo.clilib%TYPE,
                                p_clisigle  IN  client_mo.clisigle%TYPE,
                                p_top_diva  IN  client_mo.top_diva%TYPE,
                                p_clitopf   IN  client_mo.clitopf%TYPE,
                                p_userid    IN  VARCHAR2,
                                p_nbcurseur	OUT INTEGER,
                                p_message	OUT VARCHAR2
                              ) IS 

      l_msg VARCHAR2(1024);
      l_exist NUMBER(1);
   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := ''; 
	
	BEGIN
         INSERT INTO client_mo 
		      ( clicode,
				filcode,
				clisigle,
				clilib,
				clitopf,
				clidir,
				clidep,
				clipol,
				codcamo,
				top_diva
		       )
	   VALUES (	p_clicode, 
	            p_filcode, 
	            p_clisigle, 
	            p_clilib, 
	            p_clitopf,
		  		p_clidir,
		  		p_clidep,
		  		p_clipol,
		  		p_codcamo,
		  		p_top_diva);

	   -- 'Le client ' || p_clilib || ' a été créé';

	   pack_global.recuperer_message( 1, '%s1', p_clilib, NULL, l_msg);
	

         EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
            
		   -- 'Code client déjà créé

	         pack_global.recuperer_message( 20001, NULL, NULL, NULL, l_msg);
               raise_application_error( -20001, l_msg );

		WHEN OTHERS THEN
		   raise_application_error( -20997, SQLERRM);

	END;

   END insert_client_mo;



   PROCEDURE update_client_mo ( p_clicode   IN  client_mo.clicode%TYPE,
                                p_filcode   IN  client_mo.filcode%TYPE,
								p_clidir    IN	client_mo.clidir%TYPE,                                
                                p_clidep	IN  client_mo.clidep%TYPE,
								p_clipol	IN  client_mo.clipol%TYPE,
								p_codcamo	IN	client_mo.codcamo%TYPE,
                                p_clilib    IN  client_mo.clilib%TYPE,
                                p_clisigle  IN  client_mo.clisigle%TYPE,
                                p_top_diva  IN  client_mo.top_diva%TYPE,
                                p_clitopf   IN  client_mo.clitopf%TYPE,
                                p_flaglock  IN  NUMBER,
                                p_userid    IN  VARCHAR2,
								p_nbcurseur	OUT INTEGER,
                                p_message   	OUT VARCHAR2
                              ) IS 

      l_msg VARCHAR2(1024);
      l_exist NUMBER(1);
 BEGIN

-- dbms_output.put_line(p_clicode);

  

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';


-- test que le CAMO est valide - Cela peut être un CA de niveau 0, 1, 2, 3 ou 4
	BEGIN
			select
					distinct 1 into l_exist
				from
					centre_activite
				where
					codcamo=p_codcamo or p_codcamo is null or
					caniv1=p_codcamo or caniv2=p_codcamo or
					caniv3=p_codcamo or caniv4=p_codcamo ;
			EXCEPTION WHEN NO_DATA_FOUND
			THEN
				pack_global.recuperer_message( 2007, NULL, NULL, NULL, l_msg);
	         	raise_application_error( -20505, l_msg );
	END;
	BEGIN
	         UPDATE client_mo
		SET	filcode  = p_filcode,
			clisigle = p_clisigle, 
			clilib   = p_clilib,
		 	clitopf  = p_clitopf,
			flaglock = DECODE( p_flaglock, 1000000, 0, p_flaglock + 1),
			clidir   = p_clidir,
			clidep	 = p_clidep,
			clipol	 = p_clipol,
			codcamo	 = p_codcamo,
			top_diva = p_top_diva
		WHERE clicode = p_clicode
              AND flaglock = p_flaglock;


	   EXCEPTION
		WHEN OTHERS THEN
		   raise_application_error( -20997, SQLERRM);
	END;
	
	
      IF SQL%NOTFOUND THEN
	   
	   -- 'Accès concurrent'

	   pack_global.recuperer_message( 20999, NULL, NULL, NULL, l_msg);
         raise_application_error( -20999, l_msg );
       
      ELSE

	   -- 'Le client ' || p_clilib || ' a été modifié'

	   pack_global.recuperer_message( 2, '%s1', p_clilib , NULL, l_msg);
	   p_message := l_msg;

      END IF;

END update_client_mo;



   PROCEDURE delete_client_mo ( p_clicode   IN  client_mo.clicode%TYPE,
				p_clilib    IN  client_mo.clilib%TYPE,
                                p_flaglock  IN  NUMBER,
                                p_userid    IN  VARCHAR2,
                                p_nbcurseur	OUT INTEGER,
                                p_message	OUT VARCHAR2
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
	   DELETE FROM client_mo
		WHERE clicode  = p_clicode
		  AND flaglock = p_flaglock ;
         
         EXCEPTION
		WHEN referential_integrity THEN

               -- habiller le msg erreur

               pack_global.recuperation_integrite(-2292);
	   
		WHEN OTHERS THEN
		   raise_application_error( -20997, SQLERRM);
      END;

      IF SQL%NOTFOUND THEN
	   
	   -- 'Accès concurrent'

	   pack_global.recuperer_message( 20999, NULL, NULL, NULL, l_msg);
         raise_application_error( -20999, l_msg );
         
      ELSE

	   -- 'Le client ' || p_clilib || ' a été supprimé'

	   pack_global.recuperer_message( 3, '%s1', p_clilib, NULL, l_msg);
	   p_message := l_msg;

      END IF;

   END delete_client_mo;

   PROCEDURE select_client_mo ( p_clicode       IN client_mo.clicode%TYPE,
                                p_userid        IN VARCHAR2,
                                p_curClient_mo  IN OUT client_moCurType,
                                p_nbcurseur        OUT INTEGER,
                                p_message          OUT VARCHAR2
                              ) IS 
	l_msg VARCHAR2(1024);

   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_nbcurseur := 1;
      p_message := '';

      -- Attention ordre des colonnes doit correspondre a l ordre
      -- de declaration dans la table ORACLE (a cause de ROWTYPE)
      -- ou selectionner toutes les colonnes par *

      BEGIN

		OPEN p_curClient_mo FOR
			SELECT
				cmo.clicode,
				cmo.filcode,
				cmo.clilib,
				cmo.clisigle,				 
				cmo.clidir, 
				cmo.clidep,
				cmo.clipol,
				cmo.codcamo,
				ca_niv2.licoes,
				cmo.clitopf,
				cmo.top_diva,
				cmo.flaglock
			FROM
				CLIENT_MO cmo,
				(select es.codcamo, es.licoes from ENTITE_STRUCTURE es where NIVEAU=2) ca_niv2 
			WHERE
				cmo.CLICODE = p_clicode
			AND	cmo.CODCAMO = ca_niv2.CODCAMO(+);

      EXCEPTION

         WHEN OTHERS THEN
          raise_application_error(-20997,SQLERRM);
      END;

      -- en cas absence
	-- p_message := 'Code Client absent';

      pack_global.recuperer_message( 4, '%s1',p_clicode, NULL, l_msg);
      p_message := l_msg;


   END select_client_mo;

END pack_client_mo;
/
