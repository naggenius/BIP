/*
	Package		PACK_UPLOAD_FICHIER_BATCH
	
	Objet		Fonction appelee par le traitement automatique traitement_batch.sh
				destine a ecrire sur le serveur de base de donnees le contenu
				d'un champ CLOB pour un traitement exceptionnel donne.
	
12/07/2011	C. Martins CMA dans le cadre de la fiche 969

*/


CREATE OR REPLACE PACKAGE "PACK_UPLOAD_FICHIER_BATCH" IS

PROCEDURE build_fichier_batch(	    p_chemin IN VARCHAR2,
                                    p_nom_fichier       IN VARCHAR2,
                                    p_id_trait_batch          IN VARCHAR2
                       				);



END pack_upload_fichier_batch;
/


CREATE OR REPLACE PACKAGE BODY "PACK_UPLOAD_FICHIER_BATCH" IS

PROCEDURE build_fichier_batch(      p_chemin          IN VARCHAR2,
                                    p_nom_fichier     IN VARCHAR2,
                                    p_id_trait_batch        IN VARCHAR2
                                    )
IS

    l_file_out    utl_file.file_type;
    vBuffer        VARCHAR2 (32767);
    l_amount    BINARY_INTEGER := 32767;
    l_pos        PLS_INTEGER;
    l_clob_len    PLS_INTEGER;
    contenu_CLOB    CLOB;
    
    
BEGIN
    
    insert into test_message values('Construction d''un fichier pour le traitement '||p_id_trait_batch||' dans le répertoire '||p_chemin||' et sur le fichier '||p_nom_fichier);
    commit;
    SELECT DATA_FICH INTO contenu_CLOB FROM TRAIT_BATCH WHERE ID_TRAIT_BATCH = TO_NUMBER(p_id_trait_batch) AND ROWNUM<=1;
        
    l_file_out := UTL_FILE.FOPEN(p_chemin, p_nom_fichier, 'w', l_amount);
    l_clob_len := dbms_lob.getlength(contenu_CLOB);
     l_pos := 1;
     WHILE l_pos < l_clob_len
    LOOP
        dbms_lob.read(contenu_CLOB, l_amount, l_pos, vBuffer);

        IF vBuffer IS NOT NULL
        THEN
            UTL_FILE.PUT(l_file_out, vBuffer); --pas de retour à la ligne !!!!
        END IF;
        utl_file.fflush(l_file_out);
        l_pos := l_pos + l_amount;
    END LOOP;
    PACK_GLOBAL.WRITE_STRING( l_file_out, '');
    PACK_GLOBAL.CLOSE_WRITE_FILE(l_file_out);



END build_fichier_batch;


END pack_upload_fichier_batch;
/


