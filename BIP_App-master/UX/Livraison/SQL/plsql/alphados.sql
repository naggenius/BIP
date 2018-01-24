-- Nom        :  prologue
-- Auteur     :  Equipe SOPRA
-- Decription :  Package pour les editions alphados et oalfados

CREATE OR replace PACKAGE pack_alphados AS
 
   -- ------------------------------------------------------------------------
  -- Nom        :  verif_alphados
  -- Auteur     :  Equipe SOPRA
  -- Decription :  vérifie l'existence de la chaine de caractere à rechercher
  -- Paramètres :  p_param6 (IN) VARCHAR2(50): libellé selectionné
  --               p_message (out) varchar2
  -- Retour     :  renvoie rien si ok, erreur sinon
  -- 
  -- ------------------------------------------------------------------------  
PROCEDURE  verif_alphados(p_param6 IN VARCHAR2,
			 p_message OUT VARCHAR2);


  -- ------------------------------------------------------------------------
  -- Nom        :  verif_alphaappli
  -- Auteur     : MMC
  -- Decription :  vérifie l'existence de la chaine de caractere à rechercher
  -- Paramètres :  p_param6 (IN) VARCHAR2(50): libellé selectionné
  --               p_message (out) varchar2
  -- Retour     :  renvoie rien si ok, erreur sinon
  -- 
  -- ------------------------------------------------------------------------  
PROCEDURE  verif_alphaappli(p_param6 IN VARCHAR2,
			 p_message OUT VARCHAR2);
			 
 -- ------------------------------------------------------------------------
  -- Nom        :  verif_alphaproj
  -- Auteur     : MMC
  -- Decription :  vérifie l'existence de la chaine de caractere à rechercher
  -- Paramètres :  p_param6 (IN) VARCHAR2(50): libellé selectionné
  --               p_message (out) varchar2
  -- Retour     :  renvoie rien si ok, erreur sinon
  -- 
  -- ------------------------------------------------------------------------  
PROCEDURE  verif_alphaproj(p_param6 IN VARCHAR2,
			 p_message OUT VARCHAR2);
END pack_alphados;
/

CREATE OR replace PACKAGE BODY pack_alphados AS 
   -- ------------------------------------------------------------------------
  -- Nom        :  verif_libelle
  -- Auteur     :  Equipe SOPRA
  -- Decription :  vérifie l'existence de la chaine de caractere à rechercher
  -- Paramètres :  p_param6 (IN) VARCHAR2(50): libellé selectionné
  --               p_message (out) varchar2
  -- Retour     :  renvoie rien si ok, erreur sinon
  -- 
  -- ------------------------------------------------------------------------ 

PROCEDURE  verif_alphados(p_param6 IN VARCHAR2,
			 p_message OUT VARCHAR2) IS
   l_msg VARCHAR2(1024) :=''; 
   l_ret VARCHAR2(50);
BEGIN

-- replace(p_param6,''',' ') 
	SELECT  count(dplib)     INTO l_ret
	FROM dossier_projet
	WHERE  upper( dplib) like upper('%'||p_param6||'%' );
if l_ret<1 then 
	pack_global.recuperer_message(20316, NULL, NULL, 'p_param6', l_msg);
      	p_message := l_msg;
      	raise_application_error(-20316, l_msg);
	else
	p_message := l_msg;
end if;

   
EXCEPTION
   WHEN no_data_found then
      pack_global.recuperer_message(20316, NULL, NULL, 'p_param6', l_msg);
      p_message := l_msg;
      raise_application_error(-20316, l_msg);
      p_message := l_msg;
END verif_alphados;

/*
 PROCEDURE qui recherche une chaine de  caractere dans le libelle d'une application
*/
PROCEDURE  verif_alphaappli(p_param6 IN VARCHAR2,
			 p_message OUT VARCHAR2) IS
   l_msg VARCHAR2(1024) :=''; 
   l_ret VARCHAR2(50);
BEGIN

-- replace(p_param6,''',' ') 
	SELECT  count(alibel)     INTO l_ret
	FROM application
	WHERE  upper( alibel) like upper('%'||p_param6||'%' );
if l_ret<1 then 
	pack_global.recuperer_message(20316, NULL, NULL, 'p_param6', l_msg);
      	p_message := l_msg;
      	raise_application_error(-20316, l_msg);
	else
	p_message := l_msg;
end if;

   
EXCEPTION
   WHEN no_data_found then
      pack_global.recuperer_message(20316, NULL, NULL, 'p_param6', l_msg);
      p_message := l_msg;
      raise_application_error(-20316, l_msg);
      p_message := l_msg;
END verif_alphaappli;

/*
 PROCEDURE qui recherche une chaine de  caractere dans le libelle d'un projet
*/
PROCEDURE  verif_alphaproj(p_param6 IN VARCHAR2,
			 p_message OUT VARCHAR2) IS
   l_msg VARCHAR2(1024) :=''; 
   l_ret VARCHAR2(50);
BEGIN

-- replace(p_param6,''',' ') 
	SELECT  count(ilibel)     INTO l_ret
	FROM proj_info
	WHERE  upper( ilibel) like upper('%'||p_param6||'%' );
if l_ret<1 then 
	pack_global.recuperer_message(20316, NULL, NULL, 'p_param6', l_msg);
      	p_message := l_msg;
      	raise_application_error(-20316, l_msg);
	else
	p_message := l_msg;
end if;

   
EXCEPTION
   WHEN no_data_found then
      pack_global.recuperer_message(20316, NULL, NULL, 'p_param6', l_msg);
      p_message := l_msg;
      raise_application_error(-20316, l_msg);
      p_message := l_msg;
END verif_alphaproj;


END pack_alphados;
/









