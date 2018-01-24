-- pack_liste_ca_ligne_bip PL/SQL
--
-- Créé le 01/12/2004 par PJO
-- Modifie le 01/07/2005 par PPR : ajout lister_ca_utilisateur
-- Modifie le 10/07/2005 par PPR : ajout lister_ca_niv0_utilisateur
-- Modifie le 10/27/2009 par YSB : ajout lister_ca_utilisateur_rtfe
-- Modifie le 16/11/2009 par YSB : ajout lister_ca_utilisateur_rtfe_ref et suppression de lister_ca_utilisateur_rtfe
-- YSB : 08/01/2010 : Fiche TD 876 - modification de la liste des centres d'activités (lister_ca_utilisateur_rtfe_ref)
-- ABA : 15/06/2010 : fiche 1010
--*******************************************************************

CREATE OR REPLACE PACKAGE pack_liste_ca_ligne_bip AS

   TYPE CA_ListeViewType IS RECORD	 (pid        repartition_ligne.pid%TYPE,
					  datdeb     VARCHAR2(7),
                                          datfin     VARCHAR2(7),
                                          codcamo    VARCHAR2(6),
                                          libcamo    centre_activite.clibrca%TYPE,
                                          clicode    repartition_ligne.clicode%TYPE,
                                          cliclib    client_mo.clilib%TYPE,
                                          tauxrep    VARCHAR2(8)
                                         );
   TYPE CA_listeCurType IS REF CURSOR RETURN CA_ListeViewType;
   
   TYPE RefCurTyp IS REF CURSOR;

   PROCEDURE lister_ca_ligne (p_pid     IN repartition_ligne.pid%TYPE,
                              p_userid  IN VARCHAR2,
                              p_curseur IN OUT CA_listeCurType
                             );

   TYPE CA_util_ListeViewType IS RECORD	 (codcamo    VARCHAR2(6),
                                          lib    VARCHAR2(40)
                                         );
   TYPE CA_util_listeCurType IS REF CURSOR RETURN CA_util_ListeViewType;

   PROCEDURE lister_ca_utilisateur ( p_userid  IN VARCHAR2,
               			p_curseur IN OUT CA_util_listeCurType
              );

   PROCEDURE lister_ca_niv0_utilisateur ( p_userid  IN VARCHAR2,
               			p_curseur IN OUT CA_util_listeCurType
              ); 

   PROCEDURE lister_ca_utilisateur_rtfe_ref ( p_ca_payeur  IN VARCHAR2,
                    p_curseur IN OUT RefCurTyp
              );                   

END pack_liste_ca_ligne_bip; 
/

CREATE OR REPLACE PACKAGE BODY pack_liste_ca_ligne_bip AS 
   
   PROCEDURE lister_ca_ligne( p_pid     IN repartition_ligne.pid%TYPE,
                              p_userid  IN VARCHAR2,
                              p_curseur IN OUT CA_listeCurType
                             ) IS
   BEGIN
       OPEN p_curseur FOR
             SELECT 	RTRIM(LTRIM(pid)) 		,
             		TO_CHAR(datdeb, 'MM/YYYY') 	,
             		TO_CHAR(datfin, 'MM/YYYY') 	,
             		TO_CHAR(rl.codcamo)		,
             		ca.clibrca			,
             		rl.clicode			,
             		cm.clilib			,
             		TO_CHAR(tauxrep, 'FM99999D00')
             FROM     repartition_ligne rl , centre_activite ca, client_mo cm
             WHERE    pid = p_pid
               AND    rl.codcamo = ca.codcamo
               AND    rl.clicode = cm.clicode (+)
	     ORDER BY datdeb desc, tauxrep;

   END lister_ca_ligne;

--
-- Liste les CA qui ont été déclarés dans le RTFE pour un utilisateur
-- ( On utilise entite_structure pour retrouver le libelle )
-- Utilisé dans les habilitations par référentiels
--
   PROCEDURE lister_ca_utilisateur ( p_userid  IN VARCHAR2,
               			p_curseur IN OUT CA_util_listeCurType
              ) IS

   l_ca_payeur VARCHAR2(255);

   BEGIN
      l_ca_payeur := pack_global.lire_globaldata(p_userid).ca_payeur;

      BEGIN

      -- Cas particulier si on a TOUS dans la liste des ca Payeurs , dans ce cas
      -- On affiche tous les CA rattachés aux clients

      if trim(upper(l_ca_payeur)) = 'TOUS' THEN

         OPEN  p_curseur FOR
         SELECT distinct e.codcamo,
         	to_char(e.codcamo)||' - '||nvl(e.liloes,'') lib
         FROM entite_structure e, client_mo c
         WHERE e.codcamo=c.codcamo
         AND c.codcamo is not null
	 ORDER BY 1;

       else
         OPEN  p_curseur FOR
	   SELECT distinct e.codcamo,
          	to_char(e.codcamo)||' - '||nvl(e.liloes,'') lib
           FROM entite_structure e, client_mo c
           WHERE e.codcamo=c.codcamo
           AND c.codcamo is not null
	   AND c.clicode IN (
	          SELECT clicoderatt FROM vue_clicode_hierarchie v, client_mo cl
	          WHERE v.clicode = cl.clicode
	          AND (INSTR(l_ca_payeur, cl.codcamo) > 0 )  )
	  ORDER BY 1;

       end if;

      EXCEPTION

          WHEN OTHERS THEN
             raise_application_error(-20997, SQLERRM);
      END;

   END lister_ca_utilisateur;

