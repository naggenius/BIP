package com.socgen.bip.metier;

import org.apache.commons.lang.StringUtils;
import org.apache.struts.upload.FormFile;


public class TraitBatch {
	
	private String id_trait_batch;

	private String nom_shell;
	
	private String nom_fich;
	
	private String id_shell;
	
	private String date_shell;
	
	private String heure_shell;
	
	private String lienHref;
	
	private String flagSuppr;
	
	private FormFile fichier;
	
	private String tailleClob;
	
	private String top_exec;
	
	private String top_retour;
	
	private String top_ano;

	private String fichier_retour;
	
	private String donnee_retour;
	

	public String getFichier_retour() {
		return fichier_retour;
	}

	public void setFichier_retour(String fichier_retour) {
		this.fichier_retour = fichier_retour;
	}

	public String getDonnee_retour() {
		return donnee_retour;
	}

	public void setDonnee_retour(String donnee_retour) {
		this.donnee_retour = donnee_retour;
	}


	public String getTop_retour() {
		return top_retour;
	}

	public void setTop_retour(String top_retour) {
		this.top_retour = top_retour;
	}

	public String getTop_ano() {
		return top_ano;
	}

	public void setTop_ano(String top_ano) {
		this.top_ano = top_ano;
	}

	public TraitBatch() {
		super();
		// TODO Auto-generated constructor stub
	}

    public String getNom_shell() {
		return nom_shell;
	}

	public void setNom_shell(String nom_shell) {
		this.nom_shell = nom_shell;
	}
	
	public String getDate_shell() {
		return date_shell;
	}

	public void setDate_shell(String date_shell) {
		this.date_shell = date_shell;
	}

	public String getId_shell() {
		return id_shell;
	}

	public void setId_shell(String id_shell) {
		this.id_shell = id_shell;
	}

	public String getNom_fich() {
		return nom_fich;
	}

	public void setNom_fich(String nom_fich) {
		this.nom_fich = nom_fich;
	}

	public String getLienHref() {
		return lienHref;
	}

	public void setLienHref(String lienHref) {
		this.lienHref = lienHref;
	}

	public String getHeure_shell() {
		return heure_shell;
	}

	public void setHeure_shell(String heure_shell) {
		this.heure_shell = heure_shell;
	}
	
	public String getInfos_shell(){
		return nom_shell + " ("+((nom_fich==null)?"Aucun fichier en entrée":nom_fich)+")";
	}
	
	public String getInfos_batch() {
		String retour = "";
		
		if (nom_shell != null) {
			// Ajout nom du shell
			retour += nom_shell;
		}

		if (fichier != null && fichier.getFileName() != null) {
			if (StringUtils.isNotEmpty(retour)) {
				// Ajout retour charriot
				retour += " ";
			}
			// Ajout nom du fichier
			retour += fichier.getFileName();
		}
		
		return retour;
	}

	public String getId_trait_batch() {
		return id_trait_batch;
	}

	public void setId_trait_batch(String id_trait_batch) {
		this.id_trait_batch = id_trait_batch;
	}

	public TraitBatch(String id_trait_batch, String nom_shell, String nom_fich, String id_shell, String date_shell, String lienHref, String top_exec, String top_retour, String top_ano) {
		super();
			this.id_trait_batch = id_trait_batch;
			this.nom_shell = nom_shell;
			this.nom_fich = nom_fich;
			this.id_shell = id_shell;
			this.date_shell = date_shell;
			this.heure_shell = (date_shell==null)?"":date_shell.substring(11, 16);
			this.lienHref = lienHref;
			this.top_exec = top_exec;
			this.top_retour = top_retour;
			this.top_ano = top_ano;
	}
	
	public void changeHeureShell() {
		date_shell = date_shell.substring(0, 11)+heure_shell;		
	}

	public String getFlagSuppr() {
		return flagSuppr;
	}

	public void setFlagSuppr(String flagSuppr) {
		this.flagSuppr = flagSuppr;
	}

	public FormFile getFichier() {
		return fichier;
	}

	public void setFichier(FormFile fichier) {
		this.fichier = fichier;
	}

	public String getTailleClob() {
		return tailleClob;
	}

	public void setTailleClob(String uploadOK) {
		this.tailleClob = uploadOK;
	}
	public String getTop_exec() {
		return top_exec;
	}
	public void setTop_exec(String top_exec) {
		this.top_exec = top_exec;
	}
	
}
