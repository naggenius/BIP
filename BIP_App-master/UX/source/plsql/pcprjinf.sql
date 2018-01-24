-- pack_pcmratt_proj PL/SQL
--
-- Equipe SOPRA
--
-- Creer le 13/01/1999
--
-- Objet : Permet le rattachement en masse des projets à un DPG
-- Tables : struct_info	(recherche du code DPG), proj_info (modif de 'CODSG'), message
--
-- Modifié le 30/01/2001 par NBM : gestion des habilitations par périmètre ME
--				   ne prendre que les projets dont le codsg appartienne au périmètre ME de l'utilisateur
--
-- Modifié le 10/06/2003 par Pierre JOSSE : Mise à jour du nouveau format de code DPG
--
-- Modifié le 31/03/2004 par PJO : MAJ PID sur 4 caractères
---- 22/02/2010 ABA : TD 938

-- Modifié le 26/05/2011 par BSA : QC 1166

-- Attention le nom du package ne peut etre le nom
-- de la table...

create or replace
PACKAGE pack_pcmratt_proj AS

   TYPE applicationCurType IS REF CURSOR RETURN application%ROWTYPE;
   TYPE proj_infoCurType IS REF CURSOR RETURN proj_info%ROWTYPE;

  PROCEDURE update_un_projet (p_cod      IN VARCHAR2,
                              p_pid      IN ligne_bip.pid%TYPE,
                              p_flaglock IN VARCHAR2,
                              p_table    IN VARCHAR2,
			      p_userid   IN VARCHAR2,
	                      p_compteur IN OUT INTEGER,
                              p_message  IN OUT VARCHAR2,
                              p_lignes_ratt IN OUT VARCHAR2, --PPM 59288
                              p_lignes_non_ratt IN OUT VARCHAR2, --PPM 59288
                              p_isDbs IN OUT BOOLEAN --PPM 59288
                             );

   PROCEDURE update_pcmratt_proj (p_table      IN  VARCHAR2,
                                  p_cod        IN  VARCHAR2,
                                  p_lib        IN  VARCHAR2,
                                  p_pid_1      IN  ligne_bip.pid%TYPE,
				  p_nom_1      IN  VARCHAR2,
                                  p_flaglock_1 IN  VARCHAR2,
                                  p_pid_2      IN  ligne_bip.pid%TYPE,
				  p_nom_2      IN  VARCHAR2,
                                  p_flaglock_2 IN  VARCHAR2,
                                  p_pid_3      IN  ligne_bip.pid%TYPE,
				  p_nom_3      IN  VARCHAR2,
                                  p_flaglock_3 IN  VARCHAR2,
                                  p_pid_4      IN  ligne_bip.pid%TYPE,
				  p_nom_4      IN  VARCHAR2,
                                  p_flaglock_4 IN  VARCHAR2,
                                  p_pid_5      IN  ligne_bip.pid%TYPE,
				  p_nom_5      IN  VARCHAR2,
                                  p_flaglock_5 IN  VARCHAR2,
                                  p_pid_6      IN  ligne_bip.pid%TYPE,
				  p_nom_6      IN  VARCHAR2,
                                  p_flaglock_6 IN  VARCHAR2,
                                  p_userid     IN  VARCHAR2,
                                  p_nbcurseur  OUT INTEGER,
                                  p_message    OUT VARCHAR2
                                 );

   PROCEDURE select_a_pcmratt_proj (p_airt           IN application.airt%TYPE,
                                    p_userid         IN VARCHAR2,
                                    p_curapplication IN OUT applicationCurType,
                                    p_nbcurseur         OUT INTEGER,
                                    p_message           OUT VARCHAR2
                                  );

   PROCEDURE select_p_pcmratt_proj (p_icpi         IN proj_info.icpi%TYPE,
                                    p_userid       IN VARCHAR2,
                                    p_curproj_info IN OUT proj_infoCurType,
                                    p_nbcurseur       OUT INTEGER,
                                    p_message         OUT VARCHAR2
                                   );
