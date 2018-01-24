-- pack_forum PL/SQL 

--

-- JMA 

-- Créé le 06/06/2006 

-- 

--****************************************************************************

--

--

CREATE OR REPLACE PACKAGE BIP.pack_forum AS



    -- Définition curseur sur la table message_forum 



    TYPE forum_ViewType IS RECORD ( ID  	          MESSAGE_FORUM.ID%TYPE,

						  	 		PARENT_ID         MESSAGE_FORUM.PARENT_ID%TYPE,

									AUTEUR         	  VARCHAR2(60),

									MENU              MESSAGE_FORUM.MENU%TYPE,

									DATE_MSG          MESSAGE_FORUM.DATE_MSG%TYPE,

									TITRE	          MESSAGE_FORUM.TITRE%TYPE,

									TYPE_MSG          MESSAGE_FORUM.TYPE_MSG%TYPE,

                                    STATUT	          MESSAGE_FORUM.STATUT%TYPE,

                                    DATE_STATUT       MESSAGE_FORUM.DATE_STATUT%TYPE,

                                    MSG_IMPORTANT     MESSAGE_FORUM.MSG_IMPORTANT%TYPE,

                                    TEXTE	          MESSAGE_FORUM.TEXTE%TYPE,

                                    TEXTE_MODIFIE     MESSAGE_FORUM.TEXTE_MODIFIE%TYPE,

                                    MOTIF_REJET       MESSAGE_FORUM.MOTIF_REJET%TYPE,

                                    DATE_AFFICHAGE    MESSAGE_FORUM.DATE_AFFICHAGE%TYPE,

                                    DATE_MODIFICATION MESSAGE_FORUM.DATE_MODIFICATION%TYPE,

									USER_RTFE         MESSAGE_FORUM.USER_RTFE%TYPE,

                                    NB_REPONSE		  NUMBER(5),

                                    DATE_DERN_MODIF   VARCHAR2(20)

                                  );





    TYPE forumCurType_Char IS REF CURSOR RETURN forum_ViewType;





    PROCEDURE select_liste ( p_userid	 IN VARCHAR2,

   			 			  	 p_menu      IN VARCHAR2,

		 			  	 	 p_parentid  IN NUMBER,

							 p_tri       IN VARCHAR2,

   			 			  	 p_listeMenu IN VARCHAR2,

   			 			  	 p_txtRecher IN VARCHAR2,

   			 			  	 p_curstat 	 IN OUT forumCurType_Char ,

                             p_nbcurseur    OUT INTEGER,

                             p_message      OUT VARCHAR2

                           );





	FUNCTION getNbReponse (p_id IN NUMBER) RETURN NUMBER;



	FUNCTION getLastDateMsg (p_id IN NUMBER) RETURN DATE;



	

	PROCEDURE insert_message ( p_userid	       IN VARCHAR2,

		 			  	 	   p_id 	   	   IN NUMBER,

		 			  	 	   p_parentid 	   IN NUMBER,

   			 			  	   p_menu     	   IN VARCHAR2,

							   p_titre    	   IN VARCHAR2,

   			 			  	   p_type_msg 	   IN VARCHAR2,

							   p_texte    	   IN VARCHAR2,

   			 			  	   p_msg_important IN VARCHAR2,

   			 			  	   p_listeMenu 	   IN VARCHAR2,

   			 			  	   p_statut		   IN VARCHAR2,

                               p_nbcurseur        OUT INTEGER,

                               p_message     	  OUT VARCHAR2

                             );



							 

    PROCEDURE insertTemp( p_id IN NUMBER, 

					 	  p_user IN VARCHAR2);





	FUNCTION listIdFils( p_id IN NUMBER ) RETURN VARCHAR2;





	PROCEDURE VALIDATION_REJET ( p_userid	 IN VARCHAR2,

		 			  	 	   	 p_id 	     IN NUMBER,

   			 			  	   	 p_statut    IN VARCHAR2,

							   	 p_motif     IN VARCHAR2,

                               	 p_nbcurseur    OUT INTEGER,

                               	 p_message      OUT VARCHAR2

                               );



							   

    PROCEDURE select_message ( p_userid	   IN VARCHAR2,

		 			  	 	   p_id        IN NUMBER,

   			 			  	   p_curstat   IN OUT forumCurType_Char ,

                               p_nbcurseur    OUT INTEGER,

                               p_message      OUT VARCHAR2

                             );



    PROCEDURE DELETE_MESSAGE ( p_userid	 IN VARCHAR2,

		 			  	   	   p_id 	     IN NUMBER,

                           	   p_nbcurseur    OUT INTEGER,

                           	   p_message      OUT VARCHAR2

							 );



	FUNCTION findIdSujet( p_id IN NUMBER ) RETURN NUMBER;

	



    PROCEDURE RECHERCHE_AVANCEE ( p_userid	     IN VARCHAR2,

   			 			  	 	  p_menu      	 IN VARCHAR2,

   			 			  	 	  p_listeMenu 	 IN VARCHAR2,

							 	  p_mot_cle   	 IN VARCHAR2,

   			 			  	 	  p_chercheTitre IN VARCHAR2,

   			 			  	 	  p_chercheTexte IN VARCHAR2,

   			 			  	 	  p_auteur 		 IN VARCHAR2,

   			 			  	 	  p_date_debut 	 IN VARCHAR2,

   			 			  	 	  p_date_fin 	 IN VARCHAR2,

   			 			  	 	  p_curstat   	 IN OUT forumCurType_Char ,

                             	  p_nbcurseur       OUT INTEGER,

                             	  p_message         OUT VARCHAR2

                                );



END pack_forum;

/





CREATE OR REPLACE PACKAGE BODY BIP.pack_forum AS





/***************************************************************************************/

/*                                                                                     */

/*               SELECTION LISTE DES MESSAGES DU FORUM POUR UN UTILISATEUR ET UN MENU  */

/*                                                                                     */

/***************************************************************************************/

PROCEDURE select_liste ( p_userid	 IN VARCHAR2,

		 			  	 p_menu      IN VARCHAR2,

		 			  	 p_parentid  IN NUMBER,

		 			  	 p_tri       IN VARCHAR2,

		 			  	 p_listeMenu IN VARCHAR2,

		 			  	 p_txtRecher IN VARCHAR2,

		  			   	 p_curstat 	 IN OUT forumCurType_Char ,

                         p_nbcurseur    OUT INTEGER,

                         p_message      OUT VARCHAR2

                       ) IS

	l_msg      VARCHAR2(1024);

    l_idarpege MESSAGE_FORUM.USER_RTFE%TYPE;

	idSujet    NUMBER;

