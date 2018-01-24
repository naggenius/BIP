/*
 * Created on 30 juil. 03
 *
 * To change the template for this generated file go to
 * Window>Preferences>Java>Code Generation>Code and Comments
 */
package com.socgen.bip.taglib;

import java.net.URLEncoder;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.JspException;

import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.user.UserBip;
import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.config.ConfigManager;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author X039435
 * 
 * To change the template for this generated type comment go to
 * Window>Preferences>Java>Code Generation>Code and Comments
 */
public class ListeAsyncTag extends ListeMultiColonneTag {
	private String PROC_SELECT = "async.select";

	private final String STATUT_OK = "Terminé";

	private final String STATUT_KO = "Erreur";

	private final String STATUT_EN_COURS = "En cours";

	private final String IMAGE_OK = "images/imageOK.png";

	private final String IMAGE_KO = "images/imageKO.png";

	private final String IMAGE_ENCOURS = "images/imageENCOURS.bmp";

	private String type;

	private String imageOK = null;

	private String imageKO = null;

	private String imageENCOURS = null;
	
	public static String JOB_HIERARCHY = "xHierarchy1";
	
	

	/**
	 * Config pointant sur le fichier des ressources des reports
	 */
	protected static Config cfgReports = ConfigManager.getInstance(BIP_REPORT);

	/**
	 * Config pointant sur le fichier des ressources contenant la définition des
	 * états états.<br>
	 * Fichier spécifié dans le fichier des ressources des reports.
	 */
	protected static Config cfgJob = ConfigManager.getInstance(cfgReports
			.getString("report.jobCfg"));

	/**
	 * Le répertoire dans lequel les fichiers Excel de présentation peuvent être
	 * récuperes
	 */
	protected static final String sExcelDir = ConfigManager.getInstance(
			BIP_REPORT).getString("report.excel_dir");
	

	protected ArrayList getArrayList() throws JspException {
		HttpServletRequest request = (HttpServletRequest) pageContext
				.getRequest();
		
		HttpSession session = request.getSession(false);
		// appeler la proc de listage des fichiers asynchrones
		// construite l'ArrayList avec
		// modifier la valeur de l'image pour celle donnee en parametre
		Vector vRes;
		Hashtable hParam;
		ParametreProc paramOut;
		UserBip userBip = (UserBip) session.getAttribute("UserBip");

		hParam = new Hashtable();
		hParam.put("type", type);
		hParam.put("global", userBip.getInfosUser());

		if (imageOK == null)
			setImageOK(IMAGE_OK);
		if (imageKO == null)
			setImageKO(IMAGE_KO);
		if (imageENCOURS == null)
			setImageENCOURS(IMAGE_ENCOURS);

		ArrayList aList = new ArrayList();
		ArrayList colonneAList;

		// ajout des labels
		colonneAList = new ArrayList();
		colonneAList.add("Titre");
		colonneAList.add("Statut");
		colonneAList.add("Date");
		colonneAList.add("<input type=\"checkbox\" name=\"delAll" + type
				+ "\" id=\"delAll" + type
				+ "\" onclick=\"javascript:selectAll('" + type
				+ "');\" onmouseover=\"showTooltips(true,'" + type
				+ "',event);\" onmouseout=\"showTooltips(false,'" + type + "',event);\" >");
		aList.add(colonneAList);

		String statut;
		String nomFichier;
		String titre;
		String date;
		String reportid;
		String idjobreport;
		JdbcBip jdbc = new JdbcBip(); 

		try {
			vRes = jdbc.getResult(hParam, cfgProc, PROC_SELECT);
			for (Enumeration e = vRes.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();
					try {
						int nbTrait = 0;
						while (rset.next()) {
							colonneAList = new ArrayList();

							titre = rset.getString(1);
							nomFichier = rset.getString(2);
							statut = rset.getString(3);
							date = rset.getString(4);
							reportid = rset.getString(5);
							idjobreport = rset.getString(6);

							if (isShow(reportid, idjobreport)) {
								if (STATUT_OK.equals(statut)) {
									// TD 320 : Si c'est une extraction pour
									// tableau excel formattage spécifique du
									// lien
									if (isExtractionExcel(reportid)) {
										// Format du fichier de sortie
										// <nom fichier Excel>?data=<user>_<id
										// unique>.<desname>
										String host =request.getScheme()+ "://" + request.getServerName();
												//+ ":" + request.getServerPort();
										String ficExcel = cfgJob
												.getString(reportid
														+ ".fichierExcel");
										// on encode le lien vers les données
										// sinon celle pose problème avec les
										// caractères spéciaux comme /
										String lien = sExcelDir
												+ ficExcel
												+ "?"
												+ URLEncoder
														.encode("data="
																+ host
																+ nomFichier);
										if(reportid.equalsIgnoreCase(JOB_HIERARCHY)){
										
											colonneAList
											.add("<a href=\""
														+ nomFichier
														+ "\" onmouseover=\"window.status='';return true\" target=\"_blank\" content-type=\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\" style=\"text-decoration:none;\">"
													+ titre + "</a>");

										} else {
											colonneAList
											.add("<a href=\""
														+ lien
														+ "\" onmouseover=\"window.status='';return true\" target=\"_blank\" style=\"text-decoration:none;\">"
													+ titre + "</a>");
										}
									} else
										colonneAList
												.add("<a href=\""
														+ nomFichier
														+ "\" onmouseover=\"window.status='';return true\" style=\"text-decoration:none;\">"
														+ titre + "</a>");
								} else
									colonneAList.add(titre);

								if (STATUT_OK.equals(statut))
									colonneAList.add(imageOK + " " + statut);
								else if (STATUT_KO.equals(statut))
									colonneAList.add(imageKO + " " + statut);
								else if (STATUT_EN_COURS.equals(statut))
									colonneAList.add(imageENCOURS + " "
											+ statut);

								colonneAList.add(date);

								// affichage de la case à cocher pour supprimer
								// l'état si statut<>'en cours'
								// ou si statut=='en cours' et date
								// d'exécution<>date du jour (édition bloquée)
								Date today = new Date();
								SimpleDateFormat sdf = new SimpleDateFormat(
										"dd/MM/yyyy");

								if ((!STATUT_EN_COURS.equals(statut))
										|| ((STATUT_EN_COURS.equals(statut)) && (!date
												.substring(0, 10).equals(
														sdf.format(today)))))
									colonneAList
											.add("<INPUT TYPE=\"checkbox\" NAME=\"del"
													+ type
													+ "["
													+ (nbTrait)
													+ "]\" ID=\"del"
													+ type
													+ "["
													+ (nbTrait++)
													+ "]\" value=\""
													+ nomFichier + "\" >");
								else
									colonneAList.add("&nbsp;");

								aList.add(colonneAList);
							}
						}
						if (rset != null)
							rset.close();
					} catch (SQLException eSQL) {
						jdbc.closeJDBC();
						throw new JspException(eSQL);
					}
				}
			}
		} catch (BaseException e) {
			jdbc.closeJDBC();
			throw new JspException(e);
		}// catch
		finally {
			jdbc.closeJDBC();
			logService.debug(this.getClass().getName()
					+ "-valider()-Close Connection.");
		}

