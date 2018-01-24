-- APPLICATION ISAC
-- -------------------------------------
-- pack_isac_affectation PL/SQL
-- 
-- Cr�� le 04/04/2002 par NBM
-- Modifi� le 29/07/2003 par NBM : suppression des #
-- Modifi� le 03/03/2004 par PJO : passage des PID � 4 caract�res.
-- 10/02/2005 par MMC : fiche 131
--			- ajout controle pour empecher la suppression etapes ayant des sous taches
--			  ayant du consomme sur l annee courante
--			- possibilite d intervenir sur les annees precedentes
-- Package utilis�e pour les affectations ressources/sous-t�ches
--
--*******************************************************************
--
-- Attention le nom du package ne peut etre le nom
-- de la table...
-- Modifi� le 21/02/2013 par SGA : HP PPM 31695 Gestion de multi sous-taches

create or replace
PACKAGE       "PACK_ISAC_AFFECTATION" AS

TYPE t_array IS TABLE OF VARCHAR2(3900)
   INDEX BY BINARY_INTEGER;

FUNCTION SPLIT2ARRAY (p_in_string VARCHAR2, p_delim VARCHAR2) RETURN t_array;
 
   
PROCEDURE insert_affectation (	p_ident		IN VARCHAR2,
				p_pid		IN isac_affectation.pid%TYPE,
				p_sous_tache 	IN VARCHAR2,
				p_userid     	IN VARCHAR2,
				p_nbcurseur    	OUT INTEGER,
                      		p_message    	OUT VARCHAR2
			);


PROCEDURE select_affectation (	p_ident		IN VARCHAR2,
				p_pid		IN isac_affectation.pid%TYPE,
				p_userid     	IN VARCHAR2,
				p_ressourceout  OUT VARCHAR2,
				p_ligneout	OUT VARCHAR2,
				p_nbcurseur    	OUT INTEGER,
                      		p_message    	OUT VARCHAR2
			);

PROCEDURE delete_affectation ( 	p_ident		IN VARCHAR2,
				p_sous_tache	IN VARCHAR2,
				p_userid     	IN VARCHAR2,
				p_nbcurseur    	OUT INTEGER,
                      		p_message    	OUT VARCHAR2
			);
PROCEDURE select_stressource (	p_ident		IN VARCHAR2,
				p_userid     	IN VARCHAR2,
				p_ressourceout  OUT VARCHAR2,
				p_nbcurseur    	OUT INTEGER,
                      		p_message    	OUT VARCHAR2
			);
      
      
      
END pack_isac_affectation;
/
create or replace
PACKAGE BODY       "PACK_ISAC_AFFECTATION" AS
--*************************************************************************************************
-- Proc�dure insert_affectation
--
-- Permet d'affecter une sous-tache � la ressource
--
-- Appel�e dans la page iaffect.htm
--
-- ************************************************************************************************

PROCEDURE insert_affectation (	p_ident		IN VARCHAR2,
				p_pid		IN isac_affectation.pid%TYPE,
				p_sous_tache 	IN VARCHAR2,
				p_userid     	IN VARCHAR2,
				p_nbcurseur    	OUT INTEGER,
                      		p_message    	OUT VARCHAR2
			) IS
l_pos1 NUMBER(10);
l_pos2 NUMBER(10);
l_etape NUMBER(10);
l_tache NUMBER(10);
l_sous_tache VARCHAR2(5000);
libstache VARCHAR2(35);
nb_sous_tache INTEGER := 0;
nb_sous_tache_reel INTEGER;
verif INTEGER;
list_sous_tache t_array;
BEGIN
  p_nbcurseur := 0;
  p_message:='';

--******************************************************
-- PPM 31695 : Ajout de la gestion de multi sous-t�ches
--******************************************************

-- appel de la fonction SPLIT2ARRAY qui va permettre de cr�er une table temporaire
-- qui contiendra la liste des "etape-tache-sous tache" separ� par un /
list_sous_tache := SPLIT2ARRAY (p_sous_tache,'/');

-- R�cup�ration  du nombre de lignes a ins�rer
nb_sous_tache:=list_sous_tache.count;

