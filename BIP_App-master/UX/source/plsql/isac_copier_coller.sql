-- CMA 14/01/2011 Ajout et conditionnement de la copie des affectations et du déplacement des consommés
-- CMA 07/02/2011 Fiche 852 Dans le cas du déplacement des consommés, suppressions des consommés de la sous-tache source
-- CMA 08/02/2011 852 Déplacement des consommés à partir du mois de l'année en cours dans tous les cas
-- CMA 09/02/2011 852 Pas de déplacement des consommés entre la mensuelle définitive de décembre et la clôture annuelle
-- CMA 11/02/2011 852 AJout de logs dans le cas de déplacement des consommés

CREATE OR REPLACE PACKAGE     pack_isac_copier_coller AS
       PROCEDURE insert_sstache (
                		p_pid_src       IN VARCHAR2,
                        p_pid_dest      IN VARCHAR2,
                        p_sous_tache    IN VARCHAR2,
                		p_tache         IN VARCHAR2,
                        p_userid        IN VARCHAR2,
                        p_affecter      IN VARCHAR2,
                        p_mois          IN VARCHAR2,
                		p_message     	OUT VARCHAR2
                        );
END pack_isac_copier_coller;
/


CREATE OR REPLACE PACKAGE BODY     pack_isac_copier_coller AS
       PROCEDURE insert_sstache (
                                p_pid_src       IN VARCHAR2,
                                p_pid_dest      IN VARCHAR2,
                                p_sous_tache    IN VARCHAR2,
                    		    p_tache         IN VARCHAR2,
                                p_userid        IN VARCHAR2,
                                p_affecter      IN VARCHAR2,
                                p_mois          IN VARCHAR2,
                    		    p_message       OUT VARCHAR2
                        ) IS
       l_pos1       NUMBER(10);
       l_pos2       NUMBER(10);
       l_etape      NUMBER(10);
       l_tache      NUMBER(10);
       l_etape_dest NUMBER(10);
       l_tache_dest NUMBER(10);
       l_sous_tache NUMBER(10);

       l_acst isac_sous_tache.ACST%type;
       l_acta isac_tache.ACTA%type;
       -- libellé de la sous-tache
       l_asnom isac_sous_tache.ASNOM%type;
       l_aist isac_sous_tache.AIST%type;
       l_asta isac_sous_tache.ASTA%type;
       l_adeb isac_sous_tache.ADEB%type;
       l_afin isac_sous_tache.AFIN%type;
       l_ande isac_sous_tache.ANDE%type;
       l_anfi isac_sous_tache.ANFI%type;
       l_adur isac_sous_tache.ADUR%type;

       l_libtache isac_tache.LIBTACHE%type;

       l_sstache_max binary_integer;
       l_sstache_count binary_integer;
       l_sstache_seq number;
       l_max_stache NUMBER(10);
       l_new_stache NUMBER(10);
       l_ident isac_affectation.IDENT%type;
       l_annee NUMBER(4);
       l_dmensuelle DATE;
       l_dcloture DATE;
       
       l_user VARCHAR2(60);

       BEGIN
       
       l_user:=pack_global.LIRE_GLOBALDATA(p_userid).idarpege;

       --Dans le cas d'une copie avec déplacement des consommés
        -- On vérifie que l'on est pas dans la période de neutralisation
        -- C'est-à-dire entre la mensuelle définitive de décembre et la clôture annuelle
    	BEGIN
        IF (p_affecter = 'AVEC') THEN

            SELECT  c.cmensuelle INTO l_dmensuelle
            FROM CALENDRIER c
            WHERE c.calanmois = to_date('12/'||to_char(to_number(to_char(SYSDATE,'YYYY'))-1),'MM/YYYY');

            SELECT  c.ccloture INTO l_dcloture
            FROM CALENDRIER c
            WHERE c.calanmois = to_date('01/'||to_char(to_number(to_char(SYSDATE,'YYYY'))),'MM/YYYY');

        	IF (l_dmensuelle is not null and l_dcloture is not null and to_date(to_char(SYSDATE,'DD/MM/YYYY'),'DD/MM/YYYY') > l_dmensuelle AND to_date(to_char(SYSDATE,'DD/MM/YYYY'),'DD/MM/YYYY') <= l_dcloture) THEN
        		--Période de neutralisation. Opération annulée
        		Pack_Isac.recuperer_message(20033, NULL,NULL, NULL,p_message);
                       	RAISE_APPLICATION_ERROR( -20033,p_message);
        	END IF;
    
        END IF;
    	EXCEPTION
    		WHEN NO_DATA_FOUND THEN NULL;

    	END;
    
        p_message:='';
        -- p_sous_tache est de la forme "etape-tache-sous_tache"
	-- si c est vide
		if p_sous_tache=' ' then
		pack_global.recuperer_message( 20043, NULL, NULL, NULL, p_message) ;
                raise_application_error(-20043, p_message);
		end if;

        l_pos1  := INSTR(p_sous_tache,'-', 1, 1);
        l_pos2  := INSTR(p_sous_tache,'-', 1, 2);
        l_etape := TO_NUMBER(SUBSTR(p_sous_tache, 1, l_pos1-1));
        l_tache := TO_NUMBER( SUBSTR(p_sous_tache, l_pos1+1, l_pos2 - l_pos1 - 1));
        l_sous_tache := TO_NUMBER( SUBSTR(p_sous_tache, l_pos2+1, LENGTH(p_sous_tache) - l_pos2+1));


        -- p_tache est de la forme "etape-tache"

	-- si c est vide
	if p_tache=' ' then
	pack_global.recuperer_message( 20042, '%s1', p_pid_dest, NULL, p_message) ;
             raise_application_error(-20042, p_message);
	end if;
        l_pos1       := INSTR(p_tache, '-', 1, 1);
        l_etape_dest := TO_NUMBER(SUBSTR(p_tache, 1, l_pos1-1));
        l_tache_dest := TO_NUMBER( SUBSTR(p_tache, l_pos1+1, LENGTH(p_tache) - l_pos1+1));



        --on recupere le numero de tache l_acta
        select acta into l_acta
        from isac_tache
        where PID =  p_pid_dest
            and etape=l_etape_dest
	    and tache=l_tache_dest;

            -- on compte le nombre de sous taches
            select count(*) into l_sstache_count from isac_sous_tache st
            where st.PID =  p_pid_dest
            and st.etape=l_etape_dest
	    and st.tache=l_tache_dest;


            --cas particulier : il existe une sous tache de numero 99, on récupère le message d'erreur
            select max(to_number(acst)) into l_max_stache
            from isac_sous_tache st
            where st.PID =  p_pid_dest
            and st.etape=l_etape_dest
	    and st.tache=l_tache_dest;

            if (l_sstache_count >=   99) or (l_max_stache = 99) then
               --le max (99) de sous-tâches autorisées pour la tâche %s1 est atteint.
             pack_global.recuperer_message( 20041, '%s1', l_acta, NULL, p_message) ;
             raise_application_error(-20041, p_message);


            end if;



       if (l_tache_dest IS NULL OR l_sous_tache IS NULL) then
            -- Dernier identifiant atteint
                pack_isac.recuperer_message(20014, null,null,null, p_message);
            raise_application_error(-20014, p_message);
       end if;

      --calcul du numéro de sous-tache
        select NVL(MAX(TO_NUMBER(acst)),0)+1 into l_new_stache
	from isac_sous_tache
	where pid=p_pid_dest
	and etape=l_etape_dest
	and tache=l_tache_dest;

	l_acst := to_char(l_new_stache,'FM00');

       select libtache into l_libtache
       from isac_tache where tache=l_tache_dest;

       select  ASNOM, AIST, ASTA, ADEB,
              AFIN, ANDE, ANFI, ADUR
       into  l_asnom, l_aist, l_asta, l_adeb,
            l_afin, l_ande, l_anfi, l_adur
       from isac_sous_tache ist
       where ist.SOUS_TACHE = l_sous_tache;


        insert into isac_sous_tache (sous_tache, pid, etape, tache, acst, asnom, aist,
                                     asta, adeb, afin, ande, anfi, adur, flaglock)
        values (SEQ_SOUS_TACHE.nextval, p_pid_dest, l_etape_dest, l_tache_dest, l_acst, l_asnom, l_aist,
                l_asta, l_adeb, l_afin, l_ande, l_anfi, l_adur, 0
               );


        IF(p_affecter='OUI' OR p_affecter='AVEC')THEN

                    -- copier les affectations de la ligne vers une ligne vide
            	insert into isac_affectation (	SOUS_TACHE,
            					IDENT ,
            					PID     ,
            					ETAPE  ,
            					TACHE          )
            	(select sous_tache.sous_tache,
            		affect.ident,
            		sous_tache.pid,
            		sous_tache.etape,
            		sous_tache.tache
            	from isac_affectation affect,isac_sous_tache sous_tache
            	where  affect.pid=p_pid_src
            	and affect.etape=l_etape
            	and affect.tache=l_tache
            	and affect.sous_tache=l_sous_tache
            	and sous_tache.pid=p_pid_dest
            	and sous_tache.etape=l_etape_dest
            	and sous_tache.tache=l_tache_dest
            	and sous_tache.acst=l_acst);
        END IF;
        
        IF(p_affecter = 'AVEC')THEN
        
           IF(TO_NUMBER(p_mois)>TO_NUMBER(TO_CHAR(SYSDATE,'MM')))THEN
            l_annee := TO_CHAR(TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-1);
         ELSE
            l_annee := TO_CHAR(SYSDATE,'YYYY');
         END IF;
        
        
        INSERT INTO ISAC_CONSOMME ( IDENT,	
                                     SOUS_TACHE,
                                     CDEB,
                                     CUSAG,
         							 PID,
									 ETAPE,
									 TACHE)
        (SELECT affect.ident,  
               sous_tache.sous_tache,
		       c1.cdeb,
               c1.cusag,
		       affect.pid,
			   affect.ETAPE,
			   affect.TACHE
	    FROM ISAC_CONSOMME c1, 
             ISAC_AFFECTATION affect,
             ISAC_SOUS_TACHE sous_tache
	    WHERE   affect.pid=p_pid_dest
            	and affect.etape=l_etape_dest
            	and affect.tache=l_tache_dest
                and affect.sous_tache = sous_tache.sous_tache
                and sous_tache.pid=p_pid_dest
            	and sous_tache.etape=l_etape_dest
            	and sous_tache.tache=l_tache_dest
            	and sous_tache.acst=l_acst
                and c1.ident = affect.ident
                and c1.sous_tache = l_sous_tache
                AND to_number(to_char(c1.cdeb,'MM'))>=TO_NUMBER(p_mois));
                
        DELETE FROM ISAC_CONSOMME c1
        WHERE c1.sous_tache = l_sous_tache
           AND to_number(to_char(c1.cdeb,'MM'))>=TO_NUMBER(p_mois);
           
                      
           pack_ligne_bip.MAJ_LIGNE_BIP_LOGS(p_pid_src,l_user,'Consommés','des conso sont présents','des conso sont supprimés','Déplacement des consommés à compter du mois '||LPAD(p_mois,2,'0')||',vers la ligne '||p_pid_dest);
           pack_ligne_bip.MAJ_LIGNE_BIP_LOGS(p_pid_dest,l_user,'Consommés','','des conso sont créés','Déplacement des consommés à compter du mois '||LPAD(p_mois,2,'0')||',en provenance de la ligne '||p_pid_src);
        END IF;
    
    
	commit;



        --message 20982, 'La sous-tâche %s1 a été affectéé à la ligne bip %s2'
        --pack_global.recuperer_message( 20982, '%s1', rtrim(l_asnom), '%s2', p_pid_dest, NULL,  p_message);

        pack_global.recuperer_message( 20982, '%s1', rtrim(l_asnom), '%s2', l_libtache, '%s3', p_pid_dest, NULL,  p_message) ;

EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
        -- la sous-tâche %s1 a déjà été affectée à la ligne bip %s2
            pack_global.recuperer_message( 20040, '%s1', rtrim(l_asnom), '%s2', l_libtache,null, p_message);
            raise_application_error(-20040, p_message);
       -- WHEN OTHERS THEN
         --  rollback;
          --  raise_application_error(-20997, sqlerrm);



       END insert_sstache;


END pack_isac_copier_coller;
/


