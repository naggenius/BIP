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
 * @author X054232
 * 
 * Tag Struts permettant d'afficher les messages personnels de l'utilisateur
 */
public class ListeMsgPersoTag extends TagSupport implements BipConstantes {

	static protected String PROC_SELECT = "msgperso.liste.proc";

	static protected String PROC_AFFICHE = "msgperso.affiche.proc";

	protected  static Config cfgProc = ConfigManager.getInstance(BIP_PROC);
	
	

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
		UserBip userBip = (UserBip) session.getAttribute("UserBip");
		//On n'exécute cette taglib que si le profil RTFE de l'utilisateur est OK
		if(userBip.verifRTFE()){
			Vector aListe = getVector();
			try {
				if (!aListe.isEmpty()) {
	
					// en tete du tableau
					out
							.println("<TABLE class=\"tableLogin\" cellSpacing=0 cellPadding=5 width=\"100%\" border=0>");
					out
							.println("<TR><TD class=\"lib\" align=\"center\"><b>Messages personnels</b>");
					out.println("</TD></TR><TR><TD>");
	
					for (Enumeration e = aListe.elements(); e.hasMoreElements();) {
						Hashtable hActu = (Hashtable) e.nextElement();
						out.println("<DIV ID=\"info1\" class=\"posrelative\">");
						out.println("<span class=\"titre\">"
								+ hActu.get("date_affiche") + " : ");
						out.println("<b>" + hActu.get("titre") + "</b>");
						out.println("</span><br>");
						out.println(hActu.get("texte").toString().trim());
						out.println("</DIV>");
					}
	
					// fin du tableau
					out.println("</DIV></TD></TR></TABLE>");
				}
			} catch (IOException e) {
				BipAction.logBipUser.error("Error. Check the code", e);
				throw new JspException(e);
			}
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
		String sInfosUser;
		String lCfrais;
		ParametreProc paramOut;
		UserBip userBip = (UserBip) session.getAttribute("UserBip");

		hParam = new Hashtable();

		JdbcBip jdbc = new JdbcBip(); 
		
		// Envoie les infos sur l'utilisateur
		sInfosUser = userBip.getInfosUser();
		hParam.put("userid", sInfosUser);

		// Envoie la liste des menus de l'utilisateur
		Vector v = userBip.getListeMenu();
		StringBuffer sb = new StringBuffer();
		for (Enumeration vE = v.elements(); vE.hasMoreElements();) {
			BipItemMenu bim = (BipItemMenu) vE.nextElement();
			sb.append(";" + bim.getId());
		}
		sb.append(";");
		hParam.put("listeMenu", sb.toString());

		// Envoie la liste des centres de frais de l'utilisateur
		lCfrais = userBip.getListe_Centres_Frais();
		if ( lCfrais == null) 
				lCfrais = "-1" ;
				
		hParam.put("listeCFrais", lCfrais);

		vRset = new Vector();
		try {
			vRes = jdbc.getResult(hParam,cfgProc, PROC_AFFICHE);
			for (Enumeration e = vRes.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();
					try {
						while (rset.next()) {
							hRset = new Hashtable();
							hRset.put("code_mp", rset.getString(1));
							hRset.put("titre", rset.getString(2));
							hRset.put("texte", rset.getString(3));
							hRset.put("date_affiche", rset.getString(4));
							vRset.addElement(hRset.clone());

						}
						if (rset != null)
							rset.close();
					} catch (SQLException eSQL) {
						throw new JspException(eSQL);
					}
				}
			}
		} catch (BaseException e) {
			throw new JspException(e);
		} finally {
			jdbc.closeJDBC();
		}
		return vRset;
	}

}
