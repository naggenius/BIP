package com.socgen.bip.form;

import com.socgen.bip.commun.form.AutomateForm;


/**
 * @author N.BACCAM - 15/07/2003
 *
 * Formulaire de mise à jour des budgets en masse
 * chemin : Administration/Budgets JG/Saisie en masse/Mes lignes
 * pages  : fBudgMassAd.jsp et bBudgMassAd.jsp
 * pl/sql : propomass.sql et reestmass.sql
 */
public class BudgMassForm extends AutomateForm {
	
	
	public static int longueurMaxCommentaire = 200;
	
	/*Le nombre de lignes par page 
		*/
	private String blocksize ;
	
	/*ordre de tri 
	*/
	private String ordre_tri ;
	
	/*La direction
	*/
	private String clicode ;
	/*Le libelle de la direction
	*/
	private String libclicode;

	/*L'année
	*/
	private String annee ;
	
	/*Le codsg
	*/
	private String codsg ;

	/*L'application
	*/
	private String airt ;
	/*Libellé de l'application
	*/
	private String libairt ;
	
	/*Appartenance au périmètre ME
	*/
	private String perime;
	/*Appartenance au périmètre MO
	*/
	private String perimo;	

	/*La position du client dans la liste
	*/	
	protected String posClient;			

	/*La position de l'application dans la liste
	*/	
	protected String posAppli;			

	/*Le libelle du departement
	*/
	private String libcodsg;
	
	/*Le totale des consommés
		*/	
	protected String tot_xcusag0;
	
	/*Le totale des notifié
			*/	
	protected String tot_xbnmont;
		
	/*Le totale des reestimé
			*/	
	protected String tot_preesancou;
	
	
	/*Le totale des consommés founisseures
				*/	
	protected String tot_bpmontme;
		
	/*Le totale des consommés clients
				*/	
	protected String tot_bpmontmo;
	
	
	/*Le totale des old consommés
				*/	
	protected String old_tot_xcusag0;
	
	/*Le totale des old notifié
			*/	
	protected String old_tot_xbnmont;
		
	/*Le totale des old reestimé
			*/	
	protected String old_tot_preesancou;
 
	/*Le totale des old consommés founisseures
					*/	
	protected String old_tot_bpmontme;
		
	/*Le totale des old consommés clients
					*/	
	protected String old_tot_bpmontmo;		

	/*Le type save
						*/	
    protected String save;	
    


	/**
	 * Constructor for PropoMassForm.
	 */
	public BudgMassForm() {
		super();
	}


	/**
		 * Returns the blocksize.
		 * @return String
		 */
	public String getBlocksize() {
		return blocksize;
	}

	/**
			 * Returns the ordre_tri.
			 * @return String
			 */
		public String getOrdre_tri() {
			return ordre_tri;
		}
   
  
	/**
	 * Returns the annee.
	 * @return String
	 */
	public String getAnnee() {
		return annee;
	}

	/**
	 * Returns the clicode.
	 * @return String
	 */
	public String getClicode() {
		return clicode;
	}


	/**
		 * Sets the blocksize.
		 * @param annee The annee to set
		 */
		public void setBlocksize(String blocksize) {
			this.blocksize = blocksize;
		} 


	/**
			 * Sets the ordre_tri.
			 * @param annee The annee to set
			 */
	public void setOrdre_tri(String ordre_tri) {
			this.ordre_tri = ordre_tri;
	} 
  

	/**
	 * Sets the annee.
	 * @param annee The annee to set
	 */
	public void setAnnee(String annee) {
		this.annee = annee;
	}

	/**
	 * Sets the clicode.
	 * @param clicode The clicode to set
	 */
	public void setClicode(String clicode) {
		this.clicode = clicode;
	}

	/**
	 * Returns the codsg.
	 * @return String
	 */
	public String getCodsg() {
		return codsg;
	}

	/**
	 * Sets the codsg.
	 * @param codsg The codsg to set
	 */
	public void setCodsg(String codsg) {
		this.codsg = codsg;
	}


	/**
	 * Returns the libclicode.
	 * @return String
	 */
	public String getLibclicode() {
		return libclicode;
	}

