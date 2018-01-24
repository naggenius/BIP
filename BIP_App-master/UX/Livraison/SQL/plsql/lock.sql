-- pack_lock PL/SQL
--
-- Attention le nom du package ne peut etre le nom de la table...
--
-- Cree le 04/07/2012 QC 1343
--  MAJ le
--12/12/12 ABA : QC 1343

--------------------------------------------------------
--  DDL for Package PACK_LOCK
--------------------------------------------------------

--------------------------------------------------------
--  DDL for Package PACK_LOCK
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PACK_LOCK" AS

PROCEDURE RESET_LOCK_USER ( p_userid    IN VARCHAR2,
                            p_fonction  IN VARCHAR2);



PROCEDURE GESTION_LOCK (p_userid      IN  VARCHAR2,
                        p_fonction    IN  VARCHAR2,
                        p_valeur      IN  VARCHAR2,
                        p_lock        OUT VARCHAR2,
                        p_message     OUT VARCHAR2);


END PACK_LOCK;
/
--------------------------------------------------------
--  DDL for Package Body PACK_LOCK
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PACK_LOCK" 
AS
  -- Purge des locks
PROCEDURE RESET_LOCK_USER(
    p_userid   IN VARCHAR2,
    p_fonction IN VARCHAR2)
IS
  t_user_rtfe RTFE_USER.USER_RTFE%TYPE;
  t_delai parametre.valeur%TYPE;
  t_listeValeurs parametre.liste_valeurs%TYPE;
  t_libelle parametre.libelle%TYPE;
  t_message VARCHAR2(1000);
BEGIN
  -- Recuperation du user RTFE
  t_user_rtfe := pack_global.lire_globaldata(p_userid).idarpege;
  -- Purge des anciens lock + celui de l utilisateur en cours
  DELETE
  FROM TMP_LOCK l
  WHERE l.FONCTION       = upper(p_fonction)
    AND  l.USER_RTFE = UPPER(t_user_rtfe);
END RESET_LOCK_USER;

PROCEDURE GESTION_LOCK(
    p_userid   IN VARCHAR2,
    p_fonction IN VARCHAR2,
    p_valeur   IN VARCHAR2,
    p_lock OUT VARCHAR2,
    p_message OUT VARCHAR2)
IS
  t_retour VARCHAR2(10);
  t_date   DATE;
  t_user_rtfe RTFE_USER.USER_RTFE%TYPE;
  CURSOR c_lock
  IS
    SELECT l.USER_RTFE ,
      l.DATE_DERNIER_ACCES,
      EXPIRE
    FROM TMP_LOCK l
    WHERE l.FONCTION = UPPER(p_fonction)
    AND l.VALEUR          = p_valeur;
    
  t_lock c_lock%ROWTYPE;
  t_delai parametre.valeur%TYPE;
  t_listeValeurs parametre.liste_valeurs%TYPE;
  t_libelle parametre.libelle%TYPE;
  t_message  VARCHAR2(1000);
  l_presence NUMBER(2);
  l_user     VARCHAR2(150);
  l_nom      VARCHAR2(150);
  l_premon   VARCHAR2(150);
BEGIN
  -- Recuperation du delai
  BEGIN
    PACK_PARAMETRE.select_parametre('LOCK_TIME',t_delai, t_listeValeurs,t_libelle,t_message);
  EXCEPTION
  WHEN OTHERS THEN
    t_delai := '30';
  END;
  t_date := SYSDATE - t_delai/1440 ; -- p_delai en minute
  -- Recuperation du user RTFE
  t_user_rtfe := pack_global.lire_globaldata(p_userid).idarpege;
  t_retour    := 'N';
  BEGIN
    SELECT COUNT(*)
    INTO l_presence
    FROM tmp_lock
    WHERE FONCTION = UPPER(p_fonction)
    AND VALEUR            = p_valeur
    AND user_rtfe  = UPPER(t_user_rtfe)
    AND sysdate           > date_dernier_acces;
    -- we show a message if the session is expired sysdate > date_dernier_acces
    IF l_presence != 0 THEN
      Pack_Global.recuperer_message(21262, NULL, NULL,NULL, t_message);
      p_message := t_message;
      t_retour  := 'O';
    END IF;
  END;
  -- Purge des anciens lock + celui de l utilisateur en cours
  DELETE
  FROM TMP_LOCK l
  WHERE l.FONCTION = upper(p_fonction)
  AND  (l.USER_RTFE = UPPER(t_user_rtfe)
          or l.DATE_DERNIER_ACCES < sysdate - 1);
  -- Recherche du lock sur la valeur
  OPEN c_lock;
  FETCH c_lock INTO t_lock;
  IF c_lock%FOUND THEN
    -- we check if the ressource is used by an other user
    IF (t_lock.USER_RTFE <> UPPER(t_user_rtfe) AND sysdate < t_lock.date_dernier_acces) THEN
      t_retour                  := 'O';
      SELECT r.USER_RTFE ,
        r.NOM,
        r.PRENOM
      INTO l_user,
        l_nom,
        l_premon
      FROM RTFE_USER r
      WHERE r.USER_RTFE = t_lock.USER_RTFE ;
      Pack_Global.recuperer_message(21249, '%s1', l_user , '%s2', l_nom ,'%s3', l_premon, NULL, t_message);
      p_message := t_message;
    ELSE
      INSERT
      INTO TMP_LOCK
        (
          USER_RTFE,
          DATE_ACCES,
          DATE_DERNIER_ACCES,
          FONCTION,
          VALEUR,
          EXPIRE
        )
        VALUES
        (
          TRIM(t_user_rtfe),
          SYSDATE,
          sysdate + (1/1440*t_delai),
          upper(p_fonction),
          upper(p_valeur),
          null );
    END IF;
  ELSE
    INSERT
    INTO TMP_LOCK
      (
        USER_RTFE,
        DATE_ACCES,
        DATE_DERNIER_ACCES,
        FONCTION,
        VALEUR,
        EXPIRE
      )
      VALUES
      (
        TRIM(t_user_rtfe),
        SYSDATE,
        sysdate + (1/1440*t_delai),
        upper(p_fonction),
        upper(p_valeur),
        null );
  END IF;
  CLOSE c_lock;
  p_lock := t_retour;
END GESTION_LOCK;
END PACK_LOCK;
/