package com.socgen.bip.form;


import com.socgen.bip.commun.form.AutomateForm;


public class ConsultPerimsRestitForm extends AutomateForm {
	
	private String codeRestit;
	private String matRess;
	private String datedeb;
	private String datefin;
	private String heuredeb;
	private String heurefin;
	
	public ConsultPerimsRestitForm() {
		super();
	}

	/**
	 * @return the codeRestit
	 */
	public String getCodeRestit() {
		return codeRestit;
	}

	/**
	 * @param codeRestit the codeRestit to set
	 */
	public void setCodeRestit(String codeRestit) {
		this.codeRestit = codeRestit;
	}

	/**
	 * @return the datedeb
	 */
	public String getDatedeb() {
		return datedeb;
	}

	/**
	 * @param datedeb the datedeb to set
	 */
	public void setDatedeb(String datedeb) {
		this.datedeb = datedeb;
	}

	/**
	 * @return the datefin
	 */
	public String getDatefin() {
		return datefin;
	}

	/**
	 * @param datefin the datefin to set
	 */
	public void setDatefin(String datefin) {
		this.datefin = datefin;
	}

	/**
	 * @return the heuredeb
	 */
	public String getHeuredeb() {
		return heuredeb;
	}

	/**
	 * @param heuredeb the heuredeb to set
	 */
	public void setHeuredeb(String heuredeb) {
		this.heuredeb = heuredeb;
	}

	/**
	 * @return the heurefin
	 */
	public String getHeurefin() {
		return heurefin;
	}

	/**
	 * @param heurefin the heurefin to set
	 */
	public void setHeurefin(String heurefin) {
		this.heurefin = heurefin;
	}

	/**
	 * @return the matRess
	 */
	public String getMatRess() {
		return matRess;
	}

	/**
	 * @param matRess the matRess to set
	 */
	public void setMatRess(String matRess) {
		this.matRess = matRess;
	}

	/**
	 * @return
	 * @see java.lang.String#toString()
	 */
	public String toString() {
		System.out.println("ConsultPerimsRestitForm.msgErreur<<<<<<<<" + this.msgErreur);
		return codeRestit.toString();
	}


}
