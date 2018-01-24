package com.socgen.bip.user;

// Import des classes g�n�rales utilis�es


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
 * Objet permettant de faire les v�rifications concernant :
 * - la cr�ation de l'utilisateur(UserBip) dans les objets de session
 * - L'authorisation de visualiser une page ou non.
 */

public class VerifUser extends TagSupport  implements BipConstantes{
	static Log logBipUser = BipAction.getLogBipUser();
	//La cl� de la requ�te de s�lection de tous les profils dans le fichier "sql.properties"
	public static final String MENUS_PAGE = "SQL.Menus.SelectMenusPage"; 
	
	//La cha�ne qui permet de savoir que la BIP est bloqu�e
	public static final String BIP_BLOQUEE = "BLOQUEE";
	
	// Nom de la page d'accueil
	public static final String PAGE_ACCUEIL = "frameAccueil.jsp";

	//Page en cours de traitement
	private String page;

	/**
	 * Impl�mentation du tag.
	 * V�rifie si l'utilisateur est cr�� dans les objets de session
	 * - Si pas cr��, on le cr�� 
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
				throw new JspTagException("Probl�me lors de la redirection vers la page d'accueil");
			}
		}

		/**
		 * V�rification/Cr�ation de la classe UserBip
		 */
		// On r�cup�re le user 
		UserBip user = (UserBip) session.getAttribute("UserBip");
		// Si le user n'est pas dans les objets de session
		// On r�cup�re l'ojet contenant l'�l�ment SSO retourn�
		// On cr�� l'objet UserBip
		// Et on le met dans la variable de session.
		if (user == null)
		{
			//Si on est sur la page d'accueil 
			if (PAGE_ACCUEIL.equals(page))
			{
				// On r�cup�re l'objet de session SSO
				SocgenUser u;
				try {
				u = PrincipalWrapper.getSocgenUser(request);
				}
				catch (SafeException se) {
					throw new JspTagException("Probl�me lors de la r�cup�ration du user SAFE");
				}

				// On lance la m�thode qui r�cup�re les param�tres du RTFE
				// Et qui cr�� la classe UserBip dans les objets de session 
				
				user = new UserBip(u);
				
				// on ins�re le User dans la session
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
					throw new JspTagException("Probl�me lors de la redirection vers la page d'accueil");
				}
			}
		}
		/**
		 * V�rification de l'habilitation de l'utilisateur � la BIP
		 * S'il n'est pas habilit�, on le renvoie vers la page d'erreur d'habilitation
		 */
		if (!user.isHabiliteBip())
		{
			throw new JspTagException("Vous n'�tes pas habilit� � la BIP");
		}

		/**
		 * V�rification de l'habilitation du User � la page demand�e
		 * Si la personne n'est pas habilit� au menu auquel appartient la page,
		 * on redirige vers une page d'erreur
		 */
		else
		{
			if (!this.verifUserAvecPage(user))
			{
				throw new JspTagException("Vous n'�tes pas habilit� pour visualiser cette page");
			}
			/** 
			 *Si la BIP est bloqu�e et que le menu DIR n'est pas dans la liste des menus
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
	 * V�rifie la coh�rence des menus de la page avec les habilitations de l'utilisateur
	 * @return boolean disant si l'utilisateur est habilit� � la page
	 */
	public boolean verifUserAvecPage(UserBip uBip)
	{
		//il faut d�terminer si la page est autorisee pour le userBip donn�
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
	 * Met � jour la variable d'instance de la page courante.
	 * @param page La page en cours de demande
	 */
	public void setPage(String page) {
		this.page = page;
	}
}