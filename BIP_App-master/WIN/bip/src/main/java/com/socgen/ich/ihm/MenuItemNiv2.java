package com.socgen.ich.ihm;

/**
 * Objet repr�sentant un �l�ment de menu de 2e niveau.
 * Creation date: (27/12/00 11:23:13)
 * @author: Yoann Grandgirard
 */
public class MenuItemNiv2 extends MenuItem  implements IhmValues {
/**
 * Constructeur par d�faut.
 */
public MenuItemNiv2() {
	super();
}
/**
 * Cr�ation d'un �l�ment de menu de niveau 2 en sp�cifiant le libell� et le lien.
 * @param la java.lang.String
 * @param li java.lang.String
 */
public MenuItemNiv2(String la, String li) {
	super(la, li);
}
/**
 * Cr�ation d'un �l�ment de menu de niveau 2 en sp�cifiant le libell�, le lien et le sous menu associ�.
 * Creation date: (29/12/00 11:31:38)
 * @param la java.lang.String
 * @param li java.lang.String
 * @param sub com.socgen.dlg.lib.ihm.Menu
 */
public MenuItemNiv2(String la, String li, Menu sub) {
	super(la, li,sub);
}
/**
 * Cr�ation d'un �l�ment de menu de niveau 2 en sp�cifiant le libell�, le lien et le sous menu associ�, ainsi que le fichier de resource � utiliser.
 *  Date de cr�ation : (23/01/2001 17:11:11)
 * @param la java.lang.String
 * @param li java.lang.String
 * @param sub java.lang.String
 * @param resource java.lang.String
 */
public MenuItemNiv2(String la, String li, Menu sub, String resource) {
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
	if (isSelect()) {
		sb.append(
			"<td class=\""
				+ rb.getString(MENUNIV2_ITEM_SELECT_STYLE)
				+ "\" width=\""
				+ rb.getString(MENUNIV2_PUCE_WIDTH)
				+ "\"><img src=\""
				+ rb.getString(ROOT_IMAGE)+rb.getString(MENUNIV2_ITEM_PUCE_SELECT)
				+ "\" border=\"0\"></td>"); 
		sb.append(
			"<td class=\""
				+ rb.getString(MENUNIV2_ITEM_SELECT_STYLE)
				+ "\"  nowrap>"
				+ "<font class=\""
				+ rb.getString(MENUNIV2_ITEM_FONT_STYLE)
				+ "\">"
				+ getLabel()
				+ "</font></td>"); 
		sb.append(
			"<td class=\""
				+ rb.getString(MENUNIV2_ITEM_SELECT_STYLE)
				+ "\" width=\""
				+ rb.getString(MENUNIV2_BLANC_WIDTH)
				+ "\"><img src=\""
				+ rb.getString(ROOT_IMAGE)+rb.getString(MENUNIV2_ITEM_IMG_BLANC)
				+ "\" width=\""
				+ rb.getString(MENUNIV2_BLANC_WIDTH)
				+ "\" height=\"1\" border=\"0\"></td>"); 
	} else {
		sb.append(
			"<td class=\""
				+ rb.getString(MENUNIV2_ITEM_UNSELECT_STYLE)
				+ "\" width=\""
				+ rb.getString(MENUNIV2_PUCE_WIDTH)
				+ "\"><img src=\""
				+ rb.getString(ROOT_IMAGE)+rb.getString(MENUNIV2_ITEM_PUCE)
				+ "\" border=\"0\"></td>"); 
		sb.append(
			"<td class=\""
				+ rb.getString(MENUNIV2_ITEM_UNSELECT_STYLE)
				+ "\"  nowrap><a href=\""
				+ getLink()
				+ "\"><font class=\""
				+ rb.getString(MENUNIV2_ITEM_FONT_STYLE)
				+ "\">"
				+ getLabel()
				+ "</font></a></td>"); 
		sb.append(
			"<td class=\""
				+ rb.getString(MENUNIV2_ITEM_UNSELECT_STYLE)
				+ "\" width=\""
				+ rb.getString(MENUNIV2_BLANC_WIDTH)
				+ "\"><img src=\""
				+ rb.getString(ROOT_IMAGE)+rb.getString(MENUNIV2_ITEM_IMG_BLANC)
				+ "\" width=\""
				+ rb.getString(MENUNIV2_BLANC_WIDTH)
				+ "\" height=\"1\" border=\"0\"></td>"); 
	}
	if (isVertical())
		sb.append("</tr>");
	return sb.toString();
}
}
