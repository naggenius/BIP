package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author N.BACCAM - 20/06/2003
 *
 * Formulaire pour mise à jour des Personnes
 * chemin : Ressources/ mise à jour/Personne
 * pages  : bPersonneAd.jsp et mPersonneAd.jsp
 * pl/sql : resper.sql
 */


public class PersonneForm extends AutomateForm{
//oldatsitu:1;2:rnom:1;3:ident:1;4:rprenom:1;5:matricule:1;6:datsitu:1;7:datdep:1;8:codsg:1;9:filcode:1;10:soccode:1;11:rmcomp:1;12:prestation:1;13:dispo:1;14:cpident:1;15:cout:1;16:flaglock
	/*Le code Personne
	*/
	protected String ident ;
	/*Début Nom
	*/
	protected String debnom;
	/*Nom contient
	*/
	protected String nomcont;
	/*Le nom de la Personne
	*/
	private String rnom ;
	/*Le prénom de la Personne
	*/   
	private String rprenom ;
	/*Le type de la Personne
	*/   
    private String rtype ;     
	/*Le matricule de la Personne
	*/ 
	private String matricule ;
	/*Le code igg
	*/ 
	private String igg;
	
	/*La date de situation
	*/ 	
	private String datsitu ;      
	/*La date de départ
	*/ 			   
	private String datdep ;  
	/*Le code DPG
	*/ 			   
	private String codsg ; 

	/*Le pole ( present dans la liste des doublon )
	*/ 			   
	private String pole ; 

	/*Le code societe
	*/ 			   
	private String	soccode ;
	private String lib_soccode;
	private String lib_siren;
	/*Le code poste
	*/
	private String	rmcomp ;
	
	/*Le code domaine de la Personne
	 */ 
    private String code_domaine;
    
	/*La prestation de la Personne
	*/ 
	private String prestation;
	/*La disponibilité
	*/ 			   
	private String dispo ;      
	/*Le code chef de projet
	*/ 			   
	private String cpident ; 
	/*L'ident forfait (slot)
	*/ 			   
	private String fident ;  
	/*Le cout de la Personne
	*/ 			   
	private String cout; 
	/*L'ancienne date de situ
	*/ 		
	
	/**
	 * Niveau de la personne. Pour les SG seulement et pour 
	 * le menu administrateur.
	 */
	private String niveau;
		   
	private String oldatsitu ;

	/*Le code de l'immeuble
	*/ 
	private String icodimm;
	/*Le nom du bâtiment
	*/ 			   
	private String batiment ;      
	/*L'étage
	*/ 			   
	private String etage ;  
	/*Le bureau
	*/ 			   
	private String bureau; 
	/*Le numéro de téléphone
	*/ 
	private String rtel;
	/*Cas d'un homonyme
	*/ 			   
	private String homonyme; 
	/*Le flaglock
	*/
	private int flaglock ;
	/*L'identifiant de l'homonyme
	*/
	private String newident ;
  
	/*Le matricule de l'homonyme
	*/ 
	private String newmatricule ;
	/*La date de situation de l'homonyme
	*/ 	
	private String newcodsg ;
	
	private String zone ;
	
	private String coutHTR ;
		
	private String count;
	
	/*YNI
	 * Le confirm permet de retourner le resultat du test sur le doublon
	*/ 	
	private String confirm ;

		
	 /*KeyList0: sert pour la création de la liste des situations d'une personne
	  * cette clé represente l'identifiant de la ressource
	*/   
	protected String keyList0 ;	
	
	
	private String modeContractuelInd;		

	 /*mciCalcule: sert pour indiquer dans le formulaire que le mci a ete calcule
	  * 
	*/
	private String mciCalcule;

	/*mciObligatoire: sert pour indiquer dans le formulaire que le mci est obligatoire pour le dpg
	  * 
	*/
	private String mciObligatoire;

	/*mciAlert: sert pour indiquer dans le formulaire que le mci a ete calcule si changement uniquement
	  * 
	*/
	private String mciAlert;
	
	private String lib_mci;
	
	private String id_personne_col;
	
	private String etape;
	
	private String isClone;
	
