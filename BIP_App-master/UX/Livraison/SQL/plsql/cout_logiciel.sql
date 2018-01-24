-- Package pour la mise a jour du prix des logiciels de la table SITU_RESS
-- Cree le 25/07/2005 par JA

CREATE OR REPLACE PACKAGE PACKBATCH_COUTLOGICIEL AS

tempCout number(6,2);

PROCEDURE maj_cout(valeur VARCHAR2);

END PACKBATCH_COUTLOGICIEL;
/


CREATE OR REPLACE PACKAGE BODY PACKBATCH_COUTLOGICIEL AS


procedure maj_cout(valeur VARCHAR2) is

  CURSOR curseur is 
  select ident,codsg  from situ_ress where datdep is null and ident in
  (select ident from ressource where rtype='L');

BEGIN

for curseur_Rec in curseur loop

   select cout_log into tempCout from cout_std2,datdebex where curseur_Rec.codsg between 
   dpg_bas and dpg_haut
and cout_std2.annee=to_number(to_char(datdebex,'yyyy'))
and cout_std2.metier = 'ME'; 

   if (tempCout is not null) then 
     update situ_ress set cout = tempCout where ident=curseur_Rec.ident and datdep 
    is null; 
   end if; 

end loop;

END maj_cout;

END PACKBATCH_COUTLOGICIEL;
/  

show errors 
