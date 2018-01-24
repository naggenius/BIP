
--  pack_ligne_bip PL/SQL
--
-- EQUIPE SOPRA 
--
-- Crée le 10/11/1998
--
-- Modifié le 01/03/1999
--         * Ajout de la fonction de mise à jour et 
--           modifications de la selection
-- 	le 15/03/1999
--         * Modification de la gestion des messages
--	le 22/03/1999
--         * Suppression de la fonction verifier_habilitation
--           pour intégration dans le pack GLOBAL
-- 	le 21/07/2000
--	   * RTRIM(CODPSPE) dans insert et update pour la création de la liste des codes projets spéciaux
--	le 12/02/2001 par NBM
--	   * test sur le code DPG : appartenance au périmètre de l'utilisateur
--	le 16/11/2001 par NBM 
--	   * les champs pobjet01 à pobjet05 sont remplacés par le champ pobjet multiligne
--	   * ajout du champ pzone, nouvelle zone de saisie facultative
-- le  20/01/2004 par NBM : fiche 264 pb quand dossier projet =0 pour un projet de type T1
--
-- Le 25/10/2004 par PJO : Fiche 33 : ajout de logs sur les modifs de données sensibles
-- Le 08/07/2005 par DDI : Fiche 226 : Passage du type2 sur 3 caractères
-- Le 24/08/2005 par BAA : correction de la procedure calcul_base_35 qui incremente un pid 
--                         (pour les pid de 4 caractere)
-- Le 02/11/2005 par JMA : Fiche 308 : ajout de la colonne table de répartition 
-- Le 02/12/2005 par BAA  : Fiche 299 : LOG Ligne BIP - nouvelles zone à surveiller code métier et code application 
-- Le 20/03/2006 par BAA  : Fiche 380 : création de ligne par copie - oter le contrôle de périmètree  
-- Le 25/04/2006 par DDI  : Fiche 372 : Retour - Ajout du controle sur les codcamo fermés dans la fonction update.
-- Le 17/05/2006 par DDI  : Fiche 372 : Retour - Ajout du controle sur les codcamo fermés dans la fonction insert.
-- Le 07/08/2006 par DDI  : Fiche 451 : Amélioration des messages sur les CA fermés.
-- Le 28/08/2006 par DDI  : Fiche 391 : Permettre la modification des lignes inactives aux administrateurs (message 20752).
-- Le 28/08/2006 par DDI  : Fiche 446 : 
-- Le 10/10/2006 par DDI  : Fiche 391 : Annulation de la fiche. 

-- 6.3.0
-- Le 29/06/2007 par EVI  : Fiche 530 : Nouvelle regles pour le statut 'O'

-- 6.3.1
-- Le 16/03/2007 par EVI  : Fiche 483 : LOG Ligne BIP - nouvelles zone à surveiller code dossier projet et code projet
-- Le 11/05/2007 par JAL : Fiche 558 : Vérification Code Mo opérationnel non fermé aprés appui sur bouton valider
-- Le 03/07/2007 par BPO : Fiche 532 : Ajout d un parametre permettant d afficher les CA preconises dans bulle d aide
-- Le 18/07/2007 par BPO : Fiche 532 : Modification de l'affichage des CA preconises dans la bulle d'aide en fonction du type de ligne BIP
-- le 29/01/2008 par EVI : Fiche 532 : Ajoute procedure LISTER_CA_PRECONISES et correction jointure
-- Le 07/02/2008 par EVI : Fiche 483 : correction affichage des logs
-- Le 13/02/2008 par JAL : Fiche  558 : rajout de TRIM sur test Code opérationel  (varchar2) car en table on a par exemple : '104    '  
-- le 04/03/2008 par EVI : Fiche 532 : modification prodecure de recupation CA
-- le 15/04/2008 par EVI : Fiche 532 : correction anomalie, variblle l_liste trop courte
-- le 01/08/2008 par JAL : Fiche 656 : rajout méthodes ramenant l'arbitré actuel et réalisé antérieur
-- le 13/08/2008 par JAL : fiche 656 : dernière version corrigée
-- le 13/08/2008 par JAL : fiche 670 : correction bug sur Update Ligne BIP (test si ligne passe à grand T1 erreur de coding)
-- le 04/11/2008 par ABA : fiche 678 : test de coherence CAMO
-- le 16/10/2009 par YNI : fiche 843 : ajout dans les logs les changements intervenants sur le champ DPG d’une ligne BIP
-- le 29/10/2009 par YNI : fiche 756 : l’affichage des CA préconisés dans l’écran de création/modification des lignes BIP.
-- le 24/11/2009 par YNI : fiche 756 : l’affichage des CA préconisés dans l’écran de création/modification des lignes BIP en mode création.
--******************************************************************************************************************
--
-- Attention le nom du package ne peut etre le nom
-- de la table...
--
create or replace
PACKAGE     Pack_Ligne_Bip AS


   -- definition d'un enregistrement de la table ligne_bip pour la gestion  des entetes

   TYPE ligne_bip_ViewType IS RECORD ( PID         	LIGNE_BIP.PID%TYPE,
                                       PCLE        	LIGNE_BIP.PCLE%TYPE,
                                       PNOM        	LIGNE_BIP.PNOM%TYPE,
                                       ASTATUT     	LIGNE_BIP.ASTATUT%TYPE,
                                       LIBSTATUT   	CODE_STATUT.LIBSTATUT%TYPE,
									   TOPFER      	LIGNE_BIP.TOPFER%TYPE,
                                       ADATESTATUT 	VARCHAR2(10),
                                       TYPPROJ     	TYPE_PROJET.TYPPROJ%TYPE,
                                       LIBTYP      	TYPE_PROJET.LIBTYP%TYPE,
                                       ARCTYPE     	LIGNE_BIP.ARCTYPE%TYPE,
                                       LIBTYP2	   	TYPE_ACTIVITE.LIBARC%TYPE,
                                       CODPSPE     	LIGNE_BIP.CODPSPE%TYPE,
                                       TOPTRI      	LIGNE_BIP.TOPTRI%TYPE,
                                       DPCODE      	CHAR(5),
                                       PDATDEBPRE  	VARCHAR2(7),
                                       ICPI        	LIGNE_BIP.ICPI%TYPE,
                                       CODSG       	LIGNE_BIP.CODSG%TYPE,
                                       AIRT        	LIGNE_BIP.AIRT%TYPE,
                                       PCPI        	LIGNE_BIP.PCPI%TYPE,
                                       CLICODE     	LIGNE_BIP.CLICODE%TYPE,
                                       CLILIB	   	CLIENT_MO.CLILIB%TYPE,
                                       CODCAMO     	LIGNE_BIP.CODCAMO%TYPE,
                                       LIB_CODCAMO	ENTITE_STRUCTURE.LICOES%TYPE,
                                       PNMOUVRA    	LIGNE_BIP.PNMOUVRA%TYPE,
									   METIER      	LIGNE_BIP.METIER%TYPE,
									   POBJET 	   	LIGNE_BIP.POBJET%TYPE,
									   PZONE 	   	LIGNE_BIP.PZONE%TYPE,
									   CLICODE_OPER LIGNE_BIP.CLICODE_OPER%TYPE,
									   CLILIB_OPER 	CLIENT_MO.CLILIB%TYPE,
									   SOUS_TYPO    LIGNE_BIP.SOUS_TYPE%TYPE,
									   LIBSOUSTYPE  SOUS_TYPOLOGIE.LIBSOUSTYPE%TYPE,
									   CODBR		BRANCHES.CODBR%TYPE,
                                       FLAGLOCK    	LIGNE_BIP.FLAGLOCK%TYPE,
									   CODREP		LIGNE_BIP.CODREP%TYPE,
									   LIBCODREP	RJH_TABREPART.LIBREP%TYPE,
									   DPCODE_ACTIF DOSSIER_PROJET.ACTIF%TYPE,
									   ICPI_STATUT	PROJ_INFO.STATUT%TYPE
									);


   -- définition du curseur sur la table ligne_bip pour la gestion de l'entete du projet

   TYPE ligne_bipCurType IS REF CURSOR RETURN ligne_bip_ViewType;

    -- ZAA - PPM 61695
    TYPE LigneClientDBS_ListeViewType IS RECORD(	CLICODE			vue_clicode_perimo.clicode%TYPE,
                                                  OBLIGATION VARCHAR(3));

  -- définition du curseur sur la vue VUE_CLIENT_PERIMO SEL 22/05/2014 PPM 58143 8.6
   TYPE LigneClientDBS_listeCurType IS REF CURSOR RETURN LigneClientDBS_ListeViewType;


   FUNCTION SplitLongLine (chaine VARCHAR2) RETURN VARCHAR2;

   FUNCTION controle_obj (objet VARCHAR2) RETURN VARCHAR2;

   PROCEDURE maj_ligne_bip_logs(p_pid			IN LIGNE_BIP_LOGS.pid%TYPE,
							    p_user_log		IN LIGNE_BIP_LOGS.user_log%TYPE,
								p_colonne		IN LIGNE_BIP_LOGS.colonne%TYPE,
								p_valeur_prec	IN LIGNE_BIP_LOGS.valeur_prec%TYPE,
								p_valeur_nouv	IN LIGNE_BIP_LOGS.valeur_nouv%TYPE,
								p_commentaire	IN LIGNE_BIP_LOGS.commentaire%TYPE
								);

   PROCEDURE select_ligne_bip ( p_pnom         IN VARCHAR2,
                                p_pid          IN CHAR,
                                p_userid       IN VARCHAR2,
								p_duplic       IN VARCHAR2,
                                p_curLigne_bip IN OUT ligne_bipCurType,
								p_liste        OUT VARCHAR2, -- TD 532 (Liste des CA preconises)
                                p_nbcurseur    OUT INTEGER,
                                p_message      OUT VARCHAR2
                              );

   PROCEDURE insert_ligne_bip (
							   p_pnom       	IN VARCHAR2,
                               p_typproj    	IN CHAR,
							   p_pdatdebpre 	IN CHAR,
                               p_arctype    	IN VARCHAR2,
							   p_toptri     	IN CHAR,
                               p_codpspe    	IN CHAR,
                               p_icpi       	IN CHAR,
							   p_airt       	IN CHAR,
                               p_dpcode     	IN CHAR,
                               p_codsg      	IN CHAR,
                               p_pcpi       	IN CHAR,
                               p_clicode    	IN CHAR,
                               p_codcamo    	IN CHAR,
                               p_pnmouvra   	IN CHAR,
							   p_metier     	IN CHAR, --aur
                               p_liste_objet	IN VARCHAR2,
							   p_pobjet     	IN VARCHAR2,
							   p_pzone     		IN VARCHAR2,
							   p_clicode_oper	IN VARCHAR2,
							   p_sous_typo		IN VARCHAR2,
							   p_codrep			IN VARCHAR2,
                               p_userid     	IN VARCHAR2,
                               p_pid        	OUT CHAR,
                               p_pcle       	OUT CHAR,
                               p_nbcurseur  	OUT INTEGER,
                               p_message    	OUT VARCHAR2
                              );


   PROCEDURE calcul_pid ( p_pid IN OUT VARCHAR2 );

   PROCEDURE calcul_base_35 ( p_pidMax IN VARCHAR2,
                              p_pid IN OUT VARCHAR2 );

   PROCEDURE calcul_cle ( p_pid IN VARCHAR2,
                          p_cle OUT VARCHAR2 );


   PROCEDURE update_ligne_bip ( p_typproj     	IN CHAR,
								p_pid         	IN CHAR,
                                p_pcle        	IN CHAR,
                                p_pnom        	IN VARCHAR2,
                                p_astatut     	IN CHAR,
								p_topfer      	IN CHAR,
                                p_adatestatut 	IN CHAR,
								p_pdatdebpre  	IN CHAR,
                                p_arctype     	IN VARCHAR2,
								p_toptri      	IN CHAR,
                                p_codpspe     	IN CHAR,
                                p_icpi        	IN CHAR,
								p_airt        	IN CHAR,
                                p_dpcode      	IN CHAR,
                                p_codsg       	IN CHAR,
                                p_pcpi        	IN CHAR,
                                p_clicode     	IN CHAR,
                                p_codcamo     	IN CHAR,
                                p_pnmouvra    	IN CHAR,
                                p_metier      	IN CHAR,  --aur nouvelle valeur
								p_pobjet      	IN VARCHAR2,
								p_liste_objet 	IN VARCHAR2,
								p_pzone       	IN VARCHAR2,
								p_clicode_oper	IN VARCHAR2,
								p_sous_typo		IN VARCHAR2,
								p_flaglock    	IN NUMBER,
								p_codrep		IN VARCHAR2,
                                p_userid      	IN VARCHAR2,
                                p_nbcurseur   	OUT INTEGER,
                                p_message     	OUT VARCHAR2
                              );

PROCEDURE RECUPERER_CODE_BRANCHE(p_clicode		IN	CLIENT_MO.clicode%TYPE,
								 p_codbr		OUT	VARCHAR2,
                                 p_libbr        OUT VARCHAR2,
                                 p_libdir       OUT VARCHAR2,
								 p_message		OUT VARCHAR2);

PROCEDURE REMISE_A_ZERO(p_pid		IN	LIGNE_BIP.pid%TYPE,
                        p_userid   	IN  VARCHAR2,
                        p_message	OUT VARCHAR2);

-- TD 532
-- TYPE CA_preconise_ListeViewType IS RECORD(libelle	VARCHAR2(60));

--TYPE caPreconise_listeCurType IS REF CURSOR RETURN CA_preconise_ListeViewType;

FUNCTION EST_LISTE_CA_PRECONISES(p_PID		LIGNE_BIP.PID%TYPE
							    ) RETURN VARCHAR2;



FUNCTION EST_DANS_LISTE_CA_PRECONISE(p_CODCAMO	LIGNE_BIP.CODCAMO%TYPE,
									 p_AIRT		LIGNE_BIP.AIRT%TYPE,
									 p_ICPI		LIGNE_BIP.ICPI%TYPE
									) RETURN NUMBER;

PROCEDURE RECUPERER_CA_PRECONISE_APPLI(p_TYPACT   	IN VARCHAR2,
									   p_AIRT 	  	IN APPLICATION.AIRT%TYPE,
									   p_CODCAMO1 	IN OUT APPLICATION.CODCAMO1%TYPE,
									   p_CODCAMO2 	IN OUT APPLICATION.CODCAMO2%TYPE,
									   p_CODCAMO3 	IN OUT APPLICATION.CODCAMO3%TYPE,
									   p_CODCAMO4 	IN OUT APPLICATION.CODCAMO4%TYPE,
									   p_CODCAMO5 	IN OUT APPLICATION.CODCAMO5%TYPE,
									   p_CODCAMO6 	IN OUT APPLICATION.CODCAMO6%TYPE,
									   p_CODCAMO7 	IN OUT APPLICATION.CODCAMO7%TYPE,
									   p_CODCAMO8 	IN OUT APPLICATION.CODCAMO8%TYPE,
									   p_CODCAMO9 	IN OUT APPLICATION.CODCAMO9%TYPE,
									   p_CODCAMO10 	IN OUT APPLICATION.CODCAMO10%TYPE
									   );
--Ajout des arguments p_arctype et p_pid pour la fiche 756
PROCEDURE LISTER_CA_PRECONISES(p_icpi  IN PROJ_INFO.ICPI%TYPE,
		  					   p_airt  IN APPLICATION.AIRT%TYPE,
							   p_typproj IN LIGNE_BIP.TYPPROJ%TYPE,
                               p_arctype IN LIGNE_BIP.ARCTYPE%TYPE,
                               p_pid IN LIGNE_BIP.PID%TYPE,
          					   p_liste   OUT VARCHAR2);

--------------------------------- Fiche 656 --------------------------------------------
PROCEDURE recherche_realise_anterieur(p_pid IN VARCHAR2 ,
                                      p_realise OUT VARCHAR2  );

PROCEDURE recherche_arbitre_actuel(p_pid IN VARCHAR2 ,
                                   p_arbitre OUT VARCHAR2 );


-- Procédure de création des étape, tâche, sous-tâches d'une ligne BIP correspondant aux absences
-- ABN - HP PPM 64630
PROCEDURE creer_ligne_bip_absence(p_pid IN LIGNE_BIP.PID%TYPE, p_message OUT VARCHAR2);

-- Procédure de création des étape, tâche, sous-tâches d'une ligne BIP correspondant au hors projet
PROCEDURE creer_ligne_prod_hors_projet(p_pid IN LIGNE_BIP.PID%TYPE, p_direction IN VARCHAR2, p_message  OUT    VARCHAR2);

-- Procédure de création des étapes, tâches, sous-tâches d'une ligne productive en mode projet
-- ABN - HP PPM 64630
PROCEDURE creer_ligne_prod_en_projet(p_pid IN LIGNE_BIP.PID%TYPE, p_jeu IN TYPE_ETAPE_JEUX.JEU%TYPE, p_message OUT VARCHAR2);

-- Procédure de liste des directions à DBS obligatoire SEL 22/05/2014 PPM 58143 8.6
PROCEDURE lister_clients_dbs (p_userid  IN VARCHAR2,p_curseur IN OUT LigneClientDBS_listeCurType,message OUT VARCHAR2);

-- Procédure de récupération du code direction du client SEL 22/05/2014 PPM 58143 8.6
PROCEDURE RECUPERER_PARAM_APP(p_code_action		IN	VARCHAR2,
                p_code_version		IN	VARCHAR2,
                p_num_ligne		IN	VARCHAR2,
                p_valeur		OUT	VARCHAR2,
                p_message		OUT VARCHAR2);

--FAD: Récupération du séparateur du paramètre applicatif
PROCEDURE RECUPERER_SEPAR_PARAM_APP(p_code_action		IN	VARCHAR2,
                p_code_version		IN	VARCHAR2,
                p_num_ligne		IN	VARCHAR2,
                p_valeur		OUT	VARCHAR2,
                p_message		OUT VARCHAR2);


TYPE t_array IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
FUNCTION SPLIT (p_in_string VARCHAR2, p_delim VARCHAR2) RETURN t_array;

-- SEL 28/05/2014 PPM 58143 8.6
FUNCTION est_client_dbs(p_clicode VARCHAR2) RETURN boolean;

--SEL PPM 60612
PROCEDURE SUPPRIMER_SR_SI_EXISTE( p_pid IN VARCHAR2,
                                  p_user_id IN VARCHAR2,
                                  p_message OUT VARCHAR2);


--SEL PPM 60612
PROCEDURE IS_LIGNEBIP_A_SR( p_pid IN VARCHAR2,
                                  p_user_id IN VARCHAR2,
                                  p_message OUT VARCHAR2);


--HMI - PPM 60709 : $5.3 QC 1785
FUNCTION controle_parametrage(p_pid IN varchar2, p_direction IN varchar2)  RETURN BOOLEAN;
--KRA PPM 62325
FUNCTION demande_ligne_bip(P_PERIME IN VARCHAR2) RETURN NUMBER;

