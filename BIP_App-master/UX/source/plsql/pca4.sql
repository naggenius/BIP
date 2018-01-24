-- pack_pca4
-- 
-- cr‰e le 12/07/2002 par MMC
--
-- objet: insertion des sous traitances dans PCA4
--
-- Attention le nom du package ne peut etre le nom de la table...

CREATE or REPLACE PACKAGE pack_pca4 AS
-- **************************************************************************************
-- Nom 		: f_lib_sst
-- Auteur 	: MMC
-- Description 	: 
-- Paramˆtres 	: p_pid (IN) code de la ligne bip imput‰e
--		  p_propid (IN) 
-- Retour	: libelle de la sous tache
--
-- **************************************************************************************
FUNCTION  f_lib_sst (p_propid   IN proplus.pid%TYPE,p_aist IN proplus.aist%TYPE) RETURN VARCHAR2 ;
PRAGMA restrict_references(f_lib_sst,wnds,wnps);


-- **************************************************************************************
-- Nom 		: f_conso_sst
-- Auteur 	: MMC
-- Description 	: calcule le consomme en sous traitance 
-- Paramˆtres 	: p_pid (IN) code de la ligne bip imput‰e
--		  p_propid (IN) 
-- Retour	: cusag
--
-- **************************************************************************************
FUNCTION  f_conso_sst (p_pid   IN ligne_bip.pid%TYPE,p_propid IN proplus.pid%TYPE,p_pcpi IN proplus.pcpi%TYPE) RETURN VARCHAR2 ;
PRAGMA restrict_references(f_conso_sst,wnds,wnps);

-- **************************************************************************************
-- Nom 		: f_date
-- Auteur 	: MMC
-- Description 	: recupere la DATE (il faut avoir la DATE sous forme de variable afin de faire une 2eme
--			jointure ouverte sur la TABLE proplus
-- Paramˆtres 	: p_datdebex (IN) code de la ligne bip imput‰e
--		  p_propid (IN) 
-- Retour	: annee courante
--
-- **************************************************************************************
FUNCTION  f_date  RETURN VARCHAR2 ;
PRAGMA restrict_references(f_date,wnds,wnps);

END pack_pca4;
/
--**************************************************************************************

CREATE or REPLACE PACKAGE BODY pack_pca4 IS 

FUNCTION  f_lib_sst (p_propid   IN proplus.pid%TYPE,p_aist IN proplus.aist%TYPE) RETURN VARCHAR2 IS
l_lib tache.asnom%TYPE;

BEGIN
	SELECT MAX(asnom) INTO l_lib
	FROM tache
	WHERE pid=p_propid
	AND aist=p_aist;
RETURN l_lib;
END f_lib_sst;


/******************************************************************************/
FUNCTION  f_conso_sst (p_pid   IN ligne_bip.pid%TYPE,p_propid IN proplus.pid%TYPE,p_pcpi IN proplus.pcpi%TYPE) RETURN VARCHAR2 IS 
l_conso proplus.cusag%TYPE;
l_date VARCHAR2(4);

BEGIN
	SELECT to_char(DATDEBEX,'yyyy') INTO l_date
	FROM datdebex;
	
	SELECT SUM(cusag) INTO l_conso
	FROM proplus
	WHERE factpid=p_pid
	AND pid=p_propid
	AND pid <> factpid
	AND pcpi= p_pcpi
	AND TO_CHAR(cdeb,'yyyy') = l_date ;
RETURN l_conso;
END f_conso_sst;

/******************************************************************************/
FUNCTION  f_date  RETURN VARCHAR2 IS
l_annee VARCHAR2(4);
BEGIN
	SELECT to_char(DATDEBEX,'yyyy') INTO l_annee
	FROM datdebex;
RETURN l_annee;
END f_date;

END pack_pca4;
/
