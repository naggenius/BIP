package com.socgen.bip.metier;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Date;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.LinkedList;
import java.util.Vector;

import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.pdf.PdfContentByte;
import com.itextpdf.text.pdf.PdfImportedPage;
import com.itextpdf.text.pdf.PdfReader;
import com.itextpdf.text.pdf.PdfWriter;
import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.ReportException;
import com.socgen.bip.user.UserBip;
import com.socgen.cap.fwk.ServiceManager;
import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.config.ConfigManager;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.cap.fwk.log.Log;

/**
 * @author E.GREVREND
 * La classe ReportManager a �t� d�velopp�e pour pouvoir contenir les appels de reports concurrents trop nombreux<br>
 * Le but est de limiter le nombre d'appels simultan�s au server de reports qui pourrait cesser de fonctionner correctement<br>
 * Les reports synchrones sont prioritaires vis � vis des asynchrones.<br>
 * Le fonctionnement g�n�ral est le suivant :<br>
 * Une demande de job est effectu�e via ma m�thode addJob, les �tats correspondant � ce job sont empil�s dans les Vectors correspondant.<br>
 * La boucle principal (ReportManager est un Thread) s'occuper, si le nombre d'appels en cours le permet, de lancer les �tats en attente.<br>
 * La classe ThreadReport permet de lancer en arri�re plan ces appels, c'est elle qui va retirer de la liste des �tats en cours ceux qui sont termin�s.
 * @see ReportManager
 * @see com.socgen.bip.metier.ThreadReport
 */
public class ReportManager extends Thread implements BipConstantes
{
	
	protected static final String sLogCat = "BipUser";
	//protected static Log logBipUser = ServiceManager.getInstance().getLogManager().getLogInstance(sLogCat);
	
	
	/**
	 * Logger de suivi des actions des utilisateurs
	 */
	protected static Log logService = ServiceManager.getInstance().getLogManager().getLogService();
	
	/**
	 * nbMax va prendre le nombre maximal de job SIMULTANES
	 */
	private int nbMax;
	
	/**
	 * Vector contenant la liste des �tats Synchrones en attente de traitement, ils sont majoritaires sur les asynchrones.
	 */
	private Vector vSync;
	/**
	 * Vector contenant la liste des �tats Asynchrones en attente de traitement
	 */
	private Vector vAsync;
	/**
	 * Vector contenant la liste des �tats Asynchrones � concat�ner en attente de traitement
	 */
	private LinkedList vAsyncConcat;
	/**
	 * Vecteur contenant le liste des �tats en cours de traitement, de fait sa taille ne peut depasser nbMax
	 */
	private Vector vCurrenrReports;
	/**
	 * Instance du ReportManager
	 */
	static private ReportManager instance = null;
	/**
	 * R�f�rence au fichier de ressource des proc�dures stock�es
	 */
	protected static Config configProc = ConfigManager.getInstance(BIP_PROC) ;
	/**
	 * Cle pour acc�der � la proc stock 'insert_log' dans le fichier de ressource configProc
	 */
	protected static String PROC_INSERT = "report_log.insert";
	
	
	protected String timestampFichierExtractionLignesBip ; 
	
	protected String timestampOrbre ; 
	
	
	protected String FIN_FICHIER_LIGNES_BIP_FOURNISSEUR = ".ELIGNES_BIP_FOURNISSEUR.csv" ; 
	protected String FIN_FICHIER_LIGNES_BIP_FOURNISSEUR_CLIENT = ".ELIGNES_BIP_FOURNISSEUR_CLIENT.csv" ;
	
	protected String FILE_ORBRE = ".SSTACHE_RES_ORBRE.csv" ; 
	
	public static String JOB_SYNCHRONE = "1";
	public static String JOB_ASYNCHRONE = "2";
	public static String JOB_ASYNCHRONE_CONCATEN = "3";
	
	/**
	 * Constucteur priv�
	 * @see getInstance()
	 */
	private ReportManager()
	{
		super();
		logService.info("ReportManager : nouvelle instance");
		
		nbMax = Report.cfgReports.getInt("report.manager.max");
		
		vSync = new Vector();
		vAsync = new Vector();
		vAsyncConcat = new LinkedList();
		vCurrenrReports = new Vector();
		
		start();
	}
	
