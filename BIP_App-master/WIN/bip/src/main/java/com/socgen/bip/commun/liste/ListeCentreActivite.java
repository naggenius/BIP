/*
 * Created on 17 nov. 03 
 */
package com.socgen.bip.commun.liste;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Iterator;
import java.util.Vector;

import com.socgen.bip.db.JDBCUpdaterOracle;
import com.socgen.bip.metier.CentreActivite;
import com.socgen.cap.fwk.jdbc.JDBCWrapper;

/**
 * @author S.LALLIER
 *
 * représente la liste des centres d'activités pour l'utilisateur UserBip.
 */
public class ListeCentreActivite extends JDBCWrapper{

	/**
	 * Compare les centres d'activités par ordre croissant.
	 */
	private static ComparatorCA compareCA = new ComparatorCA();
	
	private static JDBCUpdaterOracle updater = null;

	public ListeCentreActivite() {

	}
	
	/**
	 * Retourne la liste de tous les centres d'activités de niveau 0.		
	 * @param codecamo_pere 
	 * @return
	 */
	public static ArrayList recupererCentresActivitesNiveau0(Vector codecamo_pere) {
		ArrayList liste_ca = new ArrayList();		
		if(updater == null){
			updater = new JDBCUpdaterOracle();
		}
		for (Iterator iter = codecamo_pere.iterator(); iter.hasNext();) {
			String cle = (String) iter.next();
			updater.recupererListeNiv0CentreActivite(cle, liste_ca);
		}
		Collections.sort(liste_ca, compareCA);
		return liste_ca;
	}

	/**
	 * Retourne la liste tous niveaux centres activités pere et fils.
	 * @param codecamo_pere liste des codcamo provenant du RTFE.
	 * @return
	 */
	public static ArrayList recupererListeGlobale(Vector codecamo_pere) {
		ArrayList liste_ca = new ArrayList();        
		ArrayList liste = null;		
		if(updater == null){
			updater = new JDBCUpdaterOracle();
		}
		for (Iterator iter = codecamo_pere.iterator(); iter.hasNext();) {
			String cle = (String) iter.next();
			updater.recupererListeGlobaleCentreActivite(cle, liste_ca);			
		}
		Collections.sort(liste_ca, compareCA);		
		return liste_ca;
	}	

		
}

class ComparatorCA implements Comparator {

	//tri par codcamo ascendant.
	public int compare(Object arg0, Object arg1) {
		CentreActivite ca1 = (CentreActivite) arg0;
		CentreActivite ca2 = (CentreActivite) arg1;
		int codcamo1 = Integer.parseInt(ca1.getCodcamo());
		int codcamo2 = Integer.parseInt(ca2.getCodcamo());
		if (codcamo1 < codcamo2) {
			return -1;
		} else {
			return 1;
		}

	}

	boolean equals(CentreActivite obj) {
		return false;
	}

}
