package com.socgen.bip.metier;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.MissingResourceException;
import java.util.Vector;

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.Tools;
import com.socgen.bip.commun.action.BipAction;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.exception.ReportException;
import com.socgen.bip.extension.MyConfig;
import com.socgen.bip.hierarchy.HierarchyAction;
import com.socgen.bip.user.UserBip;
import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.config.ConfigManager;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.cap.fwk.exception.CriticalRuntimeException;
import com.socgen.cap.fwk.log.Log;

/**
 * Report est la classe M�tier qui ex�cute les demande de travail d'�tat
 * (Editions ou Extraction)
 * 
 * @author RSRH/ICH/GMO Equipe Bip
 * @author E.GREVREND
 * 
 * 28/11/2005 JMA : ajout sp�cificit� pour les extractions pour les tableaux de pr�sentation Excel.
 * 
 */
public class Report implements BipConstantes
{
	/**
	 * Cha�ne permettant de d�finir le format de sortie d�sir� (HTML/PDF/DELIMITED/DELIMITED_DATA)
	 */
	public static final String PARAM_DESFORMAT="desformat";
	/**
	 * Cha�ne permettant de d�finir le fichier de d�finission de l'�tat (fichier .xml)
	 */
	public static final String PARAM_REPORT="module";
	/**
	 * Cha�ne permettant de d�finir le delimiteur (uniquement dans le cas d'un desformat=DELIMITED),<br>
	 * par exemple ";" pour les .csv
	 */
	public static final String PARAM_DELIMITER="delimiter";
	/**
	 * Cha�ne permettant de d�finir le nom du fichier de sortie (uniquement dans le cas d'un desformat=DELIMITED), <br>
	 * Dans les autre cas le nom du fichier est attribu� par le serveur de reports.<br>
	 * La valeur ne comprend pas le chemin absolue mais uniquement le 'basename',<br>
	 * le r�pertoire de g�n�ration d�pend du param�trage du serveur de reports et en aucun cas de cette classe
	 */
	public static final String PARAM_DESNAME="desname";
	
	/**
	* Cha�ne permettant de d�finir si le report est affich� ou non
	*/
	protected static final String PARAM_SHOW="show";
	
	/**
	 * Cha�ne permettant de d�finir le nom du serveur de reports qui va effectuer le travail
	 */
	protected static final String PARAM_SERVER="server";
	/**
	 * Cha�ne permettant de d�finir la cl� � laquelle est associ� la cha�ne d'identification pour Oracle.<br>
	 * La cl� associ� � ce param�tre doit avoir une entr�e dans le fichier cgicmd.dat (voir param�trage du script Cgi)
	 */
	protected static final String PARAM_INSTANCE="Instance";
	/**
	 * Cha�ne permettant de d�finir si un ent�te est souhait� ou non
	 */
	protected static final String PARAM_DELIMITED_HDR="delimited_hdr";
	/**
	 * Valeur associ� � PARAM_SERVER, d�finie dans le fichier des ressources des reports
	 */
	//protected static final String sServer = ServiceManager.getInstance().getConfigManager().getInstance(BIP_REPORT).getString("report.server");
	protected static final String sServer = Tools.getSysProperties().getProperty(REPORT_SERVER);//"test";//Tools.getSysProperties().getProperty(REPORT_SERVER);
	/**
	 * Valeur associ� � PARAM_INSTANCE, d�finie dans le fichier des ressources des reports
	 */
	protected static final String sInstance = ConfigManager.getInstance(BIP_REPORT).getString("report.userDbId.default");
	/**
	 * Le r�pertoire dans lequel les fichiers peuvent �tre r�cuperes
	 */	
	protected static final String sReportOut = ConfigManager.getInstance(BIP_REPORT).getString("report.out");

