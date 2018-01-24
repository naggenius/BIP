--------------------------------------------------------
--  Fichier créé - lundi-octobre-10-2016   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package PACK_IMMOSFACT
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "BIP"."PACK_IMMOSFACT" AS
-- ===============================================================================
-- ===============================================================================
PROCEDURE select_immosfact ( p_global IN CHAR,
			    p_titre  IN VARCHAR2,
                           p_chemin_fichier IN VARCHAR2,
                           p_nom_fichier IN VARCHAR2,
                           p_nbfichier OUT INTEGER,
                           p_nbcurseur OUT INTEGER,
                           p_message OUT VARCHAR2
                          );
end pack_immosfact;

 

/
