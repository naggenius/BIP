-- pack_arbitre
-- creer le 01/01/2009
-- EQUIPE BIP 
-- 
--
-- Modifié le 
-- 01/01/2009	EVI: création TD 692
-- 01/01/2009	EVI: TD 768 (lot 7.1) ajout de 2 colonnes
-- 27/05/2009	EVI: TD 815 (lot 7.1) nombre de pid possible augmenté jusqu'a 100
-- 27/08/2009   YNA: TD 822 (lot 7.3) trace des modifications des budgets
-- 01/09/2009   YNA: TD 822 (lot 7.3) trace des modifications des budgets
-- 13/03/2012	ABA  : QC 1345

create or replace
PACKAGE     pack_arbitre AS

TYPE proposes_ListeViewType IS RECORD(CLILIB        client_mo.clilib%TYPE,
                                      DPCODE        ligne_bip.DPCODE%TYPE,
                                      DP_COPI       proj_info.DP_COPI%TYPE,
                                      ICPI          ligne_bip.ICPI%TYPE,
                                      METIER        ligne_bip.METIER%TYPE,
                                      FOURNISSEUR   VARCHAR2(60),
                                      PID            ligne_bip.pid%TYPE,
                                      TYPE           ligne_bip.typproj%TYPE,
                                      ARCTYPE        ligne_bip.arctype%type,
                                      BPMONTMO       budget.BPMONTMO%TYPE,
                                      ECART          budget.BPMONTMO%TYPE,
                                      ANMONT         budget.ANMONT%TYPE,
                                      FLAGLOCK    VARCHAR2(20),
                                      APDATE          budget.APDATE%TYPE,
                                      UANMONT         budget.UANMONT%TYPE,
                                      REF_DEMANDE     VARCHAR2(12),--KRA PPM 61919 §6.9
                                      CONSOANNEE      cons_sstache_res_mois.CUSAG%TYPE --KRA PPM 61919 §6.9
                                         );

TYPE proposes_listeCurType IS REF CURSOR RETURN proposes_ListeViewType;

TYPE CURSOR_TYPE  IS TABLE OF PACK_ARBITRE_TAB%ROWTYPE;

/* BIP 32 changes for MDP check ligne conditions in reports */
FUNCTION FIND_REF_DEMANDE_LIB(P_DPCOPIAXEMETIER IN DOSSIER_PROJET_COPI.DPCOPIAXEMETIER%TYPE,
                              P_PROJAXEMETIER IN PROJ_INFO.PROJAXEMETIER%TYPE,
                              P_PID IN LIGNE_BIP.PID%TYPE) RETURN VARCHAR2;
                              
FUNCTION FIND_REF_DEMANDE(  P_DP_COPI IN DOSSIER_PROJET_COPI.DP_COPI%TYPE,
                            P_DPCOPIAXEMETIER IN DOSSIER_PROJET_COPI.DPCOPIAXEMETIER%TYPE,
                            P_PROJAXEMETIER IN PROJ_INFO.PROJAXEMETIER%TYPE,
                            P_PID IN LIGNE_BIP.PID%TYPE)  
                            return VARCHAR2;     
      
      
PROCEDURE lister_arbitre( p_codsg   IN VARCHAR2,
                          p_icpi    IN VARCHAR2,
                          p_metier  IN VARCHAR2,
                          p_dpcode      IN VARCHAR2,
                          p_pid     IN VARCHAR2,
                          p_userid  IN VARCHAR2,
                          p_ordre_tri IN VARCHAR2,
                          p_curseur IN OUT proposes_listeCurType,
                          p_message OUT VARCHAR2
                             );

FUNCTION str_arb     (    p_string     IN  VARCHAR2,
                                   p_occurence  IN  NUMBER
                                ) return VARCHAR2;


PROCEDURE update_arb(        p_string    IN  VARCHAR2,
                                      p_userid    IN  VARCHAR2,
                                      p_nbcurseur OUT INTEGER,
                                      p_message   OUT VARCHAR2
                             );

END pack_arbitre;
/


CREATE OR REPLACE PACKAGE BODY PACK_ARBITRE AS

/* BIP 32 changes for DMP check ligne,task conditions in reports */

                             
FUNCTION FIND_REF_DEMANDE_LIB(P_DPCOPIAXEMETIER IN DOSSIER_PROJET_COPI.DPCOPIAXEMETIER%TYPE,
                              P_PROJAXEMETIER IN PROJ_INFO.PROJAXEMETIER%TYPE,
                              P_PID IN LIGNE_BIP.PID%TYPE) RETURN VARCHAR2 IS

L_DMPNUM DMP_RESEAUXFRANCE.DMPNUM%TYPE := NULL;
L_REF_DEMANDE_LIB DMP_RESEAUXFRANCE.DMPLIBEL%type;
BEGIN

L_DMPNUM := TRIM(PACK_ARBITRE.FIND_REF_DEMANDE(NULL,P_DPCOPIAXEMETIER,P_PROJAXEMETIER,P_PID));
BEGIN
SELECT DMPLIBEL INTO L_REF_DEMANDE_LIB FROM DMP_RESEAUXFRANCE WHERE TRIM(DMPNUM) = L_DMPNUM AND ROWNUM = 1;
EXCEPTION
WHEN NO_DATA_FOUND THEN
 IF L_DMPNUM IS NOT NULL THEN
    L_REF_DEMANDE_LIB := '???';
  ELSE
    L_REF_DEMANDE_LIB := ' ';
  END IF;
END;
RETURN L_REF_DEMANDE_LIB;
END FIND_REF_DEMANDE_LIB;

FUNCTION FIND_REF_DEMANDE(P_DP_COPI IN DOSSIER_PROJET_COPI.DP_COPI%TYPE,P_DPCOPIAXEMETIER IN DOSSIER_PROJET_COPI.DPCOPIAXEMETIER%TYPE
,P_PROJAXEMETIER IN PROJ_INFO.PROJAXEMETIER%TYPE,P_PID IN LIGNE_BIP.PID%TYPE) RETURN VARCHAR2 IS
L_REFDEMANDE        VARCHAR2(30);

BEGIN

