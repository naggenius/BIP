package com.socgen.bip.taglib;

import java.io.IOException;
import java.util.Enumeration;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.TagSupport;
import javax.swing.tree.DefaultMutableTreeNode;

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.BipSession;
import com.socgen.bip.commun.Tools;
import com.socgen.bip.menu.BipMenuManager;
import com.socgen.bip.menu.item.BipItem;
import com.socgen.bip.menu.item.BipItemMenu;
import com.socgen.bip.menu.item.BipMenuInfoItem;
import com.socgen.bip.user.UserBip;

/**
 * Implémentation du tag responsable de la génération du menu de l'utilisateur.
 * @author E.GREVREND
 */

public class BipMenuTag extends TagSupport implements BipConstantes
{
	/**
	 * Implémentation du tag.
	 * Génère le code Javascript nécessaire à la création du menu.
	 * @see javax.servlet.jsp.tagext.TagSupport#doEndTag()
	 */
	public int doEndTag() throws JspException
	{
		HttpServletRequest request = (HttpServletRequest) pageContext.getRequest();
		HttpSession session = request.getSession(false);
		String requete = null;
		String libelle = null;
		String libMenu = null;
		String titreMenu = null;
		String titreMenuInfo = null;
		String sCouleur = null;
		String titreMenuFiliale = null;
		
		BipItem item;
		BipItem parent = null;
		// L'utilisateur doit être authentifié.
		// dans le cas inverse, on provoque une exception.

		if (session == null) 
		{
			throw new JspException("La session ne devrait pas être NULL");
		}

		UserBip user = (UserBip) session.getAttribute("UserBip");
		

		if (user == null)
		{
			throw new JspException("L'utilisateur ne devrait pas être NULL");
		}

		// Récupération de tous les menus de l'application.
		//Hashtable applicationMenus = (Hashtable) pageContext.getServletContext().getAttribute(MenuManager.APPLICATION_MENUS_KEY);
		
		DefaultMutableTreeNode menuUser = null;		
		try
		{
			menuUser = BipMenuManager.getInstance().getMenuUser(user);
		}
		catch (Exception e)
		{
			logIhm.error(e);
			throw new JspException("Récupération du menu de l'utilisateur " + user.getIdUser(), e);
		}

		JspWriter out = pageContext.getOut();
		try 
		{
			sCouleur = ((BipItemMenu)menuUser.getUserObject()).getCouleurFond();
			if (sCouleur != null)
			{
				out.println("couleur = '" + sCouleur + "' ;");
			}
			
			//Récupérer le titre du menu à afficher
			titreMenu = ((BipItem)menuUser.getUserObject()).getLibelle();
			
			libMenu = "<table width='100%'  border='1' cellpadding='0' cellspacing='0' bordercolor='#FFFFFF'>";
			libMenu += "<tr >";
			libMenu += "<td  class='TitreMenu' align='center'>"
						+ titreMenu
						+ "</td>";
			libMenu += "</tr>";
			
			/*
			 * Gestion des Infos du menu
			 */
			String sInfos = null;
			Vector vInfos = ((BipItemMenu)menuUser.getUserObject()).getInfos();
			try
			{
				for (int i=0; i< vInfos.size(); i++)
				{					
					BipMenuInfoItem bMI = (BipMenuInfoItem)vInfos.elementAt(i);
					Vector v = new Vector();
					v.add(session);
					//String sValue = (String)BipMenuManager.getInstanceOf(bMI.getClassName(), bMI.getFunctionName(), new BipSession(session));
					String sValue = (String)Tools.getInstanceOf(bMI.getClassName(), bMI.getFunctionName(), new BipSession(session));
					if (sValue != null)
					{
						if (sInfos == null)
						{
							sInfos = "<tr><td class='TitreMenuInfo'>";
						}
						else
						{
							sInfos += "</br>";
						}
						sInfos += sValue;
					}
				}
			}
			catch (Exception e)
			{
				logService.error("Récupération des infos du menu " + titreMenu, e);
				throw new JspException(e);
			}
			if (sInfos != null)
				sInfos += "</td>	</tr>";
			else
				sInfos = "";


			libMenu += sInfos + "</table>";
			
			String sLink = ((BipItemMenu)menuUser.getUserObject()).getLien();
			String sLinkOptions = ((BipItemMenu)menuUser.getUserObject()).getOptionsLien();
			if (sLink == null)
				sLink = "null";
			else
			{
				if (sLinkOptions != null)
				{
					sLink += "?"+sLinkOptions;
				}
				sLink = "\""+sLink+"\"";
			}
				
			sLink = "var code_page = "+sLink+";";
			out.println(sLink);
			
			String sPageAide = ((BipItemMenu)menuUser.getUserObject()).getPageAide();
			out.println("var pageAide = \"" + sPageAide + "\";");
			
			out.println("libMenu  = \"" + libMenu + "\" ;");
			out.println();
			// Génération du code javascript
			// le code généré est de la forme : var item0001 = new Item(idParent, "Libellé item", "URL", "alt") ;

			for (Enumeration enums = menuUser.children(); enums.hasMoreElements();)
			{
				buildMenu(out, (DefaultMutableTreeNode)enums.nextElement(),titreMenu);
			}
		
		} catch (IOException ioe)
		{
			logService.error("Problème dans la génération du javascript des menu", ioe);
			throw new JspException(ioe);
		}

		return EVAL_PAGE;
	}

	private void buildMenu(JspWriter out, DefaultMutableTreeNode noeudMenu,String menuPrincipal) throws IOException
	{
		BipItem item = (BipItem)noeudMenu.getUserObject();
		BipItem itemParent = (BipItem)((DefaultMutableTreeNode)noeudMenu.getParent()).getUserObject();
		if ( (itemParent != null) && (itemParent instanceof BipItemMenu) )
			itemParent=null;
		 
		out.print("\t\tvar " + item.getId());
		out.print(
			" = new Item("
				+ ((itemParent != null) ? "" + itemParent.getId() : "null"));
		out.print(", \"" + item.getLibelle() );
		out.print(
			"\", "
				+ (item.getLien() == null
					? "null"
					: "\""
						+ item.getLien()
						+ (item.getPageAide() == null
							? ""
							: "?arborescence="+ menuPrincipal + "/"
								+ (itemParent != null
									? ""+itemParent.getLibelle()+ "/"
									: "")
								+ item.getLibelle()
								+ "&sousMenu="
								+ item.getNivSousMenu()
								+ "&pageAide="
								+ ((HttpServletRequest) pageContext
									.getRequest())
									.getContextPath()
								+ "/"
								+ item.getPageAide()
								+ (item.getOptionsLien() == null
									? "\""
									: "&"
										+ item.getOptionsLien()
										+ "\""))));
		out.print(", \"" + item.getAltLib() + "\"");
		out.print(", \"" + item.getPageAide() + "\"");
		out.println(") ;");
		
		//on ecrit tous les fils du noeud
		for (Enumeration enums = noeudMenu.children(); enums.hasMoreElements();)
		{
			buildMenu(out, (DefaultMutableTreeNode)enums.nextElement(),menuPrincipal);
		}
	}
}
