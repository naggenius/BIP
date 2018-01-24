-- *****************************************************************************************

-- Créé le 12/09/2008 par ABA
-- Modification
--- 15/09/2008 ABA ajout d'une ligne entete des les immo encours d'expense
--- 15/09/2008 ABA mise à jour de date envoi et topenvoi en fonction du ramassage des immo def
--- 16/09/2008 ABA modif controle de date + format d'insertion de la date envoi
--- 22/09/2008 ABA ajout de la regle de gestion pour le rammassage des immo de l'annee A-1 en janvier
--- 20/11/2008 ABA modification format de fichier pour immo def
--- 03/12/2008 ABA modification du count des lignes immo d'expense
--- 09/03/2009 ABA TD 755
--- 17/03/2010 ABA TD 880
--- 19/04/2010 YNI TD 759 
-- 24/03/2011 : BSA : QC 1123
-- Modifié le 07/06/2012 par ABA : QC 1386
---- ******************************************************************************************

CREATE OR REPLACE PACKAGE "PACK_IMMO" IS

/* procedure d'extraction des immobilisations définitives */
PROCEDURE export_immo_def(P_LOGDIR          IN VARCHAR2,p_chemin_fichier VARCHAR2, p_nom_fichier VARCHAR2);

/* procedure d'extraction des immobilisations encours */
PROCEDURE export_immo_en(P_LOGDIR          IN VARCHAR2,
                  p_chemin_fichier  IN VARCHAR2,
                p_nom_fichier_expense     IN VARCHAR2);
                
                
  TYPE loupe_viewtype IS RECORD (
      selection  char(1),
      numero    number(2),
      libelle  VARCHAR2(50)
   );

   TYPE loupe_curtype IS REF CURSOR
      RETURN loupe_viewtype;                

PROCEDURE select_loupe_simul_immo(p_userid IN VARCHAR2,
                                    p_contexte IN VARCHAR2,
                                     p_curseur IN OUT loupe_curtype,
                                     p_message IN OUT VARCHAR2);
                                        
PROCEDURE update_loupe_simul_immo (p_userid IN VARCHAR2,
                                    p_contexte IN VARCHAR2,
                                     p_chaine_loupe IN VARCHAR2,
                                     p_message IN OUT VARCHAR2);
                                     
  TYPE ListeViewType IS RECORD(code      VARCHAR2(5),
                              libelle VARCHAR2(30)
                                        );
   TYPE listeCurType IS REF CURSOR RETURN ListeViewType;                                     
                                     
 
/* liste des axes strategiques de l'utilisateur*/                                    
PROCEDURE liste_axe_strat_user(p_userid IN VARCHAR2, 
                                 p_curseur IN OUT listeCurType) ;       
                    
 
/* liste des types financements de l'utilisateur*/                                                                     
PROCEDURE liste_type_fina_user(p_userid IN VARCHAR2, 
                                 p_curseur IN OUT listeCurType) ; 
                                 
/* verifie la presence d'un axe stratégique ou type financement valide dans les immos actuels*/                                                                     
PROCEDURE presence_axe_fina(p_user IN VARCHAR2,
                            p_pres_axe IN OUT VARCHAR2, 
                            p_pres_fin IN OUT VARCHAR2) ;        
                            
/* initialise les valeurs des liste deroulante selon QC 1386*/                                                                     
PROCEDURE init_valeur_liste(p_userid IN VARCHAR2,
                            p_param7 IN OUT VARCHAR2, 
                            p_param8 IN OUT VARCHAR2,
                            p_param9 IN OUT VARCHAR2, 
                            p_param10 IN OUT VARCHAR2) ;   
                            
                                                                                                                                               
END pack_immo;
/

create or replace
PACKAGE BODY "PACK_IMMO" IS


CALLEE_FAILED EXCEPTION;
PRAGMA EXCEPTION_INIT( CALLEE_FAILED, -20000 );
CALLEE_FAILED_ID     NUMBER := -20000;   -- pour propagation dans pile d'appel
TRCLOG_FAILED_ID     NUMBER := -20001;   -- problème : erreur dans la gestion d'erreur !

PROCEDURE export_immo_def(P_LOGDIR          IN VARCHAR2,
                            p_chemin_fichier    IN VARCHAR2,
                            p_nom_fichier        IN VARCHAR2
                      ) IS

