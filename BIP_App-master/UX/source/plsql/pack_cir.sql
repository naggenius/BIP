--------------------------------------------------------
--  Fichier créé - lundi-octobre-10-2016   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package PACK_CIR
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "BIP"."PACK_CIR" IS

/* procedure d'alimentation de la table audit_immo*/
PROCEDURE alim_cir(p_chemin_fichier    IN VARCHAR2,
                   p_nom_fichier        IN VARCHAR2
                    );

 
END pack_cir; 
 

/
--------------------------------------------------------
--  DDL for Package Body PACK_CIR
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "BIP"."PACK_CIR" IS

PROCEDURE alim_cir ( p_chemin_fichier    IN VARCHAR2,
                   p_nom_fichier        IN VARCHAR2
                   ) IS


l_annee varchar2(4);
      l_hfile UTL_FILE.FILE_TYPE;
     compteur number;

CURSOR csr_cir IS
select 
   BRANCHE_DIRECTION, 
   CODE_DP, 
   LIBELLE_DP, 
   POLE, 
   CODE_PROJET, 
   LIBELLE_PROJET, 
   PID, 
   LIBELLE_PID, 
   SOCCODE, 
   NOM_SOCIETE, 
   IDENT, 
   NOM, 
   NBJH, 
   JANVIER, 
   FEVRIER, 
   MARS, 
   AVRIL, 
   MAI, 
   JUIN, 
   JUILLET, 
   AOUT, 
   SEPTEMBRE, 
   OCTOBRE, 
   NOVEMBRE, 
   DECEMBRE, 
   COUT_COMPLET_JH, 
   COUT_TOTAL, 
   COUT_TOTAL_KE
from 
    tmp_cir
ORDER BY 
NLSSORT(code_dp, 'NLS_SORT=FRENCH_M'), 
NLSSORT(code_projet, 'NLS_SORT=FRENCH_M'), 
NLSSORT(pid, 'NLS_SORT=FRENCH_M'), 
NLSSORT(ident, 'NLS_SORT=FRENCH_M');
  

cursor csr_facture (p_ident number, p_mois_prestation varchar2) IS
select l.typfact typfact, 
l.numfact numfact, 
l.lmontht montant,
 l.datfact datefact,
  decode(f.num_sms,null,f.num_expense,f.num_sms) numext 
from ligne_fact l, facture f 
where l.ident = p_ident
and lmoisprest = p_mois_prestation
and l.numfact = f.numfact 
and l.typfact = f.typfact
and l.socfact = f.socfact 
and f.datfact = l.datfact;


BEGIN

     Pack_Global.INIT_WRITE_FILE( p_chemin_fichier, p_nom_fichier, l_hfile);

