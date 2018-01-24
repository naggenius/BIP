package com.socgen.bip.metier;

/**
 * @author N.BACCAM - 03/09/2003
 *
 * Classe qui instancie un filtre pour les extraction paramétrées
 */
public class FiltreRequete {
	private String libelle;
	private String type;
	private String obligatoire;
	private String code;
	private String longueur;
	private String valeur;
	private String textSql;

	/**
	 * Constructor for FiltreRequete.
	 */
	public FiltreRequete() {
		super();
	}
    /**
	 * Constructor for FiltreRequete.
	 */
	public FiltreRequete(String sLibelle,String sCode,String sType,String sLongueur,String sObligatoire,String sTextSql) {
		super();
		this.libelle = sLibelle;
		this.code = sCode;
		this.type = sType;
		this.longueur = sLongueur;
		this.obligatoire = sObligatoire;
		this.textSql=sTextSql;
	}
	/**
	 * Returns the code.
	 * @return String
	 */
	public String getCode() {
		return code;
	}

	/**
	 * Returns the libelle.
	 * @return String
	 */
	public String getLibelle() {
		return libelle;
	}

	/**
	 * Returns the longueur.
	 * @return String
	 */
	public String getLongueur() {
		return longueur;
	}

	/**
	 * Returns the obligatoire.
	 * @return String
	 */
	public String getObligatoire() {
		return obligatoire;
	}

	/**
	 * Returns the type.
	 * @return String
	 */
	public String getType() {
		return type;
	}

	/**
	 * Sets the code.
	 * @param code The code to set
	 */
	public void setCode(String code) {
		this.code = code;
	}

	/**
	 * Sets the libelle.
	 * @param libelle The libelle to set
	 */
	public void setLibelle(String libelle) {
		this.libelle = libelle;
	}

	/**
	 * Sets the longueur.
	 * @param longueur The longueur to set
	 */
	public void setLongueur(String longueur) {
		this.longueur = longueur;
	}

	/**
	 * Sets the obligatoire.
	 * @param obligatoire The obligatoire to set
	 */
	public void setObligatoire(String obligatoire) {
		this.obligatoire = obligatoire;
	}

	/**
	 * Sets the type.
	 * @param type The type to set
	 */
	public void setType(String type) {
		this.type = type;
	}

	/**
	 * Returns the valeur.
	 * @return String
	 */
	public String getValeur() {
		return valeur;
	}

	/**
	 * Sets the valeur.
	 * @param valeur The valeur to set
	 */
	public void setValeur(String valeur) {
		this.valeur = valeur;
	}

	/**
	 * Returns the textSql.
	 * @return String
	 */
	public String getTextSql() {
		return textSql;
	}

	/**
	 * Sets the textSql.
	 * @param textSql The textSql to set
	 */
	public void setTextSql(String textSql) {
		this.textSql = textSql;
	}

}
