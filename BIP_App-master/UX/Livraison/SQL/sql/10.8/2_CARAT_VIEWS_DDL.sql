

 CREATE OR REPLACE FORCE VIEW BIP.CLICODE_RBDF (CLICODE) AS 
  SELECT CMO.CLICODE
FROM ligne_param_bip LPB,
  client_mo CMO
WHERE LPB.code_version     = CMO.clidir
AND LPB.code_action        = 'DIR-REGLAGES'
AND LPB.actif              = 'O'
AND SUBSTR(LPB.valeur,1,2) = '03'
UNION ALL
SELECT CMO.CLICODE
FROM vue_clicode_perimo V,
  client_mo CMO
WHERE V.clicode             = CMO.CLICODE
AND V.codhabili             = 'br'
AND SUBSTR(V.bdclicode,1,2) = '03';

--New views for CARAT implementation 

  CREATE OR REPLACE FORCE VIEW BIP.CODSG_RBDF (CODSG) AS 
  SELECT SI.CODSG
FROM ligne_param_bip LPB,
  struct_info SI
WHERE LPB.code_action      = 'DIR-REGLAGES'
AND LPB.code_version       = SI.CODDIR
AND LPB.actif              = 'O'
AND SUBSTR(LPB.valeur,1,2) = '03'
UNION ALL
SELECT SI.CODSG
FROM vue_dpg_perime v,
  struct_info SI
WHERE V.codsg              = SI.CODSG
AND V.CODHABILI            = 'br'
AND SUBSTR(V.CODBDDPG,1,2) = '03';