--ZAA PPM 62325 F7
FUNCTION RecupDmpNonUtilisee RETURN NUMBER;
--Debut FAD PPM 64269 : Régul PPM 63824 : HMI
FUNCTION verif_RBDF_param_reglage(p_icpi  IN  PROJ_INFO.icpi%TYPE,
									p_clicode   IN  PROJ_INFO.CLICODE%TYPE,
									p_codsg         IN  VARCHAR2,
									p_pid IN LIGNE_BIP.pid%TYPE
									) RETURN VARCHAR2 ;

-- FAD PPM 64770 : Ajout du PID dans les paramètres de cette fonction pour vérifier le consomme et le type de la ligne BIP
FUNCTION verif_RBDF_DirPrin( p_icpi  IN  PROJ_INFO.icpi%TYPE,
                              p_dpcode        IN  NUMBER,
							  p_pid IN LIGNE_BIP.pid%TYPE ) RETURN VARCHAR2;
-- FAD PPM 64770 : Fin
                              
 PROCEDURE VERIFIER_MAJ_DP_Proj ( p_pid      IN  VARCHAR2,
                                 p_dpcode        IN  NUMBER,
                                 p_icpi  IN  PROJ_INFO.icpi%TYPE,
                                 p_clicode   IN  PROJ_INFO.CLICODE%TYPE,
                                 p_codsg         IN  VARCHAR2,  
                                 p_message OUT VARCHAR2,
                                 p_codeproj OUT PROJ_INFO.icpi%TYPE
                                 );
 --Fin FAD PPM 64269 : Régul PPM 63824 : HMI
-- FAD PPM 64240 : Régul SEL PPM 63412 : ???
PROCEDURE isClientBBRF03(p_clicode in varchar2,p_retour out number);

-- FAD PPM 64240 : Lister les DPCOPI à partir du DP
PROCEDURE lister_dpcopi_par_dp (p_userid     IN VARCHAR2,
                                p_dpcode VARCHAR2  ,
                                p_dpcopiCurType IN OUT pack_copi_budget.dpcopiCurType
                                  );
-- FAD PPM 64240 : Lister les projet à partir du DPCOPI
PROCEDURE lister_projet(	p_userid   IN 	  VARCHAR2,
   				p_dpcode   IN 	  VARCHAR2,
          p_dpcopicode   IN 	  VARCHAR2,
             	       		p_curseur  IN OUT pack_liste_proj_info.lib_listeCurType
            )         ;      
-- FAD PPM 64240 : Régul SEL PPM 63412 : ???
PROCEDURE recup_dpcopi(p_projet in VARCHAR2,p_dpcopi out VARCHAR2);

-- FAD PPM 64240 : Récupération du DPCOPI à partir du PID
PROCEDURE SELECT_DPCOPI_PID(P_PID IN VARCHAR2, P_DPCOPI OUT VARCHAR2);
-- FAD PPM 64240 : Fin


END Pack_Ligne_Bip;

/
create or replace
PACKAGE BODY     Pack_Ligne_Bip AS

   FUNCTION SplitLongLine (chaine VARCHAR2) RETURN VARCHAR2 IS
	pos NUMBER;
	aux VARCHAR2(100);
   BEGIN
	IF (LENGTH(chaine) <= 60) OR chaine IS NULL THEN
		RETURN(chaine);
	ELSE
		aux := SUBSTR (chaine,1,60);
		pos := INSTR(aux,' ',-1,1);
-- on traite ici le cas des mots de + de 60 caracteres (genre testeurs fous ou endormis sur le clavier)
		IF (pos=0) THEN
			pos:=60;
		END IF;
		RETURN ( SUBSTR(chaine,1,pos-1) || CHR(10) || SplitLongLine (SUBSTR(chaine,pos+1)));
  	END IF;
   END;


  FUNCTION controle_obj (objet VARCHAR2) RETURN VARCHAR2 IS
	l_nbligne 	NUMBER;
      	ligne		VARCHAR2(2000);
      	objet_split	VARCHAR2(2000);
      	chaine		VARCHAR2(2000);
      	pos 		NUMBER;
      	msg 		VARCHAR(1024);

   BEGIN
	-- chaque ligne de l'objet doit faire moins de 60 caractères
	-- sinon au 60ème caractère on met un retour chariot

	-- recherche de la première ligne , on récupère la chaine de caractères qui va jusqu'au premier retour chariot
	--et on répète les opérations jusqu'à la dernière ligne
	objet_split:='';
	chaine:=REPLACE(objet, CHR(13), '');
	chaine:=RTRIM(chaine, CHR(10));
 	<<boucle>> LOOP
		pos := INSTR(chaine,CHR(10));
		IF (pos=0) THEN
			ligne:=chaine;
			chaine:='';
		ELSE
			ligne := SUBSTR(chaine,1,pos-1);
			chaine:= SUBSTR(chaine, pos+1);
		END IF;

	-- test la longueur de la  ligne
		objet_split := objet_split || CHR(10) || SplitLongLine (ligne);

		EXIT boucle WHEN chaine IS NULL;
    NULL;
	END LOOP;
-- suppression du 1er retour chariot
	objet_split:=SUBSTR(objet_split, 2);

      -- On vérifie que le champ objet ne dépasse pas 5 lignes
	l_nbligne := INSTR(objet_split,CHR(10), 1, 5);
	IF (l_nbligne>0) THEN
		--Le champ objet ne doit pas dépasser 5 lignes
		Pack_Global.recuperer_message(20378, NULL, NULL, 'LISTE_OBJET', msg);
                RAISE_APPLICATION_ERROR(-20378, msg);

	END IF;
        RETURN(objet_split);
   END;

