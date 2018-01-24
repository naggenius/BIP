CREATE OR REPLACE PACKAGE PACK_MEGA IS

  -- -----------------------------------------------------------------------
  -- Nom        : select_export_DPG
  -- Auteur     : Equipe STERIA
  -- Description : extraction des DPG,
  -- Paramètres : p_chemin_fichier IN VARCHAR2  : Chemin où sera exporté le fichier
  --			  p_nom_fichier    IN VARCHAR2  : Nom du fichier
  -- ------------------------------------------------------------------------

  PROCEDURE select_export_DPG( p_chemin_fichier  IN VARCHAR2, p_nom_fichier   IN VARCHAR2) ;
  

END PACK_MEGA;
/


CREATE OR REPLACE PACKAGE BODY "PACK_MEGA" IS

	-- -------------------
	-- Gestions exceptions
	-- -------------------
	CALLEE_FAILED exception;
	pragma exception_init( CALLEE_FAILED, -20000 );
	CALLEE_FAILED_ID     number := -20000;   -- pour propagation dans pile d'appel
	TRCLOG_FAILED_ID     number := -20001;   -- problème : erreur dans la gestion d'erreur !
	ERR_FONCTIONNELLE_ID number := -20002;   -- pour provoquer erreur alors que Oracle OK
	CONSTRAINT_VIOLATION exception;          -- pour clause when
	pragma exception_init( CONSTRAINT_VIOLATION, -2291 ); -- typiquement : clé étrangère
	CALLEE_FAILED exception;
	pragma exception_init( CALLEE_FAILED, -20000 );



-- ======================================================================
--   SELECT_EXPORT_DPG
-- ======================================================================
PROCEDURE SELECT_EXPORT_DPG(p_chemin_fichier IN VARCHAR2,
                        p_nom_fichier    IN VARCHAR2) IS


CURSOR curs_DPG IS
SELECT 	nvl(to_char(codsg),'0')	codsg, 
	nvl(libdsg,' ')	libdsg,
	nvl(topfer,' ')	topfer,
	nvl(substr(to_char(centractiv),1,6),'0') centractiv,
	nvl(to_char(cafi),'0') cafi,
	nvl(filcode,' ') filcode,
	nvl(top_diva,' ') top_diva_lignes,
	nvl(top_diva_int,' ')	top_diva_intervenants,
	nvl(gnom, ' ') responsable,
    matricule
FROM      STRUCT_INFO
WHERE     codsg > 1
ORDER BY to_number(codsg) asc;

L_HFILE	  						UTL_FILE.FILE_TYPE;
L_RETCOD						NUMBER;
l_msg  VARCHAR2(1024);

	BEGIN

		-----------------------------------------------------
		-- Génération du fichier.
		-----------------------------------------------------
		Pack_Global.INIT_WRITE_FILE( p_chemin_fichier, p_nom_fichier, l_hfile);
    Pack_Global.WRITE_STRING( l_hfile, 
		'CODSG;LIBDSG;TOPFER;CENTRACTIV;CAFI;FILCODE;TOP_DIVA_LIGNES;TOP_DIVA_INTERVENANTS;' ||
		'RESPONSABLE;MATRICULE;'); 
    
	  FOR cur_enr IN curs_DPG
      LOOP
        Pack_Global.WRITE_STRING( l_hfile,
        cur_enr.codsg 					|| ';' ||
        cur_enr.libdsg					|| ';' ||
        cur_enr.topfer					|| ';' ||
        cur_enr.centractiv				|| ';' ||    
        cur_enr.cafi					|| ';' ||
        cur_enr.filcode					|| ';' ||
        cur_enr.top_diva_lignes			|| ';' ||
        cur_enr.top_diva_intervenants	|| ';' ||
        cur_enr.responsable				|| ';' ||
		cur_enr.matricule);
		
      END LOOP;

	Pack_Global.CLOSE_WRITE_FILE(l_hfile);

	EXCEPTION
  		WHEN OTHERS THEN
   		Pack_Global.recuperer_message(20401, NULL, NULL, NULL, l_msg);
   		RAISE_APPLICATION_ERROR(-20401, l_msg);

END SELECT_EXPORT_DPG;

END PACK_MEGA;
/
