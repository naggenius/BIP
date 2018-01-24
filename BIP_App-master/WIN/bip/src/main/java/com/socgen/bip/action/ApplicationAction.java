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

import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.ApplicationForm;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author N.BACCAM - 18/06/2003
 * 
 * Formulaire pour mise à jour des applications chemin :
 * Administration/Référentiels/Applications pages : fmApplicationAd.jsp et
 * mApplicationAd.jsp pl/sql : appli.sql
 */
public class ApplicationAction extends SocieteAction {

	private static String PACK_SELECT = "application.consulter.proc";

	private static String PACK_INSERT = "application.creer.proc";

	private static String PACK_UPDATE = "application.modifier.proc";

	private static String PACK_DELETE = "application.supprimer.proc";

	private String nomProc;

	
	/**
	 * Action qui permet de créer un code Application
	 */
	protected ActionForward creer(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;

		
		String signatureMethode = "ApplicationAction -creer( mapping, form , request,  response,  errors )";

		// logService.entry(signatureMethode);;
		logBipUser.entry(signatureMethode);
		// exécution de la procédure PL/SQL
		try {

			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT);
			try {
				message = jdbc.recupererResult(vParamOut, "creer");
				//on initilaise le lien NPSI à "Hors périmètre"
				((ApplicationForm) form).setBloc("ZZZZZ");
			} catch (BaseException be) {
				logBipUser
						.debug("ApplicationAction -creer() --> BaseException :"
								+ be);
				logBipUser.debug("ApplicationAction -creer() --> Exception :"
						+ be.getInitialException().getMessage());
				logService
						.debug("ApplicationAction -creer() --> BaseException :"
								+ be);
				logService.debug("ApplicationAction -creer() --> Exception :"
						+ be.getInitialException().getMessage());
				// Erreur de lecture du resultSet
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
			if (!message.equals("")) {
				// Entité déjà existante, on récupère le message
				((ApplicationForm) form).setMsgErreur(message);

				logBipUser.debug("message d'erreur:" + message);
				logBipUser.exit(signatureMethode);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}

		}// try
		catch (BaseException be) {
			logBipUser.debug("ApplicationAction-creer() --> BaseException :"
					+ be);
			logBipUser.debug("ApplicationAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("ApplicationAction-creer() --> BaseException :"
					+ be);
			logService.debug("ApplicationAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((ApplicationForm) form).setMsgErreur(message);
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

		// logService.exit(signatureMethode);
		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	}// creer

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
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = "ClientAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		ApplicationForm bipForm = (ApplicationForm) form;

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

							bipForm.setAirt(rset.getString(1));
							bipForm.setAmop(rset.getString(2));
							bipForm.setAmnemo(rset.getString(3));
							bipForm.setAgappli(rset.getString(4));
							bipForm.setAcme(rset.getString(5));
							bipForm.setAlibel(rset.getString(6));
							bipForm.setFlaglock(rset.getInt(7));
							bipForm.setClicode(rset.getString(8));
							bipForm.setCodsg(rset.getString(9));
							bipForm.setCodgappli(rset.getString(10));
							bipForm.setAcdareg(rset.getString(11));
							bipForm.setAlibcourt(rset.getString(12));
							// TD 532
							bipForm.setAlibme(rset.getString(13));
							bipForm.setAlibmo(rset.getString(14));
							bipForm.setAlibgappli(rset.getString(15));
							bipForm.setDatfinapp(rset.getString(16));
							bipForm.setLicodapca(rset.getString(17));
							bipForm.setCodcamo1(rset.getString(18));
							bipForm.setClibca1(rset.getString(19));
							bipForm.setCdfain1(rset.getString(20));
							bipForm.setDatvalli1(rset.getString(21));
							bipForm.setRespval1(rset.getString(22));
							bipForm.setCodcamo2(rset.getString(23));
							bipForm.setClibca2(rset.getString(24));
							bipForm.setCdfain2(rset.getString(25));
							bipForm.setDatvalli2(rset.getString(26));
							bipForm.setRespval2(rset.getString(27));
							bipForm.setCodcamo3(rset.getString(28));
							bipForm.setClibca3(rset.getString(29));
							bipForm.setCdfain3(rset.getString(30));
							bipForm.setDatvalli3(rset.getString(31));
							bipForm.setRespval3(rset.getString(32));
							bipForm.setCodcamo4(rset.getString(33));
							bipForm.setClibca4(rset.getString(34));
							bipForm.setCdfain4(rset.getString(35));
							bipForm.setDatvalli4(rset.getString(36));
							bipForm.setRespval4(rset.getString(37));
							bipForm.setCodcamo5(rset.getString(38));
							bipForm.setClibca5(rset.getString(39));
							bipForm.setCdfain5(rset.getString(40));
							bipForm.setDatvalli5(rset.getString(41));
							bipForm.setRespval5(rset.getString(42));	
							bipForm.setCodcamo6(rset.getString(43));
							bipForm.setClibca6(rset.getString(44));
							bipForm.setCdfain6(rset.getString(45));
							bipForm.setDatvalli6(rset.getString(46));
							bipForm.setRespval6(rset.getString(47));
							bipForm.setCodcamo7(rset.getString(48));
							bipForm.setClibca7(rset.getString(49));
							bipForm.setCdfain7(rset.getString(50));
							bipForm.setDatvalli7(rset.getString(51));
							bipForm.setRespval7(rset.getString(52));
							bipForm.setCodcamo8(rset.getString(53));
							bipForm.setClibca8(rset.getString(54));
							bipForm.setCdfain8(rset.getString(55));
							bipForm.setDatvalli8(rset.getString(56));
							bipForm.setRespval8(rset.getString(57));
							bipForm.setCodcamo9(rset.getString(58));
							bipForm.setClibca9(rset.getString(59));
							bipForm.setCdfain9(rset.getString(60));
							bipForm.setDatvalli9(rset.getString(61));
							bipForm.setRespval9(rset.getString(62));
							bipForm.setCodcamo10(rset.getString(63));
							bipForm.setClibca10(rset.getString(64));
							bipForm.setCdfain10(rset.getString(65));
							bipForm.setDatvalli10(rset.getString(66));
							bipForm.setRespval10(rset.getString(67));
							bipForm.setTypactca1(rset.getString(68));
							bipForm.setTypactca2(rset.getString(69));
							bipForm.setTypactca3(rset.getString(70));
							bipForm.setTypactca4(rset.getString(71));
							bipForm.setTypactca5(rset.getString(72));
							bipForm.setTypactca6(rset.getString(73));
							bipForm.setTypactca7(rset.getString(74));
							bipForm.setTypactca8(rset.getString(75));
							bipForm.setTypactca9(rset.getString(76));
							bipForm.setTypactca10(rset.getString(77));
							bipForm.setBloc(rset.getString(78));
							bipForm.setLib_bloc(rset.getString(79));
							bipForm.setAdescr(rset.getString(80));
							bipForm.setMsgErreur(null);
						} else
							msg = true;

					}// try
					catch (SQLException sqle) {
						logService
								.debug("ApplicationAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("ApplicationAction-consulter() --> SQLException :"
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
									.debug("ApplicationAction-consulter() --> SQLException :"
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
				// le code Application n'existe pas, on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		}// try
		catch (BaseException be) {
			logBipUser.debug(
					"ApplicationAction-consulter() --> BaseException :" + be,
					be);
			logBipUser.debug("ApplicationAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug(
					"ApplicationAction-consulter() --> BaseException :" + be,
					be);
			logService.debug("ApplicationAction-consulter() --> Exception :"
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

}
