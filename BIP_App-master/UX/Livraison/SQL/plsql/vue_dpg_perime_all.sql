-- Le 17/10/2003 N.BACCAM
-- On cr�� une vue qui, pour un code DPG contient la liste des BDDDPG qui lui correspond 
-- m�me les DPG qui ne sont rattach�s � aucune branche,direction



CREATE OR REPLACE FORCE VIEW "BIP"."VUE_DPG_PERIME_ALL" ("CODSG", "CODBDDPG", "CODHABILI") AS 
  select s.codsg, (TO_CHAR(d.codbr, 'FM00')
		|| TO_CHAR(s.coddir, 'FM00')
		|| TO_CHAR(s.codsg, 'FM0000000')
		) CODBDDPG,
		'grpe' CODHABILI
from struct_info s, directions d
where s.coddir = d.coddir
UNION  --Cas ou le BDDPG correspond au p�le
select s.codsg, (TO_CHAR(d.codbr, 'FM00')
		|| TO_CHAR(s.coddir, 'FM00')
		|| SUBSTR(TO_CHAR(s.codsg, 'FM0000000'),1,5)
		|| '00'
		) CODBDDPG,
		'pole' CODHABILI
from struct_info s, directions d
where s.coddir = d.coddir
UNION  --Cas ou le BDDPG correspond au d�partement
select s.codsg, (TO_CHAR(d.codbr, 'FM00')
		|| TO_CHAR(s.coddir, 'FM00')
		|| SUBSTR(TO_CHAR(s.codsg, 'FM0000000'),1,3)
		|| '0000'
		) CODBDDPG,
		'dpt' CODHABILI
from struct_info s, directions d
where s.coddir = d.coddir
UNION  --Cas ou le BDDPG correspond � la direction
select s.codsg, (TO_CHAR(d.codbr, 'FM00')
		|| TO_CHAR(s.coddir, 'FM00')
		|| '0000000'
		) CODBDDPG,
		'dir' CODHABILI
from struct_info s, directions d
where s.coddir = d.coddir
UNION  --Cas ou le BDDPG correspond � la branche
select s.codsg, (TO_CHAR(d.codbr, 'FM00')
		|| '000000000'
		) CODBDDPG,
		'br' CODHABILI
from struct_info s, directions d
where s.coddir = d.coddir
UNION  --Cas ou le BDDPG correspond � toute la BIP
select s.codsg, '00000000000' CODBDDPG, 'bip' CODHABILI
from struct_info s, directions d
where s.coddir = d.coddir
UNION  --Cas ou le BDDPG correspond � toute la BIP et le DPG n'est rattach� � aucune direction
select s.codsg, '00000000000' CODBDDPG, 'bip' CODHABILI
from struct_info s, directions d
where s.coddir = d.coddir(+)

 ;
