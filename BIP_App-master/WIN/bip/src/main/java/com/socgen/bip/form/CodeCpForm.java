package com.socgen.bip.form;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author S LALLIER
 * Formulaire pour mise à jour des codes chef de projets
 * page : mCodeCpAd.jsp
 */
public class CodeCpForm extends AutomateForm {
	private String codsg;
	private String pcpi;
	private String nouveau_pcpi;
	private int flaglock ;
	
	public CodeCpForm() {
		super();		
	}
	
	public String getCodsg() {
		return codsg;
	}

	public int getFlaglock() {
		return flaglock;
	}

	public String getNouveau_pcpi() {
		return nouveau_pcpi;
	}

	public String getPcpi() {
		return pcpi;
	}

	public void setCodsg(String string) {
		codsg = string;
	}

	public void setFlaglock(int i) {
		flaglock = i;
	}

	public void setNouveau_pcpi(String string) {
		nouveau_pcpi = string;
	}

	public void setPcpi(String string) {
		pcpi = string;
	}

}
