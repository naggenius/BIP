CREATE OR REPLACE PACKAGE PACK_PEPSI is

  /* */
  PROCEDURE export_dossier_projet(p_chemin_fichier VARCHAR2, p_nom_fichier VARCHAR2);

  /* */
  PROCEDURE export_dossier_projet_copi(p_chemin_fichier VARCHAR2, p_nom_fichier VARCHAR2);

  /* */
  PROCEDURE export_proj_info(p_chemin_fichier VARCHAR2, p_nom_fichier VARCHAR2);

  /* */
  PROCEDURE export_appli_projet(p_chemin_fichier VARCHAR2, p_nom_fichier VARCHAR2);

  /* */
  PROCEDURE export_dpg(p_chemin_fichier VARCHAR2, p_nom_fichier VARCHAR2);

end PACK_PEPSI;
/


CREATE OR REPLACE package body  PACK_PEPSI IS


PROCEDURE export_dossier_projet(p_chemin_fichier IN VARCHAR2, p_nom_fichier IN VARCHAR2) IS
-- curseur de creation du fichier DOSSIER_PROJET.DATE.csv
CURSOR csr_dossier_projet IS select dp.DPCODE code, dp.DPLIB lib, dp.ACTIF act from dossier_projet dp;
      l_msg  VARCHAR2(1024);
      l_hfile UTL_FILE.FILE_TYPE;
  BEGIN

        Pack_Global.INIT_WRITE_FILE( p_chemin_fichier, p_nom_fichier, l_hfile);
        Pack_Global.WRITE_STRING( l_hfile,
                'DPCODE'            || ';' ||
                'DPLIB'             || ';' ||
                'ACTIF'
                );
        FOR rec_dossier_projet IN csr_dossier_projet LOOP
            Pack_Global.WRITE_STRING( l_hfile,
                rec_dossier_projet.code            || ';' ||
                rec_dossier_projet.lib             || ';' ||
                rec_dossier_projet.act
                );
        END LOOP;
        Pack_Global.CLOSE_WRITE_FILE(l_hfile);

    EXCEPTION
           WHEN OTHERS THEN
            Pack_Global.recuperer_message(20401, NULL, NULL, NULL, l_msg);
            RAISE_APPLICATION_ERROR(-20401, l_msg);
end export_dossier_projet;




PROCEDURE export_dossier_projet_copi(p_chemin_fichier IN VARCHAR2, p_nom_fichier IN VARCHAR2) IS
-- curseur de creation du fichier DOSSIER_PROJET_COPI.DATE.csv
CURSOR csr_dossier_projet_copi IS select DP_COPI, LIBELLE, DPCODE from dossier_projet_copi;
      l_msg  VARCHAR2(1024);
      l_hfile UTL_FILE.FILE_TYPE;
  BEGIN
        Pack_Global.INIT_WRITE_FILE( p_chemin_fichier, p_nom_fichier, l_hfile);
        Pack_Global.WRITE_STRING( l_hfile,
                'DP_COPI'             || ';' ||
                'LIBELLE'             || ';' ||
                'DPCODE'
                );
        FOR rec_dossier_projet_copi IN csr_dossier_projet_copi LOOP
            Pack_Global.WRITE_STRING( l_hfile,
                rec_dossier_projet_copi.dp_copi             || ';' ||
                rec_dossier_projet_copi.libelle             || ';' ||
                rec_dossier_projet_copi.dpcode
                );
        END LOOP;
        Pack_Global.CLOSE_WRITE_FILE(l_hfile);
    EXCEPTION
           WHEN OTHERS THEN
            Pack_Global.recuperer_message(20401, NULL, NULL, NULL, l_msg);
            RAISE_APPLICATION_ERROR(-20401, l_msg);
end export_dossier_projet_copi;




PROCEDURE export_proj_info(p_chemin_fichier IN VARCHAR2, p_nom_fichier IN VARCHAR2) IS
-- curseur de creation du fichier PROJ_INFO.DATE.csv
CURSOR csr_proj_info IS select ICPI, ILIBEL, STATUT, DATSTATUT, ICODPROJ, DP_COPI from proj_info;
      l_msg  VARCHAR2(1024);
      l_hfile UTL_FILE.FILE_TYPE;
  BEGIN
        Pack_Global.INIT_WRITE_FILE( p_chemin_fichier, p_nom_fichier, l_hfile);
        Pack_Global.WRITE_STRING( l_hfile,
                'ICPI'              || ';' ||
                'ILIBEL'              || ';' ||
                'STATUT'              || ';' ||
                'DATSTATUT'              || ';' ||
                'ICODPROJ'              || ';' ||
                'DP_COPI'
                );
        FOR rec_proj_info IN csr_proj_info LOOP
            Pack_Global.WRITE_STRING( l_hfile,
                rec_proj_info.icpi              || ';' ||
                rec_proj_info.ilibel             || ';' ||
                rec_proj_info.statut              || ';' ||
                rec_proj_info.datstatut             || ';' ||
                rec_proj_info.icodproj             || ';' ||
                rec_proj_info.dp_copi
                );
        END LOOP;
        Pack_Global.CLOSE_WRITE_FILE(l_hfile);
    EXCEPTION
           WHEN OTHERS THEN
            Pack_Global.recuperer_message(20401, NULL, NULL, NULL, l_msg);
            RAISE_APPLICATION_ERROR(-20401, l_msg);
