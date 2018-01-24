package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.action.BipAction;
import com.socgen.bip.commun.form.AutomateForm;
import com.socgen.bip.metier.StructLb;
import com.socgen.cap.fwk.ServiceManager;
import com.socgen.cap.fwk.log.Log;

/**
 * @author N.BACCAM - 9/05/2003
 *
 * Formulaire de mise à jour de la structure des lignes BIP
 * chemin : Saisie des réalisés/Paramétrage/Structure LigneBIP
 * pages  : bStructLbSr.jsp
 * pl/sql : 
 */
public class StructLbForm extends AutomateForm{
	/*Le code pid
	*/
	protected String pid;
	/*Le libelle = pid - pnom
	*/
	protected String lib;
	/*Le keyList0
	*/
	public String sDirection;
	/*direction correspondant au pid
	*/
	
	private String typproj;
	
	private String keyList0;
	
	private boolean griserChamps;
	
	/**
	 * Structure de la ligne BIP
	 */
	private StructLb structLb;
	
	/** Eventuel identifiant du bouton radio sélectionné */
	private String btRadioStructure;
		
	public static String prefixeBtRadioStructure = "btRadioStructure_";
	public static String idBtRadioStructureComplete = prefixeBtRadioStructure + "complete";
	public static String prefixeIdEtape = "etape_";
	public static String prefixeIdTache = "tache_";
	public static String prefixeIdSsTache = "ssTache_";
	
	public static int btRadioTypeAucun = -1;
	public static int btRadioTypeStructComplete = 0;
	public static int btRadioTypeEtape = 1;
	public static int btRadioTypeTache = 2;
	public static int btRadioTypeSsTache = 3;
	
	public static String msgErreurAnoParamTypesEtapes = "Anomalie de paramétrage des types d'étapes, veuillez prévenir l'équipe BIP";
	
