package com.socgen.bip.action;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.ForfaitForm;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author N.BACCAM - 25/06/2003
 * 
 * Formulaire pour mise à jour des forfaits chemin : Ressources/ mise à
 * jour/Forfaits pages : bForfaitAd.jsp et mForfaitAd.jsp pl/sql : resfor.sql
 */
public class ForfaitAction extends AutomateAction {

	private static String PACK_SELECT_C = "forfait.consulter_c.proc";

	private static String PACK_SELECT_M = "forfait.consulter_m.proc";

	private static String PACK_SELECT_S = "forfait.consulter_s.proc";

	private static String PACK_INSERT = "forfait.creer.proc";

	private static String PACK_UPDATE = "forfait.modifier.proc";
	
	private static String PACK_RECUP_SOCIETE="societe.recup.soccode";
	
	private static String PACK_RECUP_LIB_MCI="forfait.recup.mci.lib.proc";

	private static String PACK_ISMCIOBLIGATOIRE = "personne.recup.mci.obligatoire.proc";	
	

	/**
	 * Action qui permet de créer un code Forfait
	 */
	protected ActionForward creer(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		Vector vParamOut2 = new Vector();
		String message = "";

		String signatureMethode = "ForfaitAction -creer( mapping, form , request,  response,  errors )";

		// logService.entry(signatureMethode);;
		logBipUser.entry(signatureMethode);
		// exécution de la procédure PL/SQL
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT_C);
			// Récupération des résultats
			ForfaitForm bipForm = (ForfaitForm) form;
			bipForm.setDatsitu(((ParametreProc) vParamOut.get(1)).getValeur()
					.toString());
			// bipForm.setCoufor(((ParametreProc)vParamOut.get(3)).getValeur().toString());

			// calcul si le mci est obligatoire pour le dpg
			if ( !"".equals(bipForm.getCodsg())) {
				vParamOut2 = jdbc.getResult(
						hParamProc, configProc, PACK_ISMCIOBLIGATOIRE);	
				bipForm.setMciObligatoire((String) ((ParametreProc) vParamOut2
						.elementAt(0)).getValeur());

			}
			
