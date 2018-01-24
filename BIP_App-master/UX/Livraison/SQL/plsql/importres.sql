-- -------------------------------------------------------------------

-- pack_verif_import

-- NCM

-- crée    le 01/08/2000
-- modifié le 27/03/2001 par NBM :création de update_import : sert à afficher dans la page d'import(aisegl.htm)
--				  la fin de l'import 
-- Package qui sert à déterminer la fin de l'import  et de l'export    

-- -------------------------------------------------------------------


CREATE OR REPLACE PACKAGE pack_verif_import AS

   PROCEDURE verif_import  (	p_bidon   IN  VARCHAR2,
				p_global  IN  VARCHAR2, 
                  		p_message OUT VARCHAR2
			);

  PROCEDURE update_import(p_userid IN VARCHAR2);


END pack_verif_import ;

/

CREATE OR REPLACE PACKAGE BODY pack_verif_import  AS 


PROCEDURE verif_import(	p_bidon   IN  VARCHAR2,
			p_global  IN  VARCHAR2, 
                        p_message OUT VARCHAR2
			) IS

      l_msg        VARCHAR2(512);
      l_coduser    VARCHAR2(255);
      l_res 	   number;

   BEGIN
      -- Initialiser le message retour
      p_message := '';

      -- On recupere le code user (idarpege) 
      l_coduser := pack_global.lire_globaldata(p_global).idarpege;
	

--insert into import_compta_res values (l_coduser,'global');
      -- Recherche du message de fin de traitement d'import
	select 1 into l_res
	from import_compta_res
	where userid=l_coduser
	and rownum=1
	and etat!='IMPORT EN COURS';

      
   EXCEPTION
	WHEN NO_DATA_FOUND THEN
		pack_global.recuperer_message(20447, NULL, NULL, NULL, l_msg);
         	raise_application_error(-20447,l_msg);
	WHEN OTHERS THEN 
		raise_application_error(-20997,SQLERRM);

END verif_import;
------------------------------------------------------------------------------------------------------
 PROCEDURE update_import(p_userid IN VARCHAR2) IS

  l_date varchar2(50);

  BEGIN
	select TO_CHAR(SYSDATE, 'DD/MM/YYYY')||' A '||TO_CHAR(SYSDATE,'HH24:MI:SS') into l_date
	from dual;

	update import_compta_res 
	set etat = 'IMPORT DU '||l_date||' TERMINE'
	where userid=p_userid;

  EXCEPTION
	WHEN OTHERS THEN 
		raise_application_error(-20997,SQLERRM);
  END update_import;
 

END pack_verif_import;

/

