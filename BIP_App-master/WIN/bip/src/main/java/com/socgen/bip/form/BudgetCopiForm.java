package com.socgen.bip.form;


import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.LabelValueBean;

import com.socgen.bip.commun.form.AutomateForm;


/**
 * @author J.Alves - 10/04/2008
 *
 *  Form pour écrans Budget COPI
 * 
 */
public class BudgetCopiForm extends AutomateForm {

 
 
	/**
	 * Constructor for DpgForm.
	 */
	public BudgetCopiForm() {
		super();
	}

	  /**
     * Validate the properties that have been set from this HTTP request,
     * and return an <code>ActionErrors</code> object that encapsulates any
     * validation errors that have been found.  If no errors are found, return
     * <code>null</code> or an <code>ActionErrors</code> object with no
     * recorded error messages.
     *
     * @param mapping The mapping used to select this instance
     * @param request The servlet request we are processing
     */
    public ActionErrors validate(ActionMapping mapping,
                                 HttpServletRequest request) {


        ActionErrors errors = new ActionErrors();
        
        this.logIhm.debug("Début validation de la form -> " + this.getClass()) ;
        // errors.add("Test" , new ActionError("errors.header"));
        logIhm.debug( "Fin validation de la form -> " + this.getClass()) ;
        return errors; 
    }
    
    
 
    
    private String dpcopi ;
    
    private String datecopi  ;
    
    private String annee ;
    
    private String fournisseurCopi ; 
    
    private String metier ;
    
    private String typeDemande ;
    
    private String jhArbitresDemandes ; // renommé IHM par JH Demandés
    
    private String jhArbitresDecides ; // renommé IHM par JH Decidés
    
    private String jhCantonnesDemandes ;
    
    private String jhCantonnesDecides ;
  
    private String jhCoutTotal ; // renommé IHM par JH Prévisionnel Demandé
    
    private String jhPrevisionnelDecide;
    
    private String keJhArbitresDemandes ; // renommé IHM KEuro Demandé
    
    private String keJhArbitresDecides ; // renommé IHM KEuro Decidé
    
    private String keJhCantonnesDemandes ;
    
    private String keJhCantonnesDecides ;
  
    private String keJhCoutTotal; // renommé IHM Keuro Prévisonnel Demandé
    
    private String keJhPreviDecide;
    
    private String coutKE ; 
    
    private ArrayList listeAnnees ; 
    
 
    //Gestion Pagination
    private String nombrePagesRelatif ; 
    
    private int nbbudgetcopi ; 
    
    private String type;
 


	public String getAnnee() {
		return this.annee;
	}

	public void setAnnee(String anneeParam) {
		this.annee = anneeParam;
	} 
 

	public String getFournisseurCopi() {
		return fournisseurCopi;
	}

	public void setFournisseurCopi(String fournisseurCopi) {
		this.fournisseurCopi = fournisseurCopi;
	}

	public String getJhArbitresDecides() {
		return jhArbitresDecides;
	}

	public void setJhArbitresDecides(String jhArbitresDecides) {
		this.jhArbitresDecides = jhArbitresDecides;
	}

	public String getJhArbitresDemandes() {
		return jhArbitresDemandes;
	}

	public void setJhArbitresDemandes(String jhArbitresDemandes) {
		this.jhArbitresDemandes = jhArbitresDemandes;
	}

	public String getJhCantonnesDecides() {
		return jhCantonnesDecides;
	}

	public void setJhCantonnesDecides(String jhCantonnesDecides) {
		this.jhCantonnesDecides = jhCantonnesDecides;
	}

	public String getJhCantonnesDemandes() {
		return jhCantonnesDemandes;
	}

	public void setJhCantonnesDemandes(String jhCantonnesDemandes) {
		this.jhCantonnesDemandes = jhCantonnesDemandes;
	}

	public String getMetier() {
		return metier;
	}

