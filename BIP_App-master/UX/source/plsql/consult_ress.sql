create or replace
PACKAGE "PACK_CONSULT_RESS" AS

PROCEDURE COUNT_RESS(  p_ident    IN VARCHAR2,
                            p_debnom     IN VARCHAR2,
                            p_nomcont     IN VARCHAR2,
                            p_userid      IN VARCHAR2,
                            p_matricule IN VARCHAR2,
                            p_igg IN VARCHAR2,
                            p_count  IN OUT VARCHAR2,
                            p_message OUT VARCHAR2
                            );

TYPE select_ress_View IS RECORD (
                                 IDENT        VARCHAR2(10) ,
                                 TYPE_RESS        VARCHAR2(10) ,
                                 NOM            VARCHAR2(30) ,
                                 PRENOM            VARCHAR2(15)  ,
                                 COUT_TOT            VARCHAR2(15),
                                 COUT_HTR     VARCHAR2(15),
                                 MATRICULE       VARCHAR2(10) ,
                                 TEL  VARCHAR2(20),
                                 IMMEUBLE  VARCHAR2(10),
                                 ZONES     VARCHAR2(10),
                                 ETAGE     VARCHAR2(10),
                                 BUREAU  VARCHAR2(10),
                                 SOCCODE  VARCHAR2(10),
                                 IGG        VARCHAR2(10)
                              );

TYPE select_ress_ViewCurType IS REF CURSOR RETURN select_ress_View;



PROCEDURE SELECT_RESS( p_ident    IN VARCHAR2,
                            p_debnom     IN VARCHAR2,
                            p_nomcont     IN VARCHAR2,
                            p_userid      IN VARCHAR2,
                            p_matricule   IN VARCHAR2,
                            p_igg         IN VARCHAR2,
                            p_curseur  IN OUT select_ress_ViewCurType,
                            p_message OUT VARCHAR2
                            );

TYPE situ_ress_View IS RECORD (
                                 dat_situ        VARCHAR2(20) ,--DATE_DEB
                                 libel        VARCHAR2(500)
                              );

TYPE situ_ress_ViewCurType IS REF CURSOR RETURN situ_ress_View;

TYPE list_ress_View IS RECORD (
                                 ident        VARCHAR2(20) ,
                                 libel        VARCHAR2(500)
                              );

TYPE list_ress_ViewCurType IS REF CURSOR RETURN list_ress_View;

PROCEDURE LISTER_SITU( p_ident    IN VARCHAR2,
                            p_debnom     IN VARCHAR2,
                            p_nomcont     IN VARCHAR2,
                            p_userid      IN VARCHAR2,
                            p_matricule IN VARCHAR2,
                            p_igg IN VARCHAR2,
                            p_curseur  IN OUT situ_ress_ViewCurType
                            );

PROCEDURE LISTER_RESS( p_debnom     IN VARCHAR2,
                            p_nomcont     IN VARCHAR2,
                            p_userid     IN VARCHAR2,
                            p_matricule IN VARCHAR2,
                            p_igg IN VARCHAR2,
                            p_curseur  IN OUT list_ress_ViewCurType
                            );


FUNCTION get_siren(p_soccode    IN VARCHAR2) RETURN VARCHAR2;
-- PRAGMA RESTRICT_REFERENCES(get_siren,wnds,wnps);

FUNCTION hab_perime(p_ident IN VARCHAR2,p_perime IN VARCHAR2) RETURN NUMBER;

FUNCTION affichage_prenom (p_typeress ressource.rtype%type,
                           p_prenom ressource.rprenom%type) return VARCHAR2;

END PACK_CONSULT_RESS;
 
/
create or replace
PACKAGE BODY     pack_consult_ress AS


PROCEDURE COUNT_RESS(  p_ident    IN VARCHAR2,
                            p_debnom     IN VARCHAR2,
                            p_nomcont     IN VARCHAR2,
                            p_userid      IN VARCHAR2,
                            p_matricule IN VARCHAR2,
                            p_igg IN VARCHAR2,
                            p_count  IN OUT VARCHAR2,
                            p_message OUT VARCHAR2
                            )IS
