/*
	esourcing.sql: fichier contenant le package pack_esourcing permettant la mise
	à jour des données contrats et ressources en provenance de l'application
	esourcing d'Oalia.

	créé le 23/11/2004 par DSIC/SUP
	Modifié le 13/07/2006 par PPR : traitement des accents des noms des ressources
	Modifié le 28/09/2006 par PPR : Correction du problème des dates à 0006
	Modifié le 21/03/2007 par EVI : Correction du problème de jointure avec la table IMMEUBLE
	Modifié le 20/03/2008 par EVI : correction anomalie: plantage si code societe n'existe pas
	Modifié le 04/06/2008 par ABA : ajout du test lorsque la situation à inserer appartient à la deuxième quinzaine du mois et se trouvant également dans le mois de fin de la situation précédente
	Modifié le 16/06/2008 par ABA : modification de la procedure des situation pour intégration des nouvelles règles de gestion 
	Modifié le 09/07/2008 par ABA : TD 588 flux des agences bip vers resao + prise en compte des siren lors de la creation de contrat
	Modifié le 30/07/2008 par ABA : ajout d'un test lorsque l'on insère une situation dejà existante dans la bip
	Modifié le 31/07/2008 par ABA :  TD 667 modification du la procedure historise_contrat ajout du timestamp 
	Modifié le 01/10/2008 par ABA :  TD 588  ajout siren 
	Modifié le 07/04/2008 par ABA :  TD 791 
	Modifié le 09/04/2008 par ABA :  TD 737
	Modifié le 08/06/2009 par ABA :  TD 814
	Modifié le 19/08/2009 par JBE :  TD 821
	Modifié le 09/11/2009 par ABA:  correction en cas de plusieur siren pour un soccode, c'est le soccode de resao qui fait foi
	Modifié le 09/11/2009 par ABA:  extension de la correction ci -dessus sur les contrat et ligne contrat, puis interdiction d'ajout des lignes cotrat qd le contrats existe déjà en base
	Modifié le 23/02/2010 par ABA:  TD 940 
	Modifié le 24/06/2010 par YSB:  TD 970 
	Modifié le 17/07/2010 par YSB:  TD 970
	Modifié le 23/07/2010 par YSB:  TD 970
    Modifié le 05/10/2010 par ABA:  TD 970
	Modifié le 05/10/2010 par ABA:  correction cas erreur numero 3
*/
CREATE OR REPLACE PACKAGE  PACK_ESOURCING IS

/* procedure d'insertion/controle des contrats envoyés par esourcing */
PROCEDURE create_contrat(P_HFILE utl_file.file_type);

/* procedure d'insertion/controle des lignes de contrats envoyés par esourcing */
PROCEDURE create_ligne_cont(P_HFILE utl_file.file_type);

/* procedure d'insertion/suppression des contrats et lignes contrat traités */
PROCEDURE historise_contrat(P_HFILE utl_file.file_type);

------------------------------------------------------------
-- Cette procedure met à jour ou crée les ressources
-- envoyées par l'outil eSourcing
------------------------------------------------------------
    PROCEDURE alim_ressource (P_HFILE utl_file.file_type) ;

------------------------------------------------------------
-- Cette procedure crée les situations associées
-- aux ressources
------------------------------------------------------------
    PROCEDURE alim_situ (P_HFILE utl_file.file_type);

------------------------------------------------------------
-- Cette procedure archive les données concernant
-- les ressources (conservées 2 mois)
------------------------------------------------------------
    PROCEDURE archive_esourcing(P_HFILE utl_file.file_type);

------------------------------------------------------------
-- Cette procedure supprime les ressources crees
-- sans situation
------------------------------------------------------------
    PROCEDURE verif_ress (P_HFILE utl_file.file_type);

/* procedure générale permettant le lancement des procédures d'insertions des données pour les ressources*/
PROCEDURE global_ressource (P_LOGDIR VARCHAR2);


/* procedure générale permettant le lancement des procédures d'insertions des données pour les contrats*/
PROCEDURE global_contrat (P_LOGDIR VARCHAR2);


/* procedure d'export des agences*/
PROCEDURE export_agences(p_chemin_fichier VARCHAR2, p_nom_fichier VARCHAR2);

END pack_esourcing;
/


CREATE OR REPLACE PACKAGE BODY     PACK_ESOURCING IS

        -- Gestions exceptions
    -- -------------------
    CALLEE_FAILED exception;
    pragma exception_init( CALLEE_FAILED, -20000 );
    CALLEE_FAILED_ID     number := -20000;   -- pour propagation dans pile d'appel
    TRCLOG_FAILED_ID     number := -20001;   -- problème : erreur dans la gestion d'erreur !
    ERR_FONCTIONNELLE_ID number := -20002;   -- pour provoquer erreur alors que Oracle OK
    CONSTRAINT_VIOLATION exception;          -- pour clause when
    pragma exception_init( CONSTRAINT_VIOLATION, -2291 ); -- typiquement : clé étrangère
    CALLEE_FAILED exception;
    pragma exception_init( CALLEE_FAILED, -20000 );


