package com.socgen.bip.db;

import java.io.FileWriter;
import java.io.PrintWriter;
import java.util.Hashtable;
import java.util.StringTokenizer;
import java.util.Vector;

import com.socgen.bip.form.ExtractParamForm;
import com.socgen.bip.metier.FiltreRequete;
import com.socgen.bip.user.UserBip;
import com.socgen.cap.fwk.ServiceManager;
import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.cap.fwk.jdbc.JDBCWrapper;
import com.socgen.cap.fwk.log.Log;

/**
 * @author N.BACCAM - 5/09/2003
 *
 * Classe qui permet de récupérer les données de la base pour les extractions paramétrées
 *
 */
public class ExtractParamDb {
	private static Config configSQL =
		ServiceManager.getInstance().getConfigManager().getSQL();
	private static Log logJdbc =
		ServiceManager.getInstance().getLogManager().getLogJdbc();

	/**
	 * Constructor for ExtractParamDb.
	 */
	public ExtractParamDb() {
		super();
	}
	/**
	 * Méthode qui exécute la requete SQL d'origine
	 * 
	 */
	public void execRequete(ExtractParamForm extractParamForm, String url)
		throws BaseException {
		int iNbData;
		String sRequete;
		String sData = "";
		String sNbData;
		String sResult = "";
		PrintWriter fichier = null;
		String separateur = ";";
		boolean bEntete;
		Hashtable hChoix = new Hashtable();
		Hashtable hEntete = new Hashtable();
		StringTokenizer stko;
		Integer cle;

		try {

			bEntete = extractParamForm.isEnTete();
			
			fichier = new PrintWriter(new FileWriter(url));

			//on sauvegarde les numéros de colonnes choisis dans une hashtable
			stko = new StringTokenizer(extractParamForm.getChoix(), ";");
			while (stko.hasMoreTokens()) {
				cle = new Integer(stko.nextToken());
				hChoix.put(cle, cle);
			}
		
			//On insère l'entête suivant les colonnes choisis
			if (bEntete) {
				//fichier.println(extractParamForm.getData());
				fichier.print(extractParamForm.getData());
				fichier.print("\r\n");		
			}

			sRequete = extractParamForm.getRequete();
			sNbData = extractParamForm.getNbData();
			JDBCWrapper jdbcWrapper =
				ServiceManager.getInstance().getJdbcManager().getWriter();

			try {

				//Exécution de la requête				
				jdbcWrapper.execute(sRequete);
				iNbData = new Integer(sNbData).intValue();
				logJdbc.debug("sNbData=" + sNbData);

				while (jdbcWrapper.next()) {
					sResult = "";
					for (int i = 1; i <= iNbData; i++) {
						//Vérifier qu'on a bien choisi cette colonne
						if (hChoix.containsKey(new Integer(i))) {

							sData = jdbcWrapper.getString(i);
							if (sData == null) {
								sData = "";
							} //if
							if (sResult.equals("")) {
								//dernière colonne
								sResult += sData;
							} else
								sResult += separateur + sData;
						} //if

					} // for
					if (!sResult.equals("")) {
						//fichier.println(sResult);
						fichier.print(sResult);
						fichier.print("\r\n");		
					}
				}

			} catch (BaseException be) {
				logJdbc.debug(be.getMessage());
				throw be;

			} finally {
				//fermeture de la connexion
				jdbcWrapper.close();
				//fermeture du fichier
				fichier.close();
			}
		} catch (BaseException be) {
			logJdbc.debug(be.getMessage());
			throw be;
		} catch (Exception e) {
			logJdbc.debug(e.getMessage());

		}

	} //execRequete
	/**
	 * Méthode qui récupère la requete SQL d'origine
	 * 
	 */
	public String getRequete(ExtractParamForm extractParamForm)
		throws BaseException {

		String sNomFichier;
		String requete;
		String sTextSql;
		String sSelect = "";
		String sOrderBy = "";
		boolean bWhere = false;
		try {

			JDBCWrapper jdbcWrapper =
				ServiceManager.getInstance().getJdbcManager().getWriter();
			sNomFichier = extractParamForm.getNomFichier();
			try {
				// recuperation de la requete SQL d'origine

				requete =
					configSQL.getString("SQL.extraction.requete.select")
						+ "'"
						+ sNomFichier
						+ "' "
						+ configSQL.getString("SQL.extraction.requete.orderby");
				logJdbc.debug("getRequete :requete=" + requete);
				//Exécution de la requête				
				jdbcWrapper.execute(requete);
				while (jdbcWrapper.next()) {
					sTextSql = jdbcWrapper.getString(1);
					if (sTextSql.toUpperCase().startsWith("WHERE") || 
					    sTextSql.toUpperCase().endsWith(" WHERE")  ||
						sTextSql.toUpperCase().indexOf(" WHERE ")>=0) {
						//clause where
						bWhere = true;
					}
					if (sTextSql.toUpperCase().startsWith("ORDER") || 
						sTextSql.toUpperCase().endsWith(" ORDER")  ||
						sTextSql.toUpperCase().indexOf(" ORDER ")>=0) {
						sOrderBy = sTextSql;
					} else {
						//On construit la requete dynamique en concaténant toutes les lignes
						sSelect = sSelect + " " + sTextSql;
						//logJdbc.debug("sSelect:" + sSelect);
					}
				}

				// Ajout des filtres
				if (extractParamForm.getFiltreSql().equals("")) {
					if (bWhere) {
						sSelect = sSelect + " " + sOrderBy;
					} else
						sSelect = sSelect + " " + sOrderBy;

				} else {
					if (bWhere) {
						sSelect =
							sSelect
								+ " AND "
								+ extractParamForm.getFiltreSql()
								+ " "
								+ sOrderBy;
					} else
						sSelect =
							sSelect
								+ " WHERE "
								+ extractParamForm.getFiltreSql()
								+ " "
								+ sOrderBy;
				}

				logJdbc.debug("Filtre:" + extractParamForm.getFiltreSql());

			} catch (BaseException be) {
				logJdbc.debug(be.getMessage());
				throw be;

			} finally {
				//fermeture de la connexion
				jdbcWrapper.close();
			}
		} catch (BaseException be) {
			logJdbc.debug(be.getMessage());
			throw be;
		}
		return sSelect;

	} //getData
	/**
	 * Méthode qui récupère les données de la base pour les filtres hors habilitation
	 * 
	 */
	public Hashtable getDataFiltre(String sNomFichier) throws BaseException {

		Hashtable hFiltre;
		String sLibelle;
		String sType;
		String sObligatoire;
		String sCode;
		String sLongueur;
		String sTextSql;
		String sDonnee;
		String index;
		String requete;
		int i = 0;
		FiltreRequete filtre;

		try {

			JDBCWrapper jdbcWrapper =
				ServiceManager.getInstance().getJdbcManager().getWriter();
			//initialisation
			hFiltre = new Hashtable();
			index = "0";
			sDonnee = "";

			try {
				//SQL.audit.filtre =select FR.LIBELLE, FR.TYPE, FR.OBLIGATOIRE, FR.CODE, to_char(NVL(FR.longueur, -1)) LONGUEUR, FR.TEXT_SQL TEXT_SQL from Filtre_Requete FR where FR.NOM_FICHIER=
				//SQL.audit.filtre.where = AND OBLIGATOIRE!='H'
				requete =
					configSQL.getString("SQL.audit.filtre")
						+ "'"
						+ sNomFichier
						+ "' "
						+ configSQL.getString("SQL.audit.filtre.where");
				logJdbc.debug("getData :requete=" + requete);
				//Exécution de la requête				
				jdbcWrapper.execute(requete);

				while (jdbcWrapper.next()) {
					i++;
					index = new Integer(i).toString();
					sLibelle = jdbcWrapper.getString(1);
					sType = jdbcWrapper.getString(2);
					sObligatoire = jdbcWrapper.getString(3);
					sCode = jdbcWrapper.getString(4);
					sLongueur = jdbcWrapper.getString(5);
					sTextSql = jdbcWrapper.getString(6);

					/*logJdbc.debug("sLibelle=" + sLibelle);
					logJdbc.debug("sCode=" + sCode);
					logJdbc.debug("index=" + index);
					logJdbc.debug("sType=" + sType);*/

					filtre =
						new FiltreRequete(
							sLibelle,
							sCode,
							sType,
							sLongueur,
							sObligatoire,
							sTextSql);
					hFiltre.put(index, filtre);

				}

				//SQL.audit.data = select NOM_DONNEES from Requete where NOM_FICHIER=
				requete =
					configSQL.getString("SQL.audit.data")
						+ "'"
						+ sNomFichier
						+ "'";
				//Exécution de la requête				
				jdbcWrapper.execute(requete);
				while (jdbcWrapper.next()) {
					sDonnee = jdbcWrapper.getString(1);
					logJdbc.debug("sDonnee=" + sDonnee);
				}

			} catch (BaseException be) {
				logJdbc.debug(be.getMessage());
				throw be;

			} finally {
				//fermeture de la connexion
				jdbcWrapper.close();
			}
		} catch (BaseException be) {
			logJdbc.debug(be.getMessage());
			throw be;
		}
		return hFiltre;

	} //getDataFiltre
	/**
	 * Méthode qui récupère les colonnes de la base
	 * 
	 */
	public Vector getDataColonne(String sNomFichier) throws BaseException {

		Hashtable hFiltre;
		String sDonnee;
		String requete;
		int i = 0;
		String sNbData;
		FiltreRequete filtre;
		Vector vData = new Vector();
		try {

			JDBCWrapper jdbcWrapper =
				ServiceManager.getInstance().getJdbcManager().getWriter();
			//initialisation
			hFiltre = new Hashtable();
			sDonnee = "";

			try {

				//SQL.audit.data = select NOM_DONNEES,to_char(NB_DATA) from Requete where NOM_FICHIER=
				requete =
					configSQL.getString("SQL.audit.data")
						+ "'"
						+ sNomFichier
						+ "'";
				//Exécution de la requête				
				jdbcWrapper.execute(requete);
				while (jdbcWrapper.next()) {
					sDonnee = jdbcWrapper.getString(1);
					sNbData = jdbcWrapper.getString(2);
					vData.addElement(sDonnee);
					vData.addElement(sNbData);
					logJdbc.debug("sDonnee=" + sDonnee);
					logJdbc.debug("sNbData=" + sNbData);
				}

			} catch (BaseException be) {
				logJdbc.debug(be.getMessage());
				throw be;

			} finally {
				//fermeture de la connexion
				jdbcWrapper.close();
			}
		} catch (BaseException be) {
			logJdbc.debug(be.getMessage());
			throw be;
		}
		return vData;

	} //getData

