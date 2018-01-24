CREATE OR REPLACE FORCE VIEW "BIP"."VUE_IMMO2" ("TYPE_ENREG", "ORIGINE", "ENTITE_PROJET", "PROJET", "COMPOSANT", "CADA", "ANNEE", "MOIS", "TYPE_MONTANT", "MONTANT", "SENS", "DEVISE", "CAFI", "SYSCOMPTA") AS 
  select
           2                                                    type_enreg,
        'BIP'                                                origine,
        'P7090'                                              entite_projet,
        s.icpi                                               projet,
        '0BIPIAS'                                            composant,
        s.cada                                               cada,
        to_char(d.datdebex,'YYYY')                           annee,
        to_char(d.moismens,'MM')                             mois,
        'P'                                                  type_montant,
        to_char(abs(sum(s.a_consoft)),'FM999999999990.00')   montant,
        decode(sign(sum(s.a_consoft)),-1,'C',1,'D')          sens,
'EUR'                                                devise,
s.cafi                                               cafi,
d.syscompta                                          syscompta from stock_immo s, datdebex d, struct_info si,
     directions d
where soccode<>'SG..'
and s.CODSGRESS = si.CODSG
and si.coddir = d.CODDIR
and s.a_consoft <> 0
group by s.icpi,s.cafi, d.syscompta, d.datdebex, d.moismens,s.cada
having sum(a_consoft)<>0
UNION
-- Charges salariales SSII
select
      2                                                             type_enreg,
      'BIP'                                                         origine
,
      'P7090'                                                         entite_projet,
      s.icpi                                                        projet,
      '0BIPIAS'                                                     composant,
      s.cada                                                        cada,
      to_char(d.datdebex,'YYYY')                                     annee,
      to_char(d.moismens,'MM')                                         mois,
      'C'                                                             type_montant,
      to_char(abs(sum(a_consoft*(t.taux/100))),'FM999999999990.00') montant,
      decode(sign(sum(s.a_consoft)),-1,'C',1,'D')                     sens,
      'EUR'                                                         devise,
      s.cafi                                                        cafi,
      d.syscompta                                                   syscompta
from stock_immo s,
     taux_charge_salariale t,
     datdebex d,
     struct_info si,
     directions d
where
t.annee = to_number(to_char(d.datdebex,'YYYY'))
and soccode='SG..'
and s.CODSGRESS = si.CODSG
and si.coddir = d.CODDIR
group by s.icpi,s.cafi, d.syscompta, d.datdebex, d.moismens,s.cada
having sum(a_consoft)<>0
UNION
--salaires SG
select
      2
    type_enreg,
      'BIP'
    origine,
      'P7090'
      entite_projet,
      s.icpi
    projet,
      '0BIPIAS'
    composant,
      s.cada
    cada,
      to_char(d.datdebex,'YYYY')
     annee,
      to_char(d.moismens,'MM')
       mois,
      'S'
      type_montant,
      to_char(abs(sum(s.a_consoft*((100-taux)/100))),'FM999999999990.00')
 montant,
      decode(sign(sum(s.a_consoft)),-1,'C',1,'D')
   sens,
      'EUR'
 devise,
      s.cafi
 cafi,
      d.syscompta
 syscompta
from stock_immo s,
     taux_charge_salariale t,
     datdebex d,
     struct_info si,
     directions d
where
t.annee = to_number(to_char(d.datdebex,'YYYY'))
and soccode='SG..'
and s.CODSGRESS = si.CODSG
and si.coddir = d.CODDIR
group by s.icpi,s.cafi, d.syscompta, d.datdebex, d.moismens,s.cada
having sum(a_consoft)<>0 
 ;
