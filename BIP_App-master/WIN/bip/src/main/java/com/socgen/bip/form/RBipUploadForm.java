/*
 * Créé le 20 août 04
 *
 */
package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.upload.FormFile;

import com.socgen.bip.commun.form.AutomateForm;

/**
 *
 * @author X039435
 */
public class RBipUploadForm extends AutomateForm
{
	FormFile fichier;
	
	String fichier_path;
	
	String BtnCtrlSlt;
	/**
	 * @return
	 */
	public FormFile getFichier()
	{
		return fichier;
	}

	/**
	 * @param file
	 */
	public void setFichier(FormFile file)
	{
		fichier = file;
	}

	public String getFichier_path() {
		return fichier_path;
	}

	public void setFichier_path(String fichier_path) {
		this.fichier_path = fichier_path;
	}
	
	
	
	public RBipUploadForm(FormFile fichier, String fichier_path,String BtnCtrlSlt) {
		super();
		this.fichier = fichier;
		this.fichier_path = fichier_path;
		this.BtnCtrlSlt = BtnCtrlSlt;
	}
	
	public RBipUploadForm() {
		super();
	}

	public ActionErrors validate(ActionMapping mapping,
			HttpServletRequest request) {

		ActionErrors errors = new ActionErrors();

		this.logIhm
				.debug("Dï¿½but validation de la form -> " + this.getClass());

		logIhm.debug("Fin validation de la form -> " + this.getClass());
		return errors;
	}

	public String getBtnCtrlSlt() {
		return BtnCtrlSlt;
	}

	public void setBtnCtrlSlt(String btnCtrlSlt) {
		BtnCtrlSlt = btnCtrlSlt;
	}

}
