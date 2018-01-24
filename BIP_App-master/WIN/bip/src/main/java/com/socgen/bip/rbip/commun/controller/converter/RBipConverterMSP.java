/*
 * Créé le 22 mars 05
 *
 */
package com.socgen.bip.rbip.commun.controller.converter;

import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Vector;

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.Tools;
import com.socgen.bip.rbip.commun.RBipConstants;
import com.socgen.bip.rbip.commun.erreur.RBipErreur;
import com.socgen.bip.rbip.commun.erreur.RBipErreurConstants;
import com.socgen.bip.rbip.commun.loader.RBipData;
import com.socgen.bip.rbip.commun.loader.RBipDataNoValue;
import com.socgen.bip.rbip.commun.loader.RBipStructureConstants;
import com.socgen.bip.rbip.commun.loader.RBipStructureConstantsMSP;


/**
 *
 * @author X039435
 */
public class RBipConverterMSP extends RBipConverter implements	BipConstantes,	//constantes de la bip (logService ...)
																RBipConstants, //constantes de la remontee
																RBipStructureConstantsMSP,	//structure MSP
																RBipErreurConstants	//constantes erreur
{
	public RBipConverterMSP(Vector vData)
	{
		super(vData);
	}
	
	String sPatronEnTete =		"A****42                                                              000000000000***";
	String sPatronActivite =	"G****@@@@@@      **                        000000000000               ***     ";   
	String sPatronAllocation =	"I****@@@@@@******PPPPPPPPCCCCCCCCRRRRRRRR";
	String sPatronConsomme =	"J****@@@@@@******100AAMMJJ00011111CCCCCCCC1";
	
	Hashtable hPID;
	Hashtable hNomFichier;
	Vector vErreurPBIP;	//vecteur des erreurs liées à la structure du fichier => pas specifique à un PID
	Vector vPIDEnErreur;	//liste les PID avec erreur d'erreur classés par PID
	
	
	public Vector convertToBip()
	{
		vConvertedData.clear();
		
		hPID = new Hashtable();
		hNomFichier = new Hashtable();
		vPIDEnErreur = new Vector();
		vErreurPBIP = new Vector();
		Vector vE;
		
		int iLastNumPropre = 0;
		for (int i=0; i< vData.size(); i++)
		{
			RBipData rD = (RBipData)vData.get(i);
			String sPID = (String)rD.getData(RBipStructureConstants.PID);
	
			if (sPID == null)
			{
				continue;
			}
			//logService.debug(sPID);
			RBipConverterBip bip = (RBipConverterBip)hPID.get(sPID);
			
			if (vPIDEnErreur.indexOf(sPID) >= 0)
			{
				continue;
			}
			
			if (RECTYPE_MSP_PARAM.equals(rD.getData(RBipData.PARAM_RECTYPE)) )
			{				
				if ( bip != null)
				{
					//pb : 2 param pour meme PID !
					vE = new Vector();
					vE.add(sPID);
					RBipErreur rBipE = new RBipErreur(bip.getPID(), i+1, PARAM_ERR_UNIQUE, vE);
					logService.debug(rBipE.toString());
					vErreurPBIP.add(rBipE);
					vPIDEnErreur.add(sPID);					
				}
				else
				{
					bip = new RBipConverterBip(sPID);
					
					hPID.put(sPID, bip);
					bip.setEnTete(rD);
				}
			}
			else if (RECTYPE_MSP_AUTRE.equals(rD.getData(RBipData.PARAM_RECTYPE)) )
			{
				if (i == 0)
				{
					// la premiere ligne doit etre de type param
					//on arrete apres
					//vErreur = new Erreur();
					vE = new Vector();
					vE.add(sPID);
					RBipErreur rBipE = new RBipErreur("", i+1, PARAM_ERR_PREM, vE);
					logService.debug(rBipE.toString());
					vErreurPBIP.add(rBipE);
					vPIDEnErreur.add(sPID);
				}
				else if ( bip == null)
				{
					//pb : pas de param !!
					vE = new Vector();
					vE.add(sPID);
					RBipErreur rBipE = new RBipErreur(bip.getPID(), i+1, PARAM_ERR_PREM, vE);
					logService.debug(rBipE.toString());
					vErreurPBIP.add(rBipE);
					vPIDEnErreur.add(sPID);
				}
				else
				{
				
					int iNumPropre = ((Integer)(rD).getData(NUM_PROPRE)).intValue();
					int iAnnee = ((Integer)rD.getData(ANNEE)).intValue();

					if (iNumPropre != iLastNumPropre || iAnnee>bip.getAnnee())
					{
						bip.addActivite(rD,iAnnee);
						if (iAnnee >= bip.getAnnee())
						{
							iLastNumPropre = iNumPropre;
						}						
					}
						
					bip.addAllocation(rD, iAnnee);
					bip.addConsomme(rD, iAnnee);
				}
			}
			else
			{
				//impossible !!! ... ou plutot pas normal
				vE = new Vector();
				vE.add(rD.getData(RBipData.PARAM_RECTYPE));
				RBipErreur rBipE = new RBipErreur(bip.getPID(), i+1, ERR_BAD_RECTYPE, vE);
				logService.debug(rBipE.toString());
				vErreurPBIP.add(rBipE);
				vPIDEnErreur.add(sPID);
			}	
		}
		//convertir les bip en vecteurs de chaines de caracteres
		
		Enumeration e = hPID.keys();
		while (e.hasMoreElements())
		{
			String sPID = (String)e.nextElement();
			int iFichierVide = 0;
			
			if (vPIDEnErreur.indexOf(sPID) >= 0)
			{
				logService.debug("des erreurs sur " + sPID);
				continue;
			}
			
			
			String sTmp;
			RBipConverterBip bip = (RBipConverterBip)hPID.get(sPID);
			
			Vector vCurrent = new Vector();
			
			//revoir pour le vector erreur
			sTmp = convertToEnTete(bip.getEnTete(), sPID);//, vErreurs);
			//logService.debug(sPID + " " + sTmp);
			vCurrent.add(sTmp);
			
			Vector vData;
			vData = bip.getActivite();
			if (bip.getErreur().size() > 0)
			{
				logService.debug("renum => des erreurs sur " + sPID);
				/*Vector vCurErreur = (Vector)hErreur.get(sPID);
				vCurErreur.addAll(bip.getErreur());
				hErreur.put(sPID, vCurErreur);*/
				vErreurPBIP.addAll(bip.getErreur());
				continue;
			}
			
			{
				for (int i=0; i<vData.size(); i++)
				{
					sTmp = convertToActivite((RBipData)vData.get(i), sPID);//, vErreurs);
								
					//logService.debug(sPID + " " + sTmp);
					vCurrent.add(sTmp);
				}
				
				vData = bip.getAllocation();
				
				// Trie les données par ETS Croissant
				Collections.sort(vData);
				
				for (int i=0; i<vData.size(); i++)
				{
					sTmp = convertToAllocation((RBipData)vData.get(i), sPID);//, vErreurs);
					//logService.debug(sPID + " " + sTmp);
					vCurrent.add(sTmp);
				}
							
				vData = bip.getConsomme();

				// Trie les données par ETS Croissant
				Collections.sort(vData);

				for (int i=0; i<vData.size(); i++)
				{
					iFichierVide = 1;

					Vector vTmp = convertToConsomme((RBipData)vData.get(i), sPID, bip.getAnnee());//, vErreurs);
					vCurrent.addAll(vTmp);
				}
				
				// Ne génére le fichier que s'il y a des consommés
				if (iFichierVide == 1) {
					vConvertedData.add(sPID);
					vConvertedData.add(vCurrent);
				}
			}
		}
		
		return vConvertedData; 
	}
	
	protected String convertToEnTete(RBipData rD, String sPID)//, Vector vErreur)
	{
		int iSize = 84;
		
		StringBuffer sbEnTete = new StringBuffer(sPatronEnTete);

		// cle, pole absence
		String sCle;
		String sPole;
		String sPos;
		
		String sVal = (String)rD.getData("INFOS");
		
		sCle = sVal.substring(0,3);
		sPole = sVal.substring(3,6);
		
		int iPos = 1;					
		sbEnTete.replace(iPos,iPos+sPID.length(),sPID);

		

		//logService.debug("Pole : " + sTmp);
		sPos = cfgStruct.getString(TAG_DATA + RECTYPE_ENTETE + "."+ RBipStructureConstants.A_CLE + ".pos");
		iPos = new Integer(sPos).intValue()-1;
		sbEnTete.replace(iPos,iPos+sCle.length(),sCle);

		
		boolean abs = false;
		String sTmp = sVal.substring(6,7);
		if ("O".equals(sTmp))
			abs = true;
	
		// date au carre
		// date_carre (date_creation) = now
		Calendar cal;
		cal = Calendar.getInstance();
		sTmp = ""+cal.get(Calendar.YEAR);
		sTmp = sTmp.substring(2);

		int iTemp = new Integer(sTmp).intValue();
		String sACarre = ""+ iTemp*iTemp;
		sACarre = convertString(sACarre, 4, '0', 'd');

		iTemp = new Integer(cal.get(Calendar.MONTH)).intValue()+1;
		String sMCarre = ""+ iTemp*iTemp;
		sMCarre = convertString(sMCarre, 4, '0', 'd');
					
		iTemp = new Integer(cal.get(Calendar.DAY_OF_MONTH)).intValue();
		String sDCarre = ""+ iTemp*iTemp;
		sDCarre = convertString(sDCarre, 4, '0', 'd');

		sTmp = sDCarre + sMCarre + sACarre;
		/*logService.debug("A : " + sACarre );
		logService.debug("M : " + sMCarre );
		logService.debug("D : " + sDCarre );*/
		sPos = cfgStruct.getString(TAG_DATA + RECTYPE_ENTETE + "."+ RBipStructureConstants.A_DCREATION + ".pos");
		iPos = new Integer(sPos).intValue()-1;
		sbEnTete.replace(iPos,iPos+sTmp.length(),sTmp);
		
		String sNomFichier;
		if (abs)
			sNomFichier = sPID.trim() + sPole + "AB.bip";
		else
			sNomFichier = sPID.trim() + sPole + "00.bip";
		hNomFichier.put(sPID, sNomFichier);
		
		return sbEnTete.toString();

	}
	
	public String getNomFichier(String sPID)
	{
		return (String)hNomFichier.get(sPID);
	}
	
	protected String convertToActivite(RBipData rD, String sPID)//, Vector vErreur)
	{
		int iPos;
		StringBuffer sbActivite = new StringBuffer(sPatronActivite);
		
		String sETS;
		String sTypeEtape;
		String sTypeSSTache;
		String sEtatSSTache;
		String sDateDebRev;
		String sDateFinRev;
		String sNomSSTache;
		String sPourcentage;
		String sDureeTravil;
		String sPos;
		
		Calendar c = Calendar.getInstance();
		Date d;
		
		sTypeSSTache = (String)rD.getData(TYPE_SSTACHE);
		
		d = (Date)rD.getData(DATE_DEB_REV);		
		c.setTime(d);
		sDateDebRev = Tools.getStrDate(c, Tools.FORMAT_AAMMJJ, 0, 0, 0, "");
		
		d = (Date)rD.getData(DATE_FIN_REV);		
		c.setTime(d);
		sDateFinRev = Tools.getStrDate(c, Tools.FORMAT_AAMMJJ, 0, 0, 0, "");
		
		//logService.debug("date deb : " + sDateDebRev + " --- date fin : " + sDateFinRev);
		
		sNomSSTache = (String)rD.getData(NOM_SSTA);
		sNomSSTache = convertString(sNomSSTache, 15, ' ', 'g');
		
		sPourcentage = ""+((Integer)rD.getData(POURCENTAGE)).intValue();
		sPourcentage = convertString(sPourcentage, 3, '0', 'd');
		
		sTypeEtape = (String)rD.getData(TYPE_ETAPE);
		
		// PPR : Limite le type de l'étape à deux caractères
		sTypeEtape = sTypeEtape.substring(0,2);
		
		sPos = cfgStruct.getString(TAG_DATA + RECTYPE_ACTIVITE + "."+ RBipStructureConstants.PID + ".pos");
		iPos = new Integer(sPos).intValue()-1;
		sbActivite.replace(iPos,iPos+sPID.length(),sPID);
		
		sPos = cfgStruct.getString(TAG_DATA + RECTYPE_ACTIVITE + "."+ RBipStructureConstants.TYPE_ETAPE + ".pos");
		iPos = new Integer(sPos).intValue()-1;
		sbActivite.replace(iPos,iPos+sTypeEtape.length(),sTypeEtape);

		sPos = cfgStruct.getString(TAG_DATA + RECTYPE_ACTIVITE + "."+ RBipStructureConstants.TYPE_SSTACHE + ".pos");
		iPos = new Integer(sPos).intValue()-1;
		sbActivite.replace(iPos,iPos+sTypeSSTache.length(),sTypeSSTache);
		
		sPos = cfgStruct.getString(TAG_DATA + RECTYPE_ACTIVITE + "."+ RBipStructureConstants.DATE_DEB_REV + ".pos");
		iPos = new Integer(sPos).intValue()-1;
		sbActivite.replace(iPos,iPos+sDateDebRev.length(),sDateDebRev);
		
		sPos = cfgStruct.getString(TAG_DATA + RECTYPE_ACTIVITE + "."+ RBipStructureConstants.DATE_FIN_REV + ".pos");
		iPos = new Integer(sPos).intValue()-1;
		sbActivite.replace(iPos,iPos+sDateFinRev.length(),sDateFinRev);
		
		sPos = cfgStruct.getString(TAG_DATA + RECTYPE_ACTIVITE + "."+ RBipStructureConstants.NOM_SSTA + ".pos");
		iPos = new Integer(sPos).intValue()-1;
		sbActivite.replace(iPos,iPos+sNomSSTache.length(),sNomSSTache);
		
		sPos = cfgStruct.getString(TAG_DATA + RECTYPE_ACTIVITE + "."+ RBipStructureConstants.POURCENTAGE + ".pos");
		iPos = new Integer(sPos).intValue()-1;
		sbActivite.replace(iPos,iPos+sPourcentage.length(),sPourcentage);
	
		
		//gestion ETS !!!
		sETS = (String)rD.getData(ETS);
		sPos = cfgStruct.getString(TAG_DATA + RECTYPE_ACTIVITE + "."+ RBipStructureConstants.ETS + ".pos");
		iPos = new Integer(sPos).intValue()-1;
		sbActivite.replace(iPos,iPos+sETS.length(),sETS);
		
		return sbActivite.toString();
	}
	
	protected String convertToAllocation(RBipData rD, String sPID)//, Vector vErreur)
	{
		int iPos;
		StringBuffer sbAllocation = new StringBuffer(sPatronAllocation);
		
		Double dCharge;
		String sRess;
		String sETS;
		String sChargeP;
		String sChargeC;
		String sChargeR;
		String sPos;
		
		sRess = (String)rD.getData(TIRES);
		
		dCharge = (Double)rD.getData(CHARGE_PLANIFIEE);
		sChargeP = convertString(""+(int)(dCharge.floatValue()*100), 8, '0', 'd');
		dCharge = (Double)rD.getData(CHARGE_CONSOMMEE);
		sChargeC = convertString(""+(int)(dCharge.floatValue()*100), 8, '0', 'd');
		dCharge = (Double)rD.getData(CHARGE_RAF);
		sChargeR = convertString(""+(int)(dCharge.floatValue()*100), 8, '0', 'd');
		
		sPos = cfgStruct.getString(TAG_DATA + RECTYPE_ALLOCATION + "."+ RBipStructureConstants.PID + ".pos");
		iPos = new Integer(sPos).intValue()-1;
		sbAllocation.replace(iPos,iPos+sPID.length(),sPID);
		
		sPos = cfgStruct.getString(TAG_DATA + RECTYPE_ALLOCATION + "."+ RBipStructureConstants.TIRES + ".pos");
		iPos = new Integer(sPos).intValue()-1;
		sbAllocation.replace(iPos,iPos+sRess.length(),sRess);
		
		sPos = cfgStruct.getString(TAG_DATA + RECTYPE_ALLOCATION + "."+ RBipStructureConstants.CHARGE_PLANIFIEE + ".pos");
		iPos = new Integer(sPos).intValue()-1;
		sbAllocation.replace(iPos,iPos+sChargeP.length(),sChargeP);
		
		sPos = cfgStruct.getString(TAG_DATA + RECTYPE_ALLOCATION + "."+ RBipStructureConstants.CHARGE_CONSOMMEE + ".pos");
		iPos = new Integer(sPos).intValue()-1;
		sbAllocation.replace(iPos,iPos+sChargeC.length(),sChargeC);
		
		sPos = cfgStruct.getString(TAG_DATA + RECTYPE_ALLOCATION + "."+ RBipStructureConstants.CHARGE_RAF + ".pos");
		iPos = new Integer(sPos).intValue()-1;
		sbAllocation.replace(iPos,iPos+sChargeR.length(),sChargeR);
		
		sETS = (String)rD.getData(ETS);
		sPos = cfgStruct.getString(TAG_DATA + RECTYPE_ALLOCATION + "."+ RBipStructureConstants.ETS + ".pos");
		iPos = new Integer(sPos).intValue()-1;
		sbAllocation.replace(iPos,iPos+sETS.length(),sETS);
		
		return sbAllocation.toString();
	}
	
	protected Vector convertToConsomme(RBipData rD, String sPID, int iAnnee)//, Vector vErreur)
	{
		Vector vConsommes = new Vector();
		int iPos;
		StringBuffer sbConsomme = new StringBuffer(sPatronConsomme);
	
		Calendar c = Calendar.getInstance();
		Date d;
		Double dCharge;
		
		String sRess;
		String sETS;
		String sDateDeb;
		String sDuree;
		String sCharge;
		String sTypeC;
		String sPos;
		
		sRess = (String)rD.getData(TIRES);
		
		d = (Date)rD.getData(DATE_DEB_REV);		
		c.setTime(d);
		sDateDeb = Tools.getStrDate(c, Tools.FORMAT_AAMMJJ, 0, 0, 0, "");
			
		dCharge = (Double)rD.getData(CHARGE_CONSOMMEE);
		//logService.debug("charge : " + dCharge);
		sCharge = convertString(""+(int)(dCharge.floatValue()*100), 8, '0', 'd');
		//logService.debug("charge : " + sCharge);
			
		sPos = cfgStruct.getString(TAG_DATA + RECTYPE_CONSOMME + "."+ RBipStructureConstants.PID + ".pos");
		iPos = new Integer(sPos).intValue()-1;
		sbConsomme.replace(iPos,iPos+sPID.length(),sPID);
		sPos = cfgStruct.getString(TAG_DATA + RECTYPE_CONSOMME + "."+ RBipStructureConstants.TIRES + ".pos");
		iPos = new Integer(sPos).intValue()-1;
		sbConsomme.replace(iPos,iPos+sRess.length(),sRess);


		sETS = (String)rD.getData(ETS);
		sPos = cfgStruct.getString(TAG_DATA + RECTYPE_CONSOMME + "."+ RBipStructureConstants.ETS + ".pos");
		iPos = new Integer(sPos).intValue()-1;
		sbConsomme.replace(iPos,iPos+sETS.length(),sETS);		
		//les consos marchent par 2 champs : une date puis un conso
		//on fait un consomme si la date est <> 0 
		String sLabelDebPeriode = "DEB_PERIODE_CONSO_";
		String sLabelConso = "CONSO_";
		
		for (int i=1; i<=12; i++)
		{
			String sCurLabelDeb = sLabelDebPeriode+i;
			String sCurLabelConso = sLabelConso+i;
			
			if ((rD.getData(sCurLabelDeb) != null) && !(rD.getData(sCurLabelDeb) instanceof RBipDataNoValue))
			{
				d = (Date)rD.getData(sCurLabelDeb);
				//logService.debug("champ : "+sCurLabelDeb);
				//logService.debug("calendar : "+c);
				//logService.debug("date : "+d);
				c.setTime(d);
				String sValDateDeb = Tools.getStrDate(c, Tools.FORMAT_AAMMJJ, 0, 0, 0, "");
				dCharge = (Double)rD.getData(sCurLabelConso);
				String sValCharge = convertString(""+(int)(dCharge.floatValue()*100), 8, '0', 'd');
				
				//logService.debug(sValDateDeb + " - " + sValCharge);
				
			
				StringBuffer sbCurConso = new StringBuffer(sbConsomme.toString());
				 
				sPos = cfgStruct.getString(TAG_DATA + RECTYPE_CONSOMME + "."+ RBipStructureConstants.DATE_DEB + ".pos");
				iPos = new Integer(sPos).intValue()-1;
				sbCurConso.replace(iPos,iPos+sValDateDeb.length(),sValDateDeb);
				
				
				sPos = cfgStruct.getString(TAG_DATA + RECTYPE_CONSOMME + "."+ RBipStructureConstants.CHARGE_CONSOMMEE + ".pos");
				iPos = new Integer(sPos).intValue()-1;
				sbCurConso.replace(iPos,iPos+sValCharge.length(),sValCharge);
				
				vConsommes.add(sbCurConso.toString());
			}
		}

	
		//return sbConsomme.toString();
		return vConsommes;
	}
	
	static String convertString(String sVal, int longueur, char cFiller, char cCote)
	{
		if ( (cCote == 'd') || (cCote == 'D'))
		{
			while (sVal.length() < longueur)
				sVal = cFiller + sVal;			
		}
		else
		{
			while (sVal.length() < longueur)
				sVal = sVal + cFiller;
		}
		return sVal;
	}
	
	/*public Vector getErreurPID(String sPID)
	{
		return (Vector)hErreur.get(sPID);
	}*/
	public Vector getErreurPBIP()
	{
		return vErreurPBIP;
	}
}