/*USING VISU LINE PROC TO GET THE REF_FEMANDE VALUE */
 
  IF(P_DPCOPIAXEMETIER IS NOT NULL) THEN
      RETURN P_DPCOPIAXEMETIER;
  ELSIF (P_PROJAXEMETIER IS NOT NULL) THEN
      RETURN P_PROJAXEMETIER;
  ELSE
  L_REFDEMANDE:=PACK_VISUPROJPRIN.CF_LIB_AXE_CATLOGFORMULA(P_PID,P_DPCOPIAXEMETIER,P_PROJAXEMETIER);
      RETURN TRIM(substr( L_REFDEMANDE, INSTR(L_REFDEMANDE,':')+1));
  END IF;

EXCEPTION 
WHEN OTHERS
THEN RAISE;
     
END FIND_REF_DEMANDE;

/* BIP 31 CHANGES*/
PROCEDURE SP_INS_pack_arbitre_tab (rec_list CURSOR_TYPE) AS 
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN

IF rec_list.COUNT >=1 THEN
FORALL J IN rec_list.FIRST .. rec_list.LAST
INSERT
INTO pack_arbitre_tab
  (
    CLILIB,
    DPCODE,
    DP_COPI,
    ICPI,
    METIER,
    FOURNISSEUR,
    PID,
    TYPE,
    ARCTYPE,
    BPMONTMO,
    ECART,
    ANMONT,
    FLAGLOCK,
    APDATE,
    UANMONT,
    REF_DEMANDE,
    CONSOANNEE
  )
  VALUES
  (
    rec_list(J).CLILIB,
    rec_list(J).DPCODE,
    rec_list(J).DP_COPI,
    rec_list(J).ICPI,
    rec_list(J).METIER,
    rec_list(J).FOURNISSEUR,
    rec_list(J).PID,
    rec_list(J).TYPE,
    rec_list(J).ARCTYPE,
    rec_list(J).BPMONTMO,
    rec_list(J).ECART,
    rec_list(J).ANMONT,
    rec_list(J).FLAGLOCK,
    rec_list(J).APDATE,
    rec_list(J).UANMONT,
    rec_list(J).REF_DEMANDE,
    rec_list(J).CONSOANNEE
  );

END IF;
COMMIT;
EXCEPTION
WHEN OTHERS THEN
ROLLBACK;
RAISE;

END SP_INS_pack_arbitre_tab;


PROCEDURE DELETE_TMP_TABLES IS
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
delete from pack_arbitre_tab;
COMMIT;
EXCEPTION
WHEN OTHERS THEN
ROLLBACK;

END;

