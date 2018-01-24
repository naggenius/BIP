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
import com.socgen.bip.form.LigneBipMoForm;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author NBM - 18/08/2003
 * 
 * Action pour creation ou modification d'une ligne bip : menus CDG client et
 * Saisie Client pages : bFermeLigneAl.jsp, mFermeLigneAl.jsp chemin : ligne
 * bip/fermeture pl/sql : ferme_ligne.sql
 */

public class FermeLigneAction extends AutomateAction {

	private static String PACK_SELECT = "fermeLigne.consulter.proc";

	private static String PACK_UPDATE = "fermeLigne.modifier.proc";

	private String nomProc;
	
	

	/**
	 * Action qui permet de visualiser les données liées à un code BIP pour la
	 * modification
	 */
	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParams) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = "FermeLigneAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		LigneBipMoForm bipForm = (LigneBipMoForm) form;

		boolean bRecupDate = false;

		// exécution de la procédure PL/SQL
		try {
			vParamOut = jdbc.getResult(hParams,
					configProc, PACK_SELECT);

			// Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				// récupérer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();
				}

				// on récupère la date proposée
				if (bipForm.getRecupDate().equals("OUI")) {
					if (paramOut.getNom().equals("lastDateConso")) {
						bipForm.setAdatestatut((String) paramOut.getValeur());
						bipForm.setRecupDate("NON");
						bipForm.setFocus("adatestatut");
						bRecupDate = true;
					}
				}

				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();

					try {
						logService.debug("ResultSet");
						if (rset.next()) {
							bipForm.setPid(rset.getString(1));
							bipForm.setCodcamo(rset.getString(2));
							bipForm.setTypproj(rset.getString(3));
							bipForm.setArctype(rset.getString(4));
							bipForm.setToptri(rset.getString(5));
							bipForm.setIcpi(rset.getString(6));
							bipForm.setIlibel(rset.getString(7));
							bipForm.setAirt(rset.getString(8));
							bipForm.setAlibel(rset.getString(9));
							bipForm.setDpcode(rset.getString(10));
							bipForm.setDplib(rset.getString(11));
							bipForm.setCodpspe(rset.getString(12));
							bipForm.setLibpspe(rset.getString(13));
							bipForm.setCodsg(rset.getString(14));
							bipForm.setLibdsg(rset.getString(15));
							bipForm.setRnom(rset.getString(16));
							bipForm.setMetier(rset.getString(17));
							bipForm.setPnom(rset.getString(18));
							bipForm.setPnmouvra(rset.getString(19));
							bipForm.setClicode(rset.getString(20));
							bipForm.setClilib(rset.getString(21));
							bipForm.setPobjet(rset.getString(22));
							bipForm.setAnnee(rset.getString(23));
							bipForm.setBnmont(rset.getString(24));
							bipForm.setBpmontme(rset.getString(25));
							bipForm.setAnmont(rset.getString(26));
							bipForm.setReestime(rset.getString(27));
							bipForm.setEstimplurian(rset.getString(28));
							bipForm.setCusag(rset.getString(29));
							bipForm.setBpmontmo(rset.getString(30));
							bipForm.setFlaglock(rset.getInt(31));

							bipForm.setMsgErreur(null);
						} else
							msg = true;

					} // try
					catch (SQLException sqle) {
						logService
								.debug("FermeLigneAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("FermeLigneAction-consulter() --> SQLException :"
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
									.debug("FermeLigneAction-consulter() --> SQLException-rset.close() :"
											+ sqle);
							// Erreur de lecture du resultSet
							errors.add(ActionErrors.GLOBAL_ERROR,
									new ActionError("11217"));
							 jdbc.closeJDBC(); return mapping.findForward("error");
						}

					}
				} // if
			} // for
			if (msg) {
				// le code Personne n'existe pas, on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		} // try
		catch (BaseException be) {
			logBipUser.debug("FermeLigneAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("FermeLigneAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("FermeLigneAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("FermeLigneAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((LigneBipMoForm) form).setMsgErreur(message);
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

		if (bRecupDate) {
			 jdbc.closeJDBC(); return mapping.findForward("initial");
		} else {
			 jdbc.closeJDBC(); return mapping.findForward("ecran");
		}

	} // consulter

	protected String recupererCle(String mode) {
		String cle = null;
		if (mode.equals("update")) {
			cle = PACK_UPDATE;
		}
		  return cle;
	}

	/**
	 * Action qui permet de revenir sur la saisie du PID
	 */
	protected ActionForward annuler(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParams) throws ServletException {

		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = this.getClass().getName()
				+ "-annuler(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);

		LigneBipMoForm bipForm = (LigneBipMoForm) form;

		bipForm.setRecupDate("OUI");
		bipForm.setFocus("pid");
		bipForm.setAction("");

		logBipUser.exit(signatureMethode);

		  return mapping.findForward("initial");

	} // annuler
}
