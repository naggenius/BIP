-- pack_conconsr PL/SQL
--
-- equipe SOPRA
--
-- crée le 29/10/1999
--
-- Attention le nom du package ne peut etre le nom
-- de la table...
--
---- Modifié le 20/12/2000 par NCM : gestion des habilitation suivant le centre de frais
--				le centre de frais est récupéré par la variable globale
--				=>inconvénient : si un utilisateur est affecté à un autre centre de frais,
--				la modification est prise en compte à la prochaine connexion de l'utilisateur
--
---- Modifié  28/04/2009 par ABA TD 737 contrat 27+3
---------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE pack_conconsr AS

   PROCEDURE select_conconsr (P_param6  IN  VARCHAR2,
                              P_param7  IN  VARCHAR2,
                              P_param8  IN  VARCHAR2,
                              p_userid  IN  VARCHAR2,
                              p_message OUT VARCHAR2
                             );

END pack_conconsr;
/


CREATE OR REPLACE PACKAGE BODY     pack_conconsr AS

   PROCEDURE select_conconsr (P_param6  IN VARCHAR2,
                              P_param7  IN VARCHAR2,
                              P_param8  IN VARCHAR2,
                              p_userid  IN VARCHAR2,
                              p_message OUT VARCHAR2
                             ) IS

      l_msg   		VARCHAR2(1024);
      l_soccode 	societe.soccode%TYPE;
      l_numcont 	contrat.numcont%TYPE;
      l_filcode 	filiale_cli.filcode%TYPE;
      l_centre_frais 	centre_frais.codcfrais%TYPE;
      l_ccentrefrais 	centre_frais.codcfrais%TYPE;
      l_cav VARCHAR2(3);

   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_message := '';
      l_cav := lpad(nvl(P_param8,'0'),3,'0');

      l_filcode := pack_global.lire_globaldata(p_userid).filcode;

      -- TEST existence de la societe dans la table societe.

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

      -- TEST existance du numero de contrat dans la table contrat.

      BEGIN

         SELECT distinct numcont
         INTO   l_numcont
         FROM   contrat
         WHERE  rtrim(numcont) = P_param7;

      EXCEPTION

         WHEN NO_DATA_FOUND THEN
            pack_global.recuperer_message(20280, NULL, NULL, NULL, l_msg);
            raise_application_error(-20280,l_msg);

         WHEN OTHERS THEN
            raise_application_error(-20997,SQLERRM);
      END;

      -- TEST existance du numero de contrat dans la table contrat.

     IF (length(P_param8) = 2) THEN
      
      BEGIN

	 SELECT c.numcont
	   INTO l_numcont
	   FROM contrat c,
	   societe s,
	   struct_info si,
	   ligne_cont lc,
	   ressource r,
	   filiale_cli f
	   WHERE c.codsg = 	si.codsg
	   AND   c.soccont = 	lc.soccont
	   AND   c.numcont = 	lc.numcont
	   AND   c.cav = 	lc.cav
	   AND   lc.ident = 	r.ident
	   AND   c.soccont  = 	s.soccode
	   AND   f.filcode  = 	c.filcode
	   AND   s.soccode  = 	P_param6
	   AND   rtrim(c.numcont)  = P_param7
	   AND   c.cav      = 	l_cav
       AND  c.top30 = 'N'
	   AND  ROWNUM < 2;

      EXCEPTION

         WHEN NO_DATA_FOUND THEN
            pack_global.recuperer_message(20287, NULL, NULL, NULL, l_msg);
            raise_application_error(-20287,l_msg);

         WHEN OTHERS THEN
            raise_application_error(-20997,SQLERRM);
      END;
     ELSE
           
      BEGIN

	 SELECT c.numcont
	   INTO l_numcont
	   FROM contrat c,
	   societe s,
	   struct_info si,
	   ligne_cont lc,
	   ressource r,
	   filiale_cli f
	   WHERE c.codsg = 	si.codsg
	   AND   c.soccont = 	lc.soccont
	   AND   c.numcont = 	lc.numcont
	   AND   c.cav = 	lc.cav
	   AND   lc.ident = 	r.ident
	   AND   c.soccont  = 	s.soccode
	   AND   f.filcode  = 	c.filcode
	   AND   s.soccode  = 	P_param6
	   AND   rtrim(c.numcont)  = P_param7
	   AND   c.cav      = 	l_cav
       AND  c.top30 = 'O'
	   AND  ROWNUM < 2;

      EXCEPTION

         WHEN NO_DATA_FOUND THEN
            pack_global.recuperer_message(20287, NULL, NULL, NULL, l_msg);
            raise_application_error(-20287,l_msg);

         WHEN OTHERS THEN
            raise_application_error(-20997,SQLERRM);
      END;
     END IF;

      -- test d'existance du contrat pour la filiale

      BEGIN
	 SELECT con.numcont
	   INTO   l_numcont
	   FROM   contrat con
	   WHERE  con.soccont  = P_param6
	   AND    rtrim(con.numcont)  = P_param7
	   AND    con.cav     = l_cav
	   AND    con.filcode = l_filcode
	   AND ROWNUM < 2;

      EXCEPTION
	 WHEN NO_DATA_FOUND THEN
	   pack_global.recuperer_message(20290, NULL, NULL, NULL, l_msg);
	   raise_application_error(-20290,l_msg);
	 WHEN OTHERS THEN
	   raise_application_error(-20997,SQLERRM);
      END;

     -- 20/12/2000 :Contrôler que le contrat appartient au centre de frais de l'utilisateur
      -- On récupère le code centre de frais de l'utilisateur
            l_centre_frais:=pack_global.lire_globaldata(p_userid).codcfrais;

     IF l_centre_frais!=0 then    -- le centre de frais 0 donne tout les droits à l'utilisateur
        BEGIN
		select ccentrefrais into l_ccentrefrais
		from contrat
        	where  	rtrim(numcont) = P_param7
	 	and	soccont = P_param6
         	and    	cav     = l_cav
		and    	filcode = l_filcode;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN -- Ce contrat n'est rattaché à aucun centre de frais
			 pack_global.recuperer_message(20336, NULL,NULL,NULL, l_msg);
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

   END select_conconsr;

END pack_conconsr;
/