	/**
	 * Logger de suivi des actions des utilisateurs
	 */
	protected static final Log logBipUser = BipAction.getLogBipUser();
	/**
	 * Config pointant sur le fichier des ressources des reports
	 */
	protected static Config cfgReports=ConfigManager.getInstance(BIP_REPORT);
	/**
	 * Config pointant sur le fichier des ressources des proc�dures stok�es des �tats.<br>
	 * Fichier sp�cifi� dans le fichier des ressources des reports.
	 */
	protected static Config cfgProc=ConfigManager.getInstance(cfgReports.getString("report.procCfg"));
	/**
	 * Config pointant sur le fichier des ressources contenant la d�finition des �tats �tats.<br>
	 * Fichier sp�cifi� dans le fichier des ressources des reports.
	 */
	protected static MyConfig cfgJob = new MyConfig(ConfigManager.getInstance(cfgReports.getString("report.jobCfg")));
	/**
	 * Le mode bouchon permet de conrcircuiter l'appel � execReport, le reste du processus de traitement est suivi.<br>
	 * A noter que l'url retourn�e pour un report synchrone est 'null' et que page d'erreur 404 appara�tra.<br>
	 * A noter que la table des traitements asynchrone n'est pas mise � jour pour les modes bouchons
	 */
	protected static boolean bModeBouchon = cfgReports.getBoolean("report.bouchon");
	/**
	 * Definit le temps de traitement factice pour la g�n�ration d'un �tat en mode bouchon.
	 */
	protected static int iBouchonSleep = cfgReports.getInt("report.bouchon.sleep");
	/**
	 * Chemin absolu du dossier contenant le r�pertoire de g�n�ration des rapports 
	 */
	public static String cheminAbsoluGeneration = cfgReports.getString("report.cheminAbsoluGeneration");
	/**
	 *  Dur�e max d'attente de cr�ation de fichier report sur le serveur (en ms)
	 */
	public static int dureeAttenteMax = cfgReports.getInt("report.dureeAttenteMax");
	/**
	 *  Dur�e max d'attente de disponibilit� du serveur (en ms)
	 */
	public static int dureeAttenteDispoServeurMax = cfgReports.getInt("report.dureeAttenteDispoServeurMax");
	
	public static String JOB_HIERARCHY = "xHierarchy1";
	

	
	/**
	 * Membres d'instance
	 */
	
	/**
	 * exception est renseign� si un probl�me appara�t lors de la g�n�ration de l'�tat.<br>
	 * Si sa valeur est 'null' c'est qu'il n'y a pas de probl�mes.
	 */
	private ReportException exception;
	/**
	 * hParamReports rassemble tous les param�tres n�cessaires � la g�n�rationd e l'�tat.
	 */
	private Hashtable hParamReport;
	/**
	 * La cha�ne permet de choisir valeur donner au param�tre du report server userid.
	 */
	private String sUserDbId;
	/**
	 * L'identifiant du job auquel appartient l'�tat.
	 */
	private String sJobId;
	/**
	 * L'identifiant de l'�tat dans le job (sJobId).
	 */
	private String sReportId;
	/**
	 * L'utilisateur demandeur de l'�tat.
	 */
	private UserBip userBip;
	/**
	 * Utilis�e pour renseigner la table des traitements asynchrones.
	 */	
	private Date dDate;
	

   /**
    * Permet de r�cup�rer le nom de fichier Excel qui sera g�n�r�
    */
   private String desNameFichierExcel ; 
	
	/**
	 * Constructeur de la classe
	 * @param sJobId identifiant du job auquel appartient l'�tat
	 * @param sReportId identifiant de l'�tat dans le job (sJobId)
	 * @param userBip utilisateur demandeur de l'�tat
	 * @param hParamJob ensemble des param�tres r�cup�r�s du Job (deformat, ...)
	 * @param sSchema permet de d�terminer la valeur de sUserDbId
	 */
	protected Report(	String sJobId,
						String sReportId,
						UserBip userBip,
						Hashtable hParamJob,
						String sSchema) throws ReportException
	{
		exception = null;
		this.sJobId = sJobId;
		this.sReportId = sReportId;
		this.userBip = userBip;
 
		
		
		if (sServer == null)
		{
			Object tab[] = {REPORT_SERVER};
			throw new ReportException(ReportException.REPORT_DEFAULT, new BipException(20006, null, tab));
		}
		
		//si sSchema a une valeur, celle ci vaut l'identifiant de connection
		//sinon on prend celui par defaut
		if (sSchema.length() > 0)
		{
			sSchema = sSchema.toLowerCase();
			sUserDbId = sSchema;
		}
		else
		{
			sUserDbId = sInstance;
		}
		
		hParamReport = new Hashtable(hParamJob);
		this.desNameFichierExcel = addReportParamsToHash(sSchema); 
		 
	}
	
	/**
	 * getter sur exception
	 * @return ReportException exception
	 */
	public ReportException getException()
	{
		return exception;
	}
	
	/**
	 * Construit le chemin permettant de retrouver le fichier g�n�r� � partir de sReportOut et du desname donn� au report
	 * @see genDesname(String)
	 * @return String chemin vers fichier de l'�tat
	 */
	public String getResFile()
	{
		return sReportOut+(String)hParamReport.get(PARAM_DESNAME);
	}
	
	public String getAbsoluteResFile() {
		String relatifResFile = getResFile();
		if (relatifResFile == null) {
			return null;
		}
		else {
			return cheminAbsoluGeneration + relatifResFile;
		}
	}
	
