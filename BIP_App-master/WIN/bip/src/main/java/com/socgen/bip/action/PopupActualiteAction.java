package com.socgen.bip.action;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
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

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.PopupActualiteForm;
import com.socgen.bip.menu.item.BipItemMenu;
import com.socgen.bip.metier.InfosActualite;
import com.socgen.bip.user.UserBip;
import com.socgen.bip.util.BipStringUtil;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.ich.ihm.menu.PaginationVector;

/**
 * 
 * Action de mise à jour des Actualites chemin : Administration/Gestion des
 * actualites pages : bActuAd.jsp et mActuAd.jsp pl/sql : actualite.sql
 */
public class PopupActualiteAction extends AutomateAction implements BipConstantes {
	private static String PACK_LISTE = "alertes.actualites.liste.proc";
	private static String PACK_CONF_READ = "actualites.confirmation.lecture.proc";

	/**
	 * Méthode consulter : Affichage des données dont le tableau des proposés
	 */
	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParams) throws ServletException {
		Vector vParamOut = new Vector();
		String message = "";
		ParametreProc paramOut;
		Vector vListe = new Vector();
		int linesPerPage = 50;
		String signatureMethode = "PopupActualiteAction-suite(paramProc, mapping, form , request,  response,  errors )";

		// Récupération du form
		PopupActualiteForm popupActualiteForm = (PopupActualiteForm) form;

		// On exécute la procédure PL/SQL qui ramène les résultats pour le
		// tableau
	//	try {
			UserBip user = (UserBip) request.getSession().getAttribute("UserBip");
			hParams.put("userid", user.getIdUser());
			Vector vProfil = user.getListeMenu();
 			String sProfil = new String();
 			for (int i = 0; i < vProfil.size(); i++) {
 				// MenuIdBean oMenu= (MenuIdBean)vProfil.elementAt(i);
 				BipItemMenu bIMenu = (BipItemMenu) vProfil.elementAt(i);
 				// sProfil= sProfil+";"+oMenu.getNom();
 				sProfil = sProfil + ";" + bIMenu.getId();
 			}

 			hParams.put("profils",sProfil);
 			
 			System.out.print("\n consulter" +hParams.toString() );

 			JdbcBip jdbc = new JdbcBip();
			try {
				vParamOut = jdbc.getResult( hParams,configProc, PACK_LISTE);
			} catch (BaseException be) {
				logBipUser.debug("PopupActualiteAction-suite() --> BaseException :"
						+ be, be);
				logBipUser.debug("PopupActualiteAction-suite() --> Exception :"
						+ be.getInitialException().getMessage());

				logService.debug("PopupActualiteAction-suite() --> BaseException :"
						+ be, be);
				logService.debug("PopupActualiteAction-suite() --> Exception :"
						+ be.getInitialException().getMessage());

				if (be.getInitialException().getClass().getName().equals(
						"java.sql.SQLException")) {
					message = BipException.getMessageFocus(
							BipException.getMessageOracle(be.getInitialException()
									.getMessage()), form);
					popupActualiteForm.setMsgErreur(message);
					jdbc.closeJDBC();
					return mapping.findForward("initial");

				} else {
					// Erreur d''exécution de la procédure stockée
					errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
					request.setAttribute("messageErreur", be.getInitialException()
							.getMessage());
					jdbc.closeJDBC();
					return mapping.findForward("error");
				}

			}

			// Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();

					try {
						while (rset.next()) {
							// On alimente le Bean Actualite et on le stocke
							// dans un vector
							vListe.add(new InfosActualite(rset.getString(1), rset
									.getString(2), rset.getString(3), rset
									.getString(4), rset.getString(5), rset
									.getString(6)));
						}
						if (rset != null)
							rset.close();
						PaginationVector vueListe = new PaginationVector(
								vListe, linesPerPage);
						request.setAttribute(LISTE_RECHERCHE_ID, vueListe);
						(request.getSession(false)).setAttribute(
								LISTE_RECHERCHE_ID, vueListe);
						popupActualiteForm.setListePourPagination(vueListe);
						jdbc.closeJDBC();
					}// try
					catch (SQLException sqle) {
						logService
								.debug("PopupActualiteAction-suite() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("PopupActualiteAction-suite() --> SQLException :"
										+ sqle);
						// Erreur de lecture du resultSet
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11217"));
						jdbc.closeJDBC();
						return mapping.findForward("error");
					}
				}// if

			}// for
		

		logBipUser.exit(signatureMethode);

		return mapping.findForward("suite");

	}

	/**
	 * Method pageIndex.
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param errors
	 * @return ActionForward
	 * @throws ServletException
	 */
	protected ActionForward pageIndex(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors) throws ServletException {
		PaginationVector page;
		String pageName;
		String index;
		HttpSession session = request.getSession(false);
		ActionForward actionForward = null;

		// Extraction du nom de la page
		pageName = (String) request.getParameter("page");

		// Extraction de l'index
		index = (String) request.getParameter("index");

		page = (PaginationVector) session.getAttribute(pageName);

		if (page != null) {
			page.setBlock(Integer.parseInt(index));
			actionForward = mapping.findForward("suite");

		} else {
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
					"error.page.noninitialisee"));
			actionForward = mapping.findForward("error");

		}// else if

		return actionForward;

	}// pageIndex

	/**
	 * Action envoyée pour passer à la page suivante
	 * 
	 * @param request
	 *            la requête HTTP.
	 * @param response
	 *            la réponse HTTP.
	 */
	protected ActionForward pageSuivante(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors)
			throws ServletException {
		PaginationVector page;
		String pageName;
		HttpSession session = request.getSession(false);

		// Extraction du nom de la page
		pageName = (String) request.getParameter("page");
		page = (PaginationVector) session.getAttribute(pageName);

		if (page != null) {
			page.getNextBlock();
			return mapping.findForward("suite");

		} else {
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
					"error.page.noninitialisee"));
			this.saveErrors(request, errors);
			return mapping.findForward("error");
		}
	}

	/**
	 * Action envoyée pour passer à la page précédente
	 * 
	 * @param request
	 *            la requête HTTP.
	 * @param response
	 *            la réponse HTTP.
	 */
	protected ActionForward pagePrecedente(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors)
			throws ServletException {
		PaginationVector page;
		String pageName;

		// Extraction du nom de la page
		pageName = (String) request.getParameter("page");

		// Extraction de la liste à paginer
		page = (PaginationVector) request.getSession(false).getAttribute(
				pageName);

		if (page != null) {
			page.getPreviousBlock();
			return mapping.findForward("suite");
		} else {
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
					"error.page.noninitialisee"));
			this.saveErrors(request, errors);
			return mapping.findForward("error");
		}
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
	 * @return ActionForward
	 * @throws ServletException
	 * 
	 */


