/*
 * Créé le 3 sept. 04
 */
package com.socgen.bip.commun.bd;

import java.util.Hashtable;
import java.util.StringTokenizer;
import java.util.Vector;

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.config.ConfigManager;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author X039435
 */
public class ParametreBD implements BipConstantes
{
	protected static Config cfgProc = ConfigManager.getInstance(BIP_PROC);
	protected static final String PROC_SET = "parametre.modifier.proc";
	protected static final String PROC_GET_VAL = "parametre.consulter_val.proc";
	protected static final String PROC_GET_LIB = "parametre.consulter_lib.proc";
	protected static final String PROC_GET_LISTE_VAL = "parametre.consulter_liste.proc";
	
	 
	
	static protected void setValeur(String sCle, String sVal) throws BaseException
	{
		Hashtable hParam = new Hashtable();
		hParam.put("cle_param", sCle);
		hParam.put("valeur_param", sVal);
		JdbcBip  jdbc = new JdbcBip();
		
		
		jdbc.getResult(hParam, cfgProc, PROC_SET);
		jdbc.closeJDBC();
	}
	
	static synchronized public String getValeur(String sCle) throws BaseException
	{
		Vector vRes;
		String sRes = null;
		Hashtable hParam = new Hashtable();
		hParam.put("cle_param", sCle);
		JdbcBip  jdbc = new JdbcBip();
		
		
		try
		{
			vRes = jdbc.getResult( hParam, cfgProc, PROC_GET_VAL);
			ParametreProc pP = (ParametreProc)vRes.firstElement();
			sRes = (String)pP.getValeur(); 
		}
		catch (BaseException bE)
		{
			logService.error("ParametreBD.getValeur("+sCle+")",bE);
			throw bE;
		}finally{
			jdbc.closeJDBC();
		}
		
		return sRes;
	}	
	
	static public String getLibelle(String sCle) throws BaseException
	{
		Vector vRes;
		Hashtable hParam = new Hashtable();
		hParam.put("cle_param", sCle);
		JdbcBip  jdbc = new JdbcBip();
		
		
		vRes = jdbc.getResult( hParam, cfgProc, PROC_GET_LIB);
		ParametreProc pP = (ParametreProc)vRes.firstElement();
		jdbc.closeJDBC();

		return (String)pP.getValeur();
	}
	
	static public Vector getListeValeurs(String sCle) throws BaseException
	{
		Vector vRes;
		String sVal;
		Vector vListeVal;
		Hashtable hParam = new Hashtable();
		hParam.put("cle_param", sCle);
		JdbcBip  jdbc = new JdbcBip();
		
		
		vRes = jdbc.getResult( hParam, cfgProc, PROC_GET_LISTE_VAL);
		ParametreProc pP = (ParametreProc)vRes.firstElement();

		sVal = (String)pP.getValeur();
		
		if ((sVal == null) || (sVal.trim() == ""))
			return null;
			
		StringTokenizer sTk = new StringTokenizer(sVal,";");
		vListeVal = new Vector();
		
		while (sTk.hasMoreTokens())
		{
			vListeVal.add(sTk.nextToken());			
		}
		
		jdbc.closeJDBC();
		/*if (vListeVal.size() == 0)
			return null;*/
		
		return vListeVal; 
	}
}
