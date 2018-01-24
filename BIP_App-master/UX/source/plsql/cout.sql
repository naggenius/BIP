-- pack_cout_standard PL/SQL
--
-- Equipe SOPRA
--
-- Cree le 10/02/1999
-- Modifié le 22/10/2003 :(NBM) IAS : modification des couts standards
-- 		   	  22/01/2004: NBM distinction cout ENV SG et SSII
--         le 05/01/2005:OTO  =  copie des coûts pour GAP dans les metiers EXP
--         le 11/02/2005:PPR  =  copie des coûts pour GAP dans les metiers SAU, et FOR
--            25/07/2006 : JMA = ajout des métiers pour les couts d'environnement
--            19/06/208 : JAL Rajout d'une Log des insert/modif/supression des couts standards
--            24/06/2008   : JAL  ficher 596 maj dernière version Logs coûts
--           01/08/2008   : JAL : détail des couts lors de la supression pour les Logs des coutts
--           05/08/2008 : JAL  : fiche 596 : correction bugs dans logs en mode update

-- Attention le nom du package ne peut etre le nom
-- de la table...
CREATE OR REPLACE PACKAGE pack_cout_standard AS

TYPE cout_Type IS RECORD ( 	annee varchar2(4),
						 dpg_bas varchar2(7),
						 dpg_haut varchar2(7),
                		 me varchar2(25),
						 mo varchar2(25),
						 hom varchar2(25),
						 gap varchar2(25),
			             FLAGLOCK   cout_std_sg.flaglock%TYPE
                  );
TYPE coutCurType IS REF CURSOR RETURN cout_Type;

TYPE cout_sg_Type IS RECORD ( 	annee varchar2(4),
					dpg_bas varchar2(7),
					dpg_haut varchar2(7),
                				me varchar2(7),
		 			mo varchar2(7),
		 			hom varchar2(7),
		 			gap varchar2(7),
					niveau varchar2(2),
		 			longueur number(1),
			                        FLAGLOCK   cout_std_sg.flaglock%TYPE
                  );

      TYPE coutSgCurType IS REF CURSOR RETURN cout_sg_Type;

PROCEDURE insert_cout_standard(
		p_couann    	IN  VARCHAR2,
                       p_codsg_bas 	IN  VARCHAR2,
		p_codsg_haut  IN  VARCHAR2,
		p_chaine	 IN  VARCHAR2,
		p_choix	IN  VARCHAR2,
		p_coulog	IN  VARCHAR2,
		p_coutenv_sg	IN  VARCHAR2,
		p_coutenv_ssii	IN  VARCHAR2,
        userid        IN  VARCHAR2,
  		p_nbcurseur 	OUT INTEGER,
                       p_message   	OUT VARCHAR2
);
PROCEDURE update_cout_standard (
			p_couann    	IN  VARCHAR2,
			p_codsg_bas_old IN  VARCHAR2,
		       	p_codsg_bas_new IN  VARCHAR2,
		       	p_codsg_haut 	IN  VARCHAR2,
                       	p_chaine	 IN  VARCHAR2,
			p_choix	IN  VARCHAR2,
			p_coulog	IN  VARCHAR2,
			p_coutenv_sg	IN  VARCHAR2,
			p_coutenv_ssii	IN  VARCHAR2,
                       	p_flaglock  	IN  NUMBER,
                        userid    	IN  VARCHAR2,
                       	p_nbcurseur 	OUT INTEGER,
                       	p_message   	OUT VARCHAR2
                      );

PROCEDURE delete_cout_standard (p_couann    IN  VARCHAR2,
				p_codsg_bas IN  VARCHAR2,
                       		p_flaglock  IN  NUMBER,
				p_choix	IN  VARCHAR2,
                       		userid    IN  VARCHAR2,
                       		p_nbcurseur OUT INTEGER,
                       		p_message   OUT VARCHAR2
                      );

PROCEDURE select_cout_standard (p_couann    IN VARCHAR2,
		       		p_codsg_bas IN VARCHAR2,
                       		p_userid    IN VARCHAR2,
                       		p_curcout   IN OUT coutCurType,
                       		p_nbcurseur OUT INTEGER,
                       		p_message   OUT VARCHAR2
                      );

PROCEDURE select_cout_standard_sg (p_couann    IN VARCHAR2,
		       		p_codsg_bas IN VARCHAR2,
                       		p_userid    IN VARCHAR2,
                       		p_curcout   IN OUT coutSgCurType,
                       		p_nbcurseur    OUT INTEGER,
                       		p_message      OUT VARCHAR2
                      ) ;

PROCEDURE controle_cout_standard (	p_couann    IN VARCHAR2,
                       		  		p_userid    IN VARCHAR2,
                     		 			p_message   OUT VARCHAR2
                      );
PROCEDURE controle_cout_standard_sg (p_couann    IN  VARCHAR2,
                       		 		p_userid    IN  VARCHAR2,
                       		 		p_message   OUT VARCHAR2);

FUNCTION get_coutstandard_sg (p_anneestd   	 IN VARCHAR2,
						p_dpg_bas      IN VARCHAR2,
						p_niveau  	IN VARCHAR2,
						p_metier  	IN VARCHAR2)
RETURN NUMBER;


FUNCTION get_coutstandard (p_anneestd IN VARCHAR2,
						   p_dpg_bas  IN VARCHAR2,
						   p_metier   IN VARCHAR2)
						   RETURN VARCHAR2;

PROCEDURE log_coutSTD(p_couann IN NUMBER,p_codsg_haut  IN NUMBER ,p_codsg_bas IN NUMBER ,l_metier IN VARCHAR2  ,l_niveau IN VARCHAR2,
                     l_time_stamp IN DATE , p_userid IN VARCHAR2 , p_nom_table IN VARCHAR2  ,
                     p_nom_colonne IN VARCHAR2 , p_val_prec IN VARCHAR2 , p_val_new IN VARCHAR2 ,type_action IN NUMBER ,
                     p_commentaire IN VARCHAR2 )  ;



END pack_cout_standard;
/
CREATE OR REPLACE PACKAGE BODY pack_cout_standard AS


/************************************************************************************/
/*                                                                                  */
/*       CREATION des couts standard                                                */
/*                                                                                  */
/************************************************************************************/
PROCEDURE insert_cout_standard(
		p_couann    	IN  VARCHAR2,
        p_codsg_bas 	IN  VARCHAR2,
		p_codsg_haut    IN  VARCHAR2,
		p_chaine	    IN  VARCHAR2,
		p_choix	        IN  VARCHAR2,
		p_coulog	    IN  VARCHAR2,
		p_coutenv_sg	IN  VARCHAR2,
		p_coutenv_ssii	IN  VARCHAR2,
        userid        IN  VARCHAR2,
  		p_nbcurseur 	   OUT INTEGER,
        p_message   	   OUT VARCHAR2)  IS
	l_length NUMBER(10);
	l_pos NUMBER(10);
	l_ligne VARCHAR2(50);
	l_chaine VARCHAR2(5000);
	l_egal NUMBER(10);
	l_lib VARCHAR2(50);
	l_cout VARCHAR2(50);
	l_niveau COUT_STD_SG.niveau%TYPE;
	l_metier COUT_STD_SG.metier%TYPE;
	l_underscore NUMBER(10);
	l_exist NUMBER(1);
	l_f_pos NUMBER(2);
	l_n_pos NUMBER(2);
	i NUMBER(1);
	l_cout_maj VARCHAR2(50);
    l_msg VARCHAR(1024);

    l_time_stamp DATE ;
    p_userid VARCHAR2(30) ;
    p_commentaire_insert VARCHAR2(200) ;
    p_commentaire_update VARCHAR2(200) ;

    l_ancien_coutlog NUMBER(6,2);
    l_ancien_coutenvsg NUMBER(6,2);
    l_ancien_coutenvssii NUMBER(6,2);

    CURSOR cur_coutenv_cas_simple(p_couann IN VARCHAR2, p_codsg_bas IN VARCHAR2, i IN NUMBER) IS
     	   SELECT * FROM cout_std2
     	   WHERE annee = TO_NUMBER(p_couann)
           AND dpg_bas = TO_NUMBER(p_codsg_bas)
		   AND metier  = decode(i,1,'ME',2,'MO',3,'HOM',4,'GAP')
	       AND flaglock = 0;

    -- On ne logue pas ce qui n'apparait pas à l'écran
    /* CURSOR cur_coutenv_cas_spec(p_couann IN VARCHAR2, p_codsg_bas IN VARCHAR2) IS
     	   SELECT * FROM cout_std2
     	   WHERE annee = TO_NUMBER(p_couann)
           AND dpg_bas = TO_NUMBER(p_codsg_bas)
		   AND ( metier = 'EXP' or metier = 'SAU' or metier = 'FOR' )
		   AND flaglock = 0;*/



