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
import com.socgen.bip.form.LigneRealisationForm;
import com.socgen.bip.user.UserBip;
import com.socgen.cap.fwk.exception.BaseException;
/**
 * @author S.Lallier - 12/11/2003
 *
 * Action de mise à jour des lignes budgétaires
 * chemin : 
 * pages  : bLigneReaLb.jsp, mLigneReaLb.jsp
 * pl/sql : suivinv.sql, dprojetliste.sql, investmtliste.sql, projetliste.sql
 */
public class LigneRealisationAction extends AutomateAction {
	private static String PACK_SELECT_REA_C = "ligne.realisation.consulter_c.proc";
	private static String PACK_SELECT_REA_M = "ligne.realisation.consulter_m.proc";	
	private static String PACK_INSERT       = "ligne.realisation.creer.proc";
	private static String PACK_UPDATE 		= "ligne.realisation.modifier.proc";
	private static String PACK_DELETE 		= "ligne.realisation.supprimer.proc";
	

	
	//private String nomProc;	

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
		String codcamoCourant;
		HttpSession session = null;
		
		String signatureMethode =
			"LigneRealisationAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logService.entry(signatureMethode);
	
		// Création d'une nouvelle form
		LigneRealisationForm ligneRealisationForm = (LigneRealisationForm) form;

		session = request.getSession(false);
		UserBip user = (UserBip) session.getAttribute("UserBip");
		//Mettre à jour le code centre activité courant	
		codcamoCourant = ligneRealisationForm.getCodcamo();
		if (codcamoCourant!=null)
		user.setCodcamoCourant(codcamoCourant);			
		//exécution de la procédure PL/SQL	
		try {
			vParamOut =
				jdbc.getResult(
					
					hParamProc,
					configProc,
					PACK_SELECT_REA_M);
		
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
							ligneRealisationForm.setCodrea(rset.getString("codrea"));
							ligneRealisationForm.setDate_saisie(rset.getString("date_saisie"));
							ligneRealisationForm.setEngage(rset.getString("engage"));
							ligneRealisationForm.setMarque(rset.getString("marque"));
							ligneRealisationForm.setComrea(rset.getString("comrea"));/* td124*/
							ligneRealisationForm.setModele(rset.getString("modele"));
							ligneRealisationForm.setNum_cmd(rset.getString("num_cmd"));
							ligneRealisationForm.setType_cmd(rset.getString("type_cmd"));
							ligneRealisationForm.setType_eng(rset.getString("type_eng"));
					
							ligneRealisationForm.setType_ligne(rset.getString(13/*"type_ligne"*/));
							ligneRealisationForm.setProjet(rset.getString(14/*"type_cmd"*/));
							ligneRealisationForm.setDossier_projet(rset.getString(15/*"type_eng"*/));
							ligneRealisationForm.setDisponible(rset.getString("disponible"));
							ligneRealisationForm.setDisponible_htr(rset.getString("disponible_htr"));
							ligneRealisationForm.setFlaglock(rset.getInt("flaglock"));
							ligneRealisationForm.setLibCa(rset.getString("clibca"));						 														
							ligneRealisationForm.setMsgErreur(null);
						} else
							msg = true;
							
