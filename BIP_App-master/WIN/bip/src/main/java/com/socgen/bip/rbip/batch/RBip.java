package com.socgen.bip.rbip.batch;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.util.Calendar;
import java.util.Collections;
import java.util.Iterator;
import java.util.StringTokenizer;
import java.util.Vector;

import org.apache.log4j.Logger;
import org.apache.log4j.PropertyConfigurator;
import org.apache.log4j.helpers.NullEnumeration;

import com.socgen.bip.commun.Tools;
import com.socgen.bip.commun.action.BipAction;
import com.socgen.bip.db.RBip_Jdbc;
import com.socgen.bip.rbip.commun.RBipConstants;
import com.socgen.bip.rbip.commun.RBipFilenameFilter;
import com.socgen.bip.rbip.commun.RBipsFilenameFilter;
import com.socgen.bip.rbip.commun.controller.RBipController;
import com.socgen.bip.rbip.commun.erreur.RBipErreur;
import com.socgen.bip.rbip.commun.erreur.RBipErreurComparateur;
import com.socgen.bip.rbip.commun.erreur.RBipWarning;
import com.socgen.bip.rbip.commun.loader.RBipData;
import com.socgen.bip.rbip.commun.loader.RBipLoader;
import com.socgen.bip.rbip.commun.loader.RBipLoaderBip;
import com.socgen.bip.rbip.commun.loader.RBipLoaderBips;
import com.socgen.bip.rbip.commun.loader.RBipParser;
import com.socgen.bip.rbip.commun.loader.RBipStructureConstants;
import com.socgen.bip.rbip.commun.userLogger.RBipUserLogger;
import com.socgen.bip.util.BipCrypto;
import com.socgen.bip.util.ReadConfig;
import com.socgen.cap.fwk.log.Log;



/*
 * Créé le 7 mai 04
 */

/**
 * @author X039435 / E.GREVREND
 * 
 * Classe de lancement des contrôles de la remontée Bip côté serveur.<br>
 * Pour chacun des utilisateurs définis dans le fichier de ressource, on contrôle les fichiers bip situés dans son répertoire.<br>
 * Pour chaque traitement , un fichier de log contenant le résultat des contrôle est généré.<br>
 * Ce fichier, placé dans le répertoire de l'utilisateur, est envoyé par email.<br> 
 */
public class RBip implements RBipConstants,RBipStructureConstants
{
	/**
	 * Répertoire dans lequel les fichiers valides sont transférés.
	 */
	private File fRepRemontee;
	/**
	 * rBipLog est le logger utilisé pour l'exécution de RBip.<br>
	 * Il n'est pas utilisé dans les traitements en eux même.
	 */
	private static Log rBipLog = null; 
	
	/**
	 * Initialisation puis lancement des traitement
	 * @param args pas de paramètres gérés aujourd'hui
	 * @see #init()
	 * @see #start()
	 */
	
	// Declaration des Parametres de connexion à passer pour RBip.jar
//	private static String DB_URL;
//	private static String DB_USER;
//	private static String DB_PASS;
	
	public static Vector ETAPES_PACTE = new Vector();
	private final String procedure;
	private final String cle = "listejeu.typeetape.proc";
	private final String NomConfig = "bip_proc";
	
