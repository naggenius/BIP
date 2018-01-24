package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import com.socgen.bip.commun.form.AutomateForm;
import com.socgen.bip.metier.InfosTraitFacture;

public class RapportDemFactureForm extends AutomateForm
{
	private InfosTraitFacture[] listeTracesFactures;

	private String windowTitle ;
	public String habilitationPage;

	

	public String getHabilitationPage() {
		return habilitationPage;
	}



	public void setHabilitationPage(String habilitationPage) {
		this.habilitationPage = habilitationPage;
	}



	public InfosTraitFacture[] getListeTracesFactures() {
		return listeTracesFactures;
	}



	public void setListeTracesFactures(InfosTraitFacture[] listeTracesFactures) {
		this.listeTracesFactures = listeTracesFactures;
	}



	public String getWindowTitle() {
		return windowTitle;
	}



	public void setWindowTitle(String windowTitle) {
		this.windowTitle = windowTitle;
	}



	public void removeListe(HttpServletRequest request){
		(request.getSession(false)).removeAttribute("listeRechercheId");	
	}
}