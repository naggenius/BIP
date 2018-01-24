package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;



/**
 * @author N.BACCAM - 18/06/2003
 *
 * Formulaire pour mise à jour des applications
 * chemin : Administration/Référentiels/Applications
 * pages  : fmApplicationAd.jsp et mApplicationAd.jsp
 * pl/sql : appli.sql
 */
public class ApplicationForm extends AutomateForm{

	/*Le code application
	*/   
    private String airt ; 
    /*Le libelle
	*/   
    private String alibel ;
    /*Le libellé court
	*/  
    private String alibcourt ; 

       /*Le client MO
	*/   
    private String clicode;    
    /*Le nom de la MO
	*/  
    private String amop ; 
     /*Le DPG
	*/  
    private String codsg ; 
     /*Le nom de la ME
	*/  
    private String acme ; 
     /*Le code gestionnaire
	*/  
    private String codgappli ; 
     /*Le nom du gestionnaire de l'appli
	*/  
    private String agappli ; 
     /*Le mnémonique de l'appli
	*/  
    private String amnemo ;
    /*Le code appli de regroupement
	*/  
    private String acdareg;
   
	/*Le flaglock
	*/
	private int flaglock ;

	/* Libellé du service fournisseur (ME) 
    */
    private String alibme;

	/* Libellé du service client (MO) 
    */
    private String alibmo;

	/* Libellé du service gestionnaire 
    */
    private String alibgappli;
		
	/* Date de fin d'utilisation de l'application 
    */
    private String datfinapp;

	/* Lien code Application /CA 
    */
    private String licodapca;

	/* Code CA 1 préconisé 
    */
    private String codcamo1;
		
	/* Libellé CA 1 préconisé 
    */
    private String clibca1;

	/* CA 1 préconisé facturable 
    */
    private String cdfain1;

    /* Date de validité du lien avec le CA 1 préconisé 
	*/
	private String datvalli1;

	/* Responsable de la validation du lien avec le CA 1 préconisé 
    */
    private String respval1;

	/* Code CA 2 préconisé 
    */
    private String codcamo2;
		
	/* Libellé CA 2 préconisé 
    */
    private String clibca2;

	/* CA 2 préconisé facturable 
    */
    private String cdfain2;

	/* Date de validité du lien avec le CA 2 préconisé 
    */
    private String datvalli2;

	/* Responsable de la validation du lien avec le CA 2 préconisé 
    */
    private String respval2;

	/* Code CA 3 préconisé 
    */
    private String codcamo3;
		
	/* Libellé CA 1 préconisé 
    */
    private String clibca3;

	/* CA 3 préconisé facturable 
    */
    private String cdfain3;

	/* Date de validité du lien avec le CA 3 préconisé 
    */
    private String datvalli3;

	/* Responsable de la validation du lien avec le CA 3 préconisé 
    */
    private String respval3;
		
	/* Code CA 4 préconisé 
    */
    private String codcamo4;
		
	/* Libellé CA 4 préconisé 
    */
    private String clibca4;

	/* CA 4 préconisé facturable 
    */
    private String cdfain4;

	/* Date de validité du lien avec le CA 4 préconisé 
    */
    private String datvalli4;

	/* Responsable de la validation du lien avec le CA 4 préconisé 
    */
    private String respval4;
		
	/* Code CA 5 préconisé 
    */
    private String codcamo5;
		
	/* Libellé CA 5 préconisé 
    */
    private String clibca5;

    /* CA 5 préconisé facturable 
	*/
    private String cdfain5;

	/* Date de validité du lien avec le CA 5 préconisé 
    */
    private String datvalli5;

	/* Responsable de la validation du lien avec le CA 5 préconisé 
    */
    private String respval5;

	/* Code CA 6 préconisé 
    */
    private String codcamo6;
		
	/* Libellé CA 6 préconisé 
    */
    private String clibca6;

	/* CA 6 préconisé facturable 
    */
    private String cdfain6;

	/* Date de validité du lien avec le CA 6 préconisé 
    */
    private String datvalli6;

