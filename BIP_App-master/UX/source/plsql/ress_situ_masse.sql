/*
	ress_situ_masse.sql: fichier contenant le package pack_ress_situ_masse permettant
	l'insertion en masse de ressources et situation

	créé le 18/06/2009 par ABA
	
Modifié le 03/07/2009 : ABA TD 818 correction anoamlie en fonction des différents jeux de tests
Modifié le 06/10/2009 : ABA TD 855 gestion d'un autre cas de recouvrement sur plusieurs mois
Modifié le 30/10/2009 : ABA TD 855 modification d'un message d'erreur concernant le matricule dejà existant, affichage en plus du nom et prenom de l'existant
Modifié le 02/11/2010 : ABA TD 970 prise en compte du MCI et du type * pour les codes prestation
*/
CREATE OR REPLACE PACKAGE       "PACK_RESS_SITU_MASSE" IS


PROCEDURE test_ressource ( p_chemin_fichier    IN VARCHAR2,
                              p_nom_fichier        IN VARCHAR2);


PROCEDURE insert_ressource;


END pack_ress_situ_masse;
/


CREATE OR REPLACE PACKAGE BODY "PACK_RESS_SITU_MASSE" IS


PROCEDURE test_ressource ( p_chemin_fichier    IN VARCHAR2,
                           p_nom_fichier        IN VARCHAR2) IS

L_MATRICULE ressource.matricule%TYPE;
L_TEST NUMBER;
L_CODE_RETOUR tmp_ress_masse.code_retour%TYPE;
L_ORA VARCHAR2(200);
L_RETOUR tmp_ress_masse.retour%TYPE;
referential_integrity EXCEPTION;
PRAGMA EXCEPTION_INIT(referential_integrity, -2291);

L_RETCOD    number;
L_PROCNAME  varchar2(256) := 'alim_ressource';
L_STATEMENT varchar2(256);

l_temp number;
l_ident tmp_ress_masse.retour%TYPE;

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
l_date_valid number;


l_caract_speciaux VARCHAR2(70);
l_caract_tmp VARCHAR2(70);

 tmp_rnom VARCHAR2(50);
 tmp_rprenom VARCHAR2(50);

 l_hfile UTL_FILE.FILE_TYPE;

CURSOR curseur IS
    SELECT
    ID_LIGNE,
    RPRENOM,
    RNOM,
    lpad(MATRICULE,7,0) matricule,
    DATARR,
    DATDEP,
    DPG,
    SOCCODE,
    COUTHT,
    QUALIF,
    DISPONIBILITE,
    CPIDENT
        FROM tmp_ress_masse ;

        CURSOR retour IS
    SELECT
    ID_LIGNE,
    ident,
    RPRENOM,
    RNOM,
    MATRICULE,
    DATARR,
    DATDEP,
    DPG,
    SOCCODE,
    COUTHT,
    QUALIF,
    DISPONIBILITE,
    CPIDENT,
    RETOUR
    FROM tmp_ress_masse
    where code_retour = 1;

