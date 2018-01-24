package com.socgen.bip.taglib;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.TagSupport;

import com.socgen.bip.commun.action.BipAction;
import com.socgen.cap.fwk.log.Log;
import com.socgen.ich.ihm.menu.IhmValues;
import com.socgen.ich.ihm.menu.PaginationVector;

/**
 * Tag de gestion de la pagination: ce tag est à utiliser avec les liste qui héritent
 * de PaginationVector
 * @author N.BACCAM (16/07/2003)
 */

public class PaginationTag extends TagSupport implements IhmValues {
	// Actions pour la pagination pour l'affichage des listes
	public static final String PAGE_SUIVANTE = "suivant";
	public static final String PAGE_PRECEDENTE = "precedent";
	public static final String PAGE_FIN = "fin";
	public static final String PAGE_DEBUT = "debut";
	public static final String PAGE_INDEX = "index";

	static Log logBipUser = BipAction.getLogBipUser();

	/**
	 * Nom du Vector à paginer
	 */
	protected String beanName = null;

	/**
	 * Implémentation du tag.
	 * Génère le code Javascript nécessaire à l'affichage des pages
	 * @see javax.servlet.jsp.tagext.TagSupport#doEndTag()
	 */
	public int doEndTag() throws JspException {
		int blockCount;
		int iNbVingtBlock=0;
		int iCourant=0;
		int iVingtBlock=0;
		int iFin =0;
		int iDeb =0;
		// Generate the URL to be encoded
		PaginationVector liste;
		HttpServletRequest request =
			(HttpServletRequest) pageContext.getRequest();

		// Print this element to our output writer
		JspWriter writer = pageContext.getOut();

		// Extraction de la liste à paginer
		liste =
			(PaginationVector) (request.getSession(false)).getAttribute(
				beanName);

		blockCount = liste.getBlockCount();

		try {
			// Générer les liens sur chaque page en fonction du nombre de blocs de 20 pages
			
			iCourant=(liste.isFirstBlock()?1:liste.getCurrentBlock());
			iNbVingtBlock=(blockCount%20==0?blockCount/20:blockCount/20+1);
		;
			for (int j = 0; j <= iNbVingtBlock; j++) {
				if (iCourant<j*20) {
					//On sauvegarde le numéro de bloc de 20 pages
					iVingtBlock=j;
					break;
				}
			}//for
			
			writer.print("<table><tr>");
			//Affichage du lien pour la page  précédente
			if (!liste.isFirstBlock()) {
				//Si plusieurs blocs de 20 pages
				if (iVingtBlock>1) {
					writer.print(
						"<td><a href='javascript:paginer(\""
							+ beanName
							+ "\", \""
							+ ((iVingtBlock-1)*20-20)
							+ "\" , \"index\");' ><<</a></td>");
					}
					
				writer.print(
					"<td><a href='javascript:paginer(\""
						+ beanName
						+ "\", \""
						+ (liste.getCurrentBlock() - 1)
						+ "\" , \"precedent\");' ><</a></td>");

			}
			
			//Un seul bloc
			if (blockCount<21)	{
				iFin = blockCount ;
				iDeb = 0;
			}
			else if (iVingtBlock==iNbVingtBlock) {//dernier bloc
				iFin = blockCount ;
				iDeb = iVingtBlock*20-20;
				
			}
			else {
				iFin = iVingtBlock*20 ;
				iDeb = iFin-20;
			}

			for (int i = iDeb; i < iFin; i++) {
				writer.print("<td class=\"contenu\">");
				if (liste.getCurrentBlock() == i) {
					writer.print(
						"<font size=\"2\" color=\"red\"><b> "
							+ (i + 1)
							+ "</b></font> ");
				} else {
					writer.print(
						"<a href='javascript:paginer(\""
							+ beanName
							+ "\", \""
							+ i
							+ "\" , \"index\");' >"
							+ (i + 1)
							+ "</a>");
					}
				writer.print("</td>");
			}//for
			//Affichage du lien pour la page  suivante
			if (!liste.isLastBlock()) {
				writer.print(
					"<td><a href='javascript:paginer(\""
						+ beanName
						+ "\", \""
						+ (liste.getCurrentBlock() + 1)
						+ "\" , \"suivant\");'>></a></td>");
				//Si plusieurs blocs de 20 pages
				if (iNbVingtBlock>1 && iVingtBlock<iNbVingtBlock) {
				writer.print(
					"<td><a href='javascript:paginer(\""
						+ beanName
						+ "\", \""
						+ (iVingtBlock*20)
						+ "\" , \"index\");'>>></a></td>");
				}
			}
			writer.print("</tr></table>");

		} catch (IOException e) {
			throw new JspException(e);
		}
		return EVAL_PAGE;
	}

	/**
	 * Returns the beanName.
	 * @return String
	 */
	public String getBeanName() {
		return beanName;
	}

	/**
	 * Sets the beanName.
	 * @param beanName The beanName to set
	 */
	public void setBeanName(String beanName) {
		this.beanName = beanName;
	}

}
