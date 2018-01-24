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

public class ForumDiscussionAction extends AutomateAction {

	private static String PACK_SELECT = "forum.liste.proc";

	private static String PACK_VALIDER = "forum.validerrejet.proc";

	private static String PACK_DELETE = "forum.delete.proc";

	private int blocksize = 10;
	


	/**
	 * Constructor for ForumDiscussionAction.
	 */
	public ForumDiscussionAction() {
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

		if ((listeForumForm.getParent_id() == null)
				|| (listeForumForm.getParent_id().length() == 0)) {
			if ((request.getParameter("parent_id") != null)
					&& (request.getParameter("parent_id").length() > 0))
				listeForumForm.setParent_id(request.getParameter("parent_id"));
			else
				listeForumForm.setParent_id(request.getParameter("id"));
		}

		// exécution de la procédure PL/SQL
		try {
			hParamProc.put("menu", userBip.getCurrentMenu().getId());
			hParamProc.put("listeMenu", sb.toString());
			if (listeForumForm.getParent_id() != null)
				hParamProc.put("parent_id", listeForumForm.getParent_id());
			if (listeForumForm.getTypeEcran().equals("MesMessages")
					|| listeForumForm.getTypeEcran().equals("recherche")
					|| listeForumForm.getTypeEcran().equals("rechercheAvancee")) {
				hParamProc.put("tri", "MesMessagesDiscussion");
			} else {
				hParamProc.put("tri", "DATE_MSG");
			}
			if ((request.getParameter("typeEcran") != null)
					&& (request.getParameter("typeEcran").equals("MsgAValider"))) {
				hParamProc.put("tri", "MsgAValider");
			}
			if ((request.getParameter("typeEcran") != null)
					&& (request.getParameter("typeEcran").equals("MsgRejeter"))) {
				hParamProc.put("tri", "MsgRejeter");
			}
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
				listeForumForm.setMsgErreur(message);
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
			if (session.getAttribute(DISCUSSION_FORUM) != null) {
				PaginationVector currentPV = (PaginationVector) session
						.getAttribute(DISCUSSION_FORUM);
				blocksize = currentPV.getBlockSize();
				listeForumForm.setBlocksize(Integer.toString(blocksize));
			}
		}

		Vector vSujet = new Vector();
		if ((request.getParameter("typeEcran") == null)
				|| ((!request.getParameter("typeEcran").equals("MsgAValider")) && (!request
						.getParameter("typeEcran").equals("MsgRejeter")))) {
			// ajout du sujet et tri dans le cas d'un affichage de discussion
			vSujet.add(vListe.get(0));
			vListe = trierListe(construitTable(vListe), vSujet, -1);
		}
		if ((request.getParameter("typeEcran") != null)
				&& (request.getParameter("typeEcran")
						.equals("rechercheAvancee"))) {
			listeForumForm.setParent_id(Integer.toString(((MessageForum) vListe
					.get(0)).getId()));
		}

		// Construire un PaginationVector contenant les informations du FormBean
		vueListe = new PaginationVector(vListe, blocksize);
		// Stocker le résultat dans la session
		session.setAttribute(DISCUSSION_FORUM, vueListe);
		// probleme memoire
		//hParamProc = null;
		//Tools.forceFullGarbageCollection();
		// Stocker le résultat dans le formulaire
		listeForumForm.setListePourPagination(vueListe);

		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	}

	/**
	 * Action qui redirige vers l'écran liste des sujets
	 */
	public ActionForward retour(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;

		String signatureMethode = this.getClass().getName()
				+ " - retour( mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);

		ListeMsgForumForm listeForumForm = (ListeMsgForumForm) form;

		String retour = "retour";
		if ((listeForumForm.getTypeEcran() != null)
				&& (listeForumForm.getTypeEcran().equals("rechercheAvancee"))) {
			retour = "retourRechAv";
		}
		logBipUser.debug("Retour  : " + retour);

		logBipUser.exit(signatureMethode);

		return mapping.findForward(retour);
	} // retour

	/**
	 * Action qui redirige vers l'écran motif du rejet
	 */
	public ActionForward rejetInit(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;

		String signatureMethode = this.getClass().getName()
				+ " - rejetInit( mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);

		logBipUser.exit(signatureMethode);

		return mapping.findForward("rejet");
	} // rejetInit

	/**
	 * Action qui enregistre le motif du rejet
	 */
	public ActionForward rejeter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;

		String signatureMethode = this.getClass().getName()
				+ " - rejeter( mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);

