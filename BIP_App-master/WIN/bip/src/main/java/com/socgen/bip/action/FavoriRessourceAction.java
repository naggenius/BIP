package com.socgen.bip.action;

import java.lang.reflect.InvocationTargetException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.List;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.BudCopiMasseForm;
import com.socgen.bip.form.FavoriRessourceForm;
import com.socgen.bip.form.SaisieConsoForm;
import com.socgen.bip.metier.BudCopiMasse;
import com.socgen.bip.metier.FavoriRessource;
import com.socgen.cap.fwk.exception.BaseException;

public class FavoriRessourceAction extends AutomateAction implements BipConstantes{
	
	private static String PACK_SELECT = "favori.consulter.proc";
	
	private static String PACK_INSERT = "favori.insert.proc";
	
	private static String PACK_INIT = "favori.init.proc";
	
	
	
	/**
	 * Méthode consulter : Affichage des données des ressources favorites 
	 */
	public ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		Vector vParamOut3 = new Vector();
		String message = "";
		ParametreProc paramOut;
		List<FavoriRessource> vListe = new ArrayList<FavoriRessource>();
		JdbcBip jdbc = new JdbcBip(); 
		
		hParamProc.put("userid", userBip.getInfosUser());
		
		String signatureMethode = "FavoriRessourceAction-consulter()";
		logBipUser.entry(signatureMethode);
		logBipUser
				.debug("fmemory start : " + Runtime.getRuntime().freeMemory());
		
		// Création d'une nouvelle form
		FavoriRessourceForm bipForm = (FavoriRessourceForm) form;

		if (hParamProc == null) {
			logBipUser.debug("SaisieConso-consulter-->hParamProc is null");
		}
		
		// ******* exécute la procédure PL/SQL qui ramène les résultats pour le
		// tableau
		try {
			vParamOut3 = // (new
							// JdbcBip()).getResult(hParamProc,
			jdbc.getResult(hParamProc,
					configProc, PACK_SELECT);
			// pas besoin d'aller plus loin
			if (vParamOut3 == null) {
				logBipUser
						.debug("FavoriRessourceAction-consulter(tableau) :!!! cancel forward ");
				logBipUser.exit(signatureMethode);
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
			// Récupération des résultats
			for (Enumeration e = vParamOut3.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();
				
				// récupérer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();
					bipForm.setMsgErreur(message);
				}

				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();
					try {
						while (rset.next()) {
														
							vListe.add(new FavoriRessource(rset.getString(1),
									rset.getString(2),
									rset.getString(3),
									rset.getString(4),
									rset.getString(5),
									rset.getString(6)
									));							
						}
						
						if (rset != null)
						{
							rset.close();
							rset = null;
						}																		
						
					} // try
					catch (SQLException sqle) {
						logService
								.debug("FavoriRessourceAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("FavoriRessourceAction-consulter() --> SQLException :"
										+ sqle);
						// Erreur de lecture du resultSet
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11217"));
						 jdbc.closeJDBC(); return mapping.findForward("error");
					}
				} // if
			} // for
		} // try
		catch (BaseException be) {
			logBipUser.debug(
					"FavoriRessourceAction-consulter() --> BaseException :" + be,
					be);
			logBipUser.debug("FavoriRessourceAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug(
					"FavoriRessourceAction-consulter() --> BaseException :" + be,
					be);
			logService.debug("FavoriRessourceAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((BudCopiMasseForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}

		logBipUser
				.debug("fmemory end   : " + Runtime.getRuntime().freeMemory());
		logBipUser.exit(signatureMethode);
		 jdbc.closeJDBC(); 
		 bipForm.setListeFavori(vListe);
		 return mapping.findForward("ecran");
		 
	}
	
	protected ActionForward valider(ActionMapping mapping, ActionForm form,
			String mode, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors,
			Hashtable hParamProc) throws ServletException {
		
			HttpSession session = request.getSession(false);
		
			String signatureMethode = "favoriRessourceAction.valider(ActionMapping mapping, ActionForm form,String mode, HttpServletRequest request,HttpServletResponse response, ActionErrors errors,			Hashtable hParamProc )";
			logBipUser.entry(signatureMethode);
			 
			JdbcBip jdbc = new JdbcBip(); 
			Vector vParamOut = new Vector();
			String message = "";
						
			FavoriRessourceForm bipForm = (FavoriRessourceForm) form;	
			
			// on exécute la procedure PLSQL qui insert les ressources favorites
			try {
				
				// On supprime la position de l 'indexe dans la liste deroulante
				// car les valeurs vont changer
				if ( "2".equals(session.getAttribute("CHOIXRESS")) ) {
					request.getSession().removeAttribute("POSITION");
						request.getSession().removeAttribute("IDENT");
				}
				
				hParamProc.put("idarpege", userBip.getIdUser() );
				vParamOut = jdbc.getResult(
						hParamProc, configProc, PACK_INIT);
				
				for (FavoriRessource fav:bipForm.getListeFavori()) {
					if ( "1".equals(fav.getFavori()) ) {
						
						hParamProc.put("ident", fav.getIdent() );
						
						JdbcBip jdbc2 = new JdbcBip();
						vParamOut = jdbc2.getResult(
								hParamProc, configProc, PACK_INSERT);
						
						for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
							ParametreProc paramOut = (ParametreProc) e.nextElement();
							if (paramOut.getNom().equals("message")) {
								message = (String) paramOut.getValeur();
								bipForm.setMsgErreur(message);
							}
						}
						jdbc2.closeJDBC();
					}
				}
				
			} // try
			catch (BaseException be) {
				logBipUser.debug(
						"SaisieConsoAction-consulter() --> BaseException :"
								+ be, be);
				logBipUser
						.debug("SaisieConsoAction-consulter() --> Exception :"
								+ be.getInitialException().getMessage());
				logService.debug(
						"SaisieConsoAction-consulter() --> BaseException :"
								+ be, be);
				logService
						.debug("SaisieConsoAction-consulter() --> Exception :"
								+ be.getInitialException().getMessage());
				if (be.getInitialException().getClass().getName().equals(
						"java.sql.SQLException")) {
					message = BipException.getMessageFocus(BipException
							.getMessageOracle(be.getInitialException()
									.getMessage()), form);
					((SaisieConsoForm) form).setMsgErreur(message);
					 jdbc.closeJDBC(); return mapping.findForward("ecran");
				} else {
					// Erreur d''exécution de la procédure stockée
					errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
							"11201"));
					request.setAttribute("messageErreur", be
							.getInitialException().getMessage());
					 jdbc.closeJDBC(); return mapping.findForward("error");
				}
			}
		
			jdbc.closeJDBC(); 
			return mapping.findForward("initial");

	}
	
	
}