	/**
	 * Retourne l'instance statique du ReportManager, si elle est encore a 'null' elle est instanci�e.
	 */
	public synchronized static ReportManager getInstance()
	{
		if (instance == null)
		{
			instance = new ReportManager();
		}
		return instance;
	}
	
	/**
	 * Ajout d'un job � effectuer
	 * Chaque �tat � g�n�rer est ajout� � la file d'attente lui correspondant (synchrone/asynchrone)
	 * C'est le thread principal qui va s'occuper de les lancer.
	 * Si le job est synchrone, on attend la fin du traitement mpour rendre la main (en retournant le chemin d'acc�s au fichier g�n�r�)<br>
	 * @param sJobId identifiant du job � g�n�rer
	 * @param vListeReports la liste des �tats � g�n�rer
	 * @param userBip l'utilisateur demandeur des �tats
	 * @param hParamJob les param�tres li�s au job
	 * @param sSchema si historique contient le schema � utiliser
	 * @param typeJob job synchrone / asynchrone / asynchrone concat�n� ?
	 * @throws ReportException
	 */
	public String addJob(	String sJobId,
							Vector vListeReports,
							UserBip userBip,
							Hashtable hParamJob,
							String sSchema,
							String typeJob) throws ReportException
	{
		String sMsg;
		String sLocation = null;
		ReportException rE;
		Report rTmp;
		
		
		String desNameFichierInitial = null ; 
		
		
		sMsg = "ReportManager.addJob : ";
		// JOB Synchrone : lancement imm�diat
		if (JOB_SYNCHRONE.equals(typeJob))
		{		
			rTmp = new Report(sJobId, (String)vListeReports.get(0), userBip, hParamJob, sSchema);
			
			if (logService.isDebugEnabled())
				logService.debug(sMsg + "Ajout de " + rTmp.toString() + " dans le vSync, new size : " + (vSync.size()+1));
			vSync.add(rTmp);
			
			try
			{
				while ( (vSync.contains(rTmp)) || (vCurrenrReports.contains(rTmp)) )
				{
					sleep(200);
				}
			}
			catch (InterruptedException iE)
			{
				logService.error(sMsg + "Probleme lors de l'attente de fin de generation pour report synchrone " + rTmp.toString());
				return null;
			}
			
			rE = rTmp.getException();
			
			if (rE != null)
				throw rE;

			sLocation = rTmp.getResFile();
			
			if (logService.isDebugEnabled())
				logService.debug(sMsg + "return " + sLocation);
		}
		// JOB Asynchrone : traitement diff�r�
		else
		{
			for (int i=0; i< vListeReports.size(); i++)
			{		
				rTmp = new Report(sJobId, (String)vListeReports.get(i), userBip, hParamJob, sSchema);
					
				if (logService.isDebugEnabled())
					logService.debug(sMsg + "Ajout de " + rTmp.toString() + " dans le vAsync, new size : " + (vAsync.size()+1));
		 			 				 
				//Si fichier trait� =  Fichier principal d'Extraction LIGNES BIP PERSONNALISEES : "LIGNES_BIP_FOURNISSEUR.csv"
				// r�cup�rer timestamp dans le nom de fichier g�n�r� dynamiquement 
				// Les noms de JOB "xLigneBipAd2.1" et  "xLigneBipAd1.1" proviennent du fichier bip_reports_job.properties
				// et correspondent aux extractions : 
				// "Edition Lignes BIP Fournisseur" et Edition Lignes BIP Fournisseur et Client 
				
				 //logBipUser.debug( "########## DEBUG DEBUT REPORTMANAGER : JOB =" + rTmp.toString() );
				
				  // ------------------------------------------  Nom des jobs possibles ----------------------------------------------------------------- 
				 //Extraction Tout p�rim�tre et Fournisseurs               : fichier donn�es =  xLigneBipAd1.1  /  fichier param�tres =  xLigneBipAd1.3 
				 //Extraction Tout p�rim�tre et Fournisseurs et Clients    : fichier donn�es =  xLigneBipAd1.2  /  fichier param�tres =  xLigneBipAd1.3  
				 //Extraction Code DPG et Fournisseurs                     : fichier donn�es =  xLigneBipAd2.1  /  fichier param�tres =  xLigneBipAd2.3 
				 //Extraction Code DPG et Fournisseurs et clients          : fichier donn�es =  xLigneBipAd2.2  /  fichier param�tres =  xLigneBipAd2.3 
			     if(    (rTmp.toString().indexOf("xLigneBipAd1.1")>-1) ||  (rTmp.toString().indexOf("xLigneBipAd1.2")>-1) 
			    	 || (rTmp.toString().indexOf("xLigneBipAd2.1")>-1) ||  (rTmp.toString().indexOf("xLigneBipAd2.2")>-1)	 ){
			    	    //R�cup�re le nom du fichier g�n�r� dynamiquement
				       desNameFichierInitial = rTmp.getDesNameFichierExcel() ;					       					       
				       //logBipUser.debug("############################## TRAITEMENT FICHIER DONNEES  -> " + desNameFichierInitial);
				       
				       if( (rTmp.toString().indexOf("xLigneBipAd1.1")>-1)  || (rTmp.toString().indexOf("xLigneBipAd2.1")>-1) ){ 
				    	  //logBipUser.debug( "###### JOB DETECTE : FOURNISSEURS  ");
				          this.timestampFichierExtractionLignesBip =  getTimeStampFromCommand(desNameFichierInitial, FIN_FICHIER_LIGNES_BIP_FOURNISSEUR) ;
				       }else{
				    	   //logBipUser.debug( "###### JOB DETECTE : FOURNISSEURS ET CLIENTS");
				    	  this.timestampFichierExtractionLignesBip =  getTimeStampFromCommand(desNameFichierInitial, this.FIN_FICHIER_LIGNES_BIP_FOURNISSEUR_CLIENT) ;
				       }
				       //logBipUser.debug("########## Report Manager -> timeStamp :  -> " +  this.timestampFichierExtractionLignesBip);
			     }
			     		
			     //Si fichier trait� = Fichier Param�tre d'Extraction LIGNES BIP PERSONNALISEES
			     if( (rTmp.toString().indexOf("xLigneBipAd1.3")>-1) ||  (rTmp.toString().indexOf("xLigneBipAd2.3")>-1)  ){
			    	// logBipUser.debug("############################ TRAITEMENT  FICHIER PARAMETRE ");
			    	/* if(rTmp.toString().indexOf("xLigneBipAd1.3")>-1){
			    		 logBipUser.debug("########### Job 1.3 ");
			    	 }else{
			    		 logBipUser.debug("########### Job 2.3 ");
			    	 }*/
			    	 desNameFichierInitial = rTmp.getDesNameFichierExcel() ;				    	 
			    	 String nomFichierParametres  = rajoutTimeStampFichierParametres(desNameFichierInitial,this.timestampFichierExtractionLignesBip) ;			    	 			    	 
			    	 rTmp.getHParamReport().put(rTmp.PARAM_DESNAME,nomFichierParametres) ; 
			    	 //logBipUser.debug("###########   Fichier de param�tres FINAL  -> " +  nomFichierParametres);
			     }
			     
				if (rTmp.toString().indexOf("xOrbre1.1") > -1) {
					desNameFichierInitial = rTmp.getDesNameFichierExcel();
					this.timestampOrbre = getTimeStampFromCommand(
							desNameFichierInitial,
							FILE_ORBRE);
				} 
				
				if(rTmp.toString().indexOf("xOrbre1.2")>-1){
			    	
			    	 desNameFichierInitial = rTmp.getDesNameFichierExcel() ;				    	 
			    	 String nomFichierParametres  = rajoutTimeStampFichierParametres(desNameFichierInitial,this.timestampOrbre) ;			    	 			    	 
			    	 rTmp.getHParamReport().put(rTmp.PARAM_DESNAME,nomFichierParametres) ; 
			     }
				
				
				
				
				rTmp.insertAsync();
				vAsync.add(rTmp);
			}
		}

		return sLocation;
	}
	
