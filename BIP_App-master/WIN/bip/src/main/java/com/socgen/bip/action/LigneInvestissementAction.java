/*
 * Created on 12 nov. 03
 * 
 */
package com.socgen.bip.action;

import java.io.IOException;
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
import com.socgen.bip.commun.form.AutomateForm;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.LigneInvestissementForm;
import com.socgen.bip.user.UserBip;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author S.Lallier - 12/11/2003
 *
 * Action de mise à jour des lignes budgétaires
 * chemin : 
 * pages  : bLigneInvLb.jsp, mLigneInvLb.jsp
 * pl/sql : suivinv.sql, dprojetliste.sql, investmtliste.sql, projetliste.sql
 */
public class LigneInvestissementAction extends AutomateAction {

	private static String PACK_SELECT_C = "ligne.investissement.consulter_c.proc";
	private static String PACK_SELECT_M = "ligne.investissement.consulter_m.proc";	
	private static String PACK_INSERT   = "ligne.investissement.creer.proc";
	private static String PACK_UPDATE   = "ligne.investissement.modifier.proc";
	private static String PACK_DELETE   = "ligne.investissement.supprimer.proc";
	private static String PACK_NOTIFY   = "centre.activite.notifier.proc";
	
	private static String TAG_LIGNE_NOTIFIEE = "déjà notifiée";
	


