package com.socgen.bip.action;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Vector;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.upload.FormFile;

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.Tools;
import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.LoadTableRepartForm;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author J. MAS - 07/11/2005
 *
 * Action de chargement des tables de répartition 
 * chemin : Administration/Lignes BIP/Répartition JH/Chargement
 * pages  : rLoadTableRepart.jsp
 * pl/sql : 
 */
public class LoadTableRepartAction extends AutomateAction implements BipConstantes {

	public final static String CONTENT_TYPE_ZIP = "application/x-zip-compressed";
	public final static String CONTENT_TYPE_TXT = "text/plain";
	public final static String CONTENT_TYPE_DATA = "application/octet-stream";

	public final static String SEPARATEUR = ";";
	public final static int NB_DECIMAL = 5;

	private static String PACK_INSERT = "rjh_load_tr.creer.proc";
	private static String PACK_INSERT_ERREUR = "rjh_load_tr.creer_erreur.proc";
	private static String PACK_TEST = "rjh_load_tr.control.proc";
	private static String PACK_INSERT_DETAIL = "rjh_load_tr.insert_detail.proc";
	private static String PACK_DELETE = "rjh_load_tr.supprimer_detail.proc";
	private static String PACK_SELECT_EXERC = "rjh_load_tr.select_exercice.proc";
	private static String PACK_DUPLICATE = "rjh_load_tr.dupliquer_mois.proc";
	private static String PACK_UPDATE = "rjh_load_tr.modifier.proc";

	private String p_codchr;
	
	
	/**
	* Action qui permet de passer à la page suivante
	*/
	protected ActionForward suite(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response,
		ActionErrors errors,
		Hashtable hParamProc)
		throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";

		String signatureMethode = "LoadTableRepartAction-suite()";
		logBipUser.entry(signatureMethode);

		LoadTableRepartForm uploadForm = (LoadTableRepartForm) form;

