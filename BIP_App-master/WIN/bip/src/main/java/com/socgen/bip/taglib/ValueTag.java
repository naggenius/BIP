package com.socgen.bip.taglib;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.TagSupport;

import com.socgen.bip.commun.action.BipAction;
import com.socgen.bip.user.UserBip;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.cap.fwk.jdbc.JDBCWrapper;
import com.socgen.cap.fwk.log.Log;

/**
 * Implémentation du tag permettant l'affichage du résultat d'un select d'une colonne d'une table
 * @author N.BACCAM
 */

public class ValueTag extends TagSupport
{
	static Log logBipUser = BipAction.getLogBipUser();
	
	private String champ;
	private String table;
	private String clause1;
	private String clause2;

	/**
	 * Implémentation du tag.
	 * Génère le code Javascript nécessaire à la création du menu.
	 * @see javax.servlet.jsp.tagext.TagSupport#doEndTag()
	 */
	public int doEndTag() throws JspException
	{
		HttpServletRequest request = (HttpServletRequest)pageContext.getRequest() ;
		HttpSession session = request.getSession(false) ;
  		String resultat="";
  		String requete;


		// L'utilisateur doit être authentifié.
		// dans le cas inverse, on provoque une exception.
		if (session == null)
		{
			throw new JspException("La session ne devrait pas être NULL") ;			
		}
		
		UserBip user = (UserBip)session.getAttribute("UserBip") ;
		
		if (user == null)
		{
			throw new JspException("L'utilisateur ne devrait pas être NULL") ;			
		}
		
		JspWriter out = pageContext.getOut() ;
		try
		{   
		    requete="select "+champ+" from "+table+" where "+clause1+" = '"+clause2+"'";
		    //Exécuter la requête
		    JDBCWrapper wrapper = new JDBCWrapper() ;
			try
			{
				wrapper.execute(requete) ;
				// Parcours des résultats de la requête
				wrapper.next();
				//while (wrapper.next())
				//{	
					resultat = wrapper.getString(1) ;
					
				//}
			
				out.print(resultat) ;
			}
			catch (BaseException be)
			{
				logBipUser.debug(be.toString());
			}

  		  	finally 
		{
		//			fermeture de la connexion
		wrapper.close();}
		   	
		  
		   	
		}
		catch (IOException ioe)
		{
			throw new JspException(ioe) ;	
		}
        catch (Exception e) 
        {
        	logBipUser.debug(e.toString());
        
        }
		return EVAL_PAGE ;
	}



	/**
	 * Returns the champ.
	 * @return String
	 */
	public String getChamp() {
		return champ;
	}

	/**
	 * Returns the clause1.
	 * @return String
	 */
	public String getClause1() {
		return clause1;
	}

	/**
	 * Returns the clause2.
	 * @return String
	 */
	public String getClause2() {
		return clause2;
	}

	/**
	 * Returns the table.
	 * @return String
	 */
	public String getTable() {
		return table;
	}

	
	/**
	 * Sets the champ.
	 * @param champ The champ to set
	 */
	public void setChamp(String champ) {
		this.champ = champ;
	}

	/**
	 * Sets the clause1.
	 * @param clause1 The clause1 to set
	 */
	public void setClause1(String clause1) {
		this.clause1 = clause1;
	}

	/**
	 * Sets the clause2.
	 * @param clause2 The clause2 to set
	 */
	public void setClause2(String clause2) {
		this.clause2 = clause2;
	}

	/**
	 * Sets the table.
	 * @param table The table to set
	 */
	public void setTable(String table) {
		this.table = table;
	}

}
