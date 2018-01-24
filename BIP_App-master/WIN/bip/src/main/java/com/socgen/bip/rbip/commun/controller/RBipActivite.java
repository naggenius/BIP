/*
 * Créé le 27 avr. 04
 *
 */
package com.socgen.bip.rbip.commun.controller;

import java.util.Date;

/**
 * @author X039435 / E.GREVREND
 *
 * Représente un enregistrement de type Activité.<br>
 */
public class RBipActivite extends RBipEnregistrement
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
	 * Type de l'Etape
	 */
	private String sTypeEtape;
	/**
	 * Type de la Sous-tâche
	 */
	private String sTypeSSTache;
	/**
	 * Date de Début Initiale
	 */
	private Date dDebIni;
	/**
	 * Date de Fin initiale
	 */
	private Date dFinIni;
	/**
	 * Date de Début révisée
	 */
	private Date dDebRev;
	/**
	 * Date de Fin révisée
	 */
	private Date dFinRev;
	/**
	 * Nom de l'activité
	 */
	private String sNomActivite;
	/**
	 * Pourcentage constaté
	 */
	private Integer iPourcentage;
	/**
	 * Durée en jours travaillés
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
