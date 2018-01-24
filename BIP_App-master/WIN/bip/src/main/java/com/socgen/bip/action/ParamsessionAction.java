package com.socgen.bip.action;

import java.util.Enumeration;
import java.util.Hashtable;
import java.util.StringTokenizer;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.BipConfigRTFE;
import com.socgen.bip.commun.Tools;
import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.form.ParamsessionForm;
import com.socgen.bip.metier.ParametreBip;
import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.config.ConfigManager;
import com.socgen.cap.fwk.exception.BaseException;


/**
 * @author BAA le 14/10/2005
 *
 * Action permet la modification des parametres session
 * chemin : 
 * pages  : mParamsess.jsp
 * 
 */


public class ParamsessionAction extends AutomateAction {
	

	static Config configProc = ConfigManager.getInstance("bip_reports_proc") ;
	static Config cfgSQL = ConfigManager.getInstance("sql");
	private static String sProcFiliale = "SQL.filiale";

	
	/**
	   * Action qui permet de créer un code DPG
	   */
	   protected ActionForward initialiser(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors,Hashtable hParamProc  ) throws ServletException
	   {
		
		
		HttpSession session = request.getSession();
		
		com.socgen.bip.user.UserBip user = (com.socgen.bip.user.UserBip)session.getAttribute("UserBip") ;
		
        //Création d'une nouvelle form
		ParamsessionForm bipForm= (ParamsessionForm)form ;
		
		
		if(user.getsListeMenu() != null)
		    bipForm.setListeMenus(user.getsListeMenu());
		else
		    bipForm.setListeMenus("");    
		    		    
		    
		if(user.getSousMenus() != null)   
			bipForm.setSousMenus(user.getSousMenus());
		else
		    bipForm.setSousMenus(""); 	
			
			
		if(user.getDpg_Defaut() != null)
			bipForm.setDpg_Defaut(user.getDpg_Defaut());
		else
		    bipForm.setDpg_Defaut("");	
			
			
		if(user.getPerim_ME() != null)
			bipForm.setPerim_ME(convertirvectortochaine(user.getPerim_ME()));
	    else
		    bipForm.setPerim_ME("");		
			
				
		if(user.getChefProjet() != null){
			bipForm.setChef_Projet(convertirvectortochaine(user.getChefProjet()));//KRA PPM 61776
		}
		else
		    bipForm.setChef_Projet("");	
				
				
		if(user.getClicode_Defaut() != null)
			bipForm.setClicode_Defaut(user.getClicode_Defaut());
	    else		
		    bipForm.setClicode_Defaut("");
		    
			
		if(user.getPerim_MO() != null)
			bipForm.setPerim_MO(convertirvectortochaine(user.getPerim_MO()));
		else
		    bipForm.setPerim_MO("");
		
		if(user.getPerim_MCLI() != null)
			bipForm.setPerim_MCLI(convertirvectortochaine(user.getPerim_MCLI()));
		else
		    bipForm.setPerim_MCLI("");
		
		if(user.getCADA() != null)
			bipForm.setCADA(convertirvectortochaine(user.getCADA()));
		else
		    bipForm.setCADA("");
					
		if(user.getListe_Centres_Frais() != null)
			bipForm.setListe_Centres_Frais(user.getListe_Centres_Frais());
		else
		    bipForm.setListe_Centres_Frais("");	
			
					
		if(user.getCa_suivi() != null)
			bipForm.setCa_suivi(convertirvectortochaine(user.getCa_suivi()));
		else
		    bipForm.setCa_suivi("");	
			
			
		if(user.getProjet() != null)
			bipForm.setProjet(user.getProjet());
		else
		    bipForm.setProjet("");	
		
		
		if(user.getAppli() != null)
			bipForm.setAppli(user.getAppli());
		else
		    bipForm.setAppli("");	
		
		
		if(user.getCAFI() != null)
			bipForm.setCAFI(user.getCAFI());
		else
		    bipForm.setCAFI("");	
			
					
		if(user.getCAPayeur() != null)
			bipForm.setCAPayeur(user.getCAPayeur());
		else
		    bipForm.setCAPayeur("");	
					
		if(user.getDossProj()!=null)
			bipForm.setDossProj(user.getDossProj());
		else
		    bipForm.setDossProj(""); 	
		
		
			
		
	
	     return mapping.findForward("ecran");	
	   }//initialiser


     
	protected ActionForward consulter(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors,Hashtable hParamProc  ) throws ServletException
		  {
		
		   JdbcBip jdbc = new JdbcBip(); 
		   HttpSession session = request.getSession();
		   Vector vector = new Vector();
		   String filcode=null;
		   String sSQL;
	   
		   
		   com.socgen.bip.user.UserBip user = (com.socgen.bip.user.UserBip)session.getAttribute("UserBip") ;
		   
		   //ABN - HP PPM 61422
		   //Demande Antoine - PPM 64631
		   //logBipUser.error("Chargement config RTFE dans ParamSession de l'utilisateur : " + user.getIdUser());
		   //BipConfigRTFE.getInstance().rechargerConfigRTFE();
		
		   //Création d'une nouvelle form
		   ParamsessionForm bipForm= (ParamsessionForm)form ;
		   
		   //Si les informations entrées ne correspondent pas au paramétrage du RTFE défini dans les paramètres BIP
		   //On renvoie la page sans toucher à l'objet en session avec un message d'erreur RTFE.
		   if(!verifRTFE(bipForm,user)){
			   session.setAttribute("UserBip",user); 
			   return mapping.findForward("ecran");
		   }
		
		   if(bipForm.getListeMenus() != null) 
			   user.setListeMenus(bipForm.getListeMenus().replace(';',','));
		   else	   
		       user.setListeMenus("");
			   
			   
		   if(bipForm.getSousMenus() != null)	   
			   user.setSousMenus(bipForm.getSousMenus().replace(';',','));
		   else
		       user.setSousMenus("");
			   
			   
		   if(bipForm.getDpg_Defaut() != null)	   
			   user.setDpg_Default(bipForm.getDpg_Defaut());
		   else	   
		       user.setDpg_Default("");
			   
			   
		   if((bipForm.getPerim_ME() != null)&&(bipForm.getPerim_ME() != ""))	   
			   user.setPerim_ME(convertirchainetovector(bipForm.getPerim_ME().replace(';',',')));
		   else 
		       user.setPerim_ME(new Vector());	   
			   
			//ABN - P6IN-0411723  
		   if((bipForm.getChef_Projet() != null)&&(!bipForm.getChef_Projet().equals("")))	{
			   //if(bipForm.getChef_Projet().contains("*") ){ //KRA PPM 61776
				   user.setChef_Projet(convertirchainetovector(Tools.lireListeChefsProjet(bipForm.getChef_Projet().replace(';',','))));//KRA PPM 61776
				
			  // }else{				   
					   
				  // user.setChef_Projet(convertirchainetovector(bipForm.getChef_Projet().replace(';',',')));
				 //  }
		  }
		   else   
		       user.setChef_Projet(new Vector());			   
			   
			   			   
		   if(bipForm.getClicode_Defaut() != null)	
			   user.setClicode_Defaut(bipForm.getClicode_Defaut());
		   else
		       user.setClicode_Defaut("");
		     	  
		     	   
		   if((bipForm.getPerim_MO() != null)&&(bipForm.getPerim_MO() != ""))	
			   user.setPerim_MO(convertirchainetovector(bipForm.getPerim_MO().replace(';',',')));
		   else
		       user.setPerim_MO(new Vector());  
		   
		   if((bipForm.getPerim_MCLI() != null)&&(bipForm.getPerim_MCLI() != ""))	
			   user.setPerim_MCLI(convertirchainetovector(bipForm.getPerim_MCLI().replace(';',',')));
		   else
		       user.setPerim_MCLI(new Vector());  			   
			   
		   if(bipForm.getListe_Centres_Frais() != null) 	   
			   user.setListe_Centres_Frais(bipForm.getListe_Centres_Frais().replace(';',','));
		   else
		       user.setListe_Centres_Frais(""); 	   
			   
			   
		   if((bipForm.getCa_suivi() != null)&&(bipForm.getCa_suivi() != ""))	   
			   user.setCa_suivi(convertirchainetovector(bipForm.getCa_suivi().replace(';',',')));
		   else
		       user.setCa_suivi(new Vector());
		   
		   
		   if(bipForm.getProjet() != null)	   
			   user.setProjet(bipForm.getProjet().replace(';',','));
		   else
		       user.setProjet("");  	   
			   
			   
		   if(bipForm.getAppli() != null)	   
			   user.setAppli(bipForm.getAppli().replace(';',','));
		   else
		       user.setAppli("");
			   
			   
		   if(bipForm.getCAFI() != null)	   
			   user.setCAFI(bipForm.getCAFI().replace(';',','));
		   else
		       user.setCAFI("");
		   	   
		   	   
		   if(bipForm.getCAPayeur() != null)	 
			   user.setCAPayeur(bipForm.getCAPayeur().replace(';',','));
		   else
		       user.setCAPayeur("");	   
		   
		   
		   if((bipForm.getCADA() != null)&&(bipForm.getCADA() != ""))	
			   user.setCADA(convertirchainetovector(bipForm.getCADA().replace(';',',')));
		   else
		       user.setCADA(new Vector());   
			
		   if(bipForm.getDossProj() != null) 	   
			   user.setDossProj(bipForm.getDossProj().replace(';',','));
		   else	   
		       user.setDossProj("");
		       
		       
			if((bipForm.getListe_Centres_Frais() != null)&&(bipForm.getListe_Centres_Frais() != ""))
			{
			
		         //On actualise le nouveau centre de frais et le code filliale
			     vector = convertirchainetovector(bipForm.getListe_Centres_Frais().replace(';',','));
			     //actualiser le centre de frais
			     if ((vector != null)&&(!vector.isEmpty()))
			     {
			           user.setCentre_Frais((String)vector.get(0));
			   
				       sSQL = cfgSQL.getString(sProcFiliale);
				       sSQL += "'"+ (String)vector.get(0) +"'";
				       try
				       {
				          filcode = jdbc.recupererInfo(sSQL);
				       }
				       catch (BaseException bE)
					  {
				           logService.error("InfoMenu.getInfoFiliale : Erreur dans la récuperationde la filiale " + sSQL, bE);
				      }	
			   	   user.setFilCode(filcode);
		         }		
		         else
				 {
					 user.setCentre_Frais("");
					 user.setFilCode("");
				 }
		      }
		      else
		      {
				  user.setCentre_Frais("");
				  user.setFilCode("");
		      }
		
			
			session.setAttribute("UserBip",user); 
	
		   jdbc.closeJDBC(); return mapping.findForward("ecran");	
		  }//consulter
  
