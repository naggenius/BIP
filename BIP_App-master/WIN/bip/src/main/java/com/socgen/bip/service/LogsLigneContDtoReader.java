package com.socgen.bip.service;

/**
 * EVI 16/04/2008
 * Fiche 607
 * 
 */
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Vector;



import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;

import com.socgen.bip.service.dto.LogsLigneContDto;
import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.config.ConfigManager;


public class LogsLigneContDtoReader implements BipConstantes{
	 private static String PACK_SELECT = "ebis.ligne.cont.liste.proc";
	 
	public LogsLigneContDtoReader() { 
	}

	public Collection getRejetFacturesEbisDtoExportExcell(Hashtable hParamProc) throws Exception{
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		ParametreProc paramOut;
		Config configProc = ConfigManager.getInstance(BIP_PROC);
		ResultSet rset = null;
		Collection colRejFact = new ArrayList();
		
		//hParamProc.put("centreFrais", (String)hParamProc.get("centreFrais"));
		
		//try {
			 vParamOut = jdbc.getResult(hParamProc, configProc, PACK_SELECT);
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();
				if (paramOut.getNom().equals("curseur")) {
					rset = (ResultSet) paramOut.getValeur();
				 	//try {
						 while (rset.next()) {
							LogsLigneContDto logsLigneContDto = (LogsLigneContDto) readCurrent(rset);
							colRejFact.add(logsLigneContDto);
						}
						if (rset != null){
							jdbc.closeJDBC(); 
							rset.close();
							} 
				//------------------ ATTENTION -----------------------------------
			    //NE pas faire comme les autres DTO Reader 
			    //il ne faut pas catcher l'erreur et la remonter via le throws de la méthode
			    //sinon on perd beaucoup plus de temps àrechercher l'erreur
					 //} //try
					/* catch (SQLException sqle) {
					 	jdbc.closeJDBC(); 
					 	return  new ArrayList();
					 } */
				} //if
			} //for
	//	} catch (BaseException e1) {
		//	colRejFact = null;
		//} 
		jdbc.closeJDBC();  
		return colRejFact;
	}

	protected LogsLigneContDto readCurrent(ResultSet rs) throws SQLException {
		LogsLigneContDto elt = new LogsLigneContDto();
		
		elt.setTYPE_ACTION(rs.getString("TYPE_ACTION"));
	    elt.setDATE_LOG(rs.getString("DATE_LOG"));
	    elt.setUSER_LOG(rs.getString("USER_LOG"));
	    elt.setCONTRAT(rs.getString("CONTRAT"));
		elt.setPERIMETRE(rs.getString("PERIMETRE"));
	    elt.setREFFOURNISSEUR(rs.getString("REFFOURNISSEUR"));
	    elt.setFOURNISSEUR(rs.getString("FOURNISSEUR"));
	    elt.setLIGNE(rs.getString("LIGNE"));
	    elt.setCODE_RESSOURCE(rs.getString("CODE_RESSOURCE"));
	    elt.setNOM_RESSOURCE(rs.getString("NOM_RESSOURCE"));
	    elt.setDATEDEB_LIGNE(rs.getString("DATEDEB_LIGNE"));
	    elt.setDATEFIN_LIGNE(rs.getString("DATEFIN_LIGNE"));
	    elt.setSOCIETE(rs.getString("SOCIETE"));
	    elt.setSIREN(rs.getString("SIREN"));
	    elt.setAVENANT(rs.getString("AVENANT"));
	    elt.setDATDEBCONTRAT(rs.getString("DATDEBCONTRAT"));
	    elt.setDATFINCONTRAT(rs.getString("DATFINCONTRAT"));
	    	    
		return elt;
	}
}