	/* Responsable de la validation du lien avec le CA 6 préconisé 
    */
    private String respval6;

	/* Code CA 7 préconisé 
    */
    private String codcamo7;
		
	/* Libellé CA 7 préconisé 
    */
    private String clibca7;

	/* CA 7 préconisé facturable 
    */
    private String cdfain7;

	/* Date de validité du lien avec le CA 7 préconisé 
    */
    private String datvalli7;

	/* Responsable de la validation du lien avec le CA 7 préconisé 
    */
    private String respval7;

	/* Code CA 8 préconisé 
    */
    private String codcamo8;
		
	/* Libellé CA 8 préconisé 
    */
    private String clibca8;

	/* CA 8 préconisé facturable 
    */
    private String cdfain8;

	/* Date de validité du lien avec le CA 8 préconisé 
    */
    private String datvalli8;

	/* Responsable de la validation du lien avec le CA 8 préconisé 
    */
    private String respval8;
		
	/* Code CA 9 préconisé 
    */
    private String codcamo9;
		
	/* Libellé CA 9 préconisé 
    */
    private String clibca9;

	/* CA 9 préconisé facturable 
    */
    private String cdfain9;

	/* Date de validité du lien avec le CA 9 préconisé 
    */
    private String datvalli9;

	/* Responsable de la validation du lien avec le CA 9 préconisé 
    */
    private String respval9;
		
	/* Code CA 10 préconisé 
    */
    private String codcamo10;
		
	/* Libellé CA 10 préconisé 
    */
    private String clibca10;

	/* CA 10 préconisé facturable 
    */
    private String cdfain10;

	/* Date de validité du lien avec le CA 10 préconisé 
    */
    private String datvalli10;

	/* Responsable de la validation du lien avec le CA 10 préconisé 
    */
    private String respval10;
    
	/* Type d'activité relatif au CA 1 préconisé 
    */
    private String typactca1;
     
 	/* Type d'activité relatif au CA 2 préconisé 
    */
    private String typactca2;
      
  	/* Type d'activité relatif au CA 3 préconisé 
    */
    private String typactca3;

  	/* Type d'activité relatif au CA 4 préconisé 
    */
    private String typactca4;

  	/* Type d'activité relatif au CA 5 préconisé 
    */
    private String typactca5;

	/* Type d'activité relatif au CA 6 préconisé 
    */
    private String typactca6;
      
  	/* Type d'activité relatif au CA 7 préconisé 
    */
    private String typactca7;
       
   	/* Type d'activité relatif au CA 8 préconisé 
    */
    private String typactca8;

   	/* Type d'activité relatif au CA 9 préconisé 
    */
    private String typactca9;

   	/* Type d'activité relatif au CA 10 préconisé 
    */
    private String typactca10;
    
    private String bloc;
    
    private String lib_bloc;
    
    private String adescr;
    
