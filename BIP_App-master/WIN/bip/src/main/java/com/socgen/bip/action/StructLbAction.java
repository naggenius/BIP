package com.socgen.bip.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.LinkedHashMap;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.commun.form.BipForm;
import com.socgen.bip.commun.liste.ListeOption;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.StructLbForm;
import com.socgen.bip.form.TypeEtapeForm;
import com.socgen.bip.metier.StructLb;
import com.socgen.bip.metier.StructLbEtape;
import com.socgen.bip.metier.StructLbSsTache;
import com.socgen.bip.metier.StructLbTache;
import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.config.ConfigManager;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author N.BACCAM - 27/05/2003
 *
 * Action de mise � jour des clients MO
 * chemin : Administration/Tables/ mise � jour/Clients
 * pages  : fmClientAd.jsp et mClientAd.jsp
 * pl/sql : isac_lspid.sql(liste des lignes BIP)
 */
public class StructLbAction extends AutomateAction implements BipConstantes {
	static Config config = ConfigManager.getInstance("sql");
	private static String cle = "SQL.isac.libelle";
	private static String cleDirection = "SQL.isac.direction";
	private static String cleTypproj= "SQL.isac.typproj";

	// FAD - PPM 63773 - D�claration de la proc�dure stock� qui retourne si une ligne BIP comporte un consomm� + suppression SR
	private static String PACK_A_UN_CONSOMME = "listeIsacEtape.a_un_consomme.proc";
	private static String PACK_DELETE_STRUCTURE = "isac.delete_structure.proc";
	// FAD - PPM 63773 - Fin

	private static String PACK_A_UNE_STRUCTURE = "listeIsacEtape.a_une_structure.proc";
	private static String PACK_A_UNE_STRUCTURE_RESULT = "result";
	private static String PACK_A_UNE_STRUCTURE_RESULT_OUI = "O";
	private static String PACK_GET_INFOS_STRUCTURE_LIGNE = "listeIsacEtape.get_infos_structure_ligne.proc";
	
	private static String PACK_CREER_LIGNE_BIP_ABSENCE = "lignebip.creer.absence.proc";
	private static String PACK_CREER_LIGNE_BIP_HORS_PROJ = "lignebip.creer.hors_projet.proc";
	private static String PACK_CREER_LIGNE_BIP_EN_PROJ = "lignebip.creer.en_projet.proc";
	//HMI - PPM 60709 - $5.3 - QC: 1774
	private static String PACK_VERIF_PARAM_DEFAUT = "isac.etape.parametrage_defaut.proc";
	//FIN HMI - PPM 60709 - $5.3 - QC: 1774
	
	private static String redirection_intial = "initial";
	private static String redirection_etape = "etape";
	private static String redirection_tache = "tache";
	private static String redirection_sous_tache = "sousTache";
	private static String redirection_error = "error";

	/**
	 * Retour � la page initiale de la structure de la ligne BIP, aucune ligne s�lectionn�e
	 */
	protected ActionForward annuler(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc)  {
		// TODO Tester
		// Suppression de l'attribut "PID" de la session
		request.getSession().removeAttribute(PID);
		
		// Redirection vers "initial" (jsp/bStructLbSr.jsp)
		return mapping.findForward(redirection_intial);
	}
	
