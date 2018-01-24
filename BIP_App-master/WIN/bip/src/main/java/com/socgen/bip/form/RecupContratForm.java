package com.socgen.bip.form;



import javax.servlet.http.HttpServletRequest;

import com.socgen.bip.commun.form.AutomateForm;
import com.socgen.bip.metier.InfosContrat;

public class RecupContratForm extends AutomateForm
{

private String typeContrat;//contrat ou avenant
private String soccont;
private String nomRecherche;
private String nomRessource;
private String contratEncours;//OUI ou NON


private InfosContrat[] listecontrat;

private String windowTitle ;
public  String nomChampDestinataire;
public  String nomChampDestinataire2;
public  String habilitationPage;

private boolean isEmptyResult;

 
/**
 * @return
 */
public String getTypeContrat() {
	return typeContrat;
}

/**
 * @param string
 */
public void setTypeContrat(String string) {
	typeContrat = string;
} 

 
 
 
/**
 * @return
 */
public String getSoccont() {
	return soccont;
}

/**
 * @param string
 */
public void setSoccont(String string) {
	soccont = string;
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
public String getNomRessource() {
	return nomRessource;
}


/**
 * @param string
 */
public void setNomRessource(String string) {
	nomRessource = string;
}




/**
 * @param string
 */
public void setContratEncours(String string) {
	 contratEncours = string;
}



/**
 * @return
 */
public String getContratEncours() {
	return contratEncours;
}


/**
 * @return
 */
public String getNomChampDestinataire() {
	return nomChampDestinataire;
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
public String getNomChampDestinataire2() {
	return nomChampDestinataire2;
}



/**
 * @param string
 */
public void setNomChampDestinataire2(String string) {
	nomChampDestinataire2 = string;
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
public InfosContrat[] getListeContrat() {
	return listecontrat;
}

/**
 * @param cas
 */
public void setListeMo(InfosContrat[] cas) {
	listecontrat = cas;
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