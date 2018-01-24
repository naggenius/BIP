package com.socgen.bip.service;

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
import com.socgen.bip.service.dto.LogsFacturesEbisDto;
import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.config.ConfigManager;
import com.socgen.cap.fwk.exception.BaseException;

public class RejetFacturesEbisDtoReader implements BipConstantes {
	private static String PACK_SELECT_REJET_FACTURES_EBIS = "ebis.factures.rejet.liste.proc";
	public RejetFacturesEbisDtoReader() {
	}

	public Collection getRejetFacturesEbisDtoExportExcell(Hashtable hParamProc) {
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		ParametreProc paramOut;
		Config configProc = ConfigManager.getInstance(BIP_PROC);
		ResultSet rset = null;
		Collection colRejFact = new ArrayList();
		
		//hParamProc.put("centreFrais", (String)hParamProc.get("centreFrais"));
		
		try {
			vParamOut = jdbc.getResult(hParamProc, configProc, PACK_SELECT_REJET_FACTURES_EBIS);
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();
				if (paramOut.getNom().equals("curseur")) {
					rset = (ResultSet) paramOut.getValeur();
					try {
						while (rset.next()) {
							LogsFacturesEbisDto logsFacturesEbisDto = (LogsFacturesEbisDto) readCurrent(rset);
							colRejFact.add(logsFacturesEbisDto);
						}
						if (rset != null){
							jdbc.closeJDBC(); rset.close();}
					} //try
					catch (SQLException sqle) {
						jdbc.closeJDBC(); 
						return null;
					}
				} //if
			} //for
		} catch (BaseException e1) {
			colRejFact = null;
		} 
		jdbc.closeJDBC(); 
		return colRejFact;
	}

	protected LogsFacturesEbisDto readCurrent(ResultSet rs) throws SQLException {
		LogsFacturesEbisDto elt = new LogsFacturesEbisDto();
		elt.setNUMCONT(rs.getString("NUMCONT"));
		elt.setNUMFACT(rs.getString("NUMFACT"));
		elt.setTYPFACT(rs.getString("TYPFACT"));
		elt.setDATFACT(rs.getString("DATFACT"));
		elt.setCAV(rs.getString("CAV"));
		elt.setCD_REFERENTIEL(rs.getString("CD_REFERENTIEL"));
		elt.setCD_EXPENSE(rs.getString("CD_EXPENSE"));
		elt.setSOCCODE(rs.getString("SOCCODE"));
		elt.setNUM_EXPENSE(rs.getString("NUM_EXPENSE"));
		elt.setFMONTHT(rs.getString("FMONTHT"));
		elt.setFMONTTTC(rs.getString("FMONTTTC"));
		elt.setDATE_COMPTA(rs.getString("DATE_COMPTA"));
		elt.setLNUM(rs.getString("LNUM"));
		elt.setIDENT(rs.getString("IDENT"));
		elt.setLMONTHT(rs.getString("LMONTHT"));
		elt.setLMOISPREST(rs.getString("LMOISPREST"));
		elt.setCUSAG_EXPENSE(rs.getString("CUSAG_EXPENSE"));
		elt.setTOPPOST(rs.getString("TOPPOST"));
		elt.setTIMESTAMP(rs.getString("TIMESTAMP"));
		elt.setCODE_RETOUR(rs.getString("CODE_RETOUR"));
		elt.setTOP_ETAT(rs.getString("TOP_ETAT"));
		elt.setNUMENR(rs.getString("NUMENR"));
		return elt;
	}
}
