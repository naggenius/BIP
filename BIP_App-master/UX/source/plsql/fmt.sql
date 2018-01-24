-- *************************************************************************
-- pack_fmt
-- *************************************************************************
-- pack_fmt PL/SQL
-- equipe SOPRA
-- crée le 03/12/1999
-- ROLE : Regroupe  des fonctions permettant le formatages des 
--        données passées en paramètre. Il est notamment utilisé dans les 
--        extractions.  
-- *************************************************************************
--                          MODIFICATIONS 
--
-- 10/12/1999 : MRZ Ajout des pragma pour les fonctions le permettant
-- ----------------------------------------------------------------------

CREATE OR replace PACKAGE pack_fmt IS 
-- *************************************************************************
   FUNCTION f_fmtAlpha (p_champ IN VARCHAR2, p_ln IN INTEGER) RETURN VARCHAR2;
   FUNCTION f_fmtInt (p_champ IN INTEGER, p_ln IN INTEGER) RETURN VARCHAR2;
   FUNCTION f_fmtNum (p_champ IN NUMBER, p_ln IN INTEGER) RETURN VARCHAR2;
   FUNCTION f_fmtDat(p_champ IN DATE) RETURN VARCHAR2;
   FUNCTION f_Cadrer (p_champ IN VARCHAR2, p_ln IN INTEGER, P_cote IN CHAR, p_car IN CHAR) RETURN VARCHAR2;
   
   -- Pragma permettant d'appeler les fonctions dans des selects 
   PRAGMA restrict_references(f_fmtAlpha,wnds,wnps);
   PRAGMA restrict_references(f_fmtInt,wnds,wnps);
   PRAGMA restrict_references(f_fmtDat,wnds,wnps);   
   PRAGMA restrict_references(f_Cadrer,wnds,wnps);   
END pack_fmt;
/

CREATE OR replace PACKAGE BODY pack_fmt IS 

-- *************************************************************************
-- f_fmtAlpha : formate la variable p_champ (alphabetique) selon la regle suivante :
--              cadrage à gauche, completer à blancs jusqu'a ce que p_champ
--              ait une taille = p_ln caracteres.
-- *************************************************************************
 FUNCTION f_fmtAlpha (p_champ IN VARCHAR2, p_ln IN INTEGER) RETURN VARCHAR2 IS 
    l_champ VARCHAR2(1024);
    l_car CHAR(1);
 BEGIN
    l_car   := ' ';
    l_champ := NVL(p_champ,l_car);    

    RETURN (f_Cadrer (l_champ , p_ln ,'G' , l_car));
 END;       



-- *************************************************************************
-- f_fmtInt : formate la variable p_champ (entier) selon la regle suivante :
--            Cadrage à droite, completer a gauche par des zeros jusqu' a ce 
--            que p_champ ait une taille = p_ln caracteres.
-- *************************************************************************
 FUNCTION f_fmtInt (p_champ IN INTEGER, p_ln IN INTEGER) RETURN VARCHAR2 IS 
    l_champ VARCHAR2(1024);
    l_car CHAR(1);
 BEGIN
    l_car   := '0';
    l_champ := to_char(NVL(p_champ,l_car),'FM99999999999');    

    RETURN (f_Cadrer (l_champ , p_ln ,'D' , l_car));
 END;       



-- *************************************************************************
-- f_fmtNum : formate la variable p_champ (numerique) selon la regle suivante :
--            Format des nombres avec deux chiffre décimales apres la virgule
--            Cadrage à droite, completer a gauche par des zeros jusqu' a ce 
--            que p_champ ait une taille = p_ln caracteres (positions decimale
--            et virgule comprises).
-- *************************************************************************

 FUNCTION f_fmtNum(p_champ IN NUMBER, p_ln IN INTEGER) RETURN VARCHAR2 IS 
    l_champ VARCHAR2(1024);
    l_car CHAR(1);
 BEGIN
    l_car := ' ';
    l_champ := to_char(NVL(p_champ,l_car),'FM99999999999.00');    
    RETURN (f_Cadrer (l_champ , p_ln ,'D' , l_car));

 END;       
-- *************************************************************************
-- f_fmtDat : formate la variable p_champ (date) selon la regle suivante :
--            format 'ddmmyyyy'
-- *************************************************************************

 FUNCTION f_fmtDat(p_champ IN DATE) RETURN VARCHAR2 IS 
    l_champ VARCHAR2(1024);
    l_car CHAR(1);
 BEGIN
    l_car := '0';
    IF (p_champ is null) THEN 
       RETURN ('00000000');
    ELSE 
    	RETURN (to_char(p_champ,'ddmmyyyy'));    
    END IF;
 END;       



-- *************************************************************************
-- f_Cadrer : Cadre p_champ a droite ou a gauche selon la valeur p_cote,
--            le comlete par p_car pour que p_champ soit de taille=p_ln
-- *************************************************************************
 FUNCTION f_Cadrer (p_champ IN VARCHAR2, p_ln IN INTEGER, p_cote IN CHAR, p_car IN CHAR) RETURN VARCHAR2 IS 
    l_champ VARCHAR2(1024);
 BEGIN   
    IF LENGTH(p_champ) >= p_ln then
       RETURN (SUBSTR(p_champ,1, p_ln)); 
    ELSIF P_cote = 'D' THEN
       RETURN (lpad(p_champ, p_ln, p_car));       
    ELSIF P_cote = 'G' THEN
       RETURN (rpad(p_champ, p_ln, p_car));
    ELSE 
       RETURN ('Erreur');
    END IF;
 END;       


    
END pack_fmt;
/
