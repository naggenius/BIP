package com.socgen.bip.action;

import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Hashtable;
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

import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.DatesEffetForm;
import com.socgen.bip.form.PersonneForm;
import com.socgen.bip.metier.Niveau;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author N.BACCAM - 20/06/2003
 * 
 * Action mise à jour des situations d'une personne chemin :
 * Ressources/MAJ/Personnes/Situation pages : fmSitupersAd.jsp et
 * mSitupersAd.jsp pl/sql : situper.sql
 */
public class SitupersAction extends PersonneAction {

	private static String PACK_SELECT = "situpers.consulter.proc";

	private static String PACK_INSERT = "situpers.creer.proc";

	private static String PACK_UPDATE = "situpers.modifier.proc";

	private static String PACK_DELETE = "situpers.supprimer.proc";

	// private static String PACK_SELECT_S = "personne.consulter_s.proc";
	private static String PACK_SELECT_LISTE_NIVEAUX = "recup.liste.niveaux.proc";

	private static String PACK_RECUP_SOCIETE="societe.recup.soccode";
	
	private static String PACK_RECUP_MODECONT="situpers.recup.modecont.proc";
	
	private static String PACK_RECUP_LIB_MCI="personne.recup.mci.lib.proc";

	private static String PACK_GETMCIDEFAUT = "personne.recup.mci.defaut.proc";
	
	private static String PACK_ISMCIOBLIGATOIRE = "personne.recup.mci.obligatoire.proc";

	// private String nomProc;

	/**
	 * Action qui permet de créer un code Situpers
	 */
	protected ActionForward creer(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		// boolean msg=false;
		// ParametreProc paramOut;

		String signatureMethode = "SitupersAction -creer( mapping, form , request,  response,  errors )";

		// logService.entry(signatureMethode);;
		logBipUser.entry(signatureMethode);
		// hParamProc.put("datsitu","");
		// exécution de la procédure PL/SQL
		try {

		
			
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT);
			// Récupération des résultats
			PersonneForm bipForm = (PersonneForm) form;
			/*
			 * bipForm.setCodsg((String)((ParametreProc)vParamOut.get(1)).getValeur());
			 * bipForm.setSoccode(((ParametreProc)vParamOut.get(2)).getValeur().toString());
			 * bipForm.setPrestation(((ParametreProc)vParamOut.get(3)).getValeur().toString());
			 * bipForm.setCpident(((ParametreProc)vParamOut.get(4)).getValeur().toString());
			 * bipForm.setRmcomp(((ParametreProc)vParamOut.get(5)).getValeur().toString());
			 * bipForm.setDispo(((ParametreProc)vParamOut.get(6)).getValeur().toString());
			 * bipForm.setCout(((ParametreProc)vParamOut.get(7)).getValeur().toString());
			 * bipForm.setDatsitu("");
			 */
			
			logBipUser.debug("Santoine soccide!!!!!!!!" +bipForm.getSoccode() );	
			
			bipForm.setCodsg((String) ((ParametreProc) vParamOut.get(1))
					.getValeur());
			bipForm.setSoccode(((ParametreProc) vParamOut.get(2)).getValeur()
					.toString());
			Object niveau = ((ParametreProc) vParamOut.get(3)).getValeur();
			if (niveau == null) {
				niveau = "";
			}
			// bipForm.setNiveau(((ParametreProc)vParamOut.get(3)).getValeur().toString());
			bipForm.setNiveau(niveau.toString());
			bipForm.setPrestation(((ParametreProc) vParamOut.get(4))
					.getValeur().toString());
			bipForm.setCpident(((ParametreProc) vParamOut.get(5)).getValeur()
					.toString());
			// bipForm.setRmcomp(((ParametreProc)vParamOut.get(6)).getValeur().toString());
			bipForm.setDispo(((ParametreProc) vParamOut.get(7)).getValeur()
					.toString());
			Object cout = ((ParametreProc) vParamOut.get(8)).getValeur();
			bipForm.setCode_domaine(((ParametreProc) vParamOut.get(13))
					.getValeur().toString());

			if (cout == null) {
				cout = "";
			}
			
			Object fident = ((ParametreProc) vParamOut.get(14)).getValeur();
			if (fident == null) {
				fident = "";
			}
			// bipForm.setCout(((ParametreProc)vParamOut.get(8)).getValeur().toString());
			bipForm.setCout(cout.toString());
			bipForm.setFident(fident.toString());
			bipForm.setDatsitu("");
			// int flag = new
			// Integer(((ParametreProc)vParamOut.get(9)).getValeur().toString()).intValue();
			int flag = new Integer(((ParametreProc) vParamOut.get(10))
					.getValeur().toString()).intValue();
			bipForm.setFlaglock(flag);
			
			// on recupere le mode contractuel
			if (((ParametreProc) vParamOut.get(15)).getValeur() != null) {
				bipForm.setModeContractuelInd(((ParametreProc) vParamOut.get(15))
					.getValeur().toString());
			}
			
			logBipUser.debug("Santoine222222 soccide!!!!!!!!" +bipForm.getSoccode() );	
			hParamProc.put("soccode",bipForm.getSoccode());
			// On recupere les infos sur la societé (libelle+siren)
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_RECUP_SOCIETE);
			bipForm.setLib_siren((String) ((ParametreProc) vParamOut
					.elementAt(0)).getValeur());
			bipForm.setLib_soccode((String) ((ParametreProc) vParamOut
					.elementAt(1)).getValeur());
			bipForm.setMsgErreur((String) ((ParametreProc) vParamOut
					.elementAt(2)).getValeur());
			
			
			
