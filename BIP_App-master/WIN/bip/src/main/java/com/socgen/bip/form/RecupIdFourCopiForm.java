package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import com.socgen.bip.commun.form.AutomateForm;
import com.socgen.bip.metier.InfosFourCopi;

public class RecupIdFourCopiForm  extends AutomateForm {
	
	private String nomRecherche ;
	private InfosFourCopi[] listeFourCopi;

	private String windowTitle ;
	public  String nomChampDestinataire;
	public  String habilitationPage;
	
	public String getHabilitationPage() {
		return habilitationPage;
	}
	public void setHabilitationPage(String habilitationPage) {
		this.habilitationPage = habilitationPage;
	}
	public InfosFourCopi[] getFisteFourCopi() {
		return listeFourCopi;
	}
	public void setListeFourCopi (InfosFourCopi[] listeFourCopi) {
		this.listeFourCopi = listeFourCopi;
	}
	public String getNomChampDestinataire() {
		return nomChampDestinataire;
	}
	public void setNomChampDestinataire(String nomChampDestinataire) {
		this.nomChampDestinataire = nomChampDestinataire;
	}
	public String getNomRecherche() {
		return nomRecherche;
	}
	public void setNomRecherche(String nomRecherche) {
		this.nomRecherche = nomRecherche;
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
