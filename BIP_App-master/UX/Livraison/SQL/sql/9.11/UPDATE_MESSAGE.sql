spool $TMPDIR/Log_SQL_DEPLOY.log

UPDATE MESSAGE SET LIMSG = 'Seul un Administrateur central est habilité à modifier le Dossier projet ou le Projet d''une ligne RBDF ayant du consommé.' WHERE ID_MSG = 21308;

COMMIT;
exit;

TESTTTT;
