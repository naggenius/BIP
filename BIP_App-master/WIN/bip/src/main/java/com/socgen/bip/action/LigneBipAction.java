package com.socgen.bip.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.StringTokenizer;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.Tools;
import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.commun.action.BipAction;
import com.socgen.bip.commun.form.BipForm;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.LigneBipForm;
import com.socgen.bip.form.ProjetForm;
import com.socgen.bip.form.TacheForm;
import com.socgen.bip.user.UserBip;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author MMC - 01/07/2003
 * 
 * Action pour creation ou modification d'une ligne bip pages : bLignebipAd.jsp,
 * mLignebipAd.jsp chemin : ligne bip/gestion/ligne bip pl/sql : lignebip.sql
 */

public class LigneBipAction extends AutomateAction {

	private static String PACK_SELECT = "lignebip.consulter.proc";

	private static String PACK_INSERT = "lignebip.creer.proc";

	private static String PACK_UPDATE = "lignebip.modifier.proc";

	// private static String PACK_GETLIB_CAMO = "libelles.getLibCAMO.proc";
	private static String PACK_GETLIB_CAMO_FACT = "libelles.getLibCAMOFact.proc";

	private static String PACK_GETLIB_CLIENT_MO = "libelles.getLibClientMO.proc";

	private static String PACK_GETLIB_CLIENT_MO_OPER = "libelles.getLibClientMO_Op.proc";
	 
	private static String PACK_VERIF_DPG = "dpg.verifcodsg.proc";
	
	private static String PACK_RECHERCHE_ARBITRE_ACTUEL = "lignebip.recup.arbitre.actuel.proc";
	
	
	private static String PACK_RECHERCHE_REALISE_ANTERIEUR = "lignebip.recup.realise.anterieur.proc";
  

	private static String MESSAGE_INTERDIT_REALISE = "Modification interdite en local - il existe du réalisé sur les années antérieures";
	
	private static String MESSAGE_INTERDIT_ARBITRE = "Modification interdite en local - il existe du budget arbitré sur l'année en cours"; 
	
	private static String ALERTE_INTERDIT_REALISE = "Attention , il existe du réalisé sur les années antérieures";
	
	private static String ALERTE_INTERDIT_ARBITRE = "Attention , il existe de l'arbitré sur l'année en cours"; 

	// FAD PPM 64240 : Récupération du DPCOPI à partir du PID
	private static String PACK_SELECT_DPCOPI_PID = "lignebip.dpcopi.pid.proc";
	// FAD PPM 64240 : Fin

	/**
	 * Recherche code branche d'aprés code direction
	 */
	private static String PACK_GET_CODE_BRANCHE = "lignebip.recup.branche.proc";
	
	/**
	 * Recherche CA préconisés pour un projet et une application donnés
	 */
	private static String PACK_GET_LISTE_CA_PRECONISES = "lignebip.recup.listeca.proc";
	
	private String libdir = null;
	private String libbr = null;
	private String lib_ca_payeur = null;
	
	private static String PROC_RECUPERER_PARAM_APP = "lignebip.recup.paramapp.proc";
	private static String PACK_LISTE_DIR_DBS = "dossierproj.listedirdbs.proc";//PPM 59288
	private static String PACK_DIR_PRIN_DP = "dossierproj.dirprindp.proc";//PPM 59288
	private static String PACK_LISTE_DIR_IMMO = "dossierproj.listedirdpimmo.proc";//FAD PPM 61695

	// Debut HMI PPM 63824
	private static String VERIFIER_MAJ_DP_Proj = "lignebip.verifierMajDpProj.proc";
	// Fin HMI PPM 63824
	
	private static String PROC_HABILITATION_SUIVBASE = "habilitation.suivbase.proc";
	
