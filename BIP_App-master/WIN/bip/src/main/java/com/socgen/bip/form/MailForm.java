package com.socgen.bip.form;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author E VINATIER
 * Formulaire pour mise à jour des adresse mail de contact
 * page : majMail.jsp
 */
public class MailForm extends AutomateForm {
	private String codremonte;
	private String mail1;
	private String mail2;
	private String mail3 ;
	
	public String getCodremonte() {
		return codremonte;
	}

	public void setCodremonte(String codremonte) {
		this.codremonte = codremonte;
	}

	public String getMail1() {
		return mail1;
	}

	public void setMail1(String mail1) {
		this.mail1 = mail1;
	}

	public String getMail2() {
		return mail2;
	}

	public void setMail2(String mail2) {
		this.mail2 = mail2;
	}

	public String getMail3() {
		return mail3;
	}

	public void setMail3(String mail3) {
		this.mail3 = mail3;
	}

	public MailForm() {
		super();		
	}
	
	
}
