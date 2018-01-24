/*
 * Créé le 12 août 04
 */
package com.socgen.bip.rbip.intra;

import java.io.BufferedReader;
import java.sql.Clob;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Vector;

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.Tools;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.ExceptionTechnique;
import com.socgen.bip.rbip.commun.erreur.RBipErreur;
import com.socgen.bip.user.UserBip;
import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.config.ConfigManager;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author X039435
 */
public class RBipFichier implements BipConstantes {
	public static final int STATUT_ERREUR = -1;

	public static final int STATUT_NO_DATA = 0;

	public static final int STATUT_NON_CONTROLE = 1;

	public static final int STATUT_CONTROLE_OK = 2;
	
	public static final int STATUT_CONTROLE_OK_WARNING = 22;

	public static final int STATUT_CONTROLE_KO = 3;

	public static final int STATUT_REMPLACE = 4;

	public static final int STATUT_CHARGE = 5;

	public static final int STATUT_SUPPRIME = 6;

	public static final int STATUT_PBIP_OK = 7;
	
	//SEL PPM 60612 : Statuts BIPS
	//(H) Fichier .BIPS xxxxxxxxxxxxxx 
	public static final int BIPS_STATUT_OK = 10;
	
	public static final int BIPS_STATUT_OK_WARNINGS = 11;
	
	//(H) Fichier .BIPS invalide
	public static final int BIPS_STATUT_REJET = 12;
	
	//(B) Fichiers .BIPS entièrement valides
	public static final int BIPS_STATUT_ENT_VAL_OK = 13;
	
	//(B) Fichiers .BIPS entièrement valides avec avertissements
	public static final int BIPS_STATUT_ENT_VAL_WARNINGS = 14;
	
	//(B) Fichiers .BIPS partiellement valides
	public static final int BIPS_STATUT_PAR_VAL = 15;
	
	//(B) Fichiers .BIPS entièrement valides et entièrement traités
	public static final int BIPS_STATUT_ENT_VAL_ENT_TRT_OK = 16;
	
	//(B) Fichiers .BIPS entièrement valides et entièrement traités avec avertissements
	public static final int BIPS_STATUT_ENT_VAL_ENT_TRT_WARNINGS = 17;
	
	//(B) Fichiers .BIPS partiellement valides et entièrement traités
	public static final int BIPS_STATUT_PAR_VAL_ENT_TRT = 18;
	
	
	
	//(B) Fichiers .BIPS entièrement valides et partiellement traités
	public static final int BIPS_STATUT_ENT_VAL_PAR_TRT = 19;
	
	//(B) Fichiers .BIPS entièrement valides avece des Warnings et partiellement traités
	public static final int	BIPS_STATUT_ENT_VAL_PAR_TRT_WARNINGS = 20;
	
	//(B) Fichiers .BIPS partiellement valides et partiellement traités
	public static final int BIPS_STATUT_PAR_VAL_PAR_TRT = 21;
	

	/**
	 * Config pointant sur le fichier de définition des procédures stockées des
	 * reports.<br>
	 * La valeur est récupérée de la classe com.socgen.bip.metier.Report
	 */
	public static final Config cfgProc = ConfigManager.getInstance(BIP_PROC);

	/**
	 * Identifiants des procédures stockées utilisées pour manipuler la table
	 * REMONTEE
	 */
	protected static String PROC_INSERT = "remontee.insert";

	protected static String PROC_UPDATE = "remontee.update";
	
	protected static String PROC_UPDATE_BIPS = "remontee.update_bips";

	protected static String PROC_REMPLACE = "remontee.remplacer";

	protected static String PROC_GET_FICHIER = "remontee.get_fichier";
	
	protected static String PROC_GET_FICHIER_BIPS = "remontee.get_fichier_bips";

	protected static String PROC_GET_DATA = "remontee.get_data_fichier";
	
	protected static String PROC_GET_DATA_BIPS = "remontee.get_data_fichier_bips";

	protected static String PROC_GET_ERREUR = "remontee.get_erreur_fichier";
	
