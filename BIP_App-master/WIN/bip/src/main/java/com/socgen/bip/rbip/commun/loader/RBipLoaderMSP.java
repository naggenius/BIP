/*
 * Cr�� le 23 avr. 04
 *
 */
package com.socgen.bip.rbip.commun.loader;

import java.lang.reflect.InvocationTargetException;
import java.util.StringTokenizer;
import java.util.Vector;

import com.socgen.bip.commun.Tools;
import com.socgen.bip.rbip.commun.RBipConstants;
import com.socgen.bip.rbip.commun.erreur.RBipErreur;
import com.socgen.bip.rbip.commun.erreur.RBipErreurConstants;
import com.socgen.cap.fwk.exception.CriticalRuntimeException;

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
public class RBipLoaderMSP extends RBipLoader implements RBipConstants, RBipStructureConstants, RBipStructureConstantsMSP, RBipErreurConstants
{	
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
	public Vector getVectorCSV(String sCSV)
	{
		Vector vCSV = new Vector();
		
		if (sCSV == null) return vCSV;
		
		String sTmp;
		String sVal;
		int iStart;
		int iEnd;
		String sSep = ";";
		
		sTmp = sCSV;
		iStart = 0;
		iEnd = sTmp.indexOf(sSep);
		while (iEnd>= 0)
		{
			sVal = sTmp.substring(iStart, iEnd);
			vCSV.add(sVal);
			
			iStart = iEnd +1;
			iEnd = sTmp.indexOf(sSep, iStart);
		}
		vCSV.add(sTmp.substring(iStart));
		
		
		return vCSV;		
	}
	
	public RBipData parseLigne(String sFileName, int iNumLigne, String sLigne) throws Exception
	{
		StringTokenizer sTk;
		String sRecType;
		Vector vCSV;
		
		vCSV = getVectorCSV(sLigne);
		sRecType = (String)vCSV.get(4);
		boolean tailleOk = true;
		RBipErreur rBipE;
		
		if (vListeType == null)
			init(cfgStructMSP);
		
		RBipData data = new RBipData(sFileName, iNumLigne, sRecType);
		
		boolean bTypeOk = true;
		//logService.debug("liste des types : " + vListeType);
		if (! vListeType.contains(sRecType))
		{
			try
			{				
				cfgStructMSP.getString(TAG_DATA+"*");
				sRecType = "*";
				data.put(RBipData.PARAM_RECTYPE, sRecType);
				//logService.info("type *");
			}
			catch (CriticalRuntimeException cRE)
			{
				rBipE = new RBipErreur(sFileName, iNumLigne, ERR_BAD_RECTYPE, null);
				vRBipErreur.add(rBipE);
				bTypeOk = false;
			}
		}
		
		if (bTypeOk)
		{
			String fields = cfgStructMSP.getString(TAG_DATA+sRecType+TAG_TYPE_FIELDS);
			int iRectypeSize = new Integer(cfgStructMSP.getString(TAG_DATA+sRecType+TAG_TYPE_SIZE)).intValue();
			
			if ( iRectypeSize > vCSV.size())
			{
				tailleOk = false;
				rBipE = new RBipErreur(sFileName, iNumLigne, sRecType+ERR_BAD_SIZE, null); 			
				vRBipErreur.add(rBipE);
							
			}
			
			else
			{
			sTk = new StringTokenizer(fields, ",");
			while (sTk.hasMoreElements())
			{
				Object o = null;
				String sField = sTk.nextToken().trim();
				
				int pos = new Integer(cfgStructMSP.getString(TAG_DATA+sRecType+"."+sField+TAG_FIELD_POS)).intValue()-1;
				boolean bNotNull = cfgStructMSP.getString(TAG_DATA+sRecType+"."+sField+TAG_FIELD_NOTNULL).equals("true");
	
			
				String dataType		= cfgStructMSP.getString(TAG_DATA+sRecType+"."+sField+TAG_FIELD_TYPE);				
				String sClassName	= cfgStructMSP.getString(TAG_TYPE+dataType+TAG_TYPE_CLASS);
				String sMethodName	= cfgStructMSP.getString(TAG_TYPE+dataType+TAG_TYPE_METHOD);
				String sVal = (String)vCSV.get(pos);
				
				//champ non renseigne alors qu'il est obligatoire ...
				if ( (sVal.trim().length() == 0) && (bNotNull) )
				{
					Vector vE =new Vector();
					vE.add(sField);
					//logService.debug(iNumLigne + " "+sField + "-" + sVal +"-");
					rBipE = new RBipErreur(sFileName, iNumLigne, sRecType+ERR_NOT_NULL, vE);
					vRBipErreur.add(rBipE);
					o = null;
				}
				else
				{
					try
					{
						//logService.debug(sClassName+"."+sMethodName + "("+sVal+")");
						o = Tools.getInstanceOf(sClassName, sMethodName, sVal);
					}
					catch (InvocationTargetException e)
					{
						Vector vE =new Vector();
						vE.add(sVal);
						vE.add(cfgStructMSP.getString(TAG_TYPE+dataType));
						rBipE = new RBipErreur(sFileName, iNumLigne, sRecType+ERR_BAD_TYPE, vE);
						vRBipErreur.add(rBipE);
						o = null;				
					}
					catch (Exception e)
					{
						//une erreur est survenue, elle n'est pas normale : pb dans fichier de parametrage ?							
						throw e;
					}
				}
				data.put(sField, o);			
			}
			}
		}
		return data;
	}
}