BEGIN
	l_length := LENGTH(p_chaine);
	l_chaine:=p_chaine;

    p_userid := pack_global.lire_globaldata(userid).idarpege;

    p_commentaire_insert := 'Création' ;
    p_commentaire_update := 'Mise à jour';

   SELECT TO_DATE(TO_CHAR(SYSDATE,'DD/MM/YYYY')) INTO l_time_stamp FROM DUAL   ;

	if (p_choix='SG') then
	   	--Tester si le DPG BAS existe déjà
		Begin
			select 1 into l_exist
			from  COUT_STD_SG
			where annee = to_number(p_couann)
			and dpg_bas = to_number(p_codsg_bas)
			and rownum<=1;

			if (l_exist=1) then
				--Message d'erreur : Le codsg bas existe déjà
				pack_global.recuperer_message(20370, NULL, NULL, NULL, p_message);
	           		raise_application_error( -20370, p_message );
			end if;
			Exception
				When no_data_found then
					null;

		End;

        WHILE  l_chaine is not null LOOP

        	l_pos := INSTR(l_chaine,';',1);
			--dbms_output.put_line('  l_pos:'||  l_pos);
		   	 l_ligne :=SUBSTR(l_chaine,1,l_pos-1);
			--position du =
			 l_egal := INSTR(l_ligne,'=',1);
			l_lib := SUBSTR(l_ligne,1,l_egal-1);
			--dbms_output.put_line(' l_lib:'|| l_lib);
			--récupérer le niveau et le métier
			l_underscore := INSTR(l_lib,'_',1);
			l_niveau := SUBSTR(l_lib,1,l_underscore-1);
			l_metier := SUBSTR(l_lib, l_underscore+1,l_length-l_underscore);
			dbms_output.put_line('l_niveau:'||l_niveau);
			dbms_output.put_line('l_metier:'||l_metier);

			l_cout := SUBSTR(l_ligne, l_egal+1,l_length-l_egal);
			dbms_output.put_line(' l_cout:'|| l_cout);
			--dbms_output.put_line(' l_ligne:'|| l_ligne);
		  	l_chaine :=SUBSTR(l_chaine, l_pos+1,l_length-l_pos);
			--dbms_output.put_line(' l_chaine:'||  l_chaine);
			--Insertion de chaque ligne dans la table COUT_STD_SG

			insert into COUT_STD_SG (annee, niveau, metier, dpg_haut, dpg_bas, cout_sg, flaglock)
			values (to_number(p_couann),
				upper(l_niveau),
				upper(l_metier),
				to_number(p_codsg_haut),
				to_number(p_codsg_bas),
				to_number(l_cout),
				0);
         IF(l_metier!= 'EXP' AND l_metier!= 'SAU' AND l_metier!= 'FOR') THEN
                  -- Fiche 596 : LOGS COUT STD
                  log_coutSTD(to_number(p_couann),to_number(p_codsg_haut),to_number(p_codsg_bas) ,upper(l_metier) ,upper(l_niveau),
                     l_time_stamp ,  p_userid , 'COUT_STD_SG'  ,
                     'COUT_SG' , ' ' , l_cout ,1 ,
                     p_commentaire_insert ) ;
         END IF ;






			IF upper(l_metier)='GAP' THEN

				insert into COUT_STD_SG (annee, niveau, metier, dpg_haut, dpg_bas, cout_sg, flaglock)
				values (to_number(p_couann),
					upper(l_niveau),
					'EXP',
					to_number(p_codsg_haut),
					to_number(p_codsg_bas),
					to_number(l_cout),
					0);
                     -- Fiche 596 : LOGS COUT STD
                     -- On ne logue pas ce qui n'apparait pas à l'écran
                    /* log_coutSTD(to_number(p_couann),to_number(p_codsg_haut),to_number(p_codsg_bas) ,'EXP' ,upper(l_niveau),
                     l_time_stamp ,  p_userid , 'COUT_STD_SG'  ,
                     'COUT_SG' , '' , l_cout ,1 ,
                     p_commentaire_insert ) ;*/



				insert into COUT_STD_SG (annee, niveau, metier, dpg_haut, dpg_bas, cout_sg, flaglock)
				values (to_number(p_couann),
					upper(l_niveau),
					'SAU',
					to_number(p_codsg_haut),
					to_number(p_codsg_bas),
					to_number(l_cout),
					0);
                 -- Fiche 596 : LOGS COUT STD
                 -- On ne logue pas ce qui n'apparait pas à l'écran
                 /*log_coutSTD(to_number(p_couann),to_number(p_codsg_haut),to_number(p_codsg_bas) ,'SAU' , upper(l_niveau),
                 l_time_stamp ,  p_userid , 'COUT_STD_SG'  ,
                 'COUT_SG' , '' , l_cout ,1 ,
                 p_commentaire_insert ) ;*/



    				insert into COUT_STD_SG (annee, niveau, metier, dpg_haut, dpg_bas, cout_sg, flaglock)
    				values (to_number(p_couann),
    					upper(l_niveau),
    					'FOR',
    					to_number(p_codsg_haut),
    					to_number(p_codsg_bas),
    					to_number(l_cout),
    					0);
                    -- Fiche 596 : LOGS COUT STD
                    -- On ne logue pas ce qui n'apparait pas à l'écran
                   /* log_coutSTD(to_number(p_couann),to_number(p_codsg_haut),to_number(p_codsg_bas) ,'FOR' ,upper(l_niveau),
                     l_time_stamp ,  p_userid , 'COUT_STD_SG'  ,
                     'COUT_SG' , '' , l_cout ,1 ,
                     p_commentaire_insert ) ; */



			END IF;


	    END LOOP;
	else
			--Tester si le DPG BAS existe déjà
		Begin
			select 1 into l_exist
			from  COUT_STD2
			where annee = to_number(p_couann)
			and dpg_bas = to_number(p_codsg_bas)
			and rownum<=1;

			if (l_exist=1) then
				--Message d'erreur : Le codsg bas existe déjà
				pack_global.recuperer_message(20370, NULL, NULL, NULL, p_message);
	        	raise_application_error( -20370, p_message );
			end if;
		Exception
			When no_data_found then
				null;
		End;


		-- cout logiciel
		insert into COUT_STD2 (annee, cout_log, dpg_haut, dpg_bas, metier, flaglock)
		values ( to_number(p_couann), to_number(p_coulog), to_number(p_codsg_haut),
				 to_number(p_codsg_bas), 'ME', 0);
		insert into COUT_STD2 (annee, cout_log, dpg_haut, dpg_bas, metier, flaglock)
		values ( to_number(p_couann), to_number(p_coulog), to_number(p_codsg_haut),
				 to_number(p_codsg_bas), 'MO', 0);
		insert into COUT_STD2 (annee, cout_log, dpg_haut, dpg_bas, metier, flaglock)
		values ( to_number(p_couann), to_number(p_coulog), to_number(p_codsg_haut),
				 to_number(p_codsg_bas), 'HOM', 0);
		insert into COUT_STD2 (annee, cout_log, dpg_haut, dpg_bas, metier, flaglock)
		values ( to_number(p_couann), to_number(p_coulog), to_number(p_codsg_haut),
				 to_number(p_codsg_bas), 'GAP', 0);
		insert into COUT_STD2 (annee, cout_log, dpg_haut, dpg_bas, metier, flaglock)
		values ( to_number(p_couann), to_number(p_coulog), to_number(p_codsg_haut),
				 to_number(p_codsg_bas), 'EXP', 0);
		insert into COUT_STD2 (annee, cout_log, dpg_haut, dpg_bas, metier, flaglock)
		values ( to_number(p_couann), to_number(p_coulog), to_number(p_codsg_haut),
				 to_number(p_codsg_bas), 'SAU', 0);
		insert into COUT_STD2 (annee, cout_log, dpg_haut, dpg_bas, metier, flaglock)
		values ( to_number(p_couann), to_number(p_coulog), to_number(p_codsg_haut),
				 to_number(p_codsg_bas), 'FOR', 0);


         -- Fiche 596 : LOGS COUT STD
         log_coutSTD(to_number(p_couann),to_number(p_codsg_haut),to_number(p_codsg_bas) ,'TOUS' , ' ' ,
             l_time_stamp ,  p_userid , 'COUT_STD2'  ,
             'COUT_LOG' , ' ' , p_coulog ,1 ,
             p_commentaire_insert ) ;


		-- Mise à jour cout env SG
		l_cout_maj  := '0';
		l_f_pos := 1;
		i := 1;
		l_cout := p_coutenv_sg;
		while l_cout is not null
		LOOP
			l_n_pos    := instr(l_cout, ';', l_f_pos);
			l_cout_maj := substr(l_cout, l_f_pos, l_n_pos-1);
			l_cout     := substr(l_cout, l_n_pos+1);



           ------------ Fiche 596 : LOGS DE CHAQUE COUT MIS A JOUR AVEC VALEUR  DIFFERENTE DE LA NOUVELLE ---------------------------------------------------------------------------
            FOR curseur_ENV_simple IN cur_coutenv_cas_simple(p_couann , p_codsg_bas , i ) LOOP
              BEGIN
                     l_ancien_coutenvsg := curseur_ENV_simple.coutenv_sg ;
                     IF( l_ancien_coutenvsg <>TO_NUMBER(l_cout_maj)) THEN
                      -- Fiche 596 : LOGS COUT STD
                         log_coutSTD(to_number(p_couann),curseur_ENV_simple.dpg_haut ,curseur_ENV_simple.dpg_bas  ,curseur_ENV_simple.metier , ' ' ,
                             l_time_stamp ,  p_userid , 'COUT_STD2'  ,
                             'COUTENV_SG' , ' ' , l_cout_maj ,1 ,
                             p_commentaire_update ) ;
                     END IF ;
              END ;
            END LOOP ;
            --------------------------------------------------------------------------------------------------------------------

			UPDATE COUT_STD2 SET coutenv_sg = TO_NUMBER(l_cout_maj)
			 WHERE annee   = TO_NUMBER(p_couann)
			   AND dpg_bas = TO_NUMBER(p_codsg_bas)
			   and metier  = decode(i,1,'ME',2,'MO',3,'HOM',4,'GAP')
	      	   and flaglock = 0;





			IF SQL%NOTFOUND THEN
	        	pack_global.recuperer_message(20999, NULL, NULL, NULL, l_msg);
	        	raise_application_error( -20999, l_msg );
	      	ELSE
	        	pack_global.recuperer_message(2017, '%s1', p_couann, NULL, l_msg);
				p_message := l_msg;
	      	END IF;

			-- Cas particulier pour metier GAP à recopier dans metier EXP, SAU,FOR
			if (i=4) then

            --------------------- Fiche 596 : LOGS COUT STD  ------------------------------------------
            -- On ne logue pas ce qui n'apparait pas à l'écran
            /*FOR cur_env_spec IN cur_coutenv_cas_spec(p_couann , p_codsg_bas ) LOOP
              BEGIN
                     l_ancien_coutenvsg := cur_env_spec.coutenv_sg ;
                     IF( l_ancien_coutenvsg <>TO_NUMBER(l_cout_maj)) THEN
                      -- Fiche 596 : LOGS COUT STD
                         log_coutSTD(to_number(p_couann),cur_env_spec.dpg_haut ,cur_env_spec.dpg_bas  ,cur_env_spec.metier , ' ' ,
                             l_time_stamp ,  p_userid , 'COUT_STD2'  ,
                             'COUTENV_SG' , '' , l_cout_maj ,1 ,
                             p_commentaire_insert ) ;
                     END IF ;
              END ;
            END LOOP ;*/
            ---------------------------------------------------------------------------------------------

				UPDATE COUT_STD2 SET coutenv_sg = TO_NUMBER(l_cout_maj)
				 WHERE annee   = TO_NUMBER(p_couann)
				   AND dpg_bas = TO_NUMBER(p_codsg_bas)
				   and ( metier = 'EXP' or metier = 'SAU' or metier = 'FOR' )
		      	   and flaglock = 0;



				IF SQL%NOTFOUND THEN
		        	pack_global.recuperer_message(20999, NULL, NULL, NULL, l_msg);
		        	raise_application_error( -20999, l_msg );
		      	ELSE
		        	pack_global.recuperer_message(2017, '%s1', p_couann, NULL, l_msg);
					p_message := l_msg;
		      	END IF;
			end if;

			i := i+1;
		END LOOP;

		-- Mise à jour cout env SSII
		l_cout_maj  := '0';
		l_f_pos := 1;
		i := 1;
		l_cout := p_coutenv_ssii;
		while l_cout is not null
		LOOP
			l_n_pos    := instr(l_cout, ';', l_f_pos);
			l_cout_maj := substr(l_cout, l_f_pos, l_n_pos-1);
			l_cout     := substr(l_cout, l_n_pos+1);

           ----------- Fiche 596 : LOGS COUT STD   ---------------------------------------------------------------------------
            FOR curseur_ENVSSII_simple IN cur_coutenv_cas_simple(p_couann , p_codsg_bas , i ) LOOP
              BEGIN
                    l_ancien_coutenvssii := curseur_ENVSSII_simple.coutenv_ssii ;
                     IF( l_ancien_coutenvssii <>TO_NUMBER(l_cout_maj)) THEN
                         log_coutSTD(to_number(p_couann),curseur_ENVSSII_simple.dpg_haut ,curseur_ENVSSII_simple.dpg_bas  ,
                         curseur_ENVSSII_simple.metier , ' ' , l_time_stamp ,  p_userid , 'COUT_STD2'  ,
                         'COUTENV_SSII' , ' ' , l_cout_maj ,1 ,
                        p_commentaire_update) ;
                     END IF ;
              END ;
            END LOOP ;
           --------------------------------------------------------------------------------------------------------------------


			UPDATE COUT_STD2 SET coutenv_ssii = TO_NUMBER(l_cout_maj)
			 WHERE annee   = TO_NUMBER(p_couann)
			   AND dpg_bas = TO_NUMBER(p_codsg_bas)
			   and metier  = decode(i,1,'ME',2,'MO',3,'HOM',4,'GAP')
	      	   and flaglock = 0;

			IF SQL%NOTFOUND THEN
	        	pack_global.recuperer_message(20999, NULL, NULL, NULL, l_msg);
	        	raise_application_error( -20999, l_msg );
	      	ELSE
	        	pack_global.recuperer_message(2017, '%s1', p_couann, NULL, l_msg);
				p_message := l_msg;
	      	END IF;

			-- Cas particulier pour metier GAP à recopier dans metier EXP, SAU,FOR
			if (i=4) then

            -- On ne logue pas ce qui n'apparait pas à l'écran
            ----------- Fiche 596 : LOGS COUT STD   ---------------------------------------------------------------------------
            /*FOR curseur_ENVSSII_spec IN cur_coutenv_cas_spec(p_couann , p_codsg_bas ) LOOP
              BEGIN
                     l_ancien_coutenvssii := curseur_ENVSSII_spec.coutenv_ssii ;
                     IF( l_ancien_coutenvssii <>TO_NUMBER(l_cout_maj)) THEN
                         log_coutSTD(to_number(p_couann),curseur_ENVSSII_spec.dpg_haut ,curseur_ENVSSII_spec.dpg_bas  ,
                         curseur_ENVSSII_spec.metier , ' ' , l_time_stamp ,  p_userid , 'COUT_STD2'  ,
                         'COUTENV_SSII' , '' , l_cout_maj ,1 ,
                         p_commentaire_insert ) ;
                     END IF ;
              END ;
            END LOOP ; */
           --------------------------------------------------------------------------------------------------------------------


				UPDATE COUT_STD2 SET coutenv_ssii = TO_NUMBER(l_cout_maj)
				 WHERE annee   = TO_NUMBER(p_couann)
				   AND dpg_bas = TO_NUMBER(p_codsg_bas)
				   and ( metier = 'EXP' or metier = 'SAU' or metier = 'FOR' )
		      	   and flaglock = 0;

				IF SQL%NOTFOUND THEN
		        	pack_global.recuperer_message(20999, NULL, NULL, NULL, l_msg);
		        	raise_application_error( -20999, l_msg );
		      	ELSE
		        	pack_global.recuperer_message(2017, '%s1', p_couann, NULL, l_msg);
					p_message := l_msg;
		      	END IF;
			end if;

			i := i+1;
		END LOOP;

	end if;

  	-- 'Coût Standard ' || p_couann ||  ' a été créé.';
    pack_global.recuperer_message(2016, '%s1', p_couann, NULL, p_message);

