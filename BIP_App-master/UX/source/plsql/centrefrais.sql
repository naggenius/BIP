-- pack_centrefrais PL/SQL
--
-- crée par NBM le 10/01/2001
--
-- Modifié par Pierre JOSSE le 13/06/2003  : Migration DPG sur 7 caracteres = > modifs formats de codsg et bddpg
--             NBM le 16/06/2003 : remplacer p_bouton par p_mode, suppression des paramètres inutiles
--
-- Modifier par BAA le 28/06/05 : fiche 212 ajout du code filliale à la table centre de frais
--
-- Gestion des centres de frais
--
-- **********************************************************************




CREATE OR REPLACE PACKAGE pack_centrefrais AS

   TYPE centrefrais_RecType IS RECORD (CODCFRAIS    VARCHAR2(3),
                                       LIBCFRAIS    VARCHAR2(30),
									   FILCODE      FILIALE_CLI.FILCODE%TYPE,
									   FILSIGLE     FILIALE_CLI.FILSIGLE%TYPE
									   );

   TYPE centrefrais_CurType IS REF CURSOR RETURN centrefrais_RecType;

PROCEDURE select_centrefrais( 	p_mode    IN VARCHAR2,
				p_codcfrais IN VARCHAR2,
				p_userid    IN VARCHAR2,
				p_curselect IN  OUT centrefrais_CurType,
		                p_nbcurseur     OUT INTEGER,
				p_message       OUT VARCHAR2
                           );

 PROCEDURE insert_centrefrais(	p_codcfrais IN VARCHAR2,
				p_libcfrais IN centre_frais.libcfrais%TYPE,
				p_filcode   IN filiale_cli.filcode%TYPE,
				p_nbcurseur     OUT INTEGER,
				p_message       OUT VARCHAR2
				);

PROCEDURE update_centrefrais( 	p_codcfrais IN VARCHAR2,
				p_libcfrais     IN  VARCHAR2,
				p_filcode       IN  VARCHAR2,
				p_nbcurseur     OUT INTEGER,
				p_message       OUT VARCHAR2
				);


 PROCEDURE delete_centrefrais( 	p_codcfrais IN VARCHAR2,
				p_libcfrais IN centre_frais.libcfrais%TYPE,
				p_nbcurseur     OUT INTEGER,
				p_message       OUT VARCHAR2
				);

 PROCEDURE update_struct_info(  p_mode       IN VARCHAR2,
				p_codcfrais    IN VARCHAR2,
				p_libcfrais    IN VARCHAR2,
				p_bddpg        IN VARCHAR2,
				p_habilitation IN VARCHAR2,
				p_userid       IN VARCHAR2,
				p_nbcurseur      OUT INTEGER,
				p_message        OUT VARCHAR2
				);

  PROCEDURE delete_struct_info(	p_mode    IN VARCHAR2,
				p_codcfrais IN VARCHAR2,
				p_libcfrais IN VARCHAR2,
				p_bddpg     IN VARCHAR2,
				p_userid    IN VARCHAR2,
			        p_nbcurseur     OUT INTEGER,
				p_message       OUT VARCHAR2
                           );



END pack_centrefrais;
/




CREATE OR REPLACE PACKAGE BODY pack_centrefrais AS

 PROCEDURE select_centrefrais( 	p_mode    IN VARCHAR2,
				p_codcfrais IN VARCHAR2,
				p_userid    IN VARCHAR2,
				p_curselect IN  OUT centrefrais_CurType,
		        p_nbcurseur     OUT INTEGER,
				p_message       OUT VARCHAR2
                           ) IS
l_exist number;

 BEGIN


       	BEGIN
		select 1 into l_exist
		from centre_frais
		where codcfrais= to_number(p_codcfrais);


   	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			IF p_mode!='insert' THEN
				-- le centre de frais n'existe pas
				pack_global.recuperer_message(20344,NULL, NULL, NULL,  p_message);
            			raise_application_error(-20344 ,  p_message );
			ELSE
				NULL;
			END IF;
   	END;

	IF l_exist=1 then
		IF p_mode='insert' then
		-- le centre de frais existe déjà
			pack_global.recuperer_message(20343,NULL, NULL, NULL,  p_message);
            		raise_application_error(-20343 ,  p_message );
		END IF;
	END IF;

  	OPEN p_curselect FOR
	SELECT to_char(codcfrais),
	       cf.libcfrais libcfrais,
	       f.filcode filcode,
	       f.filsigle filsigle
           FROM centre_frais cf, filiale_cli f
           WHERE to_char(cf.codcfrais)=p_codcfrais
           AND f.filcode=cf.FILCODE;
	

 END select_centrefrais ;

