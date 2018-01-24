package com.socgen.bip.commun.form;

import java.util.ArrayList;
import java.util.Hashtable;

import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.config.ConfigManager;

/**
 * @author RSRH/ICH/GMO Equipe Bip
 * @author E.GREVREND
 *
 * Classe ActionForm spécifique aux édition de la BIP
 * Les parametres sParam6..sParam12 permettent de lancer<br>
 * n'importe quel état d'édition de la BIP
 */
public class EditionForm extends ReportForm
{	
	
	
	private static String LIBELLE_ETAT_DIFFERE = "L'Etat sera lancé en temps différé.";
	private static String LIBELLE_ETAT_NON_DIFFERE = "L'Etat sera lancé immédiatement.";
	 
	/**
	 * Libellé indiquant si c'est un Etat Différé ou non Différé
	 */
	private String libelleTypeEtat; 
	
	
	
	/**
	 * Valeur de P_param6
	 */
	private String sParam6;
	/**
	 * Valeur de P_param7
	 */
	private String sParam7;
	/**
	 * Valeur de P_param8
	 */
	private String sParam8;
	/**
	 * Valeur de P_param9
	 */
	private String sParam9;
	/**
	 * Valeur de P_param10
	 */
	private String sParam10;
	/**
	 * Valeur de P_param11
	 */
	private String sParam11;
	/**
	 * Valeur de P_param12
	 */
	private String sParam12;
	/**
	 * Valeur de P_param13
	 */
	private String sParam13;
	/**
	 * Valeur de P_param14
	 */
	private String sParam14;
	/**
	 * Valeur de P_param15
	 */
	private String sParam15;
	//PPM 59805 debut
	/**
	 * Valeur de P_param16
	 */
	private String sParam16;
	/**
	 * Valeur de P_param17
	 */
	private String sParam17;
	/**
	 * Valeur de P_param18
	 */
	private String sParam18;
	/**
	 * Valeur de P_param19
	 */
	private String sParam19;
	/**
	 * Valeur de P_param20
	 */
	private String sParam20;
	/**
	 * Valeur de P_param21
	 */
	private String sParam21;
	/**
	 * Valeur de P_param22
	 */
	private String sParam22;
	/**
	 * Valeur de P_param23
	 */
	private String sParam23;
	/**
	 * Valeur de P_param24
	 */
	private String sParam24;
	/**
	 * Valeur de P_param25
	 */
	private String sParam25;
	//PPM 59805 fin

	//FAD PPM 60955 : Ajout de la liste des rejet, du param26 et du param27
	private String sParam26;
	private String sParam27;
	private String[] listeRejet;
	//FAD PPM 60955 : Fin

	/**
	 * Returns the sParam6.
	 * @return String
	 */
	public String getP_param6() {
		return sParam6;
	}

	/**
	 * Returns the sParam7.
	 * @return String
	 */
	public String getP_param7() {
		return sParam7;
	}

	/**
	 * Returns the sParam8.
	 * @return String
	 */
	public String getP_param8() {
		return sParam8;
	}

	/**
	 * Returns the sParam9.
	 * @return String
	 */
	public String getP_param9() {
		return sParam9;
	}

	/**
	 * Returns the sParam10.
	 * @return String
	 */
	public String getP_param10() {
		return sParam10;
	}

	/**
	 * Returns the sParam11.
	 * @return String
	 */
	public String getP_param11() {
		return sParam11;
	}

	/**
	 * Returns the sParam12.
	 * @return String
	 */
	public String getP_param12() {
		return sParam12;
	}
	
		/**
	 * Returns the sParam13.
	 * @return String
	 */
	public String getP_param13()
	{
		return sParam13;
	}

	/**
	 * Returns the sParam14.
	 * @return String
	 */
	public String getP_param14()
	{
		return sParam14;
	}
	
	/**
	 * Sets the sParam6.
	 * @param sParam6 The sParam6 to set
	 */
	public void setP_param6(String sParam6) {
		this.sParam6 = sParam6;
	}

	/**
	 * Sets the sParam7.
	 * @param sParam7 The sParam7 to set
	 */
	public void setP_param7(String sParam7) {
		this.sParam7 = sParam7;
	}

	/**
	 * Sets the sParam8.
	 * @param sParam8 The sParam8 to set
	 */
	public void setP_param8(String sParam8) {
		this.sParam8 = sParam8;
	}

	/**
	 * Sets the sParam9.
	 * @param sParam9 The sParam9 to set
	 */
	public void setP_param9(String sParam9) {
		this.sParam9 = sParam9;
	}
	
