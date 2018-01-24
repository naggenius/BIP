-- pack_liste_dpg_perimePL/SQL
-- 
-- cree le 09/01/2001 par NBM
--
-- Objet : Liste des DPG formant un centre de frais
-- Tables : struct_info
-- Pour le fichier HTML : dccfrais.htm
--
-- Modifié le 10/06/2003 par Pierre JOSSE : Nouveau format pour les codes MO
-- Modifié le 06/02/2007 par Emmanuel VINATIER : TD531 - Nouvelle procédure liste_dpg()
-- Modifié le 29/03/2007 par Emmanuel VINATIER : TD531 - Ajout du filtre pour ne recuperer que les DPG actif
-- Modifié le 23/04/2007 par Emmanuel VINATIER : TD531 - changement: filtre sur CODDEPPOLE et pu DPG
-- Modifié le19/11/2008 par ABA : TD711 - liste de tous les dpg en fonction du perimetre me
--
-- Attention le nom du package ne peut etre le nom
-- de la table...

CREATE OR REPLACE PACKAGE     pack_liste_dpg_perime AS

   PROCEDURE lister_dpg_perime(
				p_habilitation  IN VARCHAR2,
				p_userid  	IN VARCHAR2,
             			p_curseur 	IN OUT pack_liste_dynamique.liste_dyn
            			);

	PROCEDURE lister_dpg(
				p_coddir IN STRUCT_INFO.coddir%TYPE,
             			p_curseur 	IN OUT pack_liste_dynamique.liste_dyn
            			);

    PROCEDURE lister_total_dpg(
				        p_global IN VARCHAR2,
             			p_curseur 	IN OUT pack_liste_dynamique.liste_dyn
            			);



END pack_liste_dpg_perime;
/


CREATE OR REPLACE PACKAGE BODY     pack_liste_dpg_perime AS

PROCEDURE lister_dpg_perime(
				p_habilitation 	IN VARCHAR2,
				p_userid 	IN VARCHAR2,
             			p_curseur 	IN OUT pack_liste_dynamique.liste_dyn
            			)IS
l_habilitation varchar2(10);
BEGIN
    -- p_habilitation est la concaténation du code périmètre sur 5 caractères et du code habilitation
    l_habilitation:=substr(p_habilitation,6,4);

    IF l_habilitation='br' THEN
       		OPEN p_curseur FOR
	        SELECT distinct codbr as DPG,
	 		LPAD(codbr,2,0)||' '||libbr
		FROM branches b
		order by 1;

    ELSIF l_habilitation='dir' THEN
       		OPEN p_curseur FOR
		SELECT distinct d.coddir as DPG,
			LPAD(d.coddir,2,0)||' '||b.libbr||'/'||d.libdir
		FROM directions d,branches b
		where d.codbr=b.codbr
		order by 1;

    ELSIF l_habilitation='dpt' THEN
        	OPEN p_curseur FOR    --pour bien différencier les mêmes codes dep
		SELECT distinct s.topfer||lpad(s.coddep,3,'0')||lpad(s.coddir,2,'0') as DPG,
			LPAD(s.coddep,3,'0')||' '||b.libbr||'/'||d.libdir||'/'||s.sigdep||' '
		FROM struct_info s, directions d, branches b
		where s.coddir=d.coddir
		and d.codbr=b.codbr
		and s.topfer='O'
		order by 2;

    ELSIF l_habilitation='pole' THEN
        	OPEN p_curseur FOR
		SELECT distinct topfer||substr(lpad(s.codsg,7,'0'),1,5)||lpad(s.coddir,2,'0') as DPG,
	        SUBSTR(lpad(s.codsg,7,'0'),1,5)||' '||b.libbr||'/'||d.libdir||'/'||s.sigdep||'/'||s.sigpole||' '
		FROM struct_info s, directions d, branches b
		where s.coddir=d.coddir
		and d.codbr=b.codbr
		and s.topfer='O'
		order by 2;

    END IF;




   EXCEPTION
       WHEN OTHERS THEN
          raise_application_error(-20997, SQLERRM);

   END lister_dpg_perime;

   ----------------------

PROCEDURE lister_dpg(
				p_coddir IN STRUCT_INFO.coddir%TYPE,
             			p_curseur 	IN OUT pack_liste_dynamique.liste_dyn
            			)IS
l_habilitation varchar2(10);
BEGIN

      OPEN p_curseur FOR
	 SELECT
           coddeppole,
           coddeppole||' - '||sigdep||'/'||sigpole
      FROM STRUCT_INFO s
	  WHERE s.coddir=p_coddir
	  and s.topfer='O'
      GROUP BY coddeppole,sigdep,sigpole;


   EXCEPTION
       WHEN OTHERS THEN
          raise_application_error(-20997, SQLERRM);

   END lister_dpg;
   
   
    PROCEDURE lister_total_dpg(
				        p_global IN VARCHAR2,
             			p_curseur 	IN OUT pack_liste_dynamique.liste_dyn
            			) IS
    
