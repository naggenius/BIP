set ECHO OFF
/* (ci-dessus) supprime l'affichage des requete */
/* supprime l'affichage du nombre d'enregistrement retourne */
set FEEDBACK OFF
/* supprime le séparateur d'affichage d'un enregistrement sur plusieurs lignes */
set HEADS OFF
/* supprime l'affichage du nom des colonnes */
set HEADING OFF
/* défini la largeur des colonnes */
set linesize 1000
/* supprime l'affichage d'un caractère entre chaque enregistrement */
set RECSEP OFF
spool /applis/bipd/livraison/message2load.sql
select 'delete from MESSAGE;' from dual;
select 'insert into MESSAGE(ID_MSG, LIMSG) values ('||id_msg||','''||replace(limsg,'''','''''')||''');' from message order by id_msg;
select 'commit;' from dual;
select 'delete from FICHIERS_RDF;' from dual;
select 'insert into FICHIERS_RDF(FICHIER_RDF, LIBELLE_RDF) values ('''||replace(fichier_rdf,'''','''''')||''','''||replace(libelle_rdf,'''','''''')||''');' from fichiers_rdf order by fichier_rdf;
select 'commit;' from dual;
select 'delete from STAT_PAGE;' from dual;
select 'insert into STAT_PAGE(ID_MENU, ID_PAGE, LIB_PAGE, TRACE, TRACE_ACTION) values ('''||replace(id_menu,'''','''''')||''','||id_page||','''||replace(lib_page,'''','''''')||''','''||trace||''','''||trace_action||''');' from stat_page order by id_menu,id_page;
select 'commit;' from dual;
/* une ligne vide pour éviter l'affichage 'Entrée limitée à XX caractères.' */
select '' from dual;
spool off

