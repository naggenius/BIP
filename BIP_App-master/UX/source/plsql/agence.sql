-- pack_agence PL/SQL
--
-- Equipe SOPRA 
--
-- Créé le 08/03/1999
-- ------------------
-- Modifié le 16/10/2006 par DDI.
---- Modifié le 20/11/2008 par ABA. TD 707 affichage message interdisant la suppression d'une agence lorsqu'elle est rattaché à un frs expense
--***********************************************************
--
-- Attention le nom du package ne peut etre le nom
-- de la table...
--
CREATE OR REPLACE PACKAGE pack_agence AS

   TYPE agence2 IS RECORD (SOCFOUR agence.SOCFOUR%TYPE,
   				   		   SOCFLIB agence.SOCFLIB%TYPE,
						   FLAGLOCK agence.FLAGLOCK%TYPE,
						   SOCCODE agence.SOCCODE%TYPE,
						   SIREN agence.SIREN%TYPE,
						   RIB agence.RIB%TYPE,
						   ACTIF agence.ACTIF%TYPE);

   TYPE agenceCurType IS REF CURSOR RETURN agence2;

   PROCEDURE insert_agence ( p_soccode   IN agence.soccode%TYPE,
                             p_socfour   IN agence.socfour%TYPE,
			     			 p_socflib   IN agence.socflib%TYPE,
                             p_global    IN VARCHAR2,
							 p_siren	 IN agence.SIREN%TYPE,
							 p_rib		 IN agence.RIB%TYPE,
							 p_actif	 IN agence.ACTIF%TYPE,
                             p_nbcurseur OUT INTEGER,
                             p_message   OUT VARCHAR2
                            );

   PROCEDURE update_agence ( p_soccode      IN agence.soccode%TYPE,
                             p_socfour      IN agence.socfour%TYPE,
                             p_socfour_sav  IN agence.socfour%TYPE,
			     			 p_socflib      IN agence.socflib%TYPE,
                             p_flaglock     IN NUMBER,
                             p_global       IN VARCHAR2,
							 p_siren	 IN agence.SIREN%TYPE,
							 p_rib		 IN agence.RIB%TYPE,
							 p_actif	 IN agence.ACTIF%TYPE,
                             p_nbcurseur    OUT INTEGER,
                             p_message      OUT VARCHAR2
                           );

   PROCEDURE delete_agence ( p_soccode   IN agence.soccode%TYPE,
                             p_socfour   IN agence.socfour%TYPE,
		             		 p_socflib   IN agence.socflib%TYPE,
                             p_flaglock  IN NUMBER,
                             p_global    IN VARCHAR2,
							 p_siren	 IN agence.SIREN%TYPE,
							 p_rib		 IN agence.RIB%TYPE,
							 p_actif	 IN agence.ACTIF%TYPE,
                             p_nbcurseur OUT INTEGER,
                             p_message   OUT VARCHAR2
                           );

   PROCEDURE select_agence ( p_soccode   IN agence.soccode%TYPE,
                             p_socfour   IN agence.socfour%TYPE,
                             p_global    IN VARCHAR2,
                             p_curAgence IN OUT agenceCurType,
                             p_nbcurseur OUT INTEGER,
                             p_message   OUT VARCHAR2
                            );

END pack_agence;
/