l_count NUMBER;
l_perime VARCHAR2(1000);
l_menu   VARCHAR2(255);
l_dpg VARCHAR2(255);

CURSOR C_CODSG IS SELECT codsg FROM situ_ress
      where ident = to_number(p_ident)
      and rownum <3
      order by datsitu desc;

CURSOR C_CODSG_IGG IS SELECT codsg FROM ressource r, situ_ress s
      where r.ident = s.ident
      and r.igg = to_number(p_igg)
      and rownum <3
      order by datsitu desc;

CURSOR C_CODSG_MAT IS SELECT codsg FROM ressource r, situ_ress s
      where r.ident = s.ident
      and r.matricule = upper(p_matricule)
      and rownum <3
      order by datsitu desc;

BEGIN

    l_count := 0;
    p_message := '';
    l_dpg := '';
    l_perime := PACK_GLOBAL.lire_globaldata(p_userid).perime;
    l_menu := Pack_Global.lire_globaldata(p_userid).menutil;

    BEGIN

     if(p_ident is not null) THEN
          select
              count(*) into l_count
                from ressource r
                where r.ident = p_ident;
     ELSIF(p_igg is not null) THEN
         select
            count(*) into l_count
              from ressource r
              where to_char(r.igg) = p_igg;
     ELSIF(p_matricule is not null) THEN
         select
            count(*) into l_count
              from ressource r
              where r.matricule = UPPER(p_matricule);
     ELSIF(p_nomcont is not null) THEN
         select
            count(*) into l_count
              from ressource r
              where r.RNOM like '%'||UPPER(p_nomcont)||'%';
     ELSE
        select
            count(*) into l_count
              from ressource r
              where r.RNOM like UPPER(p_debnom)||'%';
     END IF;

     if(l_count = 0) then
        pack_global.recuperer_message( 21019,null,null,null,p_message);
     elsif(l_count != 0 AND l_menu = 'ME') then
           if(p_ident is not null) THEN
                select
                    count(*) into l_count
                    from ressource r
                    where r.ident = p_ident
                    and pack_consult_ress.hab_perime(r.ident,l_perime) = 1;
                 if(l_count = 0) then
                    FOR ONE_DPG IN C_CODSG LOOP
                      if(length(l_dpg) != 0) then
                        IF(INSTR(l_dpg,ONE_DPG.codsg) <= 0) THEN
                          l_dpg := l_dpg || ',' || ONE_DPG.codsg  ;
                        END IF;
                      else
                        l_dpg := ONE_DPG.codsg;
                      end if;
                    END LOOP;
                    pack_global.recuperer_message( 21175,'%s1',l_dpg,null,p_message);
                 end if;
           elsif(p_igg is not null) THEN
                select count(*) into l_count
                from ressource r
                where r.igg = p_igg
                and pack_consult_ress.hab_perime(r.ident,l_perime) = 1;
                if(l_count = 0) then
                  FOR ONE_DPG IN C_CODSG_IGG LOOP
                      if(length(l_dpg) != 0) then
                        IF(INSTR(l_dpg,ONE_DPG.codsg) <= 0) THEN
                          l_dpg := l_dpg || ',' || ONE_DPG.codsg  ;
                        END IF;
                      else
                        l_dpg := ONE_DPG.codsg;
                      end if;
                    END LOOP;
                    pack_global.recuperer_message( 21175,'%s1',l_dpg,null,p_message);
               end if;
           elsif(p_matricule is not null) THEN
                select count(*) into l_count
                from ressource r
                where r.matricule = UPPER(p_matricule)
                and pack_consult_ress.hab_perime(r.ident,l_perime) = 1;
                if(l_count = 0) then
                  FOR ONE_DPG IN C_CODSG_MAT LOOP
                      if(length(l_dpg) != 0) then
                        IF(INSTR(l_dpg,ONE_DPG.codsg) <= 0) THEN
                          l_dpg := l_dpg || ',' || ONE_DPG.codsg  ;
                        END IF;
                      else
                        l_dpg := ONE_DPG.codsg;
                      end if;
                    END LOOP;
                    pack_global.recuperer_message( 21175,'%s1',l_dpg,null,p_message);
               end if;
           elsif(p_nomcont is not null) THEN
                select count(*) into l_count
                    from ressource r
                    where r.rnom like '%'||UPPER(p_nomcont)||'%'
                    and pack_consult_ress.hab_perime(r.ident,l_perime) = 1;
               if(l_count = 0) then
                  pack_global.recuperer_message( 21174,null,null,null,p_message);
               end if;
          elsif(p_debnom is not null) then
                select count(*) into l_count
                    from ressource r
                    where r.RNOM like UPPER(p_debnom)||'%'
                    and pack_consult_ress.hab_perime(r.ident,l_perime) = 1;
               if(l_count = 0) then
                  pack_global.recuperer_message( 21174,null,null,null,p_message);
               end if;
          end if;
     end if;

     p_count := l_count;

     END;