------------------------------------------------------------------------------------------------------

   PROCEDURE calcul_pid ( p_pid IN OUT VARCHAR2 ) IS
      pidMax VARCHAR2(4);
      tampon NUMBER(1);
   BEGIN

      -- Attention la requete :
      -- SELECT MAX(PID) INTO pidMax FROM LIGNE_BIP;
      -- ne marche pas (la base 35 est construite selon ordre
      -- binaire des lettres puis des chiffres en vigueur en EBCDIC
      -- sur le site central IBM...
      -- => conversions necessaires pour recuperer la
      --    valeur pid maximale dans la table.


	SELECT 1
	INTO tampon
	FROM LIGNE_BIP
	WHERE LENGTH(RTRIM(pid))=4
	AND ROWNUM=1;

      	SELECT CONVERT( MAX( CONVERT( pid, 'WE8EBCDIC500' ) ),
                	      'WE8PC850',
                	      'WE8EBCDIC500'
                	    )
      	INTO pidMax
      	FROM LIGNE_BIP
      	WHERE LENGTH(RTRIM(pid))=4;

      	calcul_base_35( pidMax, p_pid );

   EXCEPTION

   	WHEN NO_DATA_FOUND THEN
   		SELECT CONVERT( MAX( CONVERT( pid, 'WE8EBCDIC500' ) ),
                	      'WE8PC850',
                	      'WE8EBCDIC500'
                	    )
      		INTO pidMax
      		FROM LIGNE_BIP;

      		IF pidMax IS NULL THEN
        		 p_pid := 'AAA';
      		ELSE
         		calcul_base_35( pidMax, p_pid );
      		END IF;

   END calcul_pid;

------------------------------------------------------------------------------------------------------

   PROCEDURE calcul_base_35 ( p_pidMax IN VARCHAR2,
                              p_pid    IN OUT VARCHAR2
                            ) IS
	msg VARCHAR(1024);
	base35 CHAR(35) := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ123456789';
	base26 CHAR(26) := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
	position NUMBER;
	pidMax VARCHAR2(4);
	longueur NUMBER;

   BEGIN
      -- debut calcul
      -- copie parametre

      pidMax := p_pidMax;

      -- On détermine s'il sagit d'un pid à 3 ou 4 caractères
      SELECT LENGTH(RTRIM(pidMax)) INTO longueur
      FROM dual;

      -- On garde un triatement spécifique pour les PID à 3 caractères en attendant
      -- que tous les PID soient sur 4.
      IF longueur = 3 THEN
           -- calcul de la valeur en base 35 du dernier caractere pour incrementation
           position := INSTR( base35, SUBSTR( pidMax,3, 1) );

           IF position < 35 THEN
             -- incrementer simplement le dernier caractere
             p_pid := SUBSTR( pidMax, 1, 2) || SUBSTR( base35, position+1, 1 );

           ELSE
              -- if faut incrementer le caractere du milieu
              position := INSTR( base35, SUBSTR( pidMax, 2, 1) );

              IF position < 35 THEN
                 -- incrementer simplement le caractere du milieu
                 -- le dernier caractere est 'A'
                 p_pid := SUBSTR(pidMax,1,1)||SUBSTR( base35, position+1, 1 ) ||'A';

              ELSE
                      -- if faut incrementer le premier caractere
                 position := INSTR( base26, SUBSTR( pidMax, 1, 1) );

                 IF position < 26 THEN
                    -- les 2 derniers caracteres sont 'AA'

                    p_pid := SUBSTR( base26, position+1, 1 ) || 'AA';
                 ELSE
                    -- on passe aux pid à 4 caracteres
                    p_pid :='AAAA';

                 END IF;
              END IF;
           END IF;
      ELSE
      	   -- calcul de la valeur en base 35 du dernier caractere pour incrementation
           position := INSTR( base35, SUBSTR( pidMax,4, 1) );

           IF position < 35 THEN
             -- incrementer simplement le dernier caractere
             p_pid := SUBSTR( pidMax, 1, 3) || SUBSTR( base35, position+1, 1 );

           ELSE
              -- if faut incrementer le 3eme caractere
              position := INSTR( base35, SUBSTR( pidMax, 3, 1) );

              IF position < 35 THEN
                 -- incrementer simplement le 3eme caractere, le dernier caractere est 'A'
                 p_pid := SUBSTR(pidMax,1,2)||SUBSTR( base35, position+1, 1 ) ||'A';

              ELSE
                  -- Il faut incrementer le 2eme caractere
                  position := INSTR( base35, SUBSTR( pidMax, 2, 1) );

                  IF position < 35 THEN
                 	-- incrementer simplement le 2EME caractere les derniers sont 'AA'
                 	p_pid := SUBSTR(pidMax,1,1)||SUBSTR( base35, position+1, 1 ) ||'AA';

                   ELSE
				        -- if faut incrementer le premier caractere
                           position := INSTR( base26, SUBSTR( pidMax, 1, 1) );

                           IF position < 26 THEN
                              -- les 2 derniers caracteres sont 'AA'

                              p_pid := SUBSTR( base26, position+1, 1 ) || 'AAA';
                           ELSE
                              -- probleme => theoriquement plus de code dispo
                              -- 'DERNIER IDENTIFIANT ATTEINT'

                              Pack_Global.recuperer_message(20014, NULL, NULL, NULL, msg);
                              RAISE_APPLICATION_ERROR( -20014, msg );
                           END IF;
                   END IF;
             END IF;
           END IF;
      END IF;


      IF p_pid IN ( 'ASH', 'BAD', 'BAF', 'BIT', 'CUL', 'CON', 'DIR',
                    'SAG', 'SAT', 'SIM', 'CIF', 'SIF', 'SMP',
                    'ANAL','ANUS','BITE','BUSH','CACA','CATO','CFDT','CFTC','CHIE','COCU','CUCU' ) THEN

         -- identifiants interdits
         -- => Relancer le calcul

         pidMax := p_pid;
         calcul_base_35( pidMax, p_pid );
      END IF;


   END calcul_base_35;


---------------------------------------------------------------------------------------------------------------
   PROCEDURE calcul_cle ( p_pid IN VARCHAR2,
                          p_cle OUT VARCHAR2
                        ) IS
      base36 CHAR(36) := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
      position_1 NUMBER;
      position_2 NUMBER;
      position_3 NUMBER;
      position_4 NUMBER;
      valeur_C1 NUMBER;
      valeur_C2 NUMBER;
      valeur_C3 NUMBER;
      char_D1 CHAR;
      char_D2 CHAR;
      char_D3 CHAR;
      longueur NUMBER;

   BEGIN
      position_1 := INSTR( base36, SUBSTR( p_pid, 1, 1) );
      position_2 := INSTR( base36, SUBSTR( p_pid, 2, 1) );
      position_3 := INSTR( base36, SUBSTR( p_pid, 3, 1) );
      position_4 := INSTR( base36, SUBSTR( p_pid, 4, 1) );

      valeur_C1 := MOD((31*position_3) + (11*position_2) + 2, 36) + 1;

      valeur_C2 := MOD((7*position_3) + (23*position_1) + 2, 36) + 1;

      char_D1 := SUBSTR( base36, valeur_C1, 1);
      char_D2 := SUBSTR( base36, valeur_C2, 1);


-- On détermine s'il sagit d'un pid à 3 ou 4 caractères
      SELECT LENGTH(RTRIM(p_pid)) INTO longueur
      FROM dual;

	IF longueur = 3 THEN

          	-- la cle est la concatenation des 2 caracteres calcules

          	p_cle := char_D1||char_D2;

	ELSE

          	-- la cle doit comporter un troisieme caractere.
          	-- On calcule a nouveau

          	valeur_C1 := MOD((30*position_2) + (17*position_4) + 2, 36) + 1;
          	valeur_C2 := MOD((11*position_2) + (31*position_3) + 2, 36) + 1;
          	valeur_C3 := MOD((23*position_1) + (7*position_3) + 2, 36) + 1;

          	char_D1 := SUBSTR( base36, valeur_C1, 1);
          	char_D2 := SUBSTR( base36, valeur_C2, 1);
          	char_D3 := SUBSTR( base36, valeur_C3, 1);

          	p_cle := char_D1||char_D2||char_D3;

	END IF;

   END calcul_cle;


   -- Procédure pour remplir les logs de MAJ de la ligne BIP
   PROCEDURE maj_ligne_bip_logs(p_pid			IN LIGNE_BIP_LOGS.pid%TYPE,
								p_user_log		IN LIGNE_BIP_LOGS.user_log%TYPE,
								p_colonne		IN LIGNE_BIP_LOGS.colonne%TYPE,
								p_valeur_prec	IN LIGNE_BIP_LOGS.valeur_prec%TYPE,
								p_valeur_nouv	IN LIGNE_BIP_LOGS.valeur_nouv%TYPE,
								p_commentaire	IN LIGNE_BIP_LOGS.commentaire%TYPE
								) IS
   BEGIN


	IF (UPPER(LTRIM(RTRIM(NVL(p_valeur_prec, 'NULL')))) <> UPPER(LTRIM(RTRIM(NVL(p_valeur_nouv, 'NULL'))))) THEN
		INSERT INTO LIGNE_BIP_LOGS
			(pid, date_log, user_log, colonne, valeur_prec, valeur_nouv, commentaire)
		VALUES
			(p_pid, CURRENT_TIMESTAMP, p_user_log, p_colonne, p_valeur_prec, p_valeur_nouv, p_commentaire);--PPM 61077 : changer SYSDATE par CURRENT_TIMESTAMP

	END IF;
	-- Pas de commit  car en cas d'erreur la MAJ n'est pas enregistrée et il ne faut donc pas créer de ligne

   END maj_ligne_bip_logs;



   PROCEDURE select_ligne_bip ( p_pnom         IN VARCHAR2,
                                p_pid          IN CHAR,
                                p_userid       IN VARCHAR2,
								p_duplic       IN VARCHAR2,
                                p_curLigne_bip IN OUT ligne_bipCurType,
								p_liste 	   OUT VARCHAR2, -- TD 532 (liste des CA preconises)
                                p_nbcurseur    OUT INTEGER,
                                p_message      OUT VARCHAR2
                              ) IS
      msg 		VARCHAR(1024);
      l_pid 		LIGNE_BIP.pid%TYPE;
      tmp_codsg 	LIGNE_BIP.codsg%TYPE;
      TEST 		NUMBER;
      l_habilitation 	VARCHAR2(10);
	  l_dir				VARCHAR2(10);

   BEGIN
IF (p_pid IS NOT NULL) THEN

         BEGIN

            -- Verifier que le projet existe pour la modification

            SELECT pid INTO l_pid
            FROM LIGNE_BIP
            WHERE pid = p_pid;

         EXCEPTION
            WHEN NO_DATA_FOUND THEN

               -- Code projet %s1 inexistant

               Pack_Global.recuperer_message(20504, '%s1', p_pid, NULL, msg);
               RAISE_APPLICATION_ERROR( -20504, msg );
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
         END;

         -- test de l'habilitation
         BEGIN
           SELECT codsg INTO tmp_codsg
           FROM   LIGNE_BIP
           WHERE  pid = p_pid;

         EXCEPTION
           WHEN OTHERS THEN
				RAISE_APPLICATION_ERROR( -20997, SQLERRM);

         END;

  -- ====================================================================
      -- 12/02/2001 : Test appartenance du DPG au perimetre de l'utilisateur
      -- ====================================================================

      IF(p_duplic <> 'OUI') THEN

        l_habilitation := Pack_Habilitation.fhabili_me(tmp_codsg, p_userid);

        IF l_habilitation='faux' THEN
                -- Vous n'etes pas autorise a modifier cette ligne BIP, son DPG est
		Pack_Global.recuperer_message(20365, '%s1',  'modifier cette ligne BIP, son DPG est '||tmp_codsg, 'PID', msg);
                RAISE_APPLICATION_ERROR(-20365, msg);
        END IF;

      END IF;

	  l_dir:=Pack_Global.lire_globaldata(p_userid).menutil;

	  -- 14/03/2008 EVI TD 501 On autorisa l'acces ligne en modif si dans le MENU DIR
	  IF l_dir!='DIR' THEN
      	-- 26/07/2004 : Vérification que les codes Projets et Dossiers Projets sont bien actifs.
      	BEGIN
            SELECT lb.pid INTO l_pid
            FROM LIGNE_BIP lb, DOSSIER_PROJET dp, PROJ_INFO pi
            WHERE lb.dpcode = dp.dpcode
              AND lb.icpi = pi.icpi
              AND (pi.statut IS NULL OR pi.statut ='O' OR pi.statut ='N')
              AND dp.actif = 'O'
              AND lb.pid = p_pid;

        EXCEPTION
           WHEN NO_DATA_FOUND THEN
            		Pack_Global.recuperer_message(20757, NULL,  NULL, 'PID', msg);
            		RAISE_APPLICATION_ERROR(-20757,msg);
           WHEN OTHERS THEN
		RAISE_APPLICATION_ERROR( -20997, SQLERRM);

        END;
		END IF;


      END IF;


  -- TD 446 --
  IF(p_duplic = 'OUI') THEN


                 OPEN p_curLigne_bip FOR
						SELECT 	lb.PID,
								lb.PCLE,
								-- lb.PNOM,
								DECODE(p_pnom,'',lb.PNOM,p_pnom),
								cs.ASTATUT,
								cs.LIBSTATUT,
								lb.TOPFER,
								TO_CHAR( lb.ADATESTATUT , 'MM/YYYY') AS ADATESTATUT,
								tp.TYPPROJ,
								tp.LIBTYP,
								lb.ARCTYPE,
								ta.LIBARC,
								lb.CODPSPE,
								lb.TOPTRI,
								LPAD(lb.DPCODE,5, '0'),
								'01/' || TO_CHAR( SYSDATE , 'YYYY') AS PDATDEBPRE ,
								lb.ICPI,
								lb.CODSG,
								lb.AIRT,
								lb.PCPI,
								lb.CLICODE,
								cm.CLILIB,
								lb.CODCAMO,
								NVL(es.LICOES, ca.CLIBCA),
								lb.PNMOUVRA,
								lb.METIER, --aur
								lb.POBJET,
								lb.PZONE,
								lb.CLICODE_OPER,
								cm1.CLILIB,
								NVL(lb.SOUS_TYPE,'0'),
								st.libsoustype,
								TO_CHAR(b.CODBR),
								lb.FLAGLOCK,
                                lb.CODREP,
                                rjh.LIBREP,
								dp.ACTIF,
								pi.STATUT
						FROM LIGNE_BIP         lb,
						TYPE_PROJET       tp,
						TYPE_ACTIVITE     ta,
						CODE_STATUT       cs,
						CLIENT_MO         cm,
						CLIENT_MO         cm1,
						CENTRE_ACTIVITE   ca,
						ENTITE_STRUCTURE  es,
						DIRECTIONS d,
						SOUS_TYPOLOGIE st,
						BRANCHES b,
                        RJH_TABREPART rjh,
						PROJ_INFO pi,
						DOSSIER_PROJET dp
						WHERE pid = p_pid
						AND lb.typproj = tp.typproj (+)
						AND lb.arctype = ta.arctype (+)
						AND lb.astatut = cs.astatut (+)
						AND lb.codcamo = es.codcamo (+)
						AND lb.codcamo = ca.codcamo (+)
						AND lb.clicode = cm.clicode (+)
						AND lb.clicode_oper = cm1.clicode (+)
						AND cm.clidir= d.coddir (+)
						AND d.CODBR=b.CODBR (+)
						AND lb.sous_type = st.sous_type (+)
						AND lb.CODREP = rjh.CODREP (+)
						AND pi.ICPI=lb.ICPI
						AND dp.DPCODE=lb.DPCODE;


                ELSE

      OPEN p_curLigne_bip FOR
         SELECT lb.PID,
                lb.PCLE,
                lb.PNOM,
                cs.ASTATUT,
                cs.LIBSTATUT,
                lb.TOPFER,
                TO_CHAR( lb.ADATESTATUT , 'MM/YYYY') AS ADATESTATUT,
                tp.TYPPROJ,
                tp.LIBTYP,
                lb.ARCTYPE,
                ta.LIBARC,
                lb.CODPSPE,
                lb.TOPTRI,
                LPAD(lb.DPCODE,5, '0'),
                TO_CHAR( lb.PDATDEBPRE , 'MM/YYYY') AS PDATDEBPRE ,
                lb.ICPI,
                lb.CODSG,
                lb.AIRT,
                lb.PCPI,
                lb.CLICODE,
                cm.CLILIB,
                lb.CODCAMO,
                NVL(es.LICOES, ca.CLIBCA),
                lb.PNMOUVRA,
                lb.METIER, --aur
                lb.POBJET,
                lb.PZONE,
                lb.CLICODE_OPER,
                cm1.CLILIB,
                NVL(lb.SOUS_TYPE,'0'),
                st.libsoustype,
                TO_CHAR(b.CODBR),
                lb.FLAGLOCK,
                lb.CODREP,
                rjh.LIBREP,
				dp.ACTIF,
				pi.STATUT
         FROM LIGNE_BIP         lb,
              TYPE_PROJET       tp,
              TYPE_ACTIVITE     ta,
              CODE_STATUT       cs,
              CLIENT_MO         cm,
              CLIENT_MO         cm1,
              CENTRE_ACTIVITE   ca,
              ENTITE_STRUCTURE  es,
              DIRECTIONS d,
              SOUS_TYPOLOGIE st,
              BRANCHES b,
              RJH_TABREPART rjh,
			  PROJ_INFO pi,
			  DOSSIER_PROJET dp
         WHERE pid = p_pid
         AND lb.typproj = tp.typproj (+)
         AND lb.arctype = ta.arctype (+)
         AND lb.astatut = cs.astatut (+)
         AND lb.codcamo = es.codcamo (+)
         AND lb.codcamo = ca.codcamo (+)
         AND lb.clicode = cm.clicode (+)
         AND lb.clicode_oper = cm1.clicode (+)
         AND cm.clidir= d.coddir (+)
         AND d.CODBR=b.CODBR (+)
         AND lb.sous_type = st.sous_type (+)
         AND lb.CODREP = rjh.CODREP (+)
         AND pi.ICPI=lb.ICPI
		 AND dp.DPCODE=lb.DPCODE;

                 END IF;

	-- TD 532 : Liste des CA preconises
	p_liste := EST_LISTE_CA_PRECONISES(p_pid);

   END select_ligne_bip;


   PROCEDURE insert_ligne_bip (
							   p_pnom       	IN VARCHAR2,
                               p_typproj    	IN CHAR,
							   p_pdatdebpre 	IN CHAR,
                               p_arctype    	IN VARCHAR2,
							   p_toptri     	IN CHAR,
                               p_codpspe    	IN CHAR,
                               p_icpi       	IN CHAR,
							   p_airt       	IN CHAR,
                               p_dpcode     	IN CHAR,
                               p_codsg      	IN CHAR,
                               p_pcpi       	IN CHAR,
                               p_clicode    	IN CHAR,
                               p_codcamo    	IN CHAR,
                               p_pnmouvra   	IN CHAR,
                               p_metier      	IN CHAR,
                               p_liste_objet   	IN VARCHAR2,
							   p_pobjet     	IN VARCHAR2,
							   p_pzone     		IN VARCHAR2,
							   p_clicode_oper	IN VARCHAR2,
							   p_sous_typo		IN VARCHAR2,
							   p_codrep			IN VARCHAR2,
                               p_userid     	IN VARCHAR2,
                               p_pid        	OUT CHAR,
                               p_pcle       	OUT CHAR,
                               p_nbcurseur  	OUT INTEGER,
                               p_message    	OUT VARCHAR2
                              ) IS

 CODCAMO_MULTI	VARCHAR2(6) := '77777';
 msg 		VARCHAR(1024);
 l_ident 	NUMBER(5);
 l_pid 		VARCHAR2(4);  -- variable locale pid (p_pid ne peut etre lue (OUT))
 l_pcle 	VARCHAR2(3);
 topfer 	CHAR(1); -- variable locale pour recuperer les tops fermeture
 l_menutil 	VARCHAR2(255);
 l_habilitation VARCHAR2(10);
 l_nbligne 	NUMBER;
 l_icodproj	PROJ_INFO.icodproj%TYPE;
 l_user		LIGNE_BIP_LOGS.user_log%TYPE;
 l_datdeb	REPARTITION_LIGNE.datdeb%TYPE;
 l_test 	CHAR(1) ; -- utilisée dans un test d'existance
 l_cdateferm centre_activite.CDATEFERM%TYPE;
 l_cdfain    centre_activite.CDFAIN%TYPE;
 l_topfer_clientmo CLIENT_MO.CLITOPF%TYPE;
 l_moismens  datdebex.moismens%TYPE;

 referential_integrity EXCEPTION;
 PRAGMA EXCEPTION_INIT( referential_integrity, -2291);
 objet_split 	VARCHAR2(2000);
   BEGIN
      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';
      l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);

         BEGIN
            SELECT ident INTO l_ident
            FROM RESSOURCE
            WHERE ident = TO_NUMBER(p_pcpi)
            AND rtype = 'P';

         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message( 20503, '%s1', p_pcpi,
                                              'PCPI', msg);
               RAISE_APPLICATION_ERROR( -20503, msg);
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
         END;


         -- Code dept/pole/groupe > 1

         IF TO_NUMBER(p_codsg) <= 1 THEN

            -- Erreur applicative

            Pack_Global.recuperer_message(20223, NULL, NULL, 'CODSG', msg);
            RAISE_APPLICATION_ERROR( -20223, msg);
         END IF;

	-- centre_activite fermé ou non facturable
  	BEGIN
		 SELECT 	c.CDATEFERM, c.CDFAIN, d.moismens INTO l_cdateferm, l_cdfain, l_moismens
		 FROM 	centre_activite c, datdebex d
		 WHERE	c.codcamo=TO_NUMBER(p_codcamo);
		 EXCEPTION
		 WHEN NO_DATA_FOUND THEN
		 		pack_global.recuperer_message( 20986, NULL, NULL, NULL, msg);
				RAISE_APPLICATION_ERROR( -20986, msg);
    	 WHEN OTHERS THEN
    	 	  	RAISE_APPLICATION_ERROR( -20997, SQLERRM);
	END;
	BEGIN
		 IF ((l_cdateferm is not null) AND (l_cdateferm < l_moismens) )THEN
		 	pack_global.recuperer_message( 20985, NULL, NULL, NULL, msg);
			RAISE_APPLICATION_ERROR( -20985, msg);
		 ELSE
		 	IF (l_cdfain=3) THEN
		 	   pack_global.recuperer_message( 20984, NULL, NULL, NULL, msg);
			   RAISE_APPLICATION_ERROR( -20984, msg);
		 	END IF;
		 END IF;






	END;



	-- Vérification que le client MO opérationlle existe bien et qu'il n'est pas fermé
	--  11/05/2007
	BEGIN
	      IF p_clicode_oper IS NOT NULL THEN
	           	 SELECT CLIENT_MO.CLITOPF into l_topfer_clientmo
	           	 FROM CLIENT_MO
				 WHERE TRIM(CLIENT_MO.CLICODE) = TRIM(p_clicode_oper) ;

				 IF l_topfer_clientmo ='F' THEN
				 	Pack_Global.recuperer_message(20026, NULL,NULL,NULL, msg);
			     	RAISE_APPLICATION_ERROR( -20026,  msg);
				 END IF ;
		 END IF ;

   	EXCEPTION
	     WHEN NO_DATA_FOUND THEN
	           Pack_Global.recuperer_message(20728, NULL,NULL,NULL, msg);
		     RAISE_APPLICATION_ERROR( -20728,  msg);

		WHEN OTHERS THEN
   		    RAISE_APPLICATION_ERROR( -20997, SQLERRM);
	END;



      -- ====================================================================
      -- 12/02/2001 : Test appartenance du DPG au périmètre de l'utilisateur
      -- ====================================================================
     	l_habilitation := Pack_Habilitation.fhabili_me(p_codsg, p_userid);
	IF l_habilitation='faux' THEN
		-- Vous n'êtes pas habilité à ce DPG 20364
		Pack_Global.recuperer_message(20364, '%s1', 'à ce DPG', 'CODSG', msg);
                RAISE_APPLICATION_ERROR(-20364, msg);
	END IF;

	-- controle du paramètre p_pobjet
	objet_split := controle_obj (p_pobjet);


            -- Calculer le pid et la cle de controle pcle

            calcul_pid ( l_pid );

            calcul_cle( RTRIM(l_pid), l_pcle );

            -- Inserer la ligne bip
            -- valeurs saisies
            -- Top facturation a 'O'
            -- top fiche PETAT 'M' projet mis a jour


        BEGIN


            INSERT INTO LIGNE_BIP ( pid,
                                    pcle,
                                    pnom,
                                    typproj,
                                    arctype,
                                    codpspe,
                                    toptri,
                                    dpcode,
                                    pdatdebpre,
                                    icpi,
                                    codsg,
                                    airt,
                                    pcpi,
                                    clicode,
                                    pnmouvra,
                                    codcamo,
									pobjet,
									pzone,
                                    pconsn1,
                                    pdecn1,
                                    pcactop,
                                    petat,
									METIER,
                                    clicode_oper,
                                    sous_type,
                                    topfer,
									flaglock,
									codrep)
            VALUES ( RTRIM(l_pid),
                     l_pcle,
                     p_pnom,
                     p_typproj,
                     p_arctype,
                     RTRIM(p_codpspe),
                     p_toptri,
                     DECODE(p_dpcode, NULL, 0, p_dpcode),
                     TO_DATE( p_pdatdebpre, 'MM/YYYY'),
                     p_icpi,
                     p_codsg,
                     p_airt,
                     p_pcpi,
                     p_clicode,
                     p_pnmouvra,
                     DECODE( p_codcamo, '', 0, p_codcamo ),
					 objet_split,
					 p_pzone,
                     0,
                     0,
                     'O',
                     'M',
					 p_metier,
					 NVL(p_clicode_oper, p_clicode),
					 p_sous_typo,
					 'N',		-- par defaut TOPFER='N'
					 0,
					 p_codrep);

            -- On loggue le type, la typologie, le CA payeur, le topfer
            maj_ligne_bip_logs(l_pid, l_user, 'Type', NULL, p_typproj, 'Création de la ligne BIP');
            maj_ligne_bip_logs(l_pid, l_user, 'Typologie', NULL, p_arctype, 'Création de la ligne BIP');
            maj_ligne_bip_logs(l_pid, l_user, 'CA payeur', NULL, p_codcamo, 'Création de la ligne BIP');
            maj_ligne_bip_logs(l_pid, l_user, 'Top fermeture', NULL, 'N', 'Création de la ligne BIP');
            maj_ligne_bip_logs(l_pid, l_user, 'Code métier', NULL, p_metier, 'Création de la ligne BIP');
            maj_ligne_bip_logs(l_pid, l_user, 'Code application', NULL, p_airt, 'Création de la ligne BIP');

            --ajout fiche 483 - 16/03/2007 EVI
            maj_ligne_bip_logs(l_pid, l_user, 'Code dossier projet', NULL, p_dpcode, 'Création de la ligne BIP');
            maj_ligne_bip_logs(l_pid, l_user, 'Code projet', NULL, p_icpi, 'Création de la ligne BIP');

            --Fiche 843 - 15/10/2009 YNI
            maj_ligne_bip_logs(l_pid, l_user, 'Code DPG fornisseur', NULL, TO_NUMBER(p_codsg), 'Création de la ligne BIP');


            --Fiche QC 1616 (PPM 58143) - 10/06/2014 SEL
            maj_ligne_bip_logs(l_pid, l_user, 'Code DBS', NULL, p_sous_typo, 'Création de la ligne BIP');

            --SEL PPM 64405
            maj_ligne_bip_logs(l_pid,l_user,'Paramètre local',null,p_pzone,'Création de la ligne BIP');


          EXCEPTION
            WHEN referential_integrity THEN
	      IF (p_clicode_oper IS NULL) AND (INSTR(SQLERRM, 'CLICODE_128') > 0) THEN
		      	-- Si le message est relatif au clicode_oper
		      	-- Alors que c'est le clicode, on donne le message du clicode
	      		Pack_Global.recuperer_message(20732, NULL, NULL, 'CLICODE', msg);
	      		RAISE_APPLICATION_ERROR( -20732, msg);
	      ELSE
	              	-- habiller le msg erreur
	              	Pack_Global.recuperation_integrite(-2291);
	      END IF;

            -- Ne pas intercepter les autres exceptions
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);

          END;



            -- Verifications apres integrites
            -- Structure SG non fermee
            -- Recuperer le top fermeture du code sg
	l_menutil := Pack_Global.lire_globaldata(p_userid).menutil;
        BEGIN
            SELECT TOPFER INTO topfer
            FROM STRUCT_INFO
            WHERE CODSG = TO_NUMBER(p_codsg);

          EXCEPTION
            WHEN NO_DATA_FOUND THEN
               NULL;
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
          END;


          IF (topfer = 'F') AND (l_menutil != 'DIR') THEN
               	-- Erreur applicative
          	Pack_Global.recuperer_message(20274, NULL, NULL, 'CODSG', msg);
             	RAISE_APPLICATION_ERROR( -20274, msg);
          END IF;

         --client mo non fermee
         -- Recuperer le top fermeture du client mo
         BEGIN
            SELECT CLITOPF INTO topfer
            FROM CLIENT_MO
            WHERE LTRIM(RTRIM(CLICODE)) = LTRIM(RTRIM(p_clicode));

          EXCEPTION
            WHEN NO_DATA_FOUND THEN
               NULL;
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
          END;

          IF (topfer = 'F') AND (l_menutil != 'DIR') THEN
             	-- Erreur applicative
           	Pack_Global.recuperer_message(20018, NULL, NULL, 'CLICODE', msg);
             	RAISE_APPLICATION_ERROR( -20018, msg);
          END IF;

         -- client mo Opérationnel non fermee
         -- Recuperer le top fermeture du client mo
         IF p_clicode_oper IS NOT NULL THEN
	         BEGIN
	            SELECT CLITOPF INTO topfer
	            FROM CLIENT_MO
	            WHERE LTRIM(RTRIM(CLICODE)) = LTRIM(RTRIM(p_clicode_oper));

	          EXCEPTION
	            WHEN NO_DATA_FOUND THEN
	               NULL;
	            WHEN OTHERS THEN
	               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
	          END;
	  END IF;


          IF (topfer = 'F') AND (l_menutil != 'DIR') THEN
             	-- Erreur applicative
           	Pack_Global.recuperer_message(20026, NULL, NULL, 'CLICODE_OPER', msg);
             	RAISE_APPLICATION_ERROR( -20026, msg);
          END IF;


	  -- Si c'est une ligne Grand T1
	  -- On la passe dans le statut à immobiliser.
	  BEGIN
	  	IF (p_typproj = '1 ') AND (p_arctype='T1' OR p_dpcode <> '00000') THEN
	  		UPDATE LIGNE_BIP
	  		SET astatut ='O'
	  		WHERE pid=l_pid;
	  		-- On logue la modif
	  		maj_ligne_bip_logs(l_pid, l_user, 'Statut', NULL, 'O', 'Création de la ligne BIP');
		END IF;
	  EXCEPTION
	     WHEN OTHERS THEN
	     	Pack_Global.recuperer_message(20929, '%s1', 'Pas de statut', '%s2', 'A immobiliser', NULL, msg);
             	RAISE_APPLICATION_ERROR( -20929, msg);
	  END;


	  -- Si le CA saisit correspond avec le code de m_facturation,
	  -- On saisit le CA 0 dans la table repartition_ligne avec un taux de 100%
	  IF (p_codcamo=CODCAMO_MULTI) THEN
	  	SELECT ADD_MONTHS(DATDEBEX, -1) INTO l_datdeb FROM DATDEBEX WHERE ROWNUM<2;
	  	INSERT INTO REPARTITION_LIGNE
	  	       (pid, codcamo, tauxrep, datdeb)
	  	VALUES (l_pid, 0, 100, l_datdeb);
	  END IF;


          -- 'Le projet '||p_pnom||'\nest créé avec
          -- le code suivant :\n'||l_pid||' clé : '||l_pcle;

          Pack_Global.recuperer_message(5, '%s1', p_pnom, '%s2', l_pid, '%s3', l_pcle, NULL, msg);
          p_message := msg;



   END insert_ligne_bip;


  PROCEDURE update_ligne_bip ( 	p_typproj     	IN CHAR,
								p_pid         	IN CHAR,
                                p_pcle        	IN CHAR,
                                p_pnom        	IN VARCHAR2,
                                p_astatut     	IN CHAR,
							    p_topfer      	IN CHAR,
                                p_adatestatut 	IN CHAR,
								p_pdatdebpre  	IN CHAR,
                                p_arctype     	IN VARCHAR2,
								p_toptri      	IN CHAR,
                                p_codpspe     	IN CHAR,
                                p_icpi        	IN CHAR,
								p_airt        	IN CHAR,
                                p_dpcode      	IN CHAR,
                                p_codsg       	IN CHAR,
                                p_pcpi        	IN CHAR,
                                p_clicode     	IN CHAR,
                                p_codcamo     	IN CHAR,
                                p_pnmouvra    	IN CHAR,
								p_metier      	IN CHAR, --aur nouvelle valeur
								p_pobjet      	IN VARCHAR2,
								p_liste_objet 	IN VARCHAR2,
								p_pzone       	IN VARCHAR2,
								p_clicode_oper  IN VARCHAR2,
								p_sous_typo  	IN VARCHAR2,
                                p_flaglock    	IN NUMBER,
								p_codrep  		IN VARCHAR2,
                                p_userid      	IN VARCHAR2,
                                p_nbcurseur   	OUT INTEGER,
                                p_message     	OUT VARCHAR2
                              )IS
 CODCAMO_MULTI	VARCHAR2(6)	:= '77777';
 msg 		VARCHAR(1024);
 l_ident 	NUMBER(5); -- variable locale pour le tester le chef de projet
 topfer 	CHAR(1);    -- variable locale pour recuperer les tops fermeture
 l_menutil 	VARCHAR2(255);
 l_habilitation VARCHAR2(10);
 l_icodproj	PROJ_INFO.icodproj%TYPE;

 l_user		LIGNE_BIP_LOGS.user_log%TYPE;
 -- Valeurs précédentes pour les logs
 l_typproj	LIGNE_BIP.typproj%TYPE;
 l_arctype	LIGNE_BIP.arctype%TYPE;
 l_codcamo	LIGNE_BIP.codcamo%TYPE;
 l_topfer	LIGNE_BIP.topfer%TYPE;
 l_astatut	LIGNE_BIP.astatut%TYPE;
 l_adatestatut	LIGNE_BIP.adatestatut%TYPE;
 l_metier	LIGNE_BIP.METIER%TYPE;
 l_airt	LIGNE_BIP.airt%TYPE;
 l_datdeb	REPARTITION_LIGNE.datdeb%TYPE;
 l_test 	CHAR(1) ; -- utilisée dans un test d'existance
 l_cdateferm centre_activite.CDATEFERM%TYPE;
 l_cdfain    centre_activite.CDFAIN%TYPE;
 l_dpcode LIGNE_BIP.DPCODE%TYPE;
 l_icpi LIGNE_BIP.ICPI%TYPE;
 l_topfer_clientmo CLIENT_MO.CLITOPF%TYPE;

 l_moismens  datdebex.moismens%TYPE;
 --YNI
