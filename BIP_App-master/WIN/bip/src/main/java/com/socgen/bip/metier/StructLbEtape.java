package com.socgen.bip.metier;

import java.util.Collection;
import java.util.LinkedHashMap;

/**
 * Classe m�tier repr�sentant une �tape d�une structure d�une ligne BIP
 * @author X119481
 *
 */
public class StructLbEtape {
	
	private LinkedHashMap<String, StructLbTache> taches;
	// L'identifiant de l'�tape
	private String idEtape;
	// Le num�ro d��tape 
	private String numeroEtape ;
	// Le type d��tape 
	private String  typeEtape;
	// Le libell� du type d��tape 
	private String libelleTypeEtape;
	// Le libell� de l��tape 
	private String libelleEtape;

	public StructLbEtape() {
		
	}

	/**
	 * @return the taches
	 */
	public LinkedHashMap<String, StructLbTache> getTaches() {
		return taches;
	}

	/**
	 * @param taches the taches to set
	 */
	public void setTaches(LinkedHashMap<String, StructLbTache> taches) {
		this.taches = taches;
	}

	/**
	 * @return the libelleEtape
	 */
	public String getLibelleEtape() {
		return libelleEtape;
	}

	/**
	 * @param libelleEtape the libelleEtape to set
	 */
	public void setLibelleEtape(String libelleEtape) {
		this.libelleEtape = libelleEtape;
	}

	/**
	 * @return the libelleTypeEtape
	 */
	public String getLibelleTypeEtape() {
		return libelleTypeEtape;
	}

	/**
	 * @param libelleTypeEtape the libelleTypeEtape to set
	 */
	public void setLibelleTypeEtape(String libelleTypeEtape) {
		this.libelleTypeEtape = libelleTypeEtape;
	}

	/**
	 * @return the numeroEtape
	 */
	public String getNumeroEtape() {
		return numeroEtape;
	}

	/**
	 * @param numeroEtape the numeroEtape to set
	 */
	public void setNumeroEtape(String numeroEtape) {
		this.numeroEtape = numeroEtape;
	}

	/**
	 * @return the typeEtape
	 */
	public String getTypeEtape() {
		return typeEtape;
	}

	/**
	 * @param typeEtape the typeEtape to set
	 */
	public void setTypeEtape(String typeEtape) {
		this.typeEtape = typeEtape;
	}
	
	public Collection<StructLbTache> getTachesValues() {
		Collection<StructLbTache> retour = null;
		
		if (taches != null) {
			retour = taches.values();
		}
		
		return retour;
	}

	/**
	 * @return the idEtape
	 */
	public String getIdEtape() {
		return idEtape;
	}

	/**
	 * @param idEtape the idEtape to set
	 */
	public void setIdEtape(String idEtape) {
		this.idEtape = idEtape;
	}
}
