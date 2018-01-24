package com.socgen.bip.action;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.EbisFactRejetForm;
import com.socgen.bip.metier.EbisFactRejet;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.ich.ihm.menu.PaginationVector;

/**
 * @author N.BACCAM - 18/06/2003
 * 
 * Formulaire pour mise à jour des Taux de récupération chemin :
 * Administration/Tables/ mise à jour/Taux de récupération pages :
 * fmTauxrecAd.jsp et mTauxrecAd.jsp pl/sql : Txrecup.sql
 */
public class EbisFactRejetAction extends AutomateAction {

	private static String PACK_SELECT = "ebis.factures.rejet.consulter.proc";

	private static String PACK_UPDATE = "ebis.factures.rejet.modifier.proc";

	private String nomProc;
	
	private int blocksize = 10;
	

	/**
	 * Action qui permet de visualiser les données liées aux facture rejete EBIS
	 * consultation
	 */
	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vListe = new Vector();
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;
		int compteur = 0;
		int linesPerPage = 10;

		String signatureMethode = "EbisFactRejetAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		EbisFactRejetForm bipForm = (EbisFactRejetForm) form;
		hParamProc.put("mode", "update");

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

				if (paramOut.getNom().equals("curseur")) {		
						
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();

					try {
						logService.debug("ResultSet");
						while (rset.next()) {

						vListe.add( new EbisFactRejet (rset.getString(1),
														   rset.getString(2),
														   rset.getString(3),
														   rset.getString(4),
														   rset.getString(5),
														   rset.getString(6),
														   rset.getString(7),
														   rset.getString(8)));
							// bipForm.setFlaglock(rset.getInt(5));
							bipForm.setMsgErreur(null);
						
						compteur ++;	
						}
						//rset.close();	
						//msg = true;
						PaginationVector vueListe = new  PaginationVector(vListe,linesPerPage);								  
						request.setAttribute(LISTE_RECHERCHE_ID, vueListe); 
						(request.getSession(false)).setAttribute(LISTE_RECHERCHE_ID, vueListe );								  
						bipForm.setListePourPagination(vueListe);

					}// try
					catch (SQLException sqle) {
						logService
								.debug("EbisFactRejetAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("EbisFactRejetAction-consulter() --> SQLException :"
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
									.debug("EbisFactRejetAction-consulter()  --> SQLException-rset.close() :"
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
				// bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		}// try
		catch (BaseException be) {
			logBipUser.debug("EbisFactRejetAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("EbisFactRejetAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("EbisFactRejetAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("EbisFactRejetAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((EbisFactRejetForm) form).setMsgErreur(message);
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
	 * Méthode valider : Met à jour le top etat des facture rejete
	 */
	protected ActionForward valider(ActionMapping mapping, ActionForm form,
			String mode, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors,
			Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";

		StringBuffer sbChaine = new StringBuffer();
		HttpSession session = request.getSession(false);
		String signatureMethode = "EbisFactRejetAction-valider()";
		logBipUser.entry(signatureMethode);
		logBipUser
				.debug("fmemory start : " + Runtime.getRuntime().freeMemory());
		try {
			//On sauvegarde les données du formulaire
			savePage(mapping, form, request, response, errors);
			
			PaginationVector page = (PaginationVector) session
			.getAttribute(LISTE_RECHERCHE_ID);
			
			// On sauvegarde les données du formulaire
			savePage(mapping, form, request, response, errors);

			EbisFactRejetForm bipForm = (EbisFactRejetForm) form;
			
			//on concatene toute les facture dans une chaine
			int i = 0;
			for (Enumeration e = page.elements(); e.hasMoreElements();) {
				EbisFactRejet EbisRejet= (EbisFactRejet) e.nextElement();
				i++;

				sbChaine.append(EbisRejet.getNumenr() + ":");
				sbChaine.append(EbisRejet.getTopetat()+ ";" );
				//ABN - HP PPM 58101
				if (sbChaine != null && !sbChaine.equals("") && sbChaine.length() > 30000) {
					// Ajouter la chaine dans la hashtable des paramètres
					hParamProc.put("string", sbChaine.toString());
					// on exécute la procedure PLSQL qui met à jour les proposés
					try {
						vParamOut = jdbc.getResult(
								hParamProc, configProc, PACK_UPDATE);
					} // try
					catch (BaseException be) {
						logBipUser
								.debug(
										"EbisFactRejetAction-consulter() --> BaseException :"
												+ be, be);
						logBipUser.debug("EbisFactRejetAction-consulter() --> Exception :"
								+ be.getInitialException().getMessage());
						logService
								.debug(
										"EbisFactRejetAction-consulter() --> BaseException :"
												+ be, be);
						logService.debug("EbisFactRejetAction-consulter() --> Exception :"
								+ be.getInitialException().getMessage());
						if (be.getInitialException().getClass().getName().equals(
								"java.sql.SQLException")) {
							message = BipException.getMessageFocus(BipException
									.getMessageOracle(be.getInitialException()
											.getMessage()), form);
							((EbisFactRejetForm) form).setMsgErreur(message);
							 jdbc.closeJDBC(); return mapping.findForward("ecran");
						} else {
							// Erreur d'exécution de la procédure stockée
							errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
									"11201"));
							request.setAttribute("messageErreur", be
									.getInitialException().getMessage());
							 jdbc.closeJDBC(); return mapping.findForward("error");
						}
					}
					//annuler la mise à jour
					if (vParamOut == null) {
						session.setAttribute("errorUpdate", "UPDATE");
						logBipUser.debug("!!! update cancelled ");
					} else {
						// on sauvegarde en session la date de debut
						session.setAttribute("datfactdebut", bipForm.getDatfactdebut());
						// on sauvegarde en session la date de fin
						session.setAttribute("datfactfin", bipForm.getDatfactfin());
						// on sauvegarde en session le topetat
						session.setAttribute("topetat", bipForm.getTopetat());
					}
					
					sbChaine = new StringBuffer(); 
				}
			
			
			
		} // for
			
			if (sbChaine != null && !sbChaine.equals("") && sbChaine.length() > 0) {
				// Ajouter la chaine dans la hashtable des paramètres
				hParamProc.put("string", sbChaine.toString());
				// on exécute la procedure PLSQL qui met à jour les proposés
				try {
					vParamOut = jdbc.getResult(
							hParamProc, configProc, PACK_UPDATE);
				} // try
				catch (BaseException be) {
					logBipUser
							.debug(
									"EbisFactRejetAction-consulter() --> BaseException :"
											+ be, be);
					logBipUser.debug("EbisFactRejetAction-consulter() --> Exception :"
							+ be.getInitialException().getMessage());
					logService
							.debug(
									"EbisFactRejetAction-consulter() --> BaseException :"
											+ be, be);
					logService.debug("EbisFactRejetAction-consulter() --> Exception :"
							+ be.getInitialException().getMessage());
					if (be.getInitialException().getClass().getName().equals(
							"java.sql.SQLException")) {
						message = BipException.getMessageFocus(BipException
								.getMessageOracle(be.getInitialException()
										.getMessage()), form);
						((EbisFactRejetForm) form).setMsgErreur(message);
						 jdbc.closeJDBC(); return mapping.findForward("ecran");
					} else {
						// Erreur d'exécution de la procédure stockée
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11201"));
						request.setAttribute("messageErreur", be
								.getInitialException().getMessage());
						 jdbc.closeJDBC(); return mapping.findForward("error");
					}
				}
				//annuler la mise à jour
				if (vParamOut == null) {
					session.setAttribute("errorUpdate", "UPDATE");
					logBipUser.debug("!!! update cancelled ");
				} else {
					// on sauvegarde en session la date de debut
					session.setAttribute("datfactdebut", bipForm.getDatfactdebut());
					// on sauvegarde en session la date de fin
					session.setAttribute("datfactfin", bipForm.getDatfactfin());
					// on sauvegarde en session le topetat
					session.setAttribute("topetat", bipForm.getTopetat());
				}
				
			}
			
			//On détruit le tableau sauvegardé en session
			session.removeAttribute(LISTE_RECHERCHE_ID);
			
		} catch (Exception e) {
			logBipUser.debug(signatureMethode + " --> exception : "
					+ e.getMessage());
			// Erreur d''exécution
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11209"));
			this.saveErrors(request, errors);
		}
		// probleme de memoire
		hParamProc = null;
		logBipUser.debug("fmemory end : " + Runtime.getRuntime().freeMemory());
		logBipUser.exit(signatureMethode);
		jdbc.closeJDBC(); return mapping.findForward("initial");
	} // valider
	
	/**
	 * Méthode savePage : Sauvegarde des écarts
	 */
	protected void savePage(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors) {

		HttpSession session = request.getSession(false);
		PaginationVector page = (PaginationVector) session.getAttribute(LISTE_RECHERCHE_ID);
		String libTopetat;
		String libNumEnr;
		
		Class[] parameterString = { String.class };
		String signatureMethode = "EbisFactRejet-savePage()";
		logBipUser.entry(signatureMethode);

		// Sauvegarde du total par mois de la page précédente
		EbisFactRejetForm bipForm = ((EbisFactRejetForm) form);

		try {
			// récupérer les champs modifiables
			for (int i = 1; i <= blocksize; i++) {

				libTopetat = "lib_topetat_" + i;
				libNumEnr="lib_numenr_"+ i;

				for (Enumeration e = page.elements(); e.hasMoreElements();) {

					EbisFactRejet EbisRejet = (EbisFactRejet) e.nextElement();

					if (request.getParameter(libTopetat)!=null) {
						if ((request.getParameter(libNumEnr)).equals(EbisRejet.getNumenr()) ) {
								EbisRejet.setTopetat(request
										.getParameter(libTopetat));
								
								
						}
					}
				} // for
			} // for
		} catch (NullPointerException npe) {
			logBipUser.debug("EcartsAction-savePage-->!!! valeur null dans : "
					+ npe.getMessage());
			// Erreur d''exécution
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11209"));
			this.saveErrors(request, errors);
		} catch (SecurityException se) {
			// Erreur d''exécution
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11209"));
			this.saveErrors(request, errors);
		} catch (IllegalArgumentException iae) {
			logBipUser.debug("arguments null : " + iae.getMessage());
			// Erreur d''exécution
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11209"));
			this.saveErrors(request, errors);
		}

		(request.getSession()).setAttribute(LISTE_RECHERCHE_ID, page);

		logBipUser.exit(signatureMethode);

	} // savePage
	
	protected String recupererCle(String mode) {
		String cle = null;
		if (mode.equals("update")) {
			cle = PACK_UPDATE;
		} 
		  return cle;
	}

}
