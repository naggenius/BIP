package com.socgen.bip.form;


import java.util.ArrayList;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author J. MAS - 16/11/2005
 *
 * Formulaire Rapport des chargements des tables de répartition 
 * chemin : Administration/Lignes BIP/Répartition JH/Rapport
 */
public class RapportTableRepartForm extends AutomateForm{

	// Liste contenant tout les chargements
	private ArrayList listeChg;
	
	
	// Champ pour un seul chargement
	private int codchr;
	private String codrep;
	private String moisrep;
	private String moisfin;
	private String nomFichier;
	private int statut;
	private String datechg;
	
	// Champs pour les erreurs
	private ArrayList numLigne;
	private ArrayList txtLigne;
	private ArrayList errLigne;

	// Champs pour le détail
	private ArrayList pid;
	private ArrayList libPID;
	private ArrayList tauxrep;
	private ArrayList liblignerep;
	private ArrayList codcamo;
	private ArrayList libCodcamo;

	/**
	 * Constructor for RapportTableRepartForm.
	 */
	public RapportTableRepartForm() {
		super();
		listeChg = new ArrayList();
	}
	
	/**
	 * @return
	 */
	public int getCodchr() {
		return codchr;
	}

	public int getCodchr(int i) {
		return ((RapportTableRepartForm) (getListeChg().get(i))).getCodchr();
	}
	
	/**
	 * @return
	 */
	public String getCodrep() {
		return codrep;
	}

	public String getCodrep(int i) {
		return ((RapportTableRepartForm) (getListeChg().get(i))).getCodrep();
	}
	
	/**
	 * @return
	 */
	public String getDatechg() {
		return datechg;
	}

	public String getDatechg(int i) {
		return ((RapportTableRepartForm) (getListeChg().get(i))).getDatechg();
	}
	
	/**
	 * @return
	 */
	public String getMoisrep() {
		return moisrep;
	}

	public String getMoisrep(int i) {
		return ((RapportTableRepartForm) (getListeChg().get(i))).getMoisrep();
	}

	/**
	 * @return
	 */
	public String getMoisfin() {
		return moisfin;
	}

	public String getMoisfin(int i) {
		return ((RapportTableRepartForm) (getListeChg().get(i))).getMoisfin();
	}
	
	/**
	 * @return
	 */
	public String getNomFichier() {
		return nomFichier;
	}

	public String getNomFichier(int i) {
		return ((RapportTableRepartForm) (getListeChg().get(i))).getNomFichier();
	}
	
	/**
	 * @return
	 */
	public int getStatut() {
		return statut;
	}

	public int getStatut(int i) {
		return ((RapportTableRepartForm) (getListeChg().get(i))).getStatut();
	}
	
	/**
	 * @param i
	 */
	public void setCodchr(int i) {
		codchr = i;
	}

	/**
	 * @param string
	 */
	public void setCodrep(String string) {
		codrep = string;
	}

	/**
	 * @param string
	 */
	public void setDatechg(String string) {
		datechg = string;
	}

	/**
	 * @param string
	 */
	public void setMoisrep(String string) {
		moisrep = string;
	}
	
	/**
	 * @param string
	 */
	public void setMoisfin(String string) {
		moisfin = string;
	}

	/**
	 * @param string
	 */
	public void setNomFichier(String string) {
		nomFichier = string;
	}



	/**
	 * @return
	 */
	public ArrayList getListeChg() {
		return listeChg;
	}

	/**
	 * @param list
	 */
	public void setListeChg(ArrayList list) {
		listeChg = list;
	}

	/**
	 * @param string
	 */
	public void setStatut(int i) {
		statut = i;
	}

	/**
	 * @return
	 */
	public ArrayList getErrLigne() {
		return errLigne;
	}

	public String getErrLigne(int i) {
		return (String) getErrLigne().get(i);
	}
	
	/**
	 * @return
	 */
	public ArrayList getNumLigne() {
		return numLigne;
	}

	public String getNumLigne(int i) {
		return ( (Integer) getNumLigne().get(i) ).toString();
	}

	/**
	 * @return
	 */
	public ArrayList getTxtLigne() {
		return txtLigne;
	}

	public String getTxtLigne(int i) {
		return (String) getTxtLigne().get(i);
	}
	
	/**
	 * @param list
	 */
	public void setErrLigne(ArrayList list) {
		errLigne = list;
	}

	/**
	 * @param list
	 */
	public void setNumLigne(ArrayList list) {
		numLigne = list;
	}

	/**
	 * @param list
	 */
	public void setTxtLigne(ArrayList list) {
		txtLigne = list;
	}

	/**
	 * @return
	 */
	public ArrayList getLiblignerep() {
		return liblignerep;
	}

	public String getLiblignerep(int i) {
		return (String) getLiblignerep().get(i);
	}
	
	/**
	 * @return
	 */
	public ArrayList getPid() {
		return pid;
	}

	public String getPid(int i) {
		return (String) getPid().get(i);
	}
	
	/**
	 * @return
	 */
	public ArrayList getTauxrep() {
		return tauxrep;
	}

	public String getTauxrep(int i) {
		return (String) getTauxrep().get(i);
	}
	
	/**
	 * @param list
	 */
	public void setLiblignerep(ArrayList list) {
		liblignerep = list;
	}

	/**
	 * @param list
	 */
	public void setPid(ArrayList list) {
		pid = list;
	}

	/**
	 * @param list
	 */
	public void setTauxrep(ArrayList list) {
		tauxrep = list;
	}

	/**
	 * @return
	 */
	public ArrayList getCodcamo() {
		return codcamo;
	}

	public String getCodcamo(int i) {
		return (String) getCodcamo().get(i);
	}
	
	/**
	 * @return
	 */
	public ArrayList getLibCodcamo() {
		return libCodcamo;
	}

	public String getLibCodcamo(int i) {
		return (String) getLibCodcamo().get(i);
	}
	
	/**
	 * @return
	 */
	public ArrayList getLibPID() {
		return libPID;
	}

	public String getLibPID(int i) {
		return (String) getLibPID().get(i);
	}
	
	/**
	 * @param list
	 */
	public void setCodcamo(ArrayList list) {
		codcamo = list;
	}

	/**
	 * @param list
	 */
	public void setLibCodcamo(ArrayList list) {
		libCodcamo = list;
	}

	/**
	 * @param list
	 */
	public void setLibPID(ArrayList list) {
		libPID = list;
	}

}
