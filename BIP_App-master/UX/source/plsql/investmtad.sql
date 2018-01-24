CREATE OR REPLACE PACKAGE BIP.pack_investissement AS

   TYPE investissement_ViewType IS RECORD ( cod_type   	VARCHAR2(4),
					 	                    lib_type    investissements.lib_type%TYPE,
                                  	 	    cod_poste    VARCHAR2(4),
                                            lib_poste   poste.lib_poste%TYPE,
                                  	 	    cod_nature  	VARCHAR2(4),	
                                            lib_nature  nature.lib_nature%TYPE,			                
					 	                    flaglock   	investissements.flaglock%TYPE
						                   );

   TYPE investissementCurType IS REF CURSOR RETURN investissement_ViewType;
  

   PROCEDURE insert_investissement (p_type  in VARCHAR2,
 	                     p_lib_type  in investissements.lib_type%TYPE,
                         p_poste     in VARCHAR2,
                         p_nature    in VARCHAR2,						                
 	                     p_flaglock  in investissements.flaglock%TYPE,
                         p_message   out VARCHAR2
                                 );

   PROCEDURE update_investissement (p_type     	in VARCHAR2,
					 	            p_lib_type  in investissements.lib_type%TYPE,
                                  	p_poste    	in VARCHAR2,
                                  	p_nature    in VARCHAR2,						                
					 	            p_flaglock  in investissements.flaglock%TYPE,
                                  	p_message   out VARCHAR2
                              );

   PROCEDURE delete_investissement ( p_type    in VARCHAR2,
                                     p_lib_type  in VARCHAR2,
                                     p_flaglock  in investissements.flaglock%TYPE,
                                     p_message out VARCHAR2
                                   );

   PROCEDURE select_investissement_c ( p_type     in VARCHAR2,                                  
                                     p_curseur IN OUT investissementCurType,
                                     p_message  out VARCHAR2
                                );
                                
   PROCEDURE select_investissement_m ( p_type     in VARCHAR2,                                  
                                     p_curseur IN OUT investissementCurType,
                                     p_message  out VARCHAR2
                                );


END pack_investissement;
/


