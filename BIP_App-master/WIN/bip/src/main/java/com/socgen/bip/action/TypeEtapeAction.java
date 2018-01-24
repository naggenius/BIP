package com.socgen.bip.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.commun.form.AutomateForm;
import com.socgen.bip.commun.form.BipForm;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.TypeEtapeForm;
import com.socgen.bip.metier.TypeEtape;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author ABA - 31/10/2011
 * 
 * Action de mise à jour des type d'étapes : Administration/Tables/ mise à
 * jour/Type Etape pages : fmTypeEtapeAd.jsp et mTypeEtapeAd.jsp.jsp pl/sql :
 * typeEtape.sql
 */
public class TypeEtapeAction extends AutomateAction implements BipConstantes {

	private static String PACK_SELECT = "typeetape.consulter.proc";

	private static String PACK_INSERT = "typeetape.creer.proc";

	private static String PACK_UPDATE = "typeetape.modifier.proc";

	private static String PACK_DELETE = "typeetape.supprimer.proc";

	private static String PACK_SELECT_JEU = "jeu.init.proc";
	private static final String PACK_INSERT_VALID_TYPELIGNE = "typeetape.creer.valid.proc";

	/**
	 * Action qui permet de créer un mode contractuel
	 */

	protected ActionForward initialiser(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		// comme le scope est en session je detruis l'objet form (typeetapeForm)
		// à chaque initialisation appel de la premiere page
		request.getSession().removeAttribute("typeetapeForm");
		return mapping.findForward("initial");
	}