	public static void main(String[] args) 
	{
		try
		{
						
			// Passage de parametres de connexion JDBC pour le fichier RBip.jar (Ex: RBip.jar DB_URL DB_USER DB_PASS TOP) pour le traitement Remontee BATCH
			
			//jdbc:oracle:thin:@dbipd02b.dns21.socgen:12200:dbipdb01
			
			/*DB_URL        = "jdbc:oracle:thin:@dbipd02b.dns21.socgen:12200:dbipdb01"; 
			DB_USER       = "BIP";
			DB_PASS   	  = "BIP";
			RBip_Jdbc.TOP = "UNIX";*/
			
			
			RBip rBip = new RBip(args);
			rBip.init();
			
			rBipLog.info("DEBUT : Controles RBIP");		
			/*rBipLog.info("CLEAR PASSWORD = "+DB_PASS+
					" ||| BYTE PASSWORD = "+DB_PASS.getBytes()+
					" ||| ENCRYPTED PASSWORD = "+RBip_Jdbc.DB_PASS+
					" ||| DECRYPTED PASSWORD = "+BipCrypto.decrypter(RBip_Jdbc.DB_PASS));	*/	
			
			if (rBip.start())
			{
				//tout ok
				rBipLog.info("FIN : Controles termines avec succes");
			}
			else
			{
				rBipLog.info("FIN : Echec des Controles, une erreur est venu perturber les controles");
				rBipLog.info("FIN : Verifier les traces d'execution pour determiner les causes du probleme");
				System.exit(2);
			}
			
			checkBipsMensuelle();
		}
		catch (Throwable e)
		{
			if (rBipLog != null)
			{
								
				rBipLog.error("ECHEC : le traitement s'est interrompu de maniere inopinee");
				rBipLog.error(e);
				
			}
			else
			{
				System.err.println("ECHEC : le traitement s'est interrompu de maniere inopinee");
				BipAction.logBipUser.error("Error. Check the code", e);			
			}
			System.exit(1);
		}
	}
	

	/**
	 * Fonction d'initialisation de la classe.<br>
	 * On y instancie le logger.<br>
	 * @throws Exception si le logger n'est pas correctement initialisé
	 */
	private void init() throws Exception
	{	
		System.out.println("Initialisation ...");
		PropertyConfigurator.configure(cfgRbip.getString("log"));
		
		if ( Logger.getLogger(RBIP_LOGGER).getAllAppenders() instanceof NullEnumeration)
		{
			throw new Exception("Echec de l'initialisation du logger");
		}
		
		rBipLog = new Log(RBIP_LOGGER);
		System.out.println("Initialisation terminee");
	}
	
	/**
	 * Dans le constructeur on récupère du fichier de ressource le répertoire de remontée où seront déplacés les fichiers valides.<br>
	 * @param args 
	 * 
	 * @throws Exception si le répertoire n'existe pas ou s'il n'est pas un répertoire
	 */
	public RBip(String[] args) throws Exception	{
		
		RBip_Jdbc.DB_URL = args[0] ;
		RBip_Jdbc.DB_USER = args[1];
		RBip_Jdbc.DB_PASS = BipCrypto.encrypter(args[2]);
		RBip_Jdbc.TOP = args[3];
		
		ReadConfig cfg = new ReadConfig(NomConfig);
		procedure = cfg.getProperty(cle);
		
		String sRepRemontee = Tools.getSysProperties().getProperty(DIR_REMONTEE, "");
		
		if (sRepRemontee.equals(""))
		{
			System.err.println("Le repertoire de remontee n'est pas definit dans l'environnement par ["+DIR_REMONTEE+"]");
			throw new Exception("Le repertoire de remontee n'est pas definit dans l'environnement par ["+DIR_REMONTEE+"]");
		}
		
		fRepRemontee = new File(sRepRemontee);
		if ( !( (fRepRemontee.exists())&&(fRepRemontee.isDirectory()) ) )
		{
			//erreur
			System.err.println(fRepRemontee.getName()+ " : Rep de remontee invalide");
			//rBipLog.error("Le répertoire de remontée ["+fRepRemontee.getName()+"] est invalide !!");
			//rBipLog.error("Traitement interrompu");
			//System.exit(1);
			throw new Exception("Le repertoire de remontee ["+fRepRemontee.getAbsolutePath()+"] est invalide !!");
		}
	}
	