	/**
	 * Dispatch en buildSync et buildAsync.<br>
	 * Court-circuite si mode bouchon<br>
	 * Alimente exception si une ReportException est d�tect�e.
	 */
	public void build()
	{
		exception = null;
		try
		{
			if (bModeBouchon)
			{
				logBipUser.debug("Mode bouchon");
				try
				{
					Thread.sleep(iBouchonSleep);
				}
				catch (InterruptedException iE) {}
				
				return;
			}		
			if (isSynchrone(sJobId))
			{
				buildSync();
			}
			else if (isAsynchroneConcat(sJobId)) {
				buildAsyncConcat();
			}
			else
			{
				buildAsync();
			}
		}
		catch (ReportException rE)
		{
			exception = rE;
		}
	}
	
	/**
	 * Lance la g�n�ration d'un report, synchrone donc rien de plus que execReport
	 * @see execReport
	 * @throws ReportExceptino
	 */
	private void buildSync() throws ReportException
	{
		execReport();
	}

	/**
	 * Si mode bouchon ne fait rien.<br>
	 * Ins�re une nouvelle valeur dans la table des traitements asynchrones.
	 * Alimente dDate qui sera utilis� au moment de fixer le statut de cette nouvelle entr�e.
	 * @see TraitAsynchrone
	 */	
	protected void insertAsync()
	{
		
		
		if (bModeBouchon)
			return;

		String sTitre;
		String sEX;
		String sDesname;
		
		dDate = new Date();
		sTitre = cfgJob.getString(sJobId+"."+sReportId+".titre");
	
		
		
		if (cfgJob.getBoolean(sJobId+".extraction"))
		{
			sEX=TraitAsynchrone.TYPE_EXTRACTION;
		}
		else
		{
			sEX=TraitAsynchrone.TYPE_EDITION;
		}
		
		try
		{
			if (sEX.equals(TraitAsynchrone.TYPE_EDITION)){
				 
				
				sDesname=(String)hParamReport.get(PARAM_REPORT)+"@"+(String)hParamReport.get(PARAM_DESNAME);
				if (isExtractionExcel(sJobId)) {
					sDesname=getResFile();
					logBipUser.debug("sDesname = " + sJobId + " --> " + sDesname); 
				}
				TraitAsynchrone.insert(	userBip.getInfosUser(),
										sEX,
										sTitre,
										sDesname,
										dDate,
										sJobId,
										sReportId);
			}
			else {
			    //sDesname=sReportOut+userBip.getIdUser() + cfgJob.getString(sJobId+"."+sReportId+".desname");
				sDesname=getResFile();
				TraitAsynchrone.updateExtract(	userBip.getInfosUser(),
												sEX,
												sTitre,
												sDesname,
												TraitAsynchrone.STATUT_ENCOURS,
												sJobId,
												sReportId);
			}
		}
		catch (BaseException e)
		{
			//on arrete, la gestion de la table asynchrone ne doit pas poser de problemes
			BipAction.logBipUser.error("Error. Check the code", e);
			logBipUser.error(e.getMessage());
			exception = new ReportException(ReportException.REPORT_ASYNC, e);
		}
	}
	