	protected static String PROC_GET_ERREUR_BIPS = "remontee.get_erreur_fichier_bips";

	protected static String PROC_SELECT_FICHIERS = "remontee.select_fichiers";

	protected static String PID_ERREUR = "????";

	protected static String PID_MSP = "_MSP";
	
	protected static String PID_BIPS = "BIPS";

	// String sTypeFichier;
	String sPID;

	String sIDRemonteur;

	String sFichierData;

	String sFichierErreur;

	int iStatut;

	Date dStatutDate;

	String sStatutInfo;

	Vector vErreurs;

	Vector vLignes;

	// on ne l'utilise pas
	Vector vData;

	Vector vWarning;
	
	//SEL PPM 60612
	UserBip userBip;
	
	String action;

	public static String getTypeFichier(String sFichier) {
		String sType;
		if (sFichier.endsWith(sBipExtension)
				|| sFichier.endsWith(sBipExtension.toUpperCase())) {
			sType = FICHIER_BIP;
		} else if (sFichier.endsWith(sPBipExtension)
				|| sFichier.endsWith(sPBipExtension.toUpperCase())) {
			sType = FICHIER_PBIP;
			//PPM 60612
		} else if (sFichier.endsWith(sPBipsExtension)
				|| sFichier.endsWith(sPBipsExtension.toUpperCase())) {
			sType = FICHIER_BIPS;
		} else {
			sType = "???";
		}

		logService.debug("Type du fichier " + sFichier + " : " + sType);
		return sType;
	}

	/**
	 * 
	 * @param sFichier
	 * @param vLignes
	 */
	public RBipFichier(String sIDRemonteur, String sFichier, Vector vLignes) {
		if (getTypeFichier(sFichier).equals(FICHIER_PBIP)) {
			sPID = PID_MSP;
		} else {
			sPID = Tools.getPIDFromFileName(sFichier);
			if (sPID == null)
				sPID = PID_ERREUR;
		}
		this.sIDRemonteur = sIDRemonteur;
		this.sFichierData = sFichier;
		this.vLignes = vLignes;

		vData = null;
		vErreurs = null;
		vWarning = null;

		iStatut = STATUT_NO_DATA;
		sStatutInfo = "";
	}

	public RBipFichier(UserBip userBip, String sFichier, Vector vLignes,String action) {
		
		if (getTypeFichier(sFichier).equals(FICHIER_PBIP)) {
			sPID = PID_MSP;
		} 
		
		else if (getTypeFichier(sFichier).equals(FICHIER_BIPS))
		{
			sPID = PID_BIPS;
		}
		else {
			sPID = Tools.getPIDFromFileName(sFichier);
			if (sPID == null)
				sPID = PID_ERREUR;
		}
		this.sIDRemonteur = userBip.getIdUser();
		this.sFichierData = sFichier;
		this.vLignes = vLignes;
		this.userBip = userBip;
		this.action=action;
		
		vData = null;
		vErreurs = null;
		vWarning = null;

		iStatut = STATUT_NO_DATA;
		sStatutInfo = action;
	}

	/**
	 * on recherche dans la base l'enregistrement identifie par les 2 parametre
	 * et on instancie avec les infos récupérees
	 * 
	 * @param sPID
	 * @param sIDRemonteur
	 */
	public RBipFichier(String sPID, String sIDRemonteur, String sFichierData,
			int iStatut, Date dStatutDate, String sStatutInfo, Vector vLignes) {
		this.sPID = sPID;
		this.sIDRemonteur = sIDRemonteur;
		this.sFichierData = sFichierData;
		this.iStatut = iStatut;
		this.dStatutDate = dStatutDate;
		this.sStatutInfo = sStatutInfo;
		this.vLignes = vLignes;

		vData = null;
		vErreurs = null;
		vWarning = null;
	}