L_RETCOD    NUMBER;
L_PROCNAME  VARCHAR2(16) := 'IMMO_DEF';
L_HFILE1    UTL_FILE.FILE_TYPE;
L_STATEMENT VARCHAR2(128);
l_nbenreg  NUMBER;
annee_en_cours NUMBER(4);
date_dem VARCHAR2(10);

   --YNI FDT 759 Modification de la requete Select pour prendre en consideration
   --le cumul de la valeur immobilisation
   CURSOR csr_immo_def IS
   select
          p.ICPI  PROJET,
          decode(p.STATUT,'D','D','A','A','R','A','Q','A')  STATUT,
          p.datdem  DATEDEM,
          p.cada  CADA,
          sum(to_number(nvl(au.totalhtr,0)) + to_number(nvl(au.totalsg,0))) SOMME,
          p.topenvoi,
          p.date_envoi,
          p.dureeamor
    from
          proj_info p, audit_immo au
    where
          p.icodproj <> 0
          and p.icpi = au.icpi (+)
          and p.datdem < trunc(sysdate,'MM')
          and p.statut in ('A','R','D','Q')
          and p.topenvoi = 'N'
          group by p.icpi,STATUT,p.datdem,p.cada, p.topenvoi, p.date_envoi, p.dureeamor
          order by p.datdem;

        l_msg  VARCHAR2(1024);
        l_hfile UTL_FILE.FILE_TYPE;


    BEGIN

    l_nbenreg :=0 ;
  -----------------------------------------------------
    -- Init de la trace
    -----------------------------------------------------
    L_RETCOD := Trclog.INITTRCLOG( P_LOGDIR , L_PROCNAME, L_HFILE1 );
    IF ( L_RETCOD <> 0 ) THEN
    RAISE_APPLICATION_ERROR( TRCLOG_FAILED_ID,
                                 'Erreur : Gestion du fichier LOG impossible',
                                 FALSE );
    END IF;

    -----------------------------------------------------
    -- Trace Start
    -----------------------------------------------------
    Trclog.Trclog( L_HFILE1, 'Debut de ' || L_PROCNAME );

     L_STATEMENT := 'ECRITURE DANS LE FICHIER DES IMMOS DEFINITIVES : début';
     Trclog.Trclog( L_HFILE1, L_STATEMENT );

     L_STATEMENT := 'Init du fichier de sortie : ' || p_chemin_fichier || '/' || p_nom_fichier;
     Trclog.Trclog( L_HFILE1, L_STATEMENT );



        Pack_Global.INIT_WRITE_FILE( p_chemin_fichier, p_nom_fichier, l_hfile);


        FOR rec_immo_def IN csr_immo_def LOOP
            --YNI FDT 759 Exclure du fichier les Pxxxx dont le total
            --des réalisés immobilisés est égal ou inférieur à « 0 »
            IF (to_number(rec_immo_def.somme) > 0 )THEN


                      select to_number(to_char(sysdate,'YYYY')) into annee_en_cours from dual;

                      IF (to_number(to_char(rec_immo_def.datedem,'YYYY')) < annee_en_cours )THEN
                          date_dem := annee_en_cours||'0101';
                      ELSE
                          date_dem := to_char(rec_immo_def.datedem,'YYYYMMDD');
                      END IF;

                      --YNI FDT 759 Ajout de la colonne Valeur immobilisation.
                      Pack_Global.WRITE_STRING( l_hfile,
                          '2'               || ';' ||
                          'BIP'             || ';' ||
                          rec_immo_def.projet       || ';' ||
                          ' '             || ';' ||
                          rec_immo_def.statut             || ';' ||
                          date_dem    || ';' ||
                          rec_immo_def.cada || ';' ||
                          rec_immo_def.dureeamor
                          );


                       UPDATE PROJ_INFO SET topenvoi='O', date_envoi = trunc(sysdate) where icpi=rec_immo_def.projet;

                    -- BSA 1123
                    Pack_Proj_Info.maj_proj_info_logs(rec_immo_def.projet, 'export_immo_def', 'TOPENVOI', rec_immo_def.topenvoi, 'O', 'Modification du top envoi');
                    Pack_Proj_Info.maj_proj_info_logs(rec_immo_def.projet, 'export_immo_def', 'DATE_ENVOI', TO_CHAR(rec_immo_def.date_envoi,'DD/MM/YYYY'), TO_CHAR(SYSDATE,'DD/MM/YYYY'), 'Modification de la date envoi');

                       l_nbenreg := l_nbenreg+1;

                -- YNI FDT 759 Pour les projets sans immobilisation, positionner le top envoi à « O »
                -- et indiquer la date standard « 01/01/ 1900 » signifiant qu'il n'y a pas eu d'envoi automatique.
                ELSE
                      UPDATE PROJ_INFO SET topenvoi='O', date_envoi = to_date('01/01/1900') where icpi=rec_immo_def.projet;

                    -- BSA 1123
                    Pack_Proj_Info.maj_proj_info_logs(rec_immo_def.projet, 'export_immo_def', 'TOPENVOI', rec_immo_def.topenvoi, 'O', 'Modification du top envoi');
                    Pack_Proj_Info.maj_proj_info_logs(rec_immo_def.projet, 'export_immo_def', 'DATE_ENVOI', TO_CHAR(rec_immo_def.date_envoi,'DD/MM/YYYY'), '01/01/1900', 'Modification de la date envoi');


                END IF;

        END LOOP;


    L_STATEMENT := 'FIN ECRITURE DANS LE FICHIER DES IMMOS DEFINITIVES';
    Trclog.Trclog( L_HFILE1, L_STATEMENT );
    L_STATEMENT := '-> '||l_nbenreg ||' lignes créées dans le fichier';
    Trclog.Trclog( L_HFILE1, L_STATEMENT );
    Pack_Global.CLOSE_WRITE_FILE(l_hfile);

    EXCEPTION
           WHEN OTHERS THEN
            Pack_Global.recuperer_message(20401, NULL, NULL, NULL, l_msg);
            RAISE_APPLICATION_ERROR(-20401, l_msg);