BEGIN



    -- Positionner le nb de curseurs ==> 1

    -- Initialiser le message retour

	p_nbcurseur := 1;

   	p_message := '';



	l_idarpege := PACK_GLOBAL.lire_globaldata(p_userid).idarpege;



	if (p_tri = 'MSG_IMPORTANT DESC, DATE_MSG DESC') then

	   	OPEN   p_curstat FOR

			SELECT mf.ID, mf.PARENT_ID, 

				   r.NOM||' '||r.PRENOM "auteur", 

				   mf.MENU, to_char(mf.DATE_MSG, 'dd/mm/yyyy') "DATE_MSG",

				   mf.TITRE, mf.TYPE_MSG, mf.STATUT, to_char(mf.DATE_STATUT, 'dd/mm/yyyy HH24:MI') "DATE_STATUT", mf.MSG_IMPORTANT,

				   mf.TEXTE, mf.TEXTE_MODIFIE, mf.MOTIF_REJET, mf.DATE_AFFICHAGE, to_char(mf.DATE_MODIFICATION, 'dd/mm/yyyy HH24:MI') "DATE_MODIFICATION",

				   mf.USER_RTFE,

				   getNbReponse(mf.ID) "NbReponse",

				   to_char(getLastDateMsg(mf.ID), 'dd/mm/yyyy HH24:MI') "datedernmodif"

			FROM   MESSAGE_FORUM mf, RTFE_USER r

			WHERE  r.USER_RTFE=mf.USER_RTFE

		   		   AND ( (p_parentid is not null and (mf.PARENT_ID = p_parentid OR mf.ID = p_parentid)) 

				         OR (p_parentid is null and mf.PARENT_ID=0) 

					   )

				   AND ( mf.TYPE_MSG='U' OR (mf.TYPE_MSG='I' AND upper(l_idarpege)=upper(mf.USER_RTFE))

				         OR (mf.TYPE_MSG='I' AND instr(p_listeMenu,';DIR;')>0 )

				       )

					   -- Message valider ou modification à valider 

				   AND ( mf.STATUT in ('V', 'M') 

					   -- Auteur du message  

				         OR upper(l_idarpege)=upper(mf.USER_RTFE)

					   -- Modérateur  

				   	     OR instr(p_listeMenu,';DIR;')>0 

				       )

			GROUP  BY mf.ID, mf.PARENT_ID, 

				   r.NOM||' '||r.PRENOM, 

				   mf.MENU, mf.DATE_MSG,

				   mf.TITRE, mf.TYPE_MSG, mf.STATUT, mf.DATE_STATUT, mf.MSG_IMPORTANT,

				   mf.TEXTE, mf.TEXTE_MODIFIE, mf.MOTIF_REJET, mf.DATE_AFFICHAGE, mf.DATE_MODIFICATION, mf.USER_RTFE

			ORDER  BY mf.MSG_IMPORTANT DESC, mf.DATE_MSG DESC;

	--

	elsif (p_tri = 'MSG_IMPORTANT DESC, DATE_MSG') then

	   	OPEN   p_curstat FOR

			SELECT mf.ID, mf.PARENT_ID, 

				   r.NOM||' '||r.PRENOM "auteur", 

				   mf.MENU, to_char(mf.DATE_MSG, 'dd/mm/yyyy') "DATE_MSG",

				   mf.TITRE, mf.TYPE_MSG, mf.STATUT, to_char(mf.DATE_STATUT, 'dd/mm/yyyy HH24:MI') "DATE_STATUT", mf.MSG_IMPORTANT,

				   mf.TEXTE, mf.TEXTE_MODIFIE, mf.MOTIF_REJET, mf.DATE_AFFICHAGE, to_char(mf.DATE_MODIFICATION, 'dd/mm/yyyy HH24:MI') "DATE_MODIFICATION",

				   mf.USER_RTFE,

				   getNbReponse(mf.ID) "NbReponse",

				   to_char(getLastDateMsg(mf.ID), 'dd/mm/yyyy HH24:MI') "datedernmodif"

			FROM   MESSAGE_FORUM mf, RTFE_USER r

			WHERE  r.USER_RTFE=mf.USER_RTFE

		   		   AND ( (p_parentid is not null and (mf.PARENT_ID = p_parentid OR mf.ID = p_parentid)) 

				         OR (p_parentid is null and mf.PARENT_ID=0) 

					   )

				   AND ( mf.TYPE_MSG='U' OR (mf.TYPE_MSG='I' AND upper(l_idarpege)=upper(mf.USER_RTFE))

				         OR (mf.TYPE_MSG='I' AND instr(p_listeMenu,';DIR;')>0 )

				       )

					   -- Message valider ou modification à valider 

				   AND ( mf.STATUT in ('V', 'M') 

					   -- Auteur du message  

				         OR upper(l_idarpege)=upper(mf.USER_RTFE)

					   -- Modérateur  

				   	     OR instr(p_listeMenu,';DIR;')>0 

				       )

			GROUP  BY mf.ID, mf.PARENT_ID, 

				   r.NOM||' '||r.PRENOM, 

				   mf.MENU, mf.DATE_MSG,

				   mf.TITRE, mf.TYPE_MSG, mf.STATUT, mf.DATE_STATUT, mf.MSG_IMPORTANT,

				   mf.TEXTE, mf.TEXTE_MODIFIE, mf.MOTIF_REJET, mf.DATE_AFFICHAGE, mf.DATE_MODIFICATION, mf.USER_RTFE

			ORDER  BY mf.MSG_IMPORTANT DESC, mf.DATE_MSG;

	--

	elsif (p_tri = 'MSG_IMPORTANT DESC, 17 DESC') then

	   	OPEN   p_curstat FOR

			SELECT mf.ID, mf.PARENT_ID, 

				   r.NOM||' '||r.PRENOM "auteur", 

				   mf.MENU, to_char(mf.DATE_MSG, 'dd/mm/yyyy') "DATE_MSG",

				   mf.TITRE, mf.TYPE_MSG, mf.STATUT, to_char(mf.DATE_STATUT, 'dd/mm/yyyy HH24:MI') "DATE_STATUT", mf.MSG_IMPORTANT,

				   mf.TEXTE, mf.TEXTE_MODIFIE, mf.MOTIF_REJET, mf.DATE_AFFICHAGE, to_char(mf.DATE_MODIFICATION, 'dd/mm/yyyy HH24:MI') "DATE_MODIFICATION",

				   mf.USER_RTFE,

				   getNbReponse(mf.ID) "NbReponse",

				   to_char(getLastDateMsg(mf.ID), 'dd/mm/yyyy HH24:MI') "datedernmodif"

			FROM   MESSAGE_FORUM mf, RTFE_USER r

			WHERE  r.USER_RTFE=mf.USER_RTFE

		   		   AND ( (p_parentid is not null and (mf.PARENT_ID = p_parentid OR mf.ID = p_parentid)) 

				         OR (p_parentid is null and mf.PARENT_ID=0) 

					   )

				   AND ( mf.TYPE_MSG='U' OR (mf.TYPE_MSG='I' AND upper(l_idarpege)=upper(mf.USER_RTFE))

				         OR (mf.TYPE_MSG='I' AND instr(p_listeMenu,';DIR;')>0 )

				       )

					   -- Message valider ou modification à valider 

				   AND ( mf.STATUT in ('V', 'M') 

					   -- Auteur du message  

				         OR upper(l_idarpege)=upper(mf.USER_RTFE)

					   -- Modérateur  

				   	     OR instr(p_listeMenu,';DIR;')>0 

				       )

			GROUP  BY mf.ID, mf.PARENT_ID, 

				   r.NOM||' '||r.PRENOM, 

				   mf.MENU, mf.DATE_MSG,

				   mf.TITRE, mf.TYPE_MSG, mf.STATUT, mf.DATE_STATUT, mf.MSG_IMPORTANT,

				   mf.TEXTE, mf.TEXTE_MODIFIE, mf.MOTIF_REJET, mf.DATE_AFFICHAGE, mf.DATE_MODIFICATION, mf.USER_RTFE

			ORDER  BY mf.MSG_IMPORTANT DESC, getLastDateMsg(mf.ID) DESC;

	--

	elsif (p_tri = 'MSG_IMPORTANT DESC, TITRE') then

	   	OPEN   p_curstat FOR

			SELECT mf.ID, mf.PARENT_ID, 

				   r.NOM||' '||r.PRENOM "auteur", 

				   mf.MENU, to_char(mf.DATE_MSG, 'dd/mm/yyyy') "DATE_MSG",

				   mf.TITRE, mf.TYPE_MSG, mf.STATUT, to_char(mf.DATE_STATUT, 'dd/mm/yyyy HH24:MI') "DATE_STATUT", mf.MSG_IMPORTANT,

				   mf.TEXTE, mf.TEXTE_MODIFIE, mf.MOTIF_REJET, mf.DATE_AFFICHAGE, to_char(mf.DATE_MODIFICATION, 'dd/mm/yyyy HH24:MI') "DATE_MODIFICATION",

				   mf.USER_RTFE,

				   getNbReponse(mf.ID) "NbReponse",

				   to_char(getLastDateMsg(mf.ID), 'dd/mm/yyyy HH24:MI') "datedernmodif"

			FROM   MESSAGE_FORUM mf, RTFE_USER r

			WHERE  r.USER_RTFE=mf.USER_RTFE

		   		   AND ( (p_parentid is not null and (mf.PARENT_ID = p_parentid OR mf.ID = p_parentid)) 

				         OR (p_parentid is null and mf.PARENT_ID=0) 

					   )

				   AND ( mf.TYPE_MSG='U' OR (mf.TYPE_MSG='I' AND upper(l_idarpege)=upper(mf.USER_RTFE))

				         OR (mf.TYPE_MSG='I' AND instr(p_listeMenu,';DIR;')>0 )

				       )

					   -- Message valider ou modification à valider 

				   AND ( mf.STATUT in ('V', 'M') 

					   -- Auteur du message  

				         OR upper(l_idarpege)=upper(mf.USER_RTFE)

					   -- Modérateur  

				   	     OR instr(p_listeMenu,';DIR;')>0 

				       )

			GROUP  BY mf.ID, mf.PARENT_ID, 

				   r.NOM||' '||r.PRENOM, 

				   mf.MENU, mf.DATE_MSG,

				   mf.TITRE, mf.TYPE_MSG, mf.STATUT, mf.DATE_STATUT, mf.MSG_IMPORTANT,

				   mf.TEXTE, mf.TEXTE_MODIFIE, mf.MOTIF_REJET, mf.DATE_AFFICHAGE, mf.DATE_MODIFICATION, mf.USER_RTFE

			ORDER  BY mf.MSG_IMPORTANT DESC, mf.TITRE;

	--

	elsif (p_tri = 'MSG_IMPORTANT DESC, TITRE DESC') then

	   	OPEN   p_curstat FOR

			SELECT mf.ID, mf.PARENT_ID, 

				   r.NOM||' '||r.PRENOM "auteur", 

				   mf.MENU, to_char(mf.DATE_MSG, 'dd/mm/yyyy') "DATE_MSG",

				   mf.TITRE, mf.TYPE_MSG, mf.STATUT, to_char(mf.DATE_STATUT, 'dd/mm/yyyy HH24:MI') "DATE_STATUT", mf.MSG_IMPORTANT,

				   mf.TEXTE, mf.TEXTE_MODIFIE, mf.MOTIF_REJET, mf.DATE_AFFICHAGE, to_char(mf.DATE_MODIFICATION, 'dd/mm/yyyy HH24:MI') "DATE_MODIFICATION",

				   mf.USER_RTFE,

				   getNbReponse(mf.ID) "NbReponse",

				   to_char(getLastDateMsg(mf.ID), 'dd/mm/yyyy HH24:MI') "datedernmodif"

			FROM   MESSAGE_FORUM mf, RTFE_USER r

			WHERE  r.USER_RTFE=mf.USER_RTFE

		   		   AND ( (p_parentid is not null and (mf.PARENT_ID = p_parentid OR mf.ID = p_parentid)) 

				         OR (p_parentid is null and mf.PARENT_ID=0) 

					   )

				   AND ( mf.TYPE_MSG='U' OR (mf.TYPE_MSG='I' AND upper(l_idarpege)=upper(mf.USER_RTFE))

				         OR (mf.TYPE_MSG='I' AND instr(p_listeMenu,';DIR;')>0 )

				       )

					   -- Message valider ou modification à valider 

				   AND ( mf.STATUT in ('V', 'M') 

					   -- Auteur du message  

				         OR upper(l_idarpege)=upper(mf.USER_RTFE)

					   -- Modérateur  

				   	     OR instr(p_listeMenu,';DIR;')>0 

				       )

			GROUP  BY mf.ID, mf.PARENT_ID, 

				   r.NOM||' '||r.PRENOM, 

				   mf.MENU, mf.DATE_MSG,

				   mf.TITRE, mf.TYPE_MSG, mf.STATUT, mf.DATE_STATUT, mf.MSG_IMPORTANT,

				   mf.TEXTE, mf.TEXTE_MODIFIE, mf.MOTIF_REJET, mf.DATE_AFFICHAGE, mf.DATE_MODIFICATION, mf.USER_RTFE

			ORDER  BY mf.MSG_IMPORTANT DESC, mf.TITRE DESC;

	--

	elsif (p_tri = 'DATE_MSG') then

		-- Curseur pour l'écran Fil de discussion

		

		-- on vide la table temporaire 

	    delete TMP_DISC_FORUM where user_rtfe = upper(l_idarpege);

		-- on ajoute les réponses au sujet

		insertTemp(p_parentid ,upper(l_idarpege));

		

	   	OPEN   p_curstat FOR

			SELECT mf.ID, mf.PARENT_ID, 

				   r.NOM||' '||r.PRENOM "auteur", 

				   mf.MENU, to_char(mf.DATE_MSG, 'dd/mm/yyyy HH24:MI') "DATE_MSG",

				   mf.TITRE, mf.TYPE_MSG, mf.STATUT, to_char(mf.DATE_STATUT, 'dd/mm/yyyy HH24:MI') "DATE_STATUT", mf.MSG_IMPORTANT,

				   mf.TEXTE, mf.TEXTE_MODIFIE, mf.MOTIF_REJET, mf.DATE_AFFICHAGE, to_char(mf.DATE_MODIFICATION, 'dd/mm/yyyy HH24:MI') "DATE_MODIFICATION",

				   mf.USER_RTFE,

				   getNbReponse(mf.ID) "NbReponse",

				   to_char(getLastDateMsg(mf.ID), 'dd/mm/yyyy HH24:MI') "datedernmodif"

			FROM   MESSAGE_FORUM mf, RTFE_USER r, TMP_DISC_FORUM tmp

			WHERE  r.USER_RTFE = mf.USER_RTFE

		   		   AND mf.ID   = tmp.ID

				   AND upper(tmp.USER_RTFE) = upper(l_idarpege)

				   AND ( mf.TYPE_MSG='U' OR (mf.TYPE_MSG='I' AND upper(l_idarpege)=upper(mf.USER_RTFE))

				         OR (mf.TYPE_MSG='I' AND instr(p_listeMenu,';DIR;')>0 )

				       )

				   AND (  (instr(p_listeMenu,';DIR;')=0 AND mf.STATUT in ('V', 'M'))

				       OR (instr(p_listeMenu,';DIR;')=0 AND upper(mf.USER_RTFE) = upper(l_idarpege) )

				       OR (instr(p_listeMenu,';DIR;')>0)

					   )

			GROUP  BY mf.ID, mf.PARENT_ID, 

				   r.NOM||' '||r.PRENOM, 

				   mf.MENU, mf.DATE_MSG,

				   mf.TITRE, mf.TYPE_MSG, mf.STATUT, mf.DATE_STATUT, mf.MSG_IMPORTANT,

				   mf.TEXTE, mf.TEXTE_MODIFIE, mf.MOTIF_REJET, mf.DATE_AFFICHAGE, mf.DATE_MODIFICATION, mf.USER_RTFE

			ORDER  BY mf.DATE_MSG;

	--

	elsif (p_tri = 'MesMessages') then

		-- Curseur pour l'écran Mes Messages

		

	   	OPEN   p_curstat FOR

			SELECT mf.ID, mf.PARENT_ID, 

				   r.NOM||' '||r.PRENOM "auteur", 

				   mf.MENU, to_char(mf.DATE_MSG, 'dd/mm/yyyy HH24:MI') "DATE_MSG",

				   mf.TITRE, mf.TYPE_MSG, mf.STATUT, to_char(mf.DATE_STATUT, 'dd/mm/yyyy HH24:MI') "DATE_STATUT", mf.MSG_IMPORTANT,

				   mf.TEXTE, mf.TEXTE_MODIFIE, mf.MOTIF_REJET, mf.DATE_AFFICHAGE, to_char(mf.DATE_MODIFICATION, 'dd/mm/yyyy HH24:MI') "DATE_MODIFICATION",

				   mf.USER_RTFE,

				   getNbReponse(mf.ID) "NbReponse",

				   to_char(getLastDateMsg(mf.ID), 'dd/mm/yyyy HH24:MI') "datedernmodif"

			FROM   MESSAGE_FORUM mf, RTFE_USER r

			WHERE  r.USER_RTFE = mf.USER_RTFE

				   AND upper(mf.USER_RTFE) = upper(l_idarpege)

			GROUP  BY mf.ID, mf.PARENT_ID, 

				   r.NOM||' '||r.PRENOM, 

				   mf.MENU, mf.DATE_MSG,

				   mf.TITRE, mf.TYPE_MSG, mf.STATUT, mf.DATE_STATUT, mf.MSG_IMPORTANT,

				   mf.TEXTE, mf.TEXTE_MODIFIE, mf.MOTIF_REJET, mf.DATE_AFFICHAGE, mf.DATE_MODIFICATION, mf.USER_RTFE

			ORDER  BY mf.DATE_MSG DESC;

	--

	elsif (p_tri = 'MesMessagesDiscussion') then

		-- Curseur pour l'écran Fil de discussion depuis la liste "Mes messages" 

		

		-- on vide la table temporaire 

	    delete TMP_DISC_FORUM where user_rtfe = upper(l_idarpege);

		-- recherche l'ID du sujet 

		idSujet := findIdSujet(p_parentid);

		-- on ajoute les réponses au sujet

		insertTemp(idSujet ,upper(l_idarpege));

		

	   	OPEN   p_curstat FOR

			SELECT mf.ID, mf.PARENT_ID, 

				   r.NOM||' '||r.PRENOM "auteur", 

				   mf.MENU, to_char(mf.DATE_MSG, 'dd/mm/yyyy HH24:MI') "DATE_MSG",

				   mf.TITRE, mf.TYPE_MSG, mf.STATUT, to_char(mf.DATE_STATUT, 'dd/mm/yyyy HH24:MI') "DATE_STATUT", mf.MSG_IMPORTANT,

				   mf.TEXTE, mf.TEXTE_MODIFIE, mf.MOTIF_REJET, mf.DATE_AFFICHAGE, to_char(mf.DATE_MODIFICATION, 'dd/mm/yyyy HH24:MI') "DATE_MODIFICATION",

				   mf.USER_RTFE,

				   getNbReponse(mf.ID) "NbReponse",

				   to_char(getLastDateMsg(mf.ID), 'dd/mm/yyyy HH24:MI') "datedernmodif"

			FROM   MESSAGE_FORUM mf, RTFE_USER r, TMP_DISC_FORUM tmp

			WHERE  r.USER_RTFE = mf.USER_RTFE

		   		   AND mf.ID   = tmp.ID

				   AND upper(tmp.USER_RTFE) = upper(l_idarpege)

				   AND ( mf.TYPE_MSG='U' OR (mf.TYPE_MSG='I' AND upper(l_idarpege)=upper(mf.USER_RTFE))

				         OR (mf.TYPE_MSG='I' AND instr(p_listeMenu,';DIR;')>0 )

				       )

				   AND (  (instr(p_listeMenu,';DIR;')=0 AND mf.STATUT in ('V', 'M'))

				       OR (instr(p_listeMenu,';DIR;')=0 AND upper(mf.USER_RTFE) = upper(l_idarpege) )

				       OR (instr(p_listeMenu,';DIR;')>0)

					   )

			GROUP  BY mf.ID, mf.PARENT_ID, 

				   r.NOM||' '||r.PRENOM, 

				   mf.MENU, mf.DATE_MSG,

				   mf.TITRE, mf.TYPE_MSG, mf.STATUT, mf.DATE_STATUT, mf.MSG_IMPORTANT,

				   mf.TEXTE, mf.TEXTE_MODIFIE, mf.MOTIF_REJET, mf.DATE_AFFICHAGE, mf.DATE_MODIFICATION, mf.USER_RTFE

			ORDER  BY mf.DATE_MSG;

	--

	elsif (p_tri = 'recherche') then

		-- Curseur pour l'écran Liste message suite à la recherche  

		

	   	OPEN   p_curstat FOR

			SELECT mf.ID, mf.PARENT_ID, 

				   r.NOM||' '||r.PRENOM "auteur", 

				   mf.MENU, to_char(mf.DATE_MSG, 'dd/mm/yyyy') "DATE_MSG",

				   mf.TITRE, mf.TYPE_MSG, mf.STATUT, to_char(mf.DATE_STATUT, 'dd/mm/yyyy HH24:MI') "DATE_STATUT", mf.MSG_IMPORTANT,

				   mf.TEXTE, mf.TEXTE_MODIFIE, mf.MOTIF_REJET, mf.DATE_AFFICHAGE, to_char(mf.DATE_MODIFICATION, 'dd/mm/yyyy HH24:MI') "DATE_MODIFICATION",

				   mf.USER_RTFE,

				   getNbReponse(mf.ID) "NbReponse",

				   to_char(getLastDateMsg(mf.ID), 'dd/mm/yyyy HH24:MI') "datedernmodif"

			FROM   MESSAGE_FORUM mf, RTFE_USER r

			WHERE  r.USER_RTFE=mf.USER_RTFE

				   AND ( mf.TYPE_MSG='U' OR (mf.TYPE_MSG='I' AND upper(l_idarpege)=upper(mf.USER_RTFE))

				         OR (mf.TYPE_MSG='I' AND instr(p_listeMenu,';DIR;')>0 )

				       )

					   -- Message valider ou modification à valider 

				   AND ( mf.STATUT in ('V', 'M') 

					   -- Auteur du message  

				         OR upper(l_idarpege)=upper(mf.USER_RTFE)

					   -- Modérateur  

				   	     OR instr(p_listeMenu,';DIR;')>0 

				       )

				   AND ( mf.TEXTE like '%'||p_txtRecher||'%' OR mf.TITRE like '%'||p_txtRecher||'%' ) 

			GROUP  BY mf.ID, mf.PARENT_ID, 

				   r.NOM||' '||r.PRENOM, 

				   mf.MENU, mf.DATE_MSG,

				   mf.TITRE, mf.TYPE_MSG, mf.STATUT, mf.DATE_STATUT, mf.MSG_IMPORTANT,

				   mf.TEXTE, mf.TEXTE_MODIFIE, mf.MOTIF_REJET, mf.DATE_AFFICHAGE, mf.DATE_MODIFICATION, mf.USER_RTFE

			ORDER  BY mf.DATE_MSG DESC;

	--

	elsif (p_tri = 'MsgAValider') then

		-- Curseur pour l'écran Messages à valider 

		

	   	OPEN   p_curstat FOR

			SELECT mf.ID, mf.PARENT_ID, 

				   r.NOM||' '||r.PRENOM "auteur", 

				   mf.MENU, to_char(mf.DATE_MSG, 'dd/mm/yyyy HH24:MI') "DATE_MSG",

				   mf.TITRE, mf.TYPE_MSG, mf.STATUT, to_char(mf.DATE_STATUT, 'dd/mm/yyyy HH24:MI') "DATE_STATUT", mf.MSG_IMPORTANT,

				   mf.TEXTE, mf.TEXTE_MODIFIE, mf.MOTIF_REJET, mf.DATE_AFFICHAGE, to_char(mf.DATE_MODIFICATION, 'dd/mm/yyyy HH24:MI') "DATE_MODIFICATION",

				   mf.USER_RTFE,

				   getNbReponse(mf.ID) "NbReponse",

				   to_char(getLastDateMsg(mf.ID), 'dd/mm/yyyy HH24:MI') "datedernmodif"

			FROM   MESSAGE_FORUM mf, RTFE_USER r

			WHERE  r.USER_RTFE = mf.USER_RTFE

				   AND mf.STATUT in ('A','M')

			GROUP  BY mf.ID, mf.PARENT_ID, 

				   r.NOM||' '||r.PRENOM, 

				   mf.MENU, mf.DATE_MSG,

				   mf.TITRE, mf.TYPE_MSG, mf.STATUT, mf.DATE_STATUT, mf.MSG_IMPORTANT,

				   mf.TEXTE, mf.TEXTE_MODIFIE, mf.MOTIF_REJET, mf.DATE_AFFICHAGE, mf.DATE_MODIFICATION, mf.USER_RTFE

			ORDER  BY mf.DATE_MSG DESC;

	--

	elsif (p_tri = 'MsgRejeter') then

		-- Curseur pour l'écran Messages rejeter 

		

	   	OPEN   p_curstat FOR

			SELECT mf.ID, mf.PARENT_ID, 

				   r.NOM||' '||r.PRENOM "auteur", 

				   mf.MENU, to_char(mf.DATE_MSG, 'dd/mm/yyyy HH24:MI') "DATE_MSG",

				   mf.TITRE, mf.TYPE_MSG, mf.STATUT, to_char(mf.DATE_STATUT, 'dd/mm/yyyy HH24:MI') "DATE_STATUT", mf.MSG_IMPORTANT,

				   mf.TEXTE, mf.TEXTE_MODIFIE, mf.MOTIF_REJET, mf.DATE_AFFICHAGE, to_char(mf.DATE_MODIFICATION, 'dd/mm/yyyy HH24:MI') "DATE_MODIFICATION",

				   mf.USER_RTFE,

				   getNbReponse(mf.ID) "NbReponse",

				   to_char(getLastDateMsg(mf.ID), 'dd/mm/yyyy HH24:MI') "datedernmodif"

			FROM   MESSAGE_FORUM mf, RTFE_USER r

			WHERE  r.USER_RTFE = mf.USER_RTFE

				   AND mf.STATUT = 'R'

			GROUP  BY mf.ID, mf.PARENT_ID, 

				   r.NOM||' '||r.PRENOM, 

				   mf.MENU, mf.DATE_MSG,

				   mf.TITRE, mf.TYPE_MSG, mf.STATUT, mf.DATE_STATUT, mf.MSG_IMPORTANT,

				   mf.TEXTE, mf.TEXTE_MODIFIE, mf.MOTIF_REJET, mf.DATE_AFFICHAGE, mf.DATE_MODIFICATION, mf.USER_RTFE

			ORDER  BY mf.DATE_MSG DESC;

	--

	else

	   	OPEN   p_curstat FOR

			SELECT mf.ID, mf.PARENT_ID, 

				   r.NOM||' '||r.PRENOM "auteur", 

				   mf.MENU, to_char(mf.DATE_MSG, 'dd/mm/yyyy') "DATE_MSG",

				   mf.TITRE, mf.TYPE_MSG, mf.STATUT, to_char(mf.DATE_STATUT, 'dd/mm/yyyy HH24:MI') "DATE_STATUT", mf.MSG_IMPORTANT,

				   mf.TEXTE, mf.TEXTE_MODIFIE, mf.MOTIF_REJET, mf.DATE_AFFICHAGE, to_char(mf.DATE_MODIFICATION, 'dd/mm/yyyy HH24:MI') "DATE_MODIFICATION",

				   mf.USER_RTFE,

				   getNbReponse(mf.ID) "NbReponse",

				   to_char(getLastDateMsg(mf.ID), 'dd/mm/yyyy HH24:MI') "datedernmodif"

			FROM   MESSAGE_FORUM mf, RTFE_USER r

			WHERE  r.USER_RTFE=mf.USER_RTFE

		   		   AND ( (p_parentid is not null and (mf.PARENT_ID = p_parentid OR mf.ID = p_parentid)) 

				         OR (p_parentid is null and mf.PARENT_ID=0) 

					   )

				   AND ( mf.TYPE_MSG='U' OR (mf.TYPE_MSG='I' AND upper(l_idarpege)=upper(mf.USER_RTFE))

				         OR (mf.TYPE_MSG='I' AND instr(p_listeMenu,';DIR;')>0 )

				       )

					   -- Message valider ou modification à valider 

				   AND ( mf.STATUT in ('V', 'M') 

					   -- Auteur du message  

				         OR upper(l_idarpege)=upper(mf.USER_RTFE)

					   -- Modérateur  

				   	     OR instr(p_listeMenu,';DIR;')>0 

				       )



			GROUP  BY mf.ID, mf.PARENT_ID, 

				   r.NOM||' '||r.PRENOM, 

				   mf.MENU, mf.DATE_MSG,

				   mf.TITRE, mf.TYPE_MSG, mf.STATUT, mf.DATE_STATUT, mf.MSG_IMPORTANT,

				   mf.TEXTE, mf.TEXTE_MODIFIE, mf.MOTIF_REJET, mf.DATE_AFFICHAGE, mf.DATE_MODIFICATION, mf.USER_RTFE

			ORDER  BY mf.MSG_IMPORTANT DESC, mf.DATE_MSG DESC;

	end if;

