/*
 * Créé le 23 avr. 04
 *
 */
package com.socgen.bip.rbip.commun.loader;

//import java.lang.reflect.InvocationTargetException;
import java.util.ResourceBundle;
import java.util.StringTokenizer;
import java.util.Vector;

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.Tools;
import com.socgen.bip.db.RBip_Jdbc;
import com.socgen.bip.rbip.commun.RBipConstants;
import com.socgen.bip.rbip.commun.erreur.RBipErreur;
import com.socgen.bip.rbip.commun.erreur.RBipErreurConstants;
/**
 * @author X039435 / E.GREVREND
 * 
 * Moteur permettant de générer une liste (Vector) de RBipData en faisant le lien entre le fichier des ressources de structure et<br>
 * le fichier de données (passé sous forme d'un Vector contenant la liste des lignes).<br>
 * Le fichier de ressource utilisé est celui qui est définit par le Tag 'structure' dans le fichier de ressource 'bip_remontee.properties'.<br>
 * 
 * Le fichier de ressource définit :<br>
 * <ul>
 * <li>le numéro de version du fichier de données auquel il correspond</li>
 * <li>Un ensemble de Types de données, ces types seront associés aux champs des enregistrements. Chaque type possède un libellé (utilisé dans les messages d'erreur), une classe et une méthode. Si la méthode n'est pas renseignée, le constructeur de la classe qui est utilisé. Sinon c'est la méthode qui l'est. Dans les 2 cas, la fonction utilisée retourne un Object (pas de type primitif) et a 1 paramètre de type String. Cette méthode permet de transformer une valeur de type chaîne (extraite du fichier) en un type recherche (Date ...) mais permet également de détecter les erreurs (par exemple une PID est construit d'une certaine manière). En cas d'erreur de parse, une Exception de type InvocationTargetException est levée et gérées dans RBipLoader.</li>
 * <li>La liste des rectypes, chaque rectype possède une une taille (en caractères), un libellé et une liste de champs. Chaque champ possède position (sur la ligne, en caractères), un taille (en caractères), un type (un des types de données définit) et un flag permettant de savoir s'il peut ne pas être définit (que des caractères espaces)</li>
 * </ul>
 */
public abstract class RBipLoader implements RBipConstants, RBipStructureConstants,  RBipErreurConstants, BipConstantes
{
	/**
	 * La liste des types autorisés, initialisée par init()
	 */
	protected Vector vListeType = null;
	
	/**
	 * La liste des RBipData générées
	 */
	protected Vector vRBipData;
	
	/**
	 * La liste des erreurs apparues lors de la génération des RBipData
	 */
	protected Vector vRBipErreur;
	
	/**
	 * La liste des warning apparus lors de la génération des RBipData
	 */
	protected Vector vRBipWarning;
	
	private ResourceBundle cfg;
	
	
	public ResourceBundle getCfg() {
		return cfg;
	}

	public void setCfg(ResourceBundle cfg) {
		this.cfg = cfg;
	}

	/**
	 * Permet de construire la liste des types d'enregistrements autorisés.<br>
	 * Les valeurs sont extraites du fichier de ressources de structure.<br>
	 * Est appelé par load(String,Vector) si la liste (vListeType) n'est pas encore définie.
	 */
	protected void init(ResourceBundle cfg)
	{
		vListeType = new Vector();
		
		this.cfg = cfg;
		
		String sListe = cfg.getString(TAG_RECTYPES);
		
		StringTokenizer sTk = new StringTokenizer(sListe, ",");
		while (sTk.hasMoreElements())
		{
			vListeType.add(sTk.nextToken().trim());
		}
		//logService.debug("INIT : " + vListeType);
	}
	
	/**
	 * @return La liste des erreurs détectées lors du chargement du fichier de données
	 */
	public Vector getErreurs() { return vRBipErreur; }
	
	/**
	 * @return La liste des warning détectés lors du chargement du fichier de données
	 */
	public Vector getWarning() { return vRBipWarning; }
	
	/**
	 * 
	 * @return la liste des RBipData générés lors du chargement du fichier de données
	 */
	public Vector getRBipData() { return vRBipData; }
	