END export_immo_def;


PROCEDURE export_immo_en( P_LOGDIR          IN VARCHAR2,
                  p_chemin_fichier  IN VARCHAR2,
                p_nom_fichier_expense     IN VARCHAR2
              ) IS


L_RETCOD    NUMBER;
L_PROCNAME  VARCHAR2(16) := 'IMMO_EN';
L_HFILE1    UTL_FILE.FILE_TYPE;
L_STATEMENT VARCHAR2(256);
l_hfile     UTL_FILE.FILE_TYPE;
l_hfile2     UTL_FILE.FILE_TYPE;
l_separateur CHAR(1) := ';';
l_nbenreg      NUMBER(15);
l_zone_evol_1 VARCHAR2(30) :='';
l_zone_evol_2 VARCHAR2(30) :='';
l_zone_evol_3 VARCHAR2(30) :='';


--########################################
-- Curseur ramenant les immos encours EXP
--########################################
CURSOR cur_immo_EXPENSE IS
select
           2                                                    type_enreg,
        'BIP'                                                origine,
        'P7090'                                              entite_projet,
        s.icpi                                               projet,
        '0BIPIAS'                                            composant,
        s.cada                                               cada,
        to_char(d.datdebex,'YYYY')                           annee,
        to_char(d.moismens,'MM')                             mois,
        'P'                                                  type_montant,
        to_char(abs(sum(s.a_consoft)),'FM999999999990.00')   montant,
        decode(sign(sum(s.a_consoft)),-1,'C',1,'D')          sens,
        'EUR'                                                devise,
        s.cafi                                               cafi,
        perim.codperim                                      perimetre_cafi
 from stock_immo s,
     datdebex d,
     struct_info si,
     directions d,
    (select distinct d.codperim, si.centractiv
           from struct_info si, directions d
          where
           si.topfer = 'O'
           and si.coddir = d.coddir

       ) perim
where soccode<>'SG..'
and s.CODSGRESS = si.CODSG
and si.coddir = d.CODDIR
and s.a_consoft <> 0
and d.syscompta = 'EXP'
and perim.centractiv(+) = s.cafi
group by s.icpi,s.cafi, d.datdebex, d.moismens,s.cada, perim.codperim
having sum(a_consoft)<>0
UNION
-- Charges salariales SSII
select
      2                                                             type_enreg,
      'BIP'                                                         origine,
      'P7090'                                                         entite_projet,
      s.icpi                                                        projet,
      '0BIPIAS'                                                     composant,
      s.cada                                                        cada,
      to_char(d.datdebex,'YYYY')                                     annee,
      to_char(d.moismens,'MM')                                         mois,
      'C'                                                             type_montant,
      to_char(abs(sum(a_consoft*(t.taux/100))),'FM999999999990.00') montant,
      decode(sign(sum(s.a_consoft)),-1,'C',1,'D')                     sens,
      'EUR'                                                         devise,
      s.cafi                                                        cafi,
       perim.codperim                                      perimetre_cafi

from stock_immo s,
     taux_charge_salariale t,
     datdebex d,
     struct_info si,
     directions d,
    (select distinct d.codperim, si.centractiv
           from struct_info si, directions d
          where
           si.topfer = 'O'
           and si.coddir = d.coddir

       ) perim
