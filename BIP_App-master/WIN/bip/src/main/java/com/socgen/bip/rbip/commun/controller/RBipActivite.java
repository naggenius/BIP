/*
 * Cr�� le 27 avr. 04
 *
 */
package com.socgen.bip.rbip.commun.controller;

import java.util.Date;

/**
 * @author X039435 / E.GREVREND
 *
 * Repr�sente un enregistrement de type Activit�.<br>
 */
public class RBipActivite extends RBipEnregistrement
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
	 * Type de l'Etape
	 */
	private String sTypeEtape;
	/**
	 * Type de la Sous-t�che
	 */
	private String sTypeSSTache;
	/**
	 * Date de D�but Initiale
	 */
	private Date dDebIni;
	/**
	 * Date de Fin initiale
	 */
	private Date dFinIni;
	/**
	 * Date de D�but r�vis�e
	 */
	private Date dDebRev;
	/**
	 * Date de Fin r�vis�e
	 */
	private Date dFinRev;
	/**
	 * Nom de l'activit�
	 */
	private String sNomActivite;
	/**
	 * Pourcentage constat�
	 */
	private Integer iPourcentage;
	/**
	 * Dur�e en jours travaill�s
	 */
	private Integer iDuree;
	
	/**
	 * 
	 * @param iNumEtape
	 * @param iNumTache
	 * @param iNumSSTache
	 * @param sETS
	 * @param sTypeEtape
	 * @param sTypeSSTache
	 * @param dDebIni
	 * @param dFinIni
	 * @param dDebRev
	 * @param dFinRev
	 * @param sNomActivite
	 * @param iPourcentage
	 * @param iDuree
	 */
	public RBipActivite(Integer iNumEtape, Integer iNumTache, Integer iNumSSTache, String sETS,
						String sTypeEtape, String sTypeSSTache,
						Date dDebIni, Date dFinIni, Date dDebRev, Date dFinRev,
						String sNomActivite,
						Integer iPourcentage,
						Integer iDuree)
	{
		
		this.iNumEtape = iNumEtape;
		this.iNumTache = iNumTache;
		this.iNumSSTache = iNumSSTache;
		
		this.sETS = sETS;
		
		this.sTypeEtape = sTypeEtape;
		this.sTypeSSTache = sTypeSSTache;
		
		this.dDebIni = dDebIni;
		this.dFinIni = dFinIni;
		this.dDebRev = dDebRev;
		this.dFinRev = dFinRev;
		
		this.sNomActivite = sNomActivite;
		this.iPourcentage = iPourcentage;
		this.iDuree = iDuree;
	}
		
	/**
	 * @return
	 */
	public Date getDateDebIni() {
		return dDebIni;
	}

	/**
	 * @return
	 */
	public Date getDateDebRev() {
		return dDebRev;
	}

	/**
	 * @return
	 */
	public Date getDateFinIni() {
		return dFinIni;
	}

	/**
	 * @return
	 */
	public Date getDateFinRev() {
		return dFinRev;
	}

	/**
	 * @return
	 */
	public Integer getDuree() {
		return iDuree;
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
	public Integer getPourcentage() {
		return iPourcentage;
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
	public String getNomActivite() {
		return sNomActivite;
	}

	/**
	 * @return
	 */
	public String getTypeEtape() {
		return sTypeEtape;
	}

	/**
	 * @return
	 */
	public String getTypeSSTache() {
		return sTypeSSTache;
	}
}