l_codsg LIGNE_BIP.CODSG%TYPE;


l_sous_typo LIGNE_BIP.SOUS_TYPE%TYPE;

--SEL PPM 64405
l_pzone LIGNE_BIP.PZONE%TYPE;

 referential_integrity EXCEPTION;
 PRAGMA EXCEPTION_INIT( referential_integrity, -2291);
 objet_split	VARCHAR2(2000);

 l_test_est_ca_preconise NUMBER; -- TD 532
 msg2 VARCHAR(1024); -- TD 532

   BEGIN
      -- positionner le nb de curseurs ==> 0
      -- initialiser le message retour
      p_nbcurseur := 0;
      p_message := '';

      l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);

      -- le Chef de projet doit exister et être une personne
      BEGIN
         SELECT ident INTO l_ident
         FROM RESSOURCE
         WHERE ident = TO_NUMBER(p_pcpi)
         AND rtype = 'P';

      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            Pack_Global.recuperer_message(20503, '%s1', p_pcpi, 'PCPI', msg);
            RAISE_APPLICATION_ERROR( -20503, msg);

         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

      -- Code dept/pole/groupe> 1

      IF TO_NUMBER(p_codsg) <= 1 THEN

         -- Erreur applicative

         Pack_Global.recuperer_message(20223, NULL, NULL, 'CODSG', msg);
         RAISE_APPLICATION_ERROR( -20223, msg);
      END IF;

	-- centre_activite fermé ou non facturable
  	BEGIN
		 SELECT 	c.CDATEFERM, c.CDFAIN, d.moismens INTO l_cdateferm, l_cdfain, l_moismens
		 FROM 	centre_activite c, datdebex d
		 WHERE	c.codcamo=TO_NUMBER(p_codcamo);
		 EXCEPTION
		 WHEN NO_DATA_FOUND THEN
		 		pack_global.recuperer_message( 20986, NULL, NULL, NULL, msg);
				RAISE_APPLICATION_ERROR( -20986, msg);
    	 WHEN OTHERS THEN
    	 	  	RAISE_APPLICATION_ERROR( -20997, SQLERRM);
	END;
	BEGIN
		 IF ((l_cdateferm is not null) AND (l_cdateferm < l_moismens) )THEN
		 	pack_global.recuperer_message( 20985, NULL, NULL, NULL, msg);
			RAISE_APPLICATION_ERROR( -20985, msg);
		 ELSE
		 	IF (l_cdfain=3) THEN
		 	   pack_global.recuperer_message( 20984, NULL, NULL, NULL, msg);
			   RAISE_APPLICATION_ERROR( -20984, msg);
		 	END IF;
		 END IF;






	END;




	-- Vérification que le client MO opérationl existe bien et qu'il n'est pas fermé
	--  11/05/2007
	BEGIN
		IF p_clicode_oper IS NOT NULL THEN
           	 SELECT CLIENT_MO.CLITOPF into l_topfer_clientmo
           	 FROM CLIENT_MO
			 WHERE TRIM(CLIENT_MO.CLICODE) = TRIM(p_clicode_oper) ;

			 IF l_topfer_clientmo ='F' THEN
			 	Pack_Global.recuperer_message(20026, NULL,NULL,NULL, msg);
		     	RAISE_APPLICATION_ERROR( -20026, msg);
			 END IF ;
		END IF ;

   	EXCEPTION
	     WHEN NO_DATA_FOUND THEN
	           Pack_Global.recuperer_message(20728, NULL,NULL,NULL, msg);
		     RAISE_APPLICATION_ERROR( -20728,  msg);

		WHEN OTHERS THEN
   		    RAISE_APPLICATION_ERROR( -20997, SQLERRM);
	END;




      -- ====================================================================
      -- 12/02/2001 : Test appartenance du DPG au périmètre de l'utilisateur
      -- ====================================================================
     	l_habilitation := Pack_Habilitation.fhabili_me(p_codsg, p_userid);
	IF l_habilitation='faux' THEN
		-- Vous n'êtes pas habilité à ce DPG 20364
		Pack_Global.recuperer_message(20364, '%s1', 'à ce DPG', 'CODSG', msg);
                RAISE_APPLICATION_ERROR(-20364, msg);
	END IF;


	-- controle du paramètre p_pobjet : il ne doit y avoir que 5 lignes qui font au max 60 caractères
	objet_split := controle_obj(p_pobjet);

        BEGIN
            -- On récupère les valeurs précédentes pour les logs
            SELECT typproj, arctype, codcamo, topfer, astatut, adatestatut, METIER,airt, dpcode,icpi, codsg, sous_type,pzone
            INTO l_typproj, l_arctype, l_codcamo, l_topfer, l_astatut, l_adatestatut, l_metier,l_airt,l_dpcode,l_icpi,l_codsg, l_sous_typo,l_pzone
            FROM LIGNE_BIP
            WHERE pid=p_pid
            AND flaglock = p_flaglock;


            UPDATE LIGNE_BIP
            SET pnom 		= p_pnom,
                astatut 	= p_astatut,
				topfer	 	= p_topfer,
                adatestatut = TO_DATE(p_adatestatut, 'MM/YYYY'),
                typproj 	= p_typproj,
                arctype 	= p_arctype,
                codpspe 	= RTRIM(p_codpspe),
                toptri 		= p_toptri,
                dpcode 		= DECODE(p_dpcode,'', '00000', p_dpcode),
                pdatdebpre 	= TO_DATE(p_pdatdebpre, 'MM/YYYY'),
                icpi 		= DECODE(p_icpi,'', 'P0000', p_icpi),
                codsg 		= TO_NUMBER(p_codsg),
                airt 		= DECODE(p_airt,'', 'A0000', p_airt),
                pcpi 		= p_pcpi,
                clicode 	= p_clicode,
                codcamo		= p_codcamo,
                pnmouvra 	= p_pnmouvra,
                METIER		= p_metier,  --aur
				pobjet 		= objet_split,
				pzone		= p_pzone,
				clicode_oper    = p_clicode_oper,
				sous_type	= p_sous_typo,
                flaglock 	= DECODE(p_flaglock, 1000000, 0, p_flaglock + 1),
				codrep      = p_codrep
            WHERE pid = p_pid
            AND flaglock = p_flaglock;

             -- On loggue le type, la typologie, le CA payeur, le topfer, le statut, la date de statut
            maj_ligne_bip_logs(p_pid, l_user, 'Type', l_typproj, p_typproj, 'Modification de la ligne BIP');
            maj_ligne_bip_logs(p_pid, l_user, 'Typologie', l_arctype, p_arctype, 'Modification de la ligne BIP');
            maj_ligne_bip_logs(p_pid, l_user, 'CA payeur', TO_CHAR(l_codcamo), p_codcamo, 'Modification de la ligne BIP');
            maj_ligne_bip_logs(p_pid, l_user, 'Top fermeture', l_topfer, p_topfer, 'Modification de la ligne BIP');
            maj_ligne_bip_logs(p_pid, l_user, 'Statut', l_astatut, p_astatut, 'Modification de la ligne BIP');
            maj_ligne_bip_logs(p_pid, l_user, 'Date statut', TO_CHAR(l_adatestatut, 'MM/YYYY'), p_adatestatut, 'Modification de la ligne BIP');

            --ajout fiche 299
            maj_ligne_bip_logs(p_pid, l_user, 'Code métier  ', l_metier, p_metier, 'Modification de la ligne BIP');
            maj_ligne_bip_logs(p_pid, l_user, 'Code application  ', l_airt, p_airt, 'Modification de la ligne BIP');

            --Fiche 843 - 15/10/2009 YNI
            if(l_codsg != p_codsg) THEN
            maj_ligne_bip_logs(p_pid, l_user, 'Code DPG fornisseur', l_codsg, p_codsg, 'Modification de la ligne BIP');
            end if;

            --Fiche QC 1616 (PPM 58143) - 10/06/2014 SEL
            maj_ligne_bip_logs(p_pid, l_user, 'Code DBS', l_sous_typo, p_sous_typo, 'Modification de la ligne BIP');

            --SEL PPM 64405
            maj_ligne_bip_logs(p_pid,l_user,'Paramètre local',l_pzone,p_pzone,'Modification de la ligne BIP');

		-- TD 530: lorsqu'une ligne passe au type 1 et à la typologie T1, alors il faut positionner sont statut comptable à "O
		-- fiche 670 : il manquait  : AND  (l_arctype<>'T1')
	  	IF (p_typproj = '1 ') AND (p_arctype='T1')  AND  (l_arctype<>'T1')  THEN
			UPDATE LIGNE_BIP
	  		SET astatut ='O'
	  		WHERE pid=p_pid;
	  		-- On logue la modif
	  		maj_ligne_bip_logs(p_pid, l_user, 'Statut', l_astatut, 'O', 'Modification de la ligne BIP');
		END IF;

		-- TD 530: Lorsqu'une ligne passe du type 1 et de la typologie T1 à un autre type alors il faut mettre son statut à vide
		IF (p_arctype<>'T1') AND (l_typproj='1 ') AND (l_arctype='T1') THEN
			UPDATE LIGNE_BIP
	  		SET astatut =''
	  		WHERE pid=p_pid;
	  		-- On logue la modif
	  		maj_ligne_bip_logs(p_pid, l_user, 'Statut', l_astatut, NULL, 'Modification de la ligne BIP');

		END IF;


			--ajout fiche 483 - 16/03/2007 EVI
			maj_ligne_bip_logs(p_pid, l_user, 'Code dossier projet', LPAD(l_dpcode,5,0), LPAD(p_dpcode,5,0), 'Modification de la ligne BIP');
            maj_ligne_bip_logs(p_pid, l_user, 'Code projet', l_icpi, p_icpi, 'Modification de la ligne BIP');


         EXCEPTION
            WHEN referential_integrity THEN
              -- habiller le msg erreur
              Pack_Global.recuperation_integrite(-2291);

              -- Ne pas intercepter les autres exceptions

            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
         END;

         IF SQL%NOTFOUND THEN
            Pack_Global.recuperer_message(20999, NULL, NULL, NULL, msg);
            RAISE_APPLICATION_ERROR( -20999, msg );
         ELSE

		 	-- TD 532 : Utilisation pour tester que le CA fait partie des CA préconisés
			l_test_est_ca_preconise := EST_DANS_LISTE_CA_PRECONISE(p_codcamo, p_airt, p_icpi);
			IF (l_test_est_ca_preconise != 0)
			THEN
				-- Affichage du message : Demander la modification du CA auprès du gestionnaire de la BIP
				Pack_Global.recuperer_message(5009, '%s1', p_pid, NULL, msg);
				Pack_Global.recuperer_message(21060, NULL, NULL, NULL, msg2);
				p_message := msg || '\r \r => ' || msg2;
			ELSE
            	Pack_Global.recuperer_message(5009, '%s1', p_pid, NULL, msg);
            	p_message := msg;
			END IF;

         END IF;

         -- Verifications apres integrites
         -- Structure SG non fermee
         -- Recuperer le top fermeture du code sg

         BEGIN
            SELECT TOPFER INTO topfer
            FROM STRUCT_INFO
            WHERE CODSG = TO_NUMBER(p_codsg);

         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               NULL;
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
          END;

	 l_menutil := Pack_Global.lire_globaldata(p_userid).menutil;

         IF (topfer = 'F') AND (l_menutil != 'DIR') THEN

            -- Erreur applicative

            Pack_Global.recuperer_message(20274, NULL, NULL, 'CODSG', msg);
            RAISE_APPLICATION_ERROR( -20274, msg );
         END IF;

	-- ABN - HP PPM 61434
	--client mo non fermee
    -- Recuperer le top fermeture du client mo
	 BEGIN
		SELECT CLITOPF INTO topfer
		FROM CLIENT_MO
		WHERE LTRIM(RTRIM(CLICODE)) = LTRIM(RTRIM(p_clicode));

	  EXCEPTION
		WHEN NO_DATA_FOUND THEN
		   NULL;
		WHEN OTHERS THEN
		   RAISE_APPLICATION_ERROR( -20997, SQLERRM);
	  END;

	  IF (topfer = 'F') AND (l_menutil != 'DIR') THEN
			-- Erreur applicative
		Pack_Global.recuperer_message(20018, NULL, NULL, 'CLICODE', msg);
			RAISE_APPLICATION_ERROR( -20018, msg);
	  END IF;

	-- ABN - HP PPM 61434

	 -- Si le CA saisit correspond avec le code de m_facturation et que l'ancien ne correspond pas
	 -- On saisit le CA 0 dans la table repartition_ligne avec un taux de 100%
	 IF ((p_codcamo=CODCAMO_MULTI) AND (l_codcamo != CODCAMO_MULTI)) THEN
	  	SELECT ADD_MONTHS(DATDEBEX, -1) INTO l_datdeb FROM DATDEBEX WHERE ROWNUM<2;
	         --
	         -- Vérifie qu'il n'existe pas déjà des lignes dans répartition ligne
	         --
	         BEGIN
	            SELECT DISTINCT '1' INTO l_test
	            FROM REPARTITION_LIGNE
	            WHERE PID = p_pid;

	         EXCEPTION
	            WHEN NO_DATA_FOUND THEN
	      	  	-- Insère une première répartition
		  	INSERT INTO REPARTITION_LIGNE
		  	       (pid, codcamo, tauxrep, datdeb)
		  	VALUES (p_pid, l_codcamo, 100, l_datdeb);

	            WHEN OTHERS THEN
	               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
	          END;
	 END IF;


	 l_menutil := Pack_Global.lire_globaldata(p_userid).menutil;
         IF (topfer = 'F') AND (l_menutil != 'DIR') THEN
            -- Erreur applicative
            Pack_Global.recuperer_message(20018, NULL, NULL, 'CLICODE', msg);
            RAISE_APPLICATION_ERROR( -20018, msg );
         END IF;

   END update_ligne_bip;

PROCEDURE RECUPERER_CODE_BRANCHE(p_clicode		IN	CLIENT_MO.clicode%TYPE,
								 p_codbr		OUT	VARCHAR2,
                                 p_libbr        OUT VARCHAR2,
                                 p_libdir       OUT VARCHAR2,
								 p_message		OUT VARCHAR2)
			IS
msg 		VARCHAR(1024);
BEGIN
	SELECT TO_CHAR(d.CODBR), b.LIBBR, d.LIBDIR INTO p_codbr, p_libbr, p_libdir
	FROM CLIENT_MO c,DIRECTIONS d, BRANCHES b
	WHERE TRIM(c.clicode)=TRIM(p_clicode)
	AND d.coddir=c.clidir
	AND b.CODBR=d.CODBR;

	EXCEPTION
	WHEN NO_DATA_FOUND THEN
			Pack_Global.recuperer_message( 4, '%s1', p_clicode, NULL, p_message);
	WHEN OTHERS THEN
	               RAISE_APPLICATION_ERROR( -20997, SQLERRM);


END 	RECUPERER_CODE_BRANCHE;

---------------------------------------------------------------------------------------------------------------
PROCEDURE REMISE_A_ZERO(p_pid		IN	    LIGNE_BIP.pid%TYPE,
                        p_userid   	IN      VARCHAR2,
                        p_message	OUT 	VARCHAR2)
			IS
msg 		    VARCHAR(1024);
l_user		    LIGNE_BIP_LOGS.user_log%TYPE;
l_dertrait	    VARCHAR2(10);
l_adatestatut	VARCHAR2(10);
l_annee	        NUMBER(4);
l_cusag	        NUMBER(12,2);
l_xcusag        NUMBER(12,2);
l_xcusagW       NUMBER(12,2);

