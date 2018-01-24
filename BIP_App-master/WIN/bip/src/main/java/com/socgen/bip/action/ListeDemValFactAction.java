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
import com.socgen.bip.form.ListeDemFactAttForm;
import com.socgen.bip.metier.DemandeValFactu;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author JMA - 03/03/2006
 * 
 * Action : gestion des demandes en attente de validation
 * 
 */

public class ListeDemValFactAction extends AutomateAction {

	private static String PACK_SELECT = "demandeValFact.liste_dem_eff.proc";

	private static String PACK_SELECT_DEMANDE = "demandeValFact.select.proc";

	private static String PACK_UPDATE_FACTURE = "demandeValFact.update_facture.proc";

	private static String PACK_SELECT_ALL_FACTURE = "demandeValFact.ligne_toutes_fact.proc";

	private static String PACK_SELECT_FACTURE_DATE_SUIVI = "demandeValFact.facture_datesuivi.proc";
	
	

	/**
	 * Constructor for ListeDemValFactAction.
	 */
	public ListeDemValFactAction() {
		super();
	}

	/**
	 * Action permettant le premier appel de la JSP
	 * 
	 */
	protected ActionForward initialiser(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = this.getClass().getName()
				+ " - initialiser(paramProc, mapping, form , request,  response,  errors )";
		String methodeName = "-initialiser";
		logBipUser.entry(signatureMethode);
		ListeDemFactAttForm ldfaForm = (ListeDemFactAttForm) form;

		// exécution de la procédure PL/SQL
		try {
			hParamProc.put("mois", "01/2000");
			hParamProc.put("statut", "X");
			ldfaForm.setStatut("X");
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT);

			// Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				// récupérer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();
					if ((message != null) && (!message.equals("")))
						msg = true;
				}

				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();

