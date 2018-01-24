package com.socgen.bip.action;

import java.util.Hashtable;
import java.util.Random;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.ContratRFForm;
import com.socgen.bip.user.UserBip;
import com.socgen.cap.fwk.exception.BaseException;


public class ContratRFAction extends AutomateAction {


	private static String PACK_CONTRATRF_INSERT = "contratrf.insert.proc";

	private String nomProc;
	
	private boolean PERIM_ME = false ;
	
	protected ActionForward initialiser(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		logBipUser.debug("(ContratRFAction) (initialiser) => debut ");
		return mapping.findForward("initial");
	}

	/**
	 * Action qui permet de valider
	 */
	protected ActionForward valider(ActionMapping mapping, ActionForm form,
			String mode, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors,
			Hashtable hParamProc) throws ServletException {
		logBipUser.debug("(ContratRFAction) (valider) => debut ");
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();

		String critereDosPac = "";
		String critereRefCon = "";
		String critereRefAve = "";
		String critereNom = "";
		String critereIgg = "";
		String critereMatArp = "";
		String critereIdenBip = "";
		String critereRefFac = "";
		String critereRefExp = "";
		String champsDosPac = "";
		String champsRefCon = "";
		String champsRefAve = "";
		String champsNom = "";
		String champsIgg1 = "";
		String champsIgg2 = "";
		String champsMatArp1 = "";
		String champsMatArp2 = "";
		String champsIdenBip = "";
		String champsRefFac = "";
		String champsRefExp = "";
		String champsRacine = "";
		String champsAvenant = "";
		String userid = "";
		
		String cle = null;
		String message = null;
		
		String centre_frais = "" ;
		String req_centre_frais = "" ;
		String req_dpg_perim_me = "" ;
		
		String signatureMethode = "valider(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors )";
		logBipUser.entry(signatureMethode);

		ContratRFForm bipForm = (ContratRFForm) form;

		UserBip user = (UserBip) request.getSession().getAttribute("UserBip");
		
		logBipUser.debug("(ContratRFAction) (valider) => request.getParameter(arborescence) =" + request.getParameter("arborescence"));
		if (request.getParameter("arborescence").startsWith("Responsable")) {
			PERIM_ME = true;
			req_dpg_perim_me = "AND contrat.codsg in (SELECT codsg FROM vue_dpg_perime where INSTR('"+user.getPerim_ME()+"', codbddpg) > 0) "  ;			
		}
		else if (request.getParameter("arborescence").startsWith("Ordonnancement")) {
			PERIM_ME = false;
			centre_frais = user.getListe_Centres_Frais() ; 
			if (!centre_frais.equals("0") && !centre_frais.equals(""))
				req_centre_frais = "AND contrat.CCENTREFRAIS in (" + centre_frais + ") "; // KRA - QC 1677 : centre frais est de type numérique (pas de '')
		}
		
		
		logBipUser.debug("(ContratRFAction) (valider) => PERIM_ME =" + PERIM_ME);
		
		
		critereDosPac = bipForm.getCritereDosPac() ;
		critereRefCon = bipForm.getCritereRefCon() ;
		critereRefAve = bipForm.getCritereRefAve();
		critereNom = bipForm.getCritereNom();
		critereIgg = bipForm.getCritereIgg();
		critereMatArp = bipForm.getCritereMatArp();
		critereIdenBip = bipForm.getCritereIdenBip();
		critereRefFac = bipForm.getCritereRefFac();
		critereRefExp = bipForm.getCritereRefExp();
		if (bipForm.getChampsDosPac() != null && !bipForm.getChampsDosPac().isEmpty()) champsDosPac = bipForm.getChampsDosPac().toUpperCase();
		if (bipForm.getChampsRefCon() != null && !bipForm.getChampsRefCon().isEmpty()) champsRefCon = bipForm.getChampsRefCon().toUpperCase();
		if (bipForm.getChampsRefAve() != null && !bipForm.getChampsRefAve().isEmpty()) champsRefAve = bipForm.getChampsRefAve().toUpperCase();
		if (bipForm.getChampsNom() != null && !bipForm.getChampsNom().isEmpty()) champsNom = bipForm.getChampsNom().toUpperCase();
		if (bipForm.getChampsIgg() != null && !bipForm.getChampsIgg().isEmpty()) champsIgg1 = bipForm.getChampsIgg().toUpperCase();
		if (bipForm.getChampsMatArp() != null && !bipForm.getChampsMatArp().isEmpty()) champsMatArp1 = bipForm.getChampsMatArp().toUpperCase();
		if (bipForm.getChampsIdenBip() != null && !bipForm.getChampsIdenBip().isEmpty()) champsIdenBip = bipForm.getChampsIdenBip().toUpperCase();
		if (bipForm.getChampsRefFac() != null && !bipForm.getChampsRefFac().isEmpty()) champsRefFac = bipForm.getChampsRefFac().toUpperCase();
		if (bipForm.getChampsRefExp() != null && !bipForm.getChampsRefExp().isEmpty()) champsRefExp = bipForm.getChampsRefExp().toUpperCase();
		if (bipForm.getChampsRacine() != null && !bipForm.getChampsRacine().isEmpty()) champsRacine = bipForm.getChampsRacine().toUpperCase();
		if (bipForm.getChampsAvenant() != null && !bipForm.getChampsAvenant().isEmpty()) champsAvenant = bipForm.getChampsAvenant().toUpperCase();

		
		/************ Controle sur le CRIRERE RESSOURCES ****************/
		if (!champsIgg1.isEmpty()) {
		
		if (champsIgg1.length() == 10 && champsIgg1.startsWith("1") )
			champsIgg2 = "9" + champsIgg1.substring(1, 10);
		else if (champsIgg1.length() == 10 && champsIgg1.startsWith("9") )
			champsIgg2 = "1" + champsIgg1.substring(1, 10);
		else if (critereIgg.matches("P") &&  champsIgg1.startsWith("1") )
			champsIgg2 = "9" + champsIgg1.substring(1, champsIgg1.length());
		else if (critereIgg.matches("P") && champsIgg1.startsWith("9") )
			champsIgg2 = "1" + champsIgg1.substring(1, champsIgg1.length());
		
		logBipUser.debug("(ContratRFAction) (valider) => champsIgg1 =" + champsIgg1);
		logBipUser.debug("(ContratRFAction) (valider) => champsIgg2 =" + champsIgg2);
		}
		
		/************ Controle sur le MATRICULE ARPEGE ****************/
		if (!champsMatArp1.isEmpty())
		{
			if (champsMatArp1 != null &&  champsMatArp1.startsWith("X") )
				champsMatArp2 = "Y" + champsMatArp1.substring(1, champsMatArp1.length());
			else if (champsMatArp1 != null && champsMatArp1.startsWith("Y") )
				champsMatArp2 = "X" + champsMatArp1.substring(1, champsMatArp1.length());		
		
		logBipUser.debug("(ContratRFAction) (valider) => champsMatArp1 =" + champsMatArp1);
		logBipUser.debug("(ContratRFAction) (valider) => champsMatArp2 =" + champsMatArp2);
		}
				
		Random r = new Random();
		int valeurMin = 1;
		int valeurMax = 999999999;
		int NUMERO_PROCESS_ENCOURS = valeurMin + r.nextInt(valeurMax - valeurMin);
		logBipUser.debug("(ContratRFAction) (valider) => NUMERO_PROCESS_ENCOURS =" + NUMERO_PROCESS_ENCOURS);

		
		try {
			
			// On exécute la procédure stockée SOCIETE	
			 logBipUser.debug("(ContratRFAction) (valider) => debut ");
			 logBipUser.debug("(ContratRFAction) (valider) => critereDosPac = " + critereDosPac);
			 logBipUser.debug("(ContratRFAction) (valider) => critereRefCon = " + critereRefCon);
			 logBipUser.debug("(ContratRFAction) (valider) => critereRefAve = " + critereRefAve);
			 logBipUser.debug("(ContratRFAction) (valider) => critereNom = " + critereNom);
			 logBipUser.debug("(ContratRFAction) (valider) => critereIgg = " + critereIgg);
			 logBipUser.debug("(ContratRFAction) (valider) => critereMatArp = " + critereMatArp);
			 logBipUser.debug("(ContratRFAction) (valider) => critereIdenBip = " + critereIdenBip);
			 logBipUser.debug("(ContratRFAction) (valider) => critereRefFac = " + critereRefFac);
			 logBipUser.debug("(ContratRFAction) (valider) => critereRefExp = " + critereRefExp);
			 logBipUser.debug("(ContratRFAction) (valider) => champsDosPac = " + champsDosPac);
			 logBipUser.debug("(ContratRFAction) (valider) => champsRefCon = " + champsRefCon);
			 logBipUser.debug("(ContratRFAction) (valider) => champsRefAve = " + champsRefAve);
			 logBipUser.debug("(ContratRFAction) (valider) => champsNom = " + champsNom);
			 logBipUser.debug("(ContratRFAction) (valider) => champsIgg1 = " + champsIgg1);
			 logBipUser.debug("(ContratRFAction) (valider) => champsIgg2 = " + champsIgg2);
			 logBipUser.debug("(ContratRFAction) (valider) => champsMatArp1 = " + champsMatArp1);
			 logBipUser.debug("(ContratRFAction) (valider) => champsMatArp2 = " + champsMatArp2);
			 logBipUser.debug("(ContratRFAction) (valider) => champsIdenBip = " + champsIdenBip);
			 logBipUser.debug("(ContratRFAction) (valider) => champsRefFac = " + champsRefFac);
			 logBipUser.debug("(ContratRFAction) (valider) => champsRefExp = " + champsRefExp);
			 logBipUser.debug("(ContratRFAction) (valider) => champsRacine = " + champsRacine);
			 logBipUser.debug("(ContratRFAction) (valider) => champsAvenant = " + champsAvenant);
			
			
			String req_societe_1 = "";
			String req_societe_2 = "";
			String req_societe_3 = "";
			String req_societe_4 = "";
			String req_societe_5 = "";
			
			if (!champsNom.isEmpty() || !champsIgg1.isEmpty() || !champsIgg2.isEmpty() || !champsMatArp1.isEmpty() || !champsMatArp2.isEmpty() || !champsIdenBip.isEmpty())
			{
				req_societe_1 ="SELECT DISTINCT '"+NUMERO_PROCESS_ENCOURS+"', SOCIETE.SOCLIB,SOCIETE.SOCCODE soccod,AGENCE.SIREN,SOCIETE.SOCCRE, " +
				"EBIS_FOURNISSEURS1.CODE_FOURNISSEUR_EBIS CODE_FOURNISSEUR_EBIS_1,EBIS_FOURNISSEURS2.CODE_FOURNISSEUR_EBIS CODE_FOURNISSEUR_EBIS_2 " +
				"FROM SOCIETE societe,  " +
				"AGENCE agence,  " +
				"EBIS_FOURNISSEURS EBIS_FOURNISSEURS1,  " +
				"EBIS_FOURNISSEURS EBIS_FOURNISSEURS2,  " ;
				if(!"".equals(req_dpg_perim_me) || !"".equals(req_centre_frais)){
					req_societe_1 = req_societe_1 + "CONTRAT contrat, LIGNE_CONT ligne_cont, ";
				}
				req_societe_1 = req_societe_1 + "SITU_RESS situ_ress,  " +
				"RESSOURCE ressource  " +
				"WHERE  " +
				"societe.soccode = agence.soccode   " +
				"AND (societe.soccode = EBIS_FOURNISSEURS1.soccode(+) AND EBIS_FOURNISSEURS1.REFERENTIEL(+) = 'FR001' )  " +
				"AND (societe.soccode = EBIS_FOURNISSEURS2.soccode(+) AND EBIS_FOURNISSEURS2.REFERENTIEL(+) = 'FR002' )  " +
				"AND societe.SOCCODE  = situ_ress.SOCCODE(+)  ";		
				if(!"".equals(req_dpg_perim_me) || !"".equals(req_centre_frais)){
					req_societe_1 = req_societe_1 +  "AND contrat.NUMCONT = ligne_cont.NUMCONT(+) AND contrat.CAV = ligne_cont.CAV(+) AND  ressource.ident = ligne_cont.ident " ;
				}		
				req_societe_1 = req_societe_1 + "AND (ressource.ident = situ_ress.ident) ";
			
				req_societe_1 = this.calculRequete("societe_1",req_societe_1, "", "", "", critereNom, critereIgg, critereMatArp, critereIdenBip, "", "", "", "", "", champsNom, champsIgg1, champsIgg2, champsMatArp1, champsMatArp2, champsIdenBip, "", "", "", "", req_centre_frais, req_dpg_perim_me);
				req_societe_1 = req_societe_1 + "UNION ";
			}
	
			if (!champsDosPac.isEmpty() || !champsRefCon.isEmpty() || !champsRefAve.isEmpty())
			{
				req_societe_3 ="SELECT DISTINCT '"+NUMERO_PROCESS_ENCOURS+"', SOCIETE.SOCLIB,SOCIETE.SOCCODE soccod,AGENCE.SIREN,SOCIETE.SOCCRE, " +
				"EBIS_FOURNISSEURS1.CODE_FOURNISSEUR_EBIS CODE_FOURNISSEUR_EBIS_1,EBIS_FOURNISSEURS2.CODE_FOURNISSEUR_EBIS CODE_FOURNISSEUR_EBIS_2 " + 
				"FROM SOCIETE societe, " + 
				"AGENCE agence, " +
				"EBIS_FOURNISSEURS EBIS_FOURNISSEURS1, " +
				"EBIS_FOURNISSEURS EBIS_FOURNISSEURS2, " + 
				"CONTRAT contrat " +
				"WHERE " +
				"societe.soccode = agence.soccode " +
				"AND (societe.soccode = EBIS_FOURNISSEURS1.soccode(+) AND EBIS_FOURNISSEURS1.REFERENTIEL(+) = 'FR001' ) " +
				"AND (societe.soccode = EBIS_FOURNISSEURS2.soccode(+) AND EBIS_FOURNISSEURS2.REFERENTIEL(+) = 'FR002' ) " + 
				"AND societe.soccode = contrat.soccont(+) ";  

				req_societe_3 = this.calculRequete("societe_3",req_societe_3, critereDosPac, critereRefCon, critereRefAve, "", "", "", "", "", "", champsDosPac, champsRefCon, champsRefAve, "", "", "", "", "", "", "", "", champsRacine, champsAvenant, req_centre_frais, req_dpg_perim_me);
				req_societe_3 = req_societe_3 + "UNION ";
			}

			
			if (!champsDosPac.isEmpty() || !champsRefCon.isEmpty() || !champsRefAve.isEmpty() || !champsNom.isEmpty() || !champsIgg1.isEmpty() || !champsIgg2.isEmpty() || !champsMatArp1.isEmpty() || !champsMatArp2.isEmpty() || !champsIdenBip.isEmpty())
			{
				req_societe_4 ="SELECT DISTINCT '"+NUMERO_PROCESS_ENCOURS+"', SOCIETE.SOCLIB,SOCIETE.SOCCODE soccod,AGENCE.SIREN,SOCIETE.SOCCRE, " +
				"EBIS_FOURNISSEURS1.CODE_FOURNISSEUR_EBIS CODE_FOURNISSEUR_EBIS_1,EBIS_FOURNISSEURS2.CODE_FOURNISSEUR_EBIS CODE_FOURNISSEUR_EBIS_2 " + 
				"FROM SOCIETE societe, " + 
				"AGENCE agence, " +
				"EBIS_FOURNISSEURS EBIS_FOURNISSEURS1, " +
				"EBIS_FOURNISSEURS EBIS_FOURNISSEURS2, " + 
				"CONTRAT contrat, " +
				"LIGNE_CONT ligne_cont, " +
				"RESSOURCE ressource " + 
				"WHERE " +
				"societe.soccode = agence.soccode " +
				"AND (societe.soccode = EBIS_FOURNISSEURS1.soccode(+) AND EBIS_FOURNISSEURS1.REFERENTIEL(+) = 'FR001' ) " +
				"AND (societe.soccode = EBIS_FOURNISSEURS2.soccode(+) AND EBIS_FOURNISSEURS2.REFERENTIEL(+) = 'FR002' ) " + 
				"AND societe.soccode = contrat.soccont(+) " +
				"AND contrat.NUMCONT = ligne_cont.NUMCONT AND contrat.CAV = ligne_cont.CAV " + 		
				"AND  ressource.ident = ligne_cont.ident "; 

				req_societe_4 = this.calculRequete("societe_4",req_societe_4, critereDosPac, critereRefCon, critereRefAve, critereNom, critereIgg, critereMatArp, critereIdenBip, "", "", champsDosPac, champsRefCon, champsRefAve, champsNom, champsIgg1, champsIgg2, champsMatArp1, champsMatArp2, champsIdenBip, "", "", champsRacine, champsAvenant, req_centre_frais, req_dpg_perim_me);
				req_societe_4 = req_societe_4 + "UNION ";
			}

			if (!champsRefExp.isEmpty() || !champsRefFac.isEmpty() || !champsNom.isEmpty() || !champsIgg1.isEmpty() || !champsIgg2.isEmpty() || !champsMatArp1.isEmpty() || !champsMatArp2.isEmpty() || !champsIdenBip.isEmpty())
			{
				req_societe_5 ="SELECT DISTINCT '"+NUMERO_PROCESS_ENCOURS+"', SOCIETE.SOCLIB,SOCIETE.SOCCODE soccod,AGENCE.SIREN,SOCIETE.SOCCRE, " +
				"EBIS_FOURNISSEURS1.CODE_FOURNISSEUR_EBIS CODE_FOURNISSEUR_EBIS_1,EBIS_FOURNISSEURS2.CODE_FOURNISSEUR_EBIS CODE_FOURNISSEUR_EBIS_2 " +
				"FROM SOCIETE societe, " +
				"AGENCE agence, " +
				"EBIS_FOURNISSEURS EBIS_FOURNISSEURS1, " + 
				"EBIS_FOURNISSEURS EBIS_FOURNISSEURS2, " +
				"FACTURE facture, " +
				"LIGNE_FACT ligne_fact, ";
				if(!"".equals(req_dpg_perim_me) || !"".equals(req_centre_frais)){
					req_societe_5 = req_societe_5 +"CONTRAT contrat, LIGNE_CONT ligne_cont, ";
				}
				req_societe_5 = req_societe_5 + "RESSOURCE ressource " +
				"WHERE " +
				"societe.soccode = agence.soccode " +  
				"AND (societe.soccode = EBIS_FOURNISSEURS1.soccode(+) AND EBIS_FOURNISSEURS1.REFERENTIEL(+) = 'FR001' ) " + 
				"AND (societe.soccode = EBIS_FOURNISSEURS2.soccode(+) AND EBIS_FOURNISSEURS2.REFERENTIEL(+) = 'FR002' ) " +
				"AND societe.SOCCODE = facture.SOCFACT(+) " +
				"AND ligne_fact.numfact = facture.numfact " +
				"AND ressource.ident = ligne_fact.ident ";
				if(!"".equals(req_dpg_perim_me) || !"".equals(req_centre_frais)){
					req_societe_5 = req_societe_5 + "AND  ressource.ident = ligne_cont.ident ";
					req_societe_5 = req_societe_5 + "AND contrat.NUMCONT = ligne_cont.NUMCONT(+) AND contrat.CAV = ligne_cont.CAV(+) "; 	
				}

				req_societe_5 = this.calculRequete("societe_5",req_societe_5, "", "", "", critereNom, critereIgg, critereMatArp, critereIdenBip, critereRefFac, critereRefExp, "", "", "", champsNom, champsIgg1, champsIgg2, champsMatArp1, champsMatArp2, champsIdenBip, champsRefFac, champsRefExp, champsRacine, champsAvenant, req_centre_frais, req_dpg_perim_me);
			}

			String req_societe = req_societe_1 + req_societe_2 + req_societe_3 + req_societe_4 + req_societe_5;
			if (req_societe.substring(req_societe.length()-6, req_societe.length()).equals("UNION "))
				req_societe = req_societe.substring(0, req_societe.length()-6);
						
			// On exécute la procédure stockée CONTRAT			
			String req_contrat = "SELECT DISTINCT '"+NUMERO_PROCESS_ENCOURS+"',CONTRAT.CDATSAI,CONTRAT.SOCCONT,CONTRAT.SIREN,CONTRAT.NUMCONT," +
					"CONTRAT.CAV,CONTRAT.CDATDEB,CONTRAT.CDATFIN,LIGNE_CONT.IDENT,RESSOURCE.RNOM,RESSOURCE.MATRICULE," +
					"RESSOURCE.IGG,CONTRAT.CODSG,LIGNE_CONT.LCCOUACT,LIGNE_CONT.LRESDEB,LIGNE_CONT.LRESFIN," +
					"LIGNE_CONT.LCNUM " +
					"FROM CONTRAT contrat " +
					"LEFT JOIN LIGNE_CONT ligne_cont ON contrat.numcont = ligne_cont.numcont and contrat.cav = ligne_cont.cav " + 
					"LEFT OUTER JOIN FACTURE facture ON facture.numcont = contrat.numcont " +
					"LEFT OUTER JOIN LIGNE_FACT ligne_fact ON ligne_fact.numfact = facture.numfact and ligne_fact.ident = ligne_cont.ident " +
					"LEFT OUTER JOIN RESSOURCE ressource ON ressource.ident = ligne_cont.ident " +
					"WHERE ";
			
			req_contrat = 
				this.calculRequete("contrat",req_contrat, critereDosPac, critereRefCon, critereRefAve, critereNom, critereIgg, critereMatArp, critereIdenBip, critereRefFac, critereRefExp, champsDosPac, champsRefCon, champsRefAve, champsNom, champsIgg1, champsIgg2, champsMatArp1, champsMatArp2, champsIdenBip, champsRefFac, champsRefExp, champsRacine, champsAvenant, req_centre_frais, req_dpg_perim_me);

			//FAD: Exception
			/*
			String req_contrat_rejet ="SELECT DISTINCT '"+NUMERO_PROCESS_ENCOURS+"', PRA_CONTRAT.DATE_TRAIT, PRA_CONTRAT.SOCCONT, PRA_CONTRAT.SIREN_FRS, "+
				"PRA_CONTRAT.NUM_CONTRAT || ' / ' || PRA_CONTRAT.CAV, PRA_CONTRAT.DATE_DEB_CTRA || CHR(10) || PRA_CONTRAT.DATE_FIN_CTRA, "+
				"PRA_CONTRAT.IDENT_RESSOURCE || ' - ' || PRA_CONTRAT.NOM_RESSOURCE, PRA_CONTRAT.MATRICULE_RESSOURCE, PRA_CONTRAT.IGG_RESSOURCE, "+
				"PRA_CONTRAT.DPG, TO_CHAR(PRA_CONTRAT.COUT_ORIGINE_SITU, 'FM99999D00'), PRA_CONTRAT.RETOUR "+
				"FROM PRA_CONTRAT "+
				"LEFT JOIN RESSOURCE ressource ON ressource.IDENT = PRA_CONTRAT.IDENT_RESSOURCE AND PRA_CONTRAT.CODE_RETOUR = 0 "+
				"LEFT JOIN FACTURE facture ON facture.NUMCONT = PRA_CONTRAT.NUM_CONTRAT "+
				"WHERE "; 
			req_contrat_rejet = 
				this.calculRequete("contrat_rejet",req_contrat_rejet, critereDosPac, critereRefCon, critereRefAve, critereNom, critereIgg, critereMatArp, critereIdenBip, critereRefFac, critereRefExp, champsDosPac, champsRefCon, champsRefAve, champsNom, champsIgg1, champsIgg2, champsMatArp1, champsMatArp2, champsIdenBip, champsRefFac, champsRefExp, champsRacine, champsAvenant, req_centre_frais, req_dpg_perim_me);
			System.out.println("req_contrat_rejet");
			System.out.println(req_contrat_rejet);
			*/
			
			// On exécute la procédure stockée RESSOURCE
			String req_ressource ="SELECT DISTINCT '"+NUMERO_PROCESS_ENCOURS+"',RESSOURCE.IDENT,RESSOURCE.RNOM,RESSOURCE.RPRENOM," +
					"RESSOURCE.MATRICULE,RESSOURCE.IGG,SITU_RESS.CODSG,SITU_RESS.CPIDENT,SITU_RESS.PRESTATION,SITU_RESS.MODE_CONTRACTUEL_INDICATIF," +
					"SITU_RESS.SOCCODE,SITU_RESS.COUT,SITU_RESS.DATSITU,SITU_RESS.DATDEP,AGENCE.SIREN,SOCIETE.SOCLIB," +
					"(SELECT sum(CUSAG) FROM CONS_SSTACHE_RES_MOIS WHERE cons_sstache_res_mois.ident  = ressource.ident) as CONSOANNUEL " +
					"FROM RESSOURCE ressource " +		
					"LEFT JOIN LIGNE_FACT ligne_fact ON ressource.ident = ligne_fact.ident " +
					"LEFT OUTER JOIN FACTURE facture ON ligne_fact.numfact = facture.numfact " +
					"LEFT OUTER JOIN LIGNE_CONT ligne_cont ON ligne_cont.ident = ressource.ident " +
					"LEFT OUTER JOIN CONTRAT contrat ON contrat.numcont = ligne_cont.numcont " + 
					"LEFT OUTER JOIN SITU_RESS situ_ress ON ressource.ident  = situ_ress.ident " +
					"LEFT OUTER JOIN SOCIETE societe ON situ_ress.soccode = societe.soccode " +
					"LEFT OUTER JOIN AGENCE agence ON societe.soccode  = agence.soccode " +
					"LEFT OUTER JOIN CONS_SSTACHE_RES_MOIS cons_sstache_res_mois ON cons_sstache_res_mois.ident  = ressource.ident " +
					"WHERE ";
			req_ressource = 
				this.calculRequete("ressource",req_ressource, critereDosPac, critereRefCon, critereRefAve, critereNom, critereIgg, critereMatArp, critereIdenBip, critereRefFac, critereRefExp, champsDosPac, champsRefCon, champsRefAve, champsNom, champsIgg1, champsIgg2, champsMatArp1, champsMatArp2, champsIdenBip, champsRefFac, champsRefExp, champsRacine, champsAvenant, req_centre_frais, req_dpg_perim_me);
	
			// On exécute la procédure stockée FACTURE
			String req_facture ="SELECT DISTINCT '"+NUMERO_PROCESS_ENCOURS+"',FACTURE.FDATSAI,FACTURE.SOCFACT,FACTURE.NUMFACT,FACTURE.NUM_EXPENSE," +
					"FACTURE.TYPFACT,FACTURE.DATFACT,FACTURE.FMONTHT,FACTURE.NUMCONT,FACTURE.CAV,LIGNE_FACT.LMOISPREST," +
					"LIGNE_FACT.IDENT,RESSOURCE.RNOM,LIGNE_FACT.LNUM,FACTURE.FDEPPOLE,STRUCT_INFO.LIBDSG " +
					"FROM FACTURE facture INNER JOIN LIGNE_FACT ligne_fact ON facture.numfact = ligne_fact.numfact " +
					"LEFT OUTER JOIN RESSOURCE ressource ON ressource.ident = ligne_fact.ident " +
					"LEFT OUTER JOIN CONTRAT contrat ON contrat.numcont = facture.numcont " +  
					"LEFT OUTER JOIN STRUCT_INFO struct_info ON facture.FDEPPOLE = struct_info.codsg " +
					"WHERE ";
			req_facture = 
				this.calculRequete("facture",req_facture, critereDosPac, critereRefCon, critereRefAve, critereNom, critereIgg, critereMatArp, critereIdenBip, critereRefFac, critereRefExp, champsDosPac, champsRefCon, champsRefAve, champsNom, champsIgg1, champsIgg2, champsMatArp1, champsMatArp2, champsIdenBip, champsRefFac, champsRefExp, champsRacine, champsAvenant, req_centre_frais, req_dpg_perim_me);


			String req_facture_rejet ="SELECT DISTINCT '"+NUMERO_PROCESS_ENCOURS+"', EBIS_FACT_REJET.TIMESTAMP, FACTURE.SOCFACT, EBIS_FACT_REJET.NUMFACT, EBIS_FACT_REJET.NUM_EXPENSE, " +
				"EBIS_FACT_REJET.TYPFACT, EBIS_FACT_REJET.DATFACT, EBIS_FACT_REJET.FMONTHT, EBIS_FACT_REJET.NUMCONT, EBIS_FACT_REJET.CAV, EBIS_FACT_REJET.LMOISPREST, " +
				"EBIS_FACT_REJET.IDENT, RESSOURCE.RNOM, EBIS_FACT_REJET.LNUM, EBIS_FACT_REJET.CODE_RETOUR " +
				"FROM EBIS_FACT_REJET " +
				"LEFT JOIN FACTURE ON TRIM(EBIS_FACT_REJET.NUMFACT) = TRIM(FACTURE.NUMFACT) " +
				"LEFT OUTER JOIN CONTRAT contrat ON contrat.numcont = EBIS_FACT_REJET.numcont AND contrat.CAV = EBIS_FACT_REJET.CAV " + // KRA - QC 1677 : + req_centre_frais + req_dpg_perim_me + 
				"LEFT OUTER JOIN PRA_CONTRAT pra_contrat ON TRIM(pra_contrat.NUM_CONTRAT) = TRIM(EBIS_FACT_REJET.numcont) AND pra_contrat.CAV = EBIS_FACT_REJET.CAV AND EBIS_FACT_REJET.CODE_RETOUR = 7 " +
				"LEFT JOIN RESSOURCE ressource ON EBIS_FACT_REJET.IDENT = RESSOURCE.IDENT " +
				"WHERE ";
			req_facture_rejet = 
				this.calculRequete("facture_rejet",req_facture_rejet, critereDosPac, critereRefCon, critereRefAve, critereNom, critereIgg, critereMatArp, critereIdenBip, critereRefFac, critereRefExp, champsDosPac, champsRefCon, champsRefAve, champsNom, champsIgg1, champsIgg2, champsMatArp1, champsMatArp2, champsIdenBip, champsRefFac, champsRefExp, champsRacine, champsAvenant, req_centre_frais, req_dpg_perim_me);
			
			
			//Debut
			String req_entete_soc = "SELECT * FROM ( ";
			String req_count_cont = "soccod in (SELECT CONTRAT.SOCCONT " + req_contrat.substring(req_contrat.indexOf("FROM CONTRAT"));
			String req_count_ress = "soccod in (SELECT SITU_RESS.SOCCODE " + req_ressource.substring(req_ressource.indexOf("FROM RESSOURCE"));
			String req_count_fact = "soccod in (SELECT FACTURE.SOCFACT " + req_facture.substring(req_facture.indexOf("FROM FACTURE"));
			
	
			// Au moins un critère est saisi dans les blocs Contrat ET Ressource ET Facture
			if ((!champsDosPac.isEmpty() || !champsRefCon.isEmpty() || !champsRefAve.isEmpty()) 
					&& (!champsNom.isEmpty() || !champsIgg1.isEmpty() || !champsIgg2.isEmpty() || !champsMatArp1.isEmpty() || !champsMatArp2.isEmpty() || !champsIdenBip.isEmpty()) 
					&& (!champsRefExp.isEmpty() || !champsRefFac.isEmpty()) )
			{
				req_entete_soc = req_entete_soc + req_societe + " ) WHERE " + req_count_cont + ") OR " ;
				req_entete_soc = req_entete_soc + req_count_ress + ") OR " ;
				req_entete_soc = req_entete_soc + req_count_fact + ") " ;
			}else
			//Au moins un critère est saisi dans les blocs Contrat ET Ressource et tous les champs de Factures sont vides
			
			if ((!champsDosPac.isEmpty() || !champsRefCon.isEmpty() || !champsRefAve.isEmpty()) 
					&& (!champsNom.isEmpty() || !champsIgg1.isEmpty() || !champsIgg2.isEmpty() || !champsMatArp1.isEmpty() || !champsMatArp2.isEmpty() || !champsIdenBip.isEmpty()) 
					&& champsRefExp.isEmpty() && champsRefFac.isEmpty() )
			{
				req_entete_soc = req_entete_soc + req_societe + " ) WHERE " + req_count_cont + ") OR " ;
				req_entete_soc = req_entete_soc + req_count_ress + ") OR " ;
				req_entete_soc = req_entete_soc + req_count_fact + ") " ;
			}else
			//Au moins un critère est saisi dans les blocs Contrat ET Facture et tous les champs de Ressources sont vides
			if ((!champsDosPac.isEmpty() || !champsRefCon.isEmpty() || !champsRefAve.isEmpty()) 
					&& champsNom.isEmpty() && champsIgg1.isEmpty() && champsIgg2.isEmpty() && champsMatArp1.isEmpty() && champsMatArp2.isEmpty() && champsIdenBip.isEmpty() 
					&& (!champsRefExp.isEmpty() || !champsRefFac.isEmpty()) )
			{
				req_entete_soc = req_entete_soc + req_societe + " ) WHERE " + req_count_cont + ") OR " ;
				req_entete_soc = req_entete_soc + req_count_ress + ") OR " ;
				req_entete_soc = req_entete_soc + req_count_fact + ") " ;
			}else
			//Au moins un critère est saisi dans les blocs Ressource ET Facture  et tous les champs de Contrats sont vides
			if (champsDosPac.isEmpty() && champsRefCon.isEmpty() && champsRefAve.isEmpty() 
					&& (!champsNom.isEmpty() || !champsIgg1.isEmpty() || !champsIgg2.isEmpty() || !champsMatArp1.isEmpty() || !champsMatArp2.isEmpty() || !champsIdenBip.isEmpty()) 
					&& (!champsRefExp.isEmpty() || !champsRefFac.isEmpty()) )
			{
				req_entete_soc = req_entete_soc + req_societe + " ) WHERE " + req_count_cont + ") OR " ;
				req_entete_soc = req_entete_soc + req_count_ress + ") OR " ;
				req_entete_soc = req_entete_soc + req_count_fact + ") " ;
			}else
			{				
				req_entete_soc = req_societe;
			}
			//on écrase l'anciènne requête
			req_societe = req_entete_soc;

			//Fin
			logBipUser.debug("req_societe=" + req_societe);
			logBipUser.debug("req_contrat=" + req_contrat);
			logBipUser.debug("req_ressource=" + req_ressource);
			logBipUser.debug("req_facture=" + req_facture);
			//logBipUser.debug("req_contrat_rejet=" + req_contrat_rejet);
			logBipUser.debug("req_facture_rejet=" + req_facture_rejet);
			
			hParamProc.put("req_societe", req_societe) ;
			hParamProc.put("req_contrat", req_contrat) ;
			hParamProc.put("req_ressource", req_ressource) ;
			hParamProc.put("req_facture", req_facture) ;
			hParamProc.put("req_facture_rejet", req_facture_rejet) ;
			//FAD: Exception
			//hParamProc.put("req_contrat_rejet", req_contrat_rejet) ;
			logBipUser.debug("(ContratRFAction) (valider) => hParamProc après ajout requete:" + hParamProc);
			
			
			vParamOut = jdbc.getResult(hParamProc, configProc, PACK_CONTRATRF_INSERT);
			logBipUser.debug("(ContratRFAction) (valider) => vParamOut:" + vParamOut);
			
			try {
				
				message = jdbc.recupererResult(vParamOut, "valider");
				
			} catch (BaseException be) {
				logBipUser.debug("valider() --> BaseException :" + be);
				logBipUser.debug("valider() --> Exception :"
						+ be.getInitialException().getMessage());
				logService.debug("valider() --> BaseException :" + be);
				logService.debug("valider() --> Exception :"
						+ be.getInitialException().getMessage());
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));

				 jdbc.closeJDBC(); return mapping.findForward("error"); 
			}