EXCEPTION

	WHEN OTHERS THEN

   		raise_application_error( -20997, SQLERRM);



END select_liste;







/***************************************************************************************/

/*                                                                                     */

/*          getNbReponse : retourne le nb de réponse reçu à un message                 */

/*                                                                                     */

/***************************************************************************************/

FUNCTION getNbReponse(p_id IN NUMBER) RETURN NUMBER IS



    CURSOR cur_message(l_id NUMBER) IS

    	   SELECT id FROM MESSAGE_FORUM WHERE parent_id = l_id;

	 

	l_resultat NUMBER;



BEGIN



	l_resultat := 0;



    FOR  cur_enr IN cur_message(p_id)

    LOOP

		l_resultat := l_resultat + 1;

		l_resultat := l_resultat + getNbReponse(cur_enr.id);

    END LOOP ;



	return l_resultat;

	

END getNbReponse;







/***********************************************************************************************************/

/*                                                                                                         */

/*          listIdFils : retourne la liste des id des réponses à un sujet sépararé par des virgules        */

/*                                                                                                         */

/***********************************************************************************************************/

FUNCTION listIdFils( p_id IN NUMBER ) RETURN VARCHAR2 IS



    CURSOR cur_message(l_id NUMBER) IS

    	   SELECT id FROM MESSAGE_FORUM WHERE parent_id = l_id;

	 

	l_resultat VARCHAR2(1024);



