package com.socgen.ich.ihm;

/**
 * Objet repr�sentant un �l�ment de menu de 1er niveau.
 * Creation date: (27/12/00 11:23:13)
 * @author: Yoann Grandgirard
 */
public class MenuItemNiv1 extends MenuItem  implements IhmValues {
/**
 * Constructeur par d�faut.
 */
public MenuItemNiv1() {
	super();
}
/**
 * Cr�ation d'un �l�ment de menu de niveau 1 en sp�cifiant le libell� et le lien.
 * @param la java.lang.String
 * @param li java.lang.String
 */
public MenuItemNiv1(String la, String li) {
	super(la, li);
}
/**
 * Cr�ation d'un �l�ment de menu de niveau 1 en sp�cifiant le libell�, le lien et le sous menu associ�.
 * Creation date: (29/12/00 11:31:38)
 * @param la java.lang.String
 * @param li java.lang.String
 * @param sub com.socgen.dlg.lib.ihm.Menu
 */
public MenuItemNiv1(String la, String li, Menu sub) {
	super(la, li,sub);
}
/**
 * Cr�ation d'un �l�ment de menu de niveau 1 en sp�cifiant le libell�, le lien et le sous menu associ�, ainsi que le fichier de resource � utiliser.
 *  Date de cr�ation : (23/01/2001 17:11:11)
 * @param la java.lang.String
 * @param li java.lang.String
 * @param sub java.lang.String
 * @param resource java.lang.String
 */
public MenuItemNiv1(String la, String li, Menu sub, String resource) {
	super(la, li, sub, resource);
}
/**
 * Renvoie la repr�sentation HTML de l'�l�ment de menu seul.
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
