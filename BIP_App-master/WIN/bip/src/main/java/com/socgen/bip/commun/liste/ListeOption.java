package com.socgen.bip.commun.liste;

/**
 * @author N.BACCAM
 *
 * représente une option d'une liste
 */
public class ListeOption {
	String cle ;
	String libelle ;

	/**
	 * Constructor for Liste.
	 */
	public ListeOption() {
		super();
	}
   /**
	 * Constructor for Liste.
	 */
	public ListeOption(String cle,String libelle ) {
	
		this. cle=  cle;
		this.libelle = libelle ;
		
	}
	/**
	 * Returns the cle.
	 * @return String
	 */
	public String getCle() {
		return cle;
	}

	/**
	 * Returns the libelle.
	 * @return String
	 */
	public String getLibelle() {
		return libelle;
	}

	/**
	 * Sets the cle.
	 * @param cle The cle to set
	 */
	public void setCle(String cle) {
		this.cle = cle;
	}

	/**
	 * Sets the libelle.
	 * @param libelle The libelle to set
	 */
	public void setLibelle(String libelle) {
		this.libelle = libelle;
	}
	
	public boolean equals(ListeOption listeOption)
	{
		if(this.cle.equals(listeOption.getCle()))
		{
			return true;
		}
		return false;
	}

}
