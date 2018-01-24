/*
 * Created on 05/11/2004
 *
 * To change the template for this generated file go to
 * Window>Preferences>Java>Code Generation>Code and Comments
 */
package com.socgen.bip.taglib;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.TagSupport;

//FIXME DHA NOT USED
//import weblogic.xml.xpath.common.functions.SubstringAfterFunction;

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.action.BipAction;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.menu.item.BipItemMenu;
import com.socgen.bip.user.UserBip;
import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.config.ConfigManager;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author A142129
 * 
 * To change the template for this generated type comment go to
 * Window>Preferences>Java>Code Generation>Code and Comments
 */
public class ListeActuTag extends TagSupport implements BipConstantes {
	static protected String PROC_SELECT_ACTUS = "select_actus";

	private String derniereMinute;

	protected static Config cfgProc = ConfigManager.getInstance(BIP_PROC);
	
	/**
	 * Implémentation du tag. Génère le code Javascript nécessaire à la création
	 * du menu.
	 * 
	 * @see javax.servlet.jsp.tagext.TagSupport#doEndTag()
	 */
	public int doEndTag() throws JspException {
		
		
		
		HttpServletRequest request = (HttpServletRequest) pageContext
				.getRequest();
		HttpSession session = request.getSession(false);
		JspWriter out = pageContext.getOut();
		Vector aListe = getVector();
		
		try {
			if (!aListe.isEmpty()) {
				// en tete du tableau
				out
						.println("<TABLE class=\"tableLogin\" cellSpacing=0 cellPadding=5 width=\"100%\" border=0>");
				out.println("<TR><TD class=\"lib\" align=\"center\"><b>"
						+ (derniereMinute.equals("N") ? "Actualités"
								: "Dernière minute !!!") + " </b>");
				out.println("</TD></TR><TR><TD>");
				// pour rendre dynamique les actu, on teste la valeur de
				// derniereMinute et si une seule actu.
				out
						.println("<DIV ID=\"co"
								+ derniereMinute.toLowerCase()
								+ "teneur"
								+ "\" "
								+ " class=\"texte\">");//SEL PPM 59158
				
				int  m = 0;
				for (Enumeration e = aListe.elements(); e.hasMoreElements();) {
					Hashtable hActu = (Hashtable) e.nextElement();
					boolean aHref = true;
					m++;
					out.println("<DIV ID=\"info_"+derniereMinute.toLowerCase()+"_"+m+"\" class=\"posrelative\">");
					out.println("<span class=\"titre\">"
							+ hActu.get("date_affiche") + " : ");
					if (!hActu.get("code_actu").toString().equals("0")) {
						out
								.println("<a href=\"/downloadfile.do?action=modifier&mode=download&code_actu="
										+ hActu.get("code_actu") + "\"");
						out.println(" target=\"_blank\">");
					} else {
						if (!hActu.get("url").toString().equals(" ")) {
							out.println("<a href=\"" + hActu.get("url")
									+ "\" target=\"_blank\">");
						} else {
							aHref = false;
						}
					}
					out.println("<b>" + hActu.get("titre") + "</b>"
							+ (aHref ? "</a>" : ""));
					out.println("</span><br>");
					out.println(hActu.get("texte").toString().trim());
					out.println("</DIV>");
					
					
					
					if (derniereMinute.equals("O") || derniereMinute.equals("P"))
						break;
				}

				// fin du tableau
				out.println("</DIV></TD></TR></TABLE>");
				
			}
		} catch (IOException e) {
			BipAction.logBipUser.error("Error. Check the code", e);
			throw new JspException(e);
		}
		return EVAL_PAGE;
	}

	protected Vector getVector() throws JspException {
		HttpServletRequest request = (HttpServletRequest) pageContext
				.getRequest();
		HttpSession session = request.getSession(false);
		Vector vRes;
		Hashtable hParam;
		Hashtable hRset;
		Vector vRset;
		ParametreProc paramOut;
		UserBip userBip = (UserBip) session.getAttribute("UserBip");
		Vector vProfil = userBip.getListeMenu();
		String sProfil = new String();
		for (int i = 0; i < vProfil.size(); i++) {
			// MenuIdBean oMenu= (MenuIdBean)vProfil.elementAt(i);
			BipItemMenu bIMenu = (BipItemMenu) vProfil.elementAt(i);
			// sProfil= sProfil+";"+oMenu.getNom();
			sProfil = sProfil + ";" + bIMenu.getId();
		}

		hParam = new Hashtable();
		hParam.put("profils", sProfil.toLowerCase());
		hParam.put("userid", userBip.getIdUser());
		hParam.put("derniere_minute", derniereMinute);
		
		JdbcBip jdbc = new JdbcBip(); 

		vRset = new Vector();
		try {
			vRes = jdbc.getResult(hParam, cfgProc, PROC_SELECT_ACTUS);
			for (Enumeration e = vRes.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();
					try {
						while (rset.next()) {
							hRset = new Hashtable();
							hRset.put("code_actu", rset.getString(1));
							hRset.put("titre", rset.getString(2));
							hRset.put("texte", rset.getString(3));
							hRset.put("date_affiche", rset.getString(4));
							hRset.put("url", rset.getString(5));
							vRset.addElement(hRset.clone());

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
		} finally {
			jdbc.closeJDBC();
		}
		return vRset;
	}

	/**
	 * Sets the derniereMinute.
	 * 
	 * @param derniereMinute
	 *            The derniereMinute. to set
	 */
	public void setDerniereMinute(String derniereMinute) {
		this.derniereMinute = derniereMinute;
	}

	/**
	 * Returns the derniereMinute.
	 * 
	 * @return String
	 */
	public String getDerniereMinute() {
		return derniereMinute;
	}
}