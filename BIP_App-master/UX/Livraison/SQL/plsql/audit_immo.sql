-- pack_application PL/SQL

-- cree le 13/11/2008 par ABA FICHE TD 698
-- modifie 18/12/2008 ABA coorection d'anomalie lors de la mise à jour des audits
-- modifie 28/01/2008 ABA nous prenons la tva de la ligne facture et non celui de la facture
-- modifie 16/02/2009 ABA TD 754
-- modifie 22/04/2009 ABA TD 760
-- modifie le 18/11/2010 CMA TD 890 nouvelle methode synthese_immo_perim
-- Modifie le 06/12/2010 CMA TD 890 prise en compte du perimetre TOUS pour projet ou dossier projet
-- Modifie le 02/05/2011 CMA TD 1206 fonctions ajoutees pour la generation des stocks immo perim client
-- Modifie le 18/10/2011 ABA QC 1255
-- 06/01/2012 QC 1329

CREATE OR REPLACE PACKAGE "PACK_AUDIT_IMMO" IS

/* procedure d'alimentation de la table audit_immo*/
PROCEDURE alim_audit_immo;

PROCEDURE update_audit_immo(p_annee IN VARCHAR2,
                            p_pid   IN VARCHAR2,
                            p_icpi  IN VARCHAR2,
                            p_message OUT VARCHAR2
                            );

TYPE synth_immo_ViewType IS RECORD (   PROJET  VARCHAR2(5),
                                       ILIBEL VARCHAR(50),--KRA PPM 61879
                                       STATUT CHAR(1), --KRA PPM 61879                                      
                                       DATSTATUT VARCHAR(7),--KRA PPM 61879
                                       ANNEE    VARCHAR2(4),
                                       JH       NUMBER(12,2),
                                       EUROS    NUMBER(12,2)

                                            );


TYPE synth_immo_listeCurType IS REF CURSOR RETURN synth_immo_ViewType;

TYPE synth_immo_mo_ViewType IS RECORD ( COMPOSANT VARCHAR2(5),
                                       ILIBEL VARCHAR(50),--KRA PPM 61879
                                       STATUT CHAR(1), --KRA PPM 61879                                      
                                       DATSTATUT VARCHAR(7),--KRA PPM 61879
                                        PROJET  VARCHAR2(5),
                                       ANNEE    VARCHAR2(4),
                                       JH       NUMBER(12,2),
                                       EUROS    NUMBER(12,2)

                                            );


TYPE synth_immo_mo_listeCurType IS REF CURSOR RETURN synth_immo_mo_ViewType;

TYPE string_ViewType IS RECORD (   ELEM  VARCHAR2(5) );


TYPE string_listeCurType IS REF CURSOR RETURN string_ViewType;


PROCEDURE synthese_immo (   p_dpcode  IN VARCHAR,
                            p_icpi    IN VARCHAR2,
                            p_moismens  OUT VARCHAR2,
                            p_libdp     OUT VARCHAR2,
                            p_libprojet     OUT VARCHAR2,
                            p_curseur     IN OUT synth_immo_listeCurType,
                            p_message   OUT VARCHAR2
                        ) ;

PROCEDURE synthese_immo_perim ( p_global IN VARCHAR2,
                            p_dpcode  IN VARCHAR,
                            p_icpi    IN VARCHAR2,
                            p_moismens  OUT VARCHAR2,
                            p_libdp     OUT VARCHAR2,
                            p_libprojet     OUT VARCHAR2,
                            p_curseur     IN OUT synth_immo_listeCurType,
                            p_message   OUT VARCHAR2
                        ) ;

PROCEDURE get_projets_perimcli ( p_global IN VARCHAR2,
                                 p_curseur IN OUT string_listeCurType);

PROCEDURE get_dpcode_perimcli ( p_global IN VARCHAR2,
                                 p_curseur IN OUT string_listeCurType);

PROCEDURE synthese_immo_mo (   p_dpcode  IN VARCHAR,
                            p_icpi    IN VARCHAR2,
                            p_moismens  OUT VARCHAR2,
                            p_libdp     OUT VARCHAR2,
                            p_libprojet     OUT VARCHAR2,
                            p_curseur     IN OUT synth_immo_mo_listeCurType,
                            p_message   OUT VARCHAR2
                        ) ;

END pack_audit_immo;
/


create or replace
PACKAGE BODY "PACK_AUDIT_IMMO" IS



/* procedure d'alimentation de la table audit_immo*/
PROCEDURE alim_audit_immo IS

tmp NUMBER(2);
nbreFacture NUMBER(5);
l_tva NUMBER(9,2);
FMONTANTTTC NUMBER(12,2);


/*Curseur qui ramène les immos P2I de l'année en cours*/
 -- ABN - HP PPM 59613 --
CURSOR csr_audit_immo IS
select
    s.cdeb                                                   CDEB,
    pr.icpi                                                  ICPI,
    pr.ilibel                                                ILIBEL,
    si.LIBDSG                                                LIBDSG,
    s.pid                                                    PID,
    s.soccode                                                SOCCODE,
    s.ident                                                  IDENT,
    s.rnom                                                   RNOM,
    s.consojh                                                CONSOJH,
    s.coutft                                                 COUTFT,
    consojh*coutftht                                         TOTALHTR, -- ABN - HP PPM 60199
	s.coutftht                                               COUTFTHT
from
    stock_immo s,
    proj_info pr,
    struct_info si
where
    s.soccode != 'SG..'
    and pr.icpi = s.icpi
    and s.codsg = si.codsg


union
select
    s.cdeb                                                   CDEB,
    pr.icpi                                                  ICPI,
    pr.ilibel                                                ILIBEL,
    si.LIBDSG                                                LIBDSG,
    s.pid                                                    PID,
    s.soccode                                                SOCCODE,
    s.ident                                                  IDENT,
    s.rnom                                                   RNOM,
    s.consojh                                                CONSOJH,
    s.coutft                                                 COUTFT,
    consojh*coutftht                                         TOTALHTR, -- ABN - HP PPM 60199
	s.coutftht                                               COUTFTHT
from
    histo_stock_immo_corrige s,
    proj_info pr,
    struct_info si
where
    s.soccode != 'SG..'
    and pr.icpi = s.icpi
    and s.codsg = si.codsg
    order by cdeb, pid, ident;


/*Curseur qui ramène les factures pour chaque ligne d'immo P2I*/
CURSOR csr_facture(p_cdeb date ,  p_ident NUMBER ) IS
select
    lf.typfact                                               TYPFACT,
    f.numfact                                                NUMFACT,
    lf.lmontht                                               FMONTANTHT,
    f.fsocfour                                               SOCFOUR,
    f.fregcompta                                             REGCOMPTA,
    decode(f.num_sms,null,f.num_expense,f.num_sms)           NUM_EXT,
	  f.DATFACT                                                DATFACT
from
    ligne_fact lf,
    facture f


