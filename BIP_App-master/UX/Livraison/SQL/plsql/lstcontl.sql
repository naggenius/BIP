-- pack_ctl_lstcontl PL/SQL
--
-- equipe SOPRA
--
-- crée le 11/10/1999
--
-- Attention le nom du package ne peut etre le nom
-- de la table...
--- modifié le 06/11/2009 ABA correction concernant le retour des message en cas d'inexistance de la société
--- modifié le 06/11/2009 YSB Ajout de la procédure select_Numexpense
-- 28/11/2011 BSA QC 1281
-- 30/01/2012 BSA QC 1281 gestion du centre de frais.

CREATE OR REPLACE PACKAGE     pack_ctl_lstcontl AS
-- ---------------------------------------------
TYPE RefCurTyp IS REF CURSOR;

      PROCEDURE select_lstcontl(
                 p_inutile   	IN  VARCHAR2,       		--  inutilisé
                 p_SOCCODE 	IN  societe.SOCCODE%TYPE, 	-- CHAR(4)
                 p_codsg   	IN  VARCHAR2,       		--  NUMBER(7)
                 p_IDENT 	IN  VARCHAR2,          		--  NUMBER(5)
                 p_ctypfact 	IN  contrat.ctypfact%TYPE,     	--  Sans utilité
                 p_datdeb 	IN  VARCHAR2,         		-- date
                 p_datfin 	IN  VARCHAR2,         		-- date
                 p_ccoutht	IN  VARCHAR2,        		--  Sans utilité
                 p_userid  	IN  VARCHAR2,
                 P_message 	OUT VARCHAR2
                 );

	PROCEDURE select_dpg (	p_userid  IN  VARCHAR2,
			 	p_codsg   IN  VARCHAR2,
                         	p_focus   IN  VARCHAR2,
                         	p_msg     OUT VARCHAR2
                 );

      PROCEDURE select_societe
                (p_SOCCODE IN  societe.SOCCODE%TYPE,
                 p_focus   IN  VARCHAR2,
                 p_msg     OUT VARCHAR2
                 );


      PROCEDURE select_ressource
                (p_IDENT IN  VARCHAR2,
                 p_focus IN  VARCHAR2,
                 p_msg   OUT VARCHAR2
                 );
      PROCEDURE select_periode (
                    p_datdeb IN VARCHAR2,
                    p_datfin IN VARCHAR2,
                    p_focus  IN VARCHAR2,
                    p_msg    OUT VARCHAR2
                    );

      PROCEDURE select_periode (
                    p_datdeb IN VARCHAR2,
                    p_datfin IN VARCHAR2,
                    p_focus  IN VARCHAR2,
                    p_oblige IN BOOLEAN,
                    p_msg    OUT VARCHAR2
                    );

      PROCEDURE select_periode (
                    p_datdeb   IN  VARCHAR2,
                    p_datfin   IN  VARCHAR2,
                    p_focusDeb IN  VARCHAR2,
                    p_focusFin IN  VARCHAR2,
                    p_msg      OUT VARCHAR2
                    );

   PROCEDURE select_Numexpense
                (p_numexpense IN  societe.SOCCODE%TYPE,
                 p_focus   IN  VARCHAR2,
                 p_msg     OUT VARCHAR2
                 );



      l_msg   VARCHAR2(1024);


END pack_ctl_lstcontl;
/


CREATE OR REPLACE PACKAGE BODY     pack_ctl_lstcontl AS

-- ------------------------------------------------
   PROCEDURE select_lstcontl(
                 p_inutile   IN  VARCHAR2,       	-- inutilisé
                 p_SOCCODE   IN  societe.SOCCODE%TYPE, 	-- CHAR(4)
                 p_codsg     IN  VARCHAR2,       	-- NUMBER(7)
                 p_IDENT     IN  VARCHAR2,          	-- NUMBER(5)
                 p_ctypfact  IN  contrat.ctypfact%TYPE, -- Sans utilité
                 p_datdeb    IN  VARCHAR2,         	-- date
                 p_datfin    IN  VARCHAR2,         	-- date
                 p_ccoutht   IN  VARCHAR2,        	-- Sans utilité
                 p_userid    IN  VARCHAR2,
                 P_message   OUT VARCHAR2
                 ) is
      l_message   VARCHAR2(1024);
   BEGIN
      l_message := '';
      if (p_SOCCODE is not null) then
      	select_societe (p_SOCCODE,'P_param7', l_message);
      end if;
      if (l_message is null) and (p_codsg is not null ) then
         select_dpg (p_userid,p_codsg,'P_param8', l_message);
      end if;
      if (l_message is null) and (p_ident is not null) then
         select_ressource (p_ident,'P_param9', l_message);
      end if;
      -- Controle de la periode
      if (l_message is null) then
		select_periode (p_datdeb, p_datfin, 'P_param11', l_message);
      end if;
      p_message := l_message;
   END select_lstcontl;