	/**
	 * Ajout des jobs � traiter pour g�n�ration puis concat�nation
	 * @param listeJobs liste des jobs � traiter
	 * @return
	 * @throws ReportException
	 */
	public void addJobsToConcat(LinkedList<Job> listeJobs) throws ReportException {
		// JOB Asynchrone concat�n� : traitement diff�r� de concat�nation de rapports
		
		Report rTmp;
		LinkedList<Report> vAsyncConcatTmp = new LinkedList<Report>();
		String sMsg = "ReportManager.addJobsToConcat : ";
		
		// Pour chaque job
		for (Job job : listeJobs) {
			Vector listeReports = job.getListeReportsEnum();
			// Pour chaque rapport (par d�faut un seul)
			for (int i=0; i < listeReports.size(); i++)
			{		
				// Instanciation d'un rapport � partir du job - le nom du rapport est d�fini lors de l'instanciation
				rTmp = new Report(job.getJobId() , (String)listeReports.get(i), job.getUserBip(), job.getParamsJob(), job.getSchema());
				// Insertion d'une nouvelle valeur dans la table des traitements asynchrones
				//rTmp.insertAsync();
				//vAsync.add(rTmp);
				// Ajout du rapport � la liste temporaire
				vAsyncConcatTmp.add(rTmp);
				
				// Attendre afin qu'il y ait un d�lai entre chaque instanciation de report (le nom du report, qui doit �tre unique, d�pend de l'instant d'instanciation)
				try {
					sleep(2);
				}
				catch (InterruptedException iE)
				{
					logService.error("ReportManager.addJobsToConcat : pb avec un sleep entre deux instanciations de report");
				}
			}
		}
		
		if (!vAsyncConcatTmp.isEmpty()) {
			Report exempleRapport = vAsyncConcatTmp.getFirst();
			// Instanciation d'un rapport correspondant au rapport concat�n� qui sera g�n�r�
			Report reportResult;
			try {
				reportResult = getRapportConcatFromRapportExemple(exempleRapport);
				// Insertion d'une nouvelle valeur dans la table des traitements asynchrones
				reportResult.insertAsync();
				
				ReportConcat reportConcat = new ReportConcat(vAsyncConcatTmp, reportResult);
				
				if (logService.isDebugEnabled()) {
					logService.debug(sMsg + "Ajout de " + reportResult.toString() + " dans le vAsyncConcat, new size : " + (vAsyncConcat.size()+1));
				}
				
				// Ajout de la liste des rapports � traiter � la liste existante des traitements de concat�nation asynchrone
				vAsyncConcat.add(reportConcat);
				
			} catch (ReportException e) {
				logService.error("Probleme lors de l'instanciation d'un rapport concatene ");
			}
		}
	}

