package com.socgen.ich.ihm;

/**
 * Objet menu de niveau 2.
 * Creation date: (27/12/00 09:40:26)
 * @author: Yoann Grandgirard
 */
public class MenuNiv2 extends Menu implements IhmValues {
/**
 * Constructeur par défaut.
 */
public MenuNiv2() {
	super();
}
/**
 * Création d'un menu de niveau 2 vide en spécifiant le fichier de resource à utiliser.
 *  Date de création : (23/01/2001 17:09:23)
 * @param param java.lang.String
 */
public MenuNiv2(String param) {
	super(param);
}
/**
 * Renvoie le code HTML correspondant à l'entête du menu.
 * Creation date: (27/12/00 13:44:13)
 * @return java.lang.String
 */
public String getMenuBegin() {
	java.util.ResourceBundle rb = java.util.ResourceBundle.getBundle(getRes());
	StringBuffer sb = new StringBuffer("");
	if (isVertical()) {
		sb.append("<tr><td class=\"" + rb.getString(MENUNIV1_ITEM_STYLE) + "\">");
		sb.append(
			"<table width=\"100%\" border=\"0\" cellspacing=\"1\" cellpadding=\"1\""
				+ " class=\""
				+ rb.getString(MENUNIV2_BG_STYLE_VERT)
				+"\">"); 
		sb.append("<tr height=\""
		+ rb.getString(MENUNIV2_TOP_BOTTOM_SPACING)
		+ "\"><td></td></tr>") ;
		sb.append("<tr>");
		sb.append("<td class=\"" + rb.getString(MENUNIV2_ITEM_UNSELECT_STYLE) + "\">");
		sb.append(
			"<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\"  width=\"100%\" height=\""
				+ rb.getString(MENUNIV2_HEIGHT)
				+ "\">"); 
	} else {
		sb.append("</tr>");
		sb.append("</table>");
		sb.append("</td>");
		sb.append("</tr>");
		sb.append("<tr>");
		sb.append(
			"<td><img src=\""
				+ rb.getString(ROOT_IMAGE)+rb.getString(MENUNIV1_SEPARATOR_IMG)
				+ "\" border=\"0\" width=\""); 
		sb.append(rb.getString(MENUNIV1_SEPARATOR_WIDTH));
		sb.append("\" height=\"");
		sb.append(rb.getString(MENUNIV1_SEPARATOR_HEIGHT));
		sb.append("\"></td>");
		sb.append("</tr>");
		sb.append("<tr>");
		sb.append("<td>");
		sb.append(
			"<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" height=\"20\">"); 
		sb.append("<tr>");
		sb.append("<td background=\"" + rb.getString(ROOT_IMAGE)+rb.getString(MENUNIV2_IMG_FOND_HORIZ) + "\">");
		sb.append(
			"<img src=\""
				+ rb.getString(ROOT_IMAGE)+rb.getString(MENUNIV2_ITEM_IMG_BLANC)
				+ "\" width=\""
				+ rb.getString(MENUNIV2_SPACE)
				+ "\" height=\""
				+ rb.getString(MENUNIV2_HEIGHT)
				+ "\" border=\"0\">"); 
		sb.append("</td>");
		sb.append("<td background=\"" + rb.getString(ROOT_IMAGE)+rb.getString(MENUNIV2_IMG_FOND_HORIZ) + "\">");
		sb.append(
			"<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" height=\""
				+ rb.getString(MENUNIV2_HEIGHT)
				+ "\">"); 
		sb.append("<tr>");
	}
	return sb.toString();
}
/**
 * Renvoie le code HTML correspondant à la fin du menu.
 * Creation date: (27/12/00 13:44:13)
 * @return java.lang.String
 */
public String getMenuEnd() {
	java.util.ResourceBundle rb = java.util.ResourceBundle.getBundle(getRes());
	StringBuffer sb = new StringBuffer("");
	if (isVertical())
	{
		sb.append("<tr height=\""
		+ rb.getString(MENUNIV2_TOP_BOTTOM_SPACING)
		+ "\"><td></td></tr>") ;
		sb.append("</table></td></tr></table></td></tr>");
	}
	else
	{
		sb.append("</tr>");
	}
	return sb.toString();
}
}
