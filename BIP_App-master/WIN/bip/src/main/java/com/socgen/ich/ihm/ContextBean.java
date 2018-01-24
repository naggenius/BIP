package com.socgen.ich.ihm;

/**
 * Bean utilisé pour le stockage en session des éléments nécessaires aux différents objets de l'IHM.
 * Creation date: (02/01/01 09:58:38)
 * @author: Yoann Grandgirard
 */
public class ContextBean {
	private boolean FullScreen = false;
/**
 * Constructeur par défaut.
 */
public ContextBean() {
	super();
}
/**
 * Test logique du mode plein écran.
 * Creation date: (02/01/01 09:59:17)
 * @return boolean
 */
public boolean isFullScreen() {
	return FullScreen;
}
/**
 * Mise à jour de l'indicateur plein écran.
 * Creation date: (02/01/01 09:59:17)
 * @param newFullScreen boolean
 */
public void setFullScreen(boolean newFullScreen) {
	FullScreen = newFullScreen;
}
}
