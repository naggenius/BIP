package com.socgen.bip.form;


import com.socgen.bip.commun.form.AutomateForm;


/**
 * @author X059413
 *
 * 
 * chemin : Ligne BIP / Paramètrage
 * pages  : 
 * pl/sql : 
 */
public class ParamLigneBipForm extends AutomateForm {

	/*
	 * Type action
	 */
	private String type_action;
	
	/*
    * champ
	*/
	private String[] champ;
	
	/*
	* champselect
	*/
	private String[] champselect;
	

	/**
	 * @return
	 */
	public String getType_action() {
		return type_action;
	}

	/**
	 * @param string
	 */
	public void setType_action(String string) {
		type_action = string;
	}

  
	
	public String[] getChamp() {
		return champ;
	}public void setChamp(String[] string) {
		champ = string;
	}

   	public String[] getChampselect() {
		return champselect;
	}

	public void setChampselect(String[] string) {
			champselect = string;
	}


}
