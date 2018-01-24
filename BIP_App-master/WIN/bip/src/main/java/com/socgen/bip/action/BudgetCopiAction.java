package com.socgen.bip.action;

import java.math.BigDecimal;
import java.math.MathContext;
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

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.commun.form.AutomateForm;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.BudgetCopiForm;
import com.socgen.bip.form.DpgForm;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author J.ALVES 10/04/2008
 * 
 * Action pour écrans Budget Copi
 * 
 */
public class BudgetCopiAction extends AutomateAction implements BipConstantes {

	private static String PACK_SELECT = "budgetcopi.select.proc";

	private static String PACK_INSERT = "dpcopi.insert.budgetcopi.proc";

	private static String PACK_UPDATE = "dpcopi.update.budgetcopi.proc";

	private static String PACK_DELETE = "dpcopi.supprimer.budgetcopi.proc";
	
	private static String PACK_VERIF_NON_EXISTANCE_BUDGET_COPI = "dpcopi.compte.budgetcopi.proc";
	
	private static String PACK_RECHERCHE_COUTKE = "recup.coutke.copi.annee.metier.fourcopi.proc";
	 

	private static String valeurARenseigner = "--   A RENSEIGNER     ---";
	
	
	private String nomProc;
	
	

	/**
	 * Action qui permet de créer un code DPG
	 */
	protected ActionForward creer(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;
		int nombreBudgetCopi ; 
		
		String signatureMethode = "DpgAction-creer( mapping, form , request,  response,  errors )";

		// logService.entry(signatureMethode);;
		logBipUser.entry(signatureMethode);
		// exécution de la procédure PL/SQL
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_VERIF_NON_EXISTANCE_BUDGET_COPI);
 
			 
			 
			BudgetCopiForm budForm = (BudgetCopiForm) form ; 
		//	budForm.razMontants() ; 
			 
					//---------------------------------
					 
					// Récupération des résultats
					for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
						 paramOut = (ParametreProc) e.nextElement();
		
