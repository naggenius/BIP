-- Package PACK_REPORT_LOG
-- permettant d'ajouter des enregistrements à la table REPORT_LOG
-- Une ligne est ajoutée à chaque demande de génération de reports
-- cf com.socgen.bip.metier.ReportManager.execReport()
-- ABA Fiche 916 24/01/2011
-- ABA 10/03/2011 ajout du champ arborescence affichant le menu complet d'obtention dfe l'édition
-- BSA 05/05/2011 qc 1176

CREATE OR REPLACE PACKAGE     PACK_REPORT_LOG AS

PROCEDURE insert_log(       p_FICHIER_RDF IN REPORT_LOG.FICHIER_RDF%TYPE,
                            p_ID_USER IN REPORT_LOG.ID_USER%TYPE,
                        p_global IN VARCHAR2,
                        p_nom_etat IN VARCHAR2,
                        p_filtre IN VARCHAR2,
                        p_jobid IN VARCHAR2,
                        p_arborescence IN VARCHAR2,
                        p_message IN OUT VARCHAR2);

END PACK_REPORT_LOG;
/


CREATE OR REPLACE PACKAGE BODY     PACK_REPORT_LOG AS

PROCEDURE insert_log(       p_FICHIER_RDF IN REPORT_LOG.FICHIER_RDF%TYPE,
                            p_ID_USER IN REPORT_LOG.ID_USER%TYPE, 
                            p_global IN VARCHAR2,
                            p_nom_etat IN VARCHAR2,
                            p_filtre IN VARCHAR2,
                            p_jobid IN VARCHAR2,
                            p_arborescence IN VARCHAR2,
                            p_message IN OUT VARCHAR2)
IS

l_ident NUMBER(5);
l_prenom VARCHAR2(30);
l_nom VARCHAR2(30);
BEGIN
    INSERT INTO REPORT_LOG (FICHIER_RDF, ID_USER, DATE_LOG) VALUES (p_FICHIER_RDF, p_ID_USER, sysdate);
    
    BEGIN
        select IDENT, NOM, PRENOM into l_IDENT, l_NOM, l_PRENOM from  rtfe_user
        where USER_RTFE = p_ID_USER;
        EXCEPTION WHEN
            NO_DATA_FOUND then  
           
        l_prenom := 'INCONNU';
        l_nom := 'INCONNU';
        l_ident := null;
    END;
    
            
     insert into rtfe_restit (IDENT, USER_RTFE, NOM, PRENOM, NOM_RDF, NOM_ETAT, JOBID, 
     DATE_RESTIT, MENU_UTILS, PERIM_ME, PERIM_MO, PERIM_MCLI, DOSS_PROJ, PROJET, 
     APPLI, CA_FI, CA_PAYEUR, CA_SUIVI, CA_DA, FILTRES) values
            (l_ident
            ,p_ID_USER
            ,l_nom
            ,l_prenom
            ,p_FICHIER_RDF
            ,p_nom_etat
            ,p_jobid
            ,sysdate
            ,p_arborescence
            ,pack_global.lire_perime(p_global)
            ,pack_global.lire_perimo(p_global)
            ,pack_global.lire_perimcli(p_global)
            ,pack_global.lire_doss_proj(p_global)
            ,pack_global.lire_projet(p_global)
            ,pack_global.lire_appli(p_global)
            ,pack_global.lire_ca_fi(p_global)
            ,pack_global.lire_ca_payeur(p_global)
            ,pack_global.lire_ca_suivi(p_global)
            ,pack_global.lire_ca_da(p_global)
            ,p_filtre
            );
            
EXCEPTION WHEN
    OTHERS THEN
        p_message := SQLERRM;
        RAISE_APPLICATION_ERROR( -20997, SQLERRM);
            
END insert_log;

END PACK_REPORT_LOG;
/


