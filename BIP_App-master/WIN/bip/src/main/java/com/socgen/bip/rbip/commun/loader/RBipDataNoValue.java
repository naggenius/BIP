/*
 * Cr�� le 26 avr. 04
 *
 */
package com.socgen.bip.rbip.commun.loader;

/**
 * @author X039435 / E.GREVREND
 *
 * On ne peut pas stocker la valeur <b>null</b> dans une Hashtable.<br>
 * Cette classe permet de palier cette contrainte.
 * @see com.socgen.bip.rbip.loader.RBipData#put(String,Object)
 * @see com.socgen.bip.rbip.loader.RBipData#getData(String)
 */
public class RBipDataNoValue
{
	/**
	 * Repr�sentation ...
	 */
	public String toString()
	{
		return "NO-VALUE";
	}
}
