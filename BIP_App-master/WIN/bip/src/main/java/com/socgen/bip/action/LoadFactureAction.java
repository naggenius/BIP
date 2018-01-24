package com.socgen.bip.action;

import java.text.ParseException;
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
import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipIOException;
import com.socgen.bip.form.LoadFactureForm;
import com.socgen.bip.user.UserBip;
import com.socgen.bip.util.BipDateUtil;
import com.socgen.bip.util.BipNumberUtil;
import com.socgen.bip.util.BipStringUtil;
import com.socgen.bip.util.BipUtil;
import com.socgen.cap.fwk.exception.BaseException;
import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.upload.FormFile;

public class LoadFactureAction extends AutomateAction implements BipConstantes {

	static ResourceBundle myResources = ResourceBundle.getBundle("ApplicationResources", Locale.getDefault());
	private int ordreEnreg = 0;
	private int nbreLigneVide = 0;
	private int colonnePosition=-1;
	private int nbrelignes=0;
	private String codeErreur = "0";
	private String numCharg = null;
	private final String PACK_INSERT_FACTURE = "load_facture.creer.proc";
	private final String PACK_GET_NEW_NUM_CHARG = "recup.num.chargement.proc";
	private final String PACK_UPDATE_NBRE_ENREG  = "update.nbre.ligne.proc";

	protected ActionForward suite(ActionMapping mapping, ActionForm form,
								  HttpServletRequest request, HttpServletResponse response,
								  ActionErrors errors, Hashtable hParamProc) throws ServletException {
		return mapping.findForward("initial");
	}

	protected ActionForward creer(ActionMapping mapping, ActionForm form,
								HttpServletRequest request, HttpServletResponse response,
								ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		Vector vLignes = null;
		String ligne = "";
		String signatureMethode = "LoadFactureAction-creer( mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);
		LoadFactureForm uploadForm = (LoadFactureForm) form;
		FormFile fichier = uploadForm.getNomfichier();

		logBipUser.info("Fichier Table de ligne bip à charger : "	+ fichier.getFileName() + " : " + fichier.getContentType());
		try {
			vLignes = BipUtil.loadFile(fichier);
		} catch (BipIOException bie) {
			uploadForm.setMsgErreur(bie.getMessage());
			jdbc.closeJDBC(); return mapping.findForward("error");
		}
		if ((uploadForm.getMsgErreur() == null)	|| (uploadForm.getMsgErreur().length() == 0)) {
			String lLigne = null;
			int numLigne = 0;
			
			String userId = ((UserBip) request.getSession().getAttribute("UserBip")).getIdUser();
			nbrelignes=vLignes.size()-(int)1;
			numCharg = getNumCharg(hParamProc,fichier.getFileName(),userId,String.valueOf(nbrelignes));
			for (Enumeration ve = vLignes.elements(); ve.hasMoreElements();) {
				lLigne = (String) ve.nextElement();
				if (lLigne.startsWith(myResources.getString("demat.fact.load.chaineentete")))
					lLigne = (String) ve.nextElement();
				if (numCharg == null)
				{
					uploadForm.setMsgErreur(message);
					ordreEnreg = 0;
					nbreLigneVide=0;
					colonnePosition=-1;
					jdbc.closeJDBC(); 
					return mapping.findForward("initial");
				}else{
					StringBuffer[] ligneBuffer = validerLigne(lLigne);
					if (ligneBuffer[1] != null)
						codeErreur = ligneBuffer[1].toString();
					if(codeErreur.equalsIgnoreCase(myResources.getString("demat.fact.load.lignevide.continuer")))
					{
						nbreLigneVide++;
						logBipUser.debug("-->chaine vide:"+ ligne);
						logBipUser.debug("-->codeErreur envoyé:"+ codeErreur);
					}else{
						if ((codeErreur.equalsIgnoreCase("1"))||(ligneBuffer[0] == null))
						{
							uploadForm.setMsgErreur("Erreur de fichier: "+ lLigne);
							ordreEnreg = 0;
							nbreLigneVide=0;
							colonnePosition=-1;
							jdbc.closeJDBC(); 
							return mapping.findForward("initial");
						}
						ligne = numCharg + ";" + ligneBuffer[0].toString() ;
						logBipUser.debug("-->chaine envoyé:"+ ligne);
						logBipUser.debug("-->codeErreur envoyé:"+ codeErreur);
						try {
							jdbc.closeJDBC() ; 
						    jdbc = new JdbcBip();
							
							hParamProc.put("ligne", ligne);
							hParamProc.put("codeErreur", codeErreur);
							hParamProc.put("colonnePosition", Integer.toString(colonnePosition));
							hParamProc.put("user", userId);
							vParamOut = jdbc.getResult(	hParamProc, configProc, PACK_INSERT_FACTURE);
							message = (String) ((ParametreProc) vParamOut.elementAt(1))	.getValeur();
							
						jdbc.closeJDBC() ;
						} catch (BaseException be) {
							traceException( signatureMethode , be, jdbc);
							updateNumCharg(hParamProc,numCharg,String.valueOf(nbrelignes-nbreLigneVide));
							nbreLigneVide=0;
							
							return mapping.findForward("initial");
						} 
						if ((message != null) && (!message.equals(""))) {
							uploadForm.setMsgErreur(message);
							
							ordreEnreg = 0;
							colonnePosition=-1;
							break;
						}
						numLigne++;
						ordreEnreg++;
						codeErreur = "0";
						colonnePosition=-1;
					}
				}
			}
		}
		ordreEnreg = 0;
		codeErreur = "0";
		colonnePosition=-1;
		nbrelignes=nbrelignes-nbreLigneVide;
		logBipUser.exit(signatureMethode);
		updateNumCharg(hParamProc,numCharg,String.valueOf(nbrelignes));
		message = (String) ((ParametreProc) vParamOut.elementAt(1))	.getValeur();
		if ((message != null) && (!message.equals(""))) 
			uploadForm.setMsgErreur(message);
			
		jdbc.closeJDBC(); 
		numCharg = null;
		nbreLigneVide=0;
		return mapping.findForward("initial");
	}

