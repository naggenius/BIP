

UPDATE sql_requete SET TEXT_SQL = 'SELECT NVL(TO_CHAR(cdeb, ''dd/mm/yyyy''),''N/A''), cusag, pid, codsg,ecet, acta, acst, ident ' 
WHERE NOM_FICHIER = 'REJET_ME' AND POSITION = '1';

UPDATE sql_requete SET TEXT_SQL = 'select NVL(TO_CHAR(cdeb, ''dd/mm/yyyy''),''N/A''), cusag, pid, codsg,ecet, acta, acst, ident , motif_rejet ' 
WHERE NOM_FICHIER = 'REJET_ME' AND POSITION = '7';


UPDATE sql_requete SET TEXT_SQL = 'select NVL(TO_CHAR(cdeb, ''dd/mm/yyyy''),''N/A''), cusag, pid, codsg,ecet, acta, acst, ident , motif_rejet ' 
WHERE NOM_FICHIER = 'REJET_ME' AND POSITION = '10';