	// private String nomProc;
	private static String PACK_CHECK_AXEMETIERLIGNE2 = "lignebip.check.ligne2.proc";
	private static String PACK_GUIINITIAL_AXEMETIERLIGNE2=  "lignebip.guiinit.ligne2.proc";
	private static String PACK_UPDATE_PROJ_DPCOPI_LIGNE = "lignebip.update.prdp_ligne2.proc";
	//BIP 29
	public ActionForward mettreAvide(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws IOException{
		String signatureMethode ="LigneAction - mettreAvide";

		return traitAjaxLigne(PACK_UPDATE_PROJ_DPCOPI_LIGNE, signatureMethode, mapping, form, response, hParamProc,request);
	}
	//BIP 29 - verfying the ligne axemetier2
	public ActionForward verifierligneaxemetier2(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws IOException{
		String signatureMethode ="LigneBipAction - verifierligneaxemetier2";
		
		return traitementAjaxLigne(PACK_CHECK_AXEMETIERLIGNE2, signatureMethode, mapping, form, response, hParamProc);
	}
	//BIP 29 , QC 2008 - to initialise the field ligne axemetier 2 using the gui fields
	public ActionForward guiInitialiserligneaxemetier2(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws IOException{
		String signatureMethode ="LigneBipAction - guiInitialiserligneaxemetier2";
		
		return traiteAjaxLigne(PACK_GUIINITIAL_AXEMETIERLIGNE2, signatureMethode, mapping, form, response, hParamProc);
	}
	
	
	/**
	 * Action qui permet de créer une ligne bip
	 */
	protected ActionForward creer(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParams) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		
		
		libdir = null;
		libbr = null;
		lib_ca_payeur = null;

		String signatureMethode = "LigneBipAction -creer( mapping, form , request,  response,  errors )";
		String messageInit=(String) request.getAttribute("messageInit");
		// logService.entry(signatureMethode);;
		logBipUser.entry(signatureMethode);
		// exécution de la procédure PL/SQL
		try {
			// Création d'une nouvelle form
			LigneBipForm bipForm = (LigneBipForm) form;
			// On initialise le codde appli et le dossier projet
			bipForm.setAirt("A0000");
			bipForm.setLib_ca_payeur(null);
			bipForm.setLibdir(null);
			bipForm.setLibbr(null);
			if("SUCCESS".equalsIgnoreCase(messageInit)){
			bipForm.setLigneaxemetier2("000000");
			}
			// Si c'est une ligne hors Grand T1
			if (!"T1".equals(bipForm.getArctype())) {
				bipForm.setDpcode("00000");
				// On initialise aussi hParams pour la liste déroulante
				hParams.put("dpcode", "00000");
			}

			vParamOut = jdbc.getResult(hParams,
					configProc, PACK_SELECT);
			try {
				message = jdbc.recupererResult(vParamOut, "creer");
			} catch (BaseException be) {
				logBipUser.debug("LigneBipAction -creer() --> BaseException :"
						+ be);
				logBipUser.debug("LigneBipAction -creer() --> Exception :"
						+ be.getInitialException().getMessage());
				logService.debug("LigneBipAction -creer() --> BaseException :"
						+ be);
				logService.debug("LigneBipAction -creer() --> Exception :"
						+ be.getInitialException().getMessage());
				// Erreur de lecture du resultSet
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
			
			if (msg) {
				// on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
			
			//PPM 59288 : debut

			ParametreProc paramOut;
			String result = "";			
			
			// Appel de la procedure
			try {
				vParamOut= jdbc.getResult (hParams,configProc, PACK_LISTE_DIR_DBS);
			 	// ----------------------------------------------------------
				for (Enumeration e=vParamOut.elements(); e.hasMoreElements();) {
					paramOut = (ParametreProc) e.nextElement();

					if (paramOut.getNom().equals("message")) {
						if (paramOut.getValeur() != null) {
							message = (String) paramOut.getValeur();
						}
					}
					if (paramOut.getNom().equals("result")) {
						if (paramOut.getValeur() != null && paramOut.getValeur()!="") {
							result = (String) paramOut.getValeur();
							StringTokenizer strtk = new StringTokenizer(result, ",");
							ArrayList<String> l_strtk = new ArrayList<String>();
							while (strtk.hasMoreTokens()){
								String s_strtk = strtk.nextToken();
								l_strtk.add(s_strtk);								
							}	
							bipForm.setListeDirDbs(l_strtk);
							request.getSession().setAttribute("listeDirDbs", l_strtk);
							
							
						}
					}
				}	
			}
			catch (BaseException be) {
				logBipUser.debug(signatureMethode + " --> Exception :"+be.getInitialException().getMessage());
				logService.debug(signatureMethode + " --> BaseException :"+be);
				
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				
				// Erreur de lecture du resultSet
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error"); 
			}
			
			//PPM 59288 : Fin
			//FAD PPM 61695 : debut
			// Appel de la procedure
			try {
				vParamOut= jdbc.getResult (hParams,configProc, PACK_LISTE_DIR_IMMO);
			 	// ----------------------------------------------------------
				for (Enumeration e=vParamOut.elements(); e.hasMoreElements();) {
					paramOut = (ParametreProc) e.nextElement();
					
					if (paramOut.getNom().equals("message")) {
						if (paramOut.getValeur() != null) {
							message = (String) paramOut.getValeur();
						}
					}
					if (paramOut.getNom().equals("result")) {
						if (paramOut.getValeur() != null && paramOut.getValeur()!="") {
							result = (String) paramOut.getValeur();
							StringTokenizer strtk = new StringTokenizer(result, ",");
							ArrayList<String> l_strtk = new ArrayList<String>();
							while (strtk.hasMoreTokens()){
								String s_strtk = strtk.nextToken();
								l_strtk.add(s_strtk);								
							}
							bipForm.setListeDirImmo(l_strtk);
							request.getSession().setAttribute("listeDirImmo", l_strtk);
						}
					}
				}	
			}
			catch (BaseException be) {
				logBipUser.debug(signatureMethode + " --> Exception :"+be.getInitialException().getMessage());
				logService.debug(signatureMethode + " --> BaseException :"+be);
				
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				
				// Erreur de lecture du resultSet
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error"); 
			}
			//FAD PPM 61695 : Fin
			
			
			
			
			
			//FAD PPM 61695 : Fin
		}// try
		catch (BaseException be) {
			logBipUser.debug("LigneBipAction-creer() --> BaseException :" + be);
			logBipUser.debug("LigneBipAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("LigneBipAction-creer() --> BaseException :" + be);
			logService.debug("LigneBipAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			// Erreur d''exécution de la procédure stockée
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
			// this.saveErrors(request,errors);
			 jdbc.closeJDBC(); return mapping.findForward("error");
		}

		// logService.exit(signatureMethode);
		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	}// creer

	/**
	 * Action qui permet de visualiser les données liées à un code BIP pour la
	 * modification et la suppression
	 */
	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParams) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		String messageInit = (String) request.getAttribute("messageInit");
		String crefrmTitle = (String) request.getAttribute("title");
		boolean msg = false;
		ParametreProc paramOut;
				
		String signatureMethode = "LigneBipAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		LigneBipForm bipForm = (LigneBipForm) form;

		// exécution de la procédure PL/SQL
		try {
			 
		
			
			
	
			
			
			
			//--------------- Fiche 656 -------------------------------------------------------
			
			 
			
			
			vParamOut = jdbc.getResult(hParams,
					configProc, PACK_SELECT);

			
			// Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				// récupérer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();
					bipForm.setMsgErreur(message);
				}


				// TD 532 : Recuperer la liste des CA preconises
				if (paramOut.getNom().equals("listecapreconise")) {
					bipForm.setListecapreconise((String) paramOut.getValeur());
				}
				
				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();

					try {
						logService.debug("ResultSet");
						if (rset.next()) {
							bipForm.setPid(rset.getString(1));
							bipForm.setPcle(rset.getString(2));
							bipForm.setPnom(rset.getString(3));
							bipForm.setAstatut(rset.getString(4));
							bipForm.setLibstatut(rset.getString(5));
							bipForm.setTopfer(rset.getString(6));
							bipForm.setAdatestatut(rset.getString(7));
							bipForm.setTypproj(rset.getString(8));
							// On initialise aussi hParams pour la liste
							// déroulante
							hParams.put("typproj", rset.getString(8));
							bipForm.setLibtyp(rset.getString(9));
							bipForm.setArctype(rset.getString(10));
							bipForm.setLibtyp2(rset.getString(11));
							bipForm.setCodpspe(rset.getString(12));
							bipForm.setToptri(rset.getString(13));
							bipForm.setDpcode(rset.getString(14));
							// On initialise aussi hParams pour la liste
							// déroulante
							hParams.put("dpcode", rset.getString(14));
							bipForm.setPdatdebpre(rset.getString(15));
							bipForm.setIcpi(rset.getString(16));
							bipForm.setCodsg(rset.getString(17));
							bipForm.setAirt(rset.getString(18));
							bipForm.setPcpi(rset.getString(19));
							bipForm.setClicode(rset.getString(20));
							bipForm.setClilib(rset.getString(21));
							bipForm.setCodcamo(rset.getString(22));
							bipForm.setLibCodCAMO(rset.getString(23));
							bipForm.setPnmouvra(rset.getString(24));
							bipForm.setMetier(rset.getString(25));
							bipForm.setPobjet(rset.getString(26));
							bipForm.setPzone(rset.getString(27));
							bipForm.setClicode_oper(rset.getString(28));
							bipForm.setClilib_oper(rset.getString(29));
							bipForm.setSous_typo(rset.getString(30));
							hParams.put("sous_typo", rset.getString(30));
							bipForm.setLibSoustype(rset.getString(31));
							bipForm.setCodbr(rset.getString(32));
							bipForm.setFlaglock(rset.getInt(33));
							bipForm.setCodrep(rset.getString(34));
							bipForm.setLibCodrep(rset.getString(35));
							bipForm.setActif(rset.getString(36));
							bipForm.setStatut(rset.getString(37));
							bipForm.setLigneaxemetier1(rset.getString(38));
							bipForm.setLigneaxemetier2(rset.getString(39));
							if("SUCCESS".equalsIgnoreCase(messageInit)){
							bipForm.setLigneaxemetier2("000000");
							}
							if("TITLE".equalsIgnoreCase(crefrmTitle)){
							bipForm.setCreateFromTitle(", à partir d'une autre");
							}
								
							bipForm.setMsgErreur(null);
			
							
							
							//sauvegarde valeurs lues avant entrer page modif
							//car certaines seront interdites en modification et il faudra remettre la 
							//valeur originale

							 bipForm.setCodeAppliAvantModif(bipForm.getAirt()) ; 
							 bipForm.setCodeDPAvantModif(bipForm.getDpcode()) ; 
							 bipForm.setCodeMetierAvantModif(bipForm.getMetier()) ; 
							 /* BIP-201 starting - seding the value before modification */
							 bipForm.setCodePrjAvantModif(bipForm.getIcpi());
							 
							 //HMI PPM 63824
							 request.getSession().setAttribute("icpi_val", bipForm.getIcpi());

						} else
							msg = true;

						// ------------ SI PAS D'ERREURS SURVENUES ---------------------
						 if(bipForm.getMsgErreur()==null){ 
								//----------------------------- FICHE 656 -----------------------------------------
								//------------ RECHERCHE ARBITRE ACTUEL DE LA LIGNE BIP ------------------------------------------- 
								vParamOut = jdbc.getResult(hParams, configProc, PACK_RECHERCHE_ARBITRE_ACTUEL);  
								for (Enumeration enum1 = vParamOut.elements(); enum1.hasMoreElements();) {
									paramOut = (ParametreProc) enum1.nextElement();
									if (paramOut.getNom().equals("arbitreactuel")) {
										bipForm.setArbitreactuel((String) paramOut.getValeur());
									}
								}								
								//------------ RECHERCHE REALISE ANTERIEUR DE LA LIGNE BIP -------------------------------------------
								vParamOut = jdbc.getResult(hParams, configProc, PACK_RECHERCHE_REALISE_ANTERIEUR); 
								for (Enumeration enum2 = vParamOut.elements(); enum2.hasMoreElements();) {
									paramOut = (ParametreProc) enum2.nextElement();
									if (paramOut.getNom().equals("realiseanterieur")) {
										bipForm.setRealiseanterieur((String) paramOut.getValeur());								 
									}
								}		
								
								// --------- Via les données lues ( arbitreactuel et realiseanterieur) -------------------------------
								// --------- met à jour les variables servant à alerter et interdire lors de modification des champs : 
								// --------- Dossier Projet , Métier , Code Application
								
								
																
								logBipUser.entry("----------> real antérieur : " + bipForm.getRealiseanterieur() + " arbitre actuel : " + bipForm.getArbitreactuel());
								
								
								bipForm =  blocageModifications(bipForm) ;
								
								logBipUser.entry("----------> blocage ME : " + bipForm.getMessageMeBlocage() + "  Alerte ADMIN : " + bipForm.getMessageAdminBlocage()  );
																		
								//
								
								//FICHE TD 678
								// on intialise les variable libdir, libbr, lib_ca_payeur du form afin que l'on puisse tester en cas de modification de la
								// ligne bip si le libelle du ca_payeur est différent de celui de la diraction ou branche du clien _mo
								hParams.put("clicode", bipForm.getClicode());
								vParamOut = jdbc.getResult(
										hParams, configProc, PACK_GET_CODE_BRANCHE);
								bipForm.setCodbr((String) (((ParametreProc) vParamOut
										.elementAt(0)).getValeur()));
								bipForm.setMsgErreur((String) ((ParametreProc) vParamOut
										.elementAt(3)).getValeur());
								bipForm.setLibdir((String) (((ParametreProc) vParamOut
										.elementAt(2)).getValeur()));
								bipForm.setLibbr((String) (((ParametreProc) vParamOut
										.elementAt(1)).getValeur()));
																
								bipForm.setLib_ca_payeur(bipForm.getLibCodCAMO().substring(0,4));
								lib_ca_payeur = bipForm.getLib_ca_payeur();
								libbr = bipForm.getLibbr();
								libdir = bipForm.getLibdir();
								
								
						 }
						 
						
					}// try
					catch (SQLException sqle) {
						logService
								.debug("LigneBipAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("LigneBipAction-consulter() --> SQLException :"
										+ sqle);
						// Erreur de lecture du resultSet
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11217"));
						// this.saveErrors(request,errors);
						 jdbc.closeJDBC(); return mapping.findForward("error");
					} finally {
						try {
							if (rset != null)
								rset.close();
						} catch (SQLException sqle) {
							logBipUser
									.debug("LigneBipAction-consulter() --> SQLException-rset.close() :"
											+ sqle);
							// Erreur de lecture du resultSet
							errors.add(ActionErrors.GLOBAL_ERROR,
									new ActionError("11217"));
							 jdbc.closeJDBC(); return mapping.findForward("error");
						}

					}
				}// if
			}// for
			if (msg) {
				// le code Personne n'existe pas, on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
			
			//PPM 59288 : debut
			String result = "";			
			
			// Appel de la procedure
			try {
				vParamOut= jdbc.getResult (hParams,configProc, PACK_LISTE_DIR_DBS);
			 	// ----------------------------------------------------------
				for (Enumeration e=vParamOut.elements(); e.hasMoreElements();) {
					paramOut = (ParametreProc) e.nextElement();

					if (paramOut.getNom().equals("message")) {
						if (paramOut.getValeur() != null) {
							message = (String) paramOut.getValeur();
						}
					}
					if (paramOut.getNom().equals("result")) {
						if (paramOut.getValeur() != null && paramOut.getValeur()!="") {
							result = (String) paramOut.getValeur();
							StringTokenizer strtk = new StringTokenizer(result, ",");
							ArrayList<String> l_strtk = new ArrayList<String>();
							while (strtk.hasMoreTokens()){
								String s_strtk = strtk.nextToken();
								l_strtk.add(s_strtk);								
							}	
							bipForm.setListeDirDbs(l_strtk);
							request.getSession().setAttribute("listeDirDbs", l_strtk);
							
							
						}
					}
				}	
			}
			catch (BaseException be) {
				logBipUser.debug(signatureMethode + " --> Exception :"+be.getInitialException().getMessage());
				logService.debug(signatureMethode + " --> BaseException :"+be);
				
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				
				// Erreur de lecture du resultSet
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error"); 
			}
			
			//PPM 59288 : Fin
			//FAD PPM 61695 : debut
			// Appel de la procedure
			try {
				vParamOut= jdbc.getResult (hParams,configProc, PACK_LISTE_DIR_IMMO);
			 	// ----------------------------------------------------------
				for (Enumeration e=vParamOut.elements(); e.hasMoreElements();) {
					paramOut = (ParametreProc) e.nextElement();
					
					if (paramOut.getNom().equals("message")) {
						if (paramOut.getValeur() != null) {
							message = (String) paramOut.getValeur();
						}
					}
					if (paramOut.getNom().equals("result")) {
						if (paramOut.getValeur() != null && paramOut.getValeur()!="") {
							result = (String) paramOut.getValeur();
							StringTokenizer strtk = new StringTokenizer(result, ",");
							ArrayList<String> l_strtk = new ArrayList<String>();
							while (strtk.hasMoreTokens()){
								String s_strtk = strtk.nextToken();
								l_strtk.add(s_strtk);								
							}
							bipForm.setListeDirImmo(l_strtk);
							request.getSession().setAttribute("listeDirImmo", l_strtk);
						}
					}
				}	
			}
			catch (BaseException be) {
				logBipUser.debug(signatureMethode + " --> Exception :"+be.getInitialException().getMessage());
				logService.debug(signatureMethode + " --> BaseException :"+be);
				
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				
				// Erreur de lecture du resultSet
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error"); 
			}
			
			//FAD PPM 61695 : Fin
		}// try
		catch (BaseException be) {
			logBipUser.debug("LigneBipAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("LigneBipAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("LigneBipAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("LigneBipAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((LigneBipForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");

			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}

		if (("OUI".equals(bipForm.getDuplic()))) {
			bipForm.setTitrePage("Créer");
			// bipForm.setPnom("");
			// bipForm.setPdatdebpre("");
			bipForm.setPobjet("");

		}

		// FAD PPM 64240 : Récupération du DPCOPI à partir du PID
		try {
			vParamOut = jdbc.getResult(
					hParams, configProc, PACK_SELECT_DPCOPI_PID);
			bipForm.setDpcopi((String) (((ParametreProc) vParamOut
					.elementAt(0)).getValeur()));
			
		} catch (BaseException e) {
			// TODO Auto-generated catch block
			logBipUser.error(e);
			BipAction.logBipUser.error("Error. Check the code", e);
		}
		// FAD PPM 64240 : Fin
		
		logBipUser.exit(signatureMethode);
		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	}// consulter

	protected ActionForward refresh(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		LigneBipForm bipForm = (LigneBipForm) form;
		// Intitulé à charger
		String focus = bipForm.getFocus();
	

		Vector vParamOut = new Vector();

		try {

			if ("clicode".equals(focus)) {
				
				libdir = null;
				libbr = null;
				vParamOut = jdbc.getResult(
						hParamProc, configProc, PACK_GETLIB_CLIENT_MO);
				bipForm.setClilib((String) ((ParametreProc) vParamOut
						.elementAt(0)).getValeur());
				bipForm.setMsgErreur((String) ((ParametreProc) vParamOut
						.elementAt(1)).getValeur());
								
				/**
				 * Recupere le Code Branche d'aprés le code Direction Client
				 */

				vParamOut = jdbc.getResult(
						hParamProc, configProc, PACK_GET_CODE_BRANCHE);
				bipForm.setCodbr((String) (((ParametreProc) vParamOut
						.elementAt(0)).getValeur()));
				bipForm.setMsgErreur((String) ((ParametreProc) vParamOut
						.elementAt(3)).getValeur());
				bipForm.setLibdir((String) (((ParametreProc) vParamOut
						.elementAt(2)).getValeur()));
				bipForm.setLibbr((String) (((ParametreProc) vParamOut
						.elementAt(1)).getValeur()));
				
				libdir = bipForm.getLibdir();
				libbr = bipForm.getLibbr();
				
				
				if ((libdir != null) && (libbr != null) && (lib_ca_payeur != null))
				{
					if ((!libdir.equals(lib_ca_payeur)) && (!libbr.equals(lib_ca_payeur)))
					{
						
						bipForm.setAffichemessage("oui");
					}
					else
						bipForm.setAffichemessage("non");
				}
				else
						bipForm.setAffichemessage("non");
						
				
										
				// MAJ du Focus
				if (bipForm.getMsgErreur() == null)
					bipForm.setFocus("clicode_oper");
			}

			else if ("clicode_oper".equals(focus)) {
				vParamOut = jdbc.getResult(
						hParamProc, configProc, PACK_GETLIB_CLIENT_MO_OPER);
				bipForm.setClilib_oper((String) ((ParametreProc) vParamOut
						.elementAt(0)).getValeur());
				bipForm.setMsgErreur((String) ((ParametreProc) vParamOut
						.elementAt(1)).getValeur());
				bipForm.setAffichemessage("non");
								// MAJ du Focus
				if (bipForm.getMsgErreur() == null)
					bipForm.setFocus("codcamo");
			} 
			
			else if ("codcamo".equals(focus)) {
				lib_ca_payeur = null;
				vParamOut = jdbc.getResult(
						hParamProc, configProc, PACK_GETLIB_CAMO_FACT);
				bipForm.setLibCodCAMO((String) ((ParametreProc) vParamOut
						.elementAt(0)).getValeur());
				bipForm.setMsgErreur((String) ((ParametreProc) vParamOut
						.elementAt(1)).getValeur());
				
				
				if (bipForm.getLibCodCAMO() != null)
				{
				bipForm.setLib_ca_payeur(bipForm.getLibCodCAMO().substring(0,4));
				lib_ca_payeur = bipForm.getLib_ca_payeur();
				}
				
				
				
				if ((libdir != null) && (libbr != null) && (lib_ca_payeur != null))
				{
					if ((!libdir.equals(lib_ca_payeur)) && (!libbr.equals(lib_ca_payeur)))
					{
						
						bipForm.setAffichemessage("oui");
					}
					else
					{
						bipForm.setAffichemessage("non");
					}
				}
				else
					bipForm.setAffichemessage("non");
				
				
				// MAJ du Focus
				if (bipForm.getMsgErreur() == null)
					bipForm.setFocus("pnmouvra");
			}else if ("codsg".equals(focus)) {
				vParamOut = jdbc.getResult(
						hParamProc, configProc, PACK_VERIF_DPG);
				bipForm.setMsgErreur((String) ((ParametreProc) vParamOut
						.elementAt(0)).getValeur());
				if (bipForm.getMsgErreur() == null || "".equals(bipForm.getMsgErreur())){
					bipForm.setFocus("pcpi");
				}else{
					bipForm.setCodsg("");
				}
			}
			// TD 532
			/**
			 * Recupere la liste des CA préconisés
			 */
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_GET_LISTE_CA_PRECONISES);
			bipForm.setListecapreconise((String)((ParametreProc) vParamOut
					.elementAt(0)).getValeur());
			
			// TD 532
			/*else if ("icpi".equals(focus)) {
				vParamOut = jdbc.getResult(
						hParamProc, configProc, PACK_GET_LISTE_CA_PRECONISES);
				bipForm.setListecapreconise((String)((ParametreProc) vParamOut
						.elementAt(0)).getValeur());
				
				// MAJ du Focus
				if (bipForm.getMsgErreur() == null)
					bipForm.setFocus("codsg");
			} else if ("airt".equals(focus)) {
				vParamOut = jdbc.getResult(
						hParamProc, configProc, PACK_GET_LISTE_CA_PRECONISES);
				bipForm.setListecapreconise((String)((ParametreProc) vParamOut
						.elementAt(0)).getValeur());
				
				// MAJ du Focus
				if (bipForm.getMsgErreur() == null)
					bipForm.setFocus("codsg");
			} // Fin TD 532
		*/
		
		//PPM HMI 63824 
			
			if (bipForm.isUpdate_controle()){
				
				bipForm.setIcpi((String) request.getSession().getAttribute("icpi_val"));
				//ABN - QC 1891
				//bipForm.setDpcopi((String) request.getSession().getAttribute("dpcopi_val"));
				bipForm.setUpdate_controle(false);
			}
			
			//FIN PPM 63824
			
		} catch (BaseException be) {
			logBipUser.debug("ClientAction-refresh() --> BaseException :" + be,
					be);
			logBipUser.debug("ClientAction-refresh() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("ClientAction-refresh() --> BaseException :" + be,
					be);
			logService.debug("ClientAction-refresh() --> Exception :"
					+ be.getInitialException().getMessage());
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));

			// this.saveErrors(request,errors);
			 jdbc.closeJDBC(); return mapping.findForward("error");
		}
		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	}

	protected String recupererCle(String mode) {
		String cle = null;
		if (mode.equals("insert")) {
			cle = PACK_INSERT;
		} else if (mode.equals("update")) {
			cle = PACK_UPDATE;
		}
		  return cle;
	}
	
	/**
	 * Voir Fiche 656 
	 * 
	 * @param bipForm
	 * @return
	 */
	protected LigneBipForm blocageModifications(LigneBipForm bipForm) {
		
		bipForm.setMessageMeBlocage(null); 
 		bipForm.setMessageAdminBlocage(null) ;  		
 		bipForm.setArbitreActuelNotNullDiffZero(false) ;
 		bipForm.setRealiseAnterieurNotNullDiffZero(false) ; 
 		
 	
 		
	    //Cas 1 :  si la ligne a du réalisé sur les années antérieures 
	   if( bipForm.getRealiseanterieur()!= null ) {
		     bipForm.setRealiseanterieur(bipForm.getRealiseanterieur().replace(',','.')) ;
		     logBipUser.entry("----------> real antérieur : " + bipForm.getRealiseanterieur() );
		     if( Float.parseFloat(bipForm.getRealiseanterieur() ) > 0 ) {
		    	    logBipUser.entry("----------> real antérieur > 0 ");
					bipForm.setMessageMeBlocage(MESSAGE_INTERDIT_REALISE); 
			     	bipForm.setMessageAdminBlocage(ALERTE_INTERDIT_REALISE);  
			     	bipForm.setRealiseAnterieurNotNullDiffZero(true) ; 
		     }			 		
		} 	   
		//Cas 2 : si la ligne a de l'arbitré non NULL et > 0 pour l'année en cours
	   
		if( bipForm.isRealiseAnterieurNotNullDiffZero()== false &&  bipForm.getArbitreactuel()!= null ) {					
			 bipForm.setArbitreactuel(bipForm.getArbitreactuel().replace(',','.')) ; 
			 logBipUser.entry("----------> real arbitreActuel : " + bipForm.getRealiseanterieur() );
			 if( Float.parseFloat(bipForm.getArbitreactuel() ) > 0 ) {	
				    logBipUser.entry("----------> arbitré actuel > 0 ");
					bipForm.setMessageMeBlocage(MESSAGE_INTERDIT_ARBITRE);
			     	bipForm.setMessageAdminBlocage(ALERTE_INTERDIT_ARBITRE); 
		     		bipForm.setArbitreActuelNotNullDiffZero(true) ; 
			 }
		}		 
		return bipForm ;		
	}
	/**
	 * PPM 59288
	 * Rècupère le code de la direction Bip principalement concernée par un code dosssier projet
	 * @param form
	 * @param hParamProc
	 * @return
	 */
	public ActionForward dirPrinDp(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws IOException{
		String signatureMethode ="DossierprojAction - dirPrinDp";

		return traitAjax(PACK_DIR_PRIN_DP, signatureMethode, mapping, form, response, hParamProc);
	}
	private ActionForward traitAjax(String cleProc, String signatureMethode, ActionMapping mapping, ActionForm form, HttpServletResponse response, Hashtable hParamProc) throws IOException {
		logBipUser.entry(signatureMethode);
		
		BipForm bipForm = (BipForm) form;
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut;
		ParametreProc paramOut;
		String message = "";
		String result = "";
		
		// Appel de la procï¿½dure
		try {
			vParamOut= jdbc.getResult (hParamProc,configProc, cleProc);
		 	// ----------------------------------------------------------
			for (Enumeration e=vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				if (paramOut.getNom().equals("message")) {
					if (paramOut.getValeur() != null) {
						message = (String) paramOut.getValeur();
					}
				}
				if (paramOut.getNom().equals("result")) {
					if (paramOut.getValeur() != null && paramOut.getValeur()!="") {
						result = (String) paramOut.getValeur();
					}
				}
			}	
		}
		catch (BaseException be) {
			logBipUser.debug(signatureMethode + " --> Exception :"+be.getInitialException().getMessage());
			logService.debug(signatureMethode + " --> BaseException :"+be);
			
			message = BipException.getMessageFocus(
					BipException.getMessageOracle(be.getInitialException()
							.getMessage()), form);
			
			if (!be.getInitialException().getClass().getName().equals(
			"java.sql.SQLException")) {
				// Erreur d'exï¿½cution
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
			} 
		}	
		
		jdbc.closeJDBC();
		
		// Ecriture du result dans la response
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		out.println(new String(result.getBytes("utf8"), "iso-8859-1"));
		out.flush();
		
		logBipUser.exit(signatureMethode);
		
		return PAS_DE_FORWARD;
	}
	
	public ActionForward recupParamApp(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws IOException{
		String signatureMethode ="LigneBipAction - recupParamApp";
		
		return traitementAjax(PROC_RECUPERER_PARAM_APP, signatureMethode, mapping, form, response, hParamProc);
	}
	
	//US BIP 29
	private ActionForward traitAjaxLigne(String cleProc, String signatureMethode, ActionMapping mapping, ActionForm form, HttpServletResponse response, Hashtable hParamProc, HttpServletRequest request) throws IOException {
		logBipUser.entry(signatureMethode);
		
		BipForm bipForm = (BipForm) form;
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut;
		ParametreProc paramOut;
		String message = "";
		
		// Appel de la procï¿½dure
		try {
			String userid = ((UserBip)request.getSession().getAttribute("UserBip")).getIdUser();
			vParamOut= jdbc.getResult (hParamProc,configProc, cleProc);
		 	// ----------------------------------------------------------
			for (Enumeration e=vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				if (paramOut.getNom().equals("message")) {
					if (paramOut.getValeur() != null) {
						message = (String) paramOut.getValeur();
					}
				
				}
			}	
		}
		catch (BaseException be) {
			logBipUser.debug(signatureMethode + " --> Exception :"+be.getInitialException().getMessage());
			logService.debug(signatureMethode + " --> BaseException :"+be);
			
			message = BipException.getMessageFocus(
					BipException.getMessageOracle(be.getInitialException()
							.getMessage()), form);
			
			if (!be.getInitialException().getClass().getName().equals(
			"java.sql.SQLException")) {
				// Erreur d'exï¿½cution
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
			} 
		}	
		
		jdbc.closeJDBC();
		
		// Ecriture du message de retour dans la response
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
		out.flush();
		
		logBipUser.exit(signatureMethode);
		
		return PAS_DE_FORWARD;
	}
	
	//US BIP 29
	
	private ActionForward traitementAjaxLigne(String cleProc, String signatureMethode, ActionMapping mapping, ActionForm form, HttpServletResponse response, Hashtable hParamProc) throws IOException {
		logBipUser.entry(signatureMethode);
		
		BipForm bipForm = (BipForm) form;
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut;
		ParametreProc paramOut;
		String message = "";
		String type = "";
		String param_id = "";
		String result = "";
		
		// Appel de la procï¿½dure
		try {
			vParamOut= jdbc.getResult (hParamProc,configProc, cleProc);
		 	// ----------------------------------------------------------
			for (Enumeration e=vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				if (paramOut.getNom().equals("message")) {
					if (paramOut.getValeur() != null) {
						message = (String) paramOut.getValeur();
					}
				}
				if (paramOut.getNom().equals("type")) {
					if (paramOut.getValeur() != null) {
						type = (String) paramOut.getValeur();
					}
				}
				if (paramOut.getNom().equals("param_id")) {
					if (paramOut.getValeur() != null) {
						param_id = (String) paramOut.getValeur();
					}
				}
			}	
		}
		catch (BaseException be) {
			logBipUser.debug(signatureMethode + " --> Exception :"+be.getInitialException().getMessage());
			logService.debug(signatureMethode + " --> BaseException :"+be);
			
			message = BipException.getMessageFocus(
					BipException.getMessageOracle(be.getInitialException()
							.getMessage()), form);
			
			if (!be.getInitialException().getClass().getName().equals(
			"java.sql.SQLException")) {
				// Erreur d'exï¿½cution
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
			} 
		}	
		
		jdbc.closeJDBC();
		
		// Ecriture du message de retour dans la response
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		result = type.concat(";").concat(param_id).concat(";").concat(message);
		out.print(new String(result.getBytes("utf8"), "iso-8859-1"));
		out.flush();
		
		logBipUser.exit(signatureMethode);
		
		return PAS_DE_FORWARD;
	}
	
	//BIP 29 ,QC 2008
	private ActionForward traiteAjaxLigne(String cleProc, String signatureMethode, ActionMapping mapping, ActionForm form, HttpServletResponse response, Hashtable hParamProc) throws IOException {
		logBipUser.entry(signatureMethode);
		
		BipForm bipForm = (BipForm) form;
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut;
		ParametreProc paramOut;
		String message = "";
		String result = "";
		
		// Appel de la procï¿½dure
		try {
			vParamOut= jdbc.getResult (hParamProc,configProc, cleProc);
		 	// ----------------------------------------------------------
			for (Enumeration e=vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				if (paramOut.getNom().equals("message")) {
					if (paramOut.getValeur() != null) {
						message = (String) paramOut.getValeur();
					}
				}
				
			}	
		}
		catch (BaseException be) {
			logBipUser.debug(signatureMethode + " --> Exception :"+be.getInitialException().getMessage());
			logService.debug(signatureMethode + " --> BaseException :"+be);
			
			message = BipException.getMessageFocus(
					BipException.getMessageOracle(be.getInitialException()
							.getMessage()), form);
			
			if (!be.getInitialException().getClass().getName().equals(
			"java.sql.SQLException")) {
				// Erreur d'exï¿½cution
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
			} 
		}	
		
		jdbc.closeJDBC();
		
		// Ecriture du message de retour dans la response
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		result = message;
		out.print(new String(result.getBytes("utf8"), "iso-8859-1"));
		out.flush();
		
		logBipUser.exit(signatureMethode);
		
		return PAS_DE_FORWARD;
	}
	
	private ActionForward traitementAjax(String cleProc, String signatureMethode, ActionMapping mapping, ActionForm form, HttpServletResponse response, Hashtable hParamProc) throws IOException {
		logBipUser.entry(signatureMethode);
		
		BipForm bipForm = (BipForm) form;
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut;
		ParametreProc paramOut;
		String message = "";
		
		// Appel de la procï¿½dure
		try {
			vParamOut= jdbc.getResult (hParamProc,configProc, cleProc);
		 	// ----------------------------------------------------------
			for (Enumeration e=vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				if (paramOut.getNom().equals("message")) {
					if (paramOut.getValeur() != null) {
						message = (String) paramOut.getValeur();
					}
				}
			}	
		}
		catch (BaseException be) {
			logBipUser.debug(signatureMethode + " --> Exception :"+be.getInitialException().getMessage());
			logService.debug(signatureMethode + " --> BaseException :"+be);
			
			message = BipException.getMessageFocus(
					BipException.getMessageOracle(be.getInitialException()
							.getMessage()), form);
			
			if (!be.getInitialException().getClass().getName().equals(
			"java.sql.SQLException")) {
				// Erreur d'exï¿½cution
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
			} 
		}	
		
		jdbc.closeJDBC();
		
		// Ecriture du message de retour dans la response
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
		out.flush();
		
		logBipUser.exit(signatureMethode);
		
		return PAS_DE_FORWARD;
	}
	
	// HMI : PPM 63824
	
	
	public ActionForward verifierMajDpProj(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws IOException{
		String signatureMethode ="LigneBipAction - verifierMajDpProj";
		
		return traitementAjaxe(VERIFIER_MAJ_DP_Proj, signatureMethode, mapping, form, response, hParamProc);
	}
	
	private ActionForward traitementAjaxe(String cleProc, String signatureMethode, ActionMapping mapping, ActionForm form, HttpServletResponse response, Hashtable hParamProc) throws IOException {
		logBipUser.entry(signatureMethode);
		
		BipForm bipForm = (BipForm) form;
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut;
		ParametreProc paramOut;
		String message = "";
		String codeproj = "";
		String result = "";
		// Appel de la procï¿½dure
		try {
			vParamOut= jdbc.getResult (hParamProc,configProc, cleProc);
		 	// ----------------------------------------------------------
			for (Enumeration e=vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				if (paramOut.getNom().equals("message")) {
					if (paramOut.getValeur() != null) {
						message = (String) paramOut.getValeur();
					}
				}
				
				if (paramOut.getNom().equals("codeproj")) {
					if (paramOut.getValeur() != null) {
						codeproj = (String) paramOut.getValeur();
					}
				}
			}	
		}
		catch (BaseException be) {
			logBipUser.debug(signatureMethode + " --> Exception :"+be.getInitialException().getMessage());
			logService.debug(signatureMethode + " --> BaseException :"+be);
			
			message = BipException.getMessageFocus(
					BipException.getMessageOracle(be.getInitialException()
							.getMessage()), form);
			
			if (!be.getInitialException().getClass().getName().equals(
			"java.sql.SQLException")) {
				// Erreur d'exï¿½cution
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
			} 
		}	
		
		jdbc.closeJDBC();
		
		// Ecriture du message de retour dans la response
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		result = message.concat(";").concat(codeproj);
		out.println(new String(result.getBytes("utf8"), "iso-8859-1"));
		
		
		out.flush();
		
		logBipUser.exit(signatureMethode);
		
	
		return PAS_DE_FORWARD;
	}
	
	
	public ActionForward recupHabilitationSuivbase(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws IOException{
		String signatureMethode ="ReportAction - recupHabilitationSuivbase";
		
		return traitementAjaxeHabilitationSuivbase(PROC_HABILITATION_SUIVBASE, signatureMethode, mapping, form, response, hParamProc);
	}
	
	private ActionForward traitementAjaxeHabilitationSuivbase(String cleProc, String signatureMethode, ActionMapping mapping, ActionForm form, HttpServletResponse response, Hashtable hParamProc) throws IOException {
		logBipUser.entry(signatureMethode);
		
		BipForm bipForm = (BipForm) form;
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut;
		ParametreProc paramOut;
		String message = "";
		String perim = "";
		String result = "";
		// Appel de la procï¿½dure
		try {
			vParamOut= jdbc.getResult (hParamProc,configProc, cleProc);
		 	// ----------------------------------------------------------
			for (Enumeration e=vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				if (paramOut.getNom().equals("message")) {
					if (paramOut.getValeur() != null) {
						message = (String) paramOut.getValeur();
					}
				}
				
				if (paramOut.getNom().equals("perim")) {
					if (paramOut.getValeur() != null) {
						perim = (String) paramOut.getValeur();
					}
				}
			}	
		}
		catch (BaseException be) {
			logBipUser.debug(signatureMethode + " --> Exception :"+be.getInitialException().getMessage());
			logService.debug(signatureMethode + " --> BaseException :"+be);
			
			message = BipException.getMessageFocus(
					BipException.getMessageOracle(be.getInitialException()
							.getMessage()), form);
			
			if (!be.getInitialException().getClass().getName().equals(
			"java.sql.SQLException")) {
				// Erreur d'exï¿½cution
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
			} 
		}	
		
		jdbc.closeJDBC();
		
		// Ecriture du message de retour dans la response
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		result = message.concat(";").concat(perim);
		out.println(new String(result.getBytes("utf8"), "iso-8859-1"));
		
		
		out.flush();
		
		logBipUser.exit(signatureMethode);
		
	
		return PAS_DE_FORWARD;
	}
	
	
}
