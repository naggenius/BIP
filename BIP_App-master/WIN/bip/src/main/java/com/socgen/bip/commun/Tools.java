/*
 * Created on 23 juin 03
 *
 * To change the template for this generated file go to
 * Window>Preferences>Java>Code Generation>Code and Comments
 */
package com.socgen.bip.commun;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.InvocationTargetException;
import java.sql.CallableStatement;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.Vector;

import org.apache.commons.lang.StringUtils;

import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.db.RBip_Jdbc;
import com.socgen.bip.hierarchy.ResultHierarchy;
import com.socgen.bip.rbip.commun.erreur.RBipErreur;
import com.socgen.bip.rbip.commun.loader.RBipData;
import com.socgen.bip.rbip.commun.loader.RBipParser;
import com.socgen.bip.rbip.commun.loader.RBipStructureConstants;
import com.socgen.bip.rbip.commun.loader.RBipStructureConstantsBIPS;
import com.socgen.bip.rbip.intra.RBipFichier;
import com.socgen.bip.util.ReadConfig;
import com.socgen.cap.fwk.ServiceManager;
import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.config.ConfigManager;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.cap.fwk.log.Log;

/**
 * @author X039435
 *
 * To change the template for this generated type comment go to
 * Window>Preferences>Java>Code Generation>Code and Comments
 */
public class Tools implements RBipStructureConstants, BipConstantes, RBipStructureConstantsBIPS
{
	private static Properties pSysProperties;
	public static final int FORMAT_JJMMAAAA=0;
	public static final int FORMAT_MMAAAA=1;
	public static final int FORMAT_AAAA=2;
	public static final int FORMAT_AAAAMMJJ=3;
	public static final int FORMAT_TIMESTAMP=4;
	public static final int FORMAT_AAMMJJ=5;
	
	protected static final String sLogCat = "BipUser";
	private static final String PACK_INSERER_ERREUR_BIPS = "bips.inserererreur.proc";
	private static final String PACK_DELETE_REJET_MENS_BIPS = "bips.deleterejetmensbips.proc";
	
	//public static Log logBipUser = ServiceManager.getInstance().getLogManager().getLogInstance(sLogCat);
	
	private static String NomConfig = "bip_proc";
	
	private static String cle = "rbip.isvalidpid.proc";
	private static String cle_pid_habilitation = "rbip.ispidhabilite.proc";
	
	private static String PROC_SUPPRIMER_SR_SI_EXISTE = "lignebip.supprimer_sr_si_existe.proc";
	
	private static String PROC_INSERT_INTRA_BIPS = "bips.creer.proc";
	
	private static String PROC_INSERT_BULK_BIPS ="bips.bulk.creer.proc";
	
	private static String PACK_RECUP_PARAM = "parambip.recuperer.proc";
	
	private static List<List<String>> listParamBip;
	
	//SEL 6.11.2
	private static String PACK_VERIFIER_AXE = "tache.verifier.proc";
	
	//SEL 60709 5.4
	private static String PACK_RECUP_PARAM_GLOBAL = "parambip.recupererglobal.proc";
	
	//PPM 61776
	private static String PACK_GLOBAL_LIRE_CHEFS_PROJET = "global.lire_liste_chefs_projet.proc";
	
	//SEL PPM 60612
	private static String PACK_LISTER_PMW_BIPS ="bips.liste.pmwbips";
	
	private static String PACK_VERIFIER_AXE_BIPS = "tache.verifierAxeBips.proc";
	
	private static String PACK_VERIFIER_LINE_AXE_BIPS = "ligne.verifierAxeBips.proc";
	
	//SEL PPM 63412
	private static String PACK_ISCLIENTBBRF03 ="lignebip.isclientbbtf03.proc";
	private static final String PACK_RECUP_DPCOPI_DU_PROJ ="lignebip.recupdpcopi.proc";
	
	private static final String PACK_CHECK_OUTSOURCE = "outsource.verifier.proc";
	
	/** CallableStatement */
	protected static CallableStatement call;
	
	public static String  getStrDate(int iFormat, int iOffsetJour, int iOffsetMois, int iOffsetAnnee, String sSeparateur)
	{
		return getStrDate(Calendar.getInstance(), iFormat, iOffsetJour, iOffsetMois, iOffsetAnnee, sSeparateur);
	}
	
	public static MonthAndYearFunctional findMoisFonctionnel() throws Exception{
		return RBip_Jdbc.findMoisFonctionnel();	
	}
	
	public static String  getStrDate(Calendar cal, int iFormat, int iOffsetJour, int iOffsetMois, int iOffsetAnnee, String sSeparateur)
	{
		//Calendar cal;		
		//cal = Calendar.getInstance();

		cal.roll(Calendar.DAY_OF_MONTH, iOffsetJour);
		cal.roll(Calendar.MONTH, iOffsetMois);
		cal.roll(Calendar.YEAR, iOffsetAnnee);
		
		String sM = ""+(cal.get(Calendar.MONTH)+1);

		// Cas particulier , lorsqu'on est sur DÈcembre et l'offset est -1, on
		// enleve 1 ‡ l'annÈe
		if (sM.equals("12") && iOffsetMois==-1 && iOffsetAnnee==0) {
			iOffsetAnnee = -1 ;
			cal.roll(Calendar.YEAR, iOffsetAnnee);
		}
		
		String sY = ""+cal.get(Calendar.YEAR);
		String sD = ""+cal.get(Calendar.DAY_OF_MONTH);
		
		while (sY.length() < 4)
			sY="0"+sY;
		while (sM.length() < 2)
			sM="0"+sM;
		while (sD.length() < 2)
			sD="0"+sD;

		switch(iFormat)
		{
			case(FORMAT_AAAA):
				return sY;
			case(FORMAT_MMAAAA):
				return sM+sSeparateur+sY;							
			case(FORMAT_JJMMAAAA):
				return sD+sSeparateur+sM+sSeparateur+sY;
			case(FORMAT_AAAAMMJJ):
				return sY+sSeparateur+sM+sSeparateur+sD;
			case (FORMAT_TIMESTAMP):
			{
				String sH = ""+cal.get(Calendar.HOUR_OF_DAY);
				String sMin = ""+cal.get(Calendar.MINUTE);
				String sSec = ""+cal.get(Calendar.SECOND);
				return sY+sM+sD+"-"+sH+":"+sMin+":"+sSec;
			}
			case (FORMAT_AAMMJJ):
			{
				return sY.substring(2,4) + sSeparateur + sM + sSeparateur + sD;
			}
			default:
				return sD+sSeparateur+sM+sSeparateur+sY;
		}
	}
	