-- =====================================================================================
-- * * * * * * * * * * * * * CREATION D'UN CENTRE DE FRAIS * * * * * * * * * * * * * * *
-- =====================================================================================

PROCEDURE insert_centrefrais(	p_codcfrais IN VARCHAR2,
				p_libcfrais IN centre_frais.libcfrais%TYPE,
				p_filcode   IN filiale_cli.filcode%TYPE,
				p_nbcurseur     OUT INTEGER,
				p_message       OUT VARCHAR2
				)  IS



 BEGIN

	insert into centre_frais (codcfrais,libcfrais,filcode)
	values (to_number(p_codcfrais),
		    p_libcfrais,
		    p_filcode
	       );
        commit;
	-- Message Centre de frais crée
       pack_global.recuperer_message(20340,'%s1', p_codcfrais, NULL, p_message);


 EXCEPTION
	  WHEN DUP_VAL_ON_INDEX THEN
            pack_global.recuperer_message(20343,NULL, NULL, NULL,  p_message);
            raise_application_error(-20343 ,  p_message );


 END insert_centrefrais;


-- =====================================================================================
-- * * * * * * * * * * * * MODIFICATION D'UN CENTRE DE FRAIS * * * * * * * * * * * * * *
-- =====================================================================================

 PROCEDURE update_centrefrais( 	p_codcfrais IN VARCHAR2,
				p_libcfrais     IN VARCHAR2,
				p_filcode       IN VARCHAR2,
				p_nbcurseur     OUT INTEGER,
				p_message       OUT VARCHAR2
				) IS
 BEGIN
	update centre_frais
	set libcfrais = p_libcfrais, filcode = p_filcode
	where codcfrais = to_number(p_codcfrais);

        commit;
	-- Message Centre de frais modifié
       pack_global.recuperer_message(20341,'%s1', p_codcfrais, NULL, p_message);



 END update_centrefrais;

-- =====================================================================================
-- * * * * * * * * * * * * * SUPPRESSION D'UN CENTRE DE FRAIS * * * * * * * * * * * * *
-- =====================================================================================

 PROCEDURE delete_centrefrais( 	p_codcfrais IN VARCHAR2,
				p_libcfrais IN centre_frais.libcfrais%TYPE,
				p_nbcurseur     OUT INTEGER,
				p_message       OUT VARCHAR2
				) IS
 BEGIN

	delete compo_centre_frais
	where codcfrais = to_number(p_codcfrais);

	update struct_info set scentrefrais=NULL
	where scentrefrais=to_number(p_codcfrais);

	delete centre_frais
	where codcfrais = to_number(p_codcfrais);

	-- Message Centre de frais supprimé
       pack_global.recuperer_message(20342,'%s1', p_codcfrais, NULL, p_message);

  END delete_centrefrais;
-- =====================================================================================
-- * * * * * * * * RATTACHEMENT D'UN BDDPG A UN CENTRE DE FRAIS * * * * * * * * * * * *
-- =====================================================================================

