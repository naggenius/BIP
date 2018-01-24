/*
 * Created on 12 nov. 03
 * 
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

import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.SuiviInvestissementForm;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author S.Lallier - 12/11/2003
 *
 * Action de mise à jour des lignes budgétaires
 * chemin : 
 * pages  : bSuivInvLb.jsp, mLigneInvLb.jspet mLigneReaLb.jsp
 * pl/sql : suivinv.sql, dprojetliste.sql, investmtliste.sql, projetliste.sql
 */
public class SuiviInvestissementAction extends AutomateAction {

	private static String PACK_SELECT_INV_C = "ligne.investissement.consulter_c.proc";
	private static String PACK_SELECT_INV_M = "ligne.investissement.consulter_m.proc";	
	private static String PACK_INSERT 		= "ligne.investissement.creer.proc";
	private static String PACK_UPDATE 		= "ligne.investissement.modifier.proc";
	private static String PACK_DELETE 		= "ligne.investissement.supprimer.proc";
	private static String PACK_NOTIFY 		= "centre.activite.notifier.proc";
	
	private static String PACK_SELECT_REA_C = "ligne.realisation.consulter_c.proc";
	private static String PACK_INSERT_REA   = "ligne.realisation.creer.proc";
	
	
	
	//private String nomProc;

	/**
		* Action qui permet de créer une ligne d'investissement
		*/
	protected ActionForward creer(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response,
		ActionErrors errors,
		Hashtable hParamProc)
		throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		ParametreProc paramOut;
		boolean msg = false;

		String signatureMethode =
			"SuiviInvestissementAction -creer( mapping, form , request,  response,  errors )";

		logService.entry(signatureMethode);
	
