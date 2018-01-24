package com.socgen.bip.commun.form;

import java.util.Hashtable;

/**
 * @author RSRH/ICH/GMO Equipe Bip
 * @author E.GREVREND
 *
 * Classe ActionForm spécifique aux extractions de la BIP
 * Les parametres permettent de lancer n'importe quelle extraction de la BIP
 */
public class ExtractionForm extends ReportForm
{
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
	
	/* utilisé dans l'ecran xMensuelleMe.jsp (eviter de creer une action et un form specifique pour 2 case à cocher */
	/* */
	private String ck1;
	private String ck2;
	private String ck3;
	private String ck4;
	private String ck5;
	
	private String pid;
	
	private String sParam16;
	//PPM 63956
	private String sParam17;
	
	private String listPid;

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

	public String getCk1() {
			return ck1;
	}

	public void setCk1(String ck1) {
		this.ck1 = ck1;
	}

	public String getCk2() {
		return ck2;
	}

	public void setCk2(String ck2) {
		this.ck2 = ck2;
	}
		
	public String getCk3() {
			return ck3;
	}

	public String getCk4() {
		return ck4;
	}

	public String getCk5() {
		return ck5;
	}

	public void setCk3(String ck3) {
		this.ck3 = ck3;
	}

	public void setCk4(String ck4) {
		this.ck4 = ck4;
	}

	public void setCk5(String ck5) {
		this.ck5 = ck5;
	}		

	/**
	 * Returns the sDesFormat.
	 * @return String
	 */
	public String getDesformat()
	{
		return DESFORMAT_DELIMITEDDATA;
	}

	/**
	 * Sets the sDesFormat.
	 * Ne fait rien : voir méthode getDesformat ci-dessus
	 * @param sDesFormat The sDesFormat to set
	 */
	public void setDesformat(String sDesFormat)
	{
		logIhm.warning("La méthode setDesFormat ne fait rien pour les extractions");
	}

	/**
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
		if ( (sParam16 != null) && (sParam16.length() >= 1) ) //PPM 58375
			hP_paramsJob.put("P_param16", sParam16);
		if ( (sParam17 != null) && (sParam17.length() >= 1) ) //PPM 63956
			hP_paramsJob.put("P_param17", sParam17);
	}
	
	/**
	 * Le format n'est pas renseigné dans le formulaire pour les extractions
	 * @see com.socgen.bip.commun.form.ReportForm#isGoodFormat(String)
	 */
	public boolean isGoodFormat(String sDesFormat)
	{
		return true;
	}
	
	//PPM 58375
	public String getP_param16() {
		return sParam16;
	}
	
	public void setP_param16(String sParam16) {
		this.sParam16 = sParam16;
	}

	//PPM 63956
	public String getP_param17() {
		return sParam17;
	}

	public void setP_param17(String sParam17) {
		this.sParam17 = sParam17;
	}
	
	public String getPid() {
		return pid;
	}

	public void setPid(String pid) {
		this.pid = pid;
	}

	public String getListPid() {
		return listPid;
	}

	public void setListPid(String listPid) {
		this.listPid = listPid;
	}
	
	
	
}
