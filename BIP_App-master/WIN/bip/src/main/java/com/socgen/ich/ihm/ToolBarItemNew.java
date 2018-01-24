package com.socgen.ich.ihm;

/**
 * Classe repr�sentant un �l�ment de la barre d'outils.
 *  Date de cr�ation : (30/01/2001 17:39:23)
 * @author : Yoann Grandgirard
 */
public class ToolBarItemNew extends IhmObject implements IhmValues {
	private java.lang.String image;
	private boolean visible = true;
	private java.lang.String link;
	private java.lang.String alt;
	// boolean indiquant si le lien de l'item doit �tre affich� dans la barre de status
	private boolean viewLink = false;
	private java.lang.String libelle;
	
/**
 * Constructeur par d�faut.
 */
public ToolBarItemNew() {
	super();
}
/**
 * Constructeur par d�faut.
 * @param res les ressources associ�es (nom de fichier sans l'extension)
 */
public ToolBarItemNew(String res) {
	super(res);
}
/**
 * Cr�ation d'un �l�ment de barre d'outils en utilisant tous les attributs et le fichier de resource par d�faut (ich_ihm.properties)
 *  Date de cr�ation : (31/01/2001 10:12:37)
 * @param img java.lang.String
 * @param lien java.lang.String
 * @param v boolean
 */
public ToolBarItemNew(String img, String a, String lien, boolean v) {
	super();
	setImage(img);
	setAlt(a);
	setLink(lien);
	setVisible(v);
}
/**
 * Cr�ation d'un �l�ment de barre d'outils en utilisant tous les attributs et le fichier de resource sp�cifi�.
 *  Date de cr�ation : (31/01/2001 10:54:10)
 * @param img java.lang.String
 * @param a java.lang.String
 * @param lien java.lang.String
 * @param v boolean
 * @param resource java.lang.String
 */
public ToolBarItemNew(String img, String a, String lien, boolean v, String resource, String libelle) {
	super(resource);
	setImage(img);
	setAlt(a);
	setLink(lien);
	setVisible(v);
	setLibelle(libelle);
}
/**
 * Renvoie la valeur du texte alternatif.
 *  Date de cr�ation : (31/01/2001 10:19:19)
 * @return java.lang.String
 */
public String getAlt() {
	return alt;
}
/**
 * Renvoie le nom di fichier image.
 *  Date de cr�ation : (30/01/2001 17:43:29)
 * @return java.lang.String
 */
public String getImage() {
	return image;
}
/**
 * Renvoie la valeur du lien associ� � l'�l�ment.
 *  Date de cr�ation : (30/01/2001 17:44:29)
 * @return java.lang.String
 */
public String getLink() {
	return link;
}
/**
 *	Indique si l'�l�ment est visible ou non.
 *  Date de cr�ation : (30/01/2001 17:43:57)
 * @return boolean
 */ 
public boolean isVisible() {
	return visible;
}
/**
 * Renvoie la valeur du libelle.
 *  Date de cr�ation : (31/01/2001 10:19:19)
 * @return java.lang.String
 */
public String getLibelle() {
	return libelle;
}
/**
 * Renvoie la chaine de caract�re repr�sentant le code HTML relatif � l'�l�ment de barre d'outils.
 *  Date de cr�ation : (30/01/2001 17:47:20)
 * @return java.lang.String
 */
public String printHtml() {
	java.util.ResourceBundle rb = java.util.ResourceBundle.getBundle(getRes());
	StringBuffer sb = new StringBuffer("<a href=\"");
	sb.append(getLink());
	sb.append("\"");
	if (isViewLink()==false)
		sb.append(" onmouseover=\"window.status='';return true\" ");
	sb.append(" >");
	sb.append(getLibelle());
	sb.append("</a>");
	return sb.toString();
}
/**
 * Mise � jour du texte alternatif.
 *  Date de cr�ation : (31/01/2001 10:19:19)
 * @param newAlt java.lang.String
 */
public void setAlt(String newAlt) {
	alt = newAlt;
}
/**
 * Mise � jour du fichier image.
 *  Date de cr�ation : (30/01/2001 17:43:29)
 * @param newImage java.lang.String
 */
public void setImage(String newImage) {
	image = newImage;
}
/**
 * Mise � jour du lien.
 *  Date de cr�ation : (30/01/2001 17:44:29)
 * @param newLink java.lang.String
 */
public void setLink(String newLink) {
	link = newLink;
}
/**
 * Masquage ou d�masquage de l'�l�ment.
 *  Date de cr�ation : (30/01/2001 17:43:57)
 * @param newVisible boolean
 */
public void setVisible(boolean newVisible) {
	visible = newVisible;
}
	/**
	 * @return
	 */
	public boolean isViewLink() {
		return viewLink;
	}

	/**
	 * @param b
	 */
	public void setViewLink(boolean b) {
		viewLink = b;
	}
	
/**
 * Mise � jour du libelle.
 *  Date de cr�ation : (31/01/2001 10:19:19)
 * @param newAlt java.lang.String
 */
public void setLibelle(String newLibelle) {
	libelle = newLibelle;
}

}
