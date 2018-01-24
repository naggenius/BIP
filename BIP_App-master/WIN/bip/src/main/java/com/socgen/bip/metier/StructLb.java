package com.socgen.bip.metier;

import java.util.Collection;
import java.util.LinkedHashMap;

/**
 * Classe m�tier contenant un arbre repr�sentant une structure de ligne BIP (�tapes, t�ches, sous-t�ches � afficher dans l��cran Structure d�une ligne BIP).
 * @author X119481
 *
 */
public class StructLb {
	
	private LinkedHashMap<String, StructLbEtape> etapes;
	
	public StructLb() {}

	/**
	 * @return the etapes
	 */
	public LinkedHashMap<String, StructLbEtape> getEtapes() {
		return etapes;
	}

	/**
	 * @param etapes the etapes to set
	 */
	public void setEtapes(LinkedHashMap<String, StructLbEtape> etapes) {
		this.etapes = etapes;
	}
	
	public Collection<StructLbEtape> getEtapesValues() {
		Collection<StructLbEtape> retour = null;
		
		if (etapes != null) {
			retour = etapes.values();
		}
		
		return retour;
	}
}
