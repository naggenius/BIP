--###############################################################################
--
--	Package PL/SQL de mise a jour des tables de FACCONS :
--		faccons_ressource
--		faccons_consomme
--		faccons_facture
--
--	Date		Auteur		Action
--    03/12/2001	O. Duprey	Premiere version
--    04/01/2002   	N.Baccam    	Remplir_facture : ajout de facture.fmodreglt is null
--    29/03/2007	EVI		Ajout du champs CUSAG_EXPENSE lors de l'alimentation de la table FACCONS_FACTURE
--    19/11/2007	EVI		TD486 Prise en compte des forfait au 12ieme n'ayant pas été facturé
--    17/03/2008    EVI		TD634 On ne prend plus en compte les consomme sur les forfait qui n'ont pas de situation valide
--    18/03/2009    EVI		TD775 On ne prend plus en compte les consomme sur les forfait qui n'ont pas de situation valide: trou dans les situations
--    30/03/2009    EVI		TD775 Provision negative si pas de situation mais du consomme ou une facture saisie
--    28/04/2009    ABA		TD737  contrat 27+3
--  Suppression des verrous SMS 23/03/20011 par BSA : Fiche 837
--
--###############################################################################




CREATE OR REPLACE PACKAGE     pack_faccons IS
--###############################################################################
--    Procedure de remplissage de la table faccons_consomme.
--    Pour chaque ressource et pour chaque mois de l'annee courante
--    (selon datdebex) consolide l'ensemble du consomme (hors FORMAT, ABSDIV,
--    CONGES, MOBILI, PARTIE, RTT) pour les ressources non SG.
--###############################################################################
    PROCEDURE Remplir_Consomme;

--###############################################################################
--    Procedure de remplissage de la table faccons_facture.
--    Pour chaque ressource, pour chaque mois de l'annee courante, contient
--    la ou les lignes de factures.
--###############################################################################
    PROCEDURE Remplir_Facture;

--###############################################################################
--    Procedure de remplissage de la table faccons_ressource.
--    Pour chaque ressource presente dans l'une ou l'autre des tables
--    faccons_consomme et faccons_facture, et pour chaque mois :
--        - les informations sur la bonne situation
--        - le cumul du consomme
--        - le cumul du facture
--###############################################################################
    PROCEDURE Remplir_Ressource;
END pack_faccons;
/


