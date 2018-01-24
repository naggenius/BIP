package com.socgen.bip.action;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Enumeration;
import java.util.GregorianCalendar;
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
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.ConsultPerimsRestitForm;
import com.socgen.bip.metier.ConsultPerimsRestit;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.ich.ihm.menu.PaginationVector;

public class ConsultPerimsRestitAction extends AutomateAction implements BipConstantes {

	//"logsBip.consulter.proc"
	private static String PACK_SELECT = "perimsrestit.consulter.proc";
		
	protected ActionForward suite(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		Vector vListe = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;
		//int compteur = 0;
		//int linesPerPage = 100;
		GregorianCalendar cal = new java.util.GregorianCalendar(); 
		SimpleDateFormat  dateFormat = new SimpleDateFormat("dd/MM/yyyy");
		String signatureMethode = "ConsultPerimsRestitActionn-suite(paramProc, mapping, form , request,  response,  errors )";
		
		logBipUser.entry(signatureMethode);
		
		// Création d'une nouvelle form
		ConsultPerimsRestitForm bipForm = (ConsultPerimsRestitForm) form;
		cal.add(cal.DATE, 0 );
		hParamProc.put("datedeb", dateFormat.format(cal.getTime()));
		bipForm.setDatedeb(dateFormat.format(cal.getTime()));
	
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
						while (rset.next()) {

						vListe.add( new ConsultPerimsRestit (rset.getString(1),
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
														   rset.getString(14),
														   rset.getString(15),
														   rset.getString(16),
														   rset.getString(17),
														   rset.getString(18),
														   rset.getString(19)));
						//bipForm.setMsgErreur(null);
						//bipForm.setMsgErreur(message);
						
						}
						PaginationVector vueListe = new  PaginationVector(vListe);								  
						request.setAttribute(LISTE_RECHERCHE_ID, vueListe); 
						(request.getSession(false)).setAttribute(LISTE_RECHERCHE_ID, vueListe );								  
						bipForm.setListePourPagination(vueListe);

					}// try
					catch (SQLException sqle) {
						logService
								.debug("ConsultPerimsRestitActionn-suite() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("ConsultPerimsRestitActionn-suite() --> SQLException :"
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
									.debug("ConsultPerimsRestitActionn-suite()  --> SQLException-rset.close() :"
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
				 //bipForm.setMsgErreur(message);
				 // on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("ecran");
			}
		}// try
		catch (BaseException be) {
			logBipUser.debug("ConsultPerimsRestitActionn-suite() --> BaseException :" + be,
					be);
			logBipUser.debug("ConsultPerimsRestitActionn-suite() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("ConsultPerimsRestitActionn-suite() --> BaseException :" + be,
					be);
			logService.debug("ConsultPerimsRestitActionn-suite() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((ConsultPerimsRestitForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("ecran");

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
		return mapping.findForward("ecran");
	}
		
	protected ActionForward refresh(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		Vector vListe = new Vector();
		String message = "";
		ParametreProc paramOut;
		//int compteur = 0;
		//int linesPerPage = 30;
		String signatureMethode = "ConsultPerimsRestitAction-consulter(paramProc, mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);
		
		// Création d'une nouvelle form
		ConsultPerimsRestitForm bipForm = (ConsultPerimsRestitForm) form;
		
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
						while (rset.next()) {

							vListe.add( new ConsultPerimsRestit (rset.getString(1),
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
									   rset.getString(14),
									   rset.getString(15),
									   rset.getString(16),
									   rset.getString(17),
									   rset.getString(18),
									   rset.getString(19)));
						//bipForm.setMsgErreur(null);
						
						}
						
						PaginationVector vueListe = new  PaginationVector(vListe);								  
						request.setAttribute(LISTE_RECHERCHE_ID, vueListe); 
						(request.getSession(false)).setAttribute(LISTE_RECHERCHE_ID, vueListe );								  
						bipForm.setListePourPagination(vueListe);

					}// try
					catch (SQLException sqle) {
						logService
								.debug("ConsultPerimsRestitAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("ConsultPerimsRestitAction-consulter() --> SQLException :"
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
									.debug("ConsultPerimsRestitAction-consulter()  --> SQLException-rset.close() :"
											+ sqle);
							// Erreur de lecture du resultSet
							errors.add(ActionErrors.GLOBAL_ERROR,
									new ActionError("11217"));
							 jdbc.closeJDBC(); return mapping.findForward("error");
						}

					}
				}// if
			}// for
			if (message != null) {
				// bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("ecran");
			}
		}// try
		catch (BaseException be) {
			logBipUser.debug("ConsultPerimsRestitAction-consulter() --> BaseException :" + be,
					be);
			logBipUser.debug("ConsultPerimsRestitAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("ConsultPerimsRestitAction-consulter() --> BaseException :" + be,
					be);
			logService.debug("ConsultPerimsRestitAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((ConsultPerimsRestitForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("ecran");

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
		return mapping.findForward("ecran");
		
	}
	
}