		// ----------------------------------------------------------
		//         On récupère l'année de l'exercice en cours
		// ----------------------------------------------------------
		try {
			vParamOut = jdbc.getResult(hParamProc, configProc, PACK_SELECT_EXERC);
			try {
				message = jdbc.recupererResult(vParamOut, "valider");
			} catch (BaseException be) {
				logBipUser.debug(signatureMethode + " --> BaseException :" + be);
				logBipUser.debug(signatureMethode + " --> Exception :" + be.getInitialException().getMessage());
				logService.debug(signatureMethode + " --> BaseException :" + be);
				logService.debug(signatureMethode + " --> Exception :" + be.getInitialException().getMessage());
				//Erreur de lecture du resultSet
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
			}
			if ((message != null) && (!message.equals(""))) {
				((LoadTableRepartForm) form).setMsgErreur(message);
				logBipUser.debug("message d'erreur:" + message);
				logBipUser.exit(signatureMethode);
				//on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}//if
			try {
				uploadForm.setDatdebex(Integer.parseInt((String) ((ParametreProc) vParamOut.elementAt(2)).getValeur()));
			} catch (NumberFormatException nfe) {
				logBipUser.error(signatureMethode + " --> Exception :" + nfe);
				logService.error(signatureMethode + " --> Exception :" + nfe);
				((LoadTableRepartForm) form).setMsgErreur("Problème lors de la récupération de l'exercice courant.");
			}
		} catch (BaseException be) {
			logBipUser.debug(signatureMethode + " --> BaseException :" + be);
			logBipUser.debug(signatureMethode + " --> Exception :" + be.getInitialException().getMessage());
			logService.debug(signatureMethode + " --> BaseException :" + be);
			logService.debug(signatureMethode + " --> Exception :" + be.getInitialException().getMessage());
			//Si exception sql alors extraire le message d'erreur du message global
			if (be.getInitialException().getClass().getName().equals("java.sql.SQLException")) {
				message =
					BipException.getMessageFocus(BipException.getMessageOracle(be.getInitialException().getMessage()), form);
				((LoadTableRepartForm) form).setMsgErreur(message.replace('\n', ' '));
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			} else {
				//Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException().getMessage());
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}//catch

		logBipUser.exit(signatureMethode);
		 jdbc.closeJDBC(); return mapping.findForward("initial");

	} //suite

	/**
	 * Action qui permet de charger un fichier de table de répartition
	 */
	protected ActionForward creer(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response,
		ActionErrors errors,
		Hashtable hParamProc)
		throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		int nb_fichier = 0;
		boolean fileHasError = false;
		boolean fileHasOnlyInfo = false;

		String signatureMethode = "LoadTableRepartAction-creer( mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);

		LoadTableRepartForm uploadForm = (LoadTableRepartForm) form;
		FormFile fichier = uploadForm.getNomfichier();
		String msgErr;
		String msgInfo = "";
		Vector vLignes = null;
		p_codchr = null;

		logBipUser.info("Fichier Table de répartition à charger : " + fichier.getFileName() + " : " + fichier.getContentType());

		try {
			//retrieve the file data
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			InputStream stream = fichier.getInputStream();

			byte[] buffer = new byte[8192];
			int bytesRead = 0;
			while ((bytesRead = stream.read(buffer, 0, 8192)) != -1) {
				baos.write(buffer, 0, bytesRead);
			}
			baos.flush();

			// on a récupérer le flux
			// maintenant on va mettre le fichier dans un Vecteur vLignes
			if (fichier.getContentType().equals(CONTENT_TYPE_ZIP)) {
				// Si c'est un fichier ZIP
				vLignes = new Vector();
				ZipEntry zip;
				ZipInputStream zipIS = new ZipInputStream(new ByteArrayInputStream(baos.toByteArray()));

				logBipUser.info(
					"ETAT MEMOIRE : "
						+ Runtime.getRuntime().freeMemory()
						+ " taille zip : "
						+ baos.size()
						+ " / "
						+ baos.size() * 4);

				if (Runtime.getRuntime().freeMemory() < baos.size() * 4)
					msgInfo =
						"\\n\\nAttention : le serveur est actuellement très chargé, il est possible que le fichier ne soit pas correctement traité\\nS'il a un statut \'En Erreur\', vous devrez le recharger à nouveau";

				try {
					while ((zip = zipIS.getNextEntry()) != null) {
						if (zip.isDirectory())
							continue;
						nb_fichier++;
						try {
							Vector vLignesTemps = Tools.stream2Vector(zipIS);
							for (Enumeration ve=vLignesTemps.elements(); ve.hasMoreElements();)
								vLignes.add(ve.nextElement());
						} catch (IOException iOE) {
							vLignes = null;
						}
					}
					zipIS.close();
				} catch (IOException iOE) {
					logBipUser.error("problème dans le flux zip " + fichier.getFileName(), iOE);
					uploadForm.setMsgErreur("Erreur dans le fichier ZIP, veuillez le regénérer puis le recharger.");
				}

			} else {
				nb_fichier++;
				InputStream iS = new ByteArrayInputStream(baos.toByteArray());
				vLignes = Tools.stream2Vector(iS);
				iS.close();
			}

		} catch (IOException iOE) {
			logBipUser.error("", iOE);
			uploadForm.setMsgErreur("Erreur dans le fichier CSV, veuillez vérifier que c'est bien un fichier texte.");
		}

		if (nb_fichier > 1) {
			msgInfo =
				"\nLe fichier ZIP chargé contient "
					+ nb_fichier
					+ " fichiers différents. Ils ont tous été concaténés en un seul.";
		}

		// --------------------------------------------------------------
		//   s'il n'y a pas eu de message d'erreur on traite le fichier
		// --------------------------------------------------------------
		if ((uploadForm.getMsgErreur() == null) || (uploadForm.getMsgErreur().length() == 0)) {

			//  On enregistre le nouveau chargement dans la table RJH_CHARGEMENT
			hParamProc.put("nomfichier_data", fichier.getFileName());
			int retour_insert = majTableChargement("insert", null, null, hParamProc, form, request);

			if (retour_insert == 1)
			{	
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
			if (retour_insert == 2)
			{	
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}	 

			String lLigne = "";
			String libLigneRep = "";
			String pid = "";
			String taux = "";
			String ca = "";
			int numLigne = 1;
			boolean hasErreur = false;
			boolean hasInfo = false;
			Vector msgErreur = null;
			float tauxTotal = 0;

			// -----------------------------------------------------------------------------------
			//         Suppression des lignes de répartion pour la table et le mois donnés
			// -----------------------------------------------------------------------------------
			try {
				hParamProc.put("aff_msg", "NON");
				vParamOut = jdbc.getResult(hParamProc, configProc, PACK_DELETE);
				try {
					message = jdbc.recupererResult(vParamOut, "valider");
				} catch (BaseException be) {
					logBipUser.debug(signatureMethode + " --> BaseException :" + be);
					logBipUser.debug(signatureMethode + " --> Exception :" + be.getInitialException().getMessage());
					logService.debug(signatureMethode + " --> BaseException :" + be);
					logService.debug(signatureMethode + " --> Exception :" + be.getInitialException().getMessage());
					//Erreur de lecture du resultSet
					errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));

					// on met le fichier en erreur
					retour_insert = majTableChargement("update", p_codchr, "9", hParamProc, form, request);
					if (retour_insert == 1)
					{
						 jdbc.closeJDBC(); return mapping.findForward("initial");
					}
					if (retour_insert == 2)
					{	
						 jdbc.closeJDBC(); return mapping.findForward("error");
					}	 
				}//catch
				if ((message != null) && (!message.equals(""))) {
					((LoadTableRepartForm) form).setMsgErreur(message);
					logBipUser.debug("message d'erreur:" + message);

					// on met le fichier en erreur
					retour_insert = majTableChargement("update", p_codchr, "9", hParamProc, form, request);
					if (retour_insert == 1)
					{
						 jdbc.closeJDBC(); return mapping.findForward("initial");
					}
					if (retour_insert == 2)
					{
						 jdbc.closeJDBC(); return mapping.findForward("error");
					}

					logBipUser.exit(signatureMethode);
					//on reste sur la même page
					 jdbc.closeJDBC(); return mapping.findForward("initial");
				}//if
			} catch (BaseException be) {
				logBipUser.debug(signatureMethode + " --> BaseException :" + be);
				logBipUser.debug(signatureMethode + " --> Exception :" + be.getInitialException().getMessage());
				logService.debug(signatureMethode + " --> BaseException :" + be);
				logService.debug(signatureMethode + " --> Exception :" + be.getInitialException().getMessage());
				
				// on met le fichier en erreur
				retour_insert = majTableChargement("update", p_codchr, "9", hParamProc, form, request);
				if (retour_insert == 1)
				{	
					 jdbc.closeJDBC(); return mapping.findForward("initial");
				}
				if (retour_insert == 2)
				{
					 jdbc.closeJDBC(); return mapping.findForward("error");
				}
					
				//Si exception sql alors extraire le message d'erreur du message global
				if (be.getInitialException().getClass().getName().equals("java.sql.SQLException")) {
					message =
						BipException.getMessageFocus(BipException.getMessageOracle(be.getInitialException().getMessage()), form);
					((LoadTableRepartForm) form).setMsgErreur(message.replace('\n', ' '));
					 jdbc.closeJDBC(); return mapping.findForward("initial");
				} else {
					//Erreur d''exécution de la procédure stockée
					errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
					request.setAttribute("messageErreur", be.getInitialException().getMessage());
					 jdbc.closeJDBC(); return mapping.findForward("error");
				}//else
			}//catch

			// -----------------------------------------------
			//         Traitement ligne par ligne
			// -----------------------------------------------
			for (Enumeration ve = vLignes.elements(); ve.hasMoreElements();) {

				// si on a déjà eu une erreur bloquante (Séparateur manquant)
				if (hasErreur || hasInfo) {
					retour_insert = insertErreur(p_codchr, numLigne, lLigne, msgErreur, hParamProc, form, request);
					if (retour_insert == 1)
					{	
						 jdbc.closeJDBC(); return mapping.findForward("initial");
				    }
					if (retour_insert == 2)
					{
						 jdbc.closeJDBC(); return mapping.findForward("error");
					}
					numLigne++;
				}

				lLigne = (String) ve.nextElement();
				libLigneRep = "";
				pid = "";
				taux = "";
				ca = "";
				hasErreur = false;
				hasInfo = false;
				msgErreur = new Vector();

				// test existance du séparateur pour le libellé
				int posf_lib = lLigne.indexOf(SEPARATEUR);
				if (posf_lib == -1) {
					msgErreur.add("Il manque des séparateurs " + SEPARATEUR);
					hasErreur = true;
					// c'est une erreur bloquante donc on ne traite pas les autres tests
					continue;
				} else {
					libLigneRep = lLigne.substring(0, posf_lib);
					// test existance du libellé
					if (libLigneRep.length() == 0) {
						msgErreur.add("Le libellé est obligatoire.");
						hasErreur = true;
					}
				}
				// test existance du séparateur pour le taux
				int posf_taux = lLigne.indexOf(SEPARATEUR, posf_lib + 1);
				if (posf_taux == -1) {
					msgErreur.add("Il manque des séparateurs " + SEPARATEUR);
					hasErreur = true;
					// c'est une erreur bloquante donc on ne traite pas les autres tests
					continue;
				} else {
					taux = lLigne.substring(posf_lib + 1, posf_taux);
					// test existance du taux
					if (taux.length() == 0) {
						msgErreur.add("Le Taux est obligatoire.");
						hasErreur = true;
					}
				}
				// test existance du séparateur pour le PID
				int posf_pid = lLigne.indexOf(SEPARATEUR, posf_taux + 1);
				if (posf_pid == -1) {
					msgErreur.add("Il manque des séparateurs " + SEPARATEUR);
					hasErreur = true;
					// c'est une erreur bloquante donc on ne traite pas les autres tests
					continue;
				} else {
					pid = lLigne.substring(posf_taux + 1, posf_pid);
					// test existance du PID
					if (pid.length() == 0) {
						msgErreur.add("Le code ligne BIP est obligatoire.");
						hasErreur = true;
					}
				}
				// test existance du séparateur pour le CA
				int posf_ca = lLigne.indexOf(SEPARATEUR, posf_pid + 1);
				if (posf_ca == -1) {
					ca = lLigne.substring(posf_pid + 1);
				} else {
					ca = lLigne.substring(posf_pid + 1, posf_ca);

					// test existance du CA
					if (ca.length() == 0) {
						msgErreur.add("Le CA est obligatoire.");
						hasErreur = true;
					}

					if (lLigne.length() > (posf_ca + 1)) {
						msgErreur.add("Remarque : La ligne contient des informations en trop : " + lLigne.substring(posf_ca + 1));
						hasInfo = true;
						fileHasOnlyInfo = true;
					}
				}

				// ----------------------------------------------
				//              Test sur les taux
				// ----------------------------------------------
				try {
					float ft = 0;
					try {
						ft = Float.parseFloat(taux.replace(',', '.'));
					} catch (NumberFormatException nf) {
						ft = Float.parseFloat(taux.replace('.', ','));
					}
					// ----------------------------------------------
					//              Test taux entre 0 et 1
					// ----------------------------------------------
					if ((ft < 0) || (ft > 1)) {
						msgErreur.add("Le taux doit être compris entre 0 et 1.");
						hasErreur = true;
					} else {

						// ----------------------------------------------------------------------------
						//     Test de la précision du taux NB_DECIMAL chiffres après la décimale
						// ----------------------------------------------------------------------------
						String t = rtrimZero(taux.replace(',', '.'));
						int pos_v = t.indexOf(".");
						if (pos_v > -1) {
							t = t.substring(pos_v + 1);
							if (t.length() > NB_DECIMAL) {
								msgErreur.add(
									"La précision du taux est trop grande, seul "
										+ NB_DECIMAL
										+ " chiffres sont autorisés après la virgule.");
								hasErreur = true;
							}
						} else {
							// ----------------------------------
							//         Test si taux = 0
							// ----------------------------------
							if (ft == 0) {
								msgErreur.add("Remarque : attention le taux est égal à 0.");
								hasInfo = true;
								fileHasOnlyInfo = true;
							}
						}

						// Calcul du taux total de la table
						tauxTotal += ft;
					}

				} catch (NumberFormatException nfe) {
					msgErreur.add("Le taux n'est pas au bon format.");
					hasErreur = true;
				} // FIN test Taux

				// ----------------------------------
				//         Test ligne BIP et CA
				// ----------------------------------
				try {
					hParamProc.put("codcamo", ca);
					hParamProc.put("pid", pid);
					vParamOut = jdbc.getResult(hParamProc, configProc, PACK_TEST);

					message = (String) ((ParametreProc) vParamOut.elementAt(1)).getValeur();
					String sInfo = (String) ((ParametreProc) vParamOut.elementAt(2)).getValeur();
					String sErreur = (String) ((ParametreProc) vParamOut.elementAt(3)).getValeur();

					if (sInfo.equalsIgnoreCase("true")) {
						hasInfo = true;
						fileHasOnlyInfo = true;
					}
					if (sErreur.equalsIgnoreCase("true"))
						hasErreur = true;
					if ((message != null) && (message.length() > 0))
						msgErreur.add(message);

				} catch (BaseException be) {
					logBipUser.debug(signatureMethode + " --> BaseException :" + be);
					logBipUser.debug(signatureMethode + " --> Exception :" + be.getInitialException().getMessage());
					logService.debug(signatureMethode + " --> BaseException :" + be);
					logService.debug(signatureMethode + " --> Exception :" + be.getInitialException().getMessage());

					// on met le fichier en erreur
					retour_insert = majTableChargement("update", p_codchr, "9", hParamProc, form, request);
					if (retour_insert == 1)
					{
						 jdbc.closeJDBC(); return mapping.findForward("initial");
					}
					if (retour_insert == 2)
					{
						 jdbc.closeJDBC(); return mapping.findForward("error");
					}
					
					//Si exception sql alors extraire le message d'erreur du message global
					if (be.getInitialException().getClass().getName().equals("java.sql.SQLException")) {
						message =
							BipException.getMessageFocus(
								BipException.getMessageOracle(be.getInitialException().getMessage()),
								form);
						((LoadTableRepartForm) form).setMsgErreur(message.replace('\n', ' '));
						 jdbc.closeJDBC(); return mapping.findForward("initial");
					} else {
						//Erreur d''exécution de la procédure stockée
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
						request.setAttribute("messageErreur", be.getInitialException().getMessage());
						 jdbc.closeJDBC(); return mapping.findForward("error");
					}
				}
				// ----------------------------------------
				//       FIN  des Test ligne BIP et CA
				// ----------------------------------------

				// -------------------------------------------------------------------------------------------------
				//        SUCCES --> on sauvegarde la ligne dans la table RJH_TABREPART_DETAIL
				// -------------------------------------------------------------------------------------------------
				if (!hasErreur) {
					try {
						hParamProc.put("taux", taux.replace('.', ','));
						hParamProc.put("liblignerep", libLigneRep);
						vParamOut = jdbc.getResult(hParamProc, configProc, PACK_INSERT_DETAIL);
						try {
							message = jdbc.recupererResult(vParamOut, "valider");
						} catch (BaseException be) {
							logBipUser.debug(signatureMethode + " --> BaseException :" + be);
							logBipUser.debug(signatureMethode + " --> Exception :" + be.getInitialException().getMessage());
							logService.debug(signatureMethode + " --> BaseException :" + be);
							logService.debug(signatureMethode + " --> Exception :" + be.getInitialException().getMessage());
							//Erreur de lecture du resultSet
							errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));

							// on met le fichier en erreur
							retour_insert = majTableChargement("update", p_codchr, "9", hParamProc, form, request);
							if (retour_insert == 1)
							{
								 jdbc.closeJDBC(); return mapping.findForward("initial");
							}
							if (retour_insert == 2)
							{
								 jdbc.closeJDBC(); return mapping.findForward("error");
							}
					
						}
						if ((message != null) && (!message.equals(""))) {
							// Code chargement-ligne déjà existant, on récupère le message 
							msgErreur.add(message);
							hasErreur = true;
						}
					} catch (BaseException be) {
						logBipUser.debug(signatureMethode + " --> BaseException :" + be);
						logBipUser.debug(signatureMethode + " --> Exception :" + be.getInitialException().getMessage());
						logService.debug(signatureMethode + " --> BaseException :" + be);
						logService.debug(signatureMethode + " --> Exception :" + be.getInitialException().getMessage());

						// on met le fichier en erreur
						retour_insert = majTableChargement("update", p_codchr, "9", hParamProc, form, request);
						if (retour_insert == 1)
						{	
							 jdbc.closeJDBC(); return mapping.findForward("initial");
						}
						if (retour_insert == 2)
						{
							 jdbc.closeJDBC(); return mapping.findForward("error");
						}
					
						//Si exception sql alors extraire le message d'erreur du message global
						if (be.getInitialException().getClass().getName().equals("java.sql.SQLException")) {
							message =
								BipException.getMessageFocus(
									BipException.getMessageOracle(be.getInitialException().getMessage()),
									form);
							((LoadTableRepartForm) form).setMsgErreur(message.replace('\n', ' '));
							 jdbc.closeJDBC(); return mapping.findForward("initial");
						} else {
							//Erreur d''exécution de la procédure stockée
							errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
							request.setAttribute("messageErreur", be.getInitialException().getMessage());
							 jdbc.closeJDBC(); return mapping.findForward("error");
						}
					}
				} // FIN SUCCES sauvegarde ligne
				else {
					fileHasError = true;
				}

