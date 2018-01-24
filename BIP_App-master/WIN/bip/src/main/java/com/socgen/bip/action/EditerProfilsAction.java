package com.socgen.bip.action;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.Collection;
import java.util.Date;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.NoSuchElementException;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.upload.FormFile;

import com.socgen.bip.commun.BipConfigRTFE;
import com.socgen.bip.commun.Tools;
import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.commun.form.ReportForm;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.exception.ReportException;
import com.socgen.bip.form.EditerProfilsForm;
import com.socgen.bip.menu.BipMenuManager;
import com.socgen.bip.metier.EnregistrementCsvEditionProfils;
import com.socgen.bip.metier.Job;
import com.socgen.bip.metier.Report;
import com.socgen.bip.metier.ReportManager;
import com.socgen.bip.user.UserBip;
import com.socgen.bip.util.BipUtil;

/**
 * @author RBO le 30/01/2013
 *
 * Action permettant le chargement des profils Bip d'une liste de ressources
 * pages  : mChargerProfil.jsp
 * 
 */


public class EditerProfilsAction extends AutomateAction {
	
	private static String SESSION_EDITION_PROFILS_IDRESSOURCESBIPVALIDES = "editionProfilsIdRessourcesBipValides";
	
	/** Page Profils Bip d'une liste de ressources */
	private static String REDIR_PROFILS_BIP_LISTE_RESS = "ecran";
	
	/** 
	 * 1er élément de l'en-tête du fichier csv
	*/
	private final static String PREMIERE_COLONNE_ENTETE = "ID_RESSBIP";
	/** 
	 * 2ème élément de l'en-tête du fichier csv
	*/
	private final static String DEUXIEME_COLONNE_ENTETE = "ID_RTFE";
	
	/**
	 * Format CSV
	 */
	private final static String CONTENT_TYPE_CSV = "application/vnd.ms-excel";
	private final static String EXTENSION_CSV = "csv";
	/**
	 * Taille max fichier csv : 500 Mo <=> 500000000
	 */
	private final static int TAILLE_MAX_FICHIER_CSV = 500000000;
	
	/**
	 * Valeur maximale du champ idRessourceBip
	 */
	private final static int valeurMaxIdRessourceBip = 100000;
	/**
	 * Longueur maximale du champ idRtfe
	 */
	private final static int longueurMaxIdRtfe = 60;
	/**
	 * Nombre maxilal d'enregistrements erronés à afficher
	 */
	private final static int nbMaxEnregistrementsErrones = 30;
	
