package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import com.socgen.bip.commun.form.AutomateForm;
import com.socgen.bip.metier.InfosPersonne;

/**
 * @author FAD - 29/02/2016 PPM 63560 : Duplication de l'Action RecupDPGAction
 * pour récupérer un code DPG ouvert ou ferme via une
 *         fenêtre Popup
 */
public class RecupDPGOuvertFermeForm extends AutomateForm
{
	private String nomRecherche ;
	private InfosPersonne[] listeNomsDpg;

	private String windowTitle ;
	public String nomChampDestinataire;
	public String habilitationPage;
	public  String rafraichir;	

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
	public InfosPersonne[] getListeNomsDpg() {
		return listeNomsDpg;
	}

	/**
	 * @param personnes
	 */
	public void setListeNomsDpg(InfosPersonne[] personnes) {
		listeNomsDpg = personnes;
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

	public void removeListe(HttpServletRequest request){
		(request.getSession(false)).removeAttribute("listeRechercheId");	
	}
}