	/**
	 * Constructor for ClientForm.
	 */
	public PersonneForm() {
		super();
	}
	
	
   public PersonneForm(String ident, String rnom, String rprenom, String matricule, String igg, String pole) {
		super();
		this.ident = ident;
		this.rnom = rnom;
		this.rprenom = rprenom;
		this.matricule = matricule;
		this.igg = igg;
		this.pole = pole;
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
	

	public String getMciAlert() {
	return mciAlert;
}

public void setMciAlert(String mciAlert) {
	this.mciAlert = mciAlert;
}

	/**
	 * Returns the codsg.
	 * @return String
	 */
	public String getCodsg() {
		return codsg;
	}

	
	public String getPole() {
		return pole;
	}


	public void setPole(String pole) {
		this.pole = pole;
	}


	/**
	 * Returns the cout.
	 * @return String
	 */
	public String getCout() {
		return cout;
	}

	/**
	 * Returns the cpident.
	 * @return String
	 */
	public String getCpident() {
		return cpident;
	}

	/**
	 * Returns the datdep.
	 * @return String
	 */
	public String getDatdep() {
		return datdep;
	}

	/**
	 * Returns the datsitu.
	 * @return String
	 */
	public String getDatsitu() {
		return datsitu;
	}

	/**
	 * Returns the dispo.
	 * @return String
	 */
	public String getDispo() {
		return dispo;
	}


	/**
	 * Returns the flaglock.
	 * @return int
	 */
	public int getFlaglock() {
		return flaglock;
	}

	/**
	 * Returns the ident.
	 * @return String
	 */
	public String getIdent() {
		return ident;
	}

	/**
	 * Returns the matricule.
	 * @return String
	 */
	public String getMatricule() {
		return matricule;
	}
	
	public String getIgg() {
		return igg;
	}

	public void setIgg(String igg) {
		this.igg = igg;
	}

	/**
	 * Returns the oldatsitu.
	 * @return String
	 */
	public String getOldatsitu() {
		return oldatsitu;
	}

	/**
	 * Returns the code_domaine.
	 * @return String
	 */
	public String getCode_domaine() {
		return code_domaine;
	}
     

	/**
	 * Returns the prestation.
	 * @return String
	 */
	public String getPrestation() {
		return prestation;
	}

	/**
	 * Returns the rmcomp.
	 * @return String
	 */
	public String getRmcomp() {
		return rmcomp;
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
     * Returns the rtype.
	 * @return String
	 */
	public String getRtype() {
		return rtype;
	}
   
	/**
	 * Returns the soccode.
	 * @return String
	 */
	public String getSoccode() {
		return soccode;
	}

	/**
	 * Sets the codsg.
	 * @param codsg The codsg to set
	 */
	public void setCodsg(String codsg) {
		this.codsg = codsg;
	}

	/**
	 * Sets the cout.
	 * @param cout The cout to set
	 */
	public void setCout(String cout) {
		this.cout = cout;
	}

	/**
	 * Sets the cpident.
	 * @param cpident The cpident to set
	 */
	public void setCpident(String cpident) {
		this.cpident = cpident;
	}

	/**
	 * Sets the datdep.
	 * @param datdep The datdep to set
	 */
	public void setDatdep(String datdep) {
		this.datdep = datdep;
	}

	/**
	 * Sets the datsitu.
	 * @param datsitu The datsitu to set
	 */
	public void setDatsitu(String datsitu) {
		this.datsitu = datsitu;
	}

	/**
	 * Sets the dispo.
	 * @param dispo The dispo to set
	 */
	public void setDispo(String dispo) {
		this.dispo = dispo;
	}

	/**
	 * Sets the flaglock.
	 * @param flaglock The flaglock to set
	 */
	public void setFlaglock(int flaglock) {
		this.flaglock = flaglock;
	}

	/**
	 * Sets the ident.
	 * @param ident The ident to set
	 */
	public void setIdent(String ident) {
		this.ident = ident;
	}

	/**
	 * Sets the matricule.
	 * @param matricule The matricule to set
	 */
	public void setMatricule(String matricule) {
		this.matricule = matricule;
	}

	/**
	 * Sets the oldatsitu.
	 * @param oldatsitu The oldatsitu to set
	 */
	public void setOldatsitu(String oldatsitu) {
		this.oldatsitu = oldatsitu;
	}
	
	/**
	 * Sets the code_domaine.
	 * @param prestation The code_domaine to set
	 */
	public void setCode_domaine(String code_domaine) {
		this.code_domaine = code_domaine;
	}
	

	/**
	 * Sets the prestation.
	 * @param prestation The prestation to set
	 */
	public void setPrestation(String prestation) {
		this.prestation = prestation;
	}

	/**
	 * Sets the rmcomp.
	 * @param rmcomp The rmcomp to set
	 */
	public void setRmcomp(String rmcomp) {
		this.rmcomp = rmcomp;
	}

	/**
	 * Sets the rnom.
	 * @param rnom The rnom to set
	 */
	public void setRnom(String rnom) {
		this.rnom = rnom;
	}

	/**
	 * Sets the rprenom.
	 * @param rprenom The rprenom to set
	 */
	public void setRprenom(String rprenom) {
		this.rprenom = rprenom;
	}
	
	/**
	 * Sets the rtype.
	 * @param rprenom The rtype to set
	 */
	public void setRtype(String rtype) {
		this.rtype = rtype;
	}
	

	/**
	 * Sets the soccode.
	 * @param soccode The soccode to set
	 */
	public void setSoccode(String soccode) {
		this.soccode = soccode;
	}

	/**
	 * Returns the batiment.
	 * @return String
	 */
	public String getBatiment() {
		return batiment;
	}

	/**
	 * Returns the bureau.
	 * @return String
	 */
	public String getBureau() {
		return bureau;
	}

	/**
	 * Returns the etage.
	 * @return String
	 */
	public String getEtage() {
		return etage;
	}

	/**
	 * Returns the icodimm.
	 * @return String
	 */
	public String getIcodimm() {
		return icodimm;
	}

	/**
	 * Sets the batiment.
	 * @param batiment The batiment to set
	 */
	public void setBatiment(String batiment) {
		this.batiment = batiment;
	}

	/**
	 * Sets the bureau.
	 * @param bureau The bureau to set
	 */
	public void setBureau(String bureau) {
		this.bureau = bureau;
	}

	/**
	 * Sets the etage.
	 * @param etage The etage to set
	 */
	public void setEtage(String etage) {
		this.etage = etage;
	}

	/**
	 * Sets the icodimm.
	 * @param icodimm The icodimm to set
	 */
	public void setIcodimm(String icodimm) {
		this.icodimm = icodimm;
	}

	/**
	 * Returns the rtel.
	 * @return String
	 */
	public String getRtel() {
		return rtel;
	}

	/**
	 * Sets the rtel.
	 * @param rtel The rtel to set
	 */
	public void setRtel(String rtel) {
		this.rtel = rtel;
	}

	/**
	 * Returns the keyList0.
	 * @return String
	 */
	public String getKeyList0() {
		return keyList0;
	}

	/**
	 * Sets the keyList0.
	 * @param keyList0 The keyList0 to set
	 */
	public void setKeyList0(String keyList0) {
		this.keyList0 = keyList0;
	}

	/**
	 * Returns the homonyme.
	 * @return String
	 */
	public String getHomonyme() {
		return homonyme;
	}

	/**
	 * Sets the homonyme.
	 * @param homonyme The homonyme to set
	 */
	public void setHomonyme(String homonyme) {
		this.homonyme = homonyme;
	}	

	/**
	 * @return
	 */
	public String getNiveau() {
		return niveau;
	}

	/**
	 * @param string
	 */
	public void setNiveau(String string) {
		niveau = string;
	}

	/**
	 * Sets the newident.
	 * @param newident The newident to set
	 */
	public void setNewident(String newident) {
		this.newident = newident;
	}
	
	/**
	 * Sets the newmatricule.
	 * @param newmatricule The newmatricule to set
	 */
	public void setNewmatricule(String newmatricule) {
		this.newmatricule = newmatricule;
	}
	
	/**
	 * Sets the newcodsg.
	 * @param newcodsg The newcodsg to set
	 */
	public void setNewcodsg(String newcodsg) {
		this.newcodsg = newcodsg;
	}
	
	/**
	 * Returns the newident.
	 * @return String
	 */
	public String getNewident() {
		return newident;
	}
	

	/**
	 * Returns the newmatricule.
	 * @return String
	 */
	public String getNewmatricule() {
		return newmatricule;
	}
	
	/**
	 * Returns the newcodsg
	 * @return String
	 */
	public String getNewcodsg() {
		return newcodsg;
	}

	public String getFident() {
		return fident;
	}

	public void setFident(String fident) {
		this.fident = fident;
	}

	public String getLib_soccode() {
		return lib_soccode;
	}

	public void setLib_soccode(String lib_soccode) {
		this.lib_soccode = lib_soccode;
	}

	public String getLib_siren() {
		return lib_siren;
	}

	public void setLib_siren(String lib_siren) {
		this.lib_siren = lib_siren;
	}

	public String getZone() {
		return zone;
	}

	public void setZone(String zone) {
		this.zone = zone;
	}

	public String getCoutHTR() {
		return coutHTR;
	}

	public void setCoutHTR(String coutHTR) {
		this.coutHTR = coutHTR;
	}

	/**
	 * @return the confirm
	 */
	public String getConfirm() {
		return confirm;
	}

	/**
	 * @param confirm the confirm to set
	 */
	public void setConfirm(String confirm) {
		this.confirm = confirm;
	}

	public String getCount() {
		return count;
	}

	public void setCount(String count) {
		this.count = count;
	}

	public String getDebnom() {
		return debnom;
	}

	public void setDebnom(String debnom) {
		this.debnom = debnom;
	}

	public String getNomcont() {
		return nomcont;
	}

	public void setNomcont(String nomcont) {
		this.nomcont = nomcont;
	}

	public String getLib_mci() {
		return lib_mci;
	}

	public void setLib_mci(String lib_mci) {
		this.lib_mci = lib_mci;
	}

	public String getId_personne_col() {
		return id_personne_col;
	}

	public void setId_personne_col(String id_personne_col) {
		this.id_personne_col = id_personne_col;
	}

	
	public String getEtape() {
		return etape;
	}


	public void setEtape(String etape) {
		this.etape = etape;
	}


	public String getIsClone() {
		return isClone;
	}


	public void setIsClone(String isClone) {
		this.isClone = isClone;
	}


	public String getModeContractuelInd() {
		return modeContractuelInd;
	}

	public void setModeContractuelInd(String modeContractuelInd) {
		this.modeContractuelInd = modeContractuelInd;
	}

	public String getMciCalcule() {
		return mciCalcule;
	}

	public void setMciCalcule(String mciCalcule) {
		this.mciCalcule = mciCalcule;
	}

	public String getMciObligatoire() {
		return mciObligatoire;
	}

	public void setMciObligatoire(String mciObligatoire) {
		this.mciObligatoire = mciObligatoire;
	}


	
}
