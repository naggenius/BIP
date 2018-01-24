package com.socgen.bip.metier;

/**
 * @author S Lallier
 * Classe representant les entites structure.
 */
public class EntiteStructure {
	/**
	 * identifiant de l'�l�ment strucutre.
	 */
	private String idelst;
	/**
	 * le code camo de l'Es.
	 */
	private String codcamo;
	/**
	 * niveau de l'�l�ment strucutre.
	 */
	private String niveau;
	/**
	 * code type �l�ment strucutre ascendant.
	 */
	private String cdtyes;
	/**
	 * libell� long �l�ment strucutre.
	 */
	private String liloes;
	/**
	 * libell� court �l�ment strucutre.
	 */
	private String licoes;

	public EntiteStructure() {

	}

	public EntiteStructure(String codcamo, String cdtyes,
	                       String niveau, String liloes) {
		this.codcamo = codcamo;
		this.cdtyes = cdtyes;
		this.niveau = niveau;
		this.liloes = liloes;
	}

	public String getCdtyes() {
		return cdtyes;
	}

	public String getIdelst() {
		return idelst;
	}

	public String getLicoes() {
		return licoes;
	}

	public String getLiloes() {
		return liloes;
	}

	public String getNiveau() {
		return niveau;
	}

	public void setCdtyes(String string) {
		cdtyes = string;
	}

	public void setIdelst(String string) {
		idelst = string;
	}

	public void setLicoes(String string) {
		licoes = string;
	}

	public void setLiloes(String string) {
		liloes = string;
	}

	public void setNiveau(String string) {
		niveau = string;
	}

	public String getCodcamo() {
		return codcamo;
	}

	public void setCodcamo(String string) {
		codcamo = string;
	}

}
