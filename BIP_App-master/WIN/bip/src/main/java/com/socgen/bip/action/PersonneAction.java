package com.socgen.bip.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.Method;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.sound.midi.Sequence;

import org.apache.commons.lang.StringUtils;
import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.commun.form.AutomateForm;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.DatesEffetForm;
import com.socgen.bip.form.PersonneForm;
import com.socgen.bip.form.RecupAppliForm;
import com.socgen.bip.metier.ConsultLogsBip;
import com.socgen.bip.user.UserBip;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.ich.ihm.menu.PaginationVector;

/**
 * @author N.BACCAM - 20/06/2003
 * 
 * Action de mise à jour des personnes chemin : Ressources/MAJ/Personnes pages :
 * bPersonneAd.jsp et mPersonneAd.jsp pl/sql : resper.sql
 */

public class PersonneAction extends AutomateAction {

	private static String PACK_SELECT_C = "personne.consulter_c.proc";

	private static String PACK_SELECT_M = "personne.consulter_m.proc";

	private static String PACK_SELECT_S = "personne.consulter_s.proc";

	private static String PACK_SELECT_PERSONNE_COL = "personne.consulter_pcol.proc";

	private static String PACK_INSERT = "personne.creer.proc";

	private static String PACK_UPDATE = "personne.modifier.proc";
	
	private static String PACK_VERIF_MATRICULE = "personne.verif.matricule.proc";

	private static String PACK_VERIF_HOMONYME = "personne.verif.homonyme.proc";
	
	private static String PACK_SELECT_DOUBLON ="personne.consulter.doublon.proc";
	
	private static String GET_LIB_SOCCODE = "personne.recup.soccode";
	
	private static String PACK_RECUP_LIB_MCI="personne.recup.mci.lib.proc";
	
	private static String PACK_GETMCIDEFAUT = "personne.recup.mci.defaut.proc";
	
	private static String PACK_ISMCIOBLIGATOIRE = "personne.recup.mci.obligatoire.proc";

