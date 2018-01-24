 CREATE OR REPLACE FORCE VIEW "BIP"."VUE_CLICODE_HIERARCHIE" ("CLICODE", "CLICODERATT", "CODHABILI") AS 
  select
	c.clicode,
	d.clicode CLICODERATT,
	'dir' CODHABILI
from
	client_mo c,
	client_mo d
where
	c.clidir = d.clidir
and c.clidep='0'
and c.clipol='0'
--
UNION
-- DEPARTEMENT ou POLE
select
	c.clicode,
	d.clicode,
	'dep' CODHABILI
from
	client_mo c,
	client_mo d
where
	c.clidir = d.clidir
and c.clidep = d.clidep
and c.clipol='0'
--
UNION
--  POLE
select
	c.clicode,
	c.clicode,
	'pole' CODHABILI
from
	client_mo c
where
	c.clipol <> '0'
 ;