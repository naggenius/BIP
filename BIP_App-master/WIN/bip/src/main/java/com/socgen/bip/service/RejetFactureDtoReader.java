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
import com.socgen.bip.service.dto.RejetFactureDto;
import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.config.ConfigManager;
import com.socgen.cap.fwk.exception.BaseException;

public class RejetFactureDtoReader implements BipConstantes {
	private static String PACK_SELECT_LISTE_REJET_FACT = "rejet_fact.select.liste.proc";
    private String numlot;
	public RejetFactureDtoReader(String numLot) {
		this.numlot=numLot;
	}

	public Collection getRejetFactureExportExcell(Hashtable hParamProc) {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		ParametreProc paramOut;

		Config configProc = ConfigManager.getInstance(BIP_PROC);
		ResultSet rset = null;
		Collection colRejFact = new ArrayList();
		try {
			vParamOut = jdbc.getResult(hParamProc, configProc, PACK_SELECT_LISTE_REJET_FACT);

			//Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();
				if (paramOut.getNom().equals("curseur")) {
					//Récupération du Ref Cursor
					rset = (ResultSet) paramOut.getValeur();

					try {
						while (rset.next()) {
							RejetFactureDto rejetFactDto = (RejetFactureDto) readCurrent(rset);
							colRejFact.add(rejetFactDto);
						}
						if (rset != null){
							jdbc.closeJDBC(); rset.close();}
					} //try
					catch (SQLException sqle) {

						jdbc.closeJDBC(); return null;

					}
				} //if
			} //for
		} catch (BaseException e1) {
			colRejFact = null;
		} 

		jdbc.closeJDBC(); return colRejFact;
	}

	/**
	 * <p>Fait le mapping entre le Dto et les informations retournées par 
	 * la requête SQL, contenus dans le jdbcWrapper</p>
	 * @param JdbcWrapper jdbcWrapper
	 * @return Dto dataObject
	 */
	protected RejetFactureDto readCurrent(ResultSet rs) throws SQLException {
		RejetFactureDto elt = new RejetFactureDto();

		elt.setNumCharg(rs.getString("NUM_CHARG"));
		elt.setCodeErr(rs.getString("CODE_ERR"));
		elt.setDateFic(rs.getString("DATE_FIC"));
		elt.setEmetteur(rs.getString("EMETTEUR"));
		elt.setMontHT(rs.getString("CODE_ERR"));
		elt.setNumOrd(rs.getString("NUMORD"));
		elt.setRefSG(rs.getString("REF_SG"));
		elt.setSiren(rs.getString("SIREN"));
		elt.setTypFact(rs.getString("TYPFACT"));
		elt.setNumFact(rs.getString("NUMFACT"));
		elt.setDatFact(rs.getString("DATFACT"));
		elt.setNumCont(rs.getString("NUMCONT"));
		elt.setRib(rs.getString("RIB"));
		elt.setMontHT(rs.getString("MONTHT"));
		elt.setMontTTC(rs.getString("MONTTTC"));
		elt.setMontTVA(rs.getString("MONTTVA"));
		elt.setDatPrest1(rs.getString("DATPREST1"));
		elt.setMontHT1(rs.getString("MONTHT1"));
		elt.setNomPrest1(rs.getString("NOM_PRENOM1"));
		elt.setDatPrest2(rs.getString("DATPREST2"));
		elt.setMontHT2(rs.getString("MONTHT2"));
		elt.setNomPrest2(rs.getString("NOM_PRENOM2"));
		elt.setDatPrest3(rs.getString("DATPREST3"));
		elt.setMontHT3(rs.getString("MONTHT3"));
		elt.setNomPrest3(rs.getString("NOM_PRENOM3"));
		elt.setDatPrest4(rs.getString("DATPREST4"));
		elt.setMontHT4(rs.getString("MONTHT4"));
		elt.setNomPrest4(rs.getString("NOM_PRENOM4"));
		elt.setDatPrest5(rs.getString("DATPREST5"));
		elt.setMontHT5(rs.getString("MONTHT5"));
		elt.setNomPrest5(rs.getString("NOM_PRENOM5"));
		elt.setDatPrest6(rs.getString("DATPREST6"));
		elt.setMontHT6(rs.getString("MONTHT6"));
		elt.setNomPrest6(rs.getString("NOM_PRENOM6"));
		elt.setDatPrest7(rs.getString("DATPREST7"));
		elt.setMontHT7(rs.getString("MONTHT7"));
		elt.setNomPrest7(rs.getString("NOM_PRENOM7"));
		elt.setDatPrest8(rs.getString("DATPREST8"));
		elt.setMontHT8(rs.getString("MONTHT8"));
		elt.setNomPrest8(rs.getString("NOM_PRENOM8"));
		elt.setLibErr(rs.getString("LIB_ERR"));
		elt.setNbPrest(rs.getString("NBPREST"));
		elt.setColonneErreur(rs.getString("NUM_CHAMPS_ERR"));
		return elt;
	}

}
