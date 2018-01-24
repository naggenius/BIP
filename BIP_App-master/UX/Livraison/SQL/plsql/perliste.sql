-- pack_liste_situation_personne PL/SQL
--
-- Equipe SOPRA

-- Cree le 18/03/1999
-- 
-- Modifié le 23/06/2003(NBM) :suppression espaces pour bip-C1 
-- Objet : Permet la création de la liste des situation_personne
-- Tables : situ_ress
-- Pour le fichier HTML : dtsituper
--
--**********************************************************************
--
-- Attention le nom du package ne peut etre le nom
-- de la table...


CREATE OR REPLACE PACKAGE pack_liste_situation_personne AS
		
		TYPE situation_p_RecType IS RECORD (datsitu    VARCHAR2(20),
		                                    lib        VARCHAR2(150));
		
		TYPE situation_p_CurType IS REF CURSOR RETURN situation_p_RecType;
		
		PROCEDURE lister_situation_personne(p_ident   IN CHAR,
		                                       p_userid  IN VARCHAR2,
		                                       p_curseur IN OUT situation_p_CurType
		                                      );
		
END pack_liste_situation_personne;
/				
CREATE OR REPLACE PACKAGE BODY pack_liste_situation_personne AS		
		
		   PROCEDURE lister_situation_personne (p_ident   IN CHAR, 			 						    
		                                        p_userid  IN VARCHAR2,
		                                        p_curseur IN OUT situation_p_CurType
		                                       ) IS
											   
		   l_soccode situ_ress.soccode%TYPE;
		   l_menu          VARCHAR2(255);
		
		   BEGIN
		   
		   	  l_menu := pack_global.lire_globaldata(p_userid).menutil;           

		   --Récupérer la société de la ressource pour la situation la plus récente
		   	  SELECT distinct RTRIM(soccode) INTO l_soccode FROM situ_ress          
            	   WHERE   datsitu = (select max(datsitu) from situ_ress s
				   		   		   	  where s.ident= situ_ress.ident)
				   and ident = TO_NUMBER(p_ident);
		
		      IF(l_soccode <> 'SG..') THEN
		
			      OPEN p_curseur FOR SELECT
			             TO_CHAR(datsitu,'dd/mm/yyyy'),
			             NVL(TO_CHAR(datsitu,'dd/mm/yyyy'), '          ')||' '||
			             NVL(TO_CHAR(datdep,'dd/mm/yyyy'), '          ')||' '||
			             TO_CHAR(codsg, 'FM0000000')||' '||
			             RPAD(prestation, 3, ' ')||'    '||      -- 3
			             soccode||' '||         -- 4
			             TO_CHAR(nvl(cout,0), '9999999990D00')
			     FROM situ_ress
			     WHERE ident = TO_NUMBER(p_ident)
			     ORDER BY datsitu DESC;
		
			 ELSE
			 	 -- TEST si c'est le menu administration 
				 -- si oui afficher le niveau pour les SG
				 -- sinon rien
				 IF l_menu = 'DIR' THEN 
		
				 	 OPEN p_curseur FOR SELECT
				             TO_CHAR(datsitu,'dd/mm/yyyy'),
				             NVL(TO_CHAR(datsitu,'dd/mm/yyyy'), '          ')||' '||
				             NVL(TO_CHAR(datdep,'dd/mm/yyyy'), '          ')||' '||
				             TO_CHAR(codsg, 'FM0000000')||' '||
				             RPAD(prestation, 3, ' ')||'    '||      -- 3
				             soccode||' '||         -- 4
				             nvl(niveau,'')
				     FROM situ_ress
				     WHERE ident = TO_NUMBER(p_ident)
				     ORDER BY datsitu DESC;
					 
				ELSE 
				
					 OPEN p_curseur FOR SELECT
				             TO_CHAR(datsitu,'dd/mm/yyyy'),
				             NVL(TO_CHAR(datsitu,'dd/mm/yyyy'), '          ')||' '||
				             NVL(TO_CHAR(datdep,'dd/mm/yyyy'), '          ')||' '||
				             TO_CHAR(codsg, 'FM0000000')||' '||
				             RPAD(prestation, 3, ' ')||'    '||      -- 3
				             soccode||' '        -- 4				             
				     FROM situ_ress
				     WHERE ident = TO_NUMBER(p_ident)
				     ORDER BY datsitu DESC;
				
				END IF;
		
			 END IF;	 
		
		   END lister_situation_personne;
		
END pack_liste_situation_personne;
/