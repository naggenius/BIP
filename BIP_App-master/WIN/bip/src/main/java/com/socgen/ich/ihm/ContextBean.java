package com.socgen.ich.ihm;

/**
 * Bean utilis� pour le stockage en session des �l�ments n�cessaires aux diff�rents objets de l'IHM.
 * Creation date: (02/01/01 09:58:38)
 * @author: Yoann Grandgirard
 */
public class ContextBean {
	private boolean FullScreen = false;
/**
 * Constructeur par d�faut.
 */
public ContextBean() {
	super();
}
/**
 * Test logique du mode plein �cran.
 * Creation date: (02/01/01 09:59:17)
 * @return boolean
 */
public boolean isFullScreen() {
	return FullScreen;
}
/**
 * Mise � jour de l'indicateur plein �cran.
 * Creation date: (02/01/01 09:59:17)
 * @param newFullScreen boolean
 */
public void setFullScreen(boolean newFullScreen) {
	FullScreen = newFullScreen;
}
}
