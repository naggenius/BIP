package com.socgen.bip.form;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;
import com.socgen.bip.metier.FavoriRessource;

/**
 * @author BSA - 01/10/2011
 *
 * Formulaire pour modifier la liste des ressources favorites
 * pages : ffavori.jsp
 */

public class FavoriRessourceForm extends AutomateForm {

	private List<FavoriRessource> listeFavori;
	private Integer taille;

	/**
	 * @return
	 */
	public List<FavoriRessource> getListeFavori() {
		return listeFavori;
	}

	/**
	 * @param string
	 */
	public void setListeFavori(List<FavoriRessource> list) {
		listeFavori = list;
	}

	/**
	 * @return
	 */
	public Integer getTaille() {
		return taille;
	}

	/**
	 * @param string
	 */
	public void setTaille(Integer intTaille) {
		taille = intTaille;
	}
	
	public FavoriRessource getFavoriRessource(int i){
		return listeFavori.get(i);
	}
	
	public void setFavoriRessource(int i,FavoriRessource favoriRessource){
		listeFavori.add(i, favoriRessource);
	}

	 public void reset(ActionMapping mapping, HttpServletRequest request) {
		 super.reset(mapping, request);
		 if (listeFavori != null) {
			 for (FavoriRessource fav:listeFavori) {
				 fav.setFavori("0");
			 }
		 }
	}
	 
}