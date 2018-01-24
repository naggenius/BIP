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
import com.socgen.bip.service.dto.ChargementFactureDto;
import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.config.ConfigManager;
import com.socgen.cap.fwk.exception.BaseException;

public class TraceIntegFactureDtoReader implements BipConstantes {
	private static String PACK_SELECT_LISTE_CHARG_FACT = "charg_fact.select.liste.proc";
    private String numlot;
	public TraceIntegFactureDtoReader(String numLot) {
		this.numlot=numLot;
	}

	public Collection getRejetFactureExportExcell(Hashtable hParamProc) {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		ParametreProc paramOut;

		Config configProc = ConfigManager.getInstance(BIP_PROC);
		ResultSet rset = null;
		Collection colChargFact = new ArrayList();
		try {
			vParamOut = jdbc.getResult(hParamProc, configProc, PACK_SELECT_LISTE_CHARG_FACT);

			//Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				if (paramOut.getNom().equals("curseur")) {
					//Récupération du Ref Cursor
					rset = (ResultSet) paramOut.getValeur();

					try {
						while (rset.next()) {
							ChargementFactureDto chargFactDto = (ChargementFactureDto) readCurrent(rset);
							colChargFact.add(chargFactDto);
						}
						if (rset != null)
							rset.close();
					} //try
					catch (SQLException sqle) {
						jdbc.closeJDBC(); return null;

					}
				} //if
			} //for
		} catch (BaseException e1) {
			colChargFact = null;
		} 
		jdbc.closeJDBC();  return colChargFact;
	}

	/**
	 * <p>Fait le mapping entre le Dto et les informations retournées par 
	 * la requête SQL, contenus dans le jdbcWrapper</p>
	 * @param JdbcWrapper jdbcWrapper
	 * @return Dto dataObject
	 */
	protected static ChargementFactureDto readCurrent(ResultSet rs) throws SQLException {
		ChargementFactureDto elt = new ChargementFactureDto();

		elt.setTypFact(rs.getString("TYPFACT"));
		elt.setNumFact(rs.getString("NUMFACT"));
		elt.setRefSG(rs.getString("REF_SG"));
		elt.setNumSMS(rs.getString("NUM_SMS"));
	    elt.setFcodUser(rs.getString("FCODUSER"));
		elt.setFmontHT(rs.getString("FMONTHT"));
		elt.setFmontTTC(rs.getString("FMONTTTC"));
		elt.setFTVA(rs.getString("FTVA"));
	    elt.setFmoiaCompta(rs.getString("FMOIACOMPTA"));
		elt.setFcodCompta(rs.getString("FCODCOMPTA"));
		elt.setFcentreFrais(rs.getString("FCENTREFRAIS"));
	    elt.setNumCont(rs.getString("NUMCONT"));
		elt.setCAV(rs.getString("CAV"));
		elt.setFstatut1(rs.getString("FSTATUT1"));
		elt.setFstatut2(rs.getString("FSTATUT2"));
		elt.setSocFact(rs.getString("SOCFACT"));
		elt.setLlibAnalyt(rs.getString("LLIBANALYT")); 
		elt.setDatFact(rs.getString("DATFACT"));
		elt.setFenrCompta(rs.getString("FENRCOMPTA"));
		elt.setFdatSai(rs.getString("FDATSAI"));
		elt.setFdatMAJ(rs.getString("FDATMAJ"));
		elt.setFaccSec(rs.getString("FACCSEC"));
		elt.setFdatRecep(rs.getString("FDATRECEP"));
		elt.setFdepPole(rs.getString("FDEPPOLE"));
		return elt;
	}

}