CREATE OR REPLACE PACKAGE BODY BIP.pack_investissement AS
       
       PROCEDURE insert_investissement (p_type  in VARCHAR2,
                	                    p_lib_type  in investissements.lib_type%TYPE,
                                        p_poste     in VARCHAR2,
                                        p_nature    in VARCHAR2,						                
                	                    p_flaglock  in investissements.flaglock%TYPE,
                         p_message   out VARCHAR2
                                 ) IS
       l_msg VARCHAR2(1024);  
       l_type investissements.CODTYPE%TYPE;                        
       
       BEGIN
          p_message := '';
          
          begin
            select codtype into l_type
            from investissements where codtype=to_number(p_type);
            
            -- test si le type d'investissement n'existe pas déjà.
                        
            if(l_type is not null OR l_type != null) then
                pack_global.recuperer_message( 20968, '%s1', p_type, NULL, l_msg);
                p_message := l_msg;              
                raise_application_error( -20968, l_msg );             
            end if;
            
            EXCEPTION    
            WHEN NO_DATA_FOUND THEN 
               begin
                -- création du type d'investissement
                insert into investissements(codtype, lib_type, codposte, codnature, flaglock)
                values
                (p_type,
                 p_lib_type,
                 p_poste,
                 p_nature,
                 0
                );                  
                pack_global.recuperer_message(20971, '%s1', 'Code type d''investissement' || p_type, NULL, l_msg);	
                p_message := l_msg;                
              end;          
            
            WHEN OTHERS THEN raise_application_error( -20997, SQLERRM);         
          end;
          
       END insert_investissement;
       
       /******************** PROCEDURE update_investissement ******************/

       PROCEDURE update_investissement (p_type     	in VARCHAR2,
					 	                p_lib_type  in investissements.lib_type%TYPE,
                                  	    p_poste    	in VARCHAR2,
                                  	    p_nature    in VARCHAR2,						                
					 	                p_flaglock  in investissements.flaglock%TYPE,
                                  	    p_message   out VARCHAR2
                              )IS
       l_msg VARCHAR2(1024); 
       l_type investissements.CODTYPE%TYPE;                         
       
       BEGIN
       p_message := '';
          
          -- test si le type d'investissement existe .
          
          begin
            select codtype into l_type
            from investissements where codtype=to_number(p_type);
            
            update investissements set 
            lib_type = p_lib_type,
            codposte = to_number(p_poste),
            codnature = to_number(p_nature),
            flaglock 	= DECODE( p_flaglock, 1000000, 0, p_flaglock + 1 ) 
            where codtype 	= TO_NUMBER(p_type)
            and   flaglock 	= p_flaglock;
            
            -- 'Type d'investissement modifié
            pack_global.recuperer_message(20972, '%s1', 'Code type d''investissement ' || p_type, NULL, l_msg);	
            p_message := l_msg;                

            EXCEPTION    
            WHEN NO_DATA_FOUND THEN 
                pack_global.recuperer_message( 20969, '%s1', p_type, NULL, l_msg);
                p_message := l_msg;             
                raise_application_error( -20969, l_msg );             
            WHEN OTHERS THEN raise_application_error( -20997, SQLERRM);  
                               
          end;
          
       END update_investissement;
       
       /******************** PROCEDURE delete_investissement ******************/

       PROCEDURE delete_investissement ( p_type  in VARCHAR2,
                                         p_lib_type  in VARCHAR2,
                                         p_flaglock  in investissements.flaglock%TYPE,
                                         p_message   out VARCHAR2
                                   )IS
       l_msg VARCHAR2(1024);       
       referential_integrity EXCEPTION;
       PRAGMA EXCEPTION_INIT(referential_integrity, -2292);
       
       BEGIN
          -- Initialiser le message retour   
          p_message := '';             
          
          begin
        	   DELETE FROM investissements
        		      WHERE codtype = TO_NUMBER(p_type)
        			  AND flaglock = p_flaglock;                  
               EXCEPTION 
               WHEN referential_integrity THEN
               -- habiller le msg erreur
               --pack_global.recuperation_integrite(-2292);       
               pack_global.recuperer_message( 20970, '%s1', p_type,'%s2','type d''investissement', NULL, l_msg); 
               p_message := l_msg;
               raise_application_error( -20970, l_msg );                         
        	   WHEN OTHERS THEN raise_application_error( -20997, SQLERRM);
          end;

          IF SQL%NOTFOUND THEN    
    	   -- 'Accès concurrent'    
    	    pack_global.recuperer_message( 20999, NULL, NULL, NULL, l_msg);
            raise_application_error( -20999, l_msg );    
          ELSE    
    	   -- 'Le type d'investissement p_type a été supprimé'    
    	   pack_global.recuperer_message( 20973, '%s1', 'Code type d''investissement ' || p_type, NULL, l_msg);    	     
          END IF;
          
          p_message := l_msg;            
       
       END delete_investissement;
       
       /******************** PROCEDURE select_investissement ******************/

       PROCEDURE select_investissement_c ( p_type     in VARCHAR2,
                                         --p_userid         IN VARCHAR2,
                                         p_curseur IN OUT investissementCurType,
                                         p_message  out VARCHAR2
                                )IS
       l_msg VARCHAR2(1024);                           
       
       BEGIN
         
            OPEN   p_curseur FOR SELECT
                        TO_CHAR(codtype) as codtype,
                     	lib_type,
                     	TO_CHAR(inv.codposte) as codposte,
                        lib_poste,
                     	TO_CHAR(inv.codnature) as codnature,
                        lib_nature,
                        inv.flaglock	
              FROM  investissements inv, poste po, nature nat
              WHERE codtype = TO_NUMBER(p_type)              
              and inv.codposte = po.codposte
              and inv.codnature = nat.codnature;             
              
              pack_global.recuperer_message( 20968, '%s1', p_type, NULL, l_msg);
              p_message := l_msg;

            EXCEPTION WHEN OTHERS THEN raise_application_error( -20997, SQLERRM);     
       
       END select_investissement_c;
       
       PROCEDURE select_investissement_m ( p_type     in VARCHAR2,
                                         --p_userid         IN VARCHAR2,
                                         p_curseur IN OUT investissementCurType,
                                         p_message  out VARCHAR2
                                )IS
       l_msg VARCHAR2(1024);                           
       
       BEGIN
         
            OPEN   p_curseur FOR SELECT
                        TO_CHAR(codtype) as codtype,
                     	lib_type,
                     	TO_CHAR(inv.codposte) as codposte,
                        lib_poste,
                     	TO_CHAR(inv.codnature) as codnature,
                        lib_nature,
                        inv.flaglock	
              FROM  investissements inv, poste po, nature nat
              WHERE codtype = TO_NUMBER(p_type)              
              and inv.codposte = po.codposte
              and inv.codnature = nat.codnature;             
              
              pack_global.recuperer_message( 20969, '%s1', p_type, NULL, l_msg);
              p_message := l_msg;

            EXCEPTION WHEN OTHERS THEN raise_application_error( -20997, SQLERRM);     
       
       END select_investissement_m;


END pack_investissement;
/