PROCEDURE update_struct_info(   p_mode       IN VARCHAR2,
				p_codcfrais    IN VARCHAR2,
				p_libcfrais    IN VARCHAR2,
				p_bddpg        IN VARCHAR2,
				p_habilitation IN VARCHAR2,
				p_userid       IN VARCHAR2,
				p_nbcurseur      OUT INTEGER,
				p_message        OUT VARCHAR2
				) IS
 l_exist number;
 l_autre varchar2(10);
 l_codbddpg varchar2(15);
 l_lib varchar2(30);
 l_reste varchar2(11);
 l_codcfrais number;

 BEGIN

  -- ================================================================================================
  --            				NIVEAU BRANCHE
  -- ================================================================================================
    IF p_habilitation='br' THEN
	-- ******************************************************
	-- Existence de la branche
	-- ******************************************************
	l_codbddpg := lpad(p_bddpg,2,0);

	BEGIN
		select 1 into l_exist
		from struct_info s, directions d, branches b
		where s.coddir=d.coddir
		and d.codbr=b.codbr
		and b.codbr=to_number(p_bddpg)
		and rownum<2 ;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN -- Aucun code DPG pour la branche
			pack_global.recuperer_message(20349,'%s1','branche', '%s2',l_codbddpg, NULL, p_message);
            		raise_application_error(-20349 ,  p_message );

	END;

	BEGIN
		select  substr(codbddpg,3,9), codcfrais into l_reste,l_codcfrais
		from compo_centre_frais
		where substr(codbddpg,1,2)=l_codbddpg
		and rownum<2;

	EXCEPTION
		WHEN NO_DATA_FOUND THEN null;
	END;

	IF l_reste='000000000' THEN
		-- -------------------------------------------------
		-- la branche est déjà rattachée au centre de frais
		-- ------------------------------------------------
		IF l_codcfrais=to_number(p_codcfrais) THEN
			pack_global.recuperer_message(20346,'%s1','branche','%s2',lpad(p_bddpg,2,0),
							'%s3', p_codcfrais, NULL, p_message);
            		raise_application_error(-20346 ,  p_message );
		ELSE
		-- ----------------------------------------------------
		-- la branche est rattachée à un autre centre de frais
		-- ----------------------------------------------------
			pack_global.recuperer_message(20346,'%s1','branche','%s2',lpad(p_bddpg,2,0),
							'%s3', to_char(l_codcfrais), NULL, p_message);
            		raise_application_error(-20346 ,  p_message );
		END IF;
	ELSE
		IF l_reste is not null THEN

			-- msg : Si vous voulez une habilitation niveau branche,
			-- il faudra d''abord supprimer les BDPPG  appartenant à cette branche
		     	pack_global.recuperer_message(20348,'%s1','branche','%s2',
				'directions, départements, pôles, groupes','%s3','cette branche', NULL, p_message);
            		raise_application_error(-20348 ,  p_message );

		END IF;
	END IF;



	-- **********************************************************
	-- Mise à jour des tables COMPO_CENTRE_FRAIS et STRUCT_INFO
 	-- **********************************************************
	BEGIN

		insert into compo_centre_frais
		 (select to_number(p_codcfrais),
				lpad(p_bddpg,2,0)||'000000000',
				'O',
				'br',
				libbr
		 from branches
	         where codbr=to_number(p_bddpg)
			);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
            	pack_global.recuperer_message(20346,'%s1','branche','%s2',lpad(p_bddpg,2,0),
							'%s3', p_codcfrais, NULL, p_message);
            	raise_application_error(-20346 ,  p_message );

	END;
       		update struct_info
		set scentrefrais=to_number(p_codcfrais)
		where codsg in (select s.codsg
				from struct_info s, directions d
				where s.coddir=d.coddir
				and  d.codbr=to_number(p_bddpg));

  -- ================================================================================================
  --            				NIVEAU DIRECTION
  -- ================================================================================================
    ELSIF p_habilitation='dir' THEN
	-- ********************************************
	-- Existence de DPG dans la direction
	-- ********************************************
	BEGIN
		select 1 into l_exist
		from struct_info s, directions d
		where s.coddir=d.coddir
		and d.coddir=to_number(p_bddpg)
		and rownum<2 ;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN -- Aucun code DPG pour la direction
			pack_global.recuperer_message(20349,'%s1','direction','%s2',lpad(p_bddpg,2,0), NULL, p_message);
            		raise_application_error(-20349 ,  p_message );

	END;


	-- *****************************************************************************************
	-- Vérifions qu'il n'y a pas un niveau d'habilitation superieur à la direction ie niveau branche
	-- ******************************************************************************************
	BEGIN
		select codbddpg,codcfrais into l_codbddpg,l_codcfrais
		from compo_centre_frais c,struct_info s, directions d
		where
		 s.coddir=d.coddir
	       	and d.coddir=to_number(p_bddpg)
		and (( substr(codbddpg,1,2)=lpad(d.codbr,2,0) and codhabili='br') or
		      (	substr(codbddpg,1,4)=lpad(d.codbr,2,0)||lpad(s.coddir,2,0) and codhabili='dir')   )
		and rownum<2;

	EXCEPTION
			WHEN NO_DATA_FOUND THEN null;


	END ;
	IF l_codbddpg is not null then
		-- La direction est déjà rattachée au centre de frais
		pack_global.recuperer_message(20346,'%s1','direction','%s2',p_bddpg,
							'%s3', l_codcfrais, NULL, p_message);
		raise_application_error(-20346, p_message);
	END IF;
	l_codbddpg:=null;
       -- *****************************************************************************************
	-- Vérifions qu'il n'y a pas un niveau d'habilitation inférieur à la direction (dpt,pôle,groupe)
	-- ******************************************************************************************
	BEGIN
		select substr(codbddpg,5,7),codcfrais into l_codbddpg, l_codcfrais
		from compo_centre_frais c,struct_info s, directions d
		where s.coddir=d.coddir
	       	and d.coddir=to_number(p_bddpg)
		and substr(codbddpg,1,4)=lpad(d.codbr,2,0)||lpad(d.coddir,2,0)
		and rownum<2;

	EXCEPTION
		WHEN NO_DATA_FOUND THEN null;
	END;
	IF l_codbddpg='0000000' THEN
		-- La direction est déjà rattachée au centre de frais
		pack_global.recuperer_message(20346,'%s1','direction','%s2',p_bddpg,
							'%s3', p_codcfrais, NULL, p_message);
		raise_application_error(-20346, p_message);
	ELSE
		IF l_codbddpg is not null THEN
			-- msg : Si vous voulez une habilitation niveau direction,
			-- il faudra d''abord supprimer les BDDPG appartenant à cette direction
		     	pack_global.recuperer_message(20348,'%s1','direction','%s2','départements, pôles, groupes',
								'%s3','cette direction', NULL, p_message);
            		raise_application_error(-20348 ,  p_message );

		END IF;
	END IF;

	-- **********************************************************
	-- Mise à jour des tables COMPO_CENTRE_FRAIS et STRUCT_INFO
 	-- **********************************************************
	insert into compo_centre_frais
		(select to_number(p_codcfrais),
			lpad(d.codbr,2,0)||lpad(p_bddpg,2,0)||'0000000',
			'O',
			'dir',
			libbr||'/'||libdir
		 from directions d,branches b
	         where d.codbr=b.codbr
	         and coddir=to_number(p_bddpg)
			);

       	update struct_info
	set scentrefrais=to_number(p_codcfrais)
	where codsg in (select s.codsg
			from struct_info s, directions d
			where s.coddir=d.coddir
			and  d.coddir=to_number(p_bddpg));

  -- ================================================================================================
  --            				NIVEAU DEPARTEMENT
  -- ================================================================================================
    ELSIF p_habilitation='dpt' THEN
	-- Remarque : p_bddpg = topfer||coddep||coddir

	-- *****************************************************************************************
	-- Vérifions qu'il n'y a pas un niveau d'habilitation superieur au département (branche,direction)
	-- ******************************************************************************************

	BEGIN
		select codbddpg, codcfrais into l_codbddpg, l_codcfrais
		from compo_centre_frais c,struct_info s, directions d
		where
 		 s.coddir=d.coddir
	       	and s.coddep=to_number(substr(p_bddpg,2,3))
		and c.topfer=substr(p_bddpg,1,1)
		and s.coddir=substr(p_bddpg,5,2)
 		and( ( substr(codbddpg,1,2)=lpad(d.codbr,2,0) and codhabili='br') or
			(substr(codbddpg,1,4)=lpad(d.codbr,2,0)||lpad(s.coddir,2,0)  and codhabili='dir') or
			(substr(codbddpg,1,7)=lpad(d.codbr,2,0)||lpad(s.coddir,2,0)||lpad(s.coddep,3,0) and codhabili='dpt' ))
		and rownum<2;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN NULL;
	END;
	IF l_codbddpg is not null THEN

		-- Le département est déjà rattaché au centre de frais
		pack_global.recuperer_message(20345,'%s1','département','%s2',substr(p_bddpg,2,3),
							'%s3', l_codcfrais, NULL, p_message);
		raise_application_error(-20345, p_message);

	END IF;

	l_codbddpg:=null;
	-- *****************************************************************************************
	-- Vérifions qu'il n'y a pas un niveau d'habilitation inférieur au département (pole,groupe)
	-- ******************************************************************************************
	BEGIN
		select substr(codbddpg,8,4) into l_codbddpg
		from compo_centre_frais c,struct_info s, directions d
		where  s.coddir=d.coddir
	       	and s.coddep=to_number(substr(p_bddpg,2,3))
		and substr(codbddpg,1,7)=lpad(d.codbr,2,0)||lpad(s.coddir,2,0)||lpad(s.coddep,3,0)
		and c.topfer=substr(p_bddpg,1,1)
		and s.coddir=substr(p_bddpg,5,2)
		and rownum<2;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN NULL;
	END;
	IF l_codbddpg is not null then
		-- msg : Si vous voulez une habilitation niveau département,
		-- il faudra d''abord supprimer les BDDPG appartenant à ce département
		pack_global.recuperer_message(20348,'%s1','département','%s2','pôles, groupes ',
								'%s3','ce département', NULL, p_message);
            	raise_application_error(-20348 ,  p_message );

	END IF;

	-- **********************************************************
	-- Mise à jour des tables COMPO_CENTRE_FRAIS et STRUCT_INFO
 	-- **********************************************************
	insert into compo_centre_frais
		(select distinct to_number(p_codcfrais),
			lpad(d.codbr,2,0)||lpad(s.coddir,2,0)||lpad(substr(p_bddpg,2,3),3,0)||'0000',
			s.topfer,
			'dpt',
			b.libbr||'/'||d.libdir||'/'||s.sigdep
		from struct_info s, directions d, branches b
		where s.coddir=d.coddir
	       	and d.codbr=b.codbr
		and coddep=to_number(substr(p_bddpg,2,3))
		and  topfer=substr(p_bddpg,1,1)
		and s.coddir=substr(p_bddpg,5,2)
				);

        update struct_info
	set scentrefrais=to_number(p_codcfrais)
	where coddep=to_number(substr(p_bddpg,2,3))
	and topfer=substr(p_bddpg,1,1)
	and coddir=substr(p_bddpg,5,2);

  -- ================================================================================================
  --           					 NIVEAU POLE
  -- ================================================================================================
    ELSIF p_habilitation='pole' THEN
	-- Remarque : p_bddpg = topfer||coddep||codpole||coddir
	-- *****************************************************************************************
	-- Vérification qu'il n'y a pas un niveau d'habilitation superieur au pôle
	-- *****************************************************************************************
	BEGIN
		select codbddpg ,codcfrais into l_codbddpg,l_codcfrais
		from compo_centre_frais c,struct_info s, directions d
		where
		 s.coddir=d.coddir
	       	and  substr(lpad(codsg,7,0),1,5)=substr(p_bddpg,2,5)
		and s.coddir=substr(p_bddpg,7,2)
		and c.topfer=substr(p_bddpg,1,1)
		and (   ( substr(codbddpg,1,2)=lpad(d.codbr,2,0) and codhabili='br') or
			(substr(codbddpg,1,4)=lpad(d.codbr,2,0)||lpad(s.coddir,2,0)  and codhabili='dir') or
			(substr(codbddpg,1,7)=lpad(d.codbr,2,0)||lpad(s.coddir,2,0)||substr(p_bddpg,2,3) and codhabili='dpt') or
 			( substr(codbddpg,1,9)=lpad(d.codbr,2,0)||lpad(s.coddir,2,0)||substr(p_bddpg,2,5) and codhabili='pole'))
		and rownum<2;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN null;

	END;
	IF l_codbddpg is not null then
		-- Le pôle est déjà rattaché au centre de frais
		pack_global.recuperer_message(20345,'%s1','pôle','%s2',substr(p_bddpg,2,5),
							'%s3', l_codcfrais, NULL, p_message);
		raise_application_error(-20345,p_message);
	END IF;
	l_codbddpg:=null;
	-- *****************************************************************************************
	-- Vérification qu'il n'y a pas un niveau d'habilitation inférieur au pôle (groupe)
	-- *****************************************************************************************
	BEGIN
		select codbddpg into l_codbddpg
		from compo_centre_frais c,struct_info s, directions d
		where
 		substr(c.codbddpg,1,9)=lpad(d.codbr,2,0)||lpad(s.coddir,2,0)||substr(p_bddpg,2,5)
		and s.coddir=d.coddir
	       	and  substr(lpad(codsg,7,0),1,5)=to_number(substr(p_bddpg,2,5))
		and s.coddir=substr(p_bddpg,7,2)
		and c.topfer=substr(p_bddpg,1,1)
		and rownum<2;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN null;
	END;
	IF l_codbddpg is not null then
	-- msg : Si vous voulez une habilitation niveau pôle,
		-- il faudra d''abord supprimer les BDDPG appartenant à ce pôle
		pack_global.recuperer_message(20348,'%s1','pôle','%s2','groupes',
								'%s3','ce pôle', NULL, p_message);
            	raise_application_error(-20348 ,  p_message );

	END IF;


	-- **********************************************************
	-- Mise à jour des tables COMPO_CENTRE_FRAIS et STRUCT_INFO
 	-- **********************************************************

	update struct_info
	set scentrefrais=to_number(p_codcfrais)
	where substr(lpad(codsg,7,0),1,5)=substr(p_bddpg,2,5)
	and topfer=substr(p_bddpg,1,1)
	and coddir=substr(p_bddpg,7,2);

	insert into compo_centre_frais
		(select distinct to_number(p_codcfrais),
			lpad(d.codbr,2,0)||lpad(s.coddir,2,0)||lpad(substr(p_bddpg,2,5),5,'0')||'00',
			s.topfer,
			'pole',
			b.libbr||'/'||d.libdir||'/'||s.sigdep||'/'||s.sigpole
		 from struct_info s, directions d, branches b
		 where s.coddir=d.coddir
		 and d.codbr=b.codbr
		 and substr(lpad(codsg,7,0),1,5)=substr(p_bddpg,2,5)
		 and topfer=substr(p_bddpg,1,1)
		 and s.coddir=substr(p_bddpg,7,2));

    ELSE
  -- ================================================================================================
  --            				NIVEAU GROUPE
  -- ================================================================================================
	-- *********************************************
	-- Vérification de l'existence du groupe
	-- *********************************************

		BEGIN
			select 1 into l_exist
			from struct_info
			where codsg=to_number(p_bddpg);

		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				--Code DPG inexistant
				pack_global.recuperer_message(20109,NULL, NULL, NULL,  p_message);
            			raise_application_error(-20109 ,  p_message );

		END;

	-- *****************************************************************************************
	-- Vérification qu'il n'y a pas un niveau d'habilitation superieur au groupe
	-- *****************************************************************************************
		BEGIN
			select codbddpg,codcfrais into l_codbddpg,l_codcfrais
			from compo_centre_frais c,struct_info s, directions d
			where
			 s.coddir=d.coddir
	        	and s.codsg=to_number(p_bddpg)
			and (   ( substr(codbddpg,1,2)=lpad(d.codbr,2,0) and codhabili='br') or
			(substr(codbddpg,1,4)=lpad(d.codbr,2,0)||lpad(s.coddir,2,0)  and codhabili='dir') or
			(substr(codbddpg,1,7)=lpad(d.codbr,2,0)||lpad(s.coddir,2,0)||substr(p_bddpg,1,3) and codhabili='dpt') or
			(substr(codbddpg,1,9)=lpad(d.codbr,2,0)||lpad(s.coddir,2,0)||substr(p_bddpg,1,5) and codhabili='pole') or
			( substr(codbddpg,5,7)=p_bddpg and codhabili='tout')
 			)
			and rownum<2;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN

				insert into compo_centre_frais
		 		(select distinct to_number(p_codcfrais),
			 		lpad(d.codbr,2,0)||lpad(s.coddir,2,0)||lpad(p_bddpg,7,0),
					s.topfer,
			 		'tout',
			 		libdsg
		 		from struct_info s, directions d
		 		where s.coddir=d.coddir
		 		and s.codsg=to_number(p_bddpg)
				);


				update struct_info
				set scentrefrais=to_number(p_codcfrais)
				where codsg=to_number(p_bddpg);



		END;
		IF l_codbddpg is not null then
		-- Le groupe est déjà rattaché au centre de frais
		pack_global.recuperer_message(20345,'%s1','groupe','%s2',p_bddpg,'%s3',to_char(l_codcfrais), NULL, p_message);
		raise_application_error(-20345,p_message);
		END IF;

    END IF;

 --pack_global.recuperer_message(20340,'%s1', p_bddpg, NULL, p_message);

   commit;
 END update_struct_info;

