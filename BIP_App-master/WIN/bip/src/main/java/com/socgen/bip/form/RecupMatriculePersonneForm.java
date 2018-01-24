package com.socgen.bip.form;

/**
 * JAL 23-04-2007
 * focntionnalité recherche de matricules d'aprés les premières lettres du nom
 * 
 */
import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author JAL - 23/04/2007
 *
 * Formulaire pour la récupération des nom,prénom et matricule d'une personne
 * 
 */

import com.socgen.bip.metier.*;

import javax.servlet.http.HttpServletRequest;

public class RecupMatriculePersonneForm extends AutomateForm
{
	private String nomRecherche ;
	private String nom ; 
	private String prenom ; 
	private InfosPersonne[] listeNomsDpg;

	private String windowTitle ;
	

	public String nomChampDestinataireMatricule;
	public String nomChampDestinataireNomPrenom ; 


	
	
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
	 * 
	 * @param request
	 */
	public void removeListe(HttpServletRequest request){
		(request.getSession(false)).removeAttribute("listeRechercheId");	
	}

	/**
	 * 
	 * @return
	 */
	public String getNomChampDestinataireMatricule() {
		return this.nomChampDestinataireMatricule;
	}

	/**
	 * 
	 * @param nomChampDestinataireMatricule
	 */
	public void setNomChampDestinataireMatricule(
			String nomChampDestinataireMatricule) {
		this.nomChampDestinataireMatricule = nomChampDestinataireMatricule;
	}

	/**
	 * 
	 * @return
	 */
	public String getNomChampDestinataireNomPrenom() {
		return nomChampDestinataireNomPrenom;
	}

	/**
	 * 
	 * @param nomChampDestinataireNomPrenom
	 */
	public void setNomChampDestinataireNomPrenom(
			String nomChampDestinataireNomPrenom) {
		this.nomChampDestinataireNomPrenom = nomChampDestinataireNomPrenom;
	}

	public String getNom() {
		return nom;
	}

	public void setNom(String nom) {
		this.nom = nom;
	}

	public String getPrenom() {
		return prenom;
	}

	public void setPrenom(String prenom) {
		this.prenom = prenom;
	}


	
}