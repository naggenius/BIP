-- Modifié le 15/03/2004 par EGR : test sur apartenance du DPG au perime
-- Modifié le 08/08/2011 par CMA : correction des comparaisons de datsitu et sysdate au même format
-- Modifié le 12/10/2011 par OEL : Nouvelles règles pour la maj CDP QC1259

CREATE OR REPLACE PACKAGE PACK_CODE_CP AS

	procedure modifier_cp(	p_codsg in varchar2,
							p_pcpi in varchar2,
							p_nouveau_pcpi in varchar2,
							p_userid in varchar2,
							p_message out varchar2);

END PACK_CODE_CP;
/


CREATE OR REPLACE PACKAGE BODY     PACK_CODE_CP AS

    procedure modifier_cp(  p_codsg in varchar2,
                            p_pcpi in varchar2,
                            p_nouveau_pcpi in varchar2,
                            p_userid in varchar2,
                            p_message out varchar2)
    IS
        l_msg VARCHAR2(1024);
        ldatsitu VARCHAR2(10);
        l_date_courante VARCHAR2(20);
        l_ident ressource.ident%TYPE;
        l_pcpi ligne_bip.pcpi%TYPE;
        l_ligbip_rowcount BINARY_INTEGER;
        l_situ_rowcount BINARY_INTEGER;
        l_test number(2);

        l_habilitation  VARCHAR2(10);
    BEGIN

        l_ligbip_rowcount := 0;
        l_situ_rowcount := 0;

        l_habilitation := pack_habilitation.fhabili_me( p_codsg, p_userid);
        IF l_habilitation='faux' THEN
                -- Vous n'êtes pas habilité à ce DPG 20364
                pack_global.recuperer_message(20364, '%s1', 'à ce DPG', 'CODSG', l_msg);
                raise_application_error(-20364, l_msg);
        END IF;

        --test si la situation du nouveau code cp p_nouveau_pcpi existe pour le DPG codsg

        /*
        BEGIN
            SELECT
                distinct sit.ident INTO l_ident
            FROM
                ligne_bip lig,
                struct_info str,
                ressource res,
                situ_ress sit
            WHERE
                str.codsg = lig.codsg
            AND str.codsg = sit.codsg
            AND res.ident = sit.ident
            AND TO_CHAR(sit.DATSITU, 'yyyymmdd') <= TO_CHAR(sysdate, 'yyyymmdd')
            AND (TO_CHAR(sit.DATDEP, 'yyyymmdd') >= TO_CHAR(sysdate, 'yyyymmdd') OR sit.DATDEP IS NULL)
            AND str.codsg=to_number(p_codsg)
            AND res.ident=to_number(p_nouveau_pcpi);

        EXCEPTION
            WHEN TOO_MANY_ROWS OR NO_DATA_FOUND THEN
                pack_global.recuperer_message(20978, '%s1', p_nouveau_pcpi, '%s2', p_codsg, NULL, l_msg);
                p_message := l_msg;
                raise_application_error( -20978, l_msg );

            WHEN OTHERS THEN
                raise_application_error( -20999, SQLERRM);
        END;

        */
        
        BEGIN
            SELECT
                distinct res.ident INTO l_ident
            FROM
                ressource res
            WHERE
            res.ident=to_number(p_nouveau_pcpi);
            
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                pack_global.recuperer_message(20979, '%s1', p_nouveau_pcpi, NULL, l_msg);
                p_message := l_msg;
                raise_application_error( -20979, l_msg );

            WHEN OTHERS THEN
                raise_application_error( -20999, SQLERRM);
        END;


        BEGIN
            SELECT
                distinct sit.ident INTO l_ident
            FROM
                struct_info str,
                situ_ress sit
            WHERE
                str.codsg = sit.codsg
            AND TO_CHAR(sit.DATSITU, 'yyyymmdd') <= TO_CHAR(sysdate, 'yyyymmdd')
            AND (TO_CHAR(sit.DATDEP, 'yyyymmdd') >= TO_CHAR(sysdate, 'yyyymmdd') OR sit.DATDEP IS NULL)
            AND str.codsg=to_number(p_codsg)
            AND sit.IDENT = to_number(p_nouveau_pcpi);
            
        EXCEPTION
            WHEN TOO_MANY_ROWS OR NO_DATA_FOUND THEN
                pack_global.recuperer_message(20978, '%s1', p_nouveau_pcpi, '%s2', p_codsg, NULL, l_msg);
                p_message := l_msg;
                raise_application_error( -20978, l_msg );

            WHEN OTHERS THEN
                raise_application_error( -20999, SQLERRM);
        END;


        -- test si l ancien CP existe et/ou a une situation
        /*
        BEGIN
            SELECT
                distinct sit.ident INTO l_ident
            FROM
                situ_ress sit
            WHERE
            TO_CHAR(sit.DATSITU, 'yyyymmdd') <= TO_CHAR(sysdate, 'yyyymmdd')
            AND (TO_CHAR(sit.DATDEP, 'yyyymmdd') >= TO_CHAR(sysdate, 'yyyymmdd') OR sit.DATDEP IS NULL)
            AND sit.ident=to_number(p_pcpi);
        */
        
        BEGIN
            SELECT
                distinct res.ident INTO l_ident
            FROM
                ressource res
            WHERE
            res.ident=to_number(p_pcpi);
        
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                pack_global.recuperer_message(20979, '%s1', p_pcpi, NULL, l_msg);
                p_message := l_msg;
                raise_application_error( -20979, l_msg );

            WHEN OTHERS THEN
                raise_application_error( -20999, SQLERRM);
        END;

        BEGIN

            begin
                -- récupération de l'année en cours au sens date de traitement annuel
            select to_char(datdebex.datdebex, 'yyyy') into l_date_courante from datdebex;
            EXCEPTION WHEN OTHERS THEN
                raise_application_error( -20999, SQLERRM);
            end;

            -- maj des lignes bip avec le nouveau code p_nouveau_pcpi

            update ligne_bip set
                pcpi=to_number(p_nouveau_pcpi)
            where
                (adatestatut is null or  (adatestatut is not null and to_number(to_char(adatestatut, 'yyyy')) = to_number(l_date_courante)))
                and codsg = p_codsg
                and pcpi=p_pcpi;

        --  IF (SQL%NOTFOUND) THEN
                -- l'ancien code cp p_pcpi n'existe pas
        --      pack_global.recuperer_message(20979, '%s1', p_pcpi, NULL, l_msg);
        --      p_message := l_msg;
        --      raise_application_error( -20979, l_msg );

        --  ELSE
                l_ligbip_rowcount := SQL%ROWCOUNT;
        --  END IF;


            -- maj des situations actives avec le nouveau code p_nouveau_pcpi
            update situ_ress set
                cpident=to_number(p_nouveau_pcpi)
            where
                 -- situ en cours
                (
                (TO_CHAR(DATSITU,'yyyymmdd') <= TO_CHAR(sysdate, 'yyyymmdd') AND (TO_CHAR(DATDEP,'yyyymmdd') >= TO_CHAR(sysdate, 'yyyymmdd') OR DATDEP IS NULL))
                 -- situ future
                OR
                (TO_CHAR(DATSITU, 'yyyymmdd') > TO_CHAR(sysdate, 'yyyymmdd') AND (TO_CHAR(DATDEP, 'yyyymmdd') >= TO_CHAR(sysdate, 'yyyymmdd') OR DATDEP IS NULL))
                )
                and codsg = p_codsg
                and cpident=p_pcpi
                                ;

            --IF (SQL%NOTFOUND) THEN
                --la ressource n existe pas ou n a pas de situation
                --pack_global.recuperer_message(20979, '%s1', p_pcpi, NULL, l_msg);
                --p_message := l_msg;
                --raise_application_error( -20979, l_msg );
            --ELSE
                l_situ_rowcount:= SQL%ROWCOUNT;
            --END IF;


            pack_global.recuperer_message(20980, '%s1', l_ligbip_rowcount, '%s2', l_situ_rowcount,NULL, l_msg);
            p_message := l_msg;

            --dbms_output.put_line('message: ' || p_message);
        END;

    END modifier_cp;

END PACK_CODE_CP;
/


