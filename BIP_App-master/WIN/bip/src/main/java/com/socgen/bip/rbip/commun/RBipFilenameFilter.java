package com.socgen.bip.rbip.commun;

import java.io.File;
import java.io.FilenameFilter;

/**
 * Filtre des fichiers de remontée
 * @author X039435 / E.GREVREND
 */
public class RBipFilenameFilter implements FilenameFilter
{
	public boolean accept(File rep, String sFileName)
	{
		sFileName = sFileName.toUpperCase();
		if (sFileName.endsWith(".BIP")) return true;
		return false;
	}
}