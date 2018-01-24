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
import com.socgen.bip.form.ArbitrageForm;
import com.socgen.bip.metier.Arbitrage;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.ich.ihm.menu.PaginationVector;

/**
 * @author EVI - 06/02/2009
 * 
 * Action de mise à jour des arbitres :
 * Administration/Budjet JH/Arbitrage : fArbitrageAd.jsp et
 * bArbitrageAd.jsp pl/sql : arbitre.sql
 */
public class ArbitrageAction extends AutomateAction implements BipConstantes {

	private static String PACK_UPDATE = "arbitremass.modifier.proc";

	private static String PACK_TABLEAU = "arbitremass.tableau.proc";

	int blocksize = 10;
	/**
	 * Constructor for ArbitrageAction.
	 */
	public ArbitrageAction() {
		super();
	}

	/**
	 * Action qui permet de passer à la page première page avec destruction du
	 * tableau en session
	 */
	protected ActionForward annuler(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		HttpSession session = request.getSession(false);

		String signatureMethode = "ArbitrageAction-annuler( mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// On détruit le tableau sauvegardé en session
		 session.removeAttribute(ARBITRE_EN_MASSE);
		 logBipUser.debug("Destruction de la liste des arbitres en session");
		logBipUser.exit(signatureMethode);

		 return mapping.findForward("initial");
	}

