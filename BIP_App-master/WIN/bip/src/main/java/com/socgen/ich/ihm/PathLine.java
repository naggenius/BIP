package com.socgen.ich.ihm;

/**
 * Objet ligne de chemin.
 * @author: Yoann Grandgirard
 */
public class PathLine extends Menu implements IhmValues {
/**
 * Constructeur par défaut.
 */
public PathLine() {
	super();
}
/**
 * Création d'une ligne de chemin vide en spécifiant le fichier de resource à utiliser.
 *  Date de création : (01/02/2001 10:59:29)
 * @param newRes java.lang.String
 */
public PathLine(String newRes) {
	super(newRes);
}
/**
 * Renvoie le code HTML correspondant à l'entête du chemin.
 * Creation date: (27/12/00 13:44:13)
 * @return java.lang.String
 */
public String getMenuBegin() {
	java.util.ResourceBundle rb = java.util.ResourceBundle.getBundle(getRes());
	return "<font class=\"" + rb.getString(PATHLINE_FONT_STYLE) + "\">";
}
/**
 * Renvoie le code HTML correspondant à la fin du chemin.
 * Creation date: (27/12/00 13:44:13)
 * @return java.lang.String
 */
public String getMenuEnd() {
	return "</font>";
}
/**
 * Renvoie le code HTML correspondant au séparateur entre les différents éléments du chemin.
 * Creation date: (27/12/00 09:45:55)
 * @return java.lang.String
 */
public String getMenuSeparator() {
	java.util.ResourceBundle rb = java.util.ResourceBundle.getBundle(getRes());
	return " "+rb.getString(PATHLINE_SEPARATOR);
}
/**
 * Renvoie la chaine de caractère représentant le code HTML relatif au chemin parcouru.
 * Creation date: (27/12/00 09:41:22)
 * @return java.lang.String
 */
public String printHtml() {
	StringBuffer sb = new StringBuffer();
	sb.append(getMenuBegin());
	for (int i = 0; i < getElem().length; i++) {
		sb.append((getElem()[i]).printHtml());
		if (i < getElem().length - 1) {
			sb.append(getMenuSeparator());
			sb.append(' ') ;
		}
	}
	sb.append(getMenuEnd());
	return sb.toString();
}
}