PROCEDURE lister_arbitre( p_codsg   IN VARCHAR2,
                          p_icpi    IN VARCHAR2,
                          p_metier  IN VARCHAR2,
                          p_dpcode      IN VARCHAR2,
                          p_pid     IN VARCHAR2,
                          p_userid  IN VARCHAR2,
                          p_ordre_tri IN VARCHAR2,
                          p_curseur IN OUT proposes_listeCurType,
                          p_message OUT VARCHAR2
                             ) IS
                             
    REC_LIST CURSOR_TYPE := CURSOR_TYPE();   
  l_msg    VARCHAR2(1024);

  l_refdemande  VARCHAR2(30);
  l_codsg VARCHAR2(1024);
  l_codsg1 VARCHAR2(30);
  l_codsg2 VARCHAR2(30);
  l_codsg3 VARCHAR2(30);
  l_codsg4 VARCHAR2(30);
  l_codsg5 VARCHAR2(30);
  l_codsg6 VARCHAR2(30);
  l_codsg7 VARCHAR2(30);
  l_codsg8 VARCHAR2(30);
  l_codsg9 VARCHAR2(30);
  l_codsg10 VARCHAR2(30);

  l_icpi VARCHAR(1024);
  l_icpi1 CHAR(30);
  l_icpi2 CHAR(30);
  l_icpi3 CHAR(30);
  l_icpi4 CHAR(30);
  l_icpi5 CHAR(30);
  l_icpi6 CHAR(30);
  l_icpi7 CHAR(30);
  l_icpi8 CHAR(30);
  l_icpi9 CHAR(30);
  l_icpi10 CHAR(30);

  l_metier VARCHAR2(1024);
  l_metier1 CHAR(30);
  l_metier2 CHAR(30);
  l_metier3 CHAR(30);
  l_metier4 CHAR(30);
  l_metier5 CHAR(30);
  l_metier6 CHAR(30);
  l_metier7 CHAR(30);

  l_pid VARCHAR2(1024);
  l_pid1 VARCHAR2(30);
  l_pid2 VARCHAR2(30);
  l_pid3 VARCHAR2(30);
  l_pid4 VARCHAR2(30);
  l_pid5 VARCHAR2(30);
  l_pid6 VARCHAR2(30);
  l_pid7 VARCHAR2(30);
  l_pid8 VARCHAR2(30);
  l_pid9 VARCHAR2(30);
  l_pid10 VARCHAR2(30);
  l_pid11 VARCHAR2(30);
  l_pid12 VARCHAR2(30);
  l_pid13 VARCHAR2(30);
  l_pid14 VARCHAR2(30);
  l_pid15 VARCHAR2(30);
  l_pid16 VARCHAR2(30);
  l_pid17 VARCHAR2(30);
  l_pid18 VARCHAR2(30);
  l_pid19 VARCHAR2(30);
  l_pid20 VARCHAR2(30);
  -- TD 815 rajout pid possible jusqu'a 100
  l_pid21 VARCHAR2(30);
  l_pid22 VARCHAR2(30);
  l_pid23 VARCHAR2(30);
  l_pid24 VARCHAR2(30);
  l_pid25 VARCHAR2(30);
  l_pid26 VARCHAR2(30);
  l_pid27 VARCHAR2(30);
  l_pid28 VARCHAR2(30);
  l_pid29 VARCHAR2(30);
  l_pid30 VARCHAR2(30);
  l_pid31 VARCHAR2(30);
  l_pid32 VARCHAR2(30);
  l_pid33 VARCHAR2(30);
  l_pid34 VARCHAR2(30);
  l_pid35 VARCHAR2(30);
  l_pid36 VARCHAR2(30);
  l_pid37 VARCHAR2(30);
  l_pid38 VARCHAR2(30);
  l_pid39 VARCHAR2(30);
  l_pid40 VARCHAR2(30);
  l_pid41 VARCHAR2(30);
  l_pid42 VARCHAR2(30);
  l_pid43 VARCHAR2(30);
  l_pid44 VARCHAR2(30);
  l_pid45 VARCHAR2(30);
  l_pid46 VARCHAR2(30);
  l_pid47 VARCHAR2(30);
  l_pid48 VARCHAR2(30);
  l_pid49 VARCHAR2(30);
  l_pid50 VARCHAR2(30);
  l_pid51 VARCHAR2(30);
  l_pid52 VARCHAR2(30);
  l_pid53 VARCHAR2(30);
  l_pid54 VARCHAR2(30);
  l_pid55 VARCHAR2(30);
  l_pid56 VARCHAR2(30);
  l_pid57 VARCHAR2(30);
  l_pid58 VARCHAR2(30);
  l_pid59 VARCHAR2(30);
  l_pid60 VARCHAR2(30);
  l_pid61 VARCHAR2(30);
  l_pid62 VARCHAR2(30);
  l_pid63 VARCHAR2(30);
  l_pid64 VARCHAR2(30);
  l_pid65 VARCHAR2(30);
  l_pid66 VARCHAR2(30);
  l_pid67 VARCHAR2(30);
  l_pid68 VARCHAR2(30);
  l_pid69 VARCHAR2(30);
  l_pid70 VARCHAR2(30);
  l_pid71 VARCHAR2(30);
  l_pid72 VARCHAR2(30);
  l_pid73 VARCHAR2(30);
  l_pid74 VARCHAR2(30);
  l_pid75 VARCHAR2(30);
  l_pid76 VARCHAR2(30);
  l_pid77 VARCHAR2(30);
  l_pid78 VARCHAR2(30);
  l_pid79 VARCHAR2(30);
  l_pid80 VARCHAR2(30);
  l_pid81 VARCHAR2(30);
  l_pid82 VARCHAR2(30);
  l_pid83 VARCHAR2(30);
  l_pid84 VARCHAR2(30);
  l_pid85 VARCHAR2(30);
  l_pid86 VARCHAR2(30);
  l_pid87 VARCHAR2(30);
  l_pid88 VARCHAR2(30);
  l_pid89 VARCHAR2(30);
  l_pid90 VARCHAR2(30);
  l_pid91 VARCHAR2(30);
  l_pid92 VARCHAR2(30);
  l_pid93 VARCHAR2(30);
  l_pid94 VARCHAR2(30);
  l_pid95 VARCHAR2(30);
  l_pid96 VARCHAR2(30);
  l_pid97 VARCHAR2(30);
  l_pid98 VARCHAR2(30);
  l_pid99 VARCHAR2(30);
  l_pid100 VARCHAR2(30);

   pos1   integer;
   pos2   integer;
   pos3   integer;
   pos4   integer;
   pos5   integer;
   pos6   integer;
   pos7   integer;
   pos8   integer;
   pos9   integer;
   pos10  integer;
   pos11  integer;
   pos12  integer;
   pos13  integer;
   pos14  integer;
   pos15  integer;
   pos16  integer;
   pos17  integer;
   pos18  integer;
   pos19  integer;
   pos20  integer;
   -- TD 815 rajout pid possible jusqu'a 100
   pos21   integer;
   pos22   integer;
   pos23   integer;
   pos24   integer;
   pos25   integer;
   pos26   integer;
   pos27   integer;
   pos28   integer;
   pos29   integer;
   pos30  integer;
   pos31  integer;
   pos32  integer;
   pos33  integer;
   pos34  integer;
   pos35  integer;
   pos36  integer;
   pos37  integer;
   pos38  integer;
   pos39  integer;
   pos40  integer;
   pos41   integer;
   pos42   integer;
   pos43   integer;
   pos44   integer;
   pos45   integer;
   pos46   integer;
   pos47   integer;
   pos48   integer;
   pos49   integer;
   pos50  integer;
   pos51  integer;
   pos52  integer;
   pos53  integer;
   pos54  integer;
   pos55  integer;
   pos56  integer;
   pos57  integer;
   pos58  integer;
   pos59  integer;
   pos60  integer;
   pos61   integer;
   pos62   integer;
   pos63   integer;
   pos64   integer;
   pos65   integer;
   pos66   integer;
   pos67   integer;
   pos68   integer;
   pos69   integer;
   pos70  integer;
   pos71  integer;
   pos72  integer;
   pos73  integer;
   pos74  integer;
   pos75  integer;
   pos76  integer;
   pos77  integer;
   pos78  integer;
   pos79  integer;
   pos80  integer;
   pos81   integer;
   pos82   integer;
   pos83   integer;
   pos84   integer;
   pos85   integer;
   pos86   integer;
   pos87   integer;
   pos88   integer;
   pos89   integer;
   pos90  integer;
   pos91  integer;
   pos92  integer;
   pos93  integer;
   pos94  integer;
   pos95  integer;
   pos96  integer;
   pos97  integer;
   pos98  integer;
   pos99  integer;
   pos100  integer;


   BEGIN

   /******************* Extraction des 20 pid max ****************************/
   -- Termine la chaine de pid par un point virgule
   l_pid := p_pid ||';';

   -- recherche la positin du premier pid
   pos1 := INSTR( l_pid, ';', 1, 1);
   l_pid1 := UPPER(substr( l_pid, 1, pos1-1));

   pos2 := INSTR( l_pid, ';', 1, 2);
   l_pid2 := UPPER(substr( l_pid, pos1+1 , pos2-pos1-1));

   pos3 := INSTR( l_pid, ';', 1, 3);
   l_pid3 := UPPER(substr( l_pid, pos2+1 , pos3-pos2-1));

   pos4 := INSTR( l_pid, ';', 1, 4);
   l_pid4 := UPPER(substr( l_pid, pos3+1 , pos4-pos3-1));

   pos5 := INSTR( l_pid, ';', 1, 5);
   l_pid5 := UPPER(substr( l_pid, pos4+1 , pos5-pos4-1));

   pos6 := INSTR( l_pid, ';', 1, 6);
   l_pid6 := UPPER(substr( l_pid, pos5+1 , pos6-pos5-1));

   pos7 := INSTR( l_pid, ';', 1, 7);
   l_pid7 := UPPER(substr( l_pid, pos6+1 , pos7-pos6-1));

   pos8 := INSTR( l_pid, ';', 1, 8);
   l_pid8 := UPPER(substr( l_pid, pos7+1 , pos8-pos7-1));

   pos9 := INSTR( l_pid, ';', 1, 9);
   l_pid9 := UPPER(substr( l_pid, pos8+1 , pos9-pos8-1));

   pos10 := INSTR( l_pid, ';', 1, 10);
   l_pid10 := UPPER(substr( l_pid, pos9+1 , pos10-pos9-1));

   pos11 := INSTR( l_pid, ';', 1, 11);
   l_pid11:= UPPER(substr( l_pid, pos10+1 , pos11-pos10-1));

   pos12 := INSTR( l_pid, ';', 1, 12);
   l_pid12 := UPPER(substr( l_pid, pos11+1 , pos12-pos11-1));

   pos13 := INSTR( l_pid, ';', 1, 13);
   l_pid13 := UPPER(substr( l_pid, pos12+1 , pos13-pos12-1));

   pos14 := INSTR( l_pid, ';', 1, 14);
   l_pid14 := UPPER(substr( l_pid, pos13+1 , pos14-pos13-1));

   pos15 := INSTR( l_pid, ';', 1, 15);
   l_pid15 := UPPER(substr( l_pid, pos14+1 , pos15-pos14-1));

   pos16 := INSTR( l_pid, ';', 1, 16);
   l_pid16 := UPPER(substr( l_pid, pos15+1 , pos16-pos15-1));

   pos17 := INSTR( l_pid, ';', 1, 17);
   l_pid17 := UPPER(substr( l_pid, pos16+1 , pos17-pos16-1));

   pos18 := INSTR( l_pid, ';', 1, 18);
   l_pid18 := UPPER(substr( l_pid, pos17+1 , pos18-pos17-1));

   pos19 := INSTR( l_pid, ';', 1, 19);
   l_pid19 := UPPER(substr( l_pid, pos18+1 , pos19-pos18-1));

   pos20 := INSTR( l_pid, ';', 1, 20);
   l_pid20 := UPPER(substr( l_pid, pos19+1 , pos20-pos19-1));