where
    lf.numfact = f.numfact(+)
    and lf.SOCFACT = f.SOCFACT(+)
    and lf.TYPFACT = f.TYPFACT(+)
    and lf.DATFACT = f.DATFACT(+)


    and lf.ident = p_ident
    and lf.lmoisprest = p_cdeb
order by lf.numfact, lf.lnum, lf.typfact;

/*Curseur qui ramène les immos SG.. de l'année en cours*/
CURSOR csr_audit_immo_SG IS
select
    s.cdeb                                                   CDEB,
    pr.icpi                                                  ICPI,
    pr.ilibel                                                ILIBEL,
    si.LIBDSG                                                LIBDSG,
    s.pid                                                    PID,
    s.soccode                                                SOCCODE,
    s.ident                                                  IDENT,
    s.rnom                                                   RNOM,
    s.consojh                                                CONSOJH,
    s.coutft                                                 COUTFT,
	  s.coutftht                                               COUTFTHT,
    consojh*coutft                                           TOTALSG,
    round(consojh*coutft*((100-t.taux)/100),2)               SALAIRESG,
    round(consojh*coutft*((t.taux)/100),2)                   CHARGESG,
    t.taux,
    t.annee
from
    stock_immo s,
    proj_info pr,
    struct_info si,
    (select taux, annee from taux_charge_salariale) t
where
    s.soccode = 'SG..'
    and pr.icpi = s.icpi
    and s.codsg = si.codsg
    and t.annee = to_number(to_char(s.cdeb,'YYYY'))
union
select
    s.cdeb                                                   CDEB,
    pr.icpi                                                  ICPI,
    pr.ilibel                                                ILIBEL,
    si.LIBDSG                                                LIBDSG,
    s.pid                                                    PID,
    s.soccode                                                SOCCODE,
    s.ident                                                  IDENT,
    s.rnom                                                   RNOM,
    s.consojh                                                CONSOJH,
    s.coutft                                                 COUTFT,
	  s.coutftht                                               COUTFTHT,
    consojh*coutft                                           TOTALSG,
    round(consojh*coutft*((100-t.taux)/100),2)               SALAIRESG,
    round(consojh*coutft*((t.taux)/100),2)                   CHARGESG,
        t.taux,
    t.annee
from
    histo_stock_immo_corrige s,
    proj_info pr,
    struct_info si,
        (select taux, annee from taux_charge_salariale) t
where
    s.soccode = 'SG..'
    and pr.icpi = s.icpi
    and s.codsg = si.codsg
    and t.annee = to_number(to_char(s.cdeb,'YYYY'))
order by cdeb, pid, ident;


BEGIN

DELETE AUDIT_IMMO;

