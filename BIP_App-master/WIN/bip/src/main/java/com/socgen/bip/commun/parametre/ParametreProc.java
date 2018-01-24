package com.socgen.bip.commun.parametre;

/**
 * @author N.BACCAM
 *
 *Paramètre utilisé dans la procédure stockée : IN, OUT ou IN/OUT
 */
public class ParametreProc {
	/*la position dans la procédure
	*/
	private String position ;
	/*le nom de l'argument
	*/
	private String nom ;
	/*le type de l'argument
	*/
	private String type ;
	/*la valeur de l'argument
	*/
	private Object valeur ;

	/**
	 * Constructor for ParametreProc.
	 */
	public ParametreProc() {
		super();
	}
	
	/**
	 * Constructor for ParametreIn.
	 */
	public ParametreProc(String position, String type, Object valeur) {
		this.position=position;
		this.type=type;	
		this.valeur=valeur;	
	}
	
	/**
	 * Constructor for parametreOut.
	 */
	public ParametreProc(String position, String nom, String type, Object valeur) {
		this.position=position;
		this.nom=nom;
		this.type=type;
		this.valeur=valeur;	
	}
	
	/**
	 * Returns the nom.
	 * @return String
	 */
	public String getNom() {
		return nom;
	}

	/**
	 * Returns the position.
	 * @return String
	 */
	public String getPosition() {
		return position;
	}

	/**
	 * Returns the type.
	 * @return String
	 */
	public String getType() {
		return type;
	}

	/**
	 * Returns the valeur.
	 * @return Object
	 */
	public Object getValeur() {
		return valeur;
	}

	/**
	 * Sets the nom.
	 * @param nom The nom to set
	 */
	public void setNom(String nom) {
		this.nom = nom;
	}

	/**
	 * Sets the position.
	 * @param position The position to set
	 */
	public void setPosition(String position) {
		this.position = position;
	}

	/**
	 * Sets the type.
	 * @param type The type to set
	 */
	public void setType(String type) {
		this.type = type;
	}

	/**
	 * Sets the valeur.
	 * @param valeur The valeur to set
	 */
	public void setValeur(Object valeur) {
		this.valeur = valeur;
	}

}
