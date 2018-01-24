package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author N.BACCAM - 02/06/2003
 *
 * Formulaire pour mise à jour des couts standards
 * chemin : Administration/Tables/ mise à jour/Standards
 * pages  : fStandardAd.jsp, bStandardAd.jsp, mStandardAd.jsp
 * pl/sql : cout.sql
 */
public class StandardForm extends AutomateForm{
	
 private String a_Me;
 private String a_Mo;
 private String a_Hom;
 private String a_Gap;
 
 private String b_Me;
 private String b_Mo;
 private String b_Hom;
 private String b_Gap;
 	
 private String c_Me;
 private String c_Mo;
 private String c_Hom;
 private String c_Gap;
 	
 private String d_Me;
 private String d_Mo;
 private String d_Hom;
 private String d_Gap;
 	
 private String e_Me;
 private String e_Mo;
 private String e_Hom;
 private String e_Gap;	
 
 private String f_Me;
 private String f_Mo;
 private String f_Hom;
 private String f_Gap;	
 
 private String g_Me;
 private String g_Mo;
 private String g_Hom;
 private String g_Gap;
 	
 private String h_Me;
 private String h_Mo;
 private String h_Hom;
 private String h_Gap;	
 
 private String i_Me;
 private String i_Mo;
 private String i_Hom;
 private String i_Gap;	
 
 private String j_Me;
 private String j_Mo;
 private String j_Hom;
 private String j_Gap;	
 
 private String k_Me;
 private String k_Mo;
 private String k_Hom;
 private String k_Gap;
 	
 private String hc_Me;
 private String hc_Mo;
 private String hc_Hom;
 private String hc_Gap;
 
 private String coulog_Me;
 private String coutenv_sg_Me;
 private String coutenv_ssii_Me;
 
 private String coulog_Mo;
 private String coutenv_sg_Mo;
 private String coutenv_ssii_Mo;
 
 private String coulog_Hom;
 private String coutenv_sg_Hom;
 private String coutenv_ssii_Hom;
 
 private String coulog_Gap;
 private String coutenv_sg_Gap;
 private String coutenv_ssii_Gap;
 
 private String couann ;
 private String cdeDPG ;

 private String codsg_bas ;
 private String codsg_haut ;
 
 private String keyList0 ; 
 private String codsg_bas_old ;
 private String codsg_bas_sg;
 private String codsg_bas_autre;
 private String choix ; 
 
 private String userid; 
 
 
   
