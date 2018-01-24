-- Package pour la gestion des écarts
-- Créé    le 24/08/2005 par BAA
-- Modifié le 13/10/2004 par BAA gestion des types de traitement
-- Modifié le 04/07/2012 par BSA QC 1410


CREATE OR REPLACE PACKAGE pack_ressource_ecart AS

------------------------------------------------------------------------------
-- Types et Curseurs

------------------------------------------------------------------------------

TYPE RefCurTyp IS REF CURSOR;

-- Définition curseur du traitement

   TYPE traitement_ViewType IS RECORD ( numtrait            datdebex.NUMTRAIT%TYPE,
   					                    traitement	        VARCHAR2(200),
										nexttrait  			VARCHAR2(10)
   					                  );


   TYPE traitement_CurType IS REF CURSOR RETURN traitement_ViewType;







-- Définition curseur sur la table ressource_ecart

   TYPE ressource_ecart_ViewType IS RECORD ( codsg           struct_info.codsg%TYPE,
   					                         cdeb	         VARCHAR2(7),
   					                         ident	         ressource.ident%TYPE,
   					                         nom 	         ressource.rnom%TYPE,
   					                         fin_contrat     VARCHAR2(10),
   					                         debut_contrat   VARCHAR2(10),
					                         type 	         VARCHAR2(8),
											 nbjbip	         VARCHAR2(7),
   					                         nbjgersh 	     VARCHAR2(7),
   					                         nbjmois         VARCHAR2(7),
   					                         valider         CHAR(1),
											 commentaire     VARCHAR2(255)
										    );


   TYPE ressource_ecart_CurType IS REF CURSOR RETURN ressource_ecart_ViewType;



   -- Définition curseur des ecarts avec messages

   TYPE ecart_message_ViewType IS RECORD ( codsg           situ_ress_full.codsg%TYPE,
   					                       gnom	           struct_info.GNOM%TYPE,
   					                       libdsg    	   struct_info.LIBDSG%TYPE,
										   nombre 		   NUMBER
   					                     );


   TYPE ecart_message_CurType IS REF CURSOR RETURN ecart_message_ViewType;



   -- Définition curseur des lignes des ecarts

   TYPE ligne_ecart_ViewType IS RECORD ( nombre VARCHAR2(800)
                                       );


   TYPE ligne_ecart_CurType IS REF CURSOR RETURN ligne_ecart_ViewType;



   -- ----------------------------------------------------------------------------
   -- Nom        : select_traitement
   -- Auteur     : BAA
   -- Decription : renvoi les données du traitement
   --
   -- Paramètres : p_curseur(IN OUT) curseur qui contient les données du traitement
   --              p_nbcurseur  (OUT) nombre de lignes du curseur
   --			   p_message (OUT) message
   --
   -- -----------------------------------------------------------------------------


    PROCEDURE select_traitement (  p_curseur 	    IN OUT traitement_CurType,
                               	   p_nbcurseur   	OUT INTEGER
                               	 );



   -- ------------------------------------------------------------------------
   -- Nom        : select_ressource_ecart
   -- Auteur     : BAA
   -- Decription : renvoi la liste des écarts
   --
   -- Paramètres : p_codsg (IN) codsg du projet
   --              p_valider  (IN) code du scenario
   --              p_globale  (IN) code de l'activite
   --			   p_curseur(IN OUT) curseur qui contient la liste des écarts
   --              p_nbcurseur  (OUT) nombre de lignes du curseur
   --			   p_message (OUT) message
   --
   -- ------------------------------------------------------------------------


    PROCEDURE select_ressource_ecart ( 	p_codsg 		IN VARCHAR2,
   					                    p_valider		IN VARCHAR2,
   					                    p_global		IN VARCHAR2,
                                        p_curseur 	    IN OUT RefCurTyp,
                               		    p_nbcurseur   	OUT INTEGER,
                               		    p_message     	OUT VARCHAR2
   					                  );


   -- ------------------------------------------------------------------------
   -- Nom        : select_ecart_message
   -- Auteur     : BAA
   -- Decription : renvoi la liste des groupes et le nombre d'écarts
   --
   -- Paramètres : p_codsg (IN) codsg du projet
   --              p_globale  (IN) code de l'activite
   --			   p_curseur(IN OUT) curseur qui contient la liste des écarts
   --              p_nbcurseur  (OUT) nombre de lignes du curseur
   --			   p_message (OUT) message
   --
   -- ------------------------------------------------------------------------


    PROCEDURE select_ecart_message ( 	p_codsg 		IN VARCHAR2,
   					                    p_global		IN VARCHAR2,
                               		    p_curseur 	    IN OUT ecart_message_CurType,
                               		    p_nbcurseur   	OUT INTEGER,
                               		    p_message     	OUT VARCHAR2
   					                  );



   -- ------------------------------------------------------------------------
   -- Nom        : update_ressource_ecart
   -- Auteur     : BAA
   -- Decription : met à jour la table ressource_ecart
   --
   -- Paramètres : p_chaine (IN) Permet de modifier la table ressource_ecart
   -- 			   				 contient les clées pimaires et les noveaux champs
   --              p_nbcurseur  (OUT) nombre de lignes du curseur
   --			   p_message (OUT) message en cas d'erreur
   --
   -- ------------------------------------------------------------------------


    PROCEDURE update_ressource_ecart(	p_chaine	IN  VARCHAR2,
                                        p_nbcurseur OUT INTEGER,
                                        p_message   OUT VARCHAR2
					                 );




   -- ------------------------------------------------------------------------
   -- Nom        : recupere_message_ecart
   -- Auteur     : BAA
   -- Decription : renvoi le corps du message
   --
   -- Paramètres : p_codsg (IN) code du pole
   -- ------------------------------------------------------------------------


    PROCEDURE recupere_message_ecart( p_codsg	IN  VARCHAR2,
	                                  p_curseur 	IN OUT ligne_ecart_CurType
                               	    ) ;



