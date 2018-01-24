package com.socgen.bip.action;

import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.form.ParametreForm;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author P. JOSSE - 11/10/2004
 *
 * Action de mise à jour des Paramètres
 * chemin : Administration/Surveillance/Etat BIP
 * pages  : fmParametreAd.jsp et mParametreAd.jsp
 * pl/sql : parametre.sql
 */
public class ParametreAction extends AutomateAction implements BipConstantes{

	private static String PACK_SELECT = "parametre.consulter_val.proc";
	private static String PACK_UPDATE = "parametre.modifier.proc";
	private String nomProc;
	
	
   /**
	* Action qui permet de visualiser les données liées à un paramètre pour la modification
	*/
	protected  ActionForward consulter(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws ServletException{
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message="";
		boolean msg=false;
		ParametreProc paramOut;
		
		String signatureMethode =
			"ParametreAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		ParametreForm bipForm= (ParametreForm)form ;
		
		//exécution de la procédure PL/SQL	
		try {
			 vParamOut=jdbc.getResult (hParamProc,configProc,PACK_SELECT);
	
		//Récupération des résultats
			for (Enumeration e=vParamOut.elements(); e.hasMoreElements();) {
				  paramOut = (ParametreProc) e.nextElement();
			
				//récupérer le message
				if (paramOut.getNom().equals("message")) {
					message=(String)paramOut.getValeur();
				}
				//récupérer le message
				if (paramOut.getNom().equals("valeur_param"))
					bipForm.setValeur_param((String)paramOut.getValeur());
				if (paramOut.getNom().equals("liste_valeurs"))
					bipForm.setListeValeurs((String)paramOut.getValeur());
				if (paramOut.getNom().equals("libelle"))
					bipForm.setLibelle((String)paramOut.getValeur());
				
			}//for
			if (msg) {	
				//le Paramètre n'existe pas, on récupère le message 
				bipForm.setMsgErreur(message);
				//on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}	
		}//try
		catch (BaseException be) {
			logBipUser.debug("ParametreAction-consulter() --> BaseException :"+be, be);
			logBipUser.debug("ParametreAction-consulter() --> Exception :"+be.getInitialException().getMessage());

			logService.debug("ParametreAction-consulter() --> BaseException :"+be, be);
			logService.debug("ParametreAction-consulter() --> Exception :"+be.getInitialException().getMessage());	
			errors.add(ActionErrors.GLOBAL_ERROR , new ActionError("11201"));
			//this.saveErrors(request,errors);
			 jdbc.closeJDBC(); return mapping.findForward("error");
		}	
		logBipUser.exit(signatureMethode);
		 
		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	}

	protected String recupererCle(String mode) {
		String cle = null;
		if (mode.equals("update")){
			cle=PACK_UPDATE;
		}
		  return cle;
	}
}