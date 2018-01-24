package com.socgen.ich.ihm;

/**
 * Objet élément de menu générique.
 * Creation date: (27/12/00 10:32:25)
 * @author: Yoann Grandgirard
 */
public class MenuItem extends IhmObject {
	private java.lang.String label;
	private java.lang.String link;
	private boolean select = false;
	private Menu subMenu;
	private boolean vertical;
/**
 * Constructeur par défaut.
 */
public MenuItem() {
	super();
}
/**
 * Création d'un élément de menu en spécifiant le libellé et le lien.
 * Creation date: (27/12/00 10:54:06)
 * @param la java.lang.String
 * @param li java.lang.String
 */
public MenuItem(String la, String li) {
	super();
	label = la;
	link = li;
}
/**
 * Création d'un élément de menu en spécifiant le libellé, le lien et le sous menu associé.
 * Creation date: (29/12/00 11:31:38)
 * @param la java.lang.String
 * @param li java.lang.String
 * @param sub com.socgen.dlg.lib.ihm.Menu
 */
public MenuItem(String la, String li, Menu sub) {
	super();
	label = la;
	link = li;
	setSubMenu(sub);
}
/**
 * Création d'un élément de menu en spécifiant le libellé, le lien et le sous menu associé, ainsi que le fichier de resource à utiliser.
 *  Date de création : (23/01/2001 17:11:11)
 * @param la java.lang.String
 * @param li java.lang.String
 * @param sub java.lang.String
 * @param resource java.lang.String
 */
public MenuItem(String la, String li, Menu sub, String resource) {
	super(resource);
	label = la;
	link = li;
	setSubMenu(sub);
}
/**
 * Renvoie le libellé.
 * Creation date: (27/12/00 10:33:13)
 * @return java.lang.String
 */
public java.lang.String getLabel() {
	return label;
}
/**
 * Renvoie le lien.
 * Creation date: (27/12/00 10:33:24)
 * @return java.lang.String
 */
public java.lang.String getLink() {
	return link;
}
/**
 * Renvoie le sous menu associé.
 * Creation date: (29/12/00 10:24:02)
 * @return com.socgen.dlg.lib.ihm.Menu
 */
public Menu getSubMenu() {
	return subMenu;
}
/**
 * Renvoie le code HTML correspondant au sous-menu associé.
 * Creation date: (27/12/00 09:41:22)
 * @return java.lang.String
 */
public String getSubMenuHtml() {
	if (subMenu != null)
		return getSubMenu().printHtml();
	else
		return "";
}
/**
 * Test si l'élément de menu est dans l'état sélectionné.
 * Creation date: (27/12/00 10:33:57)
 * @return boolean
 */
public boolean isSelect() {
	return select;
}
/**
 * Test de la verticalité du menu.
 * Creation date: (29/12/00 10:42:15)
 * @return boolean
 */
public boolean isVertical() {
	return vertical;
}
/**
 * Renvoie la chaine de caractère représentant le code HTML relatif à l'élément de menu.
 * Creation date: (27/12/00 09:41:22)
 * @return java.lang.String
 */
public String printHtml() {
	StringBuffer sb = new StringBuffer("");
	return sb.toString();
}
/**
 * Mise à jour du label.
 * Creation date: (27/12/00 10:33:13)
 * @param newLabel java.lang.String
 */
public void setLabel(java.lang.String newLabel) {
	label = newLabel;
}
/**
 * Mise à jour du lien.
 * Creation date: (27/12/00 10:33:24)
 * @param newLink java.lang.String
 */
public void setLink(java.lang.String newLink) {
	link = newLink;
}
/**
 * Mise à jour du fichier de resource utilisé pour l'élément et pour le sous-menu associé.
 *  Date de création : (23/01/2001 16:35:19)
 * @param newRes java.lang.String
 */
public void setRes(java.lang.String newRes) {
	super.setRes(newRes);
	if (subMenu != null)
		subMenu.setRes(getRes());
}
/**
 * Mise à jour de l'indicateur de sélection.
 * Creation date: (27/12/00 10:33:57)
 * @param newSelect boolean
 */
public void setSelect(boolean newSelect) {
	select = newSelect;
}
/**
 * Mise à jour du sous menu.
 * Creation date: (29/12/00 10:24:02)
 * @param newSubMenu com.socgen.dlg.lib.ihm.Menu
 */
public void setSubMenu(Menu newSubMenu) {
	subMenu = newSubMenu;
}
/**
 * Mise à jour de l'indicateur de verticalité pour l'élément de menu et aussi pour le sous menu associé (s'il existe).
 * Creation date: (29/12/00 10:42:15)
 * @param newVertical boolean
 */
public void setVertical(boolean newVertical) {
	vertical = newVertical;
	if (subMenu != null)
		subMenu.setVertical(isVertical());
}
}
