
  CREATE GLOBAL TEMPORARY TABLE BIP.HIERARCHY 
   (	IDENT NUMBER(5,0), 
	CP_IDENT NUMBER(5,0), 
	NAME VARCHAR2(50), 
	LIGNE_BIP_CNT NUMBER(9,0), 
	ACT_IND VARCHAR2(1), 
	MAN_IND VARCHAR2(1), 
	LEVL NUMBER(18,9), 
	SEL_IND VARCHAR2(1)
   ) ON COMMIT PRESERVE ROWS ;
