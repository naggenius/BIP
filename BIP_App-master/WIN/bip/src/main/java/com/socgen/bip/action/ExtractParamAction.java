package com.socgen.bip.action;

import java.util.Date;
import java.util.Enumeration;
import java.util.Hashtable;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.db.ExtractParamDb;
import com.socgen.bip.form.ExtractParamForm;
import com.socgen.bip.metier.ExtractParamManager;
import com.socgen.bip.metier.FiltreRequete;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author N.BACCAM - 01/09/2003
 *
 * Action qui gère les extractions paramétrées
 */
public class ExtractParamAction extends AutomateAction {
	private String sNomFichier;
	private Hashtable hFiltre;

	/**
	* Action qui permet de passer à la page de filtre
	*/
	protected ActionForward suite(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response,
		ActionErrors errors, Hashtable hParamProc)
		throws ServletException {
		String sColonne;
		String sNbData;

		String signatureMethode =
			"ExtractParamAction-suite( mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);

		ExtractParamDb db = new ExtractParamDb();
		ExtractParamForm extractParamForm = (ExtractParamForm) form;
		sNomFichier = extractParamForm.getNomFichier();
		try {
			hFiltre = db.getDataFiltre(sNomFichier);
			extractParamForm.setFiltre(hFiltre);
			sColonne = (String)db.getDataColonne(sNomFichier).get(0);
			sNbData = (String)db.getDataColonne(sNomFichier).get(1);
			extractParamForm.setData(sColonne);
			extractParamForm.setNbData(sNbData);

		} catch (BaseException be) {

			logService.debug(
				"suite() --> Exception :"
					+ be.getInitialException().getMessage());
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
			return mapping.findForward("error");
		}

		logBipUser.exit(signatureMethode);
		return mapping.findForward("suite");
	}

	/**
	* Action qui permet de passer à la page qui va lancer l'extraction
	*/
	protected ActionForward consulter(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response,
		ActionErrors errors, Hashtable hParamProc)
		throws ServletException {
		FiltreRequete filtre;
		String champ;
		String sql = "";
		String sType;
		String sText;
		String sPartie1;
		String sPartie2;
		String sPartie3;
		String sHabilitation;

		int position1;
		int position2;
		int position3;
		int position4;
		String signatureMethode =
			"ExtractParamAction-consulter( mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);

		//HttpSession session = request.getSession(false);

		/**
		 * Construction de la partie filtre de la requête
		 */
		try {
			ExtractParamForm extractParamForm = (ExtractParamForm) form;
			sNomFichier = extractParamForm.getNomFichier();
			
			ExtractParamDb db = new ExtractParamDb();
			if (hFiltre != null) {
				
				//Récupérer le nom des champs dans la hashtable
				for (Enumeration e = hFiltre.elements();
					e.hasMoreElements();
					) {
					filtre = (FiltreRequete) e.nextElement();
					champ = filtre.getCode();
					sType = filtre.getType();
					sText = filtre.getTextSql();
					logBipUser.debug("champ:" + champ);
					logBipUser.debug("stype:" + sType);
					logBipUser.debug("stxt:" + sText);
				
					

					if (sType.endsWith("2")) {
						if ((request.getParameter(champ + "_part1") != null)
							&& (!request
								.getParameter(champ + "_part1")
								.equals(""))) {
							//logBipUser.debug("champ2:" + champ);
							sText =
								db.getClause2(
									sText,
									request.getParameter(champ+ "_part1"),
									request.getParameter(champ+ "_part2"));
							
							logBipUser.debug("sText1:" + sText);
							if (sql.equals("")) {
								sql = sql + sText;
							} else {
								sql = sql + " AND " + sText;
							}

						}
					} else if (sType.endsWith("21")){//cas ou on a un champ mais 2 valeur dans la clause
						if ((request.getParameter(champ) != null)
							&& (!request.getParameter(champ).equals(""))) {
							//logBipUser.debug("champ:" + champ);
							//On constitue la partie filtre de la requête
							
							sText =
								db.getClause2(
									sText,
									request.getParameter(champ),
									request.getParameter(champ));
							logBipUser.debug("sText2:" + sText);
							if (sql.equals("")) {
								sql = sql + sText;
							} else {
								sql = sql + " AND " + sText;
							}

						}
						
					} else {
						if ((request.getParameter(champ) != null)
							&& (!request.getParameter(champ).equals(""))) {
							//logBipUser.debug("champ:" + champ);
							//On constitue la partie filtre de la requête
							logBipUser.debug("valeur du champ" + request.getParameter(champ));
							if (!sType.equals("RADIO"))
							{
								sText =
								db.getClause(
									sText,
									request.getParameter(champ));
							logBipUser.debug("sText31:" + sText);
							}
							
							if (sType.equals("RADIO"))
							{
								if (request.getParameter(champ).equals("1"))
									if (sql.equals("")) {
										sql = sql + sText;
									} else {
										sql = sql + " AND " + sText;
									}
							}
							else
						
								if (sql.equals("")) {
									sql = sql + sText;
								} else {
									sql = sql + " AND " + sText;
								}
							
							

						}

					} //if

				} //for
			} //if
			
			sHabilitation=db.getDataHab(sNomFichier, userBip);
			
			//récupérer le filtre habilitation
			if (sql.equals("")) {
				sql =  sHabilitation;
			}
			else
				if (!sHabilitation.equals(""))
					sql = sql +" AND " + sHabilitation;
			
			 logBipUser.debug("sHabilitation" + sHabilitation);
			logBipUser.debug("WHERE:" + sql);
			//On sauvegarde cette partie de requete dans le formulaire
			extractParamForm.setFiltreSql(sql);

		} catch (BaseException be) {

			logService.debug(
				"consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
			return mapping.findForward("error");
		}

		logBipUser.exit(signatureMethode);
		return mapping.findForward("ecran");

	}

	/**
		* Action qui permet de générer une extraction paramétrée
		*/
	protected ActionForward creer(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response,
		ActionErrors errors, Hashtable hParamProc)
		throws ServletException {

		String sNomFichier;
		Date dDate = new Date();

		String signatureMethode =
			"ExtractParamAction-creer( mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);

		ExtractParamForm extractParamForm = (ExtractParamForm) form;
		sNomFichier = extractParamForm.getNomFichier();
		
        extractParamForm.setDate(dDate);
        
        //Entête : oui ou non?
        if (request.getParameter("enTete").equals("true")) {
        	extractParamForm.setEnTete(true);
        }
        else 
        	extractParamForm.setEnTete(false);
    
		ExtractParamManager extractParamManager = new ExtractParamManager();
		//Lancement de l'extraction
		extractParamManager.launchExtract(extractParamForm,userBip );

		logBipUser.exit(signatureMethode);

		return mapping.findForward("async");

	} //suite

}
