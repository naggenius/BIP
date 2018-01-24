package com.socgen.bip.metier;

/**
 * @author BAA le 17/03/2003
 *
 */
public class InfosContrat {
	
	private String contrat;
	private String avenant;
	private String nomRessource;
	private String objet;
	private String datedebut;
	private String datefin;
	private String lienHref;
	

	/**
	 * 
	 */
	public InfosContrat() {
		super();
	}
	
	/**
	 * 
	 */
	public InfosContrat(String contrat, String avenant,String nomRessource, String objet, String datedebut, String datefin, String lienHrefCHoix) {
		this.contrat = contrat;
		this.avenant = avenant;
		this.nomRessource = nomRessource;
		this.objet = objet;
		this.datedebut = datedebut;
		this.datefin = datefin;
		this.lienHref = lienHrefCHoix;
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
	public String getAvenant() {
		return avenant;
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
	public String getObjet() {
		return objet;
	}		
  
	
	/**
	 * @return
	 */
	public String getDatedebut() {
		return datedebut;
	}

	/**
	* @return
	*/
	public String getDatefin() {
			return datefin;
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
	public void setContrat(String string) {
		contrat = string;
	}

	/**
	* @param string
	*/
	public void setAvenant(String string) {
		avenant = string;
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
	public void setObjet(String string) {
		objet = string;
	}
   
	/**
	* @param string
	*/
	public void setDatedebut(String string) {
		datedebut = string;
	}
	/**
	* @param string
	*/
	public void setDatefin(String string) {
		datefin = string;
	}	

	/**
	 * @param string
	 */
	public void setLienHref(String string) {
		lienHref = string;
	}

}