where
t.annee = to_number(to_char(d.datdebex,'YYYY'))
and soccode='SG..'
and s.CODSGRESS = si.CODSG
and si.coddir = d.CODDIR
and d.syscompta = 'EXP'
and perim.centractiv(+) = s.cafi
group by s.icpi,s.cafi, d.datdebex, d.moismens,s.cada, perim.codperim
having sum(a_consoft)<>0
UNION
--salaires SG
select
      2                                                                        type_enreg,
      'BIP'                                                                    origine,
      'P7090'                                                                    entite_projet,
      s.icpi                                                                   projet,
      '0BIPIAS'                                                                composant,
      s.cada                                                                   cada,
      to_char(d.datdebex,'YYYY')                                                annee,
      to_char(d.moismens,'MM')                                                    mois,
      'S'                                                                        type_montant,
      to_char(abs(sum(s.a_consoft*((100-taux)/100))),'FM999999999990.00')   montant,
      decode(sign(sum(s.a_consoft)),-1,'C',1,'D')                             sens,
      'EUR'                                                                 devise,
      s.cafi                                                                cafi,
       perim.codperim                                      perimetre_cafi
from stock_immo s,
     taux_charge_salariale t,
     datdebex d,
     struct_info si,
     directions d,
    (select distinct d.codperim, si.centractiv
           from struct_info si, directions d
          where
           si.topfer = 'O'
           and si.coddir = d.coddir

       ) perim
where
t.annee = to_number(to_char(d.datdebex,'YYYY'))
and soccode='SG..'
and s.CODSGRESS = si.CODSG
and si.coddir = d.CODDIR
and d.syscompta = 'EXP'
and perim.centractiv(+) = s.cafi
group by s.icpi,s.cafi, d.datdebex, d.moismens,s.cada, perim.codperim
having sum(a_consoft)<>0    ;