BEGIN
 -- initialiser le message retour
      p_message := '';

 -- récupérer le user
 l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);

   BEGIN
	SELECT TO_CHAR(DERTRAIT,'dd/mm/yyyy'),TO_NUMBER(TO_CHAR(MOISMENS,'yyyy'))
	INTO   l_dertrait, l_annee
	FROM DATDEBEX;

	SELECT TO_CHAR(ADATESTATUT,'dd/mm/yyyy')
	INTO   l_adatestatut
	FROM LIGNE_BIP
	WHERE  pid = p_pid;

	SELECT CUSAG, XCUSAG
	INTO   l_cusag, l_xcusag
	FROM CONSOMME
	WHERE  annee = l_annee
	AND pid = p_pid;


    -- Test pour savoir si la Ligne BIP est Fermée
	IF ( l_adatestatut IS NOT NULL AND l_adatestatut <= l_dertrait) THEN
	   	  Pack_Global.recuperer_message( 20371, '%s1', p_pid, NULL, p_message);
		  RAISE_APPLICATION_ERROR( -20371, p_message );
	ELSE  -- Update des tables CONS_SSTACHE_RESS_MOIS et de CONSOMME
	   -- CONS_SSTACHE_RES_MOIS
	      UPDATE CONS_SSTACHE_RES_MOIS
	      SET cusag = 0
	      WHERE pid = p_pid;
       -- CONSOMME
	      l_xcusagW := l_xcusag;
	      l_xcusagW  := (l_xcusag - l_cusag);
	      UPDATE CONSOMME
	      SET cusag  = 0,
	          xcusag = l_xcusagW
	      WHERE pid = p_pid
	      AND annee = l_annee;

       -- On logue la modification
	      maj_ligne_bip_logs(p_pid, l_user, 'CUSAG', NULL, '0', 'Remise à zéro du consommé');

	   -- Retour message informatif de mise à jour
	      Pack_Global.recuperer_message(20027, '%s1', p_pid,  NULL, msg);
          p_message := msg;
	END IF;

	EXCEPTION
	WHEN NO_DATA_FOUND THEN
			Pack_Global.recuperer_message( 20504, '%s1', p_pid, NULL, p_message);
	WHEN OTHERS THEN
	        RAISE_APPLICATION_ERROR( -20997, SQLERRM);

   END;

END 	REMISE_A_ZERO;

-- TD 532
-- Procédure pour afficher l'ensemble des CA préconisés (si il en existe) pour une application et un projet donné
-- TD 756 YNI 12/11/2009 procedure appelee lors du chargement de la page
-- l¿affichage des CA préconisés dans l¿écran de création/modification des lignes BIP.
FUNCTION EST_LISTE_CA_PRECONISES(p_PID		IN	LIGNE_BIP.PID%TYPE
							    ) RETURN VARCHAR2 IS
-- Variables locales
l_liste VARCHAR2(10024);
l_airt LIGNE_BIP.AIRT%TYPE;

l_codcamo1_pr	PROJ_INFO.CODCAMO1%TYPE;
l_codcamo2_pr	PROJ_INFO.CODCAMO2%TYPE;
l_codcamo3_pr	PROJ_INFO.CODCAMO3%TYPE;
l_codcamo4_pr	PROJ_INFO.CODCAMO4%TYPE;
l_codcamo5_pr	PROJ_INFO.CODCAMO5%TYPE;
l_codcamo1_ap	APPLICATION.CODCAMO1%TYPE;
l_codcamo2_ap	APPLICATION.CODCAMO2%TYPE;
l_codcamo3_ap	APPLICATION.CODCAMO3%TYPE;
l_codcamo4_ap	APPLICATION.CODCAMO4%TYPE;
l_codcamo5_ap	APPLICATION.CODCAMO5%TYPE;
l_codcamo6_ap	APPLICATION.CODCAMO6%TYPE;
l_codcamo7_ap	APPLICATION.CODCAMO7%TYPE;
l_codcamo8_ap	APPLICATION.CODCAMO8%TYPE;
l_codcamo9_ap	APPLICATION.CODCAMO9%TYPE;
l_codcamo10_ap	APPLICATION.CODCAMO10%TYPE;

-- YNI
l2_typproj LIGNE_BIP.TYPPROJ%TYPE;
l_arctype LIGNE_BIP.ARCTYPE%TYPE;
l_icpi LIGNE_BIP.ICPI%TYPE;
-- Fin YNI
l_typproj LIGNE_BIP.TYPPROJ%TYPE;

	-- Contruction de la liste des CA préconisés
	-- CHR(13) = Retour Chariot / CHR(32) = Espace / CHR(45) = -
	-- Utilisation de CHR(x)  pour éviter des problèmes lors de la concaténation de chaines
	CURSOR liste_ca IS
	SELECT DISTINCT
  --SEL 22/01/2015 PPM 60954
		CHR(13) || '<FONT color=white size=2>' ||TO_CHAR(ca.CODCAMO, 'FM00000') || '</FONT><FONT color=white size=1,5>'||CHR(45) || ca.CLIBCA as ligne
	--	CHR(13) || TO_CHAR(ca.CODCAMO, 'FM00000') || CHR(32) || CHR(45) || CHR(32) || ca.CLIBCA ligne
	FROM CENTRE_ACTIVITE ca
	WHERE
		ca.CODCAMO IN
			(l_codcamo1_pr, l_codcamo2_pr, l_codcamo3_pr, l_codcamo4_pr, l_codcamo5_pr,
			 l_codcamo1_ap, l_codcamo2_ap, l_codcamo3_ap, l_codcamo4_ap, l_codcamo5_ap,
			 l_codcamo6_ap, l_codcamo7_ap, l_codcamo8_ap, l_codcamo9_ap, l_codcamo10_ap)
	AND ca.CODCAMO IS NOT NULL
	AND ca.CODCAMO <> 0
	;

BEGIN
	-- Initalisation de la liste retournée au cas où aucun CA ne serait préconisé ni au niveau projet ni au niveau application
	l_liste := '';

	-- Récupération des codes CA préconisés pour le projet et l'application
	BEGIN
		 -- Récupération des CA préconisés pour le projet
     -- YNI
     BEGIN
        SELECT Tbl.TYPPROJ, Tbl.ARCTYPE, Tbl.ICPI, Tbl.AIRT
        INTO l_TYPPROJ, l_ARCTYPE, l_ICPI, l_airt
        FROM BIP.LIGNE_BIP Tbl
        where Tbl.pid = p_pid;
     END;
     -- Fin YNI
     -- de la règle d'affichage des CA préconisés pour le projet uniquement
     -- si la typologie secondaire de la ligne BIP est égale à GT1

     -- Récupération des CA préconisés pour le projet
     -- YNI Ajout du test si la ligne est GT1
		 IF l_ICPI is not null and (l_TYPPROJ = '1' and l_ARCTYPE = 'T1')THEN
         SELECT
            p.codcamo1, p.codcamo2, p.codcamo3, p.codcamo4,	p.codcamo5
         INTO
           l_codcamo1_pr, l_codcamo2_pr, l_codcamo3_pr, l_codcamo4_pr, l_codcamo5_pr
         FROM PROJ_INFO p, LIGNE_BIP lb
         WHERE lb.ICPI = p.ICPI
         AND lb.PID = p_PID
         ;
     END IF;

		 -- Récuperation des CA préconisés pour l'application
		 -- Détermination du type de ligne BIP
		/*
     SELECT
				lb.TYPPROJ, lb.AIRT
		 INTO l_typproj,l_airt
		 FROM LIGNE_BIP lb
	     WHERE lb.PID = p_PID
	     ;*/

     IF l_airt is not null and (l_TYPPROJ != '1' or l_ARCTYPE != 'T1') THEN
		 IF l_typproj IN ('6', '8', '9')
		 -- Cas  : Ligne BIP de type t6, t8, ou t9
		 THEN
			BEGIN
				-- Recuperer uniquement les CA dont le type d'activité est  "EXP" ou " "
				RECUPERER_CA_PRECONISE_APPLI('EXP', l_AIRT,
											 l_codcamo1_ap, l_codcamo2_ap, l_codcamo3_ap, l_codcamo4_ap, l_codcamo5_ap,
											 l_codcamo6_ap, l_codcamo7_ap, l_codcamo8_ap, l_codcamo9_ap, l_codcamo10_ap);
			END;
		 ELSE IF l_typproj IN ('1', '2', '3', '4')
			  -- Cas  : Ligne BIP de type t1, t2, t3 ou t4
			  THEN
				BEGIN
					-- Recuperer uniquement les CA dont le type d'activité est  "MAINT" ou " "
					RECUPERER_CA_PRECONISE_APPLI('MAINT', l_AIRT,
												 l_codcamo1_ap, l_codcamo2_ap, l_codcamo3_ap, l_codcamo4_ap, l_codcamo5_ap,
												 l_codcamo6_ap, l_codcamo7_ap, l_codcamo8_ap, l_codcamo9_ap, l_codcamo10_ap);
				END;
			  ELSE
				BEGIN
					-- Cas : Autre type de ligne
					-- Récuperer uniquement les CA dont le type d'activité est " "
					RECUPERER_CA_PRECONISE_APPLI('', l_AIRT,
												 l_codcamo1_ap, l_codcamo2_ap, l_codcamo3_ap, l_codcamo4_ap, l_codcamo5_ap,
												 l_codcamo6_ap, l_codcamo7_ap, l_codcamo8_ap, l_codcamo9_ap, l_codcamo10_ap);
				END;
			  END IF;
		 END IF;
     END IF;
 	EXCEPTION
	WHEN NO_DATA_FOUND THEN
		 l_liste := ' ';
    END;



	-- Transformation du curseur en un champ unique
	FOR ca_preconise IN liste_ca LOOP
		l_liste :='</FONT>' || l_liste || '<br>' || ca_preconise.ligne;
	END LOOP;

	RETURN (l_liste);

END EST_LISTE_CA_PRECONISES;



FUNCTION EST_DANS_LISTE_CA_PRECONISE(p_CODCAMO	LIGNE_BIP.CODCAMO%TYPE,
									 p_AIRT		LIGNE_BIP.AIRT%TYPE,
									 p_ICPI		LIGNE_BIP.ICPI%TYPE
									) RETURN NUMBER IS
-- Variables locales
l_codcamo1_pr	PROJ_INFO.CODCAMO1%TYPE;
l_codcamo2_pr	PROJ_INFO.CODCAMO2%TYPE;
l_codcamo3_pr	PROJ_INFO.CODCAMO3%TYPE;
l_codcamo4_pr	PROJ_INFO.CODCAMO4%TYPE;
l_codcamo5_pr	PROJ_INFO.CODCAMO5%TYPE;
l_codcamo1_ap	APPLICATION.CODCAMO1%TYPE;
l_codcamo2_ap	APPLICATION.CODCAMO2%TYPE;
l_codcamo3_ap	APPLICATION.CODCAMO3%TYPE;
l_codcamo4_ap	APPLICATION.CODCAMO4%TYPE;
l_codcamo5_ap	APPLICATION.CODCAMO5%TYPE;
l_codcamo6_ap	APPLICATION.CODCAMO6%TYPE;
l_codcamo7_ap	APPLICATION.CODCAMO7%TYPE;
l_codcamo8_ap	APPLICATION.CODCAMO8%TYPE;
l_codcamo9_ap	APPLICATION.CODCAMO9%TYPE;
l_codcamo10_ap	APPLICATION.CODCAMO10%TYPE;

BEGIN
	-- Récupération des codes CA préconisés pour le projet et l'application
	SELECT
		p.codcamo1, p.codcamo2, p.codcamo3, p.codcamo4,	p.codcamo5
	INTO
		l_codcamo1_pr, l_codcamo2_pr, l_codcamo3_pr, l_codcamo4_pr,	l_codcamo5_pr
	FROM PROJ_INFO p
	WHERE p.ICPI = p_ICPI
	;

	SELECT
		a.codcamo1, a.codcamo2, a.codcamo3, a.codcamo4,	a.codcamo5,
		a.codcamo6, a.codcamo7, a.codcamo8, a.codcamo9,	a.codcamo10
	INTO
		l_codcamo1_ap, l_codcamo2_ap, l_codcamo3_ap, l_codcamo4_ap,	l_codcamo5_ap,
		l_codcamo6_ap, l_codcamo7_ap, l_codcamo8_ap, l_codcamo9_ap,	l_codcamo10_ap
	FROM APPLICATION a
	WHERE a.AIRT = p_AIRT
	;

	IF (p_CODCAMO IN (l_codcamo1_pr, l_codcamo2_pr, l_codcamo3_pr, l_codcamo4_pr, l_codcamo5_pr,
					  l_codcamo1_ap, l_codcamo2_ap, l_codcamo3_ap, l_codcamo4_ap, l_codcamo5_ap,
					  l_codcamo6_ap, l_codcamo7_ap, l_codcamo8_ap, l_codcamo9_ap, l_codcamo10_ap))
	THEN
		RETURN (0);
	ELSE
		BEGIN
			 -- Cas particulier où le CODCAMO est <> 0 mais tous les CA préconisés en table sont = 0
			 IF ((l_codcamo1_pr = 0) AND (l_codcamo2_pr = 0) AND (l_codcamo3_pr = 0) AND (l_codcamo4_pr = 0) AND (l_codcamo5_pr = 0) AND
				(l_codcamo1_ap = 0) AND (l_codcamo2_ap = 0) AND (l_codcamo3_ap = 0) AND (l_codcamo4_ap = 0) AND	(l_codcamo5_ap = 0) AND
				(l_codcamo6_ap = 0) AND (l_codcamo7_ap = 0) AND (l_codcamo8_ap = 0) AND (l_codcamo9_ap = 0) AND	(l_codcamo10_ap = 0))
			 THEN
			 	 RETURN (0);
			 ELSE
			 	 RETURN (1);
			END IF;
		END;
	END IF;
END EST_DANS_LISTE_CA_PRECONISE;


PROCEDURE RECUPERER_CA_PRECONISE_APPLI(p_TYPACT   	IN VARCHAR2,
									   p_AIRT 	  	IN APPLICATION.AIRT%TYPE,
									   p_CODCAMO1 	IN OUT APPLICATION.CODCAMO1%TYPE,
									   p_CODCAMO2 	IN OUT APPLICATION.CODCAMO2%TYPE,
									   p_CODCAMO3 	IN OUT APPLICATION.CODCAMO3%TYPE,
									   p_CODCAMO4 	IN OUT APPLICATION.CODCAMO4%TYPE,
									   p_CODCAMO5 	IN OUT APPLICATION.CODCAMO5%TYPE,
									   p_CODCAMO6 	IN OUT APPLICATION.CODCAMO6%TYPE,
									   p_CODCAMO7 	IN OUT APPLICATION.CODCAMO7%TYPE,
									   p_CODCAMO8 	IN OUT APPLICATION.CODCAMO8%TYPE,
									   p_CODCAMO9 	IN OUT APPLICATION.CODCAMO9%TYPE,
									   p_CODCAMO10 	IN OUT APPLICATION.CODCAMO10%TYPE
									   ) IS
BEGIN

	SELECT
		DECODE(a.typactca1, p_TYPACT, a.codcamo1, '', a.codcamo1, 0),
		DECODE(a.typactca2, p_TYPACT, a.codcamo2, '', a.codcamo2, 0),
		DECODE(a.typactca3, p_TYPACT, a.codcamo3, '', a.codcamo3, 0),
		DECODE(a.typactca4, p_TYPACT, a.codcamo4, '', a.codcamo4, 0),
		DECODE(a.typactca5, p_TYPACT, a.codcamo5, '', a.codcamo5, 0),
		DECODE(a.typactca6, p_TYPACT, a.codcamo6, '', a.codcamo6, 0),
		DECODE(a.typactca7, p_TYPACT, a.codcamo7, '', a.codcamo7, 0),
		DECODE(a.typactca8, p_TYPACT, a.codcamo8, '', a.codcamo8, 0),
		DECODE(a.typactca9, p_TYPACT, a.codcamo9, '', a.codcamo9, 0),
		DECODE(a.typactca10, p_TYPACT, a.codcamo10, '', a.codcamo10, 0)
	INTO
		p_CODCAMO1, p_CODCAMO2, p_CODCAMO3, p_CODCAMO4,	p_CODCAMO5,
		p_CODCAMO6, p_CODCAMO7, p_CODCAMO8, p_CODCAMO9,	p_CODCAMO10
	FROM APPLICATION a
	WHERE a.AIRT=p_AIRT
	;

END RECUPERER_CA_PRECONISE_APPLI;




-- Procédure pour afficher l'ensemble des CA préconisés (si il en existe) pour une application et un projet donné
-- TD 756 YNI 12/11/2009 procedure appelee lors du refresh de la page
-- l'affichage des CA préconisés dans l'écran de création/modification des lignes BIP.
-- Ajout des arguments p_arctype et p_pid
PROCEDURE LISTER_CA_PRECONISES(p_icpi  IN PROJ_INFO.ICPI%TYPE,
		  					               p_airt  IN APPLICATION.AIRT%TYPE,
							                 p_typproj IN LIGNE_BIP.TYPPROJ%TYPE,
                               p_arctype IN LIGNE_BIP.ARCTYPE%TYPE,
                               p_pid IN LIGNE_BIP.PID%TYPE,
          					           p_liste   OUT VARCHAR2) IS
-- Variables locales
l_liste VARCHAR2(10024);

l_codcamo1_pr	PROJ_INFO.CODCAMO1%TYPE;
l_codcamo2_pr	PROJ_INFO.CODCAMO2%TYPE;
l_codcamo3_pr	PROJ_INFO.CODCAMO3%TYPE;
l_codcamo4_pr	PROJ_INFO.CODCAMO4%TYPE;
l_codcamo5_pr	PROJ_INFO.CODCAMO5%TYPE;
l_codcamo1_ap	APPLICATION.CODCAMO1%TYPE;
l_codcamo2_ap	APPLICATION.CODCAMO2%TYPE;
l_codcamo3_ap	APPLICATION.CODCAMO3%TYPE;
l_codcamo4_ap	APPLICATION.CODCAMO4%TYPE;
l_codcamo5_ap	APPLICATION.CODCAMO5%TYPE;
l_codcamo6_ap	APPLICATION.CODCAMO6%TYPE;
l_codcamo7_ap	APPLICATION.CODCAMO7%TYPE;
l_codcamo8_ap	APPLICATION.CODCAMO8%TYPE;
l_codcamo9_ap	APPLICATION.CODCAMO9%TYPE;
l_codcamo10_ap	APPLICATION.CODCAMO10%TYPE;

l_typproj LIGNE_BIP.TYPPROJ%TYPE;
-- YNI
l2_typproj LIGNE_BIP.TYPPROJ%TYPE;
l_arctype LIGNE_BIP.ARCTYPE%TYPE;

-- Fin YNI

	-- Contruction de la liste des CA préconisés
	-- CHR(13) = Retour Chariot / CHR(32) = Espace / CHR(45) = -
	-- Utilisation de CHR(x)  pour éviter des problèmes lors de la concaténation de chaines
	CURSOR liste_ca IS
	SELECT DISTINCT
  --SEL 22/01/2015 PPM 60954
	CHR(13) || '<FONT color=white size=2>' ||TO_CHAR(ca.CODCAMO, 'FM00000') || '</FONT><FONT color=white size=1,5>'||CHR(45) || ca.CLIBCA as ligne
	--CHR(13) || TO_CHAR(ca.CODCAMO, 'FM00000') || CHR(45) || ca.CLIBCA ligne
	--	CHR(13) || TO_CHAR(ca.CODCAMO, 'FM00000') || CHR(32) || CHR(45) || CHR(32) || ca.CLIBCA ligne

	FROM CENTRE_ACTIVITE ca
	WHERE
		ca.CODCAMO IN
			(l_codcamo1_pr, l_codcamo2_pr, l_codcamo3_pr, l_codcamo4_pr, l_codcamo5_pr,
			 l_codcamo1_ap, l_codcamo2_ap, l_codcamo3_ap, l_codcamo4_ap, l_codcamo5_ap,
			 l_codcamo6_ap, l_codcamo7_ap, l_codcamo8_ap, l_codcamo9_ap, l_codcamo10_ap)
	AND ca.CODCAMO IS NOT NULL
	AND ca.CODCAMO <> 0
	;

