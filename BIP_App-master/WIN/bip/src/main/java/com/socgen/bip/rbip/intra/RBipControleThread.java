/*
 * Créé le 12 août 04
 *
 * Pour changer le modèle de ce fichier généré, allez à :
 * Fenêtre&gt;Préférences&gt;Java&gt;Génération de code&gt;Code et commentaires
 */
package com.socgen.bip.rbip.intra;

import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Vector;

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.Tools;
import com.socgen.bip.commun.action.BipAction;
import com.socgen.bip.db.RBip_Jdbc;
import com.socgen.bip.rbip.commun.controller.RBipController;
import com.socgen.bip.rbip.commun.controller.converter.RBipConverterMSP;
import com.socgen.bip.rbip.commun.erreur.RBipErreur;
import com.socgen.bip.rbip.commun.loader.RBipData;
import com.socgen.bip.rbip.commun.loader.RBipLoader;
import com.socgen.bip.rbip.commun.loader.RBipLoaderBip;
import com.socgen.bip.rbip.commun.loader.RBipLoaderBips;
import com.socgen.bip.rbip.commun.loader.RBipLoaderMSP;
import com.socgen.cap.fwk.ServiceManager;
import com.socgen.cap.fwk.log.Log;

/**
 * @author E.GREVREND
 * La classe lance la génération du report qui lui est associé.
 * Aurait pu etre une inner-class de ReportManager.
 */
public class RBipControleThread extends Thread implements BipConstantes
{
	Log logService = ServiceManager.getInstance().getLogManager().getLogService(); 
	
	/*protected static final String sLogCat = "BipUser";
	public static Log logBipUser = ServiceManager.getInstance().getLogManager().getLogInstance(sLogCat);*/
	
	public static Log logBipUser = BipAction.logBipUser; //SEL QC 1864
	/**
	 * report dont va s'occuper la classe
	 */
	private RBipFichier rbipSource;
	private boolean bBips=false;
	/**
	 * Constucteur appelé par ReportManager.
	 */
	protected RBipControleThread(RBipFichier rbip)
	{
		super();
		
		/*if (logService.isDebugEnabled())
			ReportManager.logService.debug("ThreadReport.new " + report.toString());*/
		this.rbipSource = rbip;
	}


	/*private RBipLoader loadBip(String sFichier, Vector vLignes) throws Exception
	{
		RBipLoader rBipL = new RBipLoaderBip();
		rBipL.load(sFichier, vLignes);
	
		return rBipL;
	}*/
	
	private Hashtable loadPBip(String sFichier, Vector vLignes, String sIDRemonteur, Vector vErreurs) throws Exception
	{
		//Hashtable hLoader = new Hashtable();
		Hashtable hRBipF = new Hashtable();
		RBipLoader rBipL = new RBipLoaderMSP();
		rBipL.load(rbipSource.getFileName(), vLignes);
		
		if (rBipL.getErreurs().size() == 0)
		{
			RBipConverterMSP msp = new RBipConverterMSP(rBipL.getRBipData());
			Vector vPBIP = msp.convertToBip();
			vErreurs.addAll(msp.getErreurPBIP());
			
			
			//dans le vector, c'est pid/vecteur, pid/vecteur
			for (int i=0; i<vPBIP.size(); i++)
			{
				String sCurrentPID = (String)vPBIP.get(i);
				i++;
				Vector vCurrentPID = (Vector)vPBIP.get(i);
				String sCurrentFichier = msp.getNomFichier(sCurrentPID);
				
				//Vector vErrPID = msp.getErreurPID(sCurrentPID);				
				//if (vErrPID.size() == 0)
				{
					logService.debug("controlethread:loadpbip : OK convertToBip pour pid : " + sCurrentPID);
					RBipFichier rbip = new RBipFichier(sIDRemonteur, sCurrentFichier, vCurrentPID);
					rbip.alimBase();
					rbip.alimLignes();
				
					hRBipF.put(sCurrentFichier, rbip);
				}
				/*else
				{
					logService.debug("controlethread:loadpbip : des erreurs apres convertToBip pour pid : " + sCurrentPID);
					vErreurs.addAll(vErrPID);
				}*/
			}
		}
		else
		{
			vErreurs.addAll(rBipL.getErreurs());
		}
		
		//return hLoader;
		return hRBipF;
	}