BEGIN

    l_caract_speciaux := 'àâäçéèêëîïôöùûüÂÄÊËÈ$";*&(@)!:?§/<>+.~#{[|`\\_^]}=°¿£µ¿\''';

  FOR une_ligne IN curseur LOOP
        -- test format du matricule : commence par X
        begin

                l_retour:= '';
                l_date_valid :=0;

                /* Test présence champs*/
                if (une_ligne.rprenom is null) then
                    l_retour := l_retour || 'Prénom manquant; ';
                elsif (length(une_ligne.rprenom) > 15) then
                    l_retour := l_retour || 'Le prénom doit être sur 15 caractères maximum; ';
                    for i in 1..length(l_caract_speciaux) loop
                        l_caract_tmp := substr(l_caract_speciaux,i,1);
                        if (instr(une_ligne.rprenom,l_caract_tmp) != 0) then
                            l_retour := l_retour || 'Caractères spéciaux non autorisé dans le prénom; ';
                        end if;
                     end loop;



                end if;
                if (une_ligne.rnom is null) then
                    l_retour := l_retour || 'Nom manquant; ';
                elsif  (length(une_ligne.rnom) > 30) then
                l_retour := l_retour || 'Le nom doit être sur 30 caractères maximum; ';
                 for i in 1..length(l_caract_speciaux) loop
                        l_caract_tmp := substr(l_caract_speciaux,i,1);
                        if (instr(une_ligne.rnom,l_caract_tmp) != 0) then
                            l_retour := l_retour || 'Caractères spéciaux non autorisé dans le prénom; ';
                        end if;
                     end loop;
                end if;
                if (une_ligne.matricule is null) then
                    l_retour := l_retour || 'Matricule manquant; ';
                elsif (length(une_ligne.matricule)>7)then
                    l_retour := l_retour || 'Le matricule doit etre sur 7 caractères alphanum. maximum; ';
                end if;
                if (une_ligne.datarr is null) then
                   l_retour := l_retour || 'Date arrivée manquante; ';

                else
                begin
                    select count(to_date(datarr)) into l_temp from tmp_ress_masse
                    where id_ligne= une_ligne.id_ligne;
                    exception
                    when others then
                        l_retour := l_retour || 'Mauvais format de date d''arrivé (DD/MM/YYYY); ';
                        l_date_valid := 1;

                end;
                end if;

                if (une_ligne.datarr is not null) then
                    begin
                    select count(to_date(datdep)) into l_temp from tmp_ress_masse
                    where id_ligne= une_ligne.id_ligne;
                    exception
                    when others then
                        l_retour := l_retour || 'Mauvais format de date de depart (DD/MM/YYYY); ';
                        l_date_valid :=1;

                end;

                end if;

                if (une_ligne.dpg is null) then
                    l_retour := l_retour || 'DPG manquant; ';
                else
                begin
                select count(to_number(dpg)) into l_temp from tmp_ress_masse
                    where id_ligne= une_ligne.id_ligne;
                    exception
                    when others then
                        l_retour := l_retour || 'Le dpg doit être numérique; ';
                        end;
                if (length(une_ligne.dpg) > 7 )then
                l_retour := l_retour || 'Le dpg doit être sur 7 caractères numériques maxi; ';
                end if;


                end if;
                if (une_ligne.soccode is null) then
                    l_retour := l_retour || 'Société manquante; ';
                elsif (length(une_ligne.soccode) <> 4 ) then
                     l_retour := l_retour || 'Le code société doit être sur 4 caractères; ';

                end if;
                if (une_ligne.coutHT is null and (une_ligne.soccode != 'SG..' or une_ligne.soccode is null)) then
                    l_retour := l_retour || 'Cout manquant; ';
                else
                begin
                 select count(to_number(coutht)) into l_temp from tmp_ress_masse
                    where id_ligne= une_ligne.id_ligne;
                    exception
                    when others then
                        l_retour := l_retour || 'Le cout doit être numérique avec des virgules pour la partie decimale; ';
                end;
                end if;
                if (une_ligne.qualif is null) then
                    l_retour := l_retour || 'Qualification manquante; ';
                elsif (length(une_ligne.qualif) > 3 ) then
                  l_retour := l_retour || 'Qualification doit être sur 3 caractères maxi; ';
                end if;
                if (une_ligne.cpident is null) then
                    l_retour := l_retour || 'Code chef de projet manquant; ';
                else
                begin
                   select count(to_number(cpident)) into l_temp from tmp_ress_masse
                    where id_ligne= une_ligne.id_ligne;
                    exception
                    when others then
                        l_retour := l_retour || 'Ident chef de projet doit être numérique; ';
                end;
                end if;

                /* Test si le matricule commence par X ou Y pour les P2I*/
                if ((UPPER(SUBSTR(une_ligne.matricule,0,1)) <> 'X' and UPPER(SUBSTR(une_ligne.matricule,0,1)) <> 'Y')  and une_ligne.soccode != 'SG..')  then
                     l_retour := l_retour || 'Matricule doit commencer par X ou Y pour les P2I; ';
                end if;

                /* Vérifie que les caractères suivant le X ou Y soient bien numérique*/
                if   (length(translate(trim(substr(une_ligne.matricule,2,6)),'.0123456789','.')) = 1 and une_ligne.soccode != 'SG..' ) then
                     l_retour :=  l_retour || 'Matricule doit etre numérique après le X ou Y ';
                end if;

                /* Test si le matricule est conforme aux internes SG  : 7 caractères numériques*/
                if (nvl(length(translate(trim(une_ligne.matricule),'.0123456789','.')),0) != 0 and une_ligne.soccode = 'SG..' ) then
                l_retour :=  l_retour || 'Matricule doit etre numérique pour les SG; ';
                end if;

                /*Verifie s'il y as des doublons dans la table de chargement */
               select count (*) into l_temp from tmp_ress_masse
               WHERE une_ligne.matricule in
                (select matricule
                from TMP_RESS_MASSE
                group by matricule
                having count(*) > 1);

                if (l_temp > 1 ) then
                    l_retour := l_retour || 'Matricule en doublon; ';
                end if;


            if (une_ligne.disponibilite < 1 or une_ligne.disponibilite > 5 ) then
              l_retour := l_retour || 'La disponibilité doit être comprise entre 1 et 5; ';
            end if;


                /* Détermine si le matricule est dejà utilisé dans la table ressource*/
                select count(*) into l_temp FROM ressource r WHERE UPPER(une_ligne.matricule)=r.matricule
                AND ((r.rnom <> UPPER(une_ligne.rnom) AND r.rnom <> TRANSLATE(UPPER(une_ligne.rnom),'-',' ') )
                    OR (r.rprenom <> UPPER(une_ligne.rprenom) AND r.rprenom <> TRANSLATE(UPPER(une_ligne.rprenom),'-',' ')));




                if (l_temp <> 0 ) then

                 select r.rnom, r.rprenom into tmp_rnom, tmp_rprenom FROM ressource r WHERE UPPER(une_ligne.matricule)=r.matricule
                AND ((r.rnom <> UPPER(une_ligne.rnom) AND r.rnom <> TRANSLATE(UPPER(une_ligne.rnom),'-',' ') )
                    OR (r.rprenom <> UPPER(une_ligne.rprenom) AND r.rprenom <> TRANSLATE(UPPER(une_ligne.rprenom),'-',' ')));


                    l_retour := l_retour ||  'Matricule existe mais pas le nom et ou le prénom "'|| tmp_rnom || '" "' || tmp_rprenom || '";';
                end if;


                /* Détermine si la ressource est déjà existante dans la BIP*/
                 select count(*) into l_temp FROM ressource r WHERE UPPER(une_ligne.matricule)=r.matricule
                      AND (r.rnom = UPPER(une_ligne.rnom) OR r.rnom = TRANSLATE(UPPER(une_ligne.rnom),'-',' ') )
                      AND (r.rprenom = UPPER(une_ligne.rprenom) OR r.rprenom = TRANSLATE(UPPER(une_ligne.rprenom),'-',' '));



                  if (l_temp <> 0 ) then
                    L_CODE_RETOUR := 2;
                    SELECT distinct r.ident into l_ident FROM ressource r WHERE r.matricule=UPPER(une_ligne.matricule);
                      UPDATE TMP_RESS_MASSE
                        SET CODE_RETOUR=2, IDENT=(SELECT distinct r.ident FROM ressource r WHERE r.matricule=UPPER(une_ligne.matricule))
                        WHERE id_ligne = une_ligne.id_ligne;
                  elsif
                    (l_retour is not null) then
                    L_CODE_RETOUR := 1;
                    else

                   L_CODE_RETOUR := 0;

                  end  if;




              BEGIN

                            SELECT count(*) into l_temp
                            FROM societe
                            WHERE soccode = une_ligne.soccode;

              if (l_temp = 0 ) then

                               l_retour := l_retour || 'Le code société n''existe pas; ';
                end if;
                        END;



             -- test sur le chef de projet : identifiant doit exister dans la BIP
             BEGIN
                SELECT count(*) into l_temp
                 FROM ressource
                 WHERE ident = to_number(une_ligne.cpident);



                           if (l_temp = 0 ) then

                              l_retour := l_retour || 'Le code chef de projet n''existe pas; ';
                end if;
             END;


    -- test du code prestation
        BEGIN
            if (une_ligne.soccode = 'SG..') then

            SELECT count(*) into l_temp
                FROM prestation
                  WHERE (rtype ='A'  or rtype = '*')
                  AND RTRIM(prestation) = RTRIM(to_char(une_ligne.qualif));


                                          if (l_temp = 0 ) then
                l_retour := l_retour || 'Ce type de prestation/qualification n''est pas pris en charge par ce traitement; ';
                end if;
            else
              SELECT count(*) into l_temp
                FROM prestation
                  WHERE (rtype ='P' or rtype = '*')
                  AND RTRIM(prestation) = RTRIM(to_char(une_ligne.qualif));


                                          if (l_temp = 0 ) then
                l_retour := l_retour || 'Ce type de prestation/qualification n''est pas pris en charge par ce traitement; ';
                end if;
            end if;
             END;





                  -- test sur l'existence du DPG
        BEGIN
            SELECT count(*) into l_temp

                    FROM   struct_info
                    WHERE  codsg = une_ligne.dpg;



             if (l_temp = 0 ) then
                l_retour := l_retour || 'Le code DPG est inconnu; ';
                end if;
          END;


            UPDATE TMP_RESS_MASSE
                SET CODE_RETOUR=L_code_retour,RETOUR=l_retour
                WHERE id_ligne = une_ligne.id_ligne;





          if (une_ligne.DATARR is not null and l_date_valid = 0)    then

            if ( to_date(une_ligne.DATARR)>to_date(une_ligne.DATDEP,'DD/MM/YYYY')) and (une_ligne.DATDEP is not null) then
                l_retour := l_retour || 'La date d''arrivée est supérieur à la date de départ; ';
              end if;



               if (L_CODE_RETOUR = 2) then


                 L_DATARR:=to_date('01'||to_char(to_date(une_ligne.DATARR),'mmyyyy'));
                L_DATDEP:=to_date(une_ligne.DATDEP);



