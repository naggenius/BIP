/*
 * Cr�� le 10 mai 04
 *
 */
package com.socgen.bip.rbip.commun.loader;

import java.lang.reflect.InvocationTargetException;
import java.text.ParsePosition;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Vector;
import com.socgen.bip.commun.Tools;
import com.socgen.bip.db.RBip_Jdbc;
import com.socgen.bip.rbip.batch.RBip;
import com.socgen.bip.util.ReadConfig;
import com.socgen.cap.fwk.exception.BaseException;


/**
 * @author X039435 / E.GREVREND
 *
 * Cette classe contient des m�thodes qui r�pondent TOUTES aux crit�res suivant :
 * <ul>
 * <li>static et public</li>
 * <li>1 param�tre d'entr� de type <b>String</b></li>
 * <li>chaque m�thode permet de passer d'une repr�sentation sous forme de cha�ne au type correspondant, une fois convertie on retourne cette valeur </li>
 * <li>si la conversion �choue, on l�ve une InvocationTargetException</li>
 * <li>le type retourn� ne doit pas �tre un type primitif</li>
 * </ul>
 */
public class RBipParser implements RBipStructureConstants
{
	
	private static String NomConfig = "bip_proc";
	private static String cle = "listejeu.typeetape.proc";
	public static Vector ETAPES_PACTE = new Vector();

	public static void Etapes_Pacte_Clone() throws Exception{
		RBipParser.ETAPES_PACTE = (Vector) RBip.ETAPES_PACTE.clone();
	}

	
	/**
	 * Permet de v�rifier que la valeur correspond bien � un type d'�tape PACTE - Utilis� dans le traitement : Remont�e BIP Intranet et UNIx
	 * 
	 * @param sVal La valeur � convertir/tester
	 * @return sVal (en lettres capitales) si sVal correspond bien � un type d'�tape PACTE
	 * @throws InvocationTargetException
	 * @throws BaseException 
	 * @throws Throwable 
	 */
	
	
	public static String parsePACTE(String sVal) throws Throwable
	{
		
		sVal = sVal.toUpperCase();

		if("INTRANET".equals(RBip_Jdbc.TOP)){	// Remont�e BIP Intranet
		
			String Procedure = ReadConfig.ReadPropFile(cle, NomConfig);
			String p_user = null;
			RBip_Jdbc.recupererListe(Procedure, p_user, RBip_Jdbc.P_PID);

		for (int i = 0; i < RBipParser.ETAPES_PACTE.size(); i++)
		{
			if (RBipParser.ETAPES_PACTE.elementAt(i).equals(sVal) || sVal.equals(PACTE_ES) || sVal.equals(PACTE_NO))
				return sVal;
		}

		}
		else{ // Remont�e BIP UNIX
			
			for (int i = 0; i < RBipParser.ETAPES_PACTE.size(); i++)
			{
				if (RBipParser.ETAPES_PACTE.elementAt(i).equals(sVal) || sVal.equals(PACTE_ES) || sVal.equals(PACTE_NO))
					return sVal;
			}
		} // Fin Traitement
		
		throw new InvocationTargetException(null);
	}
	
	/**
	 * Permet de v�rifier que la valeur correspond bien � un type de sous-t�che
	 * @param sVal la valeur � convertir/tester
	 * @return sVal (en lettres capitales) si sVal coresspond bien � type de sous-t�che
	 * @throws InvocationTargetException
	 */
	public static String parseTypeSSTache(String sVal) throws InvocationTargetException
	{
		sVal = sVal.toUpperCase();
		for (int i = 0; i<SSTACHE_AB.length; i++)
		{
			if (SSTACHE_AB[i].equals(sVal))
				return sVal;
		}
		
		for (int i = 0; i<SSTACHE_ES.length; i++)
		{
			if (SSTACHE_ES[i].equals(sVal))
				return sVal;
		}
		
		for (int i = 0; i<SSTACHE_SANS_PID.length; i++)
		{
			if (SSTACHE_SANS_PID[i].equals(sVal))
				return sVal;
		}
		
		for (int i = 0; i<SSTACHE_PID.length; i++)
		{
			if (sVal.startsWith(SSTACHE_PID[i]))
			{
				//maintenant on verifie que les caracteres suivant sont bien un PID valide
				if (Tools.isPIDValid(sVal.substring(2, sVal.length())))
					return sVal;
			}
		}
		
		for (int i = 0; i<SSTACHE_PID_PROJET.length; i++)
		{
			if (sVal.startsWith(SSTACHE_PID_PROJET[i]))
			{
				//maintenant on verifie que les caracteres suivant sont bien un PID valide
				if (Tools.isPIDValid(sVal.substring(2, sVal.length())))
					return sVal;
			} 
		}
		throw new InvocationTargetException(null);
	}
	