	/**
	 * Sets the sParam10.
	 * @param sParam10 The sParam10 to set
	 */
	public void setP_param10(String sParam10) {
		this.sParam10 = sParam10;
	}

	/**
	 * Sets the sParam11.
	 * @param sParam11 The sParam11 to set
	 */
	public void setP_param11(String sParam11) {
		this.sParam11 = sParam11;
	}

	/**
	 * Sets the sParam12.
	 * @param sParam12 The sParam12 to set
	 */
	public void setP_param12(String sParam12) {
		this.sParam12 = sParam12;
	}

	/**
	 * Sets the sParam13.
	 * @param sParam13 The sParam13 to set
	 */
	public void setP_param13(String sParam13)
	{
		this.sParam13 = sParam13;
	}

	/**
	 * Sets the sParam14.
	 * @param sParam14 The sParam14 to set
	 */
	public void setP_param14(String sParam14)
	{
		this.sParam14 = sParam14;
	}

	
	public String getP_param15() {
		return sParam15;
	}

	public void setP_param15(String sParam15) {
		this.sParam15 = sParam15;
	}
	//PPM 59805 debut
	/**
	 * @return the sParam16
	 */
	public String getP_param16() {
		return sParam16;
	}

	/**
	 * @param sParam16 the sParam16 to set
	 */
	public void setP_param16(String sParam16) {
		this.sParam16 = sParam16;
	}

	/**
	 * @return the sParam17
	 */
	public String getP_param17() {
		return sParam17;
	}

	/**
	 * @param sParam17 the sParam17 to set
	 */
	public void setP_param17(String sParam17) {
		this.sParam17 = sParam17;
	}

	/**
	 * @return the sParam18
	 */
	public String getP_param18() {
		return sParam18;
	}

	/**
	 * @param sParam18 the sParam18 to set
	 */
	public void setP_param18(String sParam18) {
		this.sParam18 = sParam18;
	}

	/**
	 * @return the sParam19
	 */
	public String getP_param19() {
		return sParam19;
	}

	/**
	 * @param sParam19 the sParam19 to set
	 */
	public void setP_param19(String sParam19) {
		this.sParam19 = sParam19;
	}

	/**
	 * @return the sParam20
	 */
	public String getP_param20() {
		return sParam20;
	}

	/**
	 * @param sParam20 the sParam20 to set
	 */
	public void setP_param20(String sParam20) {
		this.sParam20 = sParam20;
	}

	/**
	 * @return the sParam21
	 */
	public String getP_param21() {
		return sParam21;
	}

	/**
	 * @param sParam21 the sParam21 to set
	 */
	public void setP_param21(String sParam21) {
		this.sParam21 = sParam21;
	}

	/**
	 * @return the sParam22
	 */
	public String getP_param22() {
		return sParam22;
	}

	/**
	 * @param sParam22 the sParam22 to set
	 */
	public void setP_param22(String sParam22) {
		this.sParam22 = sParam22;
	}

	/**
	 * @return the sParam23
	 */
	public String getP_param23() {
		return sParam23;
	}

	/**
	 * @param sParam23 the sParam23 to set
	 */
	public void setP_param23(String sParam23) {
		this.sParam23 = sParam23;
	}

	/**
	 * @return the sParam24
	 */
	public String getP_param24() {
		return sParam24;
	}

	/**
	 * @param sParam24 the sParam24 to set
	 */
	public void setP_param24(String sParam24) {
		this.sParam24 = sParam24;
	}

	/**
	 * @return the sParam25
	 */
	public String getP_param25() {
		return sParam25;
	}

	/**
	 * @param sParam25 the sParam25 to set
	 */
	public void setP_param25(String sParam25) {
		this.sParam25 = sParam25;
	}
	//PPM 59805 fin

	//FAD PPM 60955 : Ajout des getters et seters de la liste des rejet, du param26 et du param27
	public String getP_param26() {
		return sParam26;
	}

	public void setP_param26(String sParam26) {
		this.sParam26 = sParam26;
	}

	public String getP_param27() {
		return sParam27;
	}

	public void setP_param27(String sParam27) {
		this.sParam27 = sParam27;
	}

	public String[] getListeRejet() {
		return listeRejet;
	}

	public void setListeRejet(String[] listeRejet) {
		this.listeRejet = listeRejet;
	}
	//FAD PPM 60955 : Fin

