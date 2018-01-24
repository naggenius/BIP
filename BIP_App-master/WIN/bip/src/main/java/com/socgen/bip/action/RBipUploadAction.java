/*
 * Créé le 20 août 04
 *
 */
package com.socgen.bip.action;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Vector;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;
import java.util.zip.ZipInputStream;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.upload.FormFile;

import com.socgen.bip.commun.Tools;
import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.commun.action.BipAction;
import com.socgen.bip.commun.form.BipForm;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.DatesEffetForm;
import com.socgen.bip.form.RBipUploadForm;
import com.socgen.bip.rbip.intra.RBipManager;
import com.socgen.bip.rbip.intra.RBipZipExtractorThread;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * On récupere le fichier à partir du formulaire et on gère
 * 
 * @author X039435
 */
public class RBipUploadAction extends AutomateAction {
	public final static String CONTENT_TYPE_ZIP = "application/x-zip-compressed";
	public final static String CONTENT_TYPE_TXT = "text/plain";
	public final static String CONTENT_TYPE_DATA = "application/octet-stream";

	public ActionForward bipPerform(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response, Hashtable hParamProc)
			throws IOException, ServletException {

		RBipUploadForm uploadForm = (RBipUploadForm) form;

		// FIXME DHA Map the String to a UploadAction custom enum with two values (CONTROLER_SEULEMENt, ENREGISTRER)
		// String is too wide and it makes reading harder in the subsquents calls that pass this parameter
		String action = uploadForm.getAction();

		FormFile fichier = uploadForm.getFichier();

		String msgErr;
		String msgInfo;

		msgErr = "Un problème est survenu dans le traitement de votre fichier";
		msgInfo = "Le chargement des fichiers ZIP peut durer quelques minutes, pensez à rafraîchir votre liste de remontée";
		logBipUser.info(fichier.getFileName() + " : " + fichier.getContentType());

		InputStream inputStream = null;
		try {

			// retrieve the file data
			// ByteArrayOutputStream baos = new ByteArrayOutputStream();
			inputStream = fichier.getInputStream();

			logBipUser.info("UPLOAD FICHIER  : " + fichier.getFileName());

			// on a recup le flux
			if (fichier.getContentType().equals(CONTENT_TYPE_ZIP)) {

				// il va falloir envoyer les differents fichier au RBipManager
				ZipEntry zip;
				ZipInputStream zipIS = new ZipInputStream(inputStream);
				ZipInputStream zipISControler = new ZipInputStream(inputStream);

				int fileSize = fichier.getFileSize();

				logBipUser.info("ETAT MEMOIRE : " + Runtime.getRuntime().freeMemory() + " taille zip : " + fileSize);

				if (Runtime.getRuntime().freeMemory() < fileSize)
					msgInfo = msgInfo
							+ "\\n\\nAttention : le serveur est actuellement très chargé, il est possible que certains de vos fichiers ne soient pas correctement traités\\nCeux-ci auront un statut \'En Erreur\', vous devrez les remonter à nouveau";

				RBipZipExtractorThread rBipZET = new RBipZipExtractorThread(userBip, zipIS, action);

				boolean bips = false;

				if ("controler".equals(action)) // si clique sur le bouton Controler seulement
				{
					while ((zip = zipISControler.getNextEntry()) != null) {
						if (zip.getName().toUpperCase().endsWith("BIPS")) {
							bips = true;
							break;
						}
					}

					if (bips == false) // si il existe au moins un fichier BIPS dans l'archive, on n'affiche pas d'alerte
					{
						msgInfo = "Le fichier " + fichier.getFileName() + " ne contient aucun fichier .BIPS";
						logBipUser.info(msgInfo);
					}
				}

				// FIXME DH should specify the explicit condition with 'creer' String or doesn't specify it in the rBipUpload.jsp because it is not used by the action,
				// so it is error prone
				rBipZET.start();

				uploadForm.setMsgErreur(msgInfo);
			} else {
				msgErr += ", vérifiez que votre archive (si fichier zip) contient bien uniquement des fichiers texte";
				// il faut envoyer le fichier au RBipManager
				Vector vLignes = Tools.stream2Vector(inputStream);
				// SEL PPM 60612 - QC 1711 : enlever les espaces du fichier
				RBipManager.getInstance().addControle(userBip, fichier.getFileName().replaceAll("\\s+", "").toUpperCase(), vLignes, action);
			}
		}

		catch (IOException exception) {
			logBipUser.error("exception lors de la lecture du fichier", exception);
			uploadForm.setMsgErreur(msgErr);
		}

		finally {
			if (inputStream != null) {
				inputStream.close();
			}
		}

		return mapping.findForward("initial");
	}

}