package com.socgen.bip.rbip.commun;

import java.io.File;
import java.io.FilenameFilter;

/**
 * Filtre des fichiers de remontée
 * @author X039435 / E.GREVREND
 */
public class RBipsFilenameFilter implements FilenameFilter
{
	public boolean accept(File rep, String sFileName)
	{
		sFileName = sFileName.toUpperCase();
		if (sFileName.endsWith(".BIPS")) return true;
		return false;
	}
}