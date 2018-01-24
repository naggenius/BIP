package com.socgen.bip.form;

import java.util.ArrayList;

import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;
import com.socgen.bip.metier.TraitBatch;

public class TraitBatchForm extends AutomateForm {
	
	private String jour;
	
	private String listeTraitSuppr;
	
	private int size;
	
    private ArrayList<TraitBatch> listeTraitBatch;
    
    private ArrayList<TraitBatch> listeShell;
    
    private String infos_shell;
 
    private ArrayList<TraitBatch> listeDonneeCsv;
    
    private String full_Path;
    
    /**
	 * Messages d'erreur fichier invalide
	 */
	public final static String ERREUR_PROBLEME_FORMAT = "Problème de format";
	public final static String ERREUR_PROBLEME_EN_TETE = "Problème d'en-tête";
	public final static String ERREUR_PROBLEME_ENREGISTREMENT = "Problème d'enregistrement";
	public final static String ERREUR_TAILLE_FICHIER = "Problème de taille de fichier";
	/**
	 * Message d'erreur fichier non trouvé
	 */
	public final static String ERREUR_FICHIER_NON_TROUVE = "Fichier non trouvé";
    
	public TraitBatchForm() {
		super();
	}
	
	public TraitBatch getTrait(int index){
		
		while(listeTraitBatch.size() <= index){

			listeTraitBatch.add(new TraitBatch());

			}

			return (TraitBatch) listeTraitBatch.get(index);
		
	}

	public String getJour() {
		return jour;
	}

	public void setJour(String jour) {
		this.jour = jour;
	}

	public ArrayList<TraitBatch> getListeTraitBatch() {
		return listeTraitBatch;
	}

	public void setListeTraitBatch(ArrayList<TraitBatch> listeTraitBatch) {
		this.listeTraitBatch = listeTraitBatch;
	}

	public int getSize() {
		return size;
	}

	public void setSize(int size) {
		this.size = size;
	}
	
	public void reset(ActionMapping mapping,
            javax.servlet.ServletRequest request){
		super.reset(mapping, request);
		listeTraitBatch = new ArrayList<TraitBatch>();
	}
	
	public void first(){
		super.setMsgErreur("");
		jour = "";
	}

	public ArrayList<TraitBatch> getListeShell() {
		return listeShell;
	}

	public void setListeShell(ArrayList<TraitBatch> listeShell) {
		this.listeShell = listeShell;
	}

	public String getListeTraitSuppr() {
		return listeTraitSuppr;
	}

	public void setListeTraitSuppr(String listeTraitSuppr) {
		this.listeTraitSuppr = listeTraitSuppr;
	}

	public String getInfos_shell() {
		return infos_shell;
	}

	public void setInfos_shell(String infos_shell) {
		this.infos_shell = infos_shell;
	}

	public ArrayList<TraitBatch> getListeDonneeCsv() {
		return listeDonneeCsv;
	}

	public void setListeDonneeCsv(ArrayList<TraitBatch> listeDonneeCsv) {
		this.listeDonneeCsv = listeDonneeCsv;
	}

	public String getFull_Path() {
		return full_Path;
	}

	public void setFull_Path(String full_Path) {
		this.full_Path = full_Path;
	}


}
