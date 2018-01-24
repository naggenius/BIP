/*
 * Créé le 22 juin 05
 *
 * Pour changer le modèle de ce fichier généré, allez à :
 * Fenêtre&gt;Préférences&gt;Java&gt;Génération de code&gt;Code et commentaires
 */
package com.socgen.bip.metier;

/**
 * @author x054232
 *
 * Pour changer le modèle de ce commentaire de type généré, allez à :
 * Fenêtre&gt;Préférences&gt;Java&gt;Génération de code&gt;Code et commentaires
 */
public class Niveau {
	
	private String codeNiveau;
	private String libelleNiveau;


	/**
	 * 
	 */
	public Niveau() {
		super();

	}
	
	/**
	 * 
	 */
	public Niveau(Niveau newNivau) {
		this.codeNiveau = newNivau.getCodeNiveau();
		this.libelleNiveau = newNivau.getLibelleNiveau();

	}
	
	/**
	 * 
	 */
	public Niveau(String p_codeNiveau, String p_libelleNiveau) {
		this.codeNiveau = p_codeNiveau;
		this.libelleNiveau = p_libelleNiveau;

	}
	



	/**
	 * @return
	 */
	public String getCodeNiveau() {
		return codeNiveau;
	}

	/**
	 * @return
	 */
	public String getLibelleNiveau() {
		return libelleNiveau;
	}

	/**
	 * @param string
	 */
	public void setCodeNiveau(String string) {
		codeNiveau = string;
	}

	/**
	 * @param string
	 */
	public void setLibelleNiveau(String string) {
		libelleNiveau = string;
	}

}
