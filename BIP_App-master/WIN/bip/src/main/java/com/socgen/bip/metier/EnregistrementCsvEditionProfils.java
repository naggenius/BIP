package com.socgen.bip.metier;

/**
 * @author X119481
 * Objet m�tier repr�sentant un enregistrement (donn�es d'une ligne) du fichier csv contenant les profils d'une liste de ressources : couple ID_RESSBIP, ID_RTFE
 * page  : eProfilsListeRessources.jsp
 */
public class EnregistrementCsvEditionProfils {
	/**
	 * Donn�e de la colonne ID_RESSBIP pour l'enregistrement repr�sent� par l'objet this
	 */
	private String idRessourceBip;
	/**
	 * Donn�e de la colonne ID_RTFE pour l'enregistrement repr�sent� par l'objet this
	 */
	private String idRtfe;
	
	public EnregistrementCsvEditionProfils() {
	}
	
	public EnregistrementCsvEditionProfils(String idRessourceBip, String idRtfe) {
		this.idRessourceBip = idRessourceBip;
		this.idRtfe = idRtfe;
	}
	
	public String getIdRessourceBip() {
		return idRessourceBip;
	}
	public void setIdRessourceBip(String idRessourceBip) {
		this.idRessourceBip = idRessourceBip;
	}
	public String getIdRtfe() {
		return idRtfe;
	}
	public void setIdRtfe(String idRtfe) {
		this.idRtfe = idRtfe;
	}
}
