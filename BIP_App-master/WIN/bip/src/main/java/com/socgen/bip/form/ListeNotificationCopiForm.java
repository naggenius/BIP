package com.socgen.bip.form;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * JAL fiche 662 
 * Form servant à la gestion des listes du COPI
 * @author X060314
 *
 */
public class ListeNotificationCopiForm extends AutomateForm {
	
	private String codeChoisi ;    
	
	private String code ;
	
	private String libelle;
	
	private String codePourSupprimer ; 

	public ListeNotificationCopiForm() {
		super();
		// TODO Raccord de constructeur auto-généré
	}

 
	
		public String getCode() {
			return this.code;
		}
	
	
	
		public void setCode(String code) {
			this.code = code;
		}
	
	
	
		public String getLibelle() {
			return this.libelle;
		}
	
		public void setLibelle(String libelle) {
			this.libelle = libelle;
		}
	
	
	
		public String getCodeChoisi() {
			return this.codeChoisi;
		}
	
	
	
		public void setCodeChoisi(String codeChoisi) {
			this.codeChoisi = codeChoisi;
		}



		public String getCodePourSupprimer() {
			return this.codePourSupprimer;
		}



		public void setCodePourSupprimer(String codePourSupprimer) {
			this.codePourSupprimer = codePourSupprimer;
		}
	
	
	 
	
	}