	/**
	 * Lance la g�n�ration d'un �tat, asynchrone donc apr�s execution on met � jour la table asynchrone
	 * @see execReport
	 * @see TraitAsynchrone
	 * @throws ReportException
	 */
	private void buildAsync() throws ReportException
	{
		String sTitre;
		String sEX;
		Date dDate;
		String sDesname;
		String ident = "";
		sTitre = cfgJob.getString(sJobId+"."+sReportId+".titre");
		dDate = new Date();
				
		if (cfgJob.getBoolean(sJobId+".extraction"))
		{
			sEX=TraitAsynchrone.TYPE_EXTRACTION;
		}
		else
		{
			sEX=TraitAsynchrone.TYPE_EDITION;
		}
		
		try
		{
			try
			{
				if(sJobId.equalsIgnoreCase(JOB_HIERARCHY)){
					logBipUser.debug(">>>>>> it is an excel report - java implementation");
					ident = generateExcel();
				} else {
					execReport();	
				}
				
				//exec ok
				//on valide l'entree dans la table async
			  if (sEX.equals(TraitAsynchrone.TYPE_EDITION)){
				sDesname=(String)hParamReport.get(PARAM_REPORT)+"@"+(String)hParamReport.get(PARAM_DESNAME);
				if (isExtractionExcel(sJobId)) {
					sDesname=getResFile();
					if(sJobId.equalsIgnoreCase(JOB_HIERARCHY)){
						//sDesname = sDesname+"_"+ident+".xlsx";
						//Tools.upadateHierarchyFileExtn(hParamReport.get("P_param1").toString(), sDesname, sReportOut+hParamReport.get(PARAM_DESNAME).toString());
						hParamReport.put(PARAM_DESNAME, hParamReport.get(PARAM_DESNAME)+"_"+ident+".xlsx");
						logBipUser.debug("sDesname = " + sJobId + " --> " + sDesname+"_"+ident+".xlsx");
					} else {					
						logBipUser.debug("sDesname = " + sJobId + " --> " + sDesname);
					}
				}
				TraitAsynchrone.update(	userBip.getInfosUser(),
										sEX,
										sTitre,
										sDesname,
										dDate,
										getResFile(),
										TraitAsynchrone.STATUT_OK,
										sJobId,
										sReportId);
			  }
			  else {
			    //sDesname=sReportOut+userBip.getIdUser() + cfgJob.getString(sJobId+"."+sReportId+".desname");
			    sDesname=getResFile();
				TraitAsynchrone.updateExtract(	userBip.getInfosUser(),
												sEX,
												sTitre,
												sDesname,
												TraitAsynchrone.STATUT_OK,
												sJobId,
												sReportId);
			  }
			}
			catch (ReportException rE)
			{
				//exec ko
				//on invalide l'entree dans la table async
			  if (sEX.equals(TraitAsynchrone.TYPE_EDITION)){
				sDesname=(String)hParamReport.get(PARAM_REPORT)+"@"+(String)hParamReport.get(PARAM_DESNAME);
				if (isExtractionExcel(sJobId)) {
					sDesname=getResFile();
					logBipUser.debug("sDesname = " + sJobId + " --> " + sDesname);
				}
				TraitAsynchrone.update(	userBip.getInfosUser(),
										sEX,
										sTitre,
										sDesname,
										dDate,
										getResFile(),
										TraitAsynchrone.STATUT_KO,
										sJobId,
										sReportId);
			  }
			   else {
			    //sDesname=sReportOut+userBip.getIdUser() + cfgJob.getString(sJobId+"."+sReportId+".desname");
				sDesname=getResFile();
				TraitAsynchrone.updateExtract(	userBip.getInfosUser(),
												sEX,
												sTitre,
												sDesname,
												TraitAsynchrone.STATUT_KO,
												sJobId,
												sReportId);
			   }
			}
		}
		catch (BaseException e)
		{
			//on arrete, la gestion de la table asynchrone ne doit pas poser de problemes
			BipAction.logBipUser.error("Error. Check the code", e);
			logBipUser.error(e.getMessage());
			throw new ReportException(ReportException.REPORT_ASYNC, e);
		}
	}
	
	/**
	 * Lance la g�n�ration d'un �tat, asynchrone concat�n� donc apr�s execution on met � jour la table asynchrone
	 * @see execReport
	 * @see TraitAsynchrone
	 * @throws ReportException
	 */
	private void buildAsyncConcat()
	{
		try
		{
			execReport();
		}
		catch (ReportException rE)
		{
			// TODO
		}
	}
	
	/**
	 * Mise � jour de la table des traitements asynchrones OK (utilis�e pour la g�n�ration de rapports concat�n�s)
	 *
	 */
	public void updateAsyncOK() {
		String sTitre;
		String sEX;
		Date dDate;
		String sDesname;
		
		sTitre = cfgJob.getString(sJobId+"."+sReportId+".titre");
		dDate = new Date();
				
		if (cfgJob.getBoolean(sJobId+".extraction"))
		{
			sEX=TraitAsynchrone.TYPE_EXTRACTION;
		}
		else
		{
			sEX=TraitAsynchrone.TYPE_EDITION;
		}
		
			try
			{
				//on valide l'entree dans la table async
			  if (sEX.equals(TraitAsynchrone.TYPE_EDITION)){
				sDesname=(String)hParamReport.get(PARAM_REPORT)+"@"+(String)hParamReport.get(PARAM_DESNAME);
				if (isExtractionExcel(sJobId)) {
					sDesname=getResFile();
					logBipUser.debug("sDesname = " + sJobId + " --> " + sDesname);
				}
				TraitAsynchrone.update(	userBip.getInfosUser(),
										sEX,
										sTitre,
										sDesname,
										dDate,
										getResFile(),
										TraitAsynchrone.STATUT_OK,
										sJobId,
										sReportId);
			  }
			  else {
			    sDesname=getResFile();
				TraitAsynchrone.updateExtract(	userBip.getInfosUser(),
												sEX,
												sTitre,
												sDesname,
												TraitAsynchrone.STATUT_OK,
												sJobId,
												sReportId);
			  }
			
		}
		catch (BaseException e)
		{
			//on arrete, la gestion de la table asynchrone ne doit pas poser de problemes
			BipAction.logBipUser.error("Error. Check the code", e);
			logBipUser.error(e.getMessage());
		}
	}
	
