package com.socgen.bip.action;

import java.lang.reflect.InvocationTargetException;
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

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.BudCopiValidMasseForm;
import com.socgen.bip.metier.BudCopiValidMasse;
import com.socgen.cap.fwk.exception.BaseException;

public class BudCopiValidMasseAction extends AutomateAction implements BipConstantes {
	
	private static String PACK_SELECT = "budget.copi.valid.masse.consulter.proc";
	
	private static String PACK_UPDATE = "budget.copi.valid.masse.modifier.proc";
	
	/**Permet l'affichage des liste déroulante de l'ecran de selection lors du premier affichage**/
	protected ActionForward suite(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
	return mapping.findForward("initial");
	}
	
	/** permet l'affichage de la page se selection lorsque nous cluqons sur annuler de la page de mise  à jour**/
	protected  ActionForward initialiser(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors,Hashtable hParamProc  ) throws ServletException{
		  return mapping.findForward("initial") ;
	}
	
	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		Vector vParamOut3 = new Vector();
		String message = "";
		ParametreProc paramOut;
		Vector vListe = new Vector();
		JdbcBip jdbc = new JdbcBip(); 
		HttpSession session = request.getSession(false);
	
		String signatureMethode = "BudCopiValidMasseAction-consulter()";
		logBipUser.entry(signatureMethode);
		logBipUser
				.debug("fmemory start : " + Runtime.getRuntime().freeMemory());
		// Création d'une nouvelle form
		BudCopiValidMasseForm bipForm = (BudCopiValidMasseForm) form;

		if (hParamProc == null) {
			logBipUser.debug("SaisieConso-consulter-->hParamProc is null");
		}
		
