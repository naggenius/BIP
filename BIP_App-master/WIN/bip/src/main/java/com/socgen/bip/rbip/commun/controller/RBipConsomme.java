/*
 * Cr�� le 27 avr. 04
 *
 */
package com.socgen.bip.rbip.commun.controller;

import java.util.Date;

/**
 * @author X039435 / E.GREVREND
 *
 * Repr�sente un enregistrement de type Consomm�
 */
public class RBipConsomme extends RBipEnregistrement
{
	/**
	 * Num�ro de l'Etape
	 */
	private Integer iNumEtape;
	/**
	 * Num�ro de la T�che
	 */
	private Integer iNumTache;
	/**
	 * Num�ro de la Sous-t�che
	 */
	private Integer iNumSSTache;
	/**
	 * Etape/T�che/Sous-t�che sous forme de cha�ne de carcat�res,
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
	 * Date de d�but de la p�riode de consomm�
	 */
	private Date dDebConsomme;
	/**
	 * Dur�e de la p�riode saisie
	 */
	private Integer iDureePeriode;
	/**
	 * Consomm� sur la p�riode
	 */
	private Double fConsomme;
	/**
	 * Type de consomm� :<br>
	 * <ul>
	 * <li>0 : Charge initiale</li>
	 * <li>1 : consomm�</li>
	 * <li>2 : reste � faire</li>
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
