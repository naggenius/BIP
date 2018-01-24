package com.socgen.ich.ihm;

/**
 * El�ment de chemin.
 * Creation date: (27/12/00 11:23:13)
 * @author: Yoann Grandgirard
 */
public class PathLineItem extends MenuItem  implements IhmValues {
/**
 * Constructeur par d�faut.
 */
public PathLineItem() {
	super();
}
/**
 * Constructeur � partir du libell� et du lien.
 * @param la java.lang.String
 * @param li java.lang.String
 */
public PathLineItem(String la, String li) {
	super(la, li);
}
/**
 * Renvoie la chaine de caract�re repr�sentant le code HTML relatif � l'�l�ment de chemin.
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
