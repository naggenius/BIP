package com.socgen.bip.action;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.FactureForm;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author MMC - 31/07/2003
 * 
 * Facture chemin : Ordonnancemement / Factures / Gestion /Facture pages :
 * bFactureOr.jsp pl/sql : facture.sql
 */

public class FactureAction extends AutomateAction {

	private static String PACK_SELECT = "facture.consulter.proc";
	
	//YNI FDT 784
	private static String PACK_SELECT_EXPENSE = "facture.consulter.proc.expense";
	//FIN YNI FDT 784

	private static String PACK_INSERT = "facture.creer.proc";

	private static String PACK_UPDATE = "facture.modifier.proc";

	private static String PACK_DELETE = "facture.supprimer.proc";

	private static String PACK_SELECT_CONT = "factureContrat.consulter.proc";

	private String nomProc;
	
	 

	/**
	 * Action qui permet la création
	 */
	protected ActionForward creer(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		// Récupérer le mode
		String sTest = ((FactureForm) form).getTest();

		String signatureMethode = "FactureAction -creer( mapping, form , request,  response,  errors )";

		// logService.entry(signatureMethode);;
		logBipUser.entry(signatureMethode);
		logBipUser
				.debug("fmemory start : " + Runtime.getRuntime().freeMemory());
		// exécution de la procédure PL/SQL
		try {
			if (sTest.equals("cont")) {
				vParamOut = jdbc.getResult(
						hParamProc, configProc, PACK_SELECT_CONT);
			} else
				vParamOut = jdbc.getResult(
						hParamProc, configProc, PACK_SELECT);

			try {
				logBipUser.debug("cont : " + sTest);
				message = jdbc.recupererResult(vParamOut, "creer");
				// récupérer les résultats
				for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
					ParametreProc paramOut = (ParametreProc) e.nextElement();
					logBipUser.debug("element boucle : " + paramOut.getNom());	
					// récupérer
					if (paramOut.getNom().equals("socfactout")) {
						String sSocfactout = (String) paramOut.getValeur();
						((FactureForm) form).setSocfact(sSocfactout.trim());
					}// if
					// récupérer
					if (paramOut.getNom().equals("soclibout")) {

						String sSoclibout = (String) paramOut.getValeur();

						((FactureForm) form).setSoclib(sSoclibout.trim());
					}// if
					// récupérer
					if (paramOut.getNom().equals("numcontout")) {
						String sNumcontout = (String) paramOut.getValeur();
						if (sNumcontout != null)
							sNumcontout = sNumcontout.trim();

						((FactureForm) form).setNumcont(sNumcontout);
					}// if
					// récupérer
					if (paramOut.getNom().equals("cavout")) {
						String sCavout = (String) paramOut.getValeur();

						((FactureForm) form).setCav(sCavout);
					}// if
					// récupérer
					if (paramOut.getNom().equals("numfactout")) {
						String sNumfactout = (String) paramOut.getValeur();
						((FactureForm) form).setNumfact(sNumfactout.trim());
					}// if

					// récupérer
					if (paramOut.getNom().equals("codsgout")) {
						String sCodsgout = (String) paramOut.getValeur();
						logService.debug("Codsgout :" + sCodsgout);

						((FactureForm) form).setFdeppole(sCodsgout);
						((FactureForm) form).setCodsg(sCodsgout);
					}// if
					// récupérer
					if (paramOut.getNom().equals("comcodeout")) {
						String sComcodeout = (String) paramOut.getValeur();
						logService.debug("Comcodeout :" + sComcodeout);
						((FactureForm) form).setFcodcompta(sComcodeout);
						((FactureForm) form).setComcode(sComcodeout);
					}// if
					if (paramOut.getNom().equals("choixfscout")) {
						String sChoixfscout = (String) paramOut.getValeur();
						logService.debug("choixfscout :" + sChoixfscout);
						((FactureForm) form).setChoixfsc(sChoixfscout);
					}// if
					if (paramOut.getNom().equals("ftvaout")) {
						String sFtvaout = (String) paramOut.getValeur();
						logService.debug("Ftvaout :" + sFtvaout);
						((FactureForm) form).setFtva(sFtvaout);
					}
					if (paramOut.getNom().equals("msg_info")) {
						String sMsg_info = (String) paramOut.getValeur();
						logService.debug("Msg_info :" + sMsg_info);
						((FactureForm) form).setMsg_info(sMsg_info);
					}
					if (paramOut.getNom().equals("siren")) {
						String sSiren = (String) paramOut.getValeur();
						logService.debug("Siren :" + sSiren);
						((FactureForm) form).setSiren(sSiren);
					}
					if (paramOut.getNom().equals("fstatut1")) {
						String sFstatut1 = (String) paramOut.getValeur();
						logService.debug("Statut CS1 :" + sFstatut1 );
						((FactureForm) form).setFstatut1(sFstatut1 );
						logBipUser.debug("statut1 : " + ((FactureForm) form).getFstatut1());	
					}

				}// for

			} catch (BaseException be) {
				logBipUser.debug("FactureAction -creer() --> BaseException :"
						+ be);
				logBipUser.debug("FactureAction -creer() --> Exception :"
						+ be.getInitialException().getMessage());
				logService.debug("FactureAction -creer() --> BaseException :"
						+ be);
				logService.debug("FactureAction -creer() --> Exception :"
						+ be.getInitialException().getMessage());
				// Erreur de lecture du resultSet
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
			if (!message.equals("")) {
				// Entité déjà existante, on récupère le message
				((FactureForm) form).setMsgErreur(message);
				logBipUser.debug("message d'erreur:" + message);
				logBipUser.exit(signatureMethode);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}

		}// try
		catch (BaseException be) {
			logBipUser.debug("FactureAction-creer() --> BaseException :" + be);
			logBipUser.debug("FactureAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("FactureAction-creer() --> BaseException :" + be);
			logService.debug("FactureAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((FactureForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}// catch

		// logService.exit(signatureMethode);
		// force le garbage collector
		//Tools.forceFullGarbageCollection();
		logBipUser.debug("fmemory end : " + Runtime.getRuntime().freeMemory());
		logBipUser.exit(signatureMethode);
		if (sTest.equals("cont")) {
			 jdbc.closeJDBC(); return mapping.findForward("ecran");
		} else
			 jdbc.closeJDBC(); return mapping.findForward("contrats");
	}// creer

	/**
	 * Action qui permet de visualiser les données liées à un code Facture pour
	 * la modification et la suppression
	 */
	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = "FactureAction-consulter(paramProc, mapping, form , request,  response,  errors )";
		//logBipUser.debug("!!!!!!!!!!!!!<<<<<<<<<< yassine : request : >>>>>>>>>>!!!!!!!!!!" + request.getParameterNames().toString());
		String sParameterName;
		String sParameterValue;
		Hashtable hParams = new Hashtable();
				
		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		FactureForm bipForm = (FactureForm) form;
		logBipUser
				.debug("fmemory start : " + Runtime.getRuntime().freeMemory());

		// exécution de la procédure PL/SQL
		try {
			
			if(StringUtils.isEmpty(bipForm.getNumexpense())){

			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT);
			}else{
				vParamOut = jdbc.getResult(
						hParamProc, configProc, PACK_SELECT_EXPENSE);
			}

			// Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				// récupérer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();

				}
				if (paramOut.getNom().equals("codsgout")) {
					String sCodsgout = (String) paramOut.getValeur();
					logService.debug("Codsgout :" + sCodsgout);

					((FactureForm) form).setCodsg(sCodsgout);
				}// if
				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();

					try {
						logService.debug("ResultSet");
						if (rset.next()) {

							bipForm.setSoclib(rset.getString(1).trim());
							bipForm.setSocfact(rset.getString(2).trim());	
							bipForm.setNumfact(rset.getString(3).trim());
							bipForm.setTypfact(rset.getString(4));
							bipForm.setDatfact(rset.getString(5));
							bipForm.setFmoiacompta(rset.getString(6));
							bipForm.setFmontht(rset.getString(7));
							bipForm.setFstatut1(rset.getString(8));
							bipForm.setFlaglock(rset.getString(9));
							bipForm.setSoccont(rset.getString(10).trim());
							bipForm.setCav(rset.getString(11));
							bipForm.setNumcont(rset.getString(12).trim());
							bipForm.setFenrcompta(rset.getString(13));
							bipForm.setFaccsec(rset.getString(14));
							bipForm.setFregcompta(rset.getString(15));
							bipForm.setDate_reception(rset.getString(16));
							bipForm.setFenvsec(rset.getString(17));
							bipForm.setFcodcompta(rset.getString(18));
							bipForm.setComcode(rset.getString(18));
							bipForm.setFsocfour(rset.getString(19));
							bipForm.setFdeppole(rset.getString(20));
							bipForm.setNum_expense(rset.getString(21)); // TD 582
							bipForm.setCusagexpense(rset.getString(22)); // TD 595
							bipForm.setSiren(rset.getString(23)); // TD 637
							bipForm.setMsgErreur(null);
						} else{
							msg = true;
						}	
						if (rset != null){
							
							if(!StringUtils.isEmpty(bipForm.getNumexpense())){
								request.getSession().setAttribute("socfactcode", bipForm.getSocfact());
							}
							
							rset.close();
						}
					}// try
					catch (SQLException sqle) {
						logService
								.debug("FactureAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("FactureAction-consulter() --> SQLException :"
										+ sqle);
						// Erreur de lecture du resultSet
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11217"));
						// this.saveErrors(request,errors);
						 jdbc.closeJDBC(); return mapping.findForward("error");
					} finally {
						try {
							rset.close();
						} catch (SQLException sqle) {
							logBipUser
									.debug("FactureAction-consulter() --> SQLException-rset.close() :"
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
				// le code Facture n'existe pas, on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		}// try
		catch (BaseException be) {
			logBipUser.debug("FactureAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("FactureAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("FactureAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("FactureAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((FactureForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}
		// force garbage collector
		//Tools.forceFullGarbageCollection();
		logBipUser.debug("fmemory end : " + Runtime.getRuntime().freeMemory());
		logBipUser.exit(signatureMethode);
		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	}

	protected String recupererCle(String mode) {
		String cle = null;
		if (mode.equals("insert")) {
			cle = PACK_INSERT;
		} else if (mode.equals("update")) {
			cle = PACK_UPDATE;
		} else if (mode.equals("delete")) {
			cle = PACK_DELETE;
		}
		  return cle;
	}

	/**
	 * Action qui permet d'ouvrir sur la page de composition des lignes de
	 * facture
	 */
	protected ActionForward suite(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = "FactureAction-suite(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		FactureForm bipForm = (FactureForm) form;

		// exécution de la procédure PL/SQL
		try {
			
			if(StringUtils.isEmpty(bipForm.getNumexpense())){

			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT);
			}else{
				vParamOut = jdbc.getResult(
						hParamProc, configProc, PACK_SELECT_EXPENSE);
			}

		// exécution de la procédure PL/SQL
//		try {
//			vParamOut = jdbc.getResult(
//					hParamProc, configProc, PACK_SELECT);

			// Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				// récupérer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();

				}
				if (paramOut.getNom().equals("ftvaout")) {
					String sFtvaout = (String) paramOut.getValeur();
					logService.debug("Ftvaout :" + sFtvaout);
					((FactureForm) form).setFtva(sFtvaout);
				}// if

				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();

					try {
						logService.debug("ResultSet");
						if (rset.next()) {

							bipForm.setSoclib(rset.getString(1));
							bipForm.setFmontht(rset.getString(7));
							bipForm.setFlaglock(rset.getString(9));
							bipForm.setCav(rset.getString(11));
							bipForm.setNumcont(rset.getString(12));
							bipForm.setMsgErreur(null);
							
							// Modifications de youness
							bipForm.setSocfact(rset.getString(2).trim());	
							bipForm.setNumfact(rset.getString(3).trim());
							bipForm.setTypfact(rset.getString(4));
							bipForm.setDatfact(rset.getString(5));
							bipForm.setFmoiacompta(rset.getString(6));
							//bipForm.setFmontht(rset.getString(7));
							bipForm.setFstatut1(rset.getString(8));
							//bipForm.setFlaglock(rset.getString(9));
							bipForm.setSoccont(rset.getString(10).trim());
							//bipForm.setCav(rset.getString(11));
							//bipForm.setNumcont(rset.getString(12).trim());
							bipForm.setFenrcompta(rset.getString(13));
							bipForm.setFaccsec(rset.getString(14));
							bipForm.setFregcompta(rset.getString(15));
							bipForm.setDate_reception(rset.getString(16));
							bipForm.setFenvsec(rset.getString(17));
							bipForm.setFcodcompta(rset.getString(18));
							bipForm.setComcode(rset.getString(18));
							bipForm.setFsocfour(rset.getString(19));
							bipForm.setFdeppole(rset.getString(20));
							bipForm.setNum_expense(rset.getString(21)); // TD 582
							bipForm.setCusagexpense(rset.getString(22)); // TD 595
							bipForm.setSiren(rset.getString(23)); // TD 637
							//Fin des modifications de youness
						} else
							msg = true;
						if (rset != null)
							if(!StringUtils.isEmpty(bipForm.getNumexpense())){
								java.util.Hashtable hP = new java.util.Hashtable();
								hP.put("keyList0", bipForm.getSocfact());
								hP.put("keyList1", bipForm.getTypfact());
								hP.put("keyList2", bipForm.getDatfact());
								hP.put("keyList3", bipForm.getNumfact());
								hP.put("keyList4", bipForm.getSoccont());
								hP.put("keyList5", bipForm.getCav());
								hP.put("keyList6", bipForm.getNumcont());
								hP.put("keyList7", bipForm.getRnom());
								hP.put("userid", "");
								
								request.getSession().setAttribute("hashTab", hP);
							}
							rset.close();

					}// try
					catch (SQLException sqle) {
						logService
								.debug("FactureAction-suite() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("FactureAction-suite() --> SQLException :"
										+ sqle);
						// Erreur de lecture du resultSet
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11217"));
						// this.saveErrors(request,errors);
						 jdbc.closeJDBC(); return mapping.findForward("error");
					}
				}// if
			}// for

			if (msg) {
				// le code n'existe pas, on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}

		}// try

		catch (BaseException be) {
			logBipUser.debug("FactureAction-suite() --> BaseException :" + be,
					be);
			logBipUser.debug("FactureAction-suite() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("FactureAction-suite() --> BaseException :" + be,
					be);
			logService.debug("FactureAction-suite() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((FactureForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		} // catch

		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("suite");

	}
}