end export_proj_info;




PROCEDURE export_appli_projet(p_chemin_fichier IN VARCHAR2, p_nom_fichier IN VARCHAR2) IS
-- curseur de creation du fichier APPLI_PROJET.DATE.csv
CURSOR csr_appli_projet IS
SELECT P.ICPI codp, P.ILIBEL libp ,AP.AIRT coda, AP.ALIBEL liba FROM PROJ_INFO P, LIGNE_BIP L,APPLICATION AP
      WHERE
            P.ICPI = L.ICPI AND
            P.ICPI not in ('P0000','P9000','P9999','P9995','P9997') AND
            AP.AIRT not in ('A0000','A9000','A9995','A9997','A9999') AND
            L.AIRT = AP.AIRT
            group by P.ICPI, P.ILIBEL, AP.AIRT, AP.ALIBEL
            order by P.ICPI, AP.AIRT;
      l_msg  VARCHAR2(1024);
      l_hfile UTL_FILE.FILE_TYPE;
  BEGIN
        Pack_Global.INIT_WRITE_FILE( p_chemin_fichier, p_nom_fichier, l_hfile);
        Pack_Global.WRITE_STRING( l_hfile,
                'ICPI'              || ';' ||
                'ILIBEL'             || ';' ||
                'AIRT'             || ';' ||
                'ALIBEL'
                );
        FOR rec_appli_projet IN csr_appli_projet LOOP
            Pack_Global.WRITE_STRING( l_hfile,
                rec_appli_projet.codp              || ';' ||
                rec_appli_projet.libp             || ';' ||
                rec_appli_projet.coda             || ';' ||
                rec_appli_projet.liba
                );
        END LOOP;
        Pack_Global.CLOSE_WRITE_FILE(l_hfile);
    EXCEPTION
           WHEN OTHERS THEN
            Pack_Global.recuperer_message(20401, NULL, NULL, NULL, l_msg);
            RAISE_APPLICATION_ERROR(-20401, l_msg);
end export_appli_projet;




PROCEDURE export_dpg(p_chemin_fichier IN VARCHAR2, p_nom_fichier IN VARCHAR2) IS
-- curseur de creation du fichier DPG.DATE.csv
CURSOR csr_dpg IS
SELECT S.CODSG sgcode, S.LIBDSG sglib, S.CODDIR dircode, D.LIBDIR dirlib, B.CODBR brcode, B.LIBBR brlib, S.TOPFER fertop, S.MATRICULE mat, S.GNOM nomg
      FROM STRUCT_INFO S,DIRECTIONS D,BRANCHES B
      WHERE
      S.CODDIR=D.CODDIR and
      D.CODBR=B.CODBR;
      l_msg  VARCHAR2(1024);
      l_hfile UTL_FILE.FILE_TYPE;
  BEGIN
        Pack_Global.INIT_WRITE_FILE( p_chemin_fichier, p_nom_fichier, l_hfile);
        Pack_Global.WRITE_STRING( l_hfile,
                'CODSG'              || ';' ||
                'LIBDSG'             || ';' ||
                'CODDIR'              || ';' ||
                'LIBDIR'             || ';' ||
                'CODBR'              || ';' ||
                'LIBBR'             || ';' ||
                'TOPFER'              || ';' ||
                'MATRICULE'             || ';' ||
                'GNOM'
                );
        FOR rec_dpg IN csr_dpg LOOP
            Pack_Global.WRITE_STRING( l_hfile,
                rec_dpg.sgcode              || ';' ||
                rec_dpg.sglib             || ';' ||
                rec_dpg.dircode              || ';' ||
                rec_dpg.dirlib             || ';' ||
                rec_dpg.brcode              || ';' ||
                rec_dpg.brlib             || ';' ||
                rec_dpg.fertop              || ';' ||
                rec_dpg.mat             || ';' ||
                rec_dpg.nomg
                );
        END LOOP;
        Pack_Global.CLOSE_WRITE_FILE(l_hfile);
    EXCEPTION
           WHEN OTHERS THEN
            Pack_Global.recuperer_message(20401, NULL, NULL, NULL, l_msg);
            RAISE_APPLICATION_ERROR(-20401, l_msg);
end export_dpg;


end PACK_PEPSI;
/



