/*
 * Créé le 23 août 04
 *
 */
package com.socgen.bip.rbip.intra;

import java.io.IOException;
import java.util.Vector;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

import com.socgen.bip.commun.Tools;
import com.socgen.bip.commun.action.BipAction;
import com.socgen.bip.user.UserBip;

/**
 *
 * @author X039435
 */
public class RBipZipExtractorThread extends Thread
{
	ZipInputStream zipIS;
	UserBip sUserBip;
	String sAction;
	
	public RBipZipExtractorThread(UserBip sUserBip, ZipInputStream zipIS,String sAction)
	{
		this.sUserBip = sUserBip;
		this.zipIS = zipIS;
		this.sAction = sAction;
	}
	
	public void run()
	{
		ZipEntry zip;
		try
		{
			while ( (zip = zipIS.getNextEntry()) != null )
			{
				if (zip.isDirectory())
					continue;
				
				//S.EL PPM 60612 : les fichiers .BIP ne sont pas à controler
				if(zip.getName().toUpperCase().endsWith("BIP") && "controler".equals(sAction))
					continue;
	
				Vector vLignes;
				try
				{
					vLignes = Tools.stream2Vector(zipIS);
				}
				catch (IOException iOE)
				{
					RBipManager.logService.error("Problème dans le flux d'un des fichiers de l'archive", iOE);
					vLignes = null;
				}
				RBipManager.logService.info("RBipZipExtractorThread - Gestion du Fichier : " + zip.getName());
				RBipManager.getInstance().addControle(	sUserBip,
														zip.getName(),
														vLignes,
														sAction);					
			}
			zipIS.close();
		}
		catch (IOException iOE)
		{
			BipAction.getLogBipUser().error("RBipZipExtractor : problème dans le flux zip", iOE);
		}
	}
}
