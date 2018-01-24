/*
 * Created on 12 avr. 05
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
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

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.BudActJhForm;
import com.socgen.bip.metier.BudActJh;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.ich.ihm.menu.PaginationVector;

/**
 * @author X058813
 * 
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class BudActJhAction extends AutomateAction implements BipConstantes {
	private static String PACK_SELECT = "budActJh.consulter.proc";

	private static String PACK_UPDATE = "budActJh.modifier.proc";

	private static String PACK_TABLEAU = "budActJh.tableau.proc";

	private int blocksize = 10;
	
	

	/**
	 * Constructor for BudActJhAction.
	 */
	public BudActJhAction() {
		super();
	}

	/**
	 * Action qui permet de passer � la page premi�re page avec destruction du
	 * tableau en session
	 */
	protected ActionForward annuler(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		
		HttpSession session = request.getSession(false);

		String signatureMethode = "BudActJhAction-annuler( mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// On d�truit le tableau sauvegard� en session
		session.removeAttribute(BUD_DOSS_PROJ_DEP);
		logBipUser
				.debug("Destruction de la liste des dossiers projet en session");

		logBipUser.exit(signatureMethode);

		  return mapping.findForward("initial");
	}

	/**
	 * M�thode consulter : Affichage des donn�es dont le tableau des dossiers
	 * projet
	 */
	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParams) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;
		Vector vListe = new Vector();
		PaginationVector vueListe;

		String signatureMethode = "BudActJhAction-consulter(paramProc, mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);

		// R�cup�ration du form
		BudActJhForm bipForm = (BudActJhForm) form;

		// ex�cution de la proc�dure PL/SQL pour affichage du sigle du code
		// client MO
		try {
			vParamOut = jdbc.getResult( hParams,
					configProc, PACK_SELECT);

			// R�cup�ration des r�sultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				// r�cup�rer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();
					msg = true;
				}

				// R�cup�rer le lib du departement
				if (paramOut.getNom().equals("clisigle")) {
					bipForm.setLibClicode((String) paramOut.getValeur());
				}
			}// for
			if (msg) {
				// on r�cup�re le message
				bipForm.setMsgErreur(message);
				// on reste sur la m�me page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		}// try
		catch (BaseException be) {
			logBipUser.debug("BudActJhAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("BudActJhAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("BudActJhAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("BudActJhAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((BudActJhForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");

			} else {
				// Erreur d''ex�cution de la proc�dure stock�e
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());

				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		} finally {
			jdbc.closeJDBC();
		}

		// On ex�cute la proc�dure PL/SQL qui ram�ne les r�sultats pour le
		// tableau
		try {
			vParamOut = jdbc.getResult( hParams,
					configProc, PACK_TABLEAU);

			// R�cup�ration des r�sultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				if (paramOut.getNom().equals("curseur")) {
					// R�cup�ration du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();

					try {
						while (rset.next()) {
							// On alimente le Bean et on le stocke dans un
							// vector
							vListe.add(new BudActJh(rset.getString(1), rset
									.getString(2), rset.getString(3)));
						}
						if (rset != null)
							rset.close();
					}// try
					catch (SQLException sqle) {
						logService
								.debug("BudActJhAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("BudActJhAction-consulter() --> SQLException :"
										+ sqle);
						// Erreur de lecture du resultSet
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11217"));

						 jdbc.closeJDBC(); return mapping.findForward("error");
					}
				}// if
			}// for
		}// try
		catch (BaseException be) {
			logBipUser.debug("BudActJhAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("BudActJhAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("BudActJhAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("BudActJhAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				bipForm.setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");

			} else {
				// Erreur d''ex�cution de la proc�dure stock�e
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());

				 jdbc.closeJDBC(); return mapping.findForward("error");
			}

		}

		// Construire un PaginationVector contenant les informations du FormBean
		vueListe = new PaginationVector(vListe, blocksize);

		// Stocker le r�sultat dans la session
		(request.getSession(false)).setAttribute(BUD_DOSS_PROJ_DEP, vueListe);
		// Stocker le r�sultat dans le formulaire
		bipForm.setListePourPagination(vueListe);

		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("ecran");

	}

	/**
	 * M�thode valider : Met � jour les budgets dans la base de donn�es
	 */
	protected ActionForward valider(ActionMapping mapping, ActionForm form,
			String mode, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors, Hashtable hParams)
			throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		// boolean msg=false;
		// ParametreProc paramOut;
		String clicode;
		// String libClicode;
		String annee;
		String dpcode;
		// String dplib;
		String budgetHtr;
		StringBuffer chaine = new StringBuffer(";");
		HttpSession session = request.getSession(false);

		String signatureMethode = "BudActJhAction-valider(paramProc, mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);

		PaginationVector page = (PaginationVector) session
				.getAttribute(BUD_DOSS_PROJ_DEP);

		// On sauvegarde les donn�es du formulaire
		savePage(mapping, form, request, response, errors);

		// On construit la cha�ne qui doit �tre pass� en param�tre de la forme
		annee = ((BudActJhForm) form).getAnnee();
		clicode = ((BudActJhForm) form).getClicode();
		chaine.append(annee + ";" + clicode + ";");

		for (Enumeration e = page.elements(); e.hasMoreElements();) {
			BudActJh budActJh = (BudActJh) e.nextElement();

			dpcode = budActJh.getDpcode();
			budgetHtr = budActJh.getBudgetHtr();
			if ("".equals(budgetHtr)) {
				budgetHtr = "-1";
			}
			chaine.append(dpcode + ";" + budgetHtr + ";");
		}// for
		// Ajout d'un caract�re de fin (-1)
		chaine.append("-1;-1;");

		// On d�truit le tableau sauvegard� en session
		session.removeAttribute(BUD_DOSS_PROJ_DEP);
		logBipUser.debug("Destruction de la liste des budgets en session");

		// Ajouter la chaine dans la hashtable des param�tres
		hParams.put("string", chaine.toString());
		// on ex�cute la procedure PLSQL qui met � jour les propos�s
		try {
			vParamOut = jdbc.getResult( hParams,
					configProc, PACK_UPDATE);

			try {
				message = jdbc.recupererResult(vParamOut, "valider");

			} catch (BaseException be) {
				logBipUser.debug("valider() --> BaseException :" + be);
				logBipUser.debug("valider() --> Exception :"
						+ be.getInitialException().getMessage());
				logService.debug("valider() --> BaseException :" + be);
				logService.debug("valider() --> Exception :"
						+ be.getInitialException().getMessage());
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}

			if (message != null && !message.equals("")) {
				// on r�cup�re le message
				((BudActJhForm) form).setMsgErreur(message);
				logBipUser.debug("valider() -->message :" + message);
			}

		}// try
		catch (BaseException be) {
			logBipUser.debug("BudActJhAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("BudActJhAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("BudActJhAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("BudActJhAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((BudActJhForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("ecran");

			} else {
				// Erreur d''ex�cution de la proc�dure stock�e
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}
		logBipUser.exit(signatureMethode);
		 jdbc.closeJDBC(); return mapping.findForward("initial");
	}// valider

	/**
	 * M�thode savePage : Sauvegarde les propos�s en session
	 */
	protected void savePage(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors) {

		String dpcode;
		// String dplib;
		String budgetHtr;

		PaginationVector page = (PaginationVector) (request.getSession())
				.getAttribute(BUD_DOSS_PROJ_DEP);
		// BudActJhForm budget = (BudActJhForm) form;

		// r�cup�rer les champs modifiables
		for (int i = 1; i <= 10; i++) {
			dpcode = "dpcode_" + i;
			budgetHtr = "budgetHtr_" + i;

			for (Enumeration e = page.elements(); e.hasMoreElements();) {
				BudActJh budActJh = (BudActJh) e.nextElement();
				if (request.getParameter(dpcode) != null) {
					if ((request.getParameter(dpcode)).equals(budActJh
							.getDpcode())) {
						budActJh.setBudgetHtr(request.getParameter(budgetHtr));
					}// if
				}// if
			}// for
		} // for

		(request.getSession()).setAttribute(BUD_DOSS_PROJ_DEP, page);

	}// savePage
}
