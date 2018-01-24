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
import com.socgen.bip.form.MessageForumForm;
import com.socgen.bip.menu.item.BipItemMenu;
import com.socgen.bip.metier.MessageForum;
import com.socgen.bip.user.UserBip;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.ich.ihm.menu.PaginationVector;

/**
 * @author JMA - 06/06/2006
 * 
 * Action gérant les nouveaux sujets du forum
 * 
 * 
 */

public class ForumMessageAction extends AutomateAction {

	private static String PACK_INSERT = "forum.creer.proc";

	private static String PACK_UPDATE = "forum.liste.proc";

	private static String PACK_SELECT = "forum.select.proc";

	private static String PACK_DELETE = "forum.delete.proc";

	private int blocksize = 10;
	

	/**
	 * Constructor for ForumMessageAction.
	 */
	public ForumMessageAction() {
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

		MessageForumForm msgForumForm = (MessageForumForm) form;

		String sMode = request.getParameter("typeModMsg");

		UserBip userBip = (UserBip) (request.getSession(false))
				.getAttribute("UserBip");
		msgForumForm.setMenu(userBip.getCurrentMenu().getId());

		Vector v = userBip.getListeMenu();
		StringBuffer sb = new StringBuffer();
		for (Enumeration vE = v.elements(); vE.hasMoreElements();) {
			BipItemMenu bim = (BipItemMenu) vE.nextElement();
			sb.append(";" + bim.getId());
		}
		sb.append(";");
		msgForumForm.setListeMenu(sb.toString());

		// Reponse à un message
		if ((sMode != null)
				&& (sMode.equalsIgnoreCase("reponse") || sMode
						.equalsIgnoreCase("modification"))) {
			// on sauvegarde l'id du sujet en cours dans la varibale parent_id
			msgForumForm.setParent_id(new Integer(request
					.getParameter("parent_id")).intValue());
			// exécution de la procédure PL/SQL
			try {
				String sId = request.getParameter("id");
				hParamProc.put("id", sId);
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
							if (rset.next()) {
								MessageForum mf = new MessageForum(rset
										.getInt(1), rset.getInt(2), rset
										.getString(3), rset.getString(4), rset
										.getString(5), rset.getString(6), rset
										.getString(7), rset.getString(8), rset
										.getString(9), rset.getString(10), rset
										.getString(11), rset.getString(12),
										rset.getString(13), rset.getString(14),
										rset.getString(15), rset.getInt(17),
										rset.getString(18), rset.getString(16));
								msgForumForm.setMsgErreur(null);
								msgForumForm.setAuteur(mf.getAuteur());
								if ((mf.getDate_modification() != null)
										&& (mf.getDate_modification().length() > 0))
									msgForumForm.setDate_msg(mf
											.getDate_modification());
								else
									msgForumForm.setDate_msg(mf.getDate_msg());
								if (sMode.equalsIgnoreCase("reponse")){
									msgForumForm.setTitre("Re: "
											+ mf.getTitre());
									msgForumForm.setTexte("");
								}
								else {
									msgForumForm.setTitre(mf.getTitre());
									msgForumForm.setTexte(mf
											.getTexte());
								}
								msgForumForm.setTexte_modifie(mf
										.getTexte());
								msgForumForm.setId(mf.getId());
							}
						} // try
						catch (SQLException sqle) {
							logService.debug(this.getClass().getName()
									+ "-initialiser() --> SQLException :"
									+ sqle);
							logBipUser.debug(this.getClass().getName()
									+ "-initialiser() --> SQLException :"
									+ sqle);
							// Erreur de lecture du resultSet
							errors.add(ActionErrors.GLOBAL_ERROR,
									new ActionError("11217"));
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
					msgForumForm.setMsgErreur(message);
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
				// Si exception sql alors extraire le message d'erreur du
				// message global
				if (be.getInitialException().getClass().getName().equals(
						"java.sql.SQLException")) {
					message = BipException.getMessageFocus(BipException
							.getMessageOracle(be.getInitialException()
									.getMessage()), form);
					((MessageForumForm) form).setMsgErreur(message);
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
		}
		  return cle;
	}

}