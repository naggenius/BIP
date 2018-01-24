package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;
/**
 * @author MMC
 *
 * Formualire correspondant aux ressources de l'outil de reestime
 * chemin : Mise à jour / Ressources
 * pages  : bRessourceRe.jsp, fmRessourceRe.jsp, mRessourceRe.jsp,
 * pl/sql : ree_ress.sql
 */
public class RessReesForm extends AutomateForm {

	/*
	 * Code DPG
	 */
	private String codsg;
	/*
	 * type de ressource
	 */
	private String type;
	/*
		 * type de ressource
		 */
		private String type_choisi;

	/*
	 * nom de la ressource
	 */
		private String rnom;
	/*
	 * prenom de ressource
	 */
		private String rprenom;
	/*
	 * identifiant de ressource + type
	 */
		private String ident;
	/*
		 * identifiant de ressource
		 */
			private String code_ress;
	/*
		 * choix bouton radio
		 */
			private String choix;
	/*
	* identifiant pour une ressource fictive
	*/
		private String ident_fict;
	/*
	* identifiant pour une ressource hors du groupe
	*/
		private String ident_hors;
	/*
		 * identifiant de ressource
		 */
			private String ident_choisi;
	/*
	 * date de depart de la ressource
	 */
			private String datdep;

	/*
	 * date d'arrivee de la ressource
	 */
			private String datarrivee;
	/**
	 * Constructor for RessReesForm.
	 */
	public RessReesForm() {
		super();
	}
	
	public ActionErrors validate(ActionMapping mapping,
									 HttpServletRequest request) {


			ActionErrors errors = new ActionErrors();
        
			this.logIhm.debug("Début validation de la form -> " + this.getClass()) ;
     
			logIhm.debug( "Fin validation de la form -> " + this.getClass()) ;
			return errors; 
		}
	
	/**
	 * @return
	 */
	public String getCodsg() {
		return codsg;
	}

	/**
	 * @return
	 */
	public String getDatdep() {
		return datdep;
	}

	/**
	 * @return
	 */
	public String getIdent() {
		return ident;
	}

	/**
		 * @return
		 */
		public String getIdent_choisi() {
			return ident_choisi;
		}
	/**
	 * @return
	 */
	public String getRnom() {
		return rnom;
	}

	/**
	 * @return
	 */
	public String getRprenom() {
		return rprenom;
	}

	/**
	 * @return
	 */
	public String getType() {
		return type;
	}
	/**
	* @return
	*/
		public String getType_choisi() {
			return type_choisi;
		}

	/**
	 * @param string
	 */
	public void setCodsg(String string) {
		codsg = string;
	}

	/**
	 * @param string
	 */
	public void setDatdep(String string) {
		datdep = string;
	}

	/**
	 * @param string
	 */
	public void setIdent(String string) {
		ident = string;
	}
	
	/**
		 * @param string
		 */
		public void setIdent_choisi(String string) {
			ident_choisi = string;
		}

	/**
	 * @param string
	 */
	public void setRnom(String string) {
		rnom = string;
	}

	/**
	 * @param string
	 */
	public void setRprenom(String string) {
		rprenom = string;
	}

	/**
	 * @param string
	 */
	public void setType(String string) {
		type = string;
	}
	/**
		 * @param string
		 */
		public void setType_choisi(String string) {
			type_choisi = string;
		}
	/**
	 * @return
	 */
	public String getIdent_fict() {
		return ident_fict;
	}

	/**
	 * @return
	 */
	public String getIdent_hors() {
		return ident_hors;
	}

	/**
	 * @param string
	 */
	public void setIdent_fict(String string) {
		ident_fict = string;
	}

	/**
	 * @param string
	 */
	public void setIdent_hors(String string) {
		ident_hors = string;
	}

	/**
	 * @return
	 */
	public String getChoix() {
		return choix;
	}

	/**
	 * @param string
	 */
	public void setChoix(String string) {
		choix = string;
	}

	/**
	 * @return
	 */
	public String getCode_ress() {
		return code_ress;
	}

	/**
	 * @param string
	 */
	public void setCode_ress(String string) {
		code_ress = string;
	}

	/**
	 * @return
	 */
	public String getDatarrivee() {
		return datarrivee;
	}

	/**
	 * @param string
	 */
	public void setDatarrivee(String string) {
		datarrivee = string;
	}

}