	/**
	 * Boucle principale du ReportManager.<br>
	 */
	public void run()
	{
		Report rTmp;
		ReportConcat reportConcatTmp;
		
		logService.info("ReportManager : Go !!!!");
		while(true)
		{
			synchronized (this)
			{
				if (isServerFree())
				{
					if (!vSync.isEmpty())
					{
						rTmp = (Report)vSync.firstElement();
						launchReport(rTmp, true);
					}
					else if (!vAsync.isEmpty())
					{
						rTmp = (Report)vAsync.firstElement();
						launchReport(rTmp, true);
					}
					else if (!vAsyncConcat.isEmpty()) {
						reportConcatTmp = (ReportConcat) vAsyncConcat.element();
						launchConcatReport(reportConcatTmp);
					}
				}
				else
				{
					if (logService.isDebugEnabled())
						logService.debug("ReportManager.run : server NOT free : "+vCurrenrReports.size()+"/"+nbMax+" (vS:"+vSync.size()+" - vAs:"+vAsync.size()+" - vAsConcat:"+vAsyncConcat.size()+")");
				}
				try
				{
					sleep(200);
				}
				catch (InterruptedException iE)
				{
					logService.error("ReportManager.run : pb avec un sleep");
				}
			}
		}
	}
	
	/**
	 * Traitement d'un report en attente.<br>
	 * Il est tout d'abord ajout� � la liste des reports en court puis retir� de ceux en attente<br>
	 * Un thread ThreadReport est ensuite instancie, c'est celui-ci qui va faire l'appel de g�n�ration en arri�re plan.
	 * @param report l'instance du report � g�n�rer
	 */
	private void launchReport(Report report, boolean removeReport)
	{
		String sMsg;
		
		JdbcBip jdbc = new JdbcBip(); 
		
		sMsg = "ReportManager.launchReport : ";
		
		vCurrenrReports.add(report);
		
		if (removeReport) {
			removeReport(report);
		}
		
		if (logService.isDebugEnabled())
			logService.debug(sMsg + " on lance un report en attente : " + report.toString());
		
		/*
		 * On alimente la base pour compter les reports g�n�r�s (ie. les rdf) 
		 */
		String filtres = "<ul>";
		String P_gobal = "";
		String nom_etat ="";
		String arborescence ="";;
		
		for(Enumeration enums =report.getHParamReport().keys(); enums.hasMoreElements();)
		{
				String sP = (String)enums.nextElement();
			 
				logService.debug("	" + sP + "	: " + (String)report.getHParamReport().get(sP));
				if (sP.equals("P_global") )
					P_gobal = (String)report.getHParamReport().get(sP);
				if (sP.equals("arborescence") )
					arborescence= (String)report.getHParamReport().get(sP);
				if (sP.equals("desname") )
					nom_etat = (String)report.getHParamReport().get(sP);
				// on recup�re uniquement les p_param � partir de p_param6
				if ("P_param1,P_param2,P_param3,P_param4,P_param5,".indexOf(sP) == -1 && sP.indexOf("P_param") >= 0)
					filtres  = filtres +"<li>"+ sP + ":" + (String)report.getHParamReport().get(sP)+"</li>";
		}
		
		filtres = filtres +"<ul>"; 
		
		Hashtable<String,String> hParam = new Hashtable<String,String>();
		hParam.put("id_user", report.getUserId());
		hParam.put("fichier_pdf", report.getFichierRDF());
		hParam.put("P_gobal",P_gobal);
		hParam.put("nom_etat",nom_etat);
		hParam.put("filtres",filtres);
		hParam.put("jobid",report.getJobId());
		hParam.put("arborescence",arborescence);
		
		logService.debug("test variable " +nom_etat);
		
		try
		{
			jdbc.getResult(	hParam,
									configProc,
									PROC_INSERT);			
		}
		catch (BaseException bE)
		{
			//Non bloquant
		}
		
		jdbc.closeJDBC();
		ThreadReport tR = new ThreadReport(report);
		tR.start();
	}
	
