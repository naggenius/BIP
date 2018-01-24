/*
 * Créé le 3 déc. 04
 *
 */
package com.socgen.bip.menu;

import java.io.InputStream;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.StringTokenizer;
import java.util.Vector;

import javax.servlet.ServletContext;
import javax.swing.tree.DefaultMutableTreeNode;

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.menu.filtre.FiltreMenu;
import com.socgen.bip.menu.item.BipItem;
import com.socgen.bip.menu.item.BipItemMenu;
import com.socgen.bip.user.UserBip;

/**
 *
 * @author x039435
 */
public class BipMenuManager implements BipConstantes
{
	private static BipMenuManager instance = null;
	private DefaultMutableTreeNode menuRacine;
	private Hashtable hMenus;
	private Hashtable hItems;
	private Hashtable hPagesMenus;
	
	public BipMenuManager(ServletContext context) throws MenuException
	{
		try
		{
			InputStream iS = context.getResourceAsStream(BIP_MENUXML);
			loadMenu(iS);
		}
		catch (MenuException mE)
		{
			logService.error("BipMenuManager : pb récupération du .xml des menus" + mE.getMessage());
			throw mE;
		}
	}

	public static void init(ServletContext context) throws MenuException
	{
		instance = new BipMenuManager(context);
	}
	
	public static BipMenuManager getInstance()
	{
		return instance;
	}
	
	public void loadMenu(InputStream iS) throws MenuException
	{
		BipMenuXML bipXML = new BipMenuXML(iS);
		menuRacine = bipXML.buildTree();
		hPagesMenus = bipXML.getPagesMenus();
		hItems = bipXML.getItems();
		
		hMenus = new Hashtable();
		BipItem mItem;
		String sMenu;
		for (int i=0; i<menuRacine.getChildCount(); i++)
		{
			mItem = (BipItem)(((DefaultMutableTreeNode)menuRacine.getChildAt(i)).getUserObject());
			sMenu = mItem.getId().toUpperCase();
			hMenus.put(sMenu, mItem);
		}
	}
	
	

	/**
	 * On récupère l'arbre du menu courant de l'utilisateur
	 * @param uBip
	 * @return
	 * @throws Exception
	 */
	public DefaultMutableTreeNode getMenuUser(UserBip uBip) throws MenuException
	{
		/* parcours de menuComplet
		 * si FiltreMenuItem.<menuItem.getFiltre()>(uBip, sMenuId) est ok on le garde puis on cherche ses fils, sinon on saute au suivant
		 * si un noeud est vide, on le supprime (qu'il soit affichable ou non)
		 */
		DefaultMutableTreeNode menuUser;
		DefaultMutableTreeNode currentMenu;
		String sMenu = uBip.getCurrentMenu().getId();
		sMenu = sMenu.toUpperCase();
		for (int i=0; i< menuRacine.getChildCount(); i++)
		{
			currentMenu = (DefaultMutableTreeNode)menuRacine.getChildAt(i);
			BipItem mItem = (BipItem)(currentMenu).getUserObject();
			if (mItem.getId().toUpperCase().equals(sMenu))
			{
				try
				{
					menuUser = getMenuUser(uBip, currentMenu);
				}
				catch (Exception e)
				{
					logService.error("BipMenuManager.getMenuUser : pb dans la récupération du menu courant du user " + uBip.getIdUser());
					throw new MenuException("BipMenuManager.getMenuUser : pb dans la récupération du menu courant du user " + uBip.getIdUser(),e);
				}
				return menuUser;
			}			
		}
		//menu n'existe pas ... erreur
		logService.error("BipMenuManager.getMenuUser : le menu " + sMenu + "n'est pas définit");
		throw new MenuException("BipMenuManager.getMenuUser : le menu [" + sMenu + "] n'est pas définit");
	}
	