	/**
	 * Foncion principale de traitement.<br>
	 * On récupère la liste des utilisateurs (dans fichier de ressources), et pour chacun d'eux un traitement va être lancé.<br>
	 * Si une exception vient interrompre le contrôle des fichiers d'un utilisateur, on passe au suivant.<br>
	 * @return true si l'ensemble des contrôles se sont déroulés sans interruptions
	 */
	private boolean start()
	{
		boolean bStart = true;
		String sUser;
		File fRepControl;
		
		StringTokenizer sTk = new StringTokenizer(cfgRbip.getString(TAG_USER_LISTE), ",");
		while (sTk.hasMoreElements())
		{
			sUser = sTk.nextToken().trim();
			
			fRepControl = new File(cfgRbip.getString(TAG_USER+sUser+TAG_DIR_IN));
			
			if ( !( (fRepControl.exists())&&(fRepControl.isDirectory()) ) )
			{
				//erreur sur le user
				rBipLog.error("Le repertoire de controle de ["+sUser+"] : ["+fRepControl.getName()+"] est invalide !!");
				rBipLog.error("Fin anticipee du controle des fichiers de l'utilisateur [" + sUser + "]");
				bStart = false;
				continue;				
			}
						
			try
			{
				rBipLog.info("Debut du controles des fichiers .BIP de l'utilisateur [" + sUser + "]");
				bStart = bStart && startUser(sUser, fRepControl);
				rBipLog.info("Fin des Controles des fichiers .BIP de l'utilisateur [" + sUser + "]");
				
				
				//SEL PPM 60612
				rBipLog.info("Debut du controles des fichiers .BIPS de l'utilisateur [" + sUser + "]");
				bStart = bStart && startUserBips(sUser, fRepControl);
				rBipLog.info("Fin des Controles des fichiers .BIPS de l'utilisateur [" + sUser + "]");
			}
			catch (Exception e)
			{
				rBipLog.error("Une erreur est survenue lors des controles de remontee de l'utilisateur [" + sUser + "] : " + e.getMessage());
				rBipLog.error("Fin anticipee du controle des fichiers de l'utilisateur [" + sUser + "]");
				rBipLog.error(e);
				bStart = false;
				continue;
			}
		}
		return bStart;
	}
	
