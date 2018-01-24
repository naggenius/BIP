
package com.socgen.bip.commun;

import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

/**
 * @author DDI 14/06/2006
 * Action : Cette action �tends ActionMapping. Elle est utilis�e gr�ce � la d�finition dans "web.xml" 
 *          du "mapping" sur cette classe. 
 */
public class BIPActionMapping extends ActionMapping {
	/**
	* Action qui surcharge l'action mapping.findForward("string")
	*/
	public ActionForward findForward(String ecran){
		//Fermeture de la connexion JDBC
		//jdbc.closeJDBC();		
		
		//Redirection sur le findForward de ActionMapping
		return super.findForward(ecran);
	}
}