	/**
	 * Constructor for ClientForm.
	 */
	public ApplicationForm() {
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
	 * Returns the acdareg.
	 * @return String
	 */
	public String getAcdareg() {
		return acdareg;
	}

	/**
	 * Returns the acme.
	 * @return String
	 */
	public String getAcme() {
		return acme;
	}

	
	/**
	 * Returns the agappli.
	 * @return String
	 */
	public String getAgappli() {
		return agappli;
	}

	/**
	 * Returns the airt.
	 * @return String
	 */
	public String getAirt() {
		return airt;
	}

	/**
	 * Returns the alibcourt.
	 * @return String
	 */
	public String getAlibcourt() {
		return alibcourt;
	}

	/**
	 * Returns the alibel.
	 * @return String
	 */
	public String getAlibel() {
		return alibel;
	}

	/**
	 * Returns the amnemo.
	 * @return String
	 */
	public String getAmnemo() {
		return amnemo;
	}

	/**
	 * Returns the amop.
	 * @return String
	 */
	public String getAmop() {
		return amop;
	}

	/**
	 * Returns the clicode.
	 * @return String
	 */
	public String getClicode() {
		return clicode;
	}

	/**
	 * Returns the codgappli.
	 * @return String
	 */
	public String getCodgappli() {
		return codgappli;
	}

	/**
	 * Returns the codsg.
	 * @return String
	 */
	public String getCodsg() {
		return codsg;
	}

	/**
	 * Returns the flaglock.
	 * @return int
	 */
	public int getFlaglock() {
		return flaglock;
	}

	/**
	 * Sets the acdareg.
	 * @param acdareg The acdareg to set
	 */
	public void setAcdareg(String acdareg) {
		this.acdareg = acdareg;
	}

	/**
	 * Sets the acme.
	 * @param acme The acme to set
	 */
	public void setAcme(String acme) {
		this.acme = acme;
	}

	

	/**
	 * Sets the agappli.
	 * @param agappli The agappli to set
	 */
	public void setAgappli(String agappli) {
		this.agappli = agappli;
	}

	/**
	 * Sets the airt.
	 * @param airt The airt to set
	 */
	public void setAirt(String airt) {
		this.airt = airt;
	}

	/**
	 * Sets the alibcourt.
	 * @param alibcourt The alibcourt to set
	 */
	public void setAlibcourt(String alibcourt) {
		this.alibcourt = alibcourt;
	}

	/**
	 * Sets the alibel.
	 * @param alibel The alibel to set
	 */
	public void setAlibel(String alibel) {
		this.alibel = alibel;
	}

	/**
	 * Sets the amnemo.
	 * @param amnemo The amnemo to set
	 */
	public void setAmnemo(String amnemo) {
		this.amnemo = amnemo;
	}

	/**
	 * Sets the amop.
	 * @param amop The amop to set
	 */
	public void setAmop(String amop) {
		this.amop = amop;
	}

	/**
	 * Sets the clicode.
	 * @param clicode The clicode to set
	 */
	public void setClicode(String clicode) {
		this.clicode = clicode;
	}

	/**
	 * Sets the codgappli.
	 * @param codgappli The codgappli to set
	 */
	public void setCodgappli(String codgappli) {
		this.codgappli = codgappli;
	}

	/**
	 * Sets the codsg.
	 * @param codsg The codsg to set
	 */
	public void setCodsg(String codsg) {
		this.codsg = codsg;
	}

	/**
	 * Sets the flaglock.
	 * @param flaglock The flaglock to set
	 */
	public void setFlaglock(int flaglock) {
		this.flaglock = flaglock;
	}

	/**
	 * Returns the alibme.
	 * @return String
	 */
	public String getAlibme() {
		return alibme;
	}

	/**
	 * Returns the alibmo.
	 * @return String
	 */
	public String getAlibmo() {
		return alibmo;
	}

	/**
	 * Returns the alibgappli.
	 * @return String
	 */
	public String getAlibgappli() {
		return alibgappli;
	}

	/**
	 * Returns the datfinapp.
	 * @return String
	 */
	public String getDatfinapp() {
		return datfinapp;
	}
	
	/**
	 * Returns the licodapca.
	 * @return String
	 */
	public String getLicodapca() {
		return licodapca;
	}

	/**
	 * Returns the codcamo1.
	 * @return String
	 */
	public String getCodcamo1() {
		return codcamo1;
	}	

	/**
	 * Returns the clibca1.
	 * @return String
	 */
	public String getClibca1() {
		return clibca1;
	}	

	/**
	 * Returns the cdfain1.
	 * @return String
	 */
	public String getCdfain1() {
		return cdfain1;
	}	

	/**
	 * Returns the datvalli1.
	 * @return String
	 */
	public String getDatvalli1() {
		return datvalli1;
	}	

	/**
	 * Returns the respval1.
	 * @return String
	 */
	public String getRespval1() {
		return respval1;
	}	
	
	/**
	 * Returns the codcamo2.
	 * @return String
	 */
	public String getCodcamo2() {
		return codcamo2;
	}	

	/**
	 * Returns the clibca2.
	 * @return String
	 */
	public String getClibca2() {
		return clibca2;
	}	

	/**
	 * Returns the cdfain2.
	 * @return String
	 */
	public String getCdfain2() {
		return cdfain2;
	}	

	/**
	 * Returns the datvalli2.
	 * @return String
	 */
	public String getDatvalli2() {
		return datvalli2;
	}	

	/**
	 * Returns the respval2.
	 * @return String
	 */
	public String getRespval2() {
		return respval2;
	}

	/**
	 * Returns the codcamo3.
	 * @return String
	 */
	public String getCodcamo3() {
		return codcamo3;
	}	

	/**
	 * Returns the clibca3.
	 * @return String
	 */
	public String getClibca3() {
		return clibca3;
	}	

	/**
	 * Returns the cdfain3.
	 * @return String
	 */
	public String getCdfain3() {
		return cdfain3;
	}	

	/**
	 * Returns the datvalli3.
	 * @return String
	 */
	public String getDatvalli3() {
		return datvalli3;
	}	

	/**
	 * Returns the respval3.
	 * @return String
	 */
	public String getRespval3() {
		return respval3;
	}	

	/**
	 * Returns the codcamo4.
	 * @return String
	 */
	public String getCodcamo4() {
		return codcamo4;
	}	

	/**
	 * Returns the clibca4.
	 * @return String
	 */
	public String getClibca4() {
		return clibca4;
	}	

	/**
	 * Returns the cdfain4.
	 * @return String
	 */
	public String getCdfain4() {
		return cdfain4;
	}	

	/**
	 * Returns the datvalli4.
	 * @return String
	 */
	public String getDatvalli4() {
		return datvalli4;
	}	

	/**
	 * Returns the respval4.
	 * @return String
	 */
	public String getRespval4() {
		return respval4;
	}

	/**
	 * Returns the codcamo5.
	 * @return String
	 */
	public String getCodcamo5() {
		return codcamo5;
	}	

	/**
	 * Returns the clibca5.
	 * @return String
	 */
	public String getClibca5() {
		return clibca5;
	}	

	/**
	 * Returns the cdfain5.
	 * @return String
	 */
	public String getCdfain5() {
		return cdfain5;
	}	

	/**
	 * Returns the datvalli5.
	 * @return String
	 */
	public String getDatvalli5() {
		return datvalli5;
	}	

	/**
	 * Returns the respval5.
	 * @return String
	 */
	public String getRespval5() {
		return respval5;
	}

	/**
	 * Returns the codcamo6.
	 * @return String
	 */
	public String getCodcamo6() {
		return codcamo6;
	}	

	/**
	 * Returns the clibca6.
	 * @return String
	 */
	public String getClibca6() {
		return clibca6;
	}	

	/**
	 * Returns the cdfain6.
	 * @return String
	 */
	public String getCdfain6() {
		return cdfain6;
	}	

	/**
	 * Returns the datvalli6.
	 * @return String
	 */
	public String getDatvalli6() {
		return datvalli6;
	}	

	/**
	 * Returns the respval6.
	 * @return String
	 */
	public String getRespval6() {
		return respval6;
	}	
	
	/**
	 * Returns the codcamo7.
	 * @return String
	 */
	public String getCodcamo7() {
		return codcamo7;
	}	

	/**
	 * Returns the clibca7.
	 * @return String
	 */
	public String getClibca7() {
		return clibca7;
	}	

	/**
	 * Returns the cdfain7.
	 * @return String
	 */
	public String getCdfain7() {
		return cdfain7;
	}	

	/**
	 * Returns the datvalli7.
	 * @return String
	 */
	public String getDatvalli7() {
		return datvalli7;
	}	

	/**
	 * Returns the respval7.
	 * @return String
	 */
	public String getRespval7() {
		return respval7;
	}

	/**
	 * Returns the codcamo8.
	 * @return String
	 */
	public String getCodcamo8() {
		return codcamo8;
	}	

	/**
	 * Returns the clibca8.
	 * @return String
	 */
	public String getClibca8() {
		return clibca8;
	}	

	/**
	 * Returns the cdfain8.
	 * @return String
	 */
	public String getCdfain8() {
		return cdfain8;
	}	

	/**
	 * Returns the datvalli8.
	 * @return String
	 */
	public String getDatvalli8() {
		return datvalli8;
	}	

	/**
	 * Returns the respval8.
	 * @return String
	 */
	public String getRespval8() {
		return respval8;
	}	

	/**
	 * Returns the codcamo9.
	 * @return String
	 */
	public String getCodcamo9() {
		return codcamo9;
	}	

	/**
	 * Returns the clibca9.
	 * @return String
	 */
	public String getClibca9() {
		return clibca9;
	}	

	/**
	 * Returns the cdfain9.
	 * @return String
	 */
	public String getCdfain9() {
		return cdfain9;
	}	

	/**
	 * Returns the datvalli9.
	 * @return String
	 */
	public String getDatvalli9() {
		return datvalli9;
	}	

	/**
	 * Returns the respval9.
	 * @return String
	 */
	public String getRespval9() {
		return respval9;
	}

	/**
	 * Returns the codcamo10.
	 * @return String
	 */
	public String getCodcamo10() {
		return codcamo10;
	}	

	/**
	 * Returns the clibca10.
	 * @return String
	 */
	public String getClibca10() {
		return clibca10;
	}	

	/**
	 * Returns the cdfain10.
	 * @return String
	 */
	public String getCdfain10() {
		return cdfain10;
	}	

	/**
	 * Returns the datvalli10.
	 * @return String
	 */
	public String getDatvalli10() {
		return datvalli10;
	}	

	/**
	 * Returns the respval10.
	 * @return String
	 */
	public String getRespval10() {
		return respval10;
	}	

	/**
	 * Sets the alibme.
	 * @param alibme The alibme to set
	 */
	public void setAlibme(String alibme) {
		this.alibme = alibme;
	}	
	
	/**
	 * Sets the alibmo.
	 * @param alibmo The alibmo to set
	 */
	public void setAlibmo(String alibmo) {
		this.alibmo = alibmo;
	}		

	/**
	 * Sets the alibgappli.
	 * @param alibgappli The alibgappli to set
	 */
	public void setAlibgappli(String alibgappli) {
		this.alibgappli = alibgappli;
	}		

	/**
	 * Sets the datfinapp.
	 * @param datfinapp The datfinapp to set
	 */
	public void setDatfinapp(String datfinapp) {
		this.datfinapp = datfinapp;
	}	

	/**
	 * Sets the licodapca.
	 * @param licodapca The licodapca to set
	 */
	public void setLicodapca(String licodapca) {
		this.licodapca = licodapca;
	}

	/**
	 * Sets the codcamo1.
	 * @param codcamo1 The codcamo1 to set
	 */
	public void setCodcamo1(String codcamo1) {
		this.codcamo1 = codcamo1;
	}	

	/**
	 * Sets the clibca1.
	 * @param clibca1 The clibca1 to set
	 */
	public void setClibca1(String clibca1) {
		this.clibca1 = clibca1;
	}

	/**
	 * Sets the cdfain1.
	 * @param cdfain1 The cdfain1 to set
	 */
	public void setCdfain1(String cdfain1) {
		this.cdfain1 = cdfain1;
	}

	/**
	 * Sets the datvalli1.
	 * @param datvalli1 The datvalli1 to set
	 */
	public void setDatvalli1(String datvalli1) {
		this.datvalli1 = datvalli1;
	}

	/**
	 * Sets the respval1.
	 * @param respval1 The respval1 to set
	 */
	public void setRespval1(String respval1) {
		this.respval1 = respval1;
	}	

	/**
	 * Sets the codcamo2.
	 * @param codcamo2 The codcamo2 to set
	 */
	public void setCodcamo2(String codcamo2) {
		this.codcamo2 = codcamo2;
	}	

	/**
	 * Sets the clibca2.
	 * @param clibca2 The clibca2 to set
	 */
	public void setClibca2(String clibca2) {
		this.clibca2 = clibca2;
	}

	/**
	 * Sets the cdfain2.
	 * @param cdfain2 The cdfain2 to set
	 */
	public void setCdfain2(String cdfain2) {
		this.cdfain2 = cdfain2;
	}

	/**
	 * Sets the datvalli2.
	 * @param datvalli2 The datvalli2 to set
	 */
	public void setDatvalli2(String datvalli2) {
		this.datvalli2 = datvalli2;
	}

	/**
	 * Sets the respval2.
	 * @param respval2 The respval2 to set
	 */
	public void setRespval2(String respval2) {
		this.respval2 = respval2;
	}

	/**
	 * Sets the codcamo3.
	 * @param codcamo3 The codcamo3 to set
	 */
	public void setCodcamo3(String codcamo3) {
		this.codcamo3 = codcamo3;
	}	

	/**
	 * Sets the clibca3.
	 * @param clibca3 The clibca3 to set
	 */
	public void setClibca3(String clibca3) {
		this.clibca3 = clibca3;
	}

	/**
	 * Sets the cdfain3.
	 * @param cdfain3 The cdfain3 to set
	 */
	public void setCdfain3(String cdfain3) {
		this.cdfain3 = cdfain3;
	}

	/**
	 * Sets the datvalli3.
	 * @param datvalli3 The datvalli3 to set
	 */
	public void setDatvalli3(String datvalli3) {
		this.datvalli3 = datvalli3;
	}

	/**
	 * Sets the respval3.
	 * @param respval3 The respval3 to set
	 */
	public void setRespval3(String respval3) {
		this.respval3 = respval3;
	}

	/**
	 * Sets the codcamo4.
	 * @param codcamo4 The codcamo4 to set
	 */
	public void setCodcamo4(String codcamo4) {
		this.codcamo4 = codcamo4;
	}	

	/**
	 * Sets the clibca4.
	 * @param clibca4 The clibca4 to set
	 */
	public void setClibca4(String clibca4) {
		this.clibca4 = clibca4;
	}

	/**
	 * Sets the cdfain4.
	 * @param cdfain4 The cdfain4 to set
	 */
	public void setCdfain4(String cdfain4) {
		this.cdfain4 = cdfain4;
	}

	/**
	 * Sets the datvalli4.
	 * @param datvalli4 The datvalli4 to set
	 */
	public void setDatvalli4(String datvalli4) {
		this.datvalli4 = datvalli4;
	}

	/**
	 * Sets the respval4.
	 * @param respval4 The respval4 to set
	 */
	public void setRespval4(String respval4) {
		this.respval4 = respval4;
	}	
	
	/**
	 * Sets the codcamo5.
	 * @param codcamo5 The codcamo5 to set
	 */
	public void setCodcamo5(String codcamo5) {
		this.codcamo5 = codcamo5;
	}	

	/**
	 * Sets the clibca5.
	 * @param clibca5 The clibca5 to set
	 */
	public void setClibca5(String clibca5) {
		this.clibca5 = clibca5;
	}

	/**
	 * Sets the cdfain5.
	 * @param cdfain5 The cdfain5 to set
	 */
	public void setCdfain5(String cdfain5) {
		this.cdfain5 = cdfain5;
	}

	/**
	 * Sets the datvalli5.
	 * @param datvalli5 The datvalli5 to set
	 */
	public void setDatvalli5(String datvalli5) {
		this.datvalli5 = datvalli5;
	}

	/**
	 * Sets the respval5.
	 * @param respval5 The respval5 to set
	 */
	public void setRespval5(String respval5) {
		this.respval5 = respval5;
	}	

	/**
	 * Sets the codcamo6.
	 * @param codcamo6 The codcamo6 to set
	 */
	public void setCodcamo6(String codcamo6) {
		this.codcamo6 = codcamo6;
	}	

	/**
	 * Sets the clibca6.
	 * @param clibca6 The clibca6 to set
	 */
	public void setClibca6(String clibca6) {
		this.clibca6 = clibca6;
	}

	/**
	 * Sets the cdfain6.
	 * @param cdfain6 The cdfain6 to set
	 */
	public void setCdfain6(String cdfain6) {
		this.cdfain6 = cdfain6;
	}

	/**
	 * Sets the datvalli6.
	 * @param datvalli6 The datvalli6 to set
	 */
	public void setDatvalli6(String datvalli6) {
		this.datvalli6 = datvalli6;
	}

	/**
	 * Sets the respval6.
	 * @param respval6 The respval6 to set
	 */
	public void setRespval6(String respval6) {
		this.respval6 = respval6;
	}	

	/**
	 * Sets the codcamo7.
	 * @param codcamo7 The codcamo7 to set
	 */
	public void setCodcamo7(String codcamo7) {
		this.codcamo7 = codcamo7;
	}	

	/**
	 * Sets the clibca7.
	 * @param clibca7 The clibca7 to set
	 */
	public void setClibca7(String clibca7) {
		this.clibca7 = clibca7;
	}

	/**
	 * Sets the cdfain7.
	 * @param cdfain7 The cdfain7 to set
	 */
	public void setCdfain7(String cdfain7) {
		this.cdfain7 = cdfain7;
	}

	/**
	 * Sets the datvalli7.
	 * @param datvalli7 The datvalli7 to set
	 */
	public void setDatvalli7(String datvalli7) {
		this.datvalli7 = datvalli7;
	}

	/**
	 * Sets the respval7.
	 * @param respval7 The respval7 to set
	 */
	public void setRespval7(String respval7) {
		this.respval7 = respval7;
	}

	/**
	 * Sets the codcamo8.
	 * @param codcamo8 The codcamo8 to set
	 */
	public void setCodcamo8(String codcamo8) {
		this.codcamo8 = codcamo8;
	}	

	/**
	 * Sets the clibca8.
	 * @param clibca8 The clibca8 to set
	 */
	public void setClibca8(String clibca8) {
		this.clibca8 = clibca8;
	}

	/**
	 * Sets the cdfain8.
	 * @param cdfain8 The cdfain8 to set
	 */
	public void setCdfain8(String cdfain8) {
		this.cdfain8 = cdfain8;
	}

	/**
	 * Sets the datvalli8.
	 * @param datvalli8 The datvalli8 to set
	 */
	public void setDatvalli8(String datvalli8) {
		this.datvalli8 = datvalli8;
	}

	/**
	 * Sets the respval8.
	 * @param respval8 The respval8 to set
	 */
	public void setRespval8(String respval8) {
		this.respval8 = respval8;
	}

	/**
	 * Sets the codcamo9.
	 * @param codcamo9 The codcamo9 to set
	 */
	public void setCodcamo9(String codcamo9) {
		this.codcamo9 = codcamo9;
	}	

	/**
	 * Sets the clibca9.
	 * @param clibca9 The clibca9 to set
	 */
	public void setClibca9(String clibca9) {
		this.clibca9 = clibca9;
	}

	/**
	 * Sets the cdfain9.
	 * @param cdfain9 The cdfain9 to set
	 */
	public void setCdfain9(String cdfain9) {
		this.cdfain9 = cdfain9;
	}

	/**
	 * Sets the datvalli9.
	 * @param datvalli9 The datvalli9 to set
	 */
	public void setDatvalli9(String datvalli9) {
		this.datvalli9 = datvalli9;
	}

	/**
	 * Sets the respval9.
	 * @param respval9 The respval9 to set
	 */
	public void setRespval9(String respval9) {
		this.respval9 = respval9;
	}	
	
	/**
	 * Sets the codcamo10.
	 * @param codcamo10 The codcamo10 to set
	 */
	public void setCodcamo10(String codcamo10) {
		this.codcamo10 = codcamo10;
	}	

	/**
	 * Sets the clibca10.
	 * @param clibca10 The clibca10 to set
	 */
	public void setClibca10(String clibca10) {
		this.clibca10 = clibca10;
	}

	/**
	 * Sets the cdfain10.
	 * @param cdfain10 The cdfain10 to set
	 */
	public void setCdfain10(String cdfain10) {
		this.cdfain10 = cdfain10;
	}

	/**
	 * Sets the datvalli10.
	 * @param datvalli10 The datvalli10 to set
	 */
	public void setDatvalli10(String datvalli10) {
		this.datvalli10 = datvalli10;
	}

	/**
	 * Sets the respval10.
	 * @param respval10 The respval10 to set
	 */
	public void setRespval10(String respval10) {
		this.respval10 = respval10;
	}

	/**
	 * Returns the typactca1.
	 * @return String
	 */
	public String getTypactca1() {
		return typactca1;
	}	

	/**
	 * Returns the typactca2.
	 * @return String
	 */
	public String getTypactca2() {
		return typactca2;
	}	

	/**
	 * Returns the typactca3.
	 * @return String
	 */
	public String getTypactca3() {
		return typactca3;
	}	
	
	/**
	 * Returns the typactca4.
	 * @return String
	 */
	public String getTypactca4() {
		return typactca4;
	}	

	/**
	 * Returns the typactca5.
	 * @return String
	 */
	public String getTypactca5() {
		return typactca5;
	}		

	/**
	 * Returns the typactca6.
	 * @return String
	 */
	public String getTypactca6() {
		return typactca6;
	}		

	/**
	 * Returns the typactca7.
	 * @return String
	 */
	public String getTypactca7() {
		return typactca7;
	}	

	/**
	 * Returns the typactca8.
	 * @return String
	 */
	public String getTypactca8() {
		return typactca8;
	}	

	/**
	 * Returns the typactca9.
	 * @return String
	 */
	public String getTypactca9() {
		return typactca9;
	}	

	/**
	 * Returns the typactca10.
	 * @return String
	 */
	public String getTypactca10() {
		return typactca10;
	}	
	
	/**
	 * Sets the typactca1.
	 * @param typactca1 The typactca1 to set
	 */
	public void setTypactca1(String typactca1) {
		this.typactca1 = typactca1;
	}
	
	/**
	 * Sets the typactca2.
	 * @param typactca2 The typactca2 to set
	 */
	public void setTypactca2(String typactca2) {
		this.typactca2 = typactca2;
	}

	/**
	 * Sets the typactca3.
	 * @param typactca3 The typactca3 to set
	 */
	public void setTypactca3(String typactca3) {
		this.typactca3 = typactca3;
	}

	/**
	 * Sets the typactca4.
	 * @param typactca4 The typactca4 to set
	 */
	public void setTypactca4(String typactca4) {
		this.typactca4 = typactca4;
	}
	
	/**
	 * Sets the typactca5.
	 * @param typactca5 The typactca5 to set
	 */
	public void setTypactca5(String typactca5) {
		this.typactca5 = typactca5;
	}
	
	/**
	 * Sets the typactca6.
	 * @param typactca6 The typactca6 to set
	 */
	public void setTypactca6(String typactca6) {
		this.typactca6 = typactca6;
	}
	
	/**
	 * Sets the typactca7.
	 * @param typactca7 The typactca7 to set
	 */
	public void setTypactca7(String typactca7) {
		this.typactca7 = typactca7;
	}
	/**
	 * Sets the typactca8.
	 * @param typactca8 The typactca8 to set
	 */
	public void setTypactca8(String typactca8) {
		this.typactca8 = typactca8;
	}
	/**
	 * Sets the typactca9.
	 * @param typactca9 The typactca9 to set
	 */
	public void setTypactca9(String typactca9) {
		this.typactca9 = typactca9;
	}
	
	/**
	 * Sets the typactca10.
	 * @param typactca10 The typactca10 to set
	 */
	public void setTypactca10(String typactca10) {
		this.typactca10 = typactca10;
	}

	public String getBloc() {
		return bloc;
	}

	public void setBloc(String bloc) {
		this.bloc = bloc;
	}

	public String getLib_bloc() {
		return lib_bloc;
	}

	public void setLib_bloc(String lib_bloc) {
		this.lib_bloc = lib_bloc;
	}

	public String getAdescr() {
		return adescr;
	}

	public void setAdescr(String adescr) {
		this.adescr = adescr;
	}

	
}