	/*Le flaglock
	*/
	private int flaglock ;
	
				
	/**
	 * Constructor for ClientForm.
	 */
	public StandardForm() {
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

/**
 * Returns the codsg_bas_old.
 * @return String
 */
public String getCodsg_bas_old() {
	return codsg_bas_old;
}

/**
 * Sets the codsg_bas_old.
 * @param codsg_bas_old The codsg_bas_old to set
 */
public void setCodsg_bas_old(String codsg_bas_old) {
	this.codsg_bas_old = codsg_bas_old;
}



/**
 * Returns the a_Gap.
 * @return String
 */
public String getA_Gap() {
	return a_Gap;
}

/**
 * Returns the a_Hom.
 * @return String
 */
public String getA_Hom() {
	return a_Hom;
}

/**
 * Returns the a_Me.
 * @return String
 */
public String getA_Me() {
	return a_Me;
}

/**
 * Returns the a_Mo.
 * @return String
 */
public String getA_Mo() {
	return a_Mo;
}

/**
 * Returns the b_Gap.
 * @return String
 */
public String getB_Gap() {
	return b_Gap;
}

/**
 * Returns the b_Hom.
 * @return String
 */
public String getB_Hom() {
	return b_Hom;
}

/**
 * Returns the b_Me.
 * @return String
 */
public String getB_Me() {
	return b_Me;
}

/**
 * Returns the b_Mo.
 * @return String
 */
public String getB_Mo() {
	return b_Mo;
}

/**
 * Returns the c_Gap.
 * @return String
 */
public String getC_Gap() {
	return c_Gap;
}

/**
 * Returns the c_Hom.
 * @return String
 */
public String getC_Hom() {
	return c_Hom;
}

/**
 * Returns the c_Me.
 * @return String
 */
public String getC_Me() {
	return c_Me;
}

/**
 * Returns the c_Mo.
 * @return String
 */
public String getC_Mo() {
	return c_Mo;
}


/**
 * Returns the d_Gap.
 * @return String
 */
public String getD_Gap() {
	return d_Gap;
}

/**
 * Returns the d_Hom.
 * @return String
 */
public String getD_Hom() {
	return d_Hom;
}

/**
 * Returns the d_Me.
 * @return String
 */
public String getD_Me() {
	return d_Me;
}

/**
 * Returns the d_Mo.
 * @return String
 */
public String getD_Mo() {
	return d_Mo;
}

/**
 * Returns the e_Gap.
 * @return String
 */
public String getE_Gap() {
	return e_Gap;
}

/**
 * Returns the e_Hom.
 * @return String
 */
public String getE_Hom() {
	return e_Hom;
}

/**
 * Returns the e_Me.
 * @return String
 */
public String getE_Me() {
	return e_Me;
}

/**
 * Returns the e_Mo.
 * @return String
 */
public String getE_Mo() {
	return e_Mo;
}

/**
 * Returns the f_Gap.
 * @return String
 */
public String getF_Gap() {
	return f_Gap;
}

/**
 * Returns the f_Hom.
 * @return String
 */
public String getF_Hom() {
	return f_Hom;
}

/**
 * Returns the f_Me.
 * @return String
 */
public String getF_Me() {
	return f_Me;
}

/**
 * Returns the f_Mo.
 * @return String
 */
public String getF_Mo() {
	return f_Mo;
}

/**
 * Returns the g_Gap.
 * @return String
 */
public String getG_Gap() {
	return g_Gap;
}

/**
 * Returns the g_Hom.
 * @return String
 */
public String getG_Hom() {
	return g_Hom;
}

/**
 * Returns the g_Me.
 * @return String
 */
public String getG_Me() {
	return g_Me;
}

/**
 * Returns the g_Mo.
 * @return String
 */
public String getG_Mo() {
	return g_Mo;
}

/**
 * Returns the h_Gap.
 * @return String
 */
public String getH_Gap() {
	return h_Gap;
}

/**
 * Returns the h_Hom.
 * @return String
 */
public String getH_Hom() {
	return h_Hom;
}

/**
 * Returns the h_Me.
 * @return String
 */
public String getH_Me() {
	return h_Me;
}

/**
 * Returns the h_Mo.
 * @return String
 */
public String getH_Mo() {
	return h_Mo;
}

/**
 * Returns the hc_Gap.
 * @return String
 */
public String getHc_Gap() {
	return hc_Gap;
}

/**
 * Returns the hc_Hom.
 * @return String
 */
public String getHc_Hom() {
	return hc_Hom;
}

/**
 * Returns the hc_Me.
 * @return String
 */
public String getHc_Me() {
	return hc_Me;
}

/**
 * Returns the hc_Mo.
 * @return String
 */
public String getHc_Mo() {
	return hc_Mo;
}

/**
 * Returns the i_Gap.
 * @return String
 */
public String getI_Gap() {
	return i_Gap;
}

/**
 * Returns the i_Hom.
 * @return String
 */
public String getI_Hom() {
	return i_Hom;
}

/**
 * Returns the i_Me.
 * @return String
 */
public String getI_Me() {
	return i_Me;
}

/**
 * Returns the i_Mo.
 * @return String
 */
public String getI_Mo() {
	return i_Mo;
}

/**
 * Returns the j_Gap.
 * @return String
 */
public String getJ_Gap() {
	return j_Gap;
}

/**
 * Returns the j_Hom.
 * @return String
 */
public String getJ_Hom() {
	return j_Hom;
}

/**
 * Returns the j_Me.
 * @return String
 */
public String getJ_Me() {
	return j_Me;
}

/**
 * Returns the j_Mo.
 * @return String
 */
public String getJ_Mo() {
	return j_Mo;
}

/**
 * Returns the k_Gap.
 * @return String
 */
public String getK_Gap() {
	return k_Gap;
}

/**
 * Returns the k_Hom.
 * @return String
 */
public String getK_Hom() {
	return k_Hom;
}

/**
 * Returns the k_Me.
 * @return String
 */
public String getK_Me() {
	return k_Me;
}

/**
 * Returns the k_Mo.
 * @return String
 */
public String getK_Mo() {
	return k_Mo;
}

/**
 * Sets the a_Gap.
 * @param a_Gap The a_Gap to set
 */
public void setA_Gap(String a_Gap) {
	this.a_Gap = a_Gap;
}

/**
 * Sets the a_Hom.
 * @param a_Hom The a_Hom to set
 */
public void setA_Hom(String a_Hom) {
	this.a_Hom = a_Hom;
}

/**
 * Sets the a_Me.
 * @param a_Me The a_Me to set
 */
public void setA_Me(String a_Me) {
	this.a_Me = a_Me;
}

/**
 * Sets the a_Mo.
 * @param a_Mo The a_Mo to set
 */
public void setA_Mo(String a_Mo) {
	this.a_Mo = a_Mo;
}

/**
 * Sets the b_Gap.
 * @param b_Gap The b_Gap to set
 */
public void setB_Gap(String b_Gap) {
	this.b_Gap = b_Gap;
}

/**
 * Sets the b_Hom.
 * @param b_Hom The b_Hom to set
 */
public void setB_Hom(String b_Hom) {
	this.b_Hom = b_Hom;
}

/**
 * Sets the b_Me.
 * @param b_Me The b_Me to set
 */
public void setB_Me(String b_Me) {
	this.b_Me = b_Me;
}

/**
 * Sets the b_Mo.
 * @param b_Mo The b_Mo to set
 */
public void setB_Mo(String b_Mo) {
	this.b_Mo = b_Mo;
}

/**
 * Sets the c_Gap.
 * @param c_Gap The c_Gap to set
 */
public void setC_Gap(String c_Gap) {
	this.c_Gap = c_Gap;
}

/**
 * Sets the c_Hom.
 * @param c_Hom The c_Hom to set
 */
public void setC_Hom(String c_Hom) {
	this.c_Hom = c_Hom;
}

/**
 * Sets the c_Me.
 * @param c_Me The c_Me to set
 */
public void setC_Me(String c_Me) {
	this.c_Me = c_Me;
}

/**
 * Sets the c_Mo.
 * @param c_Mo The c_Mo to set
 */
public void setC_Mo(String c_Mo) {
	this.c_Mo = c_Mo;
}


/**
 * Sets the d_Gap.
 * @param d_Gap The d_Gap to set
 */
public void setD_Gap(String d_Gap) {
	this.d_Gap = d_Gap;
}

/**
 * Sets the d_Hom.
 * @param d_Hom The d_Hom to set
 */
public void setD_Hom(String d_Hom) {
	this.d_Hom = d_Hom;
}

/**
 * Sets the d_Me.
 * @param d_Me The d_Me to set
 */
public void setD_Me(String d_Me) {
	this.d_Me = d_Me;
}

/**
 * Sets the d_Mo.
 * @param d_Mo The d_Mo to set
 */
public void setD_Mo(String d_Mo) {
	this.d_Mo = d_Mo;
}

/**
 * Sets the e_Gap.
 * @param e_Gap The e_Gap to set
 */
public void setE_Gap(String e_Gap) {
	this.e_Gap = e_Gap;
}

/**
 * Sets the e_Hom.
 * @param e_Hom The e_Hom to set
 */
public void setE_Hom(String e_Hom) {
	this.e_Hom = e_Hom;
}

/**
 * Sets the e_Me.
 * @param e_Me The e_Me to set
 */
public void setE_Me(String e_Me) {
	this.e_Me = e_Me;
}

/**
 * Sets the e_Mo.
 * @param e_Mo The e_Mo to set
 */
public void setE_Mo(String e_Mo) {
	this.e_Mo = e_Mo;
}

/**
 * Sets the f_Gap.
 * @param f_Gap The f_Gap to set
 */
public void setF_Gap(String f_Gap) {
	this.f_Gap = f_Gap;
}

/**
 * Sets the f_Hom.
 * @param f_Hom The f_Hom to set
 */
public void setF_Hom(String f_Hom) {
	this.f_Hom = f_Hom;
}

/**
 * Sets the f_Me.
 * @param f_Me The f_Me to set
 */
public void setF_Me(String f_Me) {
	this.f_Me = f_Me;
}

/**
 * Sets the f_Mo.
 * @param f_Mo The f_Mo to set
 */
public void setF_Mo(String f_Mo) {
	this.f_Mo = f_Mo;
}

/**
 * Sets the g_Gap.
 * @param g_Gap The g_Gap to set
 */
public void setG_Gap(String g_Gap) {
	this.g_Gap = g_Gap;
}

/**
 * Sets the g_Hom.
 * @param g_Hom The g_Hom to set
 */
public void setG_Hom(String g_Hom) {
	this.g_Hom = g_Hom;
}

/**
 * Sets the g_Me.
 * @param g_Me The g_Me to set
 */
public void setG_Me(String g_Me) {
	this.g_Me = g_Me;
}

/**
 * Sets the g_Mo.
 * @param g_Mo The g_Mo to set
 */
public void setG_Mo(String g_Mo) {
	this.g_Mo = g_Mo;
}

/**
 * Sets the h_Gap.
 * @param h_Gap The h_Gap to set
 */
public void setH_Gap(String h_Gap) {
	this.h_Gap = h_Gap;
}

/**
 * Sets the h_Hom.
 * @param h_Hom The h_Hom to set
 */
public void setH_Hom(String h_Hom) {
	this.h_Hom = h_Hom;
}

/**
 * Sets the h_Me.
 * @param h_Me The h_Me to set
 */
public void setH_Me(String h_Me) {
	this.h_Me = h_Me;
}

/**
 * Sets the h_Mo.
 * @param h_Mo The h_Mo to set
 */
public void setH_Mo(String h_Mo) {
	this.h_Mo = h_Mo;
}

/**
 * Sets the hc_Gap.
 * @param hc_Gap The hc_Gap to set
 */
public void setHc_Gap(String hc_Gap) {
	this.hc_Gap = hc_Gap;
}

/**
 * Sets the hc_Hom.
 * @param hc_Hom The hc_Hom to set
 */
public void setHc_Hom(String hc_Hom) {
	this.hc_Hom = hc_Hom;
}

/**
 * Sets the hc_Me.
 * @param hc_Me The hc_Me to set
 */
public void setHc_Me(String hc_Me) {
	this.hc_Me = hc_Me;
}

/**
 * Sets the hc_Mo.
 * @param hc_Mo The hc_Mo to set
 */
public void setHc_Mo(String hc_Mo) {
	this.hc_Mo = hc_Mo;
}

/**
 * Sets the i_Gap.
 * @param i_Gap The i_Gap to set
 */
public void setI_Gap(String i_Gap) {
	this.i_Gap = i_Gap;
}

/**
 * Sets the i_Hom.
 * @param i_Hom The i_Hom to set
 */
public void setI_Hom(String i_Hom) {
	this.i_Hom = i_Hom;
}

/**
 * Sets the i_Me.
 * @param i_Me The i_Me to set
 */
public void setI_Me(String i_Me) {
	this.i_Me = i_Me;
}

/**
 * Sets the i_Mo.
 * @param i_Mo The i_Mo to set
 */
public void setI_Mo(String i_Mo) {
	this.i_Mo = i_Mo;
}

/**
 * Sets the j_Gap.
 * @param j_Gap The j_Gap to set
 */
public void setJ_Gap(String j_Gap) {
	this.j_Gap = j_Gap;
}

/**
 * Sets the j_Hom.
 * @param j_Hom The j_Hom to set
 */
public void setJ_Hom(String j_Hom) {
	this.j_Hom = j_Hom;
}

/**
 * Sets the j_Me.
 * @param j_Me The j_Me to set
 */
public void setJ_Me(String j_Me) {
	this.j_Me = j_Me;
}

/**
 * Sets the j_Mo.
 * @param j_Mo The j_Mo to set
 */
public void setJ_Mo(String j_Mo) {
	this.j_Mo = j_Mo;
}

/**
 * Sets the k_Gap.
 * @param k_Gap The k_Gap to set
 */
public void setK_Gap(String k_Gap) {
	this.k_Gap = k_Gap;
}

/**
 * Sets the k_Hom.
 * @param k_Hom The k_Hom to set
 */
public void setK_Hom(String k_Hom) {
	this.k_Hom = k_Hom;
}

/**
 * Sets the k_Me.
 * @param k_Me The k_Me to set
 */
public void setK_Me(String k_Me) {
	this.k_Me = k_Me;
}

/**
 * Sets the k_Mo.
 * @param k_Mo The k_Mo to set
 */
public void setK_Mo(String k_Mo) {
	this.k_Mo = k_Mo;
}

/**
 * Returns the choix.
 * @return String
 */
public String getChoix() {
	return choix;
}

/**
 * Sets the choix.
 * @param choix The choix to set
 */
public void setChoix(String choix) {
	this.choix = choix;
}

/**
 * Returns the codsg_bas_autre.
 * @return String
 */
public String getCodsg_bas_autre() {
	return codsg_bas_autre;
}

/**
 * Returns the codsg_bas_sg.
 * @return String
 */
public String getCodsg_bas_sg() {
	return codsg_bas_sg;
}

/**
 * Sets the codsg_bas_autre.
 * @param codsg_bas_autre The codsg_bas_autre to set
 */
public void setCodsg_bas_autre(String codsg_bas_autre) {
	this.codsg_bas_autre = codsg_bas_autre;
}

/**
 * Sets the codsg_bas_sg.
 * @param codsg_bas_sg The codsg_bas_sg to set
 */
public void setCodsg_bas_sg(String codsg_bas_sg) {
	this.codsg_bas_sg = codsg_bas_sg;
}

/**
 * @return
 */
public String getCoulog_Gap() {
	return coulog_Gap;
}

/**
 * @return
 */
public String getCoulog_Hom() {
	return coulog_Hom;
}

/**
 * @return
 */
public String getCoulog_Me() {
	return coulog_Me;
}

/**
 * @return
 */
public String getCoulog_Mo() {
	return coulog_Mo;
}

/**
 * @return
 */
public String getCoutenv_sg_Gap() {
	return coutenv_sg_Gap;
}

/**
 * @return
 */
public String getCoutenv_sg_Hom() {
	return coutenv_sg_Hom;
}

/**
 * @return
 */
public String getCoutenv_sg_Me() {
	return coutenv_sg_Me;
}

/**
 * @return
 */
public String getCoutenv_sg_Mo() {
	return coutenv_sg_Mo;
}

/**
 * @return
 */
public String getCoutenv_ssii_Gap() {
	return coutenv_ssii_Gap;
}

/**
 * @return
 */
public String getCoutenv_ssii_Hom() {
	return coutenv_ssii_Hom;
}

/**
 * @return
 */
public String getCoutenv_ssii_Me() {
	return coutenv_ssii_Me;
}

/**
 * @return
 */
public String getCoutenv_ssii_Mo() {
	return coutenv_ssii_Mo;
}

/**
 * @param string
 */
public void setCoulog_Gap(String string) {
	coulog_Gap = string;
}

/**
 * @param string
 */
public void setCoulog_Hom(String string) {
	coulog_Hom = string;
}

/**
 * @param string
 */
public void setCoulog_Me(String string) {
	coulog_Me = string;
}

/**
 * @param string
 */
public void setCoulog_Mo(String string) {
	coulog_Mo = string;
}

/**
 * @param string
 */
public void setCoutenv_sg_Gap(String string) {
	coutenv_sg_Gap = string;
}

/**
 * @param string
 */
public void setCoutenv_sg_Hom(String string) {
	coutenv_sg_Hom = string;
}

/**
 * @param string
 */
public void setCoutenv_sg_Me(String string) {
	coutenv_sg_Me = string;
}

/**
 * @param string
 */
public void setCoutenv_sg_Mo(String string) {
	coutenv_sg_Mo = string;
}

/**
 * @param string
 */
public void setCoutenv_ssii_Gap(String string) {
	coutenv_ssii_Gap = string;
}

/**
 * @param string
 */
public void setCoutenv_ssii_Hom(String string) {
	coutenv_ssii_Hom = string;
}

/**
 * @param string
 */
public void setCoutenv_ssii_Me(String string) {
	coutenv_ssii_Me = string;
}

/**
 * @param string
 */
public void setCoutenv_ssii_Mo(String string) {
	coutenv_ssii_Mo = string;
}


public String getUserid() {
	return this.userid;
}

public void setUserid(String userid) {
	this.userid = userid;
}

/**
 * @return the cdeDPG
 */
public String getCdeDPG() {
	return cdeDPG;
}

private String SGValue;


public String getSGValue() {
	return SGValue;
}

public void setSGValue(String sGValue) {
	SGValue = sGValue;
}

/**
 * @param cdeDPG the cdeDPG to set
 */
public void setCdeDPG(String cdeDPG) {
	this.cdeDPG = cdeDPG;
}


 

}