END  COUNT_RESS;

PROCEDURE SELECT_RESS( p_ident    IN VARCHAR2,
                            p_debnom     IN VARCHAR2,
                            p_nomcont     IN VARCHAR2,
                            p_userid      IN VARCHAR2,
                            p_matricule   IN VARCHAR2,
                            p_igg         IN VARCHAR2,
                            p_curseur  IN OUT select_ress_ViewCurType,
                            p_message OUT VARCHAR2
                            ) IS

l_perime VARCHAR2(1000);
l_menu   VARCHAR2(255);
l_ident VARCHAR2(255);


BEGIN

    l_perime := PACK_GLOBAL.lire_globaldata(p_userid).perime;
    l_menu := Pack_Global.lire_globaldata(p_userid).menutil;
    p_message := '';

      BEGIN


      if(p_ident is not null)   then
          l_ident := p_ident;
      elsif(p_igg is not null) then
        if(l_menu = 'ME') then
          select IDENT into l_ident
          from ressource r
          where r.igg = p_igg
          and pack_consult_ress.hab_perime(r.ident,l_perime) = 1;
        else
          select IDENT into l_ident
          from ressource r
          where r.igg = p_igg;
        end if;
      elsif(p_matricule is not null) then
        if(l_menu = 'ME') then
          select IDENT into l_ident
          from ressource r
          where r.matricule = UPPER(p_matricule)
          and pack_consult_ress.hab_perime(r.ident,l_perime) = 1;
        else
          select IDENT into l_ident
          from ressource r
          where r.matricule = UPPER(p_matricule);
        end if;
      elsif(p_nomcont is not null) then
         if(l_menu = 'ME') then
           select IDENT into l_ident
              from ressource r
              where r.rnom like '%'||UPPER(p_nomcont)||'%'
              and pack_consult_ress.hab_perime(r.ident,l_perime) = 1;
         else
           select IDENT into l_ident
              from ressource r
              where r.rnom like '%'||UPPER(p_nomcont)||'%';
         end if;
      else
         if(l_menu = 'ME') then
          select IDENT into l_ident
            from ressource r
            where r.rnom like UPPER(p_debnom)||'%'
            and pack_consult_ress.hab_perime(r.ident,l_perime) = 1;
         else
           select IDENT into l_ident
              from ressource r
              where r.rnom like upper(p_debnom)||'%';
         end if;
      end if;

        BEGIN
          OPEN    p_curseur FOR
             select
                  to_char(r.IDENT) ident,
                  r.RTYPE rtype,
                  r.RNOM nom,
                  decode(pack_consult_ress.affichage_prenom(r.rtype, r.rprenom),'O',r.RPRENOM,null) prenom,
                  decode(r.RTYPE,'P',null,to_char(r.COUTOT)) cout_tot,
                  decode(r.RTYPE,'L',(select cout from situ_ress where ident = l_ident and rownum < 2),null) cout_htr, -- n'est pas utilisé
                  decode(r.RTYPE,'P',to_char(r.MATRICULE),null) matricule,
                  decode(r.RTYPE,'P',to_char(r.RTEL),null) tel,
                  decode(r.RTYPE,'P',to_char(r.ICODIMM),null) immeuble,
                  decode(r.RTYPE,'P',to_char(r.BATIMENT),null) zones,
                  decode(r.RTYPE,'P',to_char(r.ETAGE),null) etage,
                  decode(r.RTYPE,'P',to_char(r.BUREAU),null) bureau,
                  (select soccode from situ_ress where ident = l_ident and
                  datsitu = (select max(datsitu) from situ_ress where ident = l_ident)) soccode,
                  r.IGG igg
                  from ressource r
                  where r.ident = l_ident;
        EXCEPTION
           WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR( -21019, SQLERRM);
        END;

      END;