		//exécution de la procédure PL/SQL	
		try {
		vParamOut =	jdbc.getResult(
					
					hParamProc,
					configProc,
					PACK_SELECT_INV_C);
			
			try {
				message = jdbc.recupererResult(vParamOut, "creer");
				//récupérer le code investissement
				for (Enumeration e = vParamOut.elements();e.hasMoreElements();) {
					paramOut = (ParametreProc) e.nextElement();
					if (paramOut.getNom().equals("codinv")) {
						String sCodInv = (String) paramOut.getValeur();
						logBipUser.debug("Code ligne investissement :" + sCodInv);						
						((SuiviInvestissementForm) form).setCodinv(sCodInv);
					}
					
				}
		
			} catch (BaseException be) {
				logBipUser.debug(
					"SuiviInvestissementAction -creer() --> BaseException :" + be);
				logBipUser.debug(
					"SuiviInvestissementAction -creer() --> Exception :"
						+ be.getInitialException().getMessage());
				logBipUser.debug(
					"SuiviInvestissementAction -creer() --> BaseException :" + be);
				logBipUser.debug(
					"SuiviInvestissementAction -creer() --> Exception :"
						+ be.getInitialException().getMessage());
				//Erreur de lecture du resultSet
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				//this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}			
		
		} //try
		catch (BaseException be) {
			logBipUser.debug("SuiviInvestissementAction-creer() --> BaseException :" + be);
			logBipUser.debug(
				"SuiviInvestissementAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			logBipUser.debug("SuiviInvestissementAction-creer() --> BaseException :" + be);
			logBipUser.debug(
				"SuiviInvestissementAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			if (be
				.getInitialException()
				.getClass()
				.getName()
				.equals("java.sql.SQLException")) {
				message =
					BipException.getMessageFocus(
						BipException.getMessageOracle(
							be.getInitialException().getMessage()),
						form);
				((SuiviInvestissementForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");
		
			} else {
				//Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				//this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}
		
		logService.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	} //creer

	/**
		* Action qui permet de visualiser les données liées à un code Personne pour la modification et la suppression
		*/
	protected ActionForward consulter(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response,
		ActionErrors errors,
		Hashtable hParamProc)
		throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode =
			"SuiviInvestissementAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logService.entry(signatureMethode);
	
		// Création d'une nouvelle form
		SuiviInvestissementForm suiviInvestissementForm = (SuiviInvestissementForm) form;
		
		//exécution de la procédure PL/SQL	
		try {
			vParamOut =
				jdbc.getResult(
					
					hParamProc,
					configProc,
					PACK_SELECT_INV_M);
		
			//Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();
		
				//récupérer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();
		
				}
		
				if (paramOut.getNom().equals("curseur")) {
					//Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();
		
					try {
						logBipUser.debug("ResultSet");
						if (rset.next()) {	
							String notifie  = rset.getString("notifie");
							String re_estime  = rset.getString("re_estime");
							if("0".equals(notifie))	{
								notifie = "0,00";					
							}
							if("0".equals(re_estime))	{
								re_estime = "0,00";					
							}
							suiviInvestissementForm.setCodinv(rset.getString("codinv"));
							suiviInvestissementForm.setAnnee(rset.getString("annee"));
							suiviInvestissementForm.setCa(rset.getString("codcamo"));
							suiviInvestissementForm.setType(rset.getString("type"));
							suiviInvestissementForm.setPcode(rset.getString("icpi"));
							suiviInvestissementForm.setDpcode(rset.getString("dpcode"));
							suiviInvestissementForm.setLibelle(rset.getString("libelle"));
							suiviInvestissementForm.setQuantite(rset.getString("quantite"));
							suiviInvestissementForm.setDemande(rset.getString("demande"));
							suiviInvestissementForm.setNotifie(notifie);
							suiviInvestissementForm.setEngage(rset.getString("engage"));
							suiviInvestissementForm.setRe_estime(re_estime);
							suiviInvestissementForm.setDisponible(rset.getString("disponible"));
							suiviInvestissementForm.setFlaglock(rset.getInt("flaglock"));
							//recuperation des libelles 
							suiviInvestissementForm.setLibCa(rset.getString("clibca"));
							suiviInvestissementForm.setLibType(rset.getString("lib_type"));
							suiviInvestissementForm.setLibProjet(rset.getString("ilibel"));
							suiviInvestissementForm.setLibDossierProjet(rset.getString("dplib"));								
							suiviInvestissementForm.setMsgErreur(null);
						} else
							msg = true;
							
						if(rset != null){
							rset.close();
						}
						
		
					} //try
					catch (SQLException sqle) {
						logBipUser.debug(
							"SuiviInvestissementAction-consulter() --> SQLException :"
								+ sqle);
						logBipUser.debug(
							"SuiviInvestissementAction-consulter() --> SQLException :"
								+ sqle);
						//Erreur de lecture du resultSet
						errors.add(
							ActionErrors.GLOBAL_ERROR,
							new ActionError("11217"));
						//this.saveErrors(request,errors);
						 jdbc.closeJDBC(); return mapping.findForward("error");
					}
				} //if
			} //for
			if (msg) {
				//le code Personne n'existe pas, on récupère le message 
				suiviInvestissementForm.setMsgErreur(message);
				//on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		} //try
		catch (BaseException be) {
			logBipUser.debug(
				"SuiviInvestissementAction-consulter() --> BaseException :" + be,
				be);
			logBipUser.debug(
				"SuiviInvestissementAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
		
			logBipUser.debug(
				"SuiviInvestissementAction-consulter() --> BaseException :" + be,
				be);
			logBipUser.debug(
				"SuiviInvestissementAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			//Si exception sql alors extraire le message d'erreur du message global
			if (be
				.getInitialException()
				.getClass()
				.getName()
				.equals("java.sql.SQLException")) {
				message =
					BipException.getMessageFocus(
						BipException.getMessageOracle(
							be.getInitialException().getMessage()),
						form);
				((SuiviInvestissementForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");
		
			} else {
				//Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute(
					"messageErreur",
					be.getInitialException().getMessage());
				//this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}
		

		logService.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	} //consulter

	protected ActionForward suite(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response,
		ActionErrors errors,
		Hashtable hParamProc)
		throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode =
			"SuiviInvestissementAction-suite(paramProc, mapping, form , request,  response,  errors )";

		logService.entry(signatureMethode);

		//exécution de la procédure PL/SQL	
		try {
		vParamOut =	jdbc.getResult(
					
					hParamProc,
					configProc,
					PACK_SELECT_REA_C);
			
			try {
				message = jdbc.recupererResult(vParamOut, "consulter_c");
				logBipUser.debug("Message :" + message);
				//récupérer le code investissement
				for (Enumeration e = vParamOut.elements();e.hasMoreElements();) {
					paramOut = (ParametreProc) e.nextElement();
					if (paramOut.getNom().equals("codrea")) {
						String codRea = (String) paramOut.getValeur();						
						logBipUser.debug("Code ligne realisation :" + codRea);
						
						((SuiviInvestissementForm) form).setCodrea(codRea);
					}					
				}
		
			} catch (BaseException be) {
				logBipUser.debug(
					"SuiviInvestissementAction -creer() --> BaseException :" + be);
				logBipUser.debug(
					"SuiviInvestissementAction -creer() --> Exception :"
						+ be.getInitialException().getMessage());
				logBipUser.debug(
					"SuiviInvestissementAction -creer() --> BaseException :" + be);
				logBipUser.debug(
					"SuiviInvestissementAction -creer() --> Exception :"
						+ be.getInitialException().getMessage());
				//Erreur de lecture du resultSet
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				//this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}			
		
		} //try
		catch (BaseException be) {
			logBipUser.debug("SuiviInvestissementAction-creer() --> BaseException :" + be);
			logBipUser.debug(
				"SuiviInvestissementAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			logBipUser.debug("SuiviInvestissementAction-creer() --> BaseException :" + be);
			logBipUser.debug(
				"SuiviInvestissementAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			if (be
				.getInitialException()
				.getClass()
				.getName()
				.equals("java.sql.SQLException")) {
				message =
					BipException.getMessageFocus(
						BipException.getMessageOracle(
							be.getInitialException().getMessage()),
						form);
				((SuiviInvestissementForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");
		
			} else {
				//Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				//this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}
		
		logService.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("suite");
	}

	protected String recupererCle(String mode) {		
		String cle = null;
		if (mode.equals("insert")) {
			cle = PACK_INSERT;
		} else if (mode.equals("update")) {
			cle = PACK_UPDATE;
		} else if (mode.equals("delete")) {
			cle = PACK_DELETE;
		} else if (mode.equals("notify")) {
			cle = PACK_NOTIFY;
		} else {
			cle = PACK_INSERT_REA;
		}		
		
		  return cle;
	}

}
