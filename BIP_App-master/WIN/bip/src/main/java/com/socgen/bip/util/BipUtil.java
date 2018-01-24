package com.socgen.bip.util;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.Vector;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

import org.apache.commons.lang.StringUtils;
import org.apache.struts.upload.FormFile;

import com.socgen.bip.commun.Tools;
import com.socgen.bip.exception.BipIOException;
import com.socgen.cap.fwk.ServiceManager;
import com.socgen.cap.fwk.log.Log;

public class BipUtil {
	

	public final static String CONTENT_TYPE_ZIP = "application/x-zip-compressed";
	public final static String CONTENT_TYPE_TXT = "text/plain";
	public final static String CONTENT_TYPE_DATA = "application/octet-stream";
	
	/**
	 * Séparateur des données du fichier csv
	 */
	private final static String SEPARATEUR_FICHIER_CSV = ";";
	
	protected static Log logBipUser = ServiceManager.getInstance().getLogManager().getLogInstance("BipUser");

	/**
	 * Obtention de la liste des lignes du fichier csv
	 * @param fichierCsv
	 * @return
	 * @throws FileNotFoundException
	 * @throws IOException
	 */
	public static LinkedList obtenirListeElementsLignesFichierCsv(final FormFile fichierCsv) throws FileNotFoundException, IOException {
		String signatureMethode = "TraitBatchAction-obtenirListeElementsLignesFichierCsv";
		logBipUser.entry(signatureMethode);
		
		//	 Récupération du flux associé au fichier
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		InputStream stream = fichierCsv.getInputStream();
	
		byte[] buffer = new byte[8192];
		int bytesRead = 0;
		while ((bytesRead = stream.read(buffer, 0, 8192)) != -1)
		{
			baos.write(buffer, 0, bytesRead);
		}
		baos.flush();
		
		// Flux inputStream
		InputStream iS = new ByteArrayInputStream(baos.toByteArray());
		// Vecteur des lignes du fichier
		LinkedList listeLignes = Tools.stream2LinkedList(iS);
		// Fermeture du flux inputStream
		iS.close();
		Iterator iterateur = listeLignes.iterator();
		LinkedList<String[]> listeElementsLignes = new LinkedList<String[]>();;
		
		String chaineLigne;
		String[] listeElementsLigne;
		while (iterateur.hasNext()) {
			// Contenu d'une ligne du fichier
			chaineLigne = (String) iterateur.next();
			if (StringUtils.isNotEmpty(chaineLigne)) {
				listeElementsLigne = chaineLigne.split("\\" + SEPARATEUR_FICHIER_CSV);
				listeElementsLignes.add(listeElementsLigne);
			}
		}
		
		logBipUser.exit(signatureMethode);
		
		return listeElementsLignes;
	}
	
	/**
	 * Charge le fichier de données dans un vecteur.
	 * 
	 * @param fichier
	 *            Le fichier à charger
	 * @return un vecteur contenant toutes les lignes de données du fichiers
	 */
	public static Vector loadFile(FormFile fichier) throws BipIOException {
		Vector vLignes = null;
		int nb_fichier = 0;
		try {
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			InputStream stream = fichier.getInputStream();

			byte[] buffer = new byte[8192];
			int bytesRead = 0;
			while ((bytesRead = stream.read(buffer, 0, 8192)) != -1)
				baos.write(buffer, 0, bytesRead);
			baos.flush();

			if (fichier.getContentType().equals(CONTENT_TYPE_ZIP)) {
				vLignes = new Vector();
				ZipEntry zip;
				ZipInputStream zipIS = new ZipInputStream(
						new ByteArrayInputStream(baos.toByteArray()));

				logBipUser.info("ETAT MEMOIRE : "
						+ Runtime.getRuntime().freeMemory() + " taille zip : "
						+ baos.size() + " / " + baos.size() * 4);

				if (Runtime.getRuntime().freeMemory() < baos.size() * 4)
					logBipUser
							.info("Attention : le serveur est actuellement très chargé, il est possible que le fichier ne soit pas correctement traité\\nS'il a un statut \'En Erreur\', vous devrez le recharger à nouveau");
				try {
					while ((zip = zipIS.getNextEntry()) != null) {
						if (zip.isDirectory())
							continue;
						nb_fichier++;
						try {
							Vector vLignesTemps = Tools.stream2Vector(zipIS);
							for (Enumeration ve = vLignesTemps.elements(); ve
									.hasMoreElements();)
								vLignes.add(ve.nextElement());
						} catch (IOException iOE) {
							vLignes = null;
						}
					}
					zipIS.close();
				} catch (IOException iOE) {
					logBipUser.error("problème dans le flux zip "
							+ fichier.getFileName(), iOE);
					throw new BipIOException(
							"Erreur dans le fichier ZIP, veuillez le regénérer puis le recharger.");
				}
			} else {
				nb_fichier++;
				InputStream iS = new ByteArrayInputStream(baos.toByteArray());
				vLignes = Tools.stream2Vector(iS);
				iS.close();
			}
		} catch (IOException iOE) {
			logBipUser.error("", iOE);
			throw new BipIOException(
					"Erreur dans le fichier CSV, veuillez vérifier que c'est bien un fichier texte.");
		}
		if (nb_fichier > 1)
			logBipUser
					.info("Le fichier ZIP chargé contient "
							+ nb_fichier
							+ " fichiers différents. Ils ont tous été concaténés en un seul.");
		return vLignes;

	}
	

}