	/***
	 * Parcours du Vector de données passé en paramètre. Pour chaque valeur, on contruit un RBipData que l'ont place dns vRBipData.
	 * @param sFileName le nom du fichier à charger
	 * @param vLigne contenu du fichier à charger, c'est sur cette liste que va reposer le chargement
	 * @throws Exception seulement en cas de soucis majeur (notament problème avec le fichier de ressources)
	 */
	private String sTypeFichier;
	
	public void load(String sFileName, Vector vLigne) throws Exception
	{
		boolean bOk = true;
		vRBipData = new Vector();
		vRBipErreur = new Vector();
		vRBipWarning = new Vector();
		
		if (sFileName.endsWith(sBipExtension) || sFileName.endsWith(sBipExtension.toUpperCase()))
		{
			sTypeFichier = FICHIER_BIP;
			if (! Tools.isRBipFileNameValid(sFileName))
			{
				Vector vE = new Vector();
				vE.add(sFileName);
				vRBipErreur.add(new RBipErreur(sFileName, 0, ERR_BAD_FILENAME, vE));
				bOk = false;
			}
			if ( Tools.isRBipPIDValid(Tools.getPIDFromFileName(sFileName)) == 0 )
			{	// QC 1283 : Erreur - code ligne inexistant
				Vector vE = new Vector();
				vE.add(sFileName);
				vRBipErreur.add(new RBipErreur(sFileName, 0, ERR_BAD_PID, vE)); 
				bOk = false;
			}
		}
		else
		{
			if (sFileName.endsWith(sPBipExtension) || sFileName.endsWith(sPBipExtension.toUpperCase()))
			{
				sTypeFichier = FICHIER_PBIP;
			}
			//PPM 60612 : verifier s'il y a des contrôles à faire au niveau nom de fichier
			else if (sFileName.endsWith(sPBipsExtension) || sFileName.endsWith(sPBipsExtension.toUpperCase()))
			{
				sTypeFichier = FICHIER_BIPS;
			}
			else
			{
				Vector vE = new Vector();
				vE.add(sFileName);
				vRBipErreur.add(new RBipErreur(sFileName, 0, ERR_BAD_FILENAME, vE));
				bOk = false;
			}
		}
		
		if (bOk)
		for (int i =0; i< vLigne.size(); i++)
		{
			if ( ((String)vLigne.get(i)).length() != 0)
			{
				RBipData bD = parseLigne(sFileName, i+1, (String)vLigne.get(i));
				
				//SEL PPM 60612 - QC 1710
				if(bD.isRejetBips()){
					break;
				}
				
				//Si le ligne est rejet ,  alors continuer
				if(bD.getRejetPID()!=null)
				{
				if(bD.getRejetPID().contains((String)bD.getData("LIGNEBIPCODE")))
				{
					continue;
				}
				}
				
				//logService.debug(bD.toString());
				vRBipData.add(bD);

			}
		}
		
	}
	
	/**
	 * Chargement d'un ligne<br>
	 * On va créer un RBipData et lui ajouter la liste des champs/valeurs correspond à son type à partir de la ligne de données
	 * Pour connaître la liste des champs d'un enregistrement :
	 * <ol>
	 * <li>on récupere le RecType de la ligne</li>
	 * <li>on recupère dans le fichier des ressources la liste des champs associés à ce RecType</li>
	 * <li>pour chacun des champs on récupère la chaîne de caractère (sVal) qui lui correspond (extrait de sLigne)</li>
	 * <li>si le champ est obligatoire et que la sVal est vide => une erreur</li>
	 * <li>on convertit sVal dans le type associé au champ (appel à la classe et la méthode essociées au type du champ)</li>
	 * <li> si la conversion échoue => erreur</li> 
	 * <li>on stocke dans RBipData le couple NomChamp/Valeur</li>
	 * </ol>
	 * 
	 * @param sFileName	le nom du fichier d'où vient la ligne de données
	 * @param iNumLigne	le numéro de la ligne dans le fichier
	 * @param sLigne	la ligne qui va être exploitée
	 * @return une instance de RBipData qui représente la ligne
	 * @throws Exception
	 */
	abstract public RBipData parseLigne(String sFileName, int iNumLigne, String sLigne) throws Exception;
	
}