	public static String getStrDateAAAA(int iOffsetY) { return getStrDate(FORMAT_AAAA, 0, 0, iOffsetY, "/"); }
	public static String getStrDateMMAAAA(int iOffsetM, int iOffsetY) {return getStrDate(FORMAT_MMAAAA, 0, iOffsetM, iOffsetY, "/"); }
	public static String getStrDateJJMMAAAA(int iOffsetJ, int iOffsetM, int iOffsetY) { return getStrDate(FORMAT_JJMMAAAA, iOffsetJ, iOffsetM, iOffsetY, "/"); }
	public static String getStrDateAAAAMMJJ(int iOffsetJ, int iOffsetM, int iOffsetY) { return getStrDate(FORMAT_AAAAMMJJ, iOffsetJ, iOffsetM, iOffsetY, ""); }

	public static String getTimeStamp() { return getStrDate(FORMAT_TIMESTAMP, 0, 0, 0, ""); }
     /**
	 * MÈthode qui permet l'affichage des espaces
	 * 
	 */ 
   public static String convertirEspace(String libelle) {
   	  String lib="";
   	  String lettre="";
   	  //On parcourt le libellÈ et on remplace les espaces par &nbsp;
   	  
   	 for (int i=0;i<libelle.length();i++) {
   	 	
   	  	if (String.valueOf(libelle.charAt(i)).equals(" ")) {
   	  		lib = lib + "&nbsp;";
   	  	
   	  	}//if
   	  	else {
   	  		lib= lib + String.valueOf(libelle.charAt(i));
   	  		
   	  	}
   	  	   	  	
   	  }//for
   	  
   	  
   	  return lib;
		
	}
	/**
	* MÈthode qui permet l'affichage des espaces
	* 
	*/ 
  public static String remplaceQuoteEspace(String libelle) {
	 String lib="";
	 String lettre="";
	 //On parcourt le libellÈ et on remplace les quotes par espace;
   	  
	for (int i=0;i<libelle.length();i++) {
   	 	
	   if (String.valueOf(libelle.charAt(i)).equals("'")) {
		   lib = lib + " ";
   	  	
	   }//if
	   else {
		   lib= lib + String.valueOf(libelle.charAt(i));
   	  		
	   }
   	  	   	  	
	 }//for
   	  
   	  
	 return lib;
		
   }

	/**
	 * Permet d'acceder aux variable d'environnement systeme
	 */
	public static Properties getSysProperties()
	{
		if (pSysProperties == null)
		{
			pSysProperties = new Properties();
			try
			{	
				Process p = (System.getProperty("os.name").toUpperCase().indexOf("WIN")==-1) ? Runtime.getRuntime().exec("env") : Runtime.getRuntime().exec("cmd /Cset");
				pSysProperties.load(p.getInputStream());	
			}
			catch (IOException e)
			{
				//
			}
		}
		
		return pSysProperties;
	}
	
	  /**
	   * Force the garbage collection	 
	   */
	 public static void forceFullGarbageCollection() {
  
	   Runtime runtime = Runtime.getRuntime();
	   long isFree = runtime.freeMemory();
	   long wasFree = 0;	  
	   do {
		 wasFree = isFree;
		 runtime.gc();
		 isFree = runtime.freeMemory();
	   }
	   while (isFree > wasFree);
	   runtime.runFinalization();
	   return ;
	 }

	public static void logEnv()
	{
		String sKey;
		String sVal;
		Log logService;
		Properties prop;
		Enumeration enums;
		
		logService = ServiceManager.getInstance().getLogManager().getLogService();
		prop = getSysProperties();
		
		enums = prop.keys();
		
		while (enums.hasMoreElements())
		{
			sKey = (String)enums.nextElement();
			sVal = prop.getProperty(sKey);
			
			logService.info("[ " + sKey + " ] - [ " + sVal + " ]");
		}
		
	}

	private static Class classString = "".getClass();
	
	public static Object getInstanceOf(	String sClassName,
										String sMethodName,
										Object oParam) throws	InvocationTargetException, Exception
	{
		Vector vParam;		
		Object o=null;		
		Object [] param;		
		Class [] classP;
	
		if (oParam instanceof Vector)
		{
			vParam = (Vector)oParam;
		}
		else
		{
			vParam = new Vector();
			vParam.add(oParam);
		}
	
		param = vParam.toArray();				
		classP = new Class[vParam.size()];
		for (int i=0; i< vParam.size(); i++)
		{
			Object oo = vParam.elementAt(i);
			classP[i] = oo.getClass();
		}
	
		try
		{
			if ( (sMethodName == null) || (sMethodName.equals("")) ) 
			{
				o = Class.forName(sClassName).getConstructor(classP).newInstance(param);
			}
			else
			{				
				o = Class.forName(sClassName).getMethod(sMethodName, classP).invoke(null, param);
			}
		}
		catch (InvocationTargetException iTE) { throw(iTE);}
		catch (Throwable t)
		{
			String s = sClassName+"."+sMethodName+"(";
			for (int i=0; i<vParam.size(); i++)
			{
				s+=classP[i].toString() + " " + vParam.elementAt(i).toString() + ",";
			}
			if (s.endsWith(","))
				s = s.substring(0, s.length()-2);
		
			s += ")";
			logService.error("Instanciation dynamique : " + s, t);
			throw new Exception("ClassName : " + sClassName + " MethodName : " + sMethodName);
		}
		return o;
	}
	
