
package com.socgen.bip.action;

import java.util.Hashtable;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.action.AutomateAction;

/**
 * @author S.LALLIER - 07/01/2004
 *
 * Action d'affectation des SousTaches d'une ligne bip à une autre ligne bip
 * chemin : Saisie des réalisés/Paramétrage/Copier/coller Sous-tâche
 * pages  : fSoustachecopiercollerSr.jsp, mfSoustachecopiercollerSr.jsp
 * pl/sql : isac_copier_coller.sql, isac_copiercollerliste.sql
 */
public class CopierCollerSousTacheAction extends AutomateAction {
	    private static String PACK_SELECT_R = "copierCollerSousTache.consulter_r.proc";
		private static String PACK_SELECT = "copierCollerSousTache.consulter.proc";
		private static String PACK_INSERT = "copierCollerSousTache.creer.proc";
		private static String PACK_DELETE = "copierCollerSousTache.supprimer.proc";

		private String nomProc;
	

		/**
			* Action qui permet de passer à la page suivante
			*/
		protected ActionForward suite(
			ActionMapping mapping,
			ActionForm form,
			HttpServletRequest request,
			HttpServletResponse response,
			ActionErrors errors, 
			Hashtable hParamProc)
			throws ServletException {
			HttpSession session = request.getSession(false);
			
			String signatureMethode =
				"CopierCollerSousTacheAction-suite( mapping, form , request,  response,  errors )";
			logBipUser.entry(signatureMethode);	
			logBipUser.exit(signatureMethode);								
			return mapping.findForward("ecran");

		} //suite


		protected String recupererCle(String mode) {
			String cle = null;
			if (mode.equals("insert")) {
				cle = PACK_INSERT;
			} else if (mode.equals("delete")) {
				cle = PACK_DELETE;
			}
			return cle;
		}
}