BEGIN


    -----------------------------------------------------
    -- Init de la trace
    -----------------------------------------------------
    L_RETCOD := Trclog.INITTRCLOG( P_LOGDIR , L_PROCNAME, L_HFILE1 );
    IF ( L_RETCOD <> 0 ) THEN
    RAISE_APPLICATION_ERROR( TRCLOG_FAILED_ID,
                                 'Erreur : Gestion du fichier LOG impossible',
                                 FALSE );
    END IF;


        -----------------------------------------------------
    -- Init fichier BU manquante
    -----------------------------------------------------
    Pack_Global.INIT_WRITE_FILE( p_chemin_fichier, 'BU_manquante.csv' , l_hfile2);

    -----------------------------
    --DEBUT PARTIE CONCERNANT EXPENSE
    -----------------------------
    L_STATEMENT := 'ECRITURE DANS LE FICHIER POUR EXPENSE : début';
     Trclog.Trclog( L_HFILE1, L_STATEMENT );

	 L_STATEMENT := 'Init du fichier de sortie : ' || p_chemin_fichier || '/' || p_nom_fichier_expense || '.txt';
	 Trclog.Trclog( L_HFILE1, L_STATEMENT );
	 Pack_Global.INIT_WRITE_FILE( p_chemin_fichier, p_nom_fichier_expense , l_hfile);

	 --Nombre de lignes total du fichier (enregistrement + enetete )
    l_nbenreg := 0;
       SELECT COUNT(*)+1 INTO l_nbenreg
     FROM (select
           2                                                    type_enreg,
        'BIP'                                                origine,
        'P7090'                                              entite_projet,
        s.icpi                                               projet,
        '0BIPIAS'                                            composant,
        s.cada                                               cada,
        to_char(d.datdebex,'YYYY')                           annee,
        to_char(d.moismens,'MM')                             mois,
        'P'                                                  type_montant,
        to_char(abs(sum(s.a_consoft)),'FM999999999990.00')   montant,
        decode(sign(sum(s.a_consoft)),-1,'C',1,'D')          sens,
        'EUR'                                                devise,
        s.cafi                                               cafi,
        perim.codperim                                      perimetre_cafi
 from stock_immo s,
     datdebex d,
     struct_info si,
     directions d,
    (select distinct d.codperim, si.centractiv
           from struct_info si, directions d
          where
           si.topfer = 'O'
           and si.coddir = d.coddir

       ) perim
where soccode<>'SG..'
and s.CODSGRESS = si.CODSG
and si.coddir = d.CODDIR
and s.a_consoft <> 0
and d.syscompta = 'EXP'
and perim.centractiv(+) = s.cafi
group by s.icpi,s.cafi, d.datdebex, d.moismens,s.cada, perim.codperim
having sum(a_consoft)<>0
UNION
-- Charges salariales SSII
select
      2                                                             type_enreg,
      'BIP'                                                         origine,
      'P7090'                                                         entite_projet,
      s.icpi                                                        projet,
      '0BIPIAS'                                                     composant,
      s.cada                                                        cada,
      to_char(d.datdebex,'YYYY')                                     annee,
      to_char(d.moismens,'MM')                                         mois,
      'C'                                                             type_montant,
      to_char(abs(sum(a_consoft*(t.taux/100))),'FM999999999990.00') montant,
      decode(sign(sum(s.a_consoft)),-1,'C',1,'D')                     sens,
      'EUR'                                                         devise,
      s.cafi                                                        cafi,
       perim.codperim                                      perimetre_cafi

from stock_immo s,
     taux_charge_salariale t,
     datdebex d,
     struct_info si,
     directions d,
    (select distinct d.codperim, si.centractiv
           from struct_info si, directions d
          where
           si.topfer = 'O'
           and si.coddir = d.coddir

       ) perim
where
t.annee = to_number(to_char(d.datdebex,'YYYY'))
and soccode='SG..'
and s.CODSGRESS = si.CODSG
and si.coddir = d.CODDIR
and d.syscompta = 'EXP'
and perim.centractiv(+) = s.cafi
group by s.icpi,s.cafi, d.datdebex, d.moismens,s.cada, perim.codperim
having sum(a_consoft)<>0
UNION
--salaires SG
select
      2                                                                        type_enreg,
      'BIP'                                                                    origine,
      'P7090'                                                                    entite_projet,
      s.icpi                                                                   projet,
      '0BIPIAS'                                                                composant,
      s.cada                                                                   cada,
      to_char(d.datdebex,'YYYY')                                                annee,
      to_char(d.moismens,'MM')                                                    mois,
      'S'                                                                        type_montant,
      to_char(abs(sum(s.a_consoft*((100-taux)/100))),'FM999999999990.00')   montant,
      decode(sign(sum(s.a_consoft)),-1,'C',1,'D')                             sens,
      'EUR'                                                                 devise,
      s.cafi                                                                cafi,
       perim.codperim                                      perimetre_cafi
from stock_immo s,
     taux_charge_salariale t,
     datdebex d,
     struct_info si,
     directions d,
    (select distinct d.codperim, si.centractiv
           from struct_info si, directions d
          where
           si.topfer = 'O'
           and si.coddir = d.coddir

       ) perim
where
t.annee = to_number(to_char(d.datdebex,'YYYY'))
and soccode='SG..'
and s.CODSGRESS = si.CODSG
and si.coddir = d.CODDIR
and d.syscompta = 'EXP'
and perim.centractiv(+) = s.cafi
group by s.icpi,s.cafi, d.datdebex, d.moismens,s.cada, perim.codperim
having sum(a_consoft)<>0    );
         -- Entête du fichier
     Pack_Global.WRITE_STRING(    l_hfile,
                            '1'        ||l_separateur||
                            ' '        ||l_separateur||
                            'IEC'    ||l_separateur||
                            'A0374' ||l_separateur||
                            TO_NUMBER(TO_CHAR(SYSDATE,'yyyymmdd'))||l_separateur||
                            TO_NUMBER(TO_CHAR(SYSDATE,'HH24MISS'))    ||l_separateur||
                            l_nbenreg
                        );