	/**
	 * si il y a deja un enregistrement pour ce PID qui n'a ete pris en
	 * mensuelle (statut != 'remonte'), celui la passe en 'remplacé'
	 * 
	 */
	public synchronized void alimBase() throws BaseException {
		Hashtable hParam = new Hashtable();
		Vector vRes;
		JdbcBip jdbc = new JdbcBip(); 
 
		
		hParam.put("pid", sPID);
		hParam.put("id_remonteur", sIDRemonteur);
		hParam.put("fichier_data", sFichierData);
		// appel a remontee.remplace_fichiers(pid, id_remonteur)
		vRes = jdbc.getResult(hParam, cfgProc,
				PROC_REMPLACE);
		
		hParam.put("statut", "" + iStatut);
		hParam.put("statut_info", sStatutInfo);
		

		try {
			vRes = jdbc.getResult( hParam, cfgProc, PROC_INSERT);
		} catch (BaseException e) {
			RBipManager.logService.error("RBipFichier::alimBase", e);
			throw e;
		} finally {
			jdbc.closeJDBC();
		}

		if (vLignes == null) {
			setStatut(STATUT_ERREUR, "Le fichier est illisible");
		} else {
			setStatut(STATUT_NO_DATA, sStatutInfo);
		}
	}

	public static final String TABLE_REMONTEE = "REMONTEE";

	public static final String CHAMP_DATA = "DATA";

	public static final String CHAMP_ERREUR = "ERREUR";

	protected  void alimLignes() throws BaseException {
		// try { Thread.sleep(100); } catch (InterruptedException iE) {}
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vRes = new Vector();
		ParametreProc pP = new ParametreProc();
		String clause="PID='" + sPID + "' and ID_REMONTEUR='"+ sIDRemonteur + "'";
		String clauseBips=" and FICHIER_DATA = '"+sFichierData+"' ";
		
		//SEL PPM 60612
		if(getTypeFichier(sFichierData).equals(FICHIER_BIPS))
		{
			clause=clause+clauseBips;
		}
		
		try {
			alimBase();
			jdbc.alimCLOB(jdbc.DATASOURCE_REMONTEE, TABLE_REMONTEE,
					CHAMP_DATA, 
					clause, 
					vLignes);
		} catch (BaseException e) {
			RBipManager.logService.error("RBipFichier::alimLignes", e);
			throw e;
		}

		// si statut a 'remplace', on l'y laisse
		Hashtable hParam = new Hashtable();
		hParam.put("pid", sPID);
		hParam.put("id_remonteur", sIDRemonteur);
		
		if (sFichierData.endsWith(sPBipsExtension)
				|| sFichierData.endsWith(sPBipsExtension.toUpperCase()))
		{
			hParam.put("fichier_data", sFichierData);
			vRes = jdbc.getResult(hParam,
					cfgProc, PROC_GET_FICHIER_BIPS);
			 pP = (ParametreProc) vRes.elementAt(0);
		}
		else
		{
			vRes = jdbc.getResult(hParam,
				cfgProc, PROC_GET_FICHIER);
			 pP = (ParametreProc) vRes.elementAt(1);
		}
		
		
		iStatut = ((Integer) pP.getValeur()).intValue();
		jdbc.closeJDBC();

		if (iStatut != STATUT_REMPLACE)
			setStatut(STATUT_NON_CONTROLE, sStatutInfo);

		// try { Thread.sleep(100); } catch (InterruptedException iE) {}
	}

	public static void setStatut(String sPID, String sIDRemonteur, int iStatut,
			String sStatutInfo,String sFichierData) {
		Hashtable hParam = new Hashtable();
    
		JdbcBip jdbc = new JdbcBip(); 
		
		// System.out.println("setStatut : " + iStatut + " de " +
		// this.toString());
		hParam.put("pid", sPID);
		hParam.put("id_remonteur", sIDRemonteur);
		hParam.put("statut", "" + iStatut);
		hParam.put("statut_info", sStatutInfo);

		try {
			
			if (sFichierData.endsWith(sPBipsExtension)
					|| sFichierData.endsWith(sPBipsExtension.toUpperCase()))
			{
				hParam.put("fichier_data", sFichierData);
				Vector vRes = jdbc.getResult(hParam, cfgProc, PROC_UPDATE_BIPS);
			}
			else
			{
				Vector vRes = jdbc.getResult(hParam, cfgProc, PROC_UPDATE);
			}
			
			
		} catch (BaseException bE) {
			RBipManager.logService.error("RBipFichier::setStatut", bE);
			throw new ExceptionTechnique(bE);
		} finally {
			jdbc.closeJDBC();
		}
	}