END  SELECT_RESS;

PROCEDURE LISTER_SITU( p_ident    IN VARCHAR2,
                            p_debnom     IN VARCHAR2,
                            p_nomcont     IN VARCHAR2,
                            p_userid      IN VARCHAR2,
                            p_matricule IN VARCHAR2,
                            p_igg IN VARCHAR2,
                            p_curseur  IN OUT situ_ress_ViewCurType
                            ) IS
    l_ident VARCHAR2(255);
    l_menu   VARCHAR2(255);
    l_perime VARCHAR2(1000);

      BEGIN

      l_menu := Pack_Global.lire_globaldata(p_userid).menutil;
      l_perime := PACK_GLOBAL.lire_globaldata(p_userid).perime;

      if(p_ident is not null)   then
          l_ident := p_ident;
      elsif(p_igg is not null) then
        if(l_menu = 'ME') then
          select IDENT into l_ident
            from ressource r
            where r.igg = p_igg
            and pack_consult_ress.hab_perime(r.ident,l_perime) = 1;
        else
          select IDENT into l_ident
            from ressource r
            where r.igg = p_igg;
        end if;
      elsif(p_matricule is not null) then
        if(l_menu = 'ME') then
          select IDENT into l_ident
            from ressource r
            where r.matricule = UPPER(p_matricule)
            and pack_consult_ress.hab_perime(r.ident,l_perime) = 1;
        else
          select IDENT into l_ident
            from ressource r
            where r.matricule = UPPER(p_matricule);
        end if;
      elsif(p_nomcont is not null) then
        if(l_menu = 'ME') then
          select IDENT into l_ident
            from ressource r
            where r.rnom like '%'||UPPER(p_nomcont)||'%'
            and pack_consult_ress.hab_perime(r.ident,l_perime) = 1;
        else
          select IDENT into l_ident
            from ressource r
            where r.rnom like '%'||UPPER(p_nomcont)||'%';
        end if;
      else
       if(l_menu = 'ME') then
        select IDENT into l_ident
          from ressource r
          where r.rnom like UPPER(p_debnom)||'%'
          and pack_consult_ress.hab_perime(r.ident,l_perime) = 1;
       else
        select IDENT into l_ident
            from ressource r
            where r.rnom like UPPER(p_debnom)||'%';
       end if;
      end if;

     OPEN    p_curseur FOR
      SELECT
        TO_CHAR(datsitu,'dd/mm/yyyy'),
		RPAD(NVL(TO_CHAR(datsitu,'dd/mm/yyyy'), '---'), 11, ' ')||
        RPAD(NVL(TO_CHAR(datdep,'dd/mm/yyyy'), '---'), 11, ' ')||
        RPAD(NVL(TO_CHAR(codsg, 'FM0000000'), '---'), 8, ' ')||
        RPAD(NVL(SOCCODE, '---'), 5, ' ')||
        RPAD((select decode(rs.rtype,'P',decode(to_char(SOCCODE),'SG..','---',NVL(get_siren(r.soccode), '---')),NVL(get_siren(r.soccode), '---')) from dual), 12, ' ')||
        RPAD((select  decode(rs.rtype,'P',decode(to_char(SOCCODE),'SG..','---',NVL(substr(SOCLIB,1,10), '---')),NVL(substr(SOCLIB,1,10), '---')) from societe  st where st.soccode =  r.soccode), 13, ' ')||
        RPAD(NVL((select code_domaine from prestation pr where pr.prestation = r.prestation), '---'), 5, ' ')||
        RPAD(NVL(prestation, '---'), 5, ' ')||
        RPAD(NVL(MODE_CONTRACTUEL_INDICATIF, '---'), 6, ' ')||
        RPAD(NVL(to_char(CPIDENT), '---'), 7, ' ')||
        -- FAD PPM 63904 : Ajout de la colonne Forf
        RPAD(NVL(to_char(FIDENT), '---'), 7, ' ')||
        -- FAD PPM 63904 : Fin
        RPAD(decode(rs.rtype,'P',decode(to_char(SOCCODE),'SG..',NVL(NIVEAU, '---'),'---'),'---'), 4, ' ')||
        RPAD(decode(rs.rtype,'P',NVL(to_char('  '||DISPO), '---'),'---'), 5, ' ')||
        RPAD(decode(rs.rtype,'P',decode(to_char(SOCCODE),'SG..','     ---',NVL(to_char(COUT,'999990D00'), '     ---')),NVL(to_char(COUT,'999990D00'), '     ---')),13, ' ')||
        RPAD(decode(rs.rtype,'E','HT','F','HT','L','HTR','P',DECODE(TO_CHAR(SOCCODE),'SG..','HTR','HT') ,'---'), 5, ' ') ||
        RPAD(decode(rs.rtype,'E',NVL(to_char(MONTANT_MENSUEL), '---'),'F',NVL(to_char(MONTANT_MENSUEL), '---'),'---'), 8, ' ')
        FROM situ_ress r , ressource rs
        WHERE r.ident = TO_NUMBER(l_ident)
        AND r.ident = rs.ident
        ORDER BY datsitu DESC;