BEGIN
	-- Initalisation de la liste retournée au cas où aucun CA ne serait préconisé ni au niveau projet ni au niveau application
	l_liste := '';

	-- Récupération des codes CA préconisés pour le projet et l'application
	BEGIN

      -- YNI
      IF  p_pid is not null THEN

            SELECT TYPPROJ, ARCTYPE
            INTO l2_TYPPROJ, l_ARCTYPE
            FROM LIGNE_BIP
            where pid = p_pid;

      ELSE
            l2_TYPPROJ := p_typproj;
            l_ARCTYPE := p_arctype;
      END IF;

     -- Fin YNI

		 -- Récupération des CA préconisés pour le projet
     -- YNI Ajout du test si la ligne est GT1
		 IF p_icpi is not null and (l2_TYPPROJ = '1' and l_ARCTYPE = 'T1')THEN

     SELECT
		 		p.codcamo1, p.codcamo2, p.codcamo3, p.codcamo4,	p.codcamo5
		 INTO
		 	  l_codcamo1_pr, l_codcamo2_pr, l_codcamo3_pr, l_codcamo4_pr, l_codcamo5_pr
		 FROM PROJ_INFO p
		 WHERE p.ICPI = p_icpi	 ;

		 END IF;


		 -- Récuperation des CA préconisés pour l'application
		 -- Détermination du type de ligne BIP
		/* SELECT
				lb.TYPPROJ
		 INTO l_typproj
		 FROM LIGNE_BIP lb
	     WHERE lb.PID = p_PID;*/

     --ELSE

     -- YNI Ajout du test si la ligne n'est pas GT1
		 IF p_airt is not null and (l2_TYPPROJ != '1' or l_ARCTYPE != 'T1') THEN

		 IF p_typproj IN ('6', '8', '9')
		 -- Cas  : Ligne BIP de type t6, t8, ou t9
		 THEN
			BEGIN
				-- Recuperer uniquement les CA dont le type d'activité est  "EXP" ou " "
				RECUPERER_CA_PRECONISE_APPLI('EXP', p_airt,
											 l_codcamo1_ap, l_codcamo2_ap, l_codcamo3_ap, l_codcamo4_ap, l_codcamo5_ap,
											 l_codcamo6_ap, l_codcamo7_ap, l_codcamo8_ap, l_codcamo9_ap, l_codcamo10_ap);
			END;
		 ELSE IF p_typproj IN ('1', '2', '3', '4')
			  -- Cas  : Ligne BIP de type t1, t2, t3 ou t4
			  THEN
				BEGIN
					-- Recuperer uniquement les CA dont le type d'activité est  "MAINT" ou " "
					RECUPERER_CA_PRECONISE_APPLI('MAINT', p_airt,
												 l_codcamo1_ap, l_codcamo2_ap, l_codcamo3_ap, l_codcamo4_ap, l_codcamo5_ap,
												 l_codcamo6_ap, l_codcamo7_ap, l_codcamo8_ap, l_codcamo9_ap, l_codcamo10_ap);
				END;
			  ELSE
				BEGIN
					-- Cas : Autre type de ligne
					-- Récuperer uniquement les CA dont le type d'activité est " "
					RECUPERER_CA_PRECONISE_APPLI('', p_airt,
												 l_codcamo1_ap, l_codcamo2_ap, l_codcamo3_ap, l_codcamo4_ap, l_codcamo5_ap,
												 l_codcamo6_ap, l_codcamo7_ap, l_codcamo8_ap, l_codcamo9_ap, l_codcamo10_ap);
				END;
			  END IF;
		 END IF;
		 END IF;

 	EXCEPTION
	WHEN NO_DATA_FOUND THEN
		 l_liste := ' ';
    END;

	-- Transformation du curseur en un champ unique
	FOR ca_preconise IN liste_ca LOOP
		l_liste :='</FONT>' || l_liste || '<br>' || ca_preconise.ligne;
	END LOOP;

	p_liste := l_liste;
	--RETURN (l_liste);

END LISTER_CA_PRECONISES;

---------------------------------------------------------------------------------------------------------------



--------------------------------- Fiche 656 --------------------------------------------
PROCEDURE recherche_realise_anterieur(p_pid IN VARCHAR2 ,
                                      p_realise OUT VARCHAR2  ) IS

    l_count NUMBER ;
    l_realise NUMBER (12,2) ;

        BEGIN

                  p_realise := NULL ;

                  SELECT COUNT(*) INTO l_count FROM CONSOMME cons WHERE cons.ANNEE <
                  (SELECT EXTRACT(YEAR FROM SYSDATE) FROM DUAL) AND TRIM(cons.PID)=TRIM(p_pid) ;

                   IF(l_count>0) THEN
                        SELECT SUM(CUSAG) INTO l_realise  FROM CONSOMME cons WHERE cons.ANNEE <
                        (SELECT EXTRACT(YEAR FROM SYSDATE) FROM DUAL) AND TRIM(cons.PID)=TRIM(p_pid) ;
                        p_realise := TO_CHAR(l_realise) ;
                   END IF ;




        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR( -20997, SQLERRM );

END recherche_realise_anterieur;



----------------  Fiche 656 : Recherche l'arbitré d'une ligne BIP pour l'année en cours  --------------------
PROCEDURE recherche_arbitre_actuel(p_pid IN VARCHAR2 ,
                                   p_arbitre OUT VARCHAR2 )  IS

            l_count NUMBER ;
            l_arbitre NUMBER (12,2) ;


        BEGIN


                    p_arbitre  := NULL ;

                    select count(*) INTO l_count FROM BUDGET bud WHERE bud.ANNEE =
                    (SELECT EXTRACT(YEAR FROM SYSDATE) FROM DUAL) AND TRIM(bud.PID)=TRIM(p_pid) ;

                    IF(l_count>0) THEN
                        SELECT SUM(ANMONT) INTO l_arbitre FROM BUDGET bud WHERE bud.ANNEE =
                        (SELECT EXTRACT(YEAR FROM SYSDATE) FROM DUAL) AND TRIM(bud.PID)=TRIM(p_pid) ;
                        p_arbitre := TO_CHAR(l_arbitre) ;
                    END IF ;




        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR( -20997, SQLERRM );

 END recherche_arbitre_actuel;

 -- Procédure de création des étape, tâche, sous-tâches d'une ligne BIP correspondant aux absences
PROCEDURE creer_ligne_bip_absence(p_pid IN LIGNE_BIP.PID%TYPE, p_message OUT VARCHAR2) IS

l_libetape VARCHAR2(30);
l_idetape NUMBER;
l_idtache NUMBER;
l_idsoustache NUMBER;
-- ABN - HP PPM 64630
l_exist NUMBER(1);

BEGIN

  --On teste si la ligne à remplir n'a bien aucune structure
	BEGIN
	SELECT  DISTINCT 1 INTO l_exist
	FROM ISAC_ETAPE
	WHERE pid=p_pid;

	IF (l_exist=1) THEN
		--La structure de la ligne %s1 n'est pas vide. Opération annulée
		Pack_Isac.recuperer_message(20018, '%s1',p_pid, NULL,p_message);
               	RAISE_APPLICATION_ERROR( -20018,p_message);
	END IF;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN NULL;

	END;

-- ABN - HP PPM 64630

	select substr(PNOM,0,30) into l_libetape from LIGNE_BIP where pid = p_pid;

	select SEQ_ETAPE.nextval into l_idetape from DUAL;

	insert into ISAC_ETAPE (ETAPE,PID,ECET,LIBETAPE,JEU,TYPETAPE,FLAGLOCK) values (l_idetape,p_pid,'01',l_libetape,'Sans objet','ES',0);

	select SEQ_TACHE.nextval into l_idtache from DUAL;

	insert into ISAC_TACHE (TACHE,PID,ETAPE,ACTA,LIBTACHE,FLAGLOCK) values (l_idtache,p_pid,l_idetape,'01',l_libetape,0);

	insert into ISAC_SOUS_TACHE (SOUS_TACHE,PID,ETAPE,TACHE,ACST,AIST,ASNOM,FLAGLOCK) values (SEQ_SOUS_TACHE.nextval,p_pid,l_idetape,l_idtache,'01','ABSDIV','Absences diverses',0);
	insert into ISAC_SOUS_TACHE (SOUS_TACHE,PID,ETAPE,TACHE,ACST,AIST,ASNOM,FLAGLOCK) values (SEQ_SOUS_TACHE.nextval,p_pid,l_idetape,l_idtache,'02','CONGES','Congés payés',0);
	insert into ISAC_SOUS_TACHE (SOUS_TACHE,PID,ETAPE,TACHE,ACST,AIST,ASNOM,FLAGLOCK) values (SEQ_SOUS_TACHE.nextval,p_pid,l_idetape,l_idtache,'03','RTT','RTT',0);
	insert into ISAC_SOUS_TACHE (SOUS_TACHE,PID,ETAPE,TACHE,ACST,AIST,ASNOM,FLAGLOCK) values (SEQ_SOUS_TACHE.nextval,p_pid,l_idetape,l_idtache,'04','PARTIE','Temps partiel',0);

	commit;

	EXCEPTION
        WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR( -20997, SQLERRM);
		 rollback;

END creer_ligne_bip_absence;

-- Procédure de création des étape, tâche, sous-tâches d'une ligne BIP correspondant au hors projet


PROCEDURE creer_ligne_prod_hors_projet(
p_pid IN LIGNE_BIP.PID%TYPE,
 p_direction   IN       VARCHAR2,
 p_message     OUT      VARCHAR2)

  IS
l_libetape VARCHAR2(30);
l_idetape NUMBER;
l_idtache NUMBER;
l_idsoustache NUMBER;

--HMI - PPM 60709 : $5.3 QC 1785
parametrage_controle   EXCEPTION;
l_msg         VARCHAR2 (255);
-- ABN - HP PPM 64630
l_exist NUMBER(1);
-- ABN - HP PPM 64630

BEGIN
l_msg := '';

--HMI - PPM 60709 : $5.3 QC 1785
         IF  controle_parametrage(p_pid,p_direction)
         THEN  RAISE parametrage_controle;
END IF;

-- ABN - HP PPM 64630
  --On teste si la ligne à remplir n'a bien aucune structure
	BEGIN
	SELECT  DISTINCT 1 INTO l_exist
	FROM ISAC_ETAPE
	WHERE pid=p_pid;

	IF (l_exist=1) THEN
		--La structure de la ligne %s1 n'est pas vide. Opération annulée
		Pack_Isac.recuperer_message(20018, '%s1',p_pid, NULL,p_message);
               	RAISE_APPLICATION_ERROR( -20018,p_message);
	END IF;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN NULL;

	END;
-- ABN - HP PPM 64630

	select substr(PNOM,0,30) into l_libetape from LIGNE_BIP where pid = p_pid;

	select SEQ_ETAPE.nextval into l_idetape from DUAL;

	insert into ISAC_ETAPE (ETAPE,PID,ECET,LIBETAPE,JEU,TYPETAPE,FLAGLOCK) values (l_idetape,p_pid,'01',l_libetape,'Sans objet','NO',0);

	select SEQ_TACHE.nextval into l_idtache from DUAL;

	insert into ISAC_TACHE (TACHE,PID,ETAPE,ACTA,LIBTACHE,FLAGLOCK) values (l_idtache,p_pid,l_idetape,'01',l_libetape,0);

	select SEQ_SOUS_TACHE.nextval into l_idsoustache from DUAL;

	insert into ISAC_SOUS_TACHE (SOUS_TACHE,PID,ETAPE,TACHE,ACST,AIST,ASNOM,FLAGLOCK) values (l_idsoustache,p_pid,l_idetape,l_idtache,'01','',l_libetape,0);

	commit;

	EXCEPTION

 --HMI - PPM 60709 : $5.3 QC 1785
           WHEN parametrage_controle
              THEN

            pack_global.recuperer_message (21306, NULL, NULL, NULL, p_message);
            raise_application_error (-20999, p_message);

        WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR( -20997, SQLERRM);
		 rollback;


END creer_ligne_prod_hors_projet;

-- Procédure de création des étapes, tâches, sous-tâches d'une ligne productive en mode projet
PROCEDURE creer_ligne_prod_en_projet(p_pid IN LIGNE_BIP.PID%TYPE, p_jeu IN TYPE_ETAPE_JEUX.JEU%TYPE, p_message OUT VARCHAR2) IS
  BEGIN

    DECLARE

      -- Liste des code/libellé des types d'étape du jeu de type d'étape p_jeu
      CURSOR moncurseur IS
        SELECT   TYPETAP, LIBTYET
        FROM TYPE_ETAPE
        WHERE jeu = p_jeu
        --HMI - PPM 60709 : $5.3 Selectionner que les type d'étapes compatible QC 1790
       AND (PACK_ISAC_ETAPE.verifTypologieTypeEtape(p_pid,TYPELIGNE) = 'valide')
        ORDER BY chronologie;

      -- Déclaration des var
      code_type_etape TYPE_ETAPE.TYPETAP%TYPE;
      libelle_type_etape TYPE_ETAPE.LIBTYET%TYPE;

      id_next_etape ISAC_ETAPE.ETAPE%TYPE;
      numero_next_etape NUMBER;
      numero_next_etape_chaine VARCHAR2(1024);
      id_next_tache ISAC_TACHE.TACHE%TYPE;
      id_next_sous_tache ISAC_SOUS_TACHE.SOUS_TACHE%TYPE;
      -- ABN - HP PPM 64630
      l_exist NUMBER(1);
      l_TACHEAXEMETIER ISAC_TACHE.tacheaxemetier%TYPE;--KRA HP PPM 63867


    BEGIN
 -- ABN - HP PPM 64630
  --On teste si la ligne à remplir n'a bien aucune structure
	BEGIN
    SELECT  DISTINCT 1 INTO l_exist
    FROM ISAC_ETAPE
    WHERE pid=p_pid;

    IF (l_exist=1) THEN
      --La structure de la ligne %s1 n'est pas vide. Opération annulée
      Pack_Isac.recuperer_message(20018, '%s1',p_pid, NULL,p_message);
               	RAISE_APPLICATION_ERROR( -20018,p_message);
    END IF;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN NULL;

	END;
 --KRA HP PPM 63867
   l_TACHEAXEMETIER := '';
   PACK_ISAC_TACHE.INITIALISER_TACHE_AXE_METIER(p_pid,l_TACHEAXEMETIER);
 --KRA HP PPM 63867

 -- ABN - HP PPM 64630
      -- Initialisation du numéro d'étape
      numero_next_etape := 0;

      FOR maligne IN moncurseur LOOP
        -- Alimentation du code/libellé du typoe d'étape courant
        code_type_etape := maligne.TYPETAP;
        libelle_type_etape := maligne.LIBTYET;

        -- Alimentation des id étape, tâche, sous-tâche à créer
        SELECT SEQ_ETAPE.nextval into id_next_etape from DUAL;
        numero_next_etape := numero_next_etape + 1;


        IF (numero_next_etape < 10) THEN
          numero_next_etape_chaine := '0' || numero_next_etape;
        ELSE
          numero_next_etape_chaine := numero_next_etape;
        END IF;


        SELECT SEQ_TACHE.nextval into id_next_tache from DUAL;
        SELECT SEQ_SOUS_TACHE.nextval into id_next_sous_tache from DUAL;

        -- Création des étape, tâche et sous-tâche
        INSERT INTO ISAC_ETAPE VALUES (id_next_etape, p_pid, numero_next_etape_chaine, SUBSTR(libelle_type_etape, 1, 30), code_type_etape, 0, p_jeu);
        --KRA HP PPM 63867
        INSERT INTO ISAC_TACHE VALUES (id_next_tache, p_pid, id_next_etape, '01', SUBSTR(libelle_type_etape, 1, 30), 0,l_TACHEAXEMETIER);
        --KRA HP PPM 63867
        INSERT INTO ISAC_SOUS_TACHE (SOUS_TACHE,PID,ETAPE,TACHE,ACST,ASNOM,FLAGLOCK,FAVORITE) VALUES (id_next_sous_tache, p_pid, id_next_etape, id_next_tache, '01', SUBSTR(libelle_type_etape, 1, 30), 0, 0);
      END LOOP;
    END;
END creer_ligne_prod_en_projet;



--PPM 58143
-- ZAA - PPM 61695
PROCEDURE lister_clients_dbs (p_userid  IN VARCHAR2, p_curseur IN OUT LigneClientDBS_listeCurType,message OUT VARCHAR2)
IS
l_cli_dir VARCHAR2(20);
l_chaine_dbs VARCHAR2(400);
t_table         t_array;
p_branche VARCHAR2(10);
p_direction VARCHAR2(10);
p_filtre VARCHAR2(400);
p_obligation VARCHAR2(10);
separateur VARCHAR2(1);

BEGIN

separateur := '';
RECUPERER_PARAM_APP('OBLIGATION-DBS','DEFAUT',1,l_chaine_dbs,message);
RECUPERER_SEPAR_PARAM_APP('OBLIGATION-DBS','DEFAUT',1,separateur,message);

    -- Initialisation
    p_branche       := '';
    p_direction     := '';
    p_filtre        := '';
    p_obligation    := '';


            --t_table := SPLIT(l_chaine_dbs,',');
            t_table := SPLIT(l_chaine_dbs,separateur);
            p_obligation:=t_table(1);

            FOR I IN 2..t_table.COUNT LOOP


              p_branche := SUBSTR(t_table(I),1,2);
              p_direction := SUBSTR(t_table(I),3,2);
                 IF p_direction='00' THEN
                 p_direction :='';
                 END IF;


              IF (I = t_table.COUNT)
                THEN
                  p_filtre := p_filtre||'^'||p_branche||p_direction;
              ELSE
                p_filtre := p_filtre||'^'||p_branche||p_direction||'|';
              END IF;

            END LOOP;


            OPEN p_curseur FOR
              --select distinct clicode from vue_clicode_perimo v where v.bdclicode like '03%' or v.bdclicode like '10%' order by clicode;
             select distinct v.clicode, p_obligation from vue_clicode_perimo v   where regexp_like (v.bdclicode, p_filtre)
             -- AND v.clicode <> '11050'
              order by clicode;


END lister_clients_dbs;

PROCEDURE RECUPERER_PARAM_APP(p_code_action		IN	VARCHAR2,
                p_code_version		IN	VARCHAR2,
                p_num_ligne		IN	VARCHAR2,
                p_valeur		OUT	VARCHAR2,
                p_message		OUT VARCHAR2)
			IS
msg 		VARCHAR(1024);
l_chaine_dbs  VARCHAR2(100);
BEGIN
	SELECT  valeur into p_valeur
            FROM ligne_param_bip
            WHERE code_action = p_code_action
            AND   code_version = to_char(p_code_version)
            AND   num_ligne = (SELECT MIN (num_ligne) FROM ligne_param_bip
                                WHERE code_version = to_char(p_code_version)
                                AND   code_action = p_code_action
                                AND   actif = 'O'
                                   );

