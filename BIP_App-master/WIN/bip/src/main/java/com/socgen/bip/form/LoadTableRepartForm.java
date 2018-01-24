package com.socgen.bip.form;

import org.apache.struts.upload.FormFile;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author J. MAS - 07/11/2005
 *
 * Formulaire de chargement des tables de r�partition
 * chemin : Lignes BIP/R�partition JH/Chargement
 * pages  : rLoadTableRepart.jsp
 * pl/sql : 
 * 
 * Modifi� par DDI le 30/01/2006 : Ajout du type de table de r�partition (typtab)
 * Modifi� par DDI le 01/08/2006 : Ajout du mois de fin de r�partition   (moisfin), TD452.
 */
public class LoadTableRepartForm extends AutomateForm {
         
	/*
	 * Code Table de r�partition
	 */
	private String codrep;

	/*
	 * Mois de la Table de r�partiton � charger
	 */
	private String moisrep;
	
	/*
	 * Mois de fin de la Table de r�partiton � charger (optionnel)
	 */
	private String moisfin;	
	
	/*
	 * Fichier � charger
	 */
	private FormFile nomfichier;
	
	
	/*
	 * Exercice courant
	 */
    private int datdebex; 
    
    
    /*
     * Lien vers le rapport du chargement
     */
    private String lienRapport;
    
	/*
	 * Type de table de r�partition ( "P": Propos�s ; "A": Arbitr�s )
	 */
	private String typtab;
	
     /**
	 * Constructor for ClientForm.
	 */
	public LoadTableRepartForm() {
		super();
	}
	
	/**
	 * @return
	 */
	public String getCodrep() {
		return codrep;
	}

	/**
	 * @return
	 */
	public String getMoisrep() {
		return moisrep;
	}

	/**
	 * @param string
	 */
	public void setCodrep(String string) {
		codrep = string;
	}

	/**
	 * @param string
	 */
	public void setMoisrep(String string) {
		moisrep = string;
	}

	/**
	 * @return
	 */
	public FormFile getNomfichier() {
		return nomfichier;
	}

	/**
	 * @param file
	 */
	public void setNomfichier(FormFile file) {
		nomfichier = file;
	}

	/**
	 * @return
	 */
	public int getDatdebex() {
		return datdebex;
	}

	/**
	 * @param i
	 */
	public void setDatdebex(int i) {
		datdebex = i;
	}

	/**
	 * @return
	 */
	public String getLienRapport() {
		return lienRapport;
	}

	/**
	 * @param string
	 */
	public void setLienRapport(String string) {
		lienRapport = string;
	}

	/**
	 * @return
	 */
	public String getTyptab() {
		return typtab;
	}	

	/**
	 * @param string
	 */
	public void setTyptab(String string) {
		typtab = string;
	}	

	/**
	 * @return
	 */
	public String getMoisfin() {
		return moisfin;
	}

	/**
	 * @param string
	 */
	public void setMoisfin(String string) {
		moisfin = string;
	}
}
