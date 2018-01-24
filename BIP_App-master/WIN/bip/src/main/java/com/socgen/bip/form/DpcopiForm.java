package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author E.VINATIER 18/04/2008
 *
 * pages  : fmDpcopiAd.jsp et mDpcopiAd.jsp
 * pl/sql : copi.sql
 */
public class DpcopiForm extends AutomateForm{
 
 
	/*Le code dossier projet copi
	*/   
    private String dp_copi ; 
    
    /*Le libelle du dossier projet copi
	*/   
    private String libelle ;
    
    /*Le code dossier projet
	*/  
    private String dpcode ;
    
    /*Code client
	*/   
    private String clicode ;
    
    private String sous_systeme;
    
    private String domaine;
    
    private String sous_systeme_lib;
    
    private String domaine_lib;
   
	/*Le flaglock
	*/
	private int flaglock ;
	
	private String axe_strategique;
	
	private String etape;
	
	private String typeFinancement;
	
	private String quote_part;
	
	// MCH : PPM 61919 chapitre 6.7
	private String dpcopiaxemetier;
	
	
	
	
				
	/**
	 * Constructor for ClientForm.
	 */
	public DpcopiForm() {
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
     
        logIhm.debug( "Fin validation de la form -> " + this.getClass()) ;
        return errors; 
    }

public String getClicode() {
	return clicode;
}

public void setClicode(String clicode) {
	this.clicode = clicode;
}

public String getDp_copi() {
	return dp_copi;
}

public void setDp_copi(String dp_copi) {
	this.dp_copi = dp_copi;
}

public String getDpcode() {
	return dpcode;
}

public void setDpcode(String dpcode) {
	this.dpcode = dpcode;
}

public int getFlaglock() {
	return flaglock;
}

public void setFlaglock(int flaglock) {
	this.flaglock = flaglock;
}

public String getLibelle() {
	return libelle;
}

public void setLibelle(String libelle) {
	this.libelle = libelle;
}

public String getDomaine() {
	return domaine;
}

public void setDomaine(String domaine) {
	this.domaine = domaine;
}

public String getSous_systeme() {
	return sous_systeme;
}

public void setSous_systeme(String sous_systeme) {
	this.sous_systeme = sous_systeme;
}

public String getDomaine_lib() {
	return domaine_lib;
}

public void setDomaine_lib(String domaine_lib) {
	this.domaine_lib = domaine_lib;
}

public String getSous_systeme_lib() {
	return sous_systeme_lib;
}

public void setSous_systeme_lib(String sous_systeme_lib) {
	this.sous_systeme_lib = sous_systeme_lib;
}

public String getAxe_strategique() {
	return axe_strategique;
}

public void setAxe_strategique(String axe_strategique) {
	this.axe_strategique = axe_strategique;
}

public String getEtape() {
	return etape;
}

public void setEtape(String etape) {
	this.etape = etape;
}

public String getTypeFinancement() {
	return typeFinancement;
}

public void setTypeFinancement(String typeFinancement) {
	this.typeFinancement = typeFinancement;
}

public String getQuote_part() {
	return quote_part;
}

public void setQuote_part(String quote_part) {
	this.quote_part = quote_part;
}

public String getdpcopiaxemetier() {
	return dpcopiaxemetier;
}

public void setdpcopiaxemetier(String dpcopiaxemetier) {
	this.dpcopiaxemetier = dpcopiaxemetier;
}



	


}
