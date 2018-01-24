--------------------------------------------------------
--  Fichier créé - lundi-octobre-10-2016   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package PACK_PROPOSES_MASSE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "BIP"."PACK_PROPOSES_MASSE" AS
    TYPE proposes_ViewType IS RECORD ( codsg      VARCHAR2(20),
                                       libelle    VARCHAR2(100),
			      	       annee      VARCHAR2(4)
                                     );

   TYPE proposesCurType IS REF CURSOR RETURN proposes_ViewType;


   FUNCTION str_proposes_masse (p_string     IN  VARCHAR2,
                           	p_occurence  IN  NUMBER
                               ) return VARCHAR2;

   PROCEDURE update_proposes_masse(	p_string    IN  VARCHAR2,
                              		p_userid    IN  VARCHAR2,
                              		p_nbcurseur OUT INTEGER,
                              		p_message   OUT VARCHAR2
                             );

   PROCEDURE select_proposes_masse  (	p_codsg        IN VARCHAR2,
			       		p_annee        IN VARCHAR2,
                               		p_userid       IN VARCHAR2,
                               		p_curproposes  IN OUT proposesCurType,
                               		p_nbpages         OUT VARCHAR2,
                               		p_numpage         OUT VARCHAR2,
                               		p_nbcurseur       OUT INTEGER,
                               		p_message         OUT VARCHAR2
                             		 );


END pack_proposes_masse;

 

/
--------------------------------------------------------
--  DDL for Package Body PACK_PROPOSES_MASSE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "BIP"."PACK_PROPOSES_MASSE" AS
   FUNCTION str_proposes_masse (p_string     IN  VARCHAR2,
                           p_occurence  IN  NUMBER
                          ) return VARCHAR2 IS
   pos1 NUMBER(4);
   pos2 NUMBER(4);
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

   END str_proposes_masse;

   PROCEDURE update_proposes_masse(	p_string    IN  VARCHAR2,
                              		p_userid    IN  VARCHAR2,
                              		p_nbcurseur OUT INTEGER,
                              		p_message   OUT VARCHAR2
                             	) IS

   l_msg    VARCHAR2(10000);
   l_cpt    NUMBER(7);
   l_bpannee  budget.annee%TYPE;
   l_pid    ligne_bip.pid%TYPE;
   l_bpmont1 varchar2(20);
   l_bpmont2 varchar2(20);
   l_flaglock   ligne_bip.flaglock%TYPE;
   l_exist NUMBER;

   BEGIN


      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message   := '';
      l_cpt       := 1;
      l_bpannee := TO_NUMBER(pack_proposes_masse.str_proposes_masse(p_string,l_cpt));


      WHILE l_cpt != 0 LOOP
	if l_cpt!=1 then
		l_pid := pack_proposes_masse.str_proposes_masse(p_string,l_cpt);
         	l_flaglock   := TO_NUMBER(pack_proposes_masse.str_proposes_masse(p_string,l_cpt+1));
		l_bpmont1 := pack_proposes_masse.str_proposes_masse(p_string,l_cpt+2);
		l_bpmont2 := pack_proposes_masse.str_proposes_masse(p_string,l_cpt+3);
	else
        	l_pid := pack_proposes_masse.str_proposes_masse(p_string,l_cpt+1);
         	l_flaglock   := TO_NUMBER(pack_proposes_masse.str_proposes_masse(p_string,l_cpt+2));
		l_bpmont1 := pack_proposes_masse.str_proposes_masse(p_string,l_cpt+3);
		l_bpmont2 := pack_proposes_masse.str_proposes_masse(p_string,l_cpt+4);
	end if;


        IF l_pid != '0' THEN
	   IF ((l_bpmont1 is not null) or (l_bpmont2 is not null) or (l_bpmont1!='') or(l_bpmont2!='')) THEN

	  -- Existence de la ligne bip dans prop_budget
             BEGIN
		select 1 into l_exist
		from budget
		where pid=l_pid
		and   annee = l_bpannee;
             EXCEPTION
		WHEN NO_DATA_FOUND THEN
		--Création de la ligne dans la table BUDGET
		INSERT INTO budget (annee, bpdate, bpmontme, bpmontme2, flaglock, pid)
		VALUES (l_bpannee,
			 sysdate,
			TO_NUMBER(l_bpmont1,'FM9999999990D00'),
			TO_NUMBER(l_bpmont2,'FM9999999990D00'),
			0,
			l_pid);

	     END;

	    IF l_exist=1 THEN
		 --Mise à jour de la table PROP_BUDGET
             	UPDATE budget SET
                        	bpdate  = sysdate,
                                bpmontme = DECODE(l_bpmont1,
				 	 ',00', TO_NUMBER('0,00'),
                                          TO_NUMBER(l_bpmont1,'FM9999999990D00')
                                          ),
                                bpmontme2 = DECODE(l_bpmont2,
                                          ',00', TO_NUMBER('0,00'),
                                          TO_NUMBER(l_bpmont2,'FM9999999990D00')
                                          ),
                                flaglock = decode( l_flaglock, 1000000, 0, l_flaglock + 1)
             	WHERE pid = l_pid
         	AND annee = l_bpannee
         	AND flaglock = l_flaglock;

	     END IF;
	   	-- la table budcons est supprimée et remplacée par la table consomme qui n'est pas mise à jour par le tp
	  	-- Mise à jour de la table BUDCONS
		 --pack_proposes.maj_budcons (l_pid);
	 END IF;
	   --END IF;

	    if l_cpt=1 then       --pris en compte de l'année au début de la chaîne {;annee;pid;flaglock;bpmont1;bpmont2;pid;flaglock;bpmont1;bpmont2;..;}
		l_cpt := l_cpt + 5;
		dbms_output.put_line('l_cpt1:'||l_cpt);
	    else
            	l_cpt := l_cpt + 4;
	    end if;

         ELSE
            l_cpt :=0;
         END IF;
