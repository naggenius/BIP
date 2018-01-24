package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;



/**
 * @author J.ALVES - 20/09/2007
 *
 * Formulaire pour mise à jour des couts standards pour Etats en KE 
 * 
 * chemin : Administration/Tables/ mise à jour/Standards pour états en KE
 * pages  : fStandardAd.jsp, bStandardAd.jsp, mStandardAd.jsp
 * pl/sql : cout.sql
 * 
 */
public class StandardKEForm extends AutomateForm {
	

 
 private String cout_Me_type1;
  
 private String cout_Mo_type1;
 
 private String cout_Hom_type1;
 
 private String cout_Gap_type1;
 
 private String cout_Exp_type1;
 
 private String cout_Sau_type1;
 
 private String cout_Me_type2;
 
 private String cout_Mo_type2;
 
 private String cout_Hom_type2;
 
 private String cout_Gap_type2;
 
 private String cout_Exp_type2;
 
 private String cout_Sau_type2;
 
 
 private String couann ;

 private String codsg_bas ;
 private String codsg_haut ;
 
 
 private String cleDpgBasHaut; 
 
 private String keyList0 ; 
 private String codsg_bas_new ;
 private String codsg_haut_new ;
 private String codsg_bas_sg;
 private String codsg_bas_autre;
 private String choix ; 
 
 private String fournisseurCopi ;
   
	/*Le flaglock
	*/
	private int flaglock ;
	
    
	private String userid ;

    
	/**
	 * Constructor for ClientForm.
	 */
	public StandardKEForm() {
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
	
	


/**
 * Returns the codsg_bas.
 * @return String
 */
public String getCodsg_bas() {
	return codsg_bas;
}

/**
 * Returns the codsg_haut.
 * @return String
 */
public String getCodsg_haut() {
	return codsg_haut;
}

/**
 * Returns the couann.
 * @return String
 */
public String getCouann() {
	return couann;
}

/**
 * Returns the flaglock.
 * @return int
 */
public int getFlaglock() {
	return flaglock;
}

/**
 * Returns the keyList0.
 * @return String
 */
public String getKeyList0() {
	return keyList0;
}

/**
 * Sets the codsg_bas.
 * @param codsg_bas The codsg_bas to set
 */
public void setCodsg_bas(String codsg_bas) {
	this.codsg_bas = codsg_bas;
}

/**
 * Sets the codsg_haut.
 * @param codsg_haut The codsg_haut to set
 */
public void setCodsg_haut(String codsg_haut) {
	this.codsg_haut = codsg_haut;
}

/**
 * Sets the couann.
 * @param couann The couann to set
 */
public void setCouann(String couann) {
	this.couann = couann;
}


/**
 * Sets the flaglock.
 * @param flaglock The flaglock to set
 */
public void setFlaglock(int flaglock) {
	this.flaglock = flaglock;
}

/**
 * Sets the keyList0.
 * @param keyList0 The keyList0 to set
 */
public void setKeyList0(String keyList0) {
	this.keyList0 = keyList0;
}

 

public String getChoix() {
	return choix;
}

public void setChoix(String choix) {
	this.choix = choix;
}

public String getCodsg_bas_autre() {
	return codsg_bas_autre;
}

public void setCodsg_bas_autre(String codsg_bas_autre) {
	this.codsg_bas_autre = codsg_bas_autre;
}

public String getCodsg_bas_sg() {
	return codsg_bas_sg;
}

public void setCodsg_bas_sg(String codsg_bas_sg) {
	this.codsg_bas_sg = codsg_bas_sg;
}



public String getCout_Exp_type1() {
	return cout_Exp_type1;
}

public void setCout_Exp_type1(String cout_Exp_type1) {
	this.cout_Exp_type1 = cout_Exp_type1;
}

public String getCout_Exp_type2() {
	return cout_Exp_type2;
}

public void setCout_Exp_type2(String cout_Exp_type2) {
	this.cout_Exp_type2 = cout_Exp_type2;
}

public String getCout_Gap_type1() {
	return cout_Gap_type1;
}

public void setCout_Gap_type1(String cout_Gap_type1) {
	this.cout_Gap_type1 = cout_Gap_type1;
}

public String getCout_Gap_type2() {
	return cout_Gap_type2;
}

public void setCout_Gap_type2(String cout_Gap_type2) {
	this.cout_Gap_type2 = cout_Gap_type2;
}

public String getCout_Hom_type1() {
	return cout_Hom_type1;
}

public void setCout_Hom_type1(String cout_Hom_type1) {
	this.cout_Hom_type1 = cout_Hom_type1;
}

public String getCout_Hom_type2() {
	return cout_Hom_type2;
}

public void setCout_Hom_type2(String cout_Hom_type2) {
	this.cout_Hom_type2 = cout_Hom_type2;
}

public String getCout_Me_type1() {
	return cout_Me_type1;
}

public void setCout_Me_type1(String cout_Me_type1) {
	this.cout_Me_type1 = cout_Me_type1;
}

public String getCout_Me_type2() {
	return cout_Me_type2;
}

public void setCout_Me_type2(String cout_Me_type2) {
	this.cout_Me_type2 = cout_Me_type2;
}

public String getCout_Mo_type1() {
	return cout_Mo_type1;
}

public void setCout_Mo_type1(String cout_Mo_type1) {
	this.cout_Mo_type1 = cout_Mo_type1;
}

public String getCout_Mo_type2() {
	return cout_Mo_type2;
}

public void setCout_Mo_type2(String cout_Mo_type2) {
	this.cout_Mo_type2 = cout_Mo_type2;
}

public String getCout_Sau_type1() {
	return cout_Sau_type1;
}

public void setCout_Sau_type1(String cout_Sau_type1) {
	this.cout_Sau_type1 = cout_Sau_type1;
}

public String getCout_Sau_type2() {
	return cout_Sau_type2;
}

public void setCout_Sau_type2(String cout_Sau_type2) {
	this.cout_Sau_type2 = cout_Sau_type2;
}

public String getCodsg_bas_new() {
	return this.codsg_bas_new;
}

public void setCodsg_bas_new(String codsg_bas_new) {
	this.codsg_bas_new = codsg_bas_new;
}

public String getCodsg_haut_new() {
	return this.codsg_haut_new;
}

public void setCodsg_haut_new(String codsg_haut_new) {
	this.codsg_haut_new = codsg_haut_new;
}

public String getCleDpgBasHaut() {
	return this.cleDpgBasHaut;
}

public void setCleDpgBasHaut(String cleDpgBasHaut) {
	this.cleDpgBasHaut = cleDpgBasHaut;
}

public String getFournisseurCopi() {
	return this.fournisseurCopi;
}

public void setFournisseurCopi(String fournisseurCopi) {
	this.fournisseurCopi = fournisseurCopi;
}

public String getUserid() {
	return this.userid;
}

public void setUserid(String userid) {
	this.userid = userid;
}

private String SGValue;


public String getSGValue() {
	return SGValue;
}

public void setSGValue(String sGValue) {
	SGValue = sGValue;
} 
 




}
