package com.socgen.ich.ihm;

/**
 * Elément de chemin.
 * Creation date: (27/12/00 11:23:13)
 * @author: Yoann Grandgirard
 */
public class PathLineItem extends MenuItem  implements IhmValues {
/**
 * Constructeur par défaut.
 */
public PathLineItem() {
	super();
}
/**
 * Constructeur à partir du libellé et du lien.
 * @param la java.lang.String
 * @param li java.lang.String
 */
public PathLineItem(String la, String li) {
	super(la, li);
}
/**
 * Renvoie la chaine de caractère représentant le code HTML relatif à l'élément de chemin.
 * Creation date: (27/12/00 09:41:22)
 * @return java.lang.String
 */
public String printHtml() {
	StringBuffer sb = new StringBuffer("");
	if (getLink() != null)
		sb.append("<a href=\"" + getLink() + "\">" + getLabel() + "</a>");
	else
		sb.append(getLabel());
	return sb.toString();
}
}