	/*public static Object getInstanceOf(String sClassName,
								String sMethodName,
								String sParam) throws	InvocationTargetException, Exception
	{
		Class [] classP = { classString };
		Object [] param = { sParam };
		Object o=null;
		
		try
		{
			if ( (sMethodName == null) || (sMethodName.equals("")) ) 
			{
				o = Class.forName(sClassName).getConstructor(classP).newInstance(param);
			}
			else
			{
				o = Class.forName(sClassName).getMethod(sMethodName, classP).invoke(null, param);
			}
		}
		catch (InvocationTargetException iTE) { throw(iTE);}
		catch (Exception e)
		{
			throw new Exception("ClassName : " + sClassName + " MethodName : " + sMethodName + " =>\n"+ e.toString());
		}
		
		return o;
	}*/

	public static boolean isNum(char c)
	{
		return ((c>='0') && (c<='9'));	
	}
	
	public static boolean isAlpha(char c)
	{
		return ((Character.toUpperCase(c)>='A') && (Character.toUpperCase(c)<='Z'));	
	}
	
	public static boolean isAlphaNum(char c)
	{
		return ( isNum(c) || isAlpha(c) );	
	}
	
	public static boolean isPIDValid(String sVal)
	{
		int iTaille;
		//un PID valide est de la forme : A-AN-AN-AN[-AN]
		
		if (sVal.charAt(sVal.length()-1) == ' ')
			sVal = sVal.substring(0, sVal.length()-1);
	
		iTaille = sVal.length();
	
		if ( (iTaille != 3) && (iTaille != 4) )
			return false;
	
		if (! Tools.isAlpha(sVal.charAt(0)) )
			return false;

		for (int i=1; i<iTaille; i++)
		{
			if (! Tools.isAlphaNum(sVal.charAt(i)) )
				return false;
		}
	
		return true;
	}
	
	public static int isRBipPIDValid(String sPid) 
	{ 
		// QC 1283 - ContrÙle sur le PID par une procÈdure PLSQL.
		if("INTRANET".equals(RBip_Jdbc.TOP)){	// RBip Intranet
			
			String Procedure = ReadConfig.ReadPropFile(cle, NomConfig);
			String p_user = null;
			RBip_Jdbc.isValidPID_Intra(Procedure, p_user, sPid);

		}  // pas besoin de faire le mÍme traitement pour la remontÈe sous UNIX
		   // car il est exÈcutÈ par le batch RBip.
		
		if( ! "OK".equals(RBip_Jdbc.sErrValue) )
		{
			return 0; // Dans le cas ou il y'a une erreur.
		}
		else{
			return 1; // Traitement normal, pas d'erreur.
		}
						
	}
	
	public static boolean isRBipFileNameValid(String sVal)
	{
		//un fichier valide : code bip + 3 car libres + ab ou 2chiffres + .bip
		sVal = sVal.toUpperCase();
		
		int iTaille = sVal.length();
		int iTaillePID=0;
		if (iTaille == 12)
		{
			//PID sur 3
			iTaillePID = 3;
		}
		else if (iTaille == 13)
		{
			//PID sur 4
			iTaillePID = 4;
		}
		else
			return false;
		
		if (sVal.indexOf(' ')>=0)
			return false;
			
		if (	( 	( Tools.isNum(sVal.charAt(iTaillePID+3)) &&	Tools.isNum(sVal.charAt(iTaillePID+4)) ) ||
					( (sVal.charAt(iTaillePID+3) == 'A') &&	(sVal.charAt(iTaillePID+4)=='B') )	) &&
				(sVal.endsWith(".BIP")) )
		{
			return isPIDValid(sVal.substring(0, iTaillePID));
		}
		return false;
	}
	
	public static String getPIDFromFileName(String sFileName)
	{
		sFileName = sFileName.toUpperCase();
		
		if (! isRBipFileNameValid(sFileName))
			return null;
		
		if (sFileName.length() == 12)
		{
			//PID sur 3
			return sFileName.substring(0,3)+" ";
		}
		else
		{
			//PID sur 4
			return sFileName.substring(0,4);
		}
	}
	
	private static int getVal(char c)
	{
		//A=1, Z=26
		//0=27, 9=36
		int val;
		c = Character.toUpperCase(c);
		if ( (c >= 'A') && (c <= 'Z') )
		{
			val = c - 'A' +1;
		}
		else if ( (c >= '0') && (c <= '9') )
		{
			val = c - '0' +27;
		}
		else
		{
			val=-1;
		}
		
		return val;
	}
	private static char getChar(int val)
	{
		//A=1, Z=26
		//0=27, 9=36
		char c;
		if ( (val >= 1) && (val <= 26) )
		{
			c =(char)(val + 'A' -1);
		}
		else if ( (val >= 27) && (val <= 36) )
		{
			c = (char)(val + '0' -27);
		}
		else
		{
			c='*';
		}
		
		return c;
	}
	