	//SEL PPM 60612
	private boolean startUserBips(String sUser, File fRepControl) throws Exception {
		boolean bStartUser = true; 		
		File [] fichiers = fRepControl.listFiles(new RBipsFilenameFilter());
	
		RBipController rBipC = new RBipController();
		RBipLoader rBipL = new RBipLoaderBips(null);
		
		Vector vMainWarning = new Vector();
		Vector vMainErreur = new Vector();
		Vector vFichierOk = new Vector();
		
		Vector vLignes = new Vector();
		
		Tools tools = new Tools();
		String listLigneKo="";
		RBip_Jdbc.USER_BIP_SERVER=sUser;
		
		
		boolean isOK;
		rBipLog.info("Nombre de fichier BIPS " + fichiers.length+" ["+sUser+"]");
		for (int i = 0; i<fichiers.length; i++)
		{
			File fichier = (File)fichiers[i];
			rBipLog.info("____________________________________________________________________");
			rBipLog.info("Debut de lecture du fichier " + fichier.getName()+" ["+sUser+"]");
			rBipLog.info("____________________________________________________________________");
			
			try{
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			InputStream stream = new FileInputStream(fichier);
			

			byte[] buffer = new byte[8192];
			int bytesRead = 0;
			while ((bytesRead = stream.read(buffer, 0, 8192)) != -1) {
				baos.write(buffer, 0, bytesRead);
			}
			baos.flush();
			
			InputStream iS = new ByteArrayInputStream(baos.toByteArray());
			vLignes = Tools.stream2Vector(iS);
			}catch (Exception e) {
					//erreur exception, on passe au fichier suivant
					rBipLog.error("Probleme dans la lecture du fichier [" + fichier.getName()+"]");
					rBipLog.error("Le controle du fichier [" + fichier.getName()+"] est abandonne");
					rBipLog.error(e);
					rBipLog.error(e.getMessage());
					bStartUser = false;
					continue;
			}
			
			
//			for(int j=1;j<vLignes.size();j++)
//			{
//				rBipLog.info("Ligne ("+j+") : " + vLignes.get(j).toString());
//			}
			
			try
			{			
				rBipLog.info("Debut de chargement des lignes (" + (vLignes.size()-1)+") ["+sUser+"]");
				rBipL.load(fichier.getName(), vLignes);
				rBipLog.info("Fin de chargement des lignes " + (vLignes.size()-1)+" ["+sUser+"]");
			}
			catch (Exception e)
			{
				rBipLog.error("Erreur dans la procedure de chargement du fichier [" + fichier.getName()+"]");
				rBipLog.error(e);
				rBipLog.error(e.getMessage());
				rBipLog.error("Voir si probleme dans le fichier des ressources associe");
				bStartUser = false;
				throw e;
			}
			
			Vector vErr = rBipL.getErreurs();
			Vector vData = rBipL.getRBipData();
			
			
			Iterator itErreurL = vErr.iterator();
			Iterator itData = vData.iterator();
			
			Vector dataOkL = new Vector();
			
			//recuperer les numeros des lignes rejetées
			while(itErreurL.hasNext())
			{
				int numErr = ((RBipErreur)(itErreurL.next())).getNumLigne();
				
				listLigneKo+=numErr+"-";
				
			}
			
			//remplir dataOkL avec les bonnes données suite au chargement
			while(itData.hasNext())
			{
				
				RBipData data = (RBipData) itData.next();
				
					if (!listLigneKo.contains(""+data.getNumLigne()))
					{
						
						dataOkL.add(data);
					}
					
			}
			
			rBipLog.info("Nombre de lignes chargées " + (dataOkL.size()-1)+" ["+sUser+"]");
			rBipLog.info("Erreurs de chargement " + rBipL.getErreurs().size()+" ["+sUser+"]");
			
//			for(int j=1;j<dataOkL.size();j++)
//			{
//				rBipLog.info("Ligne chargée avec succes : " + dataOkL.get(j).toString());
//			}
	
			
			try
			{
				
			rBipLog.info("Debut de contrôle des lignes (" + (dataOkL.size()-1)+") ["+sUser+"]");
			rBipC.checkBips(fichier.getName(), dataOkL, null);
			rBipLog.info("Fin de contrôle des lignes (" + (dataOkL.size()-1)+") ["+sUser+"]");
			
			}catch (Exception e) {
				rBipLog.error("Erreur dans la procedure de controle du fichier [" + fichier.getName()+"]"+" ["+sUser+"]");
				rBipLog.error(e);
				rBipLog.error(e.getMessage());
				bStartUser = false;
				throw e;
			}
			
			vErr = rBipC.getErreurs();
			
			rBipLog.info("Erreurs de contrôle : " + rBipC.getErreurs().size()+" ["+sUser+"]");
			rBipLog.info("Alertes de contrôle : " + rBipC.getWarning().size()+" ["+sUser+"]");
			
			
			Iterator itErreurC = rBipC.getErreurs().iterator();
			Iterator itDataOkL = dataOkL.iterator();
			
			Vector dataOkC =new Vector();
			listLigneKo = "-";
			
			while(itErreurC.hasNext())
			{
				int numErr = ((RBipErreur)(itErreurC.next())).getNumLigne();
				
				listLigneKo+=numErr+"-";
				
			}
			
			while(itDataOkL.hasNext())
			{
				
				RBipData data = (RBipData) itDataOkL.next();
				
					if (!listLigneKo.contains("-"+data.getNumLigne()+"-"))
					{
						
						dataOkC.add(data);
					}
					
			}
			String insert_retour="";
			RBip_Jdbc.FILENAME_BIP_SERVER=fichier.getName();
			
			rBipLog.info("Lignes controlees à insérer : " + (dataOkC.size()-1)+" ["+sUser+"]");
			try {
				if(dataOkC.size()-1>0)
				{
				
				rBipLog.info("Debut insertion des données du fichiers dans la table PMW_BIPS ["+sUser+"]");
				insert_retour = Tools.inserer_bips(dataOkC,null);
				rBipLog.info("Fin insertion des données du fichiers dans la table PMW_BIPS ["+sUser+"] : "+insert_retour.substring(17));
				}else
				{
				rBipLog.info("Aucune donnée à inserer dans la table PMW_BIPS ["+sUser+"] : ");
				}
				
			} catch (Exception e) {
				rBipLog.error("Erreur dans la procedure d'insertion du fichier [" + fichier.getName()+"] : "+insert_retour);
				rBipLog.error(e);
				rBipLog.error(e.getMessage());
				bStartUser = false;
			}
			
			
		}
		
		
		
		return bStartUser;
	}


