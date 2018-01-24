package com.socgen.bip.action;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Locale;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

//FIXME DHA NOT USED
//import weblogic.xml.xpath.common.functions.SubstringAfterFunction;

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.action.AutomateAction;

import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.RecupLienDocForm;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.ich.ihm.menu.PaginationVector;

/**
 * @author S.GARCIA - 12/11/2012
 * 
 * Formulaire pour la récupération du lien documentaire :
 * Responsable d'étude/Outils/documentation pages : recupLienDoc.jsp
 * pl/sql : pack_url_doc.sql
 */
public class RecupLienDocAction extends AutomateAction implements BipConstantes{
	
	private static String PACK_SELECT_LIENDOC = "recupliendoc.valeur.LienDoc.proc";

	
	
	/**
	 * Constructor for RecupLienDocAction.
	 */
	public RecupLienDocAction() {
		super();
	}
	
	/**
	 * Action permettant le premier appel de la JSP
	 */
	public ActionForward initialiser(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		RecupLienDocForm recupLienDocForm = (RecupLienDocForm) form;
		Vector vParamOut = new Vector();
		


		// On exécute la procédure PL/SQL qui ramène les résultats pour le
		// tableau
		try {
			
			hParamProc.put("nomRecherche","");
			vParamOut = jdbc.getResult(hParamProc, configProc, PACK_SELECT_LIENDOC);
			recupLienDocForm.setLiendoc((String) ((ParametreProc) vParamOut
					.elementAt(0)).getValeur());
			recupLienDocForm.setMsgErreur((String) ((ParametreProc) vParamOut
					.elementAt(1)).getValeur());

		} catch (BaseException be) {
			logBipUser.debug(this.getClass().getName() + "-creer() --> BaseException :" + be);
			logBipUser.debug(this.getClass().getName() + "-creer() --> Exception :" + be.getInitialException().getMessage());
			logService.debug(this.getClass().getName() + "-creer() --> BaseException :" + be);
			logService.debug(this.getClass().getName() + "-creer() --> Exception :" + be.getInitialException().getMessage());
			//Erreur de lecture du resultSet
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
			//this.saveErrors(request,errors);
			 jdbc.closeJDBC(); return mapping.findForward("error");
		}
		
        jdbc.closeJDBC();return mapping.findForward("ecran");
	} // initialiser
}
