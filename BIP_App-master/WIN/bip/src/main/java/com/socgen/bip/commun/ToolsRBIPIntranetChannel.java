package com.socgen.bip.commun;

import java.util.Set;
import java.util.Vector;

import com.socgen.bip.db.RBip_Jdbc;

public class ToolsRBIPIntranetChannel {

	private static final ToolsRBIPIntranetChannel SINGLETON = new ToolsRBIPIntranetChannel();
	
	private ToolsRBIPIntranetChannel() {
	}

	public static ToolsRBIPIntranetChannel getInstance() {
		return SINGLETON;
	}

	// SEL PPM 60612
	public  Set<String> findIdLignesBipAvecChefDeProjetValides(Set<String> idLignesBipSet, Vector<String> chefProjetVector){

		// QC 1283 - Contrôle sur le PID par une procédure PLSQL.
		// if("INTRANET".equals(RBip_Jdbc.TOP)){ // RBip Intranet

//		String Procedure = ReadConfig.ReadPropFile(cle_pid_habilitation, PREFIX_PROPERTIES_FILE);
		Set<String> idLignesBipAvecCdpValides = RBip_Jdbc.findIdLignesBipAvecCdpValides(idLignesBipSet, chefProjetVector);

		return idLignesBipAvecCdpValides;
//		if ("OK".equals(RBip_Jdbc.sErrValue)) {
//			return 1; // Le user est habilité à la ligne BIP.
//		} else {
//			return 0; // Le user n'est pas habilité à la ligne BIP.
//		}
		// } // pas besoin de faire le même traitement pour la remontée sous UNIX
		// // car il est exécuté par le batch RBip.
		// return 1;

	}

}