	private StringBuffer[] validerLigne(String lLigne) {
		StringBuffer[] resultValidation = new StringBuffer[2];
		resultValidation[0] = null;
		resultValidation[1] = null;
		ArrayList st = BipStringUtil.getStringTokenized(lLigne, myResources.getString("demat.fact.load.separateur").charAt(0));
		if((st.isEmpty())||(st.size()==1))
		{
			resultValidation[1] = new StringBuffer(myResources.getString("demat.fact.load.lignevide.continuer"));
			resultValidation[0] = new StringBuffer(lLigne);
		}else{
			if ((st.size() <  Integer.parseInt(myResources.getString("demat.fact.load.nbreseparateur")) ))
			{
				resultValidation[1] = new StringBuffer("1");
				resultValidation[0] = new StringBuffer(lLigne);
			}else {
				StringTokenizer userAccepted = new StringTokenizer(myResources.getString("demat.fact.load.useraccepted"), ",");
				String user = st.get(0).toString().trim();
				boolean userOk = false;
				while (userAccepted.hasMoreTokens()) {
					if (user.equalsIgnoreCase(userAccepted.nextToken().trim()))
						userOk = true;
				}
				if (userOk) {
					if (user.equalsIgnoreCase(myResources.getString("demat.fact.load.user"))) {
						String ordre = st.get(2).toString().trim();
						if (!(ordreEnreg == (Integer.parseInt(ordre) - 1))) {
							ordreEnreg = 0;
							colonnePosition=2;
							resultValidation[1] = new StringBuffer(myResources.getString("demat.fact.load.101"));
						}
					}
				} else
					resultValidation[1] = new StringBuffer(myResources.getString("demat.fact.load.100"));
				resultValidation[0] = valideFormat(lLigne);
				if (resultValidation[1] == null)
					resultValidation[1] = new StringBuffer(codeErreur);
			}
		}
		return resultValidation;
	}