	public static String getClePID(String sPID)
	{
		char cCle1, cCle2, cCle3;
		sPID = sPID.trim();
		
		if (sPID.length() == 3)
		{
			cCle1 = '-';
			cCle2 = getChar( ( ((11 * getVal(sPID.charAt(1))) + 1) + ((31  * getVal(sPID.charAt(2))) + 1) )%36 +1 );
			cCle3 = getChar( ( ((23 * getVal(sPID.charAt(0))) + 1) + ((7  * getVal(sPID.charAt(2))) + 1) )%36 +1 );
		}
		else
		{
			cCle1 = getChar( ( ((30 * getVal(sPID.charAt(1))) + 1) + ((17  * getVal(sPID.charAt(3))) + 1) )%36 +1 );
			cCle2 = getChar( ( ((11 * getVal(sPID.charAt(1))) + 1) + ((31  * getVal(sPID.charAt(2))) + 1) )%36 +1 );
			cCle3 = getChar( ( ((23 * getVal(sPID.charAt(0))) + 1) + ((7  * getVal(sPID.charAt(2))) + 1) )%36 +1 );	
		}
		
		return ""+cCle1+cCle2+cCle3;	
	}
	

	
	public static Vector readFile(File f) throws FileNotFoundException, IOException
	{
		Vector vLigne = new Vector();
		BufferedReader bR = new BufferedReader(new FileReader(f));

		String sTmp;

		//on construit un vecteur qui contienr les lignes du fichier
		while ( (sTmp=bR.readLine()) != null)
		{
			vLigne.add(sTmp);
		}
		
		return vLigne;
	}
	
	public static boolean isProjetAbsence(String sFileName)
	{
		sFileName = sFileName.toUpperCase();
		return ( sFileName.indexOf("AB.") >= 0 );
	}
	
	public static boolean isTypeSSTacheAB(String sVal)
	{
		for (int i=0; i<SSTACHE_AB.length; i++)
		{
			if (SSTACHE_AB[i].equals(sVal))
				return true;
		}
		return false;
	}

	//pas fichier absence, type etape ES 
	public static boolean isTypeSSTacheES(String sVal)
	{
		for (int i=0; i<SSTACHE_ES.length; i++)
		{
			if (SSTACHE_ES[i].equals(sVal))
				return true;
		}
		return false;
	}

	public static boolean isTypeSSTacheSansPID(String sVal)
	{
		for (int i=0; i<SSTACHE_SANS_PID.length; i++)
		{
			//if (SSTACHE_SANS_PID[i].equals(sVal))
			if (sVal.startsWith(SSTACHE_SANS_PID[i]))
				return true;
		}
		return false;
	}
	
	public static boolean isTypeSSTachePID(String sVal)
	{
		for (int i=0; i<SSTACHE_PID.length; i++)
		{
			if (sVal.startsWith(SSTACHE_PID[i]))
				return true;
		}
		return false;
	}

	public static boolean isTypeSSTachePIDProjet(String sVal)
	{
		for (int i=0; i<SSTACHE_PID_PROJET.length; i++)
		{
			if (sVal.startsWith(SSTACHE_PID_PROJET[i]))
				return true;
		}
		return false;
	}
	
	public static boolean isTypeConsomme(String sVal)
	{
		for (int i=0; i<CONSOMME_TYPE.length; i++)
		{
			if (sVal.startsWith(CONSOMME_TYPE[i]))
				return true;
		}
		return false;
	}
	
	//	le TypeSstache donne DOIT etre un type sstache avec PID valide ...
	public static String getPIDFromTypeSSTache(String sTypeSSTache)
	{
		return sTypeSSTache.substring(2,sTypeSSTache.length());
	}
	
	public static Vector stream2Vector(InputStream iS) throws IOException
	{
		Vector vLignes = new Vector();
		StringBuffer sTmp = new StringBuffer();
		int c = 0;
		while (0 < (c = iS.read()))
		{
			if (c == '\r')
				continue;
			if (c == '\n')
			{
				vLignes.add(sTmp.toString());
				sTmp = new StringBuffer();
			}
			else
			{
				sTmp.append((char)c);						
			}
		}
		
		// si la variable sTmp contient des donnÈes cel‡ veut dire que la derniËre ligne contenant des infos
		// n'a pas de retour chariot
		if (sTmp.length()>0) {
			vLignes.add(sTmp.toString());
		}

		return vLignes;
	}
	
	public static LinkedList stream2LinkedList(InputStream iS) throws IOException
	{
		LinkedList<String> vLignes = new LinkedList<String>();
		StringBuffer sTmp = new StringBuffer();
		int c = 0;
		while (0 < (c = iS.read()))
		{
			if (c == '\r')
				continue;
			if (c == '\n')
			{
				vLignes.add(sTmp.toString());
				sTmp = new StringBuffer();
			}
			else
			{
				sTmp.append((char)c);						
			}
		}
		
		// si la variable sTmp contient des donnÈes cel‡ veut dire que la derniËre ligne contenant des infos
		// n'a pas de retour chariot
		if (sTmp.length()>0) {
			vLignes.add(sTmp.toString());
		}
		
		return vLignes;
	}
	
	//SEL PPM 60612
//	public static int isRBipPIDHabilite(String p_pid,String p_liste_cp) 
//	{ 
//		
//		
//		// QC 1283 - ContrÙle sur le PID par une procÈdure PLSQL.
////		if("INTRANET".equals(RBip_Jdbc.TOP)){	// RBip Intranet
//			
//			String Procedure = ReadConfig.ReadPropFile(cle_pid_habilitation, NomConfig);
//			RBip_Jdbc.isPidHabilite(Procedure, p_pid, p_liste_cp);
//
//			if( "OK".equals(RBip_Jdbc.sErrValue) )
//			{
//				return 1; // Le user est habilitÈ ‡ la ligne BIP.
//			}
//			else{
//				return 0; // Le user n'est pas habilitÈ ‡ la ligne BIP.
//			}
////		}  // pas besoin de faire le mÍme traitement pour la remontÈe sous UNIX
////		   // car il est exÈcutÈ par le batch RBip.
////		return 1;
//	
//						
//	}
	
//	public static Set<String> getIdLignesBipAvecChefDeProjetValides(Set<String> idLignesBipSet, Set<String> chefDeProjetUserSet){
//		// QC 1283 - ContrÙle sur le PID par une procÈdure PLSQL.
//		if("INTRANET".equals(RBip_Jdbc.TOP)){	// RBip Intranet
//			
//			String procedure = ReadConfig.ReadPropFile(cle_pid_habilitation, NomConfig);
//			return RBip_Jdbc.getIdLignesBipAvecChefDeProjetValides(procedure, idLignesBipSet, chefDeProjetUserSet);
//
//		}  // pas besoin de faire le mÍme traitement pour la remontÈe sous UNIX
//		   // car il est exÈcutÈ par le batch RBip.
//		
//		if( "OK".equals(RBip_Jdbc.sErrValue) )
//		{
//			return 1; // Le user est habilitÈ ‡ la ligne BIP.
//		}
//		else{
//			return 0; // Le user n'est pas habilitÈ ‡ la ligne BIP.
//		}
//	}
	