l_annee :=  '2008';
compteur := 0;
    delete cir;
    commit;
    
    FOR rec_cir IN csr_cir LOOP
        
        Pack_Global.WRITE_STRING( l_hfile,
                              
                rec_cir.BRANCHE_DIRECTION || ';' ||
                rec_cir.CODE_DP || ';' ||
                rec_cir.LIBELLE_DP || ';' ||
                rec_cir.POLE || ';' ||
                rec_cir.CODE_PROJET || ';' ||
                rec_cir.LIBELLE_PROJET || ';' ||
                rec_cir.PID || ';' ||
                rec_cir.LIBELLE_PID || ';' ||
                rec_cir.SOCCODE || ';' ||
                rec_cir.NOM_SOCIETE || ';' ||
                rec_cir.IDENT || ';' ||
                rec_cir.NOM || ';' ||
                replace(rec_cir.NBJH,'.',',') || ';' ||
                replace(rec_cir.JANVIER,'.',',') || ';' ||
                replace(rec_cir.FEVRIER,'.',',') || ';' ||
                replace(rec_cir.MARS,'.',',') || ';' ||
                replace(rec_cir.AVRIL,'.',',') || ';' ||
                replace(rec_cir.MAI,'.',',')  || ';' ||
                replace(rec_cir.JUIN,'.',',') || ';' ||
                replace(rec_cir.JUILLET,'.',',') || ';' ||
                replace(rec_cir.AOUT,'.',',') || ';' ||
                replace(rec_cir.SEPTEMBRE,'.',',') || ';' ||
                replace(rec_cir.OCTOBRE,'.',',') || ';' ||
                replace(rec_cir.NOVEMBRE,'.',',') || ';' ||
                replace(rec_cir.DECEMBRE,'.',',') || ';' ||
                replace(rec_cir.COUT_COMPLET_JH,'.',',') || ';' ||
                replace(rec_cir.COUT_TOTAL,'.',',') || ';' ||
                replace(rec_cir.COUT_TOTAL_KE,'.',',') 
                
                
                );
       if (rec_cir.soccode <> 'SG..') then
            
             if (rec_cir.JANVIER <> 0) then
                  select count(*) into compteur from ligne_fact where ident = rec_cir.ident and lmoisprest = to_date('01/'||l_annee, 'MM/YYYY');
                 if (compteur <> 0) then 
                FOR rec_fact IN csr_facture(rec_cir.ident, to_date('01/'||l_annee, 'MM/YYYY')) LOOP
                Pack_Global.WRITE_STRING( l_hfile,
                              
                    'JANVIER' || ';' ||
                    replace(rec_cir.JANVIER,'.',',') || ';' ||
                    rec_fact.typfact || ';' || 
                    rec_fact.numfact || ';' ||  
                    replace(rec_fact.montant,'.',',') || ';' || 
                    rec_fact.datefact || ';' || 
                    rec_fact.numext 
                
                );
                END LOOP;
                else
                Pack_Global.WRITE_STRING( l_hfile,                           
                    'JANVIER' || ';' ||
                    replace(rec_cir.JANVIER,'.',',')                               
                );
            
                end if;
             
   
            end if;
            
            
            if (rec_cir.FEVRIER <> 0) then
               select count(*) into compteur from ligne_fact where ident = rec_cir.ident and lmoisprest = to_date('02/'||l_annee, 'MM/YYYY');
                 if (compteur <> 0) then 
                
                FOR rec_fact IN csr_facture(rec_cir.ident, to_date('02/'||l_annee, 'MM/YYYY')) LOOP
                 Pack_Global.WRITE_STRING( l_hfile,
                              
                    'FEVRIER' || ';' ||
                    replace(rec_cir.FEVRIER,'.',',') || ';' ||
                    rec_fact.typfact || ';' || 
                    rec_fact.numfact || ';' ||  
                    replace(rec_fact.montant,'.',',') || ';' || 
                    rec_fact.datefact || ';' || 
                    rec_fact.numext 
                
                );
                END LOOP;
            else
                Pack_Global.WRITE_STRING( l_hfile,
                              
                    'FEVRIER' || ';' ||
                    replace(rec_cir.FEVRIER,'.',','));
                                  
            end if;
                 
        
            
            end if;
            if (rec_cir.MARS <> 0 ) then
               select count(*) into compteur from ligne_fact where ident = rec_cir.ident and lmoisprest = to_date('03/'||l_annee, 'MM/YYYY');
                 if (compteur <> 0) then 
                
                FOR rec_fact IN csr_facture(rec_cir.ident, to_date('03/'||l_annee, 'MM/YYYY')) LOOP
                 Pack_Global.WRITE_STRING( l_hfile,
                              
                    'MARS' || ';' ||
                    replace(rec_cir.MARS,'.',',') || ';' ||
                    rec_fact.typfact || ';' || 
                    rec_fact.numfact || ';' ||  
                    replace(rec_fact.montant,'.',',') || ';' || 
                    rec_fact.datefact || ';' || 
                    rec_fact.numext 
                
                );
                END LOOP;
                  else
                Pack_Global.WRITE_STRING( l_hfile,
                              
                    'MARS' || ';' ||
                    replace(rec_cir.MARS,'.',','));
                                  
            end if;
         
            
            end if;
          
            if (rec_cir.AVRIL <> 0 ) then
                select count(*) into compteur from ligne_fact where ident = rec_cir.ident and lmoisprest = to_date('04/'||l_annee, 'MM/YYYY');
                 if (compteur <> 0) then  
                FOR rec_fact IN csr_facture(rec_cir.ident, to_date('04/'||l_annee, 'MM/YYYY')) LOOP
                 Pack_Global.WRITE_STRING( l_hfile,
                              
                    'AVRIL' || ';' ||
                    replace(rec_cir.AVRIL,'.',',') || ';' ||
                    rec_fact.typfact || ';' || 
                    rec_fact.numfact || ';' ||  
                    replace(rec_fact.montant,'.',',') || ';' || 
                    rec_fact.datefact || ';' || 
                    rec_fact.numext 
                
                );
                END LOOP;
                     else
                Pack_Global.WRITE_STRING( l_hfile,
                              
                    'AVRIL' || ';' ||
                    replace(rec_cir.AVRIL,'.',','));
                                  
            end if;
    
            
            end if;
            if (rec_cir.MAI <> 0 ) then
                select count(*) into compteur from ligne_fact where ident = rec_cir.ident and lmoisprest = to_date('05/'||l_annee, 'MM/YYYY');
                 if (compteur <> 0) then    
                FOR rec_fact IN csr_facture(rec_cir.ident, to_date('05/'||l_annee, 'MM/YYYY')) LOOP
                 Pack_Global.WRITE_STRING( l_hfile,
                              
                    'MAI' || ';' ||
                    replace(rec_cir.MAI,'.',',') || ';' ||
                    rec_fact.typfact || ';' || 
                    rec_fact.numfact || ';' ||  
                    replace(rec_fact.montant,'.',',') || ';' || 
                    rec_fact.datefact || ';' || 
                    rec_fact.numext 
                
                );
                END LOOP;
                       else
                Pack_Global.WRITE_STRING( l_hfile,
                              
                    'MAI' || ';' ||
                    replace(rec_cir.MAI,'.',',') );
                                  
            end if;
          
                                  
            end if;
          if (rec_cir.JUIN <> 0 ) then
                 select count(*) into compteur from ligne_fact where ident = rec_cir.ident and lmoisprest = to_date('06/'||l_annee, 'MM/YYYY');
                 if (compteur <> 0) then   
                FOR rec_fact IN csr_facture(rec_cir.ident, to_date('06/'||l_annee, 'MM/YYYY')) LOOP
                 Pack_Global.WRITE_STRING( l_hfile,
                              
                    'JUIN' || ';' ||
                    replace(rec_cir.JUIN,'.',',') || ';' ||
                    rec_fact.typfact || ';' || 
                    rec_fact.numfact || ';' ||  
                    replace(rec_fact.montant,'.',',') || ';' || 
                    rec_fact.datefact || ';' || 
                    rec_fact.numext 
                
                );
                END LOOP;
                         else
                Pack_Global.WRITE_STRING( l_hfile,
                              
                    'JUIN' || ';' ||
                    replace(rec_cir.JUIN,'.',',') );
                                  
            end if;
             
                                  
            end if; 
        if (rec_cir.JUILLET <> 0 ) then
                select count(*) into compteur from ligne_fact where ident = rec_cir.ident and lmoisprest = to_date('07/'||l_annee, 'MM/YYYY');
                 if (compteur <> 0) then     
                FOR rec_fact IN csr_facture(rec_cir.ident, to_date('07/'||l_annee, 'MM/YYYY')) LOOP
                 Pack_Global.WRITE_STRING( l_hfile,
                              
                    'JUILLET' || ';' ||
                    replace(rec_cir.JUILLET,'.',',') || ';' ||
                    rec_fact.typfact || ';' || 
                    rec_fact.numfact || ';' ||  
                    replace(rec_fact.montant,'.',',') || ';' || 
                    rec_fact.datefact || ';' || 
                    rec_fact.numext 
                
                );
                END LOOP;
                             else
                Pack_Global.WRITE_STRING( l_hfile,
                              
                    'JUILLET' || ';' ||
                    replace(rec_cir.JUILLET,'.',','));
                                  
            end if;
              
            end if;
          if (rec_cir.AOUT <> 0 ) then
             select count(*) into compteur from ligne_fact where ident = rec_cir.ident and lmoisprest = to_date('08/'||l_annee, 'MM/YYYY');
                 if (compteur <> 0) then      
                FOR rec_fact IN csr_facture(rec_cir.ident, to_date('08/'||l_annee, 'MM/YYYY')) LOOP
                 Pack_Global.WRITE_STRING( l_hfile,
                              
                    'AOUT' || ';' ||
                    replace(rec_cir.AOUT,'.',',') || ';' ||
                    rec_fact.typfact || ';' || 
                    rec_fact.numfact || ';' ||  
                    replace(rec_fact.montant,'.',',') || ';' || 
                    rec_fact.datefact || ';' || 
                    rec_fact.numext 
                
                );
                END LOOP;
             else
                Pack_Global.WRITE_STRING( l_hfile,
                              
                    'AOUT' || ';' ||
                    replace(rec_cir.AOUT,'.',',') );
                                  
            end if;
             
                                  
            end if;
         if (rec_cir.SEPTEMBRE<> 0 ) then
                 select count(*) into compteur from ligne_fact where ident = rec_cir.ident and lmoisprest = to_date('09/'||l_annee, 'MM/YYYY');
                 if (compteur <> 0) then       
                FOR rec_fact IN csr_facture(rec_cir.ident, to_date('09/'||l_annee, 'MM/YYYY')) LOOP
                 Pack_Global.WRITE_STRING( l_hfile,
                              
                    'SEPTEMBRE' || ';' ||
                    replace(rec_cir.SEPTEMBRE,'.',',') || ';' ||
                    rec_fact.typfact || ';' || 
                    rec_fact.numfact || ';' ||  
                    replace(rec_fact.montant,'.',',') || ';' || 
                    rec_fact.datefact || ';' || 
                    rec_fact.numext 
                
                );
                END LOOP;
            else
                Pack_Global.WRITE_STRING( l_hfile,
                              
                    'SEPTEMBRE' || ';' ||
                    replace(rec_cir.SEPTEMBRE,'.',',')) ;
                                  
            end if;
          
                                  
            end if;
            
             if (rec_cir.OCTOBRE<> 0 ) then    
               select count(*) into compteur from ligne_fact where ident = rec_cir.ident and lmoisprest = to_date('10/'||l_annee, 'MM/YYYY');
                 if (compteur <> 0) then  
                FOR rec_fact IN csr_facture(rec_cir.ident, to_date('10/'||l_annee, 'MM/YYYY')) LOOP
                 Pack_Global.WRITE_STRING( l_hfile,
                              
                    'OCTOBRE' || ';' ||
                    replace(rec_cir.OCTOBRE,'.',',') || ';' ||
                    rec_fact.typfact || ';' || 
                    rec_fact.numfact || ';' ||  
                    replace(rec_fact.montant,'.',',') || ';' || 
                    rec_fact.datefact || ';' || 
                    rec_fact.numext 
                
                );
                END LOOP;
                 else
                Pack_Global.WRITE_STRING( l_hfile,
                              
                    'OCTOBRE' || ';' ||
                    replace(rec_cir.OCTOBRE,'.',','));
                                  
            end if;
              
            end if;
         
                if (rec_cir.NOVEMBRE<> 0 ) then           
                   select count(*) into compteur from ligne_fact where ident = rec_cir.ident and lmoisprest = to_date('11/'||l_annee, 'MM/YYYY');
                 if (compteur <> 0) then     
                FOR rec_fact IN csr_facture(rec_cir.ident, to_date('11/'||l_annee, 'MM/YYYY')) LOOP
                 Pack_Global.WRITE_STRING( l_hfile,
                              
                    'NOVEMBRE' || ';' ||
                    replace(rec_cir.NOVEMBRE,'.',',') || ';' ||
                    rec_fact.typfact || ';' || 
                    rec_fact.numfact || ';' ||  
                    replace(rec_fact.montant,'.',',') || ';' || 
                    rec_fact.datefact || ';' || 
                    rec_fact.numext 
                
                );
                END LOOP;
             else
                Pack_Global.WRITE_STRING( l_hfile,                       
                    'NOVEMBRE' || ';' ||
                    replace(rec_cir.NOVEMBRE,'.',','));
                                  
            end if;
                
                                  
            end if;
       
                  if (rec_cir.DECEMBRE<> 0 ) then                  
                 select count(*) into compteur from ligne_fact where ident = rec_cir.ident and lmoisprest = to_date('12/'||l_annee, 'MM/YYYY');
                 if (compteur <> 0) then 
                 FOR rec_fact IN csr_facture(rec_cir.ident, to_date('12/'||l_annee, 'MM/YYYY')) LOOP
                 Pack_Global.WRITE_STRING( l_hfile,
                    'DECEMBRE' || ';' ||
                    replace(rec_cir.DECEMBRE,'.',',') || ';' ||
                    rec_fact.typfact || ';' || 
                    rec_fact.numfact || ';' ||  
                    replace(rec_fact.montant,'.',',') || ';' || 
                    rec_fact.datefact || ';' || 
                    rec_fact.numext 
                
                );
                END LOOP;
                else
                Pack_Global.WRITE_STRING( l_hfile,                       
                    'DECEMBRE' || ';' ||
                    replace(rec_cir.DECEMBRE,'.',','));
                                  
            end if;
                
            end if;
           
        end if;
      
    END LOOP;
      Pack_Global.CLOSE_WRITE_FILE(l_hfile);
   

END alim_cir;

END pack_cir; 

/
