package com.socgen.bip.action;

import java.io.IOException;
import java.net.URLDecoder;
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
import com.socgen.bip.commun.bd.ParametreBD;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.ListeFavorisForm;
import com.socgen.bip.metier.Favori;
import com.socgen.bip.user.UserBip;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author JMA - 03/03/2006
 * 
 * Action permettant d'ajouter un favori à partir de d'une fenêtre Popup
 * 
 * 
 */

public class ListeFavorisAction extends AutomateAction {

	private static String PACK_SELECT = "favoris.liste.proc";

	private static String PACK_DELETE = "favoris.delete.proc";

	private static String PACK_MODIF_ORDRE = "favoris.modifordre.proc";
	//PPM 57865
	private static String PACK_ISAC_FAVORIS = "favoris.ressource.proc";
	// Nom de la page d'accueil
	public static final String PAGE_ACCUEIL = "frameAccueil.jsp";
	
	
	
	/**
	 * Constructor for ListeFavorisAction.
	 */
	public ListeFavorisAction() {
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
		boolean msg = false;
		ParametreProc paramOut;
		
		String signatureMethode = this.getClass().getName()
				+ " - initialiser(paramProc, mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);
		ListeFavorisForm favForm = (ListeFavorisForm) form;
		
		String message = "";
		// exécution de la procédure PL/SQL
		try {
			hParamProc.put("menu", "" );
			hParamProc.put("p_userid", userBip.getInfosUser());
			
			//PPM 57865 debut KRA
			HttpSession session = request.getSession(false);
			//String choix = (String)session.getAttribute("CHOIXRESS");
			//Si le paramètre est null, premier chargement de la page, on cherche s'il y a des favoris
		
			boolean isRessourceFavoris = isRessourceFavoris(hParamProc, form, errors);
			
			if(isRessourceFavoris == true){
				session.setAttribute("CHOIXRESS", "2");
			}else{
				session.setAttribute("CHOIXRESS", "1");
			}
			//PPM 57865 Fin KRA
			
			vParamOut = jdbc.getResult(hParamProc, configProc, PACK_SELECT);
			
			// Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				logBipUser.debug("dans enum vparamout" );
				
				// récupérer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();
				}

				
				
				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();

					
					
					try {
						while (rset.next()) {
							Favori fav = new Favori(rset.getString(1), rset
									.getString(2), rset.getInt(3), rset
									//ABN - HP PPM 63875
									.getString(4), URLDecoder.decode(rset.getString(5)), rset
									.getString(6));
							favForm.setMsgErreur(null);
							favForm.addFavori(fav.getType(), fav);
						}
						
					} // try
					catch (SQLException sqle) {
						logService.debug(this.getClass().getName()
								+ "-initialiser() --> SQLException :" + sqle);
						logBipUser.debug(this.getClass().getName()
								+ "-initialiser() --> SQLException :" + sqle);
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
									.debug(this.getClass().getName()
											+ "-initialiser() --> SQLException-rset.close() :"
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
				favForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}

			
		} // try
		catch (BaseException be) {
			logBipUser.debug(this.getClass().getName()
					+ "-initialiser() --> BaseException :" + be, be);
			logBipUser.debug(this.getClass().getName()
					+ "-initialiser() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug(this.getClass().getName()
					+ "-initialiser() --> BaseException :" + be, be);
			logService.debug(this.getClass().getName()
					+ "-initialiser() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((ListeFavorisForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			} else {
				// Erreur d''exécution de la procédure stockée
				
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}
		
		try
		{
			
			if (("BLOQUEE".equals(ParametreBD.getValeur("ETAT_BIP"))) &&
				(!userBip.habiliteMenu("DIR"))) 
			{
				try
				{
					response.sendRedirect(request.getContextPath()+"/" + PAGE_ACCUEIL + "?bloquee=O");
					
				}
				catch (IOException io)
				{
					
					logBipUser.debug(this.getClass().getName()
							+ "-initialiser() BIP BLOQUEE -->Problème lors de la redirection vers la page d'accueil :");
					 jdbc.closeJDBC(); return mapping.findForward("initial");
				}
			}
		}
		catch (BaseException be)
		{
			
			logBipUser.debug(this.getClass().getName()
					+ "-initialiser() BIP BLOQUEE --> Exception :"
					+ be.getInitialException().getMessage());
			 jdbc.closeJDBC(); return mapping.findForward("initial");
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
		

		
		
		
		String signatureMethode = this.getClass().getName()
				+ " - consulter( mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);

		ListeFavorisForm favForm = (ListeFavorisForm) form;

		// Suppression d'un favori
		if (favForm.getMode().equals("delete")) {
			// exécution de la procédure PL/SQL
			try {
				vParamOut = jdbc.getResult(
						hParamProc, configProc, PACK_DELETE);
				try {
					message = jdbc.recupererResult(vParamOut, "valider");
				} catch (BaseException be) {
					logBipUser.debug(this.getClass().getName()
							+ "-consulter() --> BaseException :" + be);
					logBipUser.debug(this.getClass().getName()
							+ "-consulter() --> Exception :"
							+ be.getInitialException().getMessage());
					logService.debug(this.getClass().getName()
							+ "-consulter() --> BaseException :" + be);
					logService.debug(this.getClass().getName()
							+ "-consulter() --> Exception :"
							+ be.getInitialException().getMessage());
					// Erreur de lecture du resultSet
					errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
							"11217"));
					// this.saveErrors(request,errors);
					 jdbc.closeJDBC(); return mapping.findForward("error");
				}
				if ((message != null) && (!message.equals(""))) {
					// Entité déjà existante, on récupère le message
					((ListeFavorisForm) form).setMsgErreur(message);
					logBipUser.debug("message d'erreur:" + message);
					logBipUser.exit(signatureMethode);
					// on reste sur la même page
					 jdbc.closeJDBC(); return mapping.findForward("initial");
				}
			} // try
			catch (BaseException be) {
				logBipUser.error(this.getClass().getName()
						+ "-consulter() --> BaseException :" + be);
				logBipUser.error(this.getClass().getName()
						+ "-consulter() --> Exception :"
						+ be.getInitialException().getMessage());
				logService.error(this.getClass().getName()
						+ "-consulter() --> BaseException :" + be);
				logService.error(this.getClass().getName()
						+ "-consulter() --> Exception :"
						+ be.getInitialException().getMessage());
				// Si exception sql alors extraire le message d'erreur du
				// message global
				if (be.getInitialException().getClass().getName().equals(
						"java.sql.SQLException")) {
					message = BipException.getMessageFocus(BipException
							.getMessageOracle(be.getInitialException()
									.getMessage()), form);
					((ListeFavorisForm) form).setMsgErreur(message);
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
			}
		}

		// Modification de l'ordre d'un favori
		if (favForm.getMode().equals("update")) {
			// exécution de la procédure PL/SQL
			try {
				vParamOut = jdbc.getResult(
						hParamProc, configProc, PACK_MODIF_ORDRE);
				try {
					message = jdbc.recupererResult(vParamOut, "valider");
				} catch (BaseException be) {
					logBipUser.debug(this.getClass().getName()
							+ "-consulter() --> BaseException :" + be);
					logBipUser.debug(this.getClass().getName()
							+ "-consulter() --> Exception :"
							+ be.getInitialException().getMessage());
					logService.debug(this.getClass().getName()
							+ "-consulter() --> BaseException :" + be);
					logService.debug(this.getClass().getName()
							+ "-consulter() --> Exception :"
							+ be.getInitialException().getMessage());
					// Erreur de lecture du resultSet
					errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
							"11217"));
					// this.saveErrors(request,errors);
					 jdbc.closeJDBC(); return mapping.findForward("error");
				}
				if ((message != null) && (!message.equals(""))) {
					// Entité déjà existante, on récupère le message
					((ListeFavorisForm) form).setMsgErreur(message);
					logBipUser.debug("message d'erreur:" + message);
					logBipUser.exit(signatureMethode);
					// on reste sur la même page
					 jdbc.closeJDBC(); return mapping.findForward("initial");
				}
			} // try
			catch (BaseException be) {
				logBipUser.error(this.getClass().getName()
						+ "-consulter() --> BaseException :" + be);
				logBipUser.error(this.getClass().getName()
						+ "-consulter() --> Exception :"
						+ be.getInitialException().getMessage());
				logService.error(this.getClass().getName()
						+ "-consulter() --> BaseException :" + be);
				logService.error(this.getClass().getName()
						+ "-consulter() --> Exception :"
						+ be.getInitialException().getMessage());
				// Si exception sql alors extraire le message d'erreur du
				// message global
				if (be.getInitialException().getClass().getName().equals(
						"java.sql.SQLException")) {
					message = BipException.getMessageFocus(BipException
							.getMessageOracle(be.getInitialException()
									.getMessage()), form);
					((ListeFavorisForm) form).setMsgErreur(message);
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
			}
		}

		logBipUser.exit(signatureMethode);
		jdbc.closeJDBC(); return initialiser(mapping, form, request, response, errors, hParamProc);
	} // consulter