BEGIN



	l_resultat := '';

	

    FOR  cur_enr IN cur_message(p_id)

    LOOP

		if (length(l_resultat)>0) then

		    l_resultat := l_resultat ||',';

		end if;

		l_resultat := l_resultat || listIdFils(cur_enr.id);

    END LOOP ;



	if (length(l_resultat)>0) then

	    l_resultat := l_resultat ||',';

	end if;

	l_resultat := l_resultat || p_id;

	

	return l_resultat;

	

END listIdFils;









/***************************************************************************************/

/*                                                                                     */

/*    insertTemp : insert dans la table temporaire tous les messages d'une discussion  */

/*                                                                                     */

/***************************************************************************************/

PROCEDURE insertTemp( p_id IN NUMBER, 

					  p_user IN VARCHAR2) IS

					  

    CURSOR cur_message(l_id NUMBER) IS

    	   SELECT id FROM MESSAGE_FORUM WHERE parent_id = l_id;

		   

BEGIN

	

    FOR  cur_enr IN cur_message(p_id)

    LOOP

		insertTemp(cur_enr.id, p_user);

    END LOOP ;

	

    insert into TMP_DISC_FORUM (USER_RTFE, ID) values (p_user, p_id);

	

END insertTemp;







/***************************************************************************************/

/*                                                                                     */