-- par d�faut on commence par initialiser le nombre de sous-taches r�ellement ins�rer en base par le nombre
-- de sous-taches total
nb_sous_tache_reel := nb_sous_tache;

  
for i in 1..list_sous_tache.count loop
  
  -- list_sous_tache(i) est de la forme "etape-tache-sous_tache"
	l_pos1 := INSTR(list_sous_tache(i),'-',1,1);
	l_pos2 := INSTR(list_sous_tache(i),'-',1,2);
	l_etape := SUBSTR(list_sous_tache(i),1,l_pos1-1);
	l_tache := SUBSTR(list_sous_tache(i),l_pos1+1,l_pos2-l_pos1-1);
	l_sous_tache := SUBSTR(list_sous_tache(i),l_pos2+1,(LENGTH(list_sous_tache(i))-l_pos2+1));
  
  verif := 0;
  select count(*) into verif from isac_affectation
  where ident = to_number(p_ident)
  and pid = p_pid
  and etape = to_number(l_etape)
  and tache = to_number(l_tache)
  and sous_tache = to_number(l_sous_tache);
  if verif = 0 then 
      insert into isac_affectation (ident,pid,etape,tache,sous_tache)
      values (to_number(p_ident),p_pid,to_number(l_etape),to_number(l_tache),to_number(l_sous_tache));
      commit;
  else nb_sous_tache_reel := nb_sous_tache_reel-1;
  end if;

end loop;

--Gestion des messages retourn�es par la proc�dure :
-- trois messages diff�rents pourront �tre retourn�s :
-- nb_sous_tache_reel = nb_sous_tache >> Toutes les sous-t�ches s�lectionn�es ont �t� affect�es � la ressource %s1
--  nb_sous_tache_reel != nb_sous_tache >> Les sous-t�ches s�lectionn�es qui n''�taient pas d�j� affect�es � cette ressource %s1, lui ont �t� affect�es
--  nb_sous_tache_reel = 0 >> Aucune affectation n''a �t� effectu�e car toutes les sous-t�ches s�lectionn�es sont d�j� affect�es � cette ressource !

if nb_sous_tache_reel = 0 then 
pack_isac.recuperer_message(20035, null,null,null, p_message);
elsif nb_sous_tache_reel != nb_sous_tache then 
pack_isac.recuperer_message(20034, '%s1', p_ident,NULL, p_message);
elsif nb_sous_tache_reel = nb_sous_tache  then
pack_isac.recuperer_message(20033, '%s1', p_ident,NULL, p_message);
end if;

END insert_affectation;

--*************************************************************************************************
-- Proc�dure select_affectation
--
-- Permet de v�rifier que le code ressource, la ligne BIP et sa cl� existent et
-- d'afficher les donn�es de la ressource et de la ligne BIP
-- Appel�e dans la page icaffect.htm
--
-- ************************************************************************************************
PROCEDURE select_affectation (	p_ident		IN VARCHAR2,
				p_pid		IN isac_affectation.pid%TYPE,
				p_userid     	IN VARCHAR2,
				p_ressourceout  OUT VARCHAR2,
				p_ligneout	OUT VARCHAR2,
				p_nbcurseur    	OUT INTEGER,
                      		p_message    	OUT VARCHAR2
			) IS
l_rnom VARCHAR2(100);

BEGIN
  p_nbcurseur := 0;
  p_message:='';
	--V�rifier l'existence du code ressource
	BEGIN

		select rnom||' '||rprenom into l_rnom
		from ressource
		where ident=to_number(p_ident);

	p_ressourceout := l_rnom||' - '||p_ident;

		select PID||' - '||PNOM into p_ligneout
		from LIGNE_BIP where PID=p_pid;

	EXCEPTION
	WHEN NO_DATA_FOUND THEN
		-- Message : ressource inexistante
		pack_global.recuperer_message(20131, '%s1', p_ident,'IDENT', p_message);
        		raise_application_error(-20131,p_message);
	END;


END select_affectation;
--*************************************************************************************************
-- Proc�dure delete_affectation
--
-- Permet de supprimer l'affectation de la sous-t�che � la ressource et les consomm�s associ�s
-- Appel�e dans la page ilaffect.htm � partir du bouton "Supprimer"
--
-- ************************************************************************************************
PROCEDURE delete_affectation ( 	p_ident		IN VARCHAR2,
				p_sous_tache	IN VARCHAR2,
				p_userid     	IN VARCHAR2,
				p_nbcurseur    	OUT INTEGER,
                      		p_message    	OUT VARCHAR2
			) IS