	/**
	 * Action qui permet de changer de menu dans la navigation inter-menu
	 */
	public ActionForward goToFavori(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

	
		String signatureMethode = this.getClass().getName()
				+ " - goToFavori( mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);

		ListeFavorisForm favForm = (ListeFavorisForm) form;

		// Mise à jour de l'utilisateur avec le nouveau menu
		UserBip user = (UserBip) request.getSession().getAttribute("UserBip");

		// Teste si on est habilité sur le menu
		if (user.habiliteMenu(favForm.getMenu()) == false) {

			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("20002"));
			return mapping.findForward("initial");
		}

		// Mise à jour dans userBip du lien sélectionné
		user.setCurrentMenu(favForm.getMenu());
		user.setLienFavori(favForm.getLien());

		logBipUser.exit(signatureMethode);

		 return mapping.findForward("suite");
	} // goToFavori

	//PPM 57865 debut
	/**
	 * Action permettant de vérifier si la ressource a déjà paramétré des favoris
	 * 
	 */
	protected boolean isRessourceFavoris(Hashtable hParamProc, ActionForm form, ActionErrors errors) {

		JdbcBip jdbc = new JdbcBip(); 
		
		Vector vParamOut = new Vector();
		boolean result = false;
		ParametreProc paramOut;
		
		String signatureMethode = this.getClass().getName()
				+ " - isRessourceFavoris(paramProc, form, errors)";
		logBipUser.entry(signatureMethode);		
		
		String message = "";
		// execution de la procedure PL/SQL
		try {
			hParamProc.put("idarpege", userBip.getIdUser() );
			vParamOut = jdbc.getResult(hParamProc, configProc, PACK_ISAC_FAVORIS);
			
			// Recuperation des resultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				logBipUser.debug("dans enum vparamout" );
				
				// recuperer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();
				}
				// recuperer le resultat
				if (paramOut.getNom().equals("result")) {
					String resultat = (String) paramOut.getValeur();
					if("true".equals(resultat)){
						result = true;
					}else{
						result = false;
					}
				}			
				
			} // for			
		} // try
		catch (BaseException be) {
			logBipUser.debug(this.getClass().getName()
					+ "-isRessourceFavoris() --> BaseException :" + be, be);
			logBipUser.debug(this.getClass().getName()
					+ "-isRessourceFavoris() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug(this.getClass().getName()
					+ "-isRessourceFavoris() --> BaseException :" + be, be);
			logService.debug(this.getClass().getName()
					+ "-isRessourceFavoris() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((ListeFavorisForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return result;
			} else {
				// Erreur d execution de la procedure stockee
				
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));				
				jdbc.closeJDBC(); return result;
			}
		}
						
		logBipUser.exit(signatureMethode);
		
		 jdbc.closeJDBC(); return result;
	}
	
	//Fin PPM 57865
	
}