	private StringBuffer valideFormat(String lLigne) {
		ArrayList champs = BipStringUtil.getStringTokenized(lLigne,myResources.getString("demat.fact.load.separateur").charAt(0));
		ArrayList vectTypes = BipStringUtil.getStringTokenized(myResources.getString("demat.fact.load.typeligne"), myResources.getString("demat.fact.load.separateurtype").charAt(0)); 
		StringBuffer str = new StringBuffer();
		int j = 0;
		for (; j < champs.size(); j++) {
			if (j == Integer.parseInt(myResources.getString("demat.fact.load.position.nbprest")))
				str.append(myResources.getString("demat.fact.ligne.generer.presta")).append(myResources.getString("demat.fact.ligne.generer.separateur"));
			StringTokenizer stTypes = new StringTokenizer(vectTypes.get(j).toString(),myResources.getString("demat.fact.load.format.separateuroblig"));
			String types=null;
			int lgChamp=0;
			String obligatoire="";
			while (stTypes.hasMoreTokens())
			{
				types= stTypes.nextToken().toString().toUpperCase();
				if (!(types.equalsIgnoreCase(myResources.getString("demat.fact.load.ident.presta").toUpperCase()))){
					obligatoire= stTypes.nextToken().toString().toUpperCase();
					lgChamp= Integer.parseInt(stTypes.nextToken().toString());
				}
			}
			if (types.equalsIgnoreCase(myResources.getString("demat.fact.load.ident.presta").toUpperCase()))
			{
				for(int i = j+1; i<champs.size()-1; i++)
				{
					String s2=champs.get(i).toString();
					String s3=champs.get(i+1).toString();
					if(((s2==null) &&(s3==null))||((s2.trim().equalsIgnoreCase("")) &&(s3.trim().equalsIgnoreCase(""))))
					{
						i=i+1;
						break;
					}else{
						for(int k=i; k<i+3;k++)
						{
							StringTokenizer stTypes0 = new StringTokenizer(vectTypes.get(k).toString(),myResources.getString("demat.fact.load.format.separateuroblig"));
							types= stTypes0.nextToken().toString().toUpperCase();
							obligatoire= stTypes0.nextToken().toString().toUpperCase();
							lgChamp= Integer.parseInt(stTypes0.nextToken().toString());
							str.append(getValueChamp(champs.get(k-1).toString(),types,obligatoire,lgChamp, k-1));
						}
						i=i+2;
					}
				}
				j=champs.size()-1;
			}
			else
				str.append(getValueChamp(champs.get(j).toString(),types,obligatoire,lgChamp,j));
		}
		StringBuffer strFinal = new StringBuffer(BipStringUtil.replaceFirst(str
				.toString(),myResources.getString("demat.fact.ligne.generer.presta"), String.valueOf((j - 13) / 3)));
		champs = null;
		vectTypes = null;
		return strFinal;
	}
	private String getValueChamp(String champs,String types,String obligatoire,int lgChamp, int champPos)
	{
		String valChamp="";
		String vide= myResources.getString("demat.fact.load.champs.null")+myResources.getString("demat.fact.ligne.generer.separateur");
		if(obligatoire.equalsIgnoreCase(myResources.getString("obligatoire.value").toUpperCase()))
			valChamp= formatChamp(champs, types,lgChamp,champPos).toString();
		else
			{
				if(champs!=null)
					if((champs.trim().equals("")))
						valChamp=vide;
					else
						valChamp= formatChamp(champs, types,lgChamp,champPos).toString();
				else
					valChamp=vide;
			}
		return valChamp;
	}
	
