package com.socgen.ich.ihm ;

/**
 * Objet menu de niveau 1.
 * Creation date: (27/12/00 09:40:26)
 * @author: Yoann Grandgirard
 */
public class MenuNiv1 extends Menu implements IhmValues {
/**
 * Constructeur par défaut.
 */
public MenuNiv1() {
	super();
}
/**
 * Création d'un menu de niveau 1 vide en spécifiant le fichier de resource à utiliser.
 *  Date de création : (23/01/2001 17:09:23)
 * @param param java.lang.String
 */
public MenuNiv1(String param) {
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
	if (!isVertical()) {
		sb.append("<table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">") ;
		sb.append("<tr>");
		sb.append("<td class=\"" + rb.getString(MENUNIV1_STYLE) + "\">");
		sb.append("<table border=\"0\" cellspacing=\"0\" cellpadding=\"0\">");
	}
	else
	{
		sb.append("<table width=\"95%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">");
	}
	
	if (!isVertical()) {
		sb.append("<tr>");
		sb.append("<td width=\"");
		sb.append(rb.getString(MENUNIV1_SEPARATOR_WIDTH));
		sb.append("\" class=\"");
		sb.append(rb.getString(MENUNIV1_START_STYLE));
		sb.append("\"><img src=\"");
		sb.append(rb.getString(ROOT_IMAGE)+rb.getString(MENUNIV1_SEPARATOR_IMG));
		sb.append("\" width=\"");
		sb.append(rb.getString(MENUNIV1_SEPARATOR_WIDTH));
		sb.append("\" height=\"");
		sb.append(rb.getString(MENUNIV1_SEPARATOR_HEIGHT));
		sb.append("\"></td>");
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
	sb.append("</table>");
	if (!isVertical()) {
		boolean sub = false;
		for (int i = 0; i < getElem().length; i++) {
			if ((getElem()[i].isSelect()) && (getElem()[i].getSubMenu() != null)) {
				sub = true;
				break;
			}
		}
		if (sub) {
			sb.append("<td background=\"" +rb.getString(ROOT_IMAGE)+ rb.getString(MENUNIV2_IMG_FOND_HORIZ) + "\">");
			sb.append(
				"<img src=\""
					+ rb.getString(ROOT_IMAGE)+rb.getString(MENUNIV2_ITEM_IMG_BLANC)
					+ "\" width=\""
					+ rb.getString(MENUNIV2_SPACE)
					+ "\" height=\""
					+ rb.getString(MENUNIV2_HEIGHT)
					+ "\" border=\"0\">"); 
			sb.append("</td>");
			sb.append(
				"<td valign=\"top\"><img src=\""
					+ rb.getString(ROOT_IMAGE)+rb.getString(MENUNIV2_IMG_FIN_HORIZ)
					+ "\" width=\""
					+ rb.getString(MENUNIV2_IMG_FIN_HORIZ_WIDTH)
					+ "\" height=\""
					+ rb.getString(MENUNIV2_IMG_FIN_HORIZ_HEIGHT)
					+ "\" border=\"0\"></td>"); 
		}
		sb.append("</tr>");
		sb.append("</table>");
		sb.append("</td>");
		sb.append("</tr>");
		sb.append("</table>");
	}
	return sb.toString();
}
/**
 * Renvoie le code HTML correspondant au sépérateur entre les éléments du menu.
 * Creation date: (27/12/00 09:45:55)
 * @return java.lang.String
 */
public String getMenuSeparator() {
	java.util.ResourceBundle rb = java.util.ResourceBundle.getBundle(getRes());
	StringBuffer sb = new StringBuffer("");
	if (isVertical())
	{
		sb.append("<tr>");
	}
	sb.append("<td width=\"");
	sb.append(rb.getString(MENUNIV1_SEPARATOR_WIDTH));
	sb.append("\" class=\"");
	sb.append(rb.getString(MENUNIV1_SEPARATOR_STYLE));
	sb.append("\"><img src=\"");
	sb.append(rb.getString(ROOT_IMAGE)+rb.getString(MENUNIV1_SEPARATOR_IMG));
	sb.append("\" width=\"");
	sb.append(rb.getString(MENUNIV1_SEPARATOR_WIDTH));
	sb.append("\" height=\"");
	sb.append(rb.getString(MENUNIV1_SEPARATOR_HEIGHT));
	sb.append("\"></td>");
	if (isVertical())
	{
		sb.append("</tr>");
	}
	return sb.toString();
}
}
