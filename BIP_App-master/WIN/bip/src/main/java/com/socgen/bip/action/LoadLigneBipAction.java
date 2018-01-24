package com.socgen.bip.action;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Locale;
import java.util.ResourceBundle;
import java.util.StringTokenizer;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.upload.FormFile;

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.exception.BipIOException;
import com.socgen.bip.form.LoadLigneBipForm;
import com.socgen.bip.util.BipStringUtil;
import com.socgen.bip.util.BipUtil;
import com.socgen.cap.fwk.exception.BaseException;

public class LoadLigneBipAction extends AutomateAction implements BipConstantes {
	static ResourceBundle myResources = ResourceBundle.getBundle("ApplicationResources", Locale.getDefault());
	private static String PACK_INSERT_LIGNE_BIP = "load_ligne_bip.creer.proc";
	
	protected ActionForward suite(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		return mapping.findForward("initial");

	} // suite

	protected ActionForward creer(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip();
		Vector vParamOut = new Vector();
		String message = "";
		boolean fileHasError = false;
		boolean fileHasOnlyInfo = false;
		String signatureMethode = "LoadLigneBipAction-creer( mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);

		LoadLigneBipForm uploadForm = (LoadLigneBipForm) form;
		FormFile fichier = uploadForm.getNomfichier();
		Vector vLignes = null;
		String pidDebut = "";
		String pidFin = "";
		logBipUser.info("Fichier Table de ligne bip à charger : "+ fichier.getFileName() + " : " + fichier.getContentType());
		try{
			 vLignes = BipUtil.loadFile(fichier);
		}catch(BipIOException bie)
		{
			uploadForm.setMsgErreur(bie.getMessage());
		}

		if ((uploadForm.getMsgErreur() == null)
				|| (uploadForm.getMsgErreur().length() == 0)) {

			String lLigne = null;
			int numLigne = 0;
			int numEnreg = 1;
			boolean hasErreur = false;
			boolean hasInfo = false;
			Vector msgErreur = null;
			int retour_insert = 0;

			for (Enumeration ve = vLignes.elements(); ve.hasMoreElements();) {
				if (hasInfo)
				{
					((LoadLigneBipForm) form).setMsgErreur("Erreur de format de fichier");
					jdbc.closeJDBC();
					return mapping.findForward("initial");
				}
				if (hasErreur ){
					((LoadLigneBipForm) form).setMsgErreur("Erreur de format de fichier");
					jdbc.closeJDBC(); 
					return mapping.findForward("initial");
				}
				numLigne++;
				lLigne = (String) ve.nextElement();
				hasErreur = false;
				hasInfo = false;
				msgErreur = new Vector();
				String SEPARATEUR = myResources.getString("lignebip.load.separateur");
				int pos = lLigne.indexOf(SEPARATEUR);
				if (pos == -1) {
					hasErreur = true;
					continue;
				} else {
					ArrayList st = BipStringUtil.getStringTokenized(lLigne,SEPARATEUR.charAt(0));
					if (!(st.size() == Integer.parseInt(myResources.getString("lignebip.load.nbreseparateur")))) {
						hasErreur = true;
						continue;
					} else {
						int i=1;
						ArrayList vectTypes = BipStringUtil.getStringTokenized(myResources.getString("lignebip.load.listechamp"),SEPARATEUR.charAt(0)); 
						for(int j=0; j< vectTypes.size(); j++)
						{
							StringTokenizer stChamp = new StringTokenizer(vectTypes.get(j).toString(),myResources.getString("lignebip.load.listechamp.separateur"));
							String champ=stChamp.nextToken().toString();
							String obligatoire=stChamp.nextToken().toString().toUpperCase();
							while (stChamp.hasMoreTokens())
							{
								if (obligatoire.equalsIgnoreCase(myResources.getString("obligatoire.value").toUpperCase()))
								{
									if (st.get(i).toString().trim().equalsIgnoreCase("")) {
										hasErreur = true;
										continue;
									} else 
										hParamProc.put(champ, st.get(i).toString().trim());
								}
								else
									hParamProc.put(champ, st.get(i).toString().trim());
								i++;
							}
						}
					}
				}
				if (!hasErreur) {
					try {
						vParamOut = jdbc.getResult(hParamProc, configProc, PACK_INSERT_LIGNE_BIP);
						try {
							message = jdbc.recupererResult(vParamOut,"valider");
							if (numEnreg == 1)
								pidDebut = (String) ((ParametreProc) vParamOut.elementAt(1)).getValeur();
							else
								pidFin = (String) ((ParametreProc) vParamOut.elementAt(1)).getValeur();
						} catch (BaseException be) {
							logBipUser.debug(signatureMethode+ " --> BaseException :" + be);
							logBipUser.debug(signatureMethode+ " --> Exception :"+ be.getInitialException().getMessage());
							logService.debug(signatureMethode+ " --> BaseException :" + be);
							logService.debug(signatureMethode+ " --> Exception :"+ be.getInitialException().getMessage());
							errors.add(ActionErrors.GLOBAL_ERROR,	new ActionError("11217"));
							jdbc.closeJDBC(); 
							return mapping.findForward("error");
						}
						if ((message != null) && (!message.equals(""))) {
							msgErreur.add(message);
							hasErreur = true;
						}
					} catch (BaseException be) {
						logBipUser.debug(signatureMethode+ " --> BaseException :" + be);
						logBipUser.debug(signatureMethode + " --> Exception :"+ be.getInitialException().getMessage());
						logService.debug(signatureMethode+ " --> BaseException :" + be);
						logService.debug(signatureMethode + " --> Exception :"	+ be.getInitialException().getMessage());
						if (retour_insert == 2){
							jdbc.closeJDBC(); 
							return mapping.findForward("error");}

						if (be.getInitialException().getClass().getName()
								.equals("java.sql.SQLException")) {
							message = BipException.getMessageFocus(BipException.getMessageOracle(be.getInitialException().getMessage()), form);
							((LoadLigneBipForm) form).setMsgErreur(message.replace('\n', ' '));
							jdbc.closeJDBC();
							return mapping.findForward("initial");
						} else {
							errors.add(ActionErrors.GLOBAL_ERROR,new ActionError("11201"));
							request.setAttribute("messageErreur", be.getInitialException().getMessage());
							jdbc.closeJDBC(); return mapping.findForward("error");
						}
					}
				} 
				else 
					fileHasError = true;
								
				if (hasInfo){
					((LoadLigneBipForm) form).setMsgErreur("Erreur de format de fichier");
					jdbc.closeJDBC(); 
					return mapping.findForward("initial");
				}
				if (hasErreur){
					((LoadLigneBipForm) form).setMsgErreur("Erreur de format de fichier");
					jdbc.closeJDBC(); 
					return mapping.findForward("error");
				}
				hasErreur = false;
				hasInfo = false;
			}
		}
		if (fileHasError) {
			uploadForm.setMsgErreur("Le chargement a généré des erreurs.\\nVeuillez consulter le rapport.");
			jdbc.closeJDBC();
			return mapping.findForward("error");
		} else {
			if (fileHasOnlyInfo) {
				uploadForm.setMsgErreur("Le chargement a généré des remarques.\\nVeuillez consulter le rapport.");
				jdbc.closeJDBC();
				return mapping.findForward("initial");
			}
		}
		String msg = "Vous avez chargé ";
		if (pidFin == "")
			msg = msg + " la ligne BIP : " + pidDebut;
		else
			msg = msg + "les lignes BIP de " + pidDebut + " à " + pidFin;
		uploadForm.setMsgErreur(msg);
		logBipUser.exit(signatureMethode);
		jdbc.closeJDBC(); return mapping.findForward("initial");
	} // creer
}
