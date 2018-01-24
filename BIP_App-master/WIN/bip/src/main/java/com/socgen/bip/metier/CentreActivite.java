/*
 * Creé le 21 nov. 2003 
 */
package com.socgen.bip.metier;

/**
 * @author Lallier S
 * classe reprensentant un Centre d'activite
 */
public class CentreActivite {	
	
	/**
	 * l'identifiant du centre d'activité.
	 */
	private String codcamo;
	/**
	 * le niveau du centre d'activite
	 */
	private String codnivca;
	/**
	 * le libellé court du ca.
	 */
	
	private String codnivcaPere;
			
	private String libelleCourt;
	/**
		 * le libellé long du ca.
		 */
	private String libelleLong;
	/**
		 * la valeur du ca de niveau 1 associée au ca.
		 */
	private String caniv1;
	/**
	 * la valeur du ca de niveau 2 associée au ca.
	 */
	private String caniv2;
	/**
	 * la valeur du ca de niveau 3 associée au ca.
	 */
	private String caniv3;
	/**
		 * la valeur du ca de niveau 4 associée au ca.
		 */
	private String caniv4;	
	
	public CentreActivite(){
		
	}

	public CentreActivite(String codcamo, String libelleLong){
		this.codcamo = codcamo;
		this.libelleLong = libelleLong;
	}
	
	public CentreActivite(String codcamo, String libelleLong, String niveau){
		this.codcamo = codcamo;
		this.codnivca = niveau;
		this.libelleLong = libelleLong;
	}
	
	public String getCaniv1() {
		return caniv1;
	}

	public String getCaniv2() {
		return caniv2;
	}

	public String getCaniv3() {
		return caniv3;
	}

	public String getCaniv4() {
		return caniv4;
	}

	public String getCodcamo() {
		return codcamo;
	}

	public String getCodnivca() {
		return codnivca;
	}

	public String getLibelleCourt() {
		return libelleCourt;
	}

	public String getLibelleLong() {
		return libelleLong;
	}

	public void setCaniv1(String string) {
		caniv1 = string;
	}

	public void setCaniv2(String string) {
		caniv2 = string;
	}

	public void setCaniv3(String string) {
		caniv3 = string;
	}

	public void setCaniv4(String string) {
		caniv4 = string;
	}

	public void setCodcamo(String string) {
		codcamo = string;
	}

	public void setCodnivca(String niveau) {
		codnivca = niveau;
	}

	public void setLibelleCourt(String string) {
		libelleCourt = string;
	}

	public void setLibelleLong(String string) {
		libelleLong = string;
	}

	public String getCodnivcaPere() {
		return codnivcaPere;
	}

	public void setCodnivcaPere(String code) {
		codnivcaPere = code;
	}

}