CREATE OR REPLACE PACKAGE BODY     pack_faccons IS
    PROCEDURE Remplir_Consomme IS
    BEGIN
        INSERT INTO faccons_consomme(
            lmoisprest
            , ident
            , cusag
        )
        -- On recupere les consommes de toutes les ressource sauf forfait (E ou F)
        SELECT proplus.cdeb
            , proplus.tires
            , SUM(proplus.cusag)
        FROM datdebex
            , proplus
            , ressource r
        WHERE proplus.societe!='SG..'
            AND (proplus.qualif NOT IN ('GRA', 'MO') OR proplus.qualif IS NULL)
            AND proplus.cdeb BETWEEN ADD_MONTHS(datdebex.datdebex,-12) AND datdebex.moismens
            AND (proplus.aist NOT IN ('FORMAT', 'ABSDIV', 'CONGES', 'MOBILI', 'PARTIE', 'RTT', 'RTT   ', 'FORHUM', 'ACCUEI', 'FORINT', 'FORINF', 'FOREAO', 'FOREXT') OR proplus.aist IS NULL)
            --and proplus.tires='22123'
            AND proplus.tires=r.ident
            -- on ne prend pas en compte les forfaits
            AND r.RTYPE!='F'
            AND r.RTYPE!='E'
        GROUP BY proplus.cdeb, proplus.tires
        UNION
        -- On recupere les consomme des forfait ayant une situation valide
        SELECT proplus.cdeb
            , proplus.tires
            , SUM(proplus.cusag)
        FROM datdebex
            , proplus
            , situ_ress s
            , ressource r
        WHERE proplus.societe!='SG..'
            AND (proplus.qualif NOT IN ('GRA', 'MO') OR proplus.qualif IS NULL)
            AND proplus.cdeb BETWEEN ADD_MONTHS(datdebex.datdebex,-12) AND datdebex.moismens
            AND (proplus.aist NOT IN ('FORMAT', 'ABSDIV', 'CONGES', 'MOBILI', 'PARTIE', 'RTT', 'RTT   ', 'FORHUM', 'ACCUEI', 'FORINT', 'FORINF', 'FOREAO', 'FOREXT') OR proplus.aist IS NULL)
        --On verifie qu'il exite une situation valide
        and s.ident=proplus.tires
        and s.ident=r.ident
        and ( (proplus.cdeb BETWEEN s.datsitu AND s.datdep and (r.RTYPE='F' OR r.RTYPE='E')) OR
              (proplus.cdeb >= s.datsitu and s.datdep is null and (r.RTYPE='F' OR r.RTYPE='E')) )
        GROUP BY proplus.cdeb, proplus.tires;

        COMMIT;
    END Remplir_Consomme;


    PROCEDURE Remplir_Facture IS
    BEGIN
        INSERT INTO faccons_facture(
            lmoisprest
            , ident
            , montht
            , socfact
            , numfact
            , typfact
            , datfact
            , lnum
            , codcompta
            , numcont
            , cav
            , codsg
            ,cusag_expense)
        SELECT ligne_fact.lmoisprest
            , ligne_fact.ident
            , ligne_fact.lmontht
            , ligne_fact.socfact
            , ligne_fact.numfact
            , ligne_fact.typfact
            , ligne_fact.datfact
            , ligne_fact.lnum
            , ligne_fact.lcodcompta
            , facture.numcont
            , decode(contrat.top30,'N',substr(facture.cav,2,2),'O',decode(facture.cav,'000',null,facture.cav)) cav
            , ligne_fact.ldeppole
            , FACTURE.cusag_expense
        FROM
            datdebex
            , facture
            , ligne_fact
            , contrat
        WHERE facture.socfact=ligne_fact.socfact
            AND facture.numfact=ligne_fact.numfact
            AND facture.typfact=ligne_fact.typfact
            AND facture.datfact=ligne_fact.datfact
            AND facture.numcont=contrat.numcont
            AND facture.cav=contrat.cav
            AND facture.soccont=contrat.soccont
            AND (facture.fmodreglt!=8 or facture.fmodreglt is null)
            --AND ligne_fact.lcodcompta NOT IN (6350001, 6350002, 6398001)
            AND ligne_fact.lmoisprest BETWEEN ADD_MONTHS(datdebex.datdebex,-12) AND datdebex.moismens;


        COMMIT;
    END Remplir_Facture;


    PROCEDURE Remplir_Ressource IS

   --  Curseur sur les situation qui comble les trou!
   CURSOR cur_situress IS
          SELECT f.ident,f.lmoisprest FROM faccons_ressource f, situ_ress_full s
            WHERE f.MONTANT_MENSUEL is not null
            AND f.ident = s.ident
            AND s.type_situ='V'
            and f.lmoisprest between s.datsitu and NVL(s.DATDEP,SYSDATE);


    BEGIN
        INSERT INTO faccons_ressource(
            lmoisprest
            , ident
            , codsg
            , prestation
            , soccode
            , cout
            , conso_total
            , fact_total
            , rnom)
        SELECT
            calendrier.calanmois
            , ress.ident
            , NULL
            , NULL
            , NULL
            , NULL
            , NULL
            , NULL
            , ressource.rnom
        FROM
            datdebex
            , calendrier
            , ressource
            , (SELECT DISTINCT ident FROM faccons_consomme
                UNION
               SELECT DISTINCT ident FROM faccons_facture
               UNION
               SELECT DISTINCT ident FROM SITU_RESS WHERE MONTANT_MENSUEL is not null
            ) ress
        WHERE calendrier.calanmois BETWEEN ADD_MONTHS(datdebex.datdebex,-12) AND datdebex.moismens
            AND ress.ident=ressource.ident;

        COMMIT;



        UPDATE faccons_ressource
            SET (codsg, prestation, soccode, cout, montant_mensuel)=
                (SELECT situ_ress.codsg, situ_ress.prestation, situ_ress.soccode, situ_ress.cout, situ_ress.montant_mensuel
                    FROM situ_ress
                    WHERE situ_ress.ident=faccons_ressource.ident
                        AND situ_ress.datsitu=pack_situation_full.datsitu_ressource(faccons_ressource.ident, faccons_ressource.lmoisprest)
                );

        COMMIT;



        UPDATE faccons_ressource
            SET conso_total=
                (SELECT SUM(faccons_consomme.cusag)
                    FROM faccons_consomme
                    WHERE faccons_consomme.ident=faccons_ressource.ident
                        AND faccons_consomme.lmoisprest=faccons_ressource.lmoisprest
                )
                , fact_total=
                (SELECT SUM(faccons_facture.montht*DECODE(faccons_facture.typfact, 'A', -1, 1))
                    FROM faccons_facture
                    WHERE faccons_facture.ident=faccons_ressource.ident
                        AND faccons_facture.lmoisprest=faccons_ressource.lmoisprest
                );

        COMMIT;


        DELETE faccons_ressource
            WHERE NVL(conso_total, 0)=0
            AND NVL(fact_total, 0)=0
            AND MONTANT_MENSUEL is null;

        -- supprime les provision a tord -> hors situation
        DELETE faccons_ressource
			WHERE NVL(conso_total, 0)=0
			AND NVL(fact_total, 0)=0
			AND MONTANT_MENSUEL is not null
			AND
			(LMOISPREST < (select MIN(DATSITU) FROM situ_ress where ident=faccons_ressource.ident)
			OR LMOISPREST > (select NVL(DATDEP,SYSDATE) FROM situ_ress where ident=faccons_ressource.ident
			   			  									 		   		 and datsitu= (select max(datsitu) from situ_ress where ident=faccons_ressource.ident)
																			 ));

        UPDATE faccons_ressource set MONTANT_MENSUEL = '0'
			WHERE MONTANT_MENSUEL is not null
			AND
			(LMOISPREST < (select MIN(DATSITU) FROM situ_ress where ident=faccons_ressource.ident)
			OR LMOISPREST > (select NVL(DATDEP,SYSDATE) FROM situ_ress where ident=faccons_ressource.ident
			   			  									 		   		 and datsitu= (select max(datsitu) from situ_ress where ident=faccons_ressource.ident)
																			 ));
        -- supprime les provision a tord -> situation avec interuption en cours d'annee
        FOR curseur_situ_ress IN cur_situress LOOP
            BEGIN
                 UPDATE faccons_ressource set MONTANT_MENSUEL = '0'
                 WHERE ident = curseur_situ_ress.ident
                 AND lmoisprest = curseur_situ_ress.lmoisprest;
            END;
        END LOOP ;

        COMMIT;

    END Remplir_Ressource;
END pack_faccons;
/


