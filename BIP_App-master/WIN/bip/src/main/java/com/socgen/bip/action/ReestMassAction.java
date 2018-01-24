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
import com.socgen.bip.form.BudgMassForm;
import com.socgen.bip.metier.Reestime;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.ich.ihm.menu.PaginationVector;

/**
 * @author N.BACCAM - 15/07/2003
 * 
 * Action de mise � jour des reestim�s en masse chemin : Administration/Ligne
 * Bip/Gestion/Reestim�ss d'une ann�e pages : fReestMassAd.jsp et
 * bReestMassAd.jsp pl/sql : reestime.sql, ls_reest.sql
 */
public class ReestMassAction extends AutomateAction implements BipConstantes {
	private static String PACK_SELECT = "reestmass.consulter.proc";

	private static String PACK_UPDATE = "reestmass.modifier.proc";

	private static String PACK_TABLEAU = "reestmass.tableau.proc";

	private static String PACK_TOTAL = "reestmass.total.proc";

	int blocksize = 10;
	


	/**
	 * Constructor for ReestMassAction.
	 */
	public ReestMassAction() {
		super();
	}

	/**
	 * Action qui permet de passer � la page premi�re page avec destruction du
	 * tableau en session
	 */
	protected ActionForward annuler(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParams) throws ServletException {
		HttpSession session = request.getSession(false);

		String signatureMethode = "ReestMassAction-annuler( mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// On d�truit le tableau sauvegard� en session
		session.removeAttribute(REESTIME_EN_MASSE);
		logBipUser.debug("Destruction de la liste des reestim�s en session");

		BudgMassForm bipForm = ((BudgMassForm) form);
		// on sauvegarde en session la position de la ressource dans la liste
		// d�roulante
		session.setAttribute("POSITIONCLIENT", bipForm.getPosClient());
		// on sauvegarde en session la position du sc�nario dans la liste
		// d�roulante
		session.setAttribute("POSITIONAPPLI", bipForm.getPosAppli());
		// on sauvegarde en session do DPG
		session.setAttribute("CODSG", bipForm.getCodsg());

		logBipUser.exit(signatureMethode);

		 return mapping.findForward("initial");
	}