l_pos1 NUMBER(10);
l_pos2 NUMBER(10);
l_pos3 NUMBER(10);
l_pid ligne_bip.pid%TYPE;
l_etape NUMBER(10);
l_tache NUMBER(10);
l_sous_tache NUMBER(10);
l_libstache VARCHAR2(50);
l_rnom VARCHAR2(30);
l_moismens datdebex.moismens%TYPE;
l_adatestatut ligne_bip.adatestatut%TYPE;
l_pid_ff ligne_bip.pid%TYPE;
l_anneecourante VARCHAR2(4);
l_conso NUMBER;
nb_sous_tache INTEGER := 0;
nb_sous_tache_reel INTEGER;
verif_conso INTEGER;
list_sous_tache t_array;

BEGIN
  p_nbcurseur := 0;
  p_message:='';

  --on recupere l annee courante
  	select to_char(datdebex,'YYYY') into  l_anneecourante
        from datdebex;
        
--******************************************************
-- PPM 31695 : Ajout de la gestion de multi sous-t�ches
--******************************************************

-- appel de la fonction SPLIT2ARRAY qui va permettre de cr�er une table temporaire
-- qui contiendra la liste des "pid-etape-tache-sous tache" separ� par un /
list_sous_tache := SPLIT2ARRAY (p_sous_tache,'/');

-- R�cup�ration  du nombre de lignes a ins�rer
nb_sous_tache:=list_sous_tache.count;      

--Initialisation du boolean de v�rification de consomm� de l'ensemble des sous-taches
verif_conso := 0;
-- On commence par v�rifier qu'il n'existe pas de consomm� sur l'une des sous t�che
for i in 1..list_sous_tache.count loop

  -- p_sous_tache est de la forme "pid-etape-tache-sous_tache"
	l_pos1 := INSTR(list_sous_tache(i),'-',1,1);
	l_pos2 := INSTR(list_sous_tache(i),'-',1,2);
	l_pos3 := INSTR(list_sous_tache(i),'-',1,3);
	l_pid := SUBSTR(list_sous_tache(i),1,l_pos1-1);
	l_etape := TO_NUMBER( SUBSTR(list_sous_tache(i),l_pos1+1,l_pos2-l_pos1-1));
	l_tache := TO_NUMBER( SUBSTR(list_sous_tache(i),l_pos2+1,l_pos3-l_pos2-1));
	l_sous_tache :=TO_NUMBER( SUBSTR(list_sous_tache(i),l_pos3+1,LENGTH(list_sous_tache(i))-l_pos3+1));
  
  --on verifie qu il n y a pas de consomme sur l annee
  SELECT  nvl(sum(c.cusag),0) INTO l_conso
 	FROM isac_consomme c,isac_affectation a
 	WHERE c.sous_tache(+)=a.sous_tache
 	AND a.sous_tache=l_sous_tache
 	AND to_char(c.cdeb,'YYYY')=l_anneecourante
 	AND a.ident=to_number(p_ident)
 	AND a.ident=c.ident;
  
  if l_conso<>0 then
  verif_conso := verif_conso+1;
  end if;

end loop;
-- si il n'y a aucun consomm� sur l'ensemble des sous-taches sur l'ann�e, on peut alors supprim�
--les affectations de chaque sous-tache et les consomm�s qui ne sont pas sur l'ann�e (existant)
if verif_conso = 0 then
for i in 1..list_sous_tache.count loop
  -- p_sous_tache est de la forme "pid-etape-tache-sous_tache"
	l_pos1 := INSTR(list_sous_tache(i),'-',1,1);
	l_pos2 := INSTR(list_sous_tache(i),'-',1,2);
	l_pos3 := INSTR(list_sous_tache(i),'-',1,3);
	l_pid := SUBSTR(list_sous_tache(i),1,l_pos1-1);
	l_etape := TO_NUMBER( SUBSTR(list_sous_tache(i),l_pos1+1,l_pos2-l_pos1-1));
	l_tache := TO_NUMBER( SUBSTR(list_sous_tache(i),l_pos2+1,l_pos3-l_pos2-1));
	l_sous_tache :=TO_NUMBER( SUBSTR(list_sous_tache(i),l_pos3+1,LENGTH(list_sous_tache(i))-l_pos3+1));
  

	delete isac_consomme
	where ident=to_number(p_ident)
	and sous_tache=l_sous_tache;

	delete isac_affectation
	where ident=to_number(p_ident)
	and sous_tache=l_sous_tache;

  commit;
