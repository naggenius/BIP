/*
 * Créé le 27 avr. 04
 *
 */
package com.socgen.bip.rbip.commun.controller;

import java.util.Date;

/**
 * @author X039435 / E.GREVREND
 *
 * Représente un enregistrement de type EnTête
 */
public class RBipEnTete extends RBipEnregistrement
{
	/**
	 * Le PID du projet
	 */
	private String sPID;
	/**
	 * Date de création
	 */
	private Date dCreation;
	/**
	 * Clé de contrôle
	 */
	private String sCle;
	
	/**
	 * 
	 * @param sPID
	 * @param sCle
	 * @param dCreation
	 */
	public RBipEnTete(String sPID, String sCle, Date dCreation)
	{
		this.sPID = sPID;
		this.sCle = sCle;
		this.dCreation = dCreation;
	}
	
	/**
	 * @return
	 */
	public Date getDCreation() { return dCreation; }

	/**
	 * @return
	 */
	public String getCle() { return sCle; }

	/**
	 * @return
	 */
	public String getPID() { return sPID; }
}