END pack_pcmratt_proj;
/


create or replace
PACKAGE BODY     pack_pcmratt_proj AS

  PROCEDURE update_un_projet (p_cod      IN VARCHAR2,
                              p_pid      IN ligne_bip.pid%TYPE,
                              p_flaglock IN VARCHAR2,
                              p_table    IN VARCHAR2,
			      p_userid   IN VARCHAR2,
                              p_compteur IN OUT INTEGER,
                              p_message  IN OUT VARCHAR2,
                              p_lignes_ratt IN OUT VARCHAR2,
                              p_lignes_non_ratt IN OUT VARCHAR2,
                              p_isDbs IN OUT BOOLEAN
                             ) IS
   l_pid ligne_bip.pid%TYPE;
   l_codsg ligne_bip.codsg%TYPE;
   l_habilitation varchar2(10);
   l_dirprin NUMBER;--PPM 59288
   l_arctype VARCHAR2(3);--PPM 59288
   p_messages VARCHAR2(500);--PPM 59288
   l_icpi ligne_bip.icpi%TYPE;--PPM 59288 : pour traçabilité
   l_user		ligne_bip_logs.user_log%TYPE;--PPM 59288 : pour traçabilité
   BEGIN

    --PPM 59288 : initialisation de la valeur précédente du code projet pour les logs
    l_icpi :='';
    l_user := SUBSTR(pack_global.lire_globaldata(p_userid).idarpege, 1, 30);

	--Tester si le codsg de la ligne BIP fait partie du périmètre ME de l'utilisateur
	BEGIN
		select codsg into l_codsg
		from ligne_bip
		where pid = p_pid;

	EXCEPTION

	    WHEN OTHERS THEN
                raise_application_error(-20997, SQLERRM);

        END;
	l_habilitation := pack_habilitation.fhabili_me(to_char(l_codsg),p_userid);
	if l_habilitation='faux' then
		pack_global.recuperer_message(20360,'%s1', 'à la ligne bip '||p_pid, NULL, p_message);
	  	raise_application_error( -20360, p_message );
	end if;

      IF p_table = 'PRJ' THEN
      -- PPM 59288 : On récupère les valeurs précédentes pour les logs
        BEGIN
            SELECT icpi
            INTO l_icpi
            FROM ligne_bip
            WHERE pid = p_pid
            AND flaglock = p_flaglock;
          EXCEPTION
	            WHEN NO_DATA_FOUND THEN
              l_icpi :='';
        END;


