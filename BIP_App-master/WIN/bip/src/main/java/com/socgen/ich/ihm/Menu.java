package com.socgen.ich.ihm;

/**
 * Objet menu.
 * Creation date: (27/12/00 09:40:26)
 * @author: Yoann Grandgirard
 */
public class Menu extends IhmObject {
	private MenuItem[] elem = null;
	private boolean vertical = false;
/**
 * Constructeur par d�faut.
 */
public Menu() {
	super();
}
/**
 * Cr�ation d'un menu vide en sp�cifiant le fichier de resource � utiliser.
 *  Date de cr�ation : (23/01/2001 17:08:45)
 * @param param java.lang.String
 */
public Menu(String param) {
	super(param);
}
/**
 * Ajout d'un �l�ment de menu.
 * Creation date: (27/12/00 10:53:10)
 * @param label java.lang.String
 * @param link java.lang.String
 */
public void addMenuItem(MenuItem item) {
	item.setVertical(isVertical());
	if (getElem() == null) {
		elem = new MenuItem[1];
		elem[0]= item;
	} else {
		int i;
		MenuItem[] newElem = new MenuItem[getElem().length + 1];
		for (i = 0; i < getElem().length; i++) {
			newElem[i] = getElem()[i];
		}
		newElem[i]= item;
		setElem(newElem);
	}
}
/**
 * Renvoie l'ensemble des �l�ments constituant le menu.
 * Creation date: (27/12/00 10:39:28)
 * @return com.socgen.dlg.lib.ihm.MenuRubrique[]
 */
public MenuItem[] getElem() {
	return elem;
}
/**
 * Renvoie le code HTML correspondant � l'ent�te du menu.
 * Creation date: (27/12/00 13:44:13)
 * @return java.lang.String
 */
public String getMenuBegin() {
	return "";
}
/**
 * Renvoie le code HTML correspondant � la fin du menu.
 * Creation date: (27/12/00 13:44:13)
 * @return java.lang.String
 */
public String getMenuEnd() {
	return "";
}
/**
 * Renvoie le code HTML correspondant au s�p�rateur entre les �l�ments du menu.
 * Creation date: (27/12/00 09:45:55)
 * @return java.lang.String
 */
public String getMenuSeparator() {
	return "";
}
/**
 * Renvoie l'indicateur de verticalit� du menu.
 * Creation date: (29/12/00 10:25:58)
 * @return boolean
 */
public boolean isVertical() {
	return vertical;
}
/**
 * Renvoie la chaine de caract�re repr�sentant le code HTML relatif au menu.
 * Creation date: (27/12/00 09:41:22)
 * @return java.lang.String
 */
public String printHtml() {
	String horizSubMenu = "";
	StringBuffer sb = new StringBuffer();
	sb.append(getMenuBegin());
	for (int i = 0; i < getElem().length; i++) {
		sb.append(getMenuSeparator());
		sb.append((getElem()[i]).printHtml());
		if (getElem()[i].isSelect())
			if (getElem()[i].isVertical()) {
				sb.append(getMenuSeparator());
				sb.append(getElem()[i].getSubMenuHtml());
			} else
				horizSubMenu = getElem()[i].getSubMenuHtml();
	}
	sb.append(getMenuSeparator());
	sb.append(horizSubMenu);
	sb.append(getMenuEnd());
	return sb.toString();
}
/**
 * Supprime le dernier �l�ment de menu.
 * Creation date: (28/12/00 12:08:48)
 */
public void removeLast() {
	MenuItem[] newElem = new MenuItem[getElem().length-1];
	for (int i = 0; i < newElem.length;i++) {
		newElem[i] = getElem()[i];
	}
	setElem(newElem);
}
/**
 * Mise � jour de l'�l�ment de menu n�i.
 * Creation date: (27/12/00 11:54:44)
 * @param i int
 */
public void selectItemAt(int i) {
	if (i < getElem().length) {
		getElem()[i].setSelect(true);
	}
}
/**
 * Mise � jour de l'ensemble des �l�ments de menu.
 * Creation date: (27/12/00 10:39:28)
 * @param newElem com.socgen.dlg.lib.ihm.MenuRubrique[]
 */
public void setElem(MenuItem[] newElem) {
	elem = newElem;
}
/**
 * Mise � jour du fichier ressource utilis� pour l'objet menu et aussi pour l'ensemble des �l�ments le composant.
 *  Date de cr�ation : (23/01/2001 16:35:19)
 * @param newRes java.lang.String
 */
public void setRes(java.lang.String newRes) {
	super.setRes(newRes);
		if (getElem() != null)
		for (int i = 0; i < getElem().length; i++) {
			getElem()[i].setRes(getRes());
		}
}
/**
 * Mise � jour de l'indicateur de verticalit� pour l'objet menu et aussi pour l'ensemble des �l�ments le composant.
 * Creation date: (29/12/00 10:25:58)
 * @param newVertical boolean
 */
public void setVertical(boolean newVertical) {
	vertical = newVertical;
	if (getElem() != null)
		for (int i = 0; i < getElem().length; i++) {
			getElem()[i].setVertical(isVertical());
		}
}
}