	/**
	 * Taritement d'une liste de reports � concat�ner.<br>
	 * Il est tout d'abord ajout� � la liste des reports en court puis retir� de ceux en attente<br>
	 * Un thread ThreadReport est ensuite instancie, c'est celui-ci qui va faire l'appel de g�n�ration en arri�re plan.
	 * @param concatReport l'instance de liste des reports � g�n�rer puis concat�ner
	 */
	private void launchConcatReport(ReportConcat concatReport) {
		ReportException except;
		
		if (concatReport != null) {
			LinkedList<Report> listeReport = concatReport.getListeReport();
			Report reportResult = concatReport.getReportResult();
			
			// Si la liste des rapports n'est pas vide
			if (listeReport != null  && !listeReport.isEmpty()) {
				Date dateReference;
				Date dateCourante;
				
				// Dur�e max d'attente de disponibilit� du serveur (en ms)
				int dureeAttenteDispoServeurMax = Report.dureeAttenteDispoServeurMax;
				
				// Pour chaque rapport
				for (Report report : listeReport) {
					boolean timeOutDepasse = false;
					
					// Instanciation d'une nouvelle date de r�f�rence
					dateReference = new Date();
					
					// Si le nombre de rapports en cours de g�n�ration ne d�passe pas la borne max
					while (!isServerFree() && !timeOutDepasse) {
						
						try
						{
							// Attente de 200ms
							sleep(200);
						}
						catch (InterruptedException iE)
						{
							logService.error("ReportManager.launchConcatReport : pb avec un sleep");
						}
						// Instanciation d'une nouvelle date courante
						dateCourante = new Date();
						// Si la dur�ee d'attente max est d�pass�e
						if (dateCourante.getTime() - dateReference.getTime() > dureeAttenteDispoServeurMax) {
							timeOutDepasse = true;
						}
					}
					if (isServerFree() && !timeOutDepasse) {
						// Lancement de la g�n�ration du rapport
						launchReport(report, false);
						// R�cup�ration d'une �ventuelle exception, 
						// g�n�r�e soit lors du build du rapport (report.build),
						// soit lors de l'insertion dans la table des traitements asynchones (report.insertAsync)
						except = report.getException();
						if (except != null) {
							logService.error("Erreur sur le rapport " + report.getResFile(), except);
						}
						
						// TODO �ventuel : ajouter timer de 200s
					}
					else {
						break;
					}
				}
				// Suppression de la liste courante de la liste des rapports � traiter
				removeReportConcat(concatReport);
				
				boolean traitementOK = false;
				
				// Attente de la fin de g�n�ration de l'ensemble des rapports pdf � concat�ner
				// Si les rapports ont bien �t� g�n�r�s sur le serveur
				if (verifierExistenceReports(listeReport)) {
					// Concat�nation des rapports avec itext
					genererRapportConcatene(listeReport, reportResult.getAbsoluteResFile());
					
					// Si le rapport concat�n� a bien �t� cr��
					if (verifierExistenceReport(reportResult)) {
						traitementOK = true;
					}
				}
				
				// Suppression des rapports d'entr�e unitaires
				supprimerRapports(listeReport);
				
				if (traitementOK) {
					// Mise � jour de la table des traitements asynchrones en OK
					reportResult.updateAsyncOK();
				}
				else {
					// Mise � jour de la table des traitements asynchrones en KO
					reportResult.updateAsyncKO();
				}
			}
		}
	}
	
