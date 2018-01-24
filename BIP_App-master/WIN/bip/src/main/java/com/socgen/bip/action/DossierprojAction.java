package com.socgen.bip.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Locale;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.liste.ListeDynamique;
import com.socgen.bip.commun.liste.ListeOption;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.form.DossierprojForm;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author N.BACCAM - 18/06/2003
 *
 * Formulaire pour mise à jour des dossiers projet
 * chemin : Administration/Référentiels/Dossiers projet
 * pages  : fmDossierprojAd.jsp et mDossierprojAd.jsp
 * pl/sql : dos_proj.sql
 */
public class DossierprojAction extends SocieteAction {

	private static String PACK_SELECT = "dossierproj.consulter.proc";
	private static String PACK_INSERT = "dossierproj.creer.proc";
	private static String PACK_UPDATE = "dossierproj.modifier.proc";
	private static String PACK_DELETE = "dossierproj.supprimer.proc";
	private static String PACK_CONTROLE_DIRPRIN = "dossierproj.controledirprin.proc";//PPM 59288
	private String nomProc;
	
   /**
	* Action qui permet de créer un code Dossierproj
	*/
	protected ActionForward creer(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws ServletException{
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message="";
		boolean msg=false;
		
		String signatureMethode ="DossierprojAction -creer( mapping, form , request,  response,  errors )";

		//logService.entry(signatureMethode);;
		logBipUser.entry(signatureMethode);
		//exécution de la procédure PL/SQL	
		try {
				// On initialise le top actif à 'O'
				((DossierprojForm)form).setTopActif("O");
				
			 	vParamOut= jdbc.getResult (hParamProc,configProc,PACK_SELECT);
			 	try {
					message= jdbc.recupererResult(vParamOut,"creer");
			 	}
			 	catch (BaseException be) {
			 		logBipUser.debug("DossierprojAction -creer() --> BaseException :"+be);
					logBipUser.debug("DossierprojAction -creer() --> Exception :"+be.getInitialException().getMessage());
					logService.debug("DossierprojAction -creer() --> BaseException :"+be);
					logService.debug("DossierprojAction -creer() --> Exception :"+be.getInitialException().getMessage());
					//Erreur de lecture du resultSet
					errors.add(ActionErrors.GLOBAL_ERROR , new ActionError("11217"));
					//this.saveErrors(request,errors);
					jdbc.closeJDBC(); return mapping.findForward("error");
			 	}
				if (!message.equals("")) {
				//Entité déjà existante, on récupère le message 
					((DossierprojForm)form).setMsgErreur(message);
					
					logBipUser.debug("message d'erreur:"+message);
					logBipUser.exit(signatureMethode);
				//on reste sur la même page
					jdbc.closeJDBC(); return mapping.findForward("initial");
				}	
			
		}//try
		catch (BaseException be) {
			logBipUser.debug("DossierprojAction-creer() --> BaseException :"+be);
			logBipUser.debug("DossierprojAction-creer() --> Exception :"+be.getInitialException().getMessage());
			logService.debug("DossierprojAction-creer() --> BaseException :"+be);
			logService.debug("DossierprojAction-creer() --> Exception :"+be.getInitialException().getMessage());
			//Erreur d''exécution de la procédure stockée
			errors.add(ActionErrors.GLOBAL_ERROR , new ActionError("11201"));
			//this.saveErrors(request,errors);
			jdbc.closeJDBC(); return mapping.findForward("error");
		}	
			
		//logService.exit(signatureMethode);
		logBipUser.exit(signatureMethode);
	
		jdbc.closeJDBC(); return mapping.findForward("ecran");	
	}//creer
	
   /**
	* Action qui permet de visualiser les données liées à un code client pour la modification et la suppression
	*/
	protected  ActionForward consulter(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors , Hashtable hParamProc) throws ServletException{
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message="";
		boolean msg=false;
		ParametreProc paramOut;
		
		String signatureMethode =
			"ClientAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		DossierprojForm bipForm= (DossierprojForm)form ;
		
		//exécution de la procédure PL/SQL	
		try {
			 vParamOut= jdbc.getResult (hParamProc,configProc,PACK_SELECT);
	
		//Récupération des résultats
			for (Enumeration e=vParamOut.elements(); e.hasMoreElements();) {
				  paramOut = (ParametreProc) e.nextElement();
				
				//récupérer le message
				if (paramOut.getNom().equals("message")) {
					message=(String)paramOut.getValeur();
				}
			
				
				if (paramOut.getNom().equals("curseur")) {
					//Récupération du Ref Cursor
					ResultSet rset =(ResultSet)paramOut.getValeur();
			
					try {
					logService.debug("ResultSet");
						if (rset.next()) {

				     		bipForm.setDpcode(rset.getString(1));
				     	    bipForm.setDplib(rset.getString(2).trim());
							bipForm.setFlaglock(rset.getInt(3));
							Date laDateImmo = rset.getDate(4);
							if (laDateImmo!= null) {
								SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy", Locale.FRANCE);
								bipForm.setDateimmo((sdf.format(laDateImmo)).toString());
							}
							bipForm.setTopActif(rset.getString(5));
							bipForm.setTypdp( rset.getString(6) );
							bipForm.setDp1(rset.getString(7));
							bipForm.setDp2(rset.getString(8));
							//debut PPM 59288
							Integer iDirPrin = rset.getInt(9);
							bipForm.setDir_prin((iDirPrin==null) ? null : iDirPrin.toString());							
							//Fin PPM 59288
				    		bipForm.setMsgErreur(null);
						}
						else
							msg=true;
						//Debut PPM 59288 : recherche de libelle de code direction (utile en cas de supression)
						ListeDynamique listeDynamique = new ListeDynamique();
						ArrayList listDirPrin = listeDynamique.getListeDynamique("dir_prin",bipForm.getHParams()); 
						request.setAttribute("listDirPrin",listDirPrin);

						if(listDirPrin!=null){
							Iterator iterList = listDirPrin.iterator();
							while(iterList.hasNext()){
								ListeOption listeOption = (ListeOption)iterList.next();
								String cle = listeOption.getCle();
								if(cle!=null && cle!="" && cle.equalsIgnoreCase(bipForm.getDir_prin())){
									bipForm.setLibelleDirPrin(listeOption.getLibelle());
								}								
							}
						}
						//Fin PPM 59288
					}//try
					catch (SQLException sqle) {
						logService.debug("DossierprojAction-consulter() --> SQLException :"+sqle);
						logBipUser.debug("DossierprojAction-consulter() --> SQLException :"+sqle);
						//Erreur de lecture du resultSet
						errors.add(ActionErrors.GLOBAL_ERROR , new ActionError("11217"));
						//this.saveErrors(request,errors);
						jdbc.closeJDBC(); return mapping.findForward("error");
					}
					finally {
						try {
							if (rset != null)
								rset.close();
						}
						catch (SQLException sqle) {
							logBipUser.debug("DossierprojAction-consulter() --> SQLException-rset.close() :"+sqle);
							//Erreur de lecture du resultSet
							errors.add(ActionErrors.GLOBAL_ERROR , new ActionError("11217"));
							jdbc.closeJDBC(); return mapping.findForward("error");
						}
					}
				}//if
			}//for
			if (msg) {	
				//le code Dossierproj n'existe pas, on récupère le message 
				bipForm.setMsgErreur(message);
				//on reste sur la même page
				jdbc.closeJDBC(); return mapping.findForward("initial");
			}	
		}//try
		catch (BaseException be) {
			logBipUser.debug("DossierprojAction-consulter() --> BaseException :"+be, be);
			logBipUser.debug("DossierprojAction-consulter() --> Exception :"+be.getInitialException().getMessage());

			logService.debug("DossierprojAction-consulter() --> BaseException :"+be, be);
			logService.debug("DossierprojAction-consulter() --> Exception :"+be.getInitialException().getMessage());	
			errors.add(ActionErrors.GLOBAL_ERROR , new ActionError("11201"));

			//this.saveErrors(request,errors);
			jdbc.closeJDBC(); return mapping.findForward("error");
		}	
		logBipUser.exit(signatureMethode);
		 
		jdbc.closeJDBC(); return mapping.findForward("ecran");
	}
	
	/**
	 * PPM 59288
	 * Controle de cohérence d'une direction principale à un Dossier de projet
	 * @param form
	 * @param ident
	 * @param mois_annee
	 * @param hParamProc
	 * @return
	 */

	public ActionForward controleDirPrin(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws IOException{
		String signatureMethode ="DossierprojAction - controleDirPrin";

		return traitAjax(PACK_CONTROLE_DIRPRIN, signatureMethode, mapping, form, response, hParamProc);
	}

	private ActionForward traitAjax(String cleProc, String signatureMethode, ActionMapping mapping, ActionForm form, HttpServletResponse response, Hashtable hParamProc) throws IOException {
		logBipUser.entry(signatureMethode);
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut;
		ParametreProc paramOut;
		String result = "";
		
		// Appel de la procédure
		try {
			vParamOut= jdbc.getResult (hParamProc,configProc, cleProc);
		 	// ----------------------------------------------------------
			for (Enumeration e=vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				if (paramOut.getNom().equals("result")) {
					if (paramOut.getValeur() != null) {
						result = (String) paramOut.getValeur();
					}
				}
			}	
		}
		catch (BaseException be) {
			logBipUser.debug(signatureMethode + " --> Exception :"+be.getInitialException().getMessage());
			logService.debug(signatureMethode + " --> BaseException :"+be);
			
			if (!be.getInitialException().getClass().getName().equals(
			"java.sql.SQLException")) {
				// Erreur d'execution
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
			} 
		}	
		
		jdbc.closeJDBC();
		
		// Ecriture de la valeur de retour dans la response
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		out.println(new String(result.getBytes("utf8"), "iso-8859-1"));
		out.flush();
		
		logBipUser.exit(signatureMethode);
		
		return PAS_DE_FORWARD;
	}
	protected String recupererCle(String mode) {
		String cle = null;
		if (mode.equals("insert")){
			cle=PACK_INSERT;
		}
		else if (mode.equals("update")){
			cle=PACK_UPDATE;
		}
		else if (mode.equals("delete")){
			cle=PACK_DELETE;
		}
		return cle;
	}
	

}
