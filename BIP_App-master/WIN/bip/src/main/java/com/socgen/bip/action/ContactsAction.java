package com.socgen.bip.action;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.List;
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
import com.socgen.bip.form.ContactsForm;
import com.socgen.cap.fwk.exception.BaseException;


/**
 * @author CMA - 01/03/2011
 *
 * Action permettant d'afficher les contacts dans une fenêtre Popup d'après les paramètres BIP 
 * 
 *  
 */

public class ContactsAction extends AutomateAction {

	
	
	
	private static String PACK_SELECT = "parambip.recuperer.proc";

	/**
	 * Constructor for AddFavorisAction.
	 */
	public ContactsAction() {
		super();
	}

	/**
	* Action permettant le premier appel de la JSP
	*  	
	*/
	protected ActionForward initialiser(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response,
		ActionErrors errors,
		Hashtable hParams)
		throws ServletException {

		String signatureMethode =
			this.getClass().getName() + " - initialiser(paramProc, mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);
		ContactsForm contactsForm = (ContactsForm) form;
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		ParametreProc paramOut;
		String message = "";
		boolean msg = false;
		List<String> contacts = new ArrayList<String>();
		List<String> versions = new ArrayList<String>();
		
		try {
			
			//On récupère les contacts
			hParams.put("codaction", "CONTACTS");
			hParams.put("codversion", "CONTACTS");
			hParams.put("actives", "O");
			hParams.put("nbLignes", "6");
			
			vParamOut = jdbc.getResult(
					hParams, configProc, PACK_SELECT);

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
						while (rset.next()) {
							String valeur = rset.getString(18).replaceAll("[\r\n]+", "");
							if (valeur.length()<=100){
								contacts.add(valeur.replace(" ", "&nbsp;"));
							}else if(valeur.length()>100 && valeur.length()<=200){
								contacts.add(valeur.substring(0, 100).replace(" ", "&nbsp;"));
								contacts.add(valeur.substring(100).replace(" ", "&nbsp;"));
							}else if (valeur.length()>200){
								contacts.add(valeur.substring(0, 100).replace(" ", "&nbsp;"));
								contacts.add(valeur.substring(100,200).replace(" ", "&nbsp;"));
								contacts.add(valeur.substring(200).replace(" ", "&nbsp;"));
							}
						}
					}catch (SQLException sqle) {
						logService.debug("ContactsAction-initialiser() --> SQLException :"+ sqle);
						logBipUser.debug("ContactsAction-initialiser() --> SQLException :"+ sqle);
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
							logBipUser.debug("ContactsAction-initialiser() --> SQLException-rset.close() :"+ sqle);
							// Erreur de lecture du resultSet
							errors.add(ActionErrors.GLOBAL_ERROR,new ActionError("11217"));
							jdbc.closeJDBC(); 
							return mapping.findForward("error");
						}
					}
				} // if
			} // for
			
			//On récupère la version
			hParams.put("codaction", "CONTACTS");
			hParams.put("codversion", "VERSION");
			hParams.put("actives", "O");
			hParams.put("nbLignes", "1");
			
			vParamOut = jdbc.getResult(
					hParams, configProc, PACK_SELECT);

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
						while (rset.next()) {
							String valeur = rset.getString(18).replaceAll("[\r\n]+", "");
							if (valeur.length()<=100){
								versions.add(valeur.replace(" ", "&nbsp;"));
							}else if(valeur.length()>100 && valeur.length()<=200){
								versions.add(valeur.substring(0, 100).replace(" ", "&nbsp;"));
								versions.add(valeur.substring(100).replace(" ", "&nbsp;"));
							}else if (valeur.length()>200){
								versions.add(valeur.substring(0, 100).replace(" ", "&nbsp;"));
								versions.add(valeur.substring(100,200).replace(" ", "&nbsp;"));
								versions.add(valeur.substring(200).replace(" ", "&nbsp;"));
							}
						}
					}catch (SQLException sqle) {
						logService.debug("ContactsAction-initialiser() --> SQLException :"+ sqle);
						logBipUser.debug("ContactsAction-initialiser() --> SQLException :"+ sqle);
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
							logBipUser.debug("ContactsAction-initialiser() --> SQLException-rset.close() :"+ sqle);
							// Erreur de lecture du resultSet
							errors.add(ActionErrors.GLOBAL_ERROR,new ActionError("11217"));
							jdbc.closeJDBC(); 
							return mapping.findForward("error");
						}
					}
				} // if
			} // for
			if (msg) {
				// Le couple code action / code version n'existe pas
				contactsForm.setMsgErreur(message);
				// on reste sur la même page
				jdbc.closeJDBC(); 
				contactsForm.setListeContacts(contacts);
				contactsForm.setListeVersions(versions);
				return mapping.findForward("initial");
			}
			
		} // try
		catch (BaseException be) {
			logBipUser.debug("ContactsAction-initialiser() --> BaseException :"+ be, be);
			logBipUser.debug("ContactsAction-initialiser() --> Exception :"+ be.getInitialException().getMessage());
			logService.debug("ContactsAction-initialiser() --> BaseException :"+ be, be);
			logService.debug("ContactsAction-initialiser() --> Exception :"+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals("java.sql.SQLException")) {
				message = BipException.getMessageFocus(BipException.getMessageOracle(be.getInitialException().getMessage()), form);
				((ContactsForm) form).setMsgErreur(message);
				jdbc.closeJDBC();
				contactsForm.setListeContacts(contacts);
				contactsForm.setListeVersions(versions);
				return mapping.findForward("initial");
			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				// this.saveErrors(request,errors);
				jdbc.closeJDBC(); 
				return mapping.findForward("error");
			}
		}
	  contactsForm.setListeContacts(contacts);
	  contactsForm.setListeVersions(versions);
	  return mapping.findForward("initial");
	}

	public ActionForward rtfe(
			ActionMapping mapping,
			ActionForm form,
			HttpServletRequest request,
			HttpServletResponse response,
			ActionErrors errors,
			Hashtable hParams)
			throws ServletException {
		String signatureMethode =
			this.getClass().getName() + " - rtfe(paramProc, mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);
		ContactsForm contactsForm = (ContactsForm) form;
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		ParametreProc paramOut;
		String message = "";
		boolean msg = false;
		List<String> contacts = new ArrayList<String>();
		
		//paramsession si l'utilisateur vient de l'écran paramètres session, vide sinon
		contactsForm.setType(request.getParameter("type"));
		
		try {
			
			//On récupère les contacts
			hParams.put("codaction", "CONTACTS");
			hParams.put("codversion", "CONTACTS");
			hParams.put("actives", "O");
			hParams.put("nbLignes", "6");
			
			vParamOut = jdbc.getResult(
					hParams, configProc, PACK_SELECT);

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
						while (rset.next()) {
							String valeur = rset.getString(18).replaceAll("[\r\n]+", "");
							if (valeur.length()<=100){
								contacts.add(valeur.replace(" ", "&nbsp;"));
							}else if(valeur.length()>100 && valeur.length()<=200){
								contacts.add(valeur.substring(0, 100).replace(" ", "&nbsp;"));
								contacts.add(valeur.substring(100).replace(" ", "&nbsp;"));
							}else if (valeur.length()>200){
								contacts.add(valeur.substring(0, 100).replace(" ", "&nbsp;"));
								contacts.add(valeur.substring(100,200).replace(" ", "&nbsp;"));
								contacts.add(valeur.substring(200).replace(" ", "&nbsp;"));
							}
						}
					}catch (SQLException sqle) {
						logService.debug("ContactsAction-rtfe() --> SQLException :"+ sqle);
						logBipUser.debug("ContactsAction-rtfe() --> SQLException :"+ sqle);
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
							logBipUser.debug("ContactsAction-rtfe() --> SQLException-rset.close() :"+ sqle);
							// Erreur de lecture du resultSet
							errors.add(ActionErrors.GLOBAL_ERROR,new ActionError("11217"));
							jdbc.closeJDBC(); 
							return mapping.findForward("error");
						}
					}
				} // if
			} // for
			if (msg) {
				// Le couple code action / code version n'existe pas
				contactsForm.setMsgErreur(message);
				// on reste sur la même page
				jdbc.closeJDBC(); 
				contactsForm.setListeContacts(contacts);
				return mapping.findForward("rtfe");
			}
			
		} // try
		catch (BaseException be) {
			logBipUser.debug("ContactsAction-rtfe() --> BaseException :"+ be, be);
			logBipUser.debug("ContactsAction-rtfe() --> Exception :"+ be.getInitialException().getMessage());
			logService.debug("ContactsAction-rtfe() --> BaseException :"+ be, be);
			logService.debug("ContactsAction-rtfe() --> Exception :"+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals("java.sql.SQLException")) {
				message = BipException.getMessageFocus(BipException.getMessageOracle(be.getInitialException().getMessage()), form);
				((ContactsForm) form).setMsgErreur(message);
				jdbc.closeJDBC();
				contactsForm.setListeContacts(contacts);
				return mapping.findForward("rtfe");
			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				// this.saveErrors(request,errors);
				jdbc.closeJDBC(); 
				return mapping.findForward("error");
			}
		}
	  contactsForm.setListeContacts(contacts);
	  return mapping.findForward("rtfe");
	}
	

}