		// exécution de la procédure PL/SQL
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_VALIDER);
			try {
				message = jdbc.recupererResult(vParamOut, "valider");
			} catch (BaseException be) {
				logBipUser.debug(this.getClass().getName()
						+ "-rejeter() --> BaseException :" + be);
				logBipUser.debug(this.getClass().getName()
						+ "-rejeter() --> Exception :"
						+ be.getInitialException().getMessage());
				logService.debug(this.getClass().getName()
						+ "-rejeter() --> BaseException :" + be);
				logService.debug(this.getClass().getName()
						+ "-rejeter() --> Exception :"
						+ be.getInitialException().getMessage());
				// Erreur de lecture du resultSet
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		} // try
		catch (BaseException be) {
			logBipUser.error(this.getClass().getName()
					+ "-rejeter() --> BaseException :" + be);
			logBipUser.error(this.getClass().getName()
					+ "-rejeter() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.error(this.getClass().getName()
					+ "-rejeter() --> BaseException :" + be);
			logService.error(this.getClass().getName()
					+ "-rejeter() --> Exception :"
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
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}

		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("rejet");
	} // rejeter

	/**
	 * Fonction permettant de trier un vecteur de message suivant le tri
	 * ci-dessous
	 * 
	 * Sujet Réponse 1 Réponse 2 Réponse 2.1 Réponse 2.1 Réponse 3
	 * 
	 */
	private Vector trierListe(Hashtable h, Vector vListe, int tab) {
		Vector result = new Vector();

		for (int i = 0; i < vListe.size(); i++) {
			MessageForum mf = (MessageForum) vListe.elementAt(i);
			mf.setTab(tab);
			result.add(mf);

			// recherche si le message courant à des enfants
			if (h.containsKey(new Integer(mf.getId()))) {
				// appel du tri avec le vector des enfants
				Vector resultEnfant = trierListe(h, (Vector) h.get(new Integer(
						mf.getId())), tab + 1);
				for (Enumeration vE = resultEnfant.elements(); vE
						.hasMoreElements();) {
					result.add(vE.nextElement());
				}
			}
		}

		 return result;
	}

	/**
	 * Fonction contruisant une table : clé : id parent objet : liste des id
	 * ayant comme parent la clé
	 * 
	 */
	private Hashtable construitTable(Vector v) {
		Hashtable h = new Hashtable();
		Vector vt = null;
		for (Enumeration vE = v.elements(); vE.hasMoreElements();) {
			MessageForum mf = (MessageForum) vE.nextElement();
			if (h.containsKey(new Integer(mf.getParent_id()))) {
				vt = (Vector) h.get(new Integer(mf.getParent_id()));
				vt.add(mf);
			} else {
				vt = new Vector();
				vt.add(mf);
			}
			h.put(new Integer(mf.getParent_id()), vt);
		}
		return h;
	}

	/**
	 * Fonction loggant le vecteur des messages (id séparé par des virgules)
	 * 
	 */
	private void logVector(Vector v) {
		StringBuffer log = new StringBuffer();
		for (Enumeration vE = v.elements(); vE.hasMoreElements();) {
			MessageForum mf = (MessageForum) vE.nextElement();
			log.append(mf.getId() + " ,");
		}
		logBipUser.debug("Vector = [" + log.toString() + "]");
	}

	private void logVector(Vector v, String chaine) {
		logBipUser.debug(chaine);
		logVector(v);
	}

	/**
	 * Action qui valide un message
	 */
	public ActionForward validerMsg(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;

		String signatureMethode = this.getClass().getName()
				+ " - validerMsg( mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);

		ListeMsgForumForm listeForumForm = (ListeMsgForumForm) form;

		// exécution de la procédure PL/SQL
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_VALIDER);
			try {
				message = jdbc.recupererResult(vParamOut, "valider");
			} catch (BaseException be) {
				logBipUser.debug(this.getClass().getName()
						+ "-validerMsg() --> BaseException :" + be);
				logBipUser.debug(this.getClass().getName()
						+ "-validerMsg() --> Exception :"
						+ be.getInitialException().getMessage());
				logService.debug(this.getClass().getName()
						+ "-validerMsg() --> BaseException :" + be);
				logService.debug(this.getClass().getName()
						+ "-validerMsg() --> Exception :"
						+ be.getInitialException().getMessage());
				// Erreur de lecture du resultSet
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
			if ((message != null) && (!message.equals(""))) {
				// Entité déjà existante, on récupère le message
				((ListeMsgForumForm) form).setMsgErreur(message);
				logBipUser.debug("message d'erreur:" + message);
				logBipUser.exit(signatureMethode);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		} // try
		catch (BaseException be) {
			logBipUser.error(this.getClass().getName()
					+ "-validerMsg() --> BaseException :" + be);
			logBipUser.error(this.getClass().getName()
					+ "-validerMsg() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.error(this.getClass().getName()
					+ "-validerMsg() --> BaseException :" + be);
			logService.error(this.getClass().getName()
					+ "-validerMsg() --> Exception :"
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
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}

		logBipUser.exit(signatureMethode);

		// si on clore le sujet on revient à la liste des sujets
		if (listeForumForm.getStatut().equals("C")) {
			 jdbc.closeJDBC(); return mapping.findForward("retour");
		} else {
				 jdbc.closeJDBC(); return initialiser(mapping, listeForumForm, request, response,
					errors, hParamProc);
		}
	} // validerMsg

	/**
	 * Action qui redirige vers l'écran réponse au message
	 */
	public ActionForward repondre(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;

		String signatureMethode = this.getClass().getName()
				+ " - repondre( mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);

		logBipUser.exit(signatureMethode);

	 return mapping.findForward("repondre");
	} // repondre

	/**
	 * Action qui permet de supprimer un message
	 */
	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;

		String signatureMethode = this.getClass().getName()
				+ " - consulter( mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);

		ListeMsgForumForm listeForumForm = (ListeMsgForumForm) form;

		// Suppression d'un message
		if (listeForumForm.getMode().equals("delete")) {
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
					((ListeMsgForumForm) form).setMsgErreur(message);
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
					((ListeMsgForumForm) form).setMsgErreur(message);
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
		// modifier d'un message
		if (listeForumForm.getMode().equals("update")) {
			logBipUser.exit(signatureMethode);
			 jdbc.closeJDBC(); return mapping.findForward("modifier");
		} else {
			logBipUser.exit(signatureMethode);
			 jdbc.closeJDBC(); return initialiser(mapping, form, request, response, errors,
					hParamProc);
		}
	} // consulter

}