/*          getLastDateMsg : retourne la date de la dernière réponse au message        */

/*                                                                                     */

/***************************************************************************************/

FUNCTION getLastDateMsg(p_id IN NUMBER) RETURN DATE IS



	l_resultat DATE;

    l_select   VARCHAR2(1024);

BEGIN



	l_select := 'select max(date_msg) from MESSAGE_FORUM where id in ('||listIdFils(p_id)||')';

	execute immediate l_select into l_resultat;



	return l_resultat;



EXCEPTION

    WHEN OTHERS THEN

        return null;

		

END getLastDateMsg;







/***************************************************************************************/

/*                                                                                     */

/*          insert_message : créer un nouveau message       						   */

/*                                                                                     */

/***************************************************************************************/

PROCEDURE insert_message ( p_userid	       IN VARCHAR2,

	 			  	 	   p_id 	   	   IN NUMBER,

	 			  	 	   p_parentid 	   IN NUMBER,

		 			  	   p_menu     	   IN VARCHAR2,

						   p_titre    	   IN VARCHAR2,

		 			  	   p_type_msg 	   IN VARCHAR2,

						   p_texte    	   IN VARCHAR2,

		 			  	   p_msg_important IN VARCHAR2,

		 			  	   p_listeMenu 	   IN VARCHAR2,

		 			  	   p_statut 	   IN VARCHAR2,

                           p_nbcurseur        OUT INTEGER,

                           p_message     	  OUT VARCHAR2

						 ) IS



    l_idarpege	    MESSAGE_FORUM.USER_RTFE%TYPE;

    l_next_ordre	MESSAGE_FORUM.ID%TYPE;

	l_statut		MESSAGE_FORUM.STATUT%TYPE;