	/**
	 * Ajoute les paramètres renseignes à la Hashtable donnéee
	 * @param hP_paramsJob la Hashtable qui va recevoir les paramètres du formulaire
	 * 
	 * @see com.socgen.bip.commun.form.ReportForm#putParamsToHash(Hashtable)
	 */
	public void putParamsToHash(Hashtable hP_paramsJob)
	{
		if ( (sParam6 != null) && (sParam6.length() >= 1) )
			hP_paramsJob.put("P_param6", sParam6);
		if ( (sParam7 != null) && (sParam7.length() >= 1) )
			hP_paramsJob.put("P_param7", sParam7);
		if ( (sParam8 != null) && (sParam8.length() >= 1) )
			hP_paramsJob.put("P_param8", sParam8);
		if ( (sParam9 != null) && (sParam9.length() >= 1) )
			hP_paramsJob.put("P_param9", sParam9);
		if ( (sParam10 != null) && (sParam10.length() >= 1) )
			hP_paramsJob.put("P_param10", sParam10);
		if ( (sParam11 != null) && (sParam11.length() >= 1) )
			hP_paramsJob.put("P_param11", sParam11);
		if ( (sParam12 != null) && (sParam12.length() >= 1) )
			hP_paramsJob.put("P_param12", sParam12);
		if ( (sParam13 != null) && (sParam13.length() >= 1) )
			hP_paramsJob.put("P_param13", sParam13);
		if ( (sParam14 != null) && (sParam14.length() >= 1) )
			hP_paramsJob.put("P_param14", sParam14);
		if ( (sParam15 != null) && (sParam15.length() >= 1) )
			hP_paramsJob.put("P_param15", sParam15);
		if ( (sParam16 != null) && (sParam16.length() >= 1) ) //PPM 59805 debut
			hP_paramsJob.put("P_param16", sParam16);
		if ( (sParam17 != null) && (sParam17.length() >= 1) )
			hP_paramsJob.put("P_param17", sParam17);
		if ( (sParam18 != null) && (sParam18.length() >= 1) )
			hP_paramsJob.put("P_param18", sParam18);
		if ( (sParam19 != null) && (sParam19.length() >= 1) )
			hP_paramsJob.put("P_param19", sParam19);
		if ( (sParam20 != null) && (sParam20.length() >= 1) )
			hP_paramsJob.put("P_param20", sParam20);
		if ( (sParam21 != null) && (sParam21.length() >= 1) )
			hP_paramsJob.put("P_param21", sParam21);
		if ( (sParam22 != null) && (sParam22.length() >= 1) )
			hP_paramsJob.put("P_param22", sParam22);
		if ( (sParam23 != null) && (sParam23.length() >= 1) )
			hP_paramsJob.put("P_param23", sParam23);
		if ( (sParam24 != null) && (sParam24.length() >= 1) )
			hP_paramsJob.put("P_param24", sParam24);
		if ( (sParam25 != null) && (sParam25.length() >= 1) )
			hP_paramsJob.put("P_param25", sParam25); //PPM 59805 fin
		// FAD PPM 60955 : début
		if ( (sParam26 != null) && (sParam26.length() >= 1) )
			hP_paramsJob.put("P_param26", sParam26);
		if ( (sParam27 != null) && (sParam27.length() >= 1) )
			hP_paramsJob.put("P_param27", sParam27);
		// FAD PPM 60955 : fin
	}
	
	/**
	 * @see com.socgen.bip.commun.form.ReportForm#isGoodFormat(String)
	 */
	public boolean isGoodFormat(String sDesFormat)
	{
		return ((sDesFormat!=null) && (sDesFormat.equals(DESFORMAT_HTML) || sDesFormat.equals(DESFORMAT_PDF)));
	}
	
	/**
	 * 
	 * Méthode permettant de savoir si l'édition pour l'état demandé
	 * va être directe en temps réel ou différée.
	 * 
	 * Place le libellé approprié dans la variable libelleTypeEtat
	 * suivant le tye d'Etat ( différé ou pas)
	 * 
	 * @author x054232
	 *
	 * Pour changer le modèle de ce commentaire de type généré, allez à :
	 * Fenêtre&gt;Préférences&gt;Java&gt;Génération de code&gt;Code et commentaires
	 */
	public void isEtatNonDiffere(String sJobId){
		Config cfgReports=ConfigManager.getInstance(BIP_REPORT);
		Config cfgJob=ConfigManager.getInstance(cfgReports.getString("report.jobCfg"));
		if (cfgJob.getBoolean(sJobId+".synchrone")){
			libelleTypeEtat = LIBELLE_ETAT_NON_DIFFERE;
		}else{
			libelleTypeEtat = LIBELLE_ETAT_DIFFERE;
		}
	}
	
	
	/**
	 * @return
	 */
	public String getLibelleTypeEtat() {
		return libelleTypeEtat;
	}

	/**
	 * @param string
	 */
	public void setLibelleTypeEtat(String string) {
		libelleTypeEtat = string;
	}

}