EXCEPTION
	WHEN DUP_VAL_ON_INDEX THEN
		rollback;
		pack_global.recuperer_message(20370, NULL, NULL, NULL, p_message);
        raise_application_error( -20370, p_message );

 	WHEN OTHERS THEN
		rollback;
		raise_application_error( -20997, SQLERRM );

END insert_cout_standard;



/************************************************************************************/
/*                                                                                  */
/*       MISE A JOUR des couts standard                                             */
/*                                                                                  */
/************************************************************************************/
PROCEDURE update_cout_standard (p_couann    	IN  VARCHAR2,
		       				    p_codsg_bas_old IN  VARCHAR2,
		       					p_codsg_bas_new IN  VARCHAR2,
		      					p_codsg_haut 	IN  VARCHAR2,
		       					p_chaine	 	IN  VARCHAR2,
								p_choix			IN  VARCHAR2,
								p_coulog		IN  VARCHAR2,
								p_coutenv_sg	IN  VARCHAR2,
								p_coutenv_ssii	IN  VARCHAR2,
	                       		p_flaglock  	IN  NUMBER,
                       			userid    	IN  VARCHAR2,
                       			p_nbcurseur 	   OUT INTEGER,
                       			p_message   	   OUT VARCHAR2
                              ) IS

    l_msg VARCHAR(1024);
	l_length NUMBER(10);
	l_pos NUMBER(10);
	l_ligne VARCHAR2(50);
	l_chaine VARCHAR2(5000);
	l_egal NUMBER(10);
	l_lib VARCHAR2(50);
	l_cout VARCHAR2(50);
	l_niveau COUT_STD_SG.niveau%TYPE;
	l_metier COUT_STD_SG.metier%TYPE;
	l_underscore NUMBER(10);
	l_exist NUMBER(1);
	l_f_pos NUMBER(2);
	l_n_pos NUMBER(2);
	i NUMBER(1);
	l_cout_maj VARCHAR2(50);
	l_flaglock NUMBER(9);



    l_time_stamp DATE ;
    p_userid VARCHAR2(30) ;
    p_commentaire_insert VARCHAR2(200) ;
    p_commentaire_update VARCHAR2(200) ;

    l_ancien_coutlog NUMBER(6,2);
    l_ancien_coutenvsg NUMBER(6,2);
    l_ancien_coutenvssii NUMBER(6,2);
    l_dpghaut_found NUMBER(7) ;
    l_dpgtest_std_deja_faits NUMBER(1) ;
    l_dpgtest_sg_deja_faits NUMBER(1) ;

    -- On ne logue pas les métiers 'EXP', 'SAU','FOR' car ils n'apparaissent pas à l'écran
    CURSOR cur_update (p_couann IN VARCHAR2,p_codsg_bas IN VARCHAR2,p_flaglock IN NUMBER,l_niveau IN VARCHAR2,l_metier IN VARCHAR2) IS
   	SELECT * FROM COUT_STD_SG
   	WHERE annee = TO_NUMBER(p_couann)
    AND dpg_bas = TO_NUMBER(p_codsg_bas)
    AND flaglock = p_flaglock
	AND niveau = upper(l_niveau)
	AND metier = upper(l_metier)
    AND metier NOT IN ('EXP', 'SAU','FOR');

    -- On ne log pas ce qui n'apparait pas à l'écran
    /*CURSOR cur_update_gap (p_couann IN VARCHAR2,p_codsg_bas IN VARCHAR2, l_niveau IN VARCHAR2) IS
   	SELECT * FROM COUT_STD_SG
   	WHERE annee = TO_NUMBER(p_couann)
    AND dpg_bas = TO_NUMBER(p_codsg_bas)
    AND flaglock = p_flaglock
	AND niveau = upper(l_niveau)
	and ( metier = 'EXP' or metier = 'SAU' or metier = 'FOR' ) ;*/


    CURSOR cur_logiciel (p_couann IN VARCHAR2,p_codsg_bas IN VARCHAR2, p_flaglock IN NUMBER) IS
   	SELECT * FROM COUT_STD2
   	WHERE annee = TO_NUMBER(p_couann)
    AND dpg_bas = TO_NUMBER(p_codsg_bas)
    AND flaglock = p_flaglock
     -- On ne logue pas les métiers 'EXP', 'SAU','FOR' car ils n'apparaissent pas à l'écran
    AND metier NOT IN ('EXP', 'SAU','FOR');


    CURSOR cur_ensg (p_couann IN VARCHAR2,p_codsg_bas IN VARCHAR2, p_flaglock IN NUMBER,i IN NUMBER) IS
   	SELECT * FROM COUT_STD2
   	WHERE annee = TO_NUMBER(p_couann)
    AND dpg_bas = TO_NUMBER(p_codsg_bas)
    and metier  = decode(i,1,'ME',2,'MO',3,'HOM',4,'GAP')
    AND flaglock = p_flaglock ;

    -- On ne log pas ce qui n'apparait pas à l'écran
    /*CURSOR cur_ensg_gap (p_couann IN VARCHAR2,p_codsg_bas IN VARCHAR2, p_flaglock IN NUMBER ) IS
   	SELECT * FROM COUT_STD2
   	WHERE annee = TO_NUMBER(p_couann)
    AND dpg_bas = TO_NUMBER(p_codsg_bas)
    and ( metier = 'EXP' or metier = 'SAU' or metier = 'FOR' )
    AND flaglock = p_flaglock ; */