EXCEPTION
WHEN NO_DATA_FOUND THEN
Pack_Global.recuperer_message( 21284, '%s1', p_code_action, NULL, p_message);


END 	RECUPERER_PARAM_APP;

--FAD: Récupération du séparateur du paramètre applicatif
PROCEDURE RECUPERER_SEPAR_PARAM_APP(p_code_action		IN	VARCHAR2,
                p_code_version		IN	VARCHAR2,
                p_num_ligne		IN	VARCHAR2,
                p_valeur		OUT	VARCHAR2,
                p_message		OUT VARCHAR2)
			IS
msg 		VARCHAR(1024);
l_chaine_dbs  VARCHAR2(100);
BEGIN
	SELECT  SEPARATEUR into p_valeur
            FROM ligne_param_bip
            WHERE code_action = p_code_action
            AND   code_version = to_char(p_code_version)
            AND   num_ligne = (SELECT MIN (num_ligne) FROM ligne_param_bip
                                WHERE code_version = to_char(p_code_version)
                                AND   code_action = p_code_action
                                AND   actif = 'O'
                                   );

EXCEPTION
WHEN NO_DATA_FOUND THEN
Pack_Global.recuperer_message( 21284, '%s1', p_code_action, NULL, p_message);


END 	RECUPERER_SEPAR_PARAM_APP;

FUNCTION SPLIT (p_in_string VARCHAR2, p_delim VARCHAR2) RETURN t_array
IS

   i       number :=0;
   pos     number :=0;
   lv_str  varchar2(32767) := p_in_string;

strings t_array;

BEGIN

   -- determine first chuck of string
   pos := instr(lv_str,p_delim,1,1);

   IF(pos = 0) THEN
    lv_str:=lv_str||',';
    pos := instr(lv_str,p_delim,1,1);
   END IF;

   -- while there are chunks left, loop
   WHILE ( pos != 0) LOOP

      -- increment counter

      i := i + 1;


      -- create array element for chuck of string
      strings(i) := substr(lv_str,1,pos-1);

      -- remove chunk from string
      lv_str := substr(lv_str,pos+1,length(lv_str));

      -- determine next chunk
      pos := instr(lv_str,p_delim,1,1);

      -- no last chunk, add to array
      IF pos = 0 THEN

         strings(i+1) := lv_str;

      END IF;

   END LOOP;

   -- return array
   RETURN strings;

END SPLIT;

-- SEL 28/05/2014 PPM 58143 8.6
FUNCTION est_client_dbs(p_clicode VARCHAR2) RETURN boolean
IS

l_curseur_dbs LigneClientDBS_listeCurType;
l_message_dbs VARCHAR2(50);
l_userid VARCHAR2(50);
l_clicode vue_clicode_perimo.clicode%TYPE;
l_dbs_oblig VARCHAR2(50);
existe boolean:=false;


BEGIN


lister_clients_dbs (p_userid    => '',
              p_curseur => l_curseur_dbs,
              message => l_message_dbs
              );
l_dbs_oblig:= '';

LOOP

    FETCH l_curseur_dbs
    INTO  l_clicode, l_dbs_oblig;
    EXIT WHEN l_curseur_dbs%NOTFOUND;
    IF (p_clicode=l_clicode) THEN
    existe:=true;
    END IF;
  END LOOP;
  CLOSE l_curseur_dbs;


  --IF(existe) THEN DBMS_OUTPUT.PUT_LINE('TRUE '||l_clicode); ELSE DBMS_OUTPUT.PUT_LINE('FALSE '||l_clicode); END IF;

return existe;
END est_client_dbs;


--SEL PPM 60612
PROCEDURE SUPPRIMER_SR_SI_EXISTE( p_pid IN VARCHAR2,
                                  p_user_id IN VARCHAR2,
                                  p_message OUT VARCHAR2) IS


l_count number(5);

BEGIN


   select count(*) into l_count from isac_etape   where  pid = p_pid;

   IF (l_count > 0 ) THEN

    delete from isac_consomme where pid = p_pid;
    delete from isac_affectation where pid = p_pid;
    delete from isac_sous_tache where pid = p_pid;
    delete from isac_tache where pid = p_pid;
    delete from isac_etape where pid = p_pid;
    commit;

    -- DEBUT SEL PPM 60612 QC 1804 --> regul 63210 à livrer le 04/12/2015
    INSERT INTO LIGNE_BIP_LOGS
			(pid, date_log, user_log, colonne, valeur_prec, valeur_nouv, commentaire)
		VALUES
			(p_pid, CURRENT_TIMESTAMP, 'Réception .BIP', 'Toutes', '', '', 'Suppression structure Saisie des réalisée');
    -- FIN SEL PPM 60612 QC 1804 --> regul 63210
   END IF;

    EXCEPTION
    WHEN OTHERS THEN
    p_message := 'SUPPRIMER_SR_SI_EXISTE '||SQLERRM;



END SUPPRIMER_SR_SI_EXISTE;


--SEL PPM 60612
PROCEDURE IS_LIGNEBIP_A_SR( p_pid IN VARCHAR2,
                                  p_user_id IN VARCHAR2,
                                  p_message OUT VARCHAR2) IS

BEGIN
pack_remontee.check_StructSR (p_pid, p_message);
END IS_LIGNEBIP_A_SR;



 --HMI - PPM 60709 : $5.3 QC 1785
FUNCTION controle_parametrage(p_pid IN varchar2, p_direction IN varchar2)
      RETURN BOOLEAN
   IS
      l_presence   NUMBER;
      l_separateur varchar2(10);
   BEGIN
   BEGIN

  -- HMI QC 1834
   SELECT  SEPARATEUR
            INTO  l_separateur
            FROM ligne_param_bip
            WHERE code_action = 'TYPETAPES-JEUX-T'
            AND code_version = p_direction
             AND num_ligne = (SELECT MIN (num_ligne)
                                  FROM ligne_param_bip
                                 WHERE code_version = p_direction AND code_action = 'TYPETAPES-JEUX-T' AND actif = 'O');


      BEGIN
         SELECT count(*)
         into l_presence
            FROM ligne_param_bip
            WHERE code_action = 'TYPETAPES-JEUX-T'
            AND code_version = p_direction
             AND num_ligne = (SELECT MIN (num_ligne)
                                  FROM ligne_param_bip
                                 WHERE code_version = p_direction AND code_action = 'TYPETAPES-JEUX-T' AND actif = 'O')
                                 and PACK_ISAC_ETAPE.verifTypologie(p_pid,valeur,l_separateur)= 'valide';



         IF (l_presence != 0)
         THEN
         DBMS_OUTPUT.PUT_LINE(' RETURN TRUE1');
            RETURN TRUE;
         ELSE
          DBMS_OUTPUT.PUT_LINE(' RETURN FALSE1');
            RETURN FALSE;
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
          DBMS_OUTPUT.PUT_LINE(' RETURN FALSE2');
            RETURN FALSE;
      END;

      EXCEPTION
         WHEN OTHERS
         THEN
          DBMS_OUTPUT.PUT_LINE(' RETURN FALSE3');
            RETURN FALSE;
      END ;
       -- FIN HMI QC 1834
   END controle_parametrage;

--KRA PPM 62325
FUNCTION demande_ligne_bip(
            P_PERIME IN VARCHAR2) RETURN NUMBER IS
CURSOR curseur
IS
select DISTINCT LB.PID, LB.ICPI from ligne_bip LB, datdebex D
        where (LB.adatestatut IS NULL OR LB.adatestatut >= D.datdebex)
             AND (LB.codsg IN (SELECT codsg FROM vue_dpg_perime where INSTR(NVL(P_PERIME, '00000000000'), codbddpg) > 0 ));

l_numseq number;
l_nbre NUMBER;
BEGIN
  --génération d'un numéro de process
  SELECT BIP.SETATKE.NEXTVAL INTO l_numseq FROM DUAL ;

  --Boucle sur les PID actifs
  FOR ligne IN curseur
  LOOP
    l_nbre :=0;
    --Insertion dans la table TMP des PID et
    INSERT INTO tmp_conso_dmp (
	  --FAD PPM 64056 : Annulation de la joiture avec DMP_RESEAUXFRANCE
	  SELECT LB.PID, DPC.DPCOPIAXEMETIER, 0, 0, 0, l_numseq
      FROM LIGNE_BIP LB, DOSSIER_PROJET_COPI DPC, PROJ_INFO PI
      WHERE LB.ICPI = PI.ICPI
      AND PI.DP_COPI = DPC.DP_COPI
      AND DPC.DPCOPIAXEMETIER IS NOT NULL
      AND LB.PID = ligne.PID);
	  --FAD PPM 64056 : Fin

    SELECT COUNT(*) INTO l_nbre FROM tmp_conso_dmp WHERE PID = ligne.PID AND l_numseq = numseq;

    if(l_nbre = 0) then
      INSERT INTO tmp_conso_dmp (
		--FAD PPM 64056 : Annulation de la joiture avec DMP_RESEAUXFRANCE
		SELECT LB.PID, PI.PROJAXEMETIER, 0, 0, 0, l_numseq
        FROM LIGNE_BIP LB, PROJ_INFO PI
        WHERE LB.ICPI = PI.ICPI
        AND PI.PROJAXEMETIER IS NOT NULL
        AND ROWNUM = 1
        AND LB.PID = ligne.PID);
		--FAD PPM 64056 : Fin

      SELECT COUNT(*) INTO l_nbre FROM tmp_conso_dmp WHERE PID = ligne.PID AND l_numseq = numseq;

      if(l_nbre = 0) then
        INSERT INTO tmp_conso_dmp (
		  --FAD PPM 64056 : Annulation de la joiture avec DMP_RESEAUXFRANCE
		  SELECT PID, DMPNUM, SUM(CONSOAA) CONSOAA, SUM(CONSOEURAA) / 1000 CONSOEURAA, SUM(CONSOMM) CONSOMM, l_numseq
          FROM (
            SELECT DISTINCT
              ISAC_TACHE.FACTPID PID,
              ISAC_TACHE.TACHEAXEMETIER DMPNUM,
              NVL(CONSOAA.CONSOJH, 0) CONSOAA,
              NVL(CONSOEURAA.CONSOKE, 0) CONSOEURAA,
              NVL(CONSOMM.CONSOJH, 0) CONSOMM
            FROM ISAC_ETAPE
            JOIN 
			( SELECT  Decode(substr(stt.AIST,1,2),'FF',substr(stt.AIST,3),stt.PID) FACTPID,tache.PID,tache.TACHEAXEMETIER,tache.ETAPE,tache.ACTA
              from isac_tache tache,isac_sous_tache stt
		      where tache.pid=stt.pid 
		      AND tache.ETAPE=stt.ETAPE 
		      AND tache.TACHE=stt.TACHE ) ISAC_TACHE ON ISAC_ETAPE.PID = ISAC_TACHE.PID AND ISAC_ETAPE.ETAPE = ISAC_TACHE.ETAPE
            LEFT JOIN
			-- FAD PPM Corr 64486 : CONSOAA se calcule à partir de CONS_SSTACHE_RES_MOIS
			-- FAD PPM Corr 64713 Ano 1 : Remplacer TACHE.PID par DECODE(TACHE.AISTTY, 'FF', TACHE.AISTPID, TACHE.PID)
            (
              SELECT DECODE(TACHE.AISTTY, 'FF', TACHE.AISTPID, TACHE.PID) PID, TACHE.ECET, TACHE.ACTA, TACHEAXEMETIER, SUM(CUSAG) CONSOJH
              FROM TACHE
              LEFT JOIN CONS_SSTACHE_RES_MOIS ON CONS_SSTACHE_RES_MOIS.PID = TACHE.PID AND  CONS_SSTACHE_RES_MOIS.ECET = TACHE.ECET AND CONS_SSTACHE_RES_MOIS.ACTA = TACHE.ACTA AND CONS_SSTACHE_RES_MOIS.ACST = TACHE.ACST
              WHERE CDEB BETWEEN (SELECT DATDEBEX FROM DATDEBEX) AND (SELECT MOISMENS FROM DATDEBEX) GROUP BY DECODE(TACHE.AISTTY, 'FF', TACHE.AISTPID, TACHE.PID), TACHE.ECET, TACHE.ACTA, TACHEAXEMETIER
            ) CONSOAA ON CONSOAA.PID = ISAC_TACHE.FACTPID AND CONSOAA.ECET = ISAC_ETAPE.ECET AND CONSOAA.ACTA = ISAC_TACHE.ACTA AND CONSOAA.TACHEAXEMETIER = ISAC_TACHE.TACHEAXEMETIER
			-- FAD PPM Corr 64486 : Fin
			LEFT JOIN
			-- FAD PPM Corr 64486 : CONSOEURAA se calcule à partir de STOCK_RA
			-- FAD PPM Corr 64713 Ano 1 : Remplacer TACHE.PID par DECODE(TACHE.AISTTY, 'FF', TACHE.AISTPID, TACHE.PID)
            (
              SELECT DECODE(TACHE.AISTTY, 'FF', TACHE.AISTPID, TACHE.PID) PID, TACHE.ECET, TACHE.ACTA, TACHEAXEMETIER, SUM(CONSOFT + CONSOENV) CONSOKE
              FROM TACHE
              LEFT JOIN STOCK_RA ON STOCK_RA.PID = TACHE.PID AND STOCK_RA.FACTPID = DECODE(TACHE.AISTTY, 'FF', TACHE.AISTPID, TACHE.PID) AND STOCK_RA.ECET = TACHE.ECET AND STOCK_RA.ACTA = TACHE.ACTA AND STOCK_RA.ACST = TACHE.ACST
              WHERE CDEB BETWEEN (SELECT DATDEBEX FROM DATDEBEX) AND (SELECT MOISMENS FROM DATDEBEX) GROUP BY DECODE(TACHE.AISTTY, 'FF', TACHE.AISTPID, TACHE.PID), TACHE.ECET, TACHE.ACTA, TACHEAXEMETIER
            ) CONSOEURAA ON CONSOEURAA.PID = ISAC_TACHE.FACTPID AND CONSOEURAA.ECET = ISAC_ETAPE.ECET AND CONSOEURAA.ACTA = ISAC_TACHE.ACTA AND CONSOEURAA.TACHEAXEMETIER = ISAC_TACHE.TACHEAXEMETIER
			-- FAD PPM Corr 64486 : Fin
            LEFT JOIN
			-- FAD PPM Corr 64486 : CONSOMM se calcule à partir de CONS_SSTACHE_RES_MOIS
			-- FAD PPM Corr 64713 Ano 1 : Remplacer TACHE.PID par DECODE(TACHE.AISTTY, 'FF', TACHE.AISTPID, TACHE.PID)
            (
              SELECT DECODE(TACHE.AISTTY, 'FF', TACHE.AISTPID, TACHE.PID) PID, TACHE.ECET, TACHE.ACTA, TACHEAXEMETIER, SUM(CUSAG) CONSOJH
              FROM TACHE
              LEFT JOIN CONS_SSTACHE_RES_MOIS ON CONS_SSTACHE_RES_MOIS.PID = TACHE.PID AND  CONS_SSTACHE_RES_MOIS.ECET = TACHE.ECET AND CONS_SSTACHE_RES_MOIS.ACTA = TACHE.ACTA AND CONS_SSTACHE_RES_MOIS.ACST = TACHE.ACST
              WHERE TO_CHAR(CDEB, 'MM/YYYY') = TO_CHAR((SELECT MOISMENS FROM DATDEBEX), 'MM/YYYY') GROUP BY DECODE(TACHE.AISTTY, 'FF', TACHE.AISTPID, TACHE.PID), TACHE.ECET, TACHE.ACTA, TACHEAXEMETIER
            ) CONSOMM ON CONSOMM.PID = ISAC_TACHE.FACTPID AND CONSOMM.ECET = ISAC_ETAPE.ECET AND CONSOMM.ACTA = ISAC_TACHE.ACTA AND CONSOMM.TACHEAXEMETIER = ISAC_TACHE.TACHEAXEMETIER
			-- -- FAD PPM Corr 64486 : Fin
            WHERE ISAC_TACHE.FACTPID = ligne.PID AND ISAC_TACHE.TACHEAXEMETIER IS NOT NULL
          )
          GROUP BY PID, DMPNUM
		  --FAD PPM 64056 : Fin
		  );
        end if;
      end if;
    END LOOP;
  RETURN l_numseq;
END demande_ligne_bip;


--------------------------------------------------------------------------------
--ZAA PPM 62325 F7
--------------------------------------------------------------------------------
FUNCTION RecupDmpNonUtilisee RETURN NUMBER is
countDmpDpcopi integer;
countDmpProj integer;
countDpcopi integer;
countproj integer;
countDmptache integer;
l_numseq number;
BEGIN
 SELECT BIP.SETATKE.NEXTVAL INTO l_numseq FROM DUAL ;

FOR dmp IN(SELECT * FROM DMP_RESEAUXFRANCE WHERE DDETYPE IN ('C', 'E', 'P'))
LOOP

IF(dmp.DDETYPE = 'P') THEN
      SELECT COUNT(*) INTO countDmpDpcopi
      FROM DOSSIER_PROJET_COPI dpcopi
      WHERE TRIM(dpcopi.DPCOPIAXEMETIER) = TRIM(dmp.DMPNUM);
      IF(countDmpDpcopi > 0) THEN
            SELECT COUNT(*) INTO countDpcopi
            FROM DOSSIER_PROJET_COPI dpcopi, PROJ_INFO pi, LIGNE_BIP lb
            WHERE TRIM(dpcopi.DPCOPIAXEMETIER) = TRIM(dmp.DMPNUM)
              AND dpcopi.DP_COPI = pi.DP_COPI
              AND pi.ICPI = lb.ICPI;

              IF( countdpcopi = 0) THEN

                INSERT INTO TMP_DMP_NONUTILISEE(RefDemande,DdeType,DPCOPI,Projet,numseq)
                VALUES( dmp.DMPNUM,'P',dmp.DPCOPICODE, NULL,l_numseq);
              END IF;
      ELSE

              SELECT COUNT(*) INTO countDmpProj
              FROM PROJ_INFO pi
              WHERE TRIM(pi.PROJAXEMETIER) = TRIM(dmp.DMPNUM);

              IF(countDmpProj > 0) THEN

                SELECT COUNT(*) INTO countProj
                FROM PROJ_INFO pi, LIGNE_BIP lb
                WHERE TRIM(pi.PROJAXEMETIER) = TRIM(dmp.DMPNUM)
                AND pi.ICPI = lb.ICPI;

                    IF( countProj = 0) THEN
                        INSERT INTO TMP_DMP_NONUTILISEE(RefDemande,DdeType,DPCOPI,Projet,numseq)
                        VALUES( dmp.DMPNUM,'P',NULL, dmp.PROJCODE,l_numseq);

                    END IF;
           ELSE

           INSERT INTO TMP_DMP_NONUTILISEE(RefDemande,DdeType,DPCOPI,Projet,numseq)
                 VALUES( dmp.DMPNUM,'P',NULL, NULL,l_numseq);

          END IF;
      END IF;