						if(rset != null){
							rset.close();
						}
						
		
					} //try
					catch (SQLException sqle) {
						logBipUser.debug(
							"LigneRealisationAction-consulter() --> SQLException :"
								+ sqle);
						logBipUser.debug(
							"LigneRealisationAction-consulter() --> SQLException :"
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
				ligneRealisationForm.setMsgErreur(message);
				//on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		} //try
		catch (BaseException be) {
			logBipUser.debug(
				"LigneRealisationAction-consulter() --> BaseException :" + be,
				be);
			logBipUser.debug(
				"LigneRealisationAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
		
			logBipUser.debug(
				"LigneRealisationAction-consulter() --> BaseException :" + be,
				be);
			logBipUser.debug(
				"LigneRealisationAction-consulter() --> Exception :"
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
				((LigneRealisationForm) form).setMsgErreur(message);
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
	/**
		* Action qui permet de visualiser les données liées à un code Personne pour la modification et la suppression
		*/
	protected ActionForward suite(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response,
		ActionErrors errors, 
		Hashtable hParamProc)
		throws ServletException {

		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;
		String codcamoCourant;
		HttpSession session = null;
		
		// Création d'une nouvelle form
		LigneRealisationForm ligneRealisationForm = (LigneRealisationForm) form;

		session = request.getSession(false);
		UserBip user = (UserBip) session.getAttribute("UserBip");
		//Mettre à jour le code centre activité courant	
		
		codcamoCourant = ligneRealisationForm.getCodcamo();
		if (codcamoCourant!=null)
		user.setCodcamoCourant(codcamoCourant);			

		  return super.suite(mapping, form, request,response,errors,hParamProc);
	} //consulter

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
		boolean msg = false;
		ParametreProc paramOut;
		String codcamoCourant;
		HttpSession session = null;
		String signatureMethode =
			"LigneRealisationAction-suite(paramProc, mapping, form , request,  response,  errors )";

		logService.entry(signatureMethode);
		// Création d'une nouvelle form
			LigneRealisationForm ligneRealisationForm = (LigneRealisationForm) form;

			session = request.getSession(false);
			UserBip user = (UserBip) session.getAttribute("UserBip");
			//Mettre à jour le code centre activité courant	
			codcamoCourant = ligneRealisationForm.getCodcamo();
		
			user.setCodcamoCourant(codcamoCourant);	
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
					logBipUser.debug("param : " + paramOut.getNom());
					if (paramOut.getNom().equals("codrea")) {
						String codRea = (String) paramOut.getValeur();						
						logBipUser.debug("Code ligne realisation :" + codRea);						
						((LigneRealisationForm) form).setCodrea(codRea);
					}	
					if (paramOut.getNom().equals("clibca")) {
						String clibca = (String) paramOut.getValeur();						
						logBipUser.debug("Libellé centre d'activité :" + clibca);						
						((LigneRealisationForm) form).setLibCa(clibca);
					}
					if (paramOut.getNom().equals("type_ligne"))
					{
						String type_ligne = (String) paramOut.getValeur();						
						logBipUser.debug("Type d'investissement :" + type_ligne);						
						((LigneRealisationForm) form).setType_ligne(type_ligne);
					}
					if (paramOut.getNom().equals("projet"))
					{
						String projet = (String) paramOut.getValeur();						
						logBipUser.debug("Projet :" + projet);						
						((LigneRealisationForm) form).setProjet(projet);
					}
					if (paramOut.getNom().equals("dossier_projet"))
					{
						String dossier_projet = (String) paramOut.getValeur();						
						logBipUser.debug("Type d'investissement :" + dossier_projet);						
						((LigneRealisationForm) form).setDossier_projet(dossier_projet);
					}
					if (paramOut.getNom().equals("disponible"))
					{
						String dispo = (String) paramOut.getValeur();						
						logBipUser.debug("Disponible :" + dispo);						
						((LigneRealisationForm) form).setDisponible(dispo);
					}	
					if (paramOut.getNom().equals("disponible_htr"))
					{
						String dispo_htr = (String) paramOut.getValeur();						
						logBipUser.debug("Disponible_htr :" + dispo_htr);						
						((LigneRealisationForm) form).setDisponible_htr(dispo_htr);
					}				
				}
		
			} catch (BaseException be) {
				logBipUser.debug(
					"LigneRealisationAction -creer() --> BaseException :" + be);
				logBipUser.debug(
					"LigneRealisationAction -creer() --> Exception :"
						+ be.getInitialException().getMessage());
				logBipUser.debug(
					"LigneRealisationAction -creer() --> BaseException :" + be);
				logBipUser.debug(
					"LigneRealisationAction -creer() --> Exception :"
						+ be.getInitialException().getMessage());
				//Erreur de lecture du resultSet
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				//this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}			
		
		} //try
		catch (BaseException be) {
			logBipUser.debug("LigneRealisationAction-creer() --> BaseException :" + be);
			logBipUser.debug(
				"LigneRealisationAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			logBipUser.debug("LigneRealisationAction-creer() --> BaseException :" + be);
			logBipUser.debug(
				"LigneRealisationAction-creer() --> Exception :"
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
				((LigneRealisationForm) form).setMsgErreur(message);
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
	}//fin creer

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
