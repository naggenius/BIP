package com.socgen.bip.action;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.LinkedList;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.GestBudgForm;
import com.socgen.bip.metier.GestBudgHisto;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author MMC - 04/07/2003
 * 
 * Mise à jour des budgets chemin : Ligne Bip/Gestion/Gestion budget pages :
 * bGestionbudgAd.jsp, bGestionbudg2Ad, mGestionbudgAd.jsp 
 * pl/sql : PACK_GESTBUDG
 */
public class GestBudgAction extends AutomateAction {

	// Procédure stockée chargeant les budgets d'une année
	private static String PACK_SELECT = "gestbudg.consulter.proc";
	// Procédure stockée chargeant un budget arbitré et son historique
	private static String PACK_SELECT_HISTO_ARB = "gestbudg.consulterhistoarb.proc";
	// Procédure stockée chargeant un budget arbitré et son historique
	private static String PACK_SELECT_HISTO_REES = "gestbudg.consulterhistorees.proc";
	// Procédure stockée modifiant les budgets d'une année
	private static String PACK_UPDATE = "gestbudg.modifier.proc";

	/**
	 * Redirections struts-config
	 */
	// Formulaire de choix de ligne Bip et d'année
	private static String REDIR_FORMULAIRE = "initial";
	// Page de consultation des budgets / d'un arbitré et de son historique / d'un réestimé et de son historique
	private static String REDIR_CONSULT = "suite";
	// Page de modification des budgets
	private static String REDIR_MODIF = "ecran";
	// Page d'erreur
	private static String REDIR_ERREUR = "error";
	/**
	 * Action qui permet d'administrer (consulter globalement / modifier) les budgets d'une année pour une ligne (bouton "Consulter globalement" / "Modifier")
	 */
	public ActionForward administrer(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = "GestBudgAction-administrer(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		GestBudgForm bipForm = (GestBudgForm) form;

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
				// récupérer l'annee saisie
				if (paramOut.getNom().equals("annee_sav")) {
					String sAnneeSaisie = (String) paramOut.getValeur();
					logService.debug("Annee saisie :" + sAnneeSaisie);
					((GestBudgForm) form).setAnnee(sAnneeSaisie);
				}// if

				// récupérer le budg rees
				if (paramOut.getNom().equals("bud_rees")) {
					String sBudgRees = (String) paramOut.getValeur();
					logService.debug("Budget reestime :" + sBudgRees);
					((GestBudgForm) form).setBud_rees(sBudgRees);
				}// if
				
				// YNI
				// récupérer le perimetre MO
				if (paramOut.getNom().equals("perimo")) {
					String perimo = (String) paramOut.getValeur();
					logService.debug("Etat de la page :" + perimo);
					((GestBudgForm) form).setPerimo(perimo);
				}// if
				
				// récupérer le perimetre ME
				if (paramOut.getNom().equals("perime")) {
					String perime = (String) paramOut.getValeur();
					logService.debug("Etat de la page :" + perime);
					((GestBudgForm) form).setPerime(perime);
				}// if
				//FIN YNI

				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();
					try {
						logService.debug("ResultSet");
						if (rset.next()) {
							int compteur = 0;
							bipForm.setPid(rset.getString(++compteur));
							bipForm.setPnom(rset.getString(++compteur));
							
							// Ajouté dans le cadre de l'évol HPPM 31739
							bipForm.setCodsg(rset.getString(++compteur));
							bipForm.setLibdsg(rset.getString(++compteur));
							
							bipForm.setAstatut(rset.getString(++compteur));
							bipForm.setDate_statut(rset.getString(++compteur));
							bipForm.setAnnee(rset.getString(++compteur));
							bipForm.setBud_prop(rset.getString(++compteur));
							bipForm.setBud_propmo(rset.getString(++compteur));
							bipForm.setBud_not(rset.getString(++compteur));
							bipForm.setBud_arb(rset.getString(++compteur));
							bipForm.setReserve(rset.getString(++compteur));
							bipForm.setBud_rst(rset.getString(++compteur));
							bipForm.setFlaglock(rset.getInt(++compteur));
							bipForm.setBpdate(rset.getString(++compteur));
							bipForm.setBpmedate(rset.getString(++compteur)); 
							bipForm.setBndate(rset.getString(++compteur));
							bipForm.setRedate(rset.getString(++compteur));
							
							// Ajouté dans le cadre de l'évol HPPM 31739
							bipForm.setBresdate (rset.getString(++compteur));
							
							bipForm.setUbpmontme(rset.getString(++compteur));
							bipForm.setUbpmontmo(rset.getString(++compteur));
							bipForm.setUbnmont(rset.getString(++compteur));
							bipForm.setUanmont(rset.getString(++compteur));
							bipForm.setUreestime(rset.getString(++compteur));
							
//							 Ajouté dans le cadre de l'évol HPPM 31739
							bipForm.setUreserve(rset.getString(++compteur));
							
							// Ajouté dans le cadre de l'évol HPPM 31739
							bipForm.setArbcomm(rset.getString(++compteur));
							bipForm.setReescomm(rset.getString(++compteur));
							
							bipForm.setBnadate(rset.getString(++compteur));
							bipForm.setMsgErreur(null);
							
						} else
							msg = true;

					}// try
					catch (SQLException sqle) {
						logService
								.debug("GestBudgAction-administrer() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("GestBudgAction-administrer() --> SQLException :"
										+ sqle);
						// Erreur de lecture du resultSet
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11217"));
						// this.saveErrors(request,errors);
						 jdbc.closeJDBC(); return mapping.findForward(REDIR_ERREUR);
					} finally {
						try {
							if (rset != null)
								rset.close();
						} catch (SQLException sqle) {
							logBipUser
									.debug("GestBudgAction-administrer() --> SQLException-rset.close() :"
											+ sqle);
							// Erreur de lecture du resultSet
							errors.add(ActionErrors.GLOBAL_ERROR,
									new ActionError("11217"));
							 jdbc.closeJDBC(); return mapping.findForward(REDIR_ERREUR);
						}
					}
				}// if
			}// for
			if (msg) {
				// on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward(REDIR_FORMULAIRE);
			}
		}// try
		catch (BaseException be) {
			logBipUser.debug("GestBudgAction-administrer() --> BaseException :"
					+ be, be);
			logBipUser.debug("GestBudgAction-administrer() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("GestBudgAction-administrer() --> BaseException :"
					+ be, be);
			logService.debug("GestBudgAction-administrer() --> Exception :"
					+ be.getInitialException().getMessage());

			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((GestBudgForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward(REDIR_FORMULAIRE);
			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward(REDIR_ERREUR);
			}

		}

		logBipUser.exit(signatureMethode);

		String redirection = null;
		if (GestBudgForm.modeConsulterGlobalement.equals(bipForm.getMode())) {
			redirection = REDIR_CONSULT;
		}
		else if (GestBudgForm.modeModifier.equals(bipForm.getMode())) {// Clic sur le bouton modifier : mode modifier
			redirection = REDIR_MODIF;
		}
		
		 jdbc.closeJDBC(); return mapping.findForward(redirection);
	}

	/**
	 * Consulter un arbitré et son historique / d'un réestimé et son historique : appel de SELECT_GESTBUDG_HISTO_ARB / SELECT_GESTBUDG_HISTO_REES
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param errors
	 * @param hParamProc
	 * @return
	 */
	public ActionForward consulterHisto(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) {
		//PACK_SELECT_HISTO_ARB
		// Appeler la procédure stockée SELECT_GESTBUDG_HISTO_ARB
		/*
		 * Alimenter le formulaire avec les résultats renvoyés par la requête 
		 * (2 champs ligne Bip, 2 champs DPG, 1 champ Année, 4 champs Arbitré actuel, 1 champ liste des historiques des arbitrés)
		*/
		JdbcBip jdbc = new JdbcBip(); 
		String cleProc = null;
		String nomCurseur = null;
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;
		ResultSet rset = null;
		String signatureMethode = "GestBudgAction-consulterHisto(paramProc, mapping, form , request,  response,  errors, hParamProc)";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		GestBudgForm bipForm = (GestBudgForm) form;

		// exécution de la procédure PL/SQL
		try {
			if (GestBudgForm.modeConsulterHistoArb.equals(bipForm.getMode())) {
				cleProc = PACK_SELECT_HISTO_ARB;
				nomCurseur = "curGestbudgHistoArb";
			}
			else if (GestBudgForm.modeConsulterHistoRees.equals(bipForm.getMode())) {
				cleProc = PACK_SELECT_HISTO_REES;
				nomCurseur = "curGestbudgHistoRees";
			}
			
			vParamOut = jdbc.getResult(
					hParamProc, configProc, cleProc);

			// Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				// récupérer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();
				}
				
				try {
					if (paramOut.getNom().equals(nomCurseur)) {
						// Récupération du Ref Cursor
						rset = (ResultSet) paramOut.getValeur();

						logService.debug("ResultSet " + nomCurseur);
						if (rset.next()) {
							int compteur = 0;
							// Ligne BIP
							bipForm.setPid(rset.getString(++compteur));
							bipForm.setPnom(rset.getString(++compteur));
							// DPG
							bipForm.setCodsg(rset.getString(++compteur));
							bipForm.setLibdsg(rset.getString(++compteur));
							// Année
							bipForm.setAnnee(rset.getString(++compteur));
							// Statut
							bipForm.setAstatut(rset.getString(++compteur));
							
							if (GestBudgForm.modeConsulterHistoArb.equals(bipForm.getMode())) {
								//	Budget arbitré notifié
								bipForm.setBud_arb(rset.getString(++compteur));
								bipForm.setBnadate(rset.getString(++compteur));
								bipForm.setUanmont(rset.getString(++compteur));
								bipForm.setArbcomm(rset.getString(++compteur));
							}
							else if (GestBudgForm.modeConsulterHistoRees.equals(bipForm.getMode())) {
								// Budget réestimé
								bipForm.setBud_rst(rset.getString(++compteur));
								bipForm.setRedate(rset.getString(++compteur));
								bipForm.setUreestime(rset.getString(++compteur));
								bipForm.setReescomm(rset.getString(++compteur));
							}
							
							bipForm.setMsgErreur(null);
						} else {
							msg = true;
						}
					}
					// Curseur contenant les historiques
					else if (paramOut.getNom().equals("curBudgetHisto")) {
						// Récupération du Ref Cursor
						rset = (ResultSet) paramOut.getValeur();

						logService.debug("ResultSet curBudgetHisto");
						
						LinkedList<GestBudgHisto> listeHisto = null;
						GestBudgHisto histo;
						int compteur;
						while (rset.next()) {
							if (listeHisto == null) {
								listeHisto = new LinkedList<GestBudgHisto>();
							}
							histo = new GestBudgHisto();
							compteur = 0;
							// Ligne BIP
							histo.setValeur(rset.getString(++compteur));
							histo.setDateModif(rset.getString(++compteur));
							histo.setMatricule(rset.getString(++compteur));
							histo.setCommentaire(rset.getString(++compteur));
							
							listeHisto.add(histo);
						}
						if (listeHisto != null && !listeHisto.isEmpty()) {
							if (GestBudgForm.modeConsulterHistoArb.equals(bipForm.getMode())) {
								bipForm.setArbHisto(listeHisto);
							}
							else if (GestBudgForm.modeConsulterHistoRees.equals(bipForm.getMode())) {
								bipForm.setReesHisto(listeHisto);
							}
						}
					}
				}
				catch (SQLException sqle) {
					logService
							.debug("GestBudgAction-consulterHisto() --> SQLException :"
									+ sqle);
					logBipUser
							.debug("GestBudgAction-consulterHisto() --> SQLException :"
									+ sqle);
					// Erreur de lecture du resultSet
					errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
							"11217"));
					 jdbc.closeJDBC(); return mapping.findForward(REDIR_ERREUR);
				} finally {
					try {
						if (rset != null)
							rset.close();
					} catch (SQLException sqle) {
						logBipUser
								.debug("GestBudgAction-consulterHisto() --> SQLException-rset.close() :"
										+ sqle);
						// Erreur de lecture du resultSet
						errors.add(ActionErrors.GLOBAL_ERROR,
								new ActionError("11217"));
						 jdbc.closeJDBC(); return mapping.findForward(REDIR_ERREUR);
					}
				}
			}
			if (msg) {
				// on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward(REDIR_FORMULAIRE);
			}
		}// try
		catch (BaseException be) {
			logBipUser.debug("GestBudgAction-consulterHisto() --> BaseException :"
					+ be, be);
			logBipUser.debug("GestBudgAction-consulterHisto() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("GestBudgAction-consulterHisto() --> BaseException :"
					+ be, be);
			logService.debug("GestBudgAction-consulterHisto() --> Exception :"
					+ be.getInitialException().getMessage());

			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((GestBudgForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward(REDIR_FORMULAIRE);
			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward(REDIR_ERREUR);
			}

		}

		logBipUser.exit(signatureMethode);

		String redirection = REDIR_CONSULT;
		jdbc.closeJDBC(); return mapping.findForward(redirection);	
	}
	
	/**
	 * Consulter un Réestimé et son historique : appel de SELECT_GESTBUDG_HISTO_REES
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param errors
	 * @param hParamProc
	 * @return
	 */
	public ActionForward consulterHistoRees(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) {
		//PACK_SELECT_HISTO_REES
		//Appeler la procédure stockée SELECT_GESTBUDG_HISTO_REES
		/*
		Alimenter le formulaire avec les résultats renvoyés par la requête 
		(2 champs ligne Bip, 2 champs DPG, 1 champ Année, 4 champs Réestimé actuel, 1 champ liste des historiques des arbitrés)
		*/	
		return null;
		
	}
	
	/**
	 * Renvoie la procédure à exécuter
	 * Appelé lors de la validation de l'écran de modification (mGestionbudgAd)
	 */
	protected String recupererCle(String mode) {
		String cle = null;
		if (mode.equals("update")) {
			cle = PACK_UPDATE;
		}

		  return cle;
	}

}
