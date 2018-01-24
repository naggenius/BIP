package com.socgen.bip.exception;

import org.apache.struts.action.ActionForm;

import com.socgen.bip.commun.form.BipForm;
import com.socgen.cap.fwk.exception.FwkException;

/**
 * @author user
 *
 * To change this generated comment edit the template variable "typecomment":
 * Window>Preferences>Java>Templates.
 * To enable and disable the creation of type comments go to
 * Window>Preferences>Java>Code Generation.
 */
public class BipException extends FwkException {


	
	public BipException(int codeErreur, Throwable erreurSource)
	{
		super(codeErreur, erreurSource, null, null);
	}
	
	public BipException(int codeErreur, Throwable erreurSource, Object [] params)
	{
		super(codeErreur, erreurSource, null, null, params);
	}
/**
 * getMessageOracle : extrait le message d'erreur Oracle
 */	
	public static String getMessageOracle(String sMessage) {
		int iPosDebut=0;
		int iPosFin=0;
		String sNum=null;
		int iNum=0;
		String sMsg=null;
		
		iPosDebut = sMessage.indexOf("ORA-")+10;
		iPosFin = sMessage.indexOf("ORA-",iPosDebut);
		
	try{
		sNum = sMessage.substring(iPosDebut-6, iPosDebut-1);
		
		iNum = (new Integer(sNum)).intValue();
		if (iNum==20997) {
			//gestion des exceptions clause plsql OTHERS
			//positionner sur le 2ème tag 'ORA-'
			iPosDebut = iPosFin+10;
			iPosFin = sMessage.indexOf("ORA-",iPosDebut);
			sNum = sMessage.substring(iPosDebut-6, iPosDebut-1);
			iNum = (new Integer(sNum)).intValue();
			//intercepter certaines erreurs
			switch (iNum) {
				case 1400 : sMsg = "Champ obligatoire non saisi";
							break;
				case 1407 : sMsg = "Champ obligatoire non saisi";
							break;
				case 1722 : sMsg = "Nombre invalide";
							break;
				default  : sMsg = sMessage.substring(iPosDebut, iPosFin-1);
							break;	
			}//switch
		}
		else if ((iNum>=20000)&&(iNum<21000)){
			//Gestion des messages applicatifs
			if (iPosFin != -1){
				sMsg = sMessage.substring(iPosDebut, iPosFin-1);
			}
			else {
				sMsg = sMessage.substring(iPosDebut, sMessage.length() - 1);
			}
		}
		else  {
			//Gestion des erreurs Oracle non intercepté par la clause plsql OTHERS
			if (iPosFin != -1){
				sMsg = "Erreur "+sMessage.substring(iPosDebut-10, iPosFin-1);
			}
			else {
				sMsg = "Erreur "+sMessage.substring(iPosDebut-10, sMessage.length() - 1);
			}
		}
		
	   }catch(NumberFormatException e)
	   {
		   
		   return sMessage;
	   }
	   
		
		return sMsg;
	}
/**
 * getMessageFocus : extrait le message d'erreur Oracle sans le focus
 */	
    public static String getMessageFocus(String sMessage, ActionForm form) {
    	int iPosDebut=0;
    	iPosDebut = sMessage.indexOf("FOCUS=");
    	if (iPosDebut>0) {
    		((BipForm)form).setFocus(sMessage.substring(iPosDebut+6).toLowerCase());
    		
    		return sMessage.substring(0,iPosDebut);
    		
    	}
    	else {
    		return sMessage;
    	}
    	
		
	}//getMessageOracle
}