END  LISTER_SITU;

PROCEDURE LISTER_RESS( p_debnom     IN VARCHAR2,
                            p_nomcont     IN VARCHAR2,
                            p_userid     IN VARCHAR2,
                            p_matricule IN VARCHAR2,
                            p_igg IN VARCHAR2,
                            p_curseur  IN OUT list_ress_ViewCurType
                            ) IS

  -- verifier le perime si menuid = me
  l_perime VARCHAR2(1000);
  l_menu   VARCHAR2(255);
  l_count NUMBER;


    BEGIN

      l_perime := PACK_GLOBAL.lire_globaldata(p_userid).perime;
      l_menu := Pack_Global.lire_globaldata(p_userid).menutil;

        IF(l_menu = 'ME') then

            if(p_nomcont is not null) then

                OPEN    p_curseur FOR
                      select
                          to_char(r.IDENT),
                          RPAD(NVL(to_char(r.IDENT), ' '), 7, ' ')||
                          RPAD(NVL(TO_CHAR(r.rnom), ' '), 32, ' ')||
                          RPAD(NVL(TO_CHAR(decode(pack_consult_ress.affichage_prenom(r.rtype, r.rprenom),'O',r.RPRENOM,null)), ' '), 17, ' ')||
                          RPAD(NVL(TO_CHAR(decode(r.RTYPE,'P',r.matricule,null)), ' '), 9, ' ')||
                          RPAD(NVL(to_char(r.igg), ' '), 12, ' ')||
                          RPAD(NVL(TO_CHAR(decode(r.RTYPE,'P',decode((select soccode from situ_ress where ident = r.IDENT and datsitu <= sysdate and ( datdep is null or datdep >= sysdate)),'SG..','SG','Presta. au temps passé'),'L','Logiciel','E','Forfait sans frais d''env','F','Forfait avec frais d''env')), '   '), 28, ' ') -- PPM 60953
                          from ressource r
                          where r.rnom like '%'||UPPER(p_nomcont)||'%'
                          and pack_consult_ress.hab_perime(r.ident,l_perime) = 1
                          order by r.rnom,r.rprenom;

            elsif(p_igg is not null) then

                 OPEN    p_curseur FOR
                      select
                          to_char(r.IDENT),
                          RPAD(NVL(to_char(r.IDENT), ' '), 7, ' ')||
                          RPAD(NVL(TO_CHAR(r.rnom), ' '), 32, ' ')||
                          RPAD(NVL(TO_CHAR(decode(pack_consult_ress.affichage_prenom(r.rtype, r.rprenom),'O',r.RPRENOM,null)), ' '), 17, ' ')||
                          RPAD(NVL(TO_CHAR(decode(r.RTYPE,'P',r.matricule,null)), ' '), 9, ' ')||
                          RPAD(NVL(to_char(r.igg), ' '), 12, ' ')||
                          RPAD(NVL(TO_CHAR(decode(r.RTYPE,'P',decode((select soccode from situ_ress where ident = r.IDENT and datsitu <= sysdate and ( datdep is null or datdep >= sysdate)),'SG..','SG','Presta. au temps passé'),'L','Logiciel','E','Forfait sans frais d''env','F','Forfait avec frais d''env')), '   '), 28, ' ') -- PPM 60953
                          from ressource r
                          where r.igg = p_igg
                          and pack_consult_ress.hab_perime(r.ident,l_perime) = 1
                          order by r.rnom,r.rprenom;

            elsif(p_matricule is not null) then

                 OPEN    p_curseur FOR
                      select
                          to_char(r.IDENT),
                          RPAD(NVL(to_char(r.IDENT), ' '), 7, ' ')||
                          RPAD(NVL(TO_CHAR(r.rnom), ' '), 32, ' ')||
                          RPAD(NVL(TO_CHAR(decode(pack_consult_ress.affichage_prenom(r.rtype, r.rprenom),'O',r.RPRENOM,null)), ' '), 17, ' ')||
                          RPAD(NVL(TO_CHAR(decode(r.RTYPE,'P',r.matricule,null)), ' '), 9, ' ')||
                          RPAD(NVL(to_char(r.igg), ' '), 12, ' ')||
                          RPAD(NVL(TO_CHAR(decode(r.RTYPE,'P',decode((select soccode from situ_ress where ident = r.IDENT and datsitu <= sysdate and ( datdep is null or datdep >= sysdate)),'SG..','SG','Presta. au temps passé'),'L','Logiciel','E','Forfait sans frais d''env','F','Forfait avec frais d''env')), '   '), 28, ' ') -- PPM 60953
                          from ressource r
                          where r.matricule = UPPER(p_matricule)
                          and pack_consult_ress.hab_perime(r.ident,l_perime) = 1
                          order by r.rnom,r.rprenom;

           else

                OPEN    p_curseur FOR
                  select
                          to_char(r.IDENT),
                          RPAD(NVL(to_char(r.IDENT), ' '), 7, ' ')||
                          RPAD(NVL(TO_CHAR(r.rnom), ' '), 32, ' ')||
                          RPAD(NVL(TO_CHAR(decode(pack_consult_ress.affichage_prenom(r.rtype, r.rprenom),'O',r.RPRENOM,null)), ' '), 17, ' ')||
                          RPAD(NVL(TO_CHAR(decode(r.RTYPE,'P',r.matricule,null)), ' '), 9, ' ')||
                          RPAD(NVL(to_char(r.igg), ' '), 12, ' ')||
                          -- PPM 60953 : RPAD(NVL(TO_CHAR(decode(r.RTYPE,'P',decode((select soccode from situ_ress where ident = r.IDENT and rownum < 2),'SG..','SG','Presta. au temps passé'),'L','Logiciel','E','Forfait sans frais d''env','F','Forfait avec frais d''env')), '   '), 28, ' ')
                          RPAD(NVL(TO_CHAR(decode(r.RTYPE,'P',decode((select soccode from situ_ress where ident = r.IDENT and datsitu <= sysdate and ( datdep is null or datdep >= sysdate)) ,'SG..','SG','Presta. au temps passé'),'L','Logiciel','E','Forfait sans frais d''env','F','Forfait avec frais d''env')), '   '), 28, ' ') -- PPM 60953
                          from ressource r
                      where r.rnom like UPPER(p_debnom)||'%'
                      and pack_consult_ress.hab_perime(r.ident,l_perime) = 1
                      order by r.rnom,r.rprenom;

          end if;

         else

              if(p_nomcont is not null) then
              BEGIN
                OPEN    p_curseur FOR
                      select
                          to_char(r.IDENT),
                          RPAD(NVL(to_char(r.IDENT), ' '), 7, ' ')||
                          RPAD(NVL(TO_CHAR(r.rnom), ' '), 32, ' ')||
						  -- FAD PPM Corrective 64558 : Suppression du r.RTYPE depuis le DECODE
                          --RPAD(NVL(TO_CHAR(decode(r.RTYPE,pack_consult_ress.affichage_prenom(r.rtype, r.rprenom),'O',r.RPRENOM,null)), ' '), 17, ' ')||
						  RPAD(NVL(TO_CHAR(decode(pack_consult_ress.affichage_prenom(r.rtype, r.rprenom),'O',r.RPRENOM,null)), ' '), 17, ' ')||
						  -- FAD PPM Corrective 64558 : Fin
                          RPAD(NVL(TO_CHAR(decode(r.RTYPE,'P',r.matricule,null)), ' '), 9, ' ')||
                          RPAD(NVL(to_char(r.igg), ' '), 12, ' ')||
                          RPAD(NVL(TO_CHAR(decode(r.RTYPE,'P',decode((select soccode from situ_ress where ident = r.IDENT and datsitu <= sysdate and ( datdep is null or datdep >= sysdate)),'SG..','SG','Presta. au temps passé'),'L','Logiciel','E','Forfait sans frais d''env','F','Forfait avec frais d''env')), '   '), 28, ' ') -- PPM 60953
                          from ressource r
                          where r.rnom like '%'||UPPER(p_nomcont)||'%'
                          order by r.rnom,r.rprenom;
                EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                      RAISE_APPLICATION_ERROR( -21174, SQLERRM);
                END;
                elsif(p_igg is not null) then
                  BEGIN
                    OPEN    p_curseur FOR
                          select
                              to_char(r.IDENT),
                              RPAD(NVL(to_char(r.IDENT), ' '), 7, ' ')||
                              RPAD(NVL(TO_CHAR(r.rnom), ' '), 32, ' ')||
                              RPAD(NVL(TO_CHAR(decode(pack_consult_ress.affichage_prenom(r.rtype, r.rprenom),'O',r.RPRENOM,null)), ' '), 17, ' ')||
                              RPAD(NVL(TO_CHAR(decode(r.RTYPE,'P',r.matricule,null)), ' '), 9, ' ')||
                              RPAD(NVL(to_char(r.igg), ' '), 12, ' ')||
                              RPAD(NVL(TO_CHAR(decode(r.RTYPE,'P',decode((select soccode from situ_ress where ident = r.IDENT and datsitu <= sysdate and ( datdep is null or datdep >= sysdate)),'SG..','SG','Presta. au temps passé'),'L','Logiciel','E','Forfait sans frais d''env','F','Forfait avec frais d''env')), '   '), 28, ' ') -- PPM 60953
                              from ressource r
                              where r.igg = p_igg
                              order by r.rnom,r.rprenom;
                    EXCEPTION
                       WHEN NO_DATA_FOUND THEN
                          RAISE_APPLICATION_ERROR( -21174, SQLERRM);
                    END;
                elsif(p_matricule is not null) then
                  BEGIN
                    OPEN    p_curseur FOR
                          select
                              to_char(r.IDENT),
                              RPAD(NVL(to_char(r.IDENT), ' '), 7, ' ')||
                              RPAD(NVL(TO_CHAR(r.rnom), ' '), 32, ' ')||
                              RPAD(NVL(TO_CHAR(decode(pack_consult_ress.affichage_prenom(r.rtype, r.rprenom),'O',r.RPRENOM,null)), ' '), 17, ' ')||
                              RPAD(NVL(TO_CHAR(decode(r.RTYPE,'P',r.matricule,null)), ' '), 9, ' ')||
                              RPAD(NVL(to_char(r.igg), ' '), 12, ' ')||
                              RPAD(NVL(TO_CHAR(decode(r.RTYPE,'P',decode((select soccode from situ_ress where ident = r.IDENT and datsitu <= sysdate and ( datdep is null or datdep >= sysdate)),'SG..','SG','Presta. au temps passé'),'L','Logiciel','E','Forfait sans frais d''env','F','Forfait avec frais d''env')), '   '), 28, ' ') -- PPM 60953
                              from ressource r
                              where r.matricule = UPPER(p_matricule)
                              order by r.rnom,r.rprenom;
                    EXCEPTION
                       WHEN NO_DATA_FOUND THEN
                          RAISE_APPLICATION_ERROR( -21174, SQLERRM);
                    END;

           else
              BEGIN
                OPEN    p_curseur FOR
                  select
                          to_char(r.IDENT),
                          RPAD(NVL(to_char(r.IDENT), ' '), 7, ' ')||
                          RPAD(NVL(TO_CHAR(r.rnom), ' '), 32, ' ')||
                          RPAD(NVL(TO_CHAR(decode(pack_consult_ress.affichage_prenom(r.rtype, r.rprenom),'O',r.RPRENOM,null)), ' '), 17, ' ')||
                          RPAD(NVL(TO_CHAR(decode(r.RTYPE,'P',r.matricule,null)), ' '), 9, ' ')||
                          RPAD(NVL(to_char(r.igg), ' '), 12, ' ')||
                          RPAD(NVL(TO_CHAR(decode(r.RTYPE,'P',decode((select soccode from situ_ress where ident = r.IDENT and datsitu <= sysdate and ( datdep is null or datdep >= sysdate)),'SG..','SG','Presta. au temps passé'),'L','Logiciel','E','Forfait sans frais d''env','F','Forfait avec frais d''env')), '   '), 28, ' ') -- PPM 60953
                          from ressource r
                      where r.rnom like UPPER(p_debnom)||'%'
                      order by r.rnom,r.rprenom;
               EXCEPTION
                  WHEN OTHERS THEN
                    RAISE_APPLICATION_ERROR( -21174, SQLERRM);
               END;
          end if;

         end if;