--existant ppm 59288
  /*       BEGIN
            UPDATE ligne_bip
            SET icpi     = p_cod,
                flaglock = decode( TO_NUMBER(p_flaglock), 1000000, 0, p_flaglock + 1)
            WHERE pid    = p_pid
            AND flaglock = p_flaglock;

         EXCEPTION

            WHEN OTHERS THEN
                raise_application_error(-20997, SQLERRM);
         END;
*/
--fin existant

       --PPM 59288 : SI la Direction attachée au DP de ce projet autorise l'élargissement
          IF ( p_isDbs = FALSE )
          THEN
          --alors autoriser la mise à jour de toute ligne Bip saisie, en gardant les contrôles existants sur la ligne
         BEGIN
            UPDATE ligne_bip
            SET icpi     = p_cod,
                flaglock = decode( TO_NUMBER(p_flaglock), 1000000, 0, p_flaglock + 1)
            WHERE pid    = p_pid
            AND flaglock = p_flaglock;

         EXCEPTION

            WHEN OTHERS THEN
                raise_application_error(-20997, SQLERRM );
         END;
         -- on garde une traçabilité du projet modifié
         pack_ligne_bip.maj_ligne_bip_logs(p_pid, l_user, 'ICPI', TO_CHAR(l_icpi), p_cod, 'MAJ du projet');
         --on mémorise les lignes rattachées au DP
         p_lignes_ratt := p_lignes_ratt || p_pid || ', ';
     --PPM 59288 :debut
     --SINON (la Direction attachée au DP de ce projet n'autorise pas l'élargissement),
     --garder les contrôles existants sur la ligne, mais ne pas mettre à jour une ligne autre que GT1.
         ELSE
           BEGIN
            SELECT arctype into l_arctype
            FROM ligne_bip
            WHERE pid = p_pid;
          EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
             raise_application_error(-20997, SQLERRM );
          END;

          IF (l_arctype = 'T1') THEN
             BEGIN
                UPDATE ligne_bip
                SET icpi     = p_cod,
                    flaglock = decode( TO_NUMBER(p_flaglock), 1000000, 0, p_flaglock + 1)
                WHERE pid    = p_pid
                AND flaglock = p_flaglock;

             EXCEPTION

                WHEN OTHERS THEN
                    raise_application_error(-20997, SQLERRM );
             END;
              -- on garde une traçabilité du projet modifié
              pack_ligne_bip.maj_ligne_bip_logs(p_pid, l_user, 'ICPI', TO_CHAR(l_icpi), p_cod, 'MAJ du projet');
              --on mémorise les lignes rattachées au DP
              p_lignes_ratt := p_lignes_ratt || p_pid || ', ';
           ELSE
              --on mémorise les lignes non rattachées au DP
                  p_lignes_non_ratt := p_lignes_non_ratt || p_pid || ', ';
          END IF;
         END IF;

     --PPM 59288 : fin



      ELSIF p_table = 'APP' THEN
         BEGIN
            UPDATE ligne_bip
            SET airt     = p_cod,
                flaglock = decode( TO_NUMBER(p_flaglock), 1000000, 0, p_flaglock + 1)
            WHERE pid    = p_pid
            AND flaglock = p_flaglock;

         EXCEPTION

            WHEN OTHERS THEN
                raise_application_error(-20997, SQLERRM);
         END;

      ELSIF p_table = 'DP' THEN
         BEGIN
            UPDATE ligne_bip
            SET dpcode   = p_cod,
                flaglock = decode( TO_NUMBER(p_flaglock), 1000000, 0, p_flaglock + 1)
            WHERE pid    = p_pid
            AND flaglock = p_flaglock;

         EXCEPTION

            WHEN OTHERS THEN
                raise_application_error(-20997, SQLERRM);
         END;

      END IF;

      IF SQL%NOTFOUND THEN

         -- Rollback car on ne connait pas quel update ne marche pas

         ROLLBACK;

      ELSE

         COMMIT;
         p_compteur := p_compteur + 1;
         p_message := REPLACE( p_message, '%s1', p_pid||'   %s1' );

      END IF;

   END update_un_projet;


   PROCEDURE update_pcmratt_proj (p_table      IN  VARCHAR2,
                                  p_cod        IN  VARCHAR2,
                                  p_lib        IN  VARCHAR2,
                                  p_pid_1      IN  ligne_bip.pid%TYPE,
				  p_nom_1      IN  VARCHAR2,
                                  p_flaglock_1 IN  VARCHAR2,
                                  p_pid_2      IN  ligne_bip.pid%TYPE,
				  p_nom_2      IN  VARCHAR2,
                                  p_flaglock_2 IN  VARCHAR2,
                                  p_pid_3      IN  ligne_bip.pid%TYPE,
				  p_nom_3      IN  VARCHAR2,
                                  p_flaglock_3 IN  VARCHAR2,
                                  p_pid_4      IN  ligne_bip.pid%TYPE,
				  p_nom_4      IN  VARCHAR2,
                                  p_flaglock_4 IN  VARCHAR2,
                                  p_pid_5      IN  ligne_bip.pid%TYPE,
				  p_nom_5      IN  VARCHAR2,
                                  p_flaglock_5 IN  VARCHAR2,
                                  p_pid_6      IN  ligne_bip.pid%TYPE,
				  p_nom_6      IN  VARCHAR2,
                                  p_flaglock_6 IN  VARCHAR2,
                                  p_userid     IN  VARCHAR2,
                                  p_nbcurseur  OUT INTEGER,
                                  p_message    OUT VARCHAR2
                                 ) IS

      l_msg VARCHAR2(1024);
      l_total INTEGER := 0;
      l_lignes_ratt VARCHAR2(1024);--PPM 59288
      l_lignes_non_ratt VARCHAR2(1024);-- PPM 59288
      l_msg2 VARCHAR2(500);--PPM 59288
      l_message VARCHAR2(500);--PPM 59288
      l_dirprin NUMBER;--PPM 59288
      l_autoris_elargis BOOLEAN;--PPM 61695
      l_isDbs BOOLEAN;--PPM 59288
   BEGIN

     -- Positionner le nb de curseurs ==> 0
     -- Initialiser le message retour

     p_nbcurseur := 0;
     p_message := '';
     l_lignes_ratt := '';--PPM 59288
     l_lignes_non_ratt :='';--PPM 59288
     l_dirprin := null;
     -- Recuperer le message parametre

     IF p_table = 'DP' THEN
         pack_global.recuperer_message( 2060, '%s2', p_cod, NULL, l_msg);
     ELSIF p_table = 'APP' THEN
         pack_global.recuperer_message( 2083, '%s2', p_cod, NULL, l_msg);
     ELSIF p_table = 'PRJ' THEN
         pack_global.recuperer_message( 21288, '%s2', p_cod, NULL, l_msg);-- PPM 59288 : modification du message 2084 par 21288

       --PPM 59288 :debut requete pour savoir si la direction attachée au DP de ce projet autorise l'élargissement ou pas
         -- un seul appel ici est suffisant
          BEGIN
            SELECT dirprin into l_dirprin
            FROM dossier_projet dp, proj_info pi
            WHERE dp.dpcode = pi.icodproj
            AND pi.icpi = p_cod;
          EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
             raise_application_error(-20997, SQLERRM);
          END;
          --PPM 61695 :SI sur un DP la « Direction Bip principalement concernée » est absente, OU si aucun paramètre actif OBLIGATION-DP-IMMO / DEFAUT / <RR> n¿existe, OU si elle est présente et ne fait pas partie des Directions du paramètre Bip OBLIGATION-DP-IMMO / DEFAUT / <rr>, (Actif !!, on peut avoir plus qu¿un param applicatif actif ???), alors l¿élargissement de la notion de DP est autorisée, pour ce DP. On autorise d¿attacher tout type de ligne au DP.

          --PPM 59288 : SI la Direction attachée au DP de ce projet  autorise l'élargissement
          --l_isDbs := PACK_DOSSIER_PROJET.is_obligation_dbs(l_dirprin, l_message);
          --  ZAA : PPM 61695 :SI sur un DP la « Direction Bip principalement concernée » est absente, OU si aucun paramètre actif OBLIGATION-DP-IMMO / DEFAUT / <RR> n¿existe, OU si elle est présente et ne fait pas partie des Directions du paramètre Bip OBLIGATION-DP-IMMO / DEFAUT / <rr>, (Actif !!, on peut avoir plus qu¿un param applicatif actif ???), alors l¿élargissement de la notion de DP est autorisée, pour ce DP. On autorise d¿attacher tout type de ligne au DP.

          l_autoris_elargis :=not PACK_DOSSIER_PROJET.is_autoris_elargis(l_dirprin, l_message);
          -- l_autoris_elargis : variable à ajouter dans les paramètres de update_un_projet()
         -- PPM 59288 : fin
        
     END IF;

     -- 1er traitement
     if (p_pid_1!='' or p_pid_1 is not null) then
     	update_un_projet( p_cod, p_pid_1, p_flaglock_1, p_table, p_userid, l_total, l_msg, l_lignes_ratt, l_lignes_non_ratt,  l_autoris_elargis);
     end if;
     -- 2e traitement
     if (p_pid_2!='' or p_pid_2 is not null) then
    	update_un_projet( p_cod, p_pid_2, p_flaglock_2, p_table, p_userid, l_total, l_msg, l_lignes_ratt, l_lignes_non_ratt, l_autoris_elargis);
     end if;
     -- 3e traitement
     if (p_pid_3!='' or p_pid_3 is not null) then
     	update_un_projet( p_cod, p_pid_3, p_flaglock_3, p_table, p_userid, l_total, l_msg, l_lignes_ratt, l_lignes_non_ratt, l_autoris_elargis);
     end if;
     -- 4e traitement
     if (p_pid_4!='' or p_pid_4 is not null) then
     	update_un_projet( p_cod, p_pid_4, p_flaglock_4, p_table, p_userid, l_total, l_msg, l_lignes_ratt, l_lignes_non_ratt, l_autoris_elargis);
     end if;
     -- 5e traitement
     if (p_pid_5!='' or p_pid_5 is not null) then
     	update_un_projet( p_cod, p_pid_5, p_flaglock_5, p_table, p_userid, l_total,l_msg, l_lignes_ratt, l_lignes_non_ratt, l_autoris_elargis);
     end if;
     -- 6er traitement
     if (p_pid_6!='' or p_pid_6 is not null) then
     	update_un_projet( p_cod, p_pid_6, p_flaglock_6, p_table, p_userid, l_total, l_msg, l_lignes_ratt, l_lignes_non_ratt, l_autoris_elargis);
     end if;

     IF l_total > 0 THEN

      --PPM 59288 : début
        IF p_table = 'PRJ' THEN
          --Si aucune ligne Bip saisie n'a pu être validée
          IF NVL(l_lignes_ratt,'^') = '^' AND NVL(l_lignes_non_ratt,'^') <> '^' THEN
           pack_global.recuperer_message( 21290, '%s2', p_cod, NULL, l_msg);--PPM 59288 : Rattachement NON effectué
           p_message := REPLACE( l_msg, '%s1', l_lignes_non_ratt );
           --Si au moins 1 ligne a été correctement rattachée (pas de lignes non rattachées)
          ELSIF NVL(l_lignes_ratt,'^') <> '^' AND NVL(l_lignes_non_ratt,'^') = '^' THEN
           pack_global.recuperer_message( 21288, '%s2', p_cod, NULL, l_msg);--PPM 59288 Rattachement des lignes effectué
           p_message := REPLACE( l_msg, '%s1', l_lignes_ratt );
          --Si au moins 1 ligne a été correctement rattachée et s'il y a des lignes non rattachées
          ELSIF NVL(l_lignes_ratt,'^') <> '^' AND NVL(l_lignes_non_ratt,'^') <> '^' THEN
           pack_global.recuperer_message( 21288, '%s2', p_cod, NULL, l_msg);--PPM 59288 Rattachement des lignes effectué
           p_message := REPLACE( l_msg, '%s1', l_lignes_ratt );

           pack_global.recuperer_message( 21289, '%s2', p_cod, NULL, l_msg2);--PPM 59288 Rattachement des lignes NON effectué
           l_message := REPLACE( l_msg2, '%s1', l_lignes_non_ratt );
           p_message := p_message || '\n' || l_message;
          ELSE
         -- p_message := REPLACE( l_msg, '%s1', NULL );--en garde les contrôles existants sur la ligne
           pack_global.recuperer_message( 21288, '%s2', p_cod, NULL, l_msg);--PPM 59288 Rattachement des lignes effectué
           p_message := REPLACE( l_msg, '%s1', l_lignes_ratt );
          END IF;
          p_message := REPLACE( p_message, ',  ', ' ' );--on remplace la dernière virgule par espace
        --PPM 59288 : Fin
      ELSE
        p_message := REPLACE( l_msg, '%s1', NULL );

       END IF;

     ELSE

        pack_global.recuperer_message( 2061, '%s1', p_cod, NULL, l_msg);

     END IF;

  END update_pcmratt_proj;

   PROCEDURE select_a_pcmratt_proj (p_airt        IN application.airt%TYPE,
                                 p_userid         IN VARCHAR2,
                                 p_curapplication IN OUT applicationCurType,
                                 p_nbcurseur         OUT INTEGER,
                                 p_message           OUT VARCHAR2
                                ) IS


      l_msg VARCHAR2(1024);
      l_airt application.airt%TYPE;
      l_habilitation varchar2(10);

   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_nbcurseur := 1;
      p_message := '';

	-- Test pour savoir si le premier caractere de airt est un 'A'



      -- TEST pour savoir si p_airt = A0000

      IF p_airt = 'A0000' THEN
        pack_global.recuperer_message(20249, NULL, NULL, NULL, l_msg);
	  raise_application_error( -20249, l_msg );
      END IF;


      -- Attention ordre des colonnes doit correspondre a l ordre
      -- de declaration dans la table ORACLE (a cause de ROWTYPE)
      -- ou selectionner toutes les colonnes par *

      BEGIN
         OPEN p_curapplication FOR
              SELECT *
              FROM APPLICATION
              WHERE airt = p_airt;

      EXCEPTION
         WHEN OTHERS THEN
           raise_application_error( -20997, SQLERRM);

      END;

      -- en cas absence
      -- 'Le centre d'activité n'existe pas';

      pack_global.recuperer_message(2027, '%s1', p_airt, NULL, l_msg);
      p_message := l_msg;

   END select_a_pcmratt_proj;


   PROCEDURE select_p_pcmratt_proj (p_icpi         IN proj_info.icpi%TYPE,
                                    p_userid       IN VARCHAR2,
                                    p_curproj_info IN OUT proj_infoCurType,
                                    p_nbcurseur       OUT INTEGER,
                                    p_message         OUT VARCHAR2
                                   ) IS

       l_msg VARCHAR2(1024);
       l_habilitation varchar2(10);

   BEGIN

    -- Positionner le nb de curseurs ==> 1
    -- Initialiser le message retour

    p_nbcurseur := 1;
    p_message := '';

	-- Test pour savoir si le premier caractere de icpi est un 'P'
