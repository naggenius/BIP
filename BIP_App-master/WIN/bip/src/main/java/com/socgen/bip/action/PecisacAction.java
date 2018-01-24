package com.socgen.bip.action;

/**
 * @author N.BACCAM - 25/06/2003
 *
 * Formulaire pour la prise en charge sur ISAC
 * chemin : Administration/Prise en charge ISAC
 * pages  : fPecisacAd.jsp 
 * pl/sql : pmw2isac.sql
 */
public class PecisacAction extends SocieteAction {


	private static String PACK_INSERT = "pecisac.creer.proc";
	
	private String nomProc;
	
   

	protected String recupererCle(String mode) {
		String cle = null;
		
		cle=PACK_INSERT;
		
		
		return cle;
	}
	

}