	/**
	 * M�thode consulter : Affichage des donn�es dont le tableau des reestim�s
	 */
	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParams) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		Vector vParamOut2 = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;
		Vector vListe = new Vector();
		PaginationVector vueListe;

		String signatureMethode = "ReestMassAction-consulter(paramProc, mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);

		// Cr�ation d'une nouvelle form
		BudgMassForm bipForm = (BudgMassForm) form;

		// ex�cution de la proc�dure PL/SQL pour affichage du sigle du code
		// client MO
		try {
			vParamOut = jdbc.getResult(hParams,
					configProc, PACK_SELECT);

			// R�cup�ration des r�sultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				// r�cup�rer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();
				}

				// R�cup�rer le lib du codsg
				if (paramOut.getNom().equals("libcodsg")) {
					bipForm.setLibcodsg((String) paramOut.getValeur());
				}

				// R�cup�rer le lib du clicode
				if (paramOut.getNom().equals("libclicode")) {
					bipForm.setLibclicode((String) paramOut.getValeur());
				}

				// R�cup�rer le lib de l'application
				if (paramOut.getNom().equals("libairt")) {
					bipForm.setLibairt((String) paramOut.getValeur());
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
			logBipUser.debug("ReestMassAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("ReestMassAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("ReestMassAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("ReestMassAction-consulter() --> Exception :"
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

		// ******* ex�cution de la proc�dure PL/SQL pour des totaux et du nb de
		// jours ouvr�s
		try {
			vParamOut2 = jdbc.getResult(
					hParams, configProc, PACK_TOTAL);

			// pas besoin d'aller plus loin
			if (vParamOut2 == null) {
				logBipUser
						.debug("SaisieConso-consulter(totaux) :!!! cancel forward  ");
				logBipUser.exit(signatureMethode);
				 jdbc.closeJDBC(); return mapping.findForward("suite");
			}
			// R�cup�ration des r�sultats
			for (Enumeration e = vParamOut2.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();
				// r�cup�rer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();
				}
				if (paramOut.getNom().equals("curseur")) {
					// R�cup�ration du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();
					try {
						logService.debug("ResultSet");
						if (rset.next()) {
							bipForm.setTot_xcusag0(rset.getString(1));
							bipForm.setTot_xbnmont(rset.getString(2));
							bipForm.setTot_preesancou(rset.getString(3));

							// sauvegarde des mois anciens
							saveOldMonths(bipForm);
							bipForm.setMsgErreur(null);
						} else
							msg = true;
						if (rset != null)
							rset.close();
					} // try
					catch (SQLException sqle) {
						logService
								.debug("ReestMassAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("ReestMassAction-consulter() --> SQLException :"
										+ sqle);
						// Erreur de lecture du resultSet
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11217"));
						 jdbc.closeJDBC(); return mapping.findForward("error");
					}
				} // if
			} // for
			if (msg) {
				// on r�cup�re le message
				bipForm.setMsgErreur(message);
				// on reste sur la m�me page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		} // try
		catch (BaseException be) {
			logBipUser.debug("ReestMassAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("ReestMassAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("ReestMassAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("ReestMassAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((BudgMassForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			} else {
				// Erreur d''ex�cution de la proc�dure stock�e
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		} 
		// on r�cupere les donn�es de toutes les lignes
		try {
			vParamOut = jdbc.getResult(hParams,
					configProc, PACK_TABLEAU);

			// R�cup�ration des r�sultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				if (paramOut.getNom().equals("curseur")) {
					// R�cup�ration du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();

					try {
						while (rset.next()) {
							// On alimente le Bean reestime et on le stocke dans
							// un vector
							vListe.add(new Reestime(rset.getString(1), rset
									.getString(2), rset.getString(3), rset
									.getString(4), rset.getString(5), rset
									.getString(6), rset.getString(7), rset
									.getString(8), rset.getString(9)
									, rset.getString(10), rset.getString(11), rset.getString(12), rset.getString(13)));
						}
						if (rset != null)
							rset.close();
					}// try
					catch (SQLException sqle) {
						logService
								.debug("ReestMassAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("ReestMassAction-consulter() --> SQLException :"
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
			logBipUser.debug("ReestMassAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("ReestMassAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("ReestMassAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("ReestMassAction-consulter() --> Exception :"
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
		// vueListe=new PaginationVector(vListe,blocksize);

		if (bipForm.getBlocksize() != null)
			blocksize = Integer.parseInt(bipForm.getBlocksize());

		vueListe = new PaginationVector(vListe, blocksize);

		// Stocker le r�sultat dans la session
		(request.getSession(false)).setAttribute(REESTIME_EN_MASSE, vueListe);
		// Stocker le r�sultat dans le formulaire
		bipForm.setListePourPagination(vueListe);

		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	}

	/**
	 * M�thode valider : Met � jour les reestim�s dans la base de donn�es
	 */
	protected ActionForward valider(ActionMapping mapping, ActionForm form,
			String mode, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors, Hashtable hParams)
			throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;
		String pid;
		String flaglock;
		String reestime;
		String reescomm;
		// Champ s�parateur, non autoris� dans les champs commentaire 
		// (utilis� c�t� PLSQL pour d�couper la chaine
		String separateur = "�";
		String chaine = separateur;
		HttpSession session = request.getSession(false);
		String save;

		String signatureMethode = "ReestMassActionAction-valider(paramProc, mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);

		PaginationVector page = (PaginationVector) (request.getSession())
				.getAttribute("listeReestimes");

		// On sauvegarde les donn�es du formulaire
		savePage(mapping, form, request, response, errors);

		BudgMassForm bipForm = ((BudgMassForm) form);

		// On construit la cha�ne qui doit �tre pass� en param�tre de la forme
		// ;pid;flaglock;preesancou;
		for (Enumeration e = page.elements(); e.hasMoreElements();) {
			Reestime ReestMass = (Reestime) e.nextElement();
			pid = ReestMass.getPid();
			flaglock = ReestMass.getFlaglock();
			reestime = ReestMass.getPreesancou();
			reescomm = ReestMass.getReescomm();
			if (reestime == null)
				reestime= "";
			if (flaglock == null) {
				flaglock = "0";
			}
			if (reescomm == null)
				reescomm= "";
			
			
			chaine = chaine + pid + separateur + flaglock + separateur + reestime + separateur + reescomm + separateur ;
		}// for

		// logBipUser.debug("chaine:"+chaine);

		
		// on ex�cute la procedure PLSQL qui met � jour les reestim�s
		try {
			// Ajouter la chaine dans la hashtable des param�tres
			hParams.put("string", chaine);
			
			vParamOut = jdbc.getResult(hParams,
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
				((BudgMassForm) form).setMsgErreur(message);
				logBipUser.debug("valider() -->message :" + message);
			}

			// on sauvegarde en session la position de la ressource dans la
			// liste d�roulante
			session.setAttribute("POSITIONCLIENT", bipForm.getPosClient());
			// on sauvegarde en session la position du sc�nario dans la liste
			// d�roulante
			session.setAttribute("POSITIONAPPLI", bipForm.getPosAppli());
			// on sauvegarde en session do DPG
			session.setAttribute("CODSG", bipForm.getCodsg());

		}// try
		catch (BaseException be) {
			logBipUser.debug("ReestMassAction-valider() --> BaseException :"
					+ be, be);
			logBipUser.debug("ReestMassAction-valider() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("ReestMassAction-valider() --> BaseException :"
					+ be, be);
			logService.debug("ReestMassAction-valider() --> Exception :"
					+ be.getInitialException().getMessage());

			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((BudgMassForm) form).setMsgErreur(message);
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

		save = bipForm.getSave();
		if (save.equals("OUI")) {
			 jdbc.closeJDBC(); return mapping.findForward("ecran");
		} else {
			// On d�truit le tableau sauvegard� en session
			session.removeAttribute(REESTIME_EN_MASSE);
			logBipUser
					.debug("Destruction de la liste des reestim�s en session");
			 jdbc.closeJDBC(); return mapping.findForward("initial");
		}

	}// valider

	/**
	 * M�thode savePage : Sauvegarde les reestim�s en session
	 */
	protected void savePage(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors) {
		String pid;
		String flaglock;
		String reestime;
		//HPPM31739
		String reescomm;

		PaginationVector page = (PaginationVector) (request.getSession())
				.getAttribute("listeReestimes");
		// Cr�ation d'une nouvelle form
		BudgMassForm bipForm = (BudgMassForm) form;

		if (bipForm.getBlocksize() != null)
			blocksize = Integer.parseInt(bipForm.getBlocksize());

		// r�cup�rer les champs modifiables
		for (int i = 1; i <= blocksize; i++) {
			pid = "pid_" + i;
			flaglock = "flaglock_" + i;
			reestime = "preesancou_" + i;
			//HPPM31739
			reescomm = "preescomm_" + i;
			for (Enumeration e = page.elements(); e.hasMoreElements();) {
				Reestime reestMass = (Reestime) e.nextElement();
				if (request.getParameter(pid) != null) {
					if ((request.getParameter(pid)).equals(reestMass.getPid())) {
						// On met � jour le reestim� de la ligne
						reestMass.setPreesancou(request.getParameter(reestime));
						//HPPM31739
						reestMass.setReescomm(request.getParameter(reescomm));
					
					}// if
				}// if
			}// for
		} // for

		(request.getSession()).setAttribute(REESTIME_EN_MASSE, page);

	}// savePage

	/*
	 * sauvegarde des mois anciens
	 */
	private void saveOldMonths(BudgMassForm bipForm) {

		bipForm.setOld_tot_xcusag0(bipForm.getTot_xcusag0());
		bipForm.setOld_tot_xbnmont(bipForm.getTot_xbnmont());
		bipForm.setOld_tot_preesancou(bipForm.getTot_preesancou());

	}

}