BEGIN


   l_dpgtest_std_deja_faits := 0 ;
   l_dpgtest_sg_deja_faits := 0 ;

   p_userid := pack_global.lire_globaldata(userid).idarpege;
   p_commentaire_insert := 'Création' ;
   p_commentaire_update := 'Mise à jour' ;

   SELECT TO_DATE(TO_CHAR(SYSDATE,'DD/MM/YYYY')) INTO l_time_stamp FROM DUAL   ;




	l_length := LENGTH(p_chaine);
	l_chaine:=p_chaine;

    -- Positionner le nb de curseurs ==> 0
   	-- Initialiser le message retour
   	p_nbcurseur := 0;
   	p_message   := '';

	--Tester si le DPG BAS existe déjà
	if (p_codsg_bas_old!=p_codsg_bas_new) then
	  Begin

		select 1 into l_exist
		from  COUT_STD_SG
		where annee = to_number(p_couann)
		and dpg_bas = to_number(p_codsg_bas_new)
		and rownum<=1;

		if (l_exist=1) then
			--Message d'erreur : Le codsg bas existe déjà
			pack_global.recuperer_message(20370, NULL, NULL, NULL, p_message);
           		raise_application_error( -20370, p_message );
		end if;
		Exception
			When no_data_found then
				null;

	  End;
	end if;

	If (p_choix='SG') then
     	WHILE  l_chaine is not null LOOP

               	 l_pos := INSTR(l_chaine,';',1);
		--dbms_output.put_line('  l_pos:'||  l_pos);
	   	 l_ligne :=SUBSTR(l_chaine,1,l_pos-1);
		--position du =
		 l_egal := INSTR(l_ligne,'=',1);
		l_lib := SUBSTR(l_ligne,1,l_egal-1);
		--dbms_output.put_line(' l_lib:'|| l_lib);
		--récupérer le niveau et le métier
		l_underscore := INSTR(l_lib,'_',1);
		l_niveau := SUBSTR(l_lib,1,l_underscore-1);
		l_metier := SUBSTR(l_lib, l_underscore+1,l_length-l_underscore);
		l_metier := upper(l_metier);
		dbms_output.put_line('l_niveau:'||l_niveau);
		dbms_output.put_line('l_metier:'||l_metier);

		l_cout := SUBSTR(l_ligne, l_egal+1,l_length-l_egal);
		dbms_output.put_line(' l_cout:'|| l_cout);
		--dbms_output.put_line(' l_ligne:'|| l_ligne);
	  	l_chaine :=SUBSTR(l_chaine, l_pos+1,l_length-l_pos);
		--dbms_output.put_line(' l_chaine:'||  l_chaine);
		--modification de chaque ligne de la table COUT_STD_SG
		BEGIN




        IF(l_dpgtest_sg_deja_faits=0) THEN
                l_dpgtest_sg_deja_faits:= 1 ;
                -- LOG SI DPG_HAUT va être modifié
                select dpg_haut into l_dpghaut_found
        		from  COUT_STD_SG
        		where annee = to_number(p_couann)
        		and dpg_bas = to_number(p_codsg_bas_old)
        		and rownum=1;
                IF(l_dpghaut_found <> TO_NUMBER(p_codsg_haut)) THEN
                     log_coutSTD(to_number(p_couann),l_dpghaut_found ,to_number(p_codsg_bas_old)  ,'TOUS' , 'TOUS' ,
                                     l_time_stamp ,  p_userid , 'COUT_STD_SG'  ,
                                     'DPG_HAUT' , l_dpghaut_found , p_codsg_haut ,3 ,
                                      p_commentaire_update ) ;
                END IF  ;

                -- LOG SI DPG_BAS va être modifié
                IF(TO_NUMBER(p_codsg_bas_old) <> TO_NUMBER(p_codsg_bas_new)) THEN
                     log_coutSTD(to_number(p_couann),l_dpghaut_found ,to_number(p_codsg_bas_old)  ,'TOUS' , 'TOUS' ,
                                     l_time_stamp ,  p_userid , 'COUT_STD_SG'  ,
                                     'DPG_BAS' , p_codsg_bas_old, p_codsg_bas_new ,3 ,
                                     p_commentaire_update ) ;
                END IF  ;
        END IF ;
       ----------- Fiche 596 : LOGS COUT STD   ---------------------------------------------------------------------------
          FOR cuseur IN cur_update ( p_couann  ,p_codsg_bas_old  ,p_flaglock ,l_niveau  ,l_metier ) LOOP
                BEGIN
                    l_ancien_coutenvsg := cuseur.cout_sg ;
                     IF( l_ancien_coutenvsg <> l_cout) THEN
                      -- Fiche 596 : LOGS COUT STD
                         log_coutSTD(to_number(p_couann),cuseur.dpg_haut ,cuseur.dpg_bas  ,cuseur.metier , cuseur.niveau ,
                             l_time_stamp ,  p_userid , 'COUT_STD_SG'  ,
                             'COUT_SG' , TO_CHAR(l_ancien_coutenvsg) , TO_CHAR(l_cout) ,3 ,
                             p_commentaire_update ) ;
                     END IF ;
                END ;
          END LOOP ;
        --------------------------------------------------------------------------------------------------------------------

        UPDATE COUT_STD_SG SET
		      		dpg_bas  = TO_NUMBER(p_codsg_bas_new),
		     		dpg_haut = TO_NUMBER(p_codsg_haut),
				cout_sg = l_cout,
				flaglock   = decode( p_flaglock, 1000000, 0, p_flaglock + 1)
	    WHERE annee = TO_NUMBER(p_couann)
			AND dpg_bas = TO_NUMBER(p_codsg_bas_old)
      		and flaglock = p_flaglock
			and niveau = upper(l_niveau)
			and metier = upper(l_metier);


		 IF SQL%NOTFOUND THEN
        			pack_global.recuperer_message(20999, NULL, NULL, NULL, l_msg);
         			raise_application_error( -20999, l_msg );
      		ELSE
         			pack_global.recuperer_message(2017, '%s1', p_couann, NULL, l_msg);
 	  		p_message := l_msg;
      		END IF;

		IF upper(l_metier)='GAP' THEN


        ---------- Fiche 596 : LOGS COUT STD   ---------------------------------------------------------------------------
         -- On ne logue pas les métiers 'EXP', 'SAU','FOR' car ils n'apparaissent pas à l'écran
          /*FOR cuseur_gap IN cur_update_gap ( p_couann  ,p_codsg_bas_old , l_niveau ) LOOP
                BEGIN
                    l_ancien_coutenvsg :=  cuseur_gap.cout_sg ;
                     IF( l_ancien_coutenvsg <> l_cout) THEN
                      -- Fiche 596 : LOGS COUT STD
                         log_coutSTD(to_number(p_couann),cuseur_gap.dpg_haut ,cuseur_gap.dpg_haut  ,cuseur_gap.metier , ' ' ,
                             l_time_stamp ,  p_userid , 'COUT_STD_SG'  ,
                             'COUT_SG' , TO_CHAR(l_ancien_coutenvsg) , TO_CHAR(l_cout) ,3 ,
                             p_commentaire_update) ;
                     END IF ;
                END ;
          END LOOP ;*/
        --------------------------------------------------------------------------------------------------------------------

			UPDATE COUT_STD_SG SET
		      		dpg_bas  = TO_NUMBER(p_codsg_bas_new),
		     		dpg_haut = TO_NUMBER(p_codsg_haut),
				cout_sg = l_cout,
				flaglock   = decode( p_flaglock, 1000000, 0, p_flaglock + 1)
			WHERE annee = TO_NUMBER(p_couann)
			AND dpg_bas = TO_NUMBER(p_codsg_bas_old)
			and niveau = upper(l_niveau)
			and ( metier = 'EXP' or metier = 'SAU' or metier = 'FOR' ) ;



			 IF SQL%NOTFOUND THEN
        			pack_global.recuperer_message(20999, NULL, NULL, NULL, l_msg);
         			raise_application_error( -20999, l_msg );
      			 ELSE
         			pack_global.recuperer_message(2017, '%s1', p_couann, NULL, l_msg);
 	  			p_message := l_msg;
      			 END IF;
		END IF;



         		 EXCEPTION
         			WHEN OTHERS THEN
				rollback;
           			 raise_application_error( -20997, SQLERRM );

		END;


	  END LOOP;

	else --Cas autre

		l_flaglock := p_flaglock;
		-- Mise à jour cout logiciel


     -- LOGUE UNE SEULE FOIS SI ON VA MODIFIER LES DPG HAUT ET BAS
     IF( l_dpgtest_std_deja_faits = 0) THEN
         l_dpgtest_std_deja_faits := 1 ;
        -- LOG SI DPG_HAUT va être modifié  : TABLE : COUT_STD2
        select dpg_haut into l_dpghaut_found
		from  COUT_STD2
		where annee = to_number(p_couann)
		and dpg_bas = to_number(p_codsg_bas_old)
		and rownum=1;
        IF(l_dpghaut_found <> TO_NUMBER(p_codsg_haut)) THEN
             log_coutSTD(to_number(p_couann),l_dpghaut_found ,to_number(p_codsg_bas_old)  ,'TOUS' , 'TOUS' ,
                             l_time_stamp ,  p_userid , 'COUT_STD2'  ,
                             'DPG_HAUT' , l_dpghaut_found , p_codsg_haut ,3 ,
                              p_commentaire_update ) ;
        END IF  ;
        -- LOG SI DPG_BAS va être modifié
        IF(TO_NUMBER(p_codsg_bas_old) <> TO_NUMBER(p_codsg_bas_new)) THEN
             log_coutSTD(to_number(p_couann),l_dpghaut_found ,to_number(p_codsg_bas_old)  ,'TOUS' , 'TOUS' ,
                             l_time_stamp ,  p_userid , 'COUT_STD2'  ,
                             'DPG_BAS' , p_codsg_bas_old, p_codsg_bas_new ,3 ,
                             p_commentaire_update ) ;
        END IF  ;

     END IF ;


         -- ON ne LOG que ce qui a été modifié à l'écran : coût logiciel
         ----------- Fiche 596 : LOGS COUT STD   ---------------------------------------------------------------------------
         /* FOR cuseur_log IN cur_logiciel (p_couann,p_codsg_bas_old ,l_flaglock)   LOOP
                BEGIN
                    l_ancien_coutlog :=  cuseur_log.cout_log ;
                     IF(l_ancien_coutlog <>TO_NUMBER(p_coulog)) THEN
                      -- Fiche 596 : LOGS COUT STD
                         log_coutSTD(to_number(p_couann),cuseur_log.dpg_haut ,cuseur_log.dpg_haut  ,cuseur_log.metier , ' ' ,
                             l_time_stamp ,  p_userid , 'COUT_STD2'  ,
                             'COUT_LOG' , TO_CHAR(l_ancien_coutlog) , TO_CHAR(p_coulog) ,3 ,
                             p_commentaire_update ) ;
                     END IF ;
                END ;
          END LOOP ;*/

        --------------------------------------------------------------------------------------------------------------------
         -- Fiche 596 : LOGS COUT STD

         SELECT COUT_LOG INTO  l_ancien_coutlog   FROM COUT_STD2 WHERE annee   = TO_NUMBER(p_couann)
		   AND dpg_bas = TO_NUMBER(p_codsg_bas_old)
      	   and flaglock = l_flaglock AND ROWNUM = 1 ;

         log_coutSTD(to_number(p_couann),to_number( p_codsg_haut), TO_NUMBER(p_codsg_bas_old) ,'TOUS' , 'TOUS' ,
             l_time_stamp ,  p_userid , 'COUT_STD2'  ,
             'COUT_LOG' , TO_CHAR(l_ancien_coutlog) , p_coulog ,1 ,
             p_commentaire_update ) ;
         --------------------------------------------------------------------------------------------------------------------

		UPDATE COUT_STD2 SET
	     		dpg_bas  = TO_NUMBER(p_codsg_bas_new),
	     		dpg_haut = TO_NUMBER(p_codsg_haut),
				cout_log = TO_NUMBER(p_coulog),
				flaglock = decode( l_flaglock, 1000000, 0, l_flaglock + 1)
		WHERE annee   = TO_NUMBER(p_couann)
		   AND dpg_bas = TO_NUMBER(p_codsg_bas_old)
      	   and flaglock = l_flaglock ;


		-- on incrémente l_flaglock pour éviter le message de table lockée
		if (p_coulog is not null) then
		    l_flaglock := l_flaglock + 1;
		end if;


		-- Mise à jour cout env SG
		l_cout_maj  := '0';
		l_f_pos := 1;
		i := 1;
		l_cout := p_coutenv_sg;
		while l_cout is not null
		LOOP
			l_n_pos    := instr(l_cout, ';', l_f_pos);
			l_cout_maj := substr(l_cout, l_f_pos, l_n_pos-1);
			l_cout     := substr(l_cout, l_n_pos+1);


        ----------- Fiche 596 : LOGS COUT STD   ---------------------------------------------------------------------------
          FOR cuseur_env_sg IN cur_ensg (p_couann  ,p_codsg_bas_old  , l_flaglock,i )  LOOP
                BEGIN
                    l_ancien_coutenvsg :=  cuseur_env_sg.coutenv_sg ;
                     IF( l_ancien_coutenvsg <>TO_NUMBER(l_cout_maj)) THEN
                      -- Fiche 596 : LOGS COUT STD
                         log_coutSTD(to_number(p_couann),cuseur_env_sg.dpg_haut,cuseur_env_sg.dpg_bas   ,cuseur_env_sg.metier , ''  ,
                             l_time_stamp ,  p_userid , 'COUT_STD2'  ,
                             'COUTENV_SG' , TO_CHAR( l_ancien_coutenvsg) , l_cout_maj ,3 ,
                             p_commentaire_update ) ;
                     END IF ;
                END ;
          END LOOP ;
        --------------------------------------------------------------------------------------------------------------------

			UPDATE COUT_STD2 SET
		     		dpg_bas    = TO_NUMBER(p_codsg_bas_new),
		     		dpg_haut   = TO_NUMBER(p_codsg_haut),
					coutenv_sg = TO_NUMBER(l_cout_maj),
					flaglock   = decode( l_flaglock, 1000000, 0, l_flaglock + 1)
			 WHERE annee   = TO_NUMBER(p_couann)
			   AND dpg_bas = TO_NUMBER(p_codsg_bas_old)
			   and metier  = decode(i,1,'ME',2,'MO',3,'HOM',4,'GAP')
	      	   and flaglock = l_flaglock ;

			IF SQL%NOTFOUND THEN
	        	pack_global.recuperer_message(20999, NULL, NULL, NULL, l_msg);
	        	raise_application_error( -20999, l_msg );
	      	ELSE
	        	pack_global.recuperer_message(2017, '%s1', p_couann, NULL, l_msg);
				p_message := l_msg;
	      	END IF;

			-- Cas particulier pour metier GAP à recopier dans metier EXP, SAU,FOR
			if (i=4) then


            ----------- Fiche 596 : LOGS COUT STD   ---------------------------------------------------------------------------
             -- On ne logue pas les métiers 'EXP', 'SAU','FOR' car ils n'apparaissent pas à l'écran
              /*FOR cuseur_envsggap IN cur_ensg_gap (p_couann  ,p_codsg_bas_old  , l_flaglock )  LOOP
                    BEGIN
                         l_ancien_coutenvsg :=  cuseur_envsggap.coutenv_sg ;
                         IF( l_ancien_coutenvsg <>TO_NUMBER(l_cout_maj)) THEN
                          -- Fiche 596 : LOGS COUT STD
                             log_coutSTD(to_number(p_couann),cuseur_envsggap.dpg_haut ,cuseur_envsggap.dpg_haut  ,cuseur_envsggap.metier , ' ' ,
                                 l_time_stamp ,  p_userid , 'COUT_STD2'  ,
                                 'COUTENV_SG' , TO_CHAR( l_ancien_coutenvsg) , l_cout_maj ,3 ,
                                 p_commentaire_update ) ;
                         END IF ;
                    END ;
              END LOOP ;*/
            --------------------------------------------------------------------------------------------------------------------

				UPDATE COUT_STD2 SET
			     		dpg_bas    = TO_NUMBER(p_codsg_bas_new),
			     		dpg_haut   = TO_NUMBER(p_codsg_haut),
						coutenv_sg = TO_NUMBER(l_cout_maj),
						flaglock   = decode( l_flaglock, 1000000, 0, l_flaglock + 1)
				 WHERE annee   = TO_NUMBER(p_couann)
				   AND dpg_bas = TO_NUMBER(p_codsg_bas_old)
				   and ( metier = 'EXP' or metier = 'SAU' or metier = 'FOR' )
		      	   and flaglock = l_flaglock ;

				IF SQL%NOTFOUND THEN
		        	pack_global.recuperer_message(20999, NULL, NULL, NULL, l_msg);
		        	raise_application_error( -20999, l_msg );
		      	ELSE
		        	pack_global.recuperer_message(2017, '%s1', p_couann, NULL, l_msg);
					p_message := l_msg;
		      	END IF;
			end if;

			i := i+1;
		END LOOP;
		-- on incrémente l_flaglock pour éviter le message de table lockée
		if (p_coutenv_sg is not null) then
		    l_flaglock := l_flaglock + 1;
		end if;



		-- Mise à jour cout env SSII
		l_cout_maj  := '0';
		l_f_pos := 1;
		i := 1;
		l_cout := p_coutenv_ssii;
		while l_cout is not null
		LOOP
			l_n_pos    := instr(l_cout, ';', l_f_pos);
			l_cout_maj := substr(l_cout, l_f_pos, l_n_pos-1);
			l_cout     := substr(l_cout, l_n_pos+1);

              ----------- Fiche 596 : LOGS COUT STD   ---------------------------------------------------------------------------
          FOR cuseur_env_sii IN cur_ensg (p_couann  ,p_codsg_bas_old  , l_flaglock,i )  LOOP
                BEGIN
                    l_ancien_coutenvssii :=  cuseur_env_sii.coutenv_ssii ;
                         IF(  l_ancien_coutenvssii <>TO_NUMBER(l_cout_maj)) THEN
                          -- Fiche 596 : LOGS COUT STD
                          log_coutSTD(to_number(p_couann) ,cuseur_env_sii.dpg_haut, cuseur_env_sii.dpg_bas  ,cuseur_env_sii.metier , ' ' ,
                                 l_time_stamp ,  p_userid , 'COUT_STD2'  ,
                                 'COUTENV_SSII' , TO_CHAR( l_ancien_coutenvssii) , l_cout_maj ,3 ,
                                 p_commentaire_update ) ;
                         END IF ;
                END ;
          END LOOP ;
        --------------------------------------------------------------------------------------------------------------------

			UPDATE COUT_STD2 SET
		     		dpg_bas      = TO_NUMBER(p_codsg_bas_new),
		     		dpg_haut     = TO_NUMBER(p_codsg_haut),
					coutenv_ssii = TO_NUMBER(l_cout_maj),
					flaglock     = decode( l_flaglock, 1000000, 0, l_flaglock + 1)
			 WHERE annee   = TO_NUMBER(p_couann)
			   AND dpg_bas = TO_NUMBER(p_codsg_bas_old)
			   and metier  = decode(i,1,'ME',2,'MO',3,'HOM',4,'GAP')
	      	   and flaglock = l_flaglock ;

			IF SQL%NOTFOUND THEN
	        	pack_global.recuperer_message(20999, NULL, NULL, NULL, l_msg);
	        	raise_application_error( -20999, l_msg );
	      	ELSE
	        	pack_global.recuperer_message(2017, '%s1', p_couann, NULL, l_msg);
				p_message := l_msg;
	      	END IF;

			-- Cas particulier pour metier GAP à recopier dans metier EXP, SAU,FOR
			if (i=4) then

            ----------- Fiche 596 : LOGS COUT STD   ---------------------------------------------------------------------------
             -- On ne logue pas les métiers 'EXP', 'SAU','FOR' car ils n'apparaissent pas à l'écran
              /*FOR cuseur_envsiigap IN cur_ensg_gap (p_couann  ,p_codsg_bas_old  , l_flaglock )  LOOP
                    BEGIN
                        l_ancien_coutenvssii :=  cuseur_envsiigap.coutenv_ssii ;
                         IF(  l_ancien_coutenvssii <>TO_NUMBER(l_cout_maj)) THEN
                          -- Fiche 596 : LOGS COUT STD
                          log_coutSTD(to_number(p_couann),cuseur_envsiigap.dpg_haut ,cuseur_envsiigap.dpg_haut  ,cuseur_envsiigap.metier , ' ' ,
                                 l_time_stamp ,  p_userid , 'COUT_STD2'  ,
                                 'COUTENV_SSII' , TO_CHAR( l_ancien_coutenvssii) , l_cout_maj ,3 ,
                                 p_commentaire_update ) ;
                         END IF ;
                    END ;
              END LOOP ;*/
            --------------------------------------------------------------------------------------------------------------------

				UPDATE COUT_STD2 SET
			     		dpg_bas      = TO_NUMBER(p_codsg_bas_new),
			     		dpg_haut     = TO_NUMBER(p_codsg_haut),
						coutenv_ssii = TO_NUMBER(l_cout_maj),
						flaglock     = decode( l_flaglock, 1000000, 0, l_flaglock + 1)
				 WHERE annee   = TO_NUMBER(p_couann)
				   AND dpg_bas = TO_NUMBER(p_codsg_bas_old)
				   and ( metier = 'EXP' or metier = 'SAU' or metier = 'FOR' )
		      	   and flaglock = l_flaglock ;

				IF SQL%NOTFOUND THEN
		        	pack_global.recuperer_message(20999, NULL, NULL, NULL, l_msg);
		        	raise_application_error( -20999, l_msg );
		      	ELSE
		        	pack_global.recuperer_message(2017, '%s1', p_couann, NULL, l_msg);
					p_message := l_msg;
		      	END IF;
			end if;

			i := i+1;
		END LOOP;


	end if;

	commit;

  END update_cout_standard;