COMMIT;

    --DEBUT TRAITEMENT CONCERNANT LES P2I ---
    FOR rec_audit_immo IN csr_audit_immo LOOP

        select count(*) into nbreFacture from ligne_fact where lmoisprest =  rec_audit_immo.cdeb and ident = rec_audit_immo.ident;

        IF (nbreFacture != 0) THEN

          tmp := 0;

          FOR rec_facture IN csr_facture(rec_audit_immo.cdeb, rec_audit_immo.ident) LOOP




			BEGIN


             SELECT t.tva into l_tva
                   FROM tva t
                   WHERE
				   t.datetva = (SELECT max(tva.datetva) FROM tva where datetva <= rec_facture.DATFACT);
              EXCEPTION
             WHEN OTHERS THEN
                     -- Code TVA inexistant
                    l_tva := 0 ;
            END;




            --DBMS_OUTPUT.PUT_LINE('l_tva : ' || l_tva);

			-- Applique la TVA au cout
			FMONTANTTTC := rec_facture.FMONTANTHT * ( 1 + l_tva/100 ) ;






            IF (tmp = 0) THEN


               -- IF (rec_audit_immo.ICPI = 'P4766') THEN




              --  DBMS_OUTPUT.PUT_LINE('l_tva 1 : ' || l_tva);
               -- DBMS_OUTPUT.PUT_LINE('FMONTANTHT 1 : ' || rec_facture.FMONTANTHT);


              --  DBMS_OUTPUT.PUT_LINE('FMONTANTTTC 1 : ' || FMONTANTTTC);


               -- DBMS_OUTPUT.PUT_LINE('TYPFACT 1 : ' || rec_facture.TYPFACT);


              --  DBMS_OUTPUT.PUT_LINE('ICPI 1 : ' || rec_audit_immo.ICPI);


               -- DBMS_OUTPUT.PUT_LINE('CDEB 1 : ' || rec_audit_immo.CDEB);
          -- END IF;

                INSERT INTO AUDIT_IMMO (CDEB, ICPI, ILIBEL, LIBDSG, PID, SOCCODE, IDENT, RNOM, CONSOJH, COUTFT,
                                        TOTALHTR, TYPFACT,NUMFACT, FMONTANTHTR, LMONTANTHT, FSOCFOUR, FREGCOMPTA, NUM_EXT, TOTALSG, SALAIRESG, CHARGESG, COUTFTHTR, DATFACT
                                       )
                                 VALUES (rec_audit_immo.CDEB,
                                        rec_audit_immo.ICPI,
                                        rec_audit_immo.ILIBEL,
                                        rec_audit_immo.LIBDSG,
                                        rec_audit_immo.PID,
                                        rec_audit_immo.SOCCODE,
                                        rec_audit_immo.IDENT,
                                        rec_audit_immo.RNOM,
                                        rec_audit_immo.CONSOJH,
                                        rec_audit_immo.COUTFTHT,
                                        rec_audit_immo.TOTALHTR, -- ABN -- HP PPM 60155
                                        rec_facture.TYPFACT,
                                        rec_facture.NUMFACT,
                                        decode(rec_facture.TYPFACT,'A',-1*FMONTANTTTC,FMONTANTTTC),
                                        decode(rec_facture.TYPFACT,'A',-1*rec_facture.FMONTANTHT,rec_facture.FMONTANTHT),
                                        rec_facture.SOCFOUR,
                                        trunc(rec_facture.REGCOMPTA),
                                        rec_facture.NUM_EXT,
                                        null,
                                        null,
                                        null,
										                    rec_audit_immo.COUTFT,
										                    rec_facture.DATFACT
                                        );

            ELSE


            -- IF (rec_audit_immo.ICPI = 'P4766') THEN


             -- DBMS_OUTPUT.PUT_LINE('l_tva 2 : ' || l_tva);


                 --  DBMS_OUTPUT.PUT_LINE('FMONTANTHT 2 : ' || rec_facture.FMONTANTHT);


               -- DBMS_OUTPUT.PUT_LINE('FMONTANTTTC 2 : ' || FMONTANTTTC);


               -- DBMS_OUTPUT.PUT_LINE('TYPFACT 2 : ' || rec_facture.TYPFACT);
               -- DBMS_OUTPUT.PUT_LINE('ICPI 2 : ' || rec_audit_immo.ICPI);
                --DBMS_OUTPUT.PUT_LINE('CDEB 2 : ' || rec_audit_immo.CDEB);


               -- END IF;


                  INSERT INTO AUDIT_IMMO (CDEB, ICPI, ILIBEL, LIBDSG, PID, SOCCODE, IDENT, RNOM, CONSOJH, COUTFT,
                                        TOTALHTR, TYPFACT,NUMFACT, FMONTANTHTR, LMONTANTHT, FSOCFOUR, FREGCOMPTA, NUM_EXT, TOTALSG, SALAIRESG, CHARGESG, COUTFTHTR, DATFACT
                                       )
                                 VALUES (rec_audit_immo.CDEB,
                                        rec_audit_immo.ICPI,
                                        rec_audit_immo.ILIBEL,
                                        rec_audit_immo.LIBDSG,
                                        rec_audit_immo.PID,
                                        rec_audit_immo.SOCCODE,
                                        rec_audit_immo.IDENT,
                                        rec_audit_immo.RNOM,
                                        0,
                                        0,
                                        0,
                                        rec_facture.TYPFACT,
                                        rec_facture.NUMFACT,
                                        decode(rec_facture.TYPFACT,'A',-1*FMONTANTTTC,FMONTANTTTC),
                                        decode(rec_facture.TYPFACT,'A',-1*rec_facture.FMONTANTHT,rec_facture.FMONTANTHT),
                                        rec_facture.SOCFOUR,
                                        trunc(rec_facture.REGCOMPTA),
                                        rec_facture.NUM_EXT,
                                        null,
                                        null,
                                        null,
										                       0,
										                    rec_facture.DATFACT
                                        );
            END IF;

             tmp := tmp+1;


          END LOOP;

        ELSE


            INSERT INTO AUDIT_IMMO (CDEB, ICPI, ILIBEL, LIBDSG, PID, SOCCODE, IDENT, RNOM, CONSOJH, COUTFT,
                                        TOTALHTR, TYPFACT,NUMFACT,FMONTANTHTR, LMONTANTHT, FSOCFOUR, FREGCOMPTA, NUM_EXT, TOTALSG, SALAIRESG, CHARGESG, COUTFTHTR
                                       )
                                 VALUES (rec_audit_immo.CDEB,
                                        rec_audit_immo.ICPI,
                                        rec_audit_immo.ILIBEL,
                                        rec_audit_immo.LIBDSG,
                                        rec_audit_immo.PID,
                                        rec_audit_immo.SOCCODE,
                                        rec_audit_immo.IDENT,
                                        rec_audit_immo.RNOM,
                                        rec_audit_immo.CONSOJH,
                                        rec_audit_immo.COUTFTHT,
                                        rec_audit_immo.TOTALHTR, -- ABN -- HP PPM 60155
                                        null,
                                        null,
                                        0,
                                        0,
                                        null,
                                        null,
                                        null,
                                        null,
                                        null,
                                        null,
										                    rec_audit_immo.COUTFT
                                        );

        END IF;


    END LOOP;
    --FIN TRAITEMENT CONCERNANT LES P2I ---

    --DEBUT TRAITEMENT CONCERNANT LES SG.. ---
    FOR rec_audit_immo_SG IN csr_audit_immo_SG LOOP
        INSERT INTO AUDIT_IMMO (CDEB, ICPI, ILIBEL, LIBDSG, PID, SOCCODE, IDENT, RNOM, CONSOJH, COUTFT,
                                        TOTALHTR, TYPFACT,NUMFACT, FMONTANTHTR, LMONTANTHT, FSOCFOUR, FREGCOMPTA, NUM_EXT,TOTALSG, SALAIRESG, CHARGESG, COUTFTHTR
                                       )
                                 VALUES (rec_audit_immo_SG.CDEB,
                                        rec_audit_immo_SG.ICPI,
                                        rec_audit_immo_SG.ILIBEL,
                                        rec_audit_immo_SG.LIBDSG,
                                        rec_audit_immo_SG.PID,
                                        rec_audit_immo_SG.SOCCODE,
                                        rec_audit_immo_SG.IDENT,
                                        rec_audit_immo_SG.RNOM,
                                        rec_audit_immo_SG.CONSOJH,
                                        rec_audit_immo_SG.COUTFTHT,
                                        rec_audit_immo_SG.TOTALSG,
                                        null,
                                        null,
                                        null,
                                        null,
                                        null,
                                        null,
                                        null,
                                        rec_audit_immo_SG.TOTALSG,
                                        rec_audit_immo_SG.SALAIRESG,
                                        rec_audit_immo_SG.CHARGESG,
                                        rec_audit_immo_SG.COUTFT
                                        );
    END LOOP;
    -- ABN - HP PPM 59613 --
    --FIN TRAITEMENT CONCERNANT LES SG.. ---


END alim_audit_immo;


PROCEDURE update_audit_immo(p_annee IN VARCHAR2,
                            p_pid   IN VARCHAR2,
                            p_icpi  IN VARCHAR2,
                            p_message OUT VARCHAR2
                            )

    IS
       l_msg VARCHAR2(1024);
        presence NUMBER;

       BEGIN
       p_message := '';





          BEGIN

            SELECT distinct 1 into presence from histo_stock_immo_corrige hs, audit_immo a
            WHERE hs.pid = UPPER(p_pid)
            and to_char(hs.cdeb,'YYYY') = p_annee
             and hs.pid = a.pid
            and hs.cdeb = a.cdeb;


            UPDATE histo_stock_immo_corrige SET
                icpi = upper(p_icpi)
            WHERE pid = UPPER(p_pid)
            and to_char(cdeb,'YYYY') = p_annee;

             UPDATE audit_immo SET
                icpi = upper(p_icpi)
            WHERE pid = UPPER(p_pid)
            and to_char(cdeb,'YYYY') = p_annee;

            -- message systeme modifié
            pack_global.recuperer_message(21141, NULL , NULL, NULL, l_msg);
            p_message := l_msg;

          EXCEPTION
            WHEN NO_DATA_FOUND THEN
                pack_global.recuperer_message( 21142, NULL, NULL, NULL, l_msg);
                p_message := l_msg;

            WHEN OTHERS THEN raise_application_error( -20997, SQLERRM);

          END;



END update_audit_immo;