	/**
	 * Méthode consulter : Affichage des données dans un tableau
	 */
	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParams) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		Vector vParamOut2 = new Vector();
		boolean msg = false;
		ParametreProc paramOut;
		Vector vListe = new Vector();
		PaginationVector vueListe;

		String signatureMethode = "ArbitrageAction-consulter(paramProc, mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);

		// Récupération du form
		ArbitrageForm bipForm = (ArbitrageForm) form;

		
		// On exécute la procédure PL/SQL qui ramène les résultats pour le
		// tableau
		try {
			vParamOut = jdbc.getResult(hParams,
					configProc, PACK_TABLEAU);
			// Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();
				
				// récupérer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();
					logBipUser.debug("ArbitrageAction-consulter() --> message:" + message);
				}
				
				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();
					
					
					try {
						
						int compteur=0;
						while (rset.next()) {
							compteur++;
							// On alimente le Bean Propose et on le stocke dans
							// un vector
							/* on verifie si le pid est dans la liste des pids */
							int index=0;
							if (bipForm.getListe_pid() != null){
								 index = bipForm.getListe_pid().indexOf( rset.getString(5));}
									else { index=-1;}
							/* si le pid n'est pas dans la liste */
							 if ( index == -1 )
							{
							vListe.add(new Arbitrage(rset.getString(1), rset
									.getString(2), rset.getString(3), rset
									.getString(4), rset.getString(5), rset
									.getString(6), rset.getString(7),rset.getString(8), rset
									.getString(9),rset.getString(10), rset
									.getString(11),rset.getString(12),rset
									.getString(13),"N",rset.getTimestamp(14),rset.getString(15)
									, rset.getString(16),rset.getString(17)));// KRA - Version SIOP - PPM 61919 - §6.9
									
							} else
								{
								vListe.add(new Arbitrage(rset.getString(1), rset
										.getString(2), rset.getString(3), rset
										.getString(4), rset.getString(5), rset
										.getString(6), rset.getString(7),rset.getString(8), rset
										.getString(9),rset.getString(10), rset
										.getString(11),rset.getString(12),rset
										.getString(13),"O",rset.getTimestamp(14),rset.getString(15)
										, rset.getString(16),rset.getString(17)));// KRA - Version SIOP - PPM 61919 - §6.9
								}
								}// fin while
						if (rset != null)
							rset.close();	
						if (compteur == 0) { 
							msg = true;
							} 
					}// try
					catch (SQLException sqle) {
						msg = true;
						logService
								.debug("ArbitrageAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("ArbitrageAction-consulter() --> SQLException :"
										+ sqle);
						// Erreur de lecture du resultSet
						//errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
						//		"11217"));

						 //jdbc.closeJDBC(); return mapping.findForward("error");
					}
				}// if
			}// for
			if (msg) {
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		}// try
		catch (BaseException be) {
			logBipUser.debug("ArbitrageAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("ArbitrageAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("ArbitrageAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("ArbitrageAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				bipForm.setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");

			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());

				 jdbc.closeJDBC(); return mapping.findForward("error");
			}

		}

		// Construire un PaginationVector contenant les informations du FormBean

		if (bipForm.getBlocksize() != null)
			blocksize = Integer.parseInt(bipForm.getBlocksize());

		vueListe = new PaginationVector(vListe, blocksize);
				
		// Stocker le résultat dans la session
		(request.getSession(false)).setAttribute(ARBITRE_EN_MASSE, vueListe);
		// Stocker le résultat dans le formulaire
		bipForm.setListePourPagination(vueListe);

		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("ecran");

	}

	/**
	 * Méthode valider : Met à jour les arbitres
	 */
	protected ActionForward valider(ActionMapping mapping, ActionForm form,
			String mode, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors, Hashtable hParam)
			throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;
		String pid;
		String flaglock;
		String annee;
		String chaine = ";";
		String save;
		HttpSession session = request.getSession(false);

		String signatureMethode = "ArbitrageAction-valider(paramProc, mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);

		PaginationVector page = (PaginationVector) session
				.getAttribute(ARBITRE_EN_MASSE);

		// On sauvegarde les données du formulaire
		savePage(mapping, form, request, response, errors);

		ArbitrageForm bipForm = ((ArbitrageForm) form);
		// recup la valeur save: OUI = on edite, NON= on valide
		save = bipForm.getSave();

		// On construit la chaîne qui doit être passé en paramètre de la forme
		// ;annee;pid;flaglock;bpmontme; (on bpmontmo)
		annee = ((ArbitrageForm) form).getAnnee();
		chaine = chaine + annee + ";";

		for (Enumeration e = page.elements(); e.hasMoreElements();) {
			Arbitrage Arb = (Arbitrage) e.nextElement();
			
			// Si la case est coché
			if (Arb.getCk().equals("O")) {
				pid = Arb.getPid();
				flaglock = Arb.getFlaglock();
				// flaglock
				if (flaglock == null) {
					flaglock = "0";
				}			
				chaine = chaine + pid + ";" + flaglock + ";";
			} 
			
		}// for

		//logBipUser.debug("chaine envoyé: " + chaine);
		// Ajouter la chaine dans la hashtable des paramètres
		hParam.put("string", chaine);
		
		
		//si on edite pas on valide l'arbitrage
		if (save.equals("NON")) {	
		// on exécute la procedure PLSQL qui met à jour les proposés
		try {
					
			vParamOut = jdbc.getResult(hParam,
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
				// on récupère le message
				((ArbitrageForm) form).setMsgErreur(message);
				logBipUser.debug("valider() -->message :" + message);
			}
			

		}// try
		catch (BaseException be) {
			logBipUser.debug("ArbitrageAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("ArbitrageAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("ArbitrageAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("ArbitrageAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((ArbitrageForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("ecran");

			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}
		logBipUser.exit(signatureMethode);
		} // fin IF SAVE = NON
		
		// Si l'utilisateur choisi l'edition
		if (save.equals("OUI")) {
			jdbc.closeJDBC(); return mapping.findForward("edition");
		} else {
			/* on met a jour les totaux */
			bipForm.setTot_anmont(bipForm.getTot_bpmontmo());
			bipForm.setTot_ecart("0");
			/* on vide le tableau des lignes pour l'arbitrage */
			session.removeAttribute(ARBITRE_EN_MASSE);
			/* Rempli le tableau avec les données mise a jour */
			return consulter(mapping, bipForm, request, response, errors,hParam);
			//jdbc.closeJDBC(); return mapping.findForward("ecran");
		}
			 
			 

	}// valider

	/**
	 * Méthode savePage : Sauvegarde les proposés en session
	 */
	protected void savePage(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors) {

		String annee;
		String pid;
		String libck;
		String flaglock;

		PaginationVector page = (PaginationVector) (request.getSession())
				.getAttribute(ARBITRE_EN_MASSE);
		ArbitrageForm budget = (ArbitrageForm) form;

		if (budget.getBlocksize() != null)
			blocksize = Integer.parseInt(budget.getBlocksize());

		// récupérer les champs modifiables
		for (int i = 1; i <= blocksize; i++) {
			pid = "pid_" + i;
			libck = "ck_" + i;
			flaglock = "flaglock_" + i;

			for (Enumeration e = page.elements(); e.hasMoreElements();) {
				Arbitrage Arb = (Arbitrage) e.nextElement();
				if (request.getParameter(pid) != null) {
					if ((request.getParameter(pid)).equals(Arb.getPid())) {

						if (request.getParameter(libck) == null) {
							// On met à jour le type de vaildation pour le type N
							Arb.setCk("N");
						} else {
							// On met à jour le type de vaildation pour le type O
							Arb.setCk("O");
						}
							
						
						
					}// if
				}// if
			}// for
		} // for

		(request.getSession()).setAttribute(ARBITRE_EN_MASSE, page);

	}// savePage



}
