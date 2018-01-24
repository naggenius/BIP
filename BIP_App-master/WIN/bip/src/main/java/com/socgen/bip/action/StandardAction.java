package com.socgen.bip.action;

import java.lang.reflect.InvocationTargetException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.StringTokenizer;
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
import com.socgen.bip.form.StandardForm;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author N.BACCAM - 28/05/2003
 * 
 * Action mise à jour des couts standards chemin : Administration/Tables/ mise à
 * jour/Standards pages : fStandardAd.jsp, bStandardAd.jsp, mStandardAd.jsp
 * pl/sql : cout.sql
 */
public class StandardAction extends AutomateAction {

	// private static String PACK_SELECT_CREER =
	// "standard.consulter.creer.proc";
	private static String PACK_SELECT = "standard.consulter.proc";

	private static String PACK_SELECT_SG = "standard.consulter_sg.proc";

	private static String PACK_INSERT = "standard.creer.proc";

	private static String PACK_UPDATE = "standard.modifier.proc";

	private static String PACK_DELETE = "standard.supprimer.proc";

	private static String PACK_CONTROLE = "standard.controler.proc";

	private static String PACK_CONTROLE_SG = "standard.controler_sg.proc";

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

		StandardForm bipForm = (StandardForm) form;

		// On récupère la clé pour trouver le nom de la procédure stockée dans
		// bip_proc.properties
		cle = recupererCle(mode, bipForm.getChoix());
		logBipUser.debug("cle:" + cle);

		if ((!mode.equals("delete")) && (bipForm.getChoix().equals("SG"))
				&& (!mode.equals("controler"))) {
			// Constitution de la chaine : concaténation des champs couts
			for (int i = 0; i < tab_niveau.length; i++) {
				for (int j = 0; j < tab_metier.length; j++) {
					sLibelle = tab_niveau[i] + "_" + tab_metier[j];

					// logBipUser.debug("sLibelle:"+sLibelle);

					try {
						oStandard = bipForm.getClass().getDeclaredMethod(
								"get" + sLibelle, parameterString).invoke(
								(Object) bipForm, param1);

						sCout = oStandard.toString();
						// logBipUser.debug("sCout:"+sCout);

						sChaine = sChaine + tab_niveau[i].toLowerCase() + "_"
								+ tab_metier[j] + "=" + sCout + ";";

					} // try
					catch (NoSuchMethodException me) {
						logBipUser.debug("Méthode inexistante");
						// Erreur d''exécution
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11209"));
						this.saveErrors(request, errors);

					} catch (SecurityException se) {
						// Erreur d''exécution
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11209"));
						this.saveErrors(request, errors);
					} catch (IllegalAccessException ia) {
						// Erreur d''exécution
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11209"));
						this.saveErrors(request, errors);
					} catch (IllegalArgumentException iae) {
						// Erreur d''exécution
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11209"));
						this.saveErrors(request, errors);
					} catch (InvocationTargetException ite) {
						// Erreur d''exécution
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11209"));
						this.saveErrors(request, errors);
					}

				}// for j
			}// for i

			logBipUser.debug("sChaine:" + sChaine);
			// Ajouter la chaine dans la hashtable des paramètres
			hParamProc.put("chaine", sChaine);

		}// if

