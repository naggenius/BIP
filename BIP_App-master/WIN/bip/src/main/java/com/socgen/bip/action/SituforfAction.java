package com.socgen.bip.action;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.ForfaitForm;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author N.BACCAM - 25/06/2003
 * 
 * Formulaire pour mise à jour des forfaits chemin : Ressources/ mise à
 * jour/Forfaits/situation pages : bForfaitAd.jsp et mForfaitAd.jsp pl/sql :
 * resfor.sql
 */
public class SituforfAction extends ForfaitAction {

	private static String PACK_SELECT = "situforf.consulter.proc";

	private static String PACK_INSERT = "situforf.creer.proc";

	private static String PACK_UPDATE = "situforf.modifier.proc";

	private static String PACK_DELETE = "situforf.supprimer.proc";
	
	private static String PACK_RECUP_SOCIETE="societe.recup.soccode";
	
	private static String PACK_RECUP_MODECONT="situforf.recup.modecont.proc";
	
	private static String PACK_RECUP_LIB_MCI="forfait.recup.mci.lib.proc";

	private String nomProc;
	
	private static String PACK_ISMCIOBLIGATOIRE = "personne.recup.mci.obligatoire.proc";
	

	/**
	 * Action qui permet de créer un code forfait
	 */
	protected ActionForward creer(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = "SituforfAction -creer( mapping, form , request,  response,  errors )";

		// logService.entry(signatureMethode);;
		logBipUser.entry(signatureMethode);
		// hParamProc.put("datsitu","");
		// exécution de la procédure PL/SQL
		try {

			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT);

						
			// Récupération des résultats
			ForfaitForm bipForm = (ForfaitForm) form;
			
			if (((ParametreProc) vParamOut.get(1)).getValeur() != null) {
				bipForm.setCodsg(((ParametreProc) vParamOut.get(1)).getValeur()
						.toString());
			}
			if (((ParametreProc) vParamOut.get(2)).getValeur() != null) {
				bipForm.setSoccode(((ParametreProc) vParamOut.get(2))
						.getValeur().toString());
			}
			if (((ParametreProc) vParamOut.get(3)).getValeur() != null) {
				bipForm.setCpident(((ParametreProc) vParamOut.get(3))
						.getValeur().toString());
			}
			bipForm.setDatsitu("");
			if (((ParametreProc) vParamOut.get(5)).getValeur() != null) {
				bipForm.setPrestation(((ParametreProc) vParamOut.get(5))
						.getValeur().toString());
			}

			if (((ParametreProc) vParamOut.get(7)).getValeur() != null) {
				int flag = new Integer(((ParametreProc) vParamOut.get(7))
						.getValeur().toString()).intValue();
				bipForm.setFlaglock(flag);
			}
			
			//Recuperation du mode contractuel
			if (((ParametreProc) vParamOut.get(10)).getValeur() != null) {
				bipForm.setModeContractuelInd(((ParametreProc) vParamOut.get(10))
						.getValeur().toString());
			}
			
			hParamProc.put("soccode",bipForm.getSoccode());
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_RECUP_SOCIETE);
			bipForm.setLib_siren((String) ((ParametreProc) vParamOut
					.elementAt(0)).getValeur());
			bipForm.setLib_soccode((String) ((ParametreProc) vParamOut
					.elementAt(1)).getValeur());
			bipForm.setMsgErreur((String) ((ParametreProc) vParamOut
					.elementAt(2)).getValeur());

		}// try
		catch (BaseException be) {
			logBipUser.debug("SituforfAction-creer() --> BaseException :" + be);
			logBipUser.debug("SituforfAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("SituforfAction-creer() --> BaseException :" + be);
			logService.debug("SituforfAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((ForfaitForm) form).setMsgErreur(message);
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

		String signatureMethode = "SituforfAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		ForfaitForm bipForm = (ForfaitForm) form;

		// exécution de la procédure PL/SQL
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT);

			// Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();
				
				//Recuperation du mode contractuel
				if (paramOut.getNom().equals("modeContractuelInd")) {
					bipForm.setModeContractuelInd((String)paramOut.getValeur());
					
					hParamProc.put("modeContractuelInd",bipForm.getModeContractuelInd());
					vParamOut = jdbc.getResult(
							hParamProc, configProc, PACK_RECUP_LIB_MCI);
					bipForm.setLib_mci((String) ((ParametreProc) vParamOut
							.elementAt(0)).getValeur());
				}
				
				//Recuperation du code localisation
				if (paramOut.getNom().equals("codelocalisation")) {
					bipForm.setLocalisation((String)paramOut.getValeur());
				}
				
				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();

					try {
						logService.debug("ResultSet");
						if (rset.next()) {

							bipForm.setIdent(rset.getString(1));
							bipForm.setRnom(rset.getString(2));
							bipForm.setCoutot(rset.getString(3));
							bipForm.setFlaglock(rset.getInt(4));
							bipForm.setDatsitu(rset.getString(5));
							bipForm.setDatdep(rset.getString(6));
							bipForm.setCodsg(rset.getString(7));
							bipForm.setSoccode(rset.getString(8));
							bipForm.setPrestation(rset.getString(9));
							bipForm.setCpident(rset.getString(10));
							bipForm.setCoufor(rset.getString(11));
							bipForm.setMontant_mens(rset.getString(12));
							bipForm.setOldatsitu(rset.getString(13));
							bipForm.setTypeForfait(rset.getString(14));
							bipForm.setCode_domaine(rset.getString(15));
							
							hParamProc.put("soccode",bipForm.getSoccode());
							vParamOut = jdbc.getResult(
									hParamProc, configProc, PACK_RECUP_SOCIETE);
							bipForm.setLib_siren((String) ((ParametreProc) vParamOut
									.elementAt(0)).getValeur());
							bipForm.setLib_soccode((String) ((ParametreProc) vParamOut
									.elementAt(1)).getValeur());
							bipForm.setMsgErreur((String) ((ParametreProc) vParamOut
									.elementAt(2)).getValeur());
							
							// calcul si le mci est obligatoire pour le dpg
							hParamProc.put("codsg",bipForm.getCodsg());
							vParamOut = jdbc.getResult(
									hParamProc, configProc, PACK_ISMCIOBLIGATOIRE);	
							bipForm.setMciObligatoire((String) ((ParametreProc) vParamOut
									.elementAt(0)).getValeur());													

						} else
							msg = true;

					}// try
					catch (SQLException sqle) {
						logService
								.debug("SituforfAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("SituforfAction-consulter() --> SQLException :"
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
									.debug("SituforfAction-consulter()  --> SQLException-rset.close() :"
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
				// le code Situfor n'existe pas, on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		}// try
		catch (BaseException be) {
			logBipUser.debug("SituforfAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("SituforfAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("SituforfAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("SituforfAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((ForfaitForm) form).setMsgErreur(message);
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

	public ActionForward retour(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		 return mapping.findForward("retour");

	}
	
	protected ActionForward refresh(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		ForfaitForm bipForm = (ForfaitForm) form;
		// Intitulé à charger
		String focus = bipForm.getFocus();
				
		Vector vParamOut = new Vector();

		try {
			
			if ("soccode".equals(focus)) {
			
			// recherche du siren et du libelle societe
				vParamOut = jdbc.getResult(
						hParamProc, configProc, PACK_RECUP_SOCIETE);
				bipForm.setLib_siren((String) ((ParametreProc) vParamOut
						.elementAt(0)).getValeur());
				bipForm.setLib_soccode((String) ((ParametreProc) vParamOut
						.elementAt(1)).getValeur());
				bipForm.setMsgErreur((String) ((ParametreProc) vParamOut
						.elementAt(2)).getValeur());
				if (bipForm.getMsgErreur() == null)
					bipForm.setFocus("soccode");
			}	
			
			
			
				// Recherche du mode contractuel
				vParamOut = jdbc.getResult(
						hParamProc, configProc, PACK_RECUP_MODECONT);
				bipForm.setModeContractuelInd((String) ((ParametreProc) vParamOut
						.elementAt(0)).getValeur());
			
				if (bipForm.getModeContractuelInd() != null)
				hParamProc.put("modeContractuelInd",bipForm.getModeContractuelInd());
			     vParamOut = jdbc.getResult(
							hParamProc, configProc, PACK_RECUP_LIB_MCI);
					bipForm.setLib_mci((String) ((ParametreProc) vParamOut
							.elementAt(0)).getValeur());
					bipForm.setLocalisation((String) ((ParametreProc) vParamOut
							.elementAt(1)).getValeur());
				
					// Rechcherche si mci obligatoire
					logBipUser.debug("SitupersAction-consulter() --> mci_obligatoire :");
					Hashtable<String,String> lParamProc = new Hashtable<String,String>();
					lParamProc.put("codsg", bipForm.getCodsg());
					vParamOut = jdbc.getResult(
							lParamProc, configProc, PACK_ISMCIOBLIGATOIRE);
					
					//Récupération des résultats
					bipForm.setMciObligatoire((String) ((ParametreProc) vParamOut
							.elementAt(0)).getValeur());										
					
					// MAJ du Focus
					if ("datsitu".equals(focus))	
						bipForm.setFocus("datdep");
			
					if ("datdep".equals(focus))	
						bipForm.setFocus("codsg");
					
					if ("modeContractuelInd".equals(focus))	
						bipForm.setFocus("cpident");
			
					
					if ("soccode".equals(focus))	
						bipForm.setFocus("modeContractuelInd");
				
			
		} catch (BaseException be) {
			logBipUser.debug("ForfaitAction-refresh() --> BaseException :" + be,
					be);
			logBipUser.debug("ForfaitAction-refresh() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("ForfaitAction-refresh() --> BaseException :" + be,
					be);
			logService.debug("ForfaitAction-refresh() --> Exception :"
					+ be.getInitialException().getMessage());
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));

			// this.saveErrors(request,errors);
			 jdbc.closeJDBC(); return mapping.findForward("error");
		}
		
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
