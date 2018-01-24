package com.socgen.bip.metier;
/**
 * Classe m�tier repr�sentant une sous-t�che d�une structure d�une ligne BIP
 */
public class StructLbSsTache {
	// L'identifiant de la sous-t�che
	private String idSsTache;
	// Le num�ro de la sous-t�che 
	private String numeroSsTache;
	// Le libell� de la sous-t�che 
	private String libelleSsTache;
	
	public StructLbSsTache(String numeroSsTache, String libelleSsTache) {
		this.numeroSsTache = numeroSsTache;
		this.libelleSsTache = libelleSsTache;
	}
	public StructLbSsTache() {
	}
	/**
	 * @return the libelleSsTache
	 */
	public String getLibelleSsTache() {
		return libelleSsTache;
	}
	/**
	 * @param libelleSsTache the libelleSsTache to set
	 */
	public void setLibelleSsTache(String libelleSsTache) {
		this.libelleSsTache = libelleSsTache;
	}
	/**
	 * @return the numeroSsTache
	 */
	public String getNumeroSsTache() {
		return numeroSsTache;
	}
	/**
	 * @param numeroSsTache the numeroSsTache to set
	 */
	public void setNumeroSsTache(String numeroSsTache) {
		this.numeroSsTache = numeroSsTache;
	}
	/**
	 * @return the idSsTache
	 */
	public String getIdSsTache() {
		return idSsTache;
	}
	/**
	 * @param idSsTache the idSsTache to set
	 */
	public void setIdSsTache(String idSsTache) {
		this.idSsTache = idSsTache;
	}

	
}
