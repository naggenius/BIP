create or replace
PACKAGE PACK_PRA_CONSO AS

CALLEE_FAILED_ID     NUMBER := -20000;   -- pour propagation dans pile d'appel

  /* TODO enter package declarations (types, exceptions, methods etc) here */
  PROCEDURE export_pra_conso(
                                  p_chemin_fichier    IN VARCHAR2,
                                  p_nom_fichier       IN VARCHAR2
                                 );

END PACK_PRA_CONSO; 
/

create or replace
PACKAGE BODY     PACK_PRA_CONSO AS

  PROCEDURE export_pra_conso(
                             p_chemin_fichier    IN VARCHAR2,
                             p_nom_fichier       IN VARCHAR2
                            ) IS

            CURSOR csr_ress IS
                   SELECT

                                     lc.mode_contractuel type_contrat,
                                     lc.numcont numero_contrat,
                                     lc.cav avenant,
                                     c.siren siren,
                                     lc.soccont soccont,
                                     to_char(d.MOISMENS,'MMYYYY') mois_prest,
                                     r.matricule matricule,
                                     r.ident identifiant_ress,
                                     r.igg igg,
                                     r.rnom nom_ress,
                                     r.rprenom prenom_ress,
                                     SUM(cs.cusag) conso_mois,
                                     d1.coddir coddir,
                                     si1.centractiv centractiv
                                     from ligne_cont lc, contrat c, cons_sstache_res_mois cs, ressource r, ligne_bip lb, situ_ress sr, DATDEBEX d, STRUCT_INFO si1, DIRECTIONS d1, tache t
                                     where lc.numcont = c.numcont
                                     and lc.cav = c.cav
                                     and lc.soccont = c.soccont
                                     and lc.ident = r.ident
                                     and cs.ident = r.ident
                                     and cs.pid = lb.pid
                                     and sr.ident = r.ident
                                     and sr.ident = cs.ident
									 -- jointure entre les tables cons_sstache_res_mois et tache
									 and cs.pid = t.pid
									 and cs.ecet = t.ecet
									 and cs.acta = t.acta
									 and cs.acst = t.acst
                                     and ((r.rtype = 'P' and sr.soccode <> 'SG..') or lc.mode_contractuel like '%G')
                                     -- on selectionne tous les lignes contrats actives sur le mois de la mensuelle
                                     and to_char(lc.lresdeb,'YYYYMM') <= to_char(d.MOISMENS,'YYYYMM')
                                     and to_char(lc.lresfin,'YYYYMM') >=  to_char(d.MOISMENS,'YYYYMM')
                                     and c.orictr = 'PAC'
                                     and sr.PRESTATION NOT IN ('IFO','GRA','MO','INT','STA','SLT')
                                     AND (TO_DATE(TO_CHAR(sr.DATSITU,'dd/mm/yyyy'),'dd/mm/yyyy') <= d.MOISMENS AND (TO_DATE(TO_CHAR(sr.DATDEP,'dd/mm/yyyy'),'dd/mm/yyyy') >= d.MOISMENS OR sr.DATDEP IS NULL))
                                     and (cs.cdeb IS NULL OR cs.cdeb=d.moismens)
                                     and (lb.typproj <> 7 OR (lb.typproj = 7 AND t.aist IN ('FORFAC', 'SEMINA', 'CLUBUT', 'DEMENA')))
                                      -- perimetre du contrat
                   AND si1.codsg=c.codsg
                   and d1.CODDIR = si1.coddir
                                     group by lc.mode_contractuel,lc.numcont,lc.cav,lc.soccont,c.siren,r.ident, d.moismens,r.matricule, r.igg, r.rnom, r.rprenom, d1.coddir, si1.centractiv;

            CURSOR csr_pra_export IS
                select type_contrat,
                        num_contrat,
                        siren,
                        mois_prest,
                        matricule,
                        ident,
                        igg,
                        nom_ress,
                        prenom_ress,
                        top_multi_contrats,
                        conso_mois,
                        cav,
                        soccont
                from pra_export_consomme;

            CURSOR csr_pra_export2 IS
                select type_contrat,
                        num_contrat,
                        siren,
                        mois_prest,
                        matricule,
                        ident,
                        igg,
                        nom_ress,
                        prenom_ress,
                        top_multi_contrats,
                        conso_mois,
                        cav,
                        soccont
                from pra_export_consomme;

              CURSOR csr_pra_export3 IS
                select type_contrat,
                        num_contrat,
                        siren,
                        mois_prest,
                        matricule,
                        ident,
                        igg,
                        nom_ress,
                        prenom_ress,
                        top_multi_contrats,
                        conso_mois,
                        cav,
                        soccont
                from pra_export_consomme;

        nb_contrats NUMBER;
        id_ress_princ NUMBER;
        conso_ress_princ NUMBER(5,2);

        typecontrat VARCHAR2(3);
            refcontrat VARCHAR2(16);
            siren NUMBER(9);
            moisprest VARCHAR2(6);
            matricule VARCHAR2(11);
            igg NUMBER(10);
            nom VARCHAR2(30);
            consomois VARCHAR2(7);
            topmulticontrats CHAR(1);
            typetemps VARCHAR2(2);
            l_hfile UTL_FILE.FILE_TYPE;


        BEGIN
            --Insertion des ressources trouvées dans une table temporaire
            DELETE FROM PRA_EXPORT_CONSOMME;

            FOR curseur_all_lignes IN csr_ress  LOOP

                              INSERT INTO PRA_EXPORT_CONSOMME (
                                 TYPE_CONTRAT, NUM_CONTRAT, SIREN, MOIS_PREST, MATRICULE, IDENT, IGG, NOM_RESS, PRENOM_RESS, CONSO_MOIS, CAV, SOCCONT
                              )  VALUES  (
                               curseur_all_lignes.type_contrat ,
                               curseur_all_lignes.numero_contrat,
                               curseur_all_lignes.siren ,
                               curseur_all_lignes.mois_prest,
                               curseur_all_lignes.matricule  ,
                               curseur_all_lignes.identifiant_ress,
                               curseur_all_lignes.igg ,
                               curseur_all_lignes.nom_ress ,
                               curseur_all_lignes.prenom_ress,
                               curseur_all_lignes.conso_mois,
                               substr(curseur_all_lignes.avenant,2,2),
                               curseur_all_lignes.soccont
                            );

            END LOOP ;

            FOR rec_pra_export IN csr_pra_export LOOP
            -- Si un identifiant apparait plusieurs fois pour les mêmes contrat/avenant, on le tope comme multi-contrats
            select count(*) into nb_contrats from (select distinct num_contrat,cav from pra_export_consomme where ident = rec_pra_export.ident);
            if nb_contrats > 1 then
                update pra_export_consomme set top_multi_contrats = 'O', conso_mois = 0.01 where ident = rec_pra_export.ident;
            else
                update pra_export_consomme set top_multi_contrats = 'N' where ident = rec_pra_export.ident;
            end if;

            END LOOP;

            FOR rec_pra_export IN csr_pra_export2 LOOP

            --Si la ressource est un clone (recherche par IGG)
            if rec_pra_export.igg is not null and rec_pra_export.igg like '9%' then
                --recherche de la ressource principale
                --si elle existe on additionne les conso du clone et de la RP (seulement si top_multi_contrats='N' et si même contrat pour les 2 ressources) et on supprime le clone
                BEGIN
                select ident into id_ress_princ from pra_export_consomme where igg = '1' || substr(rec_pra_export.igg,2,9)
                                                                         and num_contrat = rec_pra_export.num_contrat
                                                                         and cav = rec_pra_export.cav
                                                                         and soccont = rec_pra_export.soccont;
                if rec_pra_export.top_multi_contrats = 'N' then
                        select conso_mois into conso_ress_princ from pra_export_consomme where ident = id_ress_princ;
                        update pra_export_consomme set conso_mois = conso_ress_princ + rec_pra_export.conso_mois where ident = id_ress_princ;
                end if;
                delete from pra_export_consomme where ident = rec_pra_export.ident;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                    update pra_export_consomme set igg = '1' || substr(rec_pra_export.igg,2,9) where ident = rec_pra_export.ident;
                    --On récupère également le matricule de la ressource principale s'il existe
                    if rec_pra_export.matricule is not null then
                        update pra_export_consomme set matricule = 'X' || substr(rec_pra_export.matricule,2,6) where ident = rec_pra_export.ident;
                    end if;
                END;
            --Si la ressource est un clone (recherche par matricule)
            elsif rec_pra_export.matricule is not null and rec_pra_export.matricule like 'Y%' then
                --recherche de la ressource principale
                --si elle existe on additionne les conso du clone et de la RP (seulement si top_multi_contrats='N' et si même contrat pour les 2 ressources) et on supprime le clone
                BEGIN
                select ident into id_ress_princ from pra_export_consomme where matricule = 'X' || substr(rec_pra_export.matricule,2,6)
                                                                         and num_contrat = rec_pra_export.num_contrat
                                                                         and cav = rec_pra_export.cav
                                                                         and soccont = rec_pra_export.soccont;
                if rec_pra_export.top_multi_contrats = 'N' then
                        select conso_mois into conso_ress_princ from pra_export_consomme where ident = id_ress_princ;
                        update pra_export_consomme set conso_mois = conso_ress_princ + rec_pra_export.conso_mois where ident = id_ress_princ;
                end if;
                delete from pra_export_consomme where ident = rec_pra_export.ident;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                    update pra_export_consomme set matricule = 'X' || substr(rec_pra_export.matricule,2,6) where ident = rec_pra_export.ident;
                END;
            --Si la ressource est un clone (recherche par prenom - cas des ATG)
            elsif rec_pra_export.prenom_ress like 'CLONE%' then
                --recherche de la ressource principale
                --si elle existe on additionne les conso du clone et de la RP (seulement si top_multi_contrats='N') et on supprime le clone
                BEGIN
                select ident into id_ress_princ from pra_export_consomme where ident = substr(rec_pra_export.prenom_ress,7,5);
                if rec_pra_export.top_multi_contrats = 'N' then
                        select conso_mois into conso_ress_princ from pra_export_consomme where ident = id_ress_princ;
                        update pra_export_consomme set conso_mois = conso_ress_princ + rec_pra_export.conso_mois where ident = id_ress_princ;
                end if;
                delete from pra_export_consomme where ident = rec_pra_export.ident;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                    null;
                END;
            end if;

            END LOOP;

            Pack_Global.INIT_WRITE_FILE( p_chemin_fichier, p_nom_fichier, l_hfile);
            Pack_Global.WRITE_STRING( l_hfile, 'BIP_PRA_CONSO;'||to_char(sysdate,'DDMMYYYY_HH24MISS'));
            Pack_Global.WRITE_STRING( l_hfile, 'Type_contrat;Ref_contrat;Siren;Mois_prest;Matricule;IGG;Nom;Conso_mois;Top_multi_contrats;Type_temps');
                FOR rec_ress IN csr_pra_export3 LOOP
                    matricule := '';
					igg := '';
                    if rec_ress.type_contrat like '%G' then
                        typecontrat := 'ATG';
                    else
                        typecontrat := 'ATU';
                    end if;
                    if typecontrat = 'ATU' then
                        refcontrat := substr(rec_ress.num_contrat,1,12) || '-' || rec_ress.cav;
                        -- reconstitution du matricule s'il est renseigné
                        if rec_ress.matricule is not null then
                          matricule := 'GL00' || rec_ress.matricule;
                        end if;
                        igg := rec_ress.igg;
                    -- Si contrat ATG
					elsif typecontrat = 'ATG' then
						-- Chargement de la colonne refcontrat avec la racine du contrat
						-- (sur 13 ou 16 caractères)
						refcontrat := rec_ress.num_contrat;
					else
                        refcontrat := substr(rec_ress.num_contrat,1,13);
                        matricule := '';
                        igg := '';
                    end if;
                    siren := rec_ress.siren;
                    moisprest := rec_ress.mois_prest;
                    nom := rec_ress.nom_ress;
                    consomois := to_char(rec_ress.conso_mois);
                    --Nécessaire pour l'affichage du 0 avant la virgule
                    if rec_ress.conso_mois < 1 then
                        consomois := '0' || consomois;
                    end if;
                    topmulticontrats := rec_ress.top_multi_contrats;
                    typetemps := 'ST';

                    Pack_Global.WRITE_STRING( l_hfile, typecontrat || ';' || refcontrat || ';' || siren || ';' || moisprest
                            || ';' || matricule || ';' || igg || ';' || nom || ';' || consomois || ';' || topmulticontrats || ';' || typetemps);
                END LOOP;
                Pack_Global.CLOSE_WRITE_FILE(l_hfile);

END export_pra_conso;

END PACK_PRA_CONSO;
/