			try {
				message = jdbc.recupererResult(vParamOut, "creer");
			} catch (BaseException be) {
				logBipUser.debug("ForfaitAction -creer() --> BaseException :"
						+ be);
				logBipUser.debug("ForfaitAction -creer() --> Exception :"
						+ be.getInitialException().getMessage());
				logService.debug("ForfaitAction -creer() --> BaseException :"
						+ be);
				logService.debug("ForfaitAction -creer() --> Exception :"
						+ be.getInitialException().getMessage());
				// Erreur de lecture du resultSet
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
			if (!message.equals("")) {
				// Entité déjà existante, on récupère le message
				((ForfaitForm) form).setMsgErreur(message);
				logBipUser.debug("message d'erreur:" + message);
				logBipUser.exit(signatureMethode);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}

		}// try
		catch (BaseException be) {
			logBipUser.debug("ForfaitAction-creer() --> BaseException :" + be);
			logBipUser.debug("ForfaitAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("ForfaitAction-creer() --> BaseException :" + be);
			logService.debug("ForfaitAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((ForfaitForm) form).setMsgErreur(message);
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

		// logService.exit(signatureMethode);
		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("ecran2");
	}// creer

	/**
	 * Action qui permet de visualiser les données liées à un code Forfait pour
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

		String signatureMethode = "ForfaitAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		ForfaitForm bipForm = (ForfaitForm) form;
		
		// exécution de la procédure PL/SQL
		try {
			
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT_M);

			// Récupérer la date de situ
			bipForm.setDatsitu(((ParametreProc) vParamOut.get(1)).getValeur()
					.toString());

			// Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				// récupérer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();

				}

				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();

					try {
						logService.debug("ResultSet");
						if (rset.next()) {

							bipForm.setIdent(rset.getString(1));
							bipForm.setFlaglock(rset.getInt(4));
							bipForm.setRnom(rset.getString(2));
							bipForm.setCoutot(rset.getString(3));
							bipForm.setPrestation(rset.getString(8));
							bipForm.setCodsg(rset.getString(10));
							bipForm.setTypeForfait(rset.getString(11));
							//bipForm.setCode_domaine(rset.getString(12));
							
							
							bipForm.setMsgErreur(null);
						} else
							msg = true;

					}// try
					catch (SQLException sqle) {
						logService
								.debug("ForfaitAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("ForfaitAction-consulter() --> SQLException :"
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
									.debug("ForfaitAction-consulter() --> SQLException-rset.close() :"
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
				// le code Forfait n'existe pas, on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}

		}// try
		catch (BaseException be) {
			logBipUser.debug("ForfaitAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("ForfaitAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("ForfaitAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("ForfaitAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((ForfaitForm) form).setMsgErreur(message);
				// ((ForfaitForm)form).setMsgErreur("Forfait
				// "+bipForm.getIdent() +" inexistant");
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

		logBipUser.exit(signatureMethode);

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

	protected ActionForward suite(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = "ForfaitAction-suite(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		ForfaitForm bipForm = (ForfaitForm) form;

		// exécution de la procédure PL/SQL
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT_S);

			// Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				// récupérer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();

				}

				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();

					try {
						logService.debug("ResultSet");
						if (rset.next()) {

							bipForm.setIdent(rset.getString(1));
							bipForm.setRnom(rset.getString(2));
							bipForm.setCoutot(rset.getString(3));
							bipForm.setFlaglock(rset.getInt(4));
							bipForm.setDatsitu(rset.getString(5));
							bipForm.setTypeForfait(rset.getString(11));
						} else
							msg = true;
						if (rset != null)
							rset.close();
					}// try
					catch (SQLException sqle) {
						logService
								.debug("ForfaitAction-suite() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("ForfaitAction-suite() --> SQLException :"
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
				// le code Forfait n'existe pas, on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		}// try
		catch (BaseException be) {
			logBipUser.debug("ForfaitAction-suite() --> BaseException :" + be,
					be);
			logBipUser.debug("ForfaitAction-suite() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("ForfaitAction-suite() --> BaseException :" + be,
					be);
			logService.debug("ForfaitAction-suite() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((ForfaitForm) form).setMsgErreur(message);
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

		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("suite");
	}

	/**
	 * Method valider Action qui permet d'enregistrer les données pour la
	 * création, modification, suppression d'un code client
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param errors
	 * @ jdbc.closeJDBC(); return ActionForward
	 * @throws ServletException
	 * 
	 */

	protected ActionForward valider(ActionMapping mapping, ActionForm form,
			String mode, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors,
			Hashtable hParamProctest) throws ServletException {
		
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String cle = null;
		String message = null;
		ParametreProc paramOut;

		String signatureMethode = "valider(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors )";
		logBipUser.entry(signatureMethode);
		logBipUser.debug("mode de mise à jour:" + mode);
		// On récupère la clé pour trouver le nom de la procédure stockée dans
		// bip_proc.properties
		cle = recupererCle(mode);

		// On exécute la procédure stockée
		try {

			vParamOut = jdbc.getResult(
					hParamProctest, configProc, cle);

			try {
				message = jdbc.recupererResult(vParamOut, "valider");

				// Récupération des résultats
				for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
					paramOut = (ParametreProc) e.nextElement();

					// récupérer le message
					if (paramOut.getNom().equals("message")) {
						message = (String) paramOut.getValeur();

					}

					// récupérer l'identifiant
					if (paramOut.getNom().equals("ident")) {
						((ForfaitForm) form).setIdent((String) paramOut
								.getValeur());
						request.setAttribute("ident", (String) paramOut
								.getValeur());
					}

				}// for

			} catch (BaseException be) {
				logBipUser.debug("valider() --> BaseException :" + be);
				logBipUser.debug("valider() --> Exception :"
						+ be.getInitialException().getMessage());
				logService.debug("valider() --> BaseException :" + be);
				logService.debug("valider() --> Exception :"
						+ be.getInitialException().getMessage());
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}

			if (message != null && !message.equals("")) {
				// on récupère le message
				((ForfaitForm) form).setMsgErreur(message);
				logBipUser.debug("valider() -->message :" + message);
			}

		} catch (BaseException be) {

			logService.debug("valider() --> BaseException :" + be);
			logService.debug("valider() --> Exception :"
					+ be.getInitialException().getMessage());
			logBipUser.debug("valider() --> BaseException :" + be);
			logBipUser.debug("valider() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((ForfaitForm) form).setMsgErreur(message);

				if (!mode.equals("delete")) {
					 jdbc.closeJDBC(); return mapping.findForward("ecran");
				}
			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}

		logBipUser.exit(signatureMethode);
		 jdbc.closeJDBC(); return mapping.findForward("initial");

	}// valider
	
	protected ActionForward refresh(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		ForfaitForm bipForm = (ForfaitForm) form;
		String focus = bipForm.getFocus();
		Vector vParamOut = new Vector();
	
		try {
			if ("soccode".equals(focus)) {	
			
			vParamOut = jdbc.getResult(
						hParamProc, configProc, PACK_RECUP_SOCIETE);
				bipForm.setLib_siren((String) ((ParametreProc) vParamOut
						.elementAt(0)).getValeur());
				bipForm.setLib_soccode((String) ((ParametreProc) vParamOut
						.elementAt(1)).getValeur());
				bipForm.setMsgErreur((String) ((ParametreProc) vParamOut
						.elementAt(2)).getValeur());
				
				// MAJ du Focus
				if (bipForm.getMsgErreur() == null)
					bipForm.setFocus("soccode");
			}
			if ("modeContractuelInd".equals(focus)) {
				
				vParamOut = jdbc.getResult(
						hParamProc, configProc, PACK_RECUP_LIB_MCI);
				bipForm.setLib_mci((String) ((ParametreProc) vParamOut
						.elementAt(0)).getValeur());
				bipForm.setLocalisation((String) ((ParametreProc) vParamOut
						.elementAt(1)).getValeur());
				
				// MAJ du Focus
				if (bipForm.getMsgErreur() == null)
					bipForm.setFocus("modeContractuelInd");
			}
			
		} catch (BaseException be) {
			logBipUser.debug("ForfaitAction-refresh() --> BaseException :" + be,
					be);
			logBipUser.debug("ForfaitAction-refresh() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("ForfaitAction-refresh() --> BaseException :" + be,
					be);
			logService.debug("ForfaitAction-refresh() --> Exception :"
					+ be.getInitialException().getMessage());
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));

			// this.saveErrors(request,errors);
			 jdbc.closeJDBC(); return mapping.findForward("error");
		}
		jdbc.closeJDBC();
				
		return mapping.findForward("ecran");
		 
	}

	public ActionForward edition(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		 return mapping.findForward("edition");

	}
	
	protected ActionForward suite1(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		   return mapping.findForward("ecran");
		 
	}

}
