/*
 * Created on 30 juil. 03
 *
 * To change the template for this generated file go to
 * Window>Preferences>Java>Code Generation>Code and Comments
 */
package com.socgen.bip.taglib;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.TagSupport;

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.action.BipAction;
import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.config.ConfigManager;

/**
 * @author X039435
 *
 * To change the template for this generated type comment go to
 * Window>Preferences>Java>Code Generation>Code and Comments
 */
abstract class ListeMultiColonneTag extends TagSupport implements BipConstantes
{

	static protected String PROC_SELECT_ASYNC_ID = "select_async";
	protected static Config cfgProc = ConfigManager.getInstance(BIP_PROC);
	
	private String largeurs = null;
	private String tableauStyle;
	private String valeurStyle;
	private String labelStyle;
	
	/**
	 * Implémentation du tag.
	 * Génère le code Javascript nécessaire à la création du menu.
	 * @see javax.servlet.jsp.tagext.TagSupport#doEndTag()
	 */
	public int doEndTag() throws JspException
	{
		HttpServletRequest request = (HttpServletRequest)pageContext.getRequest();
		HttpSession session = request.getSession(false);
		JspWriter out = pageContext.getOut();
		
		//String sTmp;
		ArrayList aListe = getArrayList();
		ArrayList currentAListe;
		ArrayList aLLargeurs = getArrayListLargeurs();
		Iterator itLargeurs = null;
		String currentValue;
		String currentLargeur;
		
		String sTStyle = "class=\""+tableauStyle+"\"";
		String sLStyle = "class=\""+labelStyle+"\"";
		String sVStyle = "class=\""+valeurStyle+"\"";
		boolean bFirst = true;
		try
		{
			//en tete du tableau
			out.println("<table " + sTStyle + " cellspacing=\"0\" border=\"0\">");
			
			for (Iterator itLigne = aListe.iterator(); itLigne.hasNext(); )
			{
				out.println("<tr>");
				currentAListe = (ArrayList)itLigne.next();
				
				if (aLLargeurs != null)
					itLargeurs = aLLargeurs.iterator();
				
				for (Iterator itChamp = currentAListe.iterator(); itChamp.hasNext(); )
				{
					currentValue = (String)itChamp.next();	
					
					if (itLargeurs != null)
						currentLargeur = " width=\""+(String)itLargeurs.next() + "\"";
					else
						currentLargeur = "";
					
					if (bFirst)
						out.println("<td " + sLStyle + currentLargeur + "><b>");
					else {
							if (currentValue.startsWith("<a href"))
								out.println("<td " + sLStyle + currentLargeur + ">");
							else
								out.println("<td " + sVStyle + currentLargeur + ">");
					}

					out.println(currentValue);
				
					
					if (bFirst)
						out.println("</b></td>");
					else
						out.println("</td>");
				}
				
				out.println("</tr>");
				bFirst = false;
			}
			
			//fin du tableau
			out.println("</table>");
		}
		catch (IOException e)
		{
			BipAction.logBipUser.error("Error. Check the code", e);
			throw new JspException(e);
		}
		return EVAL_PAGE;
	}
	
	protected abstract ArrayList getArrayList() throws JspException;

	/**
	 * @return
	 */
	public String getLabelStyle()
	{
		return labelStyle;
	}

	/**
	 * @return
	 */
	public String getTableauStyle()
	{
		return tableauStyle;
	}

	/**
	 * @return
	 */
	public String getValeurStyle()
	{
		return valeurStyle;
	}

	/**
	 * @param string
	 */
	public void setLabelStyle(String string)
	{
		labelStyle = string;
	}

	/**
	 * @param string
	 */
	public void setTableauStyle(String string)
	{
		tableauStyle = string;
	}

	/**
	 * @param string
	 */
	public void setValeurStyle(String string)
	{
		valeurStyle = string;
	}
	
	/**
	 * @return
	 */
	public String getLargeurs()
	{
		return largeurs;
	}

	private ArrayList getArrayListLargeurs()
	{
		if (largeurs == null)
			return null;

		ArrayList aList = new ArrayList();
		StringTokenizer sTK  = new StringTokenizer(largeurs, ";");
		while (sTK.hasMoreElements())
			aList.add(sTK.nextElement());

		return aList;
	}

	/**
	 * @param string
	 */
	public void setLargeurs(String string)
	{
		largeurs = string;
	}
}