-- ------------------
   PROCEDURE select_dpg (   p_userid  IN  VARCHAR2,
			                p_codsg   IN  VARCHAR2,
                            p_focus   IN  VARCHAR2,
                            p_msg     OUT VARCHAR2
                        ) IS

    l_msg   	    VARCHAR2(1024);
    l_codsg 	    VARCHAR2(10);
    l_centre_frais 	centre_frais.codcfrais%TYPE;
    l_scentrefrais 	centre_frais.codcfrais%TYPE;

    t_codsg         STRUCT_INFO.CODSG%TYPE;
    t_scentrefrais  STRUCT_INFO.SCENTREFRAIS%TYPE;
    verif_codsg    varchar2(1024);

    BEGIN

        l_msg := '';
        
        -- On récupère le code centre de frais de l'utilisateur
        l_centre_frais:=pack_global.lire_globaldata(p_userid).codcfrais;    
    
        -- P_codsg est de la forme 'N******', 'NN*****', .... 'NNNNNNN'
        -- On formate sur 7 caracteres a gauche par 0 puis on supprime les *
        l_codsg := RTRIM(RTRIM(LPAD(P_codsg, 7, '0'),'*')) || '%';
        
        -- On test si le DPG existe
        BEGIN
	        select codsg
            into verif_codsg
		      from STRUCT_INFO
		     where TO_CHAR(codsg,'FM0000000') like l_codsg
             and rownum = 1;

		EXCEPTION
		    WHEN NO_DATA_FOUND then
             -- Code Département/Pôle/Groupe %s1 inexistant
            pack_global.recuperer_message(2064, '%s1',p_codsg, p_focus, l_msg);
            raise_application_error(-20334, l_msg);
            WHEN OTHERS then
               	raise_application_error(-20997, SQLERRM);
		END;

    -- si centre de frais différent de 0. 0 -> toutes la BIP
    IF l_centre_frais != 0 THEN
	    BEGIN
	        select scentrefrais
	          into l_scentrefrais
		      from STRUCT_INFO
		     where TO_CHAR(codsg,'FM0000000') like l_codsg
                and scentrefrais = l_centre_frais
                and rownum = 1;

		EXCEPTION
		    WHEN NO_DATA_FOUND then
                --msg:Ce DPG n'appartient pas à ce centre de frais
                pack_global.recuperer_message(20334, '%s1',to_char(l_centre_frais),'P_param8', l_msg);
               -- pack_global.recuperer_message(21216, NULL, NULL, NULL, l_msg);
                raise_application_error(-20334, l_msg);
            WHEN OTHERS then
               	raise_application_error(-20997, SQLERRM);
		END;
    END IF;
    
    p_msg := l_msg;

END select_dpg;
-- -------------
   PROCEDURE select_societe
                (p_SOCCODE IN  societe.SOCCODE%TYPE,
                 p_focus   IN  VARCHAR2,
                 p_msg     OUT VARCHAR2
                 ) IS
      l_msg   VARCHAR2(1024);
      l_soccode societe.soccode%TYPE;
    BEGIN
      l_msg := '';
      BEGIN
            SELECT soccode INTO l_soccode
            FROM   societe
            WHERE  soccode = p_soccode;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            -- Code société inexistant
            pack_global.recuperer_message(4000, '%s1', p_soccode , p_focus, l_msg);
            raise_application_error( -20998, l_msg);
         WHEN OTHERS THEN
            raise_application_error(-20997,SQLERRM);
      END;
      p_msg := l_msg;
   END select_societe;
-- ------------------
   PROCEDURE select_ressource (p_IDENT IN VARCHAR2,
                               p_focus IN  VARCHAR2,
                               p_msg OUT VARCHAR2
                              ) IS
      l_msg   VARCHAR2(1024);
      l_IDENT Ressource.IDENT%TYPE;
    BEGIN
      l_msg := '';
      BEGIN
            SELECT IDENT INTO l_IDENT
            FROM   Ressource
            WHERE  IDENT = to_number(p_IDENT);
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            -- Code Ressource %s1 inexistant
            pack_global.recuperer_message(4001, '%s1' , P_IDENT , p_focus, l_msg);
         WHEN OTHERS THEN
            raise_application_error(-20997,SQLERRM);
      END;
      p_msg := l_msg;
   END select_ressource;
