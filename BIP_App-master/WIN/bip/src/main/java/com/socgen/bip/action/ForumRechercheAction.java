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
import com.socgen.bip.form.ListeMsgForumForm;
import com.socgen.bip.menu.item.BipItemMenu;
import com.socgen.bip.metier.MessageForum;
import com.socgen.bip.user.UserBip;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.ich.ihm.menu.PaginationVector;

/**
 * @author JMA - 06/06/2006
 * 
 * Action gérant les listes de messages du forum
 * 
 * 
 */

public class ForumRechercheAction extends AutomateAction {

	private static String PACK_SELECT = "forum.recherche.proc";

	private int blocksize = 10;

	
	
	/**
	 * Constructor for ForumRechercheAction.
	 */
	public ForumRechercheAction() {
		super();
	}

	/**
	 * Action permettant le premier appel de la JSP
	 * 
	 */
	protected ActionForward initialiser(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;
		PaginationVector vueListe;
		Vector vListe = new Vector();
		HttpSession session = request.getSession(false);

		String signatureMethode = this.getClass().getName()
				+ " - initialiser(paramProc, mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);

		ListeMsgForumForm listeForumForm = (ListeMsgForumForm) form;

		UserBip userBip = (UserBip) (request.getSession(false))
				.getAttribute("UserBip");
		Vector v = userBip.getListeMenu();
		StringBuffer sb = new StringBuffer();
		for (Enumeration vE = v.elements(); vE.hasMoreElements();) {
			BipItemMenu bim = (BipItemMenu) vE.nextElement();
			sb.append(";" + bim.getId());
		}
		sb.append(";");
		listeForumForm.setListeMenu(sb.toString());
		listeForumForm.setMenu(userBip.getCurrentMenu().getId());
		listeForumForm.setChercheTexte("O");
		listeForumForm.setChercheTitre("O");

		logBipUser.exit(signatureMethode);

		 return mapping.findForward("initial");
	} // initialiser

	/**
	 * Action lançant la recherche
	 * 
	 */
	public ActionForward recherche(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;
		PaginationVector vueListe;
		Vector vListe = new Vector();
		HttpSession session = request.getSession(false);

		String signatureMethode = this.getClass().getName()
				+ " - recherche(paramProc, mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);

		ListeMsgForumForm listeForumForm = (ListeMsgForumForm) form;

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
						boolean next = false;
						while (rset.next()) {
							vListe.add(new MessageForum(rset.getInt(1), rset
									.getInt(2), rset.getString(3), rset
									.getString(4), rset.getString(5), rset
									.getString(6), rset.getString(7), rset
									.getString(8), rset.getString(9), rset
									.getString(10), rset.getString(11), rset
									.getString(12), rset.getString(13), rset
									.getString(14), rset.getString(15), rset
									.getInt(17), rset.getString(18), rset
									.getString(16)));
							listeForumForm.setMsgErreur(null);
						}
					} // try
					catch (SQLException sqle) {
						logService.debug(this.getClass().getName()
								+ "-recherche() --> SQLException :" + sqle);
						logBipUser.debug(this.getClass().getName()
								+ "-recherche() --> SQLException :" + sqle);
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
											+ "-recherche() --> SQLException-rset.close() :"
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
				listeForumForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}

		} // try
		catch (BaseException be) {
			logBipUser.debug(this.getClass().getName()
					+ "-recherche() --> BaseException :" + be, be);
			logBipUser.debug(this.getClass().getName()
					+ "-recherche() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug(this.getClass().getName()
					+ "-recherche() --> BaseException :" + be, be);
			logService.debug(this.getClass().getName()
					+ "-recherche() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((ListeMsgForumForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}

		// si listeForumForm.getBlocksize() n'est pas nul c'est qu'on est déjà
		// dans une requête liste Forum
		if (listeForumForm.getBlocksize() != null)
			blocksize = Integer.parseInt(listeForumForm.getBlocksize());
		else {
			// si on a déjà une liste de message de forum en session c'est qu'on
			// est déjà aller dans une page
			// de liste du forum donc on va récupérer le blocksize en session
			// afin que la list de valeur
			// nb de ligne par page soit cohérente avec la liste affichée
			if (session.getAttribute(MESSAGE_FORUM) != null) {
				PaginationVector currentPV = (PaginationVector) session
						.getAttribute(MESSAGE_FORUM);
				blocksize = currentPV.getBlockSize();
				listeForumForm.setBlocksize(Integer.toString(blocksize));
			}
		}

		// Construire un PaginationVector contenant les informations du FormBean
		vueListe = new PaginationVector(vListe, blocksize);
		// Stocker le résultat dans la session
		session.setAttribute(MESSAGE_FORUM, vueListe);
		// probleme memoire
		//hParamProc = null;
		//Tools.forceFullGarbageCollection();
		// Stocker le résultat dans le formulaire
		listeForumForm.setListePourPagination(vueListe);

		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	} // recherche

}