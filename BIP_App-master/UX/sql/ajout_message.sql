spool message_PPM_64269.log;

insert into message (id_msg, limsg) values(21308,'Seul un Administrateur central est habilité à modifier le Dossier projet ou le Projet d''une ligne RBDF.');
insert into message (id_msg, limsg) values(21309,'Seul un Administrateur central est habilité à modifier une ligne BIP pour lui affecter un Dossier Projet RBDF.');

commit;
exit;
show errors