		// ******* exécute la procédure PL/SQL qui ramène les résultats pour le
		// tableau
		try {
			vParamOut3 = jdbc.getResult(hParamProc,configProc, PACK_SELECT);
			// pas besoin d'aller plus loin
			if (vParamOut3 == null) {
				logBipUser.exit(signatureMethode);
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
			// Récupération des résultats
			for (Enumeration e = vParamOut3.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();
									
				if (paramOut.getNom().equals("message")) {
					if (paramOut.getValeur() != null)
						message = (String) paramOut.getValeur();
				}
				
				
				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();
				
					try {
							
						while (rset.next()) {
							vListe.add(new BudCopiValidMasse(rset.getString(1),
									rset.getString(2),
									rset.getString(3),
									rset.getString(4),
									rset.getString(5),
									rset.getString(6),
									rset.getString(7),
									rset.getString(8),
									rset.getString(9),
									rset.getString(10),
									rset.getString(11),
									rset.getString(12),
									rset.getString(13),
									rset.getString(14)
								));
							
						}
						
						if (rset != null)
						{
							rset.close();
							rset = null;
						}	
						
					} // try
					catch (SQLException sqle) {
						logService
								.debug("BudCopiValidMasseAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("BudCopiValidMasseAction-consulter() --> SQLException :"
										+ sqle);
						// Erreur de lecture du resultSet
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11217"));
						 jdbc.closeJDBC(); return mapping.findForward("error");
					}
				} // if
				
				if (!message.equals("")) {
					
					((BudCopiValidMasseForm) form).setMsgErreur(message);
				logBipUser.debug("message d'erreur:" + message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
				
			} // for
		} // try
		catch (BaseException be) {
			logBipUser.debug(
					"BudCopiValidMasseAction-consulter() --> BaseException :" + be,
					be);
			logBipUser.debug("BudCopiValidMasseAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug(
					"BudCopiValidMasseAction-consulter() --> BaseException :" + be,
					be);
			logService.debug("BudCopiValidMasseAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((BudCopiValidMasseForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}
		
		session.setAttribute(BUDGET_COPI_EN_MASSE, vListe);

		logBipUser
				.debug("fmemory end   : " + Runtime.getRuntime().freeMemory());
		logBipUser.exit(signatureMethode);
		
		
		jdbc.closeJDBC(); return mapping.findForward("ecran");
	}
	
	
	protected void savePage(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors) {
		HttpSession session = request.getSession(false);
		Vector vListe = (Vector) session.getAttribute(BUDGET_COPI_EN_MASSE);
		String budget = "";
		Class[] parameterString = { String.class };
		String signatureMethode = "SaisieConso-savePage()";
		logBipUser.entry(signatureMethode);
				
		try {
		
		int k =0;
		
			// récupérer les champs modifiables
			for (Enumeration e = vListe.elements(); e.hasMoreElements();) {
				BudCopiValidMasse SaisieBudget = (BudCopiValidMasse) e.nextElement();
				k++;	
				for (int j = 1; j <7; j++) {

						budget = "budgetCopi_"+k+"_"+ j;
						Object[] param1 = { (Object) request
								.getParameter(budget) };
					
						if (request.getParameter(budget) != null) {
							SaisieBudget.getClass().getDeclaredMethod(
											"setBudgetCopi_" + j, parameterString)
											.invoke((Object) SaisieBudget,
													param1);
								}
					} // for
				} // for
		
		} catch (NullPointerException npe) {
			logBipUser
					.debug("BudCopiValidMasseAction-savePage-->!!! valeur null dans : "
							+ npe.getMessage());
			// Erreur d''exécution
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11209"));
			this.saveErrors(request, errors);
		} catch (NoSuchMethodException me) {
			logBipUser.debug("Méthode inexistante " + me.getMessage());
			// Erreur d''exécution
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11209"));
			this.saveErrors(request, errors);
		} catch (SecurityException se) {
			// Erreur d''exécution
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11209"));
			this.saveErrors(request, errors);
		} catch (IllegalAccessException ia) {
			// Erreur d''exécution
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11209"));
			this.saveErrors(request, errors);
		} catch (IllegalArgumentException iae) {
			logBipUser.debug("arguments null : " + iae.getMessage());
			// Erreur d''exécution
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11209"));
			this.saveErrors(request, errors);
		} catch (InvocationTargetException ite) {
			// Erreur d''exécution
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11209"));
			this.saveErrors(request, errors);
		}
		session.setAttribute(BUDGET_COPI_EN_MASSE, vListe);
		logBipUser.exit(signatureMethode);
	} // savePage
	
	
	
	protected ActionForward valider(ActionMapping mapping, ActionForm form,
			String mode, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors,
			Hashtable hParamProc) throws ServletException {
		Vector vParamOut = new Vector();
		Vector vListe = new Vector();
		String message = "";
		Class[] parameterString = {};
		Object objetBudget;
		String budget;
		JdbcBip jdbc = new JdbcBip(); 
		StringBuffer[] sbChainet = new StringBuffer[6];
		int si = 0;
		sbChainet[si] = new StringBuffer();
		
		HttpSession session = request.getSession(false);
		
		String signatureMethode = "SaisieConsoActionAction-valider()";
		logBipUser.entry(signatureMethode);
		logBipUser.debug("fmemory start : " + Runtime.getRuntime().freeMemory());
		
		vListe = (Vector) session.getAttribute(BUDGET_COPI_EN_MASSE);
		
		savePage(mapping, form, request, response, errors);
		
		BudCopiValidMasseForm bipForm = ((BudCopiValidMasseForm ) form);
												
			for (Enumeration e = vListe.elements(); e.hasMoreElements();) {
				BudCopiValidMasse SaisieBudget = (BudCopiValidMasse) e.nextElement();
				
				int i = 0;
				i++;
				Object[] param1 = {};
			
				if (sbChainet[si].length() > 30000) {
					si++;
					sbChainet[si] = new StringBuffer();
					
				}
				
				sbChainet[si].append(SaisieBudget.getDate_copi()+ ";"+SaisieBudget.getDpcopi()+ ";"+SaisieBudget.getAnnee()+ ";");
				sbChainet[si].append(SaisieBudget.getMetier()+ ";"+SaisieBudget.getCode_four_copi()+ ";"+SaisieBudget.getCode_type_demande()+ ";");
				for (int j=1;j<7;j++)
				{
					try
					{
																		
						String separateur = ";";
						if (j==6)
						{
							separateur = ":";
						}
						
						objetBudget = SaisieBudget.getClass().getDeclaredMethod("getBudgetCopi_" + j, parameterString).invoke((Object) SaisieBudget, param1);
						if (objetBudget != null)
							budget = objetBudget.toString();
						else
							budget = "";
						sbChainet[si].append(budget+separateur);
					}
					catch(Exception me)
					{
						logBipUser.debug("Problème recuperration budget");
					// Erreur d''exécution
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11209"));
						this.saveErrors(request, errors);
					}
				
				}
			}	
			
			if (sbChainet[0] != null)
				hParamProc.put("string1", sbChainet[0].toString());
		    if (sbChainet[1] != null)
				hParamProc.put("string2", sbChainet[1].toString());
			if (sbChainet[2] != null)
				hParamProc.put("string3", sbChainet[2].toString());
			if (sbChainet[3] != null)
				hParamProc.put("string4", sbChainet[3].toString());
			if (sbChainet[4] != null)
				hParamProc.put("string5", sbChainet[4].toString());
			if (sbChainet[5] != null)
				hParamProc.put("string6", sbChainet[5].toString());
	
		// on exécute la procedure PLSQL qui met à jour en masse les budgets
			try {
				vParamOut = jdbc.getResult(
						hParamProc, configProc, PACK_UPDATE);
				
			
				for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
					ParametreProc paramOut = (ParametreProc) e.nextElement();
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();
					bipForm.setMsgErreur(message);
				}
				}
			} // try
			catch (BaseException be) {
				logBipUser.debug(
						"BudCopiValidMasseAction-consulter() --> BaseException :"
								+ be, be);
				logBipUser
						.debug("BudCopiValidMasseAction-consulter() --> Exception :"
								+ be.getInitialException().getMessage());
				logService.debug(
						"BudCopiValidMasseAction-consulter() --> BaseException :"
								+ be, be);
				logService
						.debug("BudCopiValidMasseAction-consulter() --> Exception :"
								+ be.getInitialException().getMessage());
				if (be.getInitialException().getClass().getName().equals(
						"java.sql.SQLException")) {
					message = BipException.getMessageFocus(BipException
							.getMessageOracle(be.getInitialException()
									.getMessage()), form);
					((BudCopiValidMasseForm) form).setMsgErreur(message);
					 jdbc.closeJDBC(); return mapping.findForward("ecran");
				} else {
					// Erreur d''exécution de la procédure stockée
					errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
							"11201"));
					request.setAttribute("messageErreur", be
							.getInitialException().getMessage());
					 jdbc.closeJDBC(); return mapping.findForward("error");
				}
			}
			// annuler la mise à jour
			if (vParamOut == null) {
				session.setAttribute("errorUpdate", "UPDATE");
				logBipUser.debug("!!! update cancelled ");
			} 
		return mapping.findForward("ecran");
	}

}