	private String nomProc;
	
	
	/**
	 * @see org.apache.struts.action.Action#perform(ActionMapping, ActionForm,
	 *      HttpServletRequest, HttpServletResponse)
	 */
	public ActionForward bipPerform(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			Hashtable hParamProc) throws IOException, ServletException {
		// ActionErrors errors = new ActionErrors();
		ActionForward actionForward = null;
		HttpSession session = request.getSession(false);

		String action = null;
		String sMode = null;

		AutomateForm automateForm = (AutomateForm) form;

		// Extraction de la valeur action
		action = automateForm.getAction();

		// Extraction du nom de la page
		String pageName = (String) request.getParameter("page");
		
		logService.entry("Début Action  = " + action);

		// Actions pour les listes multi-pages
		if (PAGE_INDEX.equals(action)) {
				actionForward = pageIndex(mapping, form, request, response,
						errors);

		}

		if (PAGE_SUIVANTE.equals(action)) {
				actionForward = pageSuivante(mapping, form, request, response,
						errors);

		}
		if (PAGE_PRECEDENTE.equals(action)) {
				actionForward = pagePrecedente(mapping, form, request,
						response, errors);
		}
		
		if (action.equals(ACTION_ANNULER)) {
			actionForward = annuler(mapping, form, request, response, errors,
					hParamProc);
		} else if (action.equals(ACTION_SUITE)) {
			actionForward = suite(mapping, form, request, response, errors,
					hParamProc);
		} else if (action.equals(ACTION_CREER)) {
			// on sauvegarde le titre de la page
			automateForm.setTitrePage("Créer");
			automateForm.setMode("insert");
			actionForward = creer(mapping, form, request, response, errors,
					hParamProc);
		} else if (action.equals(ACTION_MODIFIER)) {
			// on sauvegarde le titre de la page
			automateForm.setTitrePage("Modifier");
			automateForm.setMode("update");
			actionForward = consulter(mapping, form, request, response, errors,
					hParamProc);
		} else if (action.equals(ACTION_SUPPRIMER)) {
			// on sauvegarde le titre de la page
			automateForm.setTitrePage("Supprimer");
			automateForm.setMode("delete");
			actionForward = consulter(mapping, form, request, response, errors,
					hParamProc);
		} else if (ACTION_REFRESH.equals(action)) {

			sMode = automateForm.getMode();
			if (sMode.equals("insert"))
				automateForm.setAction("creer");
			else
				automateForm.setAction("update");

			// On recharge la même page(ecran)
			actionForward = refresh(mapping, form, request, response, errors,
					hParamProc);
		} else if (action.equals(ACTION_VALIDER)) {
			// Gestion des homonymes en modifications des personnes.
			sMode = automateForm.getMode();
			if (((PersonneForm) form).getHomonyme() != null)
				actionForward = homonyme(mapping, form, sMode, request,
						response, errors, hParamProc);
			else
				actionForward = valider(mapping, form, sMode, request,
						response, errors, hParamProc);
		} else if ((action != null) && (action.length() > 0)) {
			// Si l'action n'est pas définie précedemment on recherche s'il
			// existe une méthode correspondante
			// càd avec le même nom
			try {
				// liste des types des paramètres de la méthode recherchée ce
				// sont les mêmes que n'importe quelle
				// méthode action
				Class partypes[] = new Class[6];
				partypes[0] = ActionMapping.class;
				partypes[1] = ActionForm.class;
				partypes[2] = HttpServletRequest.class;
				partypes[3] = HttpServletResponse.class;
				partypes[4] = ActionErrors.class;
				partypes[5] = Hashtable.class;

				// liste des objets à passer en paramètre à la fonction
				Object arglist[] = new Object[6];
				arglist[0] = mapping;
				arglist[1] = form;
				arglist[2] = request;
				arglist[3] = response;
				arglist[4] = errors;
				arglist[5] = hParamProc;

				// Recherche de la fonction
				Method meth = this.getClass().getDeclaredMethod(action,
						partypes);

				// Appel de la fonction
				Object retobj = meth.invoke((Object) this, arglist);

				// Récupération de l'objet retourné
				actionForward = (ActionForward) retobj;

			} catch (NoSuchMethodException e) {
				logBipUser.error("La méthode <" + action
						+ "> correspondant à l'action <" + action
						+ "> est introuvable dans la classe <"
						+ this.getClass().getName() + ">.");
			} catch (Throwable e) {
				logBipUser.debug("Erreur lors de la reflexion : "
						+ e.toString());
				logBipUser.debug("Erreur lors de la reflexion : "
						+ e.getMessage());
				logBipUser.debug("Erreur lors de la reflexion : "
						+ e.getLocalizedMessage());
			}
		}

		if (actionForward == null) {
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
					"error.action.inconnue", action));
			// this.saveErrors(request,errors);
			logService.error("l'action [" + action + "] est inconnue");
			 return mapping.findForward("error");
		} else {
			logService.exit("Fin Action  = " + action);
			 return actionForward;
		}
	}// perform

	/**
	 * Action qui permet de créer un code Personne
	 */
	protected ActionForward creer(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;

		String signatureMethode = "PersonneAction -creer( mapping, form , request,  response,  errors )";

		// logService.entry(signatureMethode);;
		logBipUser.entry(signatureMethode);
		// exécution de la procédure PL/SQL
		try {
			((PersonneForm) form).setFocus("");
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT_C);
			try {
				message = jdbc.recupererResult(vParamOut, "creer");
				// récupérer la date de situ
				for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
					ParametreProc paramOut = (ParametreProc) e.nextElement();
					if (paramOut.getNom().equals("datsitu")) {
						String sDateCreation = (String) paramOut.getValeur();
						logBipUser.debug("Date de situ :" + sDateCreation);
						((PersonneForm) form).setDatsitu(sDateCreation);
					}
					if (paramOut.getNom().equals("matricule")) {
						String sMatricule = (String) paramOut.getValeur();
						logBipUser.debug("Matricule :" + sMatricule);
						((PersonneForm) form).setMatricule(sMatricule);
					}
					if (paramOut.getNom().equals("id")) {
						String sId = (String) paramOut.getValeur();
						logBipUser.debug("Identifiant Ressource :" + sId);
						((PersonneForm) form).setIdent(sId);
					}
					if (paramOut.getNom().equals("codsg")) {
						String sPole = (String) paramOut.getValeur();
						logBipUser.debug("Pole :" + sPole);
						((PersonneForm) form).setCodsg(sPole);
					}
				}

			} catch (BaseException be) {
				logBipUser.debug("PersonneAction -creer() --> BaseException :"
						+ be);
				logBipUser.debug("PersonneAction -creer() --> Exception :"
						+ be.getInitialException().getMessage());
				logBipUser.debug("PersonneAction -creer() --> BaseException :"
						+ be);
				logBipUser.debug("PersonneAction -creer() --> Exception :"
						+ be.getInitialException().getMessage());
				// Erreur de lecture du resultSet
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}

			// Si on est sur la page d'homonyme et qu'il y a la demande de
			// création,
			// On remet les valeurs relatives à l'homonyme à null
			// On continue pour être dirigé sur la page de création
			if ((((PersonneForm) form).getHomonyme() != null)
					&& (((PersonneForm) form).getHomonyme()).equals("true")) {
				logBipUser.debug("On va créer un nouvel homonyme");
				((PersonneForm) form).setIdent(null);
				((PersonneForm) form).setMatricule(null);
				((PersonneForm) form).setCodsg(null);
				message = "";
			}

			// Cas d'un homonyme
			if (!message.equals("")) {
				// Entité déjà existante, on récupère le message
				logBipUser.debug("message d'erreur:" + message);
				logBipUser.exit(signatureMethode);

				// On renvoie sur la page de l'homonyme
				 jdbc.closeJDBC(); return mapping.findForward("homonyme");
			}

		}// try
		catch (BaseException be) {
			logBipUser.debug("PersonneAction-creer() --> BaseException :" + be);
			logBipUser.debug("PersonneAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			logBipUser.debug("PersonneAction-creer() --> BaseException :" + be);
			logBipUser.debug("PersonneAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((PersonneForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");

			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}

		// logBipUser.exit(signatureMethode);
		logBipUser.exit(signatureMethode);
		jdbc.closeJDBC(); return mapping.findForward("ecran");
	}// creer

	/**
	 * Method valider Action qui permet d'enregistrer les données pour la
	 * création, modification, suppression d'un code client
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param errors
	 * @ jdbc.closeJDBC(); return ActionForward
	 * @throws ServletException
	 * 
	 */

	protected ActionForward valider(ActionMapping mapping, ActionForm form,
			String mode, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors,
			Hashtable hParamProctest) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String cle = null;
		String message = null;
		
		ParametreProc paramOut;
		boolean msg = false;

		String signatureMethode = "PersonneAction-valider(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors )";
		logBipUser.entry(signatureMethode);
		logBipUser.debug("mode de mise à jour:" + mode);
		
		if ( mode.equals("vide") ) {			
			return mapping.findForward("ecran");
		}

		// On récupère la clé pour trouver le nom de la procédure stockée dans
		// bip_proc.properties
		cle = recupererCle(mode);

		// Création d'une nouvelle form
		PersonneForm bipForm = (PersonneForm) form;
		String confirm = bipForm.getConfirm();
		// On exécute la procédure stockée pour la verification
			
		if( StringUtils.isEmpty(confirm) || !confirm.equals("non")){
			try {
			
				//vParamOut = jdbc.getResult(hParamProctest, configProc, cle);
				vParamOut = jdbc.getResult(hParamProctest, configProc, PACK_VERIF_MATRICULE);
				try {
					
					message = jdbc.recupererResult(vParamOut, "valider");
					logBipUser.debug("valider() --> getMessage :" + message);
					
					// Récupération des résultats
					for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
						paramOut = (ParametreProc) e.nextElement();
						
						//recuperer la valeur du confirm
						if(paramOut.getNom().equals("confirm")){
							confirm = (String)paramOut.getValeur();
						}
						
						// récupérer le message
						if (paramOut.getNom().equals("message")) {
							//message = (String) paramOut.getValeur();
							if ( paramOut.getValeur() != null) {
								message = BipException.getMessageFocus((String) paramOut.getValeur(), form);
								System.out.println("message : ----" + message);
							}
	 
						}

					}// for
					
					bipForm.setConfirm(confirm);

					
				} catch (BaseException be) {
					logBipUser.debug("valider() --> BaseException :" + be);
					logBipUser.debug("valider() --> Exception :"
							+ be.getInitialException().getMessage());
					logService.debug("valider() --> BaseException :" + be);
					logService.debug("valider() --> Exception :"
							+ be.getInitialException().getMessage());
					errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
					 jdbc.closeJDBC(); return mapping.findForward("error");
				}
				
				
				
				
				
				//Gestion des messages d'erreurs
				if (message != null && !message.equals("")) {
					// on récupère le message
					((PersonneForm) form).setMsgErreur(message);
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
					((PersonneForm) form).setMsgErreur(message);
	
					if (!mode.equals("delete")) {
						 jdbc.closeJDBC(); return mapping.findForward("ecran");
					}
				} else {
					// Erreur d''exécution de la procédure stockée
					errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
					request.setAttribute("messageErreur", be.getInitialException()
							.getMessage());
					 jdbc.closeJDBC(); return mapping.findForward("error");
				}
			}
		}
		
		if(confirm.equals("non")){
		
			//On execute la requete stockee pour l'insertion ou la mise a jour
			//selon le confirm recupere precedement
			try {
				vParamOut = jdbc.getResult(hParamProctest, configProc, cle);
	
				try {
					message = jdbc.recupererResult(vParamOut, "valider");
					logBipUser.debug("valider() --> getMessage :" + message);
					
					// Récupération des résultats
					for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
						paramOut = (ParametreProc) e.nextElement();
						
					
						// récupérer le message
						if (paramOut.getNom().equals("message")) {
							message = (String) paramOut.getValeur();
	
						}
	
						// récupérer l'identifiant
						if (paramOut.getNom().equals("ident")) {
							((PersonneForm) form).setIdent((String) paramOut
									.getValeur());
							request.setAttribute("ident", (String) paramOut
									.getValeur());
						}
	
					}
	
				} catch (BaseException be) {
					logBipUser.debug("valider() --> BaseException :" + be);
					logBipUser.debug("valider() --> Exception :"
							+ be.getInitialException().getMessage());
					logService.debug("valider() --> BaseException :" + be);
					logService.debug("valider() --> Exception :"
							+ be.getInitialException().getMessage());
					errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
					 jdbc.closeJDBC(); return mapping.findForward("error");
				}
				
				//Gestion des messages d'erreurs
				if (message != null && !message.equals("")) {
					// on récupère le message
					((PersonneForm) form).setMsgErreur(message);
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
					((PersonneForm) form).setMsgErreur(message);
	
					if (!mode.equals("delete")) {
						 jdbc.closeJDBC(); return mapping.findForward("ecran");
					}
				} else {
					// Erreur d''exécution de la procédure stockée
					errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
					request.setAttribute("messageErreur", be.getInitialException()
							.getMessage());
					 jdbc.closeJDBC(); return mapping.findForward("error");
				}
			}
		}
		logBipUser.exit(signatureMethode);
		 jdbc.closeJDBC(); 
		 
		 if(confirm.equals("non"))
		 {
			 	return mapping.findForward("initial");
		 }
		 else{
			 	return mapping.findForward("ecran");
		 }
	}// valider

	/**
	 * Action qui permet de visualiser les données liées à un code Personne pour
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

		String signatureMethode = "PersonneAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		PersonneForm bipForm = (PersonneForm) form;
		bipForm.setFocus("");
		
		// exécution de la procédure PL/SQL

		if (((((PersonneForm) form).getHomonyme()) == null)
				|| !(((PersonneForm) form).getHomonyme()).equals("true")) {
			// premier passage: on vient de la page gestion des personnes
			try {
				vParamOut = jdbc.getResult(
						hParamProc, configProc, PACK_SELECT_M);

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
							logBipUser.debug("ResultSet");
							if (rset.next()) {

								bipForm.setIdent(rset.getString(1));
								bipForm.setFlaglock(rset.getInt(2));
								bipForm.setRnom(rset.getString(3));
								bipForm.setRprenom(rset.getString(4));
								bipForm.setMatricule(rset.getString(5));
								bipForm.setIcodimm(rset.getString(6));
								bipForm.setBatiment(rset.getString(7));
								bipForm.setEtage(rset.getString(8));
								bipForm.setBureau(rset.getString(9));
								bipForm.setRtel(rset.getString(10));
								bipForm.setIgg(rset.getString(11));
								bipForm.setMsgErreur(null);
								
								if ((rset.getString(5)!= null && "Y".equals(rset.getString(5).substring(0,1))) 
										|| (rset.getString(11) != null && "9".equals(rset.getString(11).substring(0,1))) ){
									bipForm.setIsClone("oui");
								} else {
									bipForm.setIsClone("non");
								}
							} else
								msg = true;

						}// try
						catch (SQLException sqle) {
							logBipUser
									.debug("PersonneAction-consulter() --> SQLException :"
											+ sqle);
							logBipUser
									.debug("PersonneAction-consulter() --> SQLException :"
											+ sqle);
							// Erreur de lecture du resultSet
							errors.add(ActionErrors.GLOBAL_ERROR,
									new ActionError("11217"));
							// this.saveErrors(request,errors);
							 jdbc.closeJDBC(); return mapping.findForward("error");
						} finally {
							try {
								if (rset != null)
									rset.close();
							} catch (SQLException sqle) {
								logBipUser
										.debug("PersonneAction-consulter() --> SQLException-rset.close() :"
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
					// le code Personne n'existe pas, on récupère le message
					bipForm.setMsgErreur(message);
					// on reste sur la même page
					 jdbc.closeJDBC(); return mapping.findForward("initial");
				}
			}// try
			catch (BaseException be) {
				logBipUser.debug(
						"PersonneAction-consulter() --> BaseException :" + be,
						be);
				logBipUser.debug("PersonneAction-consulter() --> Exception :"
						+ be.getInitialException().getMessage());

				logBipUser.debug(
						"PersonneAction-consulter() --> BaseException :" + be,
						be);
				logBipUser.debug("PersonneAction-consulter() --> Exception :"
						+ be.getInitialException().getMessage());
				// Si exception sql alors extraire le message d'erreur du
				// message global
				if (be.getInitialException().getClass().getName().equals(
						"java.sql.SQLException")) {
					message = BipException.getMessageFocus(BipException
							.getMessageOracle(be.getInitialException()
									.getMessage()), form);
					((PersonneForm) form).setMsgErreur(message);
					 jdbc.closeJDBC(); return mapping.findForward("initial");

				} else {
					// Erreur d''exécution de la procédure stockée
					errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
							"11201"));
					request.setAttribute("messageErreur", be
							.getInitialException().getMessage());
					// this.saveErrors(request,errors);
					 jdbc.closeJDBC(); return mapping.findForward("error");
				}
			}

		}
		// Deuxième passage: on vient de la page des homonymes
		else // ((((PersonneForm)form).getHomonyme()).equals("true"))
		{
			bipForm.setIdent(((PersonneForm) form).getIdent());
			bipForm.setFlaglock(((PersonneForm) form).getFlaglock());
			bipForm.setRnom(((PersonneForm) form).getRnom());
			bipForm.setRprenom(((PersonneForm) form).getRprenom());
			bipForm.setMatricule(((PersonneForm) form).getMatricule());
			bipForm.setIcodimm(((PersonneForm) form).getIcodimm());
			bipForm.setBatiment(((PersonneForm) form).getBatiment());
			bipForm.setEtage(((PersonneForm) form).getEtage());
			bipForm.setBureau(((PersonneForm) form).getBureau());
			bipForm.setRtel(((PersonneForm) form).getRtel());
			bipForm.setMsgErreur(null);
		}
		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	}// consulter

	protected String recupererCle(String mode) {
		String cle = null;
		if (mode.equals("insert")) {
			cle = PACK_INSERT;
		} else {
			cle = PACK_UPDATE;
		}
		  
		  return cle;
	}

	protected ActionForward homonyme(ActionMapping mapping, ActionForm form,
			String sMode, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors,
			Hashtable hParamProc) throws ServletException {

		
		JdbcBip jdbc = new JdbcBip(); 
		
		if ("non".equals(((PersonneForm) form).getConfirm()))
		{
			return valider(mapping, form, sMode, request, response, errors,hParamProc);
		}
		
		if ( ((PersonneForm) form).getIgg().length() != 0)
		{
			// cas d'un IGG commencant par 9 nous sommes en présence d'un clone nous mettons directement à jour sans verifier la presence d'homonyme
			if ("9".equals(((PersonneForm) form).getIgg().substring(0,1)))
			{
				return valider(mapping, form, sMode, request, response, errors,hParamProc);
			}
		}
		else 
		{
			//	si un IGG n'est pas renseigné alors on verifie si le matricule commence par un Y nous sommes en présence d'un clone nous mettons directement à jour sans verifier la presence d'homonyme
			if ("Y".equals(((PersonneForm) form).getMatricule().substring(0,1)))
			{
				return valider(mapping, form, sMode, request, response, errors,hParamProc);
			}
		}
			
		
			
		/*if (((PersonneForm) form).getHomonyme().equals("")
				&& sMode.equals("update")) {*/
			
			
			// lot4.3 KHA Ajout gestion des homonymes en modification
			// Si homonyme il faut valider deux fois.

			Vector vParamOut = new Vector();
			String message = " ";
			boolean msg = false;

			String signatureMethode = "PersonneAction -homonyme( mapping, form , mode, request,  response,  errors )";

			// logService.entry(signatureMethode);;
			logBipUser.entry(signatureMethode);
			// exécution de la procédure PL/SQL
			
			
			
			
			try {
				vParamOut = jdbc.getResult(
						hParamProc, configProc, PACK_VERIF_HOMONYME);
				try {
					message = jdbc.recupererResult(vParamOut, "valider");
					// récupérer la date de situ
					/*for (Enumeration e = vParamOut.elements(); e
							.hasMoreElements();) {
						ParametreProc paramOut = (ParametreProc) e
								.nextElement();
						
						 * if (paramOut.getNom().equals("datsitu")) { String
						 * sDateCreation=(String)paramOut.getValeur();
						 * logBipUser.debug("Date de situ :"+sDateCreation);
						 * ((PersonneForm)form).setDatsitu(sDateCreation); }
						 
						if (paramOut.getNom().equals("matricule")) {
							String sMatricule = (String) paramOut.getValeur();
							logBipUser.debug("Matricule :" + sMatricule);
							((PersonneForm) form).setNewmatricule(sMatricule);
						}
						if (paramOut.getNom().equals("id")) {
							String sId = (String) paramOut.getValeur();
							logBipUser.debug("Identifiant Ressource :" + sId);
							((PersonneForm) form).setNewident(sId);
						}
						if (paramOut.getNom().equals("codsg")) {
							String sPole = (String) paramOut.getValeur();
							logBipUser.debug("Pole :" + sPole);
							((PersonneForm) form).setNewcodsg(sPole);
						}
					}*/

				} catch (BaseException be) {
					logBipUser
							.debug("PersonneAction -homonyme() --> BaseException :"
									+ be);
					logBipUser
							.debug("PersonneAction -homonyme() --> Exception :"
									+ be.getInitialException().getMessage());
					logBipUser
							.debug("PersonneAction -homonyme() --> BaseException :"
									+ be);
					logBipUser
							.debug("PersonneAction -homonyme() --> Exception :"
									+ be.getInitialException().getMessage());
					// Erreur de lecture du resultSet
					errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
							"11217"));
					// this.saveErrors(request,errors);
					 jdbc.closeJDBC(); return mapping.findForward("error");
				}

				// Si on est sur la page d'homonyme et qu'il y a la demande de
				// création,
				// On remet les valeurs relatives à l'homonyme à null
				// On continue pour être dirigé sur la page de création
				// if ((((PersonneForm)form).getHomonyme()!=null) &&
				// (((PersonneForm)form).getHomonyme()).equals("true")) {
				// logBipUser.debug("On va créer un nouvel homonyme");
				// ((PersonneForm)form).setIdent(null);
				// ((PersonneForm)form).setMatricule(null);
				// ((PersonneForm)form).setCodsg(null);
				// }
				// Cas d'un homonyme
				if (!message.equals(" ")) {
					// Entité déjà existante, on récupère le message
					logBipUser.debug("message d'erreur:" + message);
					logBipUser.exit(signatureMethode);
					((PersonneForm) form).setHomonyme("true");
					// On renvoie sur la page de l'homonyme
					((PersonneForm) form).setMsgErreur(message);
					 jdbc.closeJDBC(); return mapping.findForward("ecran");
				}

			}// try
			catch (BaseException be) {
				logBipUser
						.debug("PersonneAction-homonyme() --> BaseException :"
								+ be);
				logBipUser.debug("PersonneAction-homonyme() --> Exception :"
						+ be.getInitialException().getMessage());
				logBipUser
						.debug("PersonneAction-homonyme() --> BaseException :"
								+ be);
				logBipUser.debug("PersonneAction-homonyme() --> Exception :"
						+ be.getInitialException().getMessage());
				if (be.getInitialException().getClass().getName().equals(
						"java.sql.SQLException")) {
					message = BipException.getMessageFocus(BipException
							.getMessageOracle(be.getInitialException()
									.getMessage()), form);
					((PersonneForm) form).setMsgErreur(message);
					 jdbc.closeJDBC(); return mapping.findForward("initial");

				} else {
					// Erreur d''exécution de la procédure stockée
					errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
							"11201"));
					// this.saveErrors(request,errors);
					 jdbc.closeJDBC(); return mapping.findForward("error");
				}
			}

			// logBipUser.exit(signatureMethode);
			logBipUser.exit(signatureMethode);
	//	}
		jdbc.closeJDBC();
		 jdbc.closeJDBC(); return valider(mapping, form, sMode, request, response, errors,
				hParamProc);
		 
		
		// fin lot 4.3 kha

	}

	protected ActionForward suite(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = "PersonneAction-suite(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		PersonneForm bipForm = (PersonneForm) form;

		// exécution de la procédure PL/SQL
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT_S);

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
						logBipUser.debug("ResultSet");
						if (rset.next()) {

							bipForm.setIdent(rset.getString(1));
							bipForm.setRnom(rset.getString(2));
							bipForm.setRprenom(rset.getString(3));
							bipForm.setMatricule(rset.getString(4));
							bipForm.setPrestation(rset.getString(10));
							bipForm.setSoccode(rset.getString("soccode"));
							bipForm.setIgg(rset.getString(13));
							bipForm.setMsgErreur(null);
						} else {
							msg = true;
						}

						logBipUser.debug("soccode : " + bipForm.getSoccode());

					}// try
					catch (SQLException sqle) {
						logBipUser
								.debug("PersonneAction-suite() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("PersonneAction-suite() --> SQLException :"
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
									.debug("PersonneAction-suite() --> SQLException-rset.close() :"
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
				// le code Personne n'existe pas, on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		}// try
		catch (BaseException be) {
			logBipUser.debug("PersonneAction-suite() --> BaseException :" + be,
					be);
			logBipUser.debug("PersonneAction-suite() --> Exception :"
					+ be.getInitialException().getMessage());

			logBipUser.debug("PersonneAction-suite() --> BaseException :" + be,
					be);
			logBipUser.debug("PersonneAction-suite() --> Exception :"
					+ be.getInitialException().getMessage());

			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((PersonneForm) form).setMsgErreur(message);
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

		 jdbc.closeJDBC(); return mapping.findForward("suite");
	}

	protected ActionForward suite1(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		String signatureMethode = "PersonneAction -suite1( mapping, form , request,  response,  errors, hParamProc )";		
		logBipUser.entry(signatureMethode);

		PersonneForm bipForm = (PersonneForm) form;

		if ( "vide".equals(bipForm.getEtape()) ) {	
			bipForm.setFocus("rnom");
			return mapping.findForward("ecran");
		}

		if ( "recherche".equals(bipForm.getEtape()) ) {			
			return mapping.findForward("recherche");
		}

		if ( "recherche2".equals(bipForm.getEtape()) ) {			
			return mapping.findForward("recherche2");
			
		}
		hParamProc.put("ident", "INCONNU");
		
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		ParametreProc paramOut;
		String message = "";
		Vector vListe = new Vector();
		int linesPerPage = 2;
		int trouve = 0;
		
		try {
			
			// Recherche doublon
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT_DOUBLON);

			
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
							trouve = 1;	

							bipForm.setMsgErreur(null);	
						}

					}// try
					catch (SQLException sqle) {
						logService
								.debug("PersonneAction-suite1() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("PersonneAction-suite() --> SQLException :"
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
									.debug("PersonneAction-suite()  --> SQLException-rset.close() :"
											+ sqle);
							// Erreur de lecture du resultSet
							errors.add(ActionErrors.GLOBAL_ERROR,
									new ActionError("11217"));
							 jdbc.closeJDBC(); return mapping.findForward("error");
						}

					}
				}// if
			}// for
			
			if ( trouve == 1) {
				jdbc.closeJDBC(); 
				//bipForm.setAction("creer");
				return mapping.findForward("homonyme");
				
			}
			
			
			// Initialisation des donnees du formulaire
			
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT_PERSONNE_COL);
		
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
						logBipUser.debug("ResultSet");
						if (rset.next()) {
							bipForm.setRnom(rset.getString(1));
							bipForm.setRprenom(rset.getString(2));
							bipForm.setMatricule(rset.getString(3));
							bipForm.setIcodimm(rset.getString(4));
							bipForm.setBatiment(rset.getString(5));
							bipForm.setEtage(rset.getString(6));
							bipForm.setBureau(rset.getString(7));
							bipForm.setRtel(rset.getString(8));
							bipForm.setIgg(rset.getString(9));
							bipForm.setMsgErreur(null);

						}

					}// try
					catch (SQLException sqle) {
						logBipUser
								.debug("PersonneAction-suite1() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("PersonneAction-suite1() --> SQLException :"
										+ sqle);
						// Erreur de lecture du resultSet
						errors.add(ActionErrors.GLOBAL_ERROR,
								new ActionError("11217"));
						// this.saveErrors(request,errors);
						 jdbc.closeJDBC(); return mapping.findForward("error");
					} finally {
						try {
							if (rset != null)
								rset.close();
						} catch (SQLException sqle) {
							logBipUser
									.debug("PersonneAction-suite1() --> SQLException-rset.close() :"
											+ sqle);
							// Erreur de lecture du resultSet
							errors.add(ActionErrors.GLOBAL_ERROR,
									new ActionError("11217"));
							 jdbc.closeJDBC(); return mapping.findForward("error");
						}

					}
				}// if
				
				

			}// for	
			
		}
		catch (BaseException be) {
			logBipUser.debug("PersonneAction-suite1() --> BaseException :" + be,
					be);
			logBipUser.debug("PersonneAction-suite1() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("PersonneAction-suite1() --> BaseException :" + be,
					be);
			logService.debug("PersonneAction-suite1() --> Exception :"
					+ be.getInitialException().getMessage());
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));

			// this.saveErrors(request,errors);
			 jdbc.closeJDBC(); return mapping.findForward("error");
			 
		}
		if ( "P".equals(bipForm.getRtype()) ) {
			bipForm.setFocus("soccode");
		}
		return mapping.findForward("ecran");
	}
	
	protected ActionForward refresh(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		PersonneForm bipForm = (PersonneForm) form;
		// Intitulé à charger
		String focus = bipForm.getFocus();

		Vector vParamOut = new Vector();
		Vector vParamOut2 = new Vector();
		ParametreProc paramOut;
		String message = "";
		String[] values = null;
		
		try {
			
			bipForm.setMciCalcule("N");
			bipForm.setMciObligatoire("N");
			
			// calcul si le mci est obligatoire pour le dpg
			if ( !"".equals(bipForm.getCodsg())) {
				vParamOut = jdbc.getResult(
						hParamProc, configProc, PACK_ISMCIOBLIGATOIRE);	
				bipForm.setMciObligatoire((String) ((ParametreProc) vParamOut
						.elementAt(0)).getValeur());
				logBipUser.debug("PersonneAction-refresh() --> ISMCIOBLIGATOIRE :" + (String) ((ParametreProc) vParamOut
						.elementAt(0)).getValeur());
			}
			
			if ("soccode".equals(focus)) {
			vParamOut = jdbc.getResult(
						hParamProc, configProc, GET_LIB_SOCCODE);
				bipForm.setLib_soccode((String) ((ParametreProc) vParamOut
						.elementAt(0)).getValeur());
				bipForm.setMsgErreur((String) ((ParametreProc) vParamOut
						.elementAt(1)).getValeur());
				
				// MAJ du Focus
				if (bipForm.getMsgErreur() == null)
					bipForm.setFocus("soccode");
				
			}	
				if ("modeContractuelInd".equals(focus)) {
					
					vParamOut = jdbc.getResult(
							hParamProc, configProc, PACK_RECUP_LIB_MCI);
					bipForm.setLib_mci((String) ((ParametreProc) vParamOut
							.elementAt(0)).getValeur());
					
					// MAJ du Focus
					if (bipForm.getMsgErreur() == null)
						bipForm.setFocus("cpident");
				}

				// On enrichie pour un type de prestation SLT ou IFO
				bipForm.setMciAlert("N");
				bipForm.setMciCalcule("N");
				
				if ( "DI".equals(bipForm.getCode_domaine()) && 
						(    "SLT".equals(bipForm.getPrestation()) 
						  || "IFO".equals(bipForm.getPrestation()) 
						)
					   ) {
									
					vParamOut = jdbc.getResult(
							hParamProc, configProc, PACK_GETMCIDEFAUT);
					
					// Récupération des résultats
					for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
						paramOut = (ParametreProc) e.nextElement();
		
						// récupérer le message
						if (paramOut.getNom().equals("message")) {
							message = (String) paramOut.getValeur();
		
						}
						if (paramOut.getNom().equals("modeContractuelInd")) {
							String oldMci = bipForm.getModeContractuelInd();
							
							if (paramOut.getValeur() != null) {
								bipForm.setMciCalcule("O");
								bipForm.setModeContractuelInd( (String) paramOut.getValeur() );
								if ( !paramOut.getValeur().equals(oldMci) ) {
									bipForm.setMciAlert("O");
								}
							} else {
								bipForm.setMciCalcule("N");	
							}
							
						}// if
						
						if (paramOut.getNom().equals("lib_mci")) {
							
							bipForm.setLib_mci( (String) paramOut.getValeur() );
						}
					}// for											
				}
				
				if (bipForm.getModeContractuelInd() != null)
					hParamProc.put("modeContractuelInd",bipForm.getModeContractuelInd());
				
				vParamOut = jdbc.getResult(
						hParamProc, configProc, PACK_RECUP_LIB_MCI);
				bipForm.setLib_mci((String) ((ParametreProc) vParamOut
						.elementAt(0)).getValeur());
				
				
		} catch (BaseException be) {
			logBipUser.debug("PersonneAction-refresh() --> BaseException :" + be,
					be);
			logBipUser.debug("PersonneAction-refresh() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("PersonneAction-refresh() --> BaseException :" + be,
					be);
			logService.debug("PersonneAction-refresh() --> Exception :"
					+ be.getInitialException().getMessage());
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));

			// this.saveErrors(request,errors);
			 jdbc.closeJDBC(); return mapping.findForward("error");
		}
		jdbc.closeJDBC();
				
		 if (bipForm.getAction() == "creer" || bipForm.getAction() == "suite1" || bipForm.getAction() == "valider" ) { 
		  return mapping.findForward("ecran");
		 }
		 else
		 	{
			 return mapping.findForward("initial");
		 	}
	}
	
	public ActionForward edition(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		 return mapping.findForward("edition");

	}

	//Action dédiée à un appel Ajax qui vérifie l'appartenance d'un DPG a un centre de frais
	 public ActionForward isMciObligatoire(ActionMapping mapping, ActionForm form,
			 HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc) throws Exception
	 {
		String signatureMethode = "isMciObligatoire(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors )";
		logBipUser.entry(signatureMethode);
		
		//String userid = ((UserBip)request.getSession().getAttribute("UserBip")).getInfosUser();
		String codsg = (String)request.getParameter("codsg");
	  
	  JdbcBip jdbc = new JdbcBip(); 
	  Vector vParamOut = new Vector();
	  String message = "";
	  ParametreProc paramOut;
	  Hashtable<String,String> lParamProc = new Hashtable<String,String>();
	  
	  lParamProc.put("codsg", codsg);
	  //lParamProc.put("userid", userid);  

	  // exécution de la procédure PL/SQL
		try {
		
			vParamOut = jdbc.getResult(
					lParamProc, configProc, PACK_ISMCIOBLIGATOIRE);
			// Récupération des résultats
			
			for (Enumeration e1 = vParamOut.elements(); e1.hasMoreElements();) {
				paramOut = (ParametreProc) e1.nextElement();
				
				if (paramOut.getNom().equals("mci_obligatoire")) {
					if (paramOut.getValeur() != null)
						message = (String) paramOut.getValeur();
				}
								
			}			
			
		}// try
		catch (BaseException be) {
			logBipUser.debug("PersonneAction-isMciObligatoire() --> BaseException :" + be);
			logBipUser.debug("PersonneAction-isMciObligatoire() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("PersonneAction-isMciObligatoire() --> BaseException :" + be);
			logService.debug("PersonneAction-isMciObligatoire() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((DatesEffetForm) form).setMsgErreur(message);
				 jdbc.closeJDBC();
//				 On écrit le message de retour du pl/sql dans la response
				  response.setContentType("text/html");
				  PrintWriter out = response.getWriter();
				  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
				  out.flush();
				  return PAS_DE_FORWARD;

			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC();
//				 On écrit le message de retour du pl/sql dans la response
				  response.setContentType("text/html");
				  PrintWriter out = response.getWriter();
				  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
				  out.flush();
				  return PAS_DE_FORWARD;
			}
		}

		 jdbc.closeJDBC();

	  // On écrit le message de retour du pl/sql dans la response
	  response.setContentType("text/html");
	  PrintWriter out = response.getWriter();
	  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
	  out.flush();

	  return PAS_DE_FORWARD;
	 }

		//Action dédiée à un appel Ajax qui recupere le MCI calcule.
	 public ActionForward getMciDefaut(ActionMapping mapping, ActionForm form,
			 HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc) throws Exception
	 {
		String signatureMethode = "getMciDefaut(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors )";
		logBipUser.entry(signatureMethode);
		
		String prestation = (String)request.getParameter("prestation");
		String cpident = (String)request.getParameter("cpident");
		String fident = (String)request.getParameter("fident");
		String datsitu = (String)request.getParameter("datsitu");
		String datdep = (String)request.getParameter("datdep");
    	
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		ParametreProc paramOut;
		Hashtable<String,String> lParamProc = new Hashtable<String,String>();
		
		lParamProc.put("prestation", prestation);
		lParamProc.put("fident", fident);
		lParamProc.put("cpident", cpident);	
		lParamProc.put("datsitu", datsitu);
		lParamProc.put("datdep", datdep);  

		String mci = "";
		String libmci = "";
		
	  // exécution de la procédure PL/SQL
		try {
		
			vParamOut = jdbc.getResult(
					lParamProc, configProc, PACK_GETMCIDEFAUT);
			// Récupération des résultats
			
			for (Enumeration e1 = vParamOut.elements(); e1.hasMoreElements();) {
				paramOut = (ParametreProc) e1.nextElement();
				
				if (paramOut.getNom().equals("modeContractuelInd")) {
					if (paramOut.getValeur() != null)
						mci = (String) paramOut.getValeur();
				}
				if (paramOut.getNom().equals("lib_mci")) {
					if (paramOut.getValeur() != null)
						libmci = (String) paramOut.getValeur();
				}
				
			}
			
			message = mci + ';' + libmci;
			
		}// try
		catch (BaseException be) {
			logBipUser.debug("PersonneAction-getMciDefaut() --> BaseException :" + be);
			logBipUser.debug("PersonneAction-getMciDefaut() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("PersonneAction-getMciDefaut() --> BaseException :" + be);
			logService.debug("PersonneAction-getMciDefaut() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((DatesEffetForm) form).setMsgErreur(message);
				 jdbc.closeJDBC();
//				 On écrit le message de retour du pl/sql dans la response
				  response.setContentType("text/html");
				  PrintWriter out = response.getWriter();
				  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
				  out.flush();
				  return PAS_DE_FORWARD;

			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC();
//				 On écrit le message de retour du pl/sql dans la response
				  response.setContentType("text/html");
				  PrintWriter out = response.getWriter();
				  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
				  out.flush();
				  return PAS_DE_FORWARD;
			}
		}

		 jdbc.closeJDBC();

	  // On écrit le message de retour du pl/sql dans la response
	  response.setContentType("text/html");
	  PrintWriter out = response.getWriter();
	  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
	  out.flush();

	  return PAS_DE_FORWARD;
	 }

	protected ActionForward annuler(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		logBipUser.debug("PersonneAction-annuler() ");
		
		return mapping.findForward("initial");
	}

	protected ActionForward pageIndex(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors) throws ServletException {
		PaginationVector page;
		String pageName;
		String index;
		HttpSession session = request.getSession(false);
		ActionForward actionForward = null;
		// Extraction du nom de la page
		pageName = (String) request.getParameter("page");
		// Extraction de l'index
		index = (String) request.getParameter("index");
		page = (PaginationVector) session.getAttribute(pageName);
		PersonneForm rechercheForm = (PersonneForm) form;
		if (page != null) {
			page.setBlock(Integer.parseInt(index));
			request.setAttribute("PersonneForm", rechercheForm);
			actionForward = mapping.findForward("suite1");
		} else {
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
					"error.page.noninitialisee"));
			this.saveErrors(request, errors);
			actionForward = mapping.findForward("error");
		}// else if

		 return actionForward;

	}// pageIndex

	/**
	 * Action envoyée pour passer à la page suivante
	 * 
	 * @param request
	 *            la requête HTTP.
	 * @param response
	 *            la réponse HTTP.
	 */
	protected ActionForward pageSuivante(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors)
			throws ServletException {
		PaginationVector page;
		String pageName;
		HttpSession session = request.getSession(false);

		// Extraction du nom de la page
		pageName = (String) request.getParameter("page");
		page = (PaginationVector) session.getAttribute(pageName);
		PersonneForm rechercheForm = (PersonneForm) form;
		if (page != null) {
			page.getNextBlock();
			request.setAttribute("PersonneForm", rechercheForm);
			 return mapping.findForward("suite1");

		} else {
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
					"error.page.noninitialisee"));
			this.saveErrors(request, errors);
			return mapping.findForward("error");
		}
	}

	/**
	 * Action envoyée pour passer à la page précédente
	 * 
	 * @param request
	 *            la requête HTTP.
	 * @param response
	 *            la réponse HTTP.
	 */
	protected ActionForward pagePrecedente(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors)
			throws ServletException {
		PaginationVector page;
		String pageName;
		// Extraction du nom de la page
		pageName = (String) request.getParameter("page");
		// Extraction de la liste à paginer
		page = (PaginationVector) request.getSession(false).getAttribute(
				pageName);
		PersonneForm rechercheForm = (PersonneForm) form;
		if (page != null) {
			page.getPreviousBlock();
			request.setAttribute("PersonneForm", rechercheForm);
			  return mapping.findForward("suite1");
		} else {
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
					"error.page.noninitialisee"));
			this.saveErrors(request, errors);
			 return mapping.findForward("error");
		}
	}
	
}
