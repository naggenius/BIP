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
import com.socgen.bip.form.DpcopiForm;
import com.socgen.bip.form.NotationDpcopiForm;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * 
 * @author X060314 
 * JAL 15/07/2008 
 * fiche 662 : DP COPI -> partie qualitative
 * On veut pourvoir noter, qualifier les DPCOPI
 *
 */
public class NotationDpcopiAction extends AutomateAction {

	private static String PACK_VERIF= "verifie.notation.copi.proc";
	
	private static String PACK_SELECT = "dpcopi.notification.consulter.proc"; 

	private static String PACK_INSERT = "dpcopi.notification.creer.proc";

	private static String PACK_UPDATE = "dpcopi.notification.modifier.proc";

	private static String PACK_DELETE = "dpcopi.notification.supprimer.proc";
	 
	
	

	private String nomProc;

	
	protected  ActionForward annuler(ActionMapping mapping,ActionForm form , 
					HttpServletRequest request, HttpServletResponse response, 
					ActionErrors errors,Hashtable hParamProc  ) throws ServletException{
		logBipUser.debug("######## Annuler ##############"); 
		  return mapping.findForward("initial") ;
	}
	
		
	/**
	 * Action qui permet de créer un dpcopi
	 */
	protected ActionForward creer(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = "DpcopiAction -creer( mapping, form , request,  response,  errors )";

		// logService.entry(signatureMethode);;
		logBipUser.entry(signatureMethode); 
		// exécution de la procédure PL/SQL 
	   try {

			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_VERIF); 
			
				for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
					paramOut = (ParametreProc) e.nextElement();
					// récupérer le message 
					if (paramOut.getNom().equals("message")) { 				 
						message = (String) paramOut.getValeur(); 
					}
				}  
		 
			if (message!=null && !message.equals("")) {
				// Entité déjà existante, on récupère le message
				((NotationDpcopiForm) form).setMsgErreur(message);

				logBipUser.debug("message d'erreur:" + message);
				logBipUser.exit(signatureMethode);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}

		}// try
		catch (BaseException be) {
			logBipUser.debug("DpcopiAction-creer() --> BaseException :" + be);
			logBipUser.debug("DpcopiAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("DpcopiAction-creer() --> BaseException :" + be);
			logService.debug("DpcopiAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((NotationDpcopiForm) form).setMsgErreur(message);
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

		// logService.exit(signatureMethode);
		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); 
		 return mapping.findForward("ecran");
	}// creer

	/**
	 * Action qui permet de visualiser les données liées à dpcopi pour
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
		String sClibrca;

		String signatureMethode = "ClientAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode); 
		// Création d'une nouvelle form
		NotationDpcopiForm bipForm = (NotationDpcopiForm) form;
 
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

				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();
					logBipUser.debug("Méthode lecture OK : parcours resulset!!") ;
					try {
					 
						if (rset.next()) { 
								bipForm.setEtape(rset.getString(2));
								bipForm.setDirecteurProjet(rset.getString(3));
								bipForm.setResponsableBancaire(rset.getString(4));
								bipForm.setSponsors(rset.getString(5)); 
								bipForm.setAxeStrategique(rset.getString(6));
								bipForm.setBloc(rset.getString(7));
								bipForm.setDomaine(rset.getString(8));
								bipForm.setNoteStrategique(rset.getString(9));
								bipForm.setNoteRoi(rset.getString(10));
								bipForm.setProchainCopi(rset.getString(11));
								bipForm.setDirectionRB(rset.getString(12)); 
								bipForm.setFlaglock(rset.getInt(13)); 
								bipForm.setLibelleEtape(rset.getString(14)) ; 
								bipForm.setLibelleAxe(rset.getString(15)) ; 
								bipForm.setLibelleBloc(rset.getString(16)) ;
								bipForm.setLibelleDomaine(rset.getString(17)) ;								 
							} else
							msg = true;

					}// try
					catch (SQLException sqle) {
						logService
								.debug("DpcopiAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("DpcopiAction-consulter() --> SQLException :"
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
									.debug("DpcopiAction-consulter() --> SQLException-rset.close() :"
											+ sqle);
							// Erreur de lecture du resultSet
							errors.add(ActionErrors.GLOBAL_ERROR,
									new ActionError("11217"));
							 jdbc.closeJDBC(); return mapping.findForward("error");
						}

					}
				}// if
			}// for
			if (msg) {
				// le code Camo n'existe pas, on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		}// try
		catch (BaseException be) {
			logBipUser.debug("DpcopiAction-consulter() --> BaseException :" + be,
					be);
			logBipUser.debug("DpcopiAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("DpcopiAction-consulter() --> BaseException :" + be,
					be);
			logService.debug("DpcopiAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));

			// this.saveErrors(request,errors);
			 jdbc.closeJDBC(); return mapping.findForward("error");
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
		logBipUser.debug("######## Clef ##############"); 
		  return cle;
	}

}
