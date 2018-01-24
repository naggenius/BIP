/*
 * Créé le 23 avr. 04
 *
 */
package com.socgen.bip.rbip.commun.loader;

import java.util.Date;
import java.util.Enumeration;
import java.util.Hashtable;

import org.apache.commons.lang.StringUtils;

/**
 * @author X039435 / E.GREVREND
 *
 *         La classe est utilisée pour représenter un enregistrement quelconque.<br>
 *         Cet enregistrement contient un nombre variable de champs qui ont leur propre type. On associe à chaque enregistrement le nom du fichier, le n° de la ligne à partir de
 *         laquelle il à été construit
 */
public class RBipData implements Comparable {

	public static final String SOUS_TRAITANCE_PREFIX = "FF";

	/**
	 * Chaque enregistrement doit avoir un type, le nom de ce champ est RECTYPE
	 */
	public static final String PARAM_RECTYPE = "RECTYPE";

	/**
	 * Permet de stocker les champs avec leur valeur
	 */
	private Hashtable hData;

	/**
	 * Nom du fichier d'où est tiré l'enregistrement
	 */
	private String sFileName;

	/**
	 * N° de ligne d'où est tiré l'enregistrement
	 */
	private int iNumLigne;

	/**
	 * Etat du fichier BIPS
	 */
	private boolean rejetBips;

	/**
	 * Etat du fichier BIPS
	 */
	private String rejetPID;

	/**
	 * A la création, seul le champs RECTYPE est définit pour cet enregistrement
	 * 
	 * @param sFileName
	 *            Nom du fichier d'où est tiré l'enregistrement
	 * @param iNumLigne
	 *            n° de lgne dans fichier d'où est tiré l'enregistrement
	 * @param recType
	 *            type de l'enregistrement
	 */
	public RBipData(String sFileName, int iNumLigne, String recType) {
		hData = new Hashtable();
		hData.put(PARAM_RECTYPE, "" + recType);

		this.iNumLigne = iNumLigne;
		this.sFileName = sFileName;
	}

	// 60612
	public RBipData(String sFileName, int iNumLigne) {
		hData = new Hashtable();

		this.iNumLigne = iNumLigne;
		this.sFileName = sFileName;
	}

	/**
	 * Représentation sous forme de chaîne de caractères
	 */
	public String toString() {
		String s = sFileName + ", " + iNumLigne + "\n\tFields : \n";
		Enumeration e = hData.keys();
		while (e.hasMoreElements()) {
			String sField = (String) e.nextElement();
			Object oVal = hData.get(sField);
			s += sField + "\t- " + oVal.toString() + "\n";
		}

		return s + "\n";
	}

	/**
	 * Ajout d'un nouveau champ (ou remplacement de la valeur du champ s'il existe déjà) On ne peut pas stocker <b>null</b> dans une Hashtable => on passe par RBipDateNoValue,
	 * classe dédiée.
	 * 
	 * @param sField
	 *            Nom du champ
	 * @param oValue
	 *            Valeur associée au champ
	 */
	public void put(String sField, Object oValue) {
		if (oValue == null)
			hData.put(sField, new RBipDataNoValue());
		else
			hData.put(sField, oValue);
	}

	/**
	 * @return la Hashtable contenant la liste des champs et leur valeur
	 */
	public Hashtable getData() {
		return hData;
	}

	/**
	 * Permet de récupérer la valeur associée à un champ
	 * 
	 * @param sField
	 *            le nom du champ
	 * @return la valeur du champ, si la valeur est <b>instanceof</b> alors on retourne <b>null</b>
	 */
	public Object getData(String sField) {
		if (hData.get(sField) instanceof RBipDataNoValue)
			return null;
		return hData.get(sField);
	}

	/**
	 * @param other
	 *            other Permet de comparer par ETS Croissant
	 */
	public int compareTo(Object other) {
		String ets1 = (String) ((RBipData) other).getData("ETS");
		String ets2 = (String) this.getData("ETS");
		return (ets2.compareTo(ets1));

	}

	/**
	 * @return
	 */
	public String getFileName() {
		return sFileName;
	}

	/**
	 * @return
	 */
	public int getNumLigne() {
		return iNumLigne;
	}

	public boolean isRejetBips() {
		return rejetBips;
	}

	public void setRejetBips(boolean rejetBips) {
		this.rejetBips = rejetBips;
	}

	public String getRejetPID() {
		return rejetPID;
	}

	public void setRejetPID(String rejetPID) {
		this.rejetPID = this.rejetPID + rejetPID + "-";
	}

	public boolean isSousTraitance() {
		String sousTacheType = getSousTacheType();
		if (StringUtils.isNotEmpty(sousTacheType) && sousTacheType.startsWith(SOUS_TRAITANCE_PREFIX)) {
			return true;
		}
		return false;
	}

	public String getSousTacheType() {
		return (String) getData(RBipStructureConstants.STACHE_TYPE);
	}
	
	public String extractIdLigneBipFromSousTacheType() {
		return getSousTacheType().substring(2);
	}

	public String getIdLigne() {
		return (String) getData(RBipStructureConstants.LIGNE_BIP_CODE);
	}

	public Date getDateSaisie() {
		return (Date) getData(RBipStructureConstants.CONSO_DEB_DATE);
	}

}