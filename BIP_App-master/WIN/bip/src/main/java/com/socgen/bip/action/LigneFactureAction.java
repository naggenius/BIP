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

import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.LigneFactureForm;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author MMC - 28/07/2003
 * 
 * COntrats Avenants / Lignes chemin : Ordonnancemement / Factures / factures
 * avenants pages : bLignefactureOr.jsp pl/sql : fligfact.sql
 */

public class LigneFactureAction extends FactureAction {

	private static String PACK_SELECT = "ligneFacture.consulter.proc";
	
	//YNI FDT 784
	private static String PACK_SELECT_EXPENSE = "facture.consulter.proc.expense";
	//FIN YNI FDT 784

	private static String PACK_UPDATE_MAJLIG = "ligneFacture.majlig.proc";

	private static String PACK_INSERT = "ligneFacture.creer.proc";

	private static String PACK_UPDATE = "ligneFacture.modifier.proc";

	private static String PACK_DELETE = "ligneFacture.supprimer.proc";

	private static String PACK_SELECT_1 = "facture.consulter.proc";

	private static String PACK_SELECT_RESS = "ligneFacture.identress.proc";

	private static String PACK_RAPPROCHEMENT = "ligneFacture.rapprochement.proc";

	private String nomProc;

	/**
	 * Action qui permet d'ajouter une ligne facture
	 */
	protected ActionForward creer(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = "LigneFactureAction-creer(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		LigneFactureForm bipForm = (LigneFactureForm) form;

	 return mapping.findForward("ajout");
	}

	/**
	 * Action qui permet de visualiser les données liées à une ligne facture
	 * pour la modification et la suppression
	 */
	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;
		String sMode = request.getParameter("mode");

