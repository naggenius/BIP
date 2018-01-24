package com.socgen.bip.form;

import java.util.ArrayList;
import java.util.Collection;

import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;
import com.socgen.bip.metier.TraitBatch;
import com.socgen.bip.metier.TypeEtape;

public class TypeEtapeForm extends AutomateForm {
	
	private String type_etape;
	
	private String libelle;
	
	private String top_immo;
	
	private String flaglock;
	
	private int jeu_associe_size;
	
	private String typeLigne;
	
	private ArrayList<TypeEtape> jeu_associe = new ArrayList<TypeEtape>(); 
	
	public TypeEtapeForm() {
		super();
		// TODO Raccord de constructeur auto-généré
	}

	public String getFlaglock() {
		return flaglock;
	}

	public void setFlaglock(String flaglock) {
		this.flaglock = flaglock;
	}

	public String getLibelle() {
		return libelle;
	}

	public void setLibelle(String libelle) {
		this.libelle = libelle;
	}

	public String getTop_immo() {
		return top_immo;
	}

	public void setTop_immo(String top_immo) {
		this.top_immo = top_immo;
	}

	public String getType_etape() {
		return type_etape;
	}

	public void setType_etape(String type_etape) {
		this.type_etape = type_etape;
	}

	public ArrayList<TypeEtape> getJeu_associe() {
		return jeu_associe;
	}

	public void setJeu_associe(ArrayList<TypeEtape> jeu_associe) {
			this.jeu_associe = jeu_associe;
			
	}

	public int getJeu_associe_size() {
		return jeu_associe_size;
	}

	public void setJeu_associe_size(int jeu_associe_size) {
		this.jeu_associe_size = jeu_associe_size;
	}

	public void reset()
	{
		this.jeu_associe = new ArrayList<TypeEtape>();
		this.msgErreur = null;
	}

	public String getTypeLigne() {
		return typeLigne;
	}

	public void setTypeLigne(String typeLigne) {
		this.typeLigne = typeLigne;
	}

}
