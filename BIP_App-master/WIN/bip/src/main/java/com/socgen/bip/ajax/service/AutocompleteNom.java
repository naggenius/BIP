package com.socgen.bip.ajax.service;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;

import com.socgen.bip.ajax.attributListe.AutocompleteAttribut;
import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.log4j.BipUsersAppender;
import com.socgen.bip.user.UserBip;
import com.socgen.cap.fwk.ServiceManager;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.cap.fwk.log.Log;

public class AutocompleteNom extends AutomateAction {
	
	private static String PACK_SELECT = "recup.id.nomAjax.proc";

	
	protected UserBip userBip;
	protected static final String sLogCat = "BipUser";
	protected static Log logBipUser = ServiceManager.getInstance().getLogManager().getLogInstance(sLogCat);
	
	public List<AutocompleteAttribut> RecupListe(String name,
			HttpServletRequest request, HttpServletResponse response
			) throws ServletException {
	
				
		HttpSession session;
		String sParameterName;
		String sParameterValue;
		String sInfosUser;	
	    Hashtable hParams;
	    session = request.getSession(false);
		
			
		userBip = (UserBip)session.getAttribute("UserBip");		
		BipUsersAppender.setUserId(userBip.getIdUser());
		List<AutocompleteAttribut> vListe = new ArrayList<AutocompleteAttribut>();
		
		
						
		if (name == null)
			return vListe;
		
		
		//Initialisation de la table de hash contenant les données dans le Form
		hParams = new Hashtable();
				
		// on récupère les paramètres passés dans la page 
		for (Enumeration e=request.getParameterNames();e.hasMoreElements();) {
			sParameterName= (String)e.nextElement();
			sParameterValue = request.getParameter(sParameterName);
			// PPR le 13/09 - J'enlève les multiples traces pour alléger la log
			//logBipUser.info("Parms :"+" ("+sParameterName+","+sParameterValue+")") ;
			hParams.put(sParameterName,sParameterValue);

		}
		//on rajoute les informations sur l'utilisateur dans les hashTables hParamProc et  hParamKeyList
		//Récupérer la chaîne d'info sur l'utilisateur à partir du Bean UserBip
		sInfosUser=userBip.getInfosUser();	
		hParams.put("userid",sInfosUser);					
					
					
		JdbcBip jdbc = new JdbcBip(); 
		
		Vector vParamOut = new Vector();
	
		ParametreProc paramOut;
		String signatureMethode = this.getClass().getName()
				+ " - consulter(paramProc, mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);
		logBipUser.debug(signatureMethode);
	
		
		int compteur = 0;
		
	   // On exécute la procédure PL/SQL qui ramène les résultats pour le
		// tableau
		try {
			hParams.put("nomRecherche",name);	
			vParamOut = jdbc.getResult(hParams,
					configProc, PACK_SELECT);
			// Récupération des résultats
			
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();
				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();
					try {
						
						while (rset.next()) {
							// On alimente le Bean Propose et on le stocke dans
							// un vector							
							vListe.add(compteur,new AutocompleteAttribut(rset.getString(1), 
									rset.getString(2)));
							compteur++;
						}
						if (rset != null)
							rset.close();
				
					}// try
					catch (SQLException sqle) {
						
						 jdbc.closeJDBC(); 
						 return vListe;
						
					}
				}// if
			}// for
			
		}// try
		catch (BaseException be) {
			
			logBipUser.exit(signatureMethode);
			 jdbc.closeJDBC(); 
						 return vListe;
			 

		}
		logBipUser.exit(signatureMethode);
		
		jdbc.closeJDBC(); 
		logBipUser.debug("affichage Liste"+vListe);
		
		return vListe;
	}// consulter

}