	public static void supprimer_sr_si_existe(String p_pid)
	{
		String Procedure = ReadConfig.ReadPropFile(PROC_SUPPRIMER_SR_SI_EXISTE, NomConfig);
		RBip_Jdbc.supprimer_sr_si_existe(Procedure, p_pid, "");
	}
	
	public static String inserer_bips(Vector vLignes, RBipFichier rFichier)
	{
		String Procedure = ReadConfig.ReadPropFile(PROC_INSERT_BULK_BIPS, NomConfig);
		return RBip_Jdbc.inserer_bips(Procedure, vLignes,rFichier);
	}
	
	public static List<List<String>> recup_param_bip_global(String cAction)
	{
		String Procedure = ReadConfig.ReadPropFile(PACK_RECUP_PARAM_GLOBAL, NomConfig);
		System.out.println("proc="+ Procedure);
		return RBip_Jdbc.recup_param_bip_global(Procedure,cAction);
	}
	
// KRA 16/04/2015 - PPM 60612 : Ajouts des mÈthodes pour contÙler un fichier .bips

	// Initialise la variable config ‡ pointer sur le fichier properties sql
//	protected static Config configProc = ConfigManager.getInstance(BIP_PROC) ;
	private static String PACK_REMONTEE_CHECK_PID = "bips.checkPid.proc";
	private static String PACK_REMONTEE_CHECK_PIDS = "bips.checkPids.proc";
	private static String PACK_REMONTEE_CHECK_CLE = "bips.checkCle.proc";
	private static String PACK_REMONTEE_CHECK_ACTIVITE = "bips.checkAtivite.proc";
	private static String PACK_REMONTEE_CHECK_ETAPE_TYPE = "bips.checkEtapeType.proc";
	private static String PACK_REMONTEE_CHECK_STRUCTS_SR = "bips.checkStructsSR.proc";
	private static String PACK_REMONTEE_CHECK_STACHE_TYPE =  "bips.checkStacheType.proc";
	private static String PACK_REMONTEE_CHECK_RESS_BIP_CODE =  "bips.checkRessBipCode.proc";
	private static String PACK_REMONTEE_CHECK_RESS_BIP_NOM = "bips.checkRessBipNom.proc";
	private static String PACK_REMONTEE_IS_LIGNE_PRODUCTIVE = "bips.isLigneProductive.proc";
	private static String PACK_REMONTEE_IS_PERIODE_ANTERIEURE_ANNEE_FONCT = "bips.isPeriodeAnterieureAnneeFonct.proc";
	private static String PACK_REMONTEE_IS_PERIODE_ULTERIEURE_MOIS_FONCT = "bips.isPeriodeUlterieureMoisFonct.proc";
	private static String PACK_REMONTEE_IS_PERIODE_ULTERIEURE_ANNEE_FONCT = "bips.isPeriodeUlterieureAnneeFonct.proc";

	private static String PACK_FIND_MOIS_FONCTIONNEL= "bips.find_mois_fonctionnel.proc";
	
	// FAD PPM 64368 : Insertion de la ligne en cours dans une table temporaire
	private static String PACK_REMONTEE_INSERT_CONSO_TMP = "bips.insertConsoTmp.proc";
	// FAD PPM 64368 : DÈclarations des deux nouvelles procÈdures stockÈes
	private static String PACK_REMONTEE_CONSO_MOIS_OK = "bips.consoMoisOk.proc";
	private static String PACK_REMONTEE_CONSO_ANNEE_OK = "bips.consoAnneeOk.proc";
	// FAD PPM 64368 : Purge de la table temporaire
	private static String PACK_REMONTEE_PURGE_CONSO = "bips.purgeConso.proc";
	// FAD PPM 64368 : RÈcupÈration d'un id unique pour le traitement en cours
	private static String PACK_REMONTEE_GET_NUM_SEQ = "bips.getNumSeq.proc";
	// FAD PPM 64368 : Fin
	
	public static boolean isValideEntete(String sLigne){
		String fields_entete = cfgStructBIPS.getString(TAG_DATA+"BIPS_ENTETE"+TAG_TYPE_FIELDS);
		if(!fields_entete.equals(sLigne)){
			return false;
		}
		return true;
	}
	
	//FIXME encore utilisÈ par check bip mensuel. Next step : ‡ remplacer par un appel ‡ getIdLigneBipValides()
	public static boolean isValidPid(String p_pid){ 		
		String Procedure = ReadConfig.ReadPropFile(PACK_REMONTEE_CHECK_PID, NomConfig);
		return RBip_Jdbc.isValidPid(Procedure,p_pid);								
	}
	
	public static Map<String, ValidityLineInformation> findValidityInformationForIdLigneBip(Set<String> idLignesBipSet) throws Exception{ 		
		String Procedure = ReadConfig.ReadPropFile(PACK_REMONTEE_CHECK_PIDS, NomConfig);
		return RBip_Jdbc.findValidityInformationForIdLigneBip(Procedure,idLignesBipSet);								
	}
	