	/**
	 * Permet de v�rifier que la valeur correspond bien � une valeur valide pour une charge JH (donc < 99999,99 JH)
	 * @param sVal la valeur � convertir/tester
	 * @return Double la valeur r�elle (type num�rique) de sVal/100 si <9999,99
	 * @throws InvocationTargetException
	 */
	public static Double parseChargeJH(String sVal) throws InvocationTargetException
	{
		Integer val = new Integer(sVal);
		
		//pas un digit
		if (val == null)
			throw new InvocationTargetException(null);
			
		if (val.intValue() > CHARGE_JH_MAX)
			throw new InvocationTargetException(null);
		
		return new Double(val.intValue()*0.01);
	}
	
	/**
	 * Permet de v�rifier que la valeur correspond bien � un lot bip de ressource : 5chiffres+* ou 6*
	 * @param sVal la valeur � tester
	 * @return sVal (en lettres capitales) si sVal correspond bien � un lot bip de ressource
	 * @throws InvocationTargetException
	 */
	public static String parseTires(String sVal) throws InvocationTargetException
	{
		//un lot bip de ressource :
		//5 chiffres + '*' ou alors 6 '*'
		sVal = sVal.toUpperCase();
		
		if (sVal.length() != 6)
			throw new InvocationTargetException(null);
		
		if (sVal.equals("******"))
					return sVal;
		
		if ( (sVal.charAt(5)=='*') && (new Integer(sVal.substring(0,5)) != null) )
			return sVal; 
		
		throw new InvocationTargetException(null);
	}
	
	/**
	 * 
	 * @param sVal
	 * @return
	 * @throws InvocationTargetException
	 */
	public static Integer parseVersionFichier(String sVal) throws InvocationTargetException
	{
		Integer i = new Integer(sVal);
		 		
		if ( (i == null) || !sVal.equals(cfgStruct.getString(TAG_VERSION)) ) 
			throw new InvocationTargetException(null);
		
		return i;
	}
	
	/**
	 * Permet de v�rifier que la valeur correspond bien � un PID (sur 3 ou 4)
	 * @param sVal la valeur � tester
	 * @return sVal (en lettres capitales) si sVal correspond bien � un PID valide
	 * @throws InvocationTargetException
	 */
	public static String parsePID(String sVal) throws InvocationTargetException
	{
		sVal = sVal.toUpperCase();
		if (Tools.isPIDValid(sVal)==true)
			return sVal;
		throw new InvocationTargetException(null);	
		//return sVal;
	}
	
	/**
	 * Permet de v�rifier que la valeur correspond bien � un PID (sur 3 ou 4), autorise la valeur vide
	 * @param sVal la valeur � tester
	 * @return sVal (en lettres capitales) si sVal correspond bien � un PID valide
	 * @throws InvocationTargetException
	 */
	public static String parsePID_vide(String sVal) throws InvocationTargetException
	{
		if (sVal.trim().length() == 0)
			return null;
			
		return parsePID(sVal);		
	}
	
	protected static SimpleDateFormat sDF_AAMMJJ = null;
	protected static SimpleDateFormat sDF_JJMMAAAA = null;
	
	protected static Date getDateAAMMJJ(String sD)
	{
		if (sDF_AAMMJJ == null)
		{
			sDF_AAMMJJ = new SimpleDateFormat("yyMMdd");
			sDF_AAMMJJ.setLenient(false);
		}
		Date dM = sDF_AAMMJJ.parse(sD, new ParsePosition(0)/*pos0*/);
		return dM;
	}
	
	//public static Date DATE_BLANC = sDM_AAMMJJ.parse("", new ParsePosition(0));  
	
	/**
	 * 
	 */
	public static Date parseAAMMJJ2Date(String sAAMMJJ) throws InvocationTargetException
	{
		if (sAAMMJJ.trim().length() == 0)
			return null;//DATE_BLANC;
		
		try
		{
			if ( (new Integer(sAAMMJJ)).intValue() == 0 )
			{
				return null;
			}
		}
		catch (NumberFormatException nFE)
		{
			throw new InvocationTargetException(null);
		}
		
		if (sDF_AAMMJJ == null)
		{
			sDF_AAMMJJ = new SimpleDateFormat("yyMMdd");
			sDF_AAMMJJ.setLenient(false);
		}
		
		Date dM = sDF_AAMMJJ.parse(sAAMMJJ, new ParsePosition(0)/*pos0*/);
		if (dM == null)
		 throw new InvocationTargetException(null);
		return dM;
	}
	