     /**
	 * Constructor for ClientForm.
	 */
	public StructLbForm() {
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
	 * Returns the pid.
	 * @return String
	 */
	public String getPid() {
		return pid;
	}

	/**
	 * Sets the pid.
	 * @param pid The pid to set
	 */
	public void setPid(String pid) {
		this.pid = pid;
	}

	/**
	 * Returns the lib.
	 * @return String
	 */
	public String getLib() {
		return lib;
	}

	/**
	 * Sets the lib.
	 * @param lib The lib to set
	 */
	public void setLib(String lib) {
		this.lib = lib;
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
	 * @return
	 */
	public String getDirection()
	{
		return sDirection;
	}

	/**
	 * @param string
	 */
	public void setDirection(String string)
	{
		sDirection = string;
	}

	public String getTypproj() {
		return typproj;
	}

	public void setTypproj(String typproj) {
		this.typproj = typproj;
	}

	/**
	 * @return the structLb
	 */
	public StructLb getStructLb() {
		return structLb;
	}

	/**
	 * @param structLb the structLb to set
	 */
	public void setStructLb(StructLb structLb) {
		this.structLb = structLb;
	}
	
	/*public boolean aUneStructure() {
		return structLb != null;
	}*/

	/**
	 * Décorateur de structure de ligne BIP, représentant le code html du tableau de contenu de l’arborescence 
	 */
	public String getDecorateurStructLb() {
		String decorateur = "";
		// TODO Alimenter le décorateur
		return decorateur;
	}

	/**
	 * @return the btRadioStructure
	 */
	public String getBtRadioStructure() {
		return btRadioStructure;
	}

	/**
	 * @param btRadioStructure the btRadioStructure to set
	 */
	public void setBtRadioStructure(String btRadioStructure) {
		this.btRadioStructure = btRadioStructure;
	}	
	
	public int getTypeBtRadioStructure() {
		int typeBtRadio = btRadioTypeAucun;
		
		if (btRadioStructure != null) {
			if (idBtRadioStructureComplete.equals(btRadioStructure)) {
				typeBtRadio = btRadioTypeStructComplete;
			}
			else {
				try {
					// Identification du bouton radio structure coché
					String sousChaineBtRadioStructure = btRadioStructure.substring(StructLbForm.prefixeBtRadioStructure.length());
				
					// S'il s'agit d'une étape
					if (sousChaineBtRadioStructure.startsWith(StructLbForm.prefixeIdEtape)) {
						typeBtRadio = btRadioTypeEtape;
					}
					// S'il s'agit d'une tâche
					else if (sousChaineBtRadioStructure.startsWith(StructLbForm.prefixeIdTache)) {
						typeBtRadio = btRadioTypeTache;
					}
					// S'il s'agit d'une sous-tâche
					else if (sousChaineBtRadioStructure.startsWith(StructLbForm.prefixeIdSsTache)) {
						typeBtRadio = btRadioTypeSsTache;
					}
				} catch (IndexOutOfBoundsException e) {
					// Aucune action ni log
				}
			}
		}
		
		return typeBtRadio;
	}
	
	public String getBtRadioEtapeFromTache() {
		return getBtRadioParent(StructLbForm.prefixeIdTache, StructLbForm.prefixeIdEtape);
	}
	
	public String getBtRadioTacheFromSsTache() {
		return getBtRadioParent(StructLbForm.prefixeIdSsTache, StructLbForm.prefixeIdTache);
	}
	
	public String getBtRadioParent(String prefixeDebutBtRadioCourant, String prefixeFinBtRadioCourant) {
		String btRadioEtape = "";
		
		if (btRadioStructure != null) {
			// index début tâche
			int indexDebutTache = btRadioStructure.indexOf(prefixeDebutBtRadioCourant);
			// index fin tâche = index début étape
			int indexFinTache = btRadioStructure.indexOf(prefixeFinBtRadioCourant);
			
			if (indexDebutTache != -1 && indexFinTache != -1) {
				try {
					btRadioEtape = btRadioStructure.substring(0, indexDebutTache) 
										+ btRadioStructure.substring(indexFinTache);
				} catch (IndexOutOfBoundsException e) {
					BipAction.logBipUser.info("StructLbForm -getBtRadioParent() --> IndexOutOfBoundsException :" + e.getMessage());
				}
			}
		}
		
		return btRadioEtape;
	}
	
	public String getIdEtapeFromBtRadio() {
		return getIdFromBtRadio(StructLbForm.prefixeIdEtape, null);
	}
	
	public String getIdTacheFromBtRadio() {
		return getIdFromBtRadio(StructLbForm.prefixeIdTache, StructLbForm.prefixeIdEtape);
	}
	
	public String getBtIdSsTacheFromBtRadio() {
		return getIdFromBtRadio(StructLbForm.prefixeIdSsTache, StructLbForm.prefixeIdTache);
	}
	
	public String getIdFromBtRadio(String prefixeDebut, String prefixeFin) {
		String id = "";
		
		if (prefixeDebut != null) {
			// Si valeur non nulle
			if (btRadioStructure != null) {
				int indexDebut = btRadioStructure.indexOf(prefixeDebut);
				int indexFinId = -1;
				
				if (prefixeFin != null) {
					indexFinId = btRadioStructure.indexOf(prefixeFin);
				}
				
				if (indexDebut != -1) {
					int indexDebutId = indexDebut + prefixeDebut.length();
					
					try {
						// Récupération de l'identifiant
						if (prefixeFin != null) {
							id = btRadioStructure.substring(indexDebutId, indexFinId);
						}
						else {
							id = btRadioStructure.substring(indexDebutId);
						}
						
					} catch (IndexOutOfBoundsException e) {
						// Auncune action ni log BipAction.logBipUser.info("StructLbForm -getIdFromRadioBt() --> IndexOutOfBoundsException :" + e.getMessage());
					}
				}
			}
		}
		
		return id;
	}
	
	public String getIdDivTache() {
		return StructLbForm.prefixeIdTache +  getIdTacheFromBtRadio()
				+ StructLbForm.prefixeIdEtape +  getIdEtapeFromBtRadio();
	}
	
	protected boolean suppressionOK(String suffixeOK) {
		String msgErreur = getMsgErreur();
		return msgErreur!=null && msgErreur.endsWith(suffixeOK);
	}

	/**
	 * @return the griserChamps
	 */
	public boolean isGriserChamps() {
		return griserChamps;
	}

	/**
	 * @param griserChamps the griserChamps to set
	 */
	public void setGriserChamps(boolean griserChamps) {
		this.griserChamps = griserChamps;
	}
}
