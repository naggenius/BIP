/*
 * Cr�� le 27 avr. 04
 *
 */
package com.socgen.bip.rbip.commun.controller;

/**
 * @author X039435 / E.GREVREND
 *
 * Repr�sente un enregistrement de type Allocation
 */
public class RBipAllocation extends RBipEnregistrement
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
	 * Code bip de la ressource
	 */
	private String sTires;
	/**
	 * Charge planifi�e
	 */
	private Double fChargePlanifiee;
	/**
	 * Charge consomm�e
	 */
	private Double fChargeConsommee;
	/**
	 * Charge restante estim�e
	 */
	private Double fChargeRAF;
	
	/**
	 * 
	 * @param iNumEtape
	 * @param iNumTache
	 * @param iNumSSTache
	 * @param sETS
	 * @param sTires
	 * @param fChargePlanifiee
	 * @param fChargeConsommee
	 * @param fChargeRAF
	 */
	public RBipAllocation(	Integer iNumEtape, Integer iNumTache, Integer iNumSSTache, String sETS,
							String sTires,
							Double fChargePlanifiee,
							Double fChargeConsommee,
							Double fChargeRAF)
	{
		this.iNumEtape = iNumEtape;
		this.iNumTache = iNumTache;
		this.iNumSSTache = iNumSSTache;
	
		this.sETS = sETS;
				
		this.sTires = sTires;
		this.fChargePlanifiee = fChargePlanifiee;
		this.fChargeConsommee = fChargeConsommee;
		this.fChargeRAF = fChargeRAF;
	}

	/**
	 * @return
	 */
	public Double getChargeConsommee() {
		return fChargeConsommee;
	}

	/**
	 * @return
	 */
	public Double getChargePlanifiee() {
		return fChargePlanifiee;
	}

	/**
	 * @return
	 */
	public Double getChargeRAF() {
		return fChargeRAF;
	}

	/**
	 * @return
	 */
	public String getTires() {
		return sTires;
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
}
