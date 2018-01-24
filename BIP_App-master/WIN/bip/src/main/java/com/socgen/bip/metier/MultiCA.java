package com.socgen.bip.metier;

/**
 * @author Pierre JOSSE le 10/12/2004
 * Objet Métier représentant un ligne pour la facturation MULTI CA
 */
public class MultiCA{
	/*La Ligne BIP
	*/
	private String pid ;
	/*La date de début
	*/
	private String datdeb ;
	/*La date de fin
	 */
	private String datfin;
	/*Le CA Payeur
	*/
	private String codcamo;
	/* Libellé du CA Payeur
	 */
	private String libCodcamo;
	/* Le code Client
	 */
	private String clicode;
	/* Le libellé du code client
	 */
	private String clilib;
	/* Le Taux de facturation
	 */
	private String tauxrep;

	/**
	 * Constructor for MultiCA.
	 */
	public MultiCA() {
		super();
	}

	/**
	 * Constructor for MultiCA.
	 */
	public MultiCA(String pid, String datdeb, String datfin, String codcamo, String libCodcamo, String clicode, String clilib, String tauxrep) {
		this.pid = pid;
		this.datdeb = datdeb;
		this.datfin = datfin;
		this.codcamo = codcamo;
		this.libCodcamo = libCodcamo;
		this.clicode = clicode;
		this.clilib = clilib;
		this.tauxrep = tauxrep;
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
	public String getDatfin() {
		return datfin;
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
	public void setDatfin(String string) {
		datfin = string;
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
	public void setTauxrep(String string) {
		tauxrep = string;
	}
	/**
	 * @return
	 */
	public String getLibCodcamo() {
		return libCodcamo;
	}

	/**
	 * @param string
	 */
	public void setLibCodcamo(String string) {
		libCodcamo = string;
	}
	/**
	 * @return
	 */
	public String getClicode() {
		return clicode;
	}

	/**
	 * @return
	 */
	public String getClilib() {
		return clilib;
	}

	/**
	 * @param string
	 */
	public void setClicode(String string) {
		clicode = string;
	}

	/**
	 * @param string
	 */
	public void setClilib(String string) {
		clilib = string;
	}

}