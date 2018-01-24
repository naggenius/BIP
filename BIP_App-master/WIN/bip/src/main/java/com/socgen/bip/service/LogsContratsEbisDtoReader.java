package com.socgen.bip.service;

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
import com.socgen.bip.service.dto.LogsContratsEbisDto;
import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.config.ConfigManager;
import com.socgen.cap.fwk.exception.BaseException;

public class LogsContratsEbisDtoReader implements BipConstantes {
	private static String PACK_SELECT_LOG_CONTRATS_EBIS = "ebis.contrats.logs.liste.proc";
	public LogsContratsEbisDtoReader() {
	}

	public Collection getLogsContratsEbisDtoExportExcell(Hashtable hParamProc) {
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		ParametreProc paramOut;
		Config configProc = ConfigManager.getInstance(BIP_PROC);
		ResultSet rset = null;
		Collection colRejFact = new ArrayList();
		try {
			vParamOut = jdbc.getResult(hParamProc, configProc, PACK_SELECT_LOG_CONTRATS_EBIS);
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();
				if (paramOut.getNom().equals("curseur")) {
					rset = (ResultSet) paramOut.getValeur();
					try {
						while (rset.next()) {
							LogsContratsEbisDto logsContratsEbisDto = (LogsContratsEbisDto) readCurrent(rset);
							colRejFact.add(logsContratsEbisDto);
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

	protected LogsContratsEbisDto readCurrent(ResultSet rs) throws SQLException {
		LogsContratsEbisDto elt = new LogsContratsEbisDto();
		elt.setCAV(rs.getString("CAV"));
		elt.setCHAMP_CONTRAT(rs.getString("CHAMP_CONTRAT"));
		elt.setCHAMP_RESSOURCE(rs.getString("CHAMP_RESSOURCE"));
		elt.setCOMMENTAIRE(rs.getString("COMMENTAIRE"));
		elt.setIDENT(rs.getString("IDENT"));
		elt.setLCNUM(rs.getString("LCNUM"));
		elt.setNUMCONT(rs.getString("NUMCONT"));
		elt.setSOCCONT(rs.getString("SOCCONT"));
		elt.setCODSG(rs.getString("CODSG"));
		//YNI FDT 1001
		elt.setLIBDSG(rs.getString("LIBDSG"));
		//Fin YNI FDT 1001
		elt.setCDATDEB(rs.getString("CDATDEB"));
		elt.setCDATFIN(rs.getString("CDATFIN"));
		elt.setREFERENTIEL(rs.getString("REFERENTIEL"));
		elt.setPERIMETRE(rs.getString("PERIMETRE"));
		return elt;
	}
}
