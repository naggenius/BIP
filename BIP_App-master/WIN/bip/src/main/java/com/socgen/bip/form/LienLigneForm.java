package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author N.BACCAM - 21/07/2003
 *
 * Action de mise à jour des liens Ligne BIP
 * chemin : Administration/Ligne Bip/ Liens 
 * pages  : fLiendpAd.jsp, mLiendpAd.jsp, bLiendpAd.jsp
 * 			fLiendpgAd.jsp, mLiendpgAd.jsp, bLiendpAd.jsp
 * 			fLienmoAd.jsp, mLienmoAd.jsp, bLienmoAd.jsp
 * 			fLiencamoAd.jsp, mLiencamoAd.jsp, bLiencamoAd.jsp 
 * 			fLienprojetAd.jsp, mLienprojetAd.jsp, bLienprojetAd.jsp
 * 			fLienappliAd.jsp, mLienappliAd.jsp, bLienappliAd.jsp
 * 			fLiencpAd.jsp, mLiencpAd.jsp, bLiencpAd.jsp
 * pl/sql : dos_proj.sql, pcprjinf.sql
 */
public class LienLigneForm extends AutomateForm {
	
	
	
	
	/*Le code dossier projet
		*/
		private String dpcode;
	

	/*Le libellé du dossier projet
	*/
	private String dplib;
	
	/*Le code dep/pole/groupe
	*/
	private String codsg;

	/*Le libellé du DPG
	*/
	private String libdsg;
	
	/*Le code client MO
	*/
	private String clicode;

	/*Le libellé du client MO
	*/
	private String clilib;
	
	/*Le code CA MO
	*/
	private String codcamo;

	/*Le libellé du CA MO
	*/
	private String clibca;
	
	/*Le code projet
	*/
	private String icpi;

	/*Le libellé du projet
	*/
	private String ilibel;
	
	/*Le code application
	*/
	private String airt;

	/*Le libellé de l'application
	*/
	private String alibel;
	
	
	/*Le code du chef de projet
			*/
	private String cpcode;
	
	/*Le nom du chef de projet
				*/
	private String rnom;
				
	/*Le prenom du chef de projet
				*/
	private String rprenom;
				
		
	/*Libellé = DPG ou MO
	*/
	private String table;
	/*Les codes projets 
	 */
	private String pid_1;
	private String pid_2;
	private String pid_3;
	private String pid_4;
	private String pid_5;
	private String pid_6;

	/*Le libelle des projets
	 */
	private String pnom_1;
	private String pnom_2;
	private String pnom_3;
	private String pnom_4;
	private String pnom_5;
	private String pnom_6;
	/*Les flaglocks
	*/
	private String flaglock_1;
	private String flaglock_2;
	private String flaglock_3;
	private String flaglock_4;
	private String flaglock_5;
	private String flaglock_6;
   
