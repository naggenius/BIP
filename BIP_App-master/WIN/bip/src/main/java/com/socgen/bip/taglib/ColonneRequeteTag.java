package com.socgen.bip.taglib;

import java.io.IOException;
import java.util.Hashtable;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.TagSupport;

import com.socgen.bip.commun.action.BipAction;
import com.socgen.bip.form.ExtractParamForm;
import com.socgen.bip.metier.FiltreRequete;
import com.socgen.bip.user.UserBip;
import com.socgen.cap.fwk.ServiceManager;
import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.log.Log;


/**
 * Implémentation du tag permettant l'affichage des filtres pour l'extraction paramétrée
 * @author N.BACCAM
 */

public class ColonneRequeteTag extends TagSupport {
	static Log logBipUser = BipAction.getLogBipUser();
	// Initialise la variable config à pointer sur le fichier properties sql
	private static Config configSQL =
		ServiceManager.getInstance().getConfigManager().getSQL();


	private String index = "0";
	private Hashtable hFiltre ;
	private String sDonnee;
	FiltreRequete filtre;

	/**
	 * Implémentation du tag.
	 * Génère le code Javascript nécessaire à la création du menu.
	 * @see javax.servlet.jsp.tagext.TagSupport#doEndTag()
	 */
	public int doEndTag() throws JspException {
		HttpServletRequest request =
			(HttpServletRequest) pageContext.getRequest();
		HttpSession session = request.getSession(false);
		String resultat = "";
		String sNomFichier;
		String requete;
		
		String sColonne;
		StringTokenizer stko;
		int i=0;

		// L'utilisateur doit être authentifié.
		// dans le cas inverse, on provoque une exception.
		if (session == null) {
			throw new JspException("La session ne devrait pas être NULL");
		}

		UserBip user = (UserBip) session.getAttribute("UserBip");

		if (user == null) {
			throw new JspException("L'utilisateur ne devrait pas être NULL");
		}

		JspWriter out = pageContext.getOut();
		ExtractParamForm extractParamForm =
				(ExtractParamForm) request.getAttribute("extractParamForm");
		try {
			//sDonnee="Code client MO ligne BIP";"Sigle client";"CAMO ligne BIP";"Id application";"Libellé application";"Type projet ligne BIP";"Statut amort.";"Id ligne BIP";"Libellé ligne BIP";"Code projet informatique";"Code projet spécial";"Proposé N";"Notifié N";"Réestimé N";"Consommé";"Proposé N1";"Top tri";"Code CP";"PropAA MO";"PropAA+1 MO"
			sNomFichier = request.getParameter("nomFichier");
			//Récupérer les données
			sDonnee = request.getParameter("data");
			//Construire la fonction valider
		
			
		
       		stko= new StringTokenizer(sDonnee,";");
			while (stko.hasMoreTokens()) {
    			sColonne=stko.nextToken();
    			i++;
    			out.println("                    <tr><td><input type=\"checkbox\" name=\"colonne\" value=\"" + i + "\" CHECKED>"+sColonne+"</td></tr>");
			}
	
	

		} catch (IOException ioe) {
			logBipUser.debug(ioe.getMessage());
			throw new JspException(ioe);
		} catch (Exception e) {
			logBipUser.debug(e.toString());
			
		}
		return EVAL_PAGE;
	} //doEndTag() 
	
	
}
