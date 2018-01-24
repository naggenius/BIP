package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;
import com.socgen.bip.commun.form.AutomateForm;


/**
 * 
 * @author X060314
 * JAL 15/07/2008 
 * Fiche 662 : DP COPI partie qualitative
 *
 */
public class NotationDpcopiForm extends AutomateForm{
 
 
	/*Le code dossier projet copi
	*/   
    private String dpCopi ; 
         
	private String etape ; 
		
	private String directeurProjet ;
	
	private String responsableBancaire ; 
	
	private String sponsors ; 
	
	private String axeStrategique ; 
	
	private String bloc ;
	
	private String domaine ; 
	
	private String directionRB ; 
	
	private String noteStrategique ; 
	
	private String noteRoi ; 
	
	private String prochainCopi ;
		
	private int flaglock ;
	
	private String libelleEtape ;
	
	private	String libelleAxe ; 
	
	private	String libelleBloc ;
	
	private	String libelleDomaine ;
		

	/**
	 * Constructor for ClientForm.
	 */
	public NotationDpcopiForm() {
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


public String getAxeStrategique() {
	return this.axeStrategique;
}

public void setAxeStrategique(String axeStrategique) {
	this.axeStrategique = axeStrategique;
}

public String getBloc() {
	return this.bloc;
}

public void setBloc(String bloc) {
	this.bloc = bloc;
}

public String getDirecteurProjet() {
	return this.directeurProjet;
}

public void setDirecteurProjet(String directeurProjet) {
	this.directeurProjet = directeurProjet;
}

public String getDirectionRB() {
	return this.directionRB;
}

public void setDirectionRB(String directionRB) {
	this.directionRB = directionRB;
}

public String getDomaine() {
	return this.domaine;
}

public void setDomaine(String domaine) {
	this.domaine = domaine;
}

 

public String getDpCopi() {
	return this.dpCopi;
}

public void setDpCopi(String dpCopi) {
	this.dpCopi = dpCopi;
}
 
public String getEtape() {
	return etape;
}

public void setEtape(String etape) {
	this.etape = etape;
}

public String getNoteRoi() {
	return this.noteRoi;
}

public void setNoteRoi(String noteRoi) {
	this.noteRoi = noteRoi;
}

public String getNoteStrategique() {
	return this.noteStrategique;
}

public void setNoteStrategique(String noteStrategique) {
	this.noteStrategique = noteStrategique;
}

public String getProchainCopi() {
	return this.prochainCopi;
}

public void setProchainCopi(String prochainCopi) {
	this.prochainCopi = prochainCopi;
}

public String getResponsableBancaire() {
	return this.responsableBancaire;
}

public void setResponsableBancaire(String responsableBancaire) {
	this.responsableBancaire = responsableBancaire;
}

public String getSponsors() {
	return this.sponsors;
}

public void setSponsors(String sponsors) {
	this.sponsors = sponsors;
}
 
    

public int getFlaglock() {
	return flaglock;
}

public void setFlaglock(int flaglock) {
	this.flaglock = flaglock;
}

public String getLibelleAxe() {
	return libelleAxe;
}

public void setLibelleAxe(String libelleAxe) {
	this.libelleAxe = libelleAxe;
}

public String getLibelleBloc() {
	return libelleBloc;
}

public void setLibelleBloc(String libelleBloc) {
	this.libelleBloc = libelleBloc;
}

public String getLibelleDomaine() {
	return libelleDomaine;
}

public void setLibelleDomaine(String libelleDomaine) {
	this.libelleDomaine = libelleDomaine;
}

public String getLibelleEtape() {
	return libelleEtape;
}

public void setLibelleEtape(String libelleEtape) {
	this.libelleEtape = libelleEtape;
}    
    
    
    
    
    
    
	
}