	/**
	 * Mise � jour de la table des traitements asynchrones KO (utilis�e pour la g�n�ration de rapports concat�n�s)
	 *
	 */
	public void updateAsyncKO() {
		String sTitre;
		String sEX;
		Date dDate;
		String sDesname;
		
		sTitre = cfgJob.getString(sJobId+"."+sReportId+".titre");
		dDate = new Date();
				
		if (cfgJob.getBoolean(sJobId+".extraction"))
		{
			sEX=TraitAsynchrone.TYPE_EXTRACTION;
		}
		else
		{
			sEX=TraitAsynchrone.TYPE_EDITION;
		}
		
		try {
		// exec ko
		//on invalide l'entree dans la table async
			  if (sEX.equals(TraitAsynchrone.TYPE_EDITION)){
				sDesname=(String)hParamReport.get(PARAM_REPORT)+"@"+(String)hParamReport.get(PARAM_DESNAME);
				if (isExtractionExcel(sJobId)) {
					sDesname=getResFile();
					logBipUser.debug("sDesname = " + sJobId + " --> " + sDesname);
				}
				TraitAsynchrone.update(	userBip.getInfosUser(),
										sEX,
										sTitre,
										sDesname,
										dDate,
										getResFile(),
										TraitAsynchrone.STATUT_KO,
										sJobId,
										sReportId);
			  }
			   else {
				sDesname=getResFile();
				TraitAsynchrone.updateExtract(	userBip.getInfosUser(),
												sEX,
												sTitre,
												sDesname,
												TraitAsynchrone.STATUT_KO,
												sJobId,
												sReportId);
			   }
		}
		catch (BaseException e)
		{
			// Arr�t, la gestion de la table asynchrone ne doit pas poser de problemes
			BipAction.logBipUser.error("Error. Check the code", e);
			logBipUser.error(e.getMessage());
			exception = new ReportException(ReportException.REPORT_ASYNC, e);
		}
	}
	
	/**
	 * Recherche dans le fichier de param�trage si le job donn� est synchrone ou non
	 * 
	 * @param sJobId identifiant sur le job de report dans le fichier des ressources
	 * @return boolean la valeur dela propri�t� synchrone dans le fichier des ressources des reports pour le job donne
	 */
	public static boolean isSynchrone(String sJobId)
	{
		return cfgJob.getBoolean(sJobId+".synchrone");
	}
	
	public static boolean isAsynchroneConcat(String sJobId) {
		return cfgJob.getBooleanOrDefaultValue(sJobId+".asynchroneConcat", false);	
	}
	
	/**
	 * Recherche dans le fichier de param�trage si le job donn� est une extraction ou non
	 * 
	 * @param sJobId identifiant sur le job de report dans le fichier des ressources
	 * @return boolean la valeur dela propri�t� edition dans le fichier des ressources des reports pour le job donne
	 */
	public static boolean isExtraction(String sJobId)
	{
		return cfgJob.getBoolean(sJobId+".extraction");
	}
	
	/**
	 * Recherche dans le fichier de param�trage si le job donn� est une extraction pour une pr�sentation Excel
	 * 
	 * @param sJobId identifiant sur le job de report dans le fichier des ressources
	 * @return boolean la valeur dela propri�t� edition dans le fichier des ressources des reports pour le job donne
	 */
	private boolean isExtractionExcel(String sJobId) {
		try {
			return cfgJob.getBoolean(sJobId + ".extractForExcel");
		} catch (Exception e) {
			return false;
		}
	}
	
	public static boolean isExtractionMiseEnForme(String sJobId) {
		try {
			return cfgJob.getBoolean(sJobId + ".extractMiseEnForme");
		} catch (Exception e) {
			return false;
		}
	}
	