	/**
	 * Contrôle d'un utilisateur donné.<br>
	 * Une fois les contrôles effectués, un fichier de log est généré puis envoyé par email.<br>
	 * Si un problème intervient au niveau de la lecture d'un fichier, le traitement n'est pas interrompu, on se contente de marquer la cas d'erreur et de passer au fichier suivant.<br>
	 * 
	 * @param sUser identifiant de l'utilisateur dans le fichier de ressource
	 * @param fRepControl répertoire associé à l'utilisateur dans lequel se trouvent les fichiers à contrôler
	 * @return true si la lecture des fichiers, la contruction du fichier de log, l'envoie par email du fichier de log et le déplacement du fichier se sont tous bien passés
	 * @throws Exception levée par le loader
	 * @see com.socgen.bip.rbip.loader.RBipLoader#load(String, Vector)
	 */
	private boolean startUser(String sUser, File fRepControl) throws Exception
	{
		boolean bStartUser = true; 		
		File [] fichiers = fRepControl.listFiles(new RBipFilenameFilter());
	
		RBipController rBipC = new RBipController();
		RBipLoaderBip rBipL = new RBipLoaderBip();
		
		Vector vMainWarning = new Vector();
		Vector vMainErreur = new Vector();
		Vector vFichierOk = new Vector();
		
		Tools tools = new Tools();
		
		boolean isOK;
		
		for (int i = 0; i<fichiers.length; i++)
		{
			Vector vLigne = null;
			File f = (File)fichiers[i];
			rBipLog.info("Controle du fichier " + f.getName());
			
			//readFile throws IOException et FileNotFoundException
			try
			{		
				// On récupère le PID à partir du nom de fichier .bip
				// Exécution de la procédure qui ramène la liste jeu des types étapes
				RBip_Jdbc.P_PID = tools.getPIDFromFileName(f.getName());
				
				RBip_Jdbc.getListTypetape(RBip_Jdbc.DB_URL, RBip_Jdbc.DB_USER, RBip_Jdbc.DB_PASS, procedure, null, RBip_Jdbc.P_PID);
				RBipParser.Etapes_Pacte_Clone();
				// Lecture du fichier .bip
				vLigne = Tools.readFile(f);
				//System.out.println("vLigne StartUSER: "+vLigne);
			}
			catch (Exception e)
			{
				//erreur exception, on passe au fichier suivant
				rBipLog.error("Probleme dans la lecture du fichier [" + f.getName()+"]");
				rBipLog.error("Le controle du fichier [" + f.getName()+"] est abandonne");
				rBipLog.error(e);
				bStartUser = false;
				continue;
			}
			
			try
			{								
				rBipL.load(f.getName(), vLigne);
			}
			catch (Exception e)
			{
				rBipLog.error("Erreur dans la procedure de chargement des fichiers de remontee");
				rBipLog.error("Voir si probleme dans le fichier des ressources associe");
				throw e;
			}
			
	
			Vector vErr = rBipL.getErreurs();
			Vector vWar = rBipL.getWarning();
			Vector vData = rBipL.getRBipData();
	
			if (vErr.size() == 0)
			{
				rBipC.check(f.getName(), vData);
				vErr = rBipC.getErreurs();
				vWar = rBipC.getWarning();
				if (vErr.size() == 0)
				{
					//fichier ok
					vFichierOk.add(f.getName());
				}					
			}
			vMainErreur.addAll(vErr);	
			vMainWarning.addAll(vWar);
		}

		Collections.sort(vMainErreur, new RBipErreurComparateur());
		isOK = vMainErreur.isEmpty();
		
		File fLog = getLogFile(sUser, fRepControl);
		
		RBipUserLogger userLog = (RBipUserLogger)Class.forName(cfgRbip.getString(TAG_USER+sUser+TAG_LOGGER)).getConstructor(null).newInstance(null);
		 
		bStartUser = bStartUser && buildLogFile(fLog, userLog, vFichierOk, vMainWarning, vMainErreur);
		
		/*
		 * On n'envoie pas le fichier par email ... mais on peut :p
		 bStartUser = bStartUser && sendLogFile(	isOK,
												sUser,
												cfgRbip.getString(TAG_EMAIL_EXP),
												cfgRbip.getString(TAG_USER+sUser+TAG_EMAIL),
												fLog);
		*/

		//on deplace les fichiers dans le rep de dest
		bStartUser = bStartUser && deplacerFichier(sUser, fRepControl, vFichierOk);
		
		return bStartUser;
	}
	