	protected void setStatut(int iStatut, String sStatutInfo) {
		if (getTypeFichier(sFichierData).equals(FICHIER_PBIP)) {
			iStatut = STATUT_PBIP_OK;
		}
		setStatut(sPID, sIDRemonteur, iStatut, sStatutInfo,sFichierData);
	}

	public void setDataErreur(Vector vData, Vector vErreur)
			throws BaseException {
		this.vData = vData;
		this.vErreurs = vErreur;

		Vector vLignesErreur = new Vector();
		Vector vRes = null;
		ParametreProc pP = new ParametreProc();
		
		JdbcBip jdbc = new JdbcBip(); 
 
		
		if (vErreur.isEmpty()) {
			// si statut a 'remplace', on l'y laisse
			Hashtable hParam = new Hashtable();
			hParam.put("pid", sPID);
			hParam.put("id_remonteur", sIDRemonteur);
			try {
				
				if (sFichierData.endsWith(sPBipsExtension)
						|| sFichierData.endsWith(sPBipsExtension.toUpperCase()))
				{
					hParam.put("fichier_data", sFichierData);
					vRes = jdbc.getResult(hParam,
							cfgProc, PROC_GET_FICHIER_BIPS);
					pP = (ParametreProc) vRes.elementAt(0);
				}
				else
				{
					vRes = jdbc.getResult(hParam,
						cfgProc, PROC_GET_FICHIER);
					pP = (ParametreProc) vRes.elementAt(1);
				}
				
			} catch (BaseException bE) {
				RBipManager.logService
						.error(
								"RBipFichier::setDataErreur - vErreur.isEmpty() == true  ",
								bE);
				throw bE;
			} finally {
				jdbc.closeJDBC();
			}

			
			iStatut = ((Integer) pP.getValeur()).intValue();

			if (iStatut != STATUT_REMPLACE)
				setStatut(getTypeFichier(sFichierData).equals(FICHIER_BIPS)?BIPS_STATUT_OK:STATUT_CONTROLE_OK, sStatutInfo);
		} else {

			// alim de la base
			Vector vLignes2Update = new Vector();
			for (int i = 0; i < getErreurs().size(); i++) {
				vLignes2Update.add(((RBipErreur) getErreurs().elementAt(i))
						.getCSVToSave());
			}

			try {
				
				String clause="PID='" + sPID + "' and ID_REMONTEUR='"+ sIDRemonteur + "'";
				String clauseBips=" and FICHIER_DATA = '"+sFichierData+"' ";
				
				//SEL PPM 60612
				if(getTypeFichier(sFichierData).equals(FICHIER_BIPS))
				{
					clause=clause+clauseBips;
				}
				
				jdbc.alimCLOB(jdbc.DATASOURCE_REMONTEE, TABLE_REMONTEE,
						CHAMP_ERREUR, 
						 clause
						, vLignes2Update);
			} catch (BaseException bE) {
				RBipManager.logService
						.error(
								"RBipFichier::setDataErreur - vErreur.isEmpty() == false  ",
								bE);
				throw bE;
			}
			setStatut(getTypeFichier(sFichierData).equals(FICHIER_BIPS)?BIPS_STATUT_REJET:STATUT_CONTROLE_KO, sStatutInfo);
			
		}
	}
	
