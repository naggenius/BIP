package com.socgen.bip.taglib;

import java.io.IOException;
import java.util.Enumeration;
import java.util.Hashtable;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.TagSupport;

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.action.BipAction;
import com.socgen.bip.form.ExtractParamForm;
import com.socgen.bip.metier.FiltreRequete;
import com.socgen.bip.user.UserBip;
import com.socgen.cap.fwk.ServiceManager;
import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.config.ConfigManager;
import com.socgen.cap.fwk.log.Log;
import com.socgen.ich.ihm.ToolBar;

/**
 * Implémentation du tag permettant l'affichage des filtres pour l'extraction paramétrée
 * @author N.BACCAM
 */

public class FiltreRequeteTag extends TagSupport implements BipConstantes
{
	static String sMessageFiltre = ConfigManager.getInstance(BIP_REPORT).getString("extractParam.messageFiltre");
	
	static Log logBipUser = BipAction.getLogBipUser();
	// Initialise la variable config à pointer sur le fichier properties sql
	private static Config configSQL =
		ServiceManager.getInstance().getConfigManager().getSQL();

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
		String sLibelle;
		String sType;
		String sObligatoire;
		String sCode;
		String sLongueur;
		String requete;
		Hashtable hFiltre ;
		String sDonnee;
		String sNbData;
		FiltreRequete filtre;
		
		String signatureMethode =
			"FiltreRequeteTag";
		logBipUser.entry(signatureMethode);

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
			sNomFichier = extractParamForm.getNomFichier();
			//Récupérer les données
			hFiltre = extractParamForm.getFiltre();
			sDonnee = extractParamForm.getData();
		    sNbData = extractParamForm.getNbData();

			//Construire la fonction valider
			out.println("function ValiderEcran(form)");
			out.println("{  ");
			for (Enumeration e = hFiltre.elements(); e.hasMoreElements();) {
				filtre = (FiltreRequete) e.nextElement();
				sObligatoire = filtre.getObligatoire();
				sType = filtre.getType();
				sCode = filtre.getCode();
				sLibelle = filtre.getLibelle();

				//Tester les champs obligatoires 
				if (sObligatoire.equals("O")) {

					//Tester si le type fini par 2 : champ encadré 
					if (sType.endsWith("2")) {
						
						out.println(
							"if (!ChampObligatoire(form."
								+ sCode
								+ "_part1,\""
								+ sLibelle
								+ "\")) return false;");
						out.println(
							"if (!ChampObligatoire(form."
								+ sCode
								+ "_part2,\""
								+ sLibelle
								+ "\")) return false;");
					} else {
					
						out.println(
							"if (!ChampObligatoire(form."
								+ sCode
								+ ",\""
								+ sLibelle
								+ "\")) return false;");
					}
				}
				//Pour tous les champs à 2 valeurs: si l'un est renseigné l'autre doit l'être aussi
				if (sType.endsWith("2")) {
					out.println(
						"if (!DoubleChamp(form."
							+ sCode
							+ "_part1, form."
							+ sCode
							+ "_part2, \" "
							+ sLibelle
							+ "\")) return false;");

				}
			} //for

			out.println("   return true;");
			out.println("}");

			out.println("</script>");

