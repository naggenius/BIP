package com.socgen.bip.form;



import javax.servlet.http.HttpServletRequest;

import com.socgen.bip.commun.form.AutomateForm;
import com.socgen.bip.metier.InfosFacture;

public class RecupFactureForm extends AutomateForm
{

private String typeFacture;//F ou A
private String socfact;
private String nomRessource;
private String contrat;
private String factureEncours;//OUI ou NON


private InfosFacture[] listefacture;

private String windowTitle ;
public  String nomChampDestinataire;
public  String nomChampDestinataire2;
public  String habilitationPage;

private boolean isEmptyResult;

 
/**
 * @return
 */
public String getTypeFacture() {
	return typeFacture;
}

/**
 * @param string
 */
public void setTypeFacture(String string) {
	typeFacture = string;
} 

 
/**
 * @return
 */
public String getContrat() {
	return contrat;
}

/**
 * @param string
 */
public void setContrat(String string) {
	contrat = string;
} 
 
 
/**
 * @return
 */
public String getSocfact() {
	return socfact;
}

/**
 * @param string
 */
public void setSocfact(String string) {
	socfact = string;
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
public void setFactureEncours(String string) {
	 factureEncours = string;
}



/**
 * @return
 */
public String getFactureEncours() {
	return factureEncours;
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
public InfosFacture[] getListeFacture() {
	return listefacture;
}

/**
 * @param cas
 */
public void setListeMo(InfosFacture[] cas) {
	listefacture = cas;
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