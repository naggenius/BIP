
package com.socgen.bip.form;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.Tools;
import com.socgen.bip.commun.form.AutomateForm;
import com.socgen.bip.commun.parametre.ParametreProc;

/**
 * @author MMC - 01/07/2003
 *
 * Formulaire pour creation ou modification d'une ligne bip
 * pages : bLignebipAd.jsp, mLignebipAd.jsp
 */
public class LigneBipForm extends AutomateForm{
	
	private String createFromTitle;
	
	private String ligneaxemetier1;
	
	private String ligneaxemetier2;
	
	private String pnom ;
	
    private String pid ;
	
	private String typproj ;
	
	private String libtyp;
	
	private String astatut ;
	
	private String	pcle;
	
	private String topfer ;
	
    private String toptri ;
	
	private String adatestatut ;
	
	private String pdatdebpre ;
	
	private String	arctype;
	
	private String libtyp2;
	
	private String codpspe ;
	
	private String pobjet ;
	
	private String	liste_objet;
	
	private String pzone ;
	
   	private String icpi ;
	
	private String airt ;
	
	private String dpcode ;
	
	private String	codsg;
	
	private String pcpi ;
	
    private String clicode ;
	/**Le libellé du code client
	*/
	
	private String clilib;
	
	
	private String codbr;
	/**
	 * Code Branche (sera récupéré d'aprés le code direction client)
	 */
	
	private String sous_typo;
	
	private String codcamo ;
	/**Le libellé du code CA MO
	*/
	private String libCodCAMO;
	
	private String libSoustype;
	
	private String pnmouvra ;
	
	private String	metier;
	
	private String libstatut;

	private String clicode_oper;
	/**Le libellé du code client opérationnel
	*/
	private String clilib_oper;
	/**Le flaglock
	*/
	private int flaglock;
	
	private String duplic ; 
			/* Le paramètre dupliquer/créer */
			
	// code de la table de répartition
	private String codrep;
	private String libCodrep;
	
	//statut du projet et du dossier projet
	private String actif;
	private String statut;

	/** Liste des CA préconisés
	*/
	private String listecapreconise;	
	
	
	/**
	 * Réalisé sur les années antérieures à l'année en cours
	 */
	private String realiseanterieur ;
	
	
	/**
	 * Arbitré sur l'année en cours 
	 */
	private String arbitreactuel ;
	
	/**
	 * Fiche 656
	 */
	private boolean realiseAnterieurNotNullDiffZero ; 
	
	/**
	 * Fiche 656
	 */
	private boolean arbitreActuelNotNullDiffZero ;
	
	/**
	 * Fiche 656
	 *  
	 * Messages de blocage Me
	 * 
	 */	
	private String messageMeBlocage;
	
	/**
	 * fiche 655 
	 * 
	 * Messages alerte Admin
	 */
	private String messageAdminBlocage;
	
	 
		 

	private String codeAppliAvantModif ; 
	
	private String codeDPAvantModif ;
	
	private String codePrjAvantModif;
	
	private String codeMetierAvantModif ;
	
	/**
	 * top affichant le message indiquant que le libelle du ca _payeur est different de celui de la direction et de la branche
	 *  du client mo 
	 */
	private String affichemessage;
	private String libdir;
	private String libbr;
	private String lib_ca_payeur;
		
	private boolean alertedbs;
	
	//PPM HMI 63824
	
	private boolean update_controle;
	
	// FIN PPM 63824
	/**
	 * PPM 59288 : liste des directions liées au paramètres DBS
	 */
	private ArrayList<String> listeDirDbs = new ArrayList<String>();
	
	/**
	 * PPM 61695 : vérification si une direction est liée au paramètre OBLIGATION-DP-IMMO (reçoit TRUE), sinon (reçoit FALSE).
	 */
	private ArrayList<String> listeDirImmo = new ArrayList<String>();
	
	/**
	 * PPM 64240 : Ajout du DPCOPI
	 */
	private String dpcopi;
	private boolean afficherDpcopi;
	

