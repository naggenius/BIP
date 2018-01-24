package com.socgen.bip.action;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.StringTokenizer;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.Tools;
import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.ChargerProfilForm;
import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.config.ConfigManager;
import com.socgen.cap.fwk.exception.BaseException;


/**
 * @author CMA le 21/01/2011
 *
 * Action permettant le chargement du périmètre RTFE d'un autre utilisateur
 * chemin : 
 * pages  : mChargerProfil.jsp
 * 
 */


public class ChargerProfilAction extends AutomateAction {
	

	private static String PACK_COUNT_RTFE_USER = "rtfe.user.count.proc";
	private static String PACK_SELECT_RTFE = "rtfe.charger.proc";
	
	static Config cfgSQL = ConfigManager.getInstance("sql");
	private static String sProcFiliale = "SQL.filiale";
	
	public ActionForward annuler(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		ChargerProfilForm bipForm = (ChargerProfilForm) form;
		bipForm.setDebnom("");
		bipForm.setIdent("");
		bipForm.setNomcont("");
		return mapping.findForward("initial");
	}
	
	public ActionForward initialiser(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		ChargerProfilForm bipForm = (ChargerProfilForm) form;
		if((!StringUtils.isEmpty(bipForm.getDebnom())) || (!StringUtils.isEmpty(bipForm.getNomcont()))){
			bipForm.setIdent("");
			if(StringUtils.isEmpty(bipForm.getCount())){
				return mapping.findForward("initial");
			}else{
				return mapping.findForward("list");
			}
		}
		return mapping.findForward("initial");
	}
	
	public ActionForward retour(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		ChargerProfilForm bipForm = (ChargerProfilForm) form;
		
		if((!StringUtils.isEmpty(bipForm.getDebnom())) || (!StringUtils.isEmpty(bipForm.getNomcont()))){
			bipForm.setIdent("");
			bipForm.setCount("");
		}
		
		return mapping.findForward("initial");
	}
	
	/**
	 * Action appelée lors du clic sur Valider du formulaire
	 * => redirection vers le formulaire initial si erreur ou aucun utilisateur RTFE trouvé : mChargerProfils.jsp
	 * => sinon redirection vers la liste des utilisateurs RTFE trouvés : rechercheProfil.jsp
	 */
	public ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		Vector vParamOut = new Vector();
		String message = "";
		String count = "";
		ParametreProc paramOut;
		JdbcBip jdbc = new JdbcBip();
		
		
		String signatureMethode = "RessourceAction-consulter()";
		logBipUser.entry(signatureMethode);
		logBipUser.debug("fmemory start : " + Runtime.getRuntime().freeMemory());
		// Création d'une nouvelle form
		ChargerProfilForm bipForm = (ChargerProfilForm) form;
		if (hParamProc == null) {
			logBipUser.debug("consultationRess-consulter-->hParamProc is null");
		}
		
