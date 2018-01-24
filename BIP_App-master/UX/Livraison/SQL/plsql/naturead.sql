CREATE OR REPLACE PACKAGE BIP.pack_nature AS
   
   TYPE nature_ViewType IS RECORD ( cod_nature    VARCHAR2(4),
                                   lib_nature    nature.lib_nature%TYPE,                                  	 	                    
					 	           flaglock   	nature.flaglock%TYPE
						          );

   TYPE natureCurType IS REF CURSOR RETURN nature_ViewType;
  

   PROCEDURE insert_nature ( 	                     
                         p_nature     in VARCHAR2,
                         p_lib_nature in nature.lib_nature%TYPE,					                
 	                     p_flaglock  in nature.flaglock%TYPE,
                         p_message   out VARCHAR2
                                 );

   PROCEDURE update_nature (p_nature     in VARCHAR2,
                           p_lib_nature in nature.lib_nature%TYPE,					                
 	                       p_flaglock  in nature.flaglock%TYPE,
                           p_message   out VARCHAR2
                              );

   PROCEDURE delete_nature (p_nature     in VARCHAR2,
                           p_lib_nature in nature.lib_nature%TYPE,					                
 	                       p_flaglock  in nature.flaglock%TYPE,
                           p_message   out VARCHAR2
                                   );

   PROCEDURE select_nature_c ( p_nature  in VARCHAR2,                                  
                              p_curseur IN OUT natureCurType,
                              p_message  out VARCHAR2
                                );
                                
   PROCEDURE select_nature_m ( p_nature  in VARCHAR2,                                  
                              p_curseur IN OUT natureCurType,
                              p_message  out VARCHAR2
                             );


END pack_nature;
/


