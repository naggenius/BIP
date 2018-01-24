-- *****************************************************************************************
-- Créé le 09/04/2008 par ABA
-- Modification
--    date 	            auteur             	commentaire
--28/05/2008          ABA		suppression de l'envoie des champ factpno, codsg  
-- 18/06/2008         ABA                  Modification dur format de date du champ cdeb cdebfin
-- 01/08/2008         ABA                 suppression de la somme du cout qui generait des anomalie sur le TJM  puis suite à la migration oracle 10 transformation du point en virgule sur les couts
--- 09/02/2009       ABA                   TD 751 extraction des conso sur 12 mois glissants
---- ******************************************************************************************
CREATE OR REPLACE PACKAGE     pack_adonix IS

/* procedure d'extraction des realisés BIP*/
PROCEDURE export_realises_bip(p_chemin_fichier VARCHAR2, p_nom_fichier VARCHAR2);

END pack_adonix;
/


CREATE OR REPLACE PACKAGE BODY     pack_adonix IS

PROCEDURE export_realises_bip(
                            p_chemin_fichier    IN VARCHAR2,
                            p_nom_fichier        IN VARCHAR2
                      ) IS


-- curseur de remplissage de la table temporaire tmp_adonix
            CURSOR csr_realises_bip IS

select  p.tires                        ident,
       r.rnom                       nom,
        r.rprenom                     prenom,
        p.cdeb                        cdeb,
        last_day(p.cdeb)             cdebfin,
        l.pzone                        pzone,
       substr(si.centractiv,2,4)    ca_dpg_ligne,
        replace(sum(p.cusag),'.',',')                        cusag,
        replace(s.cout,'.',',')                       cout,
        replace(sum(p.cusag*s.cout),'.',',')                tcoutht
     --  p.factpno                    pnom,
     --  l.codsg                        codsg

from PROPLUS    p,
     LIGNE_BIP     l,
     SITU_RESS_FULL s,
     RESSOURCE     r,
     STRUCT_INFO    si,
     DATDEBEX     d
where
        p.factpid = l.pid
        
        and p.cdeb between add_months(d.moismens,-11) and d.MOISMENS
       
        and r.ident=s.ident
        AND s.ident = p.tires
        AND (s.datdep >= p.cdeb OR s.datdep is null)
        AND (    ( (s.datsitu <= p.cdeb or s.datsitu is null )  AND  s.type_situ <> 'N' )
              OR (s.datsitu <= p.cdeb AND  s.type_situ =  'N' ) )
          AND l.codsg = si.codsg
        and not (l.TYPPROJ = 7 and p.aist not in ('CLUBUT', 'SEMINA', 'FORMAT', 'FORFAC'))
        and s.soccode <> 'SG..'
          and r.rtype = 'P'
       and si.coddir = 91
        group by p.tires, r.rnom, r.rprenom, p.cdeb, l.pzone, s.cout, si.centractiv
        order by p.tires, cdeb,  pzone, centractiv;
        





        l_msg  VARCHAR2(1024);
        l_hfile UTL_FILE.FILE_TYPE;



    BEGIN




        Pack_Global.INIT_WRITE_FILE( p_chemin_fichier, p_nom_fichier, l_hfile);


        FOR rec_realises_bip IN csr_realises_bip LOOP


            Pack_Global.WRITE_STRING( l_hfile,
                rec_realises_bip.ident               || ';' ||
                rec_realises_bip.nom             || ';' ||
                rec_realises_bip.prenom         || ';' ||
                to_char(rec_realises_bip.cdeb,'DD/MM/YYYY')             || ';' ||
                to_char(rec_realises_bip.cdebfin,'DD/MM/YYYY')           || ';' ||
                rec_realises_bip.pzone             || ';' ||
                rec_realises_bip.ca_dpg_ligne     || ';' ||
                rec_realises_bip.cusag             || ';' ||
                rec_realises_bip.cout             || ';' ||
                rec_realises_bip.tcoutht
                );

        END LOOP;


        Pack_Global.CLOSE_WRITE_FILE(l_hfile);
    EXCEPTION
           WHEN OTHERS THEN
            Pack_Global.recuperer_message(20401, NULL, NULL, NULL, l_msg);
            RAISE_APPLICATION_ERROR(-20401, l_msg);

END export_realises_bip;

END pack_adonix;
/


