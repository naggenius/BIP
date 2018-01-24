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
import com.socgen.bip.form.ConsultLogsBipForm;
import com.socgen.bip.metier.ConsultLogsBip;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.ich.ihm.menu.PaginationVector;

public class ConsultLogsBipAction extends AutomateAction implements BipConstantes {

	private static String PACK_SELECT = "logsBip.consulter.proc";
		
	protected ActionForward suite(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		Vector vListe = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;
		int compteur = 0;
		int linesPerPage = 30;
		GregorianCalendar cal = new java.util.GregorianCalendar(); 
		SimpleDateFormat  dateFormat = new SimpleDateFormat("dd/MM/yyyy");
		
		String signatureMethode = "ConsultLogsBipActionn-suite(paramProc, mapping, form , request,  response,  errors )";
		
		logBipUser.entry(signatureMethode);
		
		// Création d'une nouvelle form
		ConsultLogsBipForm bipForm = (ConsultLogsBipForm) form;
		
		try {
			
			cal.add(cal.DATE, -1 );
			hParamProc.put("datedeb", dateFormat.format(cal.getTime()));
			bipForm.setDatedeb(dateFormat.format(cal.getTime()));
			cal.add(cal.DATE, 1 );
			hParamProc.put("datefin", dateFormat.format(cal.getTime()));
			bipForm.setDatefin(dateFormat.format(cal.getTime()));
						
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

						vListe.add( new ConsultLogsBip (rset.getString(1),
														   rset.getString(2),
														   rset.getString(3),
														   rset.getString(4),
														   rset.getString(5),
														   rset.getString(6),
														   rset.getInt(7),
														   rset.getInt(8),
														   rset.getString(9)));
							bipForm.setMsgErreur(null);
						
						compteur ++;	
						}
					
						PaginationVector vueListe = new  PaginationVector(vListe,linesPerPage);								  
						request.setAttribute(LISTE_RECHERCHE_ID, vueListe); 
						(request.getSession(false)).setAttribute(LISTE_RECHERCHE_ID, vueListe );								  
						bipForm.setListePourPagination(vueListe);

					}// try
					catch (SQLException sqle) {
						logService
								.debug("ConsultLogsBipActionn-suite() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("ConsultLogsBipActionn-suite() --> SQLException :"
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
									.debug("ConsultLogsBipActionn-suite()  --> SQLException-rset.close() :"
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
				// bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("ecran");
			}
		}// try
		catch (BaseException be) {
			logBipUser.debug("ConsultLogsBipActionn-suite() --> BaseException :" + be,
					be);
			logBipUser.debug("ConsultLogsBipActionn-suite() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("ConsultLogsBipActionn-suite() --> BaseException :" + be,
					be);
			logService.debug("ConsultLogsBipActionn-suite() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((ConsultLogsBipForm) form).setMsgErreur(message);
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
		return mapping.findForward("ecran");
		
	}
		
	protected ActionForward refresh(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		Vector vListe = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;
		int compteur = 0;
		int linesPerPage = 30;
				
		String signatureMethode = "ConsultLogsBipAction-consulter(paramProc, mapping, form , request,  response,  errors )";
		
		logBipUser.entry(signatureMethode);
		
		// Création d'une nouvelle form
		ConsultLogsBipForm bipForm = (ConsultLogsBipForm) form;
		
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

						vListe.add( new ConsultLogsBip (rset.getString(1),
														   rset.getString(2),
														   rset.getString(3),
														   rset.getString(4),
														   rset.getString(5),
														   rset.getString(6),
														   rset.getInt(7),
														   rset.getInt(8),
														   rset.getString(9)));
							bipForm.setMsgErreur(null);
						
						compteur ++;	
						}
					
						PaginationVector vueListe = new  PaginationVector(vListe,linesPerPage);								  
						request.setAttribute(LISTE_RECHERCHE_ID, vueListe); 
						(request.getSession(false)).setAttribute(LISTE_RECHERCHE_ID, vueListe );								  
						bipForm.setListePourPagination(vueListe);

					}// try
					catch (SQLException sqle) {
						logService
								.debug("ConsultLogsBipAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("ConsultLogsBipAction-consulter() --> SQLException :"
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
									.debug("ConsultLogsBipAction-consulter()  --> SQLException-rset.close() :"
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
				// bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("ecran");
			}
		}// try
		catch (BaseException be) {
			logBipUser.debug("ConsultLogsBipAction-consulter() --> BaseException :" + be,
					be);
			logBipUser.debug("ConsultLogsBipAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("ConsultLogsBipAction-consulter() --> BaseException :" + be,
					be);
			logService.debug("ConsultLogsBipAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((ConsultLogsBipForm) form).setMsgErreur(message);
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
		return mapping.findForward("ecran");
		
	}
	
}