PROCEDURE create_contrat (P_HFILE utl_file.file_type) IS

    L_PROCNAME varchar2(30):='CREATE_CONTRAT';
    L_ORAERRMSG varchar2(150);
    L_CNAFFAIR contrat.cnaffair%TYPE;
    L_RETOUR tmp_contrat.retour%TYPE;
    L_FILCODE contrat.filcode%TYPE;
    L_CENTREFRAIS contrat.ccentrefrais%TYPE;
    L_SOCIETE societe.soccode%TYPE;
    l_date_courante VARCHAR2(8);
    l_date_fer VARCHAR2(8);
    l_soccont  VARCHAR2(4);

    L_TAMPON  number(2);

    L_VALIDATION CHAR(2);

    CURSOR cr_cont IS
    SELECT ID_OALIA,UPPER(NUMCONT) numcont,CAV,DPG,
        UPPER(SOCCONT) soccont,CAGREMENT,DATARR,
        OBJET,COMCODE,TYPEFACT,COUTOT,CHARESTI,DATDEB,DATFIN, SIREN
    FROM TMP_CONTRAT
    ;

    BEGIN
        TRCLOG.TRCLOG( P_HFILE, '!!!!!!!!!!!!!!!!!!!!  Debut du traitement d insertion des CONTRATS  !!!!!!!!!!!!!!!!!!!!');

        -- parcours du curseur pour insertion, vérification des règles, retours

        FOR enr_cour IN cr_cont LOOP
            TRCLOG.TRCLOG( P_HFILE, '********  Debut insertion contrat: '||enr_cour.numcont||' ,id oalia: '||enr_cour.id_oalia);

            BEGIN
                     L_VALIDATION:='OK';

                     /*  */
                     IF enr_cour.cav = '000' THEN
                         L_CNAFFAIR:='OUI';
                     ELSE
                         L_CNAFFAIR:='NON';
                     END IF;

                     BEGIN
                         SELECT 1 INTO L_TAMPON
                         FROM code_compt
                         WHERE comcode=enr_cour.comcode;
                EXCEPTION
                         WHEN NO_DATA_FOUND THEN
                         TRCLOG.TRCLOG( P_HFILE, 'le code comptable : '||enr_cour.comcode||' n existe pas.');
                         L_RETOUR:='Code comptable inexistant';
                         L_VALIDATION:='ER';
                     END;

                     IF NVL(enr_cour.typefact,' ')<>'R' THEN
                         TRCLOG.TRCLOG( P_HFILE, 'Type de facturation non valide.');
                         L_RETOUR:='Type de facturation non valide.';
                         L_VALIDATION:='ER';
                     END IF;

                     BEGIN
                         SELECT scentrefrais,filcode INTO L_CENTREFRAIS,L_FILCODE
                         FROM struct_info
                         where codsg=enr_cour.dpg;

                     EXCEPTION
                         WHEN NO_DATA_FOUND THEN
                             TRCLOG.TRCLOG( P_HFILE, 'le code DPG : '||enr_cour.dpg||' n est pas correct.');
                             TRCLOG.TRCLOG( P_HFILE, 'Probleme pour récupérer le centre de frais ou le code filiale.');
                             L_RETOUR:='Pb avec centre de frais ou filcode ou DPG.';
                             L_VALIDATION:='ER';
                     END;

                     -- controle de la societe

                SELECT TO_CHAR(SYSDATE,'yyyymmdd')
                      INTO l_date_courante
                      FROM DUAL;

                      l_date_fer := '00';



                       /* TD 588  : si le siren n'est pas présent on prends le soccode envoyé par resao
                       dans le cas contraire on retrouve le soccode dans la BIP via le siren de resao

                       Ce test est valable le temps que resao modifie leur traitement pour nous envoyé le siren
                       une fois qu'ils nous enverront le siren le test n'a plus lieu d'être il deviendra inutile etant donné
                       que le chargement du fichier via sqlloader généraera un .bad
                       */
                      IF (enr_cour.siren is null) THEN
                      BEGIN
                            SELECT TO_CHAR(socfer,'yyyymmdd')
                            INTO l_date_fer
                            FROM societe
                            WHERE soccode = enr_cour.soccont;

                            l_soccont := enr_cour.soccont;

                            EXCEPTION
                                WHEN NO_DATA_FOUND THEN
                                TRCLOG.TRCLOG( P_HFILE, 'le code societe : '||enr_cour.soccont||' n est pas correct.');
                                L_RETOUR:='Pb avec la societe';
                                 L_VALIDATION:='ER';
                            END;



                      ELSE
                      BEGIN
                        select distinct a.soccode, TO_CHAR(s.socfer,'yyyymmdd')  into l_soccont, l_date_fer
                        FROM AGENCE a, societe s
                        where siren = enr_cour.siren
                        and s.soccode = a.soccode;

                        EXCEPTION
                                WHEN NO_DATA_FOUND THEN
                                TRCLOG.TRCLOG( P_HFILE, 'le siren : '||enr_cour.siren||' n est pas présent dans la BIP.');
                                L_RETOUR:='Le siren n est pas present dans la BIP ';
                                 L_VALIDATION:='ER';
                                WHEN TOO_MANY_ROWS THEN
                                      SELECT TO_CHAR(socfer,'yyyymmdd')
                                    INTO l_date_fer
                                     FROM societe
                                    WHERE soccode = enr_cour.soccont;

                                 l_soccont := enr_cour.soccont;

                            END;


                      END IF;
                      /*FIN du TEST*/

                      IF l_date_fer <> '00' and l_date_fer <= l_date_courante THEN
                          L_RETOUR:='Code société fermé';
                          L_VALIDATION:='ER';
                        END IF;



                     IF enr_cour.datdeb>enr_cour.datfin THEN
                         TRCLOG.TRCLOG( P_HFILE, 'La date de début est supérieure à la date de fin.');
                         L_RETOUR:='Date de fin inférieure à date de debut contrat';
                         L_VALIDATION:='ER';
                     END IF;

                    -- controle de l'existence du contrat

                     BEGIN

                         SELECT 1 INTO L_TAMPON
                         FROM contrat c
                         WHERE c.numcont=UPPER(enr_cour.numcont)
                         AND c.cav=enr_cour.cav
                         AND RTRIM(c.soccont)=RTRIM(UPPER(enr_cour.soccont));


                         IF L_TAMPON=1 THEN
                             TRCLOG.TRCLOG( P_HFILE, 'le contrat existe déjà. Création impossible.');
                             L_RETOUR:='Contrat existe déjà. Création impossible.';
                             L_VALIDATION:='ER';
                         END IF;

                     EXCEPTION
                         WHEN NO_DATA_FOUND THEN
                             IF L_VALIDATION='OK' THEN
                                 TRCLOG.TRCLOG( P_HFILE, 'Contrat nouveau, insertion à effectuer');
                             ELSE
                                 TRCLOG.TRCLOG( P_HFILE, 'Contrat nouveau mais impossible à insérer');
                             END IF;
                     END;


                     IF L_VALIDATION='OK' THEN

                         TRCLOG.TRCLOG( P_HFILE, 'Insertion du contrat');

                         INSERT INTO contrat(numcont,cchtsoc,ctypfact,cobjet1,cobjet2,cobjet3,crem,cantfact,cmoiderfac,cmmens,
                                 ccharesti,cecartht,cevainit,cnaffair,cagrement,crang,cantcons,ccoutht,cdatannul,cdatarr,
                                 cdatclot,cdatdeb,cdatsoce,cdatfin,cdatmaj,cdatdir,cdatbilq,cdatrpol,cdatsocr,cdatsai,
                                 cduree,flaglock,soccont,cav,filcode,comcode,niche,codsg,ccentrefrais,siren,top30,orictr)
                         VALUES (
                         UPPER(enr_cour.numcont),
                         NULL,
                         enr_cour.typefact,
                         SUBSTR(enr_cour.objet,1,50),
                         SUBSTR(enr_cour.objet,51,50),
                         NULL,
                         NULL,
                         NULL,
                         NULL,
                         NULL,
                         enr_cour.charesti,
                         NULL,
                         NULL,
                         L_CNAFFAIR,
                         enr_cour.cagrement,
                         NULL,
                         0,
                         enr_cour.coutot,
                         NULL,
                         enr_cour.datarr,
                         NULL,
                         enr_cour.datdeb,
                         NULL,
                         enr_cour.datfin,
                         NULL,
                         sysdate,
                         NULL,
                         sysdate,
                         NULL,
                         sysdate,
                         NULL,
                         0,
                         UPPER(l_soccont),
                         UPPER(enr_cour.cav),
                         NVL(L_FILCODE,'01'),
                         enr_cour.comcode,
                         NULL,
                         enr_cour.dpg,
                         L_CENTREFRAIS,
                         enr_cour.siren,
                         'N',
						 'RES'
                         );

              -- YSB : Log création des contrats
              Pack_contrat.maj_contrats_logs(UPPER(enr_cour.numcont),enr_cour.siren,UPPER(l_soccont),UPPER(enr_cour.cav),enr_cour.dpg,null,
                       'Batch esourcing','contrat','numcont',null,UPPER(enr_cour.numcont),enr_cour.datdeb,enr_cour.datfin,1,'Batch');
              Pack_contrat.maj_contrats_logs(UPPER(enr_cour.numcont),enr_cour.siren,UPPER(l_soccont),UPPER(enr_cour.cav),enr_cour.dpg,null,
                       'Batch esourcing','contrat','ctypfact',null,enr_cour.typefact,enr_cour.datdeb,enr_cour.datfin,1,'Batch');
              Pack_contrat.maj_contrats_logs(UPPER(enr_cour.numcont),enr_cour.siren,UPPER(l_soccont),UPPER(enr_cour.cav),enr_cour.dpg,null,
                       'Batch esourcing','contrat','cobjet1',null,SUBSTR(enr_cour.objet,1,50),enr_cour.datdeb,enr_cour.datfin,1,'Batch');
              Pack_contrat.maj_contrats_logs(UPPER(enr_cour.numcont),enr_cour.siren,UPPER(l_soccont),UPPER(enr_cour.cav),enr_cour.dpg,null,
                       'Batch esourcing','contrat','cobjet2',null,SUBSTR(enr_cour.objet,51,50),enr_cour.datdeb,enr_cour.datfin,1,'Batch');   -- NOK
              Pack_contrat.maj_contrats_logs(UPPER(enr_cour.numcont),enr_cour.siren,UPPER(l_soccont),UPPER(enr_cour.cav),enr_cour.dpg,null,
                       'Batch esourcing','contrat','ccharesti',null,enr_cour.charesti,enr_cour.datdeb,enr_cour.datfin,1,'Batch');
              Pack_contrat.maj_contrats_logs(UPPER(enr_cour.numcont),enr_cour.siren,UPPER(l_soccont),UPPER(enr_cour.cav),enr_cour.dpg,null,
                       'Batch esourcing','contrat','cnaffair',null,L_CNAFFAIR,enr_cour.datdeb,enr_cour.datfin,1,'Batch');
              Pack_contrat.maj_contrats_logs(UPPER(enr_cour.numcont),enr_cour.siren,UPPER(l_soccont),UPPER(enr_cour.cav),enr_cour.dpg,null,
                       'Batch esourcing','contrat','cagrement',null,enr_cour.cagrement,enr_cour.datdeb,enr_cour.datfin,1,'Batch');  --NOK
              Pack_contrat.maj_contrats_logs(UPPER(enr_cour.numcont),enr_cour.siren,UPPER(l_soccont),UPPER(enr_cour.cav),enr_cour.dpg,null,
                       'Batch esourcing','contrat','cantcons',null,'0',enr_cour.datdeb,enr_cour.datfin,1,'Batch');
              Pack_contrat.maj_contrats_logs(UPPER(enr_cour.numcont),enr_cour.siren,UPPER(l_soccont),UPPER(enr_cour.cav),enr_cour.dpg,null,
                       'Batch esourcing','contrat','ccoutht',null,enr_cour.coutot,enr_cour.datdeb,enr_cour.datfin,1,'Batch');
              Pack_contrat.maj_contrats_logs(UPPER(enr_cour.numcont),enr_cour.siren,UPPER(l_soccont),UPPER(enr_cour.cav),enr_cour.dpg,null,
                       'Batch esourcing','contrat','cdatarr',null,enr_cour.datarr,enr_cour.datdeb,enr_cour.datfin,1,'Batch');
              Pack_contrat.maj_contrats_logs(UPPER(enr_cour.numcont),enr_cour.siren,UPPER(l_soccont),UPPER(enr_cour.cav),enr_cour.dpg,null,
                       'Batch esourcing','contrat','cdatdeb',null,enr_cour.datdeb,enr_cour.datdeb,enr_cour.datfin,1,'Batch');
              Pack_contrat.maj_contrats_logs(UPPER(enr_cour.numcont),enr_cour.siren,UPPER(l_soccont),UPPER(enr_cour.cav),enr_cour.dpg,null,
                       'Batch esourcing','contrat','cdatfin',null,enr_cour.datfin,enr_cour.datdeb,enr_cour.datfin,1,'Batch');
              Pack_contrat.maj_contrats_logs(UPPER(enr_cour.numcont),enr_cour.siren,UPPER(l_soccont),UPPER(enr_cour.cav),enr_cour.dpg,null,
                       'Batch esourcing','contrat','cdatdir',null,sysdate,enr_cour.datdeb,enr_cour.datfin,1,'Batch');
              Pack_contrat.maj_contrats_logs(UPPER(enr_cour.numcont),enr_cour.siren,UPPER(l_soccont),UPPER(enr_cour.cav),enr_cour.dpg,null,
                       'Batch esourcing','contrat','cdatrpol',null,sysdate,enr_cour.datdeb,enr_cour.datfin,1,'Batch');
              Pack_contrat.maj_contrats_logs(UPPER(enr_cour.numcont),enr_cour.siren,UPPER(l_soccont),UPPER(enr_cour.cav),enr_cour.dpg,null,
                       'Batch esourcing','contrat','cdatsai',null,sysdate,enr_cour.datdeb,enr_cour.datfin,1,'Batch');
              Pack_contrat.maj_contrats_logs(UPPER(enr_cour.numcont),enr_cour.siren,UPPER(l_soccont),UPPER(enr_cour.cav),enr_cour.dpg,null,
                       'Batch esourcing','contrat','flaglock',null,'0',enr_cour.datdeb,enr_cour.datfin,1,'Batch');
              Pack_contrat.maj_contrats_logs(UPPER(enr_cour.numcont),enr_cour.siren,UPPER(l_soccont),UPPER(enr_cour.cav),enr_cour.dpg,null,
                       'Batch esourcing','contrat','soccont',null,UPPER(l_soccont),enr_cour.datdeb,enr_cour.datfin,1,'Batch');
              Pack_contrat.maj_contrats_logs(UPPER(enr_cour.numcont),enr_cour.siren,UPPER(l_soccont),UPPER(enr_cour.cav),enr_cour.dpg,null,
                       'Batch esourcing','contrat','cav',null,UPPER(enr_cour.cav),enr_cour.datdeb,enr_cour.datfin,1,'Batch');
              Pack_contrat.maj_contrats_logs(UPPER(enr_cour.numcont),enr_cour.siren,UPPER(l_soccont),UPPER(enr_cour.cav),enr_cour.dpg,null,
                       'Batch esourcing','contrat','filcode',null,NVL(L_FILCODE,'01'),enr_cour.datdeb,enr_cour.datfin,1,'Batch');
              Pack_contrat.maj_contrats_logs(UPPER(enr_cour.numcont),enr_cour.siren,UPPER(l_soccont),UPPER(enr_cour.cav),enr_cour.dpg,null,
                       'Batch esourcing','contrat','comcode',null,enr_cour.comcode,enr_cour.datdeb,enr_cour.datfin,1,'Batch');
              Pack_contrat.maj_contrats_logs(UPPER(enr_cour.numcont),enr_cour.siren,UPPER(l_soccont),UPPER(enr_cour.cav),enr_cour.dpg,null,
                       'Batch esourcing','contrat','codsg',null,enr_cour.dpg,enr_cour.datdeb,enr_cour.datfin,1,'Batch');
              Pack_contrat.maj_contrats_logs(UPPER(enr_cour.numcont),enr_cour.siren,UPPER(l_soccont),UPPER(enr_cour.cav),enr_cour.dpg,null,
                       'Batch esourcing','contrat','ccentrefrais',null,L_CENTREFRAIS,enr_cour.datdeb,enr_cour.datfin,1,'Batch');
              Pack_contrat.maj_contrats_logs(UPPER(enr_cour.numcont),enr_cour.siren,UPPER(l_soccont),UPPER(enr_cour.cav),enr_cour.dpg,null,
                       'Batch esourcing','contrat','siren',null,enr_cour.siren,enr_cour.datdeb,enr_cour.datfin,1,'Batch');
              Pack_contrat.maj_contrats_logs(UPPER(enr_cour.numcont),enr_cour.siren,UPPER(l_soccont),UPPER(enr_cour.cav),enr_cour.dpg,null,
                       'Batch esourcing','contrat','top30',null,'N',enr_cour.datdeb,enr_cour.datfin,1,'Batch');

              L_RETOUR:='INSERTION OK';

                     END IF;

                     UPDATE tmp_contrat
                SET retour=L_RETOUR,
                    date_trait=sysdate
                WHERE tmp_contrat.id_oalia=enr_cour.id_oalia;

                     COMMIT;

            EXCEPTION
                WHEN CONSTRAINT_VIOLATION THEN

                    L_ORAERRMSG:=sqlerrm;

                    UPDATE tmp_contrat
                    SET retour=SUBSTR(L_ORAERRMSG,1,49),
                        date_trait=sysdate
                    WHERE tmp_contrat.id_oalia=enr_cour.id_oalia;

                    COMMIT;

                    TRCLOG.TRCLOG( P_HFILE, 'Contrat, violation de contrainte pour id_oalia: '||enr_cour.id_oalia);
                    TRCLOG.TRCLOG( P_HFILE, sqlerrm);

                WHEN others THEN

                    L_ORAERRMSG:=sqlerrm;

                    UPDATE tmp_contrat
                    SET retour=SUBSTR(L_ORAERRMSG,1,49),
                        date_trait=sysdate
                    WHERE tmp_contrat.id_oalia=enr_cour.id_oalia;

                    COMMIT;
                    TRCLOG.TRCLOG( P_HFILE, 'Contrat, probleme lors de l insert'||enr_cour.id_oalia);
                    TRCLOG.TRCLOG( P_HFILE, sqlerrm);


            END;
        END LOOP;


    EXCEPTION
        WHEN others THEN
            TRCLOG.TRCLOG( P_HFILE, '**********************************************************');
            TRCLOG.TRCLOG( P_HFILE, 'Probleme lors de l insertion des contrats _ Arret du batch');
            TRCLOG.TRCLOG( P_HFILE, sqlerrm);
            TRCLOG.TRCLOG( P_HFILE, '**********************************************************');

    END;