	protected ActionForward creer(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip();
		Vector vParamOut = new Vector();
		String message = "";
		ParametreProc paramOut;

		String signatureMethode = "TypeEtapeAction-creer( mapping, form , request,  response,  errors )";

		// logService.entry(signatureMethode);;
		logBipUser.entry(signatureMethode);
		// exécution de la procédure PL/SQL

		TypeEtapeForm bipForm = (TypeEtapeForm) form;
		bipForm.reset();
		bipForm.setLibelle(null);
		bipForm.setTypeLigne(null);

		try {
			vParamOut = jdbc.getResult(hParamProc, configProc, PACK_SELECT_JEU);
			try {
				message = jdbc.recupererResult(vParamOut, "creer");
			} catch (BaseException be) {
				logBipUser.debug("TypeEtapeAction-creer() --> BaseException :"
						+ be);
				logBipUser.debug("TypeEtapeAction-creer() --> Exception :"
						+ be.getInitialException().getMessage());
				logService.debug("TypeEtapeAction-creer() --> BaseException :"
						+ be);
				logService.debug("TypeEtapeAction-creer() --> Exception :"
						+ be.getInitialException().getMessage());
				// Erreur de lecture du resultSet
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				// this.saveErrors(request,errors);
				jdbc.closeJDBC();
				return mapping.findForward("error");
			}

			if (!message.equals("")) {

				for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
					paramOut = (ParametreProc) e.nextElement();

					// récupérer le message
					if (paramOut.getNom().equals("message")) {
						message = (String) paramOut.getValeur();

					}
				}
				bipForm.setMsgErreur(message);
				logBipUser.debug("message d'erreur:" + message);
				logBipUser.exit(signatureMethode);
				// on reste sur la même page
				jdbc.closeJDBC();
				return mapping.findForward("initial");
			} else {
				for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
					paramOut = (ParametreProc) e.nextElement();

					if (paramOut.getNom().equals("curseur_jeu")) {
						// Récupération du Ref Cursor
						ResultSet rset = (ResultSet) paramOut.getValeur();

						try {
							logService.debug("ResultSet");
							ArrayList<TypeEtape> jeutot = new ArrayList<TypeEtape>();

							while (rset.next()) {
								jeutot.add(new TypeEtape(rset.getString(1),
										rset.getString(2)));
							}
							bipForm.setJeu_associe(jeutot);

						}// try
						catch (SQLException sqle) {
							logService
									.debug("TypeEtapeAction-creer() --> SQLException :"
											+ sqle);
							logBipUser
									.debug("TypeEtapeAction-creer()) --> SQLException :"
											+ sqle);
							// Erreur de lecture du resultSet
							errors.add(ActionErrors.GLOBAL_ERROR,
									new ActionError("11217"));
							// this.saveErrors(request,errors);
							jdbc.closeJDBC();
							return mapping.findForward("error");
						}
						finally
						{
							try {
								if (rset != null)
									rset.close();
							} catch (SQLException sqle) {
								logBipUser.debug("TypeEtapeAction-creer() --> rset.close() :"+ sqle);
								// Erreur de lecture du resultSet
								errors.add(ActionErrors.GLOBAL_ERROR,new ActionError("11217"));
								return mapping.findForward("error");
							}
						}
					}
				}

			}
		}// try
		catch (BaseException be) {
			logBipUser
					.debug("TypeEtapeAction-creer() --> BaseException :" + be);
			logBipUser.debug("TypeEtapeAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			logService
					.debug("TypeEtapeAction-creer() --> BaseException :" + be);
			logService.debug("TypeEtapeAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((TypeEtapeForm) form).setMsgErreur(message);
				jdbc.closeJDBC();
				return mapping.findForward("initial");

			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				// this.saveErrors(request,errors);
				jdbc.closeJDBC();
				return mapping.findForward("error");
			}
		}

		// logService.exit(signatureMethode);
		logBipUser.exit(signatureMethode);
		jdbc.closeJDBC();
		return mapping.findForward("ecran");
	}// creer

	/**
	 * Action qui permet de visualiser les données liées à un mode contractuel
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
		int cpt = 0;

		String signatureMethode = "TypeEtapeAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		TypeEtapeForm bipForm = (TypeEtapeForm) form;
		bipForm.reset();

		// exécution de la procédure PL/SQL
		try {
			vParamOut = jdbc.getResult(hParamProc, configProc, PACK_SELECT);

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

							bipForm.setType_etape(rset.getString(1));
							bipForm.setLibelle(rset.getString(2));
							bipForm.setTop_immo(rset.getString(3));
							bipForm.setFlaglock(rset.getString(4));
							bipForm.setTypeLigne(rset.getString(5));
							bipForm.setMsgErreur(null);
						} else
							msg = true;

					}// try
					catch (SQLException sqle) {
						logService
								.debug("TypeEtapeAction - consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("TypeEtapeAction -consulter() --> SQLException :"
										+ sqle);
						// Erreur de lecture du resultSet
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11217"));
						// this.saveErrors(request,errors);
						jdbc.closeJDBC();
						return mapping.findForward("error");
					} finally {
						try {
							if (rset != null)
								rset.close();
						} catch (SQLException sqle) {
							logBipUser
									.debug("TypeEtapeAction -suite() --> SQLException-rset.close() :"
											+ sqle);
							// Erreur de lecture du resultSet
							errors.add(ActionErrors.GLOBAL_ERROR,
									new ActionError("11217"));
							jdbc.closeJDBC();
							return mapping.findForward("error");
						}

					}
				}
				if (paramOut.getNom().equals("curseur_jeu") && !msg) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();

					try {
						logService.debug("ResultSet");

						ArrayList<TypeEtape> jeutot = new ArrayList<TypeEtape>();

						while (rset.next()) {
							jeutot.add(new TypeEtape(rset.getString(1), rset
									.getString(2)));
							cpt++;
						}

						bipForm.setJeu_associe(jeutot);

						if (cpt == 0)
							msg = true;

					}// try
					catch (SQLException sqle) {
						logService
								.debug("TypeEtapeAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("TypeEtapeAction-consulter() --> SQLException :"
										+ sqle);
						// Erreur de lecture du resultSet
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11217"));
						// this.saveErrors(request,errors);
						jdbc.closeJDBC();
						return mapping.findForward("error");
					} finally {
						try {
							if (rset != null)
								rset.close();
						} catch (SQLException sqle) {
							logBipUser
									.debug("TypeEtapeAction-suite() --> SQLException-rset.close() :"
											+ sqle);
							// Erreur de lecture du resultSet
							errors.add(ActionErrors.GLOBAL_ERROR,
									new ActionError("11217"));
							jdbc.closeJDBC();
							return mapping.findForward("error");
						}

					}
				}// if
			}// for
			if (msg) {

				bipForm.setMsgErreur(message);
				// on reste sur la même page
				jdbc.closeJDBC();
				return mapping.findForward("initial");
			}
		}// try
		catch (BaseException be) {
			logBipUser.debug("TypeEtapeAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("TypeEtapeAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("TypeEtapeAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("TypeEtapeAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((TypeEtapeForm) form).setMsgErreur(message);
				jdbc.closeJDBC();
				return mapping.findForward("initial");

			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				// this.saveErrors(request,errors);
				jdbc.closeJDBC();
				return mapping.findForward("error");
			}
		}

		logBipUser.exit(signatureMethode);

		jdbc.closeJDBC();
		return mapping.findForward("ecran");
	}

	protected ActionForward annuler(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		TypeEtapeForm bipForm = (TypeEtapeForm) form;
		bipForm.setMsgErreur(null);
		return mapping.findForward("initial");
	}

	protected ActionForward valider(ActionMapping mapping, ActionForm form,
			String mode, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors,
			Hashtable hParamProc) throws ServletException {
		Vector vParamOut = new Vector();
		String cle = null;
		String message = null;
		StringBuffer chaine_jeu = new StringBuffer();

		String signatureMethode = "valider(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors )";
		logBipUser.entry(signatureMethode);
		logBipUser.debug("mode de mise à jour:" + mode);
		// On récupère la clé pour trouver le nom de la procédure stockée dans
		// bip_proc.properties
		cle = recupererCle(mode);

		JdbcBip jdbc1 = new JdbcBip();

		TypeEtapeForm bipForm = (TypeEtapeForm) form;
		Iterator<TypeEtape> it = bipForm.getJeu_associe().iterator();

		while (it.hasNext()) {
			TypeEtape te = it.next();
			if ("".equals(te.getChronologie())
					|| " ".equals(te.getChronologie())) {
				chaine_jeu = chaine_jeu.append(te.getJeu() + "@" + "0" + "+");
			} else {
				chaine_jeu = chaine_jeu.append(te.getJeu() + "@"
						+ te.getChronologie() + "+");
			}

		}

		hParamProc.put("chaine_jeu", chaine_jeu.toString());
		hParamProc.put("type_ligne", bipForm.getTypeLigne());
		// On exécute la procédure stockée
		try {

			vParamOut = jdbc1.getResult(hParamProc, configProc, cle);

			try {
				message = jdbc1.recupererResult(vParamOut, "valider");

			} catch (BaseException be) {
				logBipUser.debug("valider() --> BaseException :" + be);
				logBipUser.debug("valider() --> Exception :"
						+ be.getInitialException().getMessage());
				logService.debug("valider() --> BaseException :" + be);
				logService.debug("valider() --> Exception :"
						+ be.getInitialException().getMessage());
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				jdbc1.closeJDBC();
				return mapping.findForward("error");
			}

			if (message != null && !message.equals("")) {
				// on récupère le message
				((AutomateForm) form).setMsgErreur(message);
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
				((AutomateForm) form).setMsgErreur(message);

				if (!mode.equals("delete")) {
					jdbc1.closeJDBC();
					return mapping.findForward("ecran");
				}
			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				jdbc1.closeJDBC();
				return mapping.findForward("error");
			}
		}

		logBipUser.exit(signatureMethode);
		jdbc1.closeJDBC();
		return mapping.findForward("initial");

	}// valider

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
	
	
	
	//--- NEWWWW
	public ActionForward TypeLigneVerifVal(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws IOException{
		String signatureMethode ="InsertTypeEtape - verifTypeLigne";

		return traitementAjax(PACK_INSERT_VALID_TYPELIGNE, signatureMethode, mapping, form, response, hParamProc);
	}
	
	private ActionForward traitementAjax(String cleProc, String signatureMethode, ActionMapping mapping, ActionForm form, HttpServletResponse response, Hashtable hParamProc) throws IOException {
		logBipUser.entry(signatureMethode);
		
		BipForm bipForm = (BipForm) form;
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut;
		ParametreProc paramOut;
		String message = "";
		TypeEtapeForm typeEtape = (TypeEtapeForm) form;
		hParamProc.put("type_ligne", typeEtape.getTypeLigne());
		// Appel de la procédure
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

}