-- TD 815 rajout pid possible jusqu'a 100
pos21 := INSTR( l_pid, ';', 1, 21);
pos22 := INSTR( l_pid, ';', 1, 22);
pos23 := INSTR( l_pid, ';', 1, 23);
pos24 := INSTR( l_pid, ';', 1, 24);
pos25 := INSTR( l_pid, ';', 1, 25);
pos26 := INSTR( l_pid, ';', 1, 26);
pos27 := INSTR( l_pid, ';', 1, 27);
pos28 := INSTR( l_pid, ';', 1, 28);
pos29 := INSTR( l_pid, ';', 1, 29);
pos30 := INSTR( l_pid, ';', 1, 30);
pos31 := INSTR( l_pid, ';', 1, 31);
pos32 := INSTR( l_pid, ';', 1, 32);
pos33 := INSTR( l_pid, ';', 1, 33);
pos34 := INSTR( l_pid, ';', 1, 34);
pos35 := INSTR( l_pid, ';', 1, 35);
pos36 := INSTR( l_pid, ';', 1, 36);
pos37 := INSTR( l_pid, ';', 1, 37);
pos38 := INSTR( l_pid, ';', 1, 38);
pos39 := INSTR( l_pid, ';', 1, 39);
pos40 := INSTR( l_pid, ';', 1, 40);
pos41 := INSTR( l_pid, ';', 1, 41);
pos42 := INSTR( l_pid, ';', 1, 42);
pos43 := INSTR( l_pid, ';', 1, 43);
pos44 := INSTR( l_pid, ';', 1, 44);
pos45 := INSTR( l_pid, ';', 1, 45);
pos46 := INSTR( l_pid, ';', 1, 46);
pos47 := INSTR( l_pid, ';', 1, 47);
pos48 := INSTR( l_pid, ';', 1, 48);
pos49 := INSTR( l_pid, ';', 1, 49);
pos50 := INSTR( l_pid, ';', 1, 50);
pos51 := INSTR( l_pid, ';', 1, 51);
pos52 := INSTR( l_pid, ';', 1, 52);
pos53 := INSTR( l_pid, ';', 1, 53);
pos54 := INSTR( l_pid, ';', 1, 54);
pos55 := INSTR( l_pid, ';', 1, 55);
pos56 := INSTR( l_pid, ';', 1, 56);
pos57 := INSTR( l_pid, ';', 1, 57);
pos58 := INSTR( l_pid, ';', 1, 58);
pos59 := INSTR( l_pid, ';', 1, 59);
pos60 := INSTR( l_pid, ';', 1, 60);
pos61 := INSTR( l_pid, ';', 1, 61);
pos62 := INSTR( l_pid, ';', 1, 62);
pos63 := INSTR( l_pid, ';', 1, 63);
pos64 := INSTR( l_pid, ';', 1, 64);
pos65 := INSTR( l_pid, ';', 1, 65);
pos66 := INSTR( l_pid, ';', 1, 66);
pos67 := INSTR( l_pid, ';', 1, 67);
pos68 := INSTR( l_pid, ';', 1, 68);
pos69 := INSTR( l_pid, ';', 1, 69);
pos70 := INSTR( l_pid, ';', 1, 70);
pos71 := INSTR( l_pid, ';', 1, 71);
pos72 := INSTR( l_pid, ';', 1, 72);
pos73 := INSTR( l_pid, ';', 1, 73);
pos74 := INSTR( l_pid, ';', 1, 74);
pos75 := INSTR( l_pid, ';', 1, 75);
pos76 := INSTR( l_pid, ';', 1, 76);
pos77 := INSTR( l_pid, ';', 1, 77);
pos78 := INSTR( l_pid, ';', 1, 78);
pos79 := INSTR( l_pid, ';', 1, 79);
pos80 := INSTR( l_pid, ';', 1, 80);
pos81 := INSTR( l_pid, ';', 1, 81);
pos82 := INSTR( l_pid, ';', 1, 82);
pos83 := INSTR( l_pid, ';', 1, 83);
pos84 := INSTR( l_pid, ';', 1, 84);
pos85 := INSTR( l_pid, ';', 1, 85);
pos86 := INSTR( l_pid, ';', 1, 86);
pos87 := INSTR( l_pid, ';', 1, 87);
pos88 := INSTR( l_pid, ';', 1, 88);
pos89 := INSTR( l_pid, ';', 1, 89);
pos90 := INSTR( l_pid, ';', 1, 90);
pos91 := INSTR( l_pid, ';', 1, 91);
pos92 := INSTR( l_pid, ';', 1, 92);
pos93 := INSTR( l_pid, ';', 1, 93);
pos94 := INSTR( l_pid, ';', 1, 94);
pos95 := INSTR( l_pid, ';', 1, 95);
pos96 := INSTR( l_pid, ';', 1, 96);
pos97 := INSTR( l_pid, ';', 1, 97);
pos98 := INSTR( l_pid, ';', 1, 98);
pos99 := INSTR( l_pid, ';', 1, 99);
pos100 := INSTR( l_pid, ';', 1, 100);
-- TD 815 rajout pid possible jusqu'a 100
l_pid21 := UPPER(substr( l_pid, pos20+1 , pos21-pos20-1));
l_pid22 := UPPER(substr( l_pid, pos21+1 , pos22-pos21-1));
l_pid23 := UPPER(substr( l_pid, pos22+1 , pos23-pos22-1));
l_pid24 := UPPER(substr( l_pid, pos23+1 , pos24-pos23-1));
l_pid25 := UPPER(substr( l_pid, pos24+1 , pos25-pos24-1));
l_pid26 := UPPER(substr( l_pid, pos25+1 , pos26-pos25-1));
l_pid27 := UPPER(substr( l_pid, pos26+1 , pos27-pos26-1));
l_pid28 := UPPER(substr( l_pid, pos27+1 , pos28-pos27-1));
l_pid29 := UPPER(substr( l_pid, pos28+1 , pos29-pos28-1));
l_pid30 := UPPER(substr( l_pid, pos29+1 , pos30-pos29-1));
l_pid31 := UPPER(substr( l_pid, pos30+1 , pos31-pos30-1));
l_pid32 := UPPER(substr( l_pid, pos31+1 , pos32-pos31-1));
l_pid33 := UPPER(substr( l_pid, pos32+1 , pos33-pos32-1));
l_pid34 := UPPER(substr( l_pid, pos33+1 , pos34-pos33-1));
l_pid35 := UPPER(substr( l_pid, pos34+1 , pos35-pos34-1));
l_pid36 := UPPER(substr( l_pid, pos35+1 , pos36-pos35-1));
l_pid37 := UPPER(substr( l_pid, pos36+1 , pos37-pos36-1));
l_pid38 := UPPER(substr( l_pid, pos37+1 , pos38-pos37-1));
l_pid39 := UPPER(substr( l_pid, pos38+1 , pos39-pos38-1));
l_pid40 := UPPER(substr( l_pid, pos39+1 , pos40-pos39-1));
l_pid41 := UPPER(substr( l_pid, pos40+1 , pos41-pos40-1));
l_pid42 := UPPER(substr( l_pid, pos41+1 , pos42-pos41-1));
l_pid43 := UPPER(substr( l_pid, pos42+1 , pos43-pos42-1));
l_pid44 := UPPER(substr( l_pid, pos43+1 , pos44-pos43-1));
l_pid45 := UPPER(substr( l_pid, pos44+1 , pos45-pos44-1));
l_pid46 := UPPER(substr( l_pid, pos45+1 , pos46-pos45-1));
l_pid47 := UPPER(substr( l_pid, pos46+1 , pos47-pos46-1));
l_pid48 := UPPER(substr( l_pid, pos47+1 , pos48-pos47-1));
l_pid49 := UPPER(substr( l_pid, pos48+1 , pos49-pos48-1));
l_pid50 := UPPER(substr( l_pid, pos49+1 , pos50-pos49-1));
l_pid51 := UPPER(substr( l_pid, pos50+1 , pos51-pos50-1));
l_pid52 := UPPER(substr( l_pid, pos51+1 , pos52-pos51-1));
l_pid53 := UPPER(substr( l_pid, pos52+1 , pos53-pos52-1));
l_pid54 := UPPER(substr( l_pid, pos53+1 , pos54-pos53-1));
l_pid55 := UPPER(substr( l_pid, pos54+1 , pos55-pos54-1));
l_pid56 := UPPER(substr( l_pid, pos55+1 , pos56-pos55-1));
l_pid57 := UPPER(substr( l_pid, pos56+1 , pos57-pos56-1));
l_pid58 := UPPER(substr( l_pid, pos57+1 , pos58-pos57-1));
l_pid59 := UPPER(substr( l_pid, pos58+1 , pos59-pos58-1));
l_pid60 := UPPER(substr( l_pid, pos59+1 , pos60-pos59-1));
l_pid61 := UPPER(substr( l_pid, pos60+1 , pos61-pos60-1));
l_pid62 := UPPER(substr( l_pid, pos61+1 , pos62-pos61-1));
l_pid63 := UPPER(substr( l_pid, pos62+1 , pos63-pos62-1));
l_pid64 := UPPER(substr( l_pid, pos63+1 , pos64-pos63-1));
l_pid65 := UPPER(substr( l_pid, pos64+1 , pos65-pos64-1));
l_pid66 := UPPER(substr( l_pid, pos65+1 , pos66-pos65-1));
l_pid67 := UPPER(substr( l_pid, pos66+1 , pos67-pos66-1));
l_pid68 := UPPER(substr( l_pid, pos67+1 , pos68-pos67-1));
l_pid69 := UPPER(substr( l_pid, pos68+1 , pos69-pos68-1));
l_pid70 := UPPER(substr( l_pid, pos69+1 , pos70-pos69-1));
l_pid71 := UPPER(substr( l_pid, pos70+1 , pos71-pos70-1));
l_pid72 := UPPER(substr( l_pid, pos71+1 , pos72-pos71-1));
l_pid73 := UPPER(substr( l_pid, pos72+1 , pos73-pos72-1));
l_pid74 := UPPER(substr( l_pid, pos73+1 , pos74-pos73-1));
l_pid75 := UPPER(substr( l_pid, pos74+1 , pos75-pos74-1));
l_pid76 := UPPER(substr( l_pid, pos75+1 , pos76-pos75-1));
l_pid77 := UPPER(substr( l_pid, pos76+1 , pos77-pos76-1));
l_pid78 := UPPER(substr( l_pid, pos77+1 , pos78-pos77-1));
l_pid79 := UPPER(substr( l_pid, pos78+1 , pos79-pos78-1));
l_pid80 := UPPER(substr( l_pid, pos79+1 , pos80-pos79-1));
l_pid81 := UPPER(substr( l_pid, pos80+1 , pos81-pos80-1));
l_pid82 := UPPER(substr( l_pid, pos81+1 , pos82-pos81-1));
l_pid83 := UPPER(substr( l_pid, pos82+1 , pos83-pos82-1));
l_pid84 := UPPER(substr( l_pid, pos83+1 , pos84-pos83-1));
l_pid85 := UPPER(substr( l_pid, pos84+1 , pos85-pos84-1));
l_pid86 := UPPER(substr( l_pid, pos85+1 , pos86-pos85-1));
l_pid87 := UPPER(substr( l_pid, pos86+1 , pos87-pos86-1));
l_pid88 := UPPER(substr( l_pid, pos87+1 , pos88-pos87-1));
l_pid89 := UPPER(substr( l_pid, pos88+1 , pos89-pos88-1));
l_pid90 := UPPER(substr( l_pid, pos89+1 , pos90-pos89-1));
l_pid91 := UPPER(substr( l_pid, pos90+1 , pos91-pos90-1));
l_pid92 := UPPER(substr( l_pid, pos91+1 , pos92-pos91-1));
l_pid93 := UPPER(substr( l_pid, pos92+1 , pos93-pos92-1));
l_pid94 := UPPER(substr( l_pid, pos93+1 , pos94-pos93-1));
l_pid95 := UPPER(substr( l_pid, pos94+1 , pos95-pos94-1));
l_pid96 := UPPER(substr( l_pid, pos95+1 , pos96-pos95-1));
l_pid97 := UPPER(substr( l_pid, pos96+1 , pos97-pos96-1));
l_pid98 := UPPER(substr( l_pid, pos97+1 , pos98-pos97-1));
l_pid99 := UPPER(substr( l_pid, pos98+1 , pos99-pos98-1));
l_pid100 := UPPER(substr( l_pid, pos99+1 , pos100-pos99-1));


   /*********************** Extraction des 10 CODSG *********************************/
   -- Termine la chaine de codsg par un point virgule

   l_codsg := p_codsg ||';';

   -- recherche la positin du premier codsg
   pos1 := INSTR( l_codsg, ';', 1, 1);
   l_codsg1 := UPPER(substr( l_codsg, 1, pos1-1));

   pos2 := INSTR( l_codsg, ';', 1, 2);
   l_codsg2 := UPPER(substr( l_codsg, pos1+1 , pos2-pos1-1));

   pos3 := INSTR( l_codsg, ';', 1, 3);
   l_codsg3 := UPPER(substr( l_codsg, pos2+1 , pos3-pos2-1));

   pos4 := INSTR( l_codsg, ';', 1, 4);
   l_codsg4 := UPPER(substr( l_codsg, pos3+1 , pos4-pos3-1));

   pos5 := INSTR( l_codsg, ';', 1, 5);
   l_codsg5 := UPPER(substr( l_codsg, pos4+1 , pos5-pos4-1));

   pos6 := INSTR( l_codsg, ';', 1, 6);
   l_codsg6 := UPPER(substr( l_codsg, pos5+1 , pos6-pos5-1));

   pos7 := INSTR( l_codsg, ';', 1, 7);
   l_codsg7 := UPPER(substr( l_codsg, pos6+1 , pos7-pos6-1));

   pos8 := INSTR( l_codsg, ';', 1, 8);
   l_codsg8 := UPPER(substr( l_codsg, pos7+1 , pos8-pos7-1));

   pos9 := INSTR( l_codsg, ';', 1, 9);
   l_codsg9 := UPPER(substr( l_codsg, pos8+1 , pos9-pos8-1));

   pos10 := INSTR( l_codsg, ';', 1, 10);
   l_codsg10 := UPPER(substr( l_codsg, pos9+1 , pos10-pos9-1));