PROCEDURE create_ligne_cont(P_HFILE utl_file.file_type) IS

    L_PROCNAME varchar2(30):='CREATE_LIGNE_CONT';
    L_ORAERRMSG varchar2(150);
    L_RETOUR tmp_ligne_cont.retour%TYPE;
    L_VALIDATION CHAR(2);
    L_CDATDEB contrat.cdatdeb%TYPE;
    L_CDATFIN contrat.cdatfin%TYPE;
    L_MAXLCNUM ligne_cont.lcnum%TYPE;
    L_COUNT  number(10);
    L_COUNT1  number(10);
    L_COUNT2  number(10);
    L_TAMPON  number(2);
    l_soccont varchar2(4);

    CURSOR cr_ligne_cont IS
    SELECT  l.id_oalia,
        l.ident,
        UPPER(l.numcont) numcont,
        l.cav,
        UPPER(l.soccont) soccont,
        l.coutht,
        l.datdeb,
        l.datfin,
        l.proporig,
        l.qualif,
        l.siren
    FROM tmp_ligne_cont l, tmp_contrat c
    where c.numcont = l.numcont
    and c.cav = l.cav
    and c.soccont = l.soccont
    and c.RETOUR ='INSERTION OK'
    ORDER BY l.numcont,l.cav,l.soccont,l.ident,l.datdeb,l.datfin
    ;


    CURSOR cr_tmp_contrat IS
    SELECT numcont,
            cav,
               soccont,
               siren
           FROM TMP_CONTRAT;


    BEGIN

        /*  pour toutes les lignes dont l'insertion du contrat RESAO est en erreur,
        on met à jour le champ retour avec le message suivant : contrat resao en erreur  */

        UPDATE tmp_ligne_cont tl
        SET tl.retour = 'contrat resao en erreur, ligne contrat rejetée'
        WHERE EXISTS (
          SELECT 1
            FROM tmp_contrat c
           WHERE tl.numcont = c.numcont
             AND tl.cav = c.cav
             AND tl.soccont = c.soccont
             AND c.retour != 'INSERTION OK');

        /*  On parcoure la table tmp_contrat pour attribuer le siren à chaque ligne contrat
            celui ci permettras egalement d'affecter le bon soccode à chaque ligne en fonction du siren
            */
        FOR enr_tmp_contrat IN cr_tmp_contrat LOOP

            BEGIN
                UPDATE TMP_LIGNE_CONT SET SIREN=enr_tmp_contrat.siren
                WHERE numcont = enr_tmp_contrat.numcont
                and cav = enr_tmp_contrat.cav
                and soccont = enr_tmp_contrat.soccont;
            END;

        END LOOP;


        TRCLOG.TRCLOG( P_HFILE,' ');
        TRCLOG.TRCLOG( P_HFILE, '!!!!!!!!!!!!!!!!!!  Debut du traitement d insertion des LIGNES DE CONTRATS  !!!!!!!!!!!!!!!!!!');

        FOR enr_cour IN cr_ligne_cont LOOP
            TRCLOG.TRCLOG( P_HFILE, '********  Debut insertion ligne contrat: '||enr_cour.numcont||' ,id oalia: '||enr_cour.id_oalia);
            TRCLOG.TRCLOG( P_HFILE, 'Contrat: '||enr_cour.numcont||' ,id oalia: '||enr_cour.id_oalia);
            BEGIN
                     L_VALIDATION:='OK';
                     L_RETOUR:=NULL;
                     L_CDATDEB:=NULL;
                L_CDATFIN:=NULL;
                L_MAXLCNUM:=0;
                L_TAMPON:=NULL;

                --Vérification de la valeur du coût
                IF enr_cour.coutht IS NULL THEN
                    TRCLOG.TRCLOG( P_HFILE, 'Le coût hors taxe est null, il doit être renseigné');
                    L_VALIDATION:='ER';
                    L_RETOUR:='cout HT non valide';
                END IF;

                IF (enr_cour.siren is null) THEN

                    l_soccont := enr_cour.soccont;
                ELSE
                    BEGIN
                        SELECT distinct soccode into l_soccont
                        FROM AGENCE
                        WHERE siren = enr_cour.siren;

                        EXCEPTION
                            WHEN NO_DATA_FOUND THEN
                            TRCLOG.TRCLOG( P_HFILE, 'le siren : '||enr_cour.siren||' n existe pas dans la BIP.');
                            L_RETOUR:='Siren inexistant dans la BIP';
                            L_VALIDATION:='ER';
                        --WHEN OTHERS THEN
                               --raise_application_error(-20997,SQLERRM);
                            WHEN TOO_MANY_ROWS THEN
                                l_soccont := enr_cour.soccont;
                     END;

                END IF;


                -- Vérification de l'existence du contrat et de la validité des dates
                BEGIN
                            SELECT c.cdatdeb, c.cdatfin
                            INTO   l_cdatdeb, l_cdatfin
                            FROM   contrat c
                            WHERE UPPER(enr_cour.numcont)=c.numcont
                    AND enr_cour.cav=c.cav
                    AND RTRIM(UPPER(l_soccont))=RTRIM(c.soccont);

                     EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                               TRCLOG.TRCLOG( P_HFILE, 'le contrat : '||enr_cour.numcont||' , '||enr_cour.cav||' , '||l_soccont||' n existe pas.');
                         L_RETOUR:='Contrat inexistant';
                         L_VALIDATION:='ER';
                        --WHEN OTHERS THEN
                               --raise_application_error(-20997,SQLERRM);
                     END;

                    IF enr_cour.datdeb > enr_cour.datfin THEN
                            -- La date de fin doit être supérieure ou égale à la date de début
                            TRCLOG.TRCLOG( P_HFILE, 'La date de fin doit etre superieure a la date de debut');
                         L_RETOUR:='La date de fin doit etre superieure a la date de debut';
                         L_VALIDATION:='ER';

                    ELSIF  ( enr_cour.datdeb < L_CDATDEB ) OR
                            ( enr_cour.datdeb > L_CDATFIN ) OR
                                ( enr_cour.datfin < L_CDATDEB ) OR
                            ( enr_cour.datfin > L_CDATFIN ) THEN

                        -- message  Dates de début et de fin de prestation doivent être comprises
                        -- entre dates de début et de fin de contrat.
                            TRCLOG.TRCLOG( P_HFILE, 'Date debut et fin de prestation non comprises entre date de fin et debut de contrat');
                         L_RETOUR:='Date deb-fin prest non comprises date deb-fin cont';
                         L_VALIDATION:='ER';

                    END IF;

                     -- Test d'existence de la ressource
                     BEGIN
                         SELECT 1 INTO L_TAMPON
                         FROM ressource
                         WHERE ressource.ident=enr_cour.ident;
                     EXCEPTION
                         WHEN NO_DATA_FOUND THEN
                             TRCLOG.TRCLOG( P_HFILE, 'la ressource : '||enr_cour.ident||' n existe pas.');
                             L_RETOUR:='Ressource inexistante';
                             L_VALIDATION:='ER';
                     END;

                -- calcul du numero de ligne
                BEGIN
                         SELECT max(l.lcnum)
                         INTO   L_MAXLCNUM
                         FROM   ligne_cont l
                         WHERE  RTRIM(l.soccont) = RTRIM(UPPER(l_soccont))
                           AND  l.numcont = UPPER(enr_cour.numcont)
                           AND  l.cav = enr_cour.cav;

                      EXCEPTION
                          WHEN OTHERS THEN
                                TRCLOG.TRCLOG( P_HFILE, 'Erreur lors du calcul du numero de ligne ');
                                L_RETOUR:='Erreur lors du calcul nu numero de ligne';
                                L_VALIDATION:='ER';
                      END;


                     L_MAXLCNUM := NVL(L_MAXLCNUM,0)+1;

                      IF L_VALIDATION='OK' THEN

                  BEGIN

                     SELECT count(distinct(ident)) into L_COUNT
                        From
                        (
                         SELECT  ident
                            FROM   ligne_cont l
                            WHERE  RTRIM(l.soccont) = RTRIM(UPPER(l_soccont))
                            AND  l.numcont = UPPER(enr_cour.numcont)
                            AND  l.cav = enr_cour.cav
                        UNION
                        SELECT ident
                        From tmp_ligne_cont tl
                            WHERE  RTRIM(tl.soccont) = RTRIM(enr_cour.soccont)
                            AND  tl.numcont = UPPER(enr_cour.numcont)
                            AND  tl.cav = enr_cour.cav
                        );

                    IF(L_COUNT > 1)  THEN

                      INSERT INTO ligne_cont(lcnum,lfraisdep,lastreinte,lheursup,lresdeb,lresfin,lcdatact,lccouact,
                                  lccouinit,lcprest,soccont,cav,numcont,ident,proporig,MODE_CONTRACTUEL)
                      VALUES
                      (L_MAXLCNUM,
                      NULL,
                      NULL,
                      NULL,
                      enr_cour.datdeb,
                      enr_cour.datfin,
                      NULL,
                      enr_cour.coutht,
                      NULL,
                      NULL,-- YSB nr_cour.qualif la nature de la prestation (Domaine et prestation) sont recherchés dynamiquement dans la situation de la ressource
                      UPPER(l_soccont),
                      UPPER(enr_cour.cav),
                      UPPER(enr_cour.numcont),
                      enr_cour.ident,
                      enr_cour.proporig,
                      'ATM');

                    ELSE

                      INSERT INTO ligne_cont(lcnum,lfraisdep,lastreinte,lheursup,lresdeb,lresfin,lcdatact,lccouact,
                                  lccouinit,lcprest,soccont,cav,numcont,ident,proporig,MODE_CONTRACTUEL)
                      VALUES
                      (L_MAXLCNUM,
                      NULL,
                      NULL,
                      NULL,
                      enr_cour.datdeb,
                      enr_cour.datfin,
                      NULL,
                      enr_cour.coutht,
                      NULL,
                      NULL,-- YSB  enr_cour.qualif la nature de la prestation (Domaine et prestation) sont recherchés dynamiquement dans la situation de la ressource
                      UPPER(l_soccont),
                      UPPER(enr_cour.cav),
                      UPPER(enr_cour.numcont),
                      enr_cour.ident,
                      enr_cour.proporig,
                      'ATU');

                    END IF;

                    pack_contrat.maj_contrats_logs(enr_cour.numcont,null,l_soccont,enr_cour.cav,null,L_MAXLCNUM,'Batch esourcing','ligne_cont',
                            'lcnum',null,L_MAXLCNUM,enr_cour.datdeb,enr_cour.datfin,1,'Batch esourcing : création de la ligne contrat');
                    pack_contrat.maj_contrats_logs(enr_cour.numcont,null,l_soccont,enr_cour.cav,null,L_MAXLCNUM,'Batch esourcing','ligne_cont',
                            'lresdeb',null,enr_cour.datdeb,enr_cour.datdeb,enr_cour.datfin,1,'Batch esourcing : création de la ligne contrat');
                    pack_contrat.maj_contrats_logs(enr_cour.numcont,null,l_soccont,enr_cour.cav,null,L_MAXLCNUM,'Batch esourcing','ligne_cont',
                            'lresfin',null,enr_cour.datfin,enr_cour.datdeb,enr_cour.datfin,1,'Batch esourcing : création de la ligne contrat');
                    pack_contrat.maj_contrats_logs(enr_cour.numcont,null,l_soccont,enr_cour.cav,null,L_MAXLCNUM,'Batch esourcing','ligne_cont',
                            'lccouact',null,enr_cour.coutht,enr_cour.datdeb,enr_cour.datfin,1,'Batch esourcing : création de la ligne contrat');
                    pack_contrat.maj_contrats_logs(enr_cour.numcont,null,l_soccont,enr_cour.cav,null,L_MAXLCNUM,'Batch esourcing','ligne_cont',
                            'soccont',null,l_soccont,enr_cour.datdeb,enr_cour.datfin,1,'Batch esourcing : création de la ligne contrat');
                    pack_contrat.maj_contrats_logs(enr_cour.numcont,null,l_soccont,enr_cour.cav,null,L_MAXLCNUM,'Batch esourcing','ligne_cont',
                            'cav',null,enr_cour.cav,enr_cour.datdeb,enr_cour.datfin,1,'Batch esourcing : création de la ligne contrat');
                    pack_contrat.maj_contrats_logs(enr_cour.numcont,null,l_soccont,enr_cour.cav,null,L_MAXLCNUM,'Batch esourcing','ligne_cont',
                            'numcont',null,enr_cour.numcont,enr_cour.datdeb,enr_cour.datfin,1,'Batch esourcing : création de la ligne contrat');
                    pack_contrat.maj_contrats_logs(enr_cour.numcont,null,l_soccont,enr_cour.cav,null,L_MAXLCNUM,'Batch esourcing','ligne_cont',
                            'ident',null,enr_cour.ident,enr_cour.datdeb,enr_cour.datfin,1,'Batch esourcing : création de la ligne contrat');
                    pack_contrat.maj_contrats_logs(enr_cour.numcont,null,l_soccont,enr_cour.cav,null,L_MAXLCNUM,'Batch esourcing','ligne_cont',
                            'proporig',null,enr_cour.proporig,enr_cour.datdeb,enr_cour.datfin,1,'Batch esourcing : création de la ligne contrat');

                    IF(L_COUNT > 1)  THEN
                      pack_contrat.maj_contrats_logs(enr_cour.numcont,null,l_soccont,enr_cour.cav,null,L_MAXLCNUM,'Batch esourcing','ligne_cont',
                            'mode_contractuel',null,'ATM',enr_cour.datdeb,enr_cour.datfin,1,'Batch esourcing : création de la ligne contrat');
                    ELSE
                      pack_contrat.maj_contrats_logs(enr_cour.numcont,null,l_soccont,enr_cour.cav,null,L_MAXLCNUM,'Batch esourcing','ligne_cont',
                            'mode_contractuel',null,'ATU',enr_cour.datdeb,enr_cour.datfin,1,'Batch esourcing : création de la ligne contrat');
                    END IF;

                    L_RETOUR:='INSERTION OK';

                END;
                END IF;



                UPDATE tmp_ligne_cont
                SET retour=L_RETOUR,
                   date_trait=sysdate
                WHERE tmp_ligne_cont.id_oalia=enr_cour.id_oalia;

                     COMMIT;

            EXCEPTION
                WHEN CONSTRAINT_VIOLATION THEN

                    L_ORAERRMSG:=sqlerrm;

                    UPDATE tmp_ligne_cont
                    SET retour=SUBSTR(L_ORAERRMSG,1,50),
                        date_trait=sysdate
                    WHERE tmp_ligne_cont.id_oalia=enr_cour.id_oalia;

                    COMMIT;

                    TRCLOG.TRCLOG( P_HFILE, 'Ligne contrat, violation de contrainte pour id_oalia: '||enr_cour.id_oalia);
                    TRCLOG.TRCLOG( P_HFILE, sqlerrm);

                WHEN others THEN

                    TRCLOG.TRCLOG( P_HFILE, 'Ligne contrat, probleme lors de l insertion de : '||enr_cour.id_oalia);
                    TRCLOG.TRCLOG( P_HFILE, 'Numcont: '||enr_cour.numcont||', soccont: '||l_soccont||', avenant: '||enr_cour.cav||', N° ligne: '||L_MAXLCNUM);
                    TRCLOG.TRCLOG( P_HFILE, sqlerrm);

                    L_ORAERRMSG:=sqlerrm;

                    UPDATE tmp_ligne_cont
                    SET retour=SUBSTR(L_ORAERRMSG,1,50),
                        date_trait=sysdate
                    WHERE tmp_ligne_cont.id_oalia=enr_cour.id_oalia;

                    COMMIT;


            END;


        END LOOP;

        EXCEPTION
        WHEN others THEN
            TRCLOG.TRCLOG( P_HFILE, '**********************************************************');
            TRCLOG.TRCLOG( P_HFILE, 'Probleme lors de l insertion des lignes contrat _ Arret du batch');
            TRCLOG.TRCLOG( P_HFILE, sqlerrm);
            TRCLOG.TRCLOG( P_HFILE, '**********************************************************');

    END;

