-- pack_bjh_dpg PL/SQL
--
-- Maintenance BIP (NBM)
-- Cree le 04/09/2001
--
-- Objet : Permet de vérifier l'existence du code DPG et l'habilitation de l'utilisateur
-- Page HTML: dbjherr.htm
--
--**********************************************************************
--
-- Attention le nom du package ne peut etre le nom
-- de la table...


CREATE OR REPLACE PACKAGE pack_bjh_dpg AS

PROCEDURE select_bjh_dpg ( p_matricule IN VARCHAR2,
			   p_ident     IN VARCHAR2,
			   p_codsg     IN VARCHAR2,
			   p_userid    IN VARCHAR2,
        	           p_nbcurseur         OUT INTEGER,
                           p_message           OUT VARCHAR2);
END pack_bjh_dpg;
/


CREATE OR REPLACE PACKAGE BODY pack_bjh_dpg AS 

PROCEDURE select_bjh_dpg ( p_matricule IN VARCHAR2,
			   p_ident     IN VARCHAR2,
			   p_codsg     IN VARCHAR2,
			   p_userid    IN VARCHAR2,
        	           p_nbcurseur         OUT INTEGER,
                           p_message           OUT VARCHAR2) IS
  l_msg VARCHAR2(1024);

  BEGIN
	pack_habilitation.verif_habili_me(p_codsg,p_userid,l_msg);
 	 
	p_message:=l_msg;
	
  END select_bjh_dpg;
END pack_bjh_dpg;
/
