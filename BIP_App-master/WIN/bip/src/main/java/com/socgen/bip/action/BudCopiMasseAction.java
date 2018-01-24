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
import com.socgen.bip.form.BudCopiMasseForm;
import com.socgen.bip.form.SaisieConsoForm;
import com.socgen.bip.metier.BudCopiMasse;
import com.socgen.bip.metier.Consomme;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.ich.ihm.menu.PaginationVector;

public class BudCopiMasseAction extends AutomateAction implements BipConstantes{
	
	private static String PACK_SELECT = "budget.copi.masse.consulter.proc";
	
	private static String PACK_UPDATE = "budget.copi.masse.modifier.proc";
	
	
	/**Permet l'affichage des liste déroulante de l'ecran de selection lors du premier affichage**/
	protected ActionForward suite(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
	return mapping.findForward("initial");
	}

	protected  ActionForward initialiser(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors,Hashtable hParamProc  ) throws ServletException{
		  return mapping.findForward("initial") ;
	}
	
	/** Permet d'afficher la page des favoris lorsque nous cliquons sur la bouton annuler de l'ecran de selection**/
	protected ActionForward annuler(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		return mapping.findForward("annuler");
	}
	
	/**
	 * Méthode consulter : Affichage des données dont le tableau des budgets
	 */
	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		Vector vParamOut3 = new Vector();
		String message = "";
		ParametreProc paramOut;
		Vector vListe = new Vector();
		JdbcBip jdbc = new JdbcBip(); 
		HttpSession session = request.getSession(false);

		String signatureMethode = "BudCopiMasseAction-consulter()";
		logBipUser.entry(signatureMethode);
		logBipUser
				.debug("fmemory start : " + Runtime.getRuntime().freeMemory());
		// Création d'une nouvelle form
		BudCopiMasseForm bipForm = (BudCopiMasseForm) form;

		if (hParamProc == null) {
			logBipUser.debug("SaisieConso-consulter-->hParamProc is null");
		}
		