		String signatureMethode = "LigneFactureAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		LigneFactureForm bipForm = (LigneFactureForm) form;

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

				}
				if (paramOut.getNom().equals("fmonthtout")) {
					String sFmonthtout = (String) paramOut.getValeur();
					logService.debug("Fmonthtout :" + sFmonthtout);
					((LigneFactureForm) form).setFmontht(sFmonthtout);
				} // if
				if (paramOut.getNom().equals("ftvaout")) {
					String sFtvaout = (String) paramOut.getValeur();
					logService.debug("Ftvaout :" + sFtvaout);
					((LigneFactureForm) form).setFtva(sFtvaout);
				} // if
				if (paramOut.getNom().equals("flaglockout")) {
					String sFlaglockout = (String) paramOut.getValeur();
					logService.debug("Flaglockout :" + sFlaglockout);
					((LigneFactureForm) form).setFlaglock(sFlaglockout);
				} // if

				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();

					try {
						logService.debug("ResultSet");
						if (rset.next()) {
							bipForm.setSocfact(rset.getString(1).trim());
							bipForm.setSoclib(rset.getString(2).trim());
							bipForm.setNumcont(rset.getString(3).trim());
							bipForm.setCav(rset.getString(4).trim());
							bipForm.setNumfact(rset.getString(5).trim());
							bipForm.setTypfact(rset.getString(6).trim());
							bipForm.setDatfact(rset.getString(7));
							bipForm.setLnum(rset.getString(8));
							bipForm.setIdent(rset.getString(9));
							bipForm.setRnom(rset.getString(10));
							bipForm.setRprenom(rset.getString(11));
							bipForm.setLmontht(rset.getString(12));
							bipForm.setLmoisprest(rset.getString(13));
							bipForm.setLcodcompta(rset.getString(14));
							bipForm.setTypdpg(rset.getString(15));
							bipForm.setMsgErreur(null);
						} else
							msg = true;

					} // try
					catch (SQLException sqle) {
						logService
								.debug("ligneFactureAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("ligneFactureAction-consulter() --> SQLException :"
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
									.debug("ligneFactureAction-consulter() --> SQLException-rset.close() :"
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
				// le code ligneFacture n'existe pas, on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		} // try
		catch (BaseException be) {
			logBipUser.debug(
					"ligneFactureAction-consulter() --> BaseException :" + be,
					be);
			logBipUser.debug("ligneFactureAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug(
					"ligneFactureAction-consulter() --> BaseException :" + be,
					be);
			logService.debug("ligneFactureAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));

			// this.saveErrors(request,errors);
			 jdbc.closeJDBC(); return mapping.findForward("error");
		}

		logBipUser.exit(signatureMethode);
		// if (sMode .equals("insert")) {
		//  jdbc.closeJDBC(); return mapping.findForward("ajout");
		// }else
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
			// } else if (mode.equals("Rapprochement")) {
			// cle = PACK_RAPPROCHEMENT;
			// PACK_UPDATE
		} else if (mode.equals("majlig")) {
			cle = PACK_UPDATE_MAJLIG;
		}
		  return cle;
	}

	protected ActionForward valider(ActionMapping mapping, ActionForm form,
			String mode, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors,
			Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String cle = null;
		String message = null;
		String sTitrePage = request.getParameter("titrePage");
		String signatureMethode = "valider(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors )";
		logBipUser.entry(signatureMethode);
		logBipUser.debug("mode de mise à jour:" + mode);
		// On récupère la clé pour trouver le nom de la procédure stockée dans
		// bip_proc.properties
		cle = recupererCle(mode);

		//Debut YNI : code inséré pour la gestion du boutton annuler
		if (mode.equals("annuler")) {
			 logBipUser.exit(signatureMethode);
			 jdbc.closeJDBC(); return mapping.findForward("annuler");
		}
		//Fin YNI
		
		if (request.getParameter("rapprochement").equals("oui")) {
			hParamProc.put("mode", "Rapprochement");
		}
		// logBipUser.debug("mode de mise à jour:" +
		// hParamProc.containsKey("mode"));
		// On exécute la procédure stockée
		try {

			vParamOut = jdbc.getResult(
					hParamProc, configProc, cle);

			try {
				message = jdbc.recupererResult(vParamOut, "valider");
				// récupérer les résultats
				for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
					ParametreProc paramOut = (ParametreProc) e.nextElement();
					// récupérer
					if (paramOut.getNom().equals("flaglockout")) {
						String sFlaglockout = (String) paramOut.getValeur();
						((LigneFactureForm) form).setFlaglock(sFlaglockout
								.trim());
					} // if

					// mail à envoyer
					if (paramOut.getNom().equals("mail")
							&& paramOut.getValeur() != null) {
						String sMail = (String) paramOut.getValeur();
						((LigneFactureForm) form).setMailToSend(sMail.trim());
					} // if

				} // for
			} catch (BaseException be) {
				logBipUser.debug("valider() --> BaseException :" + be);
				logBipUser.debug("valider() --> Exception :"
						+ be.getInitialException().getMessage());
				logService.debug("valider() --> BaseException :" + be);
				logService.debug("valider() --> Exception :"
						+ be.getInitialException().getMessage());
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}

			if (message != null && !message.equals("")) {
				// on récupère le message
				((LigneFactureForm) form).setMsgErreur(message);
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
				((LigneFactureForm) form).setMsgErreur(message);
				if (!mode.equals("majlig")) {
					 jdbc.closeJDBC(); return mapping.findForward("ecran");
				} else
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

		if (mode.equals("majlig")) {

			logBipUser.exit(signatureMethode);
			 jdbc.closeJDBC(); return mapping.findForward("date");
		}
		

		if (request.getParameter("rapprochement").equals("oui")) {
			 jdbc.closeJDBC(); return mapping.findForward("ecran");
		}

		logBipUser.exit(signatureMethode);
		jdbc.closeJDBC(); return mapping.findForward("initial");

	} // valider

	/**
	 * Action qui permet d'ouvrir sur la page de maj
	 */
	
	protected ActionForward suite(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;
		// String sMode = request.getParameter("mode");
		String signatureMethode = "LigneFactureAction-suite(paramProc, mapping, form , request,  response,  errors )";
		String sMode = request.getParameter("mode");
		logBipUser.entry(signatureMethode);

		if (sMode.equals("insert")) { // exécution de la procédure PL/SQL
			LigneFactureForm bipForm = (LigneFactureForm) form;
			// Initialiser le numéro de ligne de facture à 0
			bipForm.setClelf("0");
			try {
				vParamOut = jdbc.getResult(
						hParamProc, configProc, PACK_SELECT_RESS);

				// Récupération des résultats
				for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
					paramOut = (ParametreProc) e.nextElement();

					// récupérer le message
					if (paramOut.getNom().equals("message")) {
						message = (String) paramOut.getValeur();

					}
					// Récupérer le nom
					if (paramOut.getNom().equals("rnomout")) {
						String sRnomout = (String) paramOut.getValeur();
						bipForm.setRnom(sRnomout);
					} // if
					// récupérer le prenom
					if (paramOut.getNom().equals("rprenomout")) {
						String sRprenomout = (String) paramOut.getValeur();
						bipForm.setRprenom(sRprenomout);
					} // if
					// récupérer l'ident de la ressource
					if (paramOut.getNom().equals("identout")) {
						String sIdentout = (String) paramOut.getValeur();
						bipForm.setIdent(sIdentout);
					} // if
					// valeur par défaut
						bipForm.setTypdpg("C");
					
					// récupérer le flaglock
					if (paramOut.getNom().equals("flaglockout")) {
						String sFlaglockout = (String) paramOut.getValeur();
						bipForm.setFlaglock(sFlaglockout);
					} // if

				} // for

			} // try
			catch (BaseException be) {
				logBipUser.debug(
						"ligneFactureAction-consulter() --> BaseException :"
								+ be, be);
				logBipUser
						.debug("ligneFactureAction-consulter() --> Exception :"
								+ be.getInitialException().getMessage());

				logService.debug(
						"ligneFactureAction-consulter() --> BaseException :"
								+ be, be);
				logService
						.debug("ligneFactureAction-consulter() --> Exception :"
								+ be.getInitialException().getMessage());
				// Si exception sql alors extraire le message d'erreur du
				// message global
				if (be.getInitialException().getClass().getName().equals(
						"java.sql.SQLException")) {
					message = BipException.getMessageFocus(BipException
							.getMessageOracle(be.getInitialException()
									.getMessage()), form);
					((LigneFactureForm) form).setMsgErreur(message);
					 jdbc.closeJDBC(); return mapping.findForward("ajout");
				} else {
					// Erreur d''exécution de la procédure stockée
					errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
							"11201"));
					request.setAttribute("messageErreur", be
							.getInitialException().getMessage());
					// this.saveErrors(request,errors);
					 jdbc.closeJDBC(); return mapping.findForward("error");
				}
			}// catch

			logBipUser.exit(signatureMethode);
			 jdbc.closeJDBC(); return mapping.findForward("ecran");
		} else if (sMode.equals("lignes")) {
			LigneFactureForm bipForm = (LigneFactureForm) form;

			// exécution de la procédure PL/SQL
			try {
				String expens = (String) hParamProc.get("numexpense");
				System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> num expense :" + expens);
				if(StringUtils.isEmpty(expens)){
				vParamOut = jdbc.getResult(
						hParamProc, configProc, PACK_SELECT_1);
				}else{
					vParamOut = jdbc.getResult(
							hParamProc, configProc, PACK_SELECT_EXPENSE);
				}
				
//				vParamOut = jdbc.getResult(
//						hParamProc, configProc, PACK_SELECT_1);

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
						((LigneFactureForm) form).setFtva(sFtvaout);
					} // if

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
								
								//Modifications de youness
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
								bipForm.setMsgErreur(null);
							} else
								msg = true;
							if (rset != null)
								rset.close();
						} // try
						catch (SQLException sqle) {
							logService
									.debug("LigneFactureAction-suite() --> SQLException :"
											+ sqle);
							logBipUser
									.debug("LigneFactureAction-suite() --> SQLException :"
											+ sqle);
							// Erreur de lecture du resultSet
							errors.add(ActionErrors.GLOBAL_ERROR,
									new ActionError("11217"));
							// this.saveErrors(request,errors);
							 jdbc.closeJDBC(); return mapping.findForward("error");
						}
					} // if
				} // for

				if (msg) {
					// le code n'existe pas, on récupère le message
					bipForm.setMsgErreur(message);
					// on reste sur la même page
					 jdbc.closeJDBC(); return mapping.findForward("initial");
				}

			} // try

			catch (BaseException be) {
				logBipUser.debug(
						"LigneFactureAction-suite() --> BaseException :" + be,
						be);
				logBipUser.debug("LigneFactureAction-suite() --> Exception :"
						+ be.getInitialException().getMessage());

				logService.debug(
						"LigneFactureAction-suite() --> BaseException :" + be,
						be);
				logService.debug("LigneFactureAction-suite() --> Exception :"
						+ be.getInitialException().getMessage());
				// Si exception sql alors extraire le message d'erreur du
				// message global
				if (be.getInitialException().getClass().getName().equals(
						"java.sql.SQLException")) {
					message = BipException.getMessageFocus(BipException
							.getMessageOracle(be.getInitialException()
									.getMessage()), form);
					((LigneFactureForm) form).setMsgErreur(message);
					 jdbc.closeJDBC(); return mapping.findForward("initial");
				} else {
					// Erreur d''exécution de la procédure stockée
					errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
							"11201"));
					request.setAttribute("messageErreur", be
							.getInitialException().getMessage());
					// this.saveErrors(request,errors);
					 jdbc.closeJDBC(); return mapping.findForward("error");
				}
			} // catch

			logBipUser.exit(signatureMethode);

			 jdbc.closeJDBC(); return mapping.findForward("initial");
		} else {
			logBipUser.exit(signatureMethode);
			 jdbc.closeJDBC(); return mapping.findForward("initial");
		}
	}
}
