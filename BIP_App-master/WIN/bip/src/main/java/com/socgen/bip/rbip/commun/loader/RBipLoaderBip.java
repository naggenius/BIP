/*
 * Créé le 23 avr. 04
 *
 */
package com.socgen.bip.rbip.commun.loader;

import java.lang.reflect.InvocationTargetException;
import java.util.StringTokenizer;
import java.util.Vector;

import com.socgen.bip.commun.Tools;
import com.socgen.bip.db.RBip_Jdbc;
import com.socgen.bip.rbip.commun.RBipConstants;
import com.socgen.bip.rbip.commun.erreur.RBipErreur;
import com.socgen.bip.rbip.commun.erreur.RBipErreurConstants;
import com.socgen.bip.util.ReadConfig;

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
public class RBipLoaderBip extends RBipLoader implements RBipConstants, RBipStructureConstants,  RBipErreurConstants
{
	
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
	public RBipData parseLigne(String sFileName, int iNumLigne, String sLigne) throws Exception
	{
		char rectype = sLigne.charAt(0);
		boolean tailleOk = true;
		RBipErreur rBipE;
		
		//if (vListeType == null)
			init(cfgStruct);
		
		RBipData data = new RBipData(sFileName, iNumLigne, ""+rectype);
		
		if (! vListeType.contains(""+rectype))
		{
			rBipE = new RBipErreur(sFileName, iNumLigne, ERR_BAD_RECTYPE, null);
			vRBipErreur.add(rBipE);
		}
		else
		{
			String fields = cfgStruct.getString(TAG_DATA+rectype+TAG_TYPE_FIELDS);
			int iRectypeSize = new Integer(cfgStruct.getString(TAG_DATA+rectype+TAG_TYPE_SIZE)).intValue();
			
			if ( iRectypeSize !=sLigne.length())
			{
				tailleOk = false;
				rBipE = new RBipErreur(sFileName, iNumLigne, rectype+ERR_BAD_SIZE, null); 			
				vRBipErreur.add(rBipE);			
			}

			StringTokenizer sTk = new StringTokenizer(fields, ",");
			while (sTk.hasMoreElements())
			{
				Object o = null;
				String sField = sTk.nextToken().trim();
				
				//System.out.println("Field = " + sField);
				int posD = new Integer(cfgStruct.getString(TAG_DATA+rectype+"."+sField+TAG_FIELD_POS)).intValue()-1;
				int posF = posD + new Integer(cfgStruct.getString(TAG_DATA+rectype+"."+sField+TAG_FIELD_SIZE)).intValue();
				boolean bNotNull = cfgStruct.getString(TAG_DATA+rectype+"."+sField+TAG_FIELD_NOTNULL).equals("true");
	
				if (!tailleOk)
					o = null;
				else
				{
					String dataType = cfgStruct.getString(TAG_DATA+rectype+"."+sField+TAG_FIELD_TYPE);
					
					String sClassName = cfgStruct.getString(TAG_TYPE+dataType+TAG_TYPE_CLASS);
					String sMethodName = cfgStruct.getString(TAG_TYPE+dataType+TAG_TYPE_METHOD);
					String sVal = sLigne.substring(posD, posF);
				
					//champ non renseigne alors qu'il est obligatoire ...
					if ( (sVal.trim().length() == 0) && (bNotNull) )
					{
						Vector vE =new Vector();
						vE.add(sField);
						rBipE = new RBipErreur(sFileName, iNumLigne, rectype+ERR_NOT_NULL, vE);
						vRBipErreur.add(rBipE);
						o = null;
					}
					else
					{
						try
						{
							o = Tools.getInstanceOf(sClassName, sMethodName, sVal);
						}
						catch (InvocationTargetException e)
						{
							Vector vE =new Vector();
							vE.add(sVal);
							vE.add(cfgStruct.getString(TAG_TYPE+dataType));
							rBipE = new RBipErreur(sFileName, iNumLigne, rectype+ERR_BAD_TYPE, vE);
							vRBipErreur.add(rBipE);
							o = null;

						}
						catch (Exception e)
						{
							//une erreur est survenue, elle n'est pas normale : pb dans fichier de parametrage ?							
							throw e;
						}
					}
				}
				data.put(sField, o);			
			}
		}
		return data;
	}
}
