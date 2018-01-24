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

		// QC 1283 - Contr�le sur le PID par une proc�dure PLSQL.
		// if("INTRANET".equals(RBip_Jdbc.TOP)){ // RBip Intranet

//		String Procedure = ReadConfig.ReadPropFile(cle_pid_habilitation, PREFIX_PROPERTIES_FILE);
		Set<String> idLignesBipAvecCdpValides = RBip_Jdbc.findIdLignesBipAvecCdpValides(idLignesBipSet, chefProjetVector);

		return idLignesBipAvecCdpValides;
//		if ("OK".equals(RBip_Jdbc.sErrValue)) {
//			return 1; // Le user est habilit� � la ligne BIP.
//		} else {
//			return 0; // Le user n'est pas habilit� � la ligne BIP.
//		}
		// } // pas besoin de faire le m�me traitement pour la remont�e sous UNIX
		// // car il est ex�cut� par le batch RBip.
		// return 1;

	}

}
