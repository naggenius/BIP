-- Chargement des fichiers de lignes bip

--

-- Equipe BIP 

--

-- Crée le 04/10/2005 par A. SAKHRAOUI

--



CREATE OR REPLACE PACKAGE Pack_Ligne_Bip_Load AS

/******************************************************************************

   NAME:       PACK_LIGNE_BIP_LOAD

   PURPOSE:



   REVISIONS:

   Ver        Date        Author           Description

   ---------  ----------  ---------------  ------------------------------------

   1.0        19/09/2006             1. Created this package.

******************************************************************************/



  PROCEDURE LOAD_LIGNE_BIP(

			 pnom  IN  VARCHAR2,

			 typproj  IN  VARCHAR2,

			 pdatdebpre  IN  VARCHAR2,

			 arctype  IN  VARCHAR2,

			 toptri  IN  VARCHAR2,

			 codpspe  IN  VARCHAR2,

			 airt  IN  VARCHAR2,

			 icpi  IN  VARCHAR2,

			 codsg  IN  VARCHAR2,

			 pcpi  IN  VARCHAR2,

			 clicode  IN  VARCHAR2,

			 clicode_oper  IN  VARCHAR2,

			 codcamo  IN  VARCHAR2,

			 pnmouvra IN  VARCHAR2,

			 METIER  IN  VARCHAR2,

			 pobjet  IN  VARCHAR2,

		     p_message    	OUT VARCHAR2,

			 p_pid    	OUT VARCHAR2) ;









END Pack_Ligne_Bip_Load;

/









CREATE OR REPLACE PACKAGE BODY Pack_Ligne_Bip_Load AS



  PROCEDURE LOAD_LIGNE_BIP (

  	       	 pnom  IN  VARCHAR2,

			 typproj  IN  VARCHAR2,

			 pdatdebpre  IN  VARCHAR2,

			 arctype  IN  VARCHAR2,

			 toptri  IN  VARCHAR2,

			 codpspe  IN  VARCHAR2,

			 airt  IN  VARCHAR2,

			 icpi  IN  VARCHAR2,

			 codsg  IN  VARCHAR2,

			 pcpi  IN  VARCHAR2,

			 clicode  IN  VARCHAR2,

			 clicode_oper  IN  VARCHAR2,

			 codcamo  IN  VARCHAR2,

			 pnmouvra IN  VARCHAR2,

			 METIER  IN  VARCHAR2,

			 pobjet  IN  VARCHAR2,

		     p_message    	OUT VARCHAR2,

			 p_pid    	OUT VARCHAR2

  ) IS



l_pid 		VARCHAR2(4);  -- variable locale pid (p_pid ne peut etre lue (OUT))

l_pcle    	 VARCHAR2(3);



BEGIN

	 BEGIN

              Pack_Ligne_Bip.calcul_pid ( l_pid );

           	  Pack_Ligne_Bip.calcul_cle( RTRIM(l_pid), l_pcle );



			  INSERT INTO LIGNE_BIP

				(PID, PCLE , FLAGLOCK, TOPFER, PCACTOP, PCONSN1, PDECN1, PETAT, DPCODE,

				PNOM, TYPPROJ, PDATDEBPRE, ARCTYPE,TOPTRI, CODPSPE, AIRT, ICPI,

				CODSG, PCPI, CLICODE, CLICODE_OPER,	CODCAMO, PZONE, METIER, POBJET)

				VALUES

				( RTRIM(l_pid), l_pcle, 0, 'N', 'O', 0 , 0 , 'M', 0,

				pnom, typproj, TO_DATE(pdatdebpre, 'mm/yyyy'), arctype,

				toptri,DECODE(codpspe,'',NULL,' ',NULL,codpspe),

				airt, icpi,	codsg, pcpi, clicode, clicode_oper,

				codcamo, pnmouvra, METIER, pobjet);

				COMMIT;

				p_pid:=RTRIM(l_pid);

		EXCEPTION

   		        WHEN DUP_VAL_ON_INDEX THEN

  						    Pack_Global.recuperer_message( 20008, '%s1', 'chargement ', NULL, p_message );

					        RAISE_APPLICATION_ERROR( -20008,p_message  );

        		 WHEN OTHERS THEN

 				            RAISE_APPLICATION_ERROR( -20997, SQLERRM);

	END;

END LOAD_LIGNE_BIP;



END Pack_Ligne_Bip_Load;

/



GRANT EXECUTE ON  BIP.PACK_RJH_LOAD_TR TO BIPU1;



