-- pack_liste_situation_logiciel PL/SQL
--
-- Equipe SOPRA
--
-- Cree le 01/03/1999
--
-- Modifié le 25/06/2003(NBM): ajout/suppression espaces
-- Objet : Permet la création de la liste des situation_logiciels
-- Tables : situ_ress
-- Pour le fichier HTML : dtsitlog
-- Modifié le 01/03/2006 (PPR) : va chercher le cout dans la table SITU_RESS
--
--*************************************************************************
--
-- Attention le nom du package ne peut etre le nom
-- de la table...

CREATE OR REPLACE PACKAGE pack_liste_situation_logiciel AS

  TYPE situation_l_RecType IS RECORD (datsitu    VARCHAR2(20),
                                      lib        VARCHAR2(150));


   TYPE situation_l_CurType IS REF CURSOR RETURN situation_l_RecType;

   PROCEDURE lister_situation_logiciel(p_ident   IN CHAR,
                                       p_userid  IN VARCHAR2,
                                       p_curseur IN OUT situation_l_CurType
                                      );

END pack_liste_situation_logiciel;
/

CREATE OR REPLACE PACKAGE BODY pack_liste_situation_logiciel AS 

----------------------------------- SELECT -----------------------------------

   PROCEDURE lister_situation_logiciel (p_ident   IN CHAR,
                                        p_userid  IN VARCHAR2,
                                        p_curseur IN OUT situation_l_CurType
                                       ) IS
   BEGIN
      OPEN p_curseur FOR SELECT
             TO_CHAR(datsitu,'dd/mm/yyyy'),
	     NVL(TO_CHAR(datsitu,'dd/mm/yyyy'), '          ')||' '||
             NVL(TO_CHAR(datdep,'dd/mm/yyyy'),'          ')||''||
             TO_CHAR(codsg, '0000000')||' '||
             RPAD(prestation, 3, ' ')||'    '||      -- 3
             RPAD(soccode, 4, ' ')||' '||         -- 4
             TO_CHAR(nvl(cout,0), '999990D00')
     FROM situ_ress
     WHERE ident = TO_NUMBER(p_ident)
     ORDER BY datsitu DESC;

   END lister_situation_logiciel;

END pack_liste_situation_logiciel;
/