END IF;
IF(dmp.DDETYPE = 'E') THEN
  SELECT COUNT(*) INTO countDmpProj
              FROM PROJ_INFO pi
              WHERE TRIM(pi.PROJAXEMETIER) = TRIM(dmp.DMPNUM);

              IF(countDmpProj > 0) THEN

                SELECT COUNT(*) INTO countProj
                FROM PROJ_INFO pi, LIGNE_BIP lb
                WHERE TRIM(pi.PROJAXEMETIER) = TRIM(dmp.DMPNUM)
                AND pi.ICPI = lb.ICPI;

                    IF( countProj = 0) THEN
                        INSERT INTO TMP_DMP_NONUTILISEE(RefDemande,DdeType,DPCOPI,Projet,numseq)
                        VALUES( dmp.DMPNUM,'E',NULL, dmp.PROJCODE,l_numseq);

                    END IF;
           ELSE

             INSERT INTO TMP_DMP_NONUTILISEE(RefDemande,DdeType,DPCOPI,Projet,numseq)
                 VALUES( dmp.DMPNUM,'E',NULL, NULL,l_numseq);

          END IF;
      END IF;

IF(dmp.DDETYPE = 'C') THEN

  SELECT COUNT(*) INTO countDmptache
  FROM ISAC_ETAPE ie, ISAC_TACHE it
  WHERE ie.ETAPE = it.ETAPE
  AND TRIM(dmp.DMPNUM) = TRIM(it.TACHEAXEMETIER);

  IF(countDmptache  = 0) THEN
  INSERT INTO TMP_DMP_NONUTILISEE(RefDemande,DdeType,DPCOPI,Projet,numseq)
                 VALUES( dmp.DMPNUM,'C',NULL, NULL,l_numseq);

  END IF;

END IF;
END LOOP;
RETURN l_numseq;
END RecupDmpNonUtilisee;
-- FIN : ZAA PPM 62325 F7

--Debut FAD PPM 64269 : Régul PPM 63824 : HMI
--
 FUNCTION verif_RBDF_param_reglage(p_icpi IN PROJ_INFO.icpi%TYPE,
									p_clicode IN PROJ_INFO.CLICODE%TYPE,
									p_codsg IN  VARCHAR2,
									p_pid IN LIGNE_BIP.pid%TYPE
									) RETURN VARCHAR2 IS

	l_code_action LIGNE_PARAM_BIP.CODE_ACTION%TYPE;
	l_obligatoire LIGNE_PARAM_BIP.OBLIGATOIRE%TYPE;
	l_direction CLIENT_MO.CLIDIR%TYPE;
	l_valeur VARCHAR2(20);
	l_bbrf_clicode VARCHAR2(3);
	l_bbrf_dpg VARCHAR2(3);
	l_nbre_param_local number(3);
	l_retour VARCHAR(1000) ;
	P_TYPROJ LIGNE_BIP.TYPPROJ%TYPE;
	p_arctype LIGNE_BIP.ARCTYPE%TYPE;
	sumCons NUMBER;
BEGIN
	l_retour  := 'valide';

	IF (INSTR('P0000,P9000,P9999,P9990,P9995,P9997',p_icpi)>0)
	then
		l_retour  := 'valide';
	ELSE
		select typproj, arctype into p_typroj, p_arctype from LIGNE_BIP where PID = p_pid;
		-- FAD PPM 64770 : Ajout du contrôle de consomme en centrale pour la ligne bip en cours
		-- FAD PPM 64770 QC 1951 : Utilisation de la table CONSOMME à la place CONS_SSTACHE_RES_MOIS
		select NVL(SUM(CUSAG), 0) INTO sumCons from CONSOMME, DATDEBEX D where pid = p_pid and ANNEE <= TO_NUMBER(TO_CHAR(D.DATDEBEX, 'YYYY'));
		-- FAD PPM 64770 QC 1951 : Fin
		IF (TRIM(P_ARCTYPE) = 'T1' AND TRIM(P_TYPROJ) = '1' AND sumCons > 0)
		-- FAD PPM 64770 : Fin
		THEN
			BEGIN
				select CODDIR into l_direction from STRUCT_INFO where CODSG = p_codsg  ;

				select code_action, obligatoire, substr(valeur,1,2)
				into l_code_action, l_obligatoire, l_valeur
				from ligne_param_bip
				where code_action = 'DIR-REGLAGES'
				and code_version = l_direction
				and actif = 'O';
			EXCEPTION
			WHEN NO_DATA_FOUND
			THEN
				BEGIN
					select clidir into l_direction from client_mo where clicode = p_clicode;

					select code_action, obligatoire, substr(valeur,1,2)
					into l_code_action, l_obligatoire, l_valeur
					from ligne_param_bip
					where code_action = 'DIR-REGLAGES'
					and code_version = l_direction
					and actif = 'O';
				EXCEPTION
				WHEN NO_DATA_FOUND
				THEN
					BEGIN
						select substr(CODBDDPG,1,2) into l_bbrf_dpg From vue_dpg_perime WHERE codsg = p_codsg and codhabili = 'br';
					EXCEPTION
					WHEN NO_DATA_FOUND THEN
						l_bbrf_clicode := null;
					END;

					BEGIN
						select substr(bdclicode,1,2) into l_bbrf_clicode from vue_clicode_perimo where clicode = p_clicode and codhabili = 'br';
					EXCEPTION
					WHEN NO_DATA_FOUND THEN
						l_bbrf_dpg := null;
					END;
				END;
			END;
		END IF;

		IF(l_valeur like '03' or l_bbrf_clicode like '03' or l_bbrf_dpg like '03')
		Then
			l_retour  := 'invalide';
		END IF;
		dbms_output.put_line(l_valeur);
	END IF;
	return l_retour;
END verif_RBDF_param_reglage;

--

-- FAD PPM 64770 : Ajout du PID dans les paramètres de cette fonction pour vérifier le consomme et le type de la ligne BIP
FUNCTION verif_RBDF_DirPrin(p_icpi  IN  PROJ_INFO.icpi%TYPE,
                              p_dpcode        IN  NUMBER,
							  p_pid IN LIGNE_BIP.pid%TYPE ) RETURN VARCHAR2 IS
-- FAD PPM 64770 : Fin
	l_valeur LIGNE_PARAM_BIP.VALEUR%TYPE;
	l_bbrf VARCHAR2(1000);
	l_DIRPRIN VARCHAR2(1000);
	l_bbrf_dpg VARCHAR2(1000);
	l_valeur_cli VARCHAR2(1000);
	l_valeur_dpg VARCHAR2(1000);
	l_param_local LIGNE_BIP.PZONE%TYPE;
	l_direction CLIENT_MO.CLIDIR%TYPE;
	l_retour VARCHAR(1000) ;
	l_message VARCHAR(1000);
	l_dir				VARCHAR2(10);
	l_CODBR Number;
	sumCons NUMBER;
	P_TYPROJ LIGNE_BIP.TYPPROJ%type; 
	p_arctype LIGNE_BIP.ARCTYPE%TYPE;
     
BEGIN
	l_retour  := 'valide';

	IF (INSTR('P0000,P9000,P9999,P9990,P9995,P9997',p_icpi)>0) then
		DBMS_OUTPUT.PUT_LINE('HERE0');
		l_retour  := 'valide';
	ELSE
		select typproj, arctype into p_typroj, p_arctype from LIGNE_BIP where PID = p_pid;
		-- FAD PPM 64770 : Ajout du contrôle de consomme en centrale pour la ligne bip en cours
		-- FAD PPM 64770 QC 1951 : Utilisation de la table CONSOMME à la place CONS_SSTACHE_RES_MOIS
		select NVL(SUM(CUSAG), 0) INTO sumCons from CONSOMME, DATDEBEX D where pid = p_pid and ANNEE <= TO_NUMBER(TO_CHAR(D.DATDEBEX, 'YYYY'));
		-- FAD PPM 64770 QC 1951 : Fin
		IF (TRIM(P_ARCTYPE) = 'T1' AND TRIM(P_TYPROJ) = '1' AND sumCons > 0)
		THEN
		-- FAD PPM 64770 : Fin

			select DIRPRIN into l_DIRPRIN from DOSSIER_PROJET where DPCODE = p_dpcode;

			IF l_DIRPRIN is null then
				l_retour  := 'valide';
			ELSE
				BEGIN
					select substr(valeur,1,2)  into l_valeur
					from ligne_param_bip
					where code_action = 'DIR-REGLAGES' and  TO_NUMBER(code_version, '999') = l_DIRPRIN and upper(actif) = 'O';
				EXCEPTION
				WHEN NO_DATA_FOUND THEN
					BEGIN
						select CODBR into l_CODBR from DIRECTIONS where CODDIR = l_DIRPRIN;
					EXCEPTION
					WHEN NO_DATA_FOUND THEN
						l_valeur := null;
					END;
				END ;

				IF(l_valeur = '03' or l_CODBR = 3) then
					l_retour  := 'invalide';
				END IF;
			END IF;
		END IF;
	END IF;








	return l_retour;
END verif_RBDF_DirPrin;

PROCEDURE VERIFIER_MAJ_DP_Proj ( p_pid      IN  VARCHAR2,
                                 p_dpcode        IN  NUMBER,
                                 p_icpi  IN  PROJ_INFO.icpi%TYPE,
                                 p_clicode   IN  PROJ_INFO.CLICODE%TYPE,
                                 p_codsg         IN  VARCHAR2,
                                 p_message OUT VARCHAR2,
                                 p_codeproj OUT PROJ_INFO.icpi%TYPE
                                 ) IS













	l_retour1 VARCHAR(1000) ;
	l_retour2 VARCHAR(1000);


BEGIN
	p_message := '';


	l_retour1 := verif_RBDF_param_reglage(p_icpi,p_clicode,p_codsg, p_pid);
	-- FAD PPM 64770 : Ajout du PID dans les paramètres de cette fonction pour vérifier le consomme et le type de la ligne BIP
	l_retour2 := verif_RBDF_DirPrin(p_icpi,p_dpcode, p_pid);
	-- FAD PPM 64770 : Fin

	IF (l_retour1 = 'invalide') then
		pack_global.recuperer_message (21308, NULL, NULL, NULL, p_message);
	ELSE
		IF (l_retour2 = 'invalide') then
			pack_global.recuperer_message (21309, NULL, NULL, NULL, p_message);
		END IF;
	END IF;
END VERIFIER_MAJ_DP_Proj;

--Fin FAD PPM 64269 : Régul PPM 63824 : HMI
-- FAD PPM 64240 : Régul SEL PPM 63412 : ???
PROCEDURE isClientBBRF03(p_clicode in varchar2, p_retour out number)
IS
BEGIN
	select 1 into p_retour from ligne_param_bip where
	code_version like (select clidir from client_mo where clicode like p_clicode)
	and code_action='DIR-REGLAGES'
	and substr(valeur,1,2) like '03';
EXCEPTION
	WHEN NO_DATA_FOUND THEN
	p_retour := 0;
END isClientBBRF03;

-- FAD PPM 64240 : Lister les DPCOPI à partir du DP
PROCEDURE lister_dpcopi_par_dp (p_userid IN VARCHAR2,
								p_dpcode VARCHAR2,
								p_dpcopiCurType IN OUT pack_copi_budget.dpcopiCurType
								) IS
	l_msg VARCHAR(1024);
	l_requete VARCHAR2(32767);
	l_requeteDpcopde VARCHAR2(32767) := '';

BEGIN
	BEGIN
		IF(p_dpcode is null or trim(p_dpcode) like '' or trim(p_dpcode) = '')
		THEN
			OPEN p_dpcopiCurType FOR
				SELECT
					' ' code,
					' ' LIBELLE
				FROM DUAL

				UNION

				SELECT
					'0' code,
					'***Hors DPCOPI***' LIBELLE
				FROM DUAL

				UNION

				SELECT DISTINCT
					TO_CHAR(DP_COPI) code,
					DP_COPI || ' - ' || LIBELLE
				FROM DOSSIER_PROJET_COPI
				ORDER BY code;
		ELSE
			OPEN p_dpcopiCurType FOR
				SELECT
					' ' code,
					' ' LIBELLE
				FROM DUAL

				UNION

				SELECT
					'0' code,
					'***Hors DPCOPI***' LIBELLE
				FROM DUAL

				UNION

				SELECT DISTINCT
					TO_CHAR(DP_COPI) code,
					DP_COPI || ' - ' || LIBELLE
				FROM DOSSIER_PROJET_COPI
				WHERE DPCODE = TO_NUMBER(p_dpcode)
				ORDER BY  code;
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			RAISE_APPLICATION_ERROR( -20997, SQLERRM );
	END;
      
END lister_dpcopi_par_dp;


/**************************************************************************/
/**************************************************************************/
-- FAD PPM 64240 : Lister les projet à partir du DPCOPI
PROCEDURE lister_projet(p_userid IN VARCHAR2,
						p_dpcode IN VARCHAR2,
						p_dpcopicode IN VARCHAR2,
						p_curseur IN OUT pack_liste_proj_info.lib_listeCurType
						) IS
P_ICPI CHAR(5);
P_ILIBEL VARCHAR2(58);
BEGIN

	IF (p_dpcode IS NULL)
	THEN
		OPEN p_curseur FOR
			SELECT
				' ' icpi,
				'' LIB
			FROM dual;
	ELSE
		IF (p_dpcopicode IS NULL OR p_dpcopicode = ' ')
		THEN
			OPEN p_curseur FOR
				SELECT
					' ' icpi,
					'' LIB
				FROM dual;
		ELSE
			IF (p_dpcopicode = '0')
			THEN
				IF TO_NUMBER(p_dpcode) = 70000
				THEN
					OPEN p_curseur FOR
						-- La première ligne est vide
						SELECT
							'' icpi,
							' ' LIB
						FROM dual

						UNION

						SELECT DISTINCT
							pi.icpi,
							'DP ' || TO_CHAR(pi.icodproj, 'FM00000') ||' - ' || pi.icpi ||' - ' || ltrim(rtrim(pi.ilibel))  LIB
						FROM
							proj_info pi,
							dossier_projet dp
						WHERE dp.dpcode = pi.icodproj
							AND (pi.statut IS NULL OR pi.statut='O' OR pi.statut='N')
							AND dp.actif = 'O'
							AND dp.dpcode != 0
						ORDER BY LIB;
					-- Sinon on renvoie la liste des projets actifs pour le dossier projet
				ELSE
					BEGIN
						SELECT ICPI, ICPI ||' - ' || LTRIM(RTRIM(ILIBEL))
						INTO P_ICPI, P_ILIBEL
						FROM PROJ_INFO
						WHERE DP_COPI NOT IN (SELECT DISTINCT TO_CHAR(DP_COPI) FROM DOSSIER_PROJET_COPI WHERE DPCODE = TO_NUMBER(P_DPCODE))
						AND ICODPROJ = TO_NUMBER(P_DPCODE)
						AND (STATUT IS NULL OR STATUT = 'O' OR STATUT = 'N');

						OPEN p_curseur FOR
							SELECT
								P_ICPI icpi,
								P_ILIBEL LIB
							FROM dual;

					EXCEPTION
					WHEN NO_DATA_FOUND THEN
						OPEN p_curseur FOR
							SELECT
								' ' icpi,
								' ' LIB
							FROM dual;
					WHEN TOO_MANY_ROWS THEN
						OPEN p_curseur FOR
							SELECT
								' ' icpi,
								' ' LIB
							FROM dual
							UNION
							SELECT
								ICPI,
								ICPI ||' - ' || LTRIM(RTRIM(ILIBEL)) LIB
							FROM PROJ_INFO
							WHERE DP_COPI NOT IN (SELECT DISTINCT TO_CHAR(DP_COPI) FROM DOSSIER_PROJET_COPI WHERE DPCODE = TO_NUMBER(P_DPCODE))
							AND ICODPROJ = TO_NUMBER(P_DPCODE)
							AND (STATUT IS NULL OR STATUT = 'O' OR STATUT = 'N')
							ORDER BY ICPI;
					END;
				END IF;
			ELSE
				BEGIN
					SELECT ICPI, ICPI ||' - ' || LTRIM(RTRIM(ILIBEL))
					INTO P_ICPI, P_ILIBEL
					FROM PROJ_INFO
					WHERE DP_COPI  = p_dpcopicode
					AND (STATUT IS NULL OR STATUT = 'O' OR STATUT = 'N');

					OPEN p_curseur FOR
						SELECT
							P_ICPI icpi,
							P_ILIBEL LIB
						FROM dual;

				EXCEPTION
				WHEN NO_DATA_FOUND THEN
					OPEN p_curseur FOR
						SELECT
							' ' icpi,
							' ' LIB
						FROM dual;
				WHEN TOO_MANY_ROWS THEN
					OPEN p_curseur FOR
						SELECT
							' ' icpi,
							' ' LIB
						FROM dual
						UNION
						SELECT
							ICPI,
							ICPI ||' - ' || LTRIM(RTRIM(ILIBEL)) LIB
						FROM PROJ_INFO
						WHERE DP_COPI  = p_dpcopicode
						AND (STATUT IS NULL OR STATUT = 'O' OR STATUT = 'N')
						ORDER BY ICPI;
				END;
			END IF;
		END IF;
	END IF;
EXCEPTION WHEN OTHERS THEN
	raise_application_error(-20997, SQLERRM);
END lister_projet;

/**************************************************************************/
/**************************************************************************/
-- FAD PPM 64240 : Régul SEL PPM 63412 : ???
PROCEDURE recup_dpcopi(p_projet in VARCHAR2,p_dpcopi out VARCHAR2) IS

BEGIN

select DISTINCT dp_copi into p_dpcopi from proj_info where icpi like p_projet AND ROWNUM=1;

EXCEPTION 
WHEN NO_DATA_FOUND THEN

p_dpcopi := '';



END recup_dpcopi;

-- FAD PPM 64240 : Récupération du DPCOPI à partir du PID
PROCEDURE SELECT_DPCOPI_PID(P_PID IN VARCHAR2, P_DPCOPI OUT VARCHAR2) IS
	P_DP LIGNE_BIP.DPCODE%TYPE;
BEGIN
	BEGIN
		SELECT DPCODE INTO P_DP
	FROM
		LIGNE_BIP
	WHERE
		PID = P_PID;
	EXCEPTION
	WHEN NO_DATA_FOUND THEN
		P_DP := NULL;
	END;

	IF P_DP = 70000
	THEN
		P_DPCOPI := '0';
	ELSE
		BEGIN
			SELECT
				DISTINCT NVL(PI.DP_COPI, '0') INTO P_DPCOPI
			FROM
				PROJ_INFO PI,
				LIGNE_BIP LB
			WHERE
				LB.ICPI = PI.ICPI
				AND LB.PID = P_PID
				AND ROWNUM = 1;

		EXCEPTION
		WHEN NO_DATA_FOUND THEN
			P_DPCOPI := '0';
		END;
	END IF;
END SELECT_DPCOPI_PID;

END Pack_Ligne_Bip;
/