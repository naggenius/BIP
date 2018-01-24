CREATE OR REPLACE PACKAGE pack_suivijhr AS


PROCEDURE alim12_suivijhr;
PROCEDURE alim_suivijhr;
PROCEDURE alim_histo_suivijhr;

END  pack_suivijhr;
/


CREATE OR REPLACE PACKAGE BODY pack_suivijhr AS

PROCEDURE alim12_suivijhr IS

BEGIN
	-- cette procédure est à lancer en fin de première prémensuelle
	
	-- on delete ce qu'il y a dans la table suivijhr
	DELETE  FROM suivijhr;
	COMMIT;
		
	-- on copie les données de la table histo_suivijhr pour le mois -1 et -2 dans la table suivijhr
	INSERT INTO suivijhr (DPG,PRODM2,PRODM1,PROD,ABSM1,ABS)
	(SELECT codsg,
		consmois_2,
		consmois_1,
		NULL,
		absmois_1,
		NULL
	FROM histo_suivijhr
	);

	COMMIT;

END alim12_suivijhr;
	

PROCEDURE alim_suivijhr IS

BEGIN
	
	-- cette procédure est à lancer en fin de chaque traitement de mensuelle (1,2,3)

	-- insérer ligne existante dans proplus pour le mois de mensuelle et non existante dans suivijhr
	INSERT INTO suivijhr (DPG,PRODM2,PRODM1,PROD,ABSM1,ABS)
	(SELECT divsecgrou,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL
	FROM proplus,datdebex
	WHERE cdeb = moismens
	AND NOT EXISTS (SELECT dpg FROM suivijhr
			WHERE dpg = proplus.divsecgrou) 
	GROUP BY divsecgrou);


	-- on update le productif du mois courant par ce qui a été remonté au traitement mensuel

	UPDATE suivijhr SET PROD =(	SELECT sum(cusag)  
					FROM proplus,datdebex
					WHERE cdeb = moismens
					AND factpty <>  '7'
					AND suivijhr.dpg = proplus.divsecgrou
					GROUP BY divsecgrou );

	COMMIT;


	-- on update l'autre champ du mois de mensuelle : le champ contenant les absences

	UPDATE suivijhr SET ABS =(	SELECT sum(cusag)  
					FROM proplus,datdebex
					WHERE cdeb = moismens
					AND factpty =  '7'
					AND suivijhr.dpg = proplus.divsecgrou
					GROUP BY divsecgrou );

	COMMIT;	
	

	

END alim_suivijhr;

PROCEDURE alim_histo_suivijhr IS

BEGIN
	-- cette procédure est à lancer en fin de mensuelle
	-- elle met à jour la table histo_suivijhr
	
	-- on copie ce qu'il y a dans la colonne consmois_1 dans consmois_2
	UPDATE histo_suivijhr SET consmois_2 = consmois_1;


	--on insère les nouvelles lignes ,créées dans la table suivijhr, dans la table histo_suivijhr	
	INSERT INTO histo_suivijhr (CODSG,CONSMOIS_2,CONSMOIS_1,ABSMOIS_1)
	(SELECT dpg,
		NULL,
		NULL,
		NULL
	FROM suivijhr
	WHERE NOT EXISTS (SELECT codsg FROM histo_suivijhr
			WHERE codsg = suivijhr.dpg));

	
	-- on copie les données prod et abs de la table suivijhr (données du mois de mensuelle) 
	-- dans la table histo_suivijhr dans consmois_1 et absmois_1
	UPDATE histo_suivijhr SET consmois_1 = (select prod from suivijhr
						WHERE histo_suivijhr.codsg = suivijhr.dpg),
				  absmois_1 = (select abs from suivijhr
						WHERE histo_suivijhr.codsg = suivijhr.dpg);


	COMMIT;

	-- on delete les lignes dont tous les champs sont à NULL
	DELETE FROM histo_suivijhr 
	WHERE consmois_2 IS NULL
	AND consmois_1 IS NULL
	AND absmois_1 IS NULL;

	COMMIT;

END alim_histo_suivijhr;


END pack_suivijhr;
/
