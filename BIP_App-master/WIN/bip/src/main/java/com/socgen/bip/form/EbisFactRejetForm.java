package com.socgen.bip.form;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author E.VINATIER 03/09/2007
 *
 * Formulaire pour mise à jour des Taux de récupération
 * chemin : Ordononcement/ facture / Gestion des rejets Expense
 * pages  : fmEbisFactrejetOr.jsp et mEbisFactRejetOr.jsp
 * pl/sql : 
 * 03/09/2007 EVI: creation
 */
public class EbisFactRejetForm extends AutomateForm{

	/*date debut facture 
	*/
	private String datfactdebut ;
	/*date fin facture
	*/
	private String datfactfin ;

	/*TOP ETAT
	*/
	private String topetat;
	/*TOP ETAT
	*/
	private String centreFrais;

	/*Le flaglock
	*/
	private int flaglock ;
	/**
	 * Constructor for EbisFactRejetForm.
	 */
	public EbisFactRejetForm() {
		super();
	}

	/**
	 * Returns the topetat.
	 * @return String
	 */
	public String getTopetat() {
		return topetat;
	}
	/**
	 * Returns the datfact1.
	 * @return String
	 */
	public String getDatfactdebut() {
		return datfactdebut;
	}
	/**
	 * Returns the datfact2.
	 * @return String
	 */
	public String getDatfactfin() {
		return datfactfin;
	}
	/**
	 * Sets the top_etat.
	 * @param annee The filcode to set
	 */
	public void setTopetat(String topetat) {
		this.topetat = topetat;
	}
	/**
	 * Sets the datfact1.
	 * @param annee The filcode to set
	 */
	public void setDatfactdebut(String datfactdebut) {
		this.datfactdebut = datfactdebut;
	}
	/**
	 * Sets the datfact2.
	 * @param annee The filcode to set
	 */
	public void setDatfactfin(String datfactfin) {
		this.datfactfin = datfactfin;
	}
	/**
	 * Returns the flaglock.
	 * @return int
	 */
	public int getFlaglock() {
		return flaglock;
	}
	/**
	 * Sets the flaglock.
	 * @param flaglock The flaglock to set
	 */
	public void setFlaglock(int flaglock) {
		this.flaglock = flaglock;
	}

	public String getCentreFrais() {
		return centreFrais;
	}

	public void setCentreFrais(String centreFrais) {
		this.centreFrais = centreFrais;
	}

}