	/**
	 * Méthode qui récupère les filtres d'habilitation de la requête
	 * 
	 */
	public String getDataHab(String sNomFichier, UserBip userBip)
		throws BaseException {
		String requete;
		String sType;
		String sFiltre = "";
		Vector vFiltre;
		String sql = "";
		String sText;
		String signatureMethode = "ExtractParamAction-getDataHab";
		logJdbc.entry(signatureMethode);

		try {

			JDBCWrapper jdbcWrapper =
				ServiceManager.getInstance().getJdbcManager().getWriter();

			try {

				//SELECT type,text_sql  FROM filtre_requete WHERE obligatoire='H' and nom_fichier=
				requete =
					configSQL.getString("SQL.audit.habilitation")
						+ "'"
						+ sNomFichier
						+ "'";
				logJdbc.debug("requete:" + requete);

				//Exécution de la requête				
				jdbcWrapper.execute(requete);
				while (jdbcWrapper.next()) {
					sType = jdbcWrapper.getString(1);
					sText = jdbcWrapper.getString(2);
					//logJdbc.debug("sType=" + sType);
					//logJdbc.debug("sql=" + sql);
					//On récupère la valeur des filtres
					if (sType.startsWith("PERIMETRE_ME")) {
						vFiltre = userBip.getPerim_ME();
						// On retourne la liste des périmètres avec pour séparateur la virgule
						for (int i = 0; i < vFiltre.size(); i++) {
							sFiltre += (String) vFiltre.elementAt(i);
							if (i != (vFiltre.size() - 1))
								sFiltre += ",";
							
						}
					} else if (sType.startsWith("PERIMETRE_MO")) {
						vFiltre = userBip.getPerim_MO();
						// On retourne la liste des périmètres avec pour séparateur la virgule
						for (int i = 0; i < vFiltre.size(); i++) {
							sFiltre += (String) vFiltre.elementAt(i);
							if (i != (vFiltre.size() - 1))
								sFiltre += ",";
						}
					} else if (sType.startsWith("DPG")) {
						sFiltre = userBip.getDpg_Defaut();
					} else if (sType.startsWith("DIRECTION")) {
						sFiltre = userBip.getClicode_Defaut();
					} else if (sType.startsWith("MENU")) {
						//sFiltre = userBip.getMenuUtil().getNom();
						sFiltre = userBip.getCurrentMenu().getId();
					} else if (sType.startsWith("CENTRE_FRAIS")) {
						sFiltre = userBip.getCentre_Frais();
					}

					//On construit la partie filtre habilitation de la requête
					if (sType.endsWith("2")){
						if (sql.equals("")){
							sql = getClause2(sText, sFiltre , sFiltre );
						} else {
							sql = sql +" AND "+ getClause2(sText, sFiltre , sFiltre );
						}
					} else
						if (sql.equals("")){
							sql = getClause(sText, sFiltre);
						} else {
							sql = sql +" AND "+ getClause(sText, sFiltre);
						}
				}

			} catch (BaseException be) {
				logJdbc.debug(be.getMessage());
				throw be;

			} finally {
				//fermeture de la connexion
				jdbcWrapper.close();
			}

		} catch (BaseException be) {
			logJdbc.debug(be.getMessage());
			throw be;
			//new BaseException(BaseException.BASE_EXEC_SQL, be);

		}

		logJdbc.debug("sql:" + sql);
		logJdbc.exit(signatureMethode);
		return sql;
	} //getDataHab
	/**
	 * Méthode qui construit la clause avec remplacement d'une valeur
	 * 
	 */
	public String getClause(String sql, String sValue) {
		String sText;
		String sPartie1;
		String sPartie2;
		int position1;
		int position2;

		String signatureMethode = "ExtractParamAction-getClause";
		logJdbc.entry(signatureMethode);

		position1 = sql.indexOf("%");
		position2 = sql.lastIndexOf("%");
		//Remplacer %FILTRE% par leur valeur
		/*logJdbc.debug("avant" + sql.substring(0, position1));
		logJdbc.debug("apres" + sql.substring(position2 + 1));*/
		sPartie1 = sql.substring(0, position1);
		sPartie2 = sql.substring(position2 + 1);
		sText = sPartie1 + sValue + sPartie2;

		logJdbc.exit(signatureMethode);
		return sText;
	} //getClause
	/**
	 * Méthode qui construit la clause avec remplacement de 2 valeurs
	 * 
	 */
	public String getClause2(String sql, String sValue1, String sValue2) {
		String sText;
		String sPartie1;
		String sPartie2;
		String sPartie3;
		int position1;
		int position2;
		int position3;
		int position4;

		String signatureMethode = "ExtractParamAction-getClause2";
		logJdbc.entry(signatureMethode);
		//ligne_bip.codsg BETWEEN %FILTRE1% AND %FILTRE2%
		//Remplacer  %FILTRE1% ou %FILTRE2% par leur valeur 
		//Trouver les position des %
		position1 = sql.indexOf("%");
		position2 = sql.indexOf("%", position1 + 1);
		position3 = sql.indexOf("%", position2 + 1);
		position4 = sql.lastIndexOf("%");
		/*logJdbc.debug("position1:" + position1);
		logJdbc.debug("position2:" + position2);
		logJdbc.debug("position3:" + position3);*/

		sPartie1 = sql.substring(0, position1);
		sPartie2 = sql.substring(position2 + 1, position3);
		sPartie3 = sql.substring(position4 + 1);

		/*logJdbc.debug("sPartie1:" + sPartie1);
		logJdbc.debug("sPartie2:" + sPartie2);
		logJdbc.debug("sPartie3:" + sPartie3);*/

		sText = sPartie1 + sValue1 + sPartie2 + sValue2 + sPartie3;

		logJdbc.exit(signatureMethode);
		return sText;
	} //getClause2

}