BEGIN

    -- Initialiser le message retour

    p_message   := '';

	p_nbcurseur := 1;



	l_idarpege := PACK_GLOBAL.lire_globaldata(p_userid).idarpege;



	select nvl(max(id),0) + 1

	  into l_next_ordre

	  from MESSAGE_FORUM;

	  

    l_statut := 'A';

	-- si l'utilisateur a droit au menu administration son message est validé automatiquement

	if (instr(p_listeMenu,';DIR;')>0) then

	    l_statut := 'V';

	end if;

	-- si nouveau sujet 

	if ((p_statut is null) OR (p_statut!='A' AND p_statut!='M')) then

		insert into MESSAGE_FORUM ( ID, PARENT_ID, USER_RTFE, MENU, DATE_MSG, TITRE, TYPE_MSG, STATUT, DATE_STATUT, 

			   					    MSG_IMPORTANT, TEXTE ) 

		values (l_next_ordre, nvl(p_parentid,0), l_idarpege, p_menu, sysdate, p_titre, p_type_msg, l_statut, sysdate,

			    nvl(p_msg_important,'N'), p_texte);

				

	elsif (p_statut='M') then

	-- si modifier un message 

	    if (l_statut = 'A') then

		    l_statut := 'M';

		end if;

		update MESSAGE_FORUM

		   set TITRE             = p_titre,

		   	   TYPE_MSG      	 = p_type_msg,

			   STATUT        	 = l_statut,

			   DATE_STATUT   	 = sysdate,

			   DATE_MODIFICATION = sysdate, 

			   MSG_IMPORTANT 	 = nvl(p_msg_important,'N'),

			   TEXTE_MODIFIE 	 = decode(l_statut, 'M', p_texte, null),

			   TEXTE			 = decode(l_statut, 'V', p_texte, TEXTE)

		 where ID = p_id; 



	elsif (p_statut='A') then

	-- si réponse à un message 

		insert into MESSAGE_FORUM ( ID, PARENT_ID, USER_RTFE, MENU, DATE_MSG, TITRE, TYPE_MSG, STATUT, DATE_STATUT, 

			   					    MSG_IMPORTANT, TEXTE ) 

		values (l_next_ordre, nvl(p_id,0), l_idarpege, p_menu, sysdate, p_titre, p_type_msg, l_statut, sysdate,

			    nvl(p_msg_important,'N'), p_texte);



	end if;

      

    pack_global.recuperer_message( 20366 , '%s1', 'Le message a été créé.', '', p_message);

     

