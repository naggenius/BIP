/*
 * Créé le 27 avr. 04
 *
 */
package com.socgen.bip.rbip.commun.controller;

import java.util.Date;

/**
 * @author X039435 / E.GREVREND
 *
 * Représente un enregistrement de type Consommé
 */
public class RBipConsomme extends RBipEnregistrement
{
	/**
	 * Numéro de l'Etape
	 */
	private Integer iNumEtape;
	/**
	 * Numéro de la Tâche
	 */
	private Integer iNumTache;
	/**
	 * Numéro de la Sous-tâche
	 */
	private Integer iNumSSTache;
	/**
	 * Etape/Tâche/Sous-tâche sous forme de chaîne de carcatères,
	 * pas primordial maid permet de gagner en confort de manipulation 
	 */
	private String sETS;
	/**
	 * Lot bip de la ressource
	 */
	private String sTires;
	/**
	 * Pourcentage
	 */
	private Integer iPourcentage;
	/**
	 * Date de début de la période de consommé
	 */
	private Date dDebConsomme;
	/**
	 * Durée de la période saisie
	 */
	private Integer iDureePeriode;
	/**
	 * Consommé sur la période
	 */
	private Double fConsomme;
	/**
	 * Type de consommé :<br>
	 * <ul>
	 * <li>0 : Charge initiale</li>
	 * <li>1 : consommé</li>
	 * <li>2 : reste à faire</li>
	 * </ul>
	 */
	private String sTypeConsomme;
	
	/**
	 * @param iNumEtape
	 * @param iNumTache
	 * @param iNumSSTache
	 * @param sETS
	 * @param sTires
	 * @param iPourcentage
	 * @param dDebConsomme
	 * @param iDureePeriode
	 * @param fConsomme
	 * @param iTypeConsomme
	 */
	public RBipConsomme(Integer iNumEtape, Integer iNumTache, Integer iNumSSTache, String sETS,
						String sTires,
						Integer iPourcentage, 
						Date dDebConsomme,
						Integer iDureePeriode, 
						Double fConsomme, 
						String sTypeConsomme)
	{
		
		this.iNumEtape = iNumEtape;
		this.iNumTache = iNumTache;
		this.iNumSSTache = iNumSSTache;
		this.sETS = sETS;
		this.sTires = sTires;
		
		this.iPourcentage = iPourcentage;
		this.dDebConsomme = dDebConsomme;
		this.iDureePeriode = iDureePeriode;
		this.fConsomme = fConsomme;
		this.sTypeConsomme = sTypeConsomme;
	}
	
	protected RBipEnregistrement getFils(Object oKey)
	{
		return null;
	}
	/**
	 * @return
	 */
	public Date getDateDebConsomme() {
		return dDebConsomme;
	}

	/**
	 * @return
	 */
	public Double getConsomme() {
		return fConsomme;
	}

	/**
	 * @return
	 */
	public Integer getPourcentage() {
		return iPourcentage;
	}

	/**
	 * @return
	 */
	public String getTypeConsomme() {
		return sTypeConsomme;
	}
	
	/**
	 * @return
	 */
	public Integer getNumEtape() {
		return iNumEtape;
	}

	/**
	 * @return
	 */
	public Integer getNumSSTache() {
		return iNumSSTache;
	}

	/**
	 * @return
	 */
	public Integer getNumTache() {
		return iNumTache;
	}

	/**
	 * @return
	 */
	public String getETS() {
		return sETS;
	}

	/**
	 * @return
	 */
	public Integer getDureePeriode() {
		return iDureePeriode;
	}

	/**
	 * @return
	 */
	public String getTires() {
		return sTires;
	}

}