/************************************************************************************/
/*                                                                                  */
/*       SUPPRESSION des couts standard                                             */
/*                                                                                  */
/************************************************************************************/
   PROCEDURE delete_cout_standard (p_couann    IN  VARCHAR2,
			  	   p_codsg_bas IN  VARCHAR2,
                       		   p_flaglock  IN  NUMBER,
				   p_choix	IN  VARCHAR2,
                       		   userid    IN  VARCHAR2,
                       		   p_nbcurseur OUT INTEGER,
                       		   p_message   OUT VARCHAR2
                         ) IS

      l_msg VARCHAR(1024);
      referential_integrity EXCEPTION;
      PRAGMA EXCEPTION_INIT(referential_integrity, -2292);


    l_time_stamp DATE ;
    p_userid VARCHAR2(30) ;
    p_commentaire_delete VARCHAR2(200) ;
    l_dpg_haut NUMBER(7) ;
    
    l_coutsg NUMBER(6,2) ;     
    l_coutenv_sg NUMBER(6,2) ;
    l_coutenv_ssii NUMBER(6,2) ;
    
     CURSOR cur_couts_sg IS    
            SELECT NIVEAU , METIER , COUT_SG  
             FROM COUT_STD_SG            
        	  WHERE annee = TO_NUMBER(p_couann)
			  and dpg_bas = to_number(p_codsg_bas) ;
              
    CURSOR cur_coutd2 IS    
            SELECT  COUT_LOG ,        
            COUTENV_SG ,
            COUTENV_SSII ,
            METIER  
             FROM COUT_STD2            
        	  WHERE annee = TO_NUMBER(p_couann)
			  and dpg_bas = to_number(p_codsg_bas) ;
                            
    
    
    BEGIN

      p_userid := pack_global.lire_globaldata(userid).idarpege;

      p_commentaire_delete := 'Supression' ;

      SELECT TO_DATE(TO_CHAR(SYSDATE,'DD/MM/YYYY')) INTO l_time_stamp FROM DUAL   ;

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

      BEGIN
	if (p_choix='SG') then
    
            SELECT dpg_haut INTO l_dpg_haut FROM cout_std_sg
        	WHERE annee = TO_NUMBER(p_couann)
			and dpg_bas = to_number(p_codsg_bas) AND ROWNUM = 1 ;

            ----------- Fiche 596 : LOGS COUT STD   ---------------------------------------------------------------------------
            FOR curseur_std IN  cur_couts_sg LOOP 
                BEGIN 
                 log_coutSTD(to_number(p_couann),l_dpg_haut,to_number(p_codsg_bas) ,curseur_std.METIER ,curseur_std.NIVEAU,
                    l_time_stamp ,  p_userid , 'COUT_STD_SG'  ,
                    'COUT_SG' , TO_CHAR(curseur_std.COUT_SG) , ' ' ,2 ,
                     p_commentaire_delete ) ;                
                END ; 
            END LOOP ; 
                    
         		DELETE FROM cout_std_sg
        		 WHERE annee = TO_NUMBER(p_couann)
			and dpg_bas = to_number(p_codsg_bas);

	else


            SELECT dpg_haut INTO l_dpg_haut FROM cout_std2
        	WHERE annee = TO_NUMBER(p_couann)
			and dpg_bas = to_number(p_codsg_bas) AND ROWNUM = 1 ;

            ----------- Fiche 596 : LOGS COUT STD   ---------------------------------------------------------------------------
             FOR curseur_stdg IN  cur_coutd2 LOOP 
                BEGIN 
                 log_coutSTD(to_number(p_couann),l_dpg_haut,to_number(p_codsg_bas) ,curseur_stdg.METIER ,' ',
                    l_time_stamp ,  p_userid , 'COUT_STD2'  ,
                    'COUT_LOG' , TO_CHAR(curseur_stdg.COUT_LOG) , ' ' ,2 ,
                     p_commentaire_delete ) ;
                     
                     log_coutSTD(to_number(p_couann),l_dpg_haut,to_number(p_codsg_bas) ,curseur_stdg.METIER ,' ',
                    l_time_stamp ,  p_userid , 'COUT_STD2'  ,
                    'COUTENV_SG' , TO_CHAR(curseur_stdg.COUTENV_SG) , ' ' ,2 ,
                     p_commentaire_delete ) ;                
                     
                     log_coutSTD(to_number(p_couann),l_dpg_haut,to_number(p_codsg_bas) ,curseur_stdg.METIER ,' ',
                    l_time_stamp ,  p_userid , 'COUT_STD2'  ,
                    'COUTENV_SSII' , TO_CHAR(curseur_stdg.COUTENV_SSII) , ' ' ,2 ,
                     p_commentaire_delete ) ;                                
                END ; 
            END LOOP ; 
 
 

		DELETE FROM cout_std2
        		 WHERE annee  = TO_NUMBER(p_couann)
			and dpg_bas = to_number(p_codsg_bas);


	end if;
      EXCEPTION

         WHEN referential_integrity THEN

            -- habiller le msg erreur

            pack_global.recuperation_integrite(-2292);

         WHEN OTHERS THEN
            raise_application_error( -20997, SQLERRM );
      END;

      IF SQL%NOTFOUND THEN
         pack_global.recuperer_message(20999, NULL, NULL, NULL, l_msg);
         raise_application_error( -20999, l_msg );
      ELSE
         pack_global.recuperer_message(2018, '%s1', p_couann, NULL, l_msg);
         p_message := l_msg;
      END IF;

   END delete_cout_standard;



