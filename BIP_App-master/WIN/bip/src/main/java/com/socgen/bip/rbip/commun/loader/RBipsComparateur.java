package com.socgen.bip.rbip.commun.loader;

/**
 * @author X116132
 * KRA 16/04/2015 - PPM 60612 : Création d'un comparateur des données d'un fichier .bips
 */

import java.util.Comparator;
import java.util.Date;

/**
 * @author X116132 / KRA
 *	Créer le 07/04/2015
 *
 * Permet le tri d'un java.util.Collection.<br>
 * L'ordre de tri est le suivant : <br>
 * <ol>
 * 	<li>le nom du fichier où a été trouvé l'erreur</lu>
 *  <li>le numéro de ligne dans le fichier</lu>
 * 	<li>le code de l'erreur</lu>
 * </ol>
 */
public class RBipsComparateur implements Comparator<RBipData>
{
	
	/**
	   * @param rBipData Permet de comparer par :
	   	•	Code ligne Bip, ascendant,
		•	Numéro d'étape, ascendant,
		•	Numéro de tâche, ascendant,
		•	Numéro de sous-tâche, ascendant,
		•	Date de début de période, ascendant,
		•	Code ressource, ascendant.
	   */
	 public int compare(RBipData rBipData1, RBipData rBipData2) { 
		 
		 if(rBipData1.getNumLigne()==1) return -1;
		 String ligneBipCode1;
		 String ligneBipCode2;
		 Integer etape_num1;
		 Integer etape_num2;
		 Integer tache_num1;
		 Integer tache_num2;
		 Integer stache_num1;
		 Integer stache_num2;
		 Date dDate_deb_conso1;
		 Date dDate_deb_conso2;
		 Integer ress_bip_code1;
		 Integer ress_bip_code2;	 
	
		try {
			ligneBipCode1 = (String) rBipData1.getData("LIGNEBIPCODE").toString();
		} catch (Exception e) {
			ligneBipCode1 = "";
		}

		try {
			ligneBipCode2 = (String) rBipData2.getData("LIGNEBIPCODE").toString();
		} catch (Exception e) {
			ligneBipCode2 = "";
		}

		try {
			etape_num1 = RBipParser.parseInteger(rBipData1.getData("ETAPENUM")
					.toString());
		} catch (Exception e) {
			etape_num1 = 0;
		}

		try {
			etape_num2 = RBipParser.parseInteger(rBipData2.getData("ETAPENUM")
					.toString());
		} catch (Exception e) {
			etape_num2 = 0;
		}

		try {
			tache_num1 = RBipParser.parseInteger(rBipData1.getData(
					"TACHENUM").toString());
		} catch (Exception e) {
			tache_num1 = 0;
		}

		try {
			tache_num2 = RBipParser.parseInteger(rBipData2.getData(
					"TACHENUM").toString());
		} catch (Exception e) {
			tache_num2 = 0;
		}

		try {
			stache_num1 = RBipParser.parseInteger(rBipData1.getData(
					"STACHENUM").toString());
		} catch (Exception e) {
			stache_num1 = 0;
		}

		try {
			stache_num2 = RBipParser.parseInteger(rBipData2.getData(
					"STACHENUM").toString());
		} catch (Exception e) {
			stache_num2 = 0;
		}

		try {
			dDate_deb_conso1 = (Date) rBipData1.getData("CONSODEBDATE");
		} catch (Exception e) {
			dDate_deb_conso1 = new Date(0);
		}

		try {
			dDate_deb_conso2 = (Date) rBipData2.getData("CONSODEBDATE");
		} catch (Exception e) {
			dDate_deb_conso2 = new Date(0);
		}

		try {
			ress_bip_code1 = Integer.valueOf(rBipData1.getData(
					"RESSBIPCODE").toString());
		} catch (Exception e) {
			ress_bip_code1 = 0;
		}

		try {
			ress_bip_code2 = Integer.valueOf(rBipData2.getData(
					"RESSBIPCODE").toString());
		} catch (Exception e) {
			ress_bip_code2 = 0;
		}

		
		if (ligneBipCode2.compareTo(ligneBipCode1) < 0)  
	        return 1;
		else if (ligneBipCode2.compareTo(ligneBipCode1) > 0)  
	        return -1;
		else if (etape_num2 < etape_num1)  
	        return 1;
		else if (etape_num2 > etape_num1)  
	        return -1;
		else if (tache_num2 < tache_num1)  
	        return 1;
		else if (tache_num2 > tache_num1)  
	        return -1;
		else if (stache_num2 < stache_num1)  
	        return 1;
		else if (stache_num2 > stache_num1)  
	        return -1;
		else if (dDate_deb_conso2.before(dDate_deb_conso1))  
	        return 1;
		else if (dDate_deb_conso2.after(dDate_deb_conso1))  
	        return -1;
		else if (ress_bip_code2 < ress_bip_code1)  
	        return 1;
		else if (ress_bip_code2 > ress_bip_code1)  
	        return -1;
		else
			return 0;

	 }
	 
	 
}