	private String formatChamp(String valChamps, String type, int lgChamp, int champPos)
	{
        String value = "";
		if (valChamps.length()<=lgChamp)
		{
			if (type.equalsIgnoreCase(myResources.getString("demat.fact.load.champs.type.dateheure"))) {
				try {
					value= BipDateUtil.dateToString(BipDateUtil.parseDate(valChamps,myResources.getString("demat.fact.load.format.dateheure.init")),
											myResources.getString("demat.fact.load.format.dateheure.base"))+
											myResources.getString("demat.fact.ligne.generer.separateur");
				} catch (ParseException p) {
					codeErreur = myResources.getString("demat.fact.load.103");
					colonnePosition=champPos;
					return valChamps+myResources.getString("demat.fact.ligne.generer.separateur");
				}
			}
			if (type.equalsIgnoreCase(myResources.getString("demat.fact.load.champs.type.date"))) {
				try {
					value= BipDateUtil.dateToString(BipDateUtil.parseDate(valChamps,myResources.getString("demat.fact.load.format.date.init")),
										myResources.getString("demat.fact.load.format.date.base"))
										+myResources.getString("demat.fact.ligne.generer.separateur");
				} catch (ParseException p) {
					codeErreur = myResources.getString("demat.fact.load.103");
					colonnePosition=champPos;
					return valChamps+myResources.getString("demat.fact.ligne.generer.separateur");
				}	
			}
			if (type.equalsIgnoreCase(myResources.getString("demat.fact.load.champs.type.moisannee")))
				if (valChamps!= null) {
					try {
						value= BipDateUtil.dateToString(BipDateUtil.parseDate(valChamps,myResources.getString("demat.fact.load.format.date.moisannee.init")),
								myResources.getString("demat.fact.load.format.date.moisannee.base"))
								+myResources.getString("demat.fact.ligne.generer.separateur");
					} catch (ParseException p) {
						codeErreur = myResources.getString("demat.fact.load.103");
						colonnePosition=champPos;
						return valChamps+myResources.getString("demat.fact.ligne.generer.separateur");
					}
				}
			if (type.equalsIgnoreCase(myResources.getString("demat.fact.load.champs.type.number"))) {
				try {
					return Integer.parseInt(valChamps)+ myResources.getString("demat.fact.ligne.generer.separateur");
				} catch (NumberFormatException n) {
					codeErreur = myResources.getString("demat.fact.load.104");
					colonnePosition=champPos;
					return valChamps+myResources.getString("demat.fact.ligne.generer.separateur");
				}
			}	
			if (type.equalsIgnoreCase(myResources.getString("demat.fact.load.champs.type.double"))) {
				try {
					value= BipNumberUtil.getPoint( Double.parseDouble(BipNumberUtil.setPoint(valChamps)))
					+myResources.getString("demat.fact.ligne.generer.separateur");
				} catch (NumberFormatException n) {
					codeErreur =myResources.getString("demat.fact.load.104");
					colonnePosition=champPos;
					return valChamps+myResources.getString("demat.fact.ligne.generer.separateur");
				}
			}
			if (type.equalsIgnoreCase(myResources.getString("demat.fact.load.champs.type.alpha")))
				if (!(valChamps.equalsIgnoreCase("")))
					value= String.valueOf(valChamps.toCharArray())+ myResources.getString("demat.fact.ligne.generer.separateur");
				else
				{
					codeErreur =myResources.getString("demat.fact.load.105");
					colonnePosition=champPos;
					return valChamps+myResources.getString("demat.fact.ligne.generer.separateur");
				}
		}else
		{
			codeErreur = myResources.getString("demat.fact.load.106");	
			colonnePosition=champPos;
			value= valChamps.substring(0,lgChamp)+myResources.getString("demat.fact.ligne.generer.separateur");
		}	
		return value;
	}
	private String getNumCharg(Hashtable hParamProc, String fichier,String userId, String nbrelignes) {
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String signatureMethode = "LoadFactureAction-getNumCharg( hParamProc )";
		String numCharg = "";
		try {
			
			hParamProc.put("fichier", fichier);
			hParamProc.put("nbreenreg", nbrelignes);
			hParamProc.put("userid", userId);
			vParamOut = jdbc.getResult(	hParamProc, configProc, PACK_GET_NEW_NUM_CHARG);
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				ParametreProc paramOut = (ParametreProc) e.nextElement();
				if (paramOut.getNom().equals("numcharg"))
					numCharg = (String) paramOut.getValeur();
			}
			jdbc.closeJDBC(); 
			return numCharg;
		} catch (BaseException be) {
			traceException( signatureMethode , be, jdbc);
			return null;
		}
	}
	
	private void updateNumCharg(Hashtable hParamProc, String numCharg, String nbreLignes) {
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String signatureMethode = "LoadFactureAction-updateNumCharg( hParamProc )";

		try {
			hParamProc.put("nbrelignes", nbreLignes);
			hParamProc.put("numcharg", numCharg);
			vParamOut = jdbc.getResult(	hParamProc, configProc, PACK_UPDATE_NBRE_ENREG);
			
			jdbc.closeJDBC(); 
		} catch (BaseException be) {
			traceException( signatureMethode , be, jdbc);
			
		}
	}
	private void traceException(String signatureMethode ,BaseException be, JdbcBip jdbc)
	{
		logBipUser.debug(signatureMethode + " --> BaseException :" + be);
		logBipUser.debug(signatureMethode + " --> Exception :"+ be.getInitialException().getMessage());
		logService.debug(signatureMethode + " --> BaseException :" + be);
		logService.debug(signatureMethode + " --> Exception :"+ be.getInitialException().getMessage());
		errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
		ordreEnreg = 0;
		if(jdbc!=null)
			jdbc.closeJDBC(); 
	}
}