-- ----------------------------------------------------------------------------
-- Procedure select_periode. Cette procedure est surchargée
-- Role : controle d'une periode.
-- Particularite de ce surchagre : la saisie des deux dates simultanement ne
-- sont pas obligatoires, mais la saisie de l'une oblige la saisie de l'autre.
-- ----------------------------------------------------------------------------
   PROCEDURE select_periode (
                    p_datdeb IN  VARCHAR2,
                    p_datfin IN  VARCHAR2,
                    p_focus  IN  VARCHAR2,
                    p_msg    OUT VARCHAR2
                    ) IS
      l_msg   VARCHAR2(1024);
    BEGIN
         if ((p_datdeb is not null) and (p_datfin is null)) or
            ((p_datdeb is null) and (p_datfin is not null)) then
               -- Période erronée
               pack_global.recuperer_message(20431, null, null, p_focus, l_msg);
               raise_application_error(-20431, l_msg);
         elsif (to_date(p_datdeb,'dd/mm/yyyy') > to_date(p_datfin,'dd/mm/yyyy')) then
               -- La date de fin doit être supérieure ou égale à la date de début
               pack_global.recuperer_message(20284, null, null, p_focus, l_msg);
               raise_application_error(-20284, l_msg);
         end if;
    END select_periode;
-- ----------------------------------------------------------------------------
-- Procedure select_periode. Cette procedure est surchargée
-- Role : controle d'une periode.
-- Particularite de ce surchagre : la saisie des deux dates (date de debut et
-- date de fin) est obligatoire
-- ----------------------------------------------------------------------------
   PROCEDURE select_periode (
                    p_datdeb IN VARCHAR2,
                    p_datfin IN VARCHAR2,
                    p_focus  IN VARCHAR2,
                    p_oblige IN BOOLEAN,
                    p_msg    OUT VARCHAR2
                    ) IS
      l_msg   VARCHAR2(1024);
    BEGIN
      l_msg := '';
      IF (p_datdeb is null) AND (p_datfin is null) THEN
               -- Période Obligatoire;
               pack_global.recuperer_message(4002, null, null, p_focus, l_msg);
      ELSIF (p_datdeb is null) or (p_datfin is null) THEN
               -- Période erronée
               pack_global.recuperer_message(20431, null, null, p_focus, l_msg);
               raise_application_error(-20431, l_msg);
      ELSIF (to_date(p_datdeb,'dd/mm/yyyy') > to_date(p_datfin,'dd/mm/yyyy')) then
               -- La date de fin doit être supérieure ou égale à la date de début
               pack_global.recuperer_message(20284, null, null, p_focus, l_msg);
               raise_application_error(-20284, l_msg);
      END IF;
      p_msg := l_msg;
    END select_periode;
-- ----------------------------------------------------------------------------
-- Procedure select_periode. Cette procedure est surchargée
-- Role : controle d'une periode.
-- Particularite de ce surchagre : idem au premier surcharge mais ici les
-- message sont plus explicites et le focus est gere plus precisement.
-- ----------------------------------------------------------------------------
   PROCEDURE select_periode (
                    p_datdeb   IN  VARCHAR2,
                    p_datfin   IN  VARCHAR2,
                    p_focusDeb IN  VARCHAR2,
                    p_focusFin IN  VARCHAR2,
                    p_msg      OUT VARCHAR2
                    ) IS
      l_msg   VARCHAR2(1024);
    BEGIN
          IF (p_datdeb is null) and (p_datfin is not null) THEN
               -- Date de debut obligatoire.
               pack_global.recuperer_message(20440, null, null, p_focusDeb, l_msg);
               raise_application_error(-20440, l_msg);
            ELSIF (p_datdeb is not null) and (p_datfin is null) THEN
               -- Date de fin obligatoire.
               pack_global.recuperer_message(20441, null, null, P_focusFin, l_msg);
               raise_application_error(-20441, l_msg);
          ELSIF (p_datdeb is not null) and (p_datfin is not null)
                  and (to_date(p_datdeb,'dd/mm/yyyy') > to_date(p_datfin,'dd/mm/yyyy')) then
               -- La date de fin doit être supérieure ou égale à la date de début
               pack_global.recuperer_message(20284, null, null, p_focusDeb, l_msg);
               raise_application_error(-20284, l_msg);
          END IF;
    END select_periode;


PROCEDURE select_Numexpense
                (p_numexpense IN  societe.SOCCODE%TYPE,
                 p_focus   IN  VARCHAR2,
                 p_msg     OUT VARCHAR2
                 ) IS

      l_msg   VARCHAR2(1024);
      l_numexpense facture.num_expense%TYPE;
    BEGIN
      l_msg := '';

      BEGIN
            SELECT num_expense INTO l_numexpense
            FROM   facture
            WHERE  num_expense = p_numexpense;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            -- Numéro expense inconnu
            pack_global.recuperer_message(21161, '%s1', p_numexpense , p_focus, l_msg);
            raise_application_error(-20998, l_msg);
         WHEN OTHERS THEN
            raise_application_error(-20997,SQLERRM);
      END;
      p_msg := l_msg;

END select_Numexpense;


END pack_ctl_lstcontl;
/