      public boolean verifRTFE(ParamsessionForm form, com.socgen.bip.user.UserBip user){
  		try{
  			BipConfigRTFE configRTFE = BipConfigRTFE.getInstance();
			//Si on est pas dans les dates d'effet de RTFE/MENUS, on ne fait aucun test
			if(!configRTFE.isActifVerifRtfe())
				return true;
  			//On vérifie que le champ des menus est bien formé et contient des valeurs conformes
  			if(BipConfigRTFE.CASSE_C.equals(configRTFE.getConfigMenus().getCasse()))
  				form.setListeMenus(form.getListeMenus().toUpperCase());
  			if(!configRTFE.checkChamp(form.getListeMenus(), configRTFE.getConfigMenus())){
  				form.setErreurRTFE("Votre habilitation RTFE aux menus Bip est incorrecte");
  				user.setErreurRTFE("Votre habilitation RTFE aux menus Bip est incorrecte");
  				return false;
  			}
  			//Pour chaque menu que l'utilisateur possède, 
  			//On cherche le paramètre BIP correspondant : RTFE-<menu>/SMENUS
  			//Et on prend les sous-menus qu'il autorise
  			//On en fait une liste des sous-menus autorisés
  			String sousMenusAutorises="";
  			String sousMenusAutorisesParMenu = "";
  			int nbrSMenusParMenu = 0;
  			
  			if(BipConfigRTFE.CASSE_C.equals(configRTFE.getConfigMenus().getCasse()))
  				form.setSousMenus(form.getSousMenus().toUpperCase());
  			// ABN - HP PPM 61422 - DEBUT
  			for(String menu:form.getListeMenus().split("["+configRTFE.getConfigMenus().getSeparateur()+"]")){
  				ParametreBip paramSousMenu = configRTFE.getListeConfigSousMenus().get(BipConfigRTFE.CODACTION_RTFE+"-"+menu.toUpperCase());
  				if(paramSousMenu!=null && paramSousMenu.getValeur()!=null && !"".equals(paramSousMenu.getValeur())){
  					sousMenusAutorisesParMenu = paramSousMenu.getValeur().toUpperCase();;
  					if("".equals(sousMenusAutorises)){
						sousMenusAutorises += paramSousMenu.getValeur().toUpperCase();
						
  					}else{
						sousMenusAutorises += configRTFE.getConfigMenus().getSeparateur()+paramSousMenu.getValeur().toUpperCase();
  					}
  				}
  				nbrSMenusParMenu = 0;
  				if (form.getSousMenus() != null && !"".equals(form.getSousMenus())) {
  		  			for(String sousMenu:form.getSousMenus().split("["+configRTFE.getConfigMenus().getSeparateur()+"]")){
  		  				if(!"".equals(sousMenu) && BipConfigRTFE.contient(
  		  						sousMenu, sousMenusAutorisesParMenu, configRTFE.getConfigMenus().getSeparateur())){
  		  					nbrSMenusParMenu ++;
  		  				}
  		  			}
  		  			if (nbrSMenusParMenu == 0 && !sousMenusAutorisesParMenu.toUpperCase().contains("VIDE")) {
  		  				form.setErreurRTFE("Votre habilitation RTFE au menu Bip " + menu.toUpperCase() + " ne comporte aucun sous menu");
  		  				user.setErreurRTFE("Votre habilitation RTFE au menu Bip " + menu.toUpperCase() + " ne comporte aucun sous menu");
  		  				return false;
  		  			}
  				} else if (!sousMenusAutorisesParMenu.toUpperCase().contains("VIDE")) {
  	  				form.setErreurRTFE("Votre habilitation RTFE au menu Bip ne comporte aucun sous menu");
  	  				user.setErreurRTFE("Votre habilitation RTFE au menu Bip ne comporte aucun sous menu");
  					return false;
  				}
  			}
  			
  			//Pour chaque sous-menu de l'utilisateur, on vérifie s'il est bien présent
  			//dans la liste de sous-menus que l'on vient de créer
  			if (form.getSousMenus() != null && !"".equals(form.getSousMenus())) {
  			// ABN - HP PPM 61422 - FIN
	  			for(String sousMenu:form.getSousMenus().split("["+configRTFE.getConfigMenus().getSeparateur()+"]")){
	  				if(!"".equals(sousMenu) && !BipConfigRTFE.contient(sousMenu, sousMenusAutorises, configRTFE.getConfigMenus().getSeparateur())){
	  					form.setErreurRTFE("Votre habilitation RTFE aux sous-menus Bip est incorrecte");
	  					user.setErreurRTFE("Votre habilitation RTFE aux sous-menus Bip est incorrecte");
	  					return false;
	  				}
	  			}
  			}
  			
  			String champDejaControleSpecifique="";
  			String champDejaControleDefaut="";
  			//Pour chaque menu de l'utilisateur, on va chercher le paramètre RTFE-<menu>/SMENUS
  			for(String menu:form.getListeMenus().split("["+configRTFE.getConfigMenus().getSeparateur()+"]")){
  				ParametreBip paramSousMenu = configRTFE.getListeConfigSousMenus().get(BipConfigRTFE.CODACTION_RTFE+"-"+menu.toUpperCase());
  				if(paramSousMenu!=null){
  					//Dans ce paramètre, on va regarder s'il y a un paramètre lié, qui logiquement est dela forme RTFE-<menu>/CHAMPS
  					if(paramSousMenu.getParametreLie()!=null && paramSousMenu.getParametreLie().getValeur()!=null){
  						//Si ce paramètre lié existe, on va, pour chaque élément que contient sa valeur chercher le paramètre bip RTFE-<champ>/<menu>
  						//On fait d'abord le tour pour les paramètres spécifiques à un menu, qui sont prioritaires
  						//Seulement après, on regarde pour les paramètres par défaut si les champs n'ont pas déjà été contrôlé avec un paramètre spécifique
  						for(String champ:paramSousMenu.getParametreLie().getValeur().split("["+paramSousMenu.getParametreLie().getSeparateur()+"]")){
  							ParametreBip paramChamp  = configRTFE.getListeConfigChamps().get(BipConfigRTFE.CODACTION_RTFE+"-"+champ.toUpperCase()+"/"+menu.toUpperCase());
  							//S'il existe, on teste le champ équivalent avec ce paramètre
  							//Et on rajoute ce champ à la liste des champs déjà contrôlés par un paramètre spécifique, pour plus tard
  							if(paramChamp!=null){
  								champDejaControleSpecifique += (("".equals(champDejaControleSpecifique))?"":",")+champ.toUpperCase();
  								if(!chercheChamp(form,configRTFE,paramChamp)){
  									form.setErreurRTFE("Votre habilitation RTFE au menu Bip comporte des valeurs applicatives incorrectes (Champ "+champ+")");
  									user.setErreurRTFE("Votre habilitation RTFE au menu Bip comporte des valeurs applicatives incorrectes (Champ "+champ+")");
  									return false;
  								}
  							}
						}
  					}
  				}
  			}
  			//On refait la même chose, mais pour les périmètres par défaut des champs cette fois
  			for(String menu:form.getListeMenus().split("["+configRTFE.getConfigMenus().getSeparateur()+"]")){
  				ParametreBip paramSousMenu = configRTFE.getListeConfigSousMenus().get(BipConfigRTFE.CODACTION_RTFE+"-"+menu.toUpperCase());
  				if(paramSousMenu!=null){
  					//Dans ce paramètre, on va regarder s'il y a un paramètre lié, qui logiquement est dela forme RTFE-<menu>/CHAMPS
  					if(paramSousMenu.getParametreLie()!=null && paramSousMenu.getParametreLie().getValeur()!=null){
//  			  		On cherche le paramètre bip RTFE-<champ>/DEFAUT cette fois
  						for(String champ:paramSousMenu.getParametreLie().getValeur().split("["+paramSousMenu.getParametreLie().getSeparateur()+"]")){
  								ParametreBip paramChamp  = configRTFE.getListeConfigChamps().get(BipConfigRTFE.CODACTION_RTFE+"-"+champ.toUpperCase()+"/"+BipConfigRTFE.CODVERSION_DEFAUT);
  								//Si un champ a déjà été testé par un paramètre spécifique à un menu. On ne le reteste pas avec un paramètre par défaut
  								//Les règles du paramètre spécifique prévalent
  								//Une fois qu'un champ a été testé par son paramètre par défaut, si on retrouve ce champ venant d'un autre menu, on ne le reteste pas
  								if(paramChamp!=null && !BipConfigRTFE.contient(champ,champDejaControleSpecifique,",") && !BipConfigRTFE.contient(champ,champDejaControleDefaut,",")){
  									champDejaControleDefaut += (("".equals(champDejaControleDefaut))?"":",")+champ.toUpperCase();
  									if(!chercheChamp(form,configRTFE,paramChamp)){
  										form.setErreurRTFE("Votre habilitation RTFE au menu Bip comporte des valeurs applicatives incorrectes (Champ "+champ+")");
  										user.setErreurRTFE("Votre habilitation RTFE au menu Bip comporte des valeurs applicatives incorrectes (Champ "+champ+")");
  										return false;
  									}
  								}
  						}
  					}
  				}
  			}

  			form.setErreurRTFE("");
  			user.setErreurRTFE("");
  			return true;
  		}catch(Exception e){
  			logBipUser.debug("ParamSessionAction.verifRTFE() - Exception à la vérification du profil RTFE saisie dans Paramètres Session");
  			logBipUser.debug(e.toString());
  			form.setErreurRTFE("");
  			user.setErreurRTFE("");
  			return true;
  		}
  	}