-- =====================================================================================
-- * * * * * * * * SUPPRESSION D'UN BDDPG A UN CENTRE DE FRAIS * * * * * * * * * * * *
-- =====================================================================================

 PROCEDURE delete_struct_info(	p_mode    IN VARCHAR2,
				p_codcfrais IN VARCHAR2,
				p_libcfrais IN VARCHAR2,
				p_bddpg     IN VARCHAR2,
				p_userid    IN VARCHAR2,
			        p_nbcurseur     OUT INTEGER,
				p_message       OUT VARCHAR2
                           ) IS
-- Remarque : p_bddpg est la concaténation de codbddpg||topfer

  l_habili VARCHAR2(10);

  BEGIN

	if p_mode='delete' then
		select codhabili into l_habili
		from compo_centre_frais
		where codbddpg=substr(p_bddpg,1,11)
		and topfer=substr(p_bddpg,12,1);

		IF l_habili='br' THEN		-- branche
			update struct_info
			set scentrefrais=NULL
			where codsg in (select s.codsg
					from struct_info s, directions d
					where s.coddir=d.coddir
					and  d.codbr=to_number(substr(p_bddpg,1,2))
					);

			delete compo_centre_frais
			where codbddpg=substr(p_bddpg,1,11);

		ELSIF l_habili='dir' THEN  	--direction
			update struct_info
			set scentrefrais=NULL
			where codsg in (select s.codsg
					from struct_info s, directions d
					where s.coddir=d.coddir
					and  d.coddir=to_number(substr(p_bddpg,3,2))
					and d.codbr=to_number(substr(p_bddpg,1,2))
					);

			delete compo_centre_frais
			where codbddpg=substr(p_bddpg,1,11);

		ELSIF l_habili='dpt' THEN  	--département
			update struct_info
			set scentrefrais=NULL
			where codsg in (select s.codsg
					from struct_info s, directions d
					where s.coddir=d.coddir
					and  d.coddir=to_number(substr(p_bddpg,3,2))
					and d.codbr=to_number(substr(p_bddpg,1,2))
					and s.coddep=to_number(substr(p_bddpg,5,3))
					and s.topfer=substr(p_bddpg,12,1)
					);

			delete compo_centre_frais
			where codbddpg=substr(p_bddpg,1,11)
			and topfer=substr(p_bddpg,12,1);


		ELSIF l_habili='pole' THEN  	--pôle
			update struct_info
			set scentrefrais=NULL
			where codsg  in (select s.codsg
					from struct_info s, directions d
					where s.coddir=d.coddir
					and  d.coddir=to_number(substr(p_bddpg,3,2))
					and d.codbr=to_number(substr(p_bddpg,1,2))
					and substr(TO_CHAR(s.codsg, 'FM0000000'),1,5)=substr(p_bddpg,5,5)
					and s.topfer=substr(p_bddpg,12,1)
					);

			delete compo_centre_frais
			where codbddpg=substr(p_bddpg,1,11)
			and topfer=substr(p_bddpg,12,1);

		ELSE 				--groupe
			update struct_info
			set scentrefrais=NULL
			where codsg  in (select s.codsg
					from struct_info s, directions d
					where s.coddir=d.coddir
					and  d.coddir=to_number(substr(p_bddpg,3,2))
					and d.codbr=to_number(substr(p_bddpg,1,2))
					and s.codsg=to_number(substr(p_bddpg,5,7))
					);

			delete compo_centre_frais
			where codbddpg=substr(p_bddpg,1,11);


		END IF;
		commit;
	end if;

  END delete_struct_info;

END pack_centrefrais;
/