-- test sur l'existence d'une situ dans la Bip pour la ressource
                 SELECT count(datsitu) INTO l_new FROM situ_ress where ident=l_ident;
-- pas de situation pour la ressource
                 IF l_new<>0 THEN -- la ressource a déjà une situation

                    BEGIN
                       select max(to_char(datdep,'yyyymm')) mois,max(datsitu) deb_periode,max(datdep) fin_periode
                       into mois, deb_periode, fin_periode
                       from situ_ress
                       where ident=to_number(l_ident);
                    END;

                                 --cas 2
                               IF ((une_ligne.soccode != 'SG..') and (fin_periode is null))
                               THEN
--                                l_retour := 'cas 2';
                                    l_retour := l_retour || 'Situation antérieure non fermé : à gérer en ligne; ';
                               -- cas 2 bis
                               ELSIF ((une_ligne.soccode = 'SG..') and (fin_periode is null) and (to_date(une_ligne.datarr) > deb_periode))
                                  THEN
--                                   l_retour := 'cas 2 bis';
                                      l_code_retour := 0;
                                   -- cas 3
                                   ELSIF ((to_date(une_ligne.DATARR)<deb_periode) AND (to_date(une_ligne.DATDEP)<deb_periode or une_ligne.DATDEP is null) )
                                      THEN
