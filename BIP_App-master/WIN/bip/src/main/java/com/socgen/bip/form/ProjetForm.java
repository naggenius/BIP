package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;



/**
 * @author N.BACCAM - 18/06/2003
 *
 * Formulaire pour mise à jour des projets informatiques
 * chemin : Administration/Référentiels/Projets
 * pages  : fmProjetAd.jsp et mProjetAd.jsp
 * pl/sql : projinfo.sql
 */
public class ProjetForm extends AutomateForm{

	/*Le code projet info
	*/   
    private String icpi ; 
    /*Le ref Demande 
	*/   
    
    // HMI PPM 61919 $6.8
    private String projaxemetier;
    
    // PPM 64510
    private String updatestatut;

	/*Le libelle
	*/   
    private String ilibel ;
    
    /*La description
	*/  
    private String descr ; 
    /*Le client MO
	*/   
    private String clicode ; 
     /*Le nom de la MO
	*/  
    private String imop ; 
    /*Le code DPG
	*/  
    private String codsg ; 
    /*Le nom de la ME
	*/  
    private String icme ;  
    /*Le code dossier projet
	*/  
    private String icodproj ; 
    /*Le code projet groupe
	*/  
    private String icpir ;
    /* Le statut
    */
    private String statut;
    /* Date de dernière modification du statut
    */
    private String dateStatut;
    /* CADA (Centre d'Activité 
    */
    private String cada;
    /* Date de démarrage du projet
    */
    private String dateDemarrage;
    
	/* Code domaine bancaire du projet
	 */
	private String cod_db;
	
	private String duplic ; 
		/*Le paramètre dupliquer/créer
		 */
	private String clilib ; 
		/*Libellé du code MO
		 */
	private String libdsg ; 
		/*Libellé du code ME
		 */		 
	private String datprod ; 
		/*Date prévue de mise en production
		 */		 
	private String datrpro ; 
		/*Date révisée de mise en production
		 */		 		 
	private String deanre ; 
		/*Dernière année de restitution
		 */		 		
	private String crireg ; 
		/*Critère de regroupement
		 */		 		
	private String librpb ; 
		/*Libellé du service du RPB
		 */		 		
	private String idrpb ; 
		/*Nom du RPB
		 */		 		
	private String datcre ; 
			/*Date de création du projet
			 */		 
	private String libcada ; 
				/*Libellé du CADA
				 */		 		
	private String topaction ; 
				/*Sauvegarde de l'action initiale car l'action est écrasée par le refresh
				 */

	private String edition ; 
				/*Paramètre de lancement d'édition
				 */		 					 		 		
	
	private String count = "0" ; 
	/*Paramètre count
	 */		 
	
	/*Le flaglock
	*/
	private int flaglock ;

	/* Lien code Projet /CA 
	*/
	private String licodprca;

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
		
	/* Libellé CA 3 préconisé 
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
	
    /* Statut du dossier projet (O/N)
     */
     private String dpactif;	
     
     /* Libelle du dossier projet
      */
      private String dplib;
      
     
     private String dpcopi  ; 
      
     
     private String dossierProjCode ; 
     
     private String topenvoi;
     
     private String date_envoi;
     
     private String lib_domaine;
     
     /*Date fonctionnel
 	*/   
     private String datefonctionnel ;
     
     private String dureeamor;


	public String getDureeamor() {
		return dureeamor;
	}

	public void setDureeamor(String dureeamor) {
		this.dureeamor = dureeamor;
	}