PROCEDURE synthese_immo (   p_dpcode  IN VARCHAR,
                            p_icpi    IN VARCHAR2,
                            p_moismens OUT VARCHAR2,
                            p_libdp     OUT VARCHAR2,
                            p_libprojet     OUT VARCHAR2,
                            p_curseur     IN OUT synth_immo_listeCurType,
                            p_message OUT VARCHAR2
                        ) IS

   l_msg           VARCHAR2(1024);
   l_count_proj    NUMBER(4);
   pas_de_projet exception;
     BEGIN
     BEGIN

       /*  Recupération du dernier traitement mensuel */
       select to_char(moismens,'MM/YYYY') into p_moismens from datdebex;


     IF (p_dpcode is not null ) THEN


	 BEGIN
        select count(*) into l_count_proj from proj_info
        where ICODPROJ = p_dpcode;


        IF (l_count_proj = 0) THEN
            raise pas_de_projet;
        END IF;


     EXCEPTION
       WHEN pas_de_projet THEN
       Pack_Global.recuperer_message(21226, NULL,NULL,NULL, l_msg);
                     p_message := l_msg;


     END;


     begin
      /* recupération du libelle du dossier projet */
       select dplib into p_libdp from dossier_projet where dpcode = to_number(p_dpcode);
               EXCEPTION
               WHEN NO_DATA_FOUND THEN
                     Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
                     p_message := l_msg;
      end;

       OPEN p_curseur  FOR
                --- histo_stock_immo_corrige (2004 à N-1)
                select  pi.icpi projet,
                --Debut KRA PPM 61879 : ajout des 3 valeurs suivantes
                pi.ilibel libproj,
                pi.statut statutproj,
                to_char(pi.DATDEM,'MM/YYYY') datestatutproj,
                --Fin KRA PPM 61879                 

                a.annee annee ,
                nvl((select sum(consoJH) jh from Histo_stock_immo_corrige where h.icpi = icpi and a.annee = to_char(cdeb,'YYYY') ),0) jh,
                nvl((select sum(coutFT*consoJH) euro from Histo_stock_immo_corrige where h.icpi = icpi and a.annee = to_char(cdeb,'YYYY') ),0) euro
                from
                (select to_char(h.cdeb,'YYYY') annee from Histo_stock_immo_corrige h group by to_char(h.cdeb,'YYYY') ) a
                cross join proj_info pi
                left outer join Histo_stock_immo_corrige h on h.icpi = pi.icpi

                where pi.icodproj = to_number(p_dpcode)

                union

                -- Stock immo (N)
                select  pi.icpi projet,
                --Debut KRA PPM 61879 : ajout des 3 valeurs suivantes
                pi.ilibel libproj,
                pi.statut statutproj,
                to_char(pi.DATDEM,'MM/YYYY') datestatutproj,
                --Fin KRA PPM 61879 
                a.annee annee ,
                nvl((select sum(consoJH) jh from stock_immo where h.icpi = icpi and a.annee = to_char(cdeb,'YYYY') ),0) jh,
                nvl((select sum(coutFT*consoJH) euro from stock_immo where h.icpi = icpi and a.annee = to_char(cdeb,'YYYY') ),0) euro
                from
                (select to_char(h.cdeb,'YYYY') annee from stock_immo h group by to_char(h.cdeb,'YYYY') ) a
                cross join proj_info pi
                left outer join stock_immo h on h.icpi = pi.icpi

                where pi.icodproj = to_number(p_dpcode)

                order by projet, annee;



      
     ELSE
     begin
     /* recupération du libelle du projet */
      select ilibel into p_libprojet from proj_info where icpi = p_icpi;
         EXCEPTION
               WHEN NO_DATA_FOUND THEN
                     Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
                     p_message := l_msg;
      end;
      

      OPEN p_curseur  FOR
                --- histo_stock_immo_corrige (2004 à N-1)
                select  pi.icpi projet,
                --Debut KRA PPM 61879 : ajout des 3 valeurs suivantes
                pi.ilibel libproj,
                pi.statut statutproj,
                to_char(pi.DATDEM,'MM/YYYY') datestatutproj,
                --Fin KRA PPM 61879 
                a.annee annee ,
                nvl((select sum(consoJH) jh from Histo_stock_immo_corrige where h.icpi = icpi and a.annee = to_char(cdeb,'YYYY') ),0) jh,
                nvl((select sum(coutFT*consoJH) euro from Histo_stock_immo_corrige where h.icpi = icpi and a.annee = to_char(cdeb,'YYYY') ),0) euro
                from
                (select to_char(h.cdeb,'YYYY') annee from Histo_stock_immo_corrige h group by to_char(h.cdeb,'YYYY') ) a
                cross join proj_info pi
                left outer join Histo_stock_immo_corrige h on h.icpi = pi.icpi

                where pi.icpi = p_icpi

                union

                -- Stock immo (N)
                select  pi.icpi projet,
                --Debut KRA PPM 61879 : ajout des 3 valeurs suivantes
                pi.ilibel libproj,
                pi.statut statutproj,
                to_char(pi.DATDEM,'MM/YYYY') datestatutproj,
                --Fin KRA PPM 61879 
                a.annee annee ,
                nvl((select sum(consoJH) jh from stock_immo where h.icpi = icpi and a.annee = to_char(cdeb,'YYYY') ),0) jh,
                nvl((select sum(coutFT*consoJH) euro from stock_immo where h.icpi = icpi and a.annee = to_char(cdeb,'YYYY') ),0) euro
                from
                (select to_char(h.cdeb,'YYYY') annee from stock_immo h group by to_char(h.cdeb,'YYYY') ) a
                cross join proj_info pi
                left outer join stock_immo h on h.icpi = pi.icpi

                where pi.icpi = p_icpi

                order by projet, annee;

     END IF;


     EXCEPTION
               WHEN NO_DATA_FOUND THEN
                     Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
                     p_message := l_msg;


              WHEN OTHERS THEN
                        RAISE_APPLICATION_ERROR( -20998, SQLERRM);
    END;



END synthese_immo;

PROCEDURE synthese_immo_perim ( p_global IN VARCHAR2,
                            p_dpcode  IN VARCHAR,
                            p_icpi    IN VARCHAR2,
                            p_moismens OUT VARCHAR2,
                            p_libdp     OUT VARCHAR2,
                            p_libprojet     OUT VARCHAR2,
                            p_curseur     IN OUT synth_immo_listeCurType,
                            p_message OUT VARCHAR2
                        ) IS

   l_msg           VARCHAR2(1024);
   l_projets       VARCHAR2(5000);
   l_dos_projets   VARCHAR2(5000);
   l_count_proj   NUMBER(4);
   nb_doss_proj NUMBER; --PPM 58162
   perim_projet exception;
   perim_dos_proj exception;
   pas_de_projet exception;