--                                       l_retour := 'cas 3';
                                            l_retour := l_retour || 'Situation ultérieure existante; ';
                                      -- cas 6
                                      ELSIF ((to_date(une_ligne.DATARR)=deb_periode))
                                         THEN
--                                          l_retour := 'cas 6';
                                            l_retour := l_retour || 'Situation dejà existante : à gérer en ligne; ';
                                         -- cas 5
                                         ELSIF ((to_char(to_date(une_ligne.DATARR),'yyyymm') >= to_char(deb_periode,'yyyymm'))
                                                  and (to_char(to_date(une_ligne.DATDEP),'yyyymm') <= to_char(fin_periode,'yyyymm'))
                                                  and (une_ligne.datdep is not null))
                                            THEN
--                                             l_retour := 'cas 5';
                                               l_retour := l_retour || 'Situation incluse dans la situation actuelle; ';
                                           -- cas 4
                                            ELSIF ((to_char(to_date(une_ligne.DATARR),'yyyymm') > to_char(deb_periode,'yyyymm'))
                                                    and (to_char(to_date(une_ligne.DATARR),'yyyymm') < to_char(fin_periode,'yyyymm'))
                                                    and (fin_periode is not null)
                                                    and ((to_date(une_ligne.datdep) > fin_periode) or (une_ligne.datdep is null)))
                                               THEN
