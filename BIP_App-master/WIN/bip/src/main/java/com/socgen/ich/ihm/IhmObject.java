package com.socgen.ich.ihm;

/**
 * Classe g�n�rique d'un objet de l'IHM.
 *  Date de cr�ation : (23/01/2001 16:22:01)
 * @author : Yoann Grandgirard
 */
public abstract class IhmObject {
	private String res = "ich_ihm";
/**
 * Constructeur par d�faut.
 */
public IhmObject() {
	super();
}
/**
 * Cr�ation d'un objet en utilisant un fichier de resource sp�cifique.
 *  Date de cr�ation : (23/01/2001 17:08:45)
 * @param param java.lang.String
 */
public IhmObject(String param) {
	setRes(param);
}
/**
 * R�cup�ration du nom du fichier ressource utilis� par l'objet.
 *  Date de cr�ation : (23/01/2001 16:35:19)
 * @return java.lang.String
 */
public java.lang.String getRes() {
	return res;
}
/**
 * Renvoie la chaine de caract�re repr�sentant le code HTML relatif � cette classe.
 *  Date de cr�ation : (31/01/2001 10:51:14)
 * @return java.lang.String
 */
public abstract String printHtml();
/**
 * Mise � jour du nom du fichier de resource � utiliser par l'objet.
 *  Date de cr�ation : (23/01/2001 16:35:19)
 * @param newRes java.lang.String
 */
public void setRes(String newRes) {
	res = newRes;
}
}