			logBipUser.debug("Santoine33333333 soccide!!!!!!!!" +bipForm.getSoccode() );	
			
			
		}// try
		catch (BaseException be) {
			logBipUser.debug("SitupersAction-creer() --> BaseException :" + be);
			logBipUser.debug("SitupersAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("SitupersAction-creer() --> BaseException :" + be);
			logService.debug("SitupersAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((PersonneForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");

			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}

		// logService.exit(signatureMethode);
		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	}// creer

	/**
	 * Action qui permet de visualiser les données liées à un code client pour
	 * la modification et la suppression
	 */
	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector(); 
		
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = "SitupersAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		PersonneForm bipForm = (PersonneForm) form;

		// exécution de la procédure PL/SQL
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT);
			
			// Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				// récupérer le message
				/*
				 * if (paramOut.getNom().equals("message")) {
				 * message=(String)paramOut.getValeur(); }
				 */
				
				//System.out.println("Nbre des param out :" +  vParamOut.size());
				//Recuperation du mode contractuel
				if (paramOut.getNom().equals("modeContractuelInd")) {
									
					bipForm.setModeContractuelInd((String)paramOut.getValeur());
				}
				
				if (paramOut.getNom().equals("lib_mci")) {
					
					bipForm.setLib_mci((String)paramOut.getValeur());
				}
				
				
				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();

					try {
						logService.debug("ResultSet");
						if (rset.next()) {

							/*
							 * bipForm.setIdent(rset.getString(1));
							 * bipForm.setRnom(rset.getString(2));
							 * bipForm.setRprenom(rset.getString(3));
							 * bipForm.setMatricule(rset.getString(4));
							 * bipForm.setDatsitu(rset.getString(5));
							 * bipForm.setDatdep(rset.getString(6));
							 * bipForm.setCodsg(rset.getString(7));
							 * bipForm.setFilcode(rset.getString(8));
							 * bipForm.setSoccode(rset.getString(9));
							 * bipForm.setPrestation(rset.getString(10));
							 * bipForm.setCpident(rset.getString(11));
							 * bipForm.setRmcomp(rset.getString(12));
							 * bipForm.setDispo(rset.getString(13));
							 * bipForm.setCout(rset.getString(14));
							 * bipForm.setOldatsitu(rset.getString(15));
							 * bipForm.setFlaglock(rset.getInt(16));
							 */
							bipForm.setIdent(rset.getString(1));
							bipForm.setRnom(rset.getString(2));
							bipForm.setRprenom(rset.getString(3));
							bipForm.setMatricule(rset.getString(4));
							bipForm.setDatsitu(rset.getString(5));
							bipForm.setDatdep(rset.getString(6));
							bipForm.setCodsg(rset.getString(7));

							bipForm.setSoccode(rset.getString(8));
							bipForm.setNiveau(rset.getString(9));
							bipForm.setPrestation(rset.getString(10));
							bipForm.setCpident(rset.getString(11));
							// bipForm.setRmcomp(rset.getString(12));
							bipForm.setDispo(rset.getString(13));
							bipForm.setCout(rset.getString(14));
							bipForm.setOldatsitu(rset.getString(15));
							bipForm.setFlaglock(rset.getInt(16));
							bipForm.setCode_domaine(rset.getString(17));
							bipForm.setFident(rset.getString(18));
							bipForm.setIgg(rset.getString(19));
							
//							 On recupere les infos sur la societé (libelle+siren)
							vParamOut = jdbc.getResult(
									hParamProc, configProc, PACK_RECUP_SOCIETE);
							bipForm.setLib_siren((String) ((ParametreProc) vParamOut
									.elementAt(0)).getValeur());
							bipForm.setLib_soccode((String) ((ParametreProc) vParamOut
									.elementAt(1)).getValeur());
							bipForm.setMsgErreur((String) ((ParametreProc) vParamOut
									.elementAt(2)).getValeur());
							
						} else
							msg = true;

					}// try
					catch (SQLException sqle) {
						logService
								.debug("SitupersAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("SitupersAction-consulter() --> SQLException :"
										+ sqle);
						// Erreur de lecture du resultSet
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11217"));
						// this.saveErrors(request,errors);
						 jdbc.closeJDBC(); return mapping.findForward("error");
					} finally {
						try {
							if (rset != null)
								rset.close();
						} catch (SQLException sqle) {
							logBipUser
									.debug("SitupersAction-consulter() --> SQLException-rset.close() :"
											+ sqle);
							// Erreur de lecture du resultSet
							errors.add(ActionErrors.GLOBAL_ERROR,
									new ActionError("11217"));
							 jdbc.closeJDBC(); return mapping.findForward("error");
						}

					}
				}// if
			}// for
			if (msg) {
				// le code Situpers n'existe pas, on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}		
			
			logBipUser.debug("SitupersAction-consulter() --> mci_obligatoire :");
			Hashtable<String,String> lParamProc = new Hashtable<String,String>();
			lParamProc.put("codsg", bipForm.getCodsg());
			vParamOut = jdbc.getResult(
					lParamProc, configProc, PACK_ISMCIOBLIGATOIRE);
			// Récupération des résultats
			for (Enumeration e1 = vParamOut.elements(); e1.hasMoreElements();) {
				paramOut = (ParametreProc) e1.nextElement();
				
				if (paramOut.getNom().equals("mci_obligatoire")) {
					if (paramOut.getValeur() != null)
						bipForm.setMciObligatoire((String) paramOut.getValeur());
				}								
			}		
						
			// verifie si le mci est calcule ou pas

			if ( "DI".equals(bipForm.getCode_domaine()) && 
					(    "SLT".equals(bipForm.getPrestation()) 
					  || "IFO".equals(bipForm.getPrestation()) 
					)
				   ) {				
				
					Hashtable<String,String> tParamProc = new Hashtable<String,String>();					
					tParamProc.put("prestation", bipForm.getPrestation());					
					if ( "SLT".equals(bipForm.getPrestation()) ) {
						tParamProc.put("fident", bipForm.getFident());
					} else {
						tParamProc.put("fident", "0");
					}
					tParamProc.put("cpident", bipForm.getCpident());
					tParamProc.put("datsitu", bipForm.getDatsitu());
					if (bipForm.getDatdep() != null) {
						tParamProc.put("datdep", bipForm.getDatdep());
					}
															
					logBipUser.debug("SitupersAction-consulter() --> GETMCIDEFAUT ");
					vParamOut = jdbc.getResult(
							tParamProc, configProc, PACK_GETMCIDEFAUT);
					
					// Récupération des résultats
					for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
						paramOut = (ParametreProc) e.nextElement();

						if (paramOut.getNom().equals("modeContractuelInd")) {
							String oldMci = bipForm.getModeContractuelInd();
							
							if (paramOut.getValeur() != null) {
								
								bipForm.setModeContractuelInd( (String) paramOut.getValeur() );
								bipForm.setMciCalcule("O");
								if ( !paramOut.getValeur().equals(oldMci) ) {
									bipForm.setMciAlert("O");
								}
								
							}

						}// if
					}// for											
				}
			
			// Récupération de la liste des niveaux
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT_LISTE_NIVEAUX);
			// Vector vListe = new Vector();
			// Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();
				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();
					try {
						java.util.List liste = new ArrayList();
						while (rset.next()) {
							liste.add(new Niveau(rset.getString(1), rset
									.getString(2)));
						}
						rset.close();
						request.setAttribute("liste", liste);
					}// try
					catch (SQLException sqle) {
						 jdbc.closeJDBC(); return mapping.findForward(processException(this
								.getClass().getName(), "consulter", sqle,
								bipForm, request));
					}
				}// if
			}// for

		}// try
		catch (BaseException be) {
			logBipUser.debug("SitupersAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("SitupersAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("SitupersAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("SitupersAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((PersonneForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");

			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}

		request.setAttribute("personneForm", bipForm);
		logBipUser.exit(signatureMethode);
		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	}

	public ActionForward retour(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		return mapping.findForward("retour");

	}
	
	protected ActionForward refresh(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		PersonneForm bipForm = (PersonneForm) form;
		// Intitulé à charger
		String focus = bipForm.getFocus();

		Vector vParamOut = new Vector();

		ParametreProc paramOut;
		String message = "";
		
		try {
			
			bipForm.setMciCalcule("N");
			bipForm.setMciObligatoire("N");
			
			if ("soccode".equals(focus)) {	
				// recherche du siren et du libelle societe
				vParamOut = jdbc.getResult(
						hParamProc, configProc, PACK_RECUP_SOCIETE);
				bipForm.setLib_siren((String) ((ParametreProc) vParamOut
						.elementAt(0)).getValeur());
				bipForm.setLib_soccode((String) ((ParametreProc) vParamOut
						.elementAt(1)).getValeur());
				
				if (bipForm.getSoccode().equals("SG.."))
				{
					bipForm.setRtype("A");
				}
				else
				{
					bipForm.setRtype("P");
				}
				bipForm.setMsgErreur((String) ((ParametreProc) vParamOut
						.elementAt(2)).getValeur());
				
				if (bipForm.getMsgErreur() != null)
					bipForm.setFocus("soccode");
				else
					if( bipForm.getSoccode().equals("SG.."))
						bipForm.setFocus("cpident");
					else
						bipForm.setFocus("modeContractuelInd");
						
			}			
			
				// Recherche du mode contractuel
			
				vParamOut = jdbc.getResult(
						hParamProc, configProc, PACK_RECUP_MODECONT);
				bipForm.setModeContractuelInd((String) ((ParametreProc) vParamOut
						.elementAt(0)).getValeur());
				
				// On enrichie pour un type de prestation SLT ou IFO
				bipForm.setMciAlert("N");
				bipForm.setMciCalcule("N");
				
				if ( "DI".equals(bipForm.getCode_domaine()) && 
						(    "SLT".equals(bipForm.getPrestation()) 
						  || "IFO".equals(bipForm.getPrestation()) 
						)
					   ) {
					
					vParamOut = jdbc.getResult(
							hParamProc, configProc, PACK_GETMCIDEFAUT);
					
					// Récupération des résultats
					for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
						paramOut = (ParametreProc) e.nextElement();
		
						// récupérer le message
						if (paramOut.getNom().equals("message")) {
							message = (String) paramOut.getValeur();
		
						}
						if (paramOut.getNom().equals("modeContractuelInd")) {
							String oldMci = bipForm.getModeContractuelInd();
							
							if (paramOut.getValeur() != null) {
								bipForm.setMciCalcule("O");
								bipForm.setModeContractuelInd( (String) paramOut.getValeur() );
								if (!paramOut.getValeur().equals(oldMci)) {
									bipForm.setMciAlert("O");
								}
							} else {
								bipForm.setMciCalcule("N");	
							}

						}// if
						
						if (paramOut.getNom().equals("lib_mci")) {
							
							bipForm.setLib_mci( (String) paramOut.getValeur() );
						}
					}// for											
				}

				if (bipForm.getModeContractuelInd() != null)
					hParamProc.put("modeContractuelInd",bipForm.getModeContractuelInd());
				
				vParamOut = jdbc.getResult(
						hParamProc, configProc, PACK_RECUP_LIB_MCI);
				bipForm.setLib_mci((String) ((ParametreProc) vParamOut
						.elementAt(0)).getValeur());
				
				logBipUser.debug("SitupersAction-consulter() --> mci_obligatoire :");
				Hashtable<String,String> lParamProc = new Hashtable<String,String>();
				lParamProc.put("codsg", bipForm.getCodsg());
				vParamOut = jdbc.getResult(
						lParamProc, configProc, PACK_ISMCIOBLIGATOIRE);
				// Récupération des résultats
				for (Enumeration e1 = vParamOut.elements(); e1.hasMoreElements();) {
					paramOut = (ParametreProc) e1.nextElement();
					
					if (paramOut.getNom().equals("mci_obligatoire")) {
						if (paramOut.getValeur() != null)
							bipForm.setMciObligatoire((String) paramOut.getValeur());
					}								
				}
				
				// MAJ du Focus
				if ("datsitu".equals(focus))	
					bipForm.setFocus("datdep");
		
				if ("datdep".equals(focus))	
					bipForm.setFocus("codsg");
				
				if ("modeContractuelInd".equals(focus))	
					bipForm.setFocus("cpident");
					
					
				
		} catch (BaseException be) {
			logBipUser.debug("PersonneAction-refresh() --> BaseException :" + be,
					be);
			logBipUser.debug("PersonneAction-refresh() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("PersonneAction-refresh() --> BaseException :" + be,
					be);
			logService.debug("PersonneAction-refresh() --> Exception :"
					+ be.getInitialException().getMessage());
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));

			// this.saveErrors(request,errors);
			 jdbc.closeJDBC(); return mapping.findForward("error");
		}
		
		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	}
	
	protected String recupererCle(String mode) {
		String cle = null;
		if (mode.equals("insert")) {
			cle = PACK_INSERT;
		} else if (mode.equals("update")) {
			cle = PACK_UPDATE;
		} else if (mode.equals("delete")) {
			cle = PACK_DELETE;
		}
		  return cle;
	}