	/**
	 * addReportParamsToHash <br>
	 * La m�thode ajoute les informations sp�cifiques au report, <br>
	 * le report est identifi� par l'identifiant du job auquel il est associ� et son n�<br>
	 * Si l'�tat est de type extraction , les param�tres desname et delimter sont recherch�s<br>, 
	 * et le destype prend la valeur "FILE" � la place de celle d�finie dans le fichier des ressources
	 *
	 * @param sSchema permet de d�terminer le nom du fichier de module pour les �tats historiques
	 */
	private String addReportParamsToHash(String sSchema)
	{
		String sModule;
		String sDesname;
		boolean sShow; 
		
		//Permet r�cup�rer le nom du fichier qui sera g�n�r�
		//Si c'est une extraction Excel (utilis� pour r�cup�rer entre autres le timeStamp g�n�r�)
        String desNameFichier  = null ;
		
		hParamReport.put(PARAM_SERVER, sServer);
		
		String extension = ".xml";
		try {
			// V�rification de la pr�sence du fichier xml
			cfgJob.getObject(sJobId+"."+sReportId+extension);
		} catch (MissingResourceException ex) {
			// Sinon le rapport est au format rdf
			extension = ".rdf";
		}
		
		sModule = cfgJob.getString(sJobId+"."+sReportId+extension);
		
		if (sSchema.length() != 0)
		{
			sSchema = "_"+sSchema;
			int extPos = sModule.lastIndexOf(extension);
			if (extPos == -1)
			{
				sModule+=sSchema; 			
			}
			else
			{
				sModule = sModule.substring(0, extPos) + sSchema + extension;
			}
		}
		
		hParamReport.put(PARAM_REPORT, sModule);

           sShow = cfgJob.getBooleanOrDefaultValue(sJobId+"."+sReportId+".show", true);
        

		//cas des extractions ...
		if (cfgJob.getBoolean(sJobId+".extraction"))
		{
			//sDesname=userBip.getIdUser() + cfgJob.getString(sJobId+"."+sReportId+".desname");
			sDesname=genDesname(false, sShow) + cfgJob.getString(sJobId+"."+sReportId+".desname");
			hParamReport.put(PARAM_DELIMITER, cfgJob.getString(sJobId+"."+sReportId+".delimiter"));
			hParamReport.put(PARAM_DELIMITED_HDR, cfgJob.getString(sJobId+"."+sReportId+".delimited_hdr"));
		}
		//cas des extractions pour tableau Excel...

		else if (isExtractionExcel(sJobId))
		{
			sDesname=genDesname(false, sShow) + cfgJob.getString(sJobId+"."+sReportId+".desname");
			desNameFichier = sDesname ;  
			logBipUser.debug("addReportParamsToHash >> sDesname = " + sJobId + " --> " + sDesname);
			hParamReport.put(PARAM_DELIMITER, cfgJob.getString(sJobId+"."+sReportId+".delimiter"));
			hParamReport.put(PARAM_DELIMITED_HDR, cfgJob.getString(sJobId+"."+sReportId+".delimited_hdr"));
		}
		else
		{
			sDesname=genDesname(true, sShow);
		}

		hParamReport.put(PARAM_DESNAME, sDesname);
		
		String sPatronCleFixe = "fixe_"; 		
		try
		{
			for (int i=1; i<= 10; i++)
			{
				String sCleFixe = sPatronCleFixe + i;
				String sValFixe = cfgJob.getString(sJobId+"."+sReportId+"."+sCleFixe);
				
				hParamReport.put(sCleFixe, sValFixe);
			}
		}
		catch (CriticalRuntimeException cRE)
		{
			
		}
		
		return desNameFichier ; 
		
	}
	
	/**
	 * Contruit le nom de sortie (desname) pour les Editions
	 * @param sUserId identifiant de l'utilisateur
	 * @param hParams hastable
	 */
	private String genDesname(boolean bEdition, boolean bShow)
	{
		
		String sDesname = userBip.getIdUser();
		//si il ne faut pas afficher alors on enleve la date du nom
		if (bShow) {
			sDesname += "_"+Calendar.getInstance().getTime().getTime();
		}
		else{
			sDesname += "_";
		}
		   
		// si c'est une �dition
		if (bEdition) {
			String sPatronCleFixe = "desname"; 
			try
			{
				String sValFixe = cfgJob.getString(sJobId+"."+sReportId+"."+sPatronCleFixe);
				sDesname = sDesname + sValFixe;
			}
			catch (CriticalRuntimeException cRE)
			{
				sDesname = sDesname + "";
			}
			sDesname += "."+(String)hParamReport.get(PARAM_DESFORMAT);
		}
		sDesname = sDesname.toLowerCase();
		
		if (logBipUser.isDebugEnabled())
			logBipUser.debug("Desname : " + sDesname);

		return sDesname;
	}

	/**
	 * Recup�re la cha�ne d'identification oracle corespondant � la cl� donn�e.
	 * @return String la cha�ne de la forme  userid=login/passwd@shema
	 */
	protected String getUserDbId(String sReportInstance)
	{
		return cfgReports.getString("report.userDbId."+sReportInstance);
	}
	
	/**
	 * Method to generate excel sheet uing POI implementation
	 * @throws ReportException
	 * @throws ClassNotFoundException 
	 * @throws SQLException 
	 */
	private String generateExcel() throws ReportException{
		
		String signatureMethode = "Report - generateExcel()";
		logBipUser.entry(signatureMethode);
		HierarchyAction hierarchyAction = new HierarchyAction();
		String ident;
		try
		{
			ident = hierarchyAction.generateExcel(hParamReport, sReportOut, cfgReports, userBip);
			
		}
		catch (IOException e)
		{
			throw new ReportException(ReportException.REPORT_FAILURE, e);
		}
		
		logBipUser.debug("Report.generateExcel : G�n�ration termin�e, Etat accessible via : "+sReportOut+(String)hParamReport.get(PARAM_DESNAME)+"_"+ident+".xlsx");
		return ident;
	}
	