/******************* Extraction des 7 metier max ****************************/
   -- Termine la chaine de metier par un point virgule

   l_metier := p_metier ||';';

   -- recherche la positin du premier metier
   pos1 := INSTR( l_metier, ';', 1, 1);
   l_metier1 := UPPER(substr( l_metier, 1, pos1-1));

   pos2 := INSTR( l_metier, ';', 1, 2);
   l_metier2 := UPPER(substr( l_metier, pos1+1 , pos2-pos1-1));

   pos3 := INSTR( l_metier, ';', 1, 3);
   l_metier3 := UPPER(substr( l_metier, pos2+1 , pos3-pos2-1));

   pos4 := INSTR( l_metier, ';', 1, 4);
   l_metier4 := UPPER(substr( l_metier, pos3+1 , pos4-pos3-1));

   pos5 := INSTR( l_metier, ';', 1, 5);
   l_metier5 := UPPER(substr( l_metier, pos4+1 , pos5-pos4-1));

   pos6 := INSTR( l_metier, ';', 1, 6);
   l_metier6 := UPPER(substr( l_metier, pos5+1 , pos6-pos5-1));

   pos7 := INSTR( l_metier, ';', 1, 7);
   l_metier7 := UPPER(substr( l_metier, pos6+1 , pos7-pos6-1));

   /*********************** Extraction des 10 icpi *********************************/
   -- Termine la chaine de icpi par un point virgule
   l_icpi := p_icpi ||';';

   -- recherche la positin du premier icpi
   pos1 := INSTR( l_icpi, ';', 1, 1);
   l_icpi1 := UPPER(substr( l_icpi, 1, pos1-1));

   pos2 := INSTR( l_icpi, ';', 1, 2);
   l_icpi2 := UPPER(substr( l_icpi, pos1+1 , pos2-pos1-1));

   pos3 := INSTR( l_icpi, ';', 1, 3);
   l_icpi3 := UPPER(substr( l_icpi, pos2+1 , pos3-pos2-1));

   pos4 := INSTR( l_icpi, ';', 1, 4);
   l_icpi4 := UPPER(substr( l_icpi, pos3+1 , pos4-pos3-1));

   pos5 := INSTR( l_icpi, ';', 1, 5);
   l_icpi5 := UPPER(substr( l_icpi, pos4+1 , pos5-pos4-1));

   pos6 := INSTR( l_icpi, ';', 1, 6);
   l_icpi6 := UPPER(substr( l_icpi, pos5+1 , pos6-pos5-1));

   pos7 := INSTR( l_icpi, ';', 1, 7);
   l_icpi7 := UPPER(substr( l_icpi, pos6+1 , pos7-pos6-1));

   pos8 := INSTR( l_icpi, ';', 1, 8);
   l_icpi8 := UPPER(substr( l_icpi, pos7+1 , pos8-pos7-1));

   pos9 := INSTR( l_icpi, ';', 1, 9);
   l_icpi9 := UPPER(substr( l_icpi, pos8+1 , pos9-pos8-1));

   pos10 := INSTR( l_icpi, ';', 1, 10);
   l_icpi10 := UPPER(substr( l_icpi, pos9+1 , pos10-pos9-1));

         BEGIN
         DELETE_TMP_TABLES;
        -- On rcupre les lignes correspondante
        -- OPEN p_curseur FOR
            SELECT c.clilib AS CLILIB,
                decode(l.dpcode,'0','00000',l.dpcode) AS DPCODE,
                p.DP_COPI AS DP_COPI,
                l.ICPI   AS ICPI,
                l.METIER AS METIER,
                br.LIBBR ||'/'|| di.LIBDIR AS FOURNISSEUR,
                l.pid  AS PID,
                RTRIM(LTRIM(l.typproj))    AS TYPE,
                l.arctype AS ARCTYPE,
                TO_CHAR( NVL(b.bpmontmo,0), 'FM9999999990D00') AS BPMONTMO,
                TO_CHAR( NVL(b.bpmontmo,0) - NVL(b.anmont,0), 'FM9999999990D00') AS ECART,
                TO_CHAR( NVL(b.anmont,0), 'FM9999999990D00') AS ANMONT,
                TO_CHAR(b.flaglock)         AS FLAGLOCK,
                --YNI
                b.apdate as APDATE,
                b.uanmont as UANMONT
                --Fin YNI
                -- KRA PPM 61919 6.9 : ajout de ref_demande et le consomme annuel
             --  , FIND_REF_DEMANDE(P.DP_COPI,DC.DPCOPIAXEMETIER,P.PROJAXEMETIER,L.PID)   as REF_DEMANDE
             ,'' as REF_DEMANDE
                -- ajout du consomme annuel de la ligne BIP
                ,(select TO_CHAR(sum(o.cusag), 'FM9999999990D00') from cons_sstache_res_mois o, ligne_bip ll, datdebex d
                    where o.pid = ll.pid
                    and ll.pid = l.pid
                    -- consomms sur l'anne en cours
                    and to_char(d.moismens,'YYYY')=to_char(o.cdeb,'YYYY')
                    and to_char(o.cdeb,'MM')<= to_char(d.moismens,'MM')) AS CONSOANNEE,
                    DC.DPCOPIAXEMETIER,
                    P.PROJAXEMETIER
                --Fin KRA 
                bulk collect into rec_list
             FROM   BUDGET b, LIGNE_BIP l, datdebex d, struct_info s, directions di, branches br, proj_info p, client_mo c, dossier_projet_copi dc --KRA
             WHERE  b.pid = l.pid
               AND l.CODSG = s.CODSG
               AND s.CODDIR = di.CODDIR
               AND di.CODBR = br.CODBR
               AND p.ICPI = l.ICPI
               AND dc.dp_copi(+) = p.dp_copi --KRA PPM 61919 6.9
               AND c.clicode = l.clicode
               AND b.annee(+)= TO_CHAR(d.datdebex,'YYYY')
               AND (l.adatestatut IS NULL OR TO_CHAR(l.adatestatut,'YYYY')=TO_CHAR(d.datdebex,'YYYY') )
               AND (
                    (
                    -- recupere les codsg saisie OU prend tous les codsg si rien saisie par utilisateur
                    (l.codsg IN (l_codsg1, l_codsg2, l_codsg3, l_codsg4, l_codsg5, l_codsg6, l_codsg7, l_codsg8, l_codsg9, l_codsg10) OR (l.codsg IS NOT NULL and l_codsg=';' and l_pid=';' ) )
                    -- recupere les metier saisie OU prend tous metier si rien saisie
                    AND (l.metier IN (l_metier1, l_metier2, l_metier3, l_metier4, l_metier5, l_metier6, l_metier7) or (l.metier IS NOT NULL and l_metier=';' and l_pid=';' ))
                    -- test sur le dpcode
                    AND (l.dpcode IN ( p_dpcode) or (l.dpcode IS NOT NULL and p_dpcode IS NULL and l_pid=';' ))
                    --recupere les projet saisie OU prend tous les projet si rien saisie
                    AND (l.icpi IN (l_icpi1, l_icpi2, l_icpi3, l_icpi4, l_icpi5, l_icpi6, l_icpi7, l_icpi8, l_icpi9, l_icpi10) or (l.icpi IS NOT NULL and l_icpi=';' and l_pid=';' ))
                    )
                   -- si utilisateur saisie une/des ligne(s) on ne ramene que les lignes saisie
                   OR  l.pid IN (l_pid1, l_pid2, l_pid3, l_pid4, l_pid5, l_pid6, l_pid7, l_pid8, l_pid9, l_pid10, l_pid11, l_pid12, l_pid13, l_pid14, l_pid15, l_pid16, l_pid17, l_pid18, l_pid19, l_pid20
                               -- TD 815 rajout pid possible jusqu'a 100
                               , l_pid21, l_pid22, l_pid23, l_pid24, l_pid25, l_pid26, l_pid27, l_pid28, l_pid29, l_pid30, l_pid31, l_pid32, l_pid33, l_pid34, l_pid35, l_pid36, l_pid37, l_pid38, l_pid39, l_pid40
                               , l_pid41, l_pid42, l_pid43, l_pid44, l_pid45, l_pid46, l_pid47, l_pid48, l_pid49, l_pid50, l_pid51, l_pid52, l_pid53, l_pid54, l_pid55, l_pid56, l_pid57, l_pid58, l_pid59, l_pid60
                               , l_pid61, l_pid62, l_pid63, l_pid64, l_pid65, l_pid66, l_pid67, l_pid68, l_pid69, l_pid70, l_pid71, l_pid72, l_pid73, l_pid74, l_pid75, l_pid76, l_pid77, l_pid78, l_pid79, l_pid80
                               , l_pid81, l_pid82, l_pid83, l_pid84, l_pid85, l_pid86, l_pid87, l_pid88, l_pid89, l_pid90, l_pid91, l_pid92, l_pid93, l_pid94, l_pid95, l_pid96, l_pid97, l_pid98, l_pid99, l_pid100
                               )
                   )
              ORDER BY decode(p_ordre_tri,'1',dpcode,'2',icpi,'3',pid) asc, decode(p_ordre_tri,'4',ABS(ECART)) desc ;


  IF rec_list.COUNT >= 1 THEN
  
  FOR I IN rec_list.FIRST .. rec_list.LAST
  LOOP
    rec_list(I).REF_DEMANDE := FIND_REF_DEMANDE(rec_list(I).DP_COPI,rec_list(I).DPCOPIAXEMETIER,rec_list(I).PROJAXEMETIER,rec_list(I).PID);
  END LOOP;
  /* BIP 31 CHANGES*/
 SP_INS_PACK_ARBITRE_TAB (REC_LIST) ;
   END IF;

