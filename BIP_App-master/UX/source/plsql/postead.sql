CREATE OR REPLACE PACKAGE BIP.pack_poste AS
   
   TYPE poste_ViewType IS RECORD ( cod_poste    VARCHAR2(4),
                                   lib_poste    poste.lib_poste%TYPE,                                  	 	                    
					 	           flaglock   	poste.flaglock%TYPE
						          );

   TYPE posteCurType IS REF CURSOR RETURN poste_ViewType;
  

   PROCEDURE insert_poste ( 	                     
                         p_poste     in VARCHAR2,
                         p_lib_poste in poste.lib_poste%TYPE,					                
 	                     p_flaglock  in poste.flaglock%TYPE,
                         p_message   out VARCHAR2
                                 );

   PROCEDURE update_poste (p_poste     in VARCHAR2,
                           p_lib_poste in poste.lib_poste%TYPE,					                
 	                       p_flaglock  in poste.flaglock%TYPE,
                           p_message   out VARCHAR2
                              );

   PROCEDURE delete_poste (p_poste     in VARCHAR2,
                           p_lib_poste in poste.lib_poste%TYPE,					                
 	                       p_flaglock  in poste.flaglock%TYPE,
                           p_message   out VARCHAR2
                                   );

   PROCEDURE select_poste_c ( p_poste  in VARCHAR2,                                  
                              p_curseur IN OUT posteCurType,
                              p_message  out VARCHAR2
                                );
                                
   PROCEDURE select_poste_m ( p_poste  in VARCHAR2,                                  
                              p_curseur IN OUT posteCurType,
                              p_message  out VARCHAR2
                             );


END pack_poste;
/


