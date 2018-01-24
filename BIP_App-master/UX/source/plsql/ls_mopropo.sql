-- pack_liste_moproposes PL/SQL
-- 
-- Créé le 12/10/2001 par ARE
--
-- Modifie le 16/07/2003 par NBM : suppression des parametres p_pidinf,p_pidsup,p_order
--
--*******************************************************************
--
-- Attention le nom du package ne peut etre le nom
-- de la table...


CREATE OR REPLACE PACKAGE pack_liste_moproposes AS
-- Majuscule pour javascript qui utilise le nom des colonnes pour l'automates.

   TYPE moproposes_ListeViewType IS RECORD(CLICODE    ligne_bip.clicode%TYPE,
					  PID        ligne_bip.pid%TYPE,
                                          PNOM       ligne_bip.pnom%TYPE,
                                          FLAGLOCK   VARCHAR2(20),
                                          CODSG      VARCHAR2(20),
                                          BPMONTMO    VARCHAR2(20)
                                         );

   TYPE moproposes_listeCurType IS REF CURSOR RETURN moproposes_ListeViewType;

   PROCEDURE lister_moproposes( p_clicode   IN VARCHAR2,
			      p_annee   IN VARCHAR2,
                              p_userid  IN VARCHAR2,
                              p_curseur IN OUT moproposes_listeCurType
                             );

END pack_liste_moproposes;
/

CREATE OR REPLACE PACKAGE BODY pack_liste_moproposes AS 
PROCEDURE lister_moproposes(  p_clicode IN VARCHAR2,
			      p_annee   IN VARCHAR2,
                              p_userid  IN VARCHAR2,
                              p_curseur IN OUT moproposes_listeCurType
                             ) IS


   l_pid ligne_bip.pid%TYPE;
  -- l_codsg varchar2(10);

   BEGIN

		OPEN p_curseur FOR
		SELECT RTRIM(LTRIM( bip.clicode)) as CLICODE,
		      		bip.pid as PID,
                      		SUBSTR(bip.pnom,1,20) as PNOM,
                      		TO_CHAR(budg.flaglock) as FLAGLOCK,
                      		TO_CHAR(bip.codsg, 'FM0000000') as CODSG,
                      		TO_CHAR(budg.bpmontmo, 'FM9999999990D00') as BPMONTMO
            	FROM      budget budg, ligne_bip bip,datdebex
             	WHERE    bip.clicode = p_clicode
		AND      budg.annee (+)= TO_NUMBER(p_annee)
             	AND      budg.pid (+)= bip.pid
		AND     ((bip.adatestatut is null) OR (to_number(to_char(bip.adatestatut,'YYYY') ) >= TO_NUMBER(p_annee)))
		ORDER BY   bip.clicode ||bip.pid ;


 
  END lister_moproposes;

END pack_liste_moproposes;
/
show errors
