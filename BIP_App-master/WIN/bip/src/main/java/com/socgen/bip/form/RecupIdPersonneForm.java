/*
 * Créé le 22 juin 05
 *
 * Pour changer le modèle de ce fichier généré, allez à :
 * Fenêtre&gt;Préférences&gt;Java&gt;Génération de code&gt;Code et commentaires
 */
package com.socgen.bip.form;



import javax.servlet.http.HttpServletRequest;

import com.socgen.bip.commun.form.AutomateForm;
import com.socgen.bip.metier.InfosPersonne;

public class RecupIdPersonneForm extends AutomateForm{

private String nomRecherche ;
private String rtype ;
private String soccont ;
private String lresdeb ;
private String lresfin ;
private String cav ;
private String numcont ;
private InfosPersonne[] listeNomsCdp;

public  String rafraichir;

private String windowTitle ;
public String nomChampDestinataire;
public String nomChampDestinataire2;
public String nomChampDestinataire3;
public String habilitationPage;



 
 
 

public String getRafraichir() {
	return rafraichir;
}


public void setRafraichir(String rafraichir) {
	this.rafraichir = rafraichir;
}


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
public String getRtype() {
	return rtype;
}


/**
 * @param string
 */
public void setRtype(String string) {
	rtype = string;
}




/**
 * @return
 */
public InfosPersonne[] getListeNomsCdp() {
	return listeNomsCdp;
}

/**
 * @param personnes
 */
public void setListeNomsCdp(InfosPersonne[] personnes) {
	listeNomsCdp = personnes;
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


public String getNomChampDestinataire2() {
	return nomChampDestinataire2;
}


public void setNomChampDestinataire2(String nomChampDestinataire2) {
	this.nomChampDestinataire2 = nomChampDestinataire2;
}


public String getNomChampDestinataire3() {
	return nomChampDestinataire3;
}


public void setNomChampDestinataire3(String nomChampDestinataire3) {
	this.nomChampDestinataire3 = nomChampDestinataire3;
}


public String getLresdeb() {
	return lresdeb;
}


public void setLresdeb(String lresdeb) {
	this.lresdeb = lresdeb;
}


public String getLresfin() {
	return lresfin;
}


public void setLresfin(String lresfin) {
	this.lresfin = lresfin;
}


public String getSoccont() {
	return soccont;
}


public void setSoccont(String soccont) {
	this.soccont = soccont;
}

public String getCav() {
	return cav;
}

public void setCav(String cav) {
	this.cav = cav;
}

public String getNumcont() {
	return numcont;
}

public void setNumcont(String numcont) {
	this.numcont = numcont;
}

}