/*	
	//Action dédiée à un appel Ajax qui vérifie l'appartenance d'un DPG a un centre de frais
	 public ActionForward isMciObligatoire(ActionMapping mapping, ActionForm form,
			 HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc) throws Exception
	 {
		String signatureMethode = "isMciObligatoire(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors )";
		logBipUser.entry(signatureMethode);
		
		//String userid = ((UserBip)request.getSession().getAttribute("UserBip")).getInfosUser();
		String codsg = (String)request.getParameter("codsg");
	  
	  JdbcBip jdbc = new JdbcBip(); 
	  Vector vParamOut = new Vector();
	  String message = "";
	  ParametreProc paramOut;
	  Hashtable<String,String> lParamProc = new Hashtable<String,String>();
	  
	  lParamProc.put("codsg", codsg);
	  //lParamProc.put("userid", userid);  

	  // exécution de la procédure PL/SQL
		try {
		
			vParamOut = jdbc.getResult(
					lParamProc, configProc, PACK_ISMCIOBLIGATOIRE);
			// Récupération des résultats
			
			for (Enumeration e1 = vParamOut.elements(); e1.hasMoreElements();) {
				paramOut = (ParametreProc) e1.nextElement();
				
				if (paramOut.getNom().equals("mci_obligatoire")) {
					if (paramOut.getValeur() != null)
						message = (String) paramOut.getValeur();
				}
								
			}			
			
		}// try
		catch (BaseException be) {
			logBipUser.debug("PersonneAction-isMciObligatoire() --> BaseException :" + be);
			logBipUser.debug("PersonneAction-isMciObligatoire() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("PersonneAction-isMciObligatoire() --> BaseException :" + be);
			logService.debug("PersonneAction-isMciObligatoire() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((DatesEffetForm) form).setMsgErreur(message);
				 jdbc.closeJDBC();
//				 On écrit le message de retour du pl/sql dans la response
				  response.setContentType("text/html");
				  PrintWriter out = response.getWriter();
				  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
				  out.flush();
				  return PAS_DE_FORWARD;

			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC();
//				 On écrit le message de retour du pl/sql dans la response
				  response.setContentType("text/html");
				  PrintWriter out = response.getWriter();
				  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
				  out.flush();
				  return PAS_DE_FORWARD;
			}
		}

		 jdbc.closeJDBC();

	  // On écrit le message de retour du pl/sql dans la response
	  response.setContentType("text/html");
	  PrintWriter out = response.getWriter();
	  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
	  out.flush();

	  return PAS_DE_FORWARD;
	 }
	 
	//Action dédiée à un appel Ajax qui recupere le MCI calcule.
	 public ActionForward getMciDefaut(ActionMapping mapping, ActionForm form,
			 HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc) throws Exception
	 {
		String signatureMethode = "getMciDefaut(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors )";
		logBipUser.entry(signatureMethode);
		
		String prestation = (String)request.getParameter("prestation");
		String cpident = (String)request.getParameter("cpident");
		String fident = (String)request.getParameter("fident");
		String datsitu = (String)request.getParameter("datsitu");
		String datdep = (String)request.getParameter("datdep");
   	
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		ParametreProc paramOut;
		Hashtable<String,String> lParamProc = new Hashtable<String,String>();
		
		lParamProc.put("prestation", prestation);
		lParamProc.put("fident", fident);
		lParamProc.put("cpident", cpident);	
		lParamProc.put("datsitu", datsitu);
		lParamProc.put("datdep", datdep);  

		String mci = "";
		String libmci = "";
		
	  // exécution de la procédure PL/SQL
		try {
		
			vParamOut = jdbc.getResult(
					lParamProc, configProc, PACK_GETMCIDEFAUT);
			// Récupération des résultats
			
			for (Enumeration e1 = vParamOut.elements(); e1.hasMoreElements();) {
				paramOut = (ParametreProc) e1.nextElement();
				
				if (paramOut.getNom().equals("modeContractuelInd")) {
					if (paramOut.getValeur() != null)
						mci = (String) paramOut.getValeur();
				}
				if (paramOut.getNom().equals("lib_mci")) {
					if (paramOut.getValeur() != null)
						libmci = (String) paramOut.getValeur();
				}
				
			}
			
			message = mci + ';' + libmci;			
			
		}// try
		catch (BaseException be) {
			logBipUser.debug("PersonneAction-getMciDefaut() --> BaseException :" + be);
			logBipUser.debug("PersonneAction-getMciDefaut() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("PersonneAction-getMciDefaut() --> BaseException :" + be);
			logService.debug("PersonneAction-getMciDefaut() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((DatesEffetForm) form).setMsgErreur(message);
				 jdbc.closeJDBC();
//				 On écrit le message de retour du pl/sql dans la response
				  response.setContentType("text/html");
				  PrintWriter out = response.getWriter();
				  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
				  out.flush();
				  return PAS_DE_FORWARD;

			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC();
//				 On écrit le message de retour du pl/sql dans la response
				  response.setContentType("text/html");
				  PrintWriter out = response.getWriter();
				  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
				  out.flush();
				  return PAS_DE_FORWARD;
			}
		}

		 jdbc.closeJDBC();

	  // On écrit le message de retour du pl/sql dans la response
	  response.setContentType("text/html");
	  PrintWriter out = response.getWriter();
	  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
	  out.flush();

	  return PAS_DE_FORWARD;
	 }
*/	 
}
