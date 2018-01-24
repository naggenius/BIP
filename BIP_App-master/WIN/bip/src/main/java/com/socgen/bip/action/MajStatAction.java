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
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.MajStatForm;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author MMC - 09/07/2003
 * 
 * Action de mise à jour des statuts chemin : Administration/Immobilisation/MAJ
 * Statut pages : fMajstatAd.jsp et mMajstatAd.jsp pl/sql : amortst.sql
 */
public class MajStatAction extends AutomateAction {

	private static String PACK_SELECT = "majStat.consulter.proc";

	private static String PACK_UPDATE = "majStat.modifier.proc";

	private static String PACK_CONFIRM = "majStat.confirm.proc";

	private String nomProc;
	

	/**
	 * Action qui permet de visualiser les données
	 */
	protected ActionForward suite(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = "MajStatAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		MajStatForm bipForm = (MajStatForm) form;

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
				//
				if (paramOut.getNom().equals("date")) {
					String sDate = (String) paramOut.getValeur();
					logService.debug("Date :" + sDate);
					((MajStatForm) form).setDate(sDate);
				}// if
				//
				if (paramOut.getNom().equals("filsigle")) {
					String sFilsigle = (String) paramOut.getValeur();
					logService.debug("filsigle :" + sFilsigle);
					((MajStatForm) form).setFilsigle(sFilsigle);
				}// if

				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();

					try {
						logService.debug("ResultSet");
						if (rset.next()) {
							bipForm.setPid(rset.getString(1));
							bipForm.setPnom(rset.getString(2));
							bipForm.setTypproj(rset.getString(3));

							// Gestion du statut : si null
							// Alors "" pour que le bon item soit sélectionné
							// dans la liste
							String statut = rset.getString(4);
							if (statut == null)
								statut = "";
							bipForm.setAstatut(statut);
							bipForm.setTopfer(rset.getString(5));
							bipForm.setAdatestatut(rset.getString(6));
							bipForm.setFlaglock(rset.getInt(7));
							bipForm.setDate_demande(rset.getString(8));
							bipForm.setDemandeur(rset.getString(9));
							bipForm.setCommentaire(rset.getString(10));
							bipForm.setDpcode(rset.getString(11));
							bipForm.setDplib(rset.getString(12));
							bipForm.setDatimmo(rset.getString(13));
							bipForm.setActif(rset.getString(14));
							bipForm.setIcpi(rset.getString(15));
							bipForm.setIlibel(rset.getString(16));
							bipForm.setLibstatut(rset.getString(17));
							bipForm.setDatstatut(rset.getString(18));

							bipForm.setMsgErreur(null);
						} else
							msg = true;

					}// try
					catch (SQLException sqle) {
						logService
								.debug("MajStatAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("MajStatAction-consulter() --> SQLException :"
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
									.debug("MajStatAction-consulter() --> SQLException-rset.close() :"
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
				// on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}

		}// try
		catch (BaseException be) {
			logBipUser.debug("MajStatAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("MajStatAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("MajStatAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("MajStatAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((MajStatForm) form).setMsgErreur(message);
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

		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	}

	protected String recupererCle(String mode) {
		String cle = null;
		if (mode.equals("confirm")) {
			cle = PACK_CONFIRM;
		} else if (mode.equals("update")) {
			cle = PACK_UPDATE;
		}

		  return cle;
	}

}
