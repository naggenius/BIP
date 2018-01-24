
CREATE OR REPLACE FORCE VIEW "BIP"."VUE_IMMO" ("TYPE_ENREG", "ORIGINE", "ENTITE_PROJET", "PROJET", "COMPOSANT", "CADA", "ANNEE", "MOIS", "TYPE_MONTANT", "MONTANT", "SENS", "DEVISE", "CAFI") AS 
  select
   	  	2 	   	   		 		      			type_enreg,
		'BIP' 	   			  		    			origine,
		'P7090'    	  		  		    			entite_projet,
		max(s.icpi) 		  		    			projet,
		'0BIPIAS' 			  		    			composant,
		max(s.cada) 		  		    			cada,
		to_char(max(d.datdebex),'YYYY') 			annee,
		to_char(max(d.moismens),'MM') 				mois,
		'P' 										type_montant,
		to_char(abs(sum(s.a_consoft)),'FM999999999990.00') 						montant,
		decode(sign(sum(s.a_consoft)),-1,'C',1,'D') sens,
		'EUR' 										devise,
		max(s.cafi) 								cafi
from stock_immo s,
	 datdebex d
where soccode<>'SG..'
group by s.icpi,s.cafi
having sum(a_consoft)<>0
UNION
-- Charges salariales SSII
select
	  2 											type_enreg,
	  'BIP' 										origine,
	  'P7090' 										entite_projet,
	  max(s.icpi) 									projet,
	  '0BIPIAS' 										composant,
	  max(s.cada) 									cada,
	  to_char(max(d.datdebex),'YYYY') 				annee,
	  to_char(max(d.moismens),'MM') 				mois,
	  'C' 											type_montant,
	  to_char(abs(sum(a_consoft*(t.taux/100))),'FM999999999990.00') 				montant,
	  decode(sign(sum(s.a_consoft)),-1,'C',1,'D') 	sens,
	  'EUR' 										devise,
	  max(s.cafi) 									cafi
from stock_immo s,
	 taux_charge_salariale t,
	 datdebex d
where
t.annee = to_number(to_char(d.datdebex,'YYYY'))
and soccode='SG..'
group by s.icpi,s.cafi
having sum(a_consoft)<>0
UNION
--salaires SG
select
	  2 									   		type_enreg,
	  'BIP' 								   		origine,
	  'P7090' 								   		entite_projet,
	  max(s.icpi) 						   			projet,
	  '0BIPIAS' 								   		composant,
	  max(s.cada) 							   		cada,
	  to_char(max(d.datdebex),'YYYY') 		   		annee,
	  to_char(max(d.moismens),'MM') 		   		mois,
	  'S' 									   		type_montant,
	  to_char(abs(sum(s.a_consoft*((100-taux)/100))),'FM999999999990.00')   		montant,
	  decode(sign(sum(s.a_consoft)),-1,'C',1,'D') 	sens,
	  'EUR' 										devise,
	  max(s.cafi) 									cafi
from stock_immo s,
	 taux_charge_salariale t,
	 datdebex d
where
t.annee = to_number(to_char(d.datdebex,'YYYY'))
and soccode='SG..'
group by s.icpi,s.cafi
having sum(a_consoft)<>0
 ;
