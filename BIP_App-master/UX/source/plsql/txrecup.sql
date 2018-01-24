-- pack_txrecup PL/SQL
--
-- crée par Aurore REMENS le 24/04/2001
-- Modifié le 18/06/2003 par NBM :remplacer p_bouton par p_action,inilialiser p_message 
-- 		   	  13/11/2003 par NBM : ajout taux charge salariale
-- Modifié le 26/08/2004 par KHA: ajouter gestion des filiales dans table taux_recup
-- Gestion des taux de récupération 
--
-- **********************************************************************
CREATE OR REPLACE PACKAGE pack_txrecup AS

   TYPE txrecup_RecType IS RECORD (ANNEE        VARCHAR2(4),
                                   FILCODE      CHAR(3),  
                                   TAUX_RECUP   VARCHAR2(30),
								   TAUX_SAL     VARCHAR2(30),
								   FLAGLOCK		NUMBER(7));

   TYPE txrecup_CurType IS REF CURSOR RETURN txrecup_RecType;

PROCEDURE select_txrecup( 	p_action    IN VARCHAR2,
							p_annee IN VARCHAR2,
							p_filcode IN CHAR,
							p_userid    IN CHAR,
							p_curselect IN  OUT txrecup_CurType,
		                	p_nbcurseur     OUT INTEGER,
							p_message       OUT VARCHAR2
                           );

 PROCEDURE insert_txrecup(	p_annee IN VARCHAR2,
 							p_filcode  IN  CHAR,
							p_taux_rec IN VARCHAR2,
							p_taux_sal IN VARCHAR2,
							p_nbcurseur     OUT INTEGER,
							p_message       OUT VARCHAR2
				);

 PROCEDURE update_txrecup(	p_annee IN VARCHAR2,
 							p_filcode  IN  CHAR,
							p_taux_rec IN VARCHAR2,
							p_taux_sal IN VARCHAR2,
							p_flaglock  IN  NUMBER,
							p_nbcurseur     OUT INTEGER,
							p_message       OUT VARCHAR2
				);
PROCEDURE delete_txrecup(	p_annee IN VARCHAR2,
				p_filcode  IN  CHAR,
		  					p_flaglock  IN  NUMBER,
							p_nbcurseur     OUT INTEGER,
							p_message       OUT VARCHAR2
				);



END pack_txrecup ;
/
CREATE OR REPLACE PACKAGE BODY pack_txrecup AS

PROCEDURE select_txrecup( 	p_action    IN VARCHAR2,
				p_annee IN VARCHAR2,
				p_filcode IN CHAR,
				p_userid    IN CHAR,
				p_curselect IN  OUT txrecup_CurType,
		                p_nbcurseur     OUT INTEGER,
				p_message       OUT VARCHAR2
                           ) IS

l_annee taux_recup.annee%TYPE;
l_filcode taux_recup.filcode%TYPE;

BEGIN

  p_message :='';
--On teste l'existence du taux de récup pour l'année et la filiale choisie
  BEGIN
	select annee, filcode into l_annee, l_filcode
	from taux_recup
	where annee=to_number(p_annee)
	and filcode=p_filcode;
  EXCEPTION
	WHEN NO_DATA_FOUND THEN
		l_annee := 0;
  END;


IF ((p_action='modifier') or  (p_action='supprimer')) and (l_annee=0)  THEN --Le taux n'existe pas
	-- Message Taux de récupération inexistant pour l'année
	pack_global.recuperer_message(20368,'%s1',p_annee, NULL, p_message);
	raise_application_error(-20368, p_message);

END IF;

OPEN p_curselect FOR 
select to_char(r.ANNEE) ANNEE,
        r.FILCODE FILCODE, 
	   to_char(r.TAUX) 	TAUX_RECUP,
	   decode(s.TAUX,null,'',to_char(s.TAUX)) 	TAUX_SAL,
	   decode(s.FLAGLOCK, null,0,s.FLAGLOCK)		FLAGLOCK
from taux_recup r, taux_charge_salariale s
where r.ANNEE = s.ANNEE (+)
and r.ANNEE = to_number(p_annee)
and r.FILCODE = p_filcode;

END select_txrecup;

PROCEDURE insert_txrecup(	p_annee IN VARCHAR2,
				p_filcode  IN  CHAR,
							p_taux_rec IN VARCHAR2,
							p_taux_sal IN VARCHAR2,
							p_nbcurseur     OUT INTEGER,
							p_message       OUT VARCHAR2
				) IS
BEGIN

	insert into taux_recup (annee, taux, filcode)
	values (to_number(p_annee),
		to_number(p_taux_rec),
		p_filcode);
	--KHA On renseigne le taux de charge salariale que pour SGPM
	IF (p_filcode = '01') THEN
	insert into taux_charge_salariale (annee,taux,flaglock)
	values (to_number(p_annee),
		    to_number(p_taux_sal),
			0);	
	END IF;
		
	
 p_message :='';
EXCEPTION
         WHEN OTHERS THEN
            raise_application_error( -20997,SQLERRM);   

END insert_txrecup;

PROCEDURE update_txrecup(	p_annee IN VARCHAR2,
				p_filcode  IN  CHAR,
							p_taux_rec IN VARCHAR2,
							p_taux_sal IN VARCHAR2,
							p_flaglock  IN  NUMBER,
							p_nbcurseur     OUT INTEGER,
							p_message       OUT VARCHAR2
				) IS
BEGIN
 p_message :='';

	update taux_recup set taux=to_number(p_taux_rec)
	where annee=to_number(p_annee)
	and filcode=p_filcode;
	--KHA On renseigne le taux de charge salariale que pour SGPM
	IF (p_filcode = '01') THEN
	update taux_charge_salariale 
	set taux=to_number(p_taux_sal),
		flaglock=decode(p_flaglock,9999999,0,p_flaglock+1)
	where annee=to_number(p_annee);
	END IF;

	IF SQL%NOTFOUND THEN  
         -- 'Accès concurrent'
         pack_global.recuperer_message(20999, NULL,NULL,NULL,p_message);  
         raise_application_error( -20999, p_message );
	END IF;
 EXCEPTION
         WHEN OTHERS THEN
            raise_application_error( -20997,SQLERRM);  
 


END update_txrecup;

PROCEDURE delete_txrecup(	p_annee IN VARCHAR2,
				p_filcode  IN  CHAR,
		  					p_flaglock  IN  NUMBER,
							p_nbcurseur     OUT INTEGER,
							p_message       OUT VARCHAR2
				) IS
BEGIN

	delete taux_recup 
	where annee=to_number(p_annee)
	and filcode = p_filcode;
	--KHA On renseigne le taux de charge salariale que pour SGPM
	IF (p_filcode = '01') THEN
	delete taux_charge_salariale
	where annee=to_number(p_annee)
	and flaglock=p_flaglock;
	END IF;	


 p_message :='';


END delete_txrecup;

END pack_txrecup ;
/
