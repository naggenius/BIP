/*
 * Créé le 13 déc. 04
 *
 */
package com.socgen.bip.menu.info;

import javax.servlet.http.HttpSession;

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.BipSession;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.user.UserBip;
import com.socgen.cap.fwk.ServiceManager;
import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.config.ConfigManager;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.cap.fwk.log.Log;
/**
 *
 * @author x039435
 */
public class InfoMenu implements BipConstantes
{
	private static Log logService = ServiceManager.getInstance().getLogManager().getLogService();
	static Config cfgSQL = ConfigManager.getInstance("sql");
	private static String sProcFiliale = "SQL.menus.filiale";
	private static String sProcDirection = "SQL.menus.client";
	private static String sProcDPG = "SQL.menus.dpg";
	
	protected HttpSession session;
	
	
	
	public InfoMenu(HttpSession session)
	{
		this.session = session;
	}
	
	public static String getInfoFiliale(BipSession bipSession) throws Exception
	{
		HttpSession session = bipSession.getSession();
		String sFiliale = null;
		String sSQL;
		
		JdbcBip jdbc = new JdbcBip(); 
		
		sSQL = cfgSQL.getString(sProcFiliale);
		UserBip uBip = (UserBip)session.getAttribute("UserBip");
		sSQL += "'"+ uBip.getFilCode() +"'";
		try
		{
			sFiliale = jdbc.recupererInfo(sSQL);
		}
		catch (BaseException bE)
		{
			logService.error("InfoMenu.getInfoFiliale : Erreur dans la récuperationde la filiale " + sSQL, bE);
			jdbc.closeJDBC();
			throw bE;
		}

		session.setAttribute(LIB_FILIALE, sFiliale);
		
		jdbc.closeJDBC();
		return "Filiale : " + sFiliale;
	}
	
	public static String getInfoCentreFrais(BipSession bipSession) throws Exception
	{
		HttpSession session = bipSession.getSession();
		UserBip uBip = (UserBip)session.getAttribute("UserBip");
		return "Centre Frais : " + uBip.getCentre_Frais();
	}
	
	public static String getInfoDirection(BipSession bipSession) throws Exception
	{
		HttpSession session = bipSession.getSession();
		String sCodeClientMO;
		String sLibCodeClientMO;
		String sSQL;
		UserBip uBip;
		
		JdbcBip jdbc = new JdbcBip(); 
		
		sSQL = cfgSQL.getString(sProcDirection);
		uBip = (UserBip)session.getAttribute("UserBip");
		sCodeClientMO = uBip.getClicode_Defaut();
		sSQL += "'"+ sCodeClientMO +"'";
		try
		{
			sLibCodeClientMO = jdbc.recupererInfo(sSQL);
		}
		catch (BaseException bE)
		{
			logService.error("InfoMenu.getInfoDirection : Erreur dans la récuperation du libelle du client MO " + sSQL, bE);
			jdbc.closeJDBC();
			throw bE;
		}

		session.setAttribute(LIB_INFO, sLibCodeClientMO);
		
		jdbc.closeJDBC();
		return sLibCodeClientMO;
	}
	
	public static String getInfoDPG(BipSession bipSession) throws Exception
	{
		HttpSession session = bipSession.getSession();
		String sDPGActif;
		String sLibDPGActif;
		String sSQL;
		UserBip uBip;

		JdbcBip jdbc = new JdbcBip(); 
		
		sSQL = cfgSQL.getString(sProcDPG);
		uBip = (UserBip)session.getAttribute("UserBip");
		sDPGActif = uBip.getDpg_Defaut();
		sSQL += sDPGActif;
		try
		{
			sLibDPGActif = jdbc.recupererInfo(sSQL);
		}
		catch (BaseException bE)
		{
			logService.error("InfoMenu.getInfoDPG : Erreur dans la récuperation du libelle du DPG " + sDPGActif, bE);
			jdbc.closeJDBC();
			throw bE;
		}

		session.setAttribute(LIB_INFO, sLibDPGActif);
		
		jdbc.closeJDBC();

		return sLibDPGActif;
	}	
	
	public static String getInfoSousMenu(BipSession bipSession) throws Exception
	{
		HttpSession session = bipSession.getSession();
		String sLibSousMenu = null;
		
		UserBip uBip = (UserBip)session.getAttribute("UserBip");
		String sSousMenus = uBip.getSousMenus();
		String sMenuCourant = uBip.getCurrentMenu().getId();

		
		// Renvoie un libellé court en fonction du sous menu trouvé pour l'utilisateur
		// et en fonction du menu courant
		if (sMenuCourant.equals("ME")) 
		{
			if (sSousMenus.indexOf("ges") != -1)
			{
				sLibSousMenu = "Gestionnaire" ;
			}
			if (sSousMenus.indexOf("pcm") != -1)
			{
				sLibSousMenu = "Administrateur Local" ;
			}
			if (sSousMenus.indexOf("bud") != -1)
			{
				sLibSousMenu = "Gestion Budgétaire" ;
			}
			//FAD PPM 63547
			if (sSousMenus.indexOf("bubase") != -1)
		    {
		        sLibSousMenu = "Gestion Budgétaire de Base";
		    }
			//FAD PPM 63956
			if (sSousMenus.indexOf("suivbase") != -1 || sSousMenus.indexOf("SUIVBASE") != -1)
		    {
		        sLibSousMenu = "Suivi des Directions";
		    }
		}
		if (sMenuCourant.equals("MO")) 
		{
			if (sSousMenus.indexOf("cli") != -1)
			{
				sLibSousMenu = "Saisie Client" ;
			}
		}
		if (sMenuCourant.equals("ISACM")) 
		{
			// On affiche Saisie allégée si il n'y a pas de sous menu et rien sinon
			sLibSousMenu = "Saisie Allégée" ;
			if (sSousMenus.indexOf("isac") != -1)
			{
				sLibSousMenu = null ;
			}
		}
		if (sMenuCourant.equals("INV")) 
		{
			// On affiche Consultation si il n'y a pas de sous menu 
			sLibSousMenu = "Consultation" ;
			if (sSousMenus.indexOf("sinv") != -1)
			{
				sLibSousMenu = null ;
			}
			if (sSousMenus.indexOf("ginv") != -1)
			{
				sLibSousMenu = "Supervision" ;
			}
		}
		if (sMenuCourant.equals("ACH")) 
		{
			if (sSousMenus.indexOf("supach") != -1)
			{
				sLibSousMenu = "Supervision" ;
			}
		}
		//KRA 64733
		if (sMenuCourant.equals("DIR") || sMenuCourant.equals("dir")) 
		{
			if (sSousMenus.indexOf("admbase") != -1)
			{
				sLibSousMenu = "Administration de base" ;
			}
		}
		//Fin KRA
		return sLibSousMenu;
	}

}
