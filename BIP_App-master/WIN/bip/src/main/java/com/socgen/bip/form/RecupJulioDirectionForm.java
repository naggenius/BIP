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

public class RecupJulioDirectionForm extends AutomateForm{

private String nomRecherche ;
private String rtype ;
private InfosPersonne[] listeNomsCdp;

private String windowTitle ;
public String nomChampDestinataire;
public String habilitationPage;



 
 
 

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


}