	/**
	 * Appel du report server.<br>
	 * On lance un appel system sur le script (sReportCmd) qui avec tous les parm�tres contenus dans hParamReport va g�n�rer l'�tat.
	 * @throws ReportException
	 */
	private void execReport() throws ReportException
	{
		String sTmp;
		String sReportCmd;
		String [] sCmdArray;
		sCmdArray = new String[hParamReport.size()+2];
		int i=0;
		
		sTmp = Tools.getSysProperties().getProperty(DIR_REPORT_CMD);
		if (sTmp == null)
		{
			Object tab[] = {DIR_REPORT_CMD};
			//il n'est pas normal de ne pas avoir la var de definie => erreur
			throw new ReportException(ReportException.REPORT_DEFAULT, new BipException(20006, null, tab));
		}
		sReportCmd = sTmp;
		
		sTmp = Tools.getSysProperties().getProperty(REPORT_CMD);
		if (sTmp == null)
		{
			Object tab[] = {REPORT_CMD};
			//il n'est pas normal de ne pas avoir la var de definie => erreur
			throw new ReportException(ReportException.REPORT_DEFAULT, new BipException(20006, null, tab));
		}
		sReportCmd += "/"+sTmp;
		
		sCmdArray[i++] = sReportCmd;
		sCmdArray[i++] = getUserDbId(sUserDbId);
		
		for (Enumeration enums=hParamReport.keys(); enums.hasMoreElements(); )
		{
			sTmp = (String)enums.nextElement();
			sCmdArray[i++] = sTmp + "='" + (String)hParamReport.get(sTmp)+"'";
		}
		// sCmdArray est maintenant complet, il contient touts les parametres necessaires pour la generation du reports
		
		if (logBipUser.isDebugEnabled())
		{
			sTmp = "";
			for (i=0; i<sCmdArray.length; i++)
			{
				sTmp += " " + sCmdArray[i];
			}
			logBipUser.debug("Ligne de commande : " + sTmp);
		}
		
		 
	   
		
		try
		{
			Runtime rt = Runtime.getRuntime();
			Process proc = rt.exec(sCmdArray, null, null);
			if ( proc.waitFor() != 0 ) {
				BufferedReader d = new BufferedReader(new InputStreamReader(proc.getInputStream()));
				StringBuffer sbe = new StringBuffer();
				try {
					String ls_str2 = "";
					while ((ls_str2 = d.readLine()) != null) {
						sbe.append(ls_str2);
					}
				} catch (Exception rd) {
				}
				logBipUser.debug("Flux d'input  : " + sbe.toString());

				d = new BufferedReader(new InputStreamReader(proc.getErrorStream()));
				sbe = new StringBuffer();
				try {
					String ls_str2 = "";
					while ((ls_str2 = d.readLine()) != null) {
						sbe.append(ls_str2);
					}
				} catch (Exception rd) {
				}
				logBipUser.debug("Flux d'erreur : " + sbe.toString());

				throw new ReportException(ReportException.REPORT_FAILURE, null);
			}
		}
		catch (IOException e)
		{
			throw new ReportException(ReportException.REPORT_FAILURE, e);
		}
		catch (InterruptedException ie)
		{
			throw new ReportException(ReportException.REPORT_FAILURE, ie);
		}
		
		logBipUser.debug("Report.execReport : G�n�ration termin�e, Etat accessible via : "+sReportOut+(String)hParamReport.get(PARAM_DESNAME));
	}
	