/*
	l_icpi := SUBSTR(p_icpi, 0, 1);
	IF (l_icpi != 'P') THEN
         pack_global.recuperer_message(20208, NULL, NULL, NULL, l_msg);
         raise_application_error( -20208, l_msg );
	END IF;
*/

        IF pack_proj_info.check_cod_proj(p_icpi) = 'FALSE' THEN
            Pack_Global.recuperer_message(20208, NULL, NULL, NULL, l_msg);
            RAISE_APPLICATION_ERROR( -20208, l_msg );
        END IF;

        -- TEST pour savoir si p_icpi = P0000
        IF p_icpi = 'P0000' THEN
          	pack_global.recuperer_message(20250, NULL, NULL, NULL, l_msg);
              raise_application_error( -20250, l_msg );
        END IF;

      -- Attention ordre des colonnes doit correspondre a l ordre
      -- de declaration dans la table ORACLE (a cause de ROWTYPE)
      -- ou selectionner toutes les colonnes par *

        BEGIN
            OPEN p_curproj_info FOR
                 SELECT *
                 FROM PROJ_INFO
                 WHERE icpi = p_icpi;

        EXCEPTION
           WHEN OTHERS THEN
              raise_application_error( -20997, SQLERRM);
        END;

        -- en cas absence
        -- 'Le projet n'existe pas';

        pack_global.recuperer_message(2035, '%s1', p_icpi, NULL, l_msg);
        p_message := l_msg;

    END select_p_pcmratt_proj;

END pack_pcmratt_proj;
/