protected ActionForward creer(ActionMapping mapping, ActionForm form,
				HttpServletRequest request, HttpServletResponse response,
				ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		
		
		JdbcBip jdbc = new JdbcBip();
		Vector vParamOut = new Vector();
		String message = null;
		
		String signatureMethode = "creer(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors )";
		
		// On exécute la procédure stockée
		try {
			
			ArrayList stArray = BipStringUtil.getStringTokenized(((PopupActualiteForm) form).getCodes(),(new String("|")).charAt(0));
			String code_actu = "";
		    UserBip user = (UserBip) request.getSession().getAttribute("UserBip");
			for(int i = 0; i<stArray.size();i++)
			{
				code_actu=stArray.get(i).toString();
				
			    hParamProc.put("code_actu", code_actu);
			    hParamProc.put("userid", user.getIdUser());
				vParamOut = jdbc.getResult( hParamProc,configProc, PACK_CONF_READ);

			try {
				message = jdbc.recupererResult(vParamOut, "valider");

			} catch (BaseException be) {
				logBipUser.debug("valider() --> BaseException :" + be);
				logBipUser.debug("valider() --> Exception :"
						+ be.getInitialException().getMessage());
				System.out.print("valider() --> BaseException :" + be);
				System.out.print("valider() --> Exception :"
						+ be.getInitialException().getMessage());
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				jdbc.closeJDBC();
				return mapping.findForward("error");
			}

			if (message != null && !message.equals("")) {
				// on récupère le message
				((PopupActualiteForm) form).setMsgErreur(message);
				logBipUser.debug("valider() -->message :" + message);
			}
			}//fin while 
			user.setExisteAlerte("NON");
		} catch (BaseException be) {

			logBipUser.debug("valider() --> BaseException :" + be);
			logBipUser.debug("valider() --> Exception :"
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
				((PopupActualiteForm) form).setMsgErreur(message);

				//if (!mode.equals("delete")) {
				//	jdbc.closeJDBC(); return mapping.findForward("ecran");
				//}
			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				jdbc.closeJDBC(); 
				return mapping.findForward("error");
			}
		}

		logBipUser.exit(signatureMethode);
		jdbc.closeJDBC();
		return mapping.findForward("initial");

	}// fin creer
	
	protected String recupererCle(String mode) {
		String cle = null;
		if (mode.equals("update")) {
			cle = PACK_CONF_READ;
		} else {
			cle = PACK_LISTE;
		}

		  return cle;
	}
	
}