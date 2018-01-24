-- pack_import_ES PL/SQL
--
-- Cree le 14/04/2004 par MMC
-- Ce package contient les traitements lies au chargement des ES

------------------------------------------------------------
-- Creation du package
-- CMA 01/12/2010 QC 1012 correction des liaisons type ES - Niveau
------------------------------------------------------------

CREATE OR REPLACE PACKAGE pack_import_ES AS

------------------------------------------------------------
-- Cette procedure modifie les donnees concernant le niveau
-- present dans la situation de la ressource
------------------------------------------------------------
	PROCEDURE alim_ES;

END pack_import_ES;
/


CREATE OR REPLACE PACKAGE BODY     pack_import_ES AS

PROCEDURE alim_ES IS
BEGIN
	--on vide la table des erreurs
DELETE FROM  CHARGE_ES_ERR;
COMMIT;

INSERT INTO CHARGE_ES_ERR (IDELST,CODCAMO,CDTYES,LILOES,LICOES)
SELECT   nvl(IDELST,'null'),nvl(CODCAMO,'null'),nvl(CDTYES,'0'),nvl(substr(LILOES,1,24),'non renseigné'),nvl(substr(LICOES,1,30),'non renseigné')
FROM charge_es
where IDELST is null
OR CODCAMO is null OR CDTYES is null OR LILOES is null;
commit;

DELETE FROM  CHARGE_ES
where IDELST is null
OR CODCAMO is null OR CDTYES is null OR LILOES is null;
commit;




	-----------------------------------------------------
        -- Alimentation de la table ENTITE_STRUCTURE a partir
        -- de la table CHARGE_ES
        -----------------------------------------------------

        -----------------------------------------------------
        -- MAJ dans le cas le l'existence d'un code centre
        -- d'activite dans la table de chargement et dans la
        -- la table des entites structure
        -----------------------------------------------------

     update ENTITE_STRUCTURE es
     set (es.CODCAMO,
            es.CDTYES,
            es.NIVEAU,
            es.LILOES ,
            es.LICOES,
            es.IDELST ) =
           (select
           ches.CODCAMO,
           ches.CDTYES,
           to_number(decode(ches.CDTYES, 30, 6, 99, 5, 31, 4, 32, 3,
                                 33, 2, 34, 1, 35, 0, 0)),
           substr(ches.LILOES, 1, 24),
           substr(ches.LICOES, 1, 30),
           ches.IDELST from CHARGE_ES ches
   		where to_number(ches.CODCAMO) = es.CODCAMO)
 	where es.CODCAMO IN (select es.CODCAMO
                              from entite_structure es, charge_es ches
                              where to_number(ches.CODCAMO) = es.CODCAMO
                              )

          ;
      commit;


     -----------------------------------------------------
      -- INSERT dans le cas de l'inexistance d'un code centre
      -- d'activite dans la table de chargement et dans la
      -- la table entite structure
      -----------------------------------------------------



      insert into ENTITE_STRUCTURE     (CODCAMO,CDTYES,NIVEAU,LILOES,LICOES,IDELST)
      select
          to_number(ches.CODCAMO),
          ches.CDTYES,
          to_number(decode(ches.CDTYES, 30, 6, 99, 5, 31, 4, 32, 3,
                                33, 2, 34, 1, 35, 0, 0)),
          substr(ches.LILOES, 1, 30),
          substr(ches.LICOES, 1, 30),
          to_number(ches.IDELST)
      from CHARGE_ES ches
      where not exists (select 1 from ENTITE_STRUCTURE es
                        where to_number(ches.CODCAMO) = es.CODCAMO)

        ;

      commit;


END alim_ES;



END pack_import_ES;
/