END  LISTER_RESS;





FUNCTION get_siren(p_soccode IN VARCHAR2) RETURN VARCHAR2 IS

    l_count_ag NUMBER;
    l_count_eb NUMBER;
    l_siren NUMBER;

      BEGIN
        select  count(siren) into l_count_ag
            from agence
            where soccode =  p_soccode
            and rownum < 2;
        select  count(siren) into l_count_eb
            from EBIS_FOURNISSEURS
            where soccode =  p_soccode
            and rownum < 2;

        IF(l_count_ag != 0) THEN
          select
            siren into l_siren
            from agence
            where soccode =  p_soccode
            and rownum < 2;
        ELSE
          select
            siren into l_siren
            from EBIS_FOURNISSEURS
            where soccode =  p_soccode
            and rownum < 2;
        END IF;

        return l_siren;

END  get_siren;

FUNCTION hab_perime(p_ident IN VARCHAR2,
                    p_perime IN VARCHAR2) RETURN NUMBER IS

      l_perime VARCHAR2(1000);
      l_codsg VARCHAR2(20);
      perime VARCHAR2(1000);
      l_count NUMBER;
      l_valid NUMBER;

      CURSOR C_CODSG IS SELECT codsg FROM situ_ress
      where ident = to_number(p_ident)
      and rownum <3
      order by datsitu desc;

      BEGIN

          l_perime := p_perime;
          l_codsg := '';
          l_count := 0;
          l_valid := 0;

          while (length(l_perime) != 0) loop

             if (instr(l_perime,',') != 0) then
                  perime := substr(l_perime,0,instr(l_perime,',')-1);
                  l_perime := substr(l_perime,instr(l_perime,',')+1);
             else
                perime := l_perime;
                l_perime := '';
             end if;


            FOR ONE_CODSG IN C_CODSG LOOP

              select count(*) into l_count
                  from vue_dpg_perime
                  where INSTR(perime,codbddpg)>0
                  and codsg = ONE_CODSG.codsg;

              IF (l_count != 0) THEN
                    l_valid := 1;
              END IF;

            END LOOP;

         END LOOP;

        return l_valid;

END  hab_perime;

FUNCTION affichage_prenom (p_typeress ressource.rtype%type,
                       p_prenom ressource.rprenom%type) return VARCHAR2 IS

BEGIN
  if (p_typeress = 'P' or ((p_typeress = 'E' or p_typeress = 'F') and upper(p_prenom) like 'CLONE%')) then
    return 'O';
  else
    return 'N';
  end if;

END affichage_prenom;

END pack_consult_ress;
/

show errors