    // En fonction du nom du paramètre Bip, on localise, dans l'UserBip, le champ à tester.
  	//Les valeurs sont testées en dur car il n'y a pas d'équivalence directe entre ces valeurs 
  	//et le nom des variables utilisées
    //Avant de tester le champ, si la configuration de la casse est à C, on doit mettre en upperCase avant de tester
  private boolean chercheChamp(ParamsessionForm form, BipConfigRTFE configRTFE, ParametreBip paramChamp) {
  		String champ = paramChamp.getCode_action().substring(5);
  		if(BipConfigRTFE.CHAMP_BDDPG_DEFAUT.equals(champ)){
  			if(BipConfigRTFE.CASSE_C.equals(paramChamp.getCasse()))
  				form.setDpg_Defaut(form.getDpg_Defaut().toUpperCase());
  			if(!configRTFE.checkChamp(form.getDpg_Defaut(),paramChamp))
  				return false;
  		}else
  		if(BipConfigRTFE.CHAMP_PERIM_ME.equals(champ)){
  			if(BipConfigRTFE.CASSE_C.equals(paramChamp.getCasse()))
  				form.setPerim_ME(form.getPerim_ME().toUpperCase());
  			if(!configRTFE.checkChamp(form.getPerim_ME(),paramChamp))
  				return false;
  		}else
  		if(BipConfigRTFE.CHAMP_CHEF_PROJET.equals(champ)){
  			if(BipConfigRTFE.CASSE_C.equals(paramChamp.getCasse()))
  				form.setChef_Projet(form.getChef_Projet().toUpperCase());
  			if(!configRTFE.checkChamp(form.getChef_Projet(),paramChamp))
  				return false;
  		}else
  		if(BipConfigRTFE.CHAMP_MO_DEFAUT.equals(champ)){
  			if(BipConfigRTFE.CASSE_C.equals(paramChamp.getCasse()))
  				form.setClicode_Defaut(form.getClicode_Defaut().toUpperCase());
  			if(!configRTFE.checkChamp(form.getClicode_Defaut(),paramChamp))
  				return false;
  		}else
  		if(BipConfigRTFE.CHAMP_PERIM_MO.equals(champ)){
  			if(BipConfigRTFE.CASSE_C.equals(paramChamp.getCasse()))
  				form.setPerim_MO(form.getPerim_MO().toUpperCase());
  			if(!configRTFE.checkChamp(form.getPerim_MO(),paramChamp))
  				return false;
  		}else
  	  		if(BipConfigRTFE.CHAMP_PERIM_MCLI.equals(champ)){
  	  			if(BipConfigRTFE.CASSE_C.equals(paramChamp.getCasse()))
  	  				form.setPerim_MCLI(form.getPerim_MCLI().toUpperCase());
  	  			if(!configRTFE.checkChamp(form.getPerim_MCLI(),paramChamp))
  	  				return false;
  	  	}else
  	  	if(BipConfigRTFE.CHAMP_CENTRE_FRAIS.equals(champ)){
  			if(BipConfigRTFE.CASSE_C.equals(paramChamp.getCasse()))
  				form.setListe_Centres_Frais(form.getListe_Centres_Frais().toUpperCase());
  			if(!configRTFE.checkChamp(form.getListe_Centres_Frais(),paramChamp))
  				return false;
  		}else
  		if(BipConfigRTFE.CHAMP_CA_SUIVI.equals(champ)){
  			if(BipConfigRTFE.CASSE_C.equals(paramChamp.getCasse()))
  				form.setCa_suivi(form.getCa_suivi().toUpperCase());
  			if(!configRTFE.checkChamp(form.getCa_suivi(),paramChamp))
  				return false;
  		}else
  		if(BipConfigRTFE.CHAMP_DOSS_PROJ.equals(champ)){
  			if(BipConfigRTFE.CASSE_C.equals(paramChamp.getCasse()))
  				form.setDossProj(form.getDossProj().toUpperCase());
  			if(!configRTFE.checkChamp(form.getDossProj(),paramChamp))
  				return false;
  		}else
  		if(BipConfigRTFE.CHAMP_PROJET.equals(champ)){
  			if(BipConfigRTFE.CASSE_C.equals(paramChamp.getCasse()))
  				form.setProjet(form.getProjet().toUpperCase());
  			if(!configRTFE.checkChamp(form.getProjet(),paramChamp))
  				return false;
  		}else
  		if(BipConfigRTFE.CHAMP_APPLI.equals(champ)){
  			if(BipConfigRTFE.CASSE_C.equals(paramChamp.getCasse()))
  				form.setAppli(form.getAppli().toUpperCase());
  			if(!configRTFE.checkChamp(form.getAppli(),paramChamp))
  				return false;
  		}else
  		if(BipConfigRTFE.CHAMP_CA_FI.equals(champ)){
  			if(BipConfigRTFE.CASSE_C.equals(paramChamp.getCasse()))
  				form.setCAFI(form.getCAFI().toUpperCase());
  			if(!configRTFE.checkChamp(form.getCAFI(),paramChamp))
  				return false;
  		}else
  		if(BipConfigRTFE.CHAMP_CA_PAYEUR.equals(champ)){
  			if(BipConfigRTFE.CASSE_C.equals(paramChamp.getCasse()))
  				form.setCAPayeur(form.getCAPayeur().toUpperCase());
  			if(!configRTFE.checkChamp(form.getCAPayeur(),paramChamp))
  				return false;
  		}else
  		if(BipConfigRTFE.CHAMP_CA_DA.equals(champ)){
  			if(BipConfigRTFE.CASSE_C.equals(paramChamp.getCasse()))
  				form.setCADA(form.getCADA().toUpperCase());
  			if(!configRTFE.checkChamp(form.getCADA(),paramChamp))
  				return false;
  		}
  		return true;
  	}
  
	//On met à jour le vecteur contenant les périmètres ME
      private String convertirvectortochaine(Vector vector)
      {
            String chaine = "";    
            int i=0;
     
	    	for (Enumeration e=vector.elements(); e.hasMoreElements();) 
	    	 {
	    	 	if(i==0)
					 chaine = (String) e.nextElement() ;
				else
				     chaine = chaine + "," + (String) e.nextElement() ;	
				     
				i++;     		  
	    	}
	    	
	    	 return chaine;
						 
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
  

}