	public void setDataErreurWarning(Vector vData, Vector vErreur, Vector vWarning, String sAction)
	throws BaseException {
this.vData = vData;
this.vErreurs = vErreur;
this.vWarning = vWarning;

int nbErreurs = 0;
int nbWarnings = 0;

Vector vLignesErreur = new Vector();
Vector vRes = null;
ParametreProc pP = new ParametreProc();

String listErr="";

JdbcBip jdbc = new JdbcBip(); 


if (vErreur.isEmpty()) {
	// si statut a 'remplace', on l'y laisse
	Hashtable hParam = new Hashtable();
	hParam.put("pid", sPID);
	hParam.put("id_remonteur", sIDRemonteur);
	try {
		
		if (sFichierData.endsWith(sPBipsExtension)
				|| sFichierData.endsWith(sPBipsExtension.toUpperCase()))
		{
			hParam.put("fichier_data", sFichierData);
			vRes = jdbc.getResult(hParam,
					cfgProc, PROC_GET_FICHIER_BIPS);
			pP = (ParametreProc) vRes.elementAt(0);
		}
		else
		{
			vRes = jdbc.getResult(hParam,
				cfgProc, PROC_GET_FICHIER);
			pP = (ParametreProc) vRes.elementAt(1);
		}
		
	} catch (BaseException bE) {
		RBipManager.logService
				.error(
						"RBipFichier::setDataErreur - vErreur.isEmpty() == true  ",
						bE);
		throw bE;
	} finally {
		jdbc.closeJDBC();
	}

	
	iStatut = ((Integer) pP.getValeur()).intValue();

	if (iStatut != STATUT_REMPLACE)
	{
			if (vWarning.size() != 0)
			{
				
				Vector vLignes2Update = new Vector();
				for (int i = 0; i < getWarnings().size(); i++) {
					vLignes2Update.add(((RBipErreur) getWarnings().elementAt(i))
							.getCSVToSave());
				}
				
				try {
					
					String clause="PID='" + sPID + "' and ID_REMONTEUR='"+ sIDRemonteur + "'";
					String clauseBips=" and FICHIER_DATA = '"+sFichierData+"' ";
					
					//SEL PPM 60612
					if(getTypeFichier(sFichierData).equals(FICHIER_BIPS))
					{
						clause=clause+clauseBips;
					}
					
					jdbc.alimCLOB(jdbc.DATASOURCE_REMONTEE, TABLE_REMONTEE,
							CHAMP_ERREUR, 
							 clause
							, vLignes2Update);
				} catch (BaseException bE) {
					RBipManager.logService
							.error(
									"RBipFichier::setDataErreur - vErreur.isEmpty() == false  ",
									bE);
					throw bE;
				}
				
				// pas de rejet , avec des warnings
				if("controler".equals(sAction)) 
				{
					
					setStatut(BIPS_STATUT_ENT_VAL_WARNINGS, sStatutInfo);
					
				}
				else
				{
					setStatut(BIPS_STATUT_ENT_VAL_ENT_TRT_WARNINGS, sStatutInfo);
				}
				
			   
			}else // pas de rejet , pas de warnings
			{
				if("controler".equals(sAction))
				{
					
					setStatut(BIPS_STATUT_ENT_VAL_OK, sStatutInfo);
					
				}
				else
				{
					setStatut(BIPS_STATUT_ENT_VAL_ENT_TRT_OK, sStatutInfo);
				}
			}
	}
} else {

	// alim de la base
	Vector vLignes2Update = new Vector();
	for (int i = 0; i < getErreurs().size(); i++) {
		vLignes2Update.add(((RBipErreur) getErreurs().elementAt(i))
				.getCSVToSave());
	}
	
	for (int i = 0; i < getWarnings().size(); i++) {
		vLignes2Update.add(((RBipErreur) getWarnings().elementAt(i))
				.getCSVToSave());
	}
	
	try {
		
		String clause="PID='" + sPID + "' and ID_REMONTEUR='"+ sIDRemonteur + "'";
		String clauseBips=" and FICHIER_DATA = '"+sFichierData+"' ";
		
		//SEL PPM 60612
		if(getTypeFichier(sFichierData).equals(FICHIER_BIPS))
		{
			clause=clause+clauseBips;
		}
		
		jdbc.alimCLOB(jdbc.DATASOURCE_REMONTEE, TABLE_REMONTEE,
				CHAMP_ERREUR, 
				 clause
				, vLignes2Update);
	} catch (BaseException bE) {
		RBipManager.logService
				.error(
						"RBipFichier::setDataErreur - vErreur.isEmpty() == false  ",
						bE);
		throw bE;
	}
	
	
//	Iterator itErreur = vErreur.iterator();
//	
//	while (itErreur.hasNext())
//	{
//		int n = ((RBipErreur) itErreur.next()).getNumLigne();
//			if(!listErr.contains(n+""))
//			listErr+=n+";";
//		
//	}
//	
//	nbErreurs = listErr.split(";").length;
	
	// avec rejets
	if("controler".equals(sAction)) 
	{
		
		if(vData.size()>0) // des rejets
		{
			setStatut(BIPS_STATUT_PAR_VAL, sStatutInfo);
		}
		else // tout est rejet
		{
			setStatut(BIPS_STATUT_REJET, sStatutInfo);
		}
		
		
		
	}
	else
	{

		if(vData.size()>1) // des rejets
		{
			setStatut(BIPS_STATUT_PAR_VAL_ENT_TRT, sStatutInfo);
		}
		else // tout est rejet
		{
			setStatut(BIPS_STATUT_REJET, sStatutInfo);
		}
	}
	
}
}

