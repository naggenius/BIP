-- Le 17/10/2003 N.BACCAM
-- On créé une vue qui, pour un code DPG contient la liste des BDDDPG qui lui correspond 
-- même les DPG qui ne sont rattachés à aucune branche,direction



CREATE OR REPLACE FORCE VIEW "BIP"."VUE_DPG_PERIME_ALL" ("CODSG", "CODBDDPG", "CODHABILI") AS 
  select s.codsg, (TO_CHAR(d.codbr, 'FM00')
		|| TO_CHAR(s.coddir, 'FM00')
		|| TO_CHAR(s.codsg, 'FM0000000')
		) CODBDDPG,
		'grpe' CODHABILI
from struct_info s, directions d
where s.coddir = d.coddir
UNION  --Cas ou le BDDPG correspond au pôle
select s.codsg, (TO_CHAR(d.codbr, 'FM00')
		|| TO_CHAR(s.coddir, 'FM00')
		|| SUBSTR(TO_CHAR(s.codsg, 'FM0000000'),1,5)
		|| '00'
		) CODBDDPG,
		'pole' CODHABILI
from struct_info s, directions d
where s.coddir = d.coddir
UNION  --Cas ou le BDDPG correspond au département
select s.codsg, (TO_CHAR(d.codbr, 'FM00')
		|| TO_CHAR(s.coddir, 'FM00')
		|| SUBSTR(TO_CHAR(s.codsg, 'FM0000000'),1,3)
		|| '0000'
		) CODBDDPG,
		'dpt' CODHABILI
from struct_info s, directions d
where s.coddir = d.coddir
UNION  --Cas ou le BDDPG correspond à la direction
select s.codsg, (TO_CHAR(d.codbr, 'FM00')
		|| TO_CHAR(s.coddir, 'FM00')
		|| '0000000'
		) CODBDDPG,
		'dir' CODHABILI
from struct_info s, directions d
where s.coddir = d.coddir
UNION  --Cas ou le BDDPG correspond à la branche
select s.codsg, (TO_CHAR(d.codbr, 'FM00')
		|| '000000000'
		) CODBDDPG,
		'br' CODHABILI
from struct_info s, directions d
where s.coddir = d.coddir
UNION  --Cas ou le BDDPG correspond à toute la BIP
select s.codsg, '00000000000' CODBDDPG, 'bip' CODHABILI
from struct_info s, directions d
where s.coddir = d.coddir
UNION  --Cas ou le BDDPG correspond à toute la BIP et le DPG n'est rattaché à aucune direction
select s.codsg, '00000000000' CODBDDPG, 'bip' CODHABILI
from struct_info s, directions d
where s.coddir = d.coddir(+)

 ;
