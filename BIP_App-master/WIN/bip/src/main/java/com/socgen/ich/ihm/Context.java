package com.socgen.ich.ihm;

/**
 * Classe décrivant le contexte.
 *  Date de création : (31/01/2001 11:56:36)
 * @author : Yoann Grandgirard
 */
public class Context extends IhmObject implements IhmValues {
	private java.lang.String[] label;
	private java.lang.String[] value;
	private int nbCol = 1;
	private java.lang.String imgTitre;
/**
 * Constructeur par défaut.
 */
public Context() {
	super();
}
/**
 * Création d'un contexte vide en spécifiant uniquement l'image de titre et en utilisant le fichier de resource par défaut (ich_ihm.properties)
 *  Date de création : (31/01/2001 16:56:37)
 * @param titre java.lang.String
 */
public Context(String titre) {
	super();
	setImgTitre(titre);
}
/**
 * Création d'un contexte vide en spécifiant uniquement l'image de titre  et le fichier de resource spécifié.
 *  Date de création : (31/01/2001 16:57:12)
 * @param titre java.lang.String
 * @param newRes java.lang.String
 */
public Context(String titre, String newRes) {
	super(newRes);
	setImgTitre(titre);
}
/**
 * Ajout d'un élément (libellé + valeur) au contexte.
 *  Date de création : (31/01/2001 12:06:40)
 * @param l java.lang.String
 * @param v java.lang.String
 */
public void addToContext(String l, String v) {
	String[] newLabel;
	String[] newValue;
	if (label != null) {
		newLabel = new String[getLabel().length+1];
		newValue = new String[getLabel().length+1];
		for (int i = 0; i < getLabel().length; i++) {
			newLabel[i] = getLabel()[i];
			newValue[i] = getValue()[i];
		}
		newLabel[getLabel().length] = l;
		newValue[getValue().length] = v;
	} else {
		newLabel = new String[1];
		newLabel[0] = l;
		newValue = new String[1];
		newValue[0] = v;
	}
	setLabel(newLabel);
	setValue(newValue);
}
/**
 * Renvoie le nom de l'image de titre du contexte.
 *  Date de création : (31/01/2001 16:56:11)
 * @return java.lang.String
 */
public java.lang.String getImgTitre() {
	return imgTitre;
}
/**
 * Renvoie l'ensemble des libellés du contexte.
 *  Date de création : (31/01/2001 12:05:37)
 * @return java.lang.String[]
 */
public java.lang.String[] getLabel() {
	return label;
}
/**
 * Renvoie le nombre de colonne d'affichage du contexte.
 *  Date de création : (31/01/2001 15:58:08)
 * @return int
 */
public int getNbCol() {
	return nbCol;
}
/**
 * Renvoie l'ensemble des valeurs du contexte.
 *  Date de création : (31/01/2001 12:05:58)
 * @return java.lang.String[]
 */
public java.lang.String[] getValue() {
	return value;
}
/**
 * Renvoie la chaine de caractère représentant le code HTML relatif au contexte.
 *  Date de création : (31/01/2001 10:51:14)
 * @return java.lang.String
 */
public String printHtml() {
	java.util.ResourceBundle rb = java.util.ResourceBundle.getBundle(getRes());
	StringBuffer sb = 
		new StringBuffer("<table border=\"0\" cellspacing=\"0\" cellpadding=\"0\">"); 
	
	sb.append("<tr>");
	sb.append("<td colspan=\"4\"><img src=\"");
	sb.append(rb.getString(ROOT_IMAGE));
	sb.append(getImgTitre());
	sb.append("\" height=\"16\" border=\"0\"></td>");
	sb.append("</tr>");
	
	sb.append("<tr>");
	sb.append("<td rowspan=\"3\" width=\"1\" background=\"");
	sb.append(rb.getString(ROOT_IMAGE));
	sb.append(rb.getString(CTX_IMG_FILET));
	sb.append("\"></td>");
	sb.append("<td valign=\"top\" width=\""+rb.getString(CTX_WIDTH)+"\"><img src=\"");
	sb.append(rb.getString(ROOT_IMAGE));
	sb.append(rb.getString(CTX_IMG_FILET));
	sb.append("\" width=\"100%\" height=\"1\" border=\"0\"></td>");
	sb.append("<td align=\"right\" valign=\"top\" colspan=\"2\"><img src=\"");
	sb.append(rb.getString(ROOT_IMAGE));
	sb.append(rb.getString(CTX_IMG_COINHAUT));
	sb.append("\" width=\"");
	sb.append(rb.getString(CTX_CORNER_SIZE));
	sb.append("\" height=\"");
	sb.append(rb.getString(CTX_CORNER_SIZE));
	sb.append("\" border=\"0\"></td>");
	sb.append("</tr>");
	
	sb.append("<tr>");
	sb.append("<td width=\"" + rb.getString(CTX_WIDTH) + "\">");
	sb.append("<table border=\"0\" cellspacing=\"0\" cellpadding=\"0\">");
	boolean firstLine = true;
	for (int i = 0; i < getLabel().length; i++) {
		if (i % getNbCol() == 0)
			sb.append("<tr>");
		sb.append("<td>");
		if (firstLine) {
			sb.append("<img src=\"");
			sb.append(rb.getString(ROOT_IMAGE));
			sb.append(rb.getString(CTX_IMG_BLANC));
			sb.append("\" width=\"5\" height=\"1\">");
		}
		sb.append("</td>");
		sb.append("<td class=\"");
		sb.append(rb.getString(CTX_PUCE_STYLE));
		sb.append("\"><img src=\"");
		sb.append(rb.getString(ROOT_IMAGE));
		sb.append(rb.getString(CTX_PUCE_IMG));
		sb.append("\"></td>");
		sb.append("<td>");
		if (firstLine) {
			sb.append("<img src=\"");
			sb.append(rb.getString(ROOT_IMAGE));
			sb.append(rb.getString(CTX_IMG_BLANC));
			sb.append("\" width=\"5\" height=\"1\">");
		}
		sb.append("</td>");
		sb.append("<td class=\"" + rb.getString(CTX_STYLE_NORMAL) + "\">");
		sb.append(getLabel()[i]);
		sb.append(" : ");
		sb.append(getValue()[i]);
		sb.append("</td>");
		if (i % getNbCol() == getNbCol() - 1) {
			sb.append("</tr>");
			firstLine = false;
		}
		if (i == getLabel().length - 1 && i % getNbCol() != getNbCol() - 1) {
			for (int k = 0; k < getNbCol() - i % getNbCol() - 1; k++)
				sb.append("<td></td><td></td><td></td><td></td>");
			sb.append("</tr>");
		}
	}
	sb.append("</table>");
	
	sb.append("<img src=\"");
	sb.append(rb.getString(ROOT_IMAGE));
	sb.append(rb.getString(CTX_IMG_BLANC));
	sb.append("\" width=\"5\" height=\"1\"></td>");
	sb.append("<td align=\"right\" width=\"5\"></td>") ;
	sb.append("<td align=\"right\" background=\"");
	sb.append(rb.getString(ROOT_IMAGE));
	sb.append(rb.getString(CTX_IMG_FILET));
	sb.append("\" width=\"1\"></td>");
	sb.append("</tr>");
	sb.append("<tr>");
	sb.append("<td valign=\"bottom\" width=\"");
	sb.append(rb.getString(CTX_WIDTH));
	sb.append("\"><img src=\"");
	sb.append(rb.getString(ROOT_IMAGE));
	sb.append(rb.getString(CTX_IMG_FILET));
	sb.append("\" width=\"100%\" height=\"1\" border=\"0\"></td>");
	sb.append("<td valign=\"bottom\" align=\"right\" colspan=\"2\"><img src=\"");
	sb.append(rb.getString(ROOT_IMAGE));
	sb.append(rb.getString(CTX_IMG_COINBAS));
	sb.append("\" width=\"");
	sb.append(rb.getString(CTX_CORNER_SIZE));
	sb.append("\" height=\"");
	sb.append(rb.getString(CTX_CORNER_SIZE));
	sb.append("\" border=\"0\"></td>");
	sb.append("</tr>");
	sb.append("</table>");
	return sb.toString();
}
/**
 * Mise à jour de l'image de titre.
 *  Date de création : (31/01/2001 16:56:11)
 * @param newImgTitre java.lang.String
 */
public void setImgTitre(java.lang.String newImgTitre) {
	imgTitre = newImgTitre;
}
/**
 * Mise à jour de l'ensemble des libellés.
 *  Date de création : (31/01/2001 12:05:37)
 * @param newLabel java.lang.String[]
 */
public void setLabel(java.lang.String[] newLabel) {
	label = newLabel;
}
/**
 * Mise à jour du nombre de colonne à l'affichage.
 *  Date de création : (31/01/2001 15:58:08)
 * @param newNbCol int
 */
public void setNbCol(int newNbCol) {
	nbCol = newNbCol;
}
/**
 * Mise à jour de l'ensemble des valeurs.
 *  Date de création : (31/01/2001 12:05:58)
 * @param newValue java.lang.String[]
 */
public void setValue(java.lang.String[] newValue) {
	value = newValue;
}
}