		// le count de la recherche
		try {
			vParamOut = jdbc.getResult(hParamProc,configProc, PACK_COUNT_RTFE_USER);
			
//			pas besoin d'aller plus loin
			if (vParamOut == null) {
				 logBipUser.exit(signatureMethode);
				 jdbc.closeJDBC(); 
				 return mapping.findForward("initial");
			}
			
			for (Enumeration e1 = vParamOut.elements(); e1.hasMoreElements();) {
				paramOut = (ParametreProc) e1.nextElement();
									
				if (paramOut.getNom().equals("message")) {
					if (paramOut.getValeur() != null)
						message = (String) paramOut.getValeur();
				}
				
				if (paramOut.getNom().equals("count")) {
					if (paramOut.getValeur() != null){
						count = (String) paramOut.getValeur();
					}
				}
				
				//Gestion des messages d'erreurs
				if (message != null && !message.equals("")) {
					// on récupère le message
					bipForm.setMsgErreur(message);
					((ChargerProfilForm) form).setMsgErreur(message);
					return mapping.findForward("initial");
				}
			}
			
		}catch (BaseException be) {
			logBipUser.debug(
					"RessourceAction-consulter() --> BaseException :" + be,
					be);
			logBipUser.debug("RessourceAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug(
					"RessourceAction-consulter() --> BaseException :" + be,
					be);
			logService.debug("RessourceAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			if (be.getInitialException().getClass().getName().equals("java.sql.SQLException")) {
				message = BipException.getMessageFocus(
				BipException.getMessageOracle(be.getInitialException().getMessage()), form);
				((ChargerProfilForm) form).setMsgErreur(message);
				jdbc.closeJDBC(); 
				return mapping.findForward("initial");
			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException().getMessage());
				jdbc.closeJDBC(); 
				return mapping.findForward("error");
			}
		}	

	
		  bipForm.setCount(count);
		  return mapping.findForward("list");
	
	}

	/**
	 * Action appelée lors du clic sur Charger de l'écran de liste des utililisateurs RTFE trouvés
	 * => redirection vers le formulaire initial
	 */
	public ActionForward suite1(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		String signatureMethode = "RessourceAction-suite1()";
		logBipUser.entry(signatureMethode);
		
		Vector vParamOut = new Vector();
		String message = "";
		ParametreProc paramOut;
		JdbcBip jdbc = new JdbcBip();
		
		
		logBipUser.debug("fmemory start : " + Runtime.getRuntime().freeMemory());
		// Création d'une nouvelle form
		ChargerProfilForm bipForm = (ChargerProfilForm) form;
		if (hParamProc == null) {
			logBipUser.debug("consultationRess-consulter-->hParamProc is null");
		}
		try{
			//Ensuite avec l'user_rtfe, on va chercher les informations RTFE de l'utilisateur
			vParamOut = jdbc.getResult(hParamProc,configProc, PACK_SELECT_RTFE);
			
			// pas besoin d'aller plus loin
			if (vParamOut == null) {
				 logBipUser.exit(signatureMethode);
				 jdbc.closeJDBC(); 
				 return mapping.findForward("initial");
			}
			
			// Récupération des résultats
			for (Enumeration e1 = vParamOut.elements(); e1.hasMoreElements();) {
				paramOut = (ParametreProc) e1.nextElement();
				
				if (paramOut.getNom().equals("message")) {
					if (paramOut.getValeur() != null)
						message = (String) paramOut.getValeur();
				}
				
				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();
				
					try {
						//On initialise les paramètres RTFE. On met par défaut le sous-menu admin.
						String menus="",sousMenus="admin",dpg_Defaut="",perim_ME="",chef_Projet="",clicode_Defaut="",
						perim_MO="",perim_MCLI="",liste_Centres_Frais="",ca_suivi="",
						projet="",appli="",CAFI="",CAPayeur="",CADA="",dossProj="",centre_frais="",filcode="";
						while (rset.next()) {
						//	Là on met dans l'user de la session les paramètres RTFE récupérés en base

						   
						   Vector vector = new Vector();
						   String sSQL;
							//Pour chaque ligne RTFE on rajoute les éléments à la suite, séparés par des virgules
							   if((rset.getString(6) != null)&&(rset.getString(6) != "")){ 
								   if("".equals(menus)){
									   menus+=(rset.getString(6).replace(';',','));
								   }else{
									   menus+=","+(rset.getString(6).replace(';',','));
								   }
							   }
								   
							   if((rset.getString(7) != null)&&(rset.getString(7) != "")){ 
								   if("".equals(sousMenus)){
									   sousMenus+=(rset.getString(7).replace(';',','));
								   }else{
									   sousMenus+=","+(rset.getString(7).replace(';',','));
								   }
							   }
							   //Le dpg_defaut est unique, on ne fait pas de concaténation
							   if((rset.getString(8) != null)&&(rset.getString(8) != "")){ 
									   dpg_Defaut=(rset.getString(8).replace(';',','));
							   }
								   
							   if((rset.getString(9) != null)&&(rset.getString(9) != "")&&(nonRedondance(rset.getString(9).replace(';',','),perim_ME)!="")){ 
								   if("".equals(perim_ME)){
									   perim_ME+=(nonRedondance(rset.getString(9).replace(';',','),perim_ME));
								   }else{
									   perim_ME+=","+(nonRedondance(rset.getString(9).replace(';',','),perim_ME));
								   }
							   }
							   
							   if((rset.getString(10) != null)&&(rset.getString(10) != "")&&(nonRedondance(rset.getString(10).replace(';',','),chef_Projet)!="")){ 
								   if("".equals(chef_Projet)){
									   chef_Projet+=(nonRedondance(rset.getString(10).replace(';',','),chef_Projet));
								   }else{
									   chef_Projet+=","+(nonRedondance(rset.getString(10).replace(';',','),chef_Projet));
								   }
								   //KRA PPM 61776
								  // if(chef_Projet.contains("*")){
									   chef_Projet = Tools.lireListeChefsProjet(chef_Projet);
								 //  }
								   //Fin KRA
							   }
							   // Le mo_defaut est unique, on ne fait pas de concaténation
							   // Le code 88888 est un code fictif, ne pas le prendre en compte
							   if((rset.getString(11) != null)&&(rset.getString(11) != "")&&(!"88888".equals(rset.getString(11)))){ 
									   clicode_Defaut=(rset.getString(11).replace(';',','));
							   }
							   
							   if((rset.getString(12) != null)&&(rset.getString(12) != "")&&(nonRedondance(rset.getString(12).replace(';',','),perim_MO)!="")){ 
								   if("".equals(perim_MO)){
									   perim_MO+=(nonRedondance(rset.getString(12).replace(';',','),perim_MO));
								   }else{
									   perim_MO+=","+(nonRedondance(rset.getString(12).replace(';',','),perim_MO));
								   }
							   }
							   
							   if((rset.getString(13) != null)&&(rset.getString(13) != "")&&(nonRedondance(rset.getString(13).replace(';',','),liste_Centres_Frais)!="")){ 
								   if("".equals(liste_Centres_Frais)){
									   liste_Centres_Frais+=(nonRedondance(rset.getString(13).replace(';',','),liste_Centres_Frais));
								   }else{
									   liste_Centres_Frais+=","+(nonRedondance(rset.getString(13).replace(';',','),liste_Centres_Frais));
								   }
							   }
							   
							   if((rset.getString(14) != null)&&(rset.getString(14) != "")&&(nonRedondance(rset.getString(14).replace(';',','),ca_suivi)!="")){ 
								   if("".equals(ca_suivi)){
									   ca_suivi+=(nonRedondance(rset.getString(14).replace(';',','),ca_suivi));
								   }else{
									   ca_suivi+=","+(nonRedondance(rset.getString(14).replace(';',','),ca_suivi));
								   }
							   }
							  
							   if((rset.getString(15) != null)&&(rset.getString(15) != "")&&(nonRedondance(rset.getString(15).replace(';',','),projet)!="")){ 
								   if("".equals(projet)){
									   projet+=(nonRedondance(rset.getString(15).replace(';',','),projet));
								   }else{
									   projet+=","+(nonRedondance(rset.getString(15).replace(';',','),projet));
								   }
							   }
								   
							   if((rset.getString(16) != null)&&(rset.getString(16) != "")&&(nonRedondance(rset.getString(16).replace(';',','),appli)!="")){ 
								   if("".equals(appli)){
									   appli+=(nonRedondance(rset.getString(16).replace(';',','),appli));
								   }else{
									   appli+=","+(nonRedondance(rset.getString(16).replace(';',','),appli));
								   }
							   }
							   
							   if((rset.getString(17) != null)&&(rset.getString(17) != "")&&(nonRedondance(rset.getString(17).replace(';',','),CAFI)!="")){ 
								   if("".equals(CAFI)){
									   CAFI+=(nonRedondance(rset.getString(17).replace(';',','),CAFI));
								   }else{
									   CAFI+=","+(nonRedondance(rset.getString(17).replace(';',','),CAFI));
								   }
							   }

							   if((rset.getString(18) != null)&&(rset.getString(18) != "")&&(nonRedondance(rset.getString(18).replace(';',','),CAPayeur)!="")){ 
								   if("".equals(CAPayeur)){
									   CAPayeur+=(nonRedondance(rset.getString(18).replace(';',','),CAPayeur));
								   }else{
									   CAPayeur+=","+(nonRedondance(rset.getString(18).replace(';',','),CAPayeur));
								   }
							   }
		   
							   if((rset.getString(19) != null)&&(rset.getString(19) != "")&&(nonRedondance(rset.getString(19).replace(';',','),dossProj)!="")){ 
								   if("".equals(dossProj)){
									   dossProj+=(nonRedondance(rset.getString(19).replace(';',','),dossProj));
								   }else{
									   dossProj+=","+(nonRedondance(rset.getString(19).replace(';',','),dossProj));
								   }
							   }
							   
							   if((rset.getString(20) != null)&&(rset.getString(20) != "")&&(nonRedondance(rset.getString(20).replace(';',','),CADA)!="")){ 
								   if("".equals(CADA)){
									   CADA+=(nonRedondance(rset.getString(20).replace(';',','),CADA));
								   }else{
									   CADA+=","+(nonRedondance(rset.getString(20).replace(';',','),CADA));
								   }
							   }
							   
							   if((rset.getString(22) != null)&&(rset.getString(22) != "")&&(nonRedondance(rset.getString(22).replace(';',','),perim_MCLI)!="")){ 
								   if("".equals(perim_MCLI)){
									   perim_MCLI+=(nonRedondance(rset.getString(22).replace(';',','),perim_MCLI));
								   }else{
									   perim_MCLI+=","+(nonRedondance(rset.getString(22).replace(';',','),perim_MCLI));
								   }
							   }
  
							   if((rset.getString(13) != null)&&(rset.getString(13) != ""))
								{
								
							         //On actualise le nouveau centre de frais et le code filliale
								     vector = convertirchainetovector(rset.getString(13).replace(';',','));
								     //actualiser le centre de frais
								     if ((vector != null)&&(!vector.isEmpty()))
								     {
								           centre_frais=((String)vector.get(0));
								   
									       sSQL = cfgSQL.getString(sProcFiliale);
									       sSQL += "'"+ (String)vector.get(0) +"'";
									       try
									       {
									          filcode = jdbc.recupererInfo(sSQL);
									       }
									       catch (BaseException bE)
										  {
									           logService.error("InfoMenu.getInfoFiliale : Erreur dans la récuperation de la filiale " + sSQL, bE);
									      }	
							         }		
							      }
								
						}
						HttpSession session = request.getSession();
						com.socgen.bip.user.UserBip user = (com.socgen.bip.user.UserBip)session.getAttribute("UserBip") ;
						//Dans la session on utilise uniquement le DPG (7  caractères) alors que dans la base on a le BDDPG entier (11 caractères)
						//On limite donc le BDDPG au 7 derniers caractères
						if (dpg_Defaut.length()>7){
							dpg_Defaut = dpg_Defaut.substring(dpg_Defaut.length()-7);
						}
						//On ajoute aux paramètres RTFE le menu DIR s'il n'était pas déjà présent.
						boolean dirFound = false;
						if(!"".equals(menus)){
							for(int i=0;i<menus.split(",").length;i++){
								if("dir".equals(menus.split(",")[i])){
									dirFound = true;
								}
							}
							if(!dirFound){
								menus+=",dir";
							}
						}else{
							menus = "dir";
						}
						//Puis on met les champs concaténés dans l'userBip qu'on remet ensuite en session
						user.setListeMenus(menus);
						user.setSousMenus(sousMenus);
						user.setDpg_Defaut(dpg_Defaut);
						user.setPerim_ME(convertirchainetovector(perim_ME));
						user.setChef_Projet(convertirchainetovector(chef_Projet));
						user.setClicode_Defaut(clicode_Defaut);
						user.setPerim_MO(convertirchainetovector(perim_MO));
						user.setPerim_MCLI(convertirchainetovector(perim_MCLI));
						user.setListe_Centres_Frais(liste_Centres_Frais);
						user.setCa_suivi(convertirchainetovector(ca_suivi));
						user.setProjet(projet);
						user.setAppli(appli);
						user.setCAFI(CAFI);
						user.setCAPayeur(CAPayeur);
						user.setDossProj(dossProj);
						user.setCADA(convertirchainetovector(CADA));
						user.setCentre_Frais(centre_frais);
						user.setFilCode(filcode);
						
						session.setAttribute("UserBip",user); 
						if (rset != null)
						{
							rset.close();
							rset = null;
						}	
						
					} // try
					catch (SQLException sqle) {
						logService
								.debug("RessourceForm-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("RessourceForm-consulter() --> SQLException :"
										+ sqle);
						// Erreur de lecture du resultSet
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11217"));
						 jdbc.closeJDBC(); return mapping.findForward("error");
					}
				} // if
			}
		} // try
		catch (BaseException be) {
			logBipUser.debug(
					"RessourceAction-consulter() --> BaseException :" + be,
					be);
			logBipUser.debug("RessourceAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug(
					"RessourceAction-consulter() --> BaseException :" + be,
					be);
			logService.debug("RessourceAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			if (be.getInitialException().getClass().getName().equals("java.sql.SQLException")) {
				message = BipException.getMessageFocus(
				BipException.getMessageOracle(be.getInitialException().getMessage()), form);
				((ChargerProfilForm) form).setMsgErreur(message);
				jdbc.closeJDBC(); 
				return mapping.findForward("initial");
			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException().getMessage());
				jdbc.closeJDBC(); 
				return mapping.findForward("error");
			}
		}

		logBipUser
				.debug("fmemory end   : " + Runtime.getRuntime().freeMemory());
		logBipUser.exit(signatureMethode);
		jdbc.closeJDBC(); 
		
		//Gestion des messages d'erreurs
		if (message != null && !message.equals("")) {
			// on récupère le message
			bipForm.setMsgErreur(message);
			((ChargerProfilForm) form).setMsgErreur(message);
			return mapping.findForward("initial");
		}
		return mapping.findForward("initial");
		
	  }

	
    //On met à jour le vecteur contenant les périmètres ME
	  private Vector convertirchainetovector(String chaine)
	  {
   
			StringTokenizer strtk = new StringTokenizer(chaine, ",");
			Vector vector = new Vector();
			
			while (strtk.hasMoreTokens()){
				String lePerim = strtk.nextToken();
				vector.addElement(lePerim);
							
			 }
			 
			return vector; 
	  }

	  
	  /**
	   * Cette fonction va séparer les éléments de ajouts et regarder s'ils existent déjà dans existant
	   * S'ils n'y sont pas ils sont ajoutés à la liste de sortie
	   * Sinon ils n'y sont pas ajoutés
	 * @param ajouts les éléments à rajouter, séparés par des virgules
	 * @param existant les éléments déjà dans la liste
	 * @return la liste des éléments à effectivement ajouter, vide si tous les éléments existent déjà dans l'existant
	 */
	public static String nonRedondance(String ajouts,String existant){
		  String[]listeAjouts = ajouts.split(",");
		  String listeRetour="";
		  for(String ajout:listeAjouts){
			  if(!existant.contains(ajout)){
				  if("".equals(listeRetour)){
					  listeRetour = ajout;
				  }else{
					  listeRetour += ","+ajout;
				  }
			  }
		  }
		  return listeRetour;
	  }

}