/********************************************************************************/
/*                                                                              */
/*                 Sélection pour la mise à jour suppression                    */
/*                                                                              */
/********************************************************************************/
PROCEDURE select_cout_standard (p_couann    IN VARCHAR2,
		       				    p_codsg_bas IN VARCHAR2,
                       			p_userid    IN VARCHAR2,
                       			p_curcout   IN OUT coutCurType,
                       			p_nbcurseur    OUT INTEGER,
                       			p_message      OUT VARCHAR2
                      ) IS

     l_msg VARCHAR(1024);
BEGIN

    -- Positionner le nb de curseurs ==> 1
    -- Initialiser le message retour

    p_nbcurseur := 1;
    p_message := '';

    -- TEST p_couann > 1900 et < 3000

    IF TO_NUMBER(p_couann) < 1900 OR TO_NUMBER(p_couann) > 3000 THEN
        pack_global.recuperer_message(20242, NULL, NULL, NULL, l_msg);
        raise_application_error( -20242, l_msg);
    END IF;

    -- Attention ordre des colonnes doit correspondre a l ordre
    -- de declaration dans la table ORACLE (a cause de ROWTYPE)
    -- ou selectionner toutes les colonnes par *

    BEGIN
        OPEN p_curcout FOR

            select to_char(annee),
				   to_char(dpg_bas,'FM0000000'),
				   to_char(dpg_haut,'FM0000000'),
				   get_coutstandard (p_couann ,p_codsg_bas,'ME')  me,
				   get_coutstandard (p_couann ,p_codsg_bas,'MO')  mo,
				   get_coutstandard (p_couann ,p_codsg_bas,'HOM') hom,
				   get_coutstandard (p_couann ,p_codsg_bas,'GAP') gap,
				   flaglock
		      from cout_std2
	         where annee   = to_number(p_couann)
	           and dpg_bas = to_number(p_codsg_bas)
			   and rownum  = 1;

    EXCEPTION
        WHEN OTHERS THEN
		    raise_application_error( -20997, SQLERRM );
    END;

    -- en cas absence
    -- p_message := 'Le cout n'existe pas';

    pack_global.recuperer_message(2019, '%s1', p_couann, NULL, l_msg);
    p_message := l_msg;