CREATE OR REPLACE PACKAGE BODY BIP.pack_nature AS

       PROCEDURE insert_nature (p_nature     in VARCHAR2,
                        p_lib_nature in nature.lib_nature%TYPE,					                
 	                    p_flaglock  in nature.flaglock%TYPE,
                        p_message   out VARCHAR2
  
                                 ) IS
       l_msg VARCHAR2(1024);  
       l_nature nature.lib_nature%TYPE;                        
       
       BEGIN
          p_message := '';
          
          begin
            select codnature into l_nature
            from nature where codnature=to_number(p_nature);
            
            -- test si le nature n'existe pas déjà.
                        
            if(l_nature is not null OR l_nature != null) then
                pack_global.recuperer_message( 20968, '%s1', p_nature, NULL, l_msg);
                p_message := l_msg;              
                raise_application_error( -20968, l_msg );             
            end if;
            
            EXCEPTION    
            WHEN NO_DATA_FOUND THEN 
               begin
                -- création du nature
                insert into nature(codnature, lib_nature, flaglock)
                values
                (
                 p_nature,
                 p_lib_nature,
                 0
                );                  
                pack_global.recuperer_message(20971, '%s1', 'Code nature ' || p_nature, NULL, l_msg);	
                p_message := l_msg;                
              end;          
            
            WHEN OTHERS THEN raise_application_error( -20997, SQLERRM);         
          end;
          
       END insert_nature;
       
       /******************** PROCEDURE update_nature ******************/

       PROCEDURE update_nature (p_nature     in VARCHAR2,
                               p_lib_nature in nature.lib_nature%TYPE,					                
 	                           p_flaglock  in nature.flaglock%TYPE,
                               p_message   out VARCHAR2
                              )IS
       l_msg VARCHAR2(1024); 
       l_nature nature.codnature%TYPE;                         
       
       BEGIN
       p_message := '';
          
          -- test si le nature existe .
          
          begin
            select codnature into l_nature
            from nature where codnature=to_number(p_nature);
            
            update nature set 
            lib_nature = p_lib_nature,
            codnature = to_number(p_nature),            
            flaglock 	= DECODE( p_flaglock, 1000000, 0, p_flaglock + 1 ) 
            where codnature = TO_NUMBER(p_nature)
            and   flaglock 	= p_flaglock;
            
            -- 'nature modifié
            pack_global.recuperer_message(20972, '%s1', 'Code nature ' || p_nature, NULL, l_msg);	
            p_message := l_msg;                

            EXCEPTION    
            WHEN NO_DATA_FOUND THEN 
                pack_global.recuperer_message( 20969, '%s1', p_nature, NULL, l_msg);
                p_message := l_msg;             
                raise_application_error( -20969, l_msg );             
            WHEN OTHERS THEN raise_application_error( -20997, SQLERRM);              
                   
          end;
          
       END update_nature;
       
       /******************** PROCEDURE delete_nature ******************/

       PROCEDURE delete_nature (p_nature     in VARCHAR2,
                               p_lib_nature in nature.lib_nature%TYPE,					                
 	                       p_flaglock  in nature.flaglock%TYPE,
                               p_message   out VARCHAR2                                 
                              )IS
       l_msg VARCHAR2(1024);         
       referential_integrity EXCEPTION;
       PRAGMA EXCEPTION_INIT(referential_integrity, -2292);
       
       BEGIN
          -- Initialiser le message retour   
          p_message := '';             
          
          begin
        	DELETE FROM nature
        	WHERE codnature = TO_NUMBER(p_nature)
        	AND flaglock = p_flaglock;                  
               EXCEPTION 
               WHEN referential_integrity THEN
               -- habiller le msg erreur
               --pack_global.recuperation_integrite(-2292);       
               pack_global.recuperer_message( 20970, '%s1', p_nature,'%s2','nature', NULL, l_msg); 
               p_message := l_msg;
               raise_application_error( -20970, l_msg );                         
        	   WHEN OTHERS THEN raise_application_error( -20997, SQLERRM);
          end;

          IF SQL%NOTFOUND THEN    
    	   -- 'Accès concurrent'    
    	    pack_global.recuperer_message( 20999, NULL, NULL, NULL, l_msg);
            raise_application_error( -20999, l_msg );    
          ELSE    
    	   -- 'Le code nature p_nature a été supprimé'    
    	   pack_global.recuperer_message( 20973, '%s1', 'Code nature ' || p_nature, NULL, l_msg);    	     
          END IF;
          
          p_message := l_msg;          
       
       END delete_nature;
       
       /******************** PROCEDURE select_nature ******************/

       PROCEDURE select_nature_c ( p_nature  in VARCHAR2,                                  
                                  p_curseur IN OUT natureCurType,
                                  p_message  out VARCHAR2
                                )IS
       l_msg VARCHAR2(1024);                           
       
       BEGIN
         
              OPEN p_curseur FOR SELECT               	
                   TO_CHAR(codnature) as codnature,
                   lib_nature,                     	
                   flaglock	
              FROM  nature
              WHERE codnature = TO_NUMBER(p_nature);             
              
              pack_global.recuperer_message( 20968, '%s1', p_nature, NULL, l_msg);
              p_message := l_msg;

            EXCEPTION WHEN OTHERS THEN raise_application_error( -20997, SQLERRM);     
       
       END select_nature_c;
       
       PROCEDURE select_nature_m (p_nature  in VARCHAR2,                                  
                                 p_curseur IN OUT natureCurType,
                                 p_message  out VARCHAR2
                                )IS
       l_msg VARCHAR2(1024);                           
       
       BEGIN
         
              OPEN p_curseur FOR SELECT               	
                   TO_CHAR(codnature) as codnature,
                   lib_nature,                     	
                   flaglock	
              FROM  nature
              WHERE codnature = TO_NUMBER(p_nature);          
              
              pack_global.recuperer_message( 20969, '%s1', p_nature, NULL, l_msg);
              p_message := l_msg;

            EXCEPTION WHEN OTHERS THEN raise_application_error( -20997, SQLERRM);     
       
       END select_nature_m;


END pack_nature;
/