CREATE OR REPLACE PACKAGE BODY BIP.pack_poste AS

       PROCEDURE insert_poste (p_poste     in VARCHAR2,
                        p_lib_poste in poste.lib_poste%TYPE,					                
 	                    p_flaglock  in poste.flaglock%TYPE,
                        p_message   out VARCHAR2
  
                                 ) IS
       l_msg VARCHAR2(1024);  
       l_poste poste.lib_poste%TYPE;                        
       
       BEGIN
          p_message := '';
          
          begin
            select codposte into l_poste
            from poste where codposte=to_number(p_poste);
            
            -- test si le poste n'existe pas déjà.
                        
            if(l_poste is not null OR l_poste != null) then
                pack_global.recuperer_message( 20968, '%s1', p_poste, NULL, l_msg);
                p_message := l_msg;              
                raise_application_error( -20968, l_msg );             
            end if;
            
            EXCEPTION    
            WHEN NO_DATA_FOUND THEN 
               begin
                -- création du poste
                insert into poste(codposte, lib_poste, flaglock)
                values
                (
                 p_poste,
                 p_lib_poste,
                 0
                );                  
                pack_global.recuperer_message(20971, '%s1', 'Code poste ' || p_poste, NULL, l_msg);	
                p_message := l_msg;                
              end;          
            
            WHEN OTHERS THEN raise_application_error( -20997, SQLERRM);         
          end;
          
       END insert_poste;
       
       /******************** PROCEDURE update_poste ******************/

       PROCEDURE update_poste (p_poste     in VARCHAR2,
                               p_lib_poste in poste.lib_poste%TYPE,					                
 	                           p_flaglock  in poste.flaglock%TYPE,
                               p_message   out VARCHAR2
                              )IS
       l_msg VARCHAR2(1024); 
       l_poste poste.codposte%TYPE;                         
       
       BEGIN
       p_message := '';
          
          -- test si le poste existe .
          
          begin
            select codposte into l_poste
            from poste where codposte=to_number(p_poste);
            
            update poste set 
            lib_poste = p_lib_poste,
            codposte = to_number(p_poste),            
            flaglock 	= DECODE( p_flaglock, 1000000, 0, p_flaglock + 1 ) 
            where codposte = TO_NUMBER(p_poste)
            and   flaglock 	= p_flaglock;
            
            -- 'Poste modifié
            pack_global.recuperer_message(20972, '%s1', 'Code poste ' || p_poste, NULL, l_msg);	
            p_message := l_msg;                

            EXCEPTION    
            WHEN NO_DATA_FOUND THEN 
                pack_global.recuperer_message( 20969, '%s1', p_poste, NULL, l_msg);
                p_message := l_msg;             
                raise_application_error( -20969, l_msg );             
            WHEN OTHERS THEN raise_application_error( -20997, SQLERRM);              
                   
          end;
          
       END update_poste;
       
       /******************** PROCEDURE delete_poste ******************/

       PROCEDURE delete_poste (p_poste     in VARCHAR2,
                               p_lib_poste in poste.lib_poste%TYPE,					                
 	                           p_flaglock  in poste.flaglock%TYPE,
                               p_message   out VARCHAR2                                 
                              )IS
       l_msg VARCHAR2(1024);         
       referential_integrity EXCEPTION;
       PRAGMA EXCEPTION_INIT(referential_integrity, -2292);
       
       BEGIN
          -- Initialiser le message retour   
          p_message := '';             
          
          begin
        	   DELETE FROM poste
        		      WHERE codposte = TO_NUMBER(p_poste)
        			  AND flaglock = p_flaglock;                  
               EXCEPTION 
               WHEN referential_integrity THEN
               -- habiller le msg erreur
               --pack_global.recuperation_integrite(-2292);       
               pack_global.recuperer_message( 20970, '%s1', p_poste,'%s2','poste', NULL, l_msg); 
               p_message := l_msg;
               raise_application_error( -20970, l_msg );                         
        	   WHEN OTHERS THEN raise_application_error( -20997, SQLERRM);
          end;

          IF SQL%NOTFOUND THEN    
    	   -- 'Accès concurrent'    
    	    pack_global.recuperer_message( 20999, NULL, NULL, NULL, l_msg);
            raise_application_error( -20999, l_msg );    
          ELSE    
    	   -- 'Le poste p_poste a été supprimé'    
    	   pack_global.recuperer_message( 20973, '%s1', 'Code poste ' || p_poste, NULL, l_msg);    	     
          END IF;
          
          p_message := l_msg;          
       
       END delete_poste;
       
       /******************** PROCEDURE select_poste ******************/

       PROCEDURE select_poste_c ( p_poste  in VARCHAR2,                                  
                                  p_curseur IN OUT posteCurType,
                                  p_message  out VARCHAR2
                                )IS
       l_msg VARCHAR2(1024);                           
       
       BEGIN
         
              OPEN p_curseur FOR SELECT               	
                   TO_CHAR(codposte) as codposte,
                   lib_poste,                     	
                   flaglock	
              FROM  poste
              WHERE codposte = TO_NUMBER(p_poste);             
              
              pack_global.recuperer_message( 20968, '%s1', p_poste, NULL, l_msg);
              p_message := l_msg;

            EXCEPTION WHEN OTHERS THEN raise_application_error( -20997, SQLERRM);     
       
       END select_poste_c;
       
       PROCEDURE select_poste_m (p_poste  in VARCHAR2,                                  
                                 p_curseur IN OUT posteCurType,
                                 p_message  out VARCHAR2
                                )IS
       l_msg VARCHAR2(1024);                           
       
       BEGIN
         
              OPEN p_curseur FOR SELECT               	
                   TO_CHAR(codposte) as codposte,
                   lib_poste,                     	
                   flaglock	
              FROM  poste
              WHERE codposte = TO_NUMBER(p_poste);          
              
              pack_global.recuperer_message( 20969, '%s1', p_poste, NULL, l_msg);
              p_message := l_msg;

            EXCEPTION WHEN OTHERS THEN raise_application_error( -20997, SQLERRM);     
       
       END select_poste_m;



END pack_poste;
/