END select_cout_standard;





PROCEDURE select_cout_standard_sg (p_couann    IN VARCHAR2,
		       		p_codsg_bas IN VARCHAR2,
                       		p_userid    IN VARCHAR2,
                       		p_curcout   IN OUT coutSgCurType,
                       		p_nbcurseur    OUT INTEGER,
                       		p_message      OUT VARCHAR2
                      ) IS

     l_msg VARCHAR(1024);

   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_nbcurseur := 1;
      p_message := '';

      -- TEST p_couann > 1900 et < 3000


      IF TO_NUMBER(p_couann) < 1900 OR TO_NUMBER(p_couann) > 3000 THEN
         pack_global.recuperer_message(20242, NULL, NULL, NULL, l_msg);
         raise_application_error( -20242, l_msg);
      END IF;

      -- Attention ordre des colonnes doit correspondre a l ordre
      -- de declaration dans la table ORACLE (a cause de ROWTYPE)
      -- ou selectionner toutes les colonnes par *

      BEGIN
         OPEN p_curcout FOR

            select distinct
		 to_char(annee),
		to_char(dpg_bas,'FM0000000'),
		to_char(dpg_haut,'FM0000000'),
		to_char(get_coutstandard_sg (p_couann ,p_codsg_bas,niveau,'ME'),'FM9999D00')  me,
		to_char(get_coutstandard_sg (p_couann ,p_codsg_bas,niveau,'MO'),'FM9999D00')  mo,
		to_char(get_coutstandard_sg (p_couann ,p_codsg_bas,niveau,'HOM'),'FM9999D00') hom,
		to_char(get_coutstandard_sg (p_couann ,p_codsg_bas,niveau,'GAP'),'FM9999D00') gap,
		niveau,
		length(niveau) longueur,
		flaglock
	from cout_std_sg
	where annee = to_number(p_couann)
	and dpg_bas = to_number(p_codsg_bas)
	order by length(niveau),niveau	;

      EXCEPTION

         WHEN OTHERS THEN
		raise_application_error( -20997, SQLERRM );
      END;

      -- en cas absence
      -- p_message := 'Le cout n'existe pas';

         pack_global.recuperer_message(2019, '%s1', p_couann, NULL, l_msg);
         p_message := l_msg;

   END select_cout_standard_sg;





/************************************************************************************/
/*                                                                                  */
/*       CONTROLE LA COHERENCE DES PLAGES DE DPG des couts standard                 */
/*                                                                                  */
/************************************************************************************/
PROCEDURE controle_cout_standard (	p_couann    IN  VARCHAR2,
                       		 		p_userid    IN  VARCHAR2,
                       		 		p_message   OUT VARCHAR2
                      ) IS

    l_msg VARCHAR(1024);
    dpg_bas_old cout_std2.dpg_bas%TYPE;
    dpg_haut_old cout_std2.dpg_haut%TYPE;

    dpg_bas_first cout_std2.dpg_bas%TYPE;
    flag_dpg_max number(1);

    CURSOR curs_coutstd IS
     	   SELECT distinct annee couann,
	       		  dpg_bas codsg_bas,
	    		  dpg_haut codsg_haut
             FROM cout_std2
     		WHERE annee = TO_NUMBER(p_couann)
            order by 1,2,3;

    curs_coutstd_enreg curs_coutstd%ROWTYPE;
BEGIN

    -- Initialiser le message retour et flag
	p_message := ' ';
	flag_dpg_max := 0;
    -- TEST p_couann > 1900 et < 3000

    IF TO_NUMBER(p_couann) < 1900 OR TO_NUMBER(p_couann) > 3000 THEN
        pack_global.recuperer_message(20242, NULL, NULL, NULL, l_msg);
        raise_application_error( -20242, l_msg);
    END IF;

    -- Attention ordre des colonnes doit correspondre a l ordre
    -- de declaration dans la table ORACLE (a cause de ROWTYPE)
    -- ou selectionner toutes les colonnes par *

	BEGIN

	    OPEN curs_coutstd;

	  	FETCH curs_coutstd INTO curs_coutstd_enreg;

	    IF curs_coutstd%FOUND THEN
			dpg_bas_first := curs_coutstd_enreg.codsg_bas;

		  	dpg_bas_old := curs_coutstd_enreg.codsg_bas;
		  	dpg_haut_old := curs_coutstd_enreg.codsg_haut;
			if(dpg_haut_old = 9999999) then flag_dpg_max := 1;
			end if;
	    ELSE
			p_message := 'Aucune tranche de DPG pour l''année ' || p_couann || '.';
	    END IF;

        FETCH curs_coutstd INTO curs_coutstd_enreg;

	  	WHILE curs_coutstd%FOUND LOOP

			IF (curs_coutstd_enreg.codsg_bas <= dpg_haut_old) THEN

			    p_message :=p_message || ' Recouvrement entre les tranches DPG : '|| to_char(dpg_bas_old,'0000000') ||'-'|| to_char(dpg_haut_old,'0000000') || ' et ' || to_char(curs_coutstd_enreg.codsg_bas,'0000000') ||'-'||to_char(curs_coutstd_enreg.codsg_haut,'0000000') || '.';

				dpg_bas_old := curs_coutstd_enreg.codsg_bas;
	  			dpg_haut_old := curs_coutstd_enreg.codsg_haut;
				if(dpg_haut_old = 9999999) then flag_dpg_max := 1;
				end if;

		    ELSIF (curs_coutstd_enreg.codsg_bas > dpg_haut_old+1) THEN

				p_message := p_message || ' Vide entre les tranches DPG : ' || to_char(dpg_bas_old,'0000000') || '-' || to_char(dpg_haut_old,'0000000') || ' et ' ||	to_char(curs_coutstd_enreg.codsg_bas,'0000000') || '-' || to_char(curs_coutstd_enreg.codsg_haut,'0000000') ||'.';

				dpg_bas_old := curs_coutstd_enreg.codsg_bas;
		  		dpg_haut_old := curs_coutstd_enreg.codsg_haut;
				if(dpg_haut_old = 9999999) then flag_dpg_max := 1;
				end if;

			ELSE
				dpg_bas_old := curs_coutstd_enreg.codsg_bas;
				dpg_haut_old := curs_coutstd_enreg.codsg_haut;
				if(dpg_haut_old = 9999999) then flag_dpg_max := 1;
				end if;
			END IF;

	  	    FETCH curs_coutstd INTO curs_coutstd_enreg;

	    END LOOP;

	   CLOSE curs_coutstd;
    END;

	IF (dpg_bas_first <> 0000000 OR flag_dpg_max <> 1) THEN
		p_message :=  p_message || ' Tranches de DPG incomplètes.' ;
	END IF;
	IF (p_message = ' ') THEN
		p_message := 'Les tranches de codes DPG sont ok pour l''année ' || p_couann || ' Pas de recouvrement ni de vide.';
	END IF;