	/**
	 * Constructor 
	 */
	public LigneBipForm() {
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
    

  
    



public String getCreateFromTitle() {
	return createFromTitle;
}

public void setCreateFromTitle(String createFromTitle) {
	this.createFromTitle = createFromTitle;
}

public String getLigneaxemetier1() {
	return ligneaxemetier1;
}

public void setLigneaxemetier1(String ligneaxemetier1) {
	this.ligneaxemetier1 = ligneaxemetier1;
}

public String getLigneaxemetier2() {
	return ligneaxemetier2;
}

public void setLigneaxemetier2(String ligneaxemetier2) {
	this.ligneaxemetier2 = ligneaxemetier2;
}

	/**
	 * Returns the adatestatut.
	 * @return String
	 */
	public String getAdatestatut() {
		return adatestatut;
	}

	/**
	 * Returns the airt.
	 * @return String
	 */
	public String getAirt() {
		return airt;
	}

	/**
	 * Returns the arctype.
	 * @return String
	 */
	public String getArctype() {
		return arctype;
	}

	/**
	 * Returns the astatut.
	 * @return String
	 */
	public String getAstatut() {
		return astatut;
	}

	/**
	 * Returns the clicode.
	 * @return String
	 */
	public String getClicode() {
		return clicode;
	}

	/**
	 * Returns the codcamo.
	 * @return String
	 */
	public String getCodcamo() {
		return codcamo;
	}

	/**
	 * Returns the codpspe.
	 * @return String
	 */
	public String getCodpspe() {
		return codpspe;
	}

	/**
	 * Returns the codsg.
	 * @return String
	 */
	public String getCodsg() {
		return codsg;
	}

	/**
	 * Returns the dpcode.
	 * @return String
	 */
	public String getDpcode() {
		return dpcode;
	}

	/**
	 * Returns the flaglock.
	 * @return int
	 */
	public int getFlaglock() {
		return flaglock;
	}

	/**
	 * Returns the icpi.
	 * @return String
	 */
	public String getIcpi() {
		return icpi;
	}

	/**
	 * Returns the libstatut.
	 * @return String
	 */
	public String getLibstatut() {
		return libstatut;
	}

	/**
	 * Returns the libtyp.
	 * @return String
	 */
	public String getLibtyp() {
		return libtyp;
	}

	/**
	 * Returns the liste_objet.
	 * @return String
	 */
	public String getListe_objet() {
		return liste_objet;
	}

	/**
	 * Returns the metier.
	 * @return String
	 */
	public String getMetier() {
		return metier;
	}

	/**
	 * Returns the pcle.
	 * @return String
	 */
	public String getPcle() {
		return pcle;
	}

	/**
	 * Returns the pcpi.
	 * @return String
	 */
	public String getPcpi() {
		return pcpi;
	}

	/**
	 * Returns the pdatdebpre.
	 * @return String
	 */
	public String getPdatdebpre() {
		return pdatdebpre;
	}

	/**
	 * Returns the pid.
	 * @return String
	 */
	public String getPid() {
		return pid;
	}

	/**
	 * Returns the pnmouvra.
	 * @return String
	 */
	public String getPnmouvra() {
		return pnmouvra;
	}

	/**
	 * Returns the pnom.
	 * @return String
	 */
	public String getPnom() {
		return pnom;
	}

	/**
	 * Returns the pobjet.
	 * @return String
	 */
	public String getPobjet() {
		return pobjet;
	}

	/**
	 * Returns the pzone.
	 * @return String
	 */
	public String getPzone() {
		return pzone;
	}

	/**
	 * Returns the topfer.
	 * @return String
	 */
	public String getTopfer() {
		return topfer;
	}

	/**
	 * Returns the toptri.
	 * @return String
	 */
	public String getToptri() {
		return toptri;
	}

	/**
	 * Returns the typproj.
	 * @return String
	 */
	public String getTypproj() {
		return typproj;
	}
	
	/**
	 * Returns the duplic.
	 * @return String
	 */
	public String getDuplic() {
		return duplic;
	}

	/**
	 * Sets the adatestatut.
	 * @param adatestatut The adatestatut to set
	 */
	public void setAdatestatut(String adatestatut) {
		this.adatestatut = adatestatut;
	}

	/**
	 * Sets the airt.
	 * @param airt The airt to set
	 */
	public void setAirt(String airt) {
		this.airt = airt;
	}

	/**
	 * Sets the arctype.
	 * @param arctype The arctype to set
	 */
	public void setArctype(String arctype) {
		this.arctype = arctype;
	}

	/**
	 * Sets the astatut.
	 * @param astatut The astatut to set
	 */
	public void setAstatut(String astatut) {
		this.astatut = astatut;
	}

	/**
	 * Sets the clicode.
	 * @param clicode The clicode to set
	 */
	public void setClicode(String clicode) {
		this.clicode = clicode;
	}

	/**
	 * Sets the codcamo.
	 * @param codcamo The codcamo to set
	 */
	public void setCodcamo(String codcamo) {
		this.codcamo = codcamo;
	}

	/**
	 * Sets the codpspe.
	 * @param codpspe The codpspe to set
	 */
	public void setCodpspe(String codpspe) {
		this.codpspe = codpspe;
	}

	/**
	 * Sets the codsg.
	 * @param codsg The codsg to set
	 */
	public void setCodsg(String codsg) {
		this.codsg = codsg;
	}

	/**
	 * Sets the dpcode.
	 * @param dpcode The dpcode to set
	 */
	public void setDpcode(String dpcode) {
		this.dpcode = dpcode;
	}

	/**
	 * Sets the flaglock.
	 * @param flaglock The flaglock to set
	 */
	public void setFlaglock(int flaglock) {
		this.flaglock = flaglock;
	}

	/**
	 * Sets the icpi.
	 * @param icpi The icpi to set
	 */
	public void setIcpi(String icpi) {
		this.icpi = icpi;
	}

	/**
	 * Sets the libstatut.
	 * @param libstatut The libstatut to set
	 */
	public void setLibstatut(String libstatut) {
		this.libstatut = libstatut;
	}

	/**
	 * Sets the libtyp.
	 * @param libtyp The libtyp to set
	 */
	public void setLibtyp(String libtyp) {
		this.libtyp = libtyp;
	}

	/**
	 * Sets the liste_objet.
	 * @param liste_objet The liste_objet to set
	 */
	public void setListe_objet(String liste_objet) {
		this.liste_objet = liste_objet;
	}

	/**
	 * Sets the metier.
	 * @param metier The metier to set
	 */
	public void setMetier(String metier) {
		this.metier = metier;
	}

	/**
	 * Sets the pcle.
	 * @param pcle The pcle to set
	 */
	public void setPcle(String pcle) {
		this.pcle = pcle;
	}

	/**
	 * Sets the pcpi.
	 * @param pcpi The pcpi to set
	 */
	public void setPcpi(String pcpi) {
		this.pcpi = pcpi;
	}

	/**
	 * Sets the pdatdebpre.
	 * @param pdatdebpre The pdatdebpre to set
	 */
	public void setPdatdebpre(String pdatdebpre) {
		this.pdatdebpre = pdatdebpre;
	}

	/**
	 * Sets the pid.
	 * @param pid The pid to set
	 */
	public void setPid(String pid) {
		this.pid = pid;
	}

	/**
	 * Sets the pnmouvra.
	 * @param pnmouvra The pnmouvra to set
	 */
	public void setPnmouvra(String pnmouvra) {
		this.pnmouvra = pnmouvra;
	}

	/**
	 * Sets the pnom.
	 * @param pnom The pnom to set
	 */
	public void setPnom(String pnom) {
		this.pnom = pnom;
	}

	/**
	 * Sets the pobjet.
	 * @param pobjet The pobjet to set
	 */
	public void setPobjet(String pobjet) {
		this.pobjet = pobjet;
	}

	/**
	 * Sets the pzone.
	 * @param pzone The pzone to set
	 */
	public void setPzone(String pzone) {
		this.pzone = pzone;
	}

	/**
	 * Sets the topfer.
	 * @param topfer The topfer to set
	 */
	public void setTopfer(String topfer) {
		this.topfer = topfer;
	}

	/**
	 * Sets the toptri.
	 * @param toptri The toptri to set
	 */
	public void setToptri(String toptri) {
		this.toptri = toptri;
	}

	/**
	 * Sets the typproj.
	 * @param typproj The typproj to set
	 */
	public void setTypproj(String typproj) {
		this.typproj = typproj;
	}

	/**
	 * Returns the libtyp2.
	 * @return String
	 */
	public String getLibtyp2() {
		return libtyp2;
	}

	/**
	 * Sets the libtyp2.
	 * @param libtyp2 The libtyp2 to set
	 */
	public void setLibtyp2(String libtyp2) {
		this.libtyp2 = libtyp2;
	}
	
	/**
	 * Sets the clilib.
	 * @param clilib The clilib to set
	 */
	public void setClilib(String clilib) {
		this.clilib = clilib;
	}
	
	/**
	 * Returns the clilib.
	 * @return String
	 */
	public String getClilib() {
		return clilib;
	}
	/**
	 * Retourne le code client opérationnel
	 * @return clicode_oper
	 */
	public String getClicode_oper() {
		return clicode_oper;
	}

	/**
	 * @param string the clicode_oper to set
	 */
	public void setClicode_oper(String string) {
		clicode_oper = string;
	}
	
	/**
	 * @return
	 */
	public String getClilib_oper() {
		return clilib_oper;
	}

	/**
	 * @param string
	 */
	public void setClilib_oper(String string) {
		clilib_oper = string;
	}
	/**
	 * @return
	 */
	public String getLibCodCAMO() {
		return libCodCAMO;
	}

	/**
	 * @param string
	 */
	public void setLibCodCAMO(String string) {
		libCodCAMO = string;
	}

	/**
	 * @return
	 */
	public String getCodbr() {
		return codbr;
	}

	/**
	 * @param string
	 */
	public void setCodbr(String string) {
		codbr = string;
	}

	/**
	 * @return
	 */
	public String getSous_typo() {
		return sous_typo;
	}

	/**
	 * @param string
	 */
	public void setSous_typo(String string) {
		sous_typo = string;
	}

	

	/**
	 * @return
	 */
	public String getLibSoustype() {
		return libSoustype;
	}

	/**
	 * @param string
	 */
	public void setLibSoustype(String string) {
		libSoustype = string;
	}
	
	/**
	 * Sets the duplic.
	 * @param duplic The duplic to set
	 */
	public void setDuplic(String duplic) {
		this.duplic = duplic;
	}

	/**
	 * @return
	 */
	public String getCodrep() {
		return codrep;
	}

	/**
	 * @param string
	 */
	public void setCodrep(String string) {
		codrep = string;
	}
	
	

	/**
	 * @return
	 */
	public String getLibCodrep() {
		return libCodrep;
	}

	/**
	 * @param string
	 */
	public void setLibCodrep(String string) {
		libCodrep = string;
	}
	/**
	 * @return
	 */
	public String getActif() {
		return actif;
	}

	/**
	 * @param string
	 */
	public void setActif(String string) {
		actif = string;
	}
	
	/**
	 * @return
	 */
	public String getStatut() {
		return statut;
	}

	/**
	 * @param string
	 */
	public void setStatut(String string) {
		statut = string;
	}
	/**
	 * Returns the listecapreconise.
	 * @return String
	 */
	public String getListecapreconise() {
		return listecapreconise;
	}

	/**
	 * Sets the listecapreconise.
	 * @param listecapreconise The listecapreconise to set
	 */
	public void setListecapreconise(String listecapreconise) {
		this.listecapreconise = listecapreconise;
	}

	
	public String getArbitreactuel() {
		return this.arbitreactuel;
	}

	public void setArbitreactuel(String arbitreactuel) {
		this.arbitreactuel = arbitreactuel;
	}

	public String getRealiseanterieur() {
		return this.realiseanterieur;
	}

	public void setRealiseanterieur(String realiseanterieur) {
		this.realiseanterieur = realiseanterieur;
	}

	public String getMessageAdminBlocage() {
		return messageAdminBlocage;
	}

	public void setMessageAdminBlocage(String messageAdminBlocage) {
		this.messageAdminBlocage = messageAdminBlocage;
	}

	public String getMessageMeBlocage() {
		return this.messageMeBlocage;
	}

	public void setMessageMeBlocage(String messageMeBlocage) {
		this.messageMeBlocage = messageMeBlocage;
	}

	public String getCodeAppliAvantModif() {
		return this.codeAppliAvantModif;
	}

	public void setCodeAppliAvantModif(String codeAppliAvantModif) {
		this.codeAppliAvantModif = codeAppliAvantModif;
	}

	public String getCodeDPAvantModif() {
		return this.codeDPAvantModif;
	}

	public void setCodeDPAvantModif(String codeDPAvantModif) {
		this.codeDPAvantModif = codeDPAvantModif;
	}

	public String getCodeMetierAvantModif() {
		return this.codeMetierAvantModif;
	}

	public void setCodeMetierAvantModif(String codeMetierAvantModif) {
		this.codeMetierAvantModif = codeMetierAvantModif;
	}

	public boolean isArbitreActuelNotNullDiffZero() {
		return arbitreActuelNotNullDiffZero;
	}

	public void setArbitreActuelNotNullDiffZero(boolean arbitreActuelNotNullDiffZero) {
		this.arbitreActuelNotNullDiffZero = arbitreActuelNotNullDiffZero;
	}

	public boolean isRealiseAnterieurNotNullDiffZero() {
		return realiseAnterieurNotNullDiffZero;
	}

	public void setRealiseAnterieurNotNullDiffZero(
			boolean realiseAnterieurNotNullDiffZero) {
		this.realiseAnterieurNotNullDiffZero = realiseAnterieurNotNullDiffZero;
	}

	public String getAffichemessage() {
		return affichemessage;
	}

	public void setAffichemessage(String affichemessage) {
		this.affichemessage = affichemessage;
	}

	public String getLib_ca_payeur() {
		return lib_ca_payeur;
	}

	public void setLib_ca_payeur(String lib_ca_payeur) {
		this.lib_ca_payeur = lib_ca_payeur;
	}

	public String getLibbr() {
		return libbr;
	}

	public void setLibbr(String libbr) {
		this.libbr = libbr;
	}

	public String getLibdir() {
		return libdir;
	}

	public void setLibdir(String libdir) {
		this.libdir = libdir;
	}

	public boolean isAlertedbs() {
		return alertedbs;
	}

	public void setAlertedbs(boolean alertedbs) {
		this.alertedbs = alertedbs;
	}

	/**
	 * PPM 59288
	 * @return the listeDirDbs
	 */
	public ArrayList<String> getListeDirDbs() {
		return listeDirDbs;
	}

	/**
	 * PPM 59288
	 * @param listeDirDbs the listeDirDbs to set
	 */
	public void setListeDirDbs(ArrayList<String> listeDirDbs) {
		this.listeDirDbs = listeDirDbs;
	}
	/**
	 * PPM 61695
	 * @return the listeDirImmo
	 */
	public ArrayList<String> getListeDirImmo() {
		return listeDirImmo;
	}

	/**
	 * PPM 61695
	 * @param listeDirImmo the listeDirImmo to set
	 */
	public void setListeDirImmo(ArrayList<String> listeDirImmo) {
		this.listeDirImmo = listeDirImmo;
	}

	// FAD PPM 64240 : Ajout du DPCOPI
	public String getDpcopi() {
		return dpcopi;
	}

	// FAD PPM 64240 : Ajout du DPCOPI
	public void setDpcopi(String dpcopi) {
		this.dpcopi = dpcopi;
	}

	// FAD PPM 64240 : Ajout du DPCOPI
	public boolean isAfficherDpcopi() {
		return afficherDpcopi;
	}

	// FAD PPM 64240 : Ajout du DPCOPI
	public void setAfficherDpcopi(boolean afficherDpcopi) {
		this.afficherDpcopi = afficherDpcopi;
	}
		public boolean isUpdate_controle() {
		return update_controle;
	}

	public void setUpdate_controle(boolean update_controle) {
		this.update_controle = update_controle;
	}
	/* Start of BIP - 201 User story implementation */
	
	public String getCodePrjAvantModif() {
		return codePrjAvantModif;
	}

	public void setCodePrjAvantModif(String codePrjAvantModif) {
		this.codePrjAvantModif = codePrjAvantModif;
	} 
	
	/* End of BIP - 201 User story implementation */
	
 
}