dbms_output.put_line('l_cpt:'||l_cpt);
      END LOOP;

      p_message := '';

   END update_proposes_masse;

 PROCEDURE select_proposes_masse  (	p_codsg        IN VARCHAR2,
			       		p_annee        IN VARCHAR2,
                               		p_userid       IN VARCHAR2,
                               		p_curproposes  IN OUT proposesCurType,
                               		p_nbpages         OUT VARCHAR2,
                               		p_numpage         OUT VARCHAR2,
                               		p_nbcurseur       OUT INTEGER,
                              		p_message         OUT VARCHAR2
                              		) IS

      l_msg      VARCHAR2(1024);
      l_pid      ligne_bip.pid%TYPE;
      l_nbpages  NUMBER(5);
      l_ges      NUMBER(1);
      l_habilitation varchar2(10);
      l_codsg varchar2(20);

   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_nbcurseur := 1;
      p_message := '';

      -- Attention ordre des colonnes doit correspondre a l ordre
      -- de declaration dans la table ORACLE (a cause de ROWTYPE)
      -- ou selectionner toutes les colonnes par *

      p_numpage := 'NumPage#1';
     -- ====================================================================
      -- 12/02/2001 : Test appartenance du DPG au périmètre de l'utilisateur
      -- ====================================================================
   	pack_habilitation.verif_habili_me(p_codsg, p_userid ,l_msg);

	IF SUBSTR(LPAD(p_codsg, 7, '0'),4,4) = '****' THEN
			l_codsg :=SUBSTR(LPAD(p_codsg, 7, '0'),1,3)||'%';
	ELSIF SUBSTR(LPAD(p_codsg, 7, '0'),6,2) = '**' AND SUBSTR(LPAD(p_codsg, 7, '0'),4,4) != '****' THEN
			l_codsg :=SUBSTR(p_codsg,1,4)||'%';
	ELSIF SUBSTR(LPAD(p_codsg, 7, '0'),6,2) != '**' AND SUBSTR(LPAD(p_codsg, 7, '0'),4,4) != '****' THEN
			l_codsg :=LPAD(p_codsg, 7, '0')||'%';
	END IF;


         BEGIN

             -- Compte le nombre de page et test si on a des pid

             SELECT count(*)
             INTO   l_nbpages
             FROM   budget budg, ligne_bip bip
             WHERE  TO_CHAR(bip.codsg, 'FM0000000') like l_codsg
             AND    budg.annee(+) = TO_NUMBER(p_annee)
             AND    budg.pid (+)= bip.pid ;


	     -- inutile de tester SQL%NOTFOUND car fonction de groupe renvoie toujours soit NULL, soit une valeur

	     IF (l_nbpages = 0) THEN
               pack_global.recuperer_message( 20279 , '%s1', p_codsg, NULL, l_msg);
               raise_application_error(-20279 , l_msg);
             END IF;

             l_nbpages := CEIL(l_nbpages/10);
             p_nbpages := 'NbPages#'|| l_nbpages;

            OPEN   p_curproposes FOR
                 SELECT codsg,
                        sigdep as LIBELLE,
			p_annee as BPANNEE
                 FROM   struct_info
                 WHERE  TO_CHAR(codsg, 'FM0000000') like  l_codsg;

         EXCEPTION

           WHEN NO_DATA_FOUND THEN
               pack_global.recuperer_message( 20279 , '%s1', p_codsg, NULL, l_msg);
               raise_application_error(-20279 , l_msg);

           WHEN OTHERS THEN
             raise_application_error( -20997, SQLERRM);

         END;

      p_message := l_msg;


  END select_proposes_masse;


END pack_proposes_masse;

/