--                                                l_retour := 'cas 4';
                                                    l_retour := l_retour || 'Recouvrement sur plusieurs mois; ';
                                               ELSIF ((to_char(to_date(une_ligne.DATARR),'yyyymm') < to_char(deb_periode,'yyyymm'))
                                                    and (to_char(to_date(une_ligne.DATDEP),'yyyymm') < to_char(fin_periode,'yyyymm'))
                                                     and (to_char(to_date(une_ligne.DATDEP),'yyyymm') > to_char(deb_periode,'yyyymm'))
                                                     )
                                               THEN
--                                                l_retour := 'cas 4';
                                                     l_retour := l_retour || 'Recouvrement sur plusieurs mois; ';
                                               -- cas 7
                                               ELSIF (
                                                        (mois=to_char(to_date(une_ligne.DATARR),'yyyymm'))
                                                        AND (deb_periode < to_date(une_ligne.DATARR))
                                                        and (mois!=to_char(to_date(une_ligne.datdep),'yyyymm'))
                                                        and (
                                                            (mois!=to_char(deb_periode,'yyyymm'))or ( (mois=to_char(deb_periode,'yyyymm'))   and (to_number(to_char(to_date(une_ligne.DATARR),'DD')) > 15 )    )
                                                            )
                                                      )
                                                  THEN
                                                        IF (to_number(to_char(to_date(une_ligne.DATARR),'DD')) < 16 ) THEN
--                                                             l_retour := 'cas 7';
                                                            l_code_retour := 0;
                                                        --- cas 8 et 13
                                                        ELSE
--                                                         l_retour := 'cas 8 et 13';
                                                           l_code_retour := 0;
                                                        END IF;
                                                  -- cas 12
                                                  ELSIF  ((mois=to_char(to_date(une_ligne.DATARR),'yyyymm'))
                                                             and (mois=to_char(deb_periode,'yyyymm')))
                                                     THEN
                                                        IF (mois < to_char(to_date(une_ligne.datdep),'yyyymm')) THEN
--                                                            l_retour := 'cas 12';
                                                           l_retour := l_retour || 'Changement de situation ingérable; ';
                                                        --- cas 10
                                                        ELSIF (abs(months_between(deb_periode,fin_periode)*31) > abs(months_between(to_date(une_ligne.datarr),to_date(une_ligne.datdep))*31))
                                                           THEN
--                                                             l_retour := 'cas 10';
                                                            l_code_retour := 0;
                                                        -- cas 11 et 9
                                                           ELSE