	/**
	 * Constructor for ClientForm.
	 */
	public ProjetForm() {
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
	 * Returns the icme.
	 * @return String
	 */
	public String getIcme() {
		return icme;
	}

	/**
	 * Returns the icodproj.
	 * @return String
	 */
	public String getIcodproj() {
		return icodproj;
	}

	/**
	 * Returns the icpi.
	 * @return String
	 */
	public String getIcpi() {
		return icpi;
	}

	/**
	 * Returns the icpir.
	 * @return String
	 */
	public String getIcpir() {
		return icpir;
	}

	/**
	 * Returns the idescr1.
	 * @return String
	 */
	public String getDescr() {
		return descr;
	}


	/**
	 * Returns the ilibel.
	 * @return String
	 */
	public String getIlibel() {
		return ilibel;
	}

	/**
	 * Returns the imop.
	 * @return String
	 */
	public String getImop() {
		return imop;
	}

	/**
	 * Returns the duplic.
	 * @return String
	 */
	public String getDuplic() {
		return duplic;
	}

	/**
	 * Returns the clilib.
	 * @return String
	 */
	public String getClilib() {
		return clilib;
	}

	/**
	 * Returns the libdsg.
	 * @return String
	 */
	public String getLibdsg() {
		return libdsg;
	}

	/**
	 * Returns the datprod.
	 * @return String
	 */
	public String getDatprod() {
		return datprod;
	}

	/**
	 * Returns the datrpro.
	 * @return String
	 */
	public String getDatrpro() {
		return datrpro;
	}

	/**
	 * Returns the deanre.
	 * @return String
	 */
	public String getDeanre() {
		return deanre;
	}

	/**
	 * Returns the datcre.
	 * @return String
	 */
	public String getDatcre() {
		return datcre;
	}
	
	/**
	 * Returns the librpb.
	 * @return String
	 */
	public String getLibrpb() {
		return librpb;
	}
	
	/**
	 * Returns the idrpb.
	 * @return String
	 */
	public String getIdrpb() {
		return idrpb;
	}
	
	/**
	 * Returns the crireg.
	 * @return String
	 */
	public String getCrireg() {
		return crireg;
	}	
	
	/**
	 * Returns the libcada.
	 * @return String
	 */
	public String getLibcada() {
		return libcada;
	}		
	
	/**
	 * Returns the topaction.
	 * @return String
	 */
	public String getTopaction() {
		return topaction;
	}
	
	/**
	 * Returns the edition.
	 * @return String
	 */
	public String getEdition() {
		return edition;
	}
	
	/**
	 * Sets the clicode.
	 * @param clicode The clicode to set
	 */
	public void setClicode(String clicode) {
		this.clicode = clicode;
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
	 * Sets the icme.
	 * @param icme The icme to set
	 */
	public void setIcme(String icme) {
		this.icme = icme;
	}

	/**
	 * Sets the icodproj.
	 * @param icodproj The icodproj to set
	 */
	public void setIcodproj(String icodproj) {
		this.icodproj = icodproj;
	}

	/**
	 * Sets the icpi.
	 * @param icpi The icpi to set
	 */
	public void setIcpi(String icpi) {
		this.icpi = icpi;
	}

	/**
	 * Sets the icpir.
	 * @param icpir The icpir to set
	 */
	public void setIcpir(String icpir) {
		this.icpir = icpir;
	}

	/**
	 * Sets the idescr1.
	 * @param idescr1 The idescr1 to set
	 */
	public void setDescr(String descr) {
		this.descr = descr;
	}


	/**
	 * Sets the ilibel.
	 * @param ilibel The ilibel to set
	 */
	public void setIlibel(String ilibel) {
		this.ilibel = ilibel;
	}

	/**
	 * Sets the imop.
	 * @param imop The imop to set
	 */
	public void setImop(String imop) {
		this.imop = imop;
	}

	/**
	 * Sets the duplic.
	 * @param duplic The duplic to set
	 */
	public void setDuplic(String duplic) {
		this.duplic = duplic;
	}

	/**
	 * Returns the cada.
	 * @return String
	 */
	public String getCada() {
		return cada;
	}

	/**
	 * Returns the dateDemarrage.
	 * @return String
	 */
	public String getDateDemarrage() {
		return dateDemarrage;
	}

	/**
	 * Returns the dateStatut.
	 * @return String
	 */
	public String getDateStatut() {
		return dateStatut;
	}

	/**
	 * Returns the statut.
	 * @return String
	 */
	public String getStatut() {
		return statut;
	}

	/**
	 * Sets the cada.
	 * @param cada The cada to set
	 */
	public void setCada(String cada) {
		this.cada = cada;
	}

	/**
	 * Sets the dateDemarrage.
	 * @param dateDemarrage The dateDemarrage to set
	 */
	public void setDateDemarrage(String dateDemarrage) {
		this.dateDemarrage = dateDemarrage;
	}

	/**
	 * Sets the dateStatut.
	 * @param dateStatut The dateStatut to set
	 */
	public void setDateStatut(String dateStatut) {
		this.dateStatut = dateStatut;
	}

	/**
	 * Sets the statut.
	 * @param statut The statut to set
	 */
	public void setStatut(String statut) {
		this.statut = statut;
	}

	/**
	 * @return
	 * Retourne le code domaine bancaire du projet
	 */
	public String getCod_db() {
		return cod_db;
	}

	/**
	 * @param string
	 * Met à jour le code domaine bancaire du projet
	 */
	public void setCod_db(String string) {
		cod_db = string;
	}

	/**
	 * Sets the clilib.
	 * @param clilib The clilib to set
	 */
	public void setClilib(String clilib) {
		this.clilib = clilib;
	}
	
	/**
	 * Sets the libdsg.
	 * @param libdsg The libdsg to set
	 */
	public void setLibdsg(String libdsg) {
		this.libdsg = libdsg;
	}	

	/**
	 * Sets the datprod.
	 * @param datprod The datprod to set
	 */
	public void setDatprod(String datprod) {
		this.datprod = datprod;
	}	

	/**
	 * Sets the datrpro.
	 * @param datrpro The datrpro to set
	 */
	public void setDatrpro(String datrpro) {
		this.datrpro = datrpro;
	}	
	
	/**
	 * Sets the deanre.
	 * @param deanre The deanre to set
	 */
	public void setDeanre(String deanre) {
		this.deanre = deanre;
	}	

	/**
	 * Sets the datcre.
	 * @param datcre The datcre to set
	 */
	public void setDatcre(String datcre) {
		this.datcre = datcre;
	}	
	
	/**
	 * Sets the librpb.
	 * @param librpb The librpb to set
	 */
	public void setLibrpb(String librpb) {
		this.librpb = librpb;
	}		

	/**
	 * Sets the idrpb.
	 * @param idrpb The idrpb to set
	 */
	public void setIdrpb(String idrpb) {
		this.idrpb = idrpb;
	}	
	
	/**
	 * Sets the crireg.
	 * @param crireg The crireg to set
	 */
	public void setCrireg(String crireg) {
		this.crireg = crireg;
	}		

	/**
	 * Sets the crireg.
	 * @param crireg The crireg to set
	 */
	public void setLibcada(String libcada) {
		this.libcada = libcada;
	}	
	
	/**
	 * Sets the topaction.
	 * @param topaction The topaction to set
	 */
	public void setTopaction(String topaction) {
		this.topaction = topaction;
	}
	
	/**
	 * Sets the edition.
	 * @param crireg The topaction to set
	 */
	public void setEdition(String edition) {
		this.edition = edition;
	}	

	/**
	 * Returns the licodprca.
	 * @return String
	 */
	public String getLicodprca() {
		return licodprca;
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
	 * Sets the licodprca.
	 * @param licodprca The licodprca to set
	 */
	public void setLicodprca(String licodprca) {
		this.licodprca = licodprca;
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

	public String getDpactif() {
		return dpactif;
	}

	public void setDpactif(String dpactif) {
		this.dpactif = dpactif;
	}

	public String getDplib() {
		return dplib;
	}

	public void setDplib(String dplib) {
		this.dplib = dplib;
	}

	public String getDpcopi() {
		return dpcopi;
	}

	public void setDpcopi(String dpcopi) {
		this.dpcopi = dpcopi;
	}

	public String getDossierProjCode() {
		return dossierProjCode;
	}

	public void setDossierProjCode(String dossierProjCode) {
		this.dossierProjCode = dossierProjCode;
	}

 
	public String getDate_envoi() {
		return date_envoi;
	}

	public void setDate_envoi(String date_envoi) {
		this.date_envoi = date_envoi;
	}

	public String getTopenvoi() {
		return topenvoi;
	}

	public void setTopenvoi(String topenvoi) {
		this.topenvoi = topenvoi;
	}

	public String getLib_domaine() {
		return lib_domaine;
	}

	public void setLib_domaine(String lib_domaine) {
		this.lib_domaine = lib_domaine;
	}

	public String getDatefonctionnel() {
		return datefonctionnel;
	}

	public void setDatefonctionnel(String datefonctionnel) {
		this.datefonctionnel = datefonctionnel;
	}

	public String getCount() {
		return count;
	}

	public void setCount(String count) {
		this.count = count;
	}

	public String getProjaxemetier() {
		return projaxemetier;
	}

	public void setProjaxemetier(String projaxemetier) {
		this.projaxemetier = projaxemetier;
	}

	public String getUpdatestatut() {
		return updatestatut;
	}

	public void setUpdatestatut(String updatestatut) {
		this.updatestatut = updatestatut;
	}

	




	
	
	
}