	//FIXME May break the robustness of the application as each p_cle filled in a line of BIPS, a PL SQL call is done. 
	// Actually the column is not filled by client of the web app but if it becomes filed and also for server to server processing, we should optimize the way to retrieve data. 
	public static boolean isValidCle(String p_pid, String p_cle){ 
		if (StringUtils.isEmpty(p_cle)){
			return true;
		}		
		String Procedure = ReadConfig.ReadPropFile(PACK_REMONTEE_CHECK_CLE, NomConfig);
		return RBip_Jdbc.isValidCle(Procedure,p_pid,p_cle);
						
	}
	
	
	public static boolean isValidActivite(String p_pid, String p_etape, String p_tache, String p_sous_tache) 
	{ 
		String Procedure = ReadConfig.ReadPropFile(PACK_REMONTEE_CHECK_ACTIVITE, NomConfig);
		return RBip_Jdbc.isValidActivite(Procedure,p_pid, p_etape,  p_tache,  p_sous_tache);
						
	}
	

	public static String isValidEtapeType(String p_pid, String p_activite,String p_type_etape,String p_structureAction) 
	{ 
		String Procedure = ReadConfig.ReadPropFile(PACK_REMONTEE_CHECK_ETAPE_TYPE, NomConfig);
		return RBip_Jdbc.isValidEtapeType(Procedure,p_pid, p_activite,  p_type_etape,  p_structureAction);
						
	}
	
	
	
	public static Set<String> getIdLigneBipQuiSontDesStructureSR(Set<String> idLignesBipSet) throws Exception{ 
		
		String procedure = ReadConfig.ReadPropFile(PACK_REMONTEE_CHECK_STRUCTS_SR, NomConfig);
		return RBip_Jdbc.getSetOfIdLignesBipQuiSontDesStructures(procedure,idLignesBipSet);
						
	}
	public static String getRejetStacheType(String p_pid, String p_type_stache) 
	{ 
		String Procedure = ReadConfig.ReadPropFile(PACK_REMONTEE_CHECK_STACHE_TYPE, NomConfig);
		return RBip_Jdbc.getRejetStacheType(Procedure,p_pid,p_type_stache);
		
	}

	public static String getRejetRessBipCode(String p_ident, String p_dateDebConso, String p_dateFinConso) 
	{ 
		String Procedure = ReadConfig.ReadPropFile(PACK_REMONTEE_CHECK_RESS_BIP_CODE, NomConfig);
		return RBip_Jdbc.getRejetRessBipCode(Procedure,p_ident,p_dateDebConso,p_dateFinConso);
		
	}
	
	public static boolean isValidRessBipNom(String p_ident, String p_ressBipNom) 
	{ 

		String Procedure = ReadConfig.ReadPropFile(PACK_REMONTEE_CHECK_RESS_BIP_NOM, NomConfig);
		return RBip_Jdbc.isValidRessBipNom(Procedure,p_ident,p_ressBipNom);
		
	}
	
	public static String replaceCarSpec(String p_chaine){
		
		String chaineSansCarSpec = p_chaine;
		
		String accentsA = "‡‚‰¬ƒ¿¬ƒ¬ƒ";
		String accentsC = "Á«";
		String accentsE = "ÈËÍÎ À»…» À À»";
		String accentsI = "ÓÔŒœ";
		String accentsO = "Ùˆ‘÷";
		String accentsU = "˘˚¸Ÿ€‹";
		String accentsTiret = "$\";*&(@)!:?ß/<>+.~#{[|`\\_^]}=∞§£µ®\'";
		
		
		for (int i=0; i < chaineSansCarSpec.length(); i++ ) {
			char Caractere = chaineSansCarSpec.charAt(i);
			if (accentsA.indexOf(Caractere,0) != -1) {
				chaineSansCarSpec = chaineSansCarSpec.replace(Caractere, 'A');
			}else
				if(accentsC.indexOf(Caractere,0) != -1){
					chaineSansCarSpec = chaineSansCarSpec.replace(Caractere, 'C');
				}else
					if(accentsE.indexOf(Caractere,0) != -1){
						chaineSansCarSpec = chaineSansCarSpec.replace(Caractere, 'E');
					}else
						if(accentsI.indexOf(Caractere,0) != -1){
							chaineSansCarSpec = chaineSansCarSpec.replace(Caractere, 'I');
						}else
							if(accentsO.indexOf(Caractere,0) != -1){
								chaineSansCarSpec = chaineSansCarSpec.replace(Caractere, 'O');
							}else
								if(accentsU.indexOf(Caractere,0) != -1){
									chaineSansCarSpec = chaineSansCarSpec.replace(Caractere, 'U');
								}else
									if(accentsTiret.indexOf(Caractere,0) != -1){
										chaineSansCarSpec = chaineSansCarSpec.replace(Caractere, '-');
									}
		}
		return chaineSansCarSpec;
	}

	
	public static String replaceCarSpecPar_(String p_chaine){
		
		String chaineSansCarSpec = p_chaine;
		
		//QC 1797
		if (chaineSansCarSpec.length() > 5)
		{
		chaineSansCarSpec=chaineSansCarSpec.substring(0,5);
		}
		
		String accentsA = "‡‚‰¬ƒ¿¬ƒ¬ƒ";
		String accentsC = "Á«";
		String accentsE = "ÈËÍÎ À»…» À À»";
		String accentsI = "ÓÔŒœ";
		String accentsO = "Ùˆ‘÷";
		String accentsU = "˘˚¸Ÿ€‹";
		String accentsTiret = "$\";*&(@)!:?ß/<>+.~#{[|`\\_^]}=∞§£µ®\'-";
		
		
		for (int i=0; i < chaineSansCarSpec.length(); i++ ) {
			char Caractere = chaineSansCarSpec.charAt(i);
			if (accentsA.indexOf(Caractere,0) != -1) {
				chaineSansCarSpec = chaineSansCarSpec.replace(Caractere, 'A');
			}else
				if(accentsC.indexOf(Caractere,0) != -1){
					chaineSansCarSpec = chaineSansCarSpec.replace(Caractere, 'C');
				}else
					if(accentsE.indexOf(Caractere,0) != -1){
						chaineSansCarSpec = chaineSansCarSpec.replace(Caractere, 'E');
					}else
						if(accentsI.indexOf(Caractere,0) != -1){
							chaineSansCarSpec = chaineSansCarSpec.replace(Caractere, 'I');
						}else
							if(accentsO.indexOf(Caractere,0) != -1){
								chaineSansCarSpec = chaineSansCarSpec.replace(Caractere, 'O');
							}else
								if(accentsU.indexOf(Caractere,0) != -1){
									chaineSansCarSpec = chaineSansCarSpec.replace(Caractere, 'U');
								}else
									if(accentsTiret.indexOf(Caractere,0) != -1){
										chaineSansCarSpec = chaineSansCarSpec.replace(Caractere, '_');
									}
		}		
		chaineSansCarSpec = chaineSansCarSpec.toUpperCase();//on convertit la cahine en majuscule
		chaineSansCarSpec = chaineSansCarSpec.trim();
		return chaineSansCarSpec;
	}
	
