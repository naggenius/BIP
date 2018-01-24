package com.socgen.bip.action;

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

import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.CentrefraisForm;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author N.BACCAM - 16/06/2003
 *
 * Action pour la composition des centres de frais 
 * chemin : Administration/Tables/ mise à jour/Centre de frais/ composition
 * pages  : bCompocfAd.jsp, mCompocfAd.jsp
 * pl/sql : Compocf.sql
 */
public class CompocfAction extends CentrefraisAction {

	private static String PACK_SELECT = "centrefrais.consulter.proc";
	private static String PACK_UPDATE = "compocf.modifier.proc";
	private static String PACK_DELETE = "compocf.supprimer.proc";

	private String nomProc;
	
	
	
	/**
	* Action qui permet d'ouvrir sur la page de composition des centres de frais bCompocfAd.jsp
	*/
     protected  ActionForward suite(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors,Hashtable hParamProc  ) throws ServletException{
      	String signatureMethode =
			"CompocfAction-suite(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
      	//((CentrefraisForm)form).setLibcfrais(libCentreFrais);
       logBipUser.exit(signatureMethode);
        return mapping.findForward("initial") ;
	}
	
   /**
	* Action qui permet d'ajouter un BDDPG au centre de frais
	*/
	protected ActionForward creer(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors,Hashtable hParamProc  ) throws ServletException{
		
		Vector vParamOut = new Vector();
		String message="";
		boolean msg=false;
		
		String signatureMethode ="CompocfAction -creer( mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
	
		logBipUser.exit(signatureMethode);
	
	   return mapping.findForward("ecran");	
	}//creer
	
	/**
	* Action qui permet de se rediriger sur une page lors de l'annulation
	*/
	protected  ActionForward annuler(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors,Hashtable hParamProc  ) throws ServletException{
		String sMode = request.getParameter("mode") ;
		
		//page bCompocfAd.jsp
		if (sMode .equals("avant")) 
			  return mapping.findForward("avant") ;
		
		else if (sMode .equals("ecran")) 
			 return mapping.findForward("ecran") ;
		
		else if (sMode .equals("initial")) 
			 return mapping.findForward("initial") ;
		
		else
		    return mapping.findForward("avant") ;
	}//annuler
	
	/**
	* Action qui permet de valider la saisie
	*/
	protected  ActionForward valider(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors ,Hashtable hParamProc ) throws ServletException{
		//Récupérer le niveau d'habilitation = keyList1
		String sHab = ((CentrefraisForm)form).getKeyList1();
		
		Vector vParamOut = new Vector();
	    String message="";
		ActionForward actionForward=null;
		String signatureMethode =
			"CompocfAction-valider(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		
		//Titre de la liste
		if (sHab.equals("br")){
					((CentrefraisForm)form).setTitrePage("branches");
		}
		else if (sHab.equals("dir")){
					((CentrefraisForm)form).setTitrePage("directions");
		}
		else if (sHab.equals("dpt")){
					((CentrefraisForm)form).setTitrePage("départements");
		}
		else if (sHab.equals("pole")){
					((CentrefraisForm)form).setTitrePage("pôles");
		}
		if (mode .equals("insert")){ //Page mCompocfAd.jsp
		
				logBipUser.exit(signatureMethode);
				return mapping.findForward("bddpg") ;
		
		}
		else {
			logBipUser.debug("mode:"+hParamProc.get("mode"));
			//exécuter la procédure
			actionForward = validation(mapping, form ,mode, request,response, errors,hParamProc );
			
		}
	
		 return actionForward;
	
	}//valider
  
protected  ActionForward validation(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors , Hashtable hParamProc ) throws ServletException{
	
	    JdbcBip jdbc = new JdbcBip(); 
	    Vector vParamOut = new Vector();
	    String cle = null;
	    String message="";
	    
	    String signatureMethode =
			"validation(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors )";
		logBipUser.entry(signatureMethode);
		logBipUser.debug("mode de mise à jour:"+mode);
		//On récupère la clé pour trouver le nom de la procédure stockée dans bip_proc.properties
		cle=recupererCle(mode);
	   
	
		//On exécute la procédure stockée
		try {
		
			vParamOut=jdbc.getResult (hParamProc,configProc,cle);
	
		}
		catch (BaseException be) {

			logService.debug("valider() --> BaseException :"+be);
			logService.debug("valider() --> Exception :"+be.getInitialException().getMessage());
			logBipUser.debug("valider() --> BaseException :"+be);
			logBipUser.debug("valider() --> Exception :"+be.getInitialException().getMessage());
			//Si exception sql alors extraire le message d'erreur du message global
			if (be.getInitialException().getClass().getName().equals("java.sql.SQLException")){
				message = BipException.getMessageFocus(BipException.getMessageOracle(be.getInitialException().getMessage()), form);
				((CentrefraisForm)form).setMsgErreur(message);
				if (!mode.equals("delete")) {
					 jdbc.closeJDBC(); return mapping.findForward("bddpg") ;
				}
				
			}
			else {
				//Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR , new ActionError("11201"));
		    	request.setAttribute("messageErreur",be.getInitialException().getMessage());
				//this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}	
		
		logBipUser.exit(signatureMethode);
		
		 jdbc.closeJDBC(); return mapping.findForward("initial") ;
		

	}//validation
 protected String recupererCle(String mode) {
		String cle = null;
		if (mode.equals("select")){
			cle=PACK_SELECT;
		}
		else if (mode.equals("bddpg")){
			cle=PACK_UPDATE;
		}
		else if (mode.equals("delete")){
			cle=PACK_DELETE;
		}
		  return cle;
	}//recupererCle
}
