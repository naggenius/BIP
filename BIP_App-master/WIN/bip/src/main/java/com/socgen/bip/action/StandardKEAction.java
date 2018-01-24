package com.socgen.bip.action;

import java.lang.reflect.InvocationTargetException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.Vector;
import java.util.Hashtable;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.form.StandardKEForm;

import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.bip.exception.BipException;

import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

/**
 * @author J.ALVES - 20/09/2007
 * 
 * Action mise à jour des couts standards en KE : Administration/Tables/ mise à
 * jour/Standards KE 
 * pages : fStandardKEAd.jsp, bStandardAd.jsp, mStandardAd.jsp
 * pl/sql : cout.sql
 */
public class StandardKEAction extends AutomateAction {

	// private static String PACK_SELECT_CREER =
	// "standard.consulter.creer.proc";
	private static String PACK_SELECT = "standard.ke.consulter.proc";

	private static String PACK_INSERT = "standard.ke.creer.proc";

	private static String PACK_UPDATE = "standard.ke.modifier.proc";

	private static String PACK_DELETE = "standard.ke.supprimer.proc";

	private static String PACK_CONTROLE = "standard.ke.controler.proc";



	private String nomProc;
	
	

	private static String[] tab_niveau = { "A", "B", "C", "D", "E", "F", "G",
			"H", "I", "J", "K", "Hc" };

	private static String[] tab_metier = { "Me", "Mo", "Hom", "Gap" };

	/**
	 * Action qui permet de créer un code Standard
	 */
	protected ActionForward creer(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = "StandardAction -creer( mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);

		// logService.exit(signatureMethode);
		logBipUser.exit(signatureMethode);

		 return mapping.findForward("ecran");
		 
	}// creer

