spool update_requete_sql.log;

delete from tmp_rejetmens_bips where motif_rejet like 'Dépassement de capacité%';
delete from sql_requete where nom_fichier ='REJET_ME';

Insert into SQL_REQUETE (NOM_FICHIER,TEXT_SQL,POSITION) values ('REJET_ME','SELECT TO_CHAR(cdeb, ''dd/mm/yyyy''), cusag, pid, codsg,ecet, acta, acst, ident ',1);
Insert into SQL_REQUETE (NOM_FICHIER,TEXT_SQL,POSITION) values ('REJET_ME',', DECODE(motif_rejet, ''T'',''Modif sur ligne fermée'', ''S'', ''Modif sur ligne fermée par sous-traitance'', ''A'', ''Date future'', ''F'', ''Modif sur ligne fermée'', ''G'', ''Modif sur ligne fermée par sous-traitance'', ''R'', ''Ressource inconnue'',  ',2);
Insert into SQL_REQUETE (NOM_FICHIER,TEXT_SQL,POSITION) values ('REJET_ME',' ''O'',''Modif sur ligne fermée par sous-traitance'',''N'',''Modif sur ligne fermée'',''I'',''Ligne Bip sous-traitance inexistante'',''L'',''Ligne Bip inexistante'',''K'',''Ligne Bip de type 9'',''Q'',''Ligne BIP de facturation de type 9'',',3);
Insert into SQL_REQUETE (NOM_FICHIER,TEXT_SQL,POSITION) values ('REJET_ME','''Erreur !'')',4);
Insert into SQL_REQUETE (NOM_FICHIER,TEXT_SQL,POSITION) values ('REJET_ME','FROM tmp_rejetmens ',5);
Insert into SQL_REQUETE (NOM_FICHIER,TEXT_SQL,POSITION) values ('REJET_ME','union',6);
Insert into SQL_REQUETE (NOM_FICHIER,TEXT_SQL,POSITION) values ('REJET_ME','select TO_CHAR(cdeb, ''dd/mm/yyyy''), cusag, pid, codsg,ecet, acta, acst, ident , motif_rejet',7);
Insert into SQL_REQUETE (NOM_FICHIER,TEXT_SQL,POSITION) values ('REJET_ME','from bip.tmp_rejetmens_bips',8);
Insert into SQL_REQUETE (NOM_FICHIER,TEXT_SQL,POSITION) values ('REJET_ME','union',9);
Insert into SQL_REQUETE (NOM_FICHIER,TEXT_SQL,POSITION) values ('REJET_ME','select TO_CHAR(cdeb, ''dd/mm/yyyy''), cusag, pid, codsg,ecet, acta, acst, ident , motif_rejet',10);
Insert into SQL_REQUETE (NOM_FICHIER,TEXT_SQL,POSITION) values ('REJET_ME','from bip.tmp_rejetmens_tail',11);
Insert into SQL_REQUETE (NOM_FICHIER,TEXT_SQL,POSITION) values ('REJET_ME','ORDER BY 3,8,1',12);

  
commit;
exit;
show errors