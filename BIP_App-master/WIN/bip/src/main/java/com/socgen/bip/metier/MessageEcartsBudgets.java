package com.socgen.bip.metier;

import java.util.Vector;


/**
 * @author DDI - 29/03/2006
 *
 * représente un groupe et les écarts de ce groupe
 * chemin : BudgetJH Ecarts Budgétaires
 * pages  : MessageEcartsBudgets.jsp
 * pl/sql : pack_budget_ecart.sql
 */
public class MessageEcartsBudgets {
					
	/*Le dpg
	*/
	private String codsg;
	/*Le nom du chef de groupe
	*/
	private String gnom;
	/*Contient les lines des messages
	*/
	private Vector message;
	
	/**
	 * Constructor for Ecart.
	 */
	public MessageEcartsBudgets() {
		super();
	}
    
	public MessageEcartsBudgets(String codsg, String gnom, Vector message) {
		super();
		this.codsg = codsg;
		this.gnom = gnom;
		this.message = message;			
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
	 * Returns the message.
	 * @return Vector
	 */
	public Vector getMessage() {
		return message;
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
	 * @param cdeb The cdeb to set
	 */
	public void setGnom(String gnom) {
		this.gnom = gnom;
	}

	/**
	 * Sets the message.
	 * @param ident The message to set
	 */
	public void setMessage(Vector message) {
		this.message = message;
	}
}