				// -------------------------------------------------------------------------------------------------
				//          Sauvegarde des erreurs qui se sont produites ou les messages d'informations
				// -------------------------------------------------------------------------------------------------
				if (hasErreur || hasInfo) {
					retour_insert = insertErreur(p_codchr, numLigne, lLigne, msgErreur, hParamProc, form, request);
					if (retour_insert == 1)
					{
						 jdbc.closeJDBC(); return mapping.findForward("initial");
				    }
					if (retour_insert == 2)
					{	
						 jdbc.closeJDBC(); return mapping.findForward("error");
					}
				}

				hasErreur = false;
				hasInfo = false;
				numLigne++;
			} // fin boucle sur les lignes

			// teste sur le taux total de la table
			if (tauxTotal != 1) {
				msgErreur = new Vector();
				msgErreur.add("La somme des taux de la table de répartition (" + tauxTotal + ") doit être égale à 1.");
				retour_insert =
					insertErreur(
						p_codchr,
						0,
						"Problème général sur le fichier.",
						msgErreur,
						hParamProc,
						form,
						request);
				fileHasError = true;
				if (retour_insert == 1)
				{	
					 jdbc.closeJDBC(); return mapping.findForward("initial");
				}
				if (retour_insert == 2)
				{
					jdbc.closeJDBC(); return mapping.findForward("error");
				}
			}

		}

		// Mise à jour du statut du chargement
		String statutFile = "1";
		if (fileHasError) {
			statutFile = "9";
			uploadForm.setMsgErreur("Le chargement a généré des erreurs.\\nVeuillez consulter le rapport.");
		} else if (fileHasOnlyInfo) {
			statutFile = "8";
			uploadForm.setMsgErreur("Le chargement a généré des remarques.\\nVeuillez consulter le rapport.");
		}
		int retour_insert = majTableChargement("update", p_codchr, statutFile, hParamProc, form, request);
		if (retour_insert == 1)
		{	
			 jdbc.closeJDBC(); return mapping.findForward("initial");
		}
		if (retour_insert == 2)
		{	
			 jdbc.closeJDBC(); return mapping.findForward("error");
		}
					
		uploadForm.setLienRapport("action=detail&codchr="+p_codchr+"&codrep="+uploadForm.getCodrep()+"&moisrep="+uploadForm.getMoisrep());

		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("initial");
	} //creer



	/**
	 * Action qui permet de dupliquer le mois dernier mois saisi sur le mois saisi
	 */
	public ActionForward dupliquer(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response,
		ActionErrors errors,
		Hashtable hParamProc)
		throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		int nb_fichier = 0;

		String signatureMethode = "LoadTableRepartAction-dupliquer( mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);

		LoadTableRepartForm uploadForm = (LoadTableRepartForm) form;
		String msgErr;
		String msgInfo = "";
		Vector vLignes = null;
		p_codchr = null;

		// -----------------------------------------------------------------------------------
		//         Duplication du dernier mois saisi
		// -----------------------------------------------------------------------------------
		try {
			vParamOut = jdbc.getResult(hParamProc, configProc, PACK_DUPLICATE);
			try {
				message = jdbc.recupererResult(vParamOut, "valider");
			} catch (BaseException be) {
				logBipUser.debug(signatureMethode + " --> BaseException :" + be);
				logBipUser.debug(signatureMethode + " --> Exception :" + be.getInitialException().getMessage());
				logService.debug(signatureMethode + " --> BaseException :" + be);
				logService.debug(signatureMethode + " --> Exception :" + be.getInitialException().getMessage());
				//Erreur de lecture du resultSet
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
			}
			if ((message != null) && (!message.equals(""))) {
				((LoadTableRepartForm) form).setMsgErreur(message);
				logBipUser.debug("message d'erreur:" + message);
				logBipUser.exit(signatureMethode);
				//on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		} catch (BaseException be) {
			logBipUser.debug(signatureMethode + " --> BaseException :" + be);
			logBipUser.debug(signatureMethode + " --> Exception :" + be.getInitialException().getMessage());
			logService.debug(signatureMethode + " --> BaseException :" + be);
			logService.debug(signatureMethode + " --> Exception :" + be.getInitialException().getMessage());
			//Si exception sql alors extraire le message d'erreur du message global
			if (be.getInitialException().getClass().getName().equals("java.sql.SQLException")) {
				message =
					BipException.getMessageFocus(BipException.getMessageOracle(be.getInitialException().getMessage()), form);
				((LoadTableRepartForm) form).setMsgErreur(message.replace('\n', ' '));
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			} else {
				//Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException().getMessage());
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}

		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("initial");
	} //dupliquer


	private String rtrimZero(String po) {

		int posLast0 = po.lastIndexOf("0");

		while ((posLast0 == (po.length() - 1)) && (po.length() > 0) && (posLast0 > -1)) {
			po = po.substring(0, posLast0);
			posLast0 = po.lastIndexOf("0");
		}

		 return po;
	}
	
	// insertion de la ligne en erreur dans la table RJH_CHARG_ERREUR
	private int insertErreur(
		String codchr,
		int numLigne,
		String ligne,
		Vector msgErreur,
		Hashtable hParamProc,
		ActionForm form,
		HttpServletRequest request) {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		StringBuffer listeErreurs = new StringBuffer();
		String signatureMethode = "LoadTableRepartAction-insertErreur()";
		logBipUser.entry(signatureMethode);

		listeErreurs.append("<UL>\n");
		for (Enumeration ve = msgErreur.elements(); ve.hasMoreElements();) {
			try {
				String err = (String) ve.nextElement();
				listeErreurs.append("<LI>" + err + "</LI>\n");
			} catch (ClassCastException cce) {
				logBipUser.error("Problème lors de la génération de la liste des erreurs de chargement RJH.");
				logBipUser.error(signatureMethode + " --> Exception :" + cce);
				logService.error("Problème lors de la génération de la liste des erreurs de chargement RJH.");
				logService.error(signatureMethode + " --> Exception :" + cce);
			}
		}
		listeErreurs.append("</UL>\n");

		// on tronque la longueur des erreurs
		if (listeErreurs.length() > 2000) {
			String s = listeErreurs.substring(0, 1980) + "</li></ul>";
			listeErreurs.delete(1980, 2000);
			listeErreurs.append("...</li></ul>");
		}

		try {
			hParamProc.put("codchr", codchr);
			hParamProc.put("numligne", Integer.toString(numLigne));
			hParamProc.put("txtligne", ligne);
			hParamProc.put("liberreur", listeErreurs.toString());
			vParamOut = jdbc.getResult(hParamProc, configProc, PACK_INSERT_ERREUR);
			try {
				message = jdbc.recupererResult(vParamOut, "valider");
			} catch (BaseException be) {
				logBipUser.debug(signatureMethode + " --> BaseException :" + be);
				logBipUser.debug(signatureMethode + " --> Exception :" + be.getInitialException().getMessage());
				logService.debug(signatureMethode + " --> BaseException :" + be);
				logService.debug(signatureMethode + " --> Exception :" + be.getInitialException().getMessage());
				//Erreur de lecture du resultSet
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
			}
			if ((message != null) && (!message.equals(""))) {
				// Code chargement déjà existant, on récupère le message 
				 ((LoadTableRepartForm) form).setMsgErreur(message);
				logBipUser.debug("message d'erreur:" + message);
				logBipUser.exit(signatureMethode);
				//on reste sur la même page
				
				 jdbc.closeJDBC(); return 1;
				// jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		} catch (BaseException be) {
			logBipUser.debug(signatureMethode + " --> BaseException :" + be);
			logBipUser.debug(signatureMethode + " --> Exception :" + be.getInitialException().getMessage());
			logService.debug(signatureMethode + " --> BaseException :" + be);
			logService.debug(signatureMethode + " --> Exception :" + be.getInitialException().getMessage());
			jdbc.closeJDBC();
			//Si exception sql alors extraire le message d'erreur du message global
			if (be.getInitialException().getClass().getName().equals("java.sql.SQLException")) {
				message =
					BipException.getMessageFocus(BipException.getMessageOracle(be.getInitialException().getMessage()), form);
				((LoadTableRepartForm) form).setMsgErreur(message.replace('\n', ' '));
				 jdbc.closeJDBC(); return 1;
				// jdbc.closeJDBC(); return mapping.findForward("initial");
			} else {
				//Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException().getMessage());
				 jdbc.closeJDBC(); return 2;
				// jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}
		logBipUser.exit(signatureMethode);
		jdbc.closeJDBC(); return 0;

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

	private int majTableChargement(
		String mode,
		String codchr,
		String statut,
		Hashtable hParamProc,
		ActionForm form,
		HttpServletRequest request) {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		String signatureMethode = "LoadTableRepartAction-majTableChargement()";
		logBipUser.entry(signatureMethode);
		try {
			if (codchr != null) 
				hParamProc.put("codchr", codchr);
			if (statut != null) 
				hParamProc.put("statut", statut);
			vParamOut = jdbc.getResult(hParamProc, configProc, recupererCle(mode));
			try {
				message = jdbc.recupererResult(vParamOut, "valider");
				if (mode.equals("insert")) 
					p_codchr = (String) ((ParametreProc) vParamOut.elementAt(2)).getValeur();
			} catch (BaseException be) {
				logBipUser.debug(signatureMethode + " --> BaseException :" + be);
				logBipUser.debug(signatureMethode + " --> Exception :" + be.getInitialException().getMessage());
				logService.debug(signatureMethode + " --> BaseException :" + be);
				logService.debug(signatureMethode + " --> Exception :" + be.getInitialException().getMessage());
				//Erreur de lecture du resultSet
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				//this.saveErrors(request,errors);
				
			}
			if ((message != null) && (!message.equals(""))) {
				// Code chargement déjà existant, on récupère le message 
				((LoadTableRepartForm) form).setMsgErreur(message);
				logBipUser.debug("message d'erreur:" + message);
				logBipUser.exit(signatureMethode);
				
				//on reste sur la même page
				 jdbc.closeJDBC(); return 1;
				// jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		} catch (BaseException be) {
			logBipUser.debug(signatureMethode + " --> BaseException :" + be);
			logBipUser.debug(signatureMethode + " --> Exception :" + be.getInitialException().getMessage());
			logService.debug(signatureMethode + " --> BaseException :" + be);
			logService.debug(signatureMethode + " --> Exception :" + be.getInitialException().getMessage());
			jdbc.closeJDBC();
			//Si exception sql alors extraire le message d'erreur du message global
			if (be.getInitialException().getClass().getName().equals("java.sql.SQLException")) {
				message =
					BipException.getMessageFocus(BipException.getMessageOracle(be.getInitialException().getMessage()), form);
				((LoadTableRepartForm) form).setMsgErreur(message.replace('\n', ' '));
				 jdbc.closeJDBC(); return 1;
				// jdbc.closeJDBC(); return mapping.findForward("initial");
			} else {
				//Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException().getMessage());
				 jdbc.closeJDBC(); return 2;
				// jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}

		logBipUser.exit(signatureMethode);
		 jdbc.closeJDBC(); return 0;

	}


	/**
	 * Action qui permet de supprimer le détail d'une table de répartition
	 */
	public ActionForward supprimer_detail(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response,
		ActionErrors errors, 
		Hashtable hParamProc)
		throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;
		
		String signatureMethode =
			"LoadTableRepart-supprimer_detail(paramProc, mapping, form , request,  response,  errors )";

		logService.entry(signatureMethode);
		LoadTableRepartForm uploadForm = (LoadTableRepartForm) form;
		String msgErr;
		String msgInfo = "";
		Vector vLignes = null;
		p_codchr = null;

		// -----------------------------------------------------------------------------------
		//         Duplication du dernier mois saisi
		// -----------------------------------------------------------------------------------
		try {
			hParamProc.put("aff_msg", "OUI");
			vParamOut = jdbc.getResult(hParamProc, configProc, PACK_DELETE);
			try {
				message = jdbc.recupererResult(vParamOut, "valider");
			} catch (BaseException be) {
				logBipUser.debug(signatureMethode + " --> BaseException :" + be);
				logBipUser.debug(signatureMethode + " --> Exception :" + be.getInitialException().getMessage());
				logService.debug(signatureMethode + " --> BaseException :" + be);
				logService.debug(signatureMethode + " --> Exception :" + be.getInitialException().getMessage());
				//Erreur de lecture du resultSet
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
			}
			if ((message != null) && (!message.equals(""))) {
				((LoadTableRepartForm) form).setMsgErreur(message);
				logBipUser.debug("message d'erreur:" + message);
				logBipUser.exit(signatureMethode);
				//on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		} catch (BaseException be) {
			logBipUser.debug(signatureMethode + " --> BaseException :" + be);
			logBipUser.debug(signatureMethode + " --> Exception :" + be.getInitialException().getMessage());
			logService.debug(signatureMethode + " --> BaseException :" + be);
			logService.debug(signatureMethode + " --> Exception :" + be.getInitialException().getMessage());
			//Si exception sql alors extraire le message d'erreur du message global
			if (be.getInitialException().getClass().getName().equals("java.sql.SQLException")) {
				message =
					BipException.getMessageFocus(BipException.getMessageOracle(be.getInitialException().getMessage()), form);
				((LoadTableRepartForm) form).setMsgErreur(message.replace('\n', ' '));
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			} else {
				//Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException().getMessage());
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}

		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("initial");
	} //supprimer_detail

}
