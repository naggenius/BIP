-- pack_verif_perioclot PL/SQL
--
--ABA
-- Créé le 05/02/2009
-- 
-- Modifié 
-- 05/01/2010  TD 906
--****************************************************************************
--

CREATE OR REPLACE PACKAGE pack_verif_perioClot IS

/* procedure qui verifie si nous sommes en période de cloture */
PROCEDURE verif_periode(p_periode  OUT VARCHAR2);


END pack_verif_perioClot;
/


CREATE OR REPLACE PACKAGE BODY     pack_verif_perioClot AS

PROCEDURE verif_periode(p_periode  OUT VARCHAR2) IS

        date_cloture DATE;
        /*  date de la mensuelle  plus un jour */ 
        date_mensuelle DATE;

    BEGIN
        
       
        
        select cmensuelle+1 into date_mensuelle from calendrier where
calanmois = (select moismens from datdebex);


         select distinct ccloture+1 into date_cloture from calendrier where to_char(ccloture,'YYYY') = to_char(sysdate,'YYYY');

         If ((sysdate > date_mensuelle) and (sysdate < date_cloture))
         then
            p_periode := 'OUI';
         else
            p_periode := 'NON';
          end if;

END verif_periode;

END pack_verif_perioClot;
/








