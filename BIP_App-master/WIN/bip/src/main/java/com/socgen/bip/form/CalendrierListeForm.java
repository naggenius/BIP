package com.socgen.bip.form;

import java.util.ArrayList;
import java.util.Calendar;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author J. MAS - 06/02/2006
 *
 * Formulaire pour la présentation du calendrier BIP 
 * pages  : bCalendrierAl.jsp
 */
public class CalendrierListeForm extends AutomateForm {

	/* L'année du calendrier
	*/
	private String annee;
	
	private ArrayList listMois;
	private ArrayList entete;

	/**
	 * Constructor for ClientForm.
	 */
	public CalendrierListeForm() {
		super();
		setAnnee(Integer.toString(Calendar.getInstance().get(Calendar.YEAR)));
		listMois = new ArrayList();
		entete = new ArrayList();
	}

	/**
	 * @return
	 */
	public String getAnnee() {
		return annee;
	}

	/**
	 * @param string
	 */
	public void setAnnee(String string) {
		annee = string;
	}

	/**
	 * @return
	 */
	public ArrayList getListMois() {
		return listMois;
	}

	/**
	 * @param list
	 */
	public void setListMois(ArrayList list) {
		listMois = list;
	}

	public void addListMois(Object o) {
		listMois.add(o);
	}
	
	/**
	 * @return
	 */
	public ArrayList getEntete() {
		return entete;
	}

	/**
	 * @param list
	 */
	public void setEntete(ArrayList list) {
		entete = list;
	}

	public void addEntete(Object o) {
		entete.add(o);
	}
	

}
