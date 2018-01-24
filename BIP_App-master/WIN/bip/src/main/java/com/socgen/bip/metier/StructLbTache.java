package com.socgen.bip.metier;

import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.LinkedList;

/**
 * classe métier représentant une tâche d’une structure d’une ligne BIP
 * @author X119481
 *
 */
public class StructLbTache {

	private LinkedHashMap<String, StructLbSsTache> ssTaches;
	
	// L'identifiant de la tâche
	private String idTache;
	
	// Le numéro de la tâche 
	private String numeroTache;
	// Le libellé de la tâche 
	private String libelleTache;
	// L'axe metier de la tâche 
	private String tacheAxeMetier;
	
	public StructLbTache(String numeroTache, String libelleTache, String tacheAxeMetier) {
		this.numeroTache = numeroTache;
		this.libelleTache = libelleTache;
		this.tacheAxeMetier = tacheAxeMetier;
	}
	
	public StructLbTache() {
	}

	/**
	 * @return the libelleTache
	 */
	public String getLibelleTache() {
		return libelleTache;
	}

	/**
	 * @param libelleTache the libelleTache to set
	 */
	public void setLibelleTache(String libelleTache) {
		this.libelleTache = libelleTache;
	}

	/**
	 * @return the numeroTache
	 */
	public String getNumeroTache() {
		return numeroTache;
	}

	/**
	 * @param numeroTache the numeroTache to set
	 */
	public void setNumeroTache(String numeroTache) {
		this.numeroTache = numeroTache;
	}
	
	/**
	 * @return the tacheAxeMetier
	 */
	public String getTacheAxeMetier() {
		return tacheAxeMetier;
	}

	/**
	 * @param tacheAxeMetier the tacheAxeMetier to set
	 */
	public void setTacheAxeMetier(String tacheAxeMetier) {
		this.tacheAxeMetier = tacheAxeMetier;
	}

	/**
	 * @return the ssTaches
	 */
	public LinkedHashMap<String, StructLbSsTache> getSsTaches() {
		return ssTaches;
	}

	/**
	 * @param ssTaches the ssTaches to set
	 */
	public void setSsTaches(LinkedHashMap<String, StructLbSsTache> ssTaches) {
		this.ssTaches = ssTaches;
	}
	
	public Collection<StructLbSsTache> getSsTachesValues() {
		Collection<StructLbSsTache> retour = null;
		
		if (ssTaches != null) {
			retour = ssTaches.values();
		}
		
		return retour;
	}

	/**
	 * @return the idTache
	 */
	public String getIdTache() {
		return idTache;
	}

	/**
	 * @param idTache the idTache to set
	 */
	public void setIdTache(String idTache) {
		this.idTache = idTache;
	}
}
