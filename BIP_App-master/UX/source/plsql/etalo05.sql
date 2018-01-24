-- Nom        :  prologue
-- Auteur     :  Equipe SOPRA
-- Decription :  Package pour l'edition etalo05

CREATE OR replace PACKAGE pack_etalo05 AS
  -- ------------------------------------------------------------------------
  -- Nom        :  verif_etalo05
  -- Auteur     :  Equipe SOPRA
  -- Decription :  vérifie les dates  pour l'edition etalo05
  -- Paramètres :  p_param6 (IN) DATE: date debut de prestation
  --               p_param7 (IN) DATE: date fin de prestation
  --               p_param8 (IN) DATE: date début de saisie
  --               p_message (out) varchar2
  -- Retour     :  renvoie rien si ok, erreur sinon
  -- 
  -- ------------------------------------------------------------------------  
PROCEDURE  verif_etalo05(p_param6 IN VARCHAR2,
			 p_param7 IN VARCHAR2,
			 p_param8 IN VARCHAR2,
			 p_message OUT VARCHAR2);

END pack_etalo05;
/

CREATE OR replace PACKAGE BODY pack_etalo05 AS 
  
  -- ------------------------------------------------------------------------
  -- Nom        :  prologue
  -- Auteur     :  Equipe SOPRA
  -- Decription :  vérifie que la date de début de prestation est inférieur
  --               à la date de fin de prestation pour l'edition etalo05
  -- Paramètres :  p_param6 (IN) DATE: date debut de prestation
  --               p_param7 (IN) DATE: date fin de prestation
  --               p_param8 (IN) DATE: date début de saisie
  --               p_message (out) varchar2
  -- Retour     :  renvoie rien si ok, erreur sinon
  -- 
  -- ------------------------------------------------------------------------  
PROCEDURE  verif_etalo05(p_param6 IN VARCHAR2,
			 p_param7 IN VARCHAR2,
			 p_param8 IN VARCHAR2,
			 p_message OUT VARCHAR2) IS
  l_msg VARCHAR2(1024) :=''; 
BEGIN
   IF to_date(p_param6,'mm/yyyy')>to_date(p_param7,'mm/yyyy') THEN
      pack_global.recuperer_message(20284, NULL, NULL, 'p_param6', l_msg);
      p_message := l_msg;
      raise_application_error(-20284, l_msg);
   END IF;
   p_message := l_msg;
END verif_etalo05;

END pack_etalo05;
/
