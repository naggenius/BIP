package com.socgen.bip.metier;

public class EbisFactRejet {

	/*Le numero rejet 
	*/
	private String numenr ;
	/*Le numero contrat
	*/
	private String numcont ;
    /**le numero avenant
	*/
	private String cav ;
	/*numero de facture
	*/
	private String numfact ;
	/*Code ressource
	*/
	private String ident;
	/*Numero expense de la facture
	*/
	private String num_expense;
	
	/*rejet de la facture
	*/
	private String motif_rejet;
	
	/*TOP ETAT
	*/
	private String topetat;
	/*Le flaglock
	*/
	private int flaglock ;
	
	/**
	 * Constructor for EbisFactRejetForm.
	 */
	public EbisFactRejet() {
		super();
	}
	
	public EbisFactRejet (String numenr, String numcont, String cav, String numfact, String ident, String num_expense,String motif_rejet, String topetat) {
		super();
		
		this.numenr=numenr;
		this.numcont=numcont;
		this.cav=cav;
		this.numfact=numfact;
		this.ident=ident;
		this.num_expense=num_expense;
		this.motif_rejet=motif_rejet;
		this.topetat=topetat;
	}

	/**
	 * Returns the numenr.
	 * @return String
	 */
	public String getNumenr() {
		return numenr;
	}
	/**
	 * Returns the numcont.
	 * @return String
	 */
	public String getNumcont() {
		return numcont;
	}
	/**
	 * Returns the cav.
	 * @return String
	 */
	public String getCav() {
		return cav;
	}
	/**
	 * Returns the numfact.
	 * @return String
	 */
	public String getNumfact() {
		return numfact;
	}	/**
	 * Returns the ident.
	 * @return String
	 */
	public String getIdent() {
		return ident;
	}
	/**
	 * Returns the num_expense.
	 * @return String
	 */
	public String getNum_expense() {
		return num_expense;
	}
	/**
	 * Returns the topetat.
	 * @return String
	 */
	public String getTopetat() {
		return topetat;
	}
	

	
	/**
	 * Sets the numenr.
	 * @param annee The annee to set
	 */
	public void setNumenr(String numenr) {
		this.numenr = numenr;
	}

	/**
	 * Sets the numcont.
	 * @param annee The filcode to set
	 */
	public void setNumcont(String numcont) {
		this.numcont = numcont;
	}
	/**
	 * Sets the annee.
	 * @param annee The annee to set
	 */
	public void setCav(String cav) {
		this.cav = cav;
	}

	/**
	 * Sets the filcode.
	 * @param annee The filcode to set
	 */
	public void setNumfact(String numfact) {
		this.numfact = numfact;
	}
	/**
	 * Sets the ident.
	 * @param annee The annee to set
	 */
	public void setIdent(String ident) {
		this.ident = ident;
	}

	/**
	 * Sets the num_expense.
	 * @param annee The filcode to set
	 */
	public void setNum_expense(String num_expense) {
		this.num_expense = num_expense;
	}
	/**
	 * Sets the top_etat.
	 * @param annee The filcode to set
	 */
	public void setTopetat(String topetat) {
		this.topetat = topetat;
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

	public String getMotif_rejet() {
		return motif_rejet;
	}

	public void setMotif_rejet(String motif_rejet) {
		this.motif_rejet = motif_rejet;
	}

}
