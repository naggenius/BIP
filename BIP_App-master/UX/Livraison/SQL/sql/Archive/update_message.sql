spool message_64770.log;

UPDATE MESSAGE SET LIMSG = 'Seul un Administrateur central est habilité à modifier le Dossier projet ou le Projet d''une ligne RBDF ayant du consommé.' WHERE ID_MSG = 21308;
UPDATE MESSAGE SET LIMSG = 'Seul un Administrateur central est habilité à modifier une ligne BIP GT1 ayant du consommé, pour lui affecter un Dossier Projet RBDF.' WHERE ID_MSG = 21309;

commit;
exit;
show errors
