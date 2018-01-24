package com.socgen.bip.metier;

/**
 * @author CMA 30/03/2011
 *
 * Objet métier pour les paramètres BIP
 */
public class ParametreBip {
	
	private String code_action;
	
	private String code_version;
	
	private int num_ligne;
	
	private boolean actif;
	
	private boolean applicable;
	
	private boolean obligatoire;
	
	private boolean multi;
	
	private String separateur;
	
	private String format;
	
	private String casse;
	
	private String code_action_lie;
	
	private String code_version_lie;
	
	private int num_ligne_lie;
	
	private int min_size_unit;
	
	private int max_size_unit;
	
	private int min_size_tot;
	
	private int max_size_tot;
	
	private String valeur;
	
	private String commentaire;
	
	private ParametreBip parametreLie;

	public boolean isActif() {
		return actif;
	}

	public void setActif(boolean actif) {
		this.actif = actif;
	}

	public boolean isApplicable() {
		return applicable;
	}

	public void setApplicable(boolean applicable) {
		this.applicable = applicable;
	}

	public String getCasse() {
		return casse;
	}

	public void setCasse(String casse) {
		this.casse = casse;
	}

	public String getCode_action() {
		return code_action;
	}

	public void setCode_action(String code_action) {
		this.code_action = code_action;
	}

	public String getCode_action_lie() {
		return code_action_lie;
	}

	public void setCode_action_lie(String code_action_lie) {
		this.code_action_lie = code_action_lie;
	}

	public String getCode_version() {
		return code_version;
	}

	public void setCode_version(String code_version) {
		this.code_version = code_version;
	}

	public String getCode_version_lie() {
		return code_version_lie;
	}

	public void setCode_version_lie(String code_version_lie) {
		this.code_version_lie = code_version_lie;
	}

	public String getCommentaire() {
		return commentaire;
	}

	public void setCommentaire(String commentaire) {
		this.commentaire = commentaire;
	}

	public String getFormat() {
		return format;
	}

	public void setFormat(String format) {
		this.format = format;
	}

	public int getMax_size_tot() {
		return max_size_tot;
	}

	public void setMax_size_tot(int max_size_tot) {
		this.max_size_tot = max_size_tot;
	}

	public int getMax_size_unit() {
		return max_size_unit;
	}

	public void setMax_size_unit(int max_size_unit) {
		this.max_size_unit = max_size_unit;
	}

	public int getMin_size_tot() {
		return min_size_tot;
	}

	public void setMin_size_tot(int min_size_tot) {
		this.min_size_tot = min_size_tot;
	}

	public int getMin_size_unit() {
		return min_size_unit;
	}

	public void setMin_size_unit(int min_size_unit) {
		this.min_size_unit = min_size_unit;
	}

	public boolean isMulti() {
		return multi;
	}

	public void setMulti(boolean multi) {
		this.multi = multi;
	}

	public int getNum_ligne() {
		return num_ligne;
	}

	public void setNum_ligne(int num_ligne) {
		this.num_ligne = num_ligne;
	}

	public int getNum_ligne_lie() {
		return num_ligne_lie;
	}

	public void setNum_ligne_lie(int num_ligne_lie) {
		this.num_ligne_lie = num_ligne_lie;
	}

	public boolean isObligatoire() {
		return obligatoire;
	}

	public void setObligatoire(boolean obligatoire) {
		this.obligatoire = obligatoire;
	}

	public String getSeparateur() {
		return separateur;
	}

	public void setSeparateur(String separateur) {
		this.separateur = separateur;
	}

	public String getValeur() {
		return valeur;
	}

	public void setValeur(String valeur) {
		this.valeur = valeur;
	}

	public ParametreBip getParametreLie() {
		return parametreLie;
	}

	public void setParametreLie(ParametreBip parametreLie) {
		this.parametreLie = parametreLie;
	}

}
