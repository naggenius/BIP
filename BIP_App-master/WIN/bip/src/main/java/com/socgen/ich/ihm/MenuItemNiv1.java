package com.socgen.ich.ihm;

/**
 * Objet représentant un élément de menu de 1er niveau.
 * Creation date: (27/12/00 11:23:13)
 * @author: Yoann Grandgirard
 */
public class MenuItemNiv1 extends MenuItem  implements IhmValues {
/**
 * Constructeur par défaut.
 */
public MenuItemNiv1() {
	super();
}
/**
 * Création d'un élément de menu de niveau 1 en spécifiant le libellé et le lien.
 * @param la java.lang.String
 * @param li java.lang.String
 */
public MenuItemNiv1(String la, String li) {
	super(la, li);
}
/**
 * Création d'un élément de menu de niveau 1 en spécifiant le libellé, le lien et le sous menu associé.
 * Creation date: (29/12/00 11:31:38)
 * @param la java.lang.String
 * @param li java.lang.String
 * @param sub com.socgen.dlg.lib.ihm.Menu
 */
public MenuItemNiv1(String la, String li, Menu sub) {
	super(la, li,sub);
}
/**
 * Création d'un élément de menu de niveau 1 en spécifiant le libellé, le lien et le sous menu associé, ainsi que le fichier de resource à utiliser.
 *  Date de création : (23/01/2001 17:11:11)
 * @param la java.lang.String
 * @param li java.lang.String
 * @param sub java.lang.String
 * @param resource java.lang.String
 */
public MenuItemNiv1(String la, String li, Menu sub, String resource) {
	super(la, li, sub, resource);
}
/**
 * Renvoie la représentation HTML de l'élément de menu seul.
 * Creation date: (27/12/00 09:41:22)
 * @return java.lang.String
 */
public String printHtml() {
	java.util.ResourceBundle rb = java.util.ResourceBundle.getBundle(getRes());
	StringBuffer sb = new StringBuffer("");
	if (isVertical())
		sb.append("<tr>");
	sb.append("<td width=\"");
	if (isVertical())
		sb.append(rb.getString(MENUNIV1_ITEM_WIDTH_VERT));
	else
		sb.append(rb.getString(MENUNIV1_ITEM_WIDTH));
	sb.append("\" height=\"");
	sb.append(rb.getString(MENUNIV1_ITEM_HEIGHT));
	sb.append("\" class=\"");
	if (isSelect())
	{
		sb.append(rb.getString(MENUNIV1_ITEM_SELECT_STYLE));
	}
	else
	{
		sb.append(rb.getString(MENUNIV1_ITEM_STYLE));
	}
	
	sb.append("\" nowrap>");
	
	if (!isSelect())
	{
		sb.append("<a href=\"");
		sb.append(getLink());
		sb.append("\"><font class=\"");
		sb.append(rb.getString(MENUNIV1_ITEM_FONT_SELECT_STYLE));
		sb.append("\">");
		sb.append(getLabel());
		sb.append("</font></a></td>");
	}
	else
	{
		sb.append("<font class=\"");
		sb.append(rb.getString(MENUNIV1_ITEM_FONT_STYLE));
		sb.append("\">");
		sb.append(getLabel());
		sb.append("</font></td>");
	}
	if (isVertical())
		sb.append("</tr>");
	return sb.toString();
}
}