	public static String getActivite(RBipData rBipData){
		
		Integer iEtape;
		Integer iTache;
		Integer iSous_tache;
		String sEtape;
		String sTache;
		String sSous_tache;
		try {
			iEtape = RBipParser.parseInteger(rBipData.getData(ETAPE_NUM).toString());
		} catch (Exception e) {
			iEtape = 0;
		}
		try {
			iTache = RBipParser.parseInteger(rBipData.getData(TACHE_NUM).toString());
		} catch (Exception e) {
			iTache = 0;
		}
		try {
			iSous_tache = RBipParser.parseInteger(rBipData.getData(STACHE_NUM).toString());
		} catch (Exception e) {
			iSous_tache = 0;
		}

		sEtape = iEtape==0?"00":(iEtape<10?"0".concat(iEtape.toString()):iEtape.toString());
		sTache = iTache==0?"00":(iTache<10?"0".concat(iTache.toString()):iTache.toString());
		sSous_tache = iSous_tache==0?"00":(iSous_tache<10?"0".concat(iSous_tache.toString()):iSous_tache.toString());

		String sActivite = sEtape.concat(sTache).concat(sSous_tache);
		
		return sActivite;
	}

	// FAD PPM 64368 : RÈcupÈration d'un id unique pour le traitement en cours
	public static String getNumSeq()
	{
		String Procedure = ReadConfig.ReadPropFile(PACK_REMONTEE_GET_NUM_SEQ, NomConfig);
		return RBip_Jdbc.getNumSeq(Procedure);
	}

	// FAD PPM 64368 : Purge de la table temporaire
	public static boolean purgeConsommationTmp(int numSeq)
	{
		String Procedure = ReadConfig.ReadPropFile(PACK_REMONTEE_PURGE_CONSO, NomConfig);
		return RBip_Jdbc.purgeConsommationTmp(Procedure, numSeq);
	}

	// FAD PPM 64368 : Verification consomation du mois et de l'annÈe
	public static void insererConsommationTmp(int numSeq, String sPid, String structAction, Integer etapeNum, Integer tacheNum,
			Integer stacheNum, String sDate_deb_conso, String sConsoFinDate, Integer ressBip, Float fConsoQte)
	{
		String Procedure = ReadConfig.ReadPropFile(PACK_REMONTEE_INSERT_CONSO_TMP, NomConfig);
		RBip_Jdbc.insererConsommationTmp(Procedure, numSeq, sPid, structAction, etapeNum, tacheNum,
				stacheNum, sDate_deb_conso, sConsoFinDate, ressBip, fConsoQte);
	}

	public static boolean consoMoisOk(int numSeq, String sPid, String structAction, Integer etapeNum, Integer tacheNum,
			Integer stacheNum, String sDate_deb_conso, String sConsoFinDate, Integer ressBip, Float fConsoQte)
	{
		String Procedure = ReadConfig.ReadPropFile(PACK_REMONTEE_CONSO_MOIS_OK, NomConfig);
		return RBip_Jdbc.consoMoisAnnee(Procedure, numSeq, sPid, structAction, etapeNum, tacheNum,
				stacheNum, sDate_deb_conso, sConsoFinDate, ressBip, fConsoQte);
	}

	public static boolean consoAnneeOK(int numSeq, String sPid, String structAction, Integer etapeNum, Integer tacheNum,
			Integer stacheNum, String sDate_deb_conso, String sConsoFinDate, Integer ressBip, Float fConsoQte)
	{
		String Procedure = ReadConfig.ReadPropFile(PACK_REMONTEE_CONSO_ANNEE_OK, NomConfig);
		return RBip_Jdbc.consoMoisAnnee(Procedure, numSeq, sPid, structAction, etapeNum, tacheNum,
				stacheNum, sDate_deb_conso, sConsoFinDate, ressBip, fConsoQte);
	}
	// FAD PPM 64368 : Fin

	public static boolean isLigneProductive(String p_pid) 
	{ 
		
		String Procedure = ReadConfig.ReadPropFile(PACK_REMONTEE_IS_LIGNE_PRODUCTIVE, NomConfig);
		return RBip_Jdbc.isLigneProductive(Procedure,p_pid);
						
	}
	
	public static boolean isPeriodeAnterieureAnneeFonct(String p_dateDebConso) 
	{ 
		String Procedure = ReadConfig.ReadPropFile(PACK_REMONTEE_IS_PERIODE_ANTERIEURE_ANNEE_FONCT, NomConfig);
		return RBip_Jdbc.isPeriodeAnterieureAnneeFonct(Procedure,p_dateDebConso);
		
	}
	
	public static String isPeriodeUlterieureMoisFonct(String p_dateDebConso, String p_pid) 
	{ 
		
		String Procedure = ReadConfig.ReadPropFile(PACK_REMONTEE_IS_PERIODE_ULTERIEURE_MOIS_FONCT, NomConfig);
		return RBip_Jdbc.isPeriodeUlterieureMoisFonct(Procedure,p_dateDebConso,p_pid);
		
	}
	// Fin KRA 16/04/2015 - PPM 60612
	
