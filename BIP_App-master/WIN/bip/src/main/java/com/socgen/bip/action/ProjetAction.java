package com.socgen.bip.action;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Locale;
import java.util.Vector;
import java.io.PrintWriter;
import java.io.IOException;
import java.sql.Array;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

//FIXME DHA NOT USED
//import weblogic.xml.xpath.common.functions.SubstringAfterFunction;


import com.socgen.bip.commun.form.AutomateForm;
import com.socgen.bip.commun.form.BipForm;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.ProjetForm;
import com.socgen.bip.form.TypeEtapeForm;
import com.socgen.bip.util.BipDateUtil;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author N.BACCAM - 18/06/2003
 * 
 * Formulaire pour mise à jour des projets informatiques chemin :
 * Administration/Référentiels/Projets pages : fmProjetAd.jsp et mProjetAd.jsp
 * pl/sql : projinfo.sql
 */
public class ProjetAction extends SocieteAction {

	private static String PACK_SELECT = "projet.consulter.proc";

	private static String PACK_INSERT = "projet.creer.proc";

	private static String PACK_UPDATE = "projet.modifier.proc";

	private static String PACK_DELETE = "projet.supprimer.proc";

	private static String PACK_GETLIB_CLIENT_MO = "libelles.getLibClientMO.proc";

	private static String PACK_GETLIB_CLIENT_ME = "libelles.getLibClientME.proc";

	private static String PACK_GETLIB_CODCAMO = "libelles.getLibCADA.proc";
	
	private static String PACK_GETDOM_DPCOPI = "dpcopi.getDomaine.proc";
	
	private static String PACK_INTEGRITE_LIGNE_DP = "projet.integriteLigneDP.proc";
	
	private static String PACK_DATE_FONCTIONNEL = "projet.datFonctionnel.proc";
	
	// HMI : PPM 61919 chapitre 6.8
	private static String PACK_MISEAVIDE = "projet.mise.videprojaxe.proc";
	
	private static String VERIFIER_PROJ_AXE = "projet.verifierprojaxe.proc";
	// fin HMI : PPM 61919 chapitre 6.8

	//SPRINT 6 : BIP 335 - USER STORY
	private static String VERIFIER_PROJ_LIGNE_LINK = "projet.verifierprojligne.proc";
	// FAD PPM 63826 : Déclaration procedure stocké
	private static String VERIFIER_DUREE_AMORT = "projet.verifierdureeamort.proc";
	
	private String nomProc;
	
	