BEGIN
     BEGIN

       /*  Recupération du dernier traitement mensuel */
       select to_char(moismens,'MM/YYYY') into p_moismens from datdebex;
     l_dos_projets := Pack_Global.LIRE_DOSS_PROJ(p_global);
     IF (p_dpcode is not null ) THEN
        IF('*'!=p_dpcode) THEN
            begin

                IF l_dos_projets is null OR 'TOUS'!=UPPER(l_dos_projets) THEN
                    IF (l_dos_projets is null or ''=l_dos_projets or INSTR(l_dos_projets,p_dpcode)<=0) THEN


                        RAISE perim_dos_proj;
                    end if;
                END IF;
                EXCEPTION
                WHEN perim_dos_proj THEN
                        Pack_Global.recuperer_message(21206, NULL,NULL,NULL, l_msg);
                        p_message := l_msg;
            end;


            BEGIN
                select count(*) into l_count_proj from proj_info
                where ICODPROJ = p_dpcode;


                IF (l_count_proj = 0) THEN
                    raise pas_de_projet;
                END IF;


             EXCEPTION
               WHEN pas_de_projet THEN
               Pack_Global.recuperer_message(21226, NULL,NULL,NULL, l_msg);
                             p_message := l_msg;

                END;


        END IF;

        IF('*'=p_dpcode) THEN
            p_libdp := 'Tous les dossiers projet de votre périmètre';
            begin
            IF (l_dos_projets is null) THEN
                        RAISE perim_dos_proj;
            end if;
            EXCEPTION
            WHEN perim_dos_proj THEN
                        Pack_Global.recuperer_message(21206, NULL,NULL,NULL, l_msg);
                        p_message := l_msg;
            end;
        ELSE
            begin
              /* recupération du libelle du dossier projet */
               select dplib into p_libdp from dossier_projet where dpcode = to_number(p_dpcode);
                       EXCEPTION
                       WHEN NO_DATA_FOUND THEN
                             Pack_Global.recuperer_message(21207, NULL,NULL,NULL, l_msg);
                             p_message := l_msg;
            end;
        END IF;
       IF('*'=p_dpcode) THEN
            -- Si dpcode = * , on renvoie tous les dossiers projet du périmètre utilisateur
           IF('TOUS'!=UPPER(l_dos_projets)) THEN
               OPEN p_curseur  FOR
                            --- histo_stock_immo_corrige (2004 à N-1)
                            select  pi.icpi projet,
                            --Debut KRA PPM 61879 : ajout des 3 valeurs suivantes
                            pi.ilibel libproj,
                            pi.statut statutproj,
                            to_char(pi.DATDEM,'MM/YYYY') datestatutproj,
                            --Fin KRA PPM 61879                             

                            a.annee annee ,
                            nvl((select sum(consoJH) jh from Histo_stock_immo_corrige where h.icpi = icpi and a.annee = to_char(cdeb,'YYYY') ),0) jh,
                            nvl((select sum(coutFT*consoJH) euro from Histo_stock_immo_corrige where h.icpi = icpi and a.annee = to_char(cdeb,'YYYY') ),0) euro
                            from
                            (select to_char(h.cdeb,'YYYY') annee from Histo_stock_immo_corrige h group by to_char(h.cdeb,'YYYY') ) a
                            cross join proj_info pi
                            left outer join Histo_stock_immo_corrige h on h.icpi = pi.icpi

                            where INSTR(l_dos_projets,to_char(pi.icodproj,'FM00000'))>0

                            union

                            -- Stock immo (N)
                            select  pi.icpi projet,
                            --Debut KRA PPM 61879 : ajout des 3 valeurs suivantes
                            pi.ilibel libproj,
                            pi.statut statutproj,
                            to_char(pi.DATDEM,'MM/YYYY') datestatutproj,
                            --Fin KRA PPM 61879                             

                            a.annee annee ,
                            nvl((select sum(consoJH) jh from stock_immo where h.icpi = icpi and a.annee = to_char(cdeb,'YYYY') ),0) jh,
                            nvl((select sum(coutFT*consoJH) euro from stock_immo where h.icpi = icpi and a.annee = to_char(cdeb,'YYYY') ),0) euro
                            from
                            (select to_char(h.cdeb,'YYYY') annee from stock_immo h group by to_char(h.cdeb,'YYYY') ) a
                            cross join proj_info pi
                            left outer join stock_immo h on h.icpi = pi.icpi

                            where INSTR(l_dos_projets,to_char(pi.icodproj,'FM00000'))>0

                            order by projet, annee;
            ELSE
                IF(l_dos_projets is not null)then
                    OPEN p_curseur  FOR
                                --- histo_stock_immo_corrige (2004 à N-1)
                                select  pi.icpi projet,
                                --Debut KRA PPM 61879 : ajout des 3 valeurs suivantes
                                pi.ilibel libproj,
                                pi.statut statutproj,
                                to_char(pi.DATDEM,'MM/YYYY') datestatutproj,
                                --Fin KRA PPM 61879 
                                a.annee annee ,
                                nvl((select sum(consoJH) jh from Histo_stock_immo_corrige where h.icpi = icpi and a.annee = to_char(cdeb,'YYYY') ),0) jh,
                                nvl((select sum(coutFT*consoJH) euro from Histo_stock_immo_corrige where h.icpi = icpi and a.annee = to_char(cdeb,'YYYY') ),0) euro
                                from
                                (select to_char(h.cdeb,'YYYY') annee from Histo_stock_immo_corrige h group by to_char(h.cdeb,'YYYY') ) a
                                cross join proj_info pi
                                left outer join Histo_stock_immo_corrige h on h.icpi = pi.icpi

                                union

                                -- Stock immo (N)
                                select  pi.icpi projet,
                                --Debut KRA PPM 61879 : ajout des 3 valeurs suivantes
                                pi.ilibel libproj,
                                pi.statut statutproj,
                                to_char(pi.DATDEM,'MM/YYYY') datestatutproj,
                                --Fin KRA PPM 61879                                 

                                a.annee annee ,
                                nvl((select sum(consoJH) jh from stock_immo where h.icpi = icpi and a.annee = to_char(cdeb,'YYYY') ),0) jh,
                                nvl((select sum(coutFT*consoJH) euro from stock_immo where h.icpi = icpi and a.annee = to_char(cdeb,'YYYY') ),0) euro
                                from
                                (select to_char(h.cdeb,'YYYY') annee from stock_immo h group by to_char(h.cdeb,'YYYY') ) a
                                cross join proj_info pi
                                left outer join stock_immo h on h.icpi = pi.icpi


                                order by projet, annee;
                ELSE
                        OPEN p_curseur  FOR select null,NULL,NULL,NULL,null,null,null from dual;--KRA PPM 61879
                          begin
                              RAISE perim_dos_proj;

                              EXCEPTION
                              WHEN perim_dos_proj THEN
                                Pack_Global.recuperer_message(21206, NULL,NULL,NULL, l_msg);
                                p_message := l_msg;
                          end;
                END IF;
            END IF;
       ELSE
           OPEN p_curseur  FOR
                    --- histo_stock_immo_corrige (2004 à N-1)
                    select  pi.icpi projet,
                    --Debut KRA PPM 61879 : ajout des 3 valeurs suivantes
                    pi.ilibel libproj,
                    pi.statut statutproj,
                    to_char(pi.DATDEM,'MM/YYYY') datestatutproj,
                    --Fin KRA PPM 61879                     

                    a.annee annee ,
                    nvl((select sum(consoJH) jh from Histo_stock_immo_corrige where h.icpi = icpi and a.annee = to_char(cdeb,'YYYY') ),0) jh,
                    nvl((select sum(coutFT*consoJH) euro from Histo_stock_immo_corrige where h.icpi = icpi and a.annee = to_char(cdeb,'YYYY') ),0) euro
                    from
                    (select to_char(h.cdeb,'YYYY') annee from Histo_stock_immo_corrige h group by to_char(h.cdeb,'YYYY') ) a
                    cross join proj_info pi
                    left outer join Histo_stock_immo_corrige h on h.icpi = pi.icpi

                    where pi.icodproj = to_number(p_dpcode)

                    union

                    -- Stock immo (N)
                    select  pi.icpi projet,
                    --Debut KRA PPM 61879 : ajout des 3 valeurs suivantes
                    pi.ilibel libproj,
                    pi.statut statutproj,
                    to_char(pi.DATDEM,'MM/YYYY') datestatutproj,
                    --Fin KRA PPM 61879 
                    a.annee annee ,
                    nvl((select sum(consoJH) jh from stock_immo where h.icpi = icpi and a.annee = to_char(cdeb,'YYYY') ),0) jh,
                    nvl((select sum(coutFT*consoJH) euro from stock_immo where h.icpi = icpi and a.annee = to_char(cdeb,'YYYY') ),0) euro
                    from
                    (select to_char(h.cdeb,'YYYY') annee from stock_immo h group by to_char(h.cdeb,'YYYY') ) a
                    cross join proj_info pi
                    left outer join stock_immo h on h.icpi = pi.icpi

                    where pi.icodproj = to_number(p_dpcode)

                    order by projet, annee;
       END IF;

     ELSE
         l_projets := Pack_Global.LIRE_PROJET(p_global);
                    -- Debut PPM 58162
           -- nombre de projets inclus dans des dossiers habilite
        SELECT COUNT (DISTINCT pi.icpi) INTO nb_doss_proj
	    FROM proj_info pi, ligne_bip lb, datdebex d
	    WHERE pi.icpi = lb.icpi
		AND pi.icpi = p_icpi
	      AND ((pi.datdem IS NULL) OR (pi.datdem >= d.datdebex))
	      AND ((lb.adatestatut IS NULL) OR (lb.adatestatut >= d.datdebex))
	      AND INSTR(l_dos_projets, TO_CHAR(lb.dpcode, 'FM00000')) > 0;


         IF ('*'!=p_icpi) THEN
             begin

                IF l_projets is null OR 'TOUS'!=UPPER(l_projets) THEN
                -- PPM 58162 : autorisation de la saisie des projets inclus dans des dosssiers projest sur lesquels la ressource est habilitee
                    IF ((l_projets is null or ''=l_projets or INSTR(l_projets,p_icpi)=0) and (nb_doss_proj=0)) THEN
                        RAISE perim_projet;
                    end if;
                    --Fin PPM 58162
                END IF;
                EXCEPTION
                WHEN perim_projet THEN
                        Pack_Global.recuperer_message(21204, NULL,NULL,NULL, l_msg);
                        p_message := l_msg;
             end;
         END IF;
         IF ('*'=p_icpi) THEN
            p_libprojet := 'Tous les projets de votre périmètre';
            begin
            IF (l_projets is null) THEN
                        RAISE perim_projet;
            end if;
            EXCEPTION
            WHEN perim_projet THEN
                        Pack_Global.recuperer_message(21204, NULL,NULL,NULL, l_msg);
                        p_message := l_msg;
            end;
         ELSE
             begin
             /* recupération du libelle du projet */
              select ilibel into p_libprojet from proj_info where icpi = p_icpi;
                 EXCEPTION
                       WHEN NO_DATA_FOUND THEN
                             Pack_Global.recuperer_message(21205, NULL,NULL,NULL, l_msg);
                             p_message := l_msg;
              end;
         END IF;


          IF ('*'=p_icpi) THEN
              -- si icpi = * on renvoie tous les projets du périmètre utilisateur
                  IF ('TOUS'!=UPPER(l_projets)) THEN
                      OPEN p_curseur  FOR
                                --- histo_stock_immo_corrige (2004 à N-1)
                                select  pi.icpi projet,
                                --Debut KRA PPM 61879 : ajout des 3 valeurs suivantes
                                pi.ilibel libproj,
                                pi.statut statutproj,
                                to_char(pi.DATDEM,'MM/YYYY') datestatutproj,
                                --Fin KRA PPM 61879                                 
                                a.annee annee ,
                                nvl((select sum(consoJH) jh from Histo_stock_immo_corrige where h.icpi = icpi and a.annee = to_char(cdeb,'YYYY') ),0) jh,
                                nvl((select sum(coutFT*consoJH) euro from Histo_stock_immo_corrige where h.icpi = icpi and a.annee = to_char(cdeb,'YYYY') ),0) euro
                                from
                                (select to_char(h.cdeb,'YYYY') annee from Histo_stock_immo_corrige h group by to_char(h.cdeb,'YYYY') ) a
                                cross join proj_info pi
                                left outer join Histo_stock_immo_corrige h on h.icpi = pi.icpi

                               where INSTR(l_projets,pi.icpi)>0

                                union

                                -- Stock immo (N)
                                select  pi.icpi projet,
                                --Debut KRA PPM 61879 : ajout des 3 valeurs suivantes
                                pi.ilibel libproj,
                                pi.statut statutproj,
                                to_char(pi.DATDEM,'MM/YYYY') datestatutproj,
                                --Fin KRA PPM 61879                                 
                                a.annee annee ,
                                nvl((select sum(consoJH) jh from stock_immo where h.icpi = icpi and a.annee = to_char(cdeb,'YYYY') ),0) jh,
                                nvl((select sum(coutFT*consoJH) euro from stock_immo where h.icpi = icpi and a.annee = to_char(cdeb,'YYYY') ),0) euro
                                from
                                (select to_char(h.cdeb,'YYYY') annee from stock_immo h group by to_char(h.cdeb,'YYYY') ) a
                                cross join proj_info pi
                                left outer join stock_immo h on h.icpi = pi.icpi

                                where INSTR(l_projets,pi.icpi)>0

                                order by projet, annee;
                  ELSE
                      IF(l_projets is not null)then
                            OPEN p_curseur  FOR
                                    --- histo_stock_immo_corrige (2004 à N-1)
                                    select  pi.icpi projet,
                                    --Debut KRA PPM 61879 : ajout des 3 valeurs suivantes
                                    pi.ilibel libproj,
                                    pi.statut statutproj,
                                    to_char(pi.DATDEM,'MM/YYYY') datestatutproj,
                                    --Fin KRA PPM 61879 

                                    a.annee annee ,
                                    nvl((select sum(consoJH) jh from Histo_stock_immo_corrige where h.icpi = icpi and a.annee = to_char(cdeb,'YYYY') ),0) jh,
                                    nvl((select sum(coutFT*consoJH) euro from Histo_stock_immo_corrige where h.icpi = icpi and a.annee = to_char(cdeb,'YYYY') ),0) euro
                                    from
                                    (select to_char(h.cdeb,'YYYY') annee from Histo_stock_immo_corrige h group by to_char(h.cdeb,'YYYY') ) a
                                    cross join proj_info pi
                                    left outer join Histo_stock_immo_corrige h on h.icpi = pi.icpi

                                    union

                                    -- Stock immo (N)
                                    select  pi.icpi projet,
                                    --Debut KRA PPM 61879 : ajout des 3 valeurs suivantes
                                    pi.ilibel libproj,
                                    pi.statut statutproj,
                                    to_char(pi.DATDEM,'MM/YYYY') datestatutproj,
                                    --Fin KRA PPM 61879                                     

                                    a.annee annee ,
                                    nvl((select sum(consoJH) jh from stock_immo where h.icpi = icpi and a.annee = to_char(cdeb,'YYYY') ),0) jh,
                                    nvl((select sum(coutFT*consoJH) euro from stock_immo where h.icpi = icpi and a.annee = to_char(cdeb,'YYYY') ),0) euro
                                    from
                                    (select to_char(h.cdeb,'YYYY') annee from stock_immo h group by to_char(h.cdeb,'YYYY') ) a
                                    cross join proj_info pi
                                    left outer join stock_immo h on h.icpi = pi.icpi

                                    order by projet, annee;
                      ELSE
                          OPEN p_curseur  FOR select null,NULL,NULL,NULL,null,null,null from dual;
                          begin
                              RAISE perim_projet;

                              EXCEPTION
                              WHEN perim_projet THEN
                                Pack_Global.recuperer_message(21204, NULL,NULL,NULL, l_msg);
                                p_message := l_msg;
                          end;
                      END IF;
                  END IF;
          ELSE
               OPEN p_curseur  FOR
                        --- histo_stock_immo_corrige (2004 à N-1)
                        select  pi.icpi projet,
                        --Debut KRA PPM 61879 : ajout des 3 valeurs suivantes
                        pi.ilibel libproj,
                        pi.statut statutproj,
                        to_char(pi.DATDEM,'MM/YYYY') datestatutproj,
                        --Fin KRA PPM 61879                        

                        a.annee annee ,
                        nvl((select sum(consoJH) jh from Histo_stock_immo_corrige where h.icpi = icpi and a.annee = to_char(cdeb,'YYYY') ),0) jh,
                        nvl((select sum(coutFT*consoJH) euro from Histo_stock_immo_corrige where h.icpi = icpi and a.annee = to_char(cdeb,'YYYY') ),0) euro
                        from
                        (select to_char(h.cdeb,'YYYY') annee from Histo_stock_immo_corrige h group by to_char(h.cdeb,'YYYY') ) a
                        cross join proj_info pi
                        left outer join Histo_stock_immo_corrige h on h.icpi = pi.icpi

                        where pi.icpi = p_icpi

                        union

                        -- Stock immo (N)
                        select  pi.icpi projet,
                        --Debut KRA PPM 61879 : ajout des 3 valeurs suivantes
                        pi.ilibel libproj,
                        pi.statut statutproj,
                        to_char(pi.DATDEM,'MM/YYYY') datestatutproj,
                        --Fin KRA PPM 61879                         

                        a.annee annee ,
                        nvl((select sum(consoJH) jh from stock_immo where h.icpi = icpi and a.annee = to_char(cdeb,'YYYY') ),0) jh,
                        nvl((select sum(coutFT*consoJH) euro from stock_immo where h.icpi = icpi and a.annee = to_char(cdeb,'YYYY') ),0) euro
                        from
                        (select to_char(h.cdeb,'YYYY') annee from stock_immo h group by to_char(h.cdeb,'YYYY') ) a
                        cross join proj_info pi
                        left outer join stock_immo h on h.icpi = pi.icpi

                        where pi.icpi = p_icpi

                        order by projet, annee;

          END IF;


     END IF;


     EXCEPTION
               WHEN NO_DATA_FOUND THEN
                     Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
                     p_message := l_msg;


               WHEN OTHERS THEN
                        RAISE_APPLICATION_ERROR( -20998, SQLERRM);
    END;



