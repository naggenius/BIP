package com.socgen.bip.service.dto;

public class SyntheseImmoDto {
	
	private String icpi;
	// KRA PPM 61879 : debut
	private String ilibel;
	private String statut;
	private String datstatut;
	//Fin KRA
	private String annee;
	private String composant;
	private double jh;
	private double euros;
	
	public String getAnnee() {
		return annee;
	}
	public void setAnnee(String annee) {
		this.annee = annee;
	}
		
	public String getIcpi() {
		return icpi;
	}
	public void setIcpi(String icpi) {
		this.icpi = icpi;
	}
	public double getEuros() {
		return euros;
	}
	public void setEuros(double euros) {
		this.euros = euros;
	}
	public double getJh() {
		return jh;
	}
	public void setJh(double jh) {
		this.jh = jh;
	}
	public String getComposant() {
		return composant;
	}
	public void setComposant(String composant) {
		this.composant = composant;
	}
	// KRA PPM 61879 : debut
	/**
	 * @return the ilibel
	 */
	public String getIlibel() {
		return ilibel;
	}
	/**
	 * @param ilibel the ilibel to set
	 */
	public void setIlibel(String ilibel) {
		this.ilibel = ilibel;
	}

	/**
	 * @return the statut
	 */
	public String getStatut() {
		return statut;
	}
	/**
	 * @param statut the statut to set
	 */
	public void setStatut(String statut) {
		this.statut = statut;
	}
	/**
	 * @return the datstatut
	 */
	public String getDatstatut() {
		return datstatut;
	}
	/**
	 * @param datstatut the datstatut to set
	 */
	public void setDatstatut(String datstatut) {
		this.datstatut = datstatut;
	}
	//Fin KRA

}