	//PPM 60612 : JJ/MM/AAAA
	public static Date parseJJMMAAAADate(String sJJMMAAAA) throws InvocationTargetException
	{
		if (sJJMMAAAA.trim().length() == 0)
			return null;//DATE_BLANC;
		
		if (sDF_JJMMAAAA == null)
		{
			sDF_JJMMAAAA = new SimpleDateFormat("dd/MM/yyyy");
			sDF_JJMMAAAA.setLenient(false);
		}
		
		Date dM = sDF_JJMMAAAA.parse(sJJMMAAAA, new ParsePosition(0)/*pos0*/);
		if (dM == null)
		 throw new InvocationTargetException(null);
		return dM;
	}
	
	/**
	 * Permet de convertir en Date une valeur cha�ne de caract�re qui est construite en accolant annee� + mois� + jour�
	 * @param sAAMMJJCarre la valeur � convertir
	 * @return Date issue de la conversion r�ussie de la valeur
	 * @throws InvocationTargetException
	 */
	public static Date parseJJMMAACarre2Date(String sJJMMAACarre) throws InvocationTargetException
	{
		new Double(sJJMMAACarre);
		//test longueur
		String sD="";
		int intVal;
		double dSqrtVal;
		
		//test de l'annee
		intVal = new Integer(sJJMMAACarre.substring(8,12)).intValue();
		dSqrtVal = Math.sqrt(intVal);
		if (dSqrtVal != (double)((int)dSqrtVal) )
		{
			throw new InvocationTargetException(null);
		}
		if (dSqrtVal < 10)
			sD = "0";		
		sD +=(int)dSqrtVal;
		
		//test du mois
		intVal = new Integer(sJJMMAACarre.substring(4,8)).intValue();
		dSqrtVal = Math.sqrt(intVal);
		if (dSqrtVal != (double)((int)dSqrtVal) )
		{
			throw new InvocationTargetException(null);
		}
		if (dSqrtVal < 10)
			sD += "0";
		sD += (int)dSqrtVal;
 
 		//test du jour
		intVal = new Integer(sJJMMAACarre.substring(0,4)).intValue();
		dSqrtVal = Math.sqrt(intVal);
		if (dSqrtVal != (double)((int)dSqrtVal) )
		{
			throw new InvocationTargetException(null);
		}
		if (dSqrtVal < 10)
			sD += "0";
		sD += (int)dSqrtVal;

		//Date dM = getDateAAMMJJ(sD);
		//return dM;
		return parseAAMMJJ2Date(sD);
	}
	
	/**
	 * Les cha�ne de caract�res de la BIP ne peuvent pas contenit l'ensemble des caract�res du jeux ASCII (pour faire simple).
	 * @param sVal
	 * @return sVal si la cha�ne correspond bien � une cha�ne autoris�e
	 * @throws InvocationTargetException
	 */
	public static String parseString(String sVal) throws InvocationTargetException
	{
		for (int i=0; i<sVal.length(); i++)
		{
			char c = sVal.charAt(i);
			if ( (Character.isISOControl(c)) || (c == ';') )
			{
				throw new InvocationTargetException(null);
			}
		}
		return sVal;		
	}
	
	public static Integer parseInteger(String sVal) throws InvocationTargetException
	{
		if (sVal.trim().length() == 0)
			return null;

		try
		{
			return new Integer(sVal);
		}
		catch (ClassCastException cCE)
		{
			throw new InvocationTargetException(null);
		}		
	}
	
	/**
	 * Les types de consomm� valides sont : 0, 1 et 2
	 * @param sVal la valeur � tester
	 * @return sVal si la cha�ne correspond bien � un type de consomm�
	 * @throws InvocationTargetException
	 */
	public static String parseTypeConsomme(String sVal) throws InvocationTargetException
	{
		if (!Tools.isTypeConsomme(sVal))
		{
			throw new InvocationTargetException(null);
		}
		return sVal;
	}
	
	public static Float parseDecimal(String sVal) throws InvocationTargetException
	{
		if (sVal.trim().length() == 0)
			return null;

		try {
			return new Float(sVal.replace(',', '.'));
		} catch (ClassCastException e) {
			throw new InvocationTargetException(null);
		}
	}


}
