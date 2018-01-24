/*
 * Créé le 22 mars 05
 *
 */
package com.socgen.bip.rbip.commun.loader;

import java.util.PropertyResourceBundle;
import java.util.ResourceBundle;

/**
 *
 * @author X039435
 */
public interface RBipStructureConstantsMSP extends RBipStructureConstants
{
	public static ResourceBundle cfgStructMSP = PropertyResourceBundle.getBundle(cfgRbip.getString("structureMSP"));
	public static final String RECTYPE_MSP_PARAM		="PARAM";
	public static final String RECTYPE_MSP_AUTRE		="*";
	
	public static final String ANNEE = "ANNEE";
	public static final String NUM_PROPRE = "NUM_PROPRE";
}