		// si pas de valeurs, on met quand meme une ligne vierge
		if (aList.size() == 1) {
			colonneAList = new ArrayList();
			colonneAList.add("&nbsp;");
			colonneAList.add("&nbsp;");
			colonneAList.add("&nbsp;");
			colonneAList.add("&nbsp;");
			aList.add(colonneAList);
		}

		return aList;
	}

	/**
	 * @return
	 */
	public String getType() {
		return type;
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
	public String getImageENCOURS() {
		return imageENCOURS;
	}

	/**
	 * @return
	 */
	public String getImageKO() {
		return imageKO;
	}

	/**
	 * @return
	 */
	public String getImageOK() {
		return imageOK;
	}

	/**
	 * @param string
	 */
	public void setImageENCOURS(String string) {
		// imageENCOURS = string;
		imageENCOURS = getImage(string);
	}

	/**
	 * @param string
	 */
	public void setImageKO(String string) {
		// imageKO = string;
		imageKO = getImage(string);
	}

	/**
	 * @param string
	 */
	public void setImageOK(String string) {
		// imageOK = "<img src=\"" + string + "\" border=0>";
		imageOK = getImage(string);
	}

	private String getImage(String sVal) {
		String sAppli = "/";
		return "<img src=\"" + sAppli + sVal + "\" border=0>";
	}

	/**
	 * Recherche dans le fichier de paramétrage si le job donné est une
	 * extraction pour une présentation Excel
	 * 
	 * @param sJobId
	 *            identifiant sur le job de report dans le fichier des
	 *            ressources
	 * @return boolean la valeur dela propriété edition dans le fichier des
	 *         ressources des reports pour le job donne
	 */
	private boolean isExtractionExcel(String sJobId) {
		try {
			if ((sJobId == null) || (sJobId.equals("")))
				return false;
			return cfgJob.getBoolean(sJobId + ".extractForExcel");
		} catch (Exception e) {
			return false;
		}
	}

	/**
	 * Recherche dans le fichier de paramétrage si l'état doit être afficher
	 * 
	 * @param sJobId
	 *            identifiant sur le job de report dans le fichier des
	 *            ressources
	 * @return boolean la valeur dela propriété edition dans le fichier des
	 *         ressources des reports pour le job donne
	 */
	private boolean isShow(String sJobId, String sReportId) {
		try {
			if ((sJobId == null) || (sJobId.equals("")))
				return false;
			return cfgJob.getBoolean(sJobId + "." + sReportId + ".show");
		} catch (Exception e) {
			return true;
		}
	}

}
