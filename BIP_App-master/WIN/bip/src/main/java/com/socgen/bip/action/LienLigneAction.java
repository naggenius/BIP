package com.socgen.bip.action;

import java.lang.reflect.InvocationTargetException;
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
import com.socgen.bip.form.LienLigneForm;
import com.socgen.cap.fwk.ServiceManager;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.cap.fwk.jdbc.JDBCWrapper;

/**
 * @author N.BACCAM - 21/07/2003
 * 
 * Action de mise à jour des liens Ligne BIP chemin : Administration/Ligne Bip/
 * Liens pages : fLiendpAd.jsp, mLiendpAd.jsp, bLiendpAd.jsp fLiendpgAd.jsp,
 * mLiendpgAd.jsp, bLiendpAd.jsp fLienmoAd.jsp, mLienmoAd.jsp, bLienmoAd.jsp
 * fLiencamoAd.jsp, mLiencamoAd.jsp, bLiencamoAd.jsp fLienprojetAd.jsp,
 * mLienprojetAd.jsp, bLienprojetAd.jsp fLienappliAd.jsp, mLienappliAd.jsp,
 * bLienappliAd.jsp fLiencpAd.jsp, mLiencpAd.jsp, bLiencpAd.jsp pl/sql :
 * dos_proj.sql, rtbipinf.sql,rtprjinf.sql, pcprjinf.sql
 */

public class LienLigneAction extends AutomateAction {

	private static String PACK_SELECT_DP = "lienDp.consulter.proc";

	private static String PACK_SELECT_DPG = "lienDpg.consulter.proc";

	private static String PACK_SELECT_MO = "lienMo.consulter.proc";

	private static String PACK_SELECT_CAMO = "lienCamo.consulter.proc";

	private static String PACK_SELECT_PROJET = "lienProjet.consulter.proc";

	private static String PACK_SELECT_APPLI = "lienAppli.consulter.proc";

	private static String PACK_SELECT_CP = "lienCp.consulter.proc";

	private static String PACK_UPDATE_DP = "lienDp.modifier.proc";

	private static String PACK_UPDATE_DPG = "lienDpg.modifier.proc";

	private static String PACK_UPDATE_MO = "lienMo.modifier.proc";

	private static String PACK_UPDATE_CAMO = "lienCamo.modifier.proc";

	private static String PACK_UPDATE_PROJET = "lienProjet.modifier.proc";

	private static String PACK_UPDATE_APPLI = "lienAppli.modifier.proc";

	private static String PACK_UPDATE_CP = "lienCp.modifier.proc";

	private String nomProc;
	
	JdbcBip jdbc = new JdbcBip(); 

	/**
	 * Action qui permet de visualiser les données du filtre : code DP et son
	 * libellé => page mLienDpAd.jsp code DPG et son libellé => page
	 * mLienDpgAd.jsp code Mo et son libellé => page mLienMoAd.jsp code CP et
	 * son libellé => page mLienCpAd.jsp
	 * 
	 */
	protected ActionForward suite(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;
		String sPack = "";
		String sTable = "";

		String signatureMethode = "LienProjAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		LienLigneForm bipForm = (LienLigneForm) form;

		sTable = bipForm.getTable();

		if (sTable.equals("DP")) {
			sPack = PACK_SELECT_DP;
		} else if (sTable.equals("DPG")) {
			sPack = PACK_SELECT_DPG;
		} else if (sTable.equals("MO")) {
			sPack = PACK_SELECT_MO;
		} else if (sTable.equals("CAMO")) {
			sPack = PACK_SELECT_CAMO;
		} else if (sTable.equals("PRJ")) {
			sPack = PACK_SELECT_PROJET;
		} else if (sTable.equals("APP")) {
			sPack = PACK_SELECT_APPLI;
		} else if (sTable.equals("CP")) {
			sPack = PACK_SELECT_CP;
		}

		// exécution de la procédure PL/SQL
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, sPack);

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
							if (sTable.equals("DP")) {
								bipForm.setDpcode(rset.getString(1));
								bipForm.setDplib(rset.getString(2));
							} else if (sTable.equals("DPG")) {
								bipForm.setCodsg(rset.getString(1));
								bipForm.setLibdsg(rset.getString(4));
							} else if (sTable.equals("MO")) {
								bipForm.setClicode(rset.getString(1));
								bipForm.setClilib(rset.getString(3)); // TD 584
							} else if (sTable.equals("CAMO")) {
								bipForm.setCodcamo(rset.getString(1));
								bipForm.setClibca(rset.getString(4));
							} else if (sTable.equals("PRJ")) {
								bipForm.setIcpi(rset.getString(1));
								bipForm.setIlibel(rset.getString(2)); // TD 584 : Modification car getString(8) = Icodproj au lieu de Ilibel
							} else if (sTable.equals("APP")) {
								bipForm.setAirt(rset.getString(1));
								bipForm.setAlibel(rset.getString(6));
							} else if (sTable.equals("CP")) {
								bipForm.setCpcode(rset.getString(1));
								bipForm.setRnom(rset.getString(3));
								bipForm.setRprenom(rset.getString(4));
							}