	/**
	 * Returns the libcodsg.
	 * @return String
	 */
	public String getLibcodsg() {
		return libcodsg;
	}

	/**
	 * Sets the libclicode.
	 * @param libclicode The libclicode to set
	 */
	public void setLibclicode(String libclicode) {
		this.libclicode = libclicode;
	}

	/**
	 * Sets the libcodsg.
	 * @param libcodsg The libcodsg to set
	 */
	public void setLibcodsg(String libcodsg) {
		this.libcodsg = libcodsg;
	}

	/**
	 * @return
	 */
	public String getAirt() {
		return airt;
	}

	/**
	 * @param string
	 */
	public void setAirt(String string) {
		airt = string;
	}

	/**
	 * @return
	 */
	public String getPosAppli() {
		return posAppli;
	}

	/**
	 * @return
	 */
	public String getPosClient() {
		return posClient;
	}

	/**
	 * @param string
	 */
	public void setPosAppli(String string) {
		posAppli = string;
	}

	/**
	 * @param string
	 */
	public void setPosClient(String string) {
		posClient = string;
	}

	/**
	 * @return
	 */
	public String getLibairt() {
		return libairt;
	}

	/**
	 * @param string
	 */
	public void setLibairt(String string) {
		libairt = string;
	}

	/**
		 * @return
		 */
	public String getTot_xcusag0() {
			return tot_xcusag0;
	}

	/**
	* @param string
	*/
	public void setTot_xcusag0(String string) {
			tot_xcusag0 = string;
	}


	/**
	* @return
	*/
	public String getTot_xbnmont() {
	  	  return tot_xbnmont;
	}

	/**
	* @param string
	*/
	public void setTot_xbnmont(String string) {
			tot_xbnmont = string;
	}
		
		
	/**
	* @return
	*/
	public String getTot_preesancou() {
		return tot_preesancou;
	}

	/**
	* @param string
	*/
	public void setTot_preesancou(String string) {
		tot_preesancou = string;
	}	
    
	/**
		* @return
		*/
		public String getTot_bpmontme() {
			return tot_bpmontme;
		}

    
    
	/**
		* @param string
		*/
		public void setTot_bpmontme(String string) {
				tot_bpmontme = string;
		}
		
		
		/**
		* @return
		*/
		public String getTot_bpmontmo() {
			return tot_bpmontmo;
		}

		/**
		* @param string
		*/
		public void setTot_bpmontmo(String string) {
			tot_bpmontmo = string;
		}	
    
    
	/**
			 * @return
			 */
		public String getOld_tot_xcusag0() {
				return old_tot_xcusag0;
		}

		/**
		* @param string
		*/
		public void setOld_tot_xcusag0(String string) {
				old_tot_xcusag0 = string;
		}


		/**
		* @return
		*/
		public String getOld_tot_xbnmont() {
			  return old_tot_xbnmont;
		}

		/**
		* @param string
		*/
		public void setOld_tot_xbnmont(String string) {
				old_tot_xbnmont = string;
		}
		
		
		/**
		* @return
		*/
		public String getOld_tot_preesancou() {
			return old_tot_preesancou;
		}

		/**
		* @param string
		*/
		public void setOld_tot_preesancou(String string) {
			old_tot_preesancou = string;
		}	
    
    
    
	    /**
			* @return
			*/
			public String getOld_tot_bpmontme() {
				  return old_tot_bpmontme;
			}

			/**
			* @param string
			*/
			public void setOld_tot_bpmontme(String string) {
					old_tot_bpmontme = string;
			}
		
		
			/**
			* @return
			*/
			public String getOld_tot_bpmontmo() {
				return old_tot_bpmontmo;
			}

			/**
			* @param string
			*/
			public void setOld_tot_bpmontmo(String string) {
				old_tot_bpmontmo = string;
			}	

	        /**
		     * @return
			 */
			public String getSave() {
				return save;
			}

			/**
			* @param string
			*/
			public void setSave(String string) {
				save = string;
			}


			public String getPerime() {
				return perime;
			}


			public String getPerimo() {
				return perimo;
			}


			public void setPerime(String perime) {
				this.perime = perime;
			}


			public void setPerimo(String perimo) {
				this.perimo = perimo;
			}	
			
	
			
}
