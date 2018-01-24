/*
 * Créé le 20 août 04
 *
 */
package com.socgen.bip.form;

import org.apache.struts.upload.FormFile;

import com.socgen.bip.commun.form.BipForm;

/**
 *
 * @author X116028
 */
public class BUploadAdForm extends BipForm
{
	FormFile fichier;
	
	String repDest;
	
	public String getRepDest() {
		return repDest;
	}

	public void setRepDest(String repDest) {
		this.repDest = repDest;
	}

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

}
