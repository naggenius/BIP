package com.socgen.ich.ihm;

/**
 * Classe générique d'un objet de l'IHM.
 *  Date de création : (23/01/2001 16:22:01)
 * @author : Yoann Grandgirard
 */
public abstract class IhmObject {
	private String res = "ich_ihm";
/**
 * Constructeur par défaut.
 */
public IhmObject() {
	super();
}
/**
 * Création d'un objet en utilisant un fichier de resource spécifique.
 *  Date de création : (23/01/2001 17:08:45)
 * @param param java.lang.String
 */
public IhmObject(String param) {
	setRes(param);
}
/**
 * Récupération du nom du fichier ressource utilisé par l'objet.
 *  Date de création : (23/01/2001 16:35:19)
 * @return java.lang.String
 */
public java.lang.String getRes() {
	return res;
}
/**
 * Renvoie la chaine de caractère représentant le code HTML relatif à cette classe.
 *  Date de création : (31/01/2001 10:51:14)
 * @return java.lang.String
 */
public abstract String printHtml();
/**
 * Mise à jour du nom du fichier de resource à utiliser par l'objet.
 *  Date de création : (23/01/2001 16:35:19)
 * @param newRes java.lang.String
 */
public void setRes(String newRes) {
	res = newRes;
}
}
