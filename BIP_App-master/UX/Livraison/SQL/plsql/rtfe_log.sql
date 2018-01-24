-- *****************************************************************************************
-- Package pour la survaillance des utilisateurs
--
-- ABA le 27/01/2011 Fiche TD 916
-- BSA le 06/05/2011 QC 1176
-- ******************************************************************************************

CREATE OR REPLACE PACKAGE Pack_Rtfe_Log AS

-- --------------------------------------------------------------------------------------------------
-- Procédure qui alimente la table rtfe_log lors de chaque connexion
-- -------------------------------------------------------------------------------------------------
   PROCEDURE alim_rtfe_log ( p_user_rtfe     	      IN  VARCHAR2 );

END Pack_Rtfe_Log;
/


CREATE OR REPLACE PACKAGE BODY Pack_Rtfe_Log AS

-----------------------------------------------------
-- Gestions exceptions
-----------------------------------------------------
CALLEE_FAILED EXCEPTION;
PRAGMA EXCEPTION_INIT( CALLEE_FAILED, -20000 );
CALLEE_FAILED_ID     NUMBER := -20000;   -- pour propagation dans pile d'appel
TRCLOG_FAILED_ID     NUMBER := -20001;   -- problème : erreur dans la gestion d'erreur !
ERR_FONCTIONNELLE_ID NUMBER := -20002;   -- pour provoquer erreur alors que Oracle OK
CONSTRAINT_VIOLATION EXCEPTION;          -- pour clause when
VIOLATION_CONSTRAINT_UNIQUE EXCEPTION;          -- pour clause when
PRAGMA EXCEPTION_INIT( CONSTRAINT_VIOLATION, -2291 ); -- typiquement : clé étrangère
PRAGMA EXCEPTION_INIT( VIOLATION_CONSTRAINT_UNIQUE, -00001 );



-- --------------------------------------------------------------------------------------------------
-- Procédure qui alimente la table rtfe_log lors de chaque connexion
-- -------------------------------------------------------------------------------------------------
   PROCEDURE alim_rtfe_log ( p_user_rtfe     	      IN  VARCHAR2 ) IS


	BEGIN

	                     INSERT INTO RTFE_LOG(USER_RTFE,
					   					 				 				  	 	MOIS,
																				NBR_CONNEXION
																				)
				                                              VALUES(
																 				  p_user_rtfe,
																				  TO_DATE(TO_CHAR(SYSDATE,'mm/yyyy'),'mm/yyyy') ,
																				  1
																				 );
                             COMMIT;

				       EXCEPTION

             			    WHEN VIOLATION_CONSTRAINT_UNIQUE THEN

	                                    UPDATE RTFE_LOG
				                        SET  NBR_CONNEXION = NVL(NBR_CONNEXION,0) + 1
			  	   	                               WHERE   UPPER(USER_RTFE) = UPPER(p_user_rtfe)
							                       AND TO_CHAR(MOIS,'mm/yyyy') = TO_CHAR(SYSDATE,'mm/yyyy')
			                                      ;
										COMMIT;

							 WHEN OTHERS THEN
					              		RAISE_APPLICATION_ERROR( -20997, SQLERRM);



	END alim_rtfe_log ;



END  Pack_Rtfe_Log;
/


