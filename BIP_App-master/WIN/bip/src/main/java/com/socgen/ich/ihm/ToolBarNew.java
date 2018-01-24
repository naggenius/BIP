package com.socgen.ich.ihm;

import java.net.URLEncoder;
import java.util.Arrays;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.ResourceBundle;
import java.util.StringTokenizer;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

/**
 * Objet barre d'outils.
 *  Date de création : (30/01/2001 17:37:59)
 * @author : Yoann Grandgirard
 */
public class ToolBarNew extends IhmObject implements IhmValues {
	private Vector items = null;
	private Vector otherItems = null;

	/**
	 * Constructeur par défaut.
	 */
	public ToolBarNew() {
		super();
		items = new Vector() ;
		otherItems = new Vector() ;
	}
	/**
	 * Création de la barre d'outils en spécifiant le fichier de ressources à utiliser.
	 *  Date de création : (31/01/2001 11:00:49)
	 * @param res java.lang.String
	 */
	public ToolBarNew(String newRes) {
		super(newRes);
		items = new Vector() ;
		otherItems = new Vector() ;
	}
	/**
	 * Création de la barre d'outils en spécifiant le fichier de ressources à utiliser et les éléments visibles.
	 *  Date de création : (31/01/2001 11:20:03)
	 * @param newRes java.lang.String
	 * @param it1 boolean
	 * @param it2 boolean
	 * @param it3 boolean
	 * @param it4 boolean
	 * @param it5 boolean
	 * @param it6 boolean
	 * @param it7 boolean
	 * @param it8 boolean
	 * @param it9 boolean
	 */
	public ToolBarNew(String newRes, boolean it1, boolean it2, boolean it3, boolean it4, boolean it5, boolean it6, boolean it7, boolean it8, boolean it9) {
		super(newRes);
		ResourceBundle rb = ResourceBundle.getBundle(getRes());
		ToolBarItemNew[] tbi = new ToolBarItemNew[5];
		tbi[0] = new ToolBarItemNew(rb.getString(TOOLBAR_FULLSCREEN_IMG), rb.getString(TOOLBAR_FULLSCREEN_TXT), rb.getString(TOOLBAR_FULLSCREEN_LNK), it1, getRes(), "Plein écran");
		tbi[1] = new ToolBarItemNew(rb.getString(TOOLBAR_SEARCH_IMG), rb.getString(TOOLBAR_SEARCH_TXT), rb.getString(TOOLBAR_SEARCH_LNK), it2, getRes(), "Contacts");
		tbi[2] = new ToolBarItemNew(rb.getString(TOOLBAR_HELP_IMG), rb.getString(TOOLBAR_HELP_TXT), rb.getString(TOOLBAR_HELP_LNK), it3, getRes(), "Aide");
		tbi[3] = new ToolBarItemNew(rb.getString(TOOLBAR_PRINT_IMG), rb.getString(TOOLBAR_PRINT_TXT), rb.getString(TOOLBAR_PRINT_LNK), it4, getRes(), "Imprimer");
		tbi[4] = new ToolBarItemNew(rb.getString(TOOLBAR_TOP_IMG), rb.getString(TOOLBAR_TOP_TXT), rb.getString(TOOLBAR_TOP_LNK), it5, getRes(), "Haut de page");
		ToolBarItemNew[] tbi2 = new ToolBarItemNew[4];
		tbi2[0] = new ToolBarItemNew(rb.getString(TOOLBAR_UNIT_IMG), rb.getString(TOOLBAR_UNIT_TXT), rb.getString(TOOLBAR_UNIT_LNK), it6, getRes(), "Unité");
		tbi2[1] = new ToolBarItemNew(rb.getString(TOOLBAR_CURRENCY_IMG), rb.getString(TOOLBAR_CURRENCY_TXT), rb.getString(TOOLBAR_CURRENCY_LNK), it7, getRes(), "Devise");
		tbi2[2] = new ToolBarItemNew(rb.getString(TOOLBAR_EXCEL_IMG), rb.getString(TOOLBAR_EXCEL_TXT), rb.getString(TOOLBAR_EXCEL_LNK), it8, getRes(), "Modifier");
		tbi2[3] = new ToolBarItemNew(rb.getString(TOOLBAR_ID_IMG), rb.getString(TOOLBAR_ID_TXT), rb.getString(TOOLBAR_ID_LNK), it9, getRes(), "I.D.");	setItem(tbi);
		setOtherItem(tbi2);
	}