	/**
	 * Action déclenchée lors du clic sur "Envoyer au serveur"
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param hParamProc
	 * @return
	 */
	public ActionForward envoyerAuServeur(ActionMapping mapping,
			ActionForm form,
			HttpServletRequest request,
			HttpServletResponse response,
			ActionErrors errors, 
			Hashtable hParamProc) {
		EditerProfilsForm editerProfilsForm = (EditerProfilsForm) form;		
		FormFile fichierCsv = editerProfilsForm.getFichierCsv();

		obtenirFormulaire(fichierCsv, form, request);
		
		return mapping.findForward(REDIR_PROFILS_BIP_LISTE_RESS);	
	}
	
	
	/**
	 * Action déclenchée lors du clic sur "Valider"
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param errors
	 * @param hParamProc
	 * @return
	 * @throws ReportException
	 * @throws IOException
	 */
	 public ActionForward lancerEdition(ActionMapping mapping,
			ActionForm form,
			HttpServletRequest request,
			HttpServletResponse response,
			ActionErrors errors, 
			Hashtable hParamProc) throws ReportException, IOException {
		
		final String signatureMethode = "EditerProfilsAction-lancerEdition()";
		EditerProfilsForm rForm = (EditerProfilsForm) form;
		LinkedList<String> idRessBipValides = (LinkedList<String>) request.getSession().getAttribute(rForm.getNomAttributSessionIdRessValides());
		
		// Si la liste récupérée n'est pas vide
		if (idRessBipValides != null && !idRessBipValides.isEmpty()) {
			String sSchema;
			Hashtable hParamsJob;
			// Chargement de la liste d'utilisateurs à partir de la liste des id
			Collection<UserBip> listeUtilisateurs = BipConfigRTFE.chargerUtilisateurs(idRessBipValides, configProc, errors);
			
			// Liste des jobs
			LinkedList<Job> listeJobs = new LinkedList<Job>();
			
			// Pour chaque utilisateur
			for (final UserBip utilisateur : listeUtilisateurs) {
				// Instanciation d'un nouvel hParams
				hParamsJob = new Hashtable();
				// Alimentation des parametres
				addUserParamToHash(hParamsJob, utilisateur);
				// Ajoute des parametres supplementaires definis
				rForm.putParamsToHash(hParamsJob);
				hParamsJob.put("arborescence", rForm.getArborescence().replaceAll("'", " "));
				
				// Log des hParams
				if (logBipUser.isDebugEnabled())
				{
					logBipUser.debug(signatureMethode + ": hParamsJob :");
					for(Enumeration enums = hParamsJob.keys(); enums.hasMoreElements();)
					{
						String sP = (String)enums.nextElement();
						logBipUser.debug("	" + sP + "	: " + (String)hParamsJob.get(sP));
					}
				}		
					
				sSchema = null;
				try
				{
					// Définition du format de fichier report : pdf
					if (Report.isExtractionMiseEnForme(rForm.getJobId())) {
						hParamsJob.put(Report.PARAM_DESFORMAT, "DELIMITED");
					}
					else {
						hParamsJob.put(Report.PARAM_DESFORMAT, ReportForm.DESFORMAT_PDF);
					}

					sSchema = Report.checkParamJob(rForm.getJobId(), hParamsJob);
					if (sSchema.length() != 0)
					{
						//extraire le vrai shema ...
						sSchema = sSchema.substring("NOM_SCHEMA#".length(), sSchema.length());
						logBipUser.debug("Valeur du shema : " + sSchema);
					}
				}
				catch (ReportException e)
				{
					if (e.getSubType() == ReportException.REPORT_BADPARAM)
					{
						logBipUser.debug("msgErreur : " + BipException.getMessageFocus(e.getMessage(), form));
						rForm.setMsgErreur(BipException.getMessageFocus(e.getMessage(), form));
			
						return new ActionForward(rForm.getInitial());
					}
					//exception non applicative
					errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(""+e.getSubType(), e.getMessage()));	
					logBipUser.info("EditerProfilsAction.lancerEdition: redirection struts : failure");
					return mapping.findForward("failure");
				}
					
				// Ajout du job courant à la liste des jobs à traiter
				listeJobs.add(new Job(rForm.getJobId(), rForm.getListeReportsEnum(), userBip, hParamsJob, sSchema, ReportManager.JOB_ASYNCHRONE_CONCATEN));
			}
			
			// Traitement de la liste des jobs (génération rapport puis concaténation) en asynchrone
			ReportManager.getInstance().addJobsToConcat(listeJobs);
		}
		