	//SEL PPM 62605
	public static String isPeriodeUlterieureAnneeFonct(String p_dateDebConso,
			String p_pid) { 
		
		String Procedure = ReadConfig.ReadPropFile(PACK_REMONTEE_IS_PERIODE_ULTERIEURE_ANNEE_FONCT, NomConfig);
		return RBip_Jdbc.isPeriodeUlterieureAnneeFonct(Procedure,p_dateDebConso,p_pid);
		
	}

	public static String verifier_tache_axe_metier(String sTacheAxeMetier,
			String sPid) {
		
		String Procedure = ReadConfig.ReadPropFile(PACK_VERIFIER_AXE, NomConfig);
		return RBip_Jdbc.verifier_tache_axe_metier(Procedure,sTacheAxeMetier,sPid);
		
	}

	public static List<List<String>> getListParamBip() {
		return listParamBip;
	}

	public static void setListParamBip(List<List<String>> listParamBip) {
		Tools.listParamBip = listParamBip;
	}
	
	//KRA PPM 61776	
	//PPM 64106
	public static String lireListeChefsProjet(String p_codeRess) 
	{ 
		
		Config configProc = ConfigManager.getInstance(BIP_PROC) ;
		JdbcBip jdbc = new JdbcBip();
		Vector vParamOut = new Vector();
		String listeCp ="";
		ParametreProc paramOut;
		Hashtable hParamProc = new Hashtable();
		hParamProc.put("codeRess", p_codeRess);
		
		try {
			
			vParamOut=jdbc.getResult(hParamProc,configProc,PACK_GLOBAL_LIRE_CHEFS_PROJET);	
			
			for (Enumeration e=vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				if (paramOut.getNom().equals("listeCp")) {
					if (paramOut.getValeur() != null) {
						listeCp = (String) paramOut.getValeur();
					}
				}
			}
			
		}//try
		catch (BaseException be) {
			be.getInitialException().getMessage();
			
		} finally {
			jdbc.closeJDBC();
		}
		return listeCp;
	  
	
	
						
	}
	//Fin KRA PPM 61776
	public static Vector listPmwBips() 
	{ 
		
		String procedure = ReadConfig.ReadPropFile(PACK_LISTER_PMW_BIPS, NomConfig);
		
		return RBip_Jdbc.listPmwBips(procedure);
		
	}

	//SEL QC 1811
	public static String[] verifier_tache_axe_metier_bips(String sTacheAxeMetier,String sPid) {
		
		String procedure = ReadConfig.ReadPropFile(PACK_VERIFIER_AXE_BIPS, NomConfig);
		
		return RBip_Jdbc.verifier_tache_axe_metier_bips(sTacheAxeMetier,sPid,procedure);
	}

	//Added for BIP-7 to do DMP check at ligne level
	public static String[] verifier_ligne_axe_metier_bips(String sPid) {
		
		String procedure = ReadConfig.ReadPropFile(PACK_VERIFIER_LINE_AXE_BIPS, NomConfig);
		
		return RBip_Jdbc.verifier_ligne_axe_metier_bips(sPid,procedure);
	}

	public static void inserer_erreur_bips(RBipErreur rBipErreur,String sPid,String sRess,String sActivite,String sDeb,String sConso) {
		
		String procedure = ReadConfig.ReadPropFile(PACK_INSERER_ERREUR_BIPS, NomConfig);
		
		RBip_Jdbc.inserer_erreur_bips(rBipErreur,sPid,sRess, sActivite, sDeb, sConso,procedure);
		
	}

	public static void deleteRejetMensuelleBips(String sVar) {
		
		String procedure = ReadConfig.ReadPropFile(PACK_DELETE_REJET_MENS_BIPS, NomConfig);
		
		RBip_Jdbc.deleteRejetMensuelleBips(sVar,procedure);
		
	}
	
	//SEL PPM 63412
	public static boolean isClientBBRF03(String clicode) 
	{ 
		
		String procedure = ReadConfig.ReadPropFile(PACK_ISCLIENTBBRF03, NomConfig);
		
		return RBip_Jdbc.isClientBBRF03(clicode, procedure);
		
	}
	
	public static String recup_dpcopi_du_proj(String sProjet)
	{
		String procedure = ReadConfig.ReadPropFile(PACK_RECUP_DPCOPI_DU_PROJ, NomConfig);
		
		return RBip_Jdbc.recup_dpcopi_du_proj(sProjet, procedure);
	}

	
	/*BIP-355 Outsourcing not allowed for non-productive BIP Line- STARTS*/
	public static Map<String, Set<String>> getOutSourcedData(Map<String, Set<String>> validFFbyLigneBipId) {
		
		return RBip_Jdbc.getOutSourcedData(validFFbyLigneBipId);
	
	}
	/*BIP-355 Outsourcing not allowed for non-productive BIP Line- ENDS*/
	
	public static Map<Integer, List<ResultHierarchy>> getHierarchyReportdata(String ident, String choice, String loggedUser, String orderBy) {
		
		return RBip_Jdbc.getHierarchyReportdata(ident, choice, loggedUser, orderBy);
	
	}
	

	public static String getIdentHierarchy(
			String rtfe) {
		return RBip_Jdbc.getIdentHierarchy(rtfe);
	}

	public static String getChefProj(String rtfe,  String loggedUser) {
		return RBip_Jdbc.getChefProj(rtfe, loggedUser);
	}


	public static Map<String, Set<Date>> checkRetroApplicativeParam(Map<String, Set<Date>> uniqueIdent) {
		
		return RBip_Jdbc.checkRetroApplicativeParam(uniqueIdent);
		
	}

//	public static boolean isStructSR(String idLigneBip) {
////		List<String> list = Arrays.asList(idLigneBip);
////		getListOfLigneBipThatAreStructureSR(list);
//		return true;
//	}
	
}