END insert_message;







/***************************************************************************************/

/*                                                                                     */

/*          VALIDATION_REJET : valide ou rejete un message       					   */

/*                                                                                     */

/***************************************************************************************/

PROCEDURE VALIDATION_REJET ( p_userid	 IN VARCHAR2,

		 			  	 	 p_id 	     IN NUMBER,

   			 			  	 p_statut    IN VARCHAR2,

							 p_motif     IN VARCHAR2,

                             p_nbcurseur    OUT INTEGER,

                             p_message      OUT VARCHAR2

						   ) IS



    l_idarpege	    MESSAGE_FORUM.USER_RTFE%TYPE;

    l_next_ordre	MESSAGE_FORUM.ID%TYPE;

	l_statut		MESSAGE_FORUM.STATUT%TYPE;



BEGIN

    -- Initialiser le message retour

    p_message   := '';

	p_nbcurseur := 1;



	update MESSAGE_FORUM

	   set statut        = p_statut,

	       date_statut 	 = sysdate,

		   motif_rejet 	 = decode(p_statut, 'V', null, p_motif),

		   texte       	 = nvl(texte_modifie, texte),

		   texte_modifie = null

	 where id = p_id; 

      

--    pack_global.recuperer_message( 20366 , '%s1', 'Le message a été validé.', '', p_message);

     

END VALIDATION_REJET;







/***************************************************************************************/

/*                                                                                     */

/*               SELECTION MESSAGE													   */

/*                                                                                     */

/***************************************************************************************/

PROCEDURE select_message ( p_userid	   IN VARCHAR2,

		 			  	   p_id        IN NUMBER,

		  			   	   p_curstat   IN OUT forumCurType_Char ,

                           p_nbcurseur    OUT INTEGER,

                           p_message      OUT VARCHAR2

                         ) IS

BEGIN



    -- Positionner le nb de curseurs ==> 1

    -- Initialiser le message retour

	p_nbcurseur := 1;

   	p_message := '';



   	OPEN   p_curstat FOR

		SELECT mf.ID, mf.PARENT_ID, 

			   r.NOM||' '||r.PRENOM "auteur", 

			   mf.MENU, to_char(mf.DATE_MSG, 'dd/mm/yyyy HH24:MI') "DATE_MSG",

			   mf.TITRE, mf.TYPE_MSG, mf.STATUT, to_char(mf.DATE_STATUT, 'dd/mm/yyyy HH24:MI') "DATE_STATUT", mf.MSG_IMPORTANT,

			   mf.TEXTE, mf.TEXTE_MODIFIE, mf.MOTIF_REJET, mf.DATE_AFFICHAGE, to_char(mf.DATE_MODIFICATION, 'dd/mm/yyyy HH24:MI') "DATE_MODIFICATION",

			   mf.USER_RTFE,

			   getNbReponse(mf.ID) "NbReponse",

			   to_char(getLastDateMsg(mf.ID), 'dd/mm/yyyy HH24:MI') "datedernmodif"

		FROM   MESSAGE_FORUM mf, RTFE_USER r

		WHERE  mf.ID = p_id

			   AND r.USER_RTFE=mf.USER_RTFE

		GROUP  BY mf.ID, mf.PARENT_ID, 

			   r.NOM||' '||r.PRENOM, 

			   mf.MENU, mf.DATE_MSG,

			   mf.TITRE, mf.TYPE_MSG, mf.STATUT, mf.DATE_STATUT, mf.MSG_IMPORTANT,

			   mf.TEXTE, mf.TEXTE_MODIFIE, mf.MOTIF_REJET, mf.DATE_AFFICHAGE, mf.DATE_MODIFICATION, mf.USER_RTFE;



EXCEPTION

	WHEN OTHERS THEN

   		raise_application_error( -20997, SQLERRM);



END select_message;







/***************************************************************************************/

/*                                                                                     */

/*          delete_message : supprime un message       						   		   */

/*                                                                                     */

/***************************************************************************************/