l_nbenreg := 0;
	 -- Corps du fichier
	 --Parcourir la vue vue_immo
	 FOR ligne IN cur_immo_EXPENSE LOOP


            if (ligne.perimetre_cafi = '' or ligne.perimetre_cafi = ' ' or ligne.perimetre_cafi is null) then
                Pack_Global.WRITE_STRING(	l_hfile2,
							ligne.cafi);
            end if;


            Pack_Global.WRITE_STRING(	l_hfile,
							ligne.TYPE_ENREG	||l_separateur||
							ligne.ORIGINE		||l_separateur||
							ligne.ENTITE_PROJET	||l_separateur||
							ligne.PROJET		||l_separateur||
							ligne.COMPOSANT		||l_separateur||
							ligne.CADA			||l_separateur||
							ligne.ANNEE			||l_separateur||
							ligne.MOIS			||l_separateur||
							ligne.TYPE_MONTANT	||l_separateur||
							ligne.MONTANT		||l_separateur||
							ligne.SENS			||l_separateur||
							ligne.DEVISE		||l_separateur||
							ligne.CAFI			||l_separateur||
							ligne.perimetre_cafi
						);


        l_nbenreg := l_nbenreg + 1;
	 END LOOP;


	 L_STATEMENT := 'FIN ECRITURE DANS LE FICHIER EXPENSE';
	Trclog.Trclog( L_HFILE1, L_STATEMENT );
	L_STATEMENT := '-> '||l_nbenreg ||' lignes créées dans le fichier EXPENSE';
	Trclog.Trclog( L_HFILE1, L_STATEMENT );
	Pack_Global.CLOSE_WRITE_FILE(l_hfile);

    -------------------------------
    --FIN PARTIE CONCERNANT EXPENSE
    -------------------------------
	-----------------------------------------------------
	-- Fermeture fichier BU manquante
	-----------------------------------------------------
	Pack_Global.CLOSE_WRITE_FILE(l_hfile2);

	-----------------------------------------------------
	-- Trace Stop
	-----------------------------------------------------
	Trclog.Trclog( L_HFILE1, 'Fin normale de ' || L_PROCNAME  );
	Trclog.CLOSETRCLOG( L_HFILE1 );

	EXCEPTION
		WHEN OTHERS THEN
		    IF SQLCODE <> CALLEE_FAILED_ID AND SQLCODE <> TRCLOG_FAILED_ID THEN
                Trclog.Trclog( L_HFILE1, L_PROCNAME || ' : ' || SQLERRM );
            END IF;
            IF SQLCODE <> TRCLOG_FAILED_ID THEN
                Trclog.Trclog( L_HFILE1, 'Fin ANORMALE de ' || L_PROCNAME  );
                Trclog.CLOSETRCLOG( L_HFILE1 );
                RAISE_APPLICATION_ERROR( CALLEE_FAILED_ID,
                                        'Erreur : consulter le fichier LOG',
                                         FALSE );
            ELSE
                RAISE;
            END IF;

END export_immo_en;


/* Formatted on 2012/04/18 16:49 (Formatter Plus v4.8.8) */
PROCEDURE select_loupe_simul_immo (p_userid IN VARCHAR2, p_contexte IN VARCHAR2, p_curseur IN OUT loupe_curtype, p_message IN OUT VARCHAR2)
IS

l_user VARCHAR2(30);  

BEGIN

l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);

-- loupe axe stratégique 
IF (p_contexte = 'AXE') THEN

   BEGIN
      OPEN p_curseur FOR
         SELECT   '0' selection, numero, libelle
             FROM copi_axe_strategique
            WHERE numero NOT IN (SELECT ID
                                   FROM filtre_simul_immo
                                  WHERE TYPE = 'AXE' AND user_rtfe = l_user )
             AND LIBELLE != 'A Saisir'
         UNION
         SELECT   '1' selection, numero, libelle
             FROM copi_axe_strategique
            WHERE numero IN (SELECT ID
                               FROM filtre_simul_immo
                              WHERE TYPE = 'AXE' AND user_rtfe = l_user )
         ORDER BY libelle;
   EXCEPTION
      WHEN OTHERS
      THEN
         p_message := SQLERRM;
         
   END;
-- loupe type financement 
ELSE 
  BEGIN
      OPEN p_curseur FOR
         SELECT   '0' selection, numero, libelle
             FROM copi_type_financement
            WHERE numero NOT IN (SELECT ID
                                   FROM filtre_simul_immo
                                  WHERE TYPE = 'FIN' AND user_rtfe = l_user )
         UNION
         SELECT   '1' selection, numero, libelle
             FROM copi_type_financement
            WHERE numero IN (SELECT ID
                               FROM filtre_simul_immo
                              WHERE TYPE = 'FIN' AND user_rtfe = l_user )
         ORDER BY libelle;
   EXCEPTION
      WHEN OTHERS
      THEN
         p_message := SQLERRM;
         
   END;
END IF;


END select_loupe_simul_immo;       

PROCEDURE update_loupe_simul_immo (p_userid IN VARCHAR2,
                                    p_contexte IN VARCHAR2,
                                     p_chaine_loupe IN VARCHAR2,
                                     p_message IN OUT VARCHAR2)
                                     
                                     IS
l_user VARCHAR2(30);
l_chaine VARCHAR2(1000);    
l_loupe_termine BOOLEAN ;  
pos_loupe NUMBER(3);
nb_loupe NUMBER(3);
pos_loupe_suiv NUMBER(3);                             
                                     
