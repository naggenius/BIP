package com.socgen.bip.form;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author P.JOSSE - 02/12/2004
 *
 * Formulaire de mise à jour des CA d'une ligne BIP aux CA multiples
 * chemin : Ligne BIP/Multi CA
 * pages  : fMulticaAd.jsp , bMulticaAd.jsp
 * pl/sql : multi_ca.sql
 */
public class MultiCAForm extends AutomateForm{
	/*La Ligne BIP
	*/
	private String pid ;
	/*Le libellé de la ligne BIP
	*/
	private String pnom;
	/*La date de début
	*/
	private String datdeb;
	/*Le CA Payeur
	*/
	private String codcamo;
	/*Code client
	 */
	private String clicode;
	/*Le taux de refacturation
	*/
	private String tauxrep;
	/*Année exercice
	 */
	private String anneeExercice;

	 
     /**
	 * Constructor for ClientForm.
	 */
	public MultiCAForm() {
		super();
	}

	/**
	 * @return
	 */
	public String getCodcamo() {
		return codcamo;
	}

	/**
	 * @return
	 */
	public String getDatdeb() {
		return datdeb;
	}

	/**
	 * @return
	 */
	public String getPid() {
		return pid;
	}

	/**
	 * @return
	 */
	public String getPnom() {
		return pnom;
	}

	/**
	 * @return
	 */
	public String getTauxrep() {
		return tauxrep;
	}

	/**
	 * @param string
	 */
	public void setCodcamo(String string) {
		codcamo = string;
	}

	/**
	 * @param string
	 */
	public void setDatdeb(String string) {
		datdeb = string;
	}

	/**
	 * @param string
	 */
	public void setPid(String string) {
		pid = string;
	}

	/**
	 * @param string
	 */
	public void setPnom(String string) {
		pnom = string;
	}

	/**
	 * @param string
	 */
	public void setTauxrep(String string) {
		tauxrep = string;
	}

	/**
	 * @return
	 */
	public String getAnneeExercice() {
		return anneeExercice ;
	}

	/**
	 * @param string
	 */
	public void setAnneeExercice(String string) {
		anneeExercice = string;
	}

	/**
	 * @return
	 */
	public String getClicode() {
		return clicode;
	}

	/**
	 * @param string
	 */
	public void setClicode(String string) {
		clicode = string;
	}

}
