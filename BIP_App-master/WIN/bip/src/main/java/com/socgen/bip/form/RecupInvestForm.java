
package com.socgen.bip.form;



import javax.servlet.http.HttpServletRequest;

import com.socgen.bip.commun.form.AutomateForm;
import com.socgen.bip.metier.InfosInvestissement;


public class RecupInvestForm extends AutomateForm{

private String nomRecherche ;

private String windowTitle ;
public String nomChampDestinataire;
public String habilitationPage;

public InfosInvestissement[] listeRechercheInvest;
public String rafraichir;
 
 

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



public InfosInvestissement[] getListeRechercheInvest() {
	return listeRechercheInvest;
}


public void setListeRechercheInvest(InfosInvestissement[] listeRechercheInvest) {
	this.listeRechercheInvest = listeRechercheInvest;
}


public void removeListe(HttpServletRequest request){
(request.getSession(false)).removeAttribute("listeRechercheId");	
}


}