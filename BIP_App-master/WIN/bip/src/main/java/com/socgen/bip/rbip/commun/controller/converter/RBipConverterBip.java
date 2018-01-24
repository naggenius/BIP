/*
 * Créé le 5 avr. 05
 *
 */
package com.socgen.bip.rbip.commun.controller.converter;

import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Vector;

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.rbip.commun.erreur.RBipErreur;
import com.socgen.bip.rbip.commun.erreur.RBipErreurConstants;
import com.socgen.bip.rbip.commun.loader.RBipData;
import com.socgen.bip.rbip.commun.loader.RBipStructureConstantsMSP;

/**
 *
 * @author X039435
 */
public class RBipConverterBip implements BipConstantes, RBipStructureConstantsMSP, RBipErreurConstants
{
	String sPID;
	
	RBipData enTete;
	Hashtable hActivite;
	Vector vAllocations;
	Vector vConsommes;
	Vector vErreur;
	
	int iAnnee;
	
	public RBipConverterBip(String sPID)
	{
		this.sPID = sPID;
		hActivite = new Hashtable();
		vAllocations = new Vector();
		vConsommes = new Vector();
		vErreur = new Vector();
	}
	
	public void setEnTete(RBipData rD)
	{
		enTete = rD;
	}
	
	public void addActivite(RBipData rD, int iAnnee)
	{
		Vector vE;
		String sTypeEtape = (String)rD.getData(TYPE_ETAPE);
		vE = (Vector)hActivite.get(sTypeEtape);
				
		if (iAnnee == this.iAnnee)
		{
			if (vE == null)
			{
				vE = new Vector();
				hActivite.put(sTypeEtape, vE);
			}
			vE.add(rD);
		}
		else if (iAnnee > this.iAnnee)
		{
			vE = new Vector();
			hActivite.put(sTypeEtape, vE);
			vE.add(rD);

		}
	}
	
	public void addAllocation(RBipData rD, int iAnnee)
	{
		//vAllocations.add(rD);
		if (iAnnee == this.iAnnee)
		{
			vAllocations.add(rD);
			//logService.debug("nb alloc : " + vAllocations.size());
		}
		else if (iAnnee > this.iAnnee)
		{
			//logService.debug ("annee de ref : " + iAnnee);
			//this.iAnnee = iAnnee;
			vAllocations.clear();
			vAllocations.add(rD);
		}
	}
	
	public void addConsomme(RBipData rD, int iAnnee)
	{
		if (iAnnee == this.iAnnee)
		{
			vConsommes.add(rD);
			//logService.debug("nb conso : " + vConsommes.size());
		}
		else if (iAnnee > this.iAnnee)
		{
			//logService.debug ("annee de ref : " + iAnnee);
			this.iAnnee = iAnnee;
			vConsommes.clear();
			vConsommes.add(rD);
		}
	}
	
	public RBipData getEnTete() { return enTete; }
	public Vector getAllocation() { return vAllocations; }
	public Vector getConsomme() { return vConsommes; }
	public int getAnnee() { return iAnnee; }
	
	public Vector getActivite()
	{
		Vector vActivite = new Vector();
		//return vActivite;
		
		Enumeration enums = hActivite.keys();
		while (enums.hasMoreElements())
		{
			Vector v = (Vector)hActivite.get(enums.nextElement());
			
			for (int i=0; i<v.size(); i++)
			{
				vActivite.add( (RBipData)v.get(i) );
			}
		}
		
		renumerote(vActivite);
		return vActivite;
	}
	
	public void renumerote(Vector vActivite)
	{
		Hashtable hETS;
		
		RBipData rdActivite;
		RBipData rdAllocation;
		RBipData rdConsomme;
		
		String sLastType = "";
		int iLastNum = 0;
		int iCurNum;
		int iNumE = 0;
		int iNumT = 0;
		int iNumS = 0;
		
		hETS = new Hashtable();	//lien entre numero pbip et ETS, utilise pour la renumerotation des alloc et conso
		 
		//int iE = 0;
		for (int i=0; i< vActivite.size(); i++)
		{			
			rdActivite = (RBipData)vActivite.get(i);
			String sCurTypeEtape = (String)rdActivite.getData(TYPE_ETAPE);
			iCurNum = ((Integer)rdActivite.getData(NUM_PROPRE)).intValue();
		
			if (! sLastType.equals(sCurTypeEtape))
			{
				//logService.debug("changement de type " + sCurTypeEtape + "/" + sLastType);
				iNumE++;
				iNumT = 1;
				iNumS = 1;
				
				iLastNum = iCurNum;
				sLastType = new String(sCurTypeEtape);
			}
			else
			{
				//meme type etape,
				if (iLastNum != iCurNum)
				{
					//logService.debug("+1 sur meme numpropre : " + iCurNum + "/"  +iLastNum);
					iLastNum = iCurNum;
					iNumS++;
					if (iNumS > 99)
					{
						iNumS = 1;
						iNumT++;
						if (iNumT > 97)
						{
							//trop de lignes détail
							Vector vE =new Vector();
							vE.add(sPID);
							vErreur.add(new RBipErreur(sPID, 0, AUTRE_ERR_MAX, vE));
							
							break;
						}
					}
				}
			}
			
			String sETS =	RBipConverterMSP.convertString(""+iNumE, 2, '0', 'd') +
							RBipConverterMSP.convertString(""+iNumT, 2, '0', 'd') +
							RBipConverterMSP.convertString(""+iNumS, 2, '0', 'd');
			//logService.debug(sETS);
			rdActivite.put(ETS, sETS);
			
			if (hETS.get(new Integer(iCurNum)) != null)
			{
				//
				logService.debug("pouet");
			}
			
			hETS.put(new Integer(iCurNum),sETS);

		}
		
		if (vErreur.size() > 0)
		{
			return;
		}
		
		//on renumerote
		for (int i=0; i< vAllocations.size();i++)
		{
			rdAllocation = (RBipData)vAllocations.get(i);
			
			Integer iNum = (Integer)rdAllocation.getData(NUM_PROPRE);
			String sETS = (String)hETS.get(iNum);
			
			if (sETS == null)
			{
				//pb, non ref dans les activites
				logService.error(iNum.toString() + "non ref dans les activites");
			}
			rdAllocation.put(ETS, sETS);
		}
		
		for (int i=0; i< vConsommes.size();i++)
		{
			rdConsomme = (RBipData)vConsommes.get(i);
	
			Integer iNum = (Integer)rdConsomme.getData(NUM_PROPRE);
			String sETS = (String)hETS.get(iNum);
	
			if (sETS == null)
			{
				//pb, non ref dans les activites
				logService.error(iNum.toString() + "non ref dans les activites");
			}
			rdConsomme.put(ETS, sETS);
		}
	}
	
	public String getPID()
	{
		return sPID;
	}
	
	public Vector getErreur() { return vErreur; }
}
