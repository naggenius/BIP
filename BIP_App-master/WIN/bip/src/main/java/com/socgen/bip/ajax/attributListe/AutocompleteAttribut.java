package com.socgen.bip.ajax.attributListe;

import java.io.Serializable;

import org.apache.commons.lang.builder.ToStringBuilder;


public class AutocompleteAttribut implements Serializable {

	private String id;
	private String libelle;

	/**
	 * Constructor for Car.
	 */
	public AutocompleteAttribut() {
		super();
	}

	/**
	 * Constructor for Car.
	 * 
	 * @param id
	 * @param libelle
	 */
	public AutocompleteAttribut(String id, String libelle) {
		super();
		this.id = id;
		this.libelle = libelle;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getLibelle() {
		return libelle;
	}

	public void setLibelle(String libelle) {
		this.libelle = libelle;
	}

	/**
	 * @see java.lang.Object#toString()
	 */
	public String toString() {
		return new ToStringBuilder(this).append("id", this.id).append(
				"libelle", this.libelle).toString();
	}

}