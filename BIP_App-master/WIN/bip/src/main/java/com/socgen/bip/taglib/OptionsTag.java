package com.socgen.bip.taglib;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.TagSupport;

import org.apache.struts.taglib.html.SelectTag;

import com.socgen.bip.commun.Tools;
import com.socgen.bip.commun.action.BipAction;
import com.socgen.bip.commun.liste.ListeOption;
import com.socgen.cap.fwk.log.Log;

/**
 * Implémentation du tag permettant l'affichage d'une liste
 * @author N.BACCAM
 */

public class OptionsTag extends TagSupport
{
	static Log logBipUser = BipAction.getLogBipUser();;
	private String collection;

	/**
	 * Implémentation du tag.
	 * Génère le code Javascript nécessaire à la création du menu.
	 * @see javax.servlet.jsp.tagext.TagSupport#doEndTag()
	 */
	public int doEndTag() throws JspException
	{
		int j=0;
		ListeOption listeOption;
  		String lib;
		SelectTag valeurPrec;
		
		JspWriter out = pageContext.getOut() ;
		try
		{   
		    ArrayList aListe = (ArrayList)pageContext.getAttribute(collection);
		    valeurPrec = ((SelectTag)this.getParent());

		  	
  		  	//Lire la liste pour l'afficher
  		  	for (Iterator i = aListe.iterator(); i.hasNext(); ){
  		  	  	try{
					listeOption= (ListeOption)aListe.get(j);
	  		  		j++;
  		  	  	}
  		  	  	catch(IndexOutOfBoundsException inde) {
  		  	  		break;
  		  	  	}
  		  		
  		  		if(listeOption.getCle() == null)
				      listeOption.setCle("");
  		  		
  		  		lib=  Tools.convertirEspace( listeOption.getLibelle());
  		  		
  		  		if (valeurPrec.isMatched(listeOption.getCle())){
					out.print("<option value=\""+listeOption.getCle()+"\" selected>");
  		  		}
  		  		else {  		  		
  		  			out.print("<option value=\""+listeOption.getCle()+"\">");
  		  		}
  		  		out.print(lib);
  		  		out.print("</option>\n");
  		  		
  		        aListe.iterator().next();
  		  	}  	
		}
		catch (IOException ioe)
		{
			logBipUser.debug("OptionsTag :"+ioe.toString());
			throw new JspException(ioe) ;	
		}
        catch (Exception e) 
        {
        	logBipUser.debug("OptionsTag :"+e.toString());
        	throw new JspException(e) ;	
        }
		return EVAL_PAGE ;
	}
	/**
	 * Retourne le nom de la liste des options
	 * @return 
	 */
	public String getCollection() {
		return collection;
	}

	/**
	 * Met à jour le nom de la liste des options
	 * @param string 
	 */
	public void setCollection(String string) {
		collection = string;
	}

}
