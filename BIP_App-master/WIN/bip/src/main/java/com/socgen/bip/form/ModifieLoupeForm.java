/*
 * Créé 08/08/2008 par JAL
 */
package com.socgen.bip.form;

import com.socgen.bip.commun.form.AutomateForm;
import com.socgen.bip.metier.InfosDpCopi;

public class ModifieLoupeForm extends AutomateForm
{
	private String  libelle ;
	private String  codeAxeModifier ; 

	private String windowTitle ;
	public String nomChampDestinataire;
	public String habilitationPage;
	

	
	private String nomRecherche ;
	private InfosDpCopi[] listeLibellesDpCopi;

	private String type;
		
	public  String rafraichir;	
	
	private String code ; 
	
	private String majTermine ; 
	
	
	/**
	 * Procédure à appeller pour l'Update
	 * 
	 */
	private String updateProcedure ; 
    
	
	public String getLibelle() {
		return libelle;
	}

	public void setLibelle(String libelle) {
		this.libelle = libelle;
	}

	public String getHabilitationPage() {
		return habilitationPage;
	}

	public void setHabilitationPage(String habilitationPage) {
		this.habilitationPage = habilitationPage;
	}

	public String getNomChampDestinataire() {
		return nomChampDestinataire;
	}

	public void setNomChampDestinataire(String nomChampDestinataire) {
		this.nomChampDestinataire = nomChampDestinataire;
	}

	public String getWindowTitle() {
		return windowTitle;
	}

	public void setWindowTitle(String windowTitle) {
		this.windowTitle = windowTitle;
	}

	public String getCodeAxeModifier() {
		return codeAxeModifier;
	}

	public void setCodeAxeModifier(String codeAxeModifier) {
		this.codeAxeModifier = codeAxeModifier;
	}

	public InfosDpCopi[] getListeLibellesDpCopi() {
		return listeLibellesDpCopi;
	}

	public void setListeLibellesDpCopi(InfosDpCopi[] listeLibellesDpCopi) {
		this.listeLibellesDpCopi = listeLibellesDpCopi;
	}

	public String getNomRecherche() {
		return nomRecherche;
	}

	public void setNomRecherche(String nomRecherche) {
		this.nomRecherche = nomRecherche;
	}

	public String getRafraichir() {
		return rafraichir;
	}

	public void setRafraichir(String rafraichir) {
		this.rafraichir = rafraichir;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getMajTermine() {
		return majTermine;
	}

	public void setMajTermine(String majTermine) {
		this.majTermine = majTermine;
	}

	public String getUpdateProcedure() {
		return updateProcedure;
	}

	public void setUpdateProcedure(String updateProcedure) {
		this.updateProcedure = updateProcedure;
	}

 
 
	
	 
	
}