					try {
						int prev_iddem = 0;
						while (rset.next()) {
							DemandeValFactu demande = new DemandeValFactu(rset
									.getString(1),
									prev_iddem != rset.getInt(2), rset
											.getInt(2), rset.getTimestamp(3),
									rset.getString(4), rset.getString(5), rset
											.getString(6), rset.getString(7),
									rset.getInt(8), rset.getString(9), rset
											.getString(10), rset.getString(11));
							prev_iddem = rset.getInt(2);
							ldfaForm.setMsgErreur(null);
							ldfaForm.addDemande(demande);
						}
					} // try
					catch (SQLException sqle) {
						logService.error(this.getClass().getName()
								+ methodeName + " --> SQLException :" + sqle);
						logBipUser.error(this.getClass().getName()
								+ methodeName + " --> SQLException :" + sqle);
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
									.error(this.getClass().getName()
											+ methodeName
											+ " --> SQLException-rset.close() :"
											+ sqle);
							// Erreur de lecture du resultSet
							errors.add(ActionErrors.GLOBAL_ERROR,
									new ActionError("11217"));
							 jdbc.closeJDBC(); return mapping.findForward("error");
						}

					}
				} // if
			} // for
			if (msg) {
				// le code Personne n'existe pas, on récupère le message
				ldfaForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}

		} // try
		catch (BaseException be) {
			logBipUser.error(this.getClass().getName() + methodeName
					+ " --> BaseException :" + be, be);
			logBipUser.error(this.getClass().getName() + methodeName
					+ " --> Exception :"
					+ be.getInitialException().getMessage());

			logService.error(this.getClass().getName() + methodeName
					+ " --> BaseException :" + be, be);
			logService.error(this.getClass().getName() + methodeName
					+ " --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((ListeDemFactAttForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}
		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	}

	/**
	 * Action qui permet de supprimer ou modifier l'ordre d'un favori
	 */
	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = this.getClass().getName()
				+ " - consulter(paramProc, mapping, form , request,  response,  errors )";
		String methodeName = "-consulter";
		logBipUser.entry(signatureMethode);
		ListeDemFactAttForm ldfaForm = (ListeDemFactAttForm) form;

		// exécution de la procédure PL/SQL
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT);

			// Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				// récupérer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();
					if ((message != null) && (!message.equals("")))
						msg = true;
				}

				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();

					try {
						int prev_iddem = 0;
						while (rset.next()) {
							DemandeValFactu demande = new DemandeValFactu(rset
									.getString(1),
									prev_iddem != rset.getInt(2), rset
											.getInt(2), rset.getTimestamp(3),
									rset.getString(4), rset.getString(5), rset
											.getString(6), rset.getString(7),
									rset.getInt(8), rset.getString(9), rset
											.getString(10), rset.getString(11));
							prev_iddem = rset.getInt(2);
							ldfaForm.setMsgErreur(null);
							ldfaForm.addDemande(demande);
						}
					} // try
					catch (SQLException sqle) {
						logService.error(this.getClass().getName()
								+ methodeName + " --> SQLException :" + sqle);
						logBipUser.error(this.getClass().getName()
								+ methodeName + " --> SQLException :" + sqle);
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
									.error(this.getClass().getName()
											+ methodeName
											+ " --> SQLException-rset.close() :"
											+ sqle);
							// Erreur de lecture du resultSet
							errors.add(ActionErrors.GLOBAL_ERROR,
									new ActionError("11217"));
							 jdbc.closeJDBC(); return mapping.findForward("error");
						}

					}
				} // if
			} // for
			if (msg) {
				// le code Personne n'existe pas, on récupère le message
				ldfaForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}

		} // try
		catch (BaseException be) {
			logBipUser.error(this.getClass().getName() + methodeName
					+ " --> BaseException :" + be, be);
			logBipUser.error(this.getClass().getName() + methodeName
					+ " --> Exception :"
					+ be.getInitialException().getMessage());

			logService.error(this.getClass().getName() + methodeName
					+ " --> BaseException :" + be, be);
			logService.error(this.getClass().getName() + methodeName
					+ " --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((ListeDemFactAttForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}
		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("ecran");

	} // consulter

	/**
	 * Action qui permet de visualiser la cause d'une mise en suspens ou les
	 * dates de suivi saisies
	 */
	public ActionForward visualiser(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = this.getClass().getName()
				+ " - visualiser(paramProc, mapping, form , request,  response,  errors )";
		String methodeName = "-visualiser";
		logBipUser.entry(signatureMethode);
		ListeDemFactAttForm ldfaForm = (ListeDemFactAttForm) form;

		// exécution de la procédure PL/SQL
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT_DEMANDE);

			// Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				// récupérer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();
					if ((message != null) && (!message.equals("")))
						msg = true;
				}

				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();

					try {
						String snumfact = "";
						while (rset.next()) {
							ldfaForm.setCausesuspens(rset.getString(1));
							ldfaForm.setFaccsec(rset.getString(2));
							ldfaForm.setFregcompta(rset.getString(3));
							ldfaForm.setFstatut2(rset.getString(4));
							ldfaForm.setMsgErreur(null);
							if (snumfact.length() > 0)
								snumfact += ", ";
							snumfact += rset.getString(5);
							ldfaForm.setListeFact(snumfact);
						}
					} // try
					catch (SQLException sqle) {
						logService.error(this.getClass().getName()
								+ methodeName + " --> SQLException :" + sqle);
						logBipUser.error(this.getClass().getName()
								+ methodeName + " --> SQLException :" + sqle);
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
									.error(this.getClass().getName()
											+ methodeName
											+ " --> SQLException-rset.close() :"
											+ sqle);
							// Erreur de lecture du resultSet
							errors.add(ActionErrors.GLOBAL_ERROR,
									new ActionError("11217"));
							 jdbc.closeJDBC(); return mapping.findForward("error");
						}

					}
				} // if
			} // for
			if (msg) {
				ldfaForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}

		} // try
		catch (BaseException be) {
			logBipUser.error(this.getClass().getName() + methodeName
					+ " --> BaseException :" + be, be);
			logBipUser.error(this.getClass().getName() + methodeName
					+ " --> Exception :"
					+ be.getInitialException().getMessage());

			logService.error(this.getClass().getName() + methodeName
					+ " --> BaseException :" + be, be);
			logService.error(this.getClass().getName() + methodeName
					+ " --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((ListeDemFactAttForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			} else {
				// Erreur d'exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}
		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("suite");

	} // visualiser

	/**
	 * Action
	 */
	protected ActionForward creer(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = this.getClass().getName()
				+ " - creer(paramProc, mapping, form , request,  response,  errors )";
		String methodeName = "-creer";
		logBipUser.entry(signatureMethode);
		ListeDemFactAttForm ldfaForm = (ListeDemFactAttForm) form;

		// exécution de la procédure PL/SQL
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT_FACTURE_DATE_SUIVI);

			// Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				// récupérer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();
					if ((message != null) && (!message.equals("")))
						msg = true;
				}

				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();

					try {
						while (rset.next()) {
							DemandeValFactu demande = new DemandeValFactu(rset
									.getString(1), // socfact
									rset.getString(2), // soclib
									rset.getString(3), // numfact
									rset.getString(4), // typfact
									rset.getString(5), // datfact
									rset.getString(6), // fenrcompta
									rset.getString(7), // fenvsec
									rset.getString(8), // fmodreglt
									rset.getString(9), // fordrecheq
									rset.getString(10), // fnom
									rset.getString(11), // fadresse1
									rset.getString(12), // fadresse2
									rset.getString(13), // fadresse3
									rset.getString(14), // fcodepost
									rset.getString(15), // fburdistr
									rset.getString(16), // faccsec
									rset.getString(17), // fregcompta
									rset.getString(18) // fstatut2
							);
							ldfaForm.addDemande(demande);
						}
					} // try
					catch (SQLException sqle) {
						logService.error(this.getClass().getName()
								+ methodeName + " --> SQLException :" + sqle);
						logBipUser.error(this.getClass().getName()
								+ methodeName + " --> SQLException :" + sqle);
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
									.error(this.getClass().getName()
											+ methodeName
											+ " --> SQLException-rset.close() :"
											+ sqle);
							// Erreur de lecture du resultSet
							errors.add(ActionErrors.GLOBAL_ERROR,
									new ActionError("11217"));
							 jdbc.closeJDBC(); return mapping.findForward("error");
						}

					}
				} // if
			} // for
			if (msg) {
				ldfaForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}

		} // try
		catch (BaseException be) {
			logBipUser.error(this.getClass().getName() + methodeName
					+ " --> BaseException :" + be, be);
			logBipUser.error(this.getClass().getName() + methodeName
					+ " --> Exception :"
					+ be.getInitialException().getMessage());

			logService.error(this.getClass().getName() + methodeName
					+ " --> BaseException :" + be, be);
			logService.error(this.getClass().getName() + methodeName
					+ " --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((ListeDemFactAttForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			} else {
				// Erreur d'exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}
		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("datesuivi");

	} // creer

	/**
	 * Action qui permet de revenir à l'écran liste
	 */
	protected ActionForward annuler(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = this.getClass().getName()
				+ " - annuler(paramProc, mapping, form , request,  response,  errors )";
		String methodeName = "-annuler";
		logBipUser.entry(signatureMethode);
		logBipUser.exit(signatureMethode);

		return consulter(mapping, form, request, response, errors, hParamProc);

	} // annuler

	/**
	 * Action validant la saisie des dates de suivi
	 */
	public ActionForward majdate(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = this.getClass().getName()
				+ " - majdate(paramProc, mapping, form , request,  response,  errors )";
		String methodeName = "-majdate";
		logBipUser.entry(signatureMethode);
		ListeDemFactAttForm ldfaForm = (ListeDemFactAttForm) form;
		String iddem = ldfaForm.getIddem();

		DemandeValFactu dvf[] = new DemandeValFactu[ldfaForm.getNbreFacture()];
		for (int z = 0; z < ldfaForm.getNbreFacture(); z++)
			dvf[z] = new DemandeValFactu();

		String[] valeur = request.getParameterValues("socfact");
		for (int z = 0; z < valeur.length; z++)
			dvf[z].setSocfact(valeur[z]);
		valeur = request.getParameterValues("numfact");
		for (int z = 0; z < valeur.length; z++)
			dvf[z].setNumfact(valeur[z]);
		valeur = request.getParameterValues("typfact");
		for (int z = 0; z < valeur.length; z++)
			dvf[z].setTypfact(valeur[z]);
		valeur = request.getParameterValues("datfact");
		for (int z = 0; z < valeur.length; z++)
			dvf[z].setDatfact(valeur[z]);
		valeur = request.getParameterValues("faccsec");
		for (int z = 0; z < valeur.length; z++)
			dvf[z].setFaccsec(valeur[z]);
		valeur = request.getParameterValues("fregcompta");
		for (int z = 0; z < valeur.length; z++)
			dvf[z].setFregcompta(valeur[z]);
		valeur = request.getParameterValues("fstatut2");
		for (int z = 0; z < valeur.length; z++)
			dvf[z].setFstatut2(valeur[z]);
		valeur = request.getParameterValues("fenvsec");
		for (int z = 0; z < valeur.length; z++)
			dvf[z].setFenvsec(valeur[z]);
		valeur = request.getParameterValues("fenrcompta");
		for (int z = 0; z < valeur.length; z++)
			dvf[z].setFenrcompta(valeur[z]);
		valeur = request.getParameterValues("fmodreglt");
		for (int z = 0; z < valeur.length; z++)
			dvf[z].setFmodreglt(valeur[z]);
		valeur = request.getParameterValues("fordrecheq");
		for (int z = 0; z < valeur.length; z++)
			dvf[z].setFordrecheq(valeur[z]);
		valeur = request.getParameterValues("fnom");
		for (int z = 0; z < valeur.length; z++)
			dvf[z].setFnom(valeur[z]);
		valeur = request.getParameterValues("fadresse1");
		for (int z = 0; z < valeur.length; z++)
			dvf[z].setFadresse1(valeur[z]);
		valeur = request.getParameterValues("fadresse2");
		for (int z = 0; z < valeur.length; z++)
			dvf[z].setFadresse2(valeur[z]);
		valeur = request.getParameterValues("fadresse3");
		for (int z = 0; z < valeur.length; z++)
			dvf[z].setFadresse3(valeur[z]);
		valeur = request.getParameterValues("fcodepost");
		for (int z = 0; z < valeur.length; z++)
			dvf[z].setFcodepost(valeur[z]);
		valeur = request.getParameterValues("fburdistr");
		for (int z = 0; z < valeur.length; z++)
			dvf[z].setFburdistr(valeur[z]);

		for (int z = 0; z < dvf.length; z++) {

			hParamProc.put("iddem", iddem);
			hParamProc.put("socfact", dvf[z].getSocfact());
			hParamProc.put("numfact", dvf[z].getNumfact());
			hParamProc.put("typfact", dvf[z].getTypfact());
			hParamProc.put("datfact", dvf[z].getDatfact());
			hParamProc.put("faccsec", dvf[z].getFaccsec());
			hParamProc.put("fregcompta", dvf[z].getFregcompta());
			hParamProc.put("fstatut2", dvf[z].getFstatut2());
			hParamProc.put("fenvsec", dvf[z].getFenvsec());
			hParamProc.put("fenrcompta", dvf[z].getFenrcompta());
			hParamProc.put("fmodreglt", dvf[z].getFmodreglt());
			hParamProc.put("fordrecheq", dvf[z].getFordrecheq());
			hParamProc.put("fnom", dvf[z].getFnom());
			hParamProc.put("fadresse1", dvf[z].getFadresse1());
			hParamProc.put("fadresse2", dvf[z].getFadresse2());
			hParamProc.put("fadresse3", dvf[z].getFadresse3());
			hParamProc.put("fcodepost", dvf[z].getFcodepost());
			hParamProc.put("fburdistr", dvf[z].getFburdistr());

			// exécution de la procédure PL/SQL
			try {
				vParamOut = jdbc.getResult(
						hParamProc, configProc, PACK_UPDATE_FACTURE);
				try {
					message = jdbc.recupererResult(vParamOut, "valider");
				} catch (BaseException be) {
					logBipUser.debug(this.getClass().getName() + methodeName
							+ " --> BaseException :" + be);
					logBipUser.debug(this.getClass().getName() + methodeName
							+ " --> Exception :"
							+ be.getInitialException().getMessage());
					logService.debug(this.getClass().getName() + methodeName
							+ " --> BaseException :" + be);
					logService.debug(this.getClass().getName() + methodeName
							+ " --> Exception :"
							+ be.getInitialException().getMessage());
					// Erreur de lecture du resultSet
					errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
							"11217"));
					// this.saveErrors(request,errors);
					 jdbc.closeJDBC(); return mapping.findForward("error");
				}
				if ((message != null) && (!message.equals(""))) {
					// Entité déjà existante, on récupère le message
					((ListeDemFactAttForm) form).setMsgErreur(message);
					logBipUser.debug("message d'erreur:" + message);
					logBipUser.exit(signatureMethode);
					// on reste sur la même page
					 jdbc.closeJDBC(); return mapping.findForward("initial");
				}
			} // try
			catch (BaseException be) {
				logBipUser.error(this.getClass().getName() + methodeName
						+ " --> BaseException :" + be, be);
				logBipUser.error(this.getClass().getName() + methodeName
						+ " --> Exception :"
						+ be.getInitialException().getMessage());

				logService.error(this.getClass().getName() + methodeName
						+ " --> BaseException :" + be, be);
				logService.error(this.getClass().getName() + methodeName
						+ " --> Exception :"
						+ be.getInitialException().getMessage());
				// Si exception sql alors extraire le message d'erreur du
				// message global
				if (be.getInitialException().getClass().getName().equals(
						"java.sql.SQLException")) {
					message = BipException.getMessageFocus(BipException
							.getMessageOracle(be.getInitialException()
									.getMessage()), form);
					((ListeDemFactAttForm) form).setMsgErreur(message);
					 jdbc.closeJDBC(); return mapping.findForward("initial");
				} else {
					// Erreur d''exécution de la procédure stockée
					errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
							"11201"));
					// this.saveErrors(request,errors);
					 jdbc.closeJDBC(); return mapping.findForward("error");
				}
			}

		}
		logBipUser.exit(signatureMethode);
		 jdbc.closeJDBC(); return consulter(mapping, form, request, response, errors, hParamProc);
	}// majdate

	/**
	 * Action lançant l'édition des justificatif
	 */
	public ActionForward edition(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		return mapping.findForward("edition");

	}

}