-- 21/11/2008 modifié par ABA : retoune la liste des pid en fonction du dpg passé en paramètre
-- 09/03/2011 CMA Fiche 1136 : On filtre sur le périmètre MO de l'utilisateur
-- 30/11/2011 BSA QC 1281
-- 26/04/2012 ABA QC 1391

CREATE OR REPLACE PACKAGE     pack_liste_pid AS

   -- Liste des type de dossier projet
TYPE pid_liste_ViewType IS RECORD (     CODE         VARCHAR2(5),
                                        LIBELLE            VARCHAR2(100)
                                     );
TYPE pid_listeCurType IS REF CURSOR RETURN pid_liste_ViewType;


PROCEDURE liste_pid(     p_codsg     IN VARCHAR2,
                               p_userid     IN VARCHAR2,
                               p_curseur     IN OUT pid_listeCurType
                             );

END pack_liste_pid;
/


CREATE OR REPLACE PACKAGE BODY     pack_liste_pid AS


PROCEDURE liste_pid(     p_codsg     IN VARCHAR2,
                               p_userid     IN VARCHAR2,
                               p_curseur     IN OUT pid_listeCurType
                             ) IS
    l_msg VARCHAR2(1024);

    l_FmtCharDPG VARCHAR2(10) := '';
   --   l_departement VARCHAR2(3);
   -- l_pole VARCHAR2(2);
   -- l_groupe VARCHAR2(2);
    l_codsg VARCHAR2(7);
    l_perimo VARCHAR2(1000);
    l_menu VARCHAR2(25);
    l_perim_me      VARCHAR2(1000);

BEGIN

    l_perim_me := pack_global.lire_perime(p_userid);
    l_codsg := RTRIM(LTRIM(p_codsg));

             BEGIN
                    OPEN p_curseur FOR
                          SELECT PID CODE, PID || ' - ' || PNOM LIBELLE  FROM LIGNE_BIP l
                          WHERE  l.topfer='N'
                            AND l.CODSG >= to_number(replace(l_codsg,'*','0') )
                            AND l.CODSG <= to_number(replace(l_codsg,'*','9') )
                            AND l.CODSG IN (SELECT codsg FROM vue_dpg_perime where INSTR(l_perim_me , codbddpg) > 0 )
                          ORDER BY PID;
                 EXCEPTION
                    WHEN No_Data_Found THEN
                     BEGIN
                          l_msg := 'Veuillez selectionner une ligne';
                          raise_application_error(-20203,l_msg);
                     END;
                    WHEN OTHERS THEN
                         raise_application_error( -20997, SQLERRM);
             END;


END liste_pid;

END pack_liste_pid;
/