	private Report getRapportConcatFromRapportExemple(Report exempleRapport) throws ReportException {
		if (exempleRapport == null) {
			return null;
		}
		
		Hashtable hParamsJob = new Hashtable();
		hParamsJob.put(Report.PARAM_DESFORMAT, exempleRapport.getHParamReport().get(Report.PARAM_DESFORMAT));
		hParamsJob.put("arborescence", exempleRapport.getHParamReport().get("arborescence"));

		return new Report(exempleRapport.getJobId(), exempleRapport.getReportId(), exempleRapport.getUserBip(), hParamsJob, exempleRapport.getSUserDbId());
	}
	
	/**
	 * Suppression physique de la liste des rapports pass�e en param�tre
	 * @param listeReport : liste des rapports � supprimer
	 */
	private void supprimerRapports(LinkedList<Report> listeReport) {
		String sMsg = "ReportManager.supprimerRapports : ";
		if (listeReport != null) {
			for (Report report : listeReport) {
				if (report != null  && report.getAbsoluteResFile() != null) {
					File fichier = new File(report.getAbsoluteResFile());
					if (fichier != null && existsFichier(report.getAbsoluteResFile())) {
						fichier.delete();
						if (logService.isDebugEnabled()) {
							logService.debug(sMsg + "Suppression OK du report " + report.getAbsoluteResFile());
						}
					}
				}
			}
		}
	}

	/**
	 * Concat�nation des rapports pdf d'entr�e dans un unique fichier pdf de sortie avec itext
	 * @param reportsEntree
	 * @param String
	 * @return 
	 */
	private void genererRapportConcatene(LinkedList<Report> reportsEntree, String cheminAbsoluReportSortie) {
		String sMsg = "ReportManager.genererRapportConcatene : ";
		
		if (reportsEntree != null  && cheminAbsoluReportSortie != null ) {
			if (logService.isDebugEnabled()) { 
				logService.debug(sMsg + "reportsEntree.size() " + reportsEntree.size());
				logService.debug(sMsg + "cheminReportSortie " + cheminAbsoluReportSortie);
			}
			
			// Liste des entr�es � traiter
			LinkedList<InputStream> list = new LinkedList<InputStream>();
	        try {
	        	for (Report report : reportsEntree) {
	        		// Si le chemin du rapport est d�fini
	        		if (report != null  && report.getAbsoluteResFile() != null) {
	        			if (logService.isDebugEnabled()) {
	        				logService.debug(sMsg + "ajout de " + report.getAbsoluteResFile());
	        			}
	        			// Ajout du fichier pdf en entr�e
	            		list.add(new FileInputStream(new File(report.getAbsoluteResFile())));
	        		}
				}

	            // Fichier pdf r�sultat 
	            OutputStream out = new FileOutputStream(new File(cheminAbsoluReportSortie));

	            doMerge(list, out);

	        } catch (FileNotFoundException e) {
	        	logService.error("ReportManager.genererRapportConcatene ", e);
	        } catch (DocumentException e) {
	        	logService.error("ReportManager.genererRapportConcatene ", e);
	        } catch (IOException e) {
	        	logService.error("ReportManager.genererRapportConcatene ", e);
	        }
		}
	}
	