END pack_ressource_ecart;
/


CREATE OR REPLACE PACKAGE BODY     pack_ressource_ecart AS


--*************************************************************************************************
-- Procédure select_traitement
--
-- renvoi les données du traitement
--
-- ************************************************************************************************


  PROCEDURE select_traitement (  p_curseur 	    IN OUT traitement_CurType,
                               	 p_nbcurseur   	OUT INTEGER
                              ) IS



	l_moismens datdebex.moismens%TYPE;
	l_numtrait datdebex.numtrait%TYPE;


   BEGIN


	SELECT moismens, numtrait INTO l_moismens, l_numtrait FROM datdebex;


	IF(l_numtrait = 1) THEN


	   OPEN   p_curseur FOR
              	SELECT l_numtrait, ' à l''issue du 1er traitement', ' Deuxième traitement '||to_char(CPREMENS2,'day dd/MM/yyyy')
				FROM CALENDRIER
				WHERE CALANMOIS=l_moismens;




	ELSIF(l_numtrait = 2) THEN

	   OPEN   p_curseur FOR
              	SELECT l_numtrait, ' à l''issue du 2ème traitement', ' Dernier traitement  '||to_char(CMENSUELLE,'day dd/MM/yyyy')
				FROM CALENDRIER
				WHERE  CALANMOIS=l_moismens;



	ELSIF(l_numtrait = 3) THEN

	   OPEN   p_curseur FOR
              	SELECT l_numtrait, ' à l''issue du dernier traitement', ' merci de corriger ces écarts avant le prochain traitement BIP de ce mois '
				FROM CALENDRIER
				WHERE  CALANMOIS=l_moismens;


	END IF;






   END select_traitement;





--*************************************************************************************************
-- Procédure update_rees
--
-- renvoi la liste des écarts
--
-- ************************************************************************************************



  PROCEDURE select_ressource_ecart ( 	p_codsg 		IN VARCHAR2,
   					                    p_valider		IN VARCHAR2,
   					                    p_global		IN VARCHAR2,
                                        p_curseur 	    IN OUT RefCurTyp,
                               		    p_nbcurseur   		OUT INTEGER,
                               		    p_message     		OUT VARCHAR2
   					                ) IS

    l_msg       VARCHAR2(1024);
    l_codsg     NUMBER;
    t_req       VARCHAR2(1000);
    t_perim_me  VARCHAR(1000);

    BEGIN

    -- Positionner le nb de curseurs ==> 1
    -- Initialiser le message retour
	p_nbcurseur := 1;
    p_message := '';

    t_perim_me := pack_global.lire_globaldata(p_global).perime;

	IF ( pack_utile.f_verif_dpg(p_codsg)= false ) then -- Message Dep/pole inconnu
		pack_global.recuperer_message(20203, NULL, NULL, NULL, l_msg);
               raise_application_error(-20203,l_msg);

    ELSE

    --verification de l'habiltation du codsg même s'il contient des *
    pack_habilitation.verif_habili_me(p_codsg, p_global,p_message);

        IF ( p_message <> '' ) THEN
                	pack_global.recuperer_message(20364, '%s1', p_codsg, NULL, l_msg);
                  raise_application_error(-20364,l_msg);


        ELSE

            BEGIN

                OPEN   p_curseur FOR
                    SELECT 
						  -- FAD PPM Corrective 64640 : Ajout du distinct pour ne pas avoir des doublons
						  DISTINCT
						  -- FAD PPM Corrective 64640 : Fin
    				      sr.codsg,to_char(re.cdeb,'mm/yyyy'),
    					  re.ident,r.rnom,to_char(sr.datsitu,'dd/mm/yyyy'),to_char(sr.datdep,'dd/mm/yyyy'),
    					  DECODE(re.type,'TOTAL','JH',re.type),
    					  TO_CHAR(re.nbjbip,'FM999999990D00'),
    					  TO_CHAR(re.nbjgersh,'FM999999990D0'),
    					  DECODE(re.type,'TOTAL',TO_CHAR(re.nbjmois,'FM999999990D0'),''),
    					  re.valide,re.commentaire
                    FROM RESSOURCE_ECART re, ressource r, SITU_RESS_full sr, vue_dpg_perime vdp
    				WHERE re.valide=p_valider
    				AND r.ident=re.ident
    				AND sr.ident=re.ident
    				AND sr.datsitu=pack_situation_full.datsitu_ressource(re.ident,re.cdeb)
    				AND sr.codsg>=to_number(replace(p_codsg,'*','0'))
    				AND sr.codsg<=to_number(replace(p_codsg,'*','9'))
                    AND sr.codsg = vdp.codsg
                    AND INSTR(t_perim_me, vdp.codbddpg) > 0
                    -- SEL PPM 64202 
                    AND upper(sr.prestation) <> 'SLT'
    				ORDER BY 1,2,4;


            EXCEPTION
            WHEN OTHERS THEN
                  		raise_application_error( -20997, SQLERRM);
            END;

        END IF;

    END IF;


    p_message := l_msg;


   END select_ressource_ecart;



--*************************************************************************************************
-- Procédure update_rees
--
-- renvoi la liste des groupes et le nombre d'écarts
--
-- ************************************************************************************************

 PROCEDURE select_ecart_message ( p_codsg 		IN VARCHAR2,
   					              p_global		IN VARCHAR2,
                               	  p_curseur 	IN OUT ecart_message_CurType,
                               	  p_nbcurseur   		OUT INTEGER,
                               	  p_message     		OUT VARCHAR2
   					            ) IS

	l_msg VARCHAR2(1024);
	l_codsg NUMBER;
	l_perimetre NUMBER;

   BEGIN

    -- Positionner le nb de curseurs ==> 1
    -- Initialiser le message retour
	p_nbcurseur := 1;
    p_message := '';

	--SEL 13/05/2014 PPM 58314
    l_perimetre := pack_global.lire_globaldata(p_global).perime;



	IF ( pack_utile.f_verif_dpg(p_codsg)= false ) then -- Message Dep/pole inconnu
		pack_global.recuperer_message(20203, NULL, NULL, NULL, l_msg);
               raise_application_error(-20203,l_msg);

    ELSE

	  --verification de l'habiltation du codsg même s'il contient des *
	  pack_habilitation.verif_habili_me(p_codsg, p_global,p_message);

	  IF ( p_message <> '' ) THEN
           	pack_global.recuperer_message(20364, '%s1', p_codsg, NULL, l_msg);
	            raise_application_error(-20364,l_msg);


       ELSE

	   BEGIN
        	OPEN   p_curseur FOR
              	SELECT
					  sr.codsg, si.gnom, si.libdsg, COUNT(*)
					  FROM ressource_ecart re, ressource r, SITU_RESS_full sr,struct_info si
					  WHERE re.valide='N'
					  AND r.ident=re.ident
					  AND sr.ident=re.ident
					  AND sr.datsitu=pack_situation_full.datsitu_ressource(re.ident,re.cdeb)
					  AND sr.codsg>=to_number(replace(p_codsg,'*','0'))
					  AND sr.codsg<=to_number(replace(p_codsg,'*','9'))
					  AND si.codsg=sr.codsg
            --SEL 13/05/2014 PPM 58314
            AND sr.codsg IN (select CODSG from VUE_DPG_PERIME WHERE CODBDDPG=l_perimetre)
					  GROUP BY sr.codsg, si.gnom, si.libdsg
					  ORDER BY sr.codsg;
			EXCEPTION
			WHEN OTHERS THEN
         		raise_application_error( -20997, SQLERRM);
            END;

       END IF;

     END IF;


     p_message := l_msg;


   END select_ecart_message;