	/**
	 * Construit le sujet et le corps du mail.<br>
	 * Appelle ensuite la classe Mailer pour envoyer le mail avec le fichier de log en pièce jointe.<br>
	 * Fonctionnel mais non utilisé et mis en commentaire.<br>
	 * @param isOk flag permettant de décider quel corps donner au mail : "tous les fichiers sont ok" ou "Il y a des fichiers invalides"
	 * @param sUser	identifiant de l'utilisateur dans le fichier de ressource
	 * @param sEmails liste des adresses
	 * @param fLog fichier log à mettre en pièce jointe
	 * @return true si le Mailer n'a pas levé d'exceptions
	 */
	/*
	private boolean sendLogFile(boolean isOk, String sUser, String sExp, String sEmails, File fLog)
	{
		String sSujet;
		String sCorps;
		String sDest = sEmails;
		
		if (isOk)
		{
			sSujet = cfgRbip.getString(TAG_EMAIL_OK+TAG_SUJET);
			sCorps = cfgRbip.getString(TAG_EMAIL_OK+TAG_CORPS)+ cfgRbip.getString(TAG_SIGNATURE);
		}
		else
		{
			sSujet = cfgRbip.getString(TAG_EMAIL_KO+TAG_SUJET);
			sCorps = cfgRbip.getString(TAG_EMAIL_KO+TAG_CORPS)+ cfgRbip.getString(TAG_SIGNATURE);
		}
		
		//envoie du mail au sDest avec comme sujet sSujet, comme corps de message sCorps et comme piece jointe sLogFileName
		try
		{
			Mailer.sendMail(cfgRbip.getString(TAG_EMAIL_BOUCHON).equals("true"), sExp, sDest, sSujet, sCorps, fLog);
		}
		catch (Exception e)
		{
			rBipLog.error("Echec de l'envoie du mail de " + sUser);
			rBipLog.error(e);
			return false;
		}
		
		return true;
	}*/
	
	/**
	 * Contruction du fichier de log de l'utilisateur.<br>
	 * Le fichier de log commence par lister les fichiers valides, puis les fichiers en erreur.<br>
	 * Chaque utilisateur possède un RBipUserLogger associé, qui définit le format de sortie du log (CSV, TXT).<br>
	 * @param fLog fichier qui va être construit
	 * @param rBipL pour le format de sortie
	 * @param vFichiersOk liste des fichiers valides
	 * @param vErreurs liste des erreurs rencontrées
	 * @return true s'il n'y a pas de problèmes d'écriture dans le fichier
	 */
	private boolean buildLogFile(File fLog, RBipUserLogger rBipL, Vector vFichiersOk, Vector vWarning, Vector vErreurs)
	{
		boolean bBuildLogFile = true;
		try
		{
			FileWriter fw = new FileWriter(fLog);
			rBipLog.debug("Generation du fichier de log [" + fLog.getName()+"]");
			
			//1-on log les fichiers ok
			for (int i =0; i<vFichiersOk.size(); i++)
			{
				String sFileName = (String)vFichiersOk.get(i);
				rBipLog.debug(rBipL.toStringOK(sFileName));
				fw.write(rBipL.toStringOK((String)vFichiersOk.get(i))+"\r\n");
				fw.flush();
				//System.out.println("Fichier ok : " + (String)vFichiersOk.get(i));
				
				//si il y a des warnings associes aux fichier ok, on les affihe
				for (int w=0; w<vWarning.size(); w++)
				{
					rBipLog.info("Il y a des WARNING pour le fichier "  +sFileName);
					RBipWarning rBipW = (RBipWarning)vWarning.get(w);
					if (rBipW.getFileName().equals(sFileName))
					{
						rBipLog.debug(rBipL.toStringKO((RBipErreur)rBipW));
						fw.write(rBipL.toStringKO((RBipErreur)rBipW)+"\r\n");
						fw.flush();
					}
				}
			}
			//2-on log les erreurs
			for (int i =0; i<vErreurs.size(); i++)
			{
				rBipLog.debug(rBipL.toStringKO((RBipErreur)vErreurs.get(i)));
				fw.write(rBipL.toStringKO((RBipErreur)vErreurs.get(i))+"\r\n");
				fw.flush();
				//System.out.println(rBipL.toStringKO((RBipErreur)vErreurs.get(i)));
				//System.out.println(((RBipErreur)vErreurs.get(i)).toString());
			}
			fw.close();
		}
		catch (IOException e)
		{
			//erreur
			rBipLog.error("Erreur lors de la generation du fichier de log ["+fLog.getName()+"]");
			rBipLog.error(e);
			bBuildLogFile = false;
		}
		return bBuildLogFile;
	}
	