--
-- Liste les CA de niveau 0 qui ont été déclarés dans le RTFE pour un utilisateur
-- ( On utilise entite_structure pour retrouver le libelle )
-- Utilisé dans les habilitations par référentiels
--
   PROCEDURE lister_ca_niv0_utilisateur ( p_userid  IN VARCHAR2,
               			p_curseur IN OUT CA_util_listeCurType
              ) IS

   l_ca_payeur VARCHAR2(255);

   BEGIN
      l_ca_payeur := pack_global.lire_globaldata(p_userid).ca_payeur;

      BEGIN

      -- Cas particulier si on a TOUS dans la liste des ca Payeurs , dans ce cas
      -- On affiche tous les CA rattachés aux clients

      if trim(upper(l_ca_payeur)) = 'TOUS' THEN

         OPEN  p_curseur FOR
         SELECT distinct c.codcamo,
         	to_char(c.codcamo)||' - '||nvl(c.clibrca,'') lib
         FROM centre_activite c
         WHERE c.cdateferm is null
	 ORDER BY 1;

       else
         OPEN  p_curseur FOR
         SELECT distinct c.codcamo,
         	to_char(c.codcamo)||' - '||nvl(c.clibrca,'') lib
         FROM centre_activite c
         WHERE c.cdateferm is null
         AND ( (INSTR(l_ca_payeur, codcamo) > 0)
            OR (INSTR(l_ca_payeur, caniv1) > 0)
            OR (INSTR(l_ca_payeur, caniv2) > 0)
            OR (INSTR(l_ca_payeur, caniv3) > 0)
            OR (INSTR(l_ca_payeur, caniv4) > 0) )
	 ORDER BY 1;
       end if;

      EXCEPTION

          WHEN OTHERS THEN
             raise_application_error(-20997, SQLERRM);
      END;

   END lister_ca_niv0_utilisateur;
   
   --lister_ca_utilisateur_rtfe_ref : cette procédure est utilisée dans les sous menus : 
   -- stock ligne fi ; facturation interne des études et immobilisation des études des menu : client et reférentiel 
   PROCEDURE lister_ca_utilisateur_rtfe_ref ( p_ca_payeur  IN VARCHAR2,
               			p_curseur IN OUT RefCurTyp
              ) IS
    
   l_req VARCHAR2(32000);
   chaine_ca_payeur VARCHAR2(20000);
   l_ca_payeur VARCHAR2(10);
   l_compteur NUMBER;

   BEGIN
      BEGIN
      
        chaine_ca_payeur := p_ca_payeur; 
        l_compteur := 1 ;
        l_req := 'select * from
                        (';
                            
       if p_ca_payeur is not null THEN 
            if trim(upper(p_ca_payeur)) <> 'TOUS' THEN 
                
                while (length(chaine_ca_payeur) != 0) loop
                 
                 if (instr(chaine_ca_payeur,',') != 0) then
                      l_ca_payeur := substr(chaine_ca_payeur,0,instr(chaine_ca_payeur,',')-1);
                      chaine_ca_payeur := substr(chaine_ca_payeur,instr(chaine_ca_payeur,',')+1);
                 else
                    l_ca_payeur := chaine_ca_payeur;
                    chaine_ca_payeur := '';
                 end if;
                 
                 if (pack_global.recherche_niveau(l_ca_payeur) != 99) then

                 if (l_compteur != 1) then
                        l_req := l_req || ' UNION ';           
                 end if;
                 
                 if(pack_global.recherche_niveau(l_ca_payeur) = 0) then
                    l_req := l_req || ' select TO_CHAR(codcamo) codcamo, to_char(codcamo)||'' - ''||nvl(clibca,'''') lib
                                from centre_activite
                                WHERE codcamo in ('||l_ca_payeur||') ';               
                             else
                    l_req := l_req || ' select TO_CHAR('||l_ca_payeur||') codcamo, TO_CHAR('||l_ca_payeur||') lib
                                from dual ';                     
                           
                 end if;
                 
                l_compteur := l_compteur+1;
               end if;
               END LOOP;  
                   
            end if; 
       end if; 
         
      l_req := l_req || ') src
                        order by codcamo asc';
                                          
      if ((p_ca_payeur is not null) and  (trim(upper(p_ca_payeur)) <> 'TOUS') and (l_compteur != 1))  THEN
             OPEN  p_curseur FOR  l_req;
      -- YSB : pour éviter de retourner un curseur closed (qui génére des erreurs au niveau de java) j'ai ajouter ce bloc       
      else
             OPEN  p_curseur FOR 
                select TO_CHAR(codcamo) codcamo, to_char(codcamo)||' - '||nvl(clibca,'') 
                from centre_activite where codcamo in (-1);          
      end if;    
                   
      END;
      
   END lister_ca_utilisateur_rtfe_ref;
   
END pack_liste_ca_ligne_bip;
/





