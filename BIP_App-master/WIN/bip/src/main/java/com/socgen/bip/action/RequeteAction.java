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
import com.socgen.bip.form.RequeteForm;
import com.socgen.bip.metier.Requete;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.ich.ihm.menu.PaginationVector;

public class RequeteAction extends AutomateAction implements BipConstantes {

	private static String PACK_SELECT = "contrat.lister.proc.perim";
		
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
		
		//QC 1623 (PPM 50441)
		//String perim = request.getParameter("perim");
		//if(perim!=null && "true".equals(perim))
			//PACK_SELECT = "contrat.lister.proc.perim";
		//else
			//PACK_SELECT = "contrat.lister.proc";
		//QC 1623 (PPM 50441)
		
		String signatureMethode = "RequeteActionn-suite(paramProc, mapping, form , request,  response,  errors )";
		
		logBipUser.entry(signatureMethode);
		// Cr�ation d'une nouvelle form
		RequeteForm bipForm = (RequeteForm) form;
		hParamProc.put("liste_centre_frais", userBip.getListe_Centres_Frais());
		try {
			
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT);
			
			

			// R�cup�ration des r�sultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				// r�cup�rer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();

				}

				if (paramOut.getNom().equals("curseur")) {		
						
					// R�cup�ration du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();

					try {
						logService.debug("ResultSet");
						while (rset.next()) {

						vListe.add( new Requete (rset.getString(1),
														   rset.getString(2),
														   rset.getString(3),
														   rset.getString(4),
														   rset.getString(5),
														   rset.getString(6),
														   rset.getString(7),
														   rset.getString(8),
														   rset.getString(9),
														   rset.getString(10),
														   rset.getString(11)));
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
								.debug("RequeteActionn-suite() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("RequeteActionn-suite() --> SQLException :"
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
									.debug("RequeteActionn-suite()  --> SQLException-rset.close() :"
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
				// on reste sur la m�me page
				 jdbc.closeJDBC(); return mapping.findForward("ecran");
			}
		}// try
		catch (BaseException be) {
			logBipUser.debug("RequeteActionn-suite() --> BaseException :" + be,
					be);
			logBipUser.debug("RequeteActionn-suite() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("RequeteActionn-suite() --> BaseException :" + be,
					be);
			logService.debug("RequeteActionn-suite() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((RequeteForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("ecran");

			} else {
				// Erreur d''ex�cution de la proc�dure stock�e
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
		//QC 1623 (PPM 50441)
		//String perim = request.getParameter("perim");
		//if(perim!=null && "true".equals(perim))
			//PACK_SELECT = "contrat.lister.proc.perim";
		//else
			//PACK_SELECT = "contrat.lister.proc";
		//QC 1623 (PPM 50441)
		
		String signatureMethode = "RequeteAction-consulter(paramProc, mapping, form , request,  response,  errors )";
		
		logBipUser.entry(signatureMethode);
		// Cr�ation d'une nouvelle form
		RequeteForm bipForm = (RequeteForm) form;
		hParamProc.put("liste_centre_frais", userBip.getListe_Centres_Frais());
		try {
			
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT);
			
			

			// R�cup�ration des r�sultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				// r�cup�rer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();

				}

				if (paramOut.getNom().equals("curseur")) {		
						
					// R�cup�ration du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();

					try {
						logService.debug("ResultSet");
						while (rset.next()) {

						vListe.add( new Requete (rset.getString(1),
														   rset.getString(2),
														   rset.getString(3),
														   rset.getString(4),
														   rset.getString(5),
														   rset.getString(6),
														   rset.getString(7),
														   rset.getString(8),
														   rset.getString(9),
														   rset.getString(10),
														   rset.getString(11)));
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
								.debug("RequeteAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("RequeteAction-consulter() --> SQLException :"
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
									.debug("RequeteAction-consulter()  --> SQLException-rset.close() :"
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
				// on reste sur la m�me page
				 jdbc.closeJDBC(); return mapping.findForward("ecran");
			}
		}// try
		catch (BaseException be) {
			logBipUser.debug("RequeteAction-consulter() --> BaseException :" + be,
					be);
			logBipUser.debug("RequeteAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("RequeteAction-consulter() --> BaseException :" + be,
					be);
			logService.debug("RequeteAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((RequeteForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("ecran");

			} else {
				// Erreur d''ex�cution de la proc�dure stock�e
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