CREATE OR REPLACE PACKAGE BODY     pack_agence AS

   PROCEDURE insert_agence ( p_soccode   IN agence.soccode%TYPE,
                             p_socfour   IN agence.socfour%TYPE,
			     			 p_socflib   IN agence.socflib%TYPE,
                             p_global    IN VARCHAR2,
							 p_siren     IN agence.SIREN%TYPE,
							 p_rib		 IN agence.RIB%TYPE,
							 p_actif     IN agence.ACTIF%TYPE,
                             p_nbcurseur OUT INTEGER,
                             p_message   OUT VARCHAR2
                            ) IS
      -- Variables locales

      l_msg VARCHAR(1024);
   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

      BEGIN
         INSERT INTO agence ( soccode,
                              socfour,
		   		      		  socflib,
					  		  siren,
					  		  rib,
					  		  actif)
         VALUES ( p_soccode,
				  p_socfour,
                  p_socflib,
				  p_siren,
				  p_rib,
				  p_actif
                );

      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN

	      -- 'Code fournisseur déjà créé.'

            pack_global.recuperer_message( 20307, NULL, NULL, NULL, l_msg);

            raise_application_error( -20307, l_msg);

	   WHEN OTHERS THEN
            raise_application_error( -20997, SQLERRM);
      END;

      -- 'Le fournisseur ' || p_socflib || ' a été créé.';

      pack_global.recuperer_message( 3004, '%s1', p_socflib,
                                     NULL, l_msg);
      p_message := l_msg;

   END insert_agence;


   PROCEDURE update_agence ( p_soccode     IN agence.soccode%TYPE,
                             p_socfour     IN agence.socfour%TYPE,
                             p_socfour_sav IN agence.socfour%TYPE,
			     			 p_socflib     IN agence.socflib%TYPE,
                             p_flaglock    IN NUMBER,
                             p_global      IN VARCHAR2,
							 p_siren	 IN agence.SIREN%TYPE,
							 p_rib		 IN agence.RIB%TYPE,
							 p_actif	 IN agence.ACTIF%TYPE,
                             p_nbcurseur   OUT INTEGER,
                             p_message     OUT VARCHAR2
                            ) IS
      -- Variables locales

      l_msg VARCHAR(1024);
   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

      BEGIN
         UPDATE agence
         SET socfour  = p_socfour,
             socflib  = p_socflib,
  		  	 siren	  = p_siren,
			 rib	  = p_rib,
			 actif	  = p_actif,
             flaglock = decode( p_flaglock, 1000000, 0, p_flaglock + 1)
         WHERE ltrim(rtrim(socfour))= p_socfour_sav
         AND   soccode = p_soccode
         AND   flaglock = p_flaglock;

	EXCEPTION

         WHEN DUP_VAL_ON_INDEX THEN

	      -- 'Code fournisseur déjà créé.'
            pack_global.recuperer_message( 20307, NULL, NULL, NULL, l_msg);
            raise_application_error( -20307, l_msg);

	 WHEN OTHERS THEN
            raise_application_error( -20997, SQLERRM);
      END;

      IF SQL%NOTFOUND THEN
         -- 'Accès concurrent'
         pack_global.recuperer_message( 20999, NULL, NULL, NULL, l_msg);
         raise_application_error( -20999, l_msg );
      ELSE
	   -- message 'Le fournisseur %s1 a été modifié.'
         pack_global.recuperer_message( 3005, '%s1', p_socflib,
                                        NULL, l_msg);
         p_message := l_msg;
      END IF;
   END update_agence;

   PROCEDURE delete_agence ( p_soccode   IN agence.soccode%TYPE,
                             p_socfour   IN agence.socfour%TYPE,
		             		 p_socflib   IN agence.socflib%TYPE,
                             p_flaglock  IN NUMBER,
                             p_global    IN VARCHAR2,
							 p_siren	 IN agence.SIREN%TYPE,
							 p_rib		 IN agence.RIB%TYPE,
							 p_actif	 IN agence.ACTIF%TYPE,
                             p_nbcurseur OUT INTEGER,
                             p_message   OUT VARCHAR2
                            ) IS
      l_msg   VARCHAR(1024);
      referential_integrity   EXCEPTION;
      PRAGMA EXCEPTION_INIT(referential_integrity, -2292);
      l_presence NUMBER;
   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';
      l_presence := 0;
      
      SELECT count(*) into l_presence from ebis_fournisseurs where siren = p_siren;
      
      IF (l_presence = 0)THEN
      
      BEGIN
         DELETE FROM agence
         WHERE ltrim(rtrim(socfour)) = p_socfour
         AND   soccode  = p_soccode
		 AND   siren	= p_siren
		 AND   rib		= p_rib
         AND   flaglock = p_flaglock;

      EXCEPTION
         WHEN referential_integrity THEN

            -- habiller le msg erreur

            pack_global.recuperation_integrite(-2292);

         WHEN OTHERS THEN
            raise_application_error( -20997, SQLERRM);
      END;

      IF SQL%NOTFOUND THEN

         -- 'Accès concurrent'

         pack_global.recuperer_message( 20999, NULL, NULL, NULL, l_msg);

         raise_application_error( -20999, l_msg );
      ELSE

	   -- 'Le fournisseur %s1 a été supprimé.'

         pack_global.recuperer_message( 3006, '%s1', p_socflib,
                                        NULL, l_msg);
         p_message := l_msg;
      END IF;
      
      ELSE
        pack_global.recuperer_message( 21143,null, null, NULL, l_msg);
        p_message := l_msg;
        
      END IF;

   END delete_agence;

   PROCEDURE select_agence ( p_soccode   IN agence.soccode%TYPE,
                             p_socfour   IN agence.socfour%TYPE,
                             p_global    IN VARCHAR2,
                             p_curAgence IN OUT agenceCurType,
                             p_nbcurseur OUT INTEGER,
                             p_message   OUT VARCHAR2
                            ) IS
      l_msg VARCHAR2( 1024);
   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_nbcurseur := 1;
      p_message := '';

      -- Attention ordre des colonnes doit correspondre a l ordre
      -- de declaration dans la table ORACLE (a cause de ROWTYPE)
      -- ou selectionner toutes les colonnes par *

      OPEN p_curAgence FOR
           SELECT SOCFOUR,SOCFLIB,FLAGLOCK,SOCCODE,SIREN,RIB,ACTIF
           FROM agence
           WHERE socfour = p_socfour
           AND   soccode = p_soccode;

      -- en cas absence
      -- p_message := 'Code fournisseur inexistant.';
      -- Ce message est utilisé comme message APPLICATIF et
      -- message d'exception. => Il porte un numéro d'EXCEPTION

      pack_global.recuperer_message( 20308, NULL, NULL, NULL, l_msg);
      p_message := l_msg;

   END select_agence;

END pack_agence;
/