--                                                            l_retour := 'cas 11 et 9';
                                                          l_code_retour := 0;
                                                        END IF;
                               END IF;


                end if;



            end if;

                 if (l_retour is not null )then

              UPDATE TMP_RESS_MASSE
                SET RETOUR=l_retour, code_retour = 1
                WHERE id_ligne = une_ligne.id_ligne;
             else
              UPDATE TMP_RESS_MASSE
                SET code_retour = 0
                WHERE id_ligne = une_ligne.id_ligne;
             end if;

           end if;




        end;



    END LOOP;





        Pack_Global.INIT_WRITE_FILE( p_chemin_fichier, p_nom_fichier, l_hfile);

     Pack_Global.WRITE_STRING(    l_hfile,
                            'CODE IDENT'    || ';' ||
                            'PRENOM '        || ';' ||
                            'NOM'    || ';' ||
                            'MATRICULE' || ';' ||
                            'DATE ARRIVE'    || ';' ||
                            'DATE DEPART '        || ';' ||
                            'DPG'    || ';' ||
                            'SOCIETE' || ';' ||
                             'COUT HT'    || ';' ||
                            'QUALIFICATION'        || ';' ||
                            'DISPONIBILITE'    || ';' ||
                            'CPIDENT' || ';' ||
                            'ERREURS'
                        );

        FOR rec_retour IN retour LOOP



            Pack_Global.WRITE_STRING( l_hfile,

                rec_retour.ident|| ';' ||

               rec_retour.RPRENOM || ';' ||
    rec_retour.RNOM|| ';' ||
    rec_retour.MATRICULE|| ';' ||
    rec_retour.DATARR|| ';' ||
    rec_retour.DATDEP|| ';' ||
    rec_retour.DPG|| ';' ||
   rec_retour.SOCCODE|| ';' ||
    rec_retour.COUTHT|| ';' ||
    rec_retour.QUALIF|| ';' ||
    rec_retour.DISPONIBILITE|| ';' ||
   rec_retour.CPIDENT|| ';' ||
    rec_retour.RETOUR

                );
        END LOOP;


        Pack_Global.CLOSE_WRITE_FILE(l_hfile);

      /*
      En attente d'installation du package ult_mail en homologation


        pack_mail.ENVOI_MAIL('I001',p_chemin_fichier,p_nom_fichier); */



END test_ressource;




PROCEDURE insert_ressource is


l_ident number;
MOIS varchar2(6);
deb_periode date;
fin_periode date;
L_CREATION VARCHAR2(5);

L_DATARR DATE;
L_DATDEP DATE;

l_max_date_fin DATE;
l_mci VARCHAR2(3);

 l_niveau        SITU_RESS.NIVEAU%TYPE;

        CURSOR curseur IS
    SELECT
    ID_LIGNE,
    ident,
    RPRENOM,
    RNOM,
    MATRICULE,
    to_date(DATARR) datarr,
    to_date(DATDEP) datdep,
    DPG,
    SOCCODE,
    COUTHT,
    QUALIF,
    DISPONIBILITE,
    CPIDENT,
    RETOUR
    FROM tmp_ress_masse ;




BEGIN

BEGIN
    select CODE_CONTRACTUEL into l_mci from mode_contractuel
    where CODE_CONTRACTUEL = 'ATU'
    and (TYPE_RESSOURCE = 'P' or TYPE_RESSOURCE = '*')
    and  TOP_ACTIF = 'O';
EXCEPTION 
    WHEN NO_DATA_FOUND THEN
        l_mci := '???';
END;