PROCEDURE historise_contrat(P_HFILE utl_file.file_type) IS

    L_TAMPON NUMBER(3);


    CURSOR cr_histo IS
        SELECT id_oalia_cont,id_oalia_ligne,soccont,numcont,cav,ident,codsg,datdeb,datfin,proporig,date_trait,retour
        FROM esourcing_contrat;


    cursor cr_log IS
    SELECT     c.id_oalia  c_id_oalia,
            l.id_oalia     l_id_oalia,
            c.soccont      c_soccont,
            c.numcont      c_numcont ,
            c.cav          c_cav ,
            l.ident        l_ident ,
            c.dpg          c_dpg,
            l.datdeb       l_datdeb  ,
            l.datfin        l_datfin,
            l.proporig      l_proporig,
            DECODE(c.RETOUR,'INSERTION OK',l.date_trait,to_date(c.date_trait)) datetrait,
            DECODE(c.RETOUR,'INSERTION OK',l.RETOUR, c.retour) message,
            c.siren        c_siren,
            l.MODE_CONTRACTUEL lmode_contractuel
         FROM
            tmp_contrat c,
            tmp_ligne_cont l
        WHERE
            c.soccont=l.soccont
        AND    c.numcont=l.numcont
        AND    c.cav=l.cav
        ;


    BEGIN
        TRCLOG.TRCLOG( P_HFILE, '!!!!!!!!!!!!!!!!!!  Debut du traitement d historisation des enregistrements contrat et ligne contrats  !!!!!!!!!!!!!!!!!!');
        -- 05/08/2009 YSB : Suppression des enregistrements antérieurs de 3 mois à la date du jour

        TRCLOG.TRCLOG( P_HFILE,'Suppression des enregistrements anterieurs de 3 mois à la date du jour');

        BEGIN

            DELETE esourcing_contrat
            WHERE date_trait<add_months(sysdate,-3);--sysdate-14;

            COMMIT;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                TRCLOG.TRCLOG( P_HFILE,'Pas d enregistrement à supprimer.');

        END;

        TRCLOG.TRCLOG( P_HFILE,'Verification des correspondances contrats / lignes contrats dans les tables temporaires.');

        SELECT COUNT(*) INTO L_TAMPON
        FROM tmp_contrat
        WHERE (numcont,soccont,cav) NOT IN (SELECT numcont,soccont,cav FROM tmp_ligne_cont);

        IF L_TAMPON<>0 THEN
            TRCLOG.TRCLOG( P_HFILE,'Certains contrats ne sont pas rattachés à des lignes');
        END IF;

        SELECT COUNT(*) INTO L_TAMPON
        FROM tmp_ligne_cont
        WHERE (numcont,soccont,cav) NOT IN (SELECT numcont,soccont,cav FROM tmp_contrat);

        IF L_TAMPON<>0 THEN
            TRCLOG.TRCLOG( P_HFILE,'Certaines lignes ne sont pas rattachées à des contrats');
        END IF;

        TRCLOG.TRCLOG( P_HFILE,'Insertion des données dans la table d historique');

     FOR cur IN cr_log LOOP

        INSERT INTO esourcing_contrat (id_oalia_cont,id_oalia_ligne,soccont,numcont,cav,ident,codsg,datdeb,datfin,proporig,date_trait,retour,siren,MODE_CONTRACTUEL)
       values (  cur.c_id_oalia,
                cur.l_id_oalia,
                 cur.c_soccont,
                 cur.c_numcont ,
                   cur.c_cav ,
                 cur.l_ident ,
                  cur.c_dpg,
               cur.l_datdeb  ,
                 cur.l_datfin,
                 cur.l_proporig,
            cur.datetrait,
             cur.message,
            cur.c_siren,
            cur.lmode_contractuel
            );

   END LOOP;
        COMMIT;


    EXCEPTION
        WHEN others THEN
            TRCLOG.TRCLOG( P_HFILE, '**********************************************************');
            TRCLOG.TRCLOG( P_HFILE, 'Probleme lors de l historisation des enregistrements _ Arret du batch');
            TRCLOG.TRCLOG( P_HFILE, sqlerrm);
            TRCLOG.TRCLOG( P_HFILE, '**********************************************************');


END;

--------------------------------------------------------------------------------------
-- PROCEDURE DE MAJ ET DE CREATION DES RESSOURCES
--------------------------------------------------------------------------------------
PROCEDURE alim_ressource (P_HFILE utl_file.file_type)  IS

L_MATRICULE ressource.matricule%TYPE;
L_IDENT ressource.ident%TYPE;
L_TEST NUMBER;
L_CODE_RETOUR tmp_ressource.code_retour%TYPE;
L_ORA VARCHAR2(200);
L_RETOUR tmp_ressource.retour%TYPE;
referential_integrity EXCEPTION;
PRAGMA EXCEPTION_INIT(referential_integrity, -2291);