		// ******* exécute la procédure PL/SQL qui ramène les résultats pour le
		// tableau
		try {
			vParamOut3 = // (new
							// JdbcBip()).getResult(hParamProc,
			jdbc.getResult(hParamProc,
					configProc, PACK_SELECT);
			// pas besoin d'aller plus loin
			if (vParamOut3 == null) {
				logBipUser
						.debug("SaisieConso-consulter(tableau) :!!! cancel forward ");
				logBipUser.exit(signatureMethode);
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
			// Récupération des résultats
			for (Enumeration e = vParamOut3.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();
				
				if (paramOut.getNom().equals("type_demande_retour")){
					
					bipForm.setType_demande((Integer)paramOut.getValeur());
										
				}
				if (paramOut.getNom().equals("annee")){
					
					bipForm.setAnnee((Integer)paramOut.getValeur());
				
				}
				
				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();
					try {
						while (rset.next()) {
														
							vListe.add(new BudCopiMasse(rset.getString(3),
									rset.getString(4),
									rset.getString(5),
									rset.getString(6),
									rset.getString(7),
									rset.getString(8),
									rset.getString(2),
									rset.getInt(1)
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
								.debug("SaisieConsoAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("SaisieConsoAction-consulter() --> SQLException :"
										+ sqle);
						// Erreur de lecture du resultSet
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11217"));
						 jdbc.closeJDBC(); return mapping.findForward("error");
					}
				} // if
			} // for
		} // try
		catch (BaseException be) {
			logBipUser.debug(
					"SaisieConsoAction-consulter() --> BaseException :" + be,
					be);
			logBipUser.debug("SaisieConsoAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug(
					"SaisieConsoAction-consulter() --> BaseException :" + be,
					be);
			logService.debug("SaisieConsoAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((BudCopiMasseForm) form).setMsgErreur(message);
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
	
	protected ActionForward refresh (ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		logBipUser
		.debug("Test antoine refresh  : entrer dans methode");
		return consulter(mapping,form,request,response,errors,hParamProc);
	}
	
	
	protected ActionForward valider(ActionMapping mapping, ActionForm form,
			String mode, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors,
			Hashtable hParamProc) throws ServletException {
		Vector vParamOut = new Vector();
		Vector vListe = new Vector();
		String message = "";
		String dpcopi;
		String date_copi;
		int four_copi;
		int typ_demande;
		String metier;
		int annee;
		int typ_bud;
	
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
		logBipUser
				.debug("fmemory start : " + Runtime.getRuntime().freeMemory());
		

			vListe = (Vector) session
					.getAttribute(BUDGET_COPI_EN_MASSE);
		
		

			savePage(mapping, form, request, response, errors);
		
			BudCopiMasseForm bipForm = ((BudCopiMasseForm ) form);
			
			hParamProc.put("dpcopi", bipForm.getDpcopi());
			hParamProc.put("date_copi", bipForm.getDate_copi());
			hParamProc.put("four_copi",String.valueOf(bipForm.getFour_copi()));
			hParamProc.put("type_demande", String.valueOf(bipForm.getType_demande()));
					
			//boucle qui instantie mon tableau de String buffer, j'ai besoin de 6 lignes qui correspondent à mes 6 année d'affichage en fonction de la date_copi
			for (int j=1;j<7;j++)
			{
				annee = bipForm.getAnnee()+j-1;
				sbChainet[j-1] = new StringBuffer();
				sbChainet[j-1].append(annee+":");
			}
			
			
			;
			
			for (Enumeration e = vListe.elements(); e.hasMoreElements();) {
				BudCopiMasse SaisieBudget = (BudCopiMasse) e.nextElement();
				
				int i = 0;
				i++;
				metier=SaisieBudget.getMetier();
				typ_bud=SaisieBudget.getTyp_bud();
				Object[] param1 = {};
			
				
				for (int j=1;j<7;j++)
				{
					try
					{
						if (SaisieBudget.getTyp_bud()==1)
						{
							sbChainet[j-1].append(SaisieBudget.getMetier()+ ";");
						}
						
						
						String separateur = ";";
						if (SaisieBudget.getTyp_bud()==8)
						{
							separateur = ":";
						}
						
						objetBudget = SaisieBudget.getClass().getDeclaredMethod("getBudgetCopi_" + j, parameterString).invoke((Object) SaisieBudget, param1);
						if (objetBudget != null)
							budget = objetBudget.toString();
						else
							budget = "";
						sbChainet[j-1].append(typ_bud+"="+ budget+separateur);
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
			hParamProc.put("string1", sbChainet[0].toString());
			hParamProc.put("string2", sbChainet[1].toString());
			hParamProc.put("string3", sbChainet[2].toString());
			hParamProc.put("string4", sbChainet[3].toString());
			hParamProc.put("string5", sbChainet[4].toString());
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
						"SaisieConsoAction-consulter() --> BaseException :"
								+ be, be);
				logBipUser
						.debug("SaisieConsoAction-consulter() --> Exception :"
								+ be.getInitialException().getMessage());
				logService.debug(
						"SaisieConsoAction-consulter() --> BaseException :"
								+ be, be);
				logService
						.debug("SaisieConsoAction-consulter() --> Exception :"
								+ be.getInitialException().getMessage());
				if (be.getInitialException().getClass().getName().equals(
						"java.sql.SQLException")) {
					message = BipException.getMessageFocus(BipException
							.getMessageOracle(be.getInitialException()
									.getMessage()), form);
					((SaisieConsoForm) form).setMsgErreur(message);
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
	
	protected void savePage(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors) {
		HttpSession session = request.getSession(false);
		Vector vListe = (Vector) session.getAttribute(BUDGET_COPI_EN_MASSE);
		String budget = "";
		int nbligne;
		Class[] parameterString = { String.class };
		String signatureMethode = "SaisieConso-savePage()";
		logBipUser.entry(signatureMethode);
		// Sauvegarde du total par mois de la page précédente
		// fiche gamma 214
		BudCopiMasseForm bipForm = ((BudCopiMasseForm) form);
		
		nbligne = Integer.parseInt(request.getParameter("nbligne"));
		
		try {
		


		
		int k =0;
		
			// récupérer les champs modifiables
			for (Enumeration e = vListe.elements(); e.hasMoreElements();) {
				BudCopiMasse SaisieBudget = (BudCopiMasse) e.nextElement();
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
					.debug("SaisieConsoAction-savePage-->!!! valeur null dans : "
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
		session.setAttribute(CONSOMME_EN_MASSE, vListe);
		logBipUser.exit(signatureMethode);
	} // savePage
	
}