l_perimetre  	 varchar2(1000);
l_userbip 	 varchar2(7);
pos_bddpg	 integer;
  pos_bddpg_suiv integer;
  nb_bddpg	 integer;
  l_perimTermine boolean;
    codbddpg	VARCHAR2(25);
    l_coddir  VARCHAR2(2);
    l_codbr  VARCHAR2(2);
    l_departement VARCHAR2(3);
    l_pole VARCHAR2(2);
    l_groupe VARCHAR2(2);
    l_codsg VARCHAR2(7);
    compteur NUMBER;
    requete_special VARCHAR2(3);


 CURSOR curseur1(p_codsg VARCHAR2, p_coddir NUMBEr ) IS
    select   codsg from struct_info
                where
                topfer = 'O'
                and lpad(codsg,7,0) like p_codsg ||'%'
                and coddir = p_coddir ;

 CURSOR curseur2 IS
    select   codsg from struct_info
                where
                topfer = 'O';
                
             
 
 CURSOR curseur3(p_codbr VARCHAR2 ) IS
        select   si.codsg from struct_info si, directions d
                where
                si.topfer = 'O'
                and si.coddir = d.coddir
                and d.codbr = p_codbr;                
                

BEGIN

 l_perimetre := pack_global.lire_globaldata(p_global).perime;
 l_userbip := pack_global.lire_globaldata(p_global).idarpege ;
 requete_special := 'NON';

    -- On initialise les paramètrers de la boucle while comptant le nombre de BDDPG du périmètre
	pos_bddpg := 0;
	nb_bddpg := 0;
	pos_bddpg_suiv := 0;
	l_perimTermine := false;

	-- Test si perimetre ME est vide on ne va pas plus loin
	if (l_perimetre is null or trim(l_perimetre) = '') then
		l_perimTermine := true;
	end if ;

compteur := 1;
 	-- Tant qu'il y a des bddpg dans le périmètre, on tourne.
	    WHILE NOT (l_perimTermine) LOOP

	  --On met à jour les paramètres identifiant les BDDPG du périmètre ME.
	  pos_bddpg := pos_bddpg_suiv + 1;
	  nb_bddpg := nb_bddpg + 1;
	  pos_bddpg_suiv := INSTR(l_perimetre, ',', 1, nb_bddpg);

	  IF pos_bddpg_suiv = 0 THEN
	     l_perimTermine := true;
	  END IF;
      
      --On met à jour le BDDPG courant
	  --Si c'est le dernier, on prend la longueur de chaîne du périmètre - la position de la virgule
	  --Sinon on prend la position du suivant - la position de l'actuel
	  IF l_perimTermine THEN
	     codbddpg := SUBSTR(l_perimetre, pos_bddpg, LENGTH(l_perimetre)-pos_bddpg + 1);
	  ELSE
	     codbddpg := SUBSTR(l_perimetre, pos_bddpg, pos_bddpg_suiv-pos_bddpg);
	  END IF;
      
    l_codbr   := substr(codbddpg,1,2);
    l_coddir  := substr(codbddpg,3,2);
    l_departement := substr(codbddpg,5,3);
    l_pole := substr(codbddpg,8,2);
    l_groupe := substr(codbddpg,10,2);
    l_codsg:=  substr(codbddpg,5,7);
    
    if (l_groupe != '00') then
         FOR curseur IN curseur1(l_codsg, l_coddir)  LOOP
             insert into tmp_liste_dpg (userid, codsg) values (l_userbip, lpad(curseur.codsg,7,0));
         end LOOP;
    elsif (l_pole != '00') then
            l_codsg := substr(l_codsg,1,5);
            FOR curseur IN curseur1(l_codsg, l_coddir)  LOOP
             insert into tmp_liste_dpg (userid, codsg) values (l_userbip, lpad(curseur.codsg,7,0));
            end LOOP; 
        elsif  (l_departement != '000') then
                 l_codsg := substr(l_codsg,1,3);
                FOR curseur IN curseur1(l_codsg, l_coddir)  LOOP
                    insert into tmp_liste_dpg (userid, codsg) values (l_userbip, lpad(curseur.codsg,7,0));
                end LOOP;
             elsif (l_coddir != '00') then
                    l_codsg    :=  '';
                    FOR curseur IN curseur1(l_codsg, l_coddir)  LOOP
                        insert into tmp_liste_dpg (userid, codsg) values (l_userbip, lpad(curseur.codsg,7,0));
                     end LOOP;
                  elsif (l_codbr != '00') then
                     FOR curseur IN curseur3(l_codbr)  LOOP
                        insert into tmp_liste_dpg (userid, codsg) values (l_userbip, lpad(curseur.codsg,7,0));
                     end LOOP;
                     else
                         FOR curseur IN curseur2 LOOP
                         insert into tmp_liste_dpg (userid, codsg) values (l_userbip, lpad(curseur.codsg,7,0));
                     end LOOP;
     end if;                   
                
    
    
    
        
    
    compteur:= compteur+1;
   
   end LOOP;
   
   open p_curseur for
    select tmp.codsg id, tmp.codsg libelle from tmp_liste_dpg tmp where tmp.userid = l_userbip

    ORDER BY id;

    
    
   delete from tmp_liste_dpg where userid = l_userbip;
   

  EXCEPTION
       WHEN OTHERS THEN
          raise_application_error(-20997, SQLERRM);
          



END lister_total_dpg;

END pack_liste_dpg_perime;
/


