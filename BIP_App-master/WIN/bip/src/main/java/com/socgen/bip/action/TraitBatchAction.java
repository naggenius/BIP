package com.socgen.bip.action;

import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.upload.FormFile;

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.commun.action.BipAction;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.exception.BipIOException;
import com.socgen.bip.form.TraitBatchForm;
import com.socgen.bip.metier.TraitBatch;
import com.socgen.bip.util.BipDateUtil;
import com.socgen.bip.util.BipUtil;
import com.socgen.cap.fwk.config.ConfigManager;
import com.socgen.cap.fwk.exception.BaseException;

public class TraitBatchAction extends AutomateAction implements BipConstantes {

	// Obtention de la liste des shells associ�s � une date de lancement donn�e (table trait_batch)
	private static String PACK_SELECT = "traitBatch.consulter.proc";

	// Obtention des �ventuelles erreurs / donn�es pour un identifiant de traitement batch donn� (table TRAIT_BATCH_RETOUR)
	private static String PACK_SELECT_CSV = "traitBatch.consulter_csv.proc";
	// Inseertion dans TRAIT_BATCH
	private static String PACK_INSERT = "traitBatch.creer.proc";
	
	private static String PACK_DELETE = "traitBatch.supprimer.proc";
	
	// Obtention de la liste des shells pr�sents dans l'application (table LISTE_SHELL)
	private static String PACK_LISTE_SHELL = "recup.id.traitement.proc";
	
	private static String PACK_UPLOAD_FICHIER = "traitBatch.generer.fichier.proc";
	
	private static String NOM_FICHIER_RETOUR_COURT = "trait_batch_retour";
	
	/******************
	  PREPARATION RECYCLAGE RESSOURCES - DEBUT
	*******************/
	// id 3 en prod, id 7 en homo
	private final static int ID_SHELL_PREPA_RECYCL_RESS = 3;
	/** 
	 * 1er �l�ment de l'en-t�te du fichier csv
	*/
	private final static String PREMIERE_COLONNE_ENTETE = "IDENT";
	/** 
	 * 2�me �l�ment de l'en-t�te du fichier csv
	*/
	private final static String DEUXIEME_COLONNE_ENTETE = "DATE_AUPLUSTOT";
	/**
	 * Format CSV
	 */
	private final static String CONTENT_TYPE_CSV = "application/vnd.ms-excel";
	private final static String EXTENSION_CSV = "csv";
	/**
	 * Taille max fichier csv : 500 Mo <=> 500000000
	 */
	private final static int TAILLE_MAX_FICHIER_CSV = 500000000;
	
	/**
	 * Format de date
	 */
	private final static String FORMAT_DATE = "dd-MM-yyyy";
	/******************
	  PREPARATION RECYCLAGE RESSOURCES - FIN
	*******************/
	