	/**
	 * La m�thode lance la proc�dure stock�e (s'il y en a une de donn�e pour le job sp�cifi�)<br>
	 * Si le job est de type historique, la proc�dure de v�rification retourne le nom du sh�mas.
	 * 
	 * @param sJobId l'identifiant du job
	 * @param hParamsJob la liste des param�tres du job
	 * @return String	- chaine vide si ok et pas histo<br>
	 * 					- nom du shema si ok et histo<br>
	 * @throws ReportException - si les param�tres sont invalides ou s'il y a une probl�me d'ex�cution de la proc�dure stock�e de v�rification
	 */
	public static String checkParamJob(	String sJobId,
											Hashtable hParamsJob)
											throws ReportException
	{
		Vector vRes;
		String sProcId;
		String sMsg;
		String sDataSource;
		String sNomShema;
		boolean bIsHisto;
		
		 
		
		sProcId = cfgJob.getString(sJobId+".proc");
		bIsHisto = cfgJob.getBoolean(sJobId+".histo");

		//la proc peut ne pas etre definie mais uniquement si le job n'est pas historique
		if (sProcId.equals(""))
		{
			if (bIsHisto)
			{
				logBipUser.info("Report.checkParamJob: pas de proc associ�e � un job histo");
				throw new ReportException(ReportException.REPORT_PROCHISTO, null);
			}
			else
			{
				if (logBipUser.isDebugEnabled())
					logBipUser.debug("Report.checkParamJob: Pas de proc�dure de validation pour le job '" + sJobId + "'");
				return "";
			}
		}

		//la proc est d�finie ... on lance la v�rification
		JdbcBip jdbc = new JdbcBip();
			
	
		//appel JdbcBip
		try
		{
			logBipUser.info("Report.checkParamJob: Appel de la procedure de v�rification '" + sProcId + "'");
			vRes = jdbc.getResult(hParamsJob, cfgProc, sProcId);
		}
		catch (BaseException e)
		{
			//verfier que la cause de l'exception est fonctionnelle
			if ( (e.getSubType() == BaseException.BASE_ERR_PROC) &&
				(e.getInitialException() != null) &&
				(e.getInitialException().getMessage().indexOf(PREFIXE_ERR_ORA_BIP) != -1) )
			{
				//erreur applicative
				String sMsgErreur = e.getInitialException().getMessage();
				String [] sMsgOracle = { BipException.getMessageOracle(sMsgErreur) };
				logBipUser.debug("Report.checkParamJob:Parametres invalide fonctionnellement : " + sMsgOracle[0]);
				//logBipUser.debug(e.getMessage(), e);
					
				//throw new ReportException(ReportException.REPORT_BADPARAM, e.getInitialException(), sMsgOracle);
				throw new ReportException(ReportException.REPORT_BADPARAM, null, sMsgOracle);
			}
			else
			{
				//erreur 'grave'
				logBipUser.error("Report.checkParamJob:Probleme avec appel proc : " + e.getMessage());
				throw new ReportException(ReportException.REPORT_FAILURE, e);
			}
		}finally
		{
			
			jdbc.closeJDBC();
		}
		
		
		if (bIsHisto)
		{
			if ( vRes.size() < 2)
			{
				logBipUser.debug("taille de vRes : " + vRes.size());
				for (int i=0; i<vRes.size(); i++) logBipUser.debug(""+i+" "+vRes.get(i).getClass());
				//vRes invalide !!!
				//return null ou throw ReportException ?
				logBipUser.error("Report.checkParamJob:histo: format du vRes non valide");
				throw new ReportException(ReportException.REPORT_DEFAULT, null);
			}
			
			//tester la chaine message de retour, si longuer > 0 => erreur
			sMsg = (String)((ParametreProc)vRes.get(1)).getValeur();
			sNomShema = (String)((ParametreProc)vRes.get(0)).getValeur();
		}
		else
		{
			sNomShema = "";
			sMsg = null;
			if ( ( vRes.size() > 0) && (vRes.get(0) instanceof String) )
			{	
				sMsg = (String)vRes.get(0);
			}
		}
		
		
		if ( (sMsg != null) && (sMsg.length() > 0) )
		{
			//erreur fonctionnelle c'est certain
			logBipUser.info("Report.checkParamJob:Parametres invalides fonctionnellement : " + sMsg);
			Object [] msgOracle= { sMsg	};
			throw new ReportException(ReportException.REPORT_BADPARAM, null, msgOracle);
		}
		
		
		return  sNomShema;
	}
	/**
	 * Returns the sJobId.
	 * @return String
	 */
	public String getJobId() {
		return sJobId;
	}

	/**
	 * Returns the sReportId.
	 * @return String
	 */
	public String getReportId() {
		return sReportId;
	}
	
	/**
	 * Returns the userid.
	 * @return String
	 */
	public String getUserId() {
		return userBip.getIdUser();
	}

	/**
	 * R�cup�re le label associ� au Job.<br>
	 * Static pour permettre aux pages jsp d'afficher l'info � partir du job.
	 * @param sJobId le job dont on rechecherche le libell�
	 */
	public static String getTitre(String sJobId)
	{
		try
		{
			return cfgJob.getString(sJobId);
		}
		catch (CriticalRuntimeException cE)
		{
			return null;
		}
	}
	
	/**
	 * @return String de la forme [userId] jobId.reportId
	 */
	public String toString()
	{
		return "["+userBip.getIdUser()+"] "+sJobId+"."+sReportId;
	}
	
	/**
	 * @return le nom du fichier rdf utilis� pour g�n�rer l'�tat
	 */
	public String getFichierRDF()
	{
		return (String)(hParamReport.get(PARAM_REPORT));
	}
	
	


	public String getDesNameFichierExcel() {
		return desNameFichierExcel;
	}

	public void setDesNameFichierExcel(String desNameFichierExcel) {
		this.desNameFichierExcel = desNameFichierExcel;
	}

	public Hashtable getHParamReport() {
		return hParamReport;
	}

	public void setHParamReport(Hashtable paramReport) {
		hParamReport = paramReport;
	}

	public UserBip getUserBip() {
		return userBip;
	}

	public void setUserBip(UserBip userBip) {
		this.userBip = userBip;
	}

	public String getSUserDbId() {
		return sUserDbId;
	}

	public void setSUserDbId(String userDbId) {
		sUserDbId = userDbId;
	}
	
	
	
}