	/**
	 * V�rification de l'existence des rapports g�n�r�s sur le serveur
	 * @param listeReport
	 * @return 
	 * @throws InterruptedException 
	 */
	private boolean verifierExistenceReports(LinkedList<Report> listeReport) {
		
		String sMsg = "ReportManager.verifierExistenceReports : ";
		if (logService.isDebugEnabled()) {
			logService.debug(sMsg + "nb reports : " + listeReport.size());
		}
		
		for (Report report : listeReport) {
			if (!verifierExistenceReport(report)) {
				logService.error(sMsg + "Rapport inexistant " + report.toString());
				return false;
			}
		}
		
		if (logService.isDebugEnabled()) {
			logService.debug(sMsg + "Listes de rapports trouv�s");
		}
		return true;
	}
	
	/**
	 * V�rification de l'existence du rapport g�n�r� sur le serveur
	 * @param listeReport
	 * @return 
	 * @throws InterruptedException 
	 */
	private boolean verifierExistenceReport(Report report) {
		String sMsg = "ReportManager.verifierExistenceReport : ";
		Date dateReference;
		Date dateCourante;
		// Dur�e max d'attente de cr�ation de fichier report sur le serveur (en ms)
		int dureeMaxReport = Report.dureeAttenteMax;
		
		try	{
			// Instanciation d'une nouvelle date de r�f�rence
			dateReference = new Date();
			// Tant que l'ensemble des rapports ne sont pas g�n�r�s et que le timout n'est pas d�pass�
			while (!existsFichier(report.getAbsoluteResFile())) {
				// Attente de 200ms
				sleep(200);
				// Instanciation d'une nouvelle date courante
				dateCourante = new Date();
				// Si la dur�ee d'attente max est d�pass�e
				if (dateCourante.getTime() - dateReference.getTime() > dureeMaxReport) {
					// Arr�t du traitement
					logService.error(sMsg + "Duree d'attente max de fin de generation de report asynchrone d�passee" + report.toString());
					return false;
				}
			}
		}
		catch (InterruptedException iE) {
			
			logService.error(sMsg + "Probleme lors de l'attente de fin de generation pour report asynchrone " + report.toString(), iE);
			// Si exception sur un des rapports, arr�t du traitement
			return false;
		}
		
		if (logService.isDebugEnabled()) {
			logService.debug(sMsg + "OK" + report.getAbsoluteResFile());
		}
		
		return true;
	}
	
	/**
	 * V�rification existence de fichier
	 * @param cheminAbsoluFichier
	 * @return
	 */
	private static boolean existsFichier(String cheminAbsoluFichier) {
		if (cheminAbsoluFichier == null) {
			return false;
		}
		// Instanciation d'un fichier � partir du chemin
		File fichier = new File(cheminAbsoluFichier);
		return (cheminAbsoluFichier != null && fichier.exists());
	}
	
	/**
     * Merge multiple pdf into one pdf
     *
     * @param list
     *            of pdf input stream
     * @param outputStream
     *            output file output stream
     * @throws DocumentException
     * @throws IOException
     */
    private static void doMerge(LinkedList<InputStream> list, OutputStream outputStream)
            throws DocumentException, IOException {
        Document document = new Document();
        PdfWriter writer = PdfWriter.getInstance(document, outputStream);
        document.open();
        PdfContentByte cb = writer.getDirectContent();
        PdfReader reader;
        PdfImportedPage page;
        
        for (InputStream in : list) {
            reader = new PdfReader(in);
            for (int i = 1; i <= reader.getNumberOfPages(); i++) {
                document.newPage();
                //import the page from source pdf
                page = writer.getImportedPage(reader, i);
                //add the page to the destination pdf
                cb.addTemplate(page, 0, 0);
            }
        }
       
        outputStream.flush();
        document.close();
        outputStream.close();
    }
	