	public static void supprimerFichier(String sPID, String sIDRemonteur,String sFichier_data)
			throws BaseException {
		setStatut(sPID, sIDRemonteur, STATUT_SUPPRIME, "",sFichier_data);
	}

	public static Vector getLignesFichier(String sPID, String sIDRemonteur, String sFichier)
			throws BaseException {
		Hashtable hParam = new Hashtable();
		Vector vRes = null;
		hParam.put("pid", sPID);
		hParam.put("id_remonteur", sIDRemonteur);
        
		JdbcBip jdbc = new JdbcBip(); 

		try {
			
			if (sFichier.endsWith(sPBipsExtension)
					|| sFichier.endsWith(sPBipsExtension.toUpperCase()))
			{
				hParam.put("fichier_data", sFichier);
				vRes = jdbc.getResult(hParam,
						cfgProc, PROC_GET_DATA_BIPS);
			}
			else
			{
				vRes = jdbc.getResult( hParam,
						cfgProc, PROC_GET_DATA);
			}
			
		} catch (BaseException bE) {
			RBipManager.logService.error("RBipFichier::getLignesFichier ", bE);
			throw bE;
		} finally {
			jdbc.closeJDBC();
		}
		
		ParametreProc pP = (ParametreProc) vRes.elementAt(0);
		Clob clob = (Clob) pP.getValeur();

		String sTmp;
		Vector vTmp = new Vector();
		try {
			BufferedReader r = new BufferedReader(clob.getCharacterStream());

			while ((sTmp = r.readLine()) != null) {
				vTmp.add(sTmp);
			}
			r.close();
		} catch (Exception sqlE) {
			RBipManager.logService
					.error("RBipFichier::getLignesFichier ", sqlE);
		}
		return vTmp;
	}

	public static Vector getErreursFichier(String sPID, String sIDRemonteur,String sFichier)
			throws BaseException {
		Hashtable hParam = new Hashtable();
		Vector vRes = null;

		JdbcBip jdbc = new JdbcBip(); 

		
		hParam.put("pid", sPID);
		hParam.put("id_remonteur", sIDRemonteur);

		try {
			
			
			if (sFichier.endsWith(sPBipsExtension)
					|| sFichier.endsWith(sPBipsExtension.toUpperCase()))
			{
				hParam.put("fichier_data", sFichier);
				vRes = jdbc.getResult(hParam,cfgProc, PROC_GET_ERREUR_BIPS);
			}
			else
			{
				vRes = jdbc.getResult(hParam,cfgProc, PROC_GET_ERREUR);
			}
			
		} catch (BaseException bE) {
			RBipManager.logService.error("RBipFichier::getErreursFichier ", bE);
			throw bE;
		} finally {
			jdbc.closeJDBC();
		}

		ParametreProc pP = (ParametreProc) vRes.elementAt(0);
		Clob clob = (Clob) pP.getValeur();
		String sTmp;
		Vector vTmp = new Vector();
		try {
			BufferedReader r = new BufferedReader(clob.getCharacterStream());

			while ((sTmp = r.readLine()) != null) {
				vTmp.add(sTmp);
			}
			r.close();
		} catch (Exception sqlE) {
			RBipManager.logService.error("RBipFichier::getErreursFichier ",
					sqlE);
		}
		return vTmp;
	}

