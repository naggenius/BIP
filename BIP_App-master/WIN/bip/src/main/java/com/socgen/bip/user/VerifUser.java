package com.socgen.bip.user;

// Import des classes générales utilisées


import java.io.IOException;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspTagException;
import javax.servlet.jsp.tagext.TagSupport;

//import com.socgen.adn.reader.ADNUser;
import com.socgen.afe.afer.SafeException;
import com.socgen.afe.afer.envc1.client.PrincipalWrapper;
import com.socgen.afe.afer.envc1.common.SocgenUser;
import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.action.BipAction;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.menu.BipMenuManager;
import com.socgen.cap.fwk.log.Log;

/**
 * @author Pierre JOSSE DSIC/SUP
 *
 * Objet permettant de faire les vérifications concernant :
 * - la création de l'utilisateur(UserBip) dans les objets de session
 * - L'authorisation de visualiser une page ou non.
 */

public class VerifUser extends TagSupport  implements BipConstantes{
	static Log logBipUser = BipAction.getLogBipUser();
	//La clé de la requête de sélection de tous les profils dans le fichier "sql.properties"
	public static final String MENUS_PAGE = "SQL.Menus.SelectMenusPage"; 
	
	//La chaîne qui permet de savoir que la BIP est bloquée
	public static final String BIP_BLOQUEE = "BLOQUEE";
	
	// Nom de la page d'accueil
	public static final String PAGE_ACCUEIL = "frameAccueil.jsp";

	//Page en cours de traitement
	private String page;

	/**
	 * Implémentation du tag.
	 * Vérifie si l'utilisateur est créé dans les objets de session
	 * - Si pas créé, on le créé 
	 * 
	 * @see javax.servlet.jsp.tagext.TagSupport#doEndTag()
	 */
	public int doEndTag() throws JspException
	{
		HttpServletRequest request = (HttpServletRequest) pageContext.getRequest();
		HttpServletResponse response = (HttpServletResponse) pageContext.getResponse();
		HttpSession session = request.getSession(false);
		// Si la session est nulle on redirige vers la page de fin de session
		if (session == null)
		{
			try
			{
				response.sendRedirect(request.getContextPath()+"/" + PAGE_ACCUEIL + "?redirect=O");
			}
			catch (IOException io)
			{
				throw new JspTagException("Problème lors de la redirection vers la page d'accueil");
			}
		}

		/**
		 * Vérification/Création de la classe UserBip
		 */
		// On récupère le user 
		UserBip user = (UserBip) session.getAttribute("UserBip");
		// Si le user n'est pas dans les objets de session
		// On récupère l'ojet contenant l'élément SSO retourné
		// On créé l'objet UserBip
		// Et on le met dans la variable de session.
		if (user == null)
		{
			//Si on est sur la page d'accueil 
			if (PAGE_ACCUEIL.equals(page))
			{
				// On récupère l'objet de session SSO
				SocgenUser u;
				try {
				u = PrincipalWrapper.getSocgenUser(request);
				}
				catch (SafeException se) {
					throw new JspTagException("Problème lors de la récupération du user SAFE");
				}

				// On lance la méthode qui récupère les paramètres du RTFE
				// Et qui créé la classe UserBip dans les objets de session 
				
				user = new UserBip(u);
				
				// on insère le User dans la session
				session.setAttribute("UserBip", user);
			
			} // Sinon on fait une redirection vers la page d'accueil
			else
			{
				try
				{
					response.sendRedirect(request.getContextPath()+"/" + PAGE_ACCUEIL + "?redirect=O");
				}
				catch (IOException io)
				{
					throw new JspTagException("Problème lors de la redirection vers la page d'accueil");
				}
			}
		}
		/**
		 * Vérification de l'habilitation de l'utilisateur à la BIP
		 * S'il n'est pas habilité, on le renvoie vers la page d'erreur d'habilitation
		 */
		if (!user.isHabiliteBip())
		{
			throw new JspTagException("Vous n'êtes pas habilité à la BIP");
		}

		/**
		 * Vérification de l'habilitation du User à la page demandée
		 * Si la personne n'est pas habilité au menu auquel appartient la page,
		 * on redirige vers une page d'erreur
		 */
		else
		{
			if (!this.verifUserAvecPage(user))
			{
				throw new JspTagException("Vous n'êtes pas habilité pour visualiser cette page");
			}
			/** 
			 *Si la BIP est bloquée et que le menu DIR n'est pas dans la liste des menus
			 *On renvoie vers la page d'accueil
			 *Sinon, on affiche la page normalement
			 */
			else
			{

						return EVAL_PAGE;
			}
		}
	}

	/**
	 * Vérifie la cohérence des menus de la page avec les habilitations de l'utilisateur
	 * @return boolean disant si l'utilisateur est habilité à la page
	 */
	public boolean verifUserAvecPage(UserBip uBip)
	{
		//il faut déterminer si la page est autorisee pour le userBip donné
		Hashtable hPagesMenus = BipMenuManager.getInstance().getPagesMenus();
		//page == "" => pas de verif a effectuer
		if ( (PAGE_ACCUEIL.equals(page)) || ("".equals(page)) )
			return true;

		String sMenus = (String)hPagesMenus.get(page);
		
		if (sMenus == null)
		{
			return false;
		}		
		sMenus = sMenus.toUpperCase();
		
		String sCurrentMenu = (uBip.getCurrentMenu().getId()).toUpperCase();
		/*logService.debug("Menus de page [ "+page+ "] : " + sMenus);
		logService.debug("Menu courant: " + sCurrentMenu);*/
		if (sMenus.indexOf(sCurrentMenu) < 0 )
		{
			return false;
		}
		return true;	
	}

	/**
	 * Retourne la page courante.
	 * @return String
	 */
	public String getPage() {
		return page;
	}

	/**
	 * Met à jour la variable d'instance de la page courante.
	 * @param page La page en cours de demande
	 */
	public void setPage(String page) {
		this.page = page;
	}
}