		if ((!mode.equals("delete")) && (bipForm.getChoix().equals("AUTRE"))
				&& (!mode.equals("controler"))) {
			// Constitution de la chaine : concaténation des champs couts

			if (bipForm.getCoulog_Me().length() == 0)
				bipForm.setCoulog_Me("0,00");
			// if (bipForm.getCoulog_Mo().length()==0)
			// bipForm.setCoulog_Mo("0,00");
			// if (bipForm.getCoulog_Hom().length()==0)
			// bipForm.setCoulog_Hom("0,00");
			// if (bipForm.getCoulog_Gap().length()==0)
			// bipForm.setCoulog_Gap("0,00");
			if (bipForm.getCoutenv_sg_Me().length() == 0)
				bipForm.setCoutenv_sg_Me("0,00");
			if (bipForm.getCoutenv_sg_Mo().length() == 0)
				bipForm.setCoutenv_sg_Mo("0,00");
			if (bipForm.getCoutenv_sg_Hom().length() == 0)
				bipForm.setCoutenv_sg_Hom("0,00");
			if (bipForm.getCoutenv_sg_Gap().length() == 0)
				bipForm.setCoutenv_sg_Gap("0,00");
			if (bipForm.getCoutenv_ssii_Me().length() == 0)
				bipForm.setCoutenv_ssii_Me("0,00");
			if (bipForm.getCoutenv_ssii_Mo().length() == 0)
				bipForm.setCoutenv_ssii_Mo("0,00");
			if (bipForm.getCoutenv_ssii_Hom().length() == 0)
				bipForm.setCoutenv_ssii_Hom("0,00");
			if (bipForm.getCoutenv_ssii_Gap().length() == 0)
				bipForm.setCoutenv_ssii_Gap("0,00");
			String s_Coutlog = bipForm.getCoulog_Me();
			// String s_Coutlog =
			// bipForm.getCoulog_Me()+";"+bipForm.getCoulog_Mo()+";"+bipForm.getCoulog_Hom()+";"+bipForm.getCoulog_Gap()+";";
			String s_Coutsg = bipForm.getCoutenv_sg_Me() + ";"
					+ bipForm.getCoutenv_sg_Mo() + ";"
					+ bipForm.getCoutenv_sg_Hom() + ";"
					+ bipForm.getCoutenv_sg_Gap() + ";";
			String s_Coutssii = bipForm.getCoutenv_ssii_Me() + ";"
					+ bipForm.getCoutenv_ssii_Mo() + ";"
					+ bipForm.getCoutenv_ssii_Hom() + ";"
					+ bipForm.getCoutenv_ssii_Gap() + ";";

			logBipUser.debug("s_Coutlog:" + s_Coutlog);
			logBipUser.debug("s_Coutsg:" + s_Coutsg);
			logBipUser.debug("s_Coutssii:" + s_Coutssii);
			// Ajouter la chaine dans la hashtable des paramètres
			hParamProc.put("coulog", s_Coutlog);
			hParamProc.put("coutenv_sg", s_Coutsg);
			hParamProc.put("coutenv_ssii", s_Coutssii);

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
		StandardForm bipForm = (StandardForm) form;

		// exécution de la procédure PL/SQL
		try {
			if (bipForm.getChoix().equals("SG")) {
				sProc = PACK_SELECT_SG;
			} else
				sProc = PACK_SELECT;

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
							bipForm.setCodsg_bas(rset.getString(2));
							bipForm.setCodsg_bas_old(rset.getString(2));
							bipForm.setCodsg_haut(rset.getString(3));

							if (bipForm.getChoix().equals("SG")) {
								String sNiveau = rset.getString(8);
								bipForm.setFlaglock(rset.getInt(10));
								logBipUser.debug("sNiveau:" + sNiveau);

								try {

									Object[] param2 = {
											(Object) rset.getString(4),
											(Object) rset.getString(5),
											(Object) rset.getString(6),
											(Object) rset.getString(7) };

									for (int j = 0; j < tab_metier.length; j++) {
										if (sNiveau.length() == 2) {
											sNiveau = "Hc";
										}
										sLibMethode = "set" + sNiveau + "_"
												+ tab_metier[j];

										bipForm
												.getClass()
												.getDeclaredMethod(sLibMethode,
														parameterString)
												.invoke(
														(Object) bipForm,
														new Object[] { param2[j] });
									}// for

								} catch (NoSuchMethodException me) {
									logBipUser.debug("Méthode inexistante");
									// Erreur d''exécution
									errors.add(ActionErrors.GLOBAL_ERROR,
											new ActionError("11209"));
									this.saveErrors(request, errors);

								} catch (SecurityException se) {
									// Erreur d''exécution
									errors.add(ActionErrors.GLOBAL_ERROR,
											new ActionError("11209"));
									this.saveErrors(request, errors);
								} catch (IllegalAccessException ia) {
									// Erreur d''exécution
									errors.add(ActionErrors.GLOBAL_ERROR,
											new ActionError("11209"));
									this.saveErrors(request, errors);
								} catch (IllegalArgumentException iae) {
									// Erreur d''exécution
									errors.add(ActionErrors.GLOBAL_ERROR,
											new ActionError("11209"));
									this.saveErrors(request, errors);
								} catch (InvocationTargetException ite) {
									// Erreur d''exécution
									errors.add(ActionErrors.GLOBAL_ERROR,
											new ActionError("11209"));
									this.saveErrors(request, errors);
								}

							} else { // cas AUTRE

								String cout_me = rset.getString(4);
								String cout_mo = rset.getString(5);
								String cout_hom = rset.getString(6);
								String cout_gap = rset.getString(7);

								StringTokenizer st = new StringTokenizer(
										cout_me, ";");
								for (int i = 0; st.hasMoreTokens(); i++) {
									if (i == 0)
										bipForm.setCoulog_Me(st.nextToken());
									if (i == 1)
										bipForm
												.setCoutenv_sg_Me(st
														.nextToken());
									if (i == 2)
										bipForm.setCoutenv_ssii_Me(st
												.nextToken());
								}

								st = new StringTokenizer(cout_mo, ";");
								for (int i = 0; st.hasMoreTokens(); i++) {
									if (i == 0)
										bipForm.setCoulog_Mo(st.nextToken());
									if (i == 1)
										bipForm
												.setCoutenv_sg_Mo(st
														.nextToken());
									if (i == 2)
										bipForm.setCoutenv_ssii_Mo(st
												.nextToken());
								}

								st = new StringTokenizer(cout_hom, ";");
								for (int i = 0; st.hasMoreTokens(); i++) {
									if (i == 0)
										bipForm.setCoulog_Hom(st.nextToken());
									if (i == 1)
										bipForm.setCoutenv_sg_Hom(st
												.nextToken());
									if (i == 2)
										bipForm.setCoutenv_ssii_Hom(st
												.nextToken());
								}

								st = new StringTokenizer(cout_gap, ";");
								for (int i = 0; st.hasMoreTokens(); i++) {
									if (i == 0)
										bipForm.setCoulog_Gap(st.nextToken());
									if (i == 1)
										bipForm.setCoutenv_sg_Gap(st
												.nextToken());
									if (i == 2)
										bipForm.setCoutenv_ssii_Gap(st
												.nextToken());
								}

								bipForm.setFlaglock(rset.getInt(8));
							}

							bipForm.setMsgErreur(null);
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

	protected String recupererCle(String mode, String choix) {
		String cle = null;

		if (mode.equals("insert")) {
			cle = PACK_INSERT;
		} else if (mode.equals("update")) {
			cle = PACK_UPDATE;
		} else if (mode.equals("delete")) {
			cle = PACK_DELETE;
		} else if (mode.equals("controler")) {
			if (choix.equals("SG")) {
				cle = PACK_CONTROLE_SG;
			} else
				cle = PACK_CONTROLE;
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
}