for rec in curseur loop

    if (rec.ident is null) then

            SELECT MAX(ident) INTO L_IDENT FROM RESSOURCE;
                 L_IDENT := L_IDENT +1;

                 INSERT INTO ressource (ident,rnom,rprenom,matricule,coutot,rtel,batiment,etage,
                 bureau,flaglock,rtype,icodimm)
                 VALUES (L_IDENT,
                 UPPER(rec.rnom),
                 UPPER(rec.rprenom),
                 lpad(UPPER(rec.matricule),7,0),
                 NULL,
                 NULL,
                 NULL,
                 NULL,
                 NULL,
                 0,
                 'P',
                 '00000');
                 COMMIT;

                 UPDATE TMP_RESS_MASSE SET IDENT=L_IDENT
                 WHERE id_ligne = rec.id_ligne
                 ;
                 COMMIT;
                 
            Pack_Ressource_P.maj_ressource_logs(l_ident,'CHARG MASSE', 'RESSOURCE', 'Nom', NULL, UPPER(rec.rnom), 'Création de la ressource');
            Pack_Ressource_P.maj_ressource_logs(l_ident,'CHARG MASSE', 'RESSOURCE', 'Prénom', NULL, UPPER(rec.rprenom), 'Création de la ressource');
            Pack_Ressource_P.maj_ressource_logs(l_ident,'CHARG MASSE', 'RESSOURCE', 'Type', NULL, 'P', 'Création de la ressource');
            Pack_Ressource_P.maj_ressource_logs(l_ident,'CHARG MASSE', 'RESSOURCE', 'Matricule', NULL, lpad(UPPER(rec.matricule),7,0), 'Création de la ressource');



    end if;

    begin
        SELECT NIVEAU INTO l_niveau
        FROM SITU_RESS
        WHERE datsitu=(SELECT MAX(datsitu)
        FROM SITU_RESS
        WHERE     ident=TO_NUMBER(rec.ident))
        AND    ident=TO_NUMBER(rec.ident);
        exception
            when no_data_found then
                l_niveau := null;
        end;


    BEGIN


           L_CREATION := 'OUI';

         L_DATARR:=to_date('01'||to_char(rec.DATARR,'mmyyyy'));
        L_DATDEP:=rec.DATDEP;


          BEGIN
           update situ_ress set datdep =  (L_DATARR-1)
                  WHERE ident = rec.ident
                  AND datsitu=(select max(datsitu)
                    from situ_ress
                    where ident=rec.ident)
            AND datdep IS NULL;



             END;




        select max(to_char(datdep,'yyyymm')) mois,max(datsitu) deb_periode,max(datdep) fin_periode
        into mois, deb_periode, fin_periode
            from situ_ress
        where ident=to_number(rec.IDENT);


        -- cas 2 bis
       IF ((rec.soccode = 'SG..') and (fin_periode is null) and (to_date(rec.datarr) > deb_periode))
          THEN
            L_CREATION := 'OUI';
             L_DATARR :=round(rec.DATARR,'MONTH');
             UPDATE situ_ress SET datdep=(L_DATARR-1)
              where datsitu=deb_periode
                and ident=to_number(rec.IDENT);

        --- cas 7
       ELSIF ((mois=to_char(to_date(rec.DATARR),'yyyymm')) AND (deb_periode < to_date(rec.DATARR))  and (mois!=to_char(to_date(rec.datdep),'yyyymm'))
                   and ((mois!=to_char(deb_periode,'yyyymm'))or ( (mois=to_char(deb_periode,'yyyymm'))   and (to_number(to_char(to_date(rec.DATARR),'DD')) > 15 )    )))
          THEN
        IF (to_number(to_char(to_date(rec.DATARR),'DD')) < 16 ) THEN
             L_CREATION := 'OUI';
             L_DATARR :=round(rec.DATARR,'MONTH');
            UPDATE situ_ress SET datdep=(L_DATARR-1)
              where datsitu=deb_periode
                and ident=to_number(rec.IDENT);

        --- cas 8 et 13
        ELSE
            L_CREATION := 'OUI';
             L_DATARR :=round(last_day(rec.DATARR),'MONTH');
            UPDATE situ_ress SET datdep=(L_DATARR-1)
              where datsitu=deb_periode
                and ident=to_number(rec.IDENT);
        END IF;
  -- cas 10
            ELSIF  ((mois=to_char(to_date(rec.DATARR),'yyyymm'))
             and (mois=to_char(deb_periode,'yyyymm')))
          THEN
                IF (abs(months_between(deb_periode,fin_periode)*31) > abs(months_between(to_date(rec.datarr),to_date(rec.datdep))*31))
           THEN

           if rec.datdep > fin_periode then
            l_max_date_fin := rec.datdep;
           else
            l_max_date_fin := fin_periode;
           end if;

            UPDATE situ_ress SET datdep=l_max_date_fin
            where datsitu=deb_periode
            and ident=to_number(rec.IDENT);
               L_CREATION := 'NON';

        -- cas 11 et 9
           ELSE

           if rec.datdep > fin_periode then
            l_max_date_fin := rec.datdep;
           else
            l_max_date_fin := fin_periode;
           end if;

           L_CREATION := 'NON';
           UPDATE situ_ress SET
           datdep=l_max_date_fin,
           cpident=  rec.cpident,
           codsg=rec.dpg,
           soccode=rec.soccode,
           cout=decode(rec.soccode,'SG..',null,rec.coutht),
           prestation=        rec.qualif,
           dispo=rec.DISPONIBILITE,
           niveau=l_niveau
            where datsitu=deb_periode
            and ident=to_number(rec.IDENT);
        END IF;
      END IF;



        IF L_CREATION='OUI' THEN

        INSERT INTO situ_ress(ident,datsitu,datdep,cpident,codsg,soccode,cout,rmcomp,prestation,dispo,niveau,MODE_CONTRACTUEL_INDICATIF)
        VALUES
        (decode(rec.ident,null,l_ident,rec.ident),
        L_DATARR,
        L_DATDEP,
        rec.cpident,
        rec.dpg,
        rec.soccode,
        decode(rec.soccode,'SG..',null,rec.coutht),
        0,
        rec.qualif,
        rec.DISPONIBILITE,
        l_niveau,
        decode(rec.soccode,'SG..',null,l_mci));

        COMMIT;
        
        
        
        Pack_Ressource_P.maj_ressource_logs(l_ident,'CHARG MASSE', 'SITU_RESS', 'Datsitu', NULL, L_DATARR, 'Création de la situation');
        Pack_Ressource_P.maj_ressource_logs(l_ident,'CHARG MASSE', 'SITU_RESS', 'Datdep', NULL, L_DATDEP, 'Création de la situation');
        Pack_Ressource_P.maj_ressource_logs(l_ident,'CHARG MASSE', 'SITU_RESS', 'Societe', NULL, rec.soccode, 'Création de la situation');
        Pack_Ressource_P.maj_ressource_logs(l_ident,'CHARG MASSE', 'SITU_RESS', 'DPG', NULL, rec.dpg, 'Création de la situation');
        Pack_Ressource_P.maj_ressource_logs(l_ident,'CHARG MASSE', 'SITU_RESS', 'Prestation', NULL, rec.qualif, 'Création de la situation');
        Pack_Ressource_P.maj_ressource_logs(l_ident,'CHARG MASSE', 'SITU_RESS', 'Chet de projet', NULL, rec.cpident, 'Création de la situation');
        Pack_Ressource_P.maj_ressource_logs(l_ident,'CHARG MASSE', 'SITU_RESS', 'Disponibilité', NULL, rec.DISPONIBILITE, 'Création de la situation');
        
        IF (rec.soccode != 'SG..')  THEN
            Pack_Ressource_P.maj_ressource_logs(l_ident,'CHARG MASSE', 'SITU_RESS', 'Mode contractuel indicatif', NULL, l_mci, 'Création de la situation');
        END IF;
        
        
        
        
        end if;

END;




end loop;


END insert_ressource;



END pack_ress_situ_masse;
/
