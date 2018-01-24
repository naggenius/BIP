-- pack_liste_dynamique PL/SQL
--
-- Equipe SOPRA
--
-- Cree le 05/03/1999
--
-- Objet : Definit le record d'une liste dynamique
--
--******************************************************************
--
-- Attention le nom du package ne peut etre le nom
-- de la table...

CREATE OR REPLACE PACKAGE pack_liste_dynamique AS

-- dimensionne pour id nom de var <= 50
--                  libelle ligne de 120 caracteres 
-- inutile d'avoir plus de de 120 car on ne doit pas avoir de barre
-- de scrolling horizontale

TYPE liste_dynamique IS RECORD ( id      VARCHAR2(50),
                                 libelle VARCHAR2(120)
                               );

TYPE liste_dyn IS REF CURSOR RETURN liste_dynamique;


TYPE liste_dynamique_2 IS RECORD ( id      VARCHAR2(50),
                                 libelle VARCHAR2(120),
                                 date_tri DATE
                               );

TYPE liste_dyn_2 IS REF CURSOR RETURN liste_dynamique_2;


-- liste des 12 derniers mois
PROCEDURE lister_12_mois( p_curseur IN OUT liste_dyn );


-- liste des 12 derniers mois avec tout
PROCEDURE lister_12_mois_tout( p_curseur IN OUT liste_dyn_2 );

	
END pack_liste_dynamique;
/

CREATE OR REPLACE PACKAGE BODY pack_liste_dynamique AS


-- liste des 12 derniers mois
PROCEDURE lister_12_mois( p_curseur IN OUT liste_dyn ) IS
BEGIN

      OPEN p_curseur FOR
			select to_char(c.CALANMOIS,'MM/YYYY') , to_char(c.CALANMOIS, 'Month YYYY') 
		    from calendrier c
		   where c.CALANMOIS between add_months(sysdate,-12) and sysdate
		   order by c.CALANMOIS desc
		   ;

END lister_12_mois;

-- liste des 12 derniers mois avec "Tout"
PROCEDURE lister_12_mois_tout( p_curseur IN OUT liste_dyn_2 ) IS
BEGIN

      OPEN p_curseur FOR
	  	  select '01/2000','Tout', to_date('01/12/2099') from dual
		  union
			select to_char(c.CALANMOIS,'MM/YYYY') , to_char(c.CALANMOIS, 'Month YYYY') , c.calanmois
		    from calendrier c
		   where c.CALANMOIS between add_months(sysdate,-12) and sysdate
		   order by 3 desc
		   ;

END lister_12_mois_tout;

END pack_liste_dynamique;
/