	public void setMetier(String metier) {
		this.metier = metier;
	}

	public String getTypeDemande() {
		return typeDemande;
	}

	public void setTypeDemande(String typeDemande) {
		this.typeDemande = typeDemande;
	}
    

	/**
	 * retourne la liste des années de  :  an-1  à   an+ 4
	 * @return
	 */
	public ArrayList getListeAnnees() { 
	 
		return this.listeAnnees;
	 
	}

	/**
	 * Introspection appellée par struts : affichera toujours la liste si utilisé 
	 * dans une liste d'options HTML
	 * 
	 * @param listeAnnees
	 */
	public void setListeAnnees(ArrayList listeAnnees) {
		 
		this.listeAnnees = listeAnnees;
	}

	public String getJhCoutTotal() {
		return jhCoutTotal;
	}

	public void setJhCoutTotal(String jhCoutTotal) {
		this.jhCoutTotal = jhCoutTotal;
	}

	public String getKeJhArbitresDecides() {
		return keJhArbitresDecides;
	}

	public void setKeJhArbitresDecides(String keJhArbitresDecides) {
		this.keJhArbitresDecides = keJhArbitresDecides;
	}

	public String getKeJhArbitresDemandes() {
		return keJhArbitresDemandes;
	}

	public void setKeJhArbitresDemandes(String keJhArbitresDemandes) {
		this.keJhArbitresDemandes = keJhArbitresDemandes;
	}

	public String getKeJhCantonnesDecides() {
		return keJhCantonnesDecides;
	}

	public void setKeJhCantonnesDecides(String keJhCantonnesDecides) {
		this.keJhCantonnesDecides = keJhCantonnesDecides;
	}

	public String getKeJhCantonnesDemandes() {
		return keJhCantonnesDemandes;
	}

	public void setKeJhCantonnesDemandes(String keJhCantonnesDemandes) {
		this.keJhCantonnesDemandes = keJhCantonnesDemandes;
	}

	public String getKeJhCoutTotal() {
		return keJhCoutTotal;
	}

	public void setKeJhCoutTotal(String keJhCoutTotal) {
		this.keJhCoutTotal = keJhCoutTotal;
	}

	public String getNombrePagesRelatif() {
		return nombrePagesRelatif;
	}

	public void setNombrePagesRelatif(String nombrePagesRelatif) {
		this.nombrePagesRelatif = nombrePagesRelatif;
	}


	public int getNbbudgetcopi() {
		return this.nbbudgetcopi;
	}

	public void setNbbudgetcopi(int nbbudgetcopi) {
		this.nbbudgetcopi = nbbudgetcopi;
	}

	public String getDatecopi() {
		return datecopi;
	}

	public void setDatecopi(String datecopi) {
		this.datecopi = datecopi;
	}

	public String getDpcopi() {
		return dpcopi;
	}

	public void setDpcopi(String dpcopi) {
		this.dpcopi = dpcopi;
	}
	
	public String getKeJhPreviDecide() {
		return keJhPreviDecide;
	}

	public void setKeJhPreviDecide(String keJhPreviDecide) {
		this.keJhPreviDecide = keJhPreviDecide;
	}

	public String getJhPrevisionnelDecide() {
		return jhPrevisionnelDecide;
	}

	public void setJhPrevisionnelDecide(String jhPrevisionnelDecide) {
		this.jhPrevisionnelDecide = jhPrevisionnelDecide;
	}


	public void razMontants(){
    	this.jhArbitresDecides = "0" ; 
    	this.jhArbitresDemandes = "0" ;
    	this.jhCantonnesDecides = "0" ;
    	this.jhCantonnesDemandes = "0" ;
    	this.jhCoutTotal = "0" ;
    	this.jhPrevisionnelDecide="0";
    	
    	
    }

	public String getCoutKE() {
		return coutKE;
	}

	public void setCoutKE(String coutKE) {
		this.coutKE = coutKE;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	
    

}