	/**
	 * Retire le report donn� de la liste des reports en court, son traitement est donc termin�.<br>
	 * C'est le thread ThreadReport qui appelle cette methode (d'ou le protected)
	 * @param report le report � retirer de la liste
	 */
	protected void removeCurrentReport(Report report)
	{
		String sMsg = "ReportManager.removeCurrentReport : ";
		if (vCurrenrReports.remove(report))
		{
			if (logService.isDebugEnabled()) {
				logService.debug(sMsg + "retrait de vCurrentReport : " + report.toString() + " new nbCur=" +vCurrenrReports.size());
			}
		}
		else
		{
			// ??????
			logService.warning(sMsg + " tentative de retrait d'un report qui n'est pas dans vCurrentReport : " + report.toString());
		}
	}
	
	/**
	 * Retire le report donn� de la liste des reports en attente, il va donc �tre g�n�r�.
	 * @param report le report � retirer de la liste
	 */
	private void removeReport(Report report)
	{
		String sMsg;
		sMsg = "ReportManager.removeReport : ";
		if (vSync.remove(report))
		{
			if (logService.isDebugEnabled())
				logService.debug(sMsg + "retrait de la file synchrone de : " + report.toString() + " vSync.size=" + vSync.size());
		}
		else if (vAsync.remove(report))
		{
			if (logService.isDebugEnabled())
				logService.debug(sMsg + "retrait de la file asynchrone de : " + report.toString() + " vAsync.size=" + vAsync.size());
		}
		else
		{
			// ??????
			logService.warning(sMsg + " tentative de retrait d'un report non stock� : " + report.toString());
		}
	}
	
	/**
	 * Retire la liste de rapports de la liste des reports en attente.
	 * @param rapportConcat : l'instance de liste des reports � retirer de la liste
	 */
	private void removeReportConcat(ReportConcat rapportConcat) {
		String sMsg;
		sMsg = "ReportManager.removeReportConcat : ";
		if (vAsyncConcat.remove(rapportConcat)) {
			if (logService.isDebugEnabled()) {
				logService.debug(sMsg + "retrait de la file asynchrone de : " + rapportConcat.toString() + " vAsyncConcat.size=" + vAsyncConcat.size());
			}
		}
		else {
			logService.warning(sMsg + " tentative de retrait d'une liste de reports non stock�e : " + rapportConcat.toString());
		}
	}
		
	private boolean isServerFree()
	{
		return (vCurrenrReports.size() < nbMax);
	}
	
	
	/**
	 * Permet de r�cup�rer le timeStamp du premier job si celui ci contient la chaine : .ELIGNES_BIP_FOURNISSEUR.csv
	 * 
	 * Cela permet de g�n�rer un fichier de param�tre sp�cifique � chaque extraction personnalis�e de Lignes BIP 
	 * le fichier de param poss�dera le m�me TimeStamp 
	 * 
	 * @param commande
	 * @return
	 */
	protected String getTimeStampFromCommand(String commande, String findeFichier){
		
	 String timeStamp = "" ;
	 
	 int positionDesName = commande.indexOf("_") ;  
	 
	 
     int positionFournisseurEbis = commande.indexOf(findeFichier) ;      
     timeStamp = commande.substring(positionDesName+1,positionFournisseurEbis);
     
     //logBipUser.info("#### PROC PARAM   Fin de fichier : " + findeFichier );
     
     //logBipUser.info(" #### PROC timeStamp  final -> " + timeStamp ) ;  
     
	 return timeStamp ; 		
	
	}
	
	protected String rajoutTimeStampFichierParametres(String nomfichierParametres,String timeStamp){
		
		 String nomFichierParametresFinal ; 		 
		 String debutFichier ; 
		 String finFichier ;
		 
		 
		 nomFichierParametresFinal = "" ; 
		 int positionUnderscore = 0 ; 
		// logBipUser.info("######## INFOS  fichier param�tres : pos _ : " + String.valueOf(positionUnderscore));
		 positionUnderscore = nomfichierParametres.indexOf("_") ; 		 
		 debutFichier = nomfichierParametres.substring(0,positionUnderscore) ;
		 // logBipUser.info("######## INFOS  fichier param�tres : debut fichier :  " + debutFichier);
		 finFichier = nomfichierParametres.substring(positionUnderscore+1 , nomfichierParametres.length()) ; 
		 // logBipUser.info("######## INFOS  fichier param�tres : fin fichier :  " + finFichier);
		 nomFichierParametresFinal = debutFichier + "_" + timeStamp + "_" + finFichier ; 
		 return nomFichierParametresFinal ; 		
		
		}

	
	
	
}