	private DefaultMutableTreeNode getMenuUser(UserBip uBip, DefaultMutableTreeNode racine) throws Exception
	{
		DefaultMutableTreeNode newRacine = new DefaultMutableTreeNode();

		DefaultMutableTreeNode noeud;
		DefaultMutableTreeNode filsRacine;
		BipItem menuItem;
	
		menuItem = (BipItem)racine.getUserObject();
		newRacine.setUserObject(menuItem);

		boolean afficherRacine;
		if (menuItem.getFiltre() == null)
		{
			//logService.debug("pas de filtre pour " + menuItem.getId());
			afficherRacine = true;
		}
		else
		{
			//logService.debug("Filtre pour " + menuItem.getId());
			//logService.debug(menuItem.getFiltre().getClass().getName());
			FiltreMenu fM = menuItem.getFiltre();
			afficherRacine = fM.eval(uBip);
		}	
		
		if (!afficherRacine)
		{
			return null;
		}
	
		for (int i=0; i<racine.getChildCount(); i++)
		{
			filsRacine = (DefaultMutableTreeNode)racine.getChildAt(i);			
			noeud = getMenuUser(uBip, filsRacine);
			if (noeud != null)
			{
				menuItem = (BipItem)noeud.getUserObject();
			
				if ( (filsRacine.getChildCount() ==0) ||	//si c'est une feuille, on ajoute 
					((filsRacine.getChildCount() > 0) && (noeud.getChildCount() > 0) ) )	//si c'est un sous menu et qu'il y reste des items dedans
				{
					
					if (menuItem.getId().equalsIgnoreCase("XORBRE") && (null != uBip.getPerim_ME().toString() && !uBip.getPerim_ME().toString().isEmpty())){
						List<String> perimMeList = uBip.getPerim_ME();
				        for (String perimMe : perimMeList) {
				        	if(perimMe.equals("00000000000")||perimMe.equals("06000000000")||perimMe.substring(0,4).equals("0632")) {
				        		newRacine.add(noeud);
				        		break;
							}
				        }
					}else {
						newRacine.add(noeud);
					}
				}
			}
		}							
					
		return  newRacine;
	}
	
	public Hashtable getListeMenus()
	{
		return hMenus;
	}
	
	public BipItemMenu getBipMenu(String sMenuId)
	{
		return (BipItemMenu)hMenus.get(sMenuId);
	}
	/*BIP 173 to position the new general menu*/
	private Vector<BipItemMenu> positionGeneralMenu(BipItemMenu bGEN,Vector<BipItemMenu> v){
		
		int i;
		BipItemMenu bIM;
		String menu;
		
		 Iterator<BipItemMenu> itr = v.iterator();
	        while(itr.hasNext()){
	        	bIM  = itr.next();
	        	menu=bIM.getLibelle(); 	
	        	
	        	 if (menu.equals("Responsable d'études")){
	        		i=v.indexOf(bIM);
	        		v.remove(bGEN);
	        		v.insertElementAt(bGEN,i);
	        		break;
	        	}
	        	
	        	else if ((menu.startsWith("S"))){
	          		i=v.indexOf(bIM);
	        	    v.remove(bGEN);
	        	    v.insertElementAt(bGEN,i);
	        	   break;
	           }
	        }
		
		return v;
	}
	
	public Vector<BipItemMenu> getListeBipMenu(String sListeId)
	{
		
		Vector<BipItemMenu> v = new Vector<BipItemMenu>();
		StringTokenizer sTk = new StringTokenizer(sListeId.toUpperCase(), ",");
		
		while (sTk.hasMoreTokens())
		{
			String sMenuId = sTk.nextToken().trim().toUpperCase();
			boolean bAdded = false;
			
			BipItemMenu bIM = (BipItemMenu)hMenus.get(sMenuId);
			
			if (bIM != null)
			{
				int i=0;
				while ((i<v.size()) && (!bAdded))
				{
					String sLibAtI = ((BipItemMenu)(v.get(i))).getLibelle().toUpperCase();
					String sBMLib = bIM.getLibelle().toUpperCase();
					if ( sBMLib.compareTo(sLibAtI) < 0)
					{
						v.insertElementAt(bIM,i);
						bAdded = true;
					}
					i++;
				}
				if (!bAdded)
				{
					//a la fin
					v.add(bIM);
				}
			}
			else
			{

				// /!\ pas trouvé
				logService.warning("Menu [" + sMenuId + "] non trouvé");
			}
		}
		
		/*BIP 173 to position the new general menu*/
		BipItemMenu bGEN = (BipItemMenu)hMenus.get("GENERAL");
		if(v.contains(bGEN)){
		v=positionGeneralMenu(bGEN,v);
		}
		return v;
	}
	
