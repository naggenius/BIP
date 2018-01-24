--------------------------------------------------------
--  Fichier créé - lundi-octobre-10-2016   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package PACK_AMTCDP01
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "BIP"."PACK_AMTCDP01" AS
  -- ------------------------------------------------------------------------
  -- Nom        :  f_get_dossproj
  -- Auteur     :  Equipe SOPRA
  -- Decription :  renvoie soit le code dossier projet, soit le libelle du dossier projet,
  --			soit le sigle client maitrise d'ouvrage
  -- Retour     :  renvoie soit le code dossier projet, soit le libelle du dossier projet,
  --			soit le sigle client maitrise d'ouvrage si ok, en cas d'erreur ''
  --
  -- ------------------------------------------------------------------------
FUNCTION   f_get_dossproj(	p_dpcode IN ligne_bip.dpcode%TYPE,
				p_dplib IN dossier_projet.dplib%type,
				p_clisigle IN client_mo.clisigle%type
			)  RETURN VARCHAR2 ;
 PRAGMA restrict_references(f_get_dossproj,wnds,wnps);

END pack_amtcdp01;

 

/
--------------------------------------------------------
--  DDL for Package Body PACK_AMTCDP01
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "BIP"."PACK_AMTCDP01" AS
 -- ------------------------------------------------------------------------
  -- Nom        :  f_get_dossproj
  -- Auteur     :  Equipe SOPRA
  -- Decription :  renvoie soit le code dossier projet, soit le libelle du dossier projet,
  --			soit le sigle client maitrise d'ouvrage
  -- Retour     :  renvoie soit le code dossier projet, soit le libelle du dossier projet,
  --			soit le sigle client maitrise d'ouvrage si ok, en cas d'erreur ''
  -- f_get_dossproj(dpcode,'rien','rien') renvoie le code dossier projet
  -- f_get_dossproj(dpcode,dplib,'rien') renvoie le libelle du dossier projet
  -- f_get_dossproj(dpcode,dplib,clisigle) renvoie le client maitrise d'ouvrage
  -- ------------------------------------------------------------------------
FUNCTION   f_get_dossproj(	p_dpcode IN ligne_bip.dpcode%TYPE,
				p_dplib IN dossier_projet.dplib%type,
				p_clisigle IN client_mo.clisigle%type
			)    RETURN VARCHAR2 IS
l_ret varchar2(35);
Begin
if (p_dpcode=00000 or substr(p_dpcode,1,1)=5) then
 	if p_dplib='rien' and p_clisigle='rien' then    /*code dossier projet*/
    		l_ret:='';
 	else
    		if p_clisigle='rien' then
			l_ret:='HORS PROJET';           /*libelle dossier projet*/
    		else
			l_ret:='';                      /*client mo*/
    		end if;
 	end if;
else
	if p_dplib='rien' and p_clisigle='rien' then
		if p_dpcode is not null then             /*code dossier projet*/
			l_ret:=p_dpcode;
		else
			l_ret:='';
		end if;
	else
		if p_clisigle='rien' then                /*libelle dossier projet*/
			if p_dplib is not null then
				l_ret:=p_dplib;
			else
				l_ret:='HORS PROJET';
			end if;
		else
			if p_clisigle is not null then    /*client mo*/
				l_ret:=p_clisigle;
			else
				l_ret:='';
			end if;
		end if;
	end if;
end if;
return l_ret;
exception
when others then return '';
end  f_get_dossproj;


END pack_amtcdp01;

/
