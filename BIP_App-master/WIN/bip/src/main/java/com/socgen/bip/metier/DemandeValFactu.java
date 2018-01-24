package com.socgen.bip.metier;

import java.lang.reflect.Field;
import java.text.SimpleDateFormat;
import java.util.Date;





/**
 * @author x054232
 *
 * Pour changer le modèle de ce commentaire de type généré, allez à :
 * Fenêtre&gt;Préférences&gt;Java&gt;Génération de code&gt;Code et commentaires
 */
public class DemandeValFactu {

	private String mail_cp;
	private boolean nouvelle_demande;
	private Date datdem;
	private String numfact;
	private String socfact;
	private String soclib;
	private String typfact;
	private String datfact;
	private String ecart;
	private String causesuspens;
	private String statut;
	private int lnum;
	private int iddem;
	private String fenrcompta;
	private String fenvsec;
	private String fmodreglt;
	private String fordrecheq;
	private String fnom;
	private String fadresse1;
	private String fadresse2;
	private String fadresse3;
	private String fcodepost;
	private String fburdistr;
	private String lmoisprest;
	private String lcodcompta;
	private String lmontht;
	private String coutj;
	private String faccsec;
	private String fregcompta;
	private String fstatut2;
	

	public DemandeValFactu() {
		this.mail_cp = "";
		this.datdem = new Date();
		this.nouvelle_demande = true;
		this.numfact = "";
		this.socfact = "";
		this.ecart = "";
		this.causesuspens = "";
		this.statut = "";
		this.lnum = 0;
		this.iddem = 0;
		this.fenrcompta = "";
		this.fenvsec = "";
		this.fmodreglt = "";
		this.fordrecheq = "";
		this.fnom = "";
		this.fadresse1 = "";
		this.fadresse2 = "";
		this.fadresse3 = "";
		this.fcodepost = "";
		this.fburdistr = "";
		this.lmoisprest = "";
		this.lcodcompta = "";
		this.lmontht = "";
		this.coutj = "";
	}

	public DemandeValFactu(
		String p_mail_cp,
		boolean b_new_demande,
		int p_iddem,
		Date p_datdem,
		String p_numfact,
		String p_socfact,
		String p_typfact,
		String p_datfact,
		int p_lnum,
		String p_ecart,
		String p_causesuspens,
		String p_statut) {
			
		this.mail_cp = p_mail_cp;
		this.datdem = p_datdem;
		this.iddem = p_iddem;
		this.nouvelle_demande = b_new_demande;
		this.numfact = p_numfact;
		this.socfact = p_socfact;
		this.typfact = p_typfact;
		this.datfact = p_datfact;
		this.lnum = p_lnum;
		this.ecart = p_ecart;
		this.causesuspens = p_causesuspens;
		if (p_statut==null)
			this.statut = "";
		else
			this.statut = p_statut;
	}

	/* Appeller pour mise à jour des dates de suivi */
	public DemandeValFactu(
		String p_socfact,
		String p_soclib,
		String p_numfact,
		String p_typfact,
		String p_datfact,
		String p_fenrcompta,
		String p_fenvsec,
		String p_fmodreglt,
		String p_fordrecheq,
		String p_fnom,
		String p_fadresse1,
		String p_fadresse2,
		String p_fadresse3,
		String p_fcodepost,
		String p_fburdistr,
		String p_faccsec,
		String p_fregcompta,
		String p_fstatut2) {

		this.socfact 	= p_socfact;
		this.soclib 	= p_soclib;
		this.numfact 	= p_numfact;
		this.typfact 	= p_typfact;
		this.datfact 	= p_datfact;
		this.fenrcompta = p_fenrcompta;
		this.fenvsec 	= p_fenvsec;
		this.fmodreglt 	= p_fmodreglt;
		this.fordrecheq = p_fordrecheq;
		this.fnom       = p_fnom;
		this.fadresse1 	= p_fadresse1;
		this.fadresse2 	= p_fadresse2;
		this.fadresse3 	= p_fadresse3;
		this.fcodepost 	= p_fcodepost;
		this.fburdistr 	= p_fburdistr;
		this.faccsec 	= p_faccsec;
		this.fregcompta = p_fregcompta;
		this.fstatut2 	= p_fstatut2;
	}

	private String replace(String str, String pattern, String replace) {
		int s = 0;
		int e = 0;
		StringBuffer result = new StringBuffer();

		while ((e = str.indexOf(pattern, s)) >= 0) {
			result.append(str.substring(s, e));
			result.append(replace);
			s = e + pattern.length();
		}
		result.append(str.substring(s));
		return result.toString();
	}

	/**
	 * @return
	 */
	public String getCausesuspens() {
		return causesuspens;
	}

	/**
	 * @return
	 */
	public Date getDatdem() {
		return datdem;
	}
	
	public String getDatdemFormat() {
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
		return sdf.format(datdem);
	}
	
	public String getDatdemHeure() {
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
		return sdf.format(datdem);
	}

	/**
	 * @return
	 */
	public String getMail_cp() {
		return mail_cp;
	}

	/**
	 * @return
	 */
	public String getNumfact() {
		return numfact;
	}

	/**
	 * @return
	 */
	public String getSocfact() {
		return socfact;
	}

	/**
	 * @return
	 */
	public String getStatut() {
		return statut;
	}

	/**
	 * @param string
	 */
	public void setCausesuspens(String string) {
		causesuspens = string;
	}
	
	public String getCausesuspensCourt() {
		if (causesuspens!=null) {
			if (causesuspens.length()>10) {
				return causesuspens.substring(0, 10)+"...";
			}
			return causesuspens;
		} else {
			return "";
		}
	}