	/**
	 * On lance le build du report.
	 * Une fois le traitement terminé on retire le report de la liste des traitements en cours.
	 */	
	public void run ()
	{

		logService.debug("RUN : " + rbipSource.getFileName());
		Vector vErr;
		
		Hashtable hRBipF = null;
		RBipController rBipC = null;
		//lancer controle de rbip
		try
		{
			
			//alim de la base :
			rbipSource.alimLignes();
			
			if (FICHIER_BIP.equals(RBipFichier.getTypeFichier(rbipSource.getFileName())))
			{
				hRBipF = new Hashtable();
				hRBipF.put(rbipSource.getFileName(), rbipSource);//rbipSource.getLignes());
			}
			else if (FICHIER_PBIP.equals(RBipFichier.getTypeFichier(rbipSource.getFileName())))
			{
				vErr = new Vector();
				hRBipF = loadPBip(rbipSource.getFileName(), rbipSource.getLignes(), rbipSource.getIDRemonteur(), vErr);
				
				rbipSource.setDataErreur(rbipSource.getData(), vErr);
			}
			//PPM 60612
			else if (FICHIER_BIPS.equals(RBipFichier.getTypeFichier(rbipSource.getFileName())))
			{
				hRBipF = new Hashtable();
				hRBipF.put(rbipSource.getFileName(), rbipSource);
				
				bBips=true;
			}
			else
			{
				//
				throw new Exception("Type de fichier de "+rbipSource.getFileName() + " inconnu " + RBipFichier.getTypeFichier(rbipSource.getFileName()));
			}
		}
			catch (Throwable e)
			{
				//throw e;
	
				//faire belle log erreur
				//mettre statut de controle du fichier en erreur
				BipAction.logBipUser.error("Error. Check the code", e);
	
				String sMesg = "";
				if (e.getMessage() != null)
					sMesg = e.getMessage();
				try { rbipSource.setStatut(RBipFichier.STATUT_ERREUR, sMesg); }
				catch (Throwable bE)
				{
					//quoi faire ?
					logBipUser.error("Erreur dans la procedure de chargement des fichiers de remontee.",bE);
					
				}
			}
			
			if (hRBipF != null)
			{
				// FIXME DHA : mysterious naming
				Vector dataOkL = new Vector();
				Vector dataOkC = new Vector();
				String listLigneKo ="";
				
				Enumeration enums = hRBipF.keys();
				while (enums.hasMoreElements())
				{
					String sFichier = (String)enums.nextElement();
					RBipFichier rbip = (RBipFichier)hRBipF.get(sFichier);
					
					if (rbip != null)
					{
						try
						{
							
							RBipLoader rBipL ;
							
							//SEL 60612
								if(bBips){
									
									
//									Vector<RBipData> rbipdata = Tools.listPmwBips();
//									RBipController rbipC = new RBipController();
//									rbipC.checkBipMensuelle(rbipdata);
									
								
								logBipUser.info("Chargement BIPS du fichier "+sFichier+" : Debut  de l'intégration des consommés");
								
									
								rBipL = new RBipLoaderBips(rbip.getUserBip());
								
								logBipUser.info("Chargement BIPS du fichier "+sFichier+" : Debut du chargement");
								rBipL.load(sFichier, rbip.getLignes());
								logBipUser.info("Chargement BIPS du fichier "+sFichier+" : Fin du chargement - nombre de lignes CHARGEES : "+(rbip.getLignes().size()-1));
								
								vErr = rBipL.getErreurs();
								
								Iterator itData = rBipL.getRBipData().iterator();
								Iterator itErreurL = vErr.iterator();
								
								while(itErreurL.hasNext())
								{
									int numErr = ((RBipErreur)(itErreurL.next())).getNumLigne();
									
									listLigneKo+=numErr+"-";
									
								}
								
								while(itData.hasNext())
								{
									
									RBipData data = (RBipData) itData.next();
									
										if (!listLigneKo.contains(""+data.getNumLigne()))
										{
											dataOkL.add(data);
										}
										
								}
								
								//SEL PPM 60612 - QC 1710
								if(dataOkL.size() == 0){
									
									rbip.setDataErreur(rbip.getLignes(), vErr);
								}
								else{
									
								
								rBipC = new RBipController();
								rBipC.setProv("intra");
								
								logBipUser.info("Chargement BIPS du fichier "+sFichier+" : Debut du contrôle");
								rBipC.checkBips(sFichier, dataOkL,rbip.getUserBip());
								logBipUser.info("Chargement BIPS du fichier "+sFichier+" : Fin du contrôle - nombre de lignes CONTROLEES : "+dataOkL.size());
								
								listLigneKo = "-";
								
								Iterator itDataOkL = dataOkL.iterator();
								Iterator itErreurC = rBipC.getErreurs().iterator();
									
									while(itErreurC.hasNext())
									{
										int numErr = ((RBipErreur)(itErreurC.next())).getNumLigne();
										
										listLigneKo+=numErr+"-";
										
									}
									
									while(itDataOkL.hasNext())
									{
										
										RBipData data = (RBipData) itDataOkL.next();
										
											if (!listLigneKo.contains("-"+data.getNumLigne()+"-"))
											{
												dataOkC.add(data);
											}
											
									}
									
									Vector ErreursBipsC = rBipC.getErreurs();
									
									ErreursBipsC.addAll(rBipL.getErreurs());
								
								
									
								//S.EL 60612 insert en pmw_bips
								logBipUser.info("Chargement BIPS du fichier "+sFichier+" : Debut insertion dans la table PMW_BIPS de "+(dataOkC.size()-1)+" lignes");
								String insert_retour = Tools.inserer_bips(dataOkC,rbip);
								logBipUser.info("Chargement BIPS du fichier "+sFichier+" : Fin insertion dans la table PMW_BIPS : "+insert_retour.substring(18));
								
								logBipUser.info("Chargement BIPS du fichier "+sFichier+" : Debut insertion des rejets et mise à jour des statuts");
								//vErr.addAll(rBipC.getErreurs());	
								rbip.setDataErreurWarning(dataOkC, ErreursBipsC, rBipC.getWarning(),rbip.getAction());
								logBipUser.info("Chargement BIPS du fichier "+sFichier+" : Fin insertion des rejets et mise à jour des statuts");
//								int nb_ress_bloq=Integer.parseInt(insert_retour.substring(0, 1));
//								insert_retour =insert_retour.substring(1);
								
								
								if (RBip_Jdbc.RESSOURCE_BLOQUEE.equals(insert_retour.subSequence(0, 17)) && !"controler".equals(rbip.getAction()))
								{
									if (dataOkC.size() == rbip.getLignes().size()){
										
											if(rBipC.getWarning().size()>0){
												rbip.setStatut(RBipFichier.BIPS_STATUT_ENT_VAL_PAR_TRT_WARNINGS, rbip.getAction());
											}else{
												rbip.setStatut(RBipFichier.BIPS_STATUT_ENT_VAL_PAR_TRT, rbip.getAction());
											}
										
									}else{
										rbip.setStatut(RBipFichier.BIPS_STATUT_PAR_VAL_PAR_TRT, rbip.getAction());
									}
								}
								
								}
								
								logBipUser.info("Chargement BIPS du fichier "+sFichier+" : fin insertion des lignes vers pmw_bips");
								
								}
							else{
									rBipL = new RBipLoaderBip();
									
									rBipL.load(sFichier, rbip.getLignes());
									
									vErr = rBipL.getErreurs();
									
									if (vErr.size() == 0)
									{
										rBipC = new RBipController();
										
										rBipC.check(sFichier, rBipL.getRBipData());
										
										//vErr.addAll(rBipC.getErreurs());	
										rbip.setDataErreur(rBipL.getRBipData(), rBipC.getErreurs(), rBipC.getWarning());	
										
									}
									else
									{
										rbip.setDataErreur(rBipL.getRBipData(), vErr);
									}
							
							}
							
							
						
			
						//rbip.setDataErreur(rBipL.getRBipData(), rBipL.getErreurs());
						}
						catch (Throwable e)
						{
							//throw e;
							logService.error("Erreur dans la procedure de chargement des fichiers de remontee : "+e.getMessage());
							//faire belle log erreur
							//mettre statut de controle du fichier en erreur
							BipAction.logBipUser.error("Error. Check the code", e);
	
							String sMesg = "";
							if (e.getMessage() != null)
								sMesg = e.getMessage();
							try { rbipSource.setStatut(RBipFichier.STATUT_ERREUR, sMesg); }
							catch (Throwable bE)
							{
								//quoi faire ?
								BipAction.logBipUser.error("Error. Check the code", e);
								logService.error("Erreur dans la procedure de chargement des fichiers de remontee");
								logService.error("Voir si probleme dans le fichier des ressources associe");
								logService.error("", bE);
							}
						}
						
					}
				}
			}
		
		if (RBipManager.logService.isDebugEnabled())
			RBipManager.logService.debug("RBipControleThread.run Termine : "+ rbipSource.toString());
		
		RBipManager.getInstance().retirer(rbipSource);
	}
}