	/**
	 * Le r�pertoire dans lequel les fichiers sont cr�es physiquement
	 */
	protected static final String sUrl =
		ConfigManager
			.getInstance(BIP_REPORT)
			.getString("extractParam.fichier");
	/**
	 * Cr�ation d'un fichier CSV si une erreur est survenue lors de l'ex�cution du batch
	 * @param file_name
	 * @param id_batch
	 * @param form
	 * @param request
	 */
	private void creer_fichier_csv (String file_name, String id_batch, ActionForm form,HttpServletRequest request) {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		ParametreProc paramOut;

		String signatureMethode = "TraitBatchAction-creer_fichier_csv(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Cr�ation d'une nouvelle form
		TraitBatchForm bipForm = (TraitBatchForm) form;
		bipForm.setMsgErreur("");

		
		Hashtable<String,String> lParamProc = new Hashtable<String,String>();
		lParamProc.put("id_batch", id_batch);

		
		// ex�cution de la proc�dure PL/SQL
		try {
			vParamOut = jdbc.getResult(
					lParamProc, configProc, PACK_SELECT_CSV);

			// R�cup�ration des r�sultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				// r�cup�rer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();

				}
				//On r�cup�re les valeurs
				if (paramOut.getNom().equals("curseur")) {
					// R�cup�ration du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();
					String full_path = file_name;
					
     			    FileWriter fw = new FileWriter(full_path);
				
					try {
						while (rset.next()) {
						  fw.append(rset.getString(1));
						  fw.append(';');
						  fw.append(rset.getString(2));
						  fw.append('\n');
						} 
						fw.flush();
                        fw.close();

					}// try
					catch (SQLException sqle) {
						logService
								.debug("TraitBatchAction-creer_fichier_csv() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("TraitBatchAction-creer_fichier_csv() --> SQLException :"
										+ sqle);
						// Erreur de lecture du resultSet
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11217"));
						// this.saveErrors(request,errors);
						 jdbc.closeJDBC();
					} finally {
						try {
							if (rset != null)
								rset.close();
						} catch (SQLException sqle) {
							logBipUser
									.debug("TraitBatchAction-creer_fichier_csv() --> SQLException-rset.close() :"
											+ sqle);
							// Erreur de lecture du resultSet
							errors.add(ActionErrors.GLOBAL_ERROR,
									new ActionError("11217"));
							 jdbc.closeJDBC();
						}

					}
				}// if
			}// for
		}// try
		catch (BaseException be) {
			logBipUser.debug("TraitBatchAction-creerCsv() --> BaseException :"
					+ be, be);
			logBipUser.debug("TraitBatchAction-creerCsv() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("TraitBatchAction-creerCsv() --> BaseException :"
					+ be, be);
			logService.debug("TraitBatchAction-creerCsv() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((TraitBatchForm) form).setMsgErreur(message);
				 jdbc.closeJDBC();

			} else {
				// Erreur d''ex�cution de la proc�dure stock�e
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC();
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			BipAction.logBipUser.error("Error. Check the code", e);
		}

		logBipUser.exit(signatureMethode);

		jdbc.closeJDBC(); 
		
	}
		
	/**
	 * Action qui permet de visualiser les traitements planifi�s pour
	 * un jour donn�
	 */
	public ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		ParametreProc paramOut;

		String signatureMethode = "TraitBatchAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Cr�ation d'une nouvelle form
		TraitBatchForm bipForm = (TraitBatchForm) form;
		bipForm.setMsgErreur("");

		// ex�cution de la proc�dure PL/SQL
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT);

			// R�cup�ration des r�sultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				// r�cup�rer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();
				}
				
				//On r�cup�re les valeurs
				if (paramOut.getNom().equals("curseur")) {
					// R�cup�ration du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();
					ArrayList<TraitBatch> listeTrait = new ArrayList<TraitBatch>(); 
					try {
						while (rset.next()) {
							
							TraitBatch trait = new TraitBatch(String.valueOf(rset.getInt(1)),rset.getString(3),rset.getString(5),String.valueOf(rset.getInt(2)),rset.getString(4),null,rset.getString(7), rset.getString(8), rset.getString(9) );
							
							// Creation du fichier si retour fichier = "O"
							if ( "O".equals( rset.getString(8) ) ) {
								String nom_complet_fichier = sUrl + NOM_FICHIER_RETOUR_COURT + "_" + String.valueOf(rset.getInt(1)) +".csv";
								creer_fichier_csv (nom_complet_fichier, String.valueOf(rset.getInt(1)), bipForm, request);
								// Alimentation du lien vers le fichier csv listant les lignes en erreur
								trait.setFichier_retour("rapport/"+NOM_FICHIER_RETOUR_COURT + "_" + String.valueOf(rset.getInt(1)) +".csv");
							}							
							
							trait.setTailleClob(String.valueOf(rset.getInt(6)));
							listeTrait.add(trait);
						} 
						bipForm.setListeTraitBatch(listeTrait);
						bipForm.setSize(listeTrait.size());
					}// try
					catch (SQLException sqle) {
						logService
								.debug("TraitBatchAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("TraitBatchAction-consulter() --> SQLException :"
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
									.debug("TraitBatchAction-suite() --> SQLException-rset.close() :"
											+ sqle);
							// Erreur de lecture du resultSet
							errors.add(ActionErrors.GLOBAL_ERROR,
									new ActionError("11217"));
							 jdbc.closeJDBC(); return mapping.findForward("error");
						}

					}
				}// if
			}// for
		}// try
		catch (BaseException be) {
			logBipUser.debug("TraitBatchAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("TraitBatchAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("TraitBatchAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("TraitBatchAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((TraitBatchForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");

			} else {
				// Erreur d''ex�cution de la proc�dure stock�e
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}

		logBipUser.exit(signatureMethode);

	 
			// ex�cution de la proc�dure PL/SQL
			try {
				vParamOut = jdbc.getResult(
						hParamProc, configProc, PACK_LISTE_SHELL);

				// R�cup�ration des r�sultats
				for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
					paramOut = (ParametreProc) e.nextElement();

					// r�cup�rer le message
					if (paramOut.getNom().equals("message")) {
						message = (String) paramOut.getValeur();

					}
					//On r�cup�re les valeurs pour deux usages
					//1) Les modifications
					//2) Un rollback manuel si les nouvelles donn�es sont mauvaises
					if (paramOut.getNom().equals("curseur")) {
						// R�cup�ration du Ref Cursor
						ResultSet rset = (ResultSet) paramOut.getValeur();
						ArrayList<TraitBatch> listeTrait = new ArrayList<TraitBatch>(); 
						try {
							while (rset.next()) {
								TraitBatch trait = new TraitBatch("-1",rset.getString(2),rset.getString(3),String.valueOf(rset.getInt(1)),null,null,null,null,null);
								listeTrait.add(trait);
							} 
							bipForm.setListeShell(listeTrait);
						}// try
						catch (SQLException sqle) {
							logService
									.debug("TraitBatchAction-consulter() --> SQLException :"
											+ sqle);
							logBipUser
									.debug("TraitBatchAction-consulter() --> SQLException :"
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
										.debug("TraitBatchAction-suite() --> SQLException-rset.close() :"
												+ sqle);
								// Erreur de lecture du resultSet
								errors.add(ActionErrors.GLOBAL_ERROR,
										new ActionError("11217"));
								 jdbc.closeJDBC(); return mapping.findForward("error");
							}

						}
					}// if
				}// for
			}// try
			catch (BaseException be) {
				logBipUser.debug("TraitBatchAction-consulter() --> BaseException :"
						+ be, be);
				logBipUser.debug("TraitBatchAction-consulter() --> Exception :"
						+ be.getInitialException().getMessage());

				logService.debug("TraitBatchAction-consulter() --> BaseException :"
						+ be, be);
				logService.debug("TraitBatchAction-consulter() --> Exception :"
						+ be.getInitialException().getMessage());
				// Si exception sql alors extraire le message d'erreur du message
				// global
				if (be.getInitialException().getClass().getName().equals(
						"java.sql.SQLException")) {
					message = BipException.getMessageFocus(
							BipException.getMessageOracle(be.getInitialException()
									.getMessage()), form);
					((TraitBatchForm) form).setMsgErreur(message);
					 jdbc.closeJDBC(); return mapping.findForward("initial");

				} else {
					// Erreur d''ex�cution de la proc�dure stock�e
					errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
					request.setAttribute("messageErreur", be.getInitialException()
							.getMessage());
					// this.saveErrors(request,errors);
					 jdbc.closeJDBC(); return mapping.findForward("error");
				}
			}

			logBipUser.exit(signatureMethode);

			 jdbc.closeJDBC(); 

		 if(bipForm.getListeShell().size()!=0){
			 bipForm.setInfos_shell(bipForm.getListeShell().get(0).getInfos_shell());
		 }else{
			 bipForm.setInfos_shell("Aucun fichier en entr�e");
		 }
		 
		 return mapping.findForward("ecran");
	}
	
	/**
	 * Action qui permet de visualiser les traitements planifi�s pour
	 * un jour donn�
	 */
	public ActionForward maj(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		String message = "";
		Vector vParamOut = new Vector();
		ParametreProc paramOut;

		String signatureMethode = "TraitBatchAction-maj(paramProc, mapping, form , request,  response,  errors )";
		// Premi�re �tape, on supprime tous les traitements supprim�s via l'IHM
		logBipUser.entry(signatureMethode);
		// Cr�ation d'une nouvelle form
		TraitBatchForm bipForm = (TraitBatchForm) form;
		
		String[] listeTraitSuppr = bipForm.getListeTraitSuppr().split(",");
		for(int i=0;i<listeTraitSuppr.length;i++){
			if(listeTraitSuppr[i]!=null && !"".equals(listeTraitSuppr[i]) && !"-1".equals(listeTraitSuppr[i])){
				hParamProc.put("id_trait_batch", listeTraitSuppr[i]);
				//On supprime en base les �l�ments retir�s par l'utilisateur
		//		// ex�cution de la proc�dure PL/SQL
				try {
					jdbc.getResult(
							hParamProc, configProc, PACK_DELETE);
		
				}// try
				catch (BaseException be) {
					logBipUser.debug("TraitBatchAction-maj() --> BaseException :"
							+ be, be);
					logBipUser.debug("TraitBatchAction-maj() --> Exception :"
							+ be.getInitialException().getMessage());
		
					logService.debug("TraitBatchAction-maj() --> BaseException :"
							+ be, be);
					logService.debug("TraitBatchAction-maj() --> Exception :"
							+ be.getInitialException().getMessage());
					// Si exception sql alors extraire le message d'erreur du message
					// global
					if (be.getInitialException().getClass().getName().equals(
							"java.sql.SQLException")) {
						message = BipException.getMessageFocus(
								BipException.getMessageOracle(be.getInitialException()
										.getMessage()), form);
						((TraitBatchForm) form).setMsgErreur(message);
						 jdbc.closeJDBC(); return mapping.findForward("initial");
		
					} else {
						// Erreur d''ex�cution de la proc�dure stock�e
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
						request.setAttribute("messageErreur", be.getInitialException()
								.getMessage());
						// this.saveErrors(request,errors);
						 jdbc.closeJDBC(); return mapping.findForward("error");
					}
				}
			}
		}
		String logUpload = "";
		StringBuffer messageFichiersInvalides = new StringBuffer();

		//Puis on fait un merge sur les traitements restant, c�d soit un update, soit un insert
		for(TraitBatch trait : bipForm.getListeTraitBatch()){
			//On n'ins�re pas les lignes qui ont �t� supprim�es dans l'IHM
			if("".equals(trait.getFlagSuppr())){
				// S'il s'agit du batch ressources_prepa_recyclage.sh et que le fichier d'entr�e est valide
				// Ou s'il s'agit d'un autre batch
				if ((String.valueOf(ID_SHELL_PREPA_RECYCL_RESS).equals(trait.getId_shell())
						&& estFichierValide(trait, messageFichiersInvalides))
						|| !String.valueOf(ID_SHELL_PREPA_RECYCL_RESS).equals(trait.getId_shell())) {
					// Continuer
					// On initialise l'heure de la date avec le champ String de l'heure planifi�e
					trait.changeHeureShell();
					hParamProc.put("id_trait_batch", trait.getId_trait_batch());
					hParamProc.put("id_shell", trait.getId_shell());
					hParamProc.put("date_shell", trait.getDate_shell());
					// ex�cution de la proc�dure PL/SQL
					try {
						vParamOut = jdbc.getResult(
								hParamProc, configProc, PACK_INSERT);
						//Dans le cas d'un nouveau traitement, on r�cup�re l'id que lui a attribu� la proc�dure d'insert
						if("-1".equals(trait.getId_trait_batch())){
							// R�cup�ration des r�sultats
							for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
								paramOut = (ParametreProc) e.nextElement();
		
								// r�cup�rer le message
								if (paramOut.getNom().equals("message")) {
									trait.setId_trait_batch((String) paramOut.getValeur());
								}
							}
						}
					}// try
					catch (BaseException be) {
						logBipUser.debug("TraitBatchAction-maj() --> BaseException :"
								+ be, be);
						logBipUser.debug("TraitBatchAction-maj() --> Exception :"
								+ be.getInitialException().getMessage());
		
						logService.debug("TraitBatchAction-maj() --> BaseException :"
								+ be, be);
						logService.debug("TraitBatchAction-maj() --> Exception :"
								+ be.getInitialException().getMessage());
						// Si exception sql alors extraire le message d'erreur du message
						// global
						if (be.getInitialException().getClass().getName().equals(
								"java.sql.SQLException")) {
							message = BipException.getMessageFocus(
									BipException.getMessageOracle(be.getInitialException()
											.getMessage()), form);
							((TraitBatchForm) form).setMsgErreur(message);
							 
							 jdbc.closeJDBC(); 
							 return mapping.findForward("initial");
		
						} else {
							// Erreur d''ex�cution de la proc�dure stock�e
							errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
							request.setAttribute("messageErreur", be.getInitialException()
									.getMessage());
							// this.saveErrors(request,errors);
							 jdbc.closeJDBC();
							 return mapping.findForward("error");
						}
					}
					try{
					if(trait.getFichier()!=null && !"".equals(trait.getFichier().getFileName())){
						Vector contenu = BipUtil.loadFile(trait.getFichier());
						//Puis on charge les form files dans le champ clob des lignes qu'on vient de modifier/cr�er
						jdbc.alimCLOB(jdbc.DATASOURCE_REMONTEE, "TRAIT_BATCH", "DATA_FICH", "ID_TRAIT_BATCH="+trait.getId_trait_batch(), contenu);
						
						//On rouvre la connexion, ferm�e par alimCLOB
						jdbc = new JdbcBip();
					}
					}catch(BaseException be){
						logBipUser.debug("TraitBatchAction-maj() --> BaseException :"
								+ be, be);
						logBipUser.debug("TraitBatchAction-maj() --> Exception :"
								+ be.getInitialException().getMessage());
		
						logService.debug("TraitBatchAction-maj() --> BaseException :"
								+ be, be);
						logService.debug("TraitBatchAction-maj() --> Exception :"
								+ be.getInitialException().getMessage());
						logBipUser.debug("Fichier pour "+trait.getInfos_shell()+" a g�n�r� une Base Exception");
						logUpload = " Certains fichiers n'ont pu �tre upload�s.";
					}catch(BipIOException ie){
						logBipUser.debug("Erreur dans le traitement du fichier pour "+trait.getInfos_shell());
						logUpload = " Certains fichiers n'ont pu �tre upload�s.";
					}
					//Puis on appelle la proc�dure qui g�n�re le champ blob avec le fichier sur le serveur de bd
					// ex�cution de la proc�dure PL/SQL
					//On g�n�re le fichier sur le serveur via le script shell finalement, juste avant l'ex�cution du traitement
//					
//					if(trait.getFichier()!=null && !"".equals(trait.getFichier().getFileName())){
//						hParamProc.put("chemin", repertoire);
//						hParamProc.put("nom_fichier", trait.getNom_fich());
//						try {
//							jdbc.getResult(
//									hParamProc, configProc, PACK_UPLOAD_FICHIER);
//						}// try
//						catch (BaseException be) {
//							logBipUser.debug("TraitBatchAction-maj() --> BaseException :"
//									+ be, be);
//							logBipUser.debug("TraitBatchAction-maj() --> Exception :"
//									+ be.getInitialException().getMessage());
//		
//							logService.debug("TraitBatchAction-maj() --> BaseException :"
//									+ be, be);
//							logService.debug("TraitBatchAction-maj() --> Exception :"
//									+ be.getInitialException().getMessage());
//							// Erreur d''ex�cution de la proc�dure stock�e
//							errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
//							request.setAttribute("messageErreur", be.getInitialException()
//									.getMessage());
//							// this.saveErrors(request,errors);
//						}
//					}	
					
				}
				// Sinon passage � l'it�ration suivante
			}
		}
		
		if (messageFichiersInvalides.length() != 0) {
			bipForm.setMsgErreur(messageFichiersInvalides.toString());
		}
		else {
			bipForm.setMsgErreur("Traitements du "+bipForm.getJour()+" mis � jour avec succ�s."+logUpload);
		}
		
		logBipUser.exit(signatureMethode);
		 jdbc.closeJDBC(); return mapping.findForward("initial");
	}

	/**
	 * V�rification de la validit� du fichier du traitement
	 * Concat�nation d'un �ventuel message d'invalidit� au message existant
	 * @param trait
	 * @param messageFichiersInvalides
	 * @return
	 */
	private boolean estFichierValide(TraitBatch trait, StringBuffer messageFichiersInvalides) {
		String messageFichierInvalide = estFichierValide(trait.getFichier());
		
		// Si le fichier n'est pas valide
		if (messageFichierInvalide != null) {
			// Si un message est d�j� pr�sent
			if (messageFichiersInvalides.length() != 0) {
				// Ajout d'un s�parateur
				messageFichiersInvalides.append("; ");
			}
			// Ajout du nouveau message
			messageFichiersInvalides.append(messageFichierInvalide + " : " + trait.getInfos_batch());
			return false;
		}
		return true;
	}

	/******************
	  PREPARATION RECYCLAGE RESSOURCES - DEBUT
	*******************/
	
	/**
	 * V�rification de la validit� du fichier
	 * @param fichier
	 * @return un message �ventuel d'erreur
	 */
	private static String estFichierValide(FormFile fichier) {
		String messageFichierInvalide = null;
		
		if (fichier != null) {
			String contentTypeFichier = fichier.getContentType();
			String nomFichier = fichier.getFileName();
			int tailleFichier = fichier.getFileSize();
			LinkedList listeElementsLignes = null;
			
			// V�rification du format de fichier
			messageFichierInvalide = estFormatEtTailleFichierValide(nomFichier, contentTypeFichier, tailleFichier);
			
			try {
				// Si le format de fichier est valide
				if (messageFichierInvalide == null) {
					listeElementsLignes = BipUtil.obtenirListeElementsLignesFichierCsv(fichier);
					
					// V�rification du contenu du fichier
					messageFichierInvalide = estContenuFichierValide(listeElementsLignes);
				}
			} catch (FileNotFoundException e1) {
				logBipUser.error(TraitBatchForm.ERREUR_FICHIER_NON_TROUVE, e1);
				messageFichierInvalide = TraitBatchForm.ERREUR_FICHIER_NON_TROUVE;
			} catch (IOException e2) {
				logBipUser.error("IOException estFichierValide", e2);
				messageFichierInvalide = e2.getMessage();
			}
		}
		
		return messageFichierInvalide;
	}
	
	/**
	 * V�rification du type et de la taille du fichier
	 * @param nomFichier
	 * @param contentTypeFichier
	 * @param tailleFichier
	 * @return un message �ventuel d'erreur
	 */
	private static String estFormatEtTailleFichierValide(String nomFichier, String contentTypeFichier, int tailleFichier) {
		String signatureMethode = "TraitBatchAction-estFormatEtTailleFichierValide";

		logBipUser.entry(signatureMethode);
		
		String retour = null;
		
		logBipUser.info(nomFichier + " : " + contentTypeFichier);
		
		String extensionFichier = null;
		if (nomFichier != null) {
			String[] nomFichierSplitted = nomFichier.split("\\.");
			extensionFichier = nomFichierSplitted[nomFichierSplitted.length - 1];
		}
		
		// V�rification du format et de l'extension de fichier
		if (!CONTENT_TYPE_CSV.equals(contentTypeFichier) || !EXTENSION_CSV.equalsIgnoreCase(extensionFichier)) {
			retour = TraitBatchForm.ERREUR_PROBLEME_FORMAT;
		}
		
		if (tailleFichier > TAILLE_MAX_FICHIER_CSV) {
			retour = TraitBatchForm.ERREUR_TAILLE_FICHIER;
		}
		
		logBipUser.exit(signatureMethode);
		
		return retour;
	}
	
	/**
	 * V�rification de la validit� technique des lignes charg�es
	 * @param listeElementsLignes : liste des lignes charg�es
	 * @return : �ventuel message d'erreur
	 */
	private static String estContenuFichierValide(LinkedList listeElementsLignes) {
		String signatureMethode = "TraitBatchAction-estContenuFichierValide";
		logBipUser.entry(signatureMethode);
		
		String retour = null;
		
		// V�rification de l�en-t�te du fichier : la 1�re ligne doit contenir les deux valeurs suivantes : � IDENT � en colonnes 1 et � DATE_AUPLUSTOT � en colonne 2
		if (! estEnteteValide(listeElementsLignes)) {
			retour = TraitBatchForm.ERREUR_PROBLEME_EN_TETE;
		}
		// V�rification que les enregistrements comportent un identifiant sur 1 � 5 chiffres et une date (facultative) au format JJ-MM-AAAA
		// les lignes suivant l�en-t�te doivent contenir au moins une valeur (sur 1 � 5 chiffres) en colonne 1. Si une valeur est pr�sente en colonne 2,
		// elle doit �tre vide ou au format JJ-MM-AAAA
		else if (! sontEnregistrementsValides(listeElementsLignes)) {
			retour = TraitBatchForm.ERREUR_PROBLEME_ENREGISTREMENT;
		}
		
		logBipUser.exit(signatureMethode);
		
		return retour;
	}
	
	/**
	 * V�rification de l�en-t�te du fichier : la 1�re ligne doit contenir au moins les deux valeurs suivantes : � IDENT � en colonnes 1 et � DATE_AUPLUSTOT � en colonne 2
	 * @param listeElementsLignes
	 * @return
	 */
	private static boolean estEnteteValide(final LinkedList listeElementsLignes) {
		String signatureMethode = "TraitBatchAction-estEnteteValide";
		logBipUser.entry(signatureMethode);
		
		boolean retour = false;
		
		if (listeElementsLignes != null) {
			String[] listeElementsLigne = (String[]) listeElementsLignes.getFirst();
			if (listeElementsLigne != null && listeElementsLigne.length >= 2)
			{
				retour = listeElementsLigne[0].trim().equals(PREMIERE_COLONNE_ENTETE) && listeElementsLigne[1].trim().equals(DEUXIEME_COLONNE_ENTETE);
			}
		}
		
		logBipUser.exit(signatureMethode);
		
		return retour;
	}
	
	/**
	 * V�rification que les enregistrements comportent un identifiant sur 1 � 5 chiffres et une date (facultative) au format JJ-MM-AAAA
	*/
	private static boolean sontEnregistrementsValides(final LinkedList listeElementsLignes) {
		String signatureMethode = "TraitBatchAction-sontEnregistrementsValides";
		logBipUser.entry(signatureMethode);
		
		boolean retour = true;
		
		// S'il y a au moins un enregistrement (en plus de l'en-t�te)
		if (listeElementsLignes.size() >= 2) {
			Iterator iterateur = listeElementsLignes.iterator();
			String[] listeElementsLigne;
			// En-t�te
			iterateur.next(); 
			// Chaque ligne suivant l�en-t�te doit contenir au moins une valeur (sur 1 � 5 chiffres) en colonne 1. Si une valeur est pr�sente en colonne 2,
			// elle doit �tre vide ou au format JJ-MM-AAAA
			while (iterateur.hasNext()) {
				listeElementsLigne = (String[]) iterateur.next();
				
				retour = verifierContenuColonnes(listeElementsLigne);
				if (!retour) {
					break;
				}
			}
		}
		// Cas de la pr�sence d'aucun enregistrement
		else if (listeElementsLignes.size() < 2) {
			retour = false;
		}
		
		logBipUser.exit(signatureMethode);
		
		return retour;
	}
	
	/**
	 * V�rification du contenu des colonnes d'un enregistrement
	 * @param listeElementsLigne
	 * @return
	 */
	private static boolean verifierContenuColonnes(String[] listeElementsLigne) {
		return (listeElementsLigne.length > 0 
				&& verifierContenuPremiereColonne(listeElementsLigne[0]) 
				&& ((listeElementsLigne.length <= 1) || verifierContenuSecondeColonne(listeElementsLigne[1]))
				);
	}
	
	/**
	 * V�rification du contenu de la premi�re colonne d'un enregistrement
	 * @param contenuCol
	 * @return
	 */
	private static boolean verifierContenuPremiereColonne(String contenuCol) {
		String signatureMethode = "TraitBatchAction-verifierContenuPremiereColonne " + contenuCol;
		logBipUser.entry(signatureMethode);
		
		boolean retour = false;
		if (contenuCol != null && contenuCol.trim() .length() <= 5) {
			try {
				Integer.valueOf(contenuCol.trim());
				retour = true;
			}
			catch (NumberFormatException e) {

			}
		}
		
		logBipUser.exit(signatureMethode);
		
		return retour;
	}
	
	/**
	 * V�rification du contenu de la seconde colonne d'un enregistrement
	 * @param contenuCol
	 * @return
	 */
	private static boolean verifierContenuSecondeColonne(String contenuCol) {
		String signatureMethode = "TraitBatchAction-verifierContenuSecondeColonne " + contenuCol;
		logBipUser.entry(signatureMethode);
		
		boolean retour = false;
		
		if (contenuCol == null || StringUtils.isEmpty(contenuCol.trim())) {
			retour = true;
		}
		else if (contenuCol.trim().length() == FORMAT_DATE.length()) {
			try {
				retour = BipDateUtil.stringToDate(contenuCol.trim(), FORMAT_DATE) != null;
			} catch (ParseException e) {
				logBipUser.error("Conversion en date", e);
			}
		}
		
		logBipUser.exit(signatureMethode);
		
		return retour;
	}
	
	/******************
	  PREPARATION RECYCLAGE RESSOURCES - FIN
	*******************/
	
	//M�thode plus n�cessaire avec l'utilisation du Merge Oracle
//	private void rollback(ArrayList<TraitBatch> oldListeTraitBatch, Hashtable hParamProc) {
//		JdbcBip jdbc = new JdbcBip();
//		// Avant de les remplacer par les nouveaux traitements
//		for(TraitBatch trait : oldListeTraitBatch){
//			//On initialise l'heure de la date avec le champ String de l'heure planifi�e
//			hParamProc.put("id_shell", trait.getId_shell());
//			hParamProc.put("date_shell", trait.getDate_shell());
//			// ex�cution de la proc�dure PL/SQL
//			try {
//				jdbc.getResult(
//						hParamProc, configProc, PACK_INSERT);
//
//			}// try
//			catch (BaseException be) {
//				logBipUser.debug("TraitBatchAction-rollback() --> BaseException :"
//						+ be, be);
//				logBipUser.debug("TraitBatchAction-rollback() --> Exception :"
//						+ be.getInitialException().getMessage());
//
//				logService.debug("TraitBatchAction-rollback() --> BaseException :"
//						+ be, be);
//				logService.debug("TraitBatchAction-rollback() --> Exception :"
//						+ be.getInitialException().getMessage());
//				// Si exception sql alors extraire le message d'erreur du message
//				// global
//				if (be.getInitialException().getClass().getName().equals(
//						"java.sql.SQLException")) {
//					 jdbc.closeJDBC(); 
//				} else {
//					// Erreur d''ex�cution de la proc�dure stock�e
//					errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
//					 jdbc.closeJDBC();
//				}
//			}
//		}
//	}
	

	
}
