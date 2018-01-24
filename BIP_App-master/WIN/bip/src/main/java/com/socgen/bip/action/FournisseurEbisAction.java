package com.socgen.bip.action;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.StringTokenizer;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.socgen.bip.commun.form.AutomateForm;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.FournisseurEbisForm;
import com.socgen.bip.form.FournisseurForm;
import com.socgen.cap.fwk.exception.BaseException;

import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;


public class FournisseurEbisAction extends SocieteAction {

	private static String PACK_SELECT = "ebis.fournisseur.consulter.proc";
	private static String PACK_INSERT = "ebis.fournisseur.creer.proc";
	private static String PACK_UPDATE = "ebis.fournisseur.modifier.proc";
	private static String PACK_DELETE = "ebis.fournisseur.supprimer.proc";	
//	private static String PACK_SELECT_LIGNE = "ebis.fournisseur.consulter.ligne.proc";
	

	/**
	 * Action qui permet de créer un code fournisseur
	 */
	protected ActionForward creer(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";

		String signatureMethode = "FournisseurEbisAction -creer( mapping, form , request,  response,  errors )";

		// logService.entry(signatureMethode);;
		logBipUser.entry(signatureMethode);
		// exécution de la procédure PL/SQL
		try {
			
			hParamProc.put("fsiren", "0");
			  
			hParamProc.put("perimetre", "");
			hParamProc.put("referentiel", "");
			hParamProc.put("fournebis", "");
			
			
			
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT);
			try {
				message = jdbc.recupererResult(vParamOut, "creer");

			} catch (BaseException be) {
				logBipUser.debug("FournisseurEbisAction -creer() --> BaseException :"	+ be);
				logBipUser.debug("FournisseurEbisAction -creer() --> Exception :"+ be.getInitialException().getMessage());
				logService.debug("FournisseurEbisAction -creer() --> BaseException :"	+ be);
				logService.debug("FournisseurEbisAction -creer() --> Exception :"+ be.getInitialException().getMessage());
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				jdbc.closeJDBC(); 
				return mapping.findForward("error");
			}
			if (!message.equals("")) {
				((FournisseurEbisForm) form).setMsgErreur(message);
				logBipUser.debug("message d'erreur:" + message);
				logBipUser.exit(signatureMethode);
			    jdbc.closeJDBC();
			    return mapping.findForward("initial");
			}

		}// try
		catch (BaseException be) {
			logBipUser.debug("FournisseurEbisAction-creer() --> BaseException :"+ be);
			logBipUser.debug("FournisseurEbisAction-creer() --> Exception :"+ be.getInitialException().getMessage());
			logService.debug("FournisseurEbisAction-creer() --> BaseException :"+ be);
			logService.debug("FournisseurEbisAction-creer() --> Exception :"+ be.getInitialException().getMessage());
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
			jdbc.closeJDBC();
			return mapping.findForward("error");
		}

		((FournisseurEbisForm) form).setFournebis(""); 
		
		// logService.exit(signatureMethode);
		logBipUser.exit(signatureMethode);

		
		 jdbc.closeJDBC(); 
		 return mapping.findForward("ecran");
	}// creer

	/**
	 * Action qui permet de visualiser les données liées à un code client pour
	 * la modification et la suppression
	 */
	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = "FournisseurEbisAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		FournisseurEbisForm bipForm = (FournisseurEbisForm) form;
		// exécution de la procédure PL/SQL
		try {
			
			bipForm =  decodeClef(bipForm) ; 			

			hParamProc.put("perimetre", bipForm.getPerimetre());
			hParamProc.put("referentiel", bipForm.getReferentiel());
			hParamProc.put("fournebis", bipForm.getFournebis());

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
						logService.debug("ResultSet");
						if (rset.next()) {
							// Code Societe
							bipForm.setSoccode(rset.getString(1));
							// Numero SIREN
							bipForm.setFsiren(rset.getString(2));
							// Code Perimetre
							bipForm.setPerimetre(rset.getString(3));
							// Code Referentiel
							bipForm.setReferentiel(rset.getString(4));
						    // Code Fournisseur Expense Bis
							bipForm.setFournebis(rset.getString(5));
							// Code Flaglock pour les acces concurrents
							bipForm.setFlaglock(rset.getInt(6));
							
							// Mise a jour des anciens parametres
							bipForm.setFournebis_sav(bipForm.getFournebis());
							bipForm.setPerimetre_sav(bipForm.getPerimetre()); 
							bipForm.setReferentiel_sav(bipForm.getReferentiel());
							bipForm.setFsiren_sav(bipForm.getFsiren());
							
					} else
							msg = true;

					}// try
					catch (SQLException sqle) {
						logService.debug("FournisseurEbisAction-consulter() --> SQLException :"+ sqle);
						logBipUser.debug("FournisseurEbisAction-consulter() --> SQLException :"+ sqle);
						// Erreur de lecture du resultSet
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
						// this.saveErrors(request,errors);
						 jdbc.closeJDBC();
						 return mapping.findForward("error");
					} finally {
						try {
							if (rset != null)
								rset.close();
						} catch (SQLException sqle) {
							logBipUser
									.debug("FournisseurEbisAction-consulter() --> SQLException-rset.close() :"
											+ sqle);
							// Erreur de lecture du resultSet
							errors.add(ActionErrors.GLOBAL_ERROR,
									new ActionError("11217"));
							 jdbc.closeJDBC(); 
							 return mapping.findForward("error");
						}
					}
				}// if
			}// for
			if (msg) {
				// le code fournisseur n'existe pas, on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		}// try
		catch (BaseException be) {
			logBipUser.debug("FournisseurEbisAction-consulter() --> BaseException :" + be,be);
			logBipUser.debug("FournisseurEbisAction-consulter() --> Exception :"+ be.getInitialException().getMessage());
			logService.debug("FournisseurEbisAction-consulter() --> BaseException :" + be,be);
			logService.debug("FournisseurEbisAction-consulter() --> Exception :"+ be.getInitialException().getMessage());
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));

			// this.saveErrors(request,errors);
			 jdbc.closeJDBC(); 
			 return mapping.findForward("error");
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

	protected ActionForward suite1(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
	  return mapping.findForward("initial");
	}
	
	/**
	 * Voir procedure PACK_LISTE_FOURNISSEUR_EBIS.LISTER_FOURNISSEUR_EBIS
	 * La procedure PL/SQL retourne une clef composee par
	 *  clef = "SOCCODE;PERIMETRE;REFERENTIEL;CODE_FOURNISSEUR_EBIS"
	 *  (Donnees provenant de la table EBIS_FOURNISSEURS)
	 *  ex: "WAND;FR001;RF001;123456789"  
	 *             
	 * @param hParamProc
	 * @param clef
	 * @return bipform
	 */
	private FournisseurEbisForm decodeClef(FournisseurEbisForm bipForm ){
		StringTokenizer st = new StringTokenizer(bipForm.getFournebis());
		bipForm.setSoccode(st.nextToken(";")) ; 
		bipForm.setPerimetre(st.nextToken(";")) ;
		bipForm.setReferentiel(st.nextToken(";")) ;
		bipForm.setFournebis(st.nextToken(";")) ;					
		return bipForm ; 
	}
	
	protected  ActionForward annuler(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors,Hashtable hParamProc  ) throws ServletException{
		  return mapping.findForward("depart") ;
	}	
	
}