	/**
	 * Obtention d'une arborescence � partir d�une liste d��l�ments
	 * @return
	 */
	private StructLb obtenirStructLb(ResultSet rset) {
		StructLb structLb = new StructLb();
		
		try {
			while (rset.next()) {
				alimenterEtape(structLb, rset);
			} 
			if (rset != null) {
				rset.close();
			}

		} // try
		catch (SQLException sqle) {
			logBipUser
					.debug("StructLbAction-obtenirStructLb() --> SQLException :"
							+ sqle);
			logBipUser
					.debug("StructLbAction-obtenirStructLb() --> SQLException :"
							+ sqle);
			// Erreur de lecture du resultSet
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
					"11217"));
		}
		return structLb;
	}
	
	/**
	 * Alimentation de l'�tape d'une structure de ligne BIP � partir d'une ligne r�sultat resultSet
	 * @param etapeCourante
	 * @param rset
	 * @throws SQLException
	 */
	private void alimenterEtape(StructLb structLb, ResultSet rset) throws SQLException {
		StructLbEtape etapeCourante;
		
		int idEtape = rset.getInt(1);
		
		if (idEtape != 0) {
			LinkedHashMap<String, StructLbEtape> etapes = structLb.getEtapes();
			
			if (etapes == null) {
				etapes = new LinkedHashMap<String, StructLbEtape>();
				structLb.setEtapes(etapes);
			}
			
			// Si l'�tape est d�j� dans la liste 
			if (etapes.containsKey(String.valueOf(idEtape))) {
				// R�cup�ration de l'�tape
				etapeCourante = etapes.get(String.valueOf(idEtape));
			}
			// Si l'�tape n'est pas encore pr�sente
			else {
				// Instanciation d'une nouvelle �tape
				etapeCourante = new StructLbEtape();
				
				// Alimentation des diff�rents attributs de l'�tape
				etapeCourante.setIdEtape(String.valueOf(idEtape));
				etapeCourante.setNumeroEtape(rset.getString(2));
				etapeCourante.setTypeEtape(rset.getString(3));
				etapeCourante.setLibelleTypeEtape(rset.getString(4));
				etapeCourante.setLibelleEtape(rset.getString(5));
				
				// Ajout de la nouvelle �tape � la liste
				etapes.put(String.valueOf(idEtape), etapeCourante);
			}
			
			alimenterTache(etapeCourante, rset);
		}
	}
	
	/**
	 * Alimentation de la tache d'une �tape � partir d'une ligne r�sultat resultSet
	 * @param etapeCourante
	 * @param rset
	 * @throws SQLException
	 */
	private void alimenterTache(StructLbEtape etapeCourante, ResultSet rset) throws SQLException {
		StructLbTache tacheCourante;
		
		int idTache = rset.getInt(6);
		
		if (idTache != 0) {
			LinkedHashMap<String, StructLbTache> taches = etapeCourante.getTaches();
			
			if (taches == null) {
				taches = new LinkedHashMap<String, StructLbTache>();
				etapeCourante.setTaches(taches);
			}
			
			// Si la t�che est d�j� dans la liste
			if (taches.containsKey(String.valueOf(idTache))) {
				// R�cup�ration de la t�che
				tacheCourante = taches.get(String.valueOf(idTache));
			}
			// Si la t�che n'est pas encore pr�sente
			else {
				// Instanciation d'une nouvelle t�che
				tacheCourante = new StructLbTache();
				
				// Alimentation des diff�rents attributs de la t�che
				tacheCourante.setIdTache(String.valueOf(idTache));
				tacheCourante.setNumeroTache(rset.getString(7));
				tacheCourante.setLibelleTache(rset.getString(8));
				tacheCourante.setTacheAxeMetier(rset.getString(9));
				
				taches.put(String.valueOf(idTache), tacheCourante);
			}
			
			alimenterSsTache(tacheCourante, rset);
		}
	}

	/**
	 * Alimentation de la sous-tache d'une t�che � partir d'une ligne r�sultat resultSet
	 * @param tacheCourante
	 * @param rset
	 * @throws SQLException 
	 */
	private void alimenterSsTache(StructLbTache tacheCourante, ResultSet rset) throws SQLException {
		StructLbSsTache ssTacheCourante;
		
		int idSsTache = rset.getInt(10);
		
		if (idSsTache != 0) {
			LinkedHashMap<String, StructLbSsTache> ssTaches = tacheCourante.getSsTaches();
			
			if (ssTaches == null) {
				ssTaches = new LinkedHashMap<String, StructLbSsTache>();
				tacheCourante.setSsTaches(ssTaches);
			}
			
			// Si la sous-t�che n'est pas encore pr�sente
			if (!ssTaches.containsKey(String.valueOf(idSsTache))) {
				// Instanciation d'une nouvelle sous-t�che
				ssTacheCourante = new StructLbSsTache();
				
				// Alimentation des diff�rents attributs de la sous-t�che
				ssTacheCourante.setIdSsTache(String.valueOf(idSsTache));
				ssTacheCourante.setNumeroSsTache(rset.getString(11));
				ssTacheCourante.setLibelleSsTache(rset.getString(12));
				
				ssTaches.put(String.valueOf(idSsTache), ssTacheCourante);
			}
		}
	}

	/**
	 * Chargement d'une structure arborescente de ligne BIP dans le formulaire
	 * @param form
	 * @param hParamProc
	 * @return
	 */
	private void chargerStructLb(StructLbForm form, Hashtable hParamProc) {
		String signatureMethode = "StructLbAction-chargerStructLb(StructLbForm form, Hashtable hParamProc)";
		
		JdbcBip jdbc = new JdbcBip(); 
		ParametreProc paramOut;
		Vector vParamOut;
		
		boolean aUneStructure = false;
		
		// Appel de la proc�dure PACK_LISTE_ISAC_ETAPE.a_une_structure avec pour param�tre d�entr�e l�attribut pid du formulaire bipForm
		try {
			vParamOut = jdbc.getResult(hParamProc, configProc, PACK_A_UNE_STRUCTURE);
			
			// R�cup�ration des r�sultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				if (paramOut.getNom().equals(PACK_A_UNE_STRUCTURE_RESULT)) {
					aUneStructure = PACK_A_UNE_STRUCTURE_RESULT_OUI.equals((String) paramOut.getValeur());
				}
			}
		} catch (BaseException be) {
			logBipUser.debug("StructLbAction-chargerStructLb() --> BaseException :"
					+ be, be);
			logBipUser.debug("StructLbAction-chargerStructLb() --> Exception :"
					+ be.getInitialException().getMessage());

			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				String message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				form.setMsgErreur(message);

			} else {
				// Erreur d''ex�cution de la proc�dure stock�e
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
			}

		}
		
		// Si le r�sultat de sortie est � O �
		if (aUneStructure) {
			// Appel de la proc�dure PACK_LISTE_ISAC_ETAPE.get_infos_structure_ligne avec pour param�tre d�entr�e l�attribut pid du formulaire bipForm
			try {
				vParamOut = jdbc.getResult(hParamProc, configProc, PACK_GET_INFOS_STRUCTURE_LIGNE);
				
				// R�cup�ration des r�sultats
				for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
					paramOut = (ParametreProc) e.nextElement();

					// R�cup�ration du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();
					
					// Instanciation d'un objet structLb de type StructLb via l�appel de obtenirStructLb sur le curseur r�sultat
					StructLb structLb = obtenirStructLb(rset);
					
					// Alimentation de la variable structLb du formulaire bipForm
					form.setStructLb(structLb);
				}
			} catch (BaseException be) {
				logBipUser.debug("StructLbAction-chargerStructLb() --> BaseException :"
						+ be, be);
				logBipUser.debug("StructLbAction-chargerStructLb() --> Exception :"
						+ be.getInitialException().getMessage());

				if (be.getInitialException().getClass().getName().equals(
						"java.sql.SQLException")) {
					String message = BipException.getMessageFocus(
							BipException.getMessageOracle(be.getInitialException()
									.getMessage()), form);
					form.setMsgErreur(message);

				} else {
					// Erreur d''ex�cution de la proc�dure stock�e
					errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				}
			}
		}
		
		logBipUser.exit(signatureMethode);
		jdbc.closeJDBC();
	}
	
	/**
		* Action qui permet de passer � la page suivante
		*/
	protected ActionForward suite(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response,
		ActionErrors errors, Hashtable hParamProc)
		throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		HttpSession session = request.getSession(false);
		String sPid = null;
		String sPnom = null;
		String requete = null;
		String requete2 = null;

		String signatureMethode =
			"StructLbAction-suite( mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);

		StructLbForm bipForm = (StructLbForm) form;

		sPid= bipForm.getPid();

		String pidSession = (String) session.getAttribute(PID);
		
		// Si un �l�ment de la liste ligne BIP est s�lection� et si cet �l�ment n'est pas d�j� en session
		if (sPid != null && !sPid.equals(pidSession)) {
			
			//R�cup�rer le libell� de la ligne
			//On r�cup�re la requ�te dans sql.properties	
			requete = config.getString(cle);
			//On r�cup�re le DPG par d�faut 

			requete = requete + "'" + sPid + "'";
			//m�thode qui execute la requete et retourne le libelle
			try {
				sPnom = jdbc.recupererInfo(requete);
				
				//On sauvegarde en session le PID
				session.setAttribute(PID, sPid);
				//On sauvegarde en session le PNOM
				session.setAttribute(PNOM, sPnom );
				
			} catch (BaseException be) {
				logBipUser.debug(
					"StructLbAction-suite() --> BaseException :" + be,
					be);
				logBipUser.debug(
					"StructLbAction-suite()--> Exception :"
						+ be.getInitialException().getMessage());

				logService.debug(
					"StructLbAction-suite() --> BaseException :" + be,
					be);
				logService.debug(
					"StructLbAction-suite() --> Exception :"
						+ be.getInitialException().getMessage());
				errors.add(
					ActionErrors.GLOBAL_ERROR,
					new ActionError("11201"));

				//this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward(redirection_error);
			}
		}
		
		try
		{
//			 pid issu de la request si pr�sent, sinon, issu de la session
			String pidRequete = null;
			if (sPid != null && sPid != "") {
				pidRequete = sPid;
			}
			else {
				pidRequete = pidSession;
			}
			if (pidRequete != null) {
				// on a le pid, on recherche la direction associ�e
				requete = config.getString(cleDirection) + "'" + pidRequete + "'";
				requete2 = config.getString(cleTypproj) + "'" + pidRequete + "'";
				String sDirection = jdbc.recupererInfo(requete);
				String Typproj = jdbc.recupererInfo(requete2);
				bipForm.setDirection(sDirection);
				bipForm.setTypproj(Typproj);
			}
		}
		catch (BaseException be)
		{
			logBipUser.debug(
				"StructLbAction-suite() --> BaseException :" + be,
				be);
			logBipUser.debug(
				"StructLbAction-suite()--> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug(
				"StructLbAction-suite() --> BaseException :" + be,
				be);
			logService.debug(
				"StructLbAction-suite() --> Exception :"
					+ be.getInitialException().getMessage());
			errors.add(
				ActionErrors.GLOBAL_ERROR,
				new ActionError("11201"));

			//this.saveErrors(request,errors);
			 jdbc.closeJDBC(); return mapping.findForward(redirection_error);
		}

		if (sPid == null && pidSession != null) {
			bipForm.setPid(pidSession);
			hParamProc.put("pid", pidSession);
		}
		
		// R�initialisation du radio bouton coch� lors d'un choix de ligne
		bipForm.setBtRadioStructure(null);
		
		// Chargement de la structure
		chargerStructLb(bipForm, hParamProc);
	
		logBipUser.exit(signatureMethode);

		jdbc.closeJDBC(); 
		return mapping.findForward(redirection_intial);
	} //suite
	
	/**
	 * Acc�s � l'�cran de cr�ation d'une �tape / t�che / sous-t�che
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param errors
	 * @param hParamProc
	 * @return
	 */
	public ActionForward creer(
			ActionMapping mapping,
			ActionForm form,
			HttpServletRequest request,
			HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) {
		return rediriger(mapping, form, request);
	}
	
	/**
	 * Acc�s � l'�cran de modification / suppression d'une �tape / t�che / sous-t�che
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param errors
	 * @param hParamProc
	 * @return
	 */
	public ActionForward consulter(
			ActionMapping mapping,
			ActionForm form,
			HttpServletRequest request,
			HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) {		
		return rediriger(mapping, form, request);
	}

	/**
	 * FAD PPM 63773
	 * Acc�s � l'�cran Structure d'une ligne BIP
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param errors
	 * @param hParamProc
	 * @return
	 */
	public ActionForward supprimerStr(
			ActionMapping mapping,
			ActionForm form,
			HttpServletRequest request,
			HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc){
		
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut;
		String flagerreur = null;
		ParametreProc paramOut;

		StructLbForm bipForm = (StructLbForm) form;

		try {
			vParamOut = jdbc.getResult(hParamProc, configProc, PACK_A_UN_CONSOMME);
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				if (paramOut.getNom().equals(PACK_A_UNE_STRUCTURE_RESULT)) {
					flagerreur = (String) paramOut.getValeur();
				}
			}
		} catch (BaseException be) {
			logBipUser.debug("StructLbAction-supprimerStr() --> BaseException :"
					+ be, be);
			logBipUser.debug("StructLbAction-supprimerStr() --> Exception :"
					+ be.getInitialException().getMessage());

			/*if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				String message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				bipForm.setMsgErreur(message);
			} else {
				// Erreur d''ex�cution de la proc�dure stock�e
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
			}*/
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
		}

		if (flagerreur.equals("O"))
		{
			// FAD PPM 65123 : Modification du message d'erreur lors de la suppression de la structure compl�te
			bipForm.setMsgErreur("Suppression interdite car il existe du consomm� attach� � cette ligne BIP." +
					"Il faut d'abord supprimer ce consomm� puis �ventuellement attendre la prochaine mensuelle");
			// FAD PPM 65123 : Fin
		}
		else
		{
			try {
				jdbc.getResult(hParamProc, configProc, PACK_DELETE_STRUCTURE);
			} catch (BaseException be) {
				logBipUser.debug("StructLbAction-supprimerStr() --> BaseException :"
						+ be, be);
				logBipUser.debug("StructLbAction-supprimerStr() --> Exception :"
						+ be.getInitialException().getMessage());

				/*if (be.getInitialException().getClass().getName().equals(
						"java.sql.SQLException")) {
					String message = BipException.getMessageFocus(
							BipException.getMessageOracle(be.getInitialException()
									.getMessage()), form);
					bipForm.setMsgErreur(message);
				} else {
					// Erreur d''ex�cution de la proc�dure stock�e
					errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				}*/
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
			}
		}

		jdbc.closeJDBC();

		return retourChoix(mapping, form, request, response, errors, hParamProc);
	}

	public ActionForward retourChoix(
			ActionMapping mapping,
			ActionForm form,
			HttpServletRequest request,
			HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) {

		String signatureMethode =
			"StructLbAction-retourChoix( mapping, form , request, response, errors, hParamProc )";

		logBipUser.entry(signatureMethode);

		StructLbForm bipForm = (StructLbForm) form;

		chargerStructLb(bipForm, hParamProc);

		logBipUser.exit(signatureMethode);

		return mapping.findForward(redirection_intial);
	}

	/**
	 * Redirection - clic sur un bouton d'administration d'�tape / t�che / sous-t�che dans l'�cran Structure d'une ligne BIP
	 * @param form
	 * @return
	 */
	public ActionForward rediriger(ActionMapping mapping, ActionForm form, HttpServletRequest request) {
		// Initialisation de la redirection : par d�faut, retour � l'�cran de structure
		String redirection = redirection_intial;
		
		if (request.getParameter("boutonCreaManu") != null || request.getParameter("boutonCreaEtape") != null) {
			redirection = redirection_etape;
		}
		else if (request.getParameter("boutonCreaTache") != null) {
			redirection = redirection_tache;
		} 
		else if (request.getParameter("boutonCreaSsTache") != null) {
			redirection = redirection_sous_tache;
		}
		// FAD PPM 63773 : redirection dans le cas d'erreur dans l'action  boutonSupprStr
		/*else if (request.getParameter("boutonSupprimerStr") != null){
			//StructLbForm bipForm = (StructLbForm) form;
			redirection = redirection_intial;
		}*/
		else {
			StructLbForm bipForm = (StructLbForm) form;
			// R�cup�ration du type de radio bouton coch�
			int typeBtRadio = bipForm.getTypeBtRadioStructure();
			
			// S'il s'agit d'une �tape, de la structure compl�te ou d'aucun bouton
			 if (typeBtRadio == StructLbForm.btRadioTypeEtape
					|| typeBtRadio == StructLbForm.btRadioTypeStructComplete
					|| typeBtRadio == StructLbForm.btRadioTypeAucun) {
				redirection = redirection_etape;
			}
			// S'il s'agit d'une t�che
			else if (typeBtRadio == StructLbForm.btRadioTypeTache) {
				redirection = redirection_tache;
			}
			// S'il s'agit d'une sous-t�che
			else if (typeBtRadio == StructLbForm.btRadioTypeSsTache) {
				redirection = redirection_sous_tache;
			}
		}
		
		// Redirection
		return mapping.findForward(redirection);
	}
	
	/**
	 * Retour � l'�cran structure d'une ligne BIP depuis l'�cran d'administration des �tapes / t�ches / sous-t�ches
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param errors
	 * @param hParamProc
	 * @return
	 */
	public ActionForward retour(
			ActionMapping mapping,
			ActionForm form,
			HttpServletRequest request,
			HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) {

		String signatureMethode =
			"StructLbAction-retour( mapping, form , request, response, errors, hParamProc )";
		
		logBipUser.entry(signatureMethode);
		
		StructLbForm bipForm = (StructLbForm) form;
		
		recupererAttributs(bipForm, request);
		chargerStructLb(bipForm, hParamProc);
		
		logBipUser.exit(signatureMethode);

		return mapping.findForward(redirection_intial);
	}
	
	/**
	 * Retour � l'�cran structure d'une ligne BIP depuis l'�cran de structure de ligne BIP
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param errors
	 * @param hParamProc
	 * @return
	 */
	public ActionForward retourInterne(
			ActionMapping mapping,
			ActionForm form,
			HttpServletRequest request,
			HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) {

		String signatureMethode =
			"StructLbAction-retourInterne( mapping, form , request, response, errors, hParamProc )";
		
		logBipUser.entry(signatureMethode);
		
		StructLbForm bipForm = (StructLbForm) form;
		
		// Case coch�e "Structure compl�te"
		bipForm.setBtRadioStructure(StructLbForm.idBtRadioStructureComplete);
		chargerStructLb(bipForm, hParamProc);
		
		logBipUser.exit(signatureMethode);

		return mapping.findForward(redirection_intial);
	}
	
	/**
	 * 	R�cup�ration des attributs de la request et mise � jour du formulaire, 
		car seule la request est transmise lors du changement d'action (pas le formulaire)
	 * @param bipForm
	 * @param request
	 */
	private void recupererAttributs(StructLbForm bipForm, HttpServletRequest request) {
		bipForm.setBtRadioStructure((String) request.getAttribute("btRadioStructure"));
		bipForm.setMsgErreur((String) request.getAttribute("setMsgErreur"));
	}
	
	/**
	 * Cr�ation de ligne d'absence
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param errors
	 * @param hParamProc
	 * @return
	 */
	public ActionForward creerLigneAbsence(
			ActionMapping mapping,
			ActionForm form,
			HttpServletRequest request,
			HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) {
		JdbcBip jdbc = new JdbcBip(); 
		
		StructLbForm bipForm = (StructLbForm) form;
		
		try {
			jdbc.getResult(hParamProc, configProc, PACK_CREER_LIGNE_BIP_ABSENCE);
		} catch (BaseException be) {
			logBipUser.debug("StructLbAction-creerLigneAbsence() --> BaseException :"
					+ be, be);
			logBipUser.debug("StructLbAction-creerLigneAbsence() --> Exception :"
					+ be.getInitialException().getMessage());

			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				String message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				bipForm.setMsgErreur(message);

			} else {
				// Erreur d''ex�cution de la proc�dure stock�e
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
			}
		}  
		
		jdbc.closeJDBC(); 
		
		// retour vers l'�cran initial avec la case structure compl�te coch�e
		return retourInterne(mapping, form, request, response, errors, hParamProc);
	}
	
	/**
	 * Cr�ation de ligne productive hors mode projet
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param errors
	 * @param hParamProc
	 * @return
	 */
	public ActionForward creerLigneProductiveHorsModeProjet(
			ActionMapping mapping,
			ActionForm form,
			HttpServletRequest request,
			HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) {
		JdbcBip jdbc = new JdbcBip(); 
		
		StructLbForm bipForm = (StructLbForm) form;
		
		try {
			jdbc.getResult(hParamProc, configProc, PACK_CREER_LIGNE_BIP_HORS_PROJ);
		} catch (BaseException be) {
			logBipUser.debug("StructLbAction-creerLigneProductiveHorsModeProjet() --> BaseException :"
					+ be, be);
			logBipUser.debug("StructLbAction-creerLigneProductiveHorsModeProjet() --> Exception :"
					+ be.getInitialException().getMessage());

			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				String message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				bipForm.setMsgErreur(message);

			} else {
				// Erreur d''ex�cution de la proc�dure stock�e
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
			}
		}  
		
		jdbc.closeJDBC(); 
		
		// retour vers l'�cran initial avec la case structure compl�te coch�e
		return retourInterne(mapping, form, request, response, errors, hParamProc);
	}
	
	/**
	 * Cr�ation de ligne productive en mode projet
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param errors
	 * @param hParamProc
	 * @return
	 */
	public ActionForward creerLigneProductiveEnModeProjet(
			ActionMapping mapping,
			ActionForm form,
			HttpServletRequest request,
			HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) {
		JdbcBip jdbc = new JdbcBip(); 
		
		StructLbForm bipForm = (StructLbForm) form;
		
		Hashtable hKeyList= bipForm.getHParams();
		// Ajout du mode cr�ation pour renvoyer le jeu de type d'�tape prioritaire
		hKeyList.put("mode", "create");
		
		// Jeu de type d'�tape de la direction
		java.util.ArrayList jeuTypeEtapeDirection = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("jeu", hKeyList);
		
		// Si aucun jeu de type d'�tape prioritaire : anomalie au niveau du param�trage
		if (jeuTypeEtapeDirection == null 
				|| jeuTypeEtapeDirection.isEmpty() 
				|| jeuTypeEtapeDirection.get(0) == null
				|| ((ListeOption) jeuTypeEtapeDirection.get(0)).getCle() == null
				|| "Sans objet".equals(((ListeOption) jeuTypeEtapeDirection.get(0)).getCle())) {
			bipForm.setMsgErreur(StructLbForm.msgErreurAnoParamTypesEtapes);
		}
		else {
			// 1er �l�ment de la liste
			ListeOption jeuPrio = (ListeOption) jeuTypeEtapeDirection.get(0);
			if (jeuPrio != null) {
				String jeuPrioCode = jeuPrio.getCle();
				if (jeuPrioCode != null) {
					hKeyList.put("jeu", jeuPrioCode);
					// R�cup�ration du code et libell� du type d'�tape des �tapes associ�es au jeu de type d'�tape prioritaire
					// Pour chaque r�sultat, cr�ation d'une �tape, t�che et sous-t�che
					try {
						jdbc.getResult(hParamProc, configProc, PACK_CREER_LIGNE_BIP_EN_PROJ);
					} catch (BaseException be) {
						logBipUser.debug("StructLbAction-creerLigneProductiveEnModeProjet() --> BaseException :"
								+ be, be);
						logBipUser.debug("StructLbAction-creerLigneProductiveEnModeProjet() --> Exception :"
								+ be.getInitialException().getMessage());

						if (be.getInitialException().getClass().getName().equals(
								"java.sql.SQLException")) {
							String message = BipException.getMessageFocus(
									BipException.getMessageOracle(be.getInitialException()
											.getMessage()), form);
							bipForm.setMsgErreur(message);

						} else {
							// Erreur d''ex�cution de la proc�dure stock�e
							errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
						}
					}  
				}
			}
		}
		
		jdbc.closeJDBC(); 
		
		// retour vers l'�cran initial avec la case structure compl�te coch�e (si pr�sente)
		return retourInterne(mapping, form, request, response, errors, hParamProc);
	}
	
	
	//HMI - PPM 60709 - $5.3 - QC: 1774
	public ActionForward verifierParametrageDefaut(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws IOException{
		String signatureMethode ="ISAC ETAPE - VerifParamDefault";

		return traitementAjax(PACK_VERIF_PARAM_DEFAUT, signatureMethode, mapping, form, response, hParamProc);
	}
	
	private ActionForward traitementAjax(String cleProc, String signatureMethode, ActionMapping mapping, ActionForm form, HttpServletResponse response, Hashtable hParamProc) throws IOException {
		logBipUser.entry(signatureMethode);
		
		BipForm bipForm = (BipForm) form;
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut;
		ParametreProc paramOut;
		String message = "";
		//TypeEtapeForm typeEtape = (TypeEtapeForm) form;
		//hParamProc.put("type_ligne", typeEtape.getTypeLigne());
		// Appel de la proc�dure
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
				// Erreur d'ex�cution
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
	
	//FIN HMI - PPM 60709 - $5.3 - QC: 1774
}