	/**
	 * Action qui permet de valider un code Standard
	 */
	protected ActionForward valider(ActionMapping mapping, ActionForm form,
			String mode, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors,
			Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String cle = null;
		String message = null;

		String sChaine = "";
		String sLibelle = "";
		String sCout;
		Class[] parameterString = {};
		Object oStandard;
		Object[] param1 = {};

		String signatureMethode = "valider(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors )";
		logBipUser.entry(signatureMethode);
		logBipUser.debug("mode de mise à jour:" + mode);

		StandardKEForm bipForm = (StandardKEForm) form;

		// On récupère la clé pour trouver le nom de la procédure stockée dans
		// bip_proc.properties
		cle = recupererCle(mode);
		
		logBipUser.debug("cle:" + cle);

		
		//standard.ke.creer.proc.in = 1:couann:1;2:codsg_bas:1;3:codsg_haut:1;4:cout_Me:1;5:cout_Mo:1;6:cout_Hom:1;7:cout_Gap:1;8:cout_Exp:1;9:cout_Sau:1
		//standard.ke.creer.proc.out = 10:nbcurseur:2;11:message:1     
		

		if (!mode.equals("delete")) {
			// Constitution de la chaine : concaténation des champs couts
			if(!mode.equals("controler")){
					if (bipForm.getCout_Me_type1().length()== 0)
						bipForm.setCout_Me_type1("0,00");
					if (bipForm.getCout_Mo_type1().length()== 0)
						bipForm.setCout_Mo_type1("0,00");
					if (bipForm.getCout_Hom_type1().length()== 0)				
						bipForm.setCout_Hom_type1("0,00");
					if (bipForm.getCout_Gap_type1().length()== 0)
						bipForm.setCout_Gap_type1("0,00");
					if (bipForm.getCout_Exp_type1().length()== 0)
						bipForm.setCout_Exp_type1("0,00");
					if (bipForm.getCout_Sau_type1().length()== 0)
						bipForm.setCout_Sau_type1("0,00");	
					if (Integer.parseInt(bipForm.getCouann()) > 2009)
					{
						if (bipForm.getCout_Me_type2().length()== 0)
							bipForm.setCout_Me_type2("0,00");
						if (bipForm.getCout_Mo_type2().length()== 0)
							bipForm.setCout_Mo_type2("0,00");
						if (bipForm.getCout_Hom_type2().length()== 0)				
							bipForm.setCout_Hom_type2("0,00");
						if (bipForm.getCout_Gap_type2().length()== 0)
							bipForm.setCout_Gap_type2("0,00");
						if (bipForm.getCout_Exp_type2().length()== 0)
							bipForm.setCout_Exp_type2("0,00");
						if (bipForm.getCout_Sau_type2().length()== 0)
							bipForm.setCout_Sau_type2("0,00");	
					}
			}

		}
		
		
		// On exécute la procédure stockée
		try {

			vParamOut = jdbc.getResult(
					hParamProc, configProc, cle);

			try {
				
				message = jdbc.recupererResult(vParamOut, "valider");
				
			} catch (BaseException be) {
				logBipUser.debug("valider() --> BaseException :" + be);
				logBipUser.debug("valider() --> Exception :"
						+ be.getInitialException().getMessage());
				logService.debug("valider() --> BaseException :" + be);
				logService.debug("valider() --> Exception :"
						+ be.getInitialException().getMessage());
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error"); 
			}

			if (message != null && !message.equals("")) {
				// on récupère le message
				bipForm.setMsgErreur(message);
				logBipUser.debug("valider() -->message :" + message);

			}

		} catch (BaseException be) {

			logService.debug("valider() --> BaseException :" + be);
			logService.debug("valider() --> Exception :"
					+ be.getInitialException().getMessage());
			logBipUser.debug("valider() --> BaseException :" + be);
			logBipUser.debug("valider() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				bipForm.setMsgErreur(message);

				if (!mode.equals("delete")) {
					 jdbc.closeJDBC(); return mapping.findForward("ecran");
				}
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
		 jdbc.closeJDBC(); return mapping.findForward("initial");

	}// valider

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
		boolean msg = true;
		ParametreProc paramOut;
		Class[] parameterString = { String.class };
		String sLibMethode;
		String sProc;
		String signatureMethode = "ClientAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		StandardKEForm bipForm = (StandardKEForm) form;

		// exécution de la procédure PL/SQL
		try {
			
			//Dans la JSP précédent qui provoque l'appel à la méthode "consulter"
			//la lef de la plage DPG choisie est codée qomme suit : DPG_BAS + "-" + DPG_HAUT
			//il faut donc extraire dpg_bas et dpg_haut et les remettre dans le Form
			//afin de pouvoir appeller la procédure
			
			
			//logBipUser
			//.debug("********************************clef "
			//		+ bipForm.getCleDpgBasHaut());
			
			//int posSeparateur = 	bipForm.getCleDpgBasHaut().indexOf("-") ; 
			
			//bipForm.setCodsg_bas(bipForm.getCleDpgBasHaut().substring(0,posSeparateur));
			
			//bipForm.setCodsg_haut(bipForm.getCleDpgBasHaut().substring(posSeparateur+1,bipForm.getCleDpgBasHaut().length()));
			
			/*logBipUser.debug("************************ dpg_bas "
					+ bipForm.getCodsg_bas());
			logBipUser.debug("************************ dpg_haut "
					+ bipForm.getCodsg_haut());*/
			
			
			sProc = PACK_SELECT ;

			vParamOut = jdbc.getResult(
					hParamProc, configProc, sProc);

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
						while (rset.next()) {
							msg = false;
							bipForm.setCouann(rset.getString(1));
							
							//En modification les codsg bas new et old on la même valeur avant qu'elle ne soit
							//changée via l'interface (idem pour le Codsg_haut)  
							bipForm.setCodsg_bas(rset.getString(2));
							bipForm.setCodsg_bas_new(rset.getString(2));
							bipForm.setCodsg_haut(rset.getString(3));	
							bipForm.setCodsg_haut_new(rset.getString(3));
							
							String valeur1 = rset.getString(4) ; 
							String valeur2 =  rajoutZerosApresVirgule(valeur1) ; 
							
							bipForm.setCout_Me_type1( rajoutZerosApresVirgule(rset.getString(4)) );
							bipForm.setCout_Mo_type1(rajoutZerosApresVirgule(rset.getString(5)));
							bipForm.setCout_Hom_type1(rajoutZerosApresVirgule(rset.getString(6)));
							bipForm.setCout_Gap_type1(rajoutZerosApresVirgule(rset.getString(7)));
							bipForm.setCout_Exp_type1(rajoutZerosApresVirgule(rset.getString(8)));
							bipForm.setCout_Sau_type1(rajoutZerosApresVirgule(rset.getString(9)));
							bipForm.setCout_Me_type2( rajoutZerosApresVirgule(rset.getString(10)) );
							bipForm.setCout_Mo_type2(rajoutZerosApresVirgule(rset.getString(11)));
							bipForm.setCout_Hom_type2(rajoutZerosApresVirgule(rset.getString(12)));
							bipForm.setCout_Gap_type2(rajoutZerosApresVirgule(rset.getString(13)));
							bipForm.setCout_Exp_type2(rajoutZerosApresVirgule(rset.getString(14)));
							bipForm.setCout_Sau_type2(rajoutZerosApresVirgule(rset.getString(15)));
							bipForm.setFournisseurCopi(rset.getString(16));
							bipForm.setFlaglock(rset.getInt(17));
						
							
						}

					}// try
					catch (SQLException sqle) {
						logService
								.debug("StandardAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("StandardAction-consulter() --> SQLException :"
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
									.debug("StandardAction-consulter() --> SQLException-rset.close() :"
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
				// le code Standard n'existe pas, on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		}// try
		catch (BaseException be) {
			logBipUser.debug("StandardAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("StandardAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("StandardAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("StandardAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				bipForm.setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");

			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());

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
		} else if (mode.equals("controler")) {
			cle = PACK_CONTROLE ; 			
		}
		  return cle;
	}

	protected ActionForward suite(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors) throws ServletException {

		String signatureMethode = "StandardAction - suite( mapping, form , request,  response,  errors )";

		// logService.entry(signatureMethode);;
		logBipUser.entry(signatureMethode);

		logBipUser.exit(signatureMethode);
		return mapping.findForward("suite");
	}

 
	protected  ActionForward annuler(ActionMapping mapping,ActionForm form ,
			HttpServletRequest request, HttpServletResponse response, ActionErrors errors,Hashtable hParamProc  ) throws ServletException{
		  return mapping.findForward("annuler") ;
	}
	
	
	private String rajoutZerosApresVirgule(String valeur){
	  String valeurRetour = valeur;   
	  if(valeurRetour != null){
			  if(valeurRetour.indexOf(",") == valeurRetour.length()-1){
				  valeurRetour = valeurRetour + "00" ;
			  }
	  }else{
		  valeurRetour = ",00" ; 
	  }
	  return valeurRetour ; 
	}
	
	
}