END synthese_immo_perim;

PROCEDURE get_projets_perimcli (   p_global  IN VARCHAR2,
                            p_curseur     IN OUT string_listeCurType) IS

l_perimcli VARCHAR2(1024);
l_clicode VARCHAR2(1024);

BEGIN


     l_perimcli := Pack_Global.LIRE_PERIMCLI(p_global);

     BEGIN




          OPEN p_curseur FOR  SELECT DISTINCT proj.icpi
                                                FROM proj_info proj, ligne_bip lb
                                                WHERE lb.icpi = proj.icpi
                                                AND (lb.clicode IN (select clicode from vue_clicode_perimo where INSTR (l_perimcli,bdclicode)>0) OR lb.clicode_oper IN (select clicode from vue_clicode_perimo where INSTR (l_perimcli,bdclicode)>0))
                                                and proj.icpi IN (select distinct icpi from stock_immo union select distinct icpi from histo_stock_immo_corrige)
                                                AND proj.icpi <> 'P0000'
                                                order by proj.icpi;



     EXCEPTION
              WHEN OTHERS THEN
                        RAISE_APPLICATION_ERROR( -20998, SQLERRM);
    END;



END get_projets_perimcli;

PROCEDURE get_dpcode_perimcli (   p_global  IN VARCHAR2,
                            p_curseur     IN OUT string_listeCurType) IS