	/**
	 * @param string
	 */
	public void setDatdem(Date date) {
		datdem = date;
	}

	/**
	 * @param string
	 */
	public void setMail_cp(String string) {
		mail_cp = string;
	}

	/**
	 * @param string
	 */
	public void setNumfact(String string) {
		numfact = string;
	}

	/**
	 * @param string
	 */
	public void setSocfact(String string) {
		socfact = string;
	}

	/**
	 * @param string
	 */
	public void setStatut(String string) {
		statut = string;
	}

	/**
	 * @return
	 */
	public int getLnum() {
		return lnum;
	}

	/**
	 * @param i
	 */
	public void setLnum(int i) {
		lnum = i;
	}

	/**
	 * @return
	 */
	public boolean isNouvelle_demande() {
		return nouvelle_demande;
	}

	/**
	 * @param b
	 */
	public void setNouvelle_demande(boolean b) {
		nouvelle_demande = b;
	}

	/**
	 * @return
	 */
	public String getDatfact() {
		return datfact;
	}

	/**
	 * @return
	 */
	public String getTypfact() {
		return typfact;
	}

	/**
	 * @param string
	 */
	public void setDatfact(String string) {
		datfact = string;
	}

	/**
	 * @param string
	 */
	public void setTypfact(String string) {
		typfact = string;
	}

	/**
	 * @return
	 */
	public int getIddem() {
		return iddem;
	}

	/**
	 * @param i
	 */
	public void setIddem(int i) {
		iddem = i;
	}

	/**
	 * @return
	 */
	public String getEcart() {
		return ecart;
	}

	/**
	 * @param string
	 */
	public void setEcart(String string) {
		ecart = string;
	}

	/**
	 * @return
	 */
	public String getCoutj() {
		return coutj;
	}

	/**
	 * @return
	 */
	public String getFadresse1() {
		return fadresse1;
	}

	/**
	 * @return
	 */
	public String getFadresse2() {
		return fadresse2;
	}

	/**
	 * @return
	 */
	public String getFadresse3() {
		return fadresse3;
	}

	/**
	 * @return
	 */
	public String getFburdistr() {
		return fburdistr;
	}

	/**
	 * @return
	 */
	public String getFcodepost() {
		return fcodepost;
	}

	/**
	 * @return
	 */
	public String getFenrcompta() {
		return fenrcompta;
	}

	/**
	 * @return
	 */
	public String getFenvsec() {
		return fenvsec;
	}

	/**
	 * @return
	 */
	public String getFmodreglt() {
		return fmodreglt;
	}

	/**
	 * @return
	 */
	public String getFnom() {
		return fnom;
	}

	/**
	 * @return
	 */
	public String getFordrecheq() {
		return fordrecheq;
	}

	/**
	 * @return
	 */
	public String getLcodcompta() {
		return lcodcompta;
	}

	/**
	 * @return
	 */
	public String getLmoisprest() {
		return lmoisprest;
	}

	/**
	 * @return
	 */
	public String getLmontht() {
		return lmontht;
	}

	/**
	 * @return
	 */
	public String getSoclib() {
		return soclib;
	}

	/**
	 * @param string
	 */
	public void setCoutj(String string) {
		coutj = string;
	}

	/**
	 * @param string
	 */
	public void setFadresse1(String string) {
		fadresse1 = string;
	}

	/**
	 * @param string
	 */
	public void setFadresse2(String string) {
		fadresse2 = string;
	}

	/**
	 * @param string
	 */
	public void setFadresse3(String string) {
		fadresse3 = string;
	}

	/**
	 * @param string
	 */
	public void setFburdistr(String string) {
		fburdistr = string;
	}

	/**
	 * @param string
	 */
	public void setFcodepost(String string) {
		fcodepost = string;
	}

	/**
	 * @param string
	 */
	public void setFenrcompta(String string) {
		fenrcompta = string;
	}

	/**
	 * @param string
	 */
	public void setFenvsec(String string) {
		fenvsec = string;
	}

	/**
	 * @param string
	 */
	public void setFmodreglt(String string) {
		fmodreglt = string;
	}

	/**
	 * @param string
	 */
	public void setFnom(String string) {
		fnom = string;
	}

	/**
	 * @param string
	 */
	public void setFordrecheq(String string) {
		fordrecheq = string;
	}

	/**
	 * @param string
	 */
	public void setLcodcompta(String string) {
		lcodcompta = string;
	}

	/**
	 * @param string
	 */
	public void setLmoisprest(String string) {
		lmoisprest = string;
	}

	/**
	 * @param string
	 */
	public void setLmontht(String string) {
		lmontht = string;
	}

	/**
	 * @param string
	 */
	public void setSoclib(String string) {
		soclib = string;
	}

	/**
	 * @return
	 */
	public String getFaccsec() {
		return faccsec;
	}

	/**
	 * @param string
	 */
	public void setFaccsec(String string) {
		faccsec = string;
	}

	/**
	 * @return
	 */
	public String getFregcompta() {
		return fregcompta;
	}

	/**
	 * @return
	 */
	public String getFstatut2() {
		return fstatut2;
	}

	/**
	 * @param string
	 */
	public void setFregcompta(String string) {
		fregcompta = string;
	}

	/**
	 * @param string
	 */
	public void setFstatut2(String string) {
		fstatut2 = string;
	}

	public String toString() {
		Field[] f = this.getClass().getDeclaredFields();
		StringBuffer retour = new StringBuffer();
		for (int i=0; i<f.length; i++) {
			try { 
				retour.append(f[i].getName() + " = " + f[i].get((Object) this) + "\n");
			} catch (Exception e) {
				System.out.println(" Exception : " + e.toString());
			}
		}
		return retour.toString();
	}

}
