-- LE 03/06/2003 Pierre JOSSE
-- Vue qui renvoie la liste des BDClicode qui ont accès à un clicode
-- Cette vue est utilisée dans le cadre des habilitations et les clidoms ne sont plus pris en compte
--
-- Le 12/06/2003 Pierre JOSSE
-- On ajoute une colonne qui contient le périmètre d'habilitation pour un BDCLICODE donné.
-- ABA QC 1139 modification pour selectionner correctement les codes clients en fonction code département

CREATE OR REPLACE FORCE VIEW "BIP"."VUE_CLICODE_PERIMO" ("CLICODE", "BDCLICODE", "CODHABILI") AS 
  select
      c.clicode,
      (TO_CHAR(d.codbr,  'FM00')
      || TO_CHAR(c.clidir, 'FM00')
      || TO_CHAR(c.clicode, 'FM00000')
      ) BDCLICODE,
      'cli' CODHABILI
from
      client_mo c,
      directions d
where
      c.clidir = d.coddir
and   c.clidep <> 999
--
UNION
-- Lien Pole - Département
select
      c.clicode,
      (TO_CHAR(d.codbr,  'FM00')
      || TO_CHAR(c.clidir, 'FM00')
      || TO_CHAR(c2.clicode, 'FM00000')
      ) BDCLICODE,
      'pole' CODHABILI
from
      client_mo c,
      client_mo c2,
      directions d
where
      c.clidir = d.coddir
and   c.clidir = c2.clidir
and   c.clidep = c2.clidep
and   c2.clipol = 0
and   c.clidep <> 999
and   c.clipol <> 0
and   c.clidep <> 0
--
UNION
-- Lien Pole ou Département - Direction
select
      c.clicode,
      (TO_CHAR(d.codbr,  'FM00')
      || TO_CHAR(c.clidir, 'FM00')
      || TO_CHAR(c2.clicode, 'FM00000')
      ) BDCLICODE,
      'pole' CODHABILI
from
      client_mo c,
      client_mo c2,
      directions d
where
      c.clidir = d.coddir
and   c.clidir = c2.clidir
and   c.clidep = c2.clidep
and   c2.clipol = 0
and   c.clidep <> 999
and   c.clipol <> 0
and   c.clidep <> 0
--
UNION
-- Lien Pole ou Département - Direction
select
      c.clicode,
      (TO_CHAR(d.codbr,  'FM00')
      || TO_CHAR(c.clidir, 'FM00')
      || TO_CHAR(c2.clicode, 'FM00000')
      ) BDCLICODE,
      'dep' CODHABILI
from
      client_mo c,
      client_mo c2,
      directions d
where
      c.clidir = d.coddir
and   c.clidir = c2.clidir
and   c2.clidep = 0
and   c2.clipol = 0
and   c.clidep <> 999
and   c.clidep <> 0
and substr(TO_CHAR(c.clidep, 'FM000'),1,1) = substr(TO_CHAR(c2.clicode, 'FM00000'),2,1)
--
UNION
--  DIRECTION
select
      c.clicode,
      (TO_CHAR(d.codbr,  'FM00')
      || TO_CHAR(c.clidir, 'FM00')
      || '00000'
      ) BDCLICODE,
      'dir' CODHABILI
from
      client_mo c,
      directions d
where
      c.clidir = d.coddir
--
UNION
-- BRANCHE
select
      c.clicode,
      (TO_CHAR(d.codbr,  'FM00')
      || '0000000'
      ) BDCLICODE,
      'br' CODHABILI
from
      client_mo c,
      directions d
where
      c.clidir = d.coddir
--
UNION
-- TOUT
select
      c.clicode,
      '000000000' BDCLICODE,
      'bip' CODHABILI
from
      client_mo c,
      directions d
where
      c.clidir = d.coddir 
 ;