BEGIN

l_chaine :=  p_chaine_loupe;
l_loupe_termine := FALSE;
pos_loupe_suiv := 0;
nb_loupe := 0;


l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);

Delete from filtre_simul_immo where user_rtfe = l_user and TYPE=p_contexte  ;

WHILE (NOT l_loupe_termine and l_chaine is not null ) LOOP

 pos_loupe := pos_loupe_suiv + 1;
 nb_loupe := nb_loupe + 1;
 pos_loupe_suiv := INSTR(l_chaine, ':', 1, nb_loupe);

  IF pos_loupe_suiv = 0 THEN
         l_loupe_termine  := true;
  END IF;
    
   
  IF l_loupe_termine THEN
    insert into filtre_simul_immo (USER_RTFE, TYPE, ID) values (l_user,p_contexte ,SUBSTR(l_chaine, pos_loupe, LENGTH(l_chaine)-pos_loupe + 1));
  ELSE
    insert into filtre_simul_immo (USER_RTFE, TYPE, ID) values (l_user,p_contexte ,SUBSTR(l_chaine, pos_loupe, pos_loupe_suiv-pos_loupe));
  END IF;

END LOOP;

END update_loupe_simul_immo;        

/* Formatted on 2012/04/18 16:43 (Formatter Plus v4.8.8) */
PROCEDURE liste_axe_strat_user (p_userid IN VARCHAR2, p_curseur IN OUT listecurtype)
IS
   l_user       VARCHAR2 (30);
    l_presence_fin   VARCHAR2(5);
   l_presence_axe   VARCHAR2(5);
BEGIN
   l_user := SUBSTR (pack_global.lire_globaldata (p_userid).idarpege, 1, 30);

   BEGIN
    presence_axe_fina(l_user,l_presence_axe,l_presence_fin  );

      IF (l_presence_axe = 'FALSE')
      THEN
         OPEN p_curseur FOR
            SELECT 'Pas de limitation' code, 'Pas de limitation' libelle
              FROM DUAL;
      ELSE
         OPEN p_curseur FOR
            SELECT code, libelle
              FROM (SELECT   'Pas de limitation' code, 'Pas de limitation' libelle, 1 top_tri
                        FROM DUAL
                    UNION
                    SELECT   'TOUS' code, 'Tous' libelle, 0 top_tri
                        FROM DUAL
                    UNION
                    SELECT   f.ID, axe.libelle, 2 top_tri
                        FROM filtre_simul_immo f, copi_axe_strategique axe
                       WHERE f.ID = axe.numero AND f.TYPE = 'AXE' AND f.user_rtfe = l_user
                       and axe.NUMERO in (SELECT DISTINCT dpc.axe_strategique
        
        FROM stock_ra s, ligne_bip l, dossier_projet_copi dpc, proj_info pi, type_etape te, filtre_simul_immo filtre
       WHERE s.pid = l.pid
         AND l.icpi = pi.icpi
         AND pi.dp_copi = dpc.dp_copi
         AND s.typetap = te.typetap
         AND te.top_immo = 'O'
         AND filtre.ID = dpc.axe_strategique
         AND filtre.TYPE = 'AXE'
         AND filtre.user_rtfe = l_user)
                    ORDER BY top_tri, libelle);
      END IF;
   END;
END liste_axe_strat_user;

PROCEDURE liste_type_fina_user(p_userid IN VARCHAR2, 
                                 p_curseur IN OUT listeCurType) IS
   l_user       VARCHAR2 (30);
   l_presence_fin   VARCHAR2(5);
   l_presence_axe   VARCHAR2(5);
BEGIN
  
 l_user := SUBSTR (pack_global.lire_globaldata (p_userid).idarpege, 1, 30);

    presence_axe_fina(l_user,l_presence_axe,l_presence_fin  );
    
 
   BEGIN
     
  
      IF (l_presence_fin  = 'FALSE')
      THEN
           OPEN p_curseur FOR
            SELECT 'Pas de limitation' code, 'Pas de limitation' libelle
              FROM DUAL;
      ELSE
    
         OPEN p_curseur FOR
            SELECT code, libelle
              FROM (SELECT   'Pas de limitation' code, 'Pas de limitation' libelle, 1 top_tri
                        FROM DUAL
                    UNION
                    SELECT   'TOUS' code, 'Tous' libelle, 0 top_tri
                        FROM DUAL
                    UNION
                    SELECT   f.ID, fin.libelle, 2 top_tri
                        FROM filtre_simul_immo f, copi_type_financement fin
                       WHERE f.ID = fin.numero AND f.TYPE = 'FIN' AND f.user_rtfe = l_user
                       and fin.NUMERO in (SELECT DISTINCT dpc.TYPE_FINANCEMENT
        
        FROM stock_ra s, ligne_bip l, dossier_projet_copi dpc, proj_info pi, type_etape te, filtre_simul_immo filtre
       WHERE s.pid = l.pid
         AND l.icpi = pi.icpi
         AND pi.dp_copi = dpc.dp_copi
         AND s.typetap = te.typetap
         AND te.top_immo = 'O'
         AND filtre.ID = dpc.type_financement
         AND filtre.TYPE = 'FIN'
         AND filtre.user_rtfe =  l_user)
                    ORDER BY top_tri, libelle);
      END IF;
     
   END;