L_RETCOD    number;
L_PROCNAME  varchar2(256) := 'alim_ressource';
L_STATEMENT varchar2(256);
BEGIN

    -----------------------------------------------------
    -- Trace Start
    -----------------------------------------------------
    TRCLOG.TRCLOG( P_HFILE, 'Debut de ' || L_PROCNAME );

    -- on renseigne les codes retour dans la table temporaire
                -- test format du matricule : commence par X
                UPDATE TMP_RESSOURCE
                SET CODE_RETOUR=1,RETOUR='Matricule doit commencer par X'
                WHERE UPPER(SUBSTR(matricule,0,1)) <> 'X';
                COMMIT;

                -- Matricule en doublon dans le fichier envoye par esourcing
                UPDATE TMP_RESSOURCE tmp
                SET CODE_RETOUR=1,RETOUR='Matricule en doublon'
                WHERE EXISTS (SELECT distinct 1 FROM tmp_ressource r1
                    WHERE UPPER(r1.matricule)=UPPER(tmp.matricule)
                    AND (r1.id_oalia <> tmp.id_oalia)
                          AND r1.CODE_RETOUR is null
                          AND tmp.CODE_RETOUR is null);
                COMMIT;

                -- Ajuste le nom et le prénom : met des majuscules et enlève des accents
                UPDATE TMP_RESSOURCE r
                SET rnom = TRIM(TRANSLATE(upper(rnom),upper('àâéèêëîôû') , 'AAEEEEIOU')),
                 rprenom = TRIM(TRANSLATE(upper(rprenom),upper('àâéèêëîôû') , 'AAEEEEIOU'));

                -- test existence du matricule
                UPDATE TMP_RESSOURCE tmp
                SET CODE_RETOUR=1,RETOUR='Matricule existe mais pas le nom et ou le prénom'
                WHERE EXISTS (SELECT 1 FROM ressource r WHERE UPPER(tmp.matricule)=r.matricule
                AND ((r.rnom <> UPPER(tmp.rnom) AND r.rnom <> TRANSLATE(UPPER(tmp.rnom),'-',' ') )
                    OR (r.rprenom <> UPPER(tmp.rprenom) AND r.rprenom <> TRANSLATE(UPPER(tmp.rprenom),'-',' ')))
                AND CODE_RETOUR is null);
                COMMIT;

                -- la ressource n'a pas de situation associée dans le fichier des situations
                UPDATE TMP_RESSOURCE tmp
                SET CODE_RETOUR=1,RETOUR='Ressource sans situation'
                WHERE NOT EXISTS (SELECT 1 FROM tmp_situation s WHERE UPPER(tmp.matricule)=UPPER(s.matricule))
                AND CODE_RETOUR is null;
                COMMIT;


                -- Nom Prénom et Matricule sont dans la Bip
                UPDATE TMP_RESSOURCE tmp
                SET CODE_RETOUR=0,RETOUR='Ressource existant dans la Bip'
                WHERE EXISTS (SELECT 1 FROM ressource r WHERE UPPER(tmp.matricule)=r.matricule
                      AND (r.rnom = UPPER(tmp.rnom) OR r.rnom = TRANSLATE(UPPER(tmp.rnom),'-',' ') )
                      AND (r.rprenom = UPPER(tmp.rprenom) OR r.rprenom = TRANSLATE(UPPER(tmp.rprenom),'-',' '))
                      AND CODE_RETOUR is null);
                COMMIT;

                -- Nom et Prénom connu, Matricule inconnu : homonyme
                UPDATE TMP_RESSOURCE tmp
                SET CODE_RETOUR=2,RETOUR='Homonyme'
                WHERE EXISTS (SELECT 1 FROM ressource r WHERE UPPER(tmp.matricule)<>r.matricule
                      AND (r.rnom = UPPER(tmp.rnom) OR r.rnom = TRANSLATE(UPPER(tmp.rnom),'-',' ') )
                      AND (r.rprenom = UPPER(tmp.rprenom) OR r.rprenom = TRANSLATE(UPPER(tmp.rprenom),'-',' '))
                      AND CODE_RETOUR is null);
                COMMIT;

                -- Nom/prenom inconnu, Matricule inconnu : nouvelle ressource à créer
                UPDATE TMP_RESSOURCE tmp
                SET CODE_RETOUR=2,RETOUR='Nouvelle ressource'
                WHERE NOT EXISTS (SELECT 1 FROM ressource r WHERE UPPER(tmp.matricule)=r.matricule)
                AND NOT EXISTS (SELECT 1 FROM ressource r WHERE
                        (r.rnom = UPPER(tmp.rnom) OR r.rnom = TRANSLATE(UPPER(tmp.rnom),'-',' ') )
                      AND (r.rprenom = UPPER(tmp.rprenom) OR r.rprenom = TRANSLATE(UPPER(tmp.rprenom),'-',' ')))
                AND CODE_RETOUR is null;
                COMMIT;