PROCEDURE DELETE_MESSAGE ( p_userid	 IN VARCHAR2,

		 			  	   p_id 	     IN NUMBER,

                           p_nbcurseur    OUT INTEGER,

                           p_message      OUT VARCHAR2

						 ) IS



	l_parent_id number;

						 

BEGIN

    -- Initialiser le message retour

    p_message   := '';

	p_nbcurseur := 1;



	select parent_id into l_parent_id from MESSAGE_FORUM where id = p_id;

	

	delete MESSAGE_FORUM

	 where id = p_id;

	 

	-- on réaffecte les fils au père du message supprimé

	update MESSAGE_FORUM

	   set parent_id = l_parent_id

	 where parent_id = p_id; 

      

--    pack_global.recuperer_message( 20366 , '%s1', 'Le message a été validé.', '', p_message);

     

END DELETE_MESSAGE;









/***********************************************************************************************************/

/*                                                                                                         */

/*          findIdSujet : retourne l'ID du sujet initial du message       								   */

/*                                                                                                         */

/***********************************************************************************************************/

FUNCTION findIdSujet( p_id IN NUMBER ) RETURN NUMBER IS



    CURSOR cur_message(l_id NUMBER) IS

    	   SELECT parent_id, id FROM MESSAGE_FORUM WHERE id = l_id;

	 

	l_iteration NUMBER;

	l_id		NUMBER;

BEGIN



	l_id := p_id;

	l_iteration := 0;

	

	WHILE (l_iteration<100)

	LOOP

	    FOR  cur_enr IN cur_message(l_id)

	    LOOP

			if (cur_enr.parent_id!=0) then

				l_id := cur_enr.parent_id;

				exit;

			else

				return cur_enr.id;

			end if;

	    END LOOP ;

		l_iteration := l_iteration + 1; 

	END LOOP;

	

	return null;

	

END findIdSujet;









/***********************************************************************************************************/

/*                                                                                                         */

/*          RECHERCHE_AVANCEE : retourne la liste des messages suivant la recherche demandée			   */

/*                                                                                                         */

/***********************************************************************************************************/

PROCEDURE RECHERCHE_AVANCEE ( p_userid	     IN VARCHAR2,

   			 			  	  p_menu      	 IN VARCHAR2,

   			 			  	  p_listeMenu 	 IN VARCHAR2,

							  p_mot_cle   	 IN VARCHAR2,

   			 			  	  p_chercheTitre IN VARCHAR2,

   			 			  	  p_chercheTexte IN VARCHAR2,

   			 			  	  p_auteur 		 IN VARCHAR2,

   			 			  	  p_date_debut 	 IN VARCHAR2,

   			 			  	  p_date_fin 	 IN VARCHAR2,

   			 			  	  p_curstat   	 IN OUT forumCurType_Char ,

                              p_nbcurseur       OUT INTEGER,

                              p_message         OUT VARCHAR2

                       ) IS

	l_msg      VARCHAR2(1024);

    l_idarpege MESSAGE_FORUM.USER_RTFE%TYPE;

	idSujet    NUMBER;

BEGIN



    -- Positionner le nb de curseurs ==> 1

    -- Initialiser le message retour

	p_nbcurseur := 1;

   	p_message := '';



	l_idarpege := PACK_GLOBAL.lire_globaldata(p_userid).idarpege;



	   	OPEN   p_curstat FOR

			SELECT mf.ID, mf.PARENT_ID, 

				   r.NOM||' '||r.PRENOM "auteur", 

				   mf.MENU, to_char(mf.DATE_MSG, 'dd/mm/yyyy') "DATE_MSG",

				   mf.TITRE, mf.TYPE_MSG, mf.STATUT, to_char(mf.DATE_STATUT, 'dd/mm/yyyy HH24:MI') "DATE_STATUT", mf.MSG_IMPORTANT,

				   mf.TEXTE, mf.TEXTE_MODIFIE, mf.MOTIF_REJET, mf.DATE_AFFICHAGE, to_char(mf.DATE_MODIFICATION, 'dd/mm/yyyy HH24:MI') "DATE_MODIFICATION",

				   mf.USER_RTFE,

				   getNbReponse(mf.ID) "NbReponse",

				   to_char(getLastDateMsg(mf.ID), 'dd/mm/yyyy HH24:MI') "datedernmodif"

			FROM   MESSAGE_FORUM mf, RTFE_USER r

			WHERE  r.USER_RTFE=mf.USER_RTFE

				   AND mf.MENU = p_menu

				   AND ( mf.TYPE_MSG='U' OR (mf.TYPE_MSG='I' AND upper(l_idarpege)=upper(mf.USER_RTFE))

				         OR (mf.TYPE_MSG='I' AND instr(p_listeMenu,';DIR;')>0 )

				       )

					   -- Message valider ou modification à valider 

				   AND ( mf.STATUT in ('V', 'M') 

					   -- Auteur du message  

				         OR upper(l_idarpege)=upper(mf.USER_RTFE)

					   -- Modérateur  

				   	     OR instr(p_listeMenu,';DIR;')>0 

				       )

				   AND ( (p_chercheTexte is null) OR 

				         (p_chercheTexte != 'O') OR 

				         (p_chercheTexte = 'O' and upper(mf.TEXTE) like '%'||upper(trim(p_mot_cle))||'%' )

					     OR

				   		 (p_chercheTitre is null) OR 

				         (p_chercheTitre != 'O') OR 

				         (p_chercheTitre = 'O' and upper(mf.TITRE) like '%'||upper(trim(p_mot_cle))||'%' )

					   )

				   AND ( (p_auteur is null) OR 

				         (p_auteur = '') OR 

				         (p_auteur is not null AND upper(r.NOM||' '||r.PRENOM) like upper('%'||trim(p_auteur)||'%') )

					   )

				   AND ( (p_date_debut is null) OR 

				         (p_date_debut is not null AND trunc(mf.DATE_MSG)>=p_date_debut)

					   )

				   AND ( (p_date_fin is null) OR 

				         (p_date_fin is not null AND trunc(mf.DATE_MSG)<=p_date_fin)

					   )

			GROUP  BY mf.ID, mf.PARENT_ID, 

				   r.NOM||' '||r.PRENOM, 

				   mf.MENU, mf.DATE_MSG,

				   mf.TITRE, mf.TYPE_MSG, mf.STATUT, mf.DATE_STATUT, mf.MSG_IMPORTANT,

				   mf.TEXTE, mf.TEXTE_MODIFIE, mf.MOTIF_REJET, mf.DATE_AFFICHAGE, mf.DATE_MODIFICATION, mf.USER_RTFE

			ORDER  BY mf.ID, mf.DATE_MSG DESC;

			

			

EXCEPTION

	WHEN OTHERS THEN

   		raise_application_error( -20997, SQLERRM);



END RECHERCHE_AVANCEE;







END pack_forum;

/