			out.println("</head>");
			out.println(
				"<body bgcolor=\"#FFFFFF\" text=\"#000000\" topmargin=\"0\" leftmargin=\"0\" onLoad=\"MessageInitial();\">");
			out.println(
				"<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");
			out.println(" <tr> ");
			out.println("    <td> ");
			out.println(
				"      <table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">");
			out.println("       <tr> ");
			out.println("          <td>&nbsp;</td>");
			out.println("       </tr>");
			out.println("        <tr > ");
			out.println("          <td> ");
			out.println("            <div align=\"center\">");
			ToolBar tb =
				new ToolBar(
					"bip_ihm",
					false,
					false,
					true,
					false,
					false,
					false,
					false,
					false,
					false);

			out.println(tb.printHtml());
			out.println("</div>");
			out.println("          </td>");
			out.println("        </tr>");
			out.println("        <tr> ");
			out.println("          <td>&nbsp;</td>");
			out.println("       </tr>");
			out.println("        <tr> ");
			out.println("          <td background=\"../images/ligne.gif\"></td>");
			out.println("       </tr>");
			out.println("       <tr> ");
			out.println("         <td height=\"20\" class=\"TitrePage\">Audit - Saisie des filtres");
			out.println("         </td>");
			out.println("      </tr>");
			out.println("       <tr> ");
			out.println("         <td background=\"../images/ligne.gif\"></td>");
			out.println("       </tr>");
			out.println("       <tr> ");
			out.println("         <td> </td>");
			out.println("       </tr>");
			out.println("       <tr> ");
			out.println(
				"<td> <form name=\"extractParamForm\" method=\"POST\" action=\"/extractParam.do\" onsubmit=\"return ValiderEcran(this);\">");
			out.println("            <table width=\"100 %\" border=\"0\">");
			out.println("             <tr> ");
			out.println("               <td> ");
			out.println("                 <div align=\"center\">");
			out.println(
				"<input type=\"hidden\" name=\"pageAide\" value=\""
					+ request.getParameter("pageAide")
					+ "\"> ");
			out.println("			<input type=\"hidden\" name=\"action\" value=\"modifier\">");
			out.println("			<input type=\"hidden\" name=\"titre\" value=\""+extractParamForm.getTitre()+"\">");
			out.println("			<input type=\"hidden\" name=\"nomFichier\" value=\""+sNomFichier+"\">");
			out.println("			<input type=\"hidden\" name=\"data\" value=\""+sDonnee+"\">");
			out.println("			<input type=\"hidden\" name=\"nbData\" value=\""+sNbData+"\">");
			out.println("			<input type=\"hidden\" name=\"filtreSql\" value=\"\">");
		
			out.println("                   <table cellspacing=\"2\" cellpadding=\"2\" class=\"tableBleu\">");
			out.println("                     <tr> 	<td>&nbsp;</td></tr>");
			out.println("                     <tr> ");
			out.println("                       	<td align=\"center\" colspan=\"2\"><b><u>"+extractParamForm.getTitre()+"</u></b></td>");
			out.println("                     </tr>");
			out.println("                     <tr> 	<td>&nbsp;</td></tr>");
			if (hFiltre.isEmpty()) {
				out.println("              		<tr> <td>&nbsp;</td></tr>");
				out.println(
					"<tr><td>Pas de filtre pour cette extraction</td></tr>");
			} else {
				for (Enumeration e = hFiltre.elements();
					e.hasMoreElements();
					) {
					filtre = (FiltreRequete) e.nextElement();
					sLibelle = filtre.getLibelle();
					sCode = filtre.getCode();
					sType = filtre.getType();
					sLongueur = filtre.getLongueur();
					sObligatoire = filtre.getObligatoire();
					out.println(
						AjouterFiltre(
							sLibelle,
							sCode,
							sType,
							sLongueur,
							sObligatoire));
				} //for
				
				out.println("              		<tr> <td>&nbsp;</td></tr>");
				out.println( "<tr><td colspan=\"2\">"+sMessageFiltre+"</td></tr>");
			}
	
		
			out.println("              		<tr> <td>&nbsp;</td></tr>");
			out.println("              		<tr> <td>&nbsp;</td></tr>");
			out.println("                    </table>");
			out.println("                   <table  border=\"0\" width=100%>");
			out.println("                     <tr> ");
			out.println(
				"<td  width=100% align=center> <input type=\"submit\" name=\"boutonValider\" value=\"Suite\" onclick=\"Verifier(this.form, 'modifier', true);\" class=\"input\">  ");
			out.println("                       </td>");
			out.println("                     </tr>");
			out.println("                  </table>");
			out.println("                  </div>");
			out.println("                </td>");
			out.println("              </tr>");
			out.println("           </table>");
			out.println("          </form>");

		} catch (IOException ioe) {
			logBipUser.debug(ioe.getMessage());
			throw new JspException(ioe);
		} catch (Exception e) {
			logBipUser.debug(e.toString());
			
		}
		logBipUser.exit(signatureMethode);
		return EVAL_PAGE;
	} //doEndTag() 
	
	/**
	 * Méthode qui permet de rajouter dans le formulaire un filtre
	 * 
	 */
	private String AjouterFiltre(
		String sLibelle,
		String sCode,
		String sType,
		String sLongueur,
		String sObligatoire) {
			
		String result = "";
		logBipUser.debug("AjouterFiltre:"+sType);
		if (sType.equals("NUMBER1")) {
			if (sLongueur.equals("-1"))
				sLongueur = "10";
			result =
				AjouterUnFiltre(
					sLibelle,
					sCode,
					sLongueur,
					//"VerifierNum2(" + sCode + "," + sLongueur + ",5)",
					"VerifierNum2(this," + sLongueur + ",5)",
					sObligatoire);
		} else if (sType.equals("NUMBER2")) {
			if (sLongueur.equals("-1"))
				sLongueur = "10";
			result =
				AjouterDeuxFiltre(
					sLibelle,
					sCode,
					sLongueur,
					"VerifierNum2(this," + sLongueur + ",5)",
					sObligatoire);
		} else if (sType.equals("INTEGER1")) {
			if (sLongueur.equals("-1"))
				sLongueur = "10";
			result =
				AjouterUnFiltre(
					sLibelle,
					sCode,
					sLongueur,
					"VerifierNum2(this," + sLongueur + ",0)",
					sObligatoire);
		} else if (sType.equals("INTEGER2")) {
			if (sLongueur.equals("-1"))
				sLongueur = "10";
			result =
				AjouterDeuxFiltre(
					sLibelle,
					sCode,
					sLongueur,
					"VerifierNum2(this," + sLongueur + ",0)",
					sObligatoire);
		} else if (sType.equals("INTEGER21")) {
			if (sLongueur.equals("-1"))
				sLongueur = "10";
			result =
				AjouterUnFiltre(
					sLibelle,
					sCode,
					sLongueur,
					"VerifierNum2(this," + sLongueur + ",0)",
					sObligatoire);
		} else if (sType.equals("CHAR")) {
			if (sLongueur.equals("-1"))
				sLongueur = "50";
			result =
				AjouterUnFiltre(
					sLibelle,
					sCode,
					sLongueur,
					"VerifierAlphaMax(this)",
					sObligatoire);
		} else if (sType.equals("DATE1")) {
			result =
				AjouterUnFiltre(
					sLibelle,
					sCode,
					"10",
					"VerifierDate(this,'jj/mm/aaaa')",
					sObligatoire);
		} else if (sType.equals("DATE2")) {
			result =
				AjouterDeuxFiltre(
					sLibelle,
					sCode,
					"10",
					"VerifierDate(this,'jj/mm/aaaa')",
					sObligatoire);
		}
		else if (sType.equals("CDDPG21"))
		{
			result =
				AjouterUnFiltre(
					sLibelle,
					sCode,
					"7",
					null,
					sObligatoire);
		}
		else if (sType.equals("RADIO"))
		{
			result =
				AjouterUnFiltreRadio(
					sLibelle,
					sCode,
					"7",
					null,
					sObligatoire);
			
		}
		else
		
		{
			result =
				"Le type de filtre "
					+ sType
					+ " n'existe pas.<br> Merci de contacter votre administrateur administratif<br>";
		}
		return result;
	}
	/**
	 * Méthode qui permet de rajouter dans le formulaire un champ de saisie
	 * 
	 */
	private String AjouterUnFiltre(
		String sLibelle,
		String sCode,
		String sTaille,
		String sVerif,
		String sObligatoire) {
		String result = "";
		result = "<TR>\n";
		result = result + "	<TD class=\"lib\">\n";
		if (sObligatoire.equals("O")) {
			result = result + "	<b>" + sLibelle + " :</b></TD>\n";
		} else {
			result = result + sLibelle + " :</TD>\n";
		}
		result =
			result
				+ "\t<TD><input type=\"TEXT\" class=\"input\" size="
				+ sTaille
				+ " maxlength="
				+ sTaille
				+ " name=\""
				+ sCode
				+ "\" value=\"\" onChange=\"return "
				+ sVerif
				+ ";\">\n";
		result = result + "\t</TD>\n";
		result = result + "</TR>\n";

		return result;
	} //AjouterUnFiltre
	/**
	 * Méthode qui permet de rajouter dans le formulaire 2 champs de saisie pour une plage de valeur
	 * 
	 */
	private String AjouterDeuxFiltre(
		String sLibelle,
		String sCode,
		String sLongueur,
		String sVerif,
		String sObligatoire) {
		String result = "";

		result = "<TR>\n";
		result = result + "	<TD class=\"lib\">\n";
		if (sObligatoire.equals("O")) {
			result = result + "	<b>" + sLibelle + " :</b></TD>\n";
		} else {
			result = result + sLibelle + " :</TD>\n";
		}
		result =
			result
				+ "\t<TD>De <input type=\"TEXT\" class=\"input\" size="
				+ sLongueur
				+ " maxlength="
				+ sLongueur
				+ " name=\""
				+ sCode
				+ "_part1\"  value=\"\" onChange=\"return "
				+ sVerif
				+ ";\">\n";
		result =
			result
				+ "\tà <input type=\"TEXT\" class=\"input\" size="
				+ sLongueur
				+ " maxlength="
				+ sLongueur
				+ " name=\""
				+ sCode
				+ "_part2\"  value=\"\" onChange=\"return "
				+ sVerif
				+ ";\">\n";
		result = result + "</TR>\n";

		return result;
	} //AjouterUnFiltre
	
	/**
	 * Méthode qui permet de rajouter dans le formulaire une radio
	 * 
	 */
	private String AjouterUnFiltreRadio(
		String sLibelle,
		String sCode,
		String sTaille,
		String sVerif,
		String sObligatoire) {
		String result = "";
		String result1 = "";
		result = "<TR>\n";
		result = result + "	<TD class=\"lib\">\n";
		if (sObligatoire.equals("O")) {
			result = result + "	<b>" + sLibelle + " :</b></TD>\n";
		} else {
			result = result + sLibelle + " :</TD>\n";
		}
		result =
			result
				+ "\t<TD><input type=\"radio\" class=\"input\" size="
				+ sTaille
				+ " maxlength="
				+ sTaille
				+ " name=\""
				+ sCode
				+ "\" value=0 checked>";
		result = result + "\t Toutes les lignes </TD>\n";
		result = result + "</TR>\n";
		
		result1 = "<TR>\n";
		result1 = result1 + "	<TD>&nbsp;</TD>\n";
		result1 =	result1
				+ "\t<TD><input type=\"radio\" class=\"input\" size="
				+ sTaille
				+ " maxlength="
				+ sTaille
				+ " name=\""
				+ sCode
				+ "\" value=1>\n";
		result1 = result1 + "\t Lignes avec budgets ou consommés renseignés</TD>\n";
		result1 = result1 + "</TR>\n";
		
		result = result + result1;

		return result;
	} //AjouterUnFiltreRadio
}