	/**
	 * Contruit l'instance pour le fichier de log de l'utilisateur donné
	 * @param sUser identifiant de l'utilisateur dans le fichier de ressources
	 * @param fRepControl le répertoire dans lequel sont les fichiers de l'utilisateur et dans lequel va être placé le fichier de log
	 * @return le fichier qui va être construit pour la log de cet utilisateur
	 */
	private File getLogFile(String sUser, File fRepControl)
	{
		String sDate = Tools.getStrDateAAAAMMJJ(0,0,0);
		sDate += "."+Calendar.getInstance().get(Calendar.HOUR_OF_DAY)+"H";
		return new File(fRepControl.getAbsolutePath()+"/"+sDate+"."+sUser+".RBIP"+cfgRbip.getString(TAG_USER+sUser+TAG_SUFFIX));
	}
	
	/**
	 * Pour déplacer un fichier bip dans le répertoire de remonté
	 * @param sUser nom du remonteur, utilisé pour préfixé le fichier dans le répertoire de dépot : nécessaire pour la remontee
	 * @param fRepControl répertoire dans lequel est situé le fichier à déplacer
	 * @param vFichiersOk liste des fichiers valides (et donc à déplacer)
	 * @return true l'ensemble des fichiers a été deplacé
	 */
	private boolean deplacerFichier(String sUser, File fRepControl, Vector vFichiersOk)
	{
		boolean bDeplacerFichier = true;
		for (int i=0; i<vFichiersOk.size(); i++)
		{
			String sFichierOk = (String)vFichiersOk.get(i);
			File f = new File(fRepControl.getAbsolutePath() + "/" + sFichierOk);
			
			File fDest = new File(fRepRemontee.getAbsolutePath() +"/" + sUser + "." + sFichierOk);
			
			try      
			{
			  copyFile(f,fDest);
			  rBipLog.info("Fichier " + fRepControl.getAbsolutePath()+"/"+sFichierOk + " archive");

			}
				 catch (IOException e) {
						//erreur
						rBipLog.error("Fichier de depart : " + f.getAbsolutePath());
						rBipLog.error("Fichier de destination : " + fDest.getAbsolutePath());
						rBipLog.error("Echec dans le deplacement du fichier");
						bDeplacerFichier = false;
		      
		    }
			}
		return bDeplacerFichier;
	}

	public static void copyFile(File src, File dest) throws IOException
	{  
		FileInputStream fis = new FileInputStream(src);
		FileOutputStream fos = new FileOutputStream(dest);

		java.nio.channels.FileChannel channelSrc   = fis.getChannel();
		java.nio.channels.FileChannel channelDest = fos.getChannel();

		channelSrc.transferTo(0, channelSrc.size() , channelDest);

		fis.close();
		fos.close();
	}
	
	private static void checkBipsMensuelle() {
		
		try{
		
	    Tools.deleteRejetMensuelleBips("");
			
		Vector<RBipData> rbipdata = Tools.listPmwBips();
		
		rBipLog.info("Debut contrôles et rejets des données P2 ("+rbipdata.size()+") lignes)");
		RBipController rbipC = new RBipController();
		rbipC.checkBipMensuelle(rbipdata);
		rBipLog.info("Fin contrôles et rejets des données P2 ("+rbipdata.size()+") lignes)");
		}catch (Exception e) {
			rBipLog.info(e.getMessage());
		}
		
		
		
		
	}
	

}
