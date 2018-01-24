package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author N.BACCAM - 13/06/2003
 *
 * Formulaire pour mise à jour des Centres de frais
 * chemin : Administration/Tables/ mise à jour/Centre de frais
 * pages  : bCentrefraisAd.jsp et mCentrefraisAd.jsp
 * pl/sql : centrefrais.sql
 */
public class CentrefraisForm extends AutomateForm{
	/*Le code Centrefrais
	*/
	protected String codcfrais ;
    /*Le libelle du Centrefrais
	*/
	private String libcfrais;   
	
	/*Le code de la filiale
	   */
	   private String filcode;   
	
	   
	/*Le libelle de la filiale
		   */
		   private String filsigle;    
	   
	   
	/*
    *Le code BDDPG
	*/
	private String bddpg;
	/*Le code habilitation
	*/
	private String habilitation;
	
	/*Le keyList0 = code centre frais
	*/
	private String keyList0; 
	/*Le keyList1 = niveau d'habilitation
	*/
	private String keyList1; 
	
 			
	/**
	 * Constructor for ClientForm.
	 */
	public CentrefraisForm() {
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
	 * Returns the codcfrais.
	 * @return String
	 */
	public String getCodcfrais() {
		return codcfrais;
	}

	
	/**
	 * Returns the libcfrais.
	 * @return String
	 */
	public String getLibcfrais() {
		return libcfrais;
	}
	
	
	/**
		 * Returns the filcode.
		 * @return String
		 */
		public String getFilcode() {
			return filcode;
		}
	
	/**
			 * Returns the libelle of filcode.
			 * @return String
			 */
			public String getFilsigle() {
				return filsigle;
			}
	
	
	

	/**
	 * Sets the codcfrais.
	 * @param codcfrais The codcfrais to set
	 */
	public void setCodcfrais(String codcfrais) {
		this.codcfrais = codcfrais;
	}

	/**
	 * Sets the libcfrais.
	 * @param libcfrais The libcfrais to set
	 */
	public void setLibcfrais(String libcfrais) {
		this.libcfrais = libcfrais;
	}

	/**
		 * Sets the filcode.
		 * @param libcfrais The libcfrais to set
		 */
		public void setFilcode(String filcode) {
			this.filcode = filcode;
		}

	/**
			 * Sets the filcode.
			 * @param libcfrais The libcfrais to set
			 */
			public void setFilsigle(String filsigle) {
				this.filsigle = filsigle;
			}


	/**
	 * Returns the keyList0.
	 * @return String
	 */
	public String getKeyList0() {
		return keyList0;
	}

	/**
	 * Returns the keyList1.
	 * @return String
	 */
	public String getKeyList1() {
		return keyList1;
	}



	/**
	 * Sets the keyList0.
	 * @param keyList0 The keyList0 to set
	 */
	public void setKeyList0(String keyList0) {
		this.keyList0 = keyList0;
	}

	/**
	 * Sets the keyList1.
	 * @param keyList1 The keyList1 to set
	 */
	public void setKeyList1(String keyList1) {
		this.keyList1 = keyList1;
	}

	
	/**
	 * Returns the bddpg.
	 * @return String
	 */
	public String getBddpg() {
		return bddpg;
	}

	/**
	 * Returns the habilitation.
	 * @return String
	 */
	public String getHabilitation() {
		return habilitation;
	}

	/**
	 * Sets the bddpg.
	 * @param bddpg The bddpg to set
	 */
	public void setBddpg(String bddpg) {
		this.bddpg = bddpg;
	}

	/**
	 * Sets the habilitation.
	 * @param habilitation The habilitation to set
	 */
	public void setHabilitation(String habilitation) {
		this.habilitation = habilitation;
	}

}