end loop;
end if;

--Gestion des messages retourn�es par la proc�dure :
-- trois messages diff�rents pourront �tre retourn�s :
-- verif_conso > 0 >> La suppression d''affectation est impossible pour au moins 1 des sous-t�ches s�lectionn�es, car il existe du consomm� !
--  nb_sous_tache_reel != nb_sous_tache >> Les sous-t�ches s�lectionn�es qui n''�taient pas d�j� affect�es � cette ressource %s1, lui ont �t� affect�es
--  nb_sous_tache_reel = 0 >> Aucune affectation n''a �t� effectu�e car toutes les sous-t�ches s�lectionn�es sont d�j� affect�es � cette ressource !

-- R�cup�ration du nom de la ressource
select trim(rnom) into l_rnom
from ressource
where ident=to_number(p_ident);

-- R�cup�ration du libell� de la sous-tache
select acst||'-'||asnom into l_libstache
from isac_sous_tache
where sous_tache=l_sous_tache;

if verif_conso > 0 then
  pack_isac.recuperer_message(20036, NULL,NULL, NULL, p_message);
elsif  (verif_conso = 0 and nb_sous_tache > 1) then
  pack_isac.recuperer_message(20037, '%s1', p_ident || ' - ' || l_rnom , null,p_message);
elsif  (verif_conso = 0 and nb_sous_tache = 1) then
  --pack_isac.recuperer_message(20038, '%s1', 'La sous-t�che '||l_libstache||' n''est plus affect�e � la ressource '||p_ident||' - '||l_rnom||' !', NULL, p_message);
  pack_isac.recuperer_message(20038, '%s1',l_libstache,'%s2',p_ident ||' - '||l_rnom,NULL, p_message);
end if;

END delete_affectation;

--*************************************************************************************************
-- Proc�dure select_stressource
--
-- Permet de v�rifier l'existence du code ressource et d'afficher les donn�es relatives � la ressource
-- Appel�e dans la page igaffect.htm
--
-- ************************************************************************************************
PROCEDURE select_stressource (	p_ident		IN VARCHAR2,
				p_userid     	IN VARCHAR2,
				p_ressourceout  OUT VARCHAR2,
				p_nbcurseur    	OUT INTEGER,
                      		p_message    	OUT VARCHAR2
			) IS

l_rnom VARCHAR2(50);
l_exist NUMBER;
BEGIN
  p_nbcurseur := 0;
  p_message:='';

  --V�rifier que la ressource existe dans la BIP
	select rnom||' '||rprenom into l_rnom
	from ressource
	where ident=to_number(p_ident);

	p_ressourceout := l_rnom||' - '||p_ident;

	--V�rifier si la ressource est d�j� affect�e au moins � une sous-t�che
	Begin
	select 1 into l_exist
	from isac_affectation
	where ident= to_number(p_ident)
	and rownum=1;

	Exception
	WHEN NO_DATA_FOUND THEN
	-- Aucune sous-t�che pour la ressource
		pack_isac.recuperer_message( 20005 , NULL, NULL, NULL,  p_message);
         	raise_application_error(-20005 , p_message);

	End;

EXCEPTION
	WHEN NO_DATA_FOUND THEN
	-- Message : ressource inexistante
	pack_global.recuperer_message(20131, '%s1', p_ident, NULL, p_message);
        raise_application_error(-20131,p_message);

END select_stressource;

FUNCTION SPLIT2ARRAY (p_in_string VARCHAR2, p_delim VARCHAR2) RETURN t_array
   IS
  
      i       number :=0;
      pos     number :=0;
      lv_str  varchar2(5000) := p_in_string;
     
   strings t_array;
  
   BEGIN
  
      -- determine first chuck of string 
      pos := instr(lv_str,p_delim,1,1);
      IF pos = 0 THEN
          strings(1) := lv_str;
      END IF ;
  
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
     
   END SPLIT2ARRAY;


END pack_isac_affectation;
/