END controle_cout_standard;






PROCEDURE controle_cout_standard_sg (p_couann    IN  VARCHAR2,
                       		 		p_userid    IN  VARCHAR2,
                       		 		p_message   OUT VARCHAR2
                      ) IS

     l_msg VARCHAR(1024);
     dpg_bas_old cout_std_sg.dpg_bas%TYPE;
     dpg_haut_old cout_std_sg.dpg_haut%TYPE;

     dpg_bas_first cout_std_sg.dpg_bas%TYPE;
     flag_dpg_max number(1);


     CURSOR curs_coutstd_sg IS
     SELECT distinct annee couann,
	    dpg_bas codsg_bas,
	    dpg_haut codsg_haut
     FROM cout_std_sg
     WHERE annee = TO_NUMBER(p_couann)
     order by 1,2,3;

     curs_coutstd_enreg_sg curs_coutstd_sg%ROWTYPE;

   BEGIN

      -- Initialiser le message retour et flag
	    p_message := ' ';
	    flag_dpg_max := 0;
      -- TEST p_couann > 1900 et < 3000



      IF TO_NUMBER(p_couann) < 1900 OR TO_NUMBER(p_couann) > 3000 THEN
         pack_global.recuperer_message(20242, NULL, NULL, NULL, l_msg);
         raise_application_error( -20242, l_msg);
      END IF;

      -- Attention ordre des colonnes doit correspondre a l ordre
      -- de declaration dans la table ORACLE (a cause de ROWTYPE)
      -- ou selectionner toutes les colonnes par *

	   BEGIN

	  OPEN curs_coutstd_sg;

	  FETCH curs_coutstd_sg INTO curs_coutstd_enreg_sg;

	  IF curs_coutstd_sg%FOUND THEN
		dpg_bas_first := curs_coutstd_enreg_sg.codsg_bas;

	  	dpg_bas_old := curs_coutstd_enreg_sg.codsg_bas;
	  	dpg_haut_old := curs_coutstd_enreg_sg.codsg_haut;
		if(dpg_haut_old = 9999999) then flag_dpg_max := 1;
		end if;
	  ELSE
		p_message := 'Aucune tranche de DPG pour l''année ' || p_couann || '.';
	  END IF;

          FETCH curs_coutstd_sg INTO curs_coutstd_enreg_sg;

	  WHILE curs_coutstd_sg%FOUND LOOP

		IF (curs_coutstd_enreg_sg.codsg_bas <= dpg_haut_old) THEN

			p_message :=p_message || ' Recouvrement entre les tranches DPG : '|| to_char(dpg_bas_old,'0000000') ||'-'|| to_char(dpg_haut_old,'0000000') || ' et ' || to_char(curs_coutstd_enreg_sg.codsg_bas,'0000000') ||'-'||to_char(curs_coutstd_enreg_sg.codsg_haut,'0000000') || '.';

			dpg_bas_old := curs_coutstd_enreg_sg.codsg_bas;
	  		dpg_haut_old := curs_coutstd_enreg_sg.codsg_haut;
			if(dpg_haut_old = 9999999) then flag_dpg_max := 1;
			end if;

		ELSIF (curs_coutstd_enreg_sg.codsg_bas > dpg_haut_old+1) THEN

			p_message := p_message || ' Vide entre les tranches DPG : ' || to_char(dpg_bas_old,'0000000') || '-' || to_char(dpg_haut_old,'0000000') || ' et ' ||	to_char(curs_coutstd_enreg_sg.codsg_bas,'0000000') || '-' || to_char(curs_coutstd_enreg_sg.codsg_haut,'0000000') ||'.';

			dpg_bas_old := curs_coutstd_enreg_sg.codsg_bas;
	  		dpg_haut_old := curs_coutstd_enreg_sg.codsg_haut;
			if(dpg_haut_old = 9999999) then flag_dpg_max := 1;
			end if;

		ELSE
			dpg_bas_old := curs_coutstd_enreg_sg.codsg_bas;
			dpg_haut_old := curs_coutstd_enreg_sg.codsg_haut;
			if(dpg_haut_old = 9999999) then flag_dpg_max := 1;
			end if;
		END IF;

	  	FETCH curs_coutstd_sg INTO curs_coutstd_enreg_sg;

	  END LOOP;

	  CLOSE curs_coutstd_sg;
	   END;

	IF (dpg_bas_first <> 0000000 OR flag_dpg_max <> 1) THEN
		p_message :=  p_message || ' Tranches de DPG incomplètes.' ;
	END IF;
	IF (p_message = ' ') THEN
		p_message := 'Les tranches de codes DPG sont ok pour l''année ' || p_couann || ' Pas de recouvrement ni de vide.';
	END IF;

   END controle_cout_standard_sg;

 FUNCTION get_coutstandard_sg (p_anneestd   	 IN VARCHAR2,
					p_dpg_bas      IN VARCHAR2,
					p_niveau  	IN VARCHAR2,
					p_metier  	IN VARCHAR2)
RETURN NUMBER IS
l_cout NUMBER(6,2);
BEGIN
	select cout_sg into l_cout
	from cout_std_sg
	where annee = to_number(p_anneestd)
	and dpg_bas = to_number(p_dpg_bas)
	and RTRIM(niveau)=RTRIM(p_niveau)
	and RTRIM(metier)=RTRIM(p_metier) ;

 RETURN l_cout;

 EXCEPTION
         WHEN OTHERS THEN
		raise_application_error( -20997, SQLERRM );

END get_coutstandard_sg;



/*************************************************************************/
/*         Retourne le cout suivant le metier							 */
/*************************************************************************/
FUNCTION get_coutstandard (p_anneestd IN VARCHAR2,
						   p_dpg_bas  IN VARCHAR2,
						   p_metier   IN VARCHAR2) RETURN VARCHAR2 IS
	l_cout VARCHAR2(500);
BEGIN

	select to_char(cout_log,'FM9999D00')||';'||to_char(coutenv_sg,'FM9999D00')||';'||to_char(coutenv_ssii,'FM9999D00')||';'
	  into l_cout
	  from cout_std2
	 where annee = to_number(p_anneestd)
	   and dpg_bas = to_number(p_dpg_bas)
	   and RTRIM(metier)=RTRIM(p_metier) ;

	RETURN l_cout;

EXCEPTION
    WHEN OTHERS THEN
		raise_application_error( -20997, SQLERRM );

END get_coutstandard;




-- Permet de loggeur un insert sur la table COUTSTD2 ou COUSTSG


-- Permet de loggeur un insert sur la table COUTSTD2 ou COUSTSG
PROCEDURE log_coutSTD(p_couann IN NUMBER,p_codsg_haut  IN NUMBER ,p_codsg_bas IN NUMBER ,l_metier IN VARCHAR2  ,l_niveau IN VARCHAR2,
                     l_time_stamp IN DATE , p_userid IN VARCHAR2 , p_nom_table IN VARCHAR2  ,
                     p_nom_colonne IN VARCHAR2 , p_val_prec IN VARCHAR2 , p_val_new IN VARCHAR2 ,type_action IN NUMBER ,
                     p_commentaire IN VARCHAR2 )   IS


BEGIN



            -- Fiche 596 : LOGS COUT STD
           INSERT INTO  COUT_STD2_LOG

            (
              ANNEE       , -- NUMBER(4),
              DPG_HAUT    , --  NUMBER(7),
              DPG_BAS     , --  NUMBER(7),
              METIER       , -- VARCHAR2(3 BYTE),
              NIVEAU ,

              DATE_LOG    , --  DATE                             NOT NULL,
              USER_LOG    , --  VARCHAR2(30 BYTE)                NOT NULL,
              NOM_TABLE   , --  VARCHAR2(30 BYTE)                NOT NULL,

              COLONNE     , --  VARCHAR2(30 BYTE)                NOT NULL,
              VALEUR_PREC , --  VARCHAR2(30 BYTE),
              VALEUR_NOUV , --  VARCHAR2(30 BYTE),

              TYPE_ACTION  , -- NUMBER,
              COMMENTAIRE   --  VARCHAR2(200 BYTE)
            ) VALUES  (
               p_couann ,
               p_codsg_haut,
               p_codsg_bas,
               l_metier,
               l_niveau ,

               l_time_stamp ,
               p_userid ,
               p_nom_table,

               p_nom_colonne ,
               p_val_prec ,
               p_val_new ,

               type_action,
               p_commentaire
               );

EXCEPTION
    WHEN OTHERS THEN

        RAISE_APPLICATION_ERROR( -20997, SQLERRM );

END log_coutSTD;




END pack_cout_standard;
/