	/**
	 * Action qui permet de créer un code Projet
	 */
	protected ActionForward creer(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;

		String signatureMethode = "ProjetAction -creer( mapping, form , request,  response,  errors )";

		// logService.entry(signatureMethode);;
		logBipUser.entry(signatureMethode);
		// exécution de la procédure PL/SQL
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT);
			try {
				message = jdbc.recupererResult(vParamOut, "creer");
				// On initialise le cada à 0
				((ProjetForm) form).setCada("0");
				((ProjetForm) form).setCod_db("0");
			} catch (BaseException be) {
				logBipUser.debug("ProjetAction -creer() --> BaseException :"
						+ be);
				logBipUser.debug("ProjetAction -creer() --> Exception :"
						+ be.getInitialException().getMessage());
				logService.debug("ProjetAction -creer() --> BaseException :"
						+ be);
				logService.debug("ProjetAction -creer() --> Exception :"
						+ be.getInitialException().getMessage());
				// Erreur de lecture du resultSet
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
			if (!message.equals("")) {
				// Entité déjà existante, on récupère le message
				((ProjetForm) form).setMsgErreur(message);

				logBipUser.debug("message d'erreur:" + message);
				logBipUser.exit(signatureMethode);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}

		}// try
		catch (BaseException be) {
			logBipUser.debug("ProjetAction-creer() --> BaseException :" + be);
			logBipUser.debug("ProjetAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("ProjetAction-creer() --> BaseException :" + be);
			logService.debug("ProjetAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((ProjetForm) form).setMsgErreur(message);
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
		String duplic = "";

		String signatureMethode = "ClientAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		ProjetForm bipForm = (ProjetForm) form;

		duplic = bipForm.getDuplic();

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

						SimpleDateFormat sdf = new SimpleDateFormat(
								"dd/MM/yyyy", Locale.FRANCE);
						SimpleDateFormat sdf_datdem = new SimpleDateFormat(
								"MM/yyyy", Locale.FRANCE);
						if (rset.next()) {
							 
							bipForm.setIcpi(rset.getString(1));
							bipForm.setIlibel(rset.getString(2));
							bipForm.setDescr(rset.getString(3));
							bipForm.setImop(rset.getString(4));
							bipForm.setClicode(rset.getString(5));
							bipForm.setIcme(rset.getString(6));
							bipForm.setCodsg(rset.getString(7));
							bipForm.setIcodproj(rset.getString(8));
							if(bipForm.getIcodproj()!=null){
							   hParamProc.put("icodproj", rset.getString(8));
							}
							bipForm.setIcpir(rset.getString(9));
							bipForm.setCada(rset.getString(11));
							bipForm.setFlaglock(rset.getInt(14));
							bipForm.setCod_db(rset.getString(15));
							Date laDateDemarrage = rset.getDate(12);
							bipForm.setClilib(rset.getString(16));
							bipForm.setLibdsg(rset.getString(17));
							bipForm.setDatcre(rset.getString(18));
							bipForm.setLibrpb(rset.getString(19));
							bipForm.setIdrpb(rset.getString(20));
							bipForm.setDatprod(rset.getString(21));
							bipForm.setDatrpro(rset.getString(22));
							bipForm.setCrireg(rset.getString(23));
							bipForm.setDeanre(rset.getString(24));
							bipForm.setLibcada(rset.getString(25));
							// TD 532
							bipForm.setLicodprca(rset.getString(26));
							bipForm.setCodcamo1(rset.getString(27));
							bipForm.setClibca1(rset.getString(28));
							bipForm.setCdfain1(rset.getString(29));
							bipForm.setDatvalli1(rset.getString(30));
							bipForm.setRespval1(rset.getString(31));
							bipForm.setCodcamo2(rset.getString(32));
							bipForm.setClibca2(rset.getString(33));
							bipForm.setCdfain2(rset.getString(34));
							bipForm.setDatvalli2(rset.getString(35));
							bipForm.setRespval2(rset.getString(36));
							bipForm.setCodcamo3(rset.getString(37));
							bipForm.setClibca3(rset.getString(38));
							bipForm.setCdfain3(rset.getString(39));
							bipForm.setDatvalli3(rset.getString(40));
							bipForm.setRespval3(rset.getString(41));
							bipForm.setCodcamo4(rset.getString(42));
							bipForm.setClibca4(rset.getString(43));
							bipForm.setCdfain4(rset.getString(44));
							bipForm.setDatvalli4(rset.getString(45));
							bipForm.setRespval4(rset.getString(46));
							bipForm.setCodcamo5(rset.getString(47));
							bipForm.setClibca5(rset.getString(48));
							bipForm.setCdfain5(rset.getString(49));
							bipForm.setDatvalli5(rset.getString(50));
							bipForm.setRespval5(rset.getString(51));
							bipForm.setDpactif(rset.getString(52));
							bipForm.setDplib(rset.getString(53));
							bipForm.setDpcopi(rset.getString(54));
							
							
							if(bipForm.getDpcopi()!=null){
								hParamProc.put("dpcopi", rset.getString(54));	
							} 		 
							
							if (laDateDemarrage != null)
								bipForm.setDateDemarrage((sdf_datdem
										.format(laDateDemarrage)).toString());

							Date laDateStatut = rset.getDate(13);
							if (laDateStatut != null)
								bipForm
										.setDateStatut((sdf
												.format(laDateStatut))
												.toString());

							// Si le statut est null on met statut a "" pour
							// permettre
							// l'affichage de "pas de statut" dans la liste
							// déroulante
							String statut = rset.getString(10);
							if (statut == null)
								statut = "";
							bipForm.setStatut(statut);
							bipForm.setTopenvoi(rset.getString(55));
							if (rset.getString(56)== null)
								bipForm.setDate_envoi("01/01/1900");
							else
							bipForm.setDate_envoi(rset.getString(56));
							bipForm.setLib_domaine(rset.getString(57));
							bipForm.setDatefonctionnel(rset.getString(58));
							bipForm.setDureeamor(rset.getString(59));
							
							// HMI PPM 61919 $6.8
							bipForm.setProjaxemetier(rset.getString(60));
							//FIN HMI PPM 61919 $6.8
							
							bipForm.setMsgErreur(null);
							 
							
						} else
							msg = true;

					}// try
					catch (SQLException sqle) {
						logService
								.debug("ProjetAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("ProjetAction-consulter() --> SQLException :"
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
									.debug("ProjetAction-consulter() --> SQLException-rset.close() :"
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
				// le code Projet n'existe pas, on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		}// try
		catch (BaseException be) {
			logBipUser.debug("ProjetAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("ProjetAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("ProjetAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("ProjetAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			
			/*errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201")); 
			// this.saveErrors(request,errors);
			 jdbc.closeJDBC(); return mapping.findForward("error");*/
			
			//Fiche 622 : correction récup message erreur quand code entré ne
			//commence pas par 'I' ou 'P'
			//Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((ProjetForm) form).setMsgErreur(message);
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

		if (("OUI".equals(bipForm.getDuplic()))) {
			bipForm.setIcpi("");
			bipForm.setIcpir("");
			bipForm.setDatprod("");
			bipForm.setDatrpro("");
		}

		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("ecran");

	}

	protected ActionForward refresh(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		ProjetForm projetForm = (ProjetForm) form;
		// Récupération du champs sur lequel se trouve le focus
		String focus = projetForm.getFocus();

		Vector vParamOut = new Vector();
		Vector vParamOut2 = new Vector();
		
		try {
			
			vParamOut2 = jdbc.getResult(
					hParamProc, configProc, PACK_DATE_FONCTIONNEL );
			projetForm.setDatefonctionnel((String) ((ParametreProc) vParamOut2
					.elementAt(0)).getValeur());
			
			// Récupération de l'action initiale

			if ("clicode".equals(focus)) {
				vParamOut = jdbc.getResult(
						hParamProc, configProc, PACK_GETLIB_CLIENT_MO);
				projetForm.setClilib((String) ((ParametreProc) vParamOut
						.elementAt(0)).getValeur());
				projetForm.setMsgErreur((String) ((ParametreProc) vParamOut
						.elementAt(1)).getValeur());

				// MAJ du Focus
				if (projetForm.getMsgErreur() == null)
					projetForm.setFocus("imop");
				
			} else if ("codsg".equals(focus)) {
				vParamOut = jdbc.getResult(
						hParamProc, configProc, PACK_GETLIB_CLIENT_ME);
				projetForm.setLibdsg((String) ((ParametreProc) vParamOut
						.elementAt(0)).getValeur());
				projetForm.setMsgErreur((String) ((ParametreProc) vParamOut
						.elementAt(1)).getValeur());
				// MAJ du Focus
				if (projetForm.getMsgErreur() == null)
					projetForm.setFocus("icme");
				
			} else if ("cada".equals(focus)) {
				vParamOut = jdbc.getResult(
						hParamProc, configProc, PACK_GETLIB_CODCAMO);
				projetForm.setLibcada((String) ((ParametreProc) vParamOut
						.elementAt(0)).getValeur());
				projetForm.setMsgErreur((String) ((ParametreProc) vParamOut
						.elementAt(1)).getValeur());
				// MAJ du Focus
				if (projetForm.getMsgErreur() == null)
					projetForm.setFocus("datprod");
				
			} else if ("dpcopi".equals(focus)) {
				vParamOut = jdbc.getResult(
						hParamProc, configProc, PACK_GETDOM_DPCOPI );
				projetForm.setCod_db((String) ((ParametreProc) vParamOut
						.elementAt(0)).getValeur());
				projetForm.setLib_domaine((String) ((ParametreProc) vParamOut
						.elementAt(1)).getValeur());
				projetForm.setMsgErreur((String) ((ParametreProc) vParamOut
						.elementAt(2)).getValeur());
				
			}else if ("icodproj".equals(focus)) {
				
				vParamOut = jdbc.getResult(
						hParamProc, configProc, PACK_INTEGRITE_LIGNE_DP );
				projetForm.setCount((String) ((ParametreProc) vParamOut
						.elementAt(0)).getValeur());
				projetForm.setMsgErreur((String) ((ParametreProc) vParamOut
						.elementAt(1)).getValeur());
			} 
		}

		catch (BaseException be) {
			logBipUser.debug("ClientAction-refresh() --> BaseException :" + be,
					be);
			logBipUser.debug("ClientAction-refresh() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("ClientAction-refresh() --> BaseException :" + be,
					be);
			logService.debug("ClientAction-refresh() --> Exception :"
					+ be.getInitialException().getMessage());
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));

			// this.saveErrors(request,errors);
			 jdbc.closeJDBC(); return mapping.findForward("error");
		}
		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	}

	protected ActionForward valider(ActionMapping mapping, ActionForm form,
			String mode, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors,
			Hashtable hParamProctest) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String cle = null;
		String message = null;

		String signatureMethode = "valider(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors )";
		logBipUser.entry(signatureMethode);
		logBipUser.debug("mode de mise à jour:" + mode);
		// On récupère la clé pour trouver le nom de la procédure stockée dans
		// bip_proc.properties
		cle = recupererCle(mode);

		// On exécute la procédure stockée
		try {

			vParamOut = jdbc.getResult(
					hParamProctest, configProc, cle);

			try {
				message = jdbc.recupererResult(vParamOut, "valider");

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

			if (message != null && !message.equals("")) {
				// on récupère le message
				((AutomateForm) form).setMsgErreur(message);
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
				((AutomateForm) form).setMsgErreur(message);

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

		logBipUser.exit(signatureMethode);
		String edition = ((ProjetForm) form).getEdition();

		if ("NON".equals(edition)) {
			 jdbc.closeJDBC(); return mapping.findForward("initial");
		} else {
			 jdbc.closeJDBC(); return mapping.findForward("edition");
		}

	}// valider
	
	
	//BIP 335 - To check the project and ligne link 
	
	public ActionForward verifierProjectLigneLink(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws IOException, SQLException{
		String signatureMethode ="ProjInfoAction - verifierProjectLigneLink";
		
		return traitementAjaxProj(VERIFIER_PROJ_LIGNE_LINK, signatureMethode, mapping, form, response, hParamProc);
	}
	//BIP 335 - To check the project and ligne link 
	private ActionForward traitementAjaxProj(String cleProc, String signatureMethode, ActionMapping mapping, ActionForm form, HttpServletResponse response, Hashtable hParamProc) throws IOException, SQLException {
		logBipUser.entry(signatureMethode);
		
		ProjetForm bipForm = (ProjetForm) form;
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut;
		ParametreProc paramOut;
		String message = "";
		String []tempPid=null;
		String pid="";
		int i=0;
		String result ="";
		
		
		
		// Appel de la procï¿½dure
		try {
			vParamOut= jdbc.getResult (hParamProc,configProc, cleProc);
		 	// ----------------------------------------------------------
			for (Enumeration e=vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				if (paramOut.getNom().equals("message")) {//pid
					if (paramOut.getValeur() != null) {
						message = (String) paramOut.getValeur();
					}
				
				}
				if (paramOut.getNom().equals("pid")) {//pid
					if (paramOut.getValeur() != null) {
						Array arraySqlOut = (Array) paramOut.getValeur();
						//dLignesBipOut = (String[]) (arraySqlOut.getArray());
						tempPid = (String[]) arraySqlOut.getArray();
						pid=toJavascriptArray(tempPid);
						
					}
				
				}
			}	
		}
		catch (BaseException be) {
			logBipUser.debug(signatureMethode + " --> Exception :"+be.getInitialException().getMessage());
			logService.debug(signatureMethode + " --> BaseException :"+be);
			
			message = BipException.getMessageFocus(
					BipException.getMessageOracle(be.getInitialException()
							.getMessage()), form);
			
			if (!be.getInitialException().getClass().getName().equals(
			"java.sql.SQLException")) {
				// Erreur d'exï¿½cution
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
			} 
		}	
		
		jdbc.closeJDBC();
		
		// Ecriture du message de retour dans la response
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		
		result = pid.concat(";").concat(message); 
		
		out.println(new String(result.getBytes("utf8"), "iso-8859-1"));
		out.flush();
		
		logBipUser.exit(signatureMethode);
		
		return PAS_DE_FORWARD;
	}
	
	public static String toJavascriptArray(String[] arr){
	    StringBuffer sb = new StringBuffer();
	   // sb.append("[");
	    for(int i=0; i<arr.length; i++){
	        sb.append(arr[i]);
	        if(i+1 < arr.length){
	            sb.append(",");
	        }
	    }
	    //sb.append("]");
	    return sb.toString();
	}
	
	// HMI : PPM 61919 chapitre 6.8
	
	public ActionForward verifierProjetAxeMetier(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws IOException{
		String signatureMethode ="ProjInfoAction - verifierProjAxeMet";
		
		return traitementAjax(VERIFIER_PROJ_AXE, signatureMethode, mapping, form, response, hParamProc);
	}
	
	// PPM 64510 : Debut
	public ActionForward statutPopUp(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws IOException{
		return mapping.findForward("popup");
	}
	// PPM 64510 : FIN
	private ActionForward traitementAjax(String cleProc, String signatureMethode, ActionMapping mapping, ActionForm form, HttpServletResponse response, Hashtable hParamProc) throws IOException {
		logBipUser.entry(signatureMethode);
		
		ProjetForm bipForm = (ProjetForm) form;
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut;
		ParametreProc paramOut;
		String message = "";
		String type = "";
		String param_id = "";
		String result = "";
		
		
		/*hParamProc.put("icpi", bipForm.getIcpi());
		hParamProc.put("projaxemetier", bipForm.getProjaxemetier());
		hParamProc.put("clicode", bipForm.getClicode());
		hParamProc.put("codsg", bipForm.getCodsg());*/
		
		// Appel de la procï¿½dure
		try {
			vParamOut= jdbc.getResult (hParamProc,configProc, cleProc);
		 	// ----------------------------------------------------------
			for (Enumeration e=vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				if (paramOut.getNom().equals("message")) {
					if (paramOut.getValeur() != null) {
						message = (String) paramOut.getValeur();
					}
				}
				if (paramOut.getNom().equals("type")) {
					if (paramOut.getValeur() != null) {
						type = (String) paramOut.getValeur();
					}
				}
				if (paramOut.getNom().equals("param_id")) {
					if (paramOut.getValeur() != null) {
						param_id = (String) paramOut.getValeur();
					}
				}
			}	
		}
		catch (BaseException be) {
			logBipUser.debug(signatureMethode + " --> Exception :"+be.getInitialException().getMessage());
			logService.debug(signatureMethode + " --> BaseException :"+be);
			
			message = BipException.getMessageFocus(
					BipException.getMessageOracle(be.getInitialException()
							.getMessage()), form);
			
			if (!be.getInitialException().getClass().getName().equals(
			"java.sql.SQLException")) {
				// Erreur d'exï¿½cution
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
			} 
		}	
		
		jdbc.closeJDBC();
		
		// Ecriture du message de retour dans la response
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		result = type.concat(";").concat(param_id).concat(";").concat(message);
		out.println(new String(result.getBytes("utf8"), "iso-8859-1"));
		out.flush();
		
		logBipUser.exit(signatureMethode);
		
		return PAS_DE_FORWARD;
	}
	
	public ActionForward mettreAvide(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws IOException{
		String signatureMethode ="ProjInfoAction - mettreAvide";
		
		return traitAjax(PACK_MISEAVIDE, signatureMethode, mapping, form, response, hParamProc);
	}
	
	private ActionForward traitAjax(String cleProc, String signatureMethode, ActionMapping mapping, ActionForm form, HttpServletResponse response, Hashtable hParamProc) throws IOException {
		logBipUser.entry(signatureMethode);
		
		ProjetForm bipForm = (ProjetForm) form;
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut;
		ParametreProc paramOut;
		String message = "";
		
		// Appel de la procï¿½dure
		try {
			vParamOut= jdbc.getResult (hParamProc,configProc, cleProc);
		 	// ----------------------------------------------------------
			for (Enumeration e=vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				if (paramOut.getNom().equals("message")) {
					if (paramOut.getValeur() != null) {
						message = (String) paramOut.getValeur();
					}
				
				}
			}	
		}
		catch (BaseException be) {
			logBipUser.debug(signatureMethode + " --> Exception :"+be.getInitialException().getMessage());
			logService.debug(signatureMethode + " --> BaseException :"+be);
			
			message = BipException.getMessageFocus(
					BipException.getMessageOracle(be.getInitialException()
							.getMessage()), form);
			
			if (!be.getInitialException().getClass().getName().equals(
			"java.sql.SQLException")) {
				// Erreur d'exï¿½cution
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
			} 
		}	
		
		jdbc.closeJDBC();
		
		// Ecriture du message de retour dans la response
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
		out.flush();
		
		logBipUser.exit(signatureMethode);
		
		return PAS_DE_FORWARD;
	}
	// fin HMI : PPM 61919 chapitre 6.8

	// FAD PPM 63826 : Début
	public ActionForward verifierDureeAmort(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws IOException{
		String signatureMethode ="ProjInfoAction - verifierDureeAmort";
		
		return traitementAjax(VERIFIER_DUREE_AMORT, signatureMethode, mapping, form, response, hParamProc);
	}
	// FAD PPM 63826 : Fin

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
	
	public ActionForward validateHierarchyInput(
			ActionMapping mapping,ActionForm form, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors, Hashtable<?, ?> hParamReport ) throws Exception {
			
		String signatureMethode = "validateHierarchyInput(ActionMapping mapping,ActionForm form, HttpServletRequest request,HttpServletResponse response, ActionErrors errors, Hashtable<?, ?> hParamProc )";
		logBipUser.entry(signatureMethode + " - Start");
		
		String rtfe = null;
		
		if (!hParamReport.get("p_param6").toString().isEmpty()) {
			rtfe = hParamReport.get("p_param6").toString();
			if("*".equalsIgnoreCase(String.valueOf(rtfe.charAt(rtfe
					.length() - 1)))){
				rtfe = rtfe.substring(0,rtfe.length() - 1);
			}		
			logBipUser.debug("hParamReport.get(P_PARAM6) :"+rtfe);
		} else if (!hParamReport.get("p_param7").toString().isEmpty()) {
			rtfe = hParamReport.get("p_param7").toString();
			logBipUser.debug("hParamReport.get(P_PARAM7) :"+rtfe);
		} else {
			rtfe = userBip.getIdUser();
			logBipUser.debug("userBip.getIdUser() :"+rtfe);
		}
		
		JdbcBip jdbc = new JdbcBip(); 
		  Vector vParamOut = new Vector();
		  String message = "";
		  ParametreProc paramOut;
		  Hashtable<String,String> lParamProc = new Hashtable<String,String>();
		  
		  lParamProc.put("rtfe", rtfe);
		
		try {
			
			vParamOut = jdbc.getResult(lParamProc, configProc, "hier.get.ident");
				for (Enumeration e1 = vParamOut.elements(); e1.hasMoreElements();) {
					paramOut = (ParametreProc) e1.nextElement();	
					if (paramOut.getNom().equals("resId")) {
						if (paramOut.getValeur() != null)
							//message = (String) paramOut.getValeur();
						return PAS_DE_FORWARD;
					}
				}
			}
			catch (BaseException be) {
				logBipUser.debug("ProjectAction-validateHierarchyInput() --> BaseException :" + be);
				logBipUser.debug("ProjectAction-validateHierarchyInput() --> Exception :"
						+ be.getInitialException().getMessage());
				if (be.getInitialException().getClass().getName().equals(
						"java.sql.SQLException")) {
					message = BipException.getMessageFocus(
							BipException.getMessageOracle(be.getInitialException()
									.getMessage()), form);
					((ProjetForm) form).setMsgErreur(message);					
					 jdbc.closeJDBC();
					  response.setContentType("text/html");
					  PrintWriter out = response.getWriter();
					  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
					  out.flush();
					  return PAS_DE_FORWARD;

				} else {
					errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
					request.setAttribute("messageErreur", be.getInitialException()
							.getMessage());
					 jdbc.closeJDBC();
					  response.setContentType("text/html");
					  PrintWriter out = response.getWriter();
					  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
					  out.flush();
					  return PAS_DE_FORWARD;
				}
			}

			 jdbc.closeJDBC();

		  response.setContentType("text/html");
		  PrintWriter out = response.getWriter();
		  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
		  out.flush();
		
		logBipUser.entry(signatureMethode + " - End");
		return PAS_DE_FORWARD;
	}

}