l_perimcli VARCHAR2(1024);
l_clicode VARCHAR2(1024);

BEGIN


     l_perimcli := Pack_Global.LIRE_PERIMCLI(p_global);

     BEGIN





          OPEN p_curseur FOR  SELECT DISTINCT TO_CHAR(proj.icodproj)
                                                FROM proj_info proj, ligne_bip lb
                                                WHERE lb.icpi = proj.icpi
                                                AND (lb.clicode IN (select clicode from vue_clicode_perimo where INSTR (l_perimcli,bdclicode)>0) OR lb.clicode_oper IN (select clicode from vue_clicode_perimo where INSTR (l_perimcli,bdclicode)>0))
                                                and proj.icodproj IN (select distinct dpcode from stock_immo union select distinct dpcode from histo_stock_immo_corrige)
                                                order by proj.icodproj;




     EXCEPTION
              WHEN OTHERS THEN
                        RAISE_APPLICATION_ERROR( -20998, SQLERRM);
    END;



END get_dpcode_perimcli;

PROCEDURE synthese_immo_mo (   p_dpcode  IN VARCHAR,
                            p_icpi    IN VARCHAR2,
                            p_moismens OUT VARCHAR2,
                            p_libdp     OUT VARCHAR2,
                            p_libprojet     OUT VARCHAR2,
                            p_curseur     IN OUT synth_immo_mo_listeCurType,
                            p_message OUT VARCHAR2
                        ) IS

   l_msg           VARCHAR2(1024);

