package com.socgen.bip.metier;
/**
 * @author DDI - 27/03/2006
 *
 * représente un groupe et le nombre d'écarts
 * chemin : Budget JH/Ecarts Budgétaires
 * pages  : bEcartsBudgetsMessageAd.jsp
 * pl/sql : pack_budget_ecart.sql
 */
public class EcartBudgetPole {

	/*Le dpg
	*/
	private String codsg;
	/*Le nom du chef de groupe
	*/
	private String gnom;
	/*Le libellé de groupe
	*/
	private String libdsg;
	/*Le nombre d'écart du groupe
	*/
	private String nombre;
	
	/**
	 * Constructor for Ecart.
	 */
	public EcartBudgetPole() {
		super();
	}
    
	public EcartBudgetPole(String codsg, String gnom, String libdsg, String nombre) {
		super();
		this.codsg = codsg;
		this.gnom = gnom;
		this.libdsg = libdsg;
		this.nombre = nombre;
	}

	/**
	 * Returns the codsg.
	 * @return String
	 */
	public String getCodsg() {
		return codsg;
	}

	/**
	 * Returns the gnom.
	 * @return String
	 */
	public String getGnom() {
		return gnom;
	}

	/**
	 * Returns the libdsg.
	 * @return String
	 */
	public String getLibdsg() {
		return libdsg;
	}

	/**
	 * Returns the nombre.
	 * @return String
	 */
	public String getNombre() {
		return nombre;
	}

	/**
	 * Sets the codsg.
	 * @param codsg The codsg to set
	 */
	public void setCodsg(String codsg) {
		this.codsg = codsg;
	}

	/**
	 * Sets the gnom.
	 * @param cdeb The gnom to set
	 */
	public void setGnom(String gnom) {
		this.gnom = gnom;
	}

	/**
	 * Sets the libdsg.
	 * @param ident The libdsg to set
	 */
	public void setLibdsg(String libdsg) {
		this.libdsg = libdsg;
	}

	/**
	 * Sets the nombre.
	 * @param nom The nombre to set
	 */
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
}
