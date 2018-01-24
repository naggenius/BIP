package com.socgen.bip.form;

import java.util.ArrayList;

import com.socgen.bip.commun.form.AutomateForm;
import com.socgen.bip.metier.Favori;

/**
 * @author JMA - 03/03/2006
 *
 * Formulaire pour la liste des favoris
 * pages : lFavorisAd.jsp
 */

public class ListeFavorisForm extends AutomateForm {

	private ArrayList listeFavTrait;
	private ArrayList listeFavEdit;
	private ArrayList listeFavExtract;
	private String type;
	private Integer ordre;
	private Integer sens;
	private String menu;
	private String lien;


	/**
	 * 
	 */
	public ListeFavorisForm() {
		super();
		listeFavTrait   = new ArrayList();
		listeFavEdit    = new ArrayList();
		listeFavExtract = new ArrayList();
		type= "";
		ordre = new Integer(0);
	}

	/**
	 * @return
	 */
	public ArrayList getListeFavEdit() {
		return listeFavEdit;
	}

	/**
	 * @return
	 */
	public ArrayList getListeFavExtract() {
		return listeFavExtract;
	}

	/**
	 * @return
	 */
	public ArrayList getListeFavTrait() {
		return listeFavTrait;
	}

	/**
	 * @param list
	 */
	public void setListeFavEdit(ArrayList list) {
		listeFavEdit = list;
	}

	/**
	 * @param list
	 */
	public void setListeFavExtract(ArrayList list) {
		listeFavExtract = list;
	}

	/**
	 * @param list
	 */
	public void setListeFavTrait(ArrayList list) {
		listeFavTrait = list;
	}

	public void addFavori(String typFav, Object o) {
		if (typFav.equalsIgnoreCase("T")) listeFavTrait.add(o);
		else if (typFav.equalsIgnoreCase("E")) listeFavEdit.add(o);
		else if (typFav.equalsIgnoreCase("X")) listeFavExtract.add(o);
	}

	/**
	 * @return
	 */
	public Integer getOrdre() {
		return ordre;
	}

	/**
	 * @return
	 */
	public String getType() {
		return type;
	}

	/**
	 * @param integer
	 */
	public void setOrdre(Integer integer) {
		ordre = integer;
	}

	/**
	 * @param string
	 */
	public void setType(String string) {
		type = string;
	}

	/**
	 * @return
	 */
	public Integer getSens() {
		return sens;
	}

	/**
	 * @param integer
	 */
	public void setSens(Integer integer) {
		sens = integer;
	}

	/**
	 * @return
	 */
	public String getMenu() {
		return menu;
	}

	/**
	 * @param string
	 */
	public void setMenu(String string) {
		menu = string;
	}


	public int getNbFavMenu(String typeFav, String menu) {
		int result = 0;
		
		ArrayList a = null;
		if (typeFav.equals("T"))      a = getListeFavTrait(); 
		else if (typeFav.equals("E")) a = getListeFavEdit(); 
		else if (typeFav.equals("X")) a = getListeFavExtract();
		else return 0; 
		
		for (int i=0; i<a.size(); i++) {
			Favori f = (Favori) a.get(i);
			if (f.getMenu().equals(menu)) result++;
		}
		
		return result;
	}
	/**
	 * @return
	 */
	public String getLien() {
		return lien;
	}

	/**
	 * @param string
	 */
	public void setLien(String string) {
		lien = string;
	}

}