package com.socgen.bip.service;

/**
 * JAL 07/03/2008 
 * Fiche 613 : logs de l'envoi des TT vers ExpenseBis
 * 
 */
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Vector;

import org.apache.struts.action.ActionForm;

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.form.ExporterLogsEbisForm;
import com.socgen.bip.service.dto.LogsTTEbisDto;
import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.config.ConfigManager;
import com.socgen.cap.fwk.exception.BaseException;

public class RejetTTEbisDtoReader implements BipConstantes{
	 private static String PACK_SELECT_REJET_TT_EBIS = "ebis.tt.logs.liste.proc";
	 
	//private static String PACK_SELECT_REJET_TT_EBIS = "ebis.contrats.logs.liste.proc";
	public RejetTTEbisDtoReader() { 
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
			 vParamOut = jdbc.getResult(hParamProc, configProc, PACK_SELECT_REJET_TT_EBIS);
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();
				if (paramOut.getNom().equals("curseur")) {
					rset = (ResultSet) paramOut.getValeur();
				 	//try {
						 while (rset.next()) {
							LogsTTEbisDto logsFacturesEbisDto = (LogsTTEbisDto) readCurrent(rset);
							colRejFact.add(logsFacturesEbisDto);
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

	protected LogsTTEbisDto readCurrent(ResultSet rs) throws SQLException {
		LogsTTEbisDto elt = new LogsTTEbisDto(); 
		
		elt.setDPG(rs.getString("DPG"));
	    elt.setSOCCODE(rs.getString("SOCCODE"));
	    elt.setIDENT(rs.getString("IDENT"));
	    elt.setRNOM(rs.getString("RNOM"));
	    elt.setLMOISPREST(rs.getString("LMOISPREST"));
	    elt.setCUSAG(rs.getString("CUSAG"));
	    elt.setDATDEP(rs.getString("DATDEP"));
	    elt.setNUMCONT(rs.getString("NUMCONT"));
	    elt.setCAV(rs.getString("CAV"));
	    elt.setSOCCONT(rs.getString("SOCCONT"));
	    elt.setREFERENTIEL(rs.getString("REFERENTIEL"));
	    elt.setPERIMETRE(rs.getString("PERIMETRE"));
	    elt.setCDATFIN(rs.getString("CDATFIN"));
	    elt.setMESSAGE(rs.getString("MESSAGE"));
	    elt.setDATE_TRAIT(rs.getString("DATE_TRAIT"));
	    elt.setCODE_RETOUR(rs.getString("CODE_RETOUR"));
	    elt.setCODE_RETOUR(rs.getString("CODE_RETOUR"));

	    elt.setCODSG_CONT(rs.getString("CODSG_CONT"));
	    elt.setSYSCPT_CONT(rs.getString("SYSCPT_CONT"));
	    elt.setSYSCPT_RES(rs.getString("SYSCPT_RES")); 
	    
		return elt;
	}
}