END liste_type_fina_user;

PROCEDURE presence_axe_fina(p_user IN VARCHAR2,
                            p_pres_axe IN OUT VARCHAR2, 
                            p_pres_fin IN OUT VARCHAR2)  IS
                            
  
   l_presence   NUMBER (2);                           
BEGIN

 

BEGIN
-- AXE STRATEGIQUE
p_pres_axe := 'FALSE';

 SELECT COUNT (DISTINCT dpc.axe_strategique)
        INTO l_presence
        FROM stock_ra s, ligne_bip l, dossier_projet_copi dpc, proj_info pi, type_etape te, filtre_simul_immo filtre
       WHERE s.pid = l.pid
         AND l.icpi = pi.icpi
         AND pi.dp_copi = dpc.dp_copi
         AND s.typetap = te.typetap
         AND te.top_immo = 'O'
         AND filtre.ID = dpc.axe_strategique
         AND filtre.TYPE = 'AXE'
         AND filtre.user_rtfe = p_user;

IF (l_presence != 0) THEN
    p_pres_axe := 'TRUE';
END IF;
    

END;

 BEGIN 
 -- TYPE FINANCEMENT 
 p_pres_fin := 'FALSE';
  SELECT COUNT (DISTINCT dpc.TYPE_FINANCEMENT)
        INTO l_presence
        FROM stock_ra s, ligne_bip l, dossier_projet_copi dpc, proj_info pi, type_etape te, filtre_simul_immo filtre
       WHERE s.pid = l.pid
         AND l.icpi = pi.icpi
         AND pi.dp_copi = dpc.dp_copi
         AND s.typetap = te.typetap
         AND te.top_immo = 'O'
         AND filtre.ID = dpc.type_financement
         AND filtre.TYPE = 'FIN'
         AND filtre.user_rtfe = p_user;
         
         
         
    IF (l_presence != 0) THEN
        p_pres_fin := 'TRUE';
    END IF;
    
     
END;


END presence_axe_fina;         

/* Formatted on 2012/04/20 12:31 (Formatter Plus v4.8.8) */
PROCEDURE init_valeur_liste (
   p_userid    IN       VARCHAR2,
   p_param7    IN OUT   VARCHAR2,
   p_param8    IN OUT   VARCHAR2,
   p_param9    IN OUT   VARCHAR2,
   p_param10   IN OUT   VARCHAR2
)
IS
   pas_limit        VARCHAR2 (20);
   tous             VARCHAR2 (10);
   l_user           VARCHAR2 (30);
   l_presence_fin   VARCHAR2 (5);
   l_presence_axe   VARCHAR2 (5);
BEGIN
   pas_limit := 'Pas de limitation';
   tous := 'TOUS';
   l_user := SUBSTR (pack_global.lire_globaldata (p_userid).idarpege, 1, 30);
   presence_axe_fina (l_user, l_presence_axe, l_presence_fin);
   p_param7 := pas_limit;
   p_param8 := pas_limit;

   IF (l_presence_axe = 'TRUE' AND l_presence_fin = 'TRUE')
   THEN
      p_param9 := tous;
      p_param10 := tous;
   ELSIF (l_presence_axe = 'TRUE' AND l_presence_fin = 'FALSE')
   THEN
      p_param9 := tous;
      p_param10 := pas_limit;
   ELSIF (l_presence_axe = 'FALSE' AND l_presence_fin = 'TRUE')
   THEN
      p_param9 := pas_limit;
      p_param10 := tous;
   ELSE
      p_param7 := tous;
      p_param8 := tous;
      p_param9 := pas_limit;
      p_param10 := pas_limit;
   END IF;
END init_valeur_liste;                           
                                               

END pack_immo; 
/





