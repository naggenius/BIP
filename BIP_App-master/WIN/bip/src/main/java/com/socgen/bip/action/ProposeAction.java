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
import com.socgen.bip.form.ProposeForm;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author MMC - 08/07/2003
 * 
 * Mise à jour des proposes chemin : Ligne Bip/Gestion/Proposes pages :
 * fProposeAd.jsp et Propose.jsp pl/sql : proposes.sql
 */
public class ProposeAction extends AutomateAction {

	private static String PACK_SELECT = "propose.consulter.proc";

	private static String PACK_INSERT = "propose.creer.proc";

	private static String PACK_UPDATE = "propose.modifier.proc";

	private static String PACK_DELETE = "propose.supprimer.proc";
	
	private String nomProc;
	
	
	
	
	public static String  LIGNEBIP_TYPE_PROJET_9 = "9"; 
	public static String  LIGNEBIP_MSG_ERROR_TYPE_PROJET_9 = "Ligne de répartition (T9) pas de saisie autorisée.";
		


	
	/**
	 * Le String reçu de type ligne Bip en provenance du Resultset
	 * a le format [valeur, ]
	 * donc le equals ne marchera que si l'on récupère le premier char (valeur)  
	 * 
	 * Renvoi un message erreur si le type de ligne = 9 , null sinon
	 * 
	 * @param valueTypeInTwoChars
	 * @return
	 */
	 public static String errorLigneTypeT9(String valueTypeInTwoChars){				
			char caract = valueTypeInTwoChars.charAt(0) ;
			char[] chaine = {caract};  
			String chaineFinale = new String(chaine) ; 
			if(chaineFinale.equals(ProposeAction.LIGNEBIP_TYPE_PROJET_9)){
				return ProposeAction.LIGNEBIP_MSG_ERROR_TYPE_PROJET_9 ; 
			}
			return null; 		 
	 }
	 
	 
	 

	/**
	 * Action qui permet de visualiser les données liées à une ligne bip pour la
	 * modification et la création du proposé d'une année
	 */
	protected ActionForward suite(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParams) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = "ProposeAction-suite(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		ProposeForm bipForm = (ProposeForm) form;

		// exécution de la procédure PL/SQL
		try {
			vParamOut = jdbc.getResult(hParams,
					configProc, PACK_SELECT);

			// Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();
				
				
				//récupérer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();

				}
				
				if (paramOut.getNom().equals("mode")) {
					String sMode = (String) paramOut.getValeur();
					logService.debug("Mode retourné par plsql :" + sMode);
					((ProposeForm) form).setMode(sMode);
				}// if
				//
				if (paramOut.getNom().equals("pnom")) {
					String sPnom = (String) paramOut.getValeur();
					logService.debug("Pnom :" + sPnom);
					((ProposeForm) form).setPnom(sPnom);
				}// if

				if (paramOut.getNom().equals("bpmontme")) {
					String sBpmontme = (String) paramOut.getValeur();
					logService.debug("Bpmontme :" + sBpmontme);
					((ProposeForm) form).setBpmontme(sBpmontme);
				}// if

				if (paramOut.getNom().equals("bpmontmo")) {
					String sBpmontmo = (String) paramOut.getValeur();
					logService.debug("Bpmontmo :" + sBpmontmo);
					((ProposeForm) form).setBpmontmo(sBpmontmo);
				}// if

				if (paramOut.getNom().equals("perime")) {
					String sPerime = (String) paramOut.getValeur();
					logService.debug("Perime :" + sPerime);
					((ProposeForm) form).setPerime(sPerime);
				}// if

				if (paramOut.getNom().equals("perimo")) {
					String sPerimo = (String) paramOut.getValeur();
					logService.debug("Perimo :" + sPerimo);
					((ProposeForm) form).setPerimo(sPerimo);
				}// if
				
				if (paramOut.getNom().equals("bpdate")) {
					String sBpdate = (String) paramOut.getValeur();
					logService.debug("Bpdate :" + sBpdate);
					((ProposeForm) form).setBpdate(sBpdate);
				}// if
				if (paramOut.getNom().equals("bpmedate")) {
					String sBpmedate = (String) paramOut.getValeur();
					logService.debug("Bpmedate :" + sBpmedate);
					((ProposeForm) form).setBpmedate(sBpmedate);
				}// if
				if (paramOut.getNom().equals("ubpmontme")) {
					String sUbpmontme = (String) paramOut.getValeur();
					logService.debug("Ubpmontme :" + sUbpmontme);
					((ProposeForm) form).setUbpmontme(sUbpmontme);
				}// if
				if (paramOut.getNom().equals("ubpmontmo")) {
					String sUbpmontmo = (String) paramOut.getValeur();
					logService.debug("Ubpmontmo :" + sUbpmontmo);
					((ProposeForm) form).setUbpmontmo(sUbpmontmo);
				}// if
				
				//Récupération type projet : si il est de type 9 
				//message d'erreur et impossibilité modifier
				if (paramOut.getNom().equals("typproj")) {					
					String msgErreurLigneBipType9 = errorLigneTypeT9((String) paramOut.getValeur()) ; 					
					if(msgErreurLigneBipType9 !=null){																
							bipForm.setMsgErreur(LIGNEBIP_MSG_ERROR_TYPE_PROJET_9);
							// on reste sur la même page
							jdbc.closeJDBC(); return mapping.findForward("initial");
					}
				}
				
				
				if (paramOut.getNom().equals("flaglock")) {
					String sFlaglock = (String) paramOut.getValeur();
					logService.debug("flaglock :" + sFlaglock);
					((ProposeForm) form).setFlaglock(sFlaglock);
				}// if

				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();

					try {
						logService.debug("ResultSet");
						if (rset.next()) {

							bipForm.setMsgErreur(null);
						} else
							msg = true;
						if (rset != null)
							rset.close();
					}// try
					catch (SQLException sqle) {
						logService
								.debug("ProposeAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("ProposeAction-consulter() --> SQLException :"
										+ sqle);
						// Erreur de lecture du resultSet
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11217"));
						// this.saveErrors(request,errors);
						 jdbc.closeJDBC(); return mapping.findForward("error");
					}
				}// if
			}// for

			if (msg) {
				// le code Personne n'existe pas, on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		}// try
		catch (BaseException be) {
			logBipUser.debug("ProposeAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("ProposeAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("ProposeAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("ProposeAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((ProposeForm) form).setMsgErreur(message);
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
