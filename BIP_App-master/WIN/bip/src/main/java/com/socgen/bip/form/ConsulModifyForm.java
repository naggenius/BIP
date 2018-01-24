/**
 * 
 */
package com.socgen.bip.form;

import java.util.ArrayList;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author x159644
 *
 */
public class ConsulModifyForm extends AutomateForm{
	
	private String ligne;
	private String libLigne;
	private int etape;
	private String libEtape;
	private int tache;
	private String libTache;
	private int sousTache;
	private String libSousTache;
	private int dpg_ligne;
	private int code_ress;
	private int dpg_ress;
	private ArrayList cle;
	private String libelle;
	
	
	
	
	
	public String getLibelle() {
		return libelle;
	}
	public void setLibelle(String libelle) {
		this.libelle = libelle;
	}
	public ArrayList getCle() {
		return cle;
	}
	public void setCle(ArrayList cle) {
		this.cle = cle;
	}
	public int getEtape() {
		return etape;
	}
	public void setEtape(int etape) {
		this.etape = etape;
	}
	public String getLigne() {
		return ligne;
	}
	public void setLigne(String ligne) {
		this.ligne = ligne;
	}
	public String getLibLigne() {
		return libLigne;
	}
	public void setLibLigne(String libLigne) {
		this.libLigne = libLigne;
	}
	public String getLibEtape() {
		return libEtape;
	}
	public void setLibEtape(String libEtape) {
		this.libEtape = libEtape;
	}
	public int getTache() {
		return tache;
	}
	public void setTache(int tache) {
		this.tache = tache;
	}
	public String getLibTache() {
		return libTache;
	}
	public void setLibTache(String libTache) {
		this.libTache = libTache;
	}
	public int getSousTache() {
		return sousTache;
	}
	public void setSousTache(int sousTache) {
		this.sousTache = sousTache;
	}
	public String getLibSousTache() {
		return libSousTache;
	}
	public void setLibSousTache(String libSousTache) {
		this.libSousTache = libSousTache;
	}
	public int getDpg_ligne() {
		return dpg_ligne;
	}
	public void setDpg_ligne(int dpg_ligne) {
		this.dpg_ligne = dpg_ligne;
	}
	public int getCode_ress() {
		return code_ress;
	}
	public void setCode_ress(int code_ress) {
		this.code_ress = code_ress;
	}
	public int getDpg_ress() {
		return dpg_ress;
	}
	public void setDpg_ress(int dpg_ress) {
		this.dpg_ress = dpg_ress;
	}       
  


}
