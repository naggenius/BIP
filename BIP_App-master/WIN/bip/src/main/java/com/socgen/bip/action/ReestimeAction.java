package com.socgen.bip.action;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.LinkedList;
import java.util.Vector;

import javax.servlet.ServletException;
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
import com.socgen.bip.form.ReestimeForm;
import com.socgen.bip.metier.GestBudgHisto;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author MMC - 09/07/2003
 * 
 * Mise à jour des reestimes chemin : Ligne Bip/Gestion/Reestime ligne bip pages :
 * fReestimeAd.jsp et Reestime.jsp pl/sql : reesbip.sql
 */
public class ReestimeAction extends AutomateAction {

	private static String PACK_SELECT = "reestime.consulter.proc";

	private static String PACK_UPDATE = "reestime.modifier.proc";

	/**
	 * Action qui permet de visualiser les données liées à une ligne bip pour la
	 * modification des réestimés
	 */
	protected ActionForward suite(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = "ReestimeAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		ReestimeForm bipForm = (ReestimeForm) form;

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
				ResultSet rset = null;
				try {
					if (paramOut.getNom().equals("curseur")) {
						// Récupération du Ref Cursor
						rset = (ResultSet) paramOut.getValeur();
						logService.debug("ResultSet");
						if (rset.next()) {
							int compteur = 0;;
							bipForm.setPid(rset.getString(++compteur));
							bipForm.setPnom(rset.getString(++compteur));
							
							//Modif pour Defect 556 : on récupère le type Projet de la ligne BIP
							//Si du type 9 on affiche un message d'erreur												
							String msgErreurLigneBipType9 = ProposeAction.errorLigneTypeT9(rset.getString(++compteur)) ; 
							if(msgErreurLigneBipType9 !=null){//								
								bipForm.setMsgErreur(msgErreurLigneBipType9);
								// on reste sur la même page
								jdbc.closeJDBC(); return mapping.findForward("initial");	
							}
							
							bipForm.setCodsg(rset.getString(++compteur));
							bipForm.setXcusag0(rset.getString(++compteur));
							bipForm.setBnmont(rset.getString(++compteur));
							bipForm.setPreesancou(rset.getString(++compteur));
							bipForm.setReescomm(rset.getString(++compteur));
							bipForm.setEstimpluran(rset.getString(++compteur));
							bipForm.setFlaglock(rset.getInt(++compteur));
							bipForm.setFlag(rset.getInt(++compteur));
							bipForm.setRedate(rset.getString(++compteur));
							bipForm.setUreestime(rset.getString(++compteur));
							bipForm.setMsgErreur(null);
							
						} else {
							msg = true;
						}
					}// if
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
							bipForm.setReesHisto(listeHisto);
						}
					}
				}// try
				catch (SQLException sqle) {
					logService
							.debug("ReestimeAction-consulter() --> SQLException :"
									+ sqle);
					logBipUser
							.debug("ReestimeAction-consulter() --> SQLException :"
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
								.debug("ReestimeAction-consulter() --> SQLException-rset.close() :"
										+ sqle);
						// Erreur de lecture du resultSet
						errors.add(ActionErrors.GLOBAL_ERROR,
								new ActionError("11217"));
						 jdbc.closeJDBC(); return mapping.findForward("error");
					}
				}
			}// for
			if (msg) {
				// le code Personne n'existe pas, on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		}// try
		catch (BaseException be) {
			logBipUser.debug("ReestimeAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("ReestimeAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("ReestimeAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("reestimeAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((ReestimeForm) form).setMsgErreur(message);
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

		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	}

	protected String recupererCle(String mode) {
		String cle = null;
		if (mode.equals("update")) {
			cle = PACK_UPDATE;
		}

		  return cle;
	}

	

	 
	 
}
