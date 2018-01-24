/*
 * Créé le 22 mars 05
 *
 */
package com.socgen.bip.rbip.commun.controller.converter;

import java.util.Vector;


/**
 *
 * @author X039435
 */
public class RBipConverter
{
	//Vector vErreurs;
	Vector vData;
	Vector vConvertedData;
	
	public RBipConverter(Vector vData)
	{
		//vErreurs = new Vector();
		vConvertedData = new Vector();
		vConvertedData.add(vData);
		this.vData = vData;
	}
	
	public Vector convertToBip()
	{
		return vConvertedData; 
	}
}
