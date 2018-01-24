package com.socgen.bip.action;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Hashtable;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.upload.FormFile;

import com.socgen.bip.commun.action.BipAction;
import com.socgen.bip.form.BUploadAdForm;

public class BUploadAdAction extends BipAction
{
	public ActionForward bipPerform(ActionMapping mapping,
			ActionForm form,
			HttpServletRequest request,
			HttpServletResponse response,
			Hashtable hParamProc) throws IOException, ServletException
	{
			BUploadAdForm uploadForm = (BUploadAdForm) form;
			FormFile fichier = uploadForm.getFichier();
			File fichierACreer = new File(uploadForm.getRepDest(),fichier.getFileName());
			FileOutputStream fileOutStream = new FileOutputStream(fichierACreer);
            fileOutStream.write(fichier.getFileData());
            fileOutStream.flush();
            fileOutStream.close();
            return mapping.findForward("initial");
	}
}

