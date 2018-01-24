-- pack_chgt_base PL/SQL
--
-- EQUIPE SOPRA
--
-- cree le 05/01/2000
--
-- Décodage de chaînes de caractères suivant l'algorithme URL-encoding :
--	un caractère spécial (autre que des chiffres ou des lettres) est codé de la manière suivante : %xx
--	où xx est un nombre hexadécimal représentant le code ASCII du caractère
--	--> FUNCTION unescape
--
-- Changements de base pour un nombre :
--	* de la base 10 à n'importe quelle base B (B compris entre 1 et 36)	--> FUNCTION Base10_To_BaseB
--	* d'un base B (B compris entre 1 et 36) à la base 10				--> FUNCTION BaseB_To_Base10
--		Attention : dans ce dernier cas, le nombre a convertir
--				est une chaine de caractère !!
--

CREATE OR REPLACE PACKAGE pack_conversion AS

   FUNCTION unescape( p_chaine IN VARCHAR2) RETURN VARCHAR2 ;

   FUNCTION Base10_To_BaseB( p_nombre IN INTEGER, p_base IN INTEGER ) RETURN VARCHAR2 ;

   FUNCTION BaseB_To_Base10( p_nombre IN VARCHAR2, p_base IN INTEGER ) RETURN INTEGER ;
   --
   --    WNDS   means "writes no database state" (does not modify database tables). 
   --
   --    WNPS   means "writes no package state" (does not change the values of packaged variables).
   --
   --    RNDS   means "reads no database state" (does not query database tables). 
   --
   --    RNPS   means "reads no package state" (does not reference the values of packaged variables). 
   --
   PRAGMA RESTRICT_REFERENCES (Base10_To_BaseB, WNDS, WNPS, RNDS, RNPS); 
   PRAGMA RESTRICT_REFERENCES (BaseB_To_Base10, WNDS, WNPS, RNDS, RNPS); 

END pack_conversion ;
/

CREATE OR REPLACE PACKAGE BODY pack_conversion AS 

-------------------------------------------------------------------
-- 
------------------------------------------------------------------

   FUNCTION unescape( p_chaine IN VARCHAR2) RETURN VARCHAR2 IS

      l_pos     integer;
	l_chaine  varchar2(2000);
	l_rep     varchar2(10);
	l_by      char(1);
   BEGIN
	l_chaine := REPLACE( p_chaine, '+', ' ');

	l_pos    := INSTR( p_chaine, '%', 1, 1);
	WHILE l_pos > 0 LOOP
	   l_rep    := SUBSTR( l_chaine, l_pos, 3);
	   l_by     := CHR( pack_conversion.BaseB_To_Base10( SUBSTR( l_chaine, l_pos+1, 2) , 16) );
	   l_chaine := REPLACE(	l_chaine, l_rep, l_by );
	   l_pos    := INSTR( l_chaine, '%', 1, 1);
	END LOOP; 

	RETURN l_chaine;

   END unescape;


-------------------------------------------------------------------
-- 
------------------------------------------------------------------
   FUNCTION Base10_To_BaseB( p_nombre IN INTEGER, p_base IN INTEGER ) RETURN VARCHAR2 IS

	i		binary_integer;
	quotient	integer;
	reste		integer;
	val		varchar2(100);
	base36	constant char(36) := '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
   BEGIN
	quotient := p_nombre;
	WHILE (quotient >= p_base) LOOP
	   reste    := MOD(quotient,p_base);
	   quotient := FLOOR(quotient/p_base);
	   val      := SUBSTR( base36, reste + 1,1 ) || val ;
	END LOOP; 

	val := SUBSTR( base36, quotient + 1,1 ) || val ;

	RETURN val;

   END Base10_To_BaseB;


-------------------------------------------------------------------
-- 
------------------------------------------------------------------
   FUNCTION BaseB_To_Base10( p_nombre IN VARCHAR2, p_base IN INTEGER ) RETURN INTEGER IS

	i        integer;
	N	   constant integer := LENGTH(p_nombre);
	chiffre  char;
	num      integer := 0;
	base36   constant char(36) := '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
   BEGIN
	FOR i IN 1..N LOOP
	   chiffre := SUBSTR(p_nombre, i, 1);
	   num     := num + POWER(p_base,N-i) * (INSTR(base36,chiffre,1) - 1) ;
	END LOOP; 

	RETURN num ;

   END BaseB_To_Base10;



-------------------------------------------------------------------
-- 
------------------------------------------------------------------


END pack_conversion ;
/
