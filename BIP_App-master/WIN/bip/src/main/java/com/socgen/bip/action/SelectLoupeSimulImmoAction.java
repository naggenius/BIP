package com.socgen.bip.action;

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

import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.SelectLoupeSimulImmoForm;
import com.socgen.bip.form.TypeEtapeForm;
import com.socgen.bip.metier.LoupeSimulImmo;
import com.socgen.cap.fwk.exception.BaseException;

public class SelectLoupeSimulImmoAction  extends AutomateAction implements BipConstantes {
	
	private static String PACK_SELECT = "simul_immo.loupe.consulter.proc";
	
	private static String PACK_UPDATE = "simul_immo.loupe.modifier.proc";
	
	/**
	 * Action qui permet de visualiser les axes stratégiques d'un utilisateur pour la fonction de simulation de calcul Immo du menu REF
	 * pour la modification et la suppression
	 */
	

	
	protected ActionForward initialiser(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip();
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;
		int cpt = 0;

		
		
		
		String signatureMethode = "SelectLoupeSimulImmoAction-consulter(paramProc, mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);
		
		SelectLoupeSimulImmoForm  bipform = (SelectLoupeSimulImmoForm)form;
				
		logService
		.debug("AAAAAAAAAAAAAAAAZZZZZZZZZZZZZZZZZZZZZzzzzz"+bipform.getContexte());
		
		//bipform.reset();
		
//		 exécution de la procédure PL/SQL
		try {
			vParamOut = jdbc.getResult(hParamProc, configProc, PACK_SELECT);

			// Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();
		
//				 récupérer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();
				}

				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();

					try {
						logService.debug("ResultSet");
						ArrayList<LoupeSimulImmo> valeur_loupe = new ArrayList<LoupeSimulImmo>();
						while (rset.next()) {
							valeur_loupe.add(new LoupeSimulImmo(rset.getString(1),rset.getString(2), rset
									.getString(3)));
							cpt++;
						}
						bipform.setValeur_loupe(valeur_loupe);
					}
						catch (SQLException sqle) {
							logService
									.debug("SelectLoupeSimulImmoAction-consulter() --> SQLException :"
											+ sqle);
							logBipUser
									.debug("SelectLoupeSimulImmoAction-consulter() --> SQLException :"
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
										.debug("SelectLoupeSimulImmoAction-consulter() --> SQLException-rset.close() :"
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
				
			}
			catch (BaseException be) {
				logBipUser.debug("SelectLoupeSimulImmoAction-consulter() --> BaseException :"
						+ be, be);
				logBipUser.debug("SelectLoupeSimulImmoAction-consulter() --> Exception :"
						+ be.getInitialException().getMessage());

				logService.debug("SelectLoupeSimulImmoAction-consulter() --> BaseException :"
						+ be, be);
				logService.debug("SelectLoupeSimulImmoAction-consulter() --> Exception :"
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
	
	protected ActionForward valider(ActionMapping mapping, ActionForm form,
			String mode, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors,
			Hashtable hParamProc) throws ServletException {
		Vector vParamOut = new Vector();
		String cle = null;
		String message = null;
		StringBuffer chaine_loupe = new StringBuffer();
		
		String signatureMethode = "valider(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors )";
		logBipUser.entry(signatureMethode);
		logBipUser.debug("mode de mise à jour:" + mode);
		
		JdbcBip jdbc1 = new JdbcBip();

		SelectLoupeSimulImmoForm  bipform = (SelectLoupeSimulImmoForm)form;
			
		Iterator<LoupeSimulImmo> it = bipform.getValeur_loupe().iterator();
		while (it.hasNext()) {
			LoupeSimulImmo te = it.next();
			if ("1".equals(te.getSelect()))
				chaine_loupe = chaine_loupe.append(te.getNumero()+":");
		}
		if (chaine_loupe.length() != 0)
			chaine_loupe = chaine_loupe.deleteCharAt(chaine_loupe.length()-1);
		logBipUser.debug("chaine_loupe" + chaine_loupe.toString());
		hParamProc.put("chaine_loupe", chaine_loupe.toString());
	
		// On exécute la procédure stockée
		try {

			vParamOut = jdbc1.getResult(hParamProc, configProc, PACK_UPDATE);

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
				bipform.setMsgErreur(message);
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
				bipform.setMsgErreur(message);

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
	}