			if (message != null && !message.equals("")) {
				// on récupère le message
				bipForm.setMsgErreur(message);
				logBipUser.debug("valider() -->message :" + message);

			}

		} catch (BaseException be) {

			logService.debug("valider() --> BaseException :" + be);
			logService.debug("valider() --> Exception :"
					+ be.getInitialException().getMessage());
			logBipUser.debug("valider() --> BaseException :" + be);
			logBipUser.debug("valider() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				bipForm.setMsgErreur(message);

				if (!mode.equals("delete")) {
					 jdbc.closeJDBC(); return mapping.findForward("ecran");
				}
			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException().getMessage());
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}


		logBipUser.exit(signatureMethode);
		jdbc.closeJDBC(); 

		
		request.setAttribute("num_process_en_cours", NUMERO_PROCESS_ENCOURS);
		logBipUser.debug("(ContratRFAction) (valider) => request.getAttribute(num_process_en_cours) =" + request.getAttribute("num_process_en_cours"));
		logBipUser.debug("(ContratRFAction) (valider) => fin => forward suite");
		return mapping.findForward("suite");

	}// valider

	
	protected ActionForward suite(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors) throws ServletException {
		logBipUser.debug("(ContratRFAction) (suite) => debut ");
		String signatureMethode = "StandardAction - suite( mapping, form , request,  response,  errors )";

		// logService.entry(signatureMethode);;
		logBipUser.entry(signatureMethode);

		logBipUser.exit(signatureMethode);
		return mapping.findForward("suite");
	}

 
	protected  ActionForward annuler(ActionMapping mapping,ActionForm form ,
			HttpServletRequest request, HttpServletResponse response, ActionErrors errors,Hashtable hParamProc  ) throws ServletException{
		logBipUser.debug("(ContratRFAction) (annuler) => debut ");
		

		
		String signatureMethode = "valider(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors )";
		logBipUser.entry(signatureMethode);

		ContratRFForm bipForm = (ContratRFForm) form;


		if (bipForm.getChampsDosPac() != null && bipForm.getChampsDosPac().isEmpty() && 
			bipForm.getChampsRefCon() != null && bipForm.getChampsRefCon().isEmpty() &&
		    bipForm.getChampsRefAve() != null && bipForm.getChampsRefAve().isEmpty() &&
		    bipForm.getChampsNom() != null && bipForm.getChampsNom().isEmpty() &&
		    bipForm.getChampsIgg() != null && bipForm.getChampsIgg().isEmpty() &&
		    bipForm.getChampsMatArp() != null && bipForm.getChampsMatArp().isEmpty() &&
		    bipForm.getChampsIdenBip() != null && bipForm.getChampsIdenBip().isEmpty() &&
		    bipForm.getChampsRefFac() != null && bipForm.getChampsRefFac().isEmpty() &&	
		    bipForm.getChampsRefExp() != null && bipForm.getChampsRefExp().isEmpty() &&
		    bipForm.getCritereDosPac().equals("E") && bipForm.getCritereIdenBip().equals("E") &&
		    bipForm.getCritereIgg().equals("E") && bipForm.getCritereMatArp().equals("E") &&
		    bipForm.getCritereNom().equals("E") && bipForm.getCritereRefAve().equals("E") &&
		    bipForm.getCritereRefCon().equals("E") && bipForm.getCritereRefExp().equals("E") &&
		    bipForm.getCritereRefAve().equals("E"))
			return mapping.findForward("annuler") ;
		else {
			bipForm.setChampsDosPac("");
			bipForm.setChampsIdenBip("");
			bipForm.setChampsIgg("");
			bipForm.setChampsMatArp("");
			bipForm.setChampsNom("");
			bipForm.setChampsRefAve("");
			bipForm.setChampsRefCon("");
			bipForm.setChampsRefExp("");
			bipForm.setChampsRefFac("");
			bipForm.setChampsRacine("");
			bipForm.setChampsAvenant("");
			bipForm.setCritereDosPac("E");
			bipForm.setCritereIdenBip("E");
			bipForm.setCritereIgg("E");
			bipForm.setCritereMatArp("E");
			bipForm.setCritereNom("E");
			bipForm.setCritereRefAve("E");
			bipForm.setCritereRefCon("E");
			bipForm.setCritereRefExp("E");
			bipForm.setCritereDosPac("E");
			return mapping.findForward("ecran") ;}
		  
	}
	

	protected String calculRequete(String cas,String requete,String critereDosPac , String critereRefCon ,	String critereRefAve,
			String critereNom ,	String critereIgg ,	String critereMatArp ,	String critereIdenBip ,	String critereRefFac ,
			String critereRefExp ,	String champsDosPac , String champsRefCon ,	String champsRefAve ,String champsNom ,
			String champsIgg1 , String champsIgg2 ,	String champsMatArp1 ,	String champsMatArp2 ,	String champsIdenBip ,
			String champsRefFac ,	String champsRefExp ,	String champsRacine , String champsAvenant, String req_centre_frais,
			String req_dpg_perim_me)
	{
		String cond1 = "";
	 
		 
//************ Dossier pacDOS
		boolean cdospas = false;
		if (cas.equalsIgnoreCase("contrat_rejet")) {
			if (critereDosPac.equals("E") && !champsDosPac.isEmpty())
			{
				requete = requete + cond1 +"PRA_CONTRAT.NUM_CONTRAT = '" + champsRacine +"' ";
				cdospas = true;
			}
			else if (critereDosPac.equals("P") && !champsDosPac.isEmpty())
			{
				requete = requete + cond1 +"PRA_CONTRAT.NUM_CONTRAT like '" + champsRacine +"%' ";
				cdospas = true;
			}
			else if (critereDosPac.equals("C") && !champsDosPac.isEmpty())
			{
				requete = requete + cond1 +"PRA_CONTRAT.NUM_CONTRAT like '%" + champsRacine +"%' ";
				cdospas = true;
			}
	
			if (critereDosPac.equals("E") && !champsDosPac.isEmpty() && !champsAvenant.isEmpty())
			{
				requete = requete + "AND PRA_CONTRAT.cav = '" + champsAvenant +"' ";
			}
			else if (critereDosPac.equals("P") && !champsDosPac.isEmpty() && !champsAvenant.isEmpty())
			{
				requete = requete + "AND PRA_CONTRAT.cav like '" + champsAvenant +"%' ";
			}
			else if (critereDosPac.equals("C") && !champsDosPac.isEmpty() && !champsAvenant.isEmpty())
			{
				requete = requete + "AND PRA_CONTRAT.cav like '%" + champsAvenant +"%' ";
			}
			 
	//************ Contrat
			 if (!cdospas)
			 {
				 if (critereRefCon.equals("E") && !champsRacine.isEmpty())
					 requete = requete + cond1 +"TRIM(PRA_CONTRAT.NUM_CONTRAT) = '" + champsRacine +"' ";
				 else if (critereRefCon.equals("P") && !champsRacine.isEmpty())
				 {
					 requete = requete + cond1 +"PRA_CONTRAT.NUM_CONTRAT like '" + champsRacine +"%' ";
				 }
				 else if (critereRefCon.equals("C") && !champsRacine.isEmpty())
				 {
					 requete = requete + cond1 +"PRA_CONTRAT.NUM_CONTRAT like '%" + champsRacine +"%' ";
				 }
	
				 if (critereRefAve.equals("E") && !champsRefAve.isEmpty())
				 {
					 requete = requete + "AND PRA_CONTRAT.cav = '" + champsRefAve +"' ";
				 }
				 else if (critereRefAve.equals("P") && !champsRefAve.isEmpty())
				 {
					 requete = requete + "AND PRA_CONTRAT.cav like '" + champsRefAve +"%' ";
				 }
				 else if (critereRefAve.equals("C") && !champsRefAve.isEmpty())
				 {
					 requete = requete + "AND PRA_CONTRAT.cav like '%" + champsRefAve +"%' ";
				 }
			 }
			 if (requete.substring(requete.length()-6, requete.length()).equals("WHERE "))
				 requete = requete + " PRA_CONTRAT.RETOUR LIKE 'DPG inconnu%' ";
			 else
				 requete = requete + "AND PRA_CONTRAT.RETOUR LIKE 'DPG inconnu%' ";
		}
		else if (cas.equalsIgnoreCase("facture_rejet")) {
			if (critereDosPac.equals("E") && !champsDosPac.isEmpty())
			{
				requete = requete + cond1 +"TRIM(EBIS_FACT_REJET.NUMCONT) = '" + champsRacine +"' ";
				cdospas = true;
			}
			else if (critereDosPac.equals("P") && !champsDosPac.isEmpty())
			{
				requete = requete + cond1 +"EBIS_FACT_REJET.NUMCONT like '" + champsRacine +"%' ";
				cdospas = true;
			}
			else if (critereDosPac.equals("C") && !champsDosPac.isEmpty())
			{
				requete = requete + cond1 +"EBIS_FACT_REJET.NUMCONT like '%" + champsRacine +"%' ";
				cdospas = true;
			}
	
			if (critereDosPac.equals("E") && !champsDosPac.isEmpty() && !champsAvenant.isEmpty())
			{
				requete = requete + "AND EBIS_FACT_REJET.cav = '" + champsAvenant +"' ";
			}
			else if (critereDosPac.equals("P") && !champsDosPac.isEmpty() && !champsAvenant.isEmpty())
			{
				requete = requete + "AND EBIS_FACT_REJET.cav like '" + champsAvenant +"%' ";
			}
			else if (critereDosPac.equals("C") && !champsDosPac.isEmpty() && !champsAvenant.isEmpty())
			{
				requete = requete + "AND EBIS_FACT_REJET.cav like '%" + champsAvenant +"%' ";
			}
			 
	//************ Contrat
			 if (!cdospas)
			 {
				 if (critereRefCon.equals("E") && !champsRacine.isEmpty())
					 requete = requete + cond1 +"TRIM(EBIS_FACT_REJET.NUMCONT) = '" + champsRacine +"' ";
				 else if (critereRefCon.equals("P") && !champsRacine.isEmpty())
				 {
					 requete = requete + cond1 +"EBIS_FACT_REJET.NUMCONT like '" + champsRacine +"%' ";
				 }
				 else if (critereRefCon.equals("C") && !champsRacine.isEmpty())
				 {
					 requete = requete + cond1 +"EBIS_FACT_REJET.NUMCONT like '%" + champsRacine +"%' ";
				 }
	
				 if (critereRefAve.equals("E") && !champsRefAve.isEmpty())
				 {
					 requete = requete + "AND EBIS_FACT_REJET.cav = '" + champsRefAve +"' ";
				 }
				 else if (critereRefAve.equals("P") && !champsRefAve.isEmpty())
				 {
					 requete = requete + "AND EBIS_FACT_REJET.cav like '" + champsRefAve +"%' ";
				 }
				 else if (critereRefAve.equals("C") && !champsRefAve.isEmpty())
				 {
					 requete = requete + "AND EBIS_FACT_REJET.cav like '%" + champsRefAve +"%' ";
				 }
			 }
		}
		else
		{
			if (critereDosPac.equals("E") && !champsDosPac.isEmpty())
			{
				if (requete.substring(requete.length()-6, requete.length()).equals("WHERE "))
					requete = requete + cond1 +"contrat.numcont = '" + champsRacine +"' ";
				 else
					 requete = requete + cond1 +" AND contrat.numcont = '" + champsRacine +"' ";
				cdospas = true;
			}
			else if (critereDosPac.equals("P") && !champsDosPac.isEmpty())
			{
				if (requete.substring(requete.length()-6, requete.length()).equals("WHERE "))
					requete = requete + cond1 +"contrat.numcont like '" + champsRacine +"%' ";
				else
					requete = requete + cond1 +" AND contrat.numcont like '" + champsRacine +"%' ";
				cdospas = true;
			}
			else if (critereDosPac.equals("C") && !champsDosPac.isEmpty())
			{
				if (requete.substring(requete.length()-6, requete.length()).equals("WHERE "))
					requete = requete + cond1 +"contrat.numcont like '%" + champsRacine +"%' ";
				else
					requete = requete + cond1 +" AND contrat.numcont like '%" + champsRacine +"%' ";
				cdospas = true;
			}
	
			if (critereDosPac.equals("E") && !champsDosPac.isEmpty() && !champsAvenant.isEmpty())
			{
				requete = requete + "AND contrat.cav = '" + champsAvenant +"' ";
			}
			else if (critereDosPac.equals("P") && !champsDosPac.isEmpty() && !champsAvenant.isEmpty())
			{
				requete = requete + "AND contrat.cav like '" + champsAvenant +"%' ";
			}
			else if (critereDosPac.equals("C") && !champsDosPac.isEmpty() && !champsAvenant.isEmpty())
			{
				requete = requete + "AND contrat.cav like '%" + champsAvenant +"%' ";
			}
			 
	//************ Contrat
			 if (!cdospas)
			 {
				 if (critereRefCon.equals("E") && !champsRacine.isEmpty())
					 if (requete.substring(requete.length()-6, requete.length()).equals("WHERE "))
						 requete = requete + cond1 +"contrat.numcont = '" + champsRacine +"' ";
					 else
						 requete = requete + cond1 +" AND contrat.numcont = '" + champsRacine +"' ";
				 
				 else if (critereRefCon.equals("P") && !champsRacine.isEmpty())
				 {
					 if (requete.substring(requete.length()-6, requete.length()).equals("WHERE "))
						 requete = requete + cond1 +"contrat.numcont like '" + champsRacine +"%' ";
					 else
						 requete = requete + cond1 +" AND contrat.numcont like '" + champsRacine +"%' ";
				 }
				 else if (critereRefCon.equals("C") && !champsRacine.isEmpty())
				 {
					 if (requete.substring(requete.length()-6, requete.length()).equals("WHERE "))
						 requete = requete + cond1 +"contrat.numcont like '%" + champsRacine +"%' ";
					 else
						 requete = requete + cond1 +" AND contrat.numcont like '%" + champsRacine +"%' ";
				 }
	
				 if (critereRefAve.equals("E") && !champsRefAve.isEmpty())
				 {
					 requete = requete + "AND contrat.cav = '" + champsRefAve +"' ";
				 }
				 else if (critereRefAve.equals("P") && !champsRefAve.isEmpty())
				 {
					 requete = requete + "AND contrat.cav like '" + champsRefAve +"%' ";
				 }
				 else if (critereRefAve.equals("C") && !champsRefAve.isEmpty())
				 {
					 requete = requete + "AND contrat.cav like '%" + champsRefAve +"%' ";
				 }
			 }
		}
//************ Traitement Ressource
		 boolean cressource = false ;
		 
		 String condtion_ress1 = "AND ( ";
		 
		 if (requete.substring(requete.length()-6, requete.length()).equals("WHERE "))
			 condtion_ress1 = "( ";
		 
		 if (critereNom.equals("E") && !champsNom.isEmpty())
		 {
			 if (requete.substring(requete.length()-6, requete.length()).equals("WHERE "))
				 requete = requete + "(ressource.rnom = '" + champsNom +"' ";
			 else
				 requete = requete + "AND (ressource.rnom = '" + champsNom +"' ";

			 condtion_ress1 = "OR ";
			 cressource = true;
		 }
		 else if (critereNom.equals("P") && !champsNom.isEmpty())
		 {
			 if (requete.substring(requete.length()-6, requete.length()).equals("WHERE "))
				 requete = requete + "(ressource.rnom like '" + champsNom +"%' ";
			 else
				 requete = requete + "AND (ressource.rnom like '" + champsNom +"%' ";
			 condtion_ress1 = "OR ";
			 cressource = true;
		 }
		 else if (critereNom.equals("C") && !champsNom.isEmpty())
		 {
			 if (requete.substring(requete.length()-6, requete.length()).equals("WHERE "))
				 requete = requete + "(ressource.rnom like '%" + champsNom +"%' ";
			 else
				 requete = requete + "AND (ressource.rnom like '%" + champsNom +"%' ";
			 condtion_ress1 = "OR ";
			 cressource = true;
		 }

		 String condtion_ress2 = "AND ( ";
		 if (requete.substring(requete.length()-6, requete.length()).equals("WHERE "))
			 condtion_ress2 = "( ";
		 if (critereIgg.equals("E") && !champsIgg1.isEmpty())
		 {
			 if (champsIgg2.isEmpty())
				 requete = requete + condtion_ress1 + "ressource.igg = '" + champsIgg1 +"' ";
			 else
				 requete = requete + condtion_ress1 + "ressource.igg = '" + champsIgg1 +"' OR ressource.igg = '"+ champsIgg2 + "' ";
			 //condtion_ress2 = "OR ";
			 condtion_ress1 = "OR ";
			 cressource = true;
		 }
		 else if (critereIgg.equals("P") && !champsIgg1.isEmpty())
		 {
			 if (champsIgg2.isEmpty())
				 requete = requete + condtion_ress1 + "ressource.igg like '" + champsIgg1 +"%' ";
			 else
				 requete = requete + condtion_ress1 + "ressource.igg like '" + champsIgg1 +"%' OR ressource.igg like '" + champsIgg2 +"%' ";
			 //condtion_ress2 = "OR ";
			 condtion_ress1 = "OR ";
			 cressource = true;
		 }
		 else if (critereIgg.equals("C") && !champsIgg1.isEmpty())
		 {
			 if (champsIgg2.isEmpty())
				 requete = requete + condtion_ress1 + "ressource.igg like '%" + champsIgg1 +"%' ";
			 else
				 requete = requete + condtion_ress1 + "ressource.igg like '%" + champsIgg1 +"%' OR ressource.igg like '%"+ champsIgg2 +"%' ";
			 //condtion_ress2 = "OR ";
			 condtion_ress1 = "OR ";
			 cressource = true;
		 }
		 
		 String condtion_ress3 = "AND ( ";
		 if (requete.substring(requete.length()-6, requete.length()).equals("WHERE "))
			 condtion_ress3 = "( ";
		 if (critereMatArp.equals("E") && !champsMatArp1.isEmpty())
		 {
			 if (champsMatArp2.isEmpty())
				 //requete = requete + condtion_ress2 + "ressource.matricule = '" + champsMatArp1 +"' ";
				 requete = requete + condtion_ress1 + "ressource.matricule = '" + champsMatArp1 +"' ";
			 else
				 //requete = requete + condtion_ress2 + "ressource.matricule = '" + champsMatArp1 +"' OR ressource.matricule = '"+ champsMatArp2 + "' ";
				 requete = requete + condtion_ress1 + "ressource.matricule = '" + champsMatArp1 +"' OR ressource.matricule = '"+ champsMatArp2 + "' ";
			 //condtion_ress3 = "OR ";
			 condtion_ress1 = "OR ";
			 cressource = true;
		 }
		 else if (critereMatArp.equals("P") && !champsMatArp1.isEmpty())
		 {
			 if (champsMatArp2.isEmpty())
				//requete = requete + condtion_ress2 + "ressource.matricule like '" + champsMatArp1 +"%' ";
			 	requete = requete + condtion_ress1 + "ressource.matricule like '" + champsMatArp1 +"%' ";
			 else
				 //requete = requete + condtion_ress2 + "ressource.matricule like '" + champsMatArp1 +"%' OR ressource.matricule like '" + champsMatArp2 +"%' ";
				 requete = requete + condtion_ress1 + "ressource.matricule like '" + champsMatArp1 +"%' OR ressource.matricule like '" + champsMatArp2 +"%' ";
			 //condtion_ress3 = "OR ";
			 condtion_ress1 = "OR ";
			 cressource = true;
		 }
		 else if (critereMatArp.equals("C") && !champsMatArp1.isEmpty())
		 {
			 if (champsMatArp2.isEmpty())				
			 	requete = requete + condtion_ress1 + "ressource.matricule like '%" + champsMatArp1 +"%' ";
			 else
				 requete = requete + condtion_ress1 + "ressource.matricule like '%" + champsMatArp1 +"%' OR ressource.matricule like '%"+ champsMatArp2 +"%' ";
			 condtion_ress1 = "OR ";
			 cressource = true;
		 }
		 if (critereIdenBip.equals("E") && !champsIdenBip.isEmpty())
		 {
			 requete = requete + condtion_ress1 + "ressource.ident = '" + champsIdenBip +"' ";
			 cressource = true;
		 }
		 else if (critereIdenBip.equals("P") && !champsIdenBip.isEmpty())
		 {
			 requete = requete + condtion_ress1 + "ressource.ident like '" + champsMatArp1 +"%' ";
			 cressource = true;
		 }
		 else if (critereIdenBip.equals("C") && !champsIdenBip.isEmpty())
		 {
			 requete = requete + condtion_ress1 + "ressource.ident like '%" + champsIdenBip +"%' ";
			 cressource = true;
		 }

		 if (cressource) requete = requete + ") ";
//************ Traitement  Facture				 
				boolean cfacture = false ;
				if (cas.equalsIgnoreCase("facture_rejet"))
				{
					String condtion_fact1 = "AND ( ";
					if (requete.substring(requete.length()-6, requete.length()).equals("WHERE "))
						condtion_fact1 = "( ";
					if (critereRefFac.equals("E") && !champsRefFac.isEmpty())
					{
						if (requete.substring(requete.length()-6, requete.length()).equals("WHERE "))
							requete = requete + "(EBIS_FACT_REJET.numfact = '" + champsRefFac +"' ";
						else
							requete = requete + "AND (EBIS_FACT_REJET.numfact = '" + champsRefFac +"' ";
						condtion_fact1 = "OR ";
						cfacture = true;
					}
					else if (critereRefFac.equals("P") && !champsRefFac.isEmpty())
					{
						if (requete.substring(requete.length()-6, requete.length()).equals("WHERE "))
							requete = requete + "(EBIS_FACT_REJET.numfact like '" + champsRefFac +"%' ";
						else
							requete = requete + "AND (EBIS_FACT_REJET.numfact like '" + champsRefFac +"%' ";
						condtion_fact1 = "OR ";
						cfacture = true;
					}
					else if (critereRefFac.equals("C") && !champsRefFac.isEmpty())
					{
						if (requete.substring(requete.length()-6, requete.length()).equals("WHERE "))
							requete = requete + "(EBIS_FACT_REJET.numfact like '%" + champsRefFac +"%' ";
						else
							requete = requete + "AND (EBIS_FACT_REJET.numfact like '%" + champsRefFac +"%' ";
						condtion_fact1 = "OR ";
						cfacture = true;
					}
	
					if (critereRefExp.equals("E") && !champsRefExp.isEmpty())
					{
						requete = requete + condtion_fact1+"EBIS_FACT_REJET.num_expense = '" + champsRefExp +"' ";
						cfacture = true;
					}
					else if (critereRefExp.equals("P") && !champsRefExp.isEmpty())
					{
						requete = requete + condtion_fact1+"EBIS_FACT_REJET.num_expense like '" + champsRefExp +"%' ";
						cfacture = true;
					}
					else if (critereRefExp.equals("C") && !champsRefExp.isEmpty())
					{
						requete = requete + condtion_fact1 +"EBIS_FACT_REJET.num_expense like '%" + champsRefExp +"%' ";
						cfacture = true;
					}
				}
				else
				{
					String condtion_fact1 = "AND ( ";
					if (requete.substring(requete.length()-6, requete.length()).equals("WHERE "))
						condtion_fact1 = "( ";
					if (critereRefFac.equals("E") && !champsRefFac.isEmpty())
					{
						if (requete.substring(requete.length()-6, requete.length()).equals("WHERE "))
							requete = requete + "(facture.numfact = '" + champsRefFac +"' ";
						else
							requete = requete + "AND (facture.numfact = '" + champsRefFac +"' ";
						condtion_fact1 = "OR ";
						cfacture = true;
					}
					else if (critereRefFac.equals("P") && !champsRefFac.isEmpty())
					{
						if (requete.substring(requete.length()-6, requete.length()).equals("WHERE "))
							requete = requete + "(facture.numfact like '" + champsRefFac +"%' ";
						else
							requete = requete + "AND (facture.numfact like '" + champsRefFac +"%' ";
						condtion_fact1 = "OR ";
						cfacture = true;
					}
					else if (critereRefFac.equals("C") && !champsRefFac.isEmpty())
					{
						if (requete.substring(requete.length()-6, requete.length()).equals("WHERE "))
							requete = requete + "(facture.numfact like '%" + champsRefFac +"%' ";
						else
							requete = requete + "AND (facture.numfact like '%" + champsRefFac +"%' ";
						condtion_fact1 = "OR ";
						cfacture = true;
					}
	
					if (critereRefExp.equals("E") && !champsRefExp.isEmpty())
					{
						requete = requete + condtion_fact1+"facture.num_expense = '" + champsRefExp +"' ";
						cfacture = true;
					}
					else if (critereRefExp.equals("P") && !champsRefExp.isEmpty())
					{
						requete = requete + condtion_fact1+"facture.num_expense like '" + champsRefExp +"%' ";
						cfacture = true;
					}
					else if (critereRefExp.equals("C") && !champsRefExp.isEmpty())
					{
						requete = requete + condtion_fact1 +"facture.num_expense like '%" + champsRefExp +"%' ";
						cfacture = true;
					}
				}
				
				if (cfacture) requete = requete + ") ";

				if (cas.equalsIgnoreCase("facture_rejet"))
				{
					requete = requete + " AND EBIS_FACT_REJET.TOP_ETAT = 'AT'";
				}

				requete = requete + req_centre_frais + req_dpg_perim_me;
				return requete;
	 }
	
}

