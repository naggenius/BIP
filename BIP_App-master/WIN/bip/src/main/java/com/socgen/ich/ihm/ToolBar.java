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
public class ToolBar extends IhmObject implements IhmValues {
	private Vector items = null;
	private Vector otherItems = null;

	/**
	 * Constructeur par défaut.
	 */
	public ToolBar() {
		super();
		items = new Vector() ;
		otherItems = new Vector() ;
	}
	/**
	 * Création de la barre d'outils en spécifiant le fichier de ressources à utiliser.
	 *  Date de création : (31/01/2001 11:00:49)
	 * @param res java.lang.String
	 */
	public ToolBar(String newRes) {
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
	public ToolBar(String newRes, boolean it1, boolean it2, boolean it3, boolean it4, boolean it5, boolean it6, boolean it7, boolean it8, boolean it9) {
		super(newRes);
		ResourceBundle rb = ResourceBundle.getBundle(getRes());
		ToolBarItem[] tbi = new ToolBarItem[5];
		tbi[0] = new ToolBarItem(rb.getString(TOOLBAR_FULLSCREEN_IMG), rb.getString(TOOLBAR_FULLSCREEN_TXT), rb.getString(TOOLBAR_FULLSCREEN_LNK), it1, getRes());
		tbi[1] = new ToolBarItem(rb.getString(TOOLBAR_SEARCH_IMG), rb.getString(TOOLBAR_SEARCH_TXT), rb.getString(TOOLBAR_SEARCH_LNK), it2, getRes());
		tbi[2] = new ToolBarItem(rb.getString(TOOLBAR_HELP_IMG), rb.getString(TOOLBAR_HELP_TXT), rb.getString(TOOLBAR_HELP_LNK), it3, getRes());
		tbi[3] = new ToolBarItem(rb.getString(TOOLBAR_PRINT_IMG), rb.getString(TOOLBAR_PRINT_TXT), rb.getString(TOOLBAR_PRINT_LNK), it4, getRes());
		tbi[4] = new ToolBarItem(rb.getString(TOOLBAR_TOP_IMG), rb.getString(TOOLBAR_TOP_TXT), rb.getString(TOOLBAR_TOP_LNK), it5, getRes());
		ToolBarItem[] tbi2 = new ToolBarItem[4];
		tbi2[0] = new ToolBarItem(rb.getString(TOOLBAR_UNIT_IMG), rb.getString(TOOLBAR_UNIT_TXT), rb.getString(TOOLBAR_UNIT_LNK), it6, getRes());
		tbi2[1] = new ToolBarItem(rb.getString(TOOLBAR_CURRENCY_IMG), rb.getString(TOOLBAR_CURRENCY_TXT), rb.getString(TOOLBAR_CURRENCY_LNK), it7, getRes());
		tbi2[2] = new ToolBarItem(rb.getString(TOOLBAR_EXCEL_IMG), rb.getString(TOOLBAR_EXCEL_TXT), rb.getString(TOOLBAR_EXCEL_LNK), it8, getRes());
		tbi2[3] = new ToolBarItem(rb.getString(TOOLBAR_ID_IMG), rb.getString(TOOLBAR_ID_TXT), rb.getString(TOOLBAR_ID_LNK), it9, getRes());	setItem(tbi);
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
	public ToolBar(String newRes, boolean it1, boolean it2, boolean it3, boolean it4, boolean it5, boolean it6, boolean it7, boolean it8, boolean it9, HttpServletRequest request) {
		super(newRes);
		ResourceBundle rb = ResourceBundle.getBundle(getRes());
		ToolBarItem[] tbi = new ToolBarItem[6];
		tbi[0] = new ToolBarItem(rb.getString(TOOLBAR_FULLSCREEN_IMG), rb.getString(TOOLBAR_FULLSCREEN_TXT), rb.getString(TOOLBAR_FULLSCREEN_LNK), it1, getRes());
		tbi[1] = new ToolBarItem(rb.getString(TOOLBAR_SEARCH_IMG), rb.getString(TOOLBAR_SEARCH_TXT), rb.getString(TOOLBAR_SEARCH_LNK), it2, getRes());
		tbi[2] = new ToolBarItem(rb.getString(TOOLBAR_HELP_IMG), rb.getString(TOOLBAR_HELP_TXT), rb.getString(TOOLBAR_HELP_LNK), it3, getRes());
		tbi[3] = new ToolBarItem(rb.getString(TOOLBAR_PRINT_IMG), rb.getString(TOOLBAR_PRINT_TXT), rb.getString(TOOLBAR_PRINT_LNK), it4, getRes());
		tbi[4] = new ToolBarItem(rb.getString(TOOLBAR_TOP_IMG), rb.getString(TOOLBAR_TOP_TXT), rb.getString(TOOLBAR_TOP_LNK), it5, getRes());

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

		tbi[5] = new ToolBarItem( rb.getString(TOOLBAR_ADDFAV_IMG), 
								  rb.getString(TOOLBAR_ADDFAV_TXT), 
								  "javascript:ajouterFavoris('" + request.getParameter("titlePage") + "','" + 
								  request.getParameter("lienFav") + sb.toString() + "','" + 
								  request.getParameter("typFav") + "');", 
								  bAddFav, getRes());
								  
		ToolBarItem[] tbi2 = new ToolBarItem[4];
		tbi2[0] = new ToolBarItem(rb.getString(TOOLBAR_UNIT_IMG), rb.getString(TOOLBAR_UNIT_TXT), rb.getString(TOOLBAR_UNIT_LNK), it6, getRes());
		tbi2[1] = new ToolBarItem(rb.getString(TOOLBAR_CURRENCY_IMG), rb.getString(TOOLBAR_CURRENCY_TXT), rb.getString(TOOLBAR_CURRENCY_LNK), it7, getRes());
		tbi2[2] = new ToolBarItem(rb.getString(TOOLBAR_EXCEL_IMG), rb.getString(TOOLBAR_EXCEL_TXT), rb.getString(TOOLBAR_EXCEL_LNK), it8, getRes());
		tbi2[3] = new ToolBarItem(rb.getString(TOOLBAR_ID_IMG), rb.getString(TOOLBAR_ID_TXT), rb.getString(TOOLBAR_ID_LNK), it9, getRes());	setItem(tbi);
		setOtherItem(tbi2);
	}

	/**
	 * Renvoie la liste des éléments principaux de la barre d'outils.
	 *  Date de création : (30/01/2001 17:54:11)
	 * @return com.socgen.ich.ihm.ToolBarItem[]
	 */
	public ToolBarItem[] getItem() {
		if (otherItems == null)
		{
			return null ;	
		}
		ToolBarItem[] its = new ToolBarItem[items.size()] ;
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
	 * @return com.socgen.ich.ihm.ToolBarItem[]
	 */
	public ToolBarItem[] getOtherItem() {
		if (otherItems == null)
		{
			return null ;	
		}
		ToolBarItem[] its = new ToolBarItem[otherItems.size()] ;
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
			"<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" height=\"25\" align=\"center\">"); 
		sb.append("<tr>");
		if (items != null) {
			sb.append(getLeft());
			sb.append(getSeparator());
	
			for (int i = 0; i < items.size(); i++) {
				ToolBarItem it = (ToolBarItem)items.elementAt(i) ;
				if (it.isVisible()) {
					sb.append(it.printHtml());
					sb.append(getSeparator());
				}
			}
			sb.append(getRight());
		}
		if (otherItems != null) {
			boolean test = false;
			for (int i = 0; i < otherItems.size(); i++) {
				ToolBarItem it = (ToolBarItem)otherItems.elementAt(i) ;
				if (it.isVisible())
					test = true;
			}
			if (test) {
				sb.append(getLeft());
				sb.append(getSeparator());
				for (int i = 0; i < otherItems.size(); i++) {
					ToolBarItem it = (ToolBarItem)otherItems.elementAt(i) ;
					if (it.isVisible()) {
						sb.append(it.printHtml());
						sb.append(getSeparator());
					}
				}
				sb.append(getRight());
			}
		}
		sb.append("</tr>");
		sb.append("</table>");
		return sb.toString();
	}
	/**
	 * Mise à jour de la liste des éléments principaux.
	 *  Date de création : (30/01/2001 17:54:11)
	 * @param newItem com.socgen.ich.ihm.ToolBarItem[]
	 */
	public void setItem(ToolBarItem[] newItem) {
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
	 * @param newOtherItem com.socgen.ich.ihm.ToolBarItem][
	 */
	public void setOtherItem(ToolBarItem[] newOtherItem) {
		if (newOtherItem == null)
		{
			return ;	
		}
		
		otherItems = new Vector() ;
		otherItems.addAll(Arrays.asList(newOtherItem));
	}
	
	public void addToMainBar(ToolBarItem item)
	{
		if (items == null)
			items = new Vector() ;
		
		items.addElement(item) ;
	}
	
	public void addToMainBar(String img, String a, String lien, boolean v)
	{
		ToolBarItem item = new ToolBarItem(getRes()) ;
		item.setImage(img);
		item.setAlt(a);
		item.setLink(lien);
		item.setVisible(v);
		addToMainBar(item) ;
	}

	public void addToContextualBar(ToolBarItem item)
	{
		if (otherItems == null)
			otherItems = new Vector() ;
		
		otherItems.addElement(item) ;
	}
	
	public void addToContextualBar(String img, String a, String lien, boolean v)
	{
		ToolBarItem item = new ToolBarItem(getRes()) ;
		item.setImage(img);
		item.setAlt(a);
		item.setLink(lien);
		item.setVisible(v);
		addToContextualBar(item) ;
	}

}