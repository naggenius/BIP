package com.socgen.bip.rbip.commun.loader;

import java.lang.reflect.InvocationTargetException;
import java.util.Date;
import java.util.ResourceBundle;
import java.util.StringTokenizer;
import java.util.Vector;

import com.socgen.bip.commun.Tools;
import com.socgen.bip.rbip.commun.RBipConstants;
import com.socgen.bip.rbip.commun.erreur.RBipErreur;
import com.socgen.bip.rbip.commun.erreur.RBipErreurConstants;
import com.socgen.bip.user.UserBip;

public class RBipLoaderBips extends RBipLoader implements RBipConstants, RBipStructureConstants,  RBipErreurConstants {

	private static final String ENTETE = "ENTETE";
	private UserBip userBip;
	private String chaineRejetPID;

	@Override
	public RBipData parseLigne(String sFileName, int iNumLigne, String sLigne)
			throws Exception {
		
		String rectype = ENTETE;
		boolean tailleOk = true;
		RBipErreur rBipE;
		
		init(cfgStructBips);
		
		RBipData data = new RBipData(sFileName, iNumLigne);
		
		
		//recuperer la chaine des champs entete
		String fields_cfg = cfgStructBips.getString(TAG_DATA+rectype+TAG_TYPE_FIELDS);
		
		// KRA 16/04/2015 - PPM 60612 : ajout des paramètres
		//recuperer la chaine des codes Obligatoire Facultatif
		String[] cof_cfg = cfgStructBips.getString(TAG_DATA+rectype+TAG_TYPE_COF).split(",");		
		
		//récupere le nombre des champs à contrôler
		int nbre_champ = new Integer(cfgStructBips.getString(TAG_DATA+rectype+TAG_TYPE_NBRE));
		//la taille des champs data.ENTETE.size
		int size_champ = new Integer(cfgStructBips.getString(TAG_DATA+rectype+TAG_TYPE_SIZE));
		//Les enregistrements du fichier transmis peuvent contenir plus de champs que demandé : seuls les N premiers imposés par le format (précisés plus loin) seront analysés,

		//recuperer la chaine des données
		String[] ligne_fichier = (sLigne+";FIN").split(";");
	
	//Acceder a l'entete
	if(iNumLigne==1)
	{
		//Verifier si le premier enregistrement correspond bien à une entete
		// KRA 16/04/2015 - PPM 60612 : ajout des conditions pour vérifier que les 23 colonnes et ne pas générer d'erreurs s'il y'en a plus.
		if( ligne_fichier.length < nbre_champ || sLigne.length() < size_champ || !(fields_cfg.toUpperCase()).equals(sLigne.substring(0, size_champ).replace(';', ',').toUpperCase()))
		{
			Vector<String> vE=new Vector<String>();
			vE.add(sFileName);
			rBipE = new RBipErreur(TAG_ERREUR,sFileName, iNumLigne, ERR_BAD_REC, vE); 			
			vRBipErreur.add(rBipE);
			
			//rejeter le fichier BIPS
			data.setRejetBips(true);
			
		}
		
	}
	//Acceder aux données
	else
	{
		
		StringTokenizer sTk = new StringTokenizer(fields_cfg, ",");
		while (sTk.hasMoreElements() && !data.isRejetBips())
		{
				Object o = null;
				String sField = sTk.nextToken().trim();
				int pos = new Integer(cfgStructBips.getString(TAG_DATA+sField+TAG_FIELD_POS));
				
				//Facultatif ou obligatoire
				String cof_fichier = cfgStructBips.getString(TAG_DATA+sField+TAG_FIELD_COF);
	
				if (!tailleOk)
					o = null;
				else
				{
					String dataType = cfgStructBips.getString(TAG_DATA+sField+TAG_FIELD_TYPE);
					
					String sClassName = cfgStructBips.getString(TAG_TYPE+dataType+TAG_TYPE_CLASS);
					String sMethodName = cfgStructBips.getString(TAG_TYPE+dataType+TAG_TYPE_METHOD);
					String sVal = "";
		
					if (ligne_fichier.length == 22 && "CONSOQTE".equals(sField))
					{
						sVal = "";
					}
					else
						sVal = ligne_fichier[pos-1]; //l'indexation du split commence par 0
						
					
					
					
					//champ non renseigne
					if ( (sVal.trim().length() == 0) && !"CONSODEBDATE,CONSOFINDATE".contains(sField))
					{
						//O
						if( cof_fichier.equals(cof_cfg[0]) )
						{
							Vector vE =new Vector();
							vE.add(sField);
							rBipE = new RBipErreur(TAG_ERREUR,sFileName, iNumLigne, ERR_NOT_NULL, vE);
							vRBipErreur.add(rBipE);
							o = null;
							if("LIGNEBIPCODE".equals(sField))
							{
								break;
							}
						}
						//S1
						else if ( cof_fichier.equals(cof_cfg[2]) )
						{
							// KRA 16/04/2015 - PPM 60612 : ajout de contrôle du cas spécifique S1
							String sPid = ligne_fichier[0];
							//Obligatoire si ligne non productive
							if(!Tools.isLigneProductive(sPid)){
								//Si  le cas specifique n'est pas satisfait
								Vector vE =new Vector();
								vE.add(sField);
								rBipE = new RBipErreur(TAG_ERREUR,sFileName, iNumLigne, ERR_NOT_NULL, vE);
								vRBipErreur.add(rBipE);
								o = null;
							}
							

						}
						//S2
						else if ( cof_fichier.equals(cof_cfg[3]) )
						{
//							Si  le cas specifique n'est pas satisfait
//							Vector vE =new Vector();
//							vE.add(sField);
//							rBipE = new RBipErreur(TAG_ERREUR_BIPS,sFileName, iNumLigne, rectype+"."+ERR_S1, vE);
//							vRBipErreur.add(rBipE);
//							o = null;
							data.put(sField, "CHARGER-CREER");
							continue;
						}
						//S3
						else if ( cof_fichier.equals(cof_cfg[3]) )
						{
//							Si  le cas specifique n'est pas satisfait
//							Vector vE =new Vector();
//							vE.add(sField);
//							rBipE = new RBipErreur(TAG_ERREUR_BIPS,sFileName, iNumLigne, rectype+"."+ERR_S1, vE);
//							vRBipErreur.add(rBipE);
//							o = null;
						}
					}
					else
					{
						
						try
						{
							o = Tools.getInstanceOf(sClassName, sMethodName, sVal);
						}
						catch (InvocationTargetException e)
						{

						if("CONSOQTE,CONSODEBDATE,CONSOFINDATE,STACHEDUREE,STACHEINITDEBDATE,STACHEINITFINDATE,STACHEREVDEBDATE,STACHEREVFINDATE".contains(sField))
						{
							o = Tools.getInstanceOf(sClassName, "parseString", sVal);
						}
						
						else
						{
							Vector vE =new Vector();
							vE.add(sVal);
							vE.add(cfgStructBips.getString(TAG_TYPE+dataType));
							rBipE = new RBipErreur(TAG_ERREUR,sFileName, iNumLigne, ERR_BAD_TYPE, vE);	
							vRBipErreur.add(rBipE);
							o = null;
						}

						}
						catch (Exception e)
						{
							//une erreur est survenue, elle n'est pas normale : pb dans fichier de parametrage ?							
							throw e;
						}
					}
				}
				
				data.put(sField, o);			
			}
	}
		return data;
	}
	
	@Override
	protected void init(ResourceBundle cfg)
	{
		super.setCfg(cfg);		
	}

	public UserBip getUserBip() {
		return userBip;
	}

	public void setUserBip(UserBip userBip) {
		this.userBip = userBip;
	}

	public RBipLoaderBips(UserBip userBip) {
		super();
		this.userBip = userBip;
	}
	
	
	
	public String getChaineRejetPID() {
		return chaineRejetPID;
	}

	public void setChaineRejetPID(String chaineRejetPID) {
		this.chaineRejetPID = chaineRejetPID;
	}

	public void rejeterLigneBip(String sPid)
	{
		if(this.chaineRejetPID.contains(sPid))
		{
			sPid ="";
		}
		this.chaineRejetPID=this.chaineRejetPID+sPid+"-";
	}
	
	

}