		logBipUser.info("EditerProfilsAction.lancerEdition: redirection struts : async");
		return mapping.findForward("async");
	}

	/**
	 * addUserParams va ajouter les P_param à la Hashtable des parametres
	 * @param hParam la hastable qui va se voir ajouter les parametres de l'utilisateur Bip
	 */
	private void addUserParamToHash(Hashtable hParams, UserBip uBip)
	{
		hParams.put("P_param0", uBip.getActeur());		//indique si utilisateur est un clien ou fournisseur
		
		hParams.put("P_param1", uBip.getIdUser());		//idArpege
		// Pôle
		if (uBip.getDpg_Defaut() != null) hParams.put("P_param2", uBip.getDpg_Defaut());
		else hParams.put("P_param2", "");
		//filliale
		if (uBip.getFilCode() != null) hParams.put("P_param3", uBip.getFilCode());
		else hParams.put("P_param3", "");
		//direction
		if (uBip.getClicode_Defaut() != null) hParams.put("P_param4", uBip.getClicode_Defaut());
		else hParams.put("P_param4", "");
		//centre2frais
		if (uBip.getCentre_Frais() != null) hParams.put("P_param5", uBip.getCentre_Frais());
		else hParams.put("P_param5", "");
		
		// Nom
		if (StringUtils.isNotEmpty(uBip.getNom())) {
			hParams.put("P_param6", uBip.getNom());
		}
		
		// Prénom
		if (StringUtils.isNotEmpty(uBip.getPrenom())) {
			hParams.put("P_param7", uBip.getPrenom());
		}
		
		// Menus
		// Construction de la liste des libellés des menus
		String sMenus = "";
		Vector vMenus = uBip.getListeMenuConfig();
		if (vMenus != null) {
			for (int i=0; i < vMenus.size(); i++)
			{
				if (i == (vMenus.size()-1)) {
					sMenus += vMenus.get(i);
				}
				else {
					sMenus += vMenus.get(i) + ";";
				}
			}
		    
		    sMenus = com.socgen.bip.commun.Tools.remplaceQuoteEspace(sMenus);
		}
		if (StringUtils.isNotEmpty(sMenus)) {
			hParams.put("P_param8", sMenus);
		}
		
		// Sous-menus
		// Construction de la liste des libellés des sous-menus
		String sSSMenus = "";
		Vector vSSMenus = BipMenuManager.getInstance().getListeBipItemConfig(uBip.getSousMenus());
		if (vSSMenus != null)
		for (int i=0; i < vSSMenus.size(); i++)
		{
			if (i == (vSSMenus.size()-1))
				sSSMenus += vSSMenus.get(i);
			else
				sSSMenus += vSSMenus.get(i) + ";";
		}
	    sSSMenus = com.socgen.bip.commun.Tools.remplaceQuoteEspace(sSSMenus);
	    if (StringUtils.isNotEmpty(sSSMenus)) {
	    	hParams.put("P_param9", sSSMenus);
	    }
	    	
	    // Construction de la liste des CA du suivi des investissements
	    String sCA = "";
	    java.util.Vector vCA = uBip.getCa_suivi();
		if (vCA != null && vCA.size() > 0)
		{
			for (int i=0; i< vCA.size(); i++)
			{
				if (i == (vCA.size()-1))
					sCA += (String)vCA.get(i);
				else
					sCA += (String)vCA.get(i) + ",";
			}
		}
		if (StringUtils.isNotEmpty(sCA)) {
			hParams.put("P_param10", sCA);
		}
		
		if (StringUtils.isNotEmpty(uBip.getListe_Centres_Frais())) {
			hParams.put("P_param11", uBip.getListe_Centres_Frais());
		}
		
		if (StringUtils.isNotEmpty(uBip.getInfosUser())) {
			hParams.put("P_global", uBip.getInfosUser());
		}
	}	
	
	/**
	 * Obtention du formulaire suite au chargement d'un flux
	 * @param fichier
	 * @return
	 * @throws IOException 
	 * @throws FileNotFoundException 
	 */
	private EditerProfilsForm obtenirFormulaire(final FormFile fichier, ActionForm form, HttpServletRequest request) {
		EditerProfilsForm editerProfilsForm = (EditerProfilsForm) form;
		
		try {
			String contentTypeFichier = fichier.getContentType();
			String nomFichier = fichier.getFileName();
			int tailleFichier = fichier.getFileSize();
			LinkedList listeElementsLignes = null;
			
			// Vérification du format de fichier
			String messageFichierTechniquementInvalide = estFormatEtTailleFichierSerieRessourcesValide(nomFichier, contentTypeFichier, tailleFichier);
			
			// Si le format de fichier est valide
			if (messageFichierTechniquementInvalide == null) {
				listeElementsLignes = BipUtil.obtenirListeElementsLignesFichierCsv(fichier);
				
				// Vérification de la validité technique du fichier
				messageFichierTechniquementInvalide = estFichierSerieRessourcesTechniquementValide(listeElementsLignes);
			}
			
			editerProfilsForm.setMessageFichierTechniquementInvalide(messageFichierTechniquementInvalide);
			
			// Si le fichier est techniquement valide
			if (messageFichierTechniquementInvalide == null) {
				Iterator iterateur = listeElementsLignes.iterator();
				String[] listeElementsLigne;
				
				// En-tête
				iterateur.next(); 
				
				//	Vérification de chaque enregistrement
				while (iterateur.hasNext()) {
					listeElementsLigne = (String[]) iterateur.next();
					if (listeElementsLigne != null && listeElementsLigne.length <= 2) {
						// 1ère colonne
						String idRessourceBip = null;
						
						if (listeElementsLigne.length > 0) {
							idRessourceBip = listeElementsLigne[0];
							if (idRessourceBip != null) {
								idRessourceBip = StringUtils.trim(idRessourceBip);
							}
						}
						
						// 2ème colonne
						String idRtfe = null;
						
						if (listeElementsLigne.length == 2) {
							// 2ème colonne
							idRtfe = listeElementsLigne[1];
							if (idRtfe != null) {
								idRtfe = StringUtils.trim(idRtfe);
							}
						}
						
						EnregistrementCsvEditionProfils enregistrement = new EnregistrementCsvEditionProfils(idRessourceBip, idRtfe);
						traiterEnregistrement(enregistrement, editerProfilsForm);
					}
				}
			}
		} catch (FileNotFoundException e) {
			logBipUser.error(EditerProfilsForm.ERREUR_FICHIER_NON_TROUVE, e);
			editerProfilsForm.setMsgErreur(EditerProfilsForm.ERREUR_FICHIER_NON_TROUVE);
		} catch (IOException iOE) {
			logBipUser.error("", iOE);
			editerProfilsForm.setMsgErreur("");
		}
		
		// Alimentation des champs autocalculés du formulaire
		editerProfilsForm.alimenterChampsCalcules();
		
		// Alimentation en session de la liste des id ressource Bip valides
		alimenterIdRessBipValidesSession(editerProfilsForm, request);
		
		return editerProfilsForm;
	}
	
	/**
	 * Alimentation en session de la liste des id ressource Bip valides
	 * @param editerProfilsForm
	 * @param request
	 */
	private void alimenterIdRessBipValidesSession(EditerProfilsForm editerProfilsForm, HttpServletRequest request) {
		// Si statut OK
		if (EditerProfilsForm.statutOk.equals(editerProfilsForm.getStatut())) {
			// Nouveau nom de l'attribut de session liste des id ressource Bip valides
			String nomAttributSessionIdRessValides = SESSION_EDITION_PROFILS_IDRESSOURCESBIPVALIDES + new Date().getTime();
			// Alimentation de la session avec la liste d'identifiants ressource Bip valides
			request.getSession().setAttribute(nomAttributSessionIdRessValides, editerProfilsForm.getIdRessBipValides());
			// Alimentation du formulaire avec le nom de la liste passée en session
			editerProfilsForm.setNomAttributSessionIdRessValides(nomAttributSessionIdRessValides);
		}
	}

	
	/**
	 * Mise à jour du formulaire en fonction de l'enregistrement (OK / KO)
	 * @param enregistrement
	 * @param editerProfilsForm
	 */
	private void traiterEnregistrement(EnregistrementCsvEditionProfils enregistrement, EditerProfilsForm editerProfilsForm) {
		boolean enregistrementValide = estEnregistrementValide(enregistrement, editerProfilsForm);
		
		// Enregistrement OK
		if (enregistrementValide) {
			traitementEnregistrementValide(editerProfilsForm);
		}
		// Enregistrement KO
		else {
			traitementEnregistrementErrone(enregistrement, editerProfilsForm);
		}
	}
	
	/**
	 * Vérification de la validité d'un enregistrement
	 * @param idRessourceBip
	 * @param idRtfe
	 * @return
	 */
	private boolean estEnregistrementValide(EnregistrementCsvEditionProfils enregistrement, EditerProfilsForm editerProfilsForm) {
		boolean retour = false;
		
		// Prioriser l'idRtfe : si l'identifiant rtfe est renseigné, 
		// il doit être une chaine de caractères ne contenant pas d'espace et ne dépassant pas 60 caractères
		// et être habilité BIP
		if ((enregistrement.getIdRtfe() != null && !enregistrement.getIdRtfe().contains(" "))) {
			if (enregistrement.getIdRtfe().length() <= longueurMaxIdRtfe) {
				retour = BipConfigRTFE.estHabiliteBip(enregistrement.getIdRtfe(), configProc);
				if (retour) {
					// Ajout de l'identifiant RTFE à la liste des éléments valides
					editerProfilsForm.getIdRessBipValides().add(enregistrement.getIdRtfe());
				}
			}
		}
		// Sinon, si l’identifiant Bip est renseigné, 
		// il doit être un entier sur 5 chiffres 
		// et être habilité BIP
		else if ((enregistrement.getIdRessourceBip() != null && !enregistrement.getIdRessourceBip().contains(" "))) {
			int idRessourceBipEntier;
			try {
				idRessourceBipEntier = Integer.parseInt(enregistrement.getIdRessourceBip());
				if (idRessourceBipEntier < valeurMaxIdRessourceBip) {
					LinkedList<String> listeIdsBip = BipConfigRTFE.chargerIdsRtfeFromIdBip(idRessourceBipEntier, configProc, errors);
					// Ajout de(s) (l')identifiant(s) à la liste des éléments valides
					editerProfilsForm.getIdRessBipValides().addAll(listeIdsBip);
					retour = listeIdsBip != null && !listeIdsBip.isEmpty();
				}
			}
			catch (NumberFormatException e) {

			}
		}
		
		return retour;
	}
	
	/**
	 * - Si la taille de la liste « enregistrementsErrones »  est strictement inférieure à 30, 
	 * ajout à la variable « enregistrementsErrones » le couple correspondant à l’enregistrement 
	 * - Incrémenter la variable « nbEnregistrementsNonIdentifies »
	 * @param idRessourceBip
	 * @param idRtfe
	 * @param editerProfilsForm
	 */
	private void traitementEnregistrementErrone(EnregistrementCsvEditionProfils enregistrement, EditerProfilsForm editerProfilsForm) {
		if (editerProfilsForm.getNbEnregistrementsErrones() < nbMaxEnregistrementsErrones) {
			editerProfilsForm.ajouterEnregistrementErrone(enregistrement);
		}
		
		editerProfilsForm.incrementerNbEnregistrementsNonIdentifiesBip();
	}
	
	/**
	 * Incrémentation de la variable « nbEnregistrementsIdentifies »
	 * @param enregistrement
	 * @param editerProfilsForm
	 * @param request
	 */
	private void traitementEnregistrementValide(EditerProfilsForm editerProfilsForm) {
		editerProfilsForm.incrementerNbEnregistrementsIdentifiesBip();
	}
	
	
	
	/**
	 * Vérification de la validité technique du fichier
	 * @param fichier : fichier chargé
	 * @return : éventuel message d'erreur
	 */
	private String estFichierSerieRessourcesTechniquementValide(LinkedList listeElementsLignes) {
		String retour = null;
		
		// Vérification de l’en-tête du fichier : la 1ère ligne doit contenir uniquement les deux valeurs suivantes : « ID_RESSBIP » et « ID_RTFE »
		if (! estEnteteValide(listeElementsLignes)) {
			retour = EditerProfilsForm.ERREUR_PROBLEME_EN_TETE;
		}
		// Vérification que les enregistrements comportent au plus un code ress Bip et un identifiant RTFE : 
		// les lignes suivant l’en-tête doivent contenir au plus deux valeurs (si aucune valeur n’est renseignée, la ligne est considérée comme valide, ne contenant aucune donnée)
		else if (! sontEnregistrementsTechniquementValides(listeElementsLignes)) {
			retour = EditerProfilsForm.ERREUR_PROBLEME_ENREGISTREMENT;
		}
		
		return retour;
	}
	
	/**
	 * Vérification du type et de la taille du fichier
	 * @param nomFichier
	 * @param contentTypeFichier
	 * @param tailleFichier
	 * @return un message éventuel d'erreur
	 */
	private String estFormatEtTailleFichierSerieRessourcesValide(String nomFichier, String contentTypeFichier, int tailleFichier) {
		String retour = null;
		
		logBipUser.info(nomFichier + " : " + contentTypeFichier);
		
		String extensionFichier = null;
		if (nomFichier != null) {
			String[] nomFichierSplitted = nomFichier.split("\\.");
			extensionFichier = nomFichierSplitted[nomFichierSplitted.length - 1];
		}
		
		// Vérification du format et de l'extension de fichier
		if (!CONTENT_TYPE_CSV.equals(contentTypeFichier) || !EXTENSION_CSV.equalsIgnoreCase(extensionFichier)) {
			retour = EditerProfilsForm.ERREUR_PROBLEME_FORMAT;
		}
		
		if (tailleFichier > TAILLE_MAX_FICHIER_CSV) {
			retour = EditerProfilsForm.ERREUR_TAILLE_FICHIER;
		}
		
		return retour;
	}
	
	/**
	 * Vérification de l’en-tête du fichier : la 1ère ligne doit contenir uniquement les deux valeurs suivantes : « ID_RESSBIP » et « ID_RTFE »
	 * @param listeElementsLignes
	 * @return
	 */
	private boolean estEnteteValide(final LinkedList listeElementsLignes) {
		boolean retour = false;
		
		try {
			if (listeElementsLignes != null) {
				String[] listeElementsLigne = (String[]) listeElementsLignes.getFirst();
				if (listeElementsLigne != null && listeElementsLigne.length == 2)
				{
					retour = listeElementsLigne[0].trim().equals(PREMIERE_COLONNE_ENTETE) && listeElementsLigne[1].trim().equals(DEUXIEME_COLONNE_ENTETE);
				}
			}
		}
		catch (NoSuchElementException e) {
			
		}
		
		return retour;
	}
	
	/**
	 * Vérification que les enregistrements comportent au plus un code ress Bip et un identifiant RTFE : 
	 * les lignes suivant l’en-tête contiennent au plus deux valeurs 
	 * (si aucune valeur n’est renseignée, la ligne est considérée comme valide, ne contenant aucune donnée)
	*/
	private boolean sontEnregistrementsTechniquementValides(final LinkedList listeElementsLignes) {
		boolean retour = true;
		
		// S'il y a au moins un enregistrement
		if (listeElementsLignes.size() >= 2) {
			Iterator iterateur = listeElementsLignes.iterator();
			String[] listeElementsLigne;
			// En-tête
			iterateur.next(); 
			// Chaque ligne suivant l'en-tête doit contenir au plus 2 éléments
			while (iterateur.hasNext()) {
				listeElementsLigne = (String[]) iterateur.next();
				if (listeElementsLigne.length > 2) {
					retour = false;
					break;
				}
			}
		}
		// Cas de la présence d'aucun enregistrement
		else if (listeElementsLignes.size() < 2) {
			retour = false;
		}
		
		return retour;
	}
}
	 