	/**
		* Action qui permet de créer une ligne d'investissement
		*/
	protected ActionForward creer(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		ParametreProc paramOut;
		boolean msg = false;
		String codcamoCourant;
		HttpSession session = null;
		String signatureMethode =
			"LigneInvestissementAction -creer( mapping, form , request,  response,  errors )";

		logService.entry(signatureMethode);
		LigneInvestissementForm bipForm = (LigneInvestissementForm) form;
		session = request.getSession(false);
		UserBip user = (UserBip) session.getAttribute("UserBip");
		//Mettre à jour le code centre activité courant	
		codcamoCourant = bipForm.getCodcamo();
		
		user.setCodcamoCourant(codcamoCourant);
		//exécution de la procédure PL/SQL	
		try {
			vParamOut =	jdbc.getResult(
						
						hParamProc,
						configProc,
						PACK_SELECT_C);
			
			try {
				message = jdbc.recupererResult(vParamOut, "creer");
				//récupérer le code investissement
				for (Enumeration e = vParamOut.elements();e.hasMoreElements();) {
					paramOut = (ParametreProc) e.nextElement();
					if (paramOut.getNom().equals("codinv")) {
						String sCodInv = (String) paramOut.getValeur();												
						((LigneInvestissementForm) form).setCodinv(sCodInv);
					}
					
					if (paramOut.getNom().equals("clibca")) {
						String clibca = (String) paramOut.getValeur();						
						logBipUser.debug("Libellé centre d'activité :" + clibca);						
						((LigneInvestissementForm) form).setLibCa(clibca);
					}	
					
				}
		
			} catch (BaseException be) {
				logBipUser.debug(
					"LigneInvestissementAction -creer() --> BaseException :" + be);
				logBipUser.debug(
					"LigneInvestissementAction -creer() --> Exception :"
						+ be.getInitialException().getMessage());
				logBipUser.debug(
					"LigneInvestissementAction -creer() --> BaseException :" + be);
				logBipUser.debug(
					"LigneInvestissementAction -creer() --> Exception :"
						+ be.getInitialException().getMessage());
				//Erreur de lecture du resultSet
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				//this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}			
		
		} //try
		catch (BaseException be) {
			logBipUser.debug("LigneInvestissementAction-creer() --> BaseException :" + be);
			logBipUser.debug(
				"LigneInvestissementAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			logBipUser.debug("LigneInvestissementAction-creer() --> BaseException :" + be);
			logBipUser.debug(
				"LigneInvestissementAction-creer() --> Exception :"
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
				((LigneInvestissementForm) form).setMsgErreur(message);
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
	protected ActionForward consulter(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParams) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;
		String codcamoCourant;
		HttpSession session = null;
		
		String signatureMethode =
			"LigneInvestissementAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logService.entry(signatureMethode);
	
		// Création d'une nouvelle form
		LigneInvestissementForm ligneInvestissementForm = (LigneInvestissementForm) form;

		session = request.getSession(false);
		UserBip user = (UserBip) session.getAttribute("UserBip");
		//Mettre à jour le code centre activité courant	
		codcamoCourant = ligneInvestissementForm.getCodcamo();
		
		user.setCodcamoCourant(codcamoCourant);		
		//exécution de la procédure PL/SQL	
		try {
			vParamOut =
				jdbc.getResult(
					
					hParams,
					configProc,
					PACK_SELECT_M);
		
			//Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();
		
				//récupérer le message
				if (paramOut.getNom().equals("message")) {					
					message = (String) paramOut.getValeur();
					logBipUser.debug("Message : "+message);
					if ((""+message).indexOf(TAG_LIGNE_NOTIFIEE) > 0){
						//ligne notifée
						ligneInvestissementForm.setIsNotifiee(true);
						//logBipUser.info("La ligne d'investissement est notifiée");
						message = "";
					}
					else {
						logBipUser.debug("pas notifiee");
						ligneInvestissementForm.setIsNotifiee(false);
					}	
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
							ligneInvestissementForm.setCodinv(rset.getString("codinv"));
							ligneInvestissementForm.setAnnee(rset.getString("annee"));
							ligneInvestissementForm.setCodcamo(rset.getString("codcamo"));
							ligneInvestissementForm.setType(rset.getString("type"));
							ligneInvestissementForm.setPcode(rset.getString("icpi"));
							ligneInvestissementForm.setDpcode(rset.getString("dpcode"));
							// On met à jour hParams pour les listes déroulantes
							hParams.put("dpcode", rset.getString("dpcode"));
							ligneInvestissementForm.setLibelle(rset.getString("libelle"));
							ligneInvestissementForm.setQuantite(rset.getString("quantite"));
							ligneInvestissementForm.setDemande(rset.getString("demande"));
							ligneInvestissementForm.setNotifie(notifie);
							ligneInvestissementForm.setEngage(rset.getString("engage"));
							ligneInvestissementForm.setRe_estime(re_estime);
							ligneInvestissementForm.setDisponible(rset.getString("disponible"));
							//kha 30/08/2004
							ligneInvestissementForm.setCominv(rset.getString("cominv"));
							ligneInvestissementForm.setToprp(rset.getString("toprp"));
							//
							ligneInvestissementForm.setFlaglock(rset.getInt("flaglock"));
							//recuperation des libelles 
							ligneInvestissementForm.setLibCa(rset.getString("clibca"));
							ligneInvestissementForm.setLibType(rset.getString("lib_type"));
							ligneInvestissementForm.setLibProjet(rset.getString("ilibel"));
							ligneInvestissementForm.setLibDossierProjet(rset.getString("dplib"));								
							ligneInvestissementForm.setMsgErreur(null);
						} else msg = true;
							
						if(rset != null){
							rset.close();
						}
						
		
					} //try
					catch (SQLException sqle) {
						logBipUser.debug(
							"LigneInvestissementAction-consulter() --> SQLException :"
								+ sqle);
						logBipUser.debug(
							"LigneInvestissementAction-consulter() --> SQLException :"
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
				logBipUser.debug("MSG : " + message);
				//la ligne d'investissement n'existe pas, on récupère le message 
				ligneInvestissementForm.setMsgErreur(message);
				//on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		} //try
		catch (BaseException be) {
			logBipUser.debug(
				"LigneInvestissementAction-consulter() --> BaseException :" + be,
				be);
			logBipUser.debug(
				"LigneInvestissementAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
		
			logBipUser.debug(
				"LigneInvestissementAction-consulter() --> BaseException :" + be,
				be);
			logBipUser.debug(
				"LigneInvestissementAction-consulter() --> Exception :"
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
				((LigneInvestissementForm) form).setMsgErreur(message);
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
		} 
		
		  return cle;
	}

	public ActionForward bipPerform(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response,Hashtable hParamProc) throws IOException, ServletException{
		//ActionErrors errors = new ActionErrors();
		ActionForward  actionForward = null ;
		HttpSession session = request.getSession(false);
	
		String action = null;
		String sMode = null;
				
		AutomateForm automateForm = (AutomateForm)form ;
		
		// Extraction de la valeur action
		action = automateForm.getAction() ;
		
		logService.entry("Début Action  = " + action);

		// Actions pour les listes multi-pages
		if (PAGE_INDEX.equals(action))
		{
			savePage(mapping, form , request, response,errors );
			actionForward = pageIndex(mapping,form, request, response, errors) ;
		}
		
		if (PAGE_SUIVANTE.equals(action))
		{
			savePage(mapping, form , request, response,errors );
			actionForward = pageSuivante(mapping,form, request, response, errors) ;
		}
		if (PAGE_PRECEDENTE.equals(action))
		{
			savePage(mapping, form , request, response,errors );
			actionForward = pagePrecedente(mapping,form, request, response, errors) ;
		}
		// Actions courantes
		if (ACTION_ANNULER.equals(action)){
			actionForward = annuler(mapping,form, request, response , errors,hParamProc) ;
		}
		else if (ACTION_SUITE.equals(action)) {	
			actionForward = suite(mapping,form, request, response , errors,hParamProc) ;
		}
		else if (ACTION_CREER.equals(action)){
			//on sauvegarde le titre de la page
			automateForm.setTitrePage("Créer");
			automateForm.setMode("insert");
			actionForward = creer(mapping,form, request, response , errors,hParamProc) ;
		}
		else if (ACTION_MODIFIER.equals(action)){
			//on sauvegarde le titre de la page
			automateForm.setTitrePage("Modifier");
			automateForm.setMode("update");
			actionForward = consulter(mapping,form, request, response , errors,hParamProc) ;
		}
		else if (ACTION_SUPPRIMER.equals(action)){
			//on sauvegarde le titre de la page
			automateForm.setTitrePage("Supprimer");
			automateForm.setMode("delete");
			actionForward = consulter(mapping,form, request, response , errors,hParamProc) ;
		}
		else if (ACTION_VALIDER.equals(action)){
			sMode  = automateForm.getMode() ;
			String codcamoCourant;
			LigneInvestissementForm bipForm = (LigneInvestissementForm) form;
			UserBip user = (UserBip) session.getAttribute("UserBip");
			//Mettre à jour le code centre activité courant	
			codcamoCourant = bipForm.getCodcamo();
			user.setCodcamoCourant(codcamoCourant);
			actionForward = valider(mapping, form, sMode, request, response , errors,hParamProc);
		}
		else if (ACTION_REFRESH.equals(action)){
			// On recharge la même page(ecran)
			actionForward = refresh(mapping,form, request, response , errors,hParamProc);
		}
		
		if ( actionForward == null ) {
			errors.add(ActionErrors.GLOBAL_ERROR , new ActionError("error.action.inconnue" , action ));
			//this.saveErrors(request,errors);
			logService.error("l'action [" + action + "] est inconnue");
			return mapping.findForward("error") ;
		}else {
			logService.exit("Fin Action  = " + action);
			return actionForward ;
		}
}//perform
}