	/**
	 * Création de la barre d'outils en spécifiant le fichier de ressources à utiliser et les éléments visibles.
	 * Avec paramétrage de l'élément "Ajouter aux favoris" suivant un paramètre reçu dans le lien
	 *  Date de création : 01/03/2006
	 * @param newRes java.lang.String
	 * @param it1 boolean
	 * @param it2 boolean
	 * @param it3 boolean
	 * @param it4 boolean
	 * @param it5 boolean
	 * @param it6 boolean
	 * @param it7 boolean
	 * @param it8 boolean
	 * @param it9 boolean
	 * @param request HttpServletRequest
	 */
	public ToolBarNew(String newRes, boolean it1, boolean it2, boolean it3, boolean it4, boolean it5, boolean it6, boolean it7, boolean it8, boolean it9, HttpServletRequest request) {
		super(newRes);
		ResourceBundle rb = ResourceBundle.getBundle(getRes());
		ToolBarItemNew[] tbi = new ToolBarItemNew[6];
		tbi[0] = new ToolBarItemNew(rb.getString(TOOLBAR_FULLSCREEN_IMG), rb.getString(TOOLBAR_FULLSCREEN_TXT), rb.getString(TOOLBAR_FULLSCREEN_LNK), it1, getRes(), "Plein écran");
		tbi[1] = new ToolBarItemNew(rb.getString(TOOLBAR_SEARCH_IMG), rb.getString(TOOLBAR_SEARCH_TXT), rb.getString(TOOLBAR_SEARCH_LNK), it2, getRes(), "Contacts");
		tbi[2] = new ToolBarItemNew(rb.getString(TOOLBAR_HELP_IMG), rb.getString(TOOLBAR_HELP_TXT), rb.getString(TOOLBAR_HELP_LNK), it3, getRes(), "Aide");
		tbi[3] = new ToolBarItemNew(rb.getString(TOOLBAR_PRINT_IMG), rb.getString(TOOLBAR_PRINT_TXT), rb.getString(TOOLBAR_PRINT_LNK), it4, getRes(), "Imprimer");
		tbi[4] = new ToolBarItemNew(rb.getString(TOOLBAR_TOP_IMG), rb.getString(TOOLBAR_TOP_TXT), rb.getString(TOOLBAR_TOP_LNK), it5, getRes(), "Haut de page");

		boolean bAddFav = false;
		if (request.getParameter("addFav")!=null && request.getParameter("addFav").equalsIgnoreCase("yes")) 
			bAddFav = true;

		StringBuffer sb = new StringBuffer();
		if (request.getQueryString()!=null) {
			StringTokenizer paramValue = new StringTokenizer(request.getQueryString(), "&", false);
			Hashtable hParam = new Hashtable();
			while (paramValue.hasMoreTokens()) {
				StringTokenizer pv = new StringTokenizer(paramValue.nextToken(), "=", false);
				if (pv.hasMoreTokens()) {
					String nom = pv.nextToken(); 
					String valeur = ""; 
					if (pv.hasMoreTokens()) valeur = pv.nextToken();
					hParam.put(nom,valeur);
				}
			}
	
			int i=0;
			for (Enumeration vE=hParam.keys(); vE.hasMoreElements();) {
				String key = (String) vE.nextElement();
				String valeur = (String) hParam.get(key);
				sb.append("&param" + i + "=" + key);
				// remplacement du caratère aspostrophe par un espace blanc notamment pour le menu responsable d'études et suivi d'activite
				sb.append("&value" + i + "=" + valeur.replaceAll("\'", " "));
				i++;
			}
		}

		tbi[5] = new ToolBarItemNew( rb.getString(TOOLBAR_ADDFAV_IMG), 
								  rb.getString(TOOLBAR_ADDFAV_TXT), 
								  "javascript:ajouterFavoris('" + request.getParameter("titlePage") + "','" + 
								  request.getParameter("lienFav") + sb.toString() + "','" + 
								  request.getParameter("typFav") + "');", 
								  bAddFav, getRes(), "Ajouter aux favoris");
								  
		ToolBarItemNew[] tbi2 = new ToolBarItemNew[4];
		tbi2[0] = new ToolBarItemNew(rb.getString(TOOLBAR_UNIT_IMG), rb.getString(TOOLBAR_UNIT_TXT), rb.getString(TOOLBAR_UNIT_LNK), it6, getRes(), "Unité");
		tbi2[1] = new ToolBarItemNew(rb.getString(TOOLBAR_CURRENCY_IMG), rb.getString(TOOLBAR_CURRENCY_TXT), rb.getString(TOOLBAR_CURRENCY_LNK), it7, getRes(), "Devise");
		tbi2[2] = new ToolBarItemNew(rb.getString(TOOLBAR_EXCEL_IMG), rb.getString(TOOLBAR_EXCEL_TXT), rb.getString(TOOLBAR_EXCEL_LNK), it8, getRes(), "Modifier");
		tbi2[3] = new ToolBarItemNew(rb.getString(TOOLBAR_ID_IMG), rb.getString(TOOLBAR_ID_TXT), rb.getString(TOOLBAR_ID_LNK), it9, getRes(), "I.D.");	setItem(tbi);
		setOtherItem(tbi2);
	}

