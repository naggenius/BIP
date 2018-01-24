-- pack_budget_ecart PL/SQL
--
-- Créé le 29/03/2006 par DDI .
-- Modifié le __________ par ___ . 
--****************************************************************************
-- Attention le nom du package ne peut etre le nom
-- de la table...

CREATE OR REPLACE PACKAGE pack_budget_ecart AS

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


-- Définition curseur sur la table budget_ecart

   TYPE budget_ecart_ViewType IS RECORD 	( codsg         budget_ecart.codsg%TYPE,
   					          annee	        budget_ecart.annee%TYPE,
   					          pid         	budget_ecart.pid%TYPE,
   					          pnom          budget_ecart.pnom%TYPE,
   					          reestime      budget_ecart.reestime%TYPE,
   					          anmont	budget_ecart.anmont%TYPE,
   					          bpmontme	budget_ecart.bpmontme%TYPE,
   					          bnmont	budget_ecart.bnmont%TYPE,
   					          cusag		budget_ecart.cusag%TYPE,
					          type 	        VARCHAR2(15),
						  valide        CHAR(1),
						  commentaire   VARCHAR2(255)
										    );


   TYPE budget_ecart_CurType IS REF CURSOR RETURN budget_ecart_ViewType;



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
   -- Nom        : select_budget_ecart
   -- Auteur     : DDI
   -- Decription : renvoi la liste des écarts budgétaires
   --
   -- Paramètres : p_codsg (IN) codsg du projet
   --              p_globale  (IN) code de l'activite
   --		   p_curseur(IN OUT) curseur qui contient la liste des écarts
   --              p_nbcurseur  (OUT) nombre de lignes du curseur
   --		   p_message (OUT) message
   -- ------------------------------------------------------------------------
    PROCEDURE select_budget_ecart(	p_codsg		IN VARCHAR2,
			  		p_type      IN VARCHAR2,
					p_global	IN VARCHAR2,
					p_curseur	IN OUT RefCurTyp,
					p_nbcurseur	OUT INTEGER,
					p_message	OUT VARCHAR2
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
   -- Nom        : update_budget_ecart
   -- Auteur     : DDI
   -- Decription : met à jour la table ressource_ecart
   --
   -- Paramètres : p_chaine (IN) Permet de modifier la table budget_ecart
   -- 			   	   contient les clefs pimaires et les nouveaux champs
   --              p_nbcurseur  (OUT) nombre de lignes du curseur
   --			   p_message (OUT) message en cas d'erreur
   -- ------------------------------------------------------------------------
    PROCEDURE update_budget_ecart(	p_chaine	IN  VARCHAR2,
                                    p_nbcurseur OUT INTEGER,
                                    p_message   OUT VARCHAR2
					                 );




   -- ------------------------------------------------------------------------
   -- Nom        : recupere_message_ecart
   -- Auteur     : DDI
   -- Decription : renvoi le corps du message
   --
   -- Paramètres : p_codsg (IN) code du pole
   -- ------------------------------------------------------------------------


    PROCEDURE recupere_message_ecart( p_codsg	IN  VARCHAR2,
	                                  p_curseur 	IN OUT ligne_ecart_CurType
                               	    ) ;



END pack_budget_ecart;
/


CREATE OR REPLACE PACKAGE BODY     pack_budget_ecart AS

--*************************************************************************************************
-- Procédure select_traitement
--
-- renvoi les données du traitement
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
-- *************************************************************************************************
-- Procédure select_budget_ecart
--
-- renvoi la liste des écarts
-- ************************************************************************************************
  PROCEDURE select_budget_ecart (p_codsg 		IN VARCHAR2,
  								 p_type		IN VARCHAR2,
   				 				 p_global		IN VARCHAR2,
                               	 p_curseur 		IN OUT RefCurTyp,
                               	 p_nbcurseur   	   OUT INTEGER,
                               	 p_message     	   OUT VARCHAR2
   					                ) IS

	l_msg VARCHAR2(1024);
	l_codsg NUMBER;
	l_type VARCHAR2(15);
    t_perim_me  VARCHAR(1000);

    BEGIN

    -- Positionner le nb de curseurs ==> 1
    -- Initialiser le message retour
    p_nbcurseur := 1;
    p_message := '';

    t_perim_me := pack_global.lire_globaldata(p_global).perime; 

	IF (p_type = 'TOUS') THEN
	    l_type := '%';
	ELSE
		l_type := p_type||'%';
	END IF;

	IF ( pack_utile.f_verif_dpg(p_codsg)= false ) then -- Message Dep/pole inconnu
		pack_global.recuperer_message(20203, NULL, NULL, NULL, l_msg);
               raise_application_error(-20203,l_msg);

    ELSE

        --verification de l'habilitation du codsg même s'il contient des *
        pack_habilitation.verif_habili_me(p_codsg, p_global,p_message);

        IF ( p_message <> '' ) THEN
           	pack_global.recuperer_message(20364, '%s1', p_codsg, NULL, l_msg);
            raise_application_error(-20364,l_msg);

        ELSE

	        BEGIN
       /*
                t_req := 'SELECT codsg, to_char(annee), pid, pnom, to_char(reestime,''FM999999999990D00''), ';
    		   	t_req := t_req || ' to_char(anmont,''FM999999999990D00''),to_char(bpmontme,''FM999999999990D00''), ';
    		   	t_req := t_req || ' to_char(bnmont,''FM999999999990D00''), to_char(cusag,''FM999999999990D00''), type, ';
    			t_req := t_req || ' valide, commentaire ';
                t_req := t_req || ' FROM budget_ecart';
        		t_req := t_req || ' WHERE 1=1 ';
        		t_req := t_req || ' AND codsg>= to_number(''' || replace(p_codsg,'*','0') || ''') ';
        		t_req := t_req || ' AND codsg<=to_number('''|| replace(p_codsg,'*','9') || ''') ';
        		t_req := t_req || ' AND type like(''' || l_type || ''') ';
                IF ( t_liste_me <> '-1' ) THEN
                    t_req := t_req	|| ' AND codsg IN (';
                    t_req := t_req	|| '        SELECT DISTINCT p.CODSG FROM VUE_DPG_PERIME p WHERE p.CODBDDPG IN (';
                    t_req := t_req	|| t_liste_me;
                    t_req := t_req	|| '                   )';
                    t_req := t_req	|| '             )';
                END IF;                
        		t_req := t_req || ' ORDER BY codsg,pid ';
                */
                
            	OPEN   p_curseur FOR 
                
                  	SELECT
                  		b.codsg,
            			to_char(b.annee),
            		   	b.pid,
            		   	b.pnom,
            		   	to_char(b.reestime,'FM999999999990D00'),
            		   	to_char(b.anmont,'FM999999999990D00'),
            		   	to_char(b.bpmontme,'FM999999999990D00'),
            		   	to_char(b.bnmont,'FM999999999990D00'),
            		   	to_char(b.cusag,'FM999999999990D00'),
            			b.type,
            			b.valide,
            			b.commentaire
                    FROM budget_ecart b, vue_dpg_perime vdp
            		WHERE 1 = 1
                        AND b.codsg = vdp.codsg
                        AND INSTR(t_perim_me, vdp.codbddpg) > 0 
            		    AND b.codsg>=to_number(replace(p_codsg,'*','0'))
                		AND b.codsg<=to_number(replace(p_codsg,'*','9'))
                		AND type like(l_type)
            		ORDER BY b.codsg,b.pid;

          		EXCEPTION
    			WHEN OTHERS THEN
             		raise_application_error( -20997, SQLERRM);
                
            END;

       END IF;

     END IF;

     p_message := l_msg;

   END select_budget_ecart;

--*************************************************************************************************
-- Procédure select_ecart_message
--
-- renvoi la liste des groupes et le nombre d'écarts qui leurs est rattaché
-- ************************************************************************************************
 PROCEDURE select_ecart_message ( p_codsg 		IN VARCHAR2,
   					              p_global		IN VARCHAR2,
                               	  p_curseur 	IN OUT ecart_message_CurType,
                               	  p_nbcurseur   		OUT INTEGER,
                               	  p_message     		OUT VARCHAR2
   					            ) IS

	l_msg VARCHAR2(1024);
	l_codsg NUMBER;

   BEGIN

    -- Positionner le nb de curseurs ==> 1
    -- Initialiser le message retour
	p_nbcurseur := 1;
    p_message := '';



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
					  be.codsg, si.gnom, si.libdsg, COUNT(*)
					  FROM budget_ecart be, struct_info si--,SITU_RESS_full sr
					  WHERE be.valide='N'
					  AND be.codsg=si.codsg
					  AND be.codsg>=to_number(replace(p_codsg,'*','0'))
					  AND be.codsg<=to_number(replace(p_codsg,'*','9'))
					  GROUP BY be.codsg, si.gnom, si.libdsg
					  ORDER BY be.codsg;
			EXCEPTION
			WHEN OTHERS THEN
         		raise_application_error( -20997, SQLERRM);
            END;

       END IF;

     END IF;


     p_message := l_msg;


   END select_ecart_message;




--*************************************************************************************************
-- Procédure update_budget_ecart
--
-- Permet de modifier la table budget_ecart lors de la validation des écarts.
-- ************************************************************************************************
PROCEDURE update_budget_ecart(	p_chaine	IN  VARCHAR2,
		  						p_nbcurseur OUT INTEGER,
								p_message   OUT VARCHAR2
					            ) IS
	l_pos number(7);
	l_pos1 number(7);

	l_debug   VARCHAR2(1) := 'N';
	l_msg     VARCHAR2(1024);

	l_annee          BUDGET_ECART.ANNEE%TYPE;
	l_pid            BUDGET_ECART.PID%TYPE;
	l_type           BUDGET_ECART.TYPE%TYPE;
	l_valide         BUDGET_ECART.VALIDE%TYPE;
	l_commentaire    BUDGET_ECART.COMMENTAIRE%TYPE;
	l_dd varchar2(4);

BEGIN
	l_debug := 'N';

	p_message:='';

    -- p_chaine du type ':annee;pid;type;valide;commentaire:''

	l_pos := 2;
	l_pos1 := INSTR(p_chaine,';',1,1);
	l_annee := to_number(substr(p_chaine,l_pos,l_pos1-l_pos));

	l_pos := INSTR(p_chaine,';',1,1)+1;
	l_pos1 := INSTR(p_chaine,';',1,2);
	l_pid := substr(p_chaine,l_pos,l_pos1-l_pos);

	l_pos := INSTR(p_chaine,';',1,2)+1;
	l_pos1 := INSTR(p_chaine,';',1,3);
	l_type := substr(p_chaine,l_pos,l_pos1-l_pos);

	l_pos := INSTR(p_chaine,';',1,3)+1;
	l_pos1 := INSTR(p_chaine,';',1,4);
	l_valide := substr(p_chaine,l_pos,l_pos1-l_pos);

	l_pos := INSTR(p_chaine,';',1,4)+1;
	l_pos1 := INSTR(p_chaine,':',1,2);
	l_commentaire := substr(p_chaine,l_pos,l_pos1-l_pos);

--	dbms_output.put_line('annee:'||l_annee);
--	dbms_output.put_line('pid:'||l_pid);
--	dbms_output.put_line('type:'||l_type);
--	dbms_output.put_line('valide:'||l_valide);
--	dbms_output.put_line('commentaire:'||l_commentaire);

	UPDATE BUDGET_ECART
	SET valide=l_valide,
	    commentaire=l_commentaire
	WHERE annee=l_annee
	AND pid=l_pid
	AND type=l_type;

	IF SQL%NOTFOUND THEN
	   pack_global.recuperer_message( 20999, NULL, NULL, NULL, l_msg);
	   raise_application_error( -20999, l_msg );
    END IF;

END update_budget_ecart;

--*************************************************************************************************
-- FUNCTION recupere_message_ecart
--
-- renvoi le corps du message mail
-- ************************************************************************************************
PROCEDURE recupere_message_ecart( p_codsg	    IN  VARCHAR2,
	                              p_curseur 	IN OUT ligne_ecart_CurType
                               	)  IS

   BEGIN

   OPEN   p_curseur FOR
           SELECT
		   		 'Mois '||' - '||to_char(da.moismens,'mm/yyyy')||' - Ligne - '||be.pid||' - '||be.commentaire
				 FROM budget_ecart be, datdebex da
				 WHERE be.valide='N'
				 AND be.codsg=to_number(p_codsg)
				 ORDER BY be.pid;

			EXCEPTION
			WHEN OTHERS THEN
         		raise_application_error( -20997, SQLERRM);

END recupere_message_ecart;

END pack_budget_ecart;
/


