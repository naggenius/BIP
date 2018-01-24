/*
 * Créé le 22 juin 05
 *
 * Pour changer le modèle de ce fichier généré, allez à :
 * Fenêtre&gt;Préférences&gt;Java&gt;Génération de code&gt;Code et commentaires
 */
package com.socgen.bip.form;



import javax.servlet.http.HttpServletRequest;

import com.socgen.bip.commun.form.AutomateForm;
import com.socgen.bip.metier.InfosCa;

public class RecupIdrubriqueForm extends AutomateForm{

private String nomRecherche ;
private InfosCa[] listeCa;

private String windowTitle ;
public String nomChampDestinataire;
public String habilitationPage;
public String rafraichir;

private boolean isEmptyResult;
 

/**
 * @return
 */
public String getNomRecherche() {
	return nomRecherche;
}


/**
 * @param string
 */
public void setNomRecherche(String string) {
	nomRecherche = string;
}



/**
 * @return
 */
public String getNomChampDestinataire() {
	return nomChampDestinataire;
}

/**
 * @return
 */
public String getWindowTitle() {
	return windowTitle;
}

/**
 * @param string
 */
public void setNomChampDestinataire(String string) {
	nomChampDestinataire = string;
}

/**
 * @return
 */
public String getRafraichir() {
	return rafraichir;
}
/**
 * @param string
 */
public void setRafraichir(String string) {
	rafraichir = string;
}

/**
 * @param string
 */
public void setWindowTitle(String string) {
	windowTitle = string;
}

/**
 * @return
 */
public String getHabilitationPage() {
	return habilitationPage;
}

/**
 * @param string
 */
public void setHabilitationPage(String string) {
	habilitationPage = string;
}

public void removeListe(HttpServletRequest request){
(request.getSession(false)).removeAttribute("listeRechercheId");	
}


/**
 * @return
 */
public InfosCa[] getListeCa() {
	return listeCa;
}

/**
 * @param cas
 */
public void setListeCa(InfosCa[] cas) {
	listeCa = cas;
}



/**
 * @return
 */
public boolean isEmptyResult() {
	return isEmptyResult;
}

/**
 * @param b
 */
public void setEmptyResult(boolean b) {
	isEmptyResult = b;
}

}