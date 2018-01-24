package com.socgen.bip.form;

import com.socgen.bip.commun.form.AutomateForm;


/**
 * @author EVI - 06/02/2009
 *
 * Formulaire de mise à jour des arbitre
 * chemin : Administration/Budgets JG/Arbitrage
 * pages  : fArbitrageAd.jsp et bArbitrageAd.jsp
 * pl/sql : arbitre.sql
 */
public class ArbitrageForm extends AutomateForm {
	
	/*Code dossier projet
	*/
	private String dpcode;
	/*Code projet 
	*/
	private String icpi;
	/*Le metier
	*/
	private String metier;
	/*Le pid de la ligne BIP
	*/
	private String pid;
	/*L'annee
	*/
	private String annee ;
	
	/*Le nombre de lignes par page 
		*/
	private String blocksize ;
	/*ordre de tri 
	*/
	private String ordre_tri ;
	/*Total arbitre
	*/
	protected String tot_anmont;
	/*Total propose
	*/
	protected String tot_bpmontmo;
	/*Total ecart
	*/
	protected String tot_ecart;
	/*Le codsg
	*/
	private String codsg ;

	/*Le type save
						*/	
    protected String save;
    
    /*Le type save
	*/	
    protected String liste_pid;
		
	/**
	 * Constructor for PropoMassForm.
	 */
	public ArbitrageForm() {
		super();
	}

	public String getAnnee() {
		return annee;
	}

	public void setAnnee(String annee) {
		this.annee = annee;
	}

	public String getBlocksize() {
		return blocksize;
	}

	public void setBlocksize(String blocksize) {
		this.blocksize = blocksize;
	}

	public String getCodsg() {
		return codsg;
	}

	public void setCodsg(String codsg) {
		this.codsg = codsg;
	}

	public String getDpcode() {
		return dpcode;
	}

	public void setDpcode(String dpcode) {
		this.dpcode = dpcode;
	}

	public String getIcpi() {
		return icpi;
	}

	public void setIcpi(String icpi) {
		this.icpi = icpi;
	}

	public String getMetier() {
		return metier;
	}

	public void setMetier(String metier) {
		this.metier = metier;
	}

	public String getOrdre_tri() {
		return ordre_tri;
	}

	public void setOrdre_tri(String ordre_tri) {
		this.ordre_tri = ordre_tri;
	}

	public String getPid() {
		return pid;
	}

	public void setPid(String pid) {
		this.pid = pid;
	}

	public String getSave() {
		return save;
	}

	public void setSave(String save) {
		this.save = save;
	}

	public String getTot_anmont() {
		return tot_anmont;
	}

	public void setTot_anmont(String tot_anmont) {
		this.tot_anmont = tot_anmont;
	}

	public String getTot_bpmontmo() {
		return tot_bpmontmo;
	}

	public void setTot_bpmontmo(String tot_bpmontmo) {
		this.tot_bpmontmo = tot_bpmontmo;
	}

	public String getTot_ecart() {
		return tot_ecart;
	}

	public void setTot_ecart(String tot_ecart) {
		this.tot_ecart = tot_ecart;
	}

	public String getListe_pid() {
		return liste_pid;
	}

	public void setListe_pid(String liste_pid) {
		this.liste_pid = liste_pid;
	}




}
