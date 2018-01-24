package com.socgen.bip.metier;

/**
 * @author BAA le 29/03/2003
 *
 */
public class InfosFacture {
	
	private String facture;
	private String type;
	private String nomRessource;
	private String prenomRessource;
	private String datfact;
	private String contrat;
	private String lienHref;
	

	/**
	 * 
	 */
	public InfosFacture() {
		super();
	}
	
	/**
	 * 
	 */
	public InfosFacture(String facture, String type, String datfact, String nomRessource, String prenomRessource,String contrat, String lienHrefCHoix) {
		this.facture = facture;
		this.type = type;
		this.nomRessource = nomRessource;
		this.prenomRessource = prenomRessource;
		this.contrat = contrat;
		this.datfact = datfact;
		this.lienHref = lienHrefCHoix;
	}
	
	
	
	/**
	* @return
	*/
	public String getFacture() {
		return facture;
	} 


	/**
	* @return
	*/
	public String getType() {
		return type;
	}
		
	/**
	* @return
	*/
	public String getNomRessource() {
		return nomRessource;
	}
		
	/**
	* @return
	*/
	public String getPrenomRessource() {
		return prenomRessource;
    }	
		
	
	/**
	 * @return
	 */
	public String getContrat() {
		return contrat;
	}
	
	/**
	 * @return
	 */
	public String getDatfact() {
		return datfact;
	}



	/**
	 * @return
	 */
	public String getLienHref() {
		return lienHref;
	}


	/**
	 * @param string
	 */
	public void setFacture(String string) {
		facture = string;
	}


	

	/**
	* @param string
	*/
	public void setType(String string) {
		type = string;
	}
	
	/**
	* @param string
	*/
	public void setNomRessource(String string) {
		nomRessource = string;
	}

	/**
	* @param string
	*/
	public void setPrenomRessource(String string) {
		prenomRessource = string;
	}
   
	/**
	* @param string
	*/
	public void setContrat(String string) {
		contrat = string;
	}
   
	/**
	* @param string
	*/
	public void setDatfact(String string) {
		datfact = string;
	}


	/**
	 * @param string
	 */
	public void setLienHref(String string) {
		lienHref = string;
	}

}
