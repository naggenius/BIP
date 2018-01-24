package com.socgen.bip.form;

import java.util.ArrayList;
import java.util.Iterator;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;
import com.socgen.bip.metier.LoupeSimulImmo;
import com.socgen.bip.metier.TypeEtape;

public class SelectLoupeSimulImmoForm  extends AutomateForm {
	
	private int liste_size;
	
	private String contexte;
	
	private ArrayList<LoupeSimulImmo> valeur_loupe = new ArrayList<LoupeSimulImmo>();

	public SelectLoupeSimulImmoForm() {
		super();
		// TODO Auto-generated constructor stub
	}


	public ArrayList<LoupeSimulImmo> getValeur_loupe() {
		return valeur_loupe;
	}


	public void setValeur_loupe(ArrayList<LoupeSimulImmo> valeur_loupe) {
		this.valeur_loupe = valeur_loupe;
	}


	public int getListe_size() {
		return liste_size;
	}

	public void setListe_size(int liste_size) {
		this.liste_size = liste_size;
	} 
	
	public String getContexte() {
		return contexte;
	}

	public void setContexte(String contexte) {
		this.contexte = contexte;
	}

	public void reset(ActionMapping mapping, HttpServletRequest request) {
    	super.reset(mapping,request);
		Iterator<LoupeSimulImmo> it = this.valeur_loupe.iterator();
		while (it.hasNext()) 
		{
			LoupeSimulImmo te = it.next();
			te.setSelect("0");
		
		}
	}

}