							// bipForm.setMsgErreur(null);
						} else
							msg = true;
						if (rset != null)
							rset.close();
					} // try
					catch (SQLException sqle) {
						logService
								.debug("LienProjAction-suite() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("LienProjAction-suite() --> SQLException :"
										+ sqle);
						// Erreur de lecture du resultSet
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11217"));
						// this.saveErrors(request,errors);
						 jdbc.closeJDBC(); return mapping.findForward("error");
					}
				} // if
			} // for
			if (msg) {
				// le code n'existe pas, on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		} // try
		catch (BaseException be) {
			logBipUser.debug("LienProjAction-suite() --> BaseException :" + be,
					be);
			logBipUser.debug("LienProjAction-suite() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("LienProjAction-suite() --> BaseException :" + be,
					be);
			logService.debug("LienProjAction-suite() --> Exception :"
					+ be.getInitialException().getMessage());

			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((LienLigneForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}

		}

		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("suite");
	}

	/**
	 * Action qui permet de visualiser les données liées aux projets
	 */
	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;
		String sRequete = "";
		String sPid = "";
		boolean bUnion = false;
		// booleen permettant d'ajouter le mot-cle UNION au bons endroits
		int noligne;
		Class[] parameterString = { String.class };
		Class[] parameterInt = { int.class };

		String signatureMethode = "LienProjAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		LienLigneForm bipForm = (LienLigneForm) form;

		try {
			JDBCWrapper jdbcWrapper = ServiceManager.getInstance()
					.getJdbcManager().getWriter();

			//
			// Contruction requete dynamique
			//
			for (int i = 1; i < 7; i++) {
				sPid = "pid_" + i;

				// Récupérer la valeur des codes projets
				if (!request.getParameter(sPid).equals("")) {
					// parametre non nul
					if (bUnion)
						sRequete += " union "; // ajouter mot-cle UNION

					sRequete = sRequete + "SELECT pid, pnom,  flaglock, " + i
							+ " as noligne " + "FROM ligne_bip "
							+ "WHERE pid = '" + request.getParameter(sPid)
							+ "'";
					bUnion = true;
				}
			}

			try {

				// Exécution de la requête
				jdbcWrapper.execute(sRequete);

				while (jdbcWrapper.next()) {
					noligne = jdbcWrapper.getInt(4);

					try {
						// On doit récupérer les méthodes suivant l'index
						// noligne
						// pour cela, on utilise les méthodes
						// - Method getDeclaredMethod(String name, Class[]
						// parameterTypes) : récupère la bonne méthode
						// - puis Object invoke(Object obj, Object[] args) :
						// exécute la méthode

						Object[] param1 = { (Object) jdbcWrapper.getString(1) };
						Object[] param2 = { (Object) jdbcWrapper.getString(2) };
						Object[] param3 = { (Object) (new Integer(jdbcWrapper
								.getInt(3))).toString() };

						bipForm.getClass().getDeclaredMethod(
								"setPid_" + noligne, parameterString).invoke(
								(Object) bipForm, param1);

						bipForm.getClass().getDeclaredMethod(
								"setPnom_" + noligne, parameterString).invoke(
								(Object) bipForm, param2);

						bipForm.getClass().getDeclaredMethod(
								"setFlaglock_" + noligne, parameterString)
								.invoke((Object) bipForm, param3);

					} catch (NoSuchMethodException me) {
						logBipUser.debug("Méthode inexistante");
						// Erreur d''exécution
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11209"));
						this.saveErrors(request, errors);
						  return mapping.findForward("error");

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

				}

			} catch (BaseException be) {
				// Si exception sql alors extraire le message d'erreur du
				// message global
				if (be.getInitialException().getClass().getName().equals(
						"java.sql.SQLException")) {
					message = BipException.getMessageFocus(BipException
							.getMessageOracle(be.getInitialException()
									.getMessage()), form);
					((LienLigneForm) form).setMsgErreur(message);
					 return mapping.findForward("initial");

				} else {
					// Erreur d''exécution de la requête
					errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
							"11208"));
					request.setAttribute("messageErreur", be
							.getInitialException().getMessage());
					// this.saveErrors(request,errors);
					 return mapping.findForward("error");
				}
			} finally {
				// fermeture de la connexion
				jdbcWrapper.close();

			}

		} catch (BaseException be) {

			logBipUser.debug("LienProjAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("LienProjAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("LienProjAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("LienProjAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			// Impossible de créer JDBCWrapper
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11206"));
			request.setAttribute("messageErreur", be.getInitialException()
					.getMessage());
			// this.saveErrors(request,errors);
			return mapping.findForward("error");

		}

		logBipUser.exit(signatureMethode);

		return mapping.findForward("ecran");

	} // consulter

	protected String recupererCle(String mode) {
		String cle = null;

		if (mode.equals("DP")) {
			cle = PACK_UPDATE_DP;
		} else if (mode.equals("DPG")) {
			cle = PACK_UPDATE_DPG;
		} else if (mode.equals("MO")) {
			cle = PACK_UPDATE_MO;
		} else if (mode.equals("CAMO")) {
			cle = PACK_UPDATE_CAMO;
		} else if (mode.equals("PRJ")) {
			cle = PACK_UPDATE_PROJET;
		} else if (mode.equals("APP")) {
			cle = PACK_UPDATE_APPLI;
		} else if (mode.equals("CP")) {
			cle = PACK_UPDATE_CP;
		}
		  return cle;
	}
} // class