BEGIN
     BEGIN

       /*  Recupération du dernier traitement mensuel */
       select to_char(moismens,'MM/YYYY') into p_moismens from datdebex;


     IF (p_dpcode is not null ) THEN
     begin
      /* recupération du libelle du dossier projet */
       select dplib into p_libdp from dossier_projet where dpcode = to_number(p_dpcode);
               EXCEPTION
               WHEN NO_DATA_FOUND THEN
                     Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
                     p_message := l_msg;
      end;
       OPEN p_curseur  FOR
                select composant,
                --Debut KRA PPM 61879 : ajout des 3 valeurs suivantes
                libproj, statutproj, datestatutproj, 
                --Fin KRA PPM 61879                  
                projet, annee, nvl(sum(jh),0), nvl(sum(euro),0) from(

                --- histo_stock_immo_corrige (2004 à N-1)
                select  TO_CHAR(pi.icodproj) composant, 
                --Debut KRA PPM 61879 : ajout des 3 valeurs suivantes
                pi.ilibel libproj,
                pi.statut statutproj,
                to_char(pi.DATDEM,'MM/YYYY') datestatutproj,
                --Fin KRA PPM 61879                
                pi.icpi projet,

                a.annee annee ,
                nvl((select sum(consoJH) jh from Histo_stock_immo_corrige where h.icpi = icpi and a.annee = to_char(cdeb,'YYYY') and dpcode = to_number(p_dpcode) ),0) jh,
                nvl((select sum(coutFT*consoJH) euro from Histo_stock_immo_corrige where h.icpi = icpi and a.annee = to_char(cdeb,'YYYY') and dpcode = to_number(p_dpcode) ),0) euro
                from
                (select to_char(cdeb,'YYYY') annee from Histo_stock_immo_corrige group by to_char(cdeb,'YYYY') union
                select to_char(cdeb,'YYYY') annee from stock_immo group by to_char(cdeb,'YYYY') order by annee) a
                cross join proj_info pi
                left outer join Histo_stock_immo_corrige h on h.icpi = pi.icpi

                where pi.icodproj = to_number(p_dpcode)
                and h.consoJH <> 0

                union

                -- Stock immo (N)
                select  TO_CHAR(pi.icodproj) composant, 
                --Debut KRA PPM 61879 : ajout des 3 valeurs suivantes
                pi.ilibel libproj,
                pi.statut statutproj,
                to_char(pi.DATDEM,'MM/YYYY') datestatutproj,
                --Fin KRA PPM 61879                 
                pi.icpi projet,

                a.annee annee ,
                nvl((select sum(consoJH) jh from stock_immo where h.icpi = icpi and a.annee = to_char(cdeb,'YYYY') and dpcode = to_number(p_dpcode) ),0) jh,
                nvl((select sum(coutFT*consoJH) euro from stock_immo where h.icpi = icpi and a.annee = to_char(cdeb,'YYYY') and dpcode = to_number(p_dpcode) ),0) euro
                from
                (select to_char(cdeb,'YYYY') annee from Histo_stock_immo_corrige group by to_char(cdeb,'YYYY') union
                select to_char(cdeb,'YYYY') annee from stock_immo group by to_char(cdeb,'YYYY') order by annee) a
                cross join proj_info pi
                left outer join stock_immo h on h.icpi = pi.icpi

                where pi.icodproj = to_number(p_dpcode)
                and h.consoJH <> 0

                order by projet, annee)
                group by composant, libproj, statutproj, datestatutproj, projet, annee --KRA PPM 61879 : ajout de 3 valeurs


                order by composant, projet, annee;


     ELSE
     begin
     /* recupération du libelle du projet */
      select ilibel into p_libprojet from proj_info where icpi = p_icpi;
         EXCEPTION
               WHEN NO_DATA_FOUND THEN
                     Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
                     p_message := l_msg;
      end;

      OPEN p_curseur  FOR
            select composant, 
                --Debut KRA PPM 61879 : ajout des 3 valeurs suivantes
                libproj, statutproj, datestatutproj, 
                --Fin KRA PPM 61879 
                projet, annee, nvl(sum(jh),0), nvl(sum(euro),0) from(


                --- histo_stock_immo_corrige (2004 à N-1)
            select  h.icpi composant, 
                --Debut KRA PPM 61879 : ajout des 3 valeurs suivantes
                pi.ilibel libproj,
                pi.statut statutproj,
                to_char(pi.DATDEM,'MM/YYYY') datestatutproj,
                --Fin KRA PPM 61879
                h.pid projet,

                a.annee annee ,
                nvl((select sum(consoJH) jh from Histo_stock_immo_corrige where h.pid = pid and a.annee = to_char(cdeb,'YYYY') and icpi = p_icpi ),0) jh,
                nvl((select sum(coutFT*consoJH) euro from Histo_stock_immo_corrige where h.pid = pid and a.annee = to_char(cdeb,'YYYY') and icpi = p_icpi ),0) euro
                from
                (select to_char(cdeb,'YYYY') annee from Histo_stock_immo_corrige group by to_char(cdeb,'YYYY') union
                select to_char(cdeb,'YYYY') annee from stock_immo group by to_char(cdeb,'YYYY') order by annee) a
                cross join proj_info pi
                left outer join Histo_stock_immo_corrige h on h.icpi = pi.icpi

                where h.icpi = p_icpi
                and h.consoJH <> 0

                union

                -- Stock immo (N)
                select  h.icpi composant, 
                --Debut KRA PPM 61879 : ajout des 3 valeurs suivantes
                pi.ilibel libproj,
                pi.statut statutproj,
                to_char(pi.DATDEM,'MM/YYYY') datestatutproj,
                --Fin KRA PPM 61879
                h.pid projet,

                a.annee annee ,
                nvl((select sum(consoJH) jh from stock_immo where h.pid = pid and a.annee = to_char(cdeb,'YYYY') and icpi = p_icpi ),0) jh,
                nvl((select sum(coutFT*consoJH) euro from stock_immo where h.pid = pid and a.annee = to_char(cdeb,'YYYY') and icpi = p_icpi ),0) euro
                from
                (select to_char(cdeb,'YYYY') annee from Histo_stock_immo_corrige group by to_char(cdeb,'YYYY') union
                select to_char(cdeb,'YYYY') annee from stock_immo group by to_char(cdeb,'YYYY') order by annee) a
                cross join proj_info pi
                left outer join stock_immo h on h.icpi = pi.icpi

                where h.icpi = p_icpi
                and h.consoJH <> 0

                order by projet, annee)
                group by composant, libproj, statutproj, datestatutproj, projet, annee --KRA PPM 61879 : ajout de 3 valeurs


                order by composant, projet, annee;

     END IF;


     EXCEPTION
               WHEN NO_DATA_FOUND THEN
                     Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
                     p_message := l_msg;


              WHEN OTHERS THEN
                        RAISE_APPLICATION_ERROR( -20998, SQLERRM);
    END;



END synthese_immo_mo;


END pack_audit_immo;
/


