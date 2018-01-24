package com.socgen.bip.form;



import javax.servlet.http.HttpServletRequest;

import com.socgen.bip.commun.form.AutomateForm;
import com.socgen.bip.metier.InfosMo;

public class RecupIdMoForm extends AutomateForm
{

private String nomRecherche ;
private InfosMo[] listeMo;

private String windowTitle ;
public  String nomChampDestinataire;
public  String rafraichir;
public  String habilitationPage;

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
public String getRafraichir() {
	return rafraichir;
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
public InfosMo[] getListeMo() {
	return listeMo;
}

/**
 * @param cas
 */
public void setListeMo(InfosMo[] cas) {
	listeMo = cas;
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