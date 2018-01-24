--------------------------------------------------------
--  Fichier créé - lundi-octobre-10-2016   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package PACK_CONCONSH
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "BIP"."PACK_CONCONSH" AS

   PROCEDURE select_conconsh (P_param6  IN VARCHAR2,
                              P_param7  IN VARCHAR2,
                              P_param8  IN VARCHAR2,
                              p_userid  IN  CHAR,
                              p_message OUT VARCHAR2
                             );

END pack_conconsh;

 

/
--------------------------------------------------------
--  DDL for Package Body PACK_CONCONSH
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "BIP"."PACK_CONCONSH" AS

   PROCEDURE select_conconsh (P_param6  IN VARCHAR2,
                              P_param7  IN VARCHAR2,
                              P_param8  IN VARCHAR2,
                              p_userid  IN CHAR,
                              p_message OUT VARCHAR2
                             ) IS

      l_msg   VARCHAR2(1024);
      l_soccode societe.soccode%TYPE;
      l_numcont histo_contrat.numcont%TYPE;
      l_filcode filiale_cli.filcode%TYPE;
      l_centre_frais centre_frais.codcfrais%TYPE;
      l_ccentrefrais centre_frais.codcfrais%TYPE;

   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_message := '';

      l_filcode := pack_global.lire_globaldata(p_userid).filcode;

      -- test d'existance de la societe dans la table des societe
      BEGIN

         SELECT soccode
         INTO   l_soccode
         FROM   societe
         WHERE  soccode = P_param6;

      EXCEPTION

         WHEN NO_DATA_FOUND THEN
            pack_global.recuperer_message(20749, NULL, NULL, NULL, l_msg);
            raise_application_error(-20749,l_msg);

         WHEN OTHERS THEN
            raise_application_error(-20997,SQLERRM);
      END;

      -- TEST existance du numero de contrat dans la table histo_contrat.

      BEGIN

         SELECT distinct numcont
         INTO   l_numcont
         FROM   histo_contrat
         WHERE  rtrim(numcont) = P_param7;

      EXCEPTION

         WHEN NO_DATA_FOUND THEN
            pack_global.recuperer_message(20280, NULL, NULL, NULL, l_msg);
            raise_application_error(-20280,l_msg);

         WHEN OTHERS THEN
            raise_application_error(-20997,SQLERRM);
      END;

      -- TEST existance du numero de contrat dans la table contrat.

      BEGIN

	 SELECT c.numcont
	   INTO   l_numcont
	   FROM   histo_contrat c,
	   societe s,
	   struct_info si,
	   histo_ligne_cont lc,
	   ressource r,
	   filiale_cli f
	   WHERE c.codsg   = si.codsg
	   AND  c.soccont  = lc.soccont
	   AND  c.numcont  = lc.numcont
	   AND  c.cav      = lc.cav
	   AND  lc.ident   = r.ident
	   AND  c.soccont  = s.soccode
	   AND  f.filcode  = c.filcode
	   AND  s.soccode  = P_param6
	   AND  rtrim(c.numcont)  = P_param7
	   AND  c.cav      = P_param8
	   AND  ROWNUM < 2;

      EXCEPTION

         WHEN NO_DATA_FOUND THEN
            pack_global.recuperer_message(20288, NULL, NULL, NULL, l_msg);
            raise_application_error(-20288,l_msg);

         WHEN OTHERS THEN
            raise_application_error(-20997,SQLERRM);
      END;

      -- test d'existance du contrat pour la filiale
      BEGIN
	 SELECT hco.numcont
	   INTO   l_numcont
	   FROM   histo_contrat hco
	   WHERE  hco.soccont  = P_param6
	   AND    rtrim(hco.numcont)  = P_param7
	   AND    hco.cav     = P_param8
	   AND    hco.filcode = l_filcode
	   AND ROWNUM < 2;

      EXCEPTION
	 WHEN NO_DATA_FOUND THEN
	   pack_global.recuperer_message(20289, NULL, NULL, NULL, l_msg);
	   raise_application_error(-20289,l_msg);
	 WHEN OTHERS THEN
	   raise_application_error(-20997,SQLERRM);
      END;

     -- 20/12/2000 :Contrôler que le contrat appartient au centre de frais de l'utilisateur
      -- On récupère le code centre de frais de l'utilisateur
            l_centre_frais:=pack_global.lire_globaldata(p_userid).codcfrais;

     IF l_centre_frais!=0 then    -- le centre de frais 0 donne tout les droits à l'utilisateur
        BEGIN
		select ccentrefrais into l_ccentrefrais
		from histo_contrat
        	where  rtrim(numcont) = P_param7
	 	and	soccont = P_param6
         	and    cav     = P_param8
		and    filcode = l_filcode;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN -- Ce contrat n'est rattaché à aucun centre de frais
			 pack_global.recuperer_message(20336,NULL,NULL,NULL, l_msg);
         		 raise_application_error(-20336, l_msg);

		WHEN OTHERS THEN
               		raise_application_error(-20997,SQLERRM);

	END;
	IF l_ccentrefrais is null  then
		-- Ce contrat n'est rattaché à aucun centre de frais
			 pack_global.recuperer_message(20336, NULL,NULL,NULL, l_msg);
         		 raise_application_error(-20336, l_msg);

	END IF;
  	IF l_ccentrefrais!=l_centre_frais then
		--Le contrat n'existe pas dans le centre de frais mais dans le centre %s2
		 pack_global.recuperer_message(20335, '%s1',to_char(l_centre_frais),'%s2',to_char(l_ccentrefrais),NULL, l_msg);
         	raise_application_error(-20335, l_msg);
	END IF;
     END IF;

   END select_conconsh;

END pack_conconsh;

/