DECLARE
-- curseur qui parcourt la table temporaire TMP_RESSOURCE alimentée par eSourcing
CURSOR C_RESS IS SELECT ID_OALIA,MATRICULE,RNOM,RPRENOM,CODE_RETOUR
             FROM TMP_RESSOURCE
             ;

    BEGIN


    FOR ONE_RESS IN C_RESS LOOP

        BEGIN

             -- test format du matricule : 6 numériques
             SELECT TO_NUMBER(SUBSTR(ONE_RESS.matricule,2,6)) INTO L_MATRICULE
             FROM dual;
             EXCEPTION
        WHEN OTHERS THEN
            BEGIN
                UPDATE TMP_RESSOURCE SET CODE_RETOUR=1,RETOUR='Numériques après le X'
                     WHERE ONE_RESS.matricule = MATRICULE
                     AND ONE_RESS.ID_OALIA = ID_OALIA;
                     COMMIT;
                 END;
             END;
        END LOOP;

        FOR ONE_RESS IN C_RESS LOOP

            TRCLOG.TRCLOG( P_HFILE, 'Debut insertion des ressources: '||ONE_RESS.matricule||' ,id oalia: '||ONE_RESS.id_oalia);

        BEGIN

             IF ONE_RESS.CODE_RETOUR = 2 THEN
                 SELECT MAX(ident) INTO L_IDENT FROM RESSOURCE;
                 L_IDENT := L_IDENT +1;

                 INSERT INTO ressource (ident,rnom,rprenom,matricule,coutot,rtel,batiment,etage,
                 bureau,flaglock,rtype,icodimm)
                 VALUES (L_IDENT,
                 UPPER(ONE_RESS.rnom),
                 UPPER(ONE_RESS.rprenom),
                 UPPER(ONE_RESS.matricule),
                 NULL,
                 NULL,
                 NULL,
                 NULL,
                 NULL,
                 0,
                 'P',
                 '00000');
                 COMMIT;

                 UPDATE TMP_RESSOURCE SET IDENT=L_IDENT,CODE_RETOUR=0
                 WHERE ONE_RESS.matricule = MATRICULE
                 AND ONE_RESS.ID_OALIA = ID_OALIA
                 ;
                 COMMIT;

                 --YSB : Log création de la ressource
                 Pack_Ressource_F.maj_ressource_logs(L_IDENT,'Batch esourcing','ressource','ident',null,L_IDENT,'Création');
                 Pack_Ressource_F.maj_ressource_logs(L_IDENT,'Batch esourcing','ressource','rnom',null,UPPER(ONE_RESS.rnom),'Création');
                 Pack_Ressource_F.maj_ressource_logs(L_IDENT,'Batch esourcing','ressource','rprenom',null,UPPER(ONE_RESS.rprenom),'Création');
                 Pack_Ressource_F.maj_ressource_logs(L_IDENT,'Batch esourcing','ressource','matricule',null,UPPER(ONE_RESS.matricule),'Création');
                 Pack_Ressource_F.maj_ressource_logs(L_IDENT,'Batch esourcing','ressource','flaglock',null,'0','Création');
                 Pack_Ressource_F.maj_ressource_logs(L_IDENT,'Batch esourcing','ressource','rtype',null,'P','Création');
                 Pack_Ressource_F.maj_ressource_logs(L_IDENT,'Batch esourcing','ressource','icodimm',null,'00000','Création');

             ELSIF ONE_RESS.CODE_RETOUR=0 THEN

                 UPDATE TMP_RESSOURCE SET IDENT=(SELECT distinct r.ident FROM ressource r WHERE r.matricule=UPPER(ONE_RESS.matricule)),
                 CODE_RETOUR=0
                 WHERE ONE_RESS.matricule = MATRICULE
                 AND ONE_RESS.ID_OALIA = ID_OALIA
                 AND ONE_RESS.CODE_RETOUR = 0;
                 COMMIT;

             END IF;

             EXCEPTION
                WHEN referential_integrity THEN
                    L_ORA:=sqlerrm;

                    UPDATE tmp_ressource
                    SET retour=SUBSTR(L_ORA,1,49)
                    WHERE tmp_ressource.id_oalia=ONE_RESS.id_oalia;
                    COMMIT;

                    TRCLOG.TRCLOG( P_HFILE, 'Violation de contrainte pour id_oalia de la ressource : '||ONE_RESS.id_oalia);
                    TRCLOG.TRCLOG( P_HFILE, sqlerrm);

                WHEN others THEN

                    L_ORA:=sqlerrm;

                    UPDATE tmp_ressource
                    SET retour=SUBSTR(L_ORA,1,49)
                    WHERE tmp_ressource.id_oalia=ONE_RESS.id_oalia;
                    COMMIT;
                    TRCLOG.TRCLOG( P_HFILE, 'Erreur lors de l insertion de la ressource '||ONE_RESS.matricule);
                    TRCLOG.TRCLOG( P_HFILE, sqlerrm);

         END;
         END LOOP;
        END;

        -----------------------------------------------------
    -- Trace Stop
    -----------------------------------------------------
    TRCLOG.TRCLOG( P_HFILE, 'Fin normale de ' || L_PROCNAME  );

    EXCEPTION
        when others then

            ROLLBACK;

            if sqlcode <> CALLEE_FAILED_ID and sqlcode <> TRCLOG_FAILED_ID then
                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : ' || SQLERRM );
            end if;
            if sqlcode <> TRCLOG_FAILED_ID then
                TRCLOG.TRCLOG( P_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
--                TRCLOG.CLOSETRCLOG( P_HFILE );
                raise_application_error( CALLEE_FAILED_ID,
                                        'Erreur : consulter le fichier LOG',
                                         false );
            else
                raise;
            end if;

END alim_ressource;


--------------------------------------------------------------------------------------
-- PROCEDURE DE MAJ ET DE CREATION DES SITUATIONS
-- ASSOCIEES AUX RESSOURCES
--------------------------------------------------------------------------------------
PROCEDURE alim_situ (P_HFILE utl_file.file_type) IS

L_CREATION CHAR(3);
L_RETOUR tmp_ressource.retour%TYPE;
L_CODE_RETOUR tmp_ressource.code_retour%TYPE;
l_soccode societe.soccode%TYPE;
l_date_courante VARCHAR2(8);
l_date_fer VARCHAR2(8);
l_topfer struct_info.topfer%TYPE;
l_cpident ressource.ident%TYPE;
l_prestation prestation.prestation%TYPE;
l_top_actif prestation.top_actif%TYPE;
l_rtype prestation.RTYPE%TYPE;
l_presence number;
l_fermee VARCHAR2(8);

L_DATARR DATE;
L_DATDEP DATE;
L_DATEMIMOIS DATE;

--modif antoine
MOIS varchar2(6);
deb_periode date;
fin_periode date;
--/modif antoine

l_dat_fin_max VARCHAR2(8);
l_dat_dep_max VARCHAR2(8);
l_dat_deb_max VARCHAR2(8);
l_new number;
l_soccont varchar2(4);


referential_integrity EXCEPTION;
PRAGMA EXCEPTION_INIT(referential_integrity, -2291);


CURSOR C_SITU IS
    SELECT  s.id_oalia,
        UPPER(s.matricule) MATRICULE,
        s.datarr,
        s.datdep,
        s.dpg,
        UPPER(s.soccode) SOCCODE,
        s.coutht,
        UPPER(s.qualif) QUALIF,
        UPPER(s.code_prest) CODE_PREST,
        s.cpident,
        r.ident,
        s.siren,
        s.MODE_CONTRACTUEL_INDICATIF
    FROM tmp_situation s,tmp_ressource r
    WHERE UPPER(s.matricule)=UPPER(r.matricule)
    AND r.CODE_RETOUR='0'
    ORDER BY datarr,datdep
    ;

L_RETCOD    number;
L_PROCNAME  varchar2(256) := 'alim_situ';
L_STATEMENT varchar2(256);
ldatdep date;

BEGIN
    -----------------------------------------------------
    -- Trace Start
    -----------------------------------------------------
    TRCLOG.TRCLOG( P_HFILE, 'Debut de ' || L_PROCNAME );


    -- pas de ressource associée pour la situation
        UPDATE TMP_SITUATION tmp
        SET CODE_RETOUR=1,RETOUR='Situation sans ressource'
        WHERE NOT EXISTS (SELECT 1 FROM tmp_ressource r WHERE UPPER(tmp.matricule)=UPPER(r.matricule)
        AND CODE_RETOUR='0');
        COMMIT;

    TRCLOG.TRCLOG( P_HFILE, 'Debut du traitement d insertion des situations');

    FOR ONE_SITU IN C_SITU LOOP
    TRCLOG.TRCLOG( P_HFILE, 'Debut insertion de la situation de la ressource : '||ONE_SITU.ident||' ,id oalia: '||ONE_SITU.id_oalia);

    BEGIN
            L_CREATION:='OUI';

        -- test sur le code société

            SELECT TO_CHAR(SYSDATE,'yyyymmdd')
                  INTO l_date_courante
                  FROM DUAL;

                  l_date_fer := '00';


                    /* TD 588  : si le siren n'est pas présent on prends le soccode envoyé par resao
                       dans le cas contraire on retrouve le soccode dans la BIP via le siren de resao

                       Ce test est valable le temps que resao modifie leur traitement pour nous envoyé le siren
                       une fois qu'ils nous enverront le siren le test n'a plus lieu d'être il deviendra inutile etant donné
                       que le chargement du fichier via sqlloader généraera un .bad
                       */
                 IF (ONE_SITU.siren is null) THEN
                      BEGIN
                            SELECT TO_CHAR(socfer,'yyyymmdd')
                            INTO l_date_fer
                            FROM societe
                            WHERE soccode = ONE_SITU.soccode;

                            l_soccont := ONE_SITU.soccode;

                      EXCEPTION
                          WHEN NO_DATA_FOUND THEN
                               TRCLOG.TRCLOG(P_HFILE, 'la société : '||ONE_SITU.soccode||' n existe pas.');
                               L_CODE_RETOUR:='1';
                         L_RETOUR:='Code société inconnu';
                         L_CREATION:='NON';
                         
                           when others then

                                ROLLBACK;
                                    TRCLOG.TRCLOG( P_HFILE, 'Erreur cas 01 : ' || sqlerrm  );
                                    raise_application_error( CALLEE_FAILED_ID,'Erreur : consulter le fichier LOG',false );
                                                        
                        END;


                 ELSE
                      BEGIN
                        select distinct a.soccode, TO_CHAR(s.socfer,'yyyymmdd')  into l_soccont, l_date_fer
                        FROM AGENCE a, societe s
                        where siren = ONE_SITU.siren
                        and s.soccode = a.soccode;

                        EXCEPTION
                              WHEN NO_DATA_FOUND THEN
                               TRCLOG.TRCLOG(P_HFILE, 'la siren : '||ONE_SITU.siren||' n existe pas dans la BIP.');
                               L_CODE_RETOUR:='1';
                                 L_RETOUR:='Siren inexistant dans la BIP';
                            L_CREATION:='NON';
                              WHEN TOO_MANY_ROWS THEN
                                      SELECT TO_CHAR(socfer,'yyyymmdd')
                                    INTO l_date_fer
                                     FROM societe
                                    WHERE soccode = ONE_SITU.soccode;
                                  l_soccont := ONE_SITU.soccode;
                               when others then

                                ROLLBACK;
                                    TRCLOG.TRCLOG( P_HFILE, 'Erreur cas 02 : ' || sqlerrm  );
                                    raise_application_error( CALLEE_FAILED_ID,'Erreur : consulter le fichier LOG',false );
                                
                        END;


                 END IF;
                      /*FIN du TEST*/



                 IF l_date_fer <> '00' and l_date_fer <= l_date_courante THEN
                     L_CODE_RETOUR:='1';
                     L_RETOUR:='Code société fermé';
                     L_CREATION:='NON';
                 END IF;


         -- test sur le chef de projet : identifiant doit exister dans la BIP
             BEGIN
            SELECT ident
                 INTO l_cpident
                 FROM ressource
                 WHERE ident = ONE_SITU.cpident;
                     EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                               TRCLOG.TRCLOG( P_HFILE, 'l''identifiant chef de projet : '||ONE_SITU.cpident||' n existe pas.');
                               L_CODE_RETOUR:='1';
                         L_RETOUR:='Code chef de projet inconnu';
                         L_CREATION:='NON';
                         when others then

                                ROLLBACK;
                                    TRCLOG.TRCLOG( P_HFILE, 'Erreur cas 03 : ' || sqlerrm  );
                                    raise_application_error( CALLEE_FAILED_ID,'Erreur : consulter le fichier LOG',false );
             END;

        -- test d'existance du code prestation dans la BIP.
        BEGIN
        
            l_presence := 0;
               
          SELECT count(*) INTO l_presence
                 FROM prestation
                  WHERE RTRIM(prestation) = RTRIM(ONE_SITU.qualif); 
          EXCEPTION  
             when others then

                                ROLLBACK;
                                    TRCLOG.TRCLOG( P_HFILE, 'Erreur cas 04 : ' || sqlerrm  );
                                    raise_application_error( CALLEE_FAILED_ID,'Erreur : consulter le fichier LOG',false );
        
          END;
      
       IF ( l_presence = 0) then
         TRCLOG.TRCLOG( P_HFILE, 'Code prestation inconnu .');
                        L_RETOUR:='Code prestation inconnu .';
                        L_CODE_RETOUR:='1';
                        L_CREATION:='NON';
       ELSE
       
        BEGIN
          SELECT top_actif, rtype   INTO l_top_actif, l_rtype
                 FROM prestation
                   WHERE RTRIM(prestation) = RTRIM(ONE_SITU.qualif);
          EXCEPTION
          when others then

                                ROLLBACK;
                                    TRCLOG.TRCLOG( P_HFILE, 'Erreur cas 05 : ' || sqlerrm  );
                                    raise_application_error( CALLEE_FAILED_ID,'Erreur : consulter le fichier LOG',false );
        
        END;

    -- test du code prestation
            IF(upper(l_top_actif) = 'N') THEN
                
                TRCLOG.TRCLOG( P_HFILE, 'Code prestation inactif .');
                L_RETOUR:='Code prestation inactif .';
                L_CODE_RETOUR:='1';
                L_CREATION:='NON';
            ELSE
                IF((l_rtype <> 'P' and l_rtype <> '*')) THEN
                  TRCLOG.TRCLOG( P_HFILE, 'Code prestation interdit pour un prestataire au temps passé .');
                  L_CODE_RETOUR:='1';
                  L_RETOUR:='Code prestation interdit pour un prestataire au temps passé .';
                  L_CREATION:='NON';
                END IF;
            END IF;
        
         END IF;

-- cas d'erreur : la date de départ ou d'arrivée n'est pas renseignée
-- la date d'arrivée est supérieure à la date de départ
IF ONE_SITU.DATARR is null THEN
    L_CODE_RETOUR:='1';
    L_RETOUR:='Date d''arrivée non renseignée';
        L_CREATION:='NON';
ELSIF ONE_SITU.DATDEP is null THEN
    L_CODE_RETOUR:='1';
    L_RETOUR:='Date de départ non renseignée';
        L_CREATION:='NON';
ELSIF  ONE_SITU.DATARR>ONE_SITU.DATDEP THEN
    L_CODE_RETOUR:='1';
        L_RETOUR:='Date d''arrivée supérieure à la date de départ';
        L_CREATION:='NON';
ELSE
-- gestion des dates : dates de la situation à créer
    L_DATARR:=to_date('01'||to_char(ONE_SITU.DATARR,'mmyyyy'));
    L_DATDEP:=ONE_SITU.DATDEP;
END IF;

    -- test sur l'existence du DPG
        BEGIN
            SELECT topfer
                    INTO   l_topfer
                    FROM   struct_info
                    WHERE  to_number(codsg) = ONE_SITU.dpg;
                        EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                               TRCLOG.TRCLOG( P_HFILE, 'le dpg : '||ONE_SITU.dpg||' n existe pas.');
                               L_CODE_RETOUR:='1';
                         L_RETOUR:='Code DPG inconnu';
                         L_CREATION:='NON';
                     when others then

                                ROLLBACK;
                                    TRCLOG.TRCLOG( P_HFILE, 'Erreur cas 06 : ' || sqlerrm  );
                                    raise_application_error( CALLEE_FAILED_ID,'Erreur : consulter le fichier LOG',false );
             END;
                 IF l_topfer='F' THEN
                     L_CODE_RETOUR:='1';
                     L_RETOUR:='Code DPG fermé';
                     L_CREATION:='NON';
                 END IF;

-- test sur l'existence d'une situ dans la Bip pour la ressource
SELECT count(datsitu) INTO l_new FROM situ_ress where ident=ONE_SITU.IDENT;
-- pas de situation pour la ressource
IF l_new=0  AND L_CODE_RETOUR <> '1' AND L_CREATION!='NON' THEN
    L_CREATION := 'OUI';
    L_CODE_RETOUR := '0';
    --L_RETOUR := 'Nouvelle situation créée';
ELSIF  l_new<>0 THEN -- la ressource a déjà une situation

    -- cas d'une situation non fermée dans la BIP
        l_fermee := '0';
        BEGIN
            SELECT '1'
                 INTO l_fermee
                 FROM situ_ress
                  WHERE ident = ONE_SITU.ident
                  AND datsitu=(select max(datsitu)
                    from situ_ress
                    where ident=ONE_SITU.ident)
            AND datdep IS NOT NULL
             ;
                     EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                     TRCLOG.TRCLOG( P_HFILE, 'La situation antérieure de  : '||ONE_SITU.ident||' n est pas fermee.');
                     L_CODE_RETOUR:='1';
                     L_CREATION:='NON';
                     when others then

                                ROLLBACK;
                                    TRCLOG.TRCLOG( P_HFILE, 'Erreur cas 07 : ' || sqlerrm  );
                                    raise_application_error( CALLEE_FAILED_ID,'Erreur : consulter le fichier LOG',false );
             END;
             IF l_fermee<>'1' THEN
                 L_CODE_RETOUR:='1';
                 L_RETOUR:='Situation antérieure non fermée';
                 L_CREATION:='NON';
             END IF;



BEGIN
   select max(to_char(datdep,'yyyymm')) mois,max(datsitu) deb_periode,max(datdep) fin_periode
   into mois, deb_periode, fin_periode
   from situ_ress
   where ident=to_number(ONE_SITU.IDENT);
END;

-- cas 9
-- situation antérieur à la situation existante
IF ((ONE_SITU.DATARR<deb_periode) AND (ONE_SITU.DATDEP<deb_periode) AND (L_CREATION!='NON'))
THEN
    L_CODE_RETOUR:='1';
    L_RETOUR:='Creation impossible situ postérieure existante';
    L_CREATION:='NON';
-- cas 8
-- situation dejà existante
ELSIF ((ONE_SITU.DATARR=deb_periode) AND (L_CREATION!='NON'))
THEN
    L_CODE_RETOUR:='1';
    L_RETOUR:='situation dejà existante';
    L_CREATION:='NON';
-- cas 4
-- nouvelle situation incluse dans la situation existante
ELSIF ((ONE_SITU.DATARR > deb_periode) AND (ONE_SITU.DATDEP < fin_periode) AND (L_CREATION!='NON'))
THEN
    L_CODE_RETOUR:='1';
    L_RETOUR:='situation incluse dans la situation actuelle';
    L_CREATION:='NON';

    -- cas 5 et 6
    ELSIF ((mois=to_char(ONE_SITU.DATARR,'yyyymm')) AND (mois=to_char(ONE_SITU.DATDEP,'yyyymm')) AND (mois=to_char(deb_periode,'yyyymm')) AND (L_CREATION!='NON'))
        THEN
         BEGIN

            begin
              select datdep into ldatdep
                from situ_ress
                where to_char(datdep,'yyyymm')= mois
                and ident=to_number(ONE_SITU.IDENT);
            EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                     null;
                     when others then

                                ROLLBACK;
                                    TRCLOG.TRCLOG( P_HFILE, 'Erreur cas 08 : ' || sqlerrm  );
                                    raise_application_error( CALLEE_FAILED_ID,'Erreur : consulter le fichier LOG',false );
             END;

            UPDATE situ_ress SET datdep=ONE_SITU.DATDEP
            where to_char(datdep,'yyyymm')= mois
            and ident=to_number(ONE_SITU.IDENT);

            -- YSB : log mise à jour situ_ress
            Pack_Ressource_F.maj_ressource_logs(ONE_SITU.ident,'Batch esourcing','situ_ress','datdep',ldatdep,ONE_SITU.DATDEP,'Modification de la datdep');
        END;

        L_CREATION := 'NON';
        L_RETOUR := 'Situation créée';
        L_CODE_RETOUR := '0';


    -- cas 1 et 2
    ELSIF ((mois=to_char(ONE_SITU.DATARR,'yyyymm')) AND (to_char(deb_periode,'yyyymm')=to_char(ONE_SITU.DATARR,'yyyymm')) AND (L_CREATION!='NON'))
        THEN

            L_DATARR :=round(last_day(ONE_SITU.DATARR),'MONTH');
            L_CREATION := 'OUI';
            BEGIN
                begin
                  select datdep into ldatdep
                    from situ_ress
                    where to_char(datdep,'yyyymm')=mois
                    and ident=to_number(ONE_SITU.IDENT);
                EXCEPTION
                         WHEN NO_DATA_FOUND THEN
                         null;
                         when others then

                                ROLLBACK;
                                    TRCLOG.TRCLOG( P_HFILE, 'Erreur cas 09 : ' || sqlerrm  );
                                    raise_application_error( CALLEE_FAILED_ID,'Erreur : consulter le fichier LOG',false );
                 END;

                UPDATE situ_ress SET datdep=(L_DATARR-1)
                where to_char(datdep,'yyyymm')=mois
                and ident=to_number(ONE_SITU.IDENT);
            END;
            -- YSB : log mise à jour situ_ress
            Pack_Ressource_F.maj_ressource_logs(ONE_SITU.ident,'Batch esourcing','situ_ress','datdep',ldatdep,L_DATARR-1,'Modification de la datdep');
        -- cas 7
         ELSIF  (mois=to_char(ONE_SITU.DATARR,'yyyymm') AND L_CREATION!='NON')
            THEN
            L_DATARR :=round(ONE_SITU.DATARR,'MONTH');
            L_CREATION := 'OUI';
            BEGIN
                 begin
                  select datdep into ldatdep
                    from situ_ress
                     where to_char(datdep,'yyyymm')=mois
                and ident=to_number(ONE_SITU.IDENT);
                EXCEPTION
                         WHEN NO_DATA_FOUND THEN
                         null;
                         when others then

                                ROLLBACK;
                                    TRCLOG.TRCLOG( P_HFILE, 'Erreur cas 10 : ' || sqlerrm  );
                                    raise_application_error( CALLEE_FAILED_ID,'Erreur : consulter le fichier LOG',false );
                 END;

                UPDATE situ_ress SET datdep=(L_DATARR-1)
                where to_char(datdep,'yyyymm')=mois
                and ident=to_number(ONE_SITU.IDENT);
            END;
            -- YSB : log mise à jour situ_ress
            Pack_Ressource_F.maj_ressource_logs(ONE_SITU.ident,'Batch esourcing','situ_ress','datdep',ldatdep,L_DATARR-1,'Modification de la datdep');
        --cas 3
              ELSIF (ONE_SITU.DATDEP > deb_periode AND ONE_SITU.DATARR < fin_periode AND L_CREATION!='NON') 
                 THEN

                    L_CREATION := 'NON';
                    L_RETOUR := 'Recouvrement supérieur à 1 mois';
                    L_CODE_RETOUR := '1';



END IF;


END IF;

    -- insertion de la nouvelle situation.
    IF L_CREATION='OUI' THEN
        TRCLOG.TRCLOG( P_HFILE, 'IDENT INSERE: ' || ONE_SITU.ident  );
        TRCLOG.TRCLOG( P_HFILE, 'L_DATARR    : ' || L_DATARR        );
        INSERT INTO situ_ress(ident,datsitu,datdep,cpident,codsg,soccode,cout,rmcomp,prestation,dispo,MODE_CONTRACTUEL_INDICATIF)
        VALUES
        (ONE_SITU.ident,
        L_DATARR,
        L_DATDEP,
        ONE_SITU.cpident,
        ONE_SITU.dpg,
        l_soccont,
        ONE_SITU.coutht,
        0,
        ONE_SITU.qualif,
        5,
        ONE_SITU.MODE_CONTRACTUEL_INDICATIF);


        -- YSB : Log création d'une nouvelle situation
        Pack_Ressource_F.maj_ressource_logs(ONE_SITU.ident,'Batch esourcing','situ_ress','ident',null,ONE_SITU.ident,'Création');
        Pack_Ressource_F.maj_ressource_logs(ONE_SITU.ident,'Batch esourcing','situ_ress','datsitu',null,L_DATARR,'Création');
        Pack_Ressource_F.maj_ressource_logs(ONE_SITU.ident,'Batch esourcing','situ_ress','datdep',null,L_DATDEP,'Création');
        Pack_Ressource_F.maj_ressource_logs(ONE_SITU.ident,'Batch esourcing','situ_ress','cpident',null,ONE_SITU.cpident,'Création');
        Pack_Ressource_F.maj_ressource_logs(ONE_SITU.ident,'Batch esourcing','situ_ress','codsg',null,ONE_SITU.dpg,'Création');
        Pack_Ressource_F.maj_ressource_logs(ONE_SITU.ident,'Batch esourcing','situ_ress','soccode',null,l_soccont,'Création');
        Pack_Ressource_F.maj_ressource_logs(ONE_SITU.ident,'Batch esourcing','situ_ress','cout',null,ONE_SITU.coutht,'Création');
        Pack_Ressource_F.maj_ressource_logs(ONE_SITU.ident,'Batch esourcing','situ_ress','rmcomp',null,'0','Création');
        Pack_Ressource_F.maj_ressource_logs(ONE_SITU.ident,'Batch esourcing','situ_ress','prestation',null,ONE_SITU.qualif,'Création');
        Pack_Ressource_F.maj_ressource_logs(ONE_SITU.ident,'Batch esourcing','situ_ress','dispo',null,'5','Création');
        Pack_Ressource_F.maj_ressource_logs(ONE_SITU.ident,'Batch esourcing','situ_ress','mode_contractuel_indicatif',null,ONE_SITU.MODE_CONTRACTUEL_INDICATIF,'Création');

        UPDATE tmp_situation
        SET retour='Situation créée',code_retour='0'
        WHERE tmp_situation.id_oalia=ONE_SITU.id_oalia
        AND UPPER(tmp_situation.matricule)=ONE_SITU.matricule;
        COMMIT;
    ELSIF L_CREATION = 'NON' THEN
        UPDATE tmp_situation
        SET retour=L_RETOUR,code_retour=L_CODE_RETOUR
        WHERE tmp_situation.id_oalia=ONE_SITU.id_oalia;
        COMMIT;
    END IF;



END;
END LOOP;
    -----------------------------------------------------
    -- Trace Stop
    -----------------------------------------------------
    TRCLOG.TRCLOG( P_HFILE, 'Fin normale de ' || L_PROCNAME  );

    EXCEPTION
        when others then

            ROLLBACK;

            if sqlcode <> CALLEE_FAILED_ID and sqlcode <> TRCLOG_FAILED_ID then
                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : ' || SQLERRM );
            end if;
            if sqlcode <> TRCLOG_FAILED_ID then
                TRCLOG.TRCLOG( P_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
--                TRCLOG.CLOSETRCLOG( P_HFILE );
                raise_application_error( CALLEE_FAILED_ID,
                                        'Erreur : consulter le fichier LOG',
                                         false );
            else
                raise;
            end if;
END alim_situ;

------------------------------------------------------------
-- Cette procedure archive les données concernant
-- les ressources (conservées 2 mois)
------------------------------------------------------------
PROCEDURE archive_esourcing (P_HFILE utl_file.file_type) IS

L_DATE_COURANTE DATE;

referential_integrity EXCEPTION;
PRAGMA EXCEPTION_INIT(referential_integrity, -2291);


-- On parcourt la table temporaire de création des ressources
    CURSOR C_RESS IS
    SELECT  UPPER(NVL(r.matricule,'vide')) MATRICULE,
        NVL(r.id_oalia,'vide') ID_OALIA,
        UPPER(r.rnom) RNOM,
        UPPER(r.rprenom) RPRENOM,
        r.ident,
        r.code_retour,
        r.retour
    FROM tmp_ressource r
    --WHERE code_retour = '1'
    ORDER BY ident
    ;

-- On parcourt la table temporaire de création des situations
    CURSOR C_SITU IS
    SELECT  UPPER(NVL(s.matricule,'vide')) MATRICULE,
          NVL(s.id_oalia,'vide') ID_OALIA,
          s.datarr,
        s.datdep,
          s.dpg,
          UPPER(s.soccode) SOCCODE,
          s.coutht,
          UPPER(s.qualif) QUALIF,
          s.cpident,
          r.ident,
          UPPER(r.rnom) RNOM,
          UPPER(r.rprenom) RPRENOM,
          s.code_retour,
          s.retour,
          s.mode_contractuel_indicatif
     FROM tmp_ressource r,tmp_situation s
     WHERE UPPER(r.matricule(+))=UPPER(s.matricule)
     AND  r.retour(+) <> 'Matricule en doublon'
     ORDER BY r.ident
    ;

-- Cas particulier : matricule en doublon
    CURSOR C_DOUBLON IS
     SELECT DISTINCT UPPER(NVL(s.matricule,'vide')) MATRICULE,
       NVL(s.id_oalia,'vide') ID_OALIA,
       s.datarr,
       s.datdep,
       s.dpg,
       UPPER(s.soccode) SOCCODE,
       s.coutht,
       UPPER(s.qualif) QUALIF,
       s.cpident,
       s.code_retour,
       s.retour,
       s.mode_contractuel_indicatif
      FROM tmp_ressource r,tmp_situation s
     WHERE UPPER(r.matricule)=UPPER(s.matricule)
     and r.retour='Matricule en doublon'
     ;

BEGIN
    BEGIN
        SELECT to_date(to_char(sysdate,'dd/mm/yyyy'),'dd/mm/yyyy') into L_DATE_COURANTE FROM dual;

        DELETE FROM ESOURCING
        WHERE date_trait < ADD_MONTHS(L_DATE_COURANTE,-2)
        ;
        COMMIT;
    END;
    TRCLOG.TRCLOG( P_HFILE, 'Debut du traitement d archivage des ressources');

    FOR ONE_RESS IN C_RESS LOOP
    TRCLOG.TRCLOG( P_HFILE, 'Debut archivage de la ressource : '||ONE_RESS.ident);

    BEGIN
            INSERT INTO ESOURCING (date_trait,id_oalia,matricule,rnom,rprenom,ident,code_retour,retour)
            VALUES
            (L_DATE_COURANTE,
            ONE_RESS.id_oalia,
            ONE_RESS.matricule,
            ONE_RESS.rnom,
            ONE_RESS.rprenom,
            ONE_RESS.ident,
            ONE_RESS.code_retour,
            ONE_RESS.retour
            );
            COMMIT;
        END;
      END LOOP;

    TRCLOG.TRCLOG( P_HFILE, 'Debut du traitement d archivage des situations');

    FOR ONE_SITU IN C_SITU LOOP
    TRCLOG.TRCLOG( P_HFILE, 'Debut archivage de la situation de la ressource : '||ONE_SITU.ident);

    BEGIN
            INSERT INTO ESOURCING (date_trait,id_oalia,matricule,datarr,datdep,dpg,soccode,coutht,qualif,
            cpident,ident,rnom,rprenom,code_retour,retour,mode_contractuel_indicatif)
            VALUES
            (L_DATE_COURANTE,
            ONE_SITU.id_oalia,
            ONE_SITU.matricule,
            ONE_SITU.datarr,
            ONE_SITU.datdep,
            ONE_SITU.dpg,
            ONE_SITU.soccode,
            ONE_SITU.coutht,
            ONE_SITU.qualif,
            ONE_SITU.cpident,
            ONE_SITU.ident,
            ONE_SITU.rnom,
            ONE_SITU.rprenom,
            ONE_SITU.code_retour,
            ONE_SITU.retour,
            ONE_SITU.mode_contractuel_indicatif
            );
            COMMIT;
        END;
      END LOOP;


      FOR ONE_DOUBLON IN C_DOUBLON LOOP
    TRCLOG.TRCLOG( P_HFILE, 'Debut archivage cas des doublons de matricule '||ONE_DOUBLON.id_oalia);

    BEGIN
            INSERT INTO ESOURCING (date_trait,id_oalia,matricule,datarr,datdep,dpg,soccode,coutht,qualif,
            cpident,code_retour,retour,mode_contractuel_indicatif)
            VALUES
            (L_DATE_COURANTE,
            ONE_DOUBLON.id_oalia,
            ONE_DOUBLON.matricule,
            ONE_DOUBLON.datarr,
            ONE_DOUBLON.datdep,
            ONE_DOUBLON.dpg,
            ONE_DOUBLON.soccode,
            ONE_DOUBLON.coutht,
            ONE_DOUBLON.qualif,
            ONE_DOUBLON.cpident,
            ONE_DOUBLON.code_retour,
            ONE_DOUBLON.retour,
            ONE_DOUBLON.mode_contractuel_indicatif
            );
            COMMIT;
        END;

      END LOOP;

    TRCLOG.TRCLOG( P_HFILE, 'Fin du traitement d archivage des situations et ressources');

    -- suppression des donnees des tables temporaires
    /*TRCLOG.TRCLOG( P_HFILE, 'Debut de la suppression des donnees des tables temporaires');
    BEGIN
        DELETE FROM TMP_RESSOURCE;
        DELETE FROM TMP_SITUATION;
        COMMIT;
    TRCLOG.TRCLOG( P_HFILE, 'Fin de la suppression des donnees des tables temporaires');
    END;*/

END archive_esourcing;

------------------------------------------------------------
-- Cette procedure verifie que l on a pas cree de ressource
-- sans situation
------------------------------------------------------------
PROCEDURE verif_ress (P_HFILE utl_file.file_type) IS

L_DATE_COURANTE DATE;

referential_integrity EXCEPTION;
PRAGMA EXCEPTION_INIT(referential_integrity, -2291);


L_RETCOD    number;
L_PROCNAME  varchar2(256) := 'verif_ress';
L_STATEMENT varchar2(256);

BEGIN
    -----------------------------------------------------
    -- Trace Start
    -----------------------------------------------------
    TRCLOG.TRCLOG( P_HFILE, 'Debut de ' || L_PROCNAME );
    TRCLOG.TRCLOG( P_HFILE, 'Debut du traitement de suppression des ressources');



    -- suppression des ressources crees sans situ
        DELETE FROM ressource ress
        WHERE ress.ident IN (select distinct r.ident from tmp_ressource r,tmp_situation s
                 where r.code_retour=0
                 and s.code_retour <>0)
                 and ress.ident not in (select distinct sr.ident from situ_ress sr
                where ress.ident=sr.ident)
                 ;

        -- suppression des logs des ressources crees sans situ
        DELETE FROM ressource_logs ress
        WHERE ress.ident IN (select distinct r.ident from tmp_ressource r,tmp_situation s
                 where r.code_retour=0
                 and s.code_retour <>0)
                 and ress.ident not in (select distinct sr.ident from situ_ress sr
                where ress.ident=sr.ident)
                 ;

        UPDATE tmp_ressource tmp
               set CODE_RETOUR=1,
                   RETOUR='Ressource sans situation'
             WHERE tmp.ident in (select distinct r.ident from tmp_ressource r,tmp_situation s
                 where r.code_retour=0
                 and s.code_retour <>0)
                 and tmp.ident not in (select distinct sr.ident from situ_ress sr
                where tmp.ident=sr.ident)
              ;
        COMMIT;




    -----------------------------------------------------
    -- Trace Stop
    -----------------------------------------------------
    TRCLOG.TRCLOG( P_HFILE, 'Fin normale de ' || L_PROCNAME  );

    EXCEPTION
        when others then

            ROLLBACK;

            if sqlcode <> CALLEE_FAILED_ID and sqlcode <> TRCLOG_FAILED_ID then
                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : ' || SQLERRM );
            end if;
            if sqlcode <> TRCLOG_FAILED_ID then
                TRCLOG.TRCLOG( P_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
--                TRCLOG.CLOSETRCLOG( P_HFILE );
                raise_application_error( CALLEE_FAILED_ID,
                                        'Erreur : consulter le fichier LOG',
                                         false );
            else
                raise;
            end if;
END verif_ress;


PROCEDURE global_ressource (P_LOGDIR VARCHAR2) IS

        P_HFILE utl_file.file_type;
        L_RETCOD number;
        L_PROCNAME varchar2(30):='GLOBAL_RESSOURCE';

    BEGIN
        -- Init de la trace
        -- ----------------
        L_RETCOD := TRCLOG.INITTRCLOG( P_LOGDIR , L_PROCNAME, P_HFILE );
        if ( L_RETCOD <> 0 ) then
        raise_application_error( TRCLOG_FAILED_ID,
                                 'Erreur : Gestion du fichier LOG impossible',
                                 false );
        end if;

        -- Trace Start
        -- -----------
        TRCLOG.TRCLOG( P_HFILE, 'Debut de ' || L_PROCNAME );

        -- lancement des procédures

        pack_esourcing.alim_ressource (P_HFILE) ;

        pack_esourcing.alim_situ (P_HFILE);

        pack_esourcing.verif_ress(P_HFILE);

        pack_esourcing.archive_esourcing(P_HFILE);


        -- Trace Stop
        -- ----------
        TRCLOG.TRCLOG( P_HFILE, 'Fin normale de ' || L_PROCNAME  );
        TRCLOG.CLOSETRCLOG( P_HFILE );

    exception

        when others then
            rollback;
            if sqlcode <> CALLEE_FAILED_ID and
               sqlcode <> TRCLOG_FAILED_ID then
                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : ' || SQLERRM );
            end if;
            if sqlcode <> TRCLOG_FAILED_ID then
                TRCLOG.TRCLOG( P_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
                TRCLOG.CLOSETRCLOG( P_HFILE );
                raise_application_error( CALLEE_FAILED_ID,
                                        'Erreur : consulter le fichier LOG',
                                         false );
            else
                raise;
            end if;

    END;


PROCEDURE global_contrat (P_LOGDIR VARCHAR2) IS

        P_HFILE utl_file.file_type;
        L_RETCOD number;
        L_PROCNAME varchar2(30):='GLOBAL_CONTRAT';

    BEGIN
        -- Init de la trace
        -- ----------------
        L_RETCOD := TRCLOG.INITTRCLOG( P_LOGDIR , L_PROCNAME, P_HFILE );
        if ( L_RETCOD <> 0 ) then
        raise_application_error( TRCLOG_FAILED_ID,
                                 'Erreur : Gestion du fichier LOG impossible',
                                 false );
        end if;

        -- Trace Start
        -- -----------
        TRCLOG.TRCLOG( P_HFILE, 'Debut de ' || L_PROCNAME );

        -- lancement des procédures

        pack_esourcing.create_contrat(P_HFILE);

        pack_esourcing.create_ligne_cont(P_HFILE);

        pack_esourcing.historise_contrat(P_HFILE);

        -- Trace Stop
        -- ----------
        TRCLOG.TRCLOG( P_HFILE, 'Fin normale de ' || L_PROCNAME  );
        TRCLOG.CLOSETRCLOG( P_HFILE );

    exception

        when others then
            rollback;
            if sqlcode <> CALLEE_FAILED_ID and
               sqlcode <> TRCLOG_FAILED_ID then
                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : ' || SQLERRM );
            end if;
            if sqlcode <> TRCLOG_FAILED_ID then
                TRCLOG.TRCLOG( P_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
                TRCLOG.CLOSETRCLOG( P_HFILE );
                raise_application_error( CALLEE_FAILED_ID,
                                        'Erreur : consulter le fichier LOG',
                                         false );
            else
                raise;
            end if;

    END;

PROCEDURE export_agences(
                            p_chemin_fichier    IN VARCHAR2,
                            p_nom_fichier        IN VARCHAR2
                      ) IS


            CURSOR csr_export IS

            select a.socfour socfour,
                   a.socflib socflib,
                   a.soccode soccode,
                   a.siren   siren
            from agence a, societe s
            where a.soccode = s.soccode
            and (
                    s.SOCFER > add_months(sysdate,6)
                    or s.socfer is null
                )
            and a.siren is not null;





        l_msg  VARCHAR2(1024);
        l_hfile UTL_FILE.FILE_TYPE;



    BEGIN




        Pack_Global.INIT_WRITE_FILE( p_chemin_fichier, p_nom_fichier, l_hfile);


        FOR rec_export IN csr_export LOOP


            Pack_Global.WRITE_STRING( l_hfile,
                rec_export.socfour               || ';' ||
                rec_export.socflib             || ';' ||
                rec_export.soccode         || ';' ||
                rec_export.siren
                );

        END LOOP;


        Pack_Global.CLOSE_WRITE_FILE(l_hfile);
    EXCEPTION
           WHEN OTHERS THEN
            Pack_Global.recuperer_message(20401, NULL, NULL, NULL, l_msg);
            RAISE_APPLICATION_ERROR(-20401, l_msg);

END export_agences;

END pack_esourcing;
/