OPEN p_curseur FOR SELECT CLILIB,
  DPCODE,
  DP_COPI,
  ICPI,
  METIER,
  FOURNISSEUR,
  PID,
  TYPE,
  ARCTYPE,
  BPMONTMO,
  ECART,
  ANMONT,
  FLAGLOCK,
  APDATE,
  UANMONT,
  REF_DEMANDE,
  CONSOANNEE
FROM pack_arbitre_tab;    
    
          EXCEPTION
           WHEN NO_DATA_FOUND THEN
             --RAISE_APPLICATION_ERROR(-20373 , l_msg);
             Pack_Global.recuperer_message( 20373 , '%s1', p_codsg, 'codsg', l_msg);
             p_message := 'Aucune ligne trouvée';


           WHEN OTHERS THEN
             RAISE_APPLICATION_ERROR( -20997, SQLERRM);
             Pack_Global.recuperer_message( 20373 , '%s1', p_codsg, 'codsg', l_msg);
          END;

p_message := 'Aucune ligne trouvée';

END lister_arbitre;

   FUNCTION str_arb (    p_string     IN  VARCHAR2,
                               p_occurence  IN  NUMBER
                              ) return VARCHAR2 IS
   pos1 NUMBER(6);
   pos2 NUMBER(6);
   str  VARCHAR2(111);

   BEGIN

      pos1 := INSTR(p_string,';',1,p_occurence);
      pos2 := INSTR(p_string,';',1,p_occurence+1);

      IF pos2 != 1 THEN
         str := SUBSTR( p_string, pos1+1, pos2-pos1-1);
         return str;
      ELSE
         return '1';
      END IF;

   END str_arb;



  PROCEDURE update_arb(        p_string    IN  VARCHAR2,
                                      p_userid    IN  VARCHAR2,
                                      p_nbcurseur OUT INTEGER,
                                      p_message   OUT VARCHAR2
                                 ) IS

   l_msg        VARCHAR2(10000);
   l_cpt        NUMBER(7);
   --l_bpannee      budget.annee%TYPE;
   l_bpannee    VARCHAR2(4);
   l_pid        ligne_bip.pid%TYPE;
   --YNI
   l_userid     LIGNE_BIP_LOGS.user_log%TYPE;
   l_anmont     varchar2(20);
   --Fin YNI
   l_bpmontme     varchar2(20);
   l_bpmontmo     varchar2(20);
   l_flaglock   budget.flaglock%TYPE;
   l_exist     NUMBER;

   BEGIN


      -- Positionner le nb de curseurs ==> 1

      p_nbcurseur := 0;
      p_message   := '';
      l_cpt       := 1;
      l_bpannee := TO_NUMBER(pack_arbitre.str_arb(p_string,l_cpt));
      --YNI Initialisation du user
      l_userid := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);
      --Fin YNI
      WHILE l_cpt != 0 LOOP
    if l_cpt!=1 then
        l_pid := pack_arbitre.str_arb(p_string,l_cpt);
        l_flaglock   := TO_NUMBER(pack_arbitre.str_arb(p_string,l_cpt+1));
    else
        l_pid := pack_arbitre.str_arb(p_string,l_cpt+1);
        l_flaglock   := TO_NUMBER(pack_arbitre.str_arb(p_string,l_cpt+2));
    end if;


        IF l_pid != '0' THEN

      -- Existence de la ligne bip dans budget
             BEGIN
        select 1 into l_exist
        from budget
        where pid=l_pid
        and   annee = l_bpannee;
             EXCEPTION
        WHEN NO_DATA_FOUND THEN
        --Création de la ligne dans la table BUDGET
        INSERT INTO budget (annee, bpdate, anmont, bpmontmo, flaglock, pid)
        VALUES (l_bpannee,
             sysdate,
            TO_NUMBER(0,'FM9999999990D00'),
            TO_NUMBER(0,'FM9999999990D00'),
            0,
            l_pid);

         END;

        IF l_exist=1 THEN
                 --YNI
                 SELECT bpmontmo, anmont INTO  l_bpmontmo, l_anmont
                     FROM BUDGET
                 WHERE  pid = l_pid
                 AND annee = l_bpannee;
                 --Fin YNI
                 --Mise à jour de la table BUDGET
                 UPDATE budget SET
                            apdate  = sysdate,
                            anmont = (SELECT bpmontmo FROM BUDGET WHERE annee = l_bpannee
                                                                        and pid = l_pid
                                                                        and flaglock = l_flaglock),
                            uanmont = l_userid,
                            flaglock = decode( l_flaglock, 1000000, 0, l_flaglock + 1)
                            WHERE pid = l_pid
                                  AND annee = l_bpannee
                                  AND flaglock = l_flaglock;

         --YNI
         Pack_Ligne_Bip.maj_ligne_bip_logs(l_pid, l_userid, 'arbitré ' || l_bpannee, l_anmont, l_bpmontmo, 'Modification IHM (Arbitrage ligne BIP)');

         --Fin YNI
         END IF;



        if l_cpt=1 then       --pris en compte de l'année au début de la chaîne {;annee;pid;flaglock;pid;flaglock;..;}
        l_cpt := l_cpt + 3;
        dbms_output.put_line('l_cpt1:'||l_cpt);
        else
                l_cpt := l_cpt + 2;
        end if;

            ELSE
            l_cpt :=0;
         END IF;
     dbms_output.put_line('l_cpt:'||l_cpt);
      END LOOP;

   pack_global.recuperer_message( 21148,NULL,NULL,NULL, p_message);

   END update_arb;


END pack_arbitre;
/


