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
import com.socgen.bip.form.BudgetCopiForm;
import com.socgen.bip.form.PersonneForm;
import com.socgen.bip.form.SocieteForm;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author N.BACCAM - 28/05/2003
 * 
 * Action de mise à jour des sociétée chemin : Administration/Tables/ mise à
 * jour/Societe pages : bSocieteAd.jsp et mSocieteAd.jsp pl/sql : societe.sql
 */
public class SocieteAction extends AutomateAction {

	private static String PACK_SELECT = "societe.consulter.proc";

	private static String PACK_INSERT = "societe.creer.proc";

	private static String PACK_UPDATE = "societe.modifier.proc";

	private static String PACK_DELETE = "societe.supprimer.proc";
	
	private static String GET_LIB_SOCCODE = "personne.recup.soccode";

	private String nomProc;
	
	

	/**
	 * Action qui permet de créer un code societe
	 */
	protected ActionForward creer(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;

		String signatureMethode = "SocieteAction -creer( mapping, form , request,  response,  errors )";

		// logService.entry(signatureMethode);;
		logBipUser.entry(signatureMethode);
		// exécution de la procédure PL/SQL
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT);
			try {
				message = jdbc.recupererResult(vParamOut, "creer");
				// récupérer la date de création
				for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
					ParametreProc paramOut = (ParametreProc) e.nextElement();
					if (paramOut.getNom().equals("datcre")) {
						String sDateCreation = (String) paramOut.getValeur();
						logService.debug("Date de création :" + sDateCreation);
						((SocieteForm) form).setSoccre(sDateCreation);
					}// if

				}// for

			} catch (BaseException be) {
				logBipUser.debug("SocieteAction -creer() --> BaseException :"
						+ be);
				logBipUser.debug("SocieteAction -creer() --> Exception :"
						+ be.getInitialException().getMessage());
				logService.debug("SocieteAction -creer() --> BaseException :"
						+ be);
				logService.debug("SocieteAction -creer() --> Exception :"
						+ be.getInitialException().getMessage());
				// Erreur de lecture du resultSet
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
			if (!message.equals("")) {
				// Entité déjà existante, on récupère le message
				((SocieteForm) form).setMsgErreur(message);
				logBipUser.debug("message d'erreur:" + message);
				logBipUser.exit(signatureMethode);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}

		}// try
		catch (BaseException be) {
			logBipUser.debug("SocieteAction-creer() --> BaseException :" + be);
			logBipUser.debug("SocieteAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("SocieteAction-creer() --> BaseException :" + be);
			logService.debug("SocieteAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			// Erreur d''exécution de la procédure stockée
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
			// this.saveErrors(request,errors);
			 jdbc.closeJDBC(); return mapping.findForward("error");
		}

		// logService.exit(signatureMethode);
		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	}// creer

	/**
	 * Action qui permet de visualiser les données liées à un code Societe pour
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

		String signatureMethode = "SocieteAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		SocieteForm bipForm = (SocieteForm) form;

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
				// récupérer la date de création
				if (paramOut.getNom().equals("datcre")) {
					String sDateCreation = (String) paramOut.getValeur();
					logService.debug("Date de création :" + sDateCreation);
					((SocieteForm) form).setSoccre(sDateCreation);
				}// if

				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();

					try {
						logService.debug("ResultSet");
						if (rset.next()) {

							bipForm.setSoccode(rset.getString(1));
							bipForm.setSocgrpe(rset.getString(2));
							bipForm.setSoclib(rset.getString(3));
							bipForm.setSocnat(rset.getString(4));
							bipForm.setSoccat(rset.getString(5));
							bipForm.setSoccre(rset.getString(6));
							bipForm.setSocfer_ch(rset.getString(7));
							bipForm.setSocnou(rset.getString(8));
							bipForm.setSoccop(rset.getString(9));
							bipForm.setSocfer_cl(rset.getString(10));
							bipForm.setSoccom(rset.getString(11));
							bipForm.setFlaglock(rset.getInt(12));
							bipForm.setSiren(rset.getString(13));
							bipForm.setMsgErreur(null);
							if (rset.getString(8) != null)
								hParamProc.put("socnou", bipForm.getSocnou());
							if ((rset.getString(7) == null) && (rset.getString(8) == null))
								bipForm.setToppresence("N");
							else
								bipForm.setToppresence("O");
								
									
						} else
							msg = true;

					}// try
					catch (SQLException sqle) {
						logService
								.debug("SocieteAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("SocieteAction-consulter() --> SQLException :"
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
									.debug("SocieteAction-consulter() --> SQLException-rset.close() :"
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
				// le code Societe n'existe pas, on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		}// try
		catch (BaseException be) {
			logBipUser.debug("SocieteAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("SocieteAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("SocieteAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("SocieteAction-consulter() --> Exception :"
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
		return cle;
	}

	protected ActionForward suite(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = "SocieteAction-suite(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		SocieteForm bipForm = (SocieteForm) form;

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

					try {
						logService.debug("ResultSet");
						if (rset.next()) {

							bipForm.setSoccode(rset.getString(1));
							bipForm.setSiren(rset.getString(13));
							bipForm.setMsgErreur(null);
						} else
							msg = true;
						if (rset != null)
							rset.close();
					}// try
					catch (SQLException sqle) {
						logService
								.debug("SocieteAction-suite() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("SocieteAction-suite() --> SQLException :"
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
				// le code Societe n'existe pas, on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		}// try
		catch (BaseException be) {
			logBipUser.debug("SocieteAction-suite() --> BaseException :" + be,
					be);
			logBipUser.debug("SocieteAction-suite() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("SocieteAction-suite() --> BaseException :" + be,
					be);
			logService.debug("SocieteAction-suite() --> Exception :"
					+ be.getInitialException().getMessage());
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));

			// this.saveErrors(request,errors);
			 jdbc.closeJDBC(); return mapping.findForward("error");
		}

		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("suite");
	}

	protected ActionForward suite1(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = "SocieteAction-suiteebis(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		SocieteForm bipForm = (SocieteForm) form;

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

					try {
						logService.debug("ResultSet");
						if (rset.next()) {

							bipForm.setSoccode(rset.getString(1));
							bipForm.setSiren(rset.getString(13));
							bipForm.setMsgErreur(null);
						} else
							msg = true;
						if (rset != null)
							rset.close();
					}// try
					catch (SQLException sqle) {
						logService
								.debug("SocieteAction-suiteebis() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("SocieteAction-suiteebis() --> SQLException :"
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
				// le code Societe n'existe pas, on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		}// try
		catch (BaseException be) {
			logBipUser.debug("SocieteAction-suiteebis() --> BaseException :" + be,
					be);
			logBipUser.debug("SocieteAction-suiteebis() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("SocieteAction-suiteebis() --> BaseException :" + be,
					be);
			logService.debug("SocieteAction-suiteebis() --> Exception :"
					+ be.getInitialException().getMessage());
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));

			// this.saveErrors(request,errors);
			 jdbc.closeJDBC(); return mapping.findForward("error");
		}

		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("suite1");
	}

	protected ActionForward refresh(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		SocieteForm bipForm = (SocieteForm) form;

		Vector vParamOut = new Vector();

		try {
				vParamOut = jdbc.getResult(
						hParamProc, configProc, GET_LIB_SOCCODE);
				bipForm.setLib_soccode((String) ((ParametreProc) vParamOut
						.elementAt(0)).getValeur());
				bipForm.setMsgErreur((String) ((ParametreProc) vParamOut
						.elementAt(1)).getValeur());
				
				// MAJ du Focus
				if (bipForm.getMsgErreur() == null)
					bipForm.setFocus("soccode");

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
				
		 if (bipForm.getAction() == "creer") { 
		  return mapping.findForward("ecran");
		 }
		 else
		 	{
			 return mapping.findForward("initial");
		 	}
	}
	
	
	protected  ActionForward initialiser(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors ,Hashtable hParamProc ) throws ServletException
	{
		
		  String signatureMethode =
				"suite(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors )";
			logBipUser.entry(signatureMethode);
			logBipUser.entry(signatureMethode);
		logBipUser.debug("methode initialiser societe action");
		
		
		
		return mapping.findForward("ecran") ;
	}
	
}