--*************************************************************************************************
-- Procédure update_rees
--
-- Permet de modifier la table ressource_ecart
--
-- ************************************************************************************************
PROCEDURE update_ressource_ecart(	p_chaine	IN  VARCHAR2,
                                    p_nbcurseur OUT INTEGER,
                                    p_message   OUT VARCHAR2
					            ) IS
	l_pos number(7);
	l_pos1 number(7);

	l_debug   VARCHAR2(1) := 'N';
	l_msg     VARCHAR2(1024);

	l_cdeb           RESSOURCE_ECART.CDEB%TYPE;
	l_ident          RESSOURCE.IDENT%TYPE;
	l_type           RESSOURCE_ECART.TYPE%TYPE;

	l_valide         RESSOURCE_ECART.VALIDE%TYPE;
	l_commentaire    RESSOURCE_ECART.COMMENTAIRE%TYPE;



BEGIN
	l_debug := 'N';

	p_message:='';

    -- p_chaine du type ':cdeb;ident;type;valide;commentaire:''


	l_pos := 2;
	l_pos1 := INSTR(p_chaine,';',1,1);
	l_cdeb := to_date(substr(p_chaine,l_pos,l_pos1-l_pos),'mm/yyyy');



	l_pos := INSTR(p_chaine,';',1,1)+1;
	l_pos1 := INSTR(p_chaine,';',1,2);
	l_ident := to_number(substr(p_chaine,l_pos,l_pos1-l_pos));


	l_pos := INSTR(p_chaine,';',1,2)+1;
	l_pos1 := INSTR(p_chaine,';',1,3);
	l_type := substr(p_chaine,l_pos,l_pos1-l_pos);


	l_pos := INSTR(p_chaine,';',1,3)+1;
	l_pos1 := INSTR(p_chaine,';',1,4);
	l_valide := substr(p_chaine,l_pos,l_pos1-l_pos);



	l_pos := INSTR(p_chaine,';',1,4)+1;
	l_pos1 := INSTR(p_chaine,':',1,2);
	l_commentaire := substr(p_chaine,l_pos,l_pos1-l_pos);




	dbms_output.put_line('cdeb:'||l_cdeb);
	dbms_output.put_line('ident:'||l_ident);
	dbms_output.put_line('type:'||l_type);

	dbms_output.put_line('valide:'||l_valide);
	dbms_output.put_line('commentaire:'||l_commentaire);



	UPDATE RESSOURCE_ECART
	SET valide=l_valide,
	    commentaire=l_commentaire
	WHERE cdeb=l_cdeb
	AND ident=l_ident
	AND type=DECODE(l_type,'JH','TOTAL',l_type);



	IF SQL%NOTFOUND THEN


	   pack_global.recuperer_message( 20999, NULL, NULL, NULL, l_msg);
         raise_application_error( -20999, l_msg );


      END IF;
    COMMIT;

END update_ressource_ecart;





--*************************************************************************************************
-- FUNCTION update_rees
--
-- renvoi le corps du message
--
-- ************************************************************************************************
PROCEDURE recupere_message_ecart( p_codsg	    IN  VARCHAR2,
	                              p_curseur 	IN OUT ligne_ecart_CurType
                               	)  IS


   BEGIN


   OPEN   p_curseur FOR
           SELECT
			        'Mois '||' - '||to_char(re.cdeb,'mm/yyyy')||' - '||r.rnom||' - '||DECODE(re.type,'TOTAL','Consommé BIP : '||TO_CHAR(nbjbip,'FM999999990D0')||' - Nb jours Mois : '||TO_CHAR(nbjmois,'FM999999990D0'),re.type||' BIP : '||TO_CHAR(nbjbip,'FM999999990D0')||' - Gershwin : '||TO_CHAR(nbjgersh,'FM999999990D0'))||' - '||commentaire
					FROM ressource_ecart re, ressource r, SITU_RESS_full sr
					WHERE re.valide='N'
					AND r.ident=re.ident
					AND sr.ident=re.ident
					AND sr.datsitu=pack_situation_full.datsitu_ressource(re.ident,re.cdeb)
					AND sr.codsg=to_number(p_codsg)
					ORDER BY re.cdeb;

			EXCEPTION
			WHEN OTHERS THEN
         		raise_application_error( -20997, SQLERRM);



END recupere_message_ecart;




END pack_ressource_ecart;
/


