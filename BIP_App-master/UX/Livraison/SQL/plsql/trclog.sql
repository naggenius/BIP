/* ----------------------- */
/* Application REFONTE BIP */
/* Package TRCLOG          */
/* ----------------------- */

/* --------------------------------------- */
/* Nom           Date         Livraison    */
/* --------------------------------------- */
/* M. LECLERC    17/02/1999   Lot 1        */
/* --------------------------------------- */

/******
 * Ce package contient diverses fonctions
 * utilitaires, dont le but est de permettre
 * la constitution d'un fichier de trace et
 * de logging des erreurs au Run-Time des
 * proc�dures stock�es.
 ******/

create or replace package TRCLOG as

	/* ------------------------------------------------ */
	/* On appelle l'Init. au d�but d'un traitement dont */
	/* on veut que les informations de trace soient     */
	/* toutes dans un m�me fichier. L'int�gralit� du    */
	/* traitement devra avoir acc�s au hFile rendu.     */
	/* Renvoie 0 si tout va bien, <> 0 sinon            */
	/* Le nom de fichier pass� va servir � construire   */
	/* un nom de fichier avec la date "devant" et       */
	/* l'extension LOG "derri�re"                       */
	/* ------------------------------------------------ */
	function INITTRCLOG( P_DIRNAME in varchar2, P_FILENAME in varchar2,
	                     P_HFILE out utl_file.file_type ) return number;

	/* ------------------------------------------------ */
	/* Permet la mise en fichier d'une cha�ne de        */
	/* caract�re. La proc�dure ajoute la s�quence de    */
	/* ligne.                                           */
	/* ------------------------------------------------ */
	procedure TRCLOG( P_HFILE in utl_file.file_type, P_STRING in varchar2 );

	/* ------------------------------------------------ */
	/* Fermeture propre du fichier                      */
	/* ------------------------------------------------ */
	procedure CLOSETRCLOG( P_HFILE in out utl_file.file_type );

end TRCLOG;
/

create or replace package body TRCLOG is

	/* ************ */
	/*              */
	/* INITTRCLOG   */
	/*              */
	/* ************ */
	function INITTRCLOG( P_DIRNAME in varchar2, P_FILENAME in varchar2, 
	                     P_HFILE out utl_file.file_type ) return number is

		L_FILENAME varchar2( 64 );

	begin

		-- nom de fichier null interdit
		-- ----------------------------
		if P_FILENAME is null then
			return 1;
		end if;

		-- nom de fichier vide ou tout blanc interdit
		-- ------------------------------------------
		if length( rtrim( ltrim( P_FILENAME ) ) ) = 0 then
			return 2;
		end if;

		-- Date syst�me en d�but de nom
		-- ----------------------------
		select to_char( SYSDATE, 'YYYY.MM.DD.' ) into L_FILENAME from dual;

		-- Ajout du nom pass�
		-- ------------------
		L_FILENAME := L_FILENAME || P_FILENAME;

		-- Ajout de l'extension
		-- --------------------
		L_FILENAME := L_FILENAME || '.log';

		-- Ouverture en ajout ou cr�ation si n'existe pas
		-- Documentation Oracle manifestement fausse : on
		-- ne peut pas utiliser le mode Append si le
		-- fichier n'existe pas. Donc on essaye en 'a' et
		-- si on re�oit une erreur on essaye en 'w'
		-- ----------------------------------------------
		begin
	      	P_HFILE := utl_file.fopen( P_DIRNAME, L_FILENAME, 'a' );
		exception
			when utl_file.invalid_operation then
				begin
					P_HFILE := utl_file.fopen( P_DIRNAME, L_FILENAME, 'w' );
				exception
					when others then
						return 3;
				end;
				return 0;
		end;
		return 0;
	
	exception
		when others then
			return 3;

	end INITTRCLOG;




	/* ************ */
	/*              */
	/* TRCLOG       */
	/*              */
	/* ************ */
	procedure TRCLOG( P_HFILE in utl_file.file_type, P_STRING in varchar2 ) is
		NOW varchar2(32);
		THELINE varchar2(1024);
	begin

		-- construction ligne
		-- ------------------
		select to_char( sysdate, 'YYYY/MM/DD HH24:MI:SS' ) into NOW from dual;
		THELINE := NOW || ' ' || P_STRING;

		-- moi, j'aime bien la s�quence
		-- put flush, mais il faut
		-- dire qu'en ce moment j'ai
		-- une p�riode scato.
		utl_file.put_line( P_HFILE, THELINE );
		utl_file.fflush( P_HFILE );

	exception
		when others then
			return;

	end TRCLOG;



	/* ************ */
	/*              */
	/* CLOSETRCLOG  */
	/*              */
	/* ************ */
	procedure CLOSETRCLOG( P_HFILE in out utl_file.file_type ) is
	begin

		utl_file.fclose( P_HFILE );

	exception
		when others then
			return; 

	end CLOSETRCLOG;

	
end TRCLOG;
/

