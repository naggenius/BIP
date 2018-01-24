-- -------------------------------------------------------------------
-- pack_facres PL/SQL
--
-- Aurore REMENS
--
-- cr�e le 18/07/2000
--
-- Package qui sert � la r�alisation de l'�tat FACRES
--  Modification
-- ABA 04/08/2008 modification proc�dure concernant la verificaton des habilitations
-- ABA 24/09/2008 modification du test pour le centre de frais pour chaque code dpg
-- ABA 02/10/2008 marche arri�re suppression des modifs
-- CMA 05/11/2010 Ajout de la proc�dure de v�rification ressource/habilitation pour l'�dition des contrats/situations
-- -------------------------------------------------------------------

CREATE OR REPLACE PACKAGE "PACK_FACRES" AS

   PROCEDURE verif_facres(
            p_coderessource IN VARCHAR2,
            p_date_deb      IN VARCHAR2,
            p_date_fin     IN VARCHAR2,
                        p_menu         IN VARCHAR2,
            p_userid     IN VARCHAR2
            );
            
   PROCEDURE verif_ctrres(
            p_menu         IN VARCHAR2,
            p_coderessource IN VARCHAR2,
            p_userid     IN VARCHAR2
            );
END pack_facres;
/


CREATE OR REPLACE PACKAGE BODY "PACK_FACRES" AS
-- ---------------------------------------------------

PROCEDURE verif_facres(
            p_coderessource IN VARCHAR2,
            p_date_deb      IN VARCHAR2,
            p_date_fin     IN VARCHAR2,
            p_menu         IN VARCHAR2,
            p_userid     IN VARCHAR2
                       )

IS
     code_ress        VARCHAR2(30);
     l_msg        VARCHAR2(100);
     l_codsg        varchar2(7);
     l_habilitation     varchar2(10);
     l_date_deb     varchar2(8);
     l_date_fin     varchar2(8);
     l_menu         varchar2(30);
     l_centrefrais     varchar2(30);
     l_cfrais         varchar2(30);









   BEGIN


    -- V�rification que la date d�but est inf�rieure � la date de fin

    select to_char(to_date(p_date_deb,'DD/MM/YYYY'),'YYYYMMDD') INTO l_date_deb from dual;
    select to_char(to_date(p_date_fin,'DD/MM/YYYY'),'YYYYMMDD') INTO l_date_fin from dual;
    if (l_date_deb > l_date_fin) then
        raise_application_error(-20000,'la date de d�but doit �tre inf�rieure � la date de fin');
    end if;

    -- Recherche d'un code ressource correspondant au crit�re p_coderessource
    BEGIN
        select ident into code_ress
        from ressource
        where ident = p_coderessource
        and rownum =1;

        select to_char(codsg, 'FM0000000') into l_codsg
        from situ_ress_full,datdebex
        where ident=p_coderessource
        and datsitu <= moismens
        and (datdep > moismens or datdep is null);


     EXCEPTION
         WHEN NO_DATA_FOUND THEN -- Msg Code  ressource inconnue
                          pack_global.recuperer_message(20017, NULL, NULL, NULL, l_msg);
                          raise_application_error(-20017,l_msg);

        WHEN OTHERS THEN
                     raise_application_error(-20997, SQLERRM);
    END;

    l_menu := pack_global.lire_globaldata(p_userid).menutil;

    IF l_menu != 'ACH' THEN

     -- =====================================================================
     -- 07/02/2001 : Test si le DPG appartient au p�rim�tre de l'utilisateur
     -- =====================================================================
             l_habilitation := pack_habilitation.fhabili_me( l_codsg, p_userid );



        If l_habilitation='faux' then
        -- 'Vous n''�tes pas habilit� � cette ressource'
            pack_global.recuperer_message(20364, '%s1', '� cette ressource', 'P_param6', l_msg);
                    raise_application_error(-20364,l_msg);
        End if;

    ELSE

        l_centrefrais := pack_global.lire_globaldata(p_userid).codcfrais;
        IF (l_centrefrais <> 0) THEN


            SELECT scentrefrais INTO l_cfrais
            FROM struct_info
            where codsg = TO_NUMBER(l_codsg);

            IF l_cfrais <> l_centrefrais THEN
                -- 'Vous n''�tes pas habilit� � cette ressource'
                pack_global.recuperer_message(20364, '%s1', '� cette ressource', 'P_param6', l_msg);
                        raise_application_error(-20364,l_msg);
            End if;
        END IF;
    END IF;

   END verif_facres;


PROCEDURE verif_ctrres(
            p_menu         IN VARCHAR2,
            p_coderessource IN VARCHAR2,
            p_userid     IN VARCHAR2
                       )

IS
     code_ress        VARCHAR2(30);
     l_msg        VARCHAR2(100);
     l_codsg        varchar2(7);
     l_habilitation     varchar2(10);
     l_menu         varchar2(30);
     l_centrefrais     varchar2(30);
     l_cfrais         varchar2(30);


   BEGIN


    -- Recherche d'un code ressource correspondant au crit�re p_coderessource
    BEGIN
        select ident into code_ress
        from ressource
        where ident = p_coderessource
        and rownum =1;

        select to_char(codsg, 'FM0000000') into l_codsg
        from situ_ress_full,datdebex
        where ident=p_coderessource
        and datsitu <= moismens
        and (datdep > moismens or datdep is null);


     EXCEPTION
         WHEN NO_DATA_FOUND THEN -- Msg Code  ressource inconnue
                          pack_global.recuperer_message(20017, NULL, NULL, NULL, l_msg);
                          raise_application_error(-20017,l_msg);

        WHEN OTHERS THEN
                     raise_application_error(-20997, SQLERRM);
    END;

    l_menu := pack_global.lire_globaldata(p_userid).menutil;

    IF l_menu != 'ACH' THEN


     -- =====================================================================
     -- 07/02/2001 : Test si le DPG appartient au p�rim�tre de l'utilisateur
     -- =====================================================================
             l_habilitation := pack_habilitation.fhabili_me( l_codsg, p_userid );



        If l_habilitation='faux' then
        -- 'Vous n''�tes pas habilit� � cette ressource'
            pack_global.recuperer_message(20364, '%s1', '� cette ressource', 'P_param10', l_msg);
                    raise_application_error(-20364,l_msg);
        End if;

    ELSE

        l_centrefrais := pack_global.lire_globaldata(p_userid).codcfrais;
        IF (l_centrefrais <> 0) THEN


            SELECT scentrefrais INTO l_cfrais
            FROM struct_info
            where codsg = TO_NUMBER(l_codsg);

            IF l_cfrais <> l_centrefrais THEN
                -- 'Vous n''�tes pas habilit� � cette ressource'
                pack_global.recuperer_message(20364, '%s1', '� cette ressource', 'P_param10', l_msg);
                        raise_application_error(-20364,l_msg);
            End if;
        END IF;
    END IF;

   END verif_ctrres;

END pack_facres;
/


