CREATE OR REPLACE PACKAGE pack_liste_coutstandard AS

	TYPE dpg_std_type is RECORD(
			  	   pcle		varchar2(20),
			  	   pcoutstd	varchar2(200)
					  );

 	TYPE dpg_stdCurType IS REF CURSOR RETURN dpg_std_type;

	
	PROCEDURE lister_coutstandard (	p_anneestd    IN VARCHAR2,
				     	p_userid      IN VARCHAR2,
                             		p_curdpg_std  IN OUT dpg_stdCurType
				 );
	PROCEDURE lister_coutstandard_sg (	p_anneestd    IN VARCHAR2,
				     	p_userid      IN VARCHAR2,
                             		p_curdpg_std  IN OUT dpg_stdCurType
				 );



END pack_liste_coutstandard;
/

CREATE OR REPLACE PACKAGE BODY pack_liste_coutstandard AS

PROCEDURE lister_coutstandard	(p_anneestd    	IN VARCHAR2,
				 p_userid       IN VARCHAR2,
                         	 p_curdpg_std   IN OUT dpg_stdCurType
				 ) IS

BEGIN
OPEN p_curdpg_std FOR
	select  distinct (TO_CHAR(dpg_bas, 'FM0000000')) as pcle,
                 (
                  '   ' || TO_CHAR(nvl(dpg_bas,0),'FM0000000') ||
                  '               ' || rpad(TO_CHAR(nvl(dpg_haut,0),'FM0000000'),9,' ')
                 ) as pcoutstd
        from cout_std2
        where annee = to_number(p_anneestd)
        order by 2 asc
        ;
END lister_coutstandard;


PROCEDURE lister_coutstandard_sg        (p_anneestd     IN VARCHAR2,
                                 p_userid       IN VARCHAR2,
                                 p_curdpg_std   IN OUT dpg_stdCurType
                                 ) IS
BEGIN
OPEN p_curdpg_std FOR
select  distinct (TO_CHAR(dpg_bas, 'FM0000000')) as pcle,
                 (
                  '   ' || TO_CHAR(nvl(dpg_bas,0),'FM0000000') ||
                  '               ' || rpad(TO_CHAR(nvl(dpg_haut,0),'FM0000000'),9,' ')
                 ) as pcoutstd
        from cout_std_sg
        where annee = to_number(p_anneestd)
        order by 2 asc
        ;
END lister_coutstandard_sg;






END pack_liste_coutstandard;
/