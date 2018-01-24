package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author N.BACCAM - 9/05/2003
 *
 * Formulaire pour mise à jour des codes clients MO
 * pages : fmClientAd.jsp, mClientAd.jsp
 */
public class ClientForm extends AutomateForm{
	/*Le code client MO */
	private String clicode ;
	
    /*Le code filiale */
	private String filcode ;
	
	/*direction du client */
	private int iCliDir;
		
	/*Le pôle du client */
	private String sCliPole;
	
	/*Le département du client */
	private String sCliDep;
	
	/*Code CA de la MO */
	private String sCodcamo;
	
	/*Libelle du CAMO */
	private String sLibCodeCAMO;
	
	/*Le libellé du client MO */
	private String clilib ;
	
	/*Le sigle */
	private String clisigle ;
	
	/*Le top fermeture */
	private String clitopf ;
	
	/*Le flaglock */
	private int flaglock ;
	/*Le top diva (O/F)
	*/
	private String top_diva;
	
	/**
	 * Constructor for ClientForm.
	 */
	public ClientForm() {
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
	 * Returns the clicode.
	 * @return String
	 */
	public String getClicode() {
		return clicode;
	}

	/**
	 * Returns the clilib.
	 * @return String
	 */
	public String getClilib() {
		return clilib;
	}

	/**
	 * Returns the clisigle.
	 * @return String
	 */
	public String getClisigle() {
		return clisigle;
	}

	/**
	 * Returns the clitopf.
	 * @return String
	 */
	public String getClitopf() {
		return clitopf;
	}

	/**
	 * Returns the filcode.
	 * @return String
	 */
	public String getFilcode() {
		return filcode;
	}
	/**
	 * Returns the top_diva.
	 * @return String
	 */
	public String getTop_diva() {
		return top_diva;
	}

	/**
	 * Sets the clicode.
	 * @param clicode The clicode to set
	 */
	public void setClicode(String clicode) {
		this.clicode = clicode;
	}


	

	/**
	 * Sets the clilib.
	 * @param clilib The clilib to set
	 */
	public void setClilib(String clilib) {
		this.clilib = clilib;
	}

	/**
	 * Sets the clisigle.
	 * @param clisigle The clisigle to set
	 */
	public void setClisigle(String clisigle) {
		this.clisigle = clisigle;
	}

	/**
	 * Sets the clitopf.
	 * @param clitopf The clitopf to set
	 */
	public void setClitopf(String clitopf) {
		this.clitopf = clitopf;
	}

	/**
	 * Sets the filcode.
	 * @param filcode The filcode to set
	 */
	public void setFilcode(String filcode) {
		this.filcode = filcode;
	}




	
	/**
	 * Sets the flaglock.
	 * @param flaglock The flaglock to set
	 */
	public void setFlaglock(int flaglock) {
		this.flaglock = flaglock;
	}

	/**
	 * Returns the flaglock.
	 * @return int
	 */
	public int getFlaglock() {
		return flaglock;
	}

	

	/**
	 * @return
	 */
	public String getCodcamo()
	{
		return sCodcamo;
	}

	/**
	 * @return
	 */
	public String getCliDep()
	{
		return sCliDep;
	}

	/**
	 * @return
	 */
	public String getCliPole()
	{
		return sCliPole;
	}

	/**
	 * @param string
	 */
	public void setCodcamo(String string)
	{
		sCodcamo = string;
	}

	/**
	 * @param string
	 */
	public void setCliDep(String string)
	{
		sCliDep = string;
	}

	/**
	 * @param string
	 */
	public void setCliPole(String string)
	{
		sCliPole = string;
	}

	/**
	 * @return
	 */
	public int getCliDir()
	{
		return iCliDir;
	}

	/**
	 * @param string
	 */
	public void setCliDir(int val)
	{
		iCliDir = val;
	}

	/**
	 * @return
	 */
	public String getLibCodeCAMO()
	{
		return sLibCodeCAMO;
	}

	/**
	 * @param string
	 */
	public void setLibCodeCAMO(String string)
	{
		sLibCodeCAMO = string;
	}
	/**
	 * Sets the top_diva.
	 * @param top_diva The top_diva to set
	 */
	public void setTop_diva(String top_diva) {
		this.top_diva = top_diva;
	}
}
