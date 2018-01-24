package com.socgen.bip.commun.form;

import java.util.Hashtable;

import org.apache.struts.action.ActionForm;
import org.owasp.esapi.ESAPI;
import org.owasp.esapi.errors.EncodingException;

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.action.BipAction;

/**
 * @author RSRH/ICH/GMO Equipe Bip
 *
 * ActionForm à l'origine de tous les Forms de la BIP
 */
public class BipForm extends ActionForm implements BipConstantes
{
	/**
	 * La page d'aide du formulaire
	 */
	protected String pageAide;   
	/**
	 * Le début du titre de la page (Créer, Modifier, Supprimer ...)
	 */
	protected  String titrePage;
	/**
	 * Le champ mis en focus
	 */
	protected  String focus;
	/**
	 * Le message d'erreur applicatif
	 */
	protected  String msgErreur;
	/**
	 * La hashtable contenant la liste des paramètres du Form
	 */
	protected  Hashtable hParams ;
	/**
	 * La chaîne contenant les informations sur le User
	 */
	protected  String infosUser;
	
	protected String arborescence;
	
	/**
	 * Returns the focus.
	 * @return String
	 */
	public String getFocus() {
		return focus;
	}

	/**
	 * Returns the hKeyList.
	 * @return Hashtable
	 */
	public Hashtable getHParams() {
		return hParams;
	}

	/**
	 * Returns the msgErreur.
	 * @return String
	 */
	public String getMsgErreur() {
		return msgErreur;
	}

	/**
	 * Returns the titrePage.
	 * @return String
	 */
	public String getTitrePage() {
		return titrePage;
	}

	/**
	 * Sets the focus.
	 * @param focus The focus to set
	 */
	public void setFocus(String focus) {
		this.focus = focus;
	}

	/**
	 * Sets the hKeyList.
	 * @param hKeyList The hKeyList to set
	 */
	public void setHParams(Hashtable hParams) {
		this.hParams = hParams;
	}

	/**
	 * Sets the msgErreur.
	 * @param msgErreur The msgErreur to set
	 */
	public void setMsgErreur(String msgErreur) {
		this.msgErreur = msgErreur;
	}

	/**
	 * Sets the titrePage.
	 * @param titrePage The titrePage to set
	 */
	public void setTitrePage(String titrePage) {
		this.titrePage = titrePage;
	}
   /**
	 * Returns the infosUser.
	 * @return String
	 */
	public String getInfosUser() {
		return infosUser;
	}

	/**
	 * Sets the infosUser.
	 * @param infosUser The infosUser to set
	 */
	public void setInfosUser(String infosUser) {
		this.infosUser = infosUser;
	}

	/**
	 * @return
	 */
	public String getPageAide()
	{
		return pageAide;
	}

	/**
	 * @param string
	 */
	public void setPageAide(String string)
	{
		pageAide = string;
	}

	public String getArborescence() {
		try {
			return ESAPI.encoder().decodeFromURL(arborescence);
		} catch (EncodingException e) {
			// TODO Auto-generated catch block
			BipAction.logBipUser.error("Error. Check the code", e);
			return "Menu indéterminé";
		}
	}

	public void setArborescence(String arborescence) {
		this.arborescence = arborescence;
	}

	
}