	public static Vector getFichiersUser(String sIDRemonteur) {
		Vector vFichiers = new Vector();
		Vector vRes;
		Hashtable hParam = new Hashtable();

		JdbcBip jdbc = new JdbcBip(); 

		
		try {
			hParam.put("id_remonteur", sIDRemonteur);
			vRes = jdbc.getResult(hParam,cfgProc, PROC_SELECT_FICHIERS);

			ParametreProc paramOut = (ParametreProc) vRes.firstElement();

			ResultSet rset = (ResultSet) paramOut.getValeur();
			try {
				while (rset.next()) {
					Vector vTmp = new Vector();
					vTmp.add(rset.getString(1)); // PID
					vTmp.add(rset.getString(2)); // ID_remonteur
					vTmp.add(rset.getString(3)); // fichier
					vTmp.add(rset.getString(4)); // statut
					vTmp.add(rset.getString(5)); // statut_info
					vTmp.add(rset.getString(6)); // statut_date
					vFichiers.add(vTmp);
				}
				if (rset != null)
					rset.close();
			} catch (SQLException sqlE) {
				throw new BaseException(BaseException.BASE_EXEC_SQL, sqlE);
			}
		} catch (BaseException bE) {
			RBipManager.logService.error("RBipFichier::getFichierUser ", bE);
		} finally {

			jdbc.closeJDBC();
		}
		return vFichiers;
	}

	/**
	 * @return
	 */
	public String getIDRemonteur() {
		return sIDRemonteur;
	}

	/**
	 * @return
	 */
	public String getPID() {
		return sPID;
	}

	public String toString() {
		return sPID + " / " + sIDRemonteur + " : " + sFichierData;
	}

	public String getFileName() {
		return sFichierData;
	}

	public Vector getErreurs() {
		return vErreurs;
	}
	
	public Vector getWarnings() {
		return vWarning;
	}

	public Vector getLignes() {
		return vLignes;
	}

	public Vector getData() {
		return vData;
	}

	public UserBip getUserBip() {
		return userBip;
	}

	public String getAction() {
		return action;
	}

	public void setAction(String action) {
		this.action = action;
	}

	public void setDataErreur(Vector rBipData, Vector erreurs, Vector warnings) throws BaseException {
		
		ParametreProc pP = new ParametreProc();
		
		JdbcBip jdbc = new JdbcBip(); 

		setDataErreur(rBipData,erreurs);
		
		if(erreurs.isEmpty() && !warnings.isEmpty())
		{
			
			// alim de la base
			Vector vLignes2Update = new Vector();
			for (int i = 0; i < warnings.size(); i++) {
				vLignes2Update.add(((RBipErreur) warnings.elementAt(i))
						.getCSVToSave());
			}

			try {
				
				String clause="PID='" + sPID + "' and ID_REMONTEUR='"+ sIDRemonteur + "'";
				
				jdbc.alimCLOB(jdbc.DATASOURCE_REMONTEE, TABLE_REMONTEE,
						CHAMP_ERREUR, 
						 clause
						, vLignes2Update);
			} catch (BaseException bE) {
				RBipManager.logService
						.error(
								"RBipFichier::setDataErreur - vErreur.isEmpty() == false  ",
								bE);
				throw bE;
			}
			setStatut(STATUT_CONTROLE_OK_WARNING, sStatutInfo);
			
		}
		
	}
	
	
	
	
}