	//Renvoie la liste des menu configurés qu'ils existent ou non. Sert pour l'affiche du report Mon Profil
	public Vector getListeBipMenuConfig(String sListeId)
	{
		
		Vector v = new Vector();
		Vector codesInconnus = new Vector();
		StringTokenizer sTk = new StringTokenizer(sListeId.toUpperCase(), ",");
		
		while (sTk.hasMoreTokens())
		{
			String sMenuId = sTk.nextToken().trim().toUpperCase();
			boolean bAdded = false;
			
			BipItemMenu bIM = (BipItemMenu)hMenus.get(sMenuId);
			if (bIM != null)
			{
				int i=0;
				while ((i<v.size()) && (!bAdded))
				{
					String sLibAtI = ((String)(v.get(i))).toUpperCase();
					String sBMLib = bIM.getLibelle().toUpperCase();
					if ( sBMLib.compareTo(sLibAtI) < 0)
					{
						v.insertElementAt(bIM.getLibelle(),i);
						bAdded = true;
					}
					i++;
				}
				if (!bAdded)
				{
					//a la fin
					v.add(bIM.getLibelle());
				}
			}
			else
			{
				codesInconnus.add(sMenuId+" Code menu inconnu");
				// /!\ pas trouvé
				logService.warning("Menu [" + sMenuId + "] non trouvé");
			}
		}
		v.addAll(codesInconnus);
		return v;
	}
	
	public Vector getListeBipItem(String sListeId)
	{
	
		Vector v = new Vector();
		StringTokenizer sTk = new StringTokenizer(sListeId.toUpperCase(), ",");
	
		while (sTk.hasMoreTokens())
		{
			String sId = sTk.nextToken().trim();
			//logService.debug(sId);

			boolean bAdded = false;
		
			BipItem bI = (BipItem)hItems.get(sId);
			if (bI != null)
			{
				int i=0;
				while ((i<v.size()) && (!bAdded))
				{
					BipItem bIAtI = (BipItem)v.get(i);
										
					String sLibAtI = bIAtI.getLibelle().toUpperCase();
					String sBLib = bI.getLibelle().toUpperCase();
					if ( sBLib.compareTo(sLibAtI) < 0)
					{
						v.insertElementAt(bI,i);
						bAdded = true;
					}
					i++;
				}
				if (!bAdded)
				{
					//a la fin
					v.add(bI);
				}
			}
			else
			{
				// /!\ pas trouvé
				logService.warning("Item [" + sId + "] non trouvé");
			}
		}
		return v;
	}
	
	//Renvoie la liste des sous-menus configurés qu'ils existent ou non. Sert pour l'affiche du report Mon Profil
	public Vector getListeBipItemConfig(String sListeId)
	{
	
		Vector v = new Vector();
		Vector codesInconnus = new Vector();
		StringTokenizer sTk = new StringTokenizer(sListeId.toUpperCase(), ",");
	
		while (sTk.hasMoreTokens())
		{
			String sId = sTk.nextToken().trim();
			//logService.debug(sId);

			boolean bAdded = false;
		
			BipItem bI = (BipItem)hItems.get(sId);
			if (bI != null)
			{
				int i=0;
				while ((i<v.size()) && (!bAdded))
				{
					String sLibAtI = ((String)v.get(i)).toUpperCase();
					String sBLib = bI.getLibelle().toUpperCase();
					if ( sBLib.compareTo(sLibAtI) < 0)
					{
						v.insertElementAt(bI.getLibelle(),i);
						bAdded = true;
					}
					i++;
				}
				if (!bAdded)
				{
					//a la fin
					v.add(bI.getLibelle());
				}
			}
			else
			{
				codesInconnus.add(sId+" Code sous-menu inconnu");
				// /!\ pas trouvé
				logService.warning("Item [" + sId + "] non trouvé");
			}
		}
		v.addAll(codesInconnus);
		return v;
	}
	
	/**
	 * @return
	 */
	public Hashtable getPagesMenus()
	{
		return hPagesMenus;
	}

	public String getMenuPageAide(String sMenuId)
	{
		return (String)((BipItem)hMenus.get(sMenuId)).getPageAide();
	}
}
