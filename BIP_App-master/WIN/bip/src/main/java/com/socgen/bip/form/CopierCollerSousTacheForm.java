package com.socgen.bip.form;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author S LALLIER
 * chemin : Saisie des réalisés/Paramétrage/Copier/coller Sous-tâche
 * pages  : fSoustachecopiercollerSr.jsp, mfSoustachecopiercollerSr.jsp
 * pl/sql : isac_copier_coller.sql
 */
public class CopierCollerSousTacheForm extends AutomateForm {

	/*Le code pid de sous tache a copier
		*/
	private String pid_src;
	/*Le code pid de la tache qui va recevoir la sous-tache
	*/
	private String pid_dest;
	/*Le keyList0
	*/
	private String keyList0;

	/*Le keyList1
		*/
	private String keyList1;
	
	/* La sous tâche sélectionnée
	 */ 
	private String sous_tache;
	
	/* La tâche sélectionnée
	 */
	private String tache;
	
	/*Affectation des ressources (OUI, NON ou AVEC)
	*/
	private String affecter;
	
	/*Le mois pour le déplacement des consommés pour le cas 
	  où affecter = AVEC*/
	private String mois;
	

	public String getKeyList0() {
		return keyList0;
	}

	public String getKeyList1() {
		return keyList1;
	}

	public String getPid_dest() {
		return pid_dest;
	}

	public String getPid_src() {
		return pid_src;
	}
	
	public String getAffecter(){
		return affecter;
	}
	
	public String getMois(){
		return mois;
	}

	public void setKeyList0(String string) {
		keyList0 = string;
	}

	public void setKeyList1(String string) {
		keyList1 = string;
	}

	public void setPid_dest(String string) {
		pid_dest = string;
	}

	public void setPid_src(String string) {
		pid_src = string;
	}
	
	public void setAffecter(String string) {
		affecter = string;
	}
	
	public void setMois(String string) {
		mois = string;
	}

	/**
	 * @return
	 */
	public String getSous_tache() {
		return sous_tache;
	}

	/**
	 * @return
	 */
	public String getTache() {
		return tache;
	}

	/**
	 * @param string
	 */
	public void setSous_tache(String string) {
		sous_tache = string;
	}

	/**
	 * @param string
	 */
	public void setTache(String string) {
		tache = string;
	}

}