	/**
	 * Renvoie la liste des éléments principaux de la barre d'outils.
	 *  Date de création : (30/01/2001 17:54:11)
	 * @return com.socgen.ich.ihm.ToolBarItemNew[]
	 */
	public ToolBarItemNew[] getItem() {
		if (otherItems == null)
		{
			return null ;	
		}
		ToolBarItemNew[] its = new ToolBarItemNew[items.size()] ;
		System.arraycopy(items.toArray(), 0, its, 0, items.size()) ;
		
		return its ;
	}
	/**
	 * Renvoie le code HTML d'entête de la sous barre d'outils.
	 *  Date de création : (31/01/2001 10:33:20)
	 * @return java.lang.String
	 */
	private String getLeft() {
			ResourceBundle rb = ResourceBundle.getBundle(getRes());
		return "<td valign=\"top\" height=\"25\"><img src=\""+rb.getString(ROOT_IMAGE)+rb.getString(TOOLBAR_LEFT)+"\" width=\"11\" height=\"25\" border=\"0\"></td><td background=\""+rb.getString(ROOT_IMAGE)+rb.getString(TOOLBAR_BACKGROUND)+"\">"; 
	}
	/**
	 * Renvoie la liste des éléments secondaires de la barre d'outils.
	 *  Date de création : (30/01/2001 17:57:03)
	 * @return com.socgen.ich.ihm.ToolBarItemNew[]
	 */
	public ToolBarItemNew[] getOtherItem() {
		if (otherItems == null)
		{
			return null ;	
		}
		ToolBarItemNew[] its = new ToolBarItemNew[otherItems.size()] ;
		System.arraycopy(otherItems.toArray(), 0, its, 0, otherItems.size()) ;
		
		return its ;
	}
	/**
	 * Renvoie le code HTML de fin de la sous barre d'outils.
	 *  Date de création : (31/01/2001 10:33:38)
	 * @return java.lang.String
	 */
	private String getRight() {
			java.util.ResourceBundle rb = java.util.ResourceBundle.getBundle(getRes());
		return 
			"</td><td valign=\"top\"><img src=\""+rb.getString(ROOT_IMAGE)+rb.getString(TOOLBAR_RIGHT)+"\" width=\"11\" height=\"25\" border=\"0\"></td>"; 
	}
	/**
	 * Renvoie le code HTML du séparateur d'élément de barre d'outils.
	 *  Date de création : (31/01/2001 10:33:52)
	 * @return java.lang.String
	 */
	private String getSeparator() {
			java.util.ResourceBundle rb = java.util.ResourceBundle.getBundle(getRes());
		return "<img src=\"" + rb.getString(ROOT_IMAGE) + rb.getString(TOOLBAR_SEPARATOR_IMG) + "\" width=\"10\" height=\"1\" border=\"0\">";}
	/**
	 * Renvoie la chaine de caractère représentant le code HTML relatif à la barre d'outils.
	 *  Date de création : (30/01/2001 17:47:20)
	 * @return java.lang.String
	 */
	public String printHtml() {
		StringBuffer sb = new StringBuffer();
		sb.append(
			"<ul id=\"tabs\"><li class=\"homeLink\"><a href=\"../chgmenu.do?action=creer\"><img src=\"../images/home.gif\" width=\"31\" height=\"30\" border=\"0\" /></a></li>"); 
		//sb.append("<tr>");
		if (items != null) {
	
			for (int i = 0; i < items.size(); i++) {
				ToolBarItemNew it = (ToolBarItemNew)items.elementAt(i) ;
				if (it.isVisible()) {
					sb.append("<li>");
					sb.append(it.printHtml());
					sb.append("</li>");
				}
			}
		}
		if (otherItems != null) {
			boolean test = false;
			for (int i = 0; i < otherItems.size(); i++) {
				ToolBarItemNew it = (ToolBarItemNew)otherItems.elementAt(i) ;
				if (it.isVisible())
					test = true;
			}
			if (test) {
				for (int i = 0; i < otherItems.size(); i++) {
					ToolBarItemNew it = (ToolBarItemNew)otherItems.elementAt(i) ;
					if (it.isVisible()) {
						sb.append("<li>");
						sb.append(it.printHtml());
						sb.append("</li>");
					}
				}
			}
		}
		sb.append("</ul>");
		return sb.toString();
	}
	/**
	 * Mise à jour de la liste des éléments principaux.
	 *  Date de création : (30/01/2001 17:54:11)
	 * @param newItem com.socgen.ich.ihm.ToolBarItemNew[]
	 */
	public void setItem(ToolBarItemNew[] newItem) {
		if (newItem == null)
		{
			return ;	
		}
		items = new Vector() ;
		items.addAll(Arrays.asList(newItem));
	}
	/**
	 * Mise à jour de la liste des éléments secondaires.
	 *  Date de création : (30/01/2001 17:57:03)
	 * @param newOtherItem com.socgen.ich.ihm.ToolBarItemNew][
	 */
	public void setOtherItem(ToolBarItemNew[] newOtherItem) {
		if (newOtherItem == null)
		{
			return ;	
		}
		
		otherItems = new Vector() ;
		otherItems.addAll(Arrays.asList(newOtherItem));
	}
	
	public void addToMainBar(ToolBarItemNew item)
	{
		if (items == null)
			items = new Vector() ;
		
		items.addElement(item) ;
	}
	
	public void addToMainBar(String img, String a, String lien, boolean v)
	{
		ToolBarItemNew item = new ToolBarItemNew(getRes()) ;
		item.setImage(img);
		item.setAlt(a);
		item.setLink(lien);
		item.setVisible(v);
		addToMainBar(item) ;
	}

	public void addToContextualBar(ToolBarItemNew item)
	{
		if (otherItems == null)
			otherItems = new Vector() ;
		
		otherItems.addElement(item) ;
	}
	
	public void addToContextualBar(String img, String a, String lien, boolean v)
	{
		ToolBarItemNew item = new ToolBarItemNew(getRes()) ;
		item.setImage(img);
		item.setAlt(a);
		item.setLink(lien);
		item.setVisible(v);
		addToContextualBar(item) ;
	}

}