	/**
	 * Constructor 
	 */
	public LienLigneForm() {
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
	public ActionErrors validate(
		ActionMapping mapping,
		HttpServletRequest request) {

		ActionErrors errors = new ActionErrors();

		this.logIhm.debug("Début validation de la form -> " + this.getClass());
		logIhm.debug("Fin validation de la form -> " + this.getClass());
		return errors;
	}

	

	/**
	 * Returns the libdsg.
	 * @return String
	 */
	public String getLibdsg() {
		return libdsg;
	}

	/**
	 * Sets the codsg.
	 * @param codsg The codsg to set
	 */
	public void setCodsg(String codsg) {
		this.codsg = codsg;
	}

	/**
	 * Sets the libdsg.
	 * @param libdsg The libdsg to set
	 */
	public void setLibdsg(String libdsg) {
		this.libdsg = libdsg;
	}


	/**
		 * Returns the codsg.
		 * @return String
		 */
		public String getCodsg() {
			return codsg;
		}
		
	/**
		 * Returns the rnom.
		 * @return String
		 */
		public String getRnom() {
			return rnom;
		}
		
		
	/**
		 * Returns the rprenom.
		 * @return String
		 */
		public String getRprenom() {
			return rprenom;
		}

	
	/**
	 * Returns the flaglock_1.
	 * @return String
	 */
	public String getFlaglock_1() {
		return flaglock_1;
	}

	/**
	 * Returns the flaglock_2.
	 * @return String
	 */
	public String getFlaglock_2() {
		return flaglock_2;
	}

	/**
	 * Returns the flaglock_3.
	 * @return String
	 */
	public String getFlaglock_3() {
		return flaglock_3;
	}

	/**
	 * Returns the flaglock_4.
	 * @return String
	 */
	public String getFlaglock_4() {
		return flaglock_4;
	}

	/**
	 * Returns the flaglock_5.
	 * @return String
	 */
	public String getFlaglock_5() {
		return flaglock_5;
	}

	/**
	 * Returns the flaglock_6.
	 * @return String
	 */
	public String getFlaglock_6() {
		return flaglock_6;
	}

	/**
	 * Returns the pid_1.
	 * @return String
	 */
	public String getpid_1() {
		return pid_1;
	}

	/**
	 * Returns the pid_2.
	 * @return String
	 */
	public String getpid_2() {
		return pid_2;
	}

	/**
	 * Returns the pid_3.
	 * @return String
	 */
	public String getpid_3() {
		return pid_3;
	}

	/**
	 * Returns the pid_4.
	 * @return String
	 */
	public String getpid_4() {
		return pid_4;
	}

	/**
	 * Returns the pid_5.
	 * @return String
	 */
	public String getpid_5() {
		return pid_5;
	}

	/**
	 * Returns the pid_6.
	 * @return String
	 */
	public String getpid_6() {
		return pid_6;
	}

	/**
	 * Returns the pnom_1.
	 * @return String
	 */
	public String getpnom_1() {
		return pnom_1;
	}

	/**
	 * Returns the pnom_2.
	 * @return String
	 */
	public String getpnom_2() {
		return pnom_2;
	}

	/**
	 * Returns the pnom_3.
	 * @return String
	 */
	public String getpnom_3() {
		return pnom_3;
	}

	/**
	 * Returns the pnom_4.
	 * @return String
	 */
	public String getpnom_4() {
		return pnom_4;
	}

	/**
	 * Returns the pnom_5.
	 * @return String
	 */
	public String getpnom_5() {
		return pnom_5;
	}

	/**
	 * Returns the pnom_6.
	 * @return String
	 */
	public String getpnom_6() {
		return pnom_6;
	}

	/**
	 * Sets the flaglock_1.
	 * @param flaglock_1 The flaglock_1 to set
	 */
	public void setFlaglock_1(String flaglock_1) {
		this.flaglock_1 = flaglock_1;
	}

	/**
	 * Sets the flaglock_2.
	 * @param flaglock_2 The flaglock_2 to set
	 */
	public void setFlaglock_2(String flaglock_2) {
		this.flaglock_2 = flaglock_2;
	}

	/**
	 * Sets the flaglock_3.
	 * @param flaglock_3 The flaglock_3 to set
	 */
	public void setFlaglock_3(String flaglock_3) {
		this.flaglock_3 = flaglock_3;
	}

	/**
	 * Sets the flaglock_4.
	 * @param flaglock_4 The flaglock_4 to set
	 */
	public void setFlaglock_4(String flaglock_4) {
		this.flaglock_4 = flaglock_4;
	}

	/**
	 * Sets the flaglock_5.
	 * @param flaglock_5 The flaglock_5 to set
	 */
	public void setFlaglock_5(String flaglock_5) {
		this.flaglock_5 = flaglock_5;
	}

	/**
	 * Sets the flaglock_6.
	 * @param flaglock_6 The flaglock_6 to set
	 */
	public void setFlaglock_6(String flaglock_6) {
		this.flaglock_6 = flaglock_6;
	}

	/**
	 * Sets the pid_1.
	 * @param pid_1 The pid_1 to set
	 */
	public void setpid_1(String pid_1) {
		this.pid_1 = pid_1;
	}

	/**
	 * Sets the pid_2.
	 * @param pid_2 The pid_2 to set
	 */
	public void setpid_2(String pid_2) {
		this.pid_2 = pid_2;
	}

	/**
	 * Sets the pid_3.
	 * @param pid_3 The pid_3 to set
	 */
	public void setpid_3(String pid_3) {
		this.pid_3 = pid_3;
	}

	/**
	 * Sets the pid_4.
	 * @param pid_4 The pid_4 to set
	 */
	public void setpid_4(String pid_4) {
		this.pid_4 = pid_4;
	}

	/**
	 * Sets the pid_5.
	 * @param pid_5 The pid_5 to set
	 */
	public void setpid_5(String pid_5) {
		this.pid_5 = pid_5;
	}

	/**
	 * Sets the pid_6.
	 * @param pid_6 The pid_6 to set
	 */
	public void setpid_6(String pid_6) {
		this.pid_6 = pid_6;
	}

	/**
	 * Sets the pnom_1.
	 * @param pnom_1 The pnom_1 to set
	 */
	public void setpnom_1(String pnom_1) {
		this.pnom_1 = pnom_1;
	}

	/**
	 * Sets the pnom_2.
	 * @param pnom_2 The pnom_2 to set
	 */
	public void setpnom_2(String pnom_2) {
		this.pnom_2 = pnom_2;
	}

	/**
	 * Sets the pnom_3.
	 * @param pnom_3 The pnom_3 to set
	 */
	public void setpnom_3(String pnom_3) {
		this.pnom_3 = pnom_3;
	}

	/**
	 * Sets the pnom_4.
	 * @param pnom_4 The pnom_4 to set
	 */
	public void setpnom_4(String pnom_4) {
		this.pnom_4 = pnom_4;
	}

	/**
	 * Sets the pnom_5.
	 * @param pnom_5 The pnom_5 to set
	 */
	public void setpnom_5(String pnom_5) {
		this.pnom_5 = pnom_5;
	}

	/**
	 * Sets the pnom_6.
	 * @param pnom_6 The pnom_6 to set
	 */
	public void setpnom_6(String pnom_6) {
		this.pnom_6 = pnom_6;
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
	 * Returns the table.
	 * @return String
	 */
	public String getTable() {
		return table;
	}

	/**
	 * Sets the table.
	 * @param table The table to set
	 */
	public void setTable(String table) {
		this.table = table;
	}

	/**
	 * Returns the airt.
	 * @return String
	 */
	public String getAirt() {
		return airt;
	}

	/**
	 * Returns the alibel.
	 * @return String
	 */
	public String getAlibel() {
		return alibel;
	}

	/**
	 * Returns the clibca.
	 * @return String
	 */
	public String getClibca() {
		return clibca;
	}

	/**
	 * Returns the codcamo.
	 * @return String
	 */
	public String getCodcamo() {
		return codcamo;
	}
	
	/**
		 * Returns the cpcode.
		 * @return String
		 */
		public String getCpcode() {
			return cpcode;
		}
	
	/**
	 * Returns the dpcode.
	 * @return String
	 */
	public String getDpcode() {
		return dpcode;
	}

	/**
	 * Returns the dplib.
	 * @return String
	 */
	public String getDplib() {
		return dplib;
	}

	

	/**
	 * Sets the airt.
	 * @param airt The airt to set
	 */
	public void setAirt(String airt) {
		this.airt = airt;
	}

	/**
	 * Sets the alibel.
	 * @param alibel The alibel to set
	 */
	public void setAlibel(String alibel) {
		this.alibel = alibel;
	}

	/**
	 * Sets the clibca.
	 * @param clibca The clibca to set
	 */
	public void setClibca(String clibca) {
		this.clibca = clibca;
	}

	/**
	 * Sets the codcamo.
	 * @param codcamo The codcamo to set
	 */
	public void setCodcamo(String codcamo) {
		this.codcamo = codcamo;
	}

	/**
		 * Sets the cpcode.
		 * @param cpcode The cpcode to set
		 */
		public void setCpcode(String cpcode) {
			this.cpcode = cpcode;
		}
		
		
	/**
			 * Sets the rnom.
			 * @param cpcode The cpcode to set
			 */
			public void setRnom(String rnom) {
				this.rnom = rnom;
			}
			
	/**
			 * Sets the rprenom.
			 * @param cpcode The cpcode to set
			 */
			public void setRprenom(String rprenom) {
				this.rprenom = rprenom;
			}			


	/**
	 * Sets the dpcode.
	 * @param dpcode The dpcode to set
	 */
	public void setDpcode(String dpcode) {
		this.dpcode = dpcode;
	}

	/**
	 * Sets the dplib.
	 * @param dplib The dplib to set
	 */
	public void setDplib(String dplib) {
		this.dplib = dplib;
	}



	
	/**
	 * Returns the pid_1.
	 * @return String
	 */
	public String getPid_1() {
		return pid_1;
	}

	/**
	 * Returns the pid_2.
	 * @return String
	 */
	public String getPid_2() {
		return pid_2;
	}

	/**
	 * Returns the pid_3.
	 * @return String
	 */
	public String getPid_3() {
		return pid_3;
	}

	/**
	 * Returns the pid_4.
	 * @return String
	 */
	public String getPid_4() {
		return pid_4;
	}

	/**
	 * Returns the pid_5.
	 * @return String
	 */
	public String getPid_5() {
		return pid_5;
	}

	/**
	 * Returns the pid_6.
	 * @return String
	 */
	public String getPid_6() {
		return pid_6;
	}

	

	/**
	 * Returns the pnom_1.
	 * @return String
	 */
	public String getPnom_1() {
		return pnom_1;
	}

	/**
	 * Returns the pnom_2.
	 * @return String
	 */
	public String getPnom_2() {
		return pnom_2;
	}

	/**
	 * Returns the pnom_3.
	 * @return String
	 */
	public String getPnom_3() {
		return pnom_3;
	}

	/**
	 * Returns the pnom_4.
	 * @return String
	 */
	public String getPnom_4() {
		return pnom_4;
	}

	/**
	 * Returns the pnom_5.
	 * @return String
	 */
	public String getPnom_5() {
		return pnom_5;
	}

	/**
	 * Returns the pnom_6.
	 * @return String
	 */
	public String getPnom_6() {
		return pnom_6;
	}

	

	/**
	 * Sets the pid_1.
	 * @param pid_1 The pid_1 to set
	 */
	public void setPid_1(String pid_1) {
		this.pid_1 = pid_1;
	}

	/**
	 * Sets the pid_2.
	 * @param pid_2 The pid_2 to set
	 */
	public void setPid_2(String pid_2) {
		this.pid_2 = pid_2;
	}

	/**
	 * Sets the pid_3.
	 * @param pid_3 The pid_3 to set
	 */
	public void setPid_3(String pid_3) {
		this.pid_3 = pid_3;
	}

	/**
	 * Sets the pid_4.
	 * @param pid_4 The pid_4 to set
	 */
	public void setPid_4(String pid_4) {
		this.pid_4 = pid_4;
	}

	/**
	 * Sets the pid_5.
	 * @param pid_5 The pid_5 to set
	 */
	public void setPid_5(String pid_5) {
		this.pid_5 = pid_5;
	}

	/**
	 * Sets the pid_6.
	 * @param pid_6 The pid_6 to set
	 */
	public void setPid_6(String pid_6) {
		this.pid_6 = pid_6;
	}

	
	/**
	 * Sets the pnom_1.
	 * @param pnom_1 The pnom_1 to set
	 */
	public void setPnom_1(String pnom_1) {
		this.pnom_1 = pnom_1;
	}

	/**
	 * Sets the pnom_2.
	 * @param pnom_2 The pnom_2 to set
	 */
	public void setPnom_2(String pnom_2) {
		this.pnom_2 = pnom_2;
	}

	/**
	 * Sets the pnom_3.
	 * @param pnom_3 The pnom_3 to set
	 */
	public void setPnom_3(String pnom_3) {
		this.pnom_3 = pnom_3;
	}

	/**
	 * Sets the pnom_4.
	 * @param pnom_4 The pnom_4 to set
	 */
	public void setPnom_4(String pnom_4) {
		this.pnom_4 = pnom_4;
	}

	/**
	 * Sets the pnom_5.
	 * @param pnom_5 The pnom_5 to set
	 */
	public void setPnom_5(String pnom_5) {
		this.pnom_5 = pnom_5;
	}

	/**
	 * Sets the pnom_6.
	 * @param pnom_6 The pnom_6 to set
	 */
	public void setPnom_6(String pnom_6) {
		this.pnom_6 = pnom_6;
	}

	/**
	 * Returns the icpi.
	 * @return String
	 */
	public String getIcpi() {
		return icpi;
	}

	/**
	 * Returns the ilibel.
	 * @return String
	 */
	public String getIlibel() {
		return ilibel;
	}

	/**
	 * Sets the icpi.
	 * @param icpi The icpi to set
	 */
	public void setIcpi(String icpi) {
		this.icpi = icpi;
	}

	/**
	 * Sets the ilibel.
	 * @param ilibel The ilibel to set
	 */
	public void setIlibel(String ilibel) {
		this.ilibel = ilibel;
	}

}