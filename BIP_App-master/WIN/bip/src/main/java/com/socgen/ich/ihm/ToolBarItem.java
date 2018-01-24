package com.socgen.ich.ihm;

/**
 * Classe représentant un élément de la barre d'outils.
 *  Date de création : (30/01/2001 17:39:23)
 * @author : Yoann Grandgirard
 */
public class ToolBarItem extends IhmObject implements IhmValues {
	private java.lang.String image;
	private boolean visible = true;
	private java.lang.String link;
	private java.lang.String alt;
	// boolean indiquant si le lien de l'item doit être affiché dans la barre de status
	private boolean viewLink = false;
	
/**
 * Constructeur par défaut.
 */
public ToolBarItem() {
	super();
}
/**
 * Constructeur par défaut.
 * @param res les ressources associées (nom de fichier sans l'extension)
 */
public ToolBarItem(String res) {
	super(res);
}
/**
 * Création d'un élément de barre d'outils en utilisant tous les attributs et le fichier de resource par défaut (ich_ihm.properties)
 *  Date de création : (31/01/2001 10:12:37)
 * @param img java.lang.String
 * @param lien java.lang.String
 * @param v boolean
 */
public ToolBarItem(String img, String a, String lien, boolean v) {
	super();
	setImage(img);
	setAlt(a);
	setLink(lien);
	setVisible(v);
}
/**
 * Création d'un élément de barre d'outils en utilisant tous les attributs et le fichier de resource spécifié.
 *  Date de création : (31/01/2001 10:54:10)
 * @param img java.lang.String
 * @param a java.lang.String
 * @param lien java.lang.String
 * @param v boolean
 * @param resource java.lang.String
 */
public ToolBarItem(String img, String a, String lien, boolean v, String resource) {
	super(resource);
	setImage(img);
	setAlt(a);
	setLink(lien);
	setVisible(v);
}
/**
 * Renvoie la valeur du texte alternatif.
 *  Date de création : (31/01/2001 10:19:19)
 * @return java.lang.String
 */
public String getAlt() {
	return alt;
}
/**
 * Renvoie le nom di fichier image.
 *  Date de création : (30/01/2001 17:43:29)
 * @return java.lang.String
 */
public String getImage() {
	return image;
}
/**
 * Renvoie la valeur du lien associé à l'élément.
 *  Date de création : (30/01/2001 17:44:29)
 * @return java.lang.String
 */
public String getLink() {
	return link;
}
/**
 *	Indique si l'élément est visible ou non.
 *  Date de création : (30/01/2001 17:43:57)
 * @return boolean
 */ 
public boolean isVisible() {
	return visible;
}
/**
 * Renvoie la chaine de caractère représentant le code HTML relatif à l'élément de barre d'outils.
 *  Date de création : (30/01/2001 17:47:20)
 * @return java.lang.String
 */
public String printHtml() {
	java.util.ResourceBundle rb = java.util.ResourceBundle.getBundle(getRes());
	StringBuffer sb = new StringBuffer("<a href=\"");
	sb.append(getLink());
	sb.append("\"");
	if (isViewLink()==false)
		sb.append(" onmouseover=\"window.status='';return true\" ");
	sb.append(" ><img src=\"");
	sb.append(rb.getString(ROOT_IMAGE) + getImage());
	sb.append("\" border=\"0\" alt=\"");
	sb.append(getAlt());
	sb.append("\"></a>");
	return sb.toString();
}
/**
 * Mise à jour du texte alternatif.
 *  Date de création : (31/01/2001 10:19:19)
 * @param newAlt java.lang.String
 */
public void setAlt(String newAlt) {
	alt = newAlt;
}
/**
 * Mise à jour du fichier image.
 *  Date de création : (30/01/2001 17:43:29)
 * @param newImage java.lang.String
 */
public void setImage(String newImage) {
	image = newImage;
}
/**
 * Mise à jour du lien.
 *  Date de création : (30/01/2001 17:44:29)
 * @param newLink java.lang.String
 */
public void setLink(String newLink) {
	link = newLink;
}
/**
 * Masquage ou démasquage de l'élément.
 *  Date de création : (30/01/2001 17:43:57)
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

}