						 logBipUser.entry("parcours params");
						 if (paramOut.getNom().equals("nbbudgetcopi")) {
							nombreBudgetCopi = ((Integer) paramOut.getValeur()).intValue(); 
 
							 
							//Si pas de DP_COPI trouvé poru celui saisi sur l'interface
							// alerte message erreur
							if(nombreBudgetCopi == -1){
								message = "Le Dossier Projet COPI saisi n'existe pas !";
								// Entité déjà existante, on récupère le message
								((BudgetCopiForm) form).setMsgErreur(message);
								logBipUser.debug("message d'erreur:" + message);
								logBipUser.exit(signatureMethode);
								
								// on reste sur la même page
								jdbc.closeJDBC(); 
								return mapping.findForward("creation");
							}
							//Si déjà un couple Budget_COPI / Dates COPI Trouvés : création impossible
							if(nombreBudgetCopi >0){
								message = "Il existe déjà un Budget COPI pour les Date COPI ,DP COPI, métier et année saisis!";
								// Entité déjà existante, on récupère le message
								((BudgetCopiForm) form).setMsgErreur(message);
								logBipUser.debug("message d'erreur:" + message);
								logBipUser.exit(signatureMethode);
								// on reste sur la même page
								jdbc.closeJDBC(); 
								return mapping.findForward("creation");
								
							} 
						 }  
					}
					
 
			
			
			try { 
				message = jdbc.recupererResult(vParamOut, "creer");
			} catch (BaseException be) {
				logBipUser.debug("DpgAction-creer() --> BaseException :" + be);
				logBipUser.debug("DpgAction-creer() --> Exception :"
						+ be.getInitialException().getMessage());
				logService.debug("DpgAction-creer() --> BaseException :" + be);
				logService.debug("DpgAction-creer() --> Exception :"
						+ be.getInitialException().getMessage());
				// Erreur de lecture du resultSet
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
			if (!message.equals("")) {
				// Entité déjà existante, on récupère le message
				((BudgetCopiForm) form).setMsgErreur(message);
				logBipUser.debug("message d'erreur:" + message);
				logBipUser.exit(signatureMethode);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("creation");
			}

		}// try
		catch (BaseException be) {
			logBipUser.debug("DpgAction-creer() --> BaseException :" + be);
			logBipUser.debug("DpgAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("DpgAction-creer() --> BaseException :" + be);
			logService.debug("DpgAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((BudgetCopiForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("creation");

			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}

		
		//initialisations pour écran création
		BudgetCopiForm budForm = (BudgetCopiForm) form; 		
		//budForm.setFournisseurCopi(valeurARenseigner);		
		//budForm.setTypeDemande(valeurARenseigner);
		
		// logService.exit(signatureMethode);
		logBipUser.exit(signatureMethode);
		jdbc.closeJDBC(); 
		return mapping.findForward("ecran");
	}// creer

	
	/**
	 * Action qui permet de visualiser les données liées à un code Dpg pour la
	 * modification et la suppression
	 */
	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;
		 
		String signatureMethode = "BudgetCopiAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		BudgetCopiForm bipForm = (BudgetCopiForm) form;
		int nombreBudgetCopi=-5;
		// exécution de la procédure PL/SQL
		try {
			
			
			//----------------------- Test existance Budget Copi à Modifier/Supprimer--------------
			
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_VERIF_NON_EXISTANCE_BUDGET_COPI);
					 
					// Récupération des résultats
					for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
						 
						 paramOut = (ParametreProc) e.nextElement();
		
						 logBipUser.entry("parcours params");
						 if (paramOut.getNom().equals("nbbudgetcopi")) {
							
							nombreBudgetCopi = ((Integer) paramOut.getValeur()).intValue();
							 
 
							
							//Si pas de DP_COPI trouvé pour celui saisi sur l'interface
							// alerte message erreur
							if(nombreBudgetCopi <1 ){ 
								message = "Modification impossible: Le Budget COPI n'existe pas !";								
								((BudgetCopiForm) form).setMsgErreur(message);															
								jdbc.closeJDBC(); 
								return mapping.findForward("initial");
							}
							 
						 }  
					}
			
			if(nombreBudgetCopi >0) {
				 
			//-------------------------------------------------------------------------------------
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
 
							bipForm.setDpcopi(rset.getString(1));
							bipForm.setAnnee(rset.getString(2));
							bipForm.setDatecopi(rset.getString(3));
							bipForm.setFournisseurCopi(rset.getString(4)); 
							bipForm.setMetier(rset.getString(5));
							bipForm.setTypeDemande(rset.getString(6));
							bipForm.setJhCoutTotal(rset.getString(7));
							bipForm.setJhArbitresDemandes(rset.getString(8));
							bipForm.setJhArbitresDecides(rset.getString(9));
							bipForm.setJhCantonnesDemandes(rset.getString(10));
							bipForm.setJhCantonnesDecides(rset.getString(11))  ;
							bipForm.setJhPrevisionnelDecide(rset.getString(12));
							bipForm.setMsgErreur(null);
							
							bipForm.setKeJhArbitresDecides("0");
							bipForm.setKeJhArbitresDemandes("0");
							bipForm.setKeJhCantonnesDecides("0");
							bipForm.setKeJhCantonnesDemandes("0");
							bipForm.setKeJhCoutTotal("0");
							bipForm.setKeJhPreviDecide("0");

						 
						} else
							msg = true;

					}// try
					catch (SQLException sqle) {
						 
						logService
								.debug("BudgetCopiAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("BudgetCopiAction-consulter() --> SQLException :"
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
									.debug("BudgetCopiAction-suite() --> SQLException-rset.close() :"
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
				logBipUser.debug("Erreur : test msg retour : pas de données trouvé --> "+msg);
				// le code Dpg n'existe pas, on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		  }// Fin if nombreBudgetCopi > 0 
		}// try
		 catch (BaseException be) {
			logBipUser.debug("BudgetCopiAction-consulter() --> BaseException :" + be,
					be);
			logBipUser.debug("BudgetCopiAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("BudgetCopiAction-consulter() --> BaseException :" + be,
					be);
			logService.debug("BudgetCopiAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((DpgForm) form).setMsgErreur(message);
				logBipUser.debug("Erreur --> BaseException"+message);
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
		jdbc.closeJDBC();
		if(nombreBudgetCopi >0) {  	
				return mapping.findForward("ecran");
		 }else{
			    return mapping.findForward("initial");
		 }
	}
	
	protected String renvoitCout(String jh,BigDecimal coutKe){
		BigDecimal jhDecimal = new BigDecimal(replaceVirguleOfNumber(jh)); 
		BigDecimal valeurSortie = new BigDecimal (  (jhDecimal.floatValue() *  coutKe.floatValue())/1000 )  ; 
		valeurSortie = valeurSortie.setScale ( 3, java.math.BigDecimal.ROUND_HALF_UP ) ; 
		return valeurSortie.toString() ;
	}
	

	/**
	 * 
	 * Appellé pour calculer les couts en KEuro des zones saisies en JH
	 * 
	 */
	protected ActionForward refresh(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = "DpgAction-refresh(paramProc, mapping, form , request,  response,  errors )";
 
		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		BudgetCopiForm budForm = (BudgetCopiForm) form;
		
		BigDecimal coutKE = new BigDecimal("0"); 
		BigDecimal jh ; 

		try { 
			
			logBipUser.entry(budForm.getAnnee() + " - " + budForm.getMetier() + " - " + budForm.getFournisseurCopi());
			
				vParamOut = jdbc.getResult(
								hParamProc, configProc, PACK_RECHERCHE_COUTKE );
						
				for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
					paramOut = (ParametreProc) e.nextElement();
					// récupérer le message
					if (paramOut.getNom().equals("message")) {
						message = (String) paramOut.getValeur();
						budForm.setMsgErreur(message) ;
					}
					
					if (paramOut.getNom().equals("coutKE")) {
			  
						if(paramOut.getValeur()!=null){
							logBipUser.entry( "Cout KE String trouvé :" + (String)paramOut.getValeur());
							coutKE = new BigDecimal( replaceVirguleOfNumber((String)paramOut.getValeur()));
							logBipUser.entry("Cout KE trouvé :" + coutKE.toString());
						}
					}
				} 
				logBipUser.entry("test valeur Antoine : " + budForm.getJhArbitresDecides().length());
				if (budForm.getJhArbitresDecides().length() != 0)  {
					budForm.setKeJhArbitresDecides(replacePointOfNumber (renvoitCout(  budForm.getJhArbitresDecides(), coutKE))) ;
				}
				if (budForm.getJhArbitresDemandes().length() != 0)  {
					budForm.setKeJhArbitresDemandes(replacePointOfNumber (renvoitCout(  budForm.getJhArbitresDemandes(), coutKE))) ;
				}
				if (budForm.getJhCantonnesDemandes().length() != 0)  {
					budForm.setKeJhCantonnesDemandes(replacePointOfNumber (renvoitCout( budForm.getJhCantonnesDemandes(), coutKE))) ;
				}
				if (budForm.getJhCantonnesDecides().length() != 0)  { 
					budForm.setKeJhCantonnesDecides(replacePointOfNumber (renvoitCout( budForm.getJhCantonnesDecides(), coutKE))) ; 
				}
				if (budForm.getJhCoutTotal().length() != 0)   {
					budForm.setKeJhCoutTotal(replacePointOfNumber (renvoitCout( budForm.getJhCoutTotal(), coutKE))) ; 
				}
				if (budForm.getJhPrevisionnelDecide().length() != 0) {
				budForm.setKeJhPreviDecide(replacePointOfNumber (renvoitCout( budForm.getJhPrevisionnelDecide(), coutKE))) ; 
				}
		}

		catch (BaseException be) {
			logBipUser.debug("ClientAction-refresh() --> BaseException :" + be,
					be);
			logBipUser.debug("ClientAction-refresh() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("ClientAction-refresh() --> BaseException :" + be,
					be);
			logService.debug("ClientAction-refresh() --> Exception :"
					+ be.getInitialException().getMessage());
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));

			// this.saveErrors(request,errors);
			 jdbc.closeJDBC(); return mapping.findForward("error");
		}
		 jdbc.closeJDBC();
	 
		return mapping.findForward("ecran");
	}

	
	
	protected String replacePointOfNumber(String nombre){
    
		int positionPoint = nombre.indexOf(".");
		if(positionPoint != -1){
			return  nombre.substring(0,positionPoint) + ","+ nombre.substring(positionPoint+1,nombre.length());  
		}else
			return nombre ; 

	}
	
	protected String replaceVirguleOfNumber(String nombre){
	    
		int positionPoint = nombre.indexOf(",");
		if(positionPoint != -1){
			return  nombre.substring(0,positionPoint) + "."+ nombre.substring(positionPoint+1,nombre.length());  
		}else
			return nombre ; 

	}
	
	
	/**
	 * Method valider
	 * Action qui permet d'enregistrer les données pour la création, modification, suppression d'un code client
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param errors
	 * @ jdbc1.closeJDBC(); return ActionForward
	 * @throws ServletException
	 * 
	*/	
	protected  ActionForward valider(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors ,Hashtable hParamProctest ) throws ServletException{
	    Vector vParamOut = new Vector();
	    String cle = null;
	    String message=null;
	    BudgetCopiForm bipForm = (BudgetCopiForm) form;			
	    
	    String signatureMethode =
			"valider(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors )";
		logBipUser.entry(signatureMethode);
		logBipUser.debug("mode de mise à jour:"+mode);
		 
		//On récupère la clé pour trouver le nom de la procédure stockée dans bip_proc.properties
		cle=recupererCle(mode);

		logBipUser.debug("valider() --> cle :"+ mode);
		JdbcBip jdbc1 = new JdbcBip(); 
		
		//On exécute la procédure stockée
		try {

						
		
			logBipUser.debug("##### vars : "+ bipForm.getAction() + " -  "+ bipForm.getMetier() + " -  "+ bipForm.getTypeDemande() + " -  "+ bipForm.getDpcopi());
			//Reprise fonctionnement normal de la procédure de Validation de AutomateAction 
			 vParamOut=jdbc1.getResult ( hParamProctest,configProc,cle);
		
			try {
					message=jdbc1.recupererResult(vParamOut,"valider");
					
					if(bipForm.getMode().equals("delete")) 
					{
						bipForm.setMsgErreur(message);						
						/*bipForm.setDpcopi(null);
						bipForm.setDatecopi(null);
						bipForm.setAnnee(null);
						bipForm.setMetier(null);
						bipForm.setFournisseurCopi(null);*/
						bipForm.setDpcopi(null);
						hParamProctest.put("dpcopi","") ; 
						jdbc1.closeJDBC();
						return mapping.findForward("initial") ;
					}
					
			 	}
			 	catch (BaseException be) {
			 		logBipUser.debug("valider() --> BaseException :"+be);
					logBipUser.debug("valider() --> Exception :"+be.getInitialException().getMessage());
			 		logService .debug("valider() --> BaseException :"+be);
					logService .debug("valider() --> Exception :"+be.getInitialException().getMessage());
					errors.add(ActionErrors.GLOBAL_ERROR , new ActionError("11217"));
					 jdbc1.closeJDBC(); return mapping.findForward("error");
			 	}
		
			 	if (message!=null && !message.equals("")) {
				// on récupère le message 
					((AutomateForm)form).setMsgErreur(message);
					logBipUser.debug("valider() -->message :"+message);
				}
				
		} catch (BaseException be) {

			logService.debug("valider() --> BaseException :"+be);
			logService.debug("valider() --> Exception :"+be.getInitialException().getMessage());
			logBipUser.debug("valider() --> BaseException :"+be);
			logBipUser.debug("valider() --> Exception :"+be.getInitialException().getMessage());
			//Si exception sql alors extraire le message d'erreur du message global
			if (be.getInitialException().getClass().getName().equals("java.sql.SQLException")){
				message = BipException.getMessageFocus(BipException.getMessageOracle(be.getInitialException().getMessage()), form);
				((AutomateForm)form).setMsgErreur(message);
			
				if (!mode.equals("delete")) {
					 jdbc1.closeJDBC(); return mapping.findForward("ecran") ;
				}
			}
			else {
				//Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR , new ActionError("11201"));
		    	request.setAttribute("messageErreur",be.getInitialException().getMessage());
				 jdbc1.closeJDBC(); return mapping.findForward("error");
			}
		}	
		
		logBipUser.exit(signatureMethode);
		 jdbc1.closeJDBC(); 
		 if (bipForm.getType().equals("creation"))
			 
		return mapping.findForward("creation") ;
		 else
		 return mapping.findForward("initial") ;

	}//valider
	
	protected  ActionForward suite(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors ,Hashtable hParamProc ) throws ServletException
	{
		
		  String signatureMethode =
				"suite(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors )";
			logBipUser.entry(signatureMethode);
		BudgetCopiForm bipForm = (BudgetCopiForm) form;		
		logBipUser.entry(signatureMethode);
		bipForm.setAnnee(request.getParameter("annee"));
		logBipUser.debug("enter dans la methode suite"+bipForm.getDpcopi());
		logBipUser.debug("enter dans la methode suite"+bipForm.getAnnee());
		logBipUser.debug("enter dans la methode suite"+bipForm.getDatecopi());
		logBipUser.debug("enter dans la methode suite"+bipForm.getMetier());
		logBipUser.debug("enter dans la methode suite"+bipForm.getFournisseurCopi());
		
		
		return mapping.findForward("initial") ;
	}
	
	
	protected  ActionForward annuler(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors,Hashtable hParamProc  ) throws ServletException{
		 BudgetCopiForm bipForm = (BudgetCopiForm) form;		
		 if (bipForm.getType().equals("creation")) 
		   return mapping.findForward("creation") ;
		     else
		   return mapping.findForward("initial") ;
	}
	  

	/**
	 * 
	 */
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
