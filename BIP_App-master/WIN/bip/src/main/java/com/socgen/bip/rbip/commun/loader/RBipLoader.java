/*
 * Cr�� le 23 avr. 04
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
 * Moteur permettant de g�n�rer une liste (Vector) de RBipData en faisant le lien entre le fichier des ressources de structure et<br>
 * le fichier de donn�es (pass� sous forme d'un Vector contenant la liste des lignes).<br>
 * Le fichier de ressource utilis� est celui qui est d�finit par le Tag 'structure' dans le fichier de ressource 'bip_remontee.properties'.<br>
 * 
 * Le fichier de ressource d�finit :<br>
 * <ul>
 * <li>le num�ro de version du fichier de donn�es auquel il correspond</li>
 * <li>Un ensemble de Types de donn�es, ces types seront associ�s aux champs des enregistrements. Chaque type poss�de un libell� (utilis� dans les messages d'erreur), une classe et une m�thode. Si la m�thode n'est pas renseign�e, le constructeur de la classe qui est utilis�. Sinon c'est la m�thode qui l'est. Dans les 2 cas, la fonction utilis�e retourne un Object (pas de type primitif) et a 1 param�tre de type String. Cette m�thode permet de transformer une valeur de type cha�ne (extraite du fichier) en un type recherche (Date ...) mais permet �galement de d�tecter les erreurs (par exemple une PID est construit d'une certaine mani�re). En cas d'erreur de parse, une Exception de type InvocationTargetException est lev�e et g�r�es dans RBipLoader.</li>
 * <li>La liste des rectypes, chaque rectype poss�de une une taille (en caract�res), un libell� et une liste de champs. Chaque champ poss�de position (sur la ligne, en caract�res), un taille (en caract�res), un type (un des types de donn�es d�finit) et un flag permettant de savoir s'il peut ne pas �tre d�finit (que des caract�res espaces)</li>
 * </ul>
 */
public abstract class RBipLoader implements RBipConstants, RBipStructureConstants,  RBipErreurConstants, BipConstantes
{
	/**
	 * La liste des types autoris�s, initialis�e par init()
	 */
	protected Vector vListeType = null;
	
	/**
	 * La liste des RBipData g�n�r�es
	 */
	protected Vector vRBipData;
	
	/**
	 * La liste des erreurs apparues lors de la g�n�ration des RBipData
	 */
	protected Vector vRBipErreur;
	
	/**
	 * La liste des warning apparus lors de la g�n�ration des RBipData
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
	 * Permet de construire la liste des types d'enregistrements autoris�s.<br>
	 * Les valeurs sont extraites du fichier de ressources de structure.<br>
	 * Est appel� par load(String,Vector) si la liste (vListeType) n'est pas encore d�finie.
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
	 * @return La liste des erreurs d�tect�es lors du chargement du fichier de donn�es
	 */
	public Vector getErreurs() { return vRBipErreur; }
	
	/**
	 * @return La liste des warning d�tect�s lors du chargement du fichier de donn�es
	 */
	public Vector getWarning() { return vRBipWarning; }
	
	/**
	 * 
	 * @return la liste des RBipData g�n�r�s lors du chargement du fichier de donn�es
	 */
	public Vector getRBipData() { return vRBipData; }
	
	/***
	 * Parcours du Vector de donn�es pass� en param�tre. Pour chaque valeur, on contruit un RBipData que l'ont place dns vRBipData.
	 * @param sFileName le nom du fichier � charger
	 * @param vLigne contenu du fichier � charger, c'est sur cette liste que va reposer le chargement
	 * @throws Exception seulement en cas de soucis majeur (notament probl�me avec le fichier de ressources)
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
			//PPM 60612 : verifier s'il y a des contr�les � faire au niveau nom de fichier
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
	 * On va cr�er un RBipData et lui ajouter la liste des champs/valeurs correspond � son type � partir de la ligne de donn�es
	 * Pour conna�tre la liste des champs d'un enregistrement :
	 * <ol>
	 * <li>on r�cupere le RecType de la ligne</li>
	 * <li>on recup�re dans le fichier des ressources la liste des champs associ�s � ce RecType</li>
	 * <li>pour chacun des champs on r�cup�re la cha�ne de caract�re (sVal) qui lui correspond (extrait de sLigne)</li>
	 * <li>si le champ est obligatoire et que la sVal est vide => une erreur</li>
	 * <li>on convertit sVal dans le type associ� au champ (appel � la classe et la m�thode essoci�es au type du champ)</li>
	 * <li> si la conversion �choue => erreur</li> 
	 * <li>on stocke dans RBipData le couple NomChamp/Valeur</li>
	 * </ol>
	 * 
	 * @param sFileName	le nom du fichier d'o� vient la ligne de donn�es
	 * @param iNumLigne	le num�ro de la ligne dans le fichier
	 * @param sLigne	la ligne qui va �tre exploit�e
	 * @return une instance de RBipData qui repr�sente la ligne
	 * @throws Exception
	 */
	abstract public RBipData parseLigne(String sFileName, int iNumLigne, String sLigne) throws Exception;
	
}
