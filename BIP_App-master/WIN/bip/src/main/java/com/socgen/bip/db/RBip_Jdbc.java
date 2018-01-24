package com.socgen.bip.db;

import java.sql.Array;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Types;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import java.util.StringTokenizer;
import java.util.Vector;

import javax.servlet.http.HttpSession;

import oracle.jdbc.OracleCallableStatement;
import oracle.jdbc.OracleTypes;
import oracle.sql.ARRAY;
import oracle.sql.ArrayDescriptor;
import oracle.sql.STRUCT;
import oracle.sql.StructDescriptor;

import org.threeten.bp.Instant;
import org.threeten.bp.LocalDate;
import org.threeten.bp.ZoneId;

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.MonthAndYearFunctional;
import com.socgen.bip.commun.ValidityLineInformation;
import com.socgen.bip.commun.action.BipAction;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.exception.ExceptionTechnique;
import com.socgen.bip.hierarchy.ResultHierarchy;
import com.socgen.bip.rbip.batch.RBip;
import com.socgen.bip.rbip.commun.erreur.RBipErreur;
import com.socgen.bip.rbip.commun.erreur.RBipErreurConstants;
import com.socgen.bip.rbip.commun.loader.RBipData;
import com.socgen.bip.rbip.commun.loader.RBipParser;
import com.socgen.bip.rbip.commun.loader.RBipStructureConstants;
import com.socgen.bip.rbip.intra.RBipFichier;
import com.socgen.bip.user.UserBip;
import com.socgen.bip.util.PropertiesResource;
import com.socgen.bip.util.PropertiesResourceImpl;
import com.socgen.cap.fwk.exception.BaseException;

public class RBip_Jdbc implements BipConstantes, RBipStructureConstants, RBipErreurConstants {

	private static final String ARRAY_TABLE_PLSQL_TYPE = "ARRAY_TABLE";
	private static final String ARRAY_DATE_PLSQL_TYPE = "ARRAY_DATE";
	private static final String ARRAY_BIPS_OUTSRC_TYPE = "BIPS_OUTSOUC";
	private static final String ARRAY_BIPS_OUTSRC_REC_TYPE = "BIPS_OUTSOUC_REC";
	// private static final String VARCHAR_TABLE_PLSQL_TYPE = "BIP.PACK_HABILITATION.VARCHAR_TBLE";

	private static final String PROPERTY_FILENAME = "bip_proc";

	private static PropertiesResource storedProcProperties;

	protected static final String sLogCat = "BipUser";
	// public static Log logBipUser =
	// ServiceManager.getInstance().getLogManager().getLogInstance(sLogCat);

	public static String TOP = "INTRANET";
	public static String P_PID = "RBIP";
	public static String sErrValue = null;
	public static String RESSOURCE_BLOQUEE = "RESSOURCE_BLOQUEE";

	public static String DB_URL;
	public static String DB_USER;
	public static String DB_PASS;

	public static String USER_BIP_SERVER;
	public static String FILENAME_BIP_SERVER;

	public static final String[] COLONNES_BIPS = { LIGNE_BIP_CODE, LIGNE_BIP_CLE, STRUCTURE_ACTION, ETAPE_NUM, ETAPE_TYPE, ETAPE_LIBEL, TACHE_NUM, TACHE_LIBEL, TACHE_AXE_METIER,
			STACHE_NUM, STACHE_TYPE, STACHE_LIBEL, STACHE_INIT_DEB_DATE, STACHE_INIT_FIN_DATE, STACHE_REV_DEB_DATE, STACHE_REV_FIN_DATE, STACHE_STATUT, STACHE_DUREE,
			STACHE_PARAM_LOCAL, RESS_BIP_CODE, RESS_BIP_NOM, CONSO_DEB_DATE, CONSO_FIN_DATE, CONSO_QTE, PROVENANCE, PRIORITE, TOP_BIPS, USER_PEC, DATE_PEC, FICHIER };

	/** CallableStatement */

	static {
		storedProcProperties = new PropertiesResourceImpl(PROPERTY_FILENAME);

	}

	// protected static Config configProc = ConfigManager.getInstance(BIP_PROC)
	// ;

	/**
	 * Permet de récupérer la liste jeu des valeurs type étape - Utilisé dans le traitement : Remontée BIP Intranet
	 **/

	public static void recupererListe(String Proc, String p_user, String p_pid) {

		Vector VTYPETAPE = new Vector();
		String Resultat = null;
		String SPACE = "    ";

		Connection conn = null;
		try {
			conn = ConnectionManager.getInstance().getConnection();

			CallableStatement call = conn.prepareCall(" { call " + Proc + " } ");

			// Déclaration des paramètres

			call.setString(1, p_user);
			call.setString(2, p_pid);
			call.registerOutParameter(3, OracleTypes.VARCHAR);
			call.registerOutParameter(4, OracleTypes.VARCHAR);
			call.executeQuery();

			Resultat = (String) call.getString(4);
			sErrValue = (String) call.getString(3);

			if (Resultat != null) {

				StringTokenizer st = new StringTokenizer(Resultat, ",");
				while (st.hasMoreTokens()) {
					VTYPETAPE.add(st.nextToken() + SPACE);
				}

				RBipParser.ETAPES_PACTE = (Vector) VTYPETAPE.clone();

			}

			if (call != null)
				call.close();

			// Fermeture de la connexion
			if (conn != null) {
				conn.close();
			}

		} catch (BaseException e) {
			// TODO Auto-generated catch block
			BipAction.logBipUser.error("Error. Check the code", e);
		}

		catch (SQLException e) {
			// TODO Auto-generated catch block
			BipAction.logBipUser.error("Error. Check the code", e);
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			BipAction.logBipUser.error("Error. Check the code", e);
		} catch (InstantiationException e) {
			// TODO Auto-generated catch block
			BipAction.logBipUser.error("Error. Check the code", e);
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			BipAction.logBipUser.error("Error. Check the code", e);
		} finally {
			// fermeture de la connexion
			try {
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				BipAction.logBipUser.error("Error. Check the code", e);
			}
		}

	}// recupererListeJeux

	// -------------------------------------------------------------------------------------------------------------
	// Contôle du PID
	public static void isValidPID_Intra(String Proc_Plsql, String p_user, String p_pid) {

		Vector VTYPETAPE = new Vector();
		String Resultat = null;
		String SPACE = "    ";

		Connection conn = null;
		try {
			conn = ConnectionManager.getInstance().getConnection();

			CallableStatement call = conn.prepareCall(" { call " + Proc_Plsql + " } ");

			// Déclaration des paramètres

			call.setString(1, p_user);
			call.setString(2, p_pid);
			call.registerOutParameter(3, OracleTypes.VARCHAR);
			call.executeQuery();

			sErrValue = (String) call.getString(3);

			if (call != null)
				call.close();

			// Fermeture de la connexion
			if (conn != null) {
				conn.close();
			}

		} catch (BaseException e) {
			// TODO Auto-generated catch block
			BipAction.logBipUser.error("Error. Check the code", e);
		}

		catch (SQLException e) {
			// TODO Auto-generated catch block
			BipAction.logBipUser.error("Error. Check the code", e);
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			BipAction.logBipUser.error("Error. Check the code", e);
		} catch (InstantiationException e) {
			// TODO Auto-generated catch block
			BipAction.logBipUser.error("Error. Check the code", e);
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			BipAction.logBipUser.error("Error. Check the code", e);
		} finally {
			// Fermeture de la connexion
			try {
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				BipAction.logBipUser.error("Error. Check the code", e);
			}
		}

	}// isValidPID Intranet

	// -------------------------------------------------------------------------------------------------------------

	/**
	 * Permet de récupérer la liste jeu des valeurs type étape - Utilisé dans le traitement : Remontée BIP UNIX
	 **/

	public static void getListTypetape(String url, String username, String password, String Proc, String p_user, String p_pid) {

		Connection conn = null;
		Vector VTYPETAPE = new Vector();
		String SPACE = "    ";

		try {

			Class cDriverOracle = Class.forName("oracle.jdbc.driver.OracleDriver");
			Driver dDriverOracle = (java.sql.Driver) cDriverOracle.newInstance();
			DriverManager.registerDriver(dDriverOracle);
			conn = DriverManager.getConnection(url, username, password);

			try {

				String plsql_call = "begin " + Proc + "; end;";
				CallableStatement statement;
				statement = conn.prepareCall(plsql_call);

				statement.setString(1, p_user);
				statement.setString(2, p_pid);

				statement.registerOutParameter(3, java.sql.Types.VARCHAR);
				statement.registerOutParameter(4, java.sql.Types.VARCHAR);
				statement.setFetchDirection(ResultSet.FETCH_FORWARD);

				statement.execute();

				String Resultat = statement.getString(4);
				sErrValue = statement.getString(3);

				if (Resultat != null) {

					StringTokenizer st = new StringTokenizer(Resultat, ",");
					while (st.hasMoreTokens()) {
						VTYPETAPE.add(st.nextToken() + SPACE);
					}

					RBip.ETAPES_PACTE = (Vector) VTYPETAPE.clone();

				}

				statement.close();

			} // try

			finally {
				// fermeture de la connexion
				if (conn != null) {
					conn.close();
				}
			} // finally

		} // try

		catch (SQLException e) {
			// TODO Auto-generated catch block
			BipAction.logBipUser.error("Error. Check the code", e);

		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			BipAction.logBipUser.error("Error. Check the code", e);

		} catch (InstantiationException e) {
			// TODO Auto-generated catch block
			BipAction.logBipUser.error("Error. Check the code", e);

		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			BipAction.logBipUser.error("Error. Check the code", e);

		}

		// return Resultat;

	} // recupererListTypetap

	// SEL PPM 60612
	public static void isPidHabilite(String Proc_Plsql, String p_pid, String p_liste_cp) {

		Connection conn = null;
		try {
			conn = ConnectionManager.getInstance().getConnection();

			CallableStatement call = conn.prepareCall(" { call " + Proc_Plsql + " } ");

			// Déclaration des paramètres

			call.setString(1, p_pid);
			call.setString(2, p_liste_cp);

			call.registerOutParameter(3, OracleTypes.VARCHAR);
			call.executeQuery();

			sErrValue = (String) call.getString(3);

			if (call != null)
				call.close();

			// Fermeture de la connexion
			if (conn != null) {
				conn.close();
			}

		} catch (BaseException e) {
			// TODO Auto-generated catch block
			BipAction.logBipUser.error("Error. Check the code", e);
		}

		catch (SQLException e) {
			// TODO Auto-generated catch block
			BipAction.logBipUser.error("Error. Check the code", e);
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			BipAction.logBipUser.error("Error. Check the code", e);
		} catch (InstantiationException e) {
			// TODO Auto-generated catch block
			BipAction.logBipUser.error("Error. Check the code", e);
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			BipAction.logBipUser.error("Error. Check the code", e);
		} finally {
			// Fermeture de la connexion
			try {
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				BipAction.logBipUser.error("Error. Check the code", e);
			}
		}

	}// isValidPID Intranet

	public static Set<String> findIdLignesBipAvecCdpValides(Set<String> idLignesBipSet, Vector<String> chefProjetUserVector) {

		String procedure = null;
		Connection conn = null;
		try {
			procedure = storedProcProperties.getValueOrThrowException("rbip.find_pid_avec_cdp_valides.proc");
			conn = ConnectionManager.getInstance().getConnection();

			String[] idBipArray = idLignesBipSet.toArray(new String[idLignesBipSet.size()]);
			String[] cdpUserArray = chefProjetUserVector.toArray(new String[chefProjetUserVector.size()]);
			CallableStatement statement = conn.prepareCall(" { call " + procedure + " } ");

			ArrayDescriptor arrayBipsDesc = ArrayDescriptor.createDescriptor(ARRAY_TABLE_PLSQL_TYPE, conn);
			ARRAY arrayIdLigneBips = new ARRAY(arrayBipsDesc, conn, idBipArray);
			ARRAY arrayCdpUsers = new ARRAY(arrayBipsDesc, conn, cdpUserArray);

			statement.setArray(1, arrayIdLigneBips);
			statement.setArray(2, arrayCdpUsers);
			statement.registerOutParameter(3, OracleTypes.ARRAY, ARRAY_TABLE_PLSQL_TYPE);
			statement.execute();

			Array arraySqlOut = ((OracleCallableStatement) statement).getArray(3);

			Set<String> idLigneBipOut = createSetIdLignesBip(arraySqlOut);
			return idLigneBipOut;

		} catch (Exception e) {
			String errorMsg = String.format("exception dans findIdLignesBipAvecCdpValides () avec les paramètres : procedure=%s, idLignesBip=%s", procedure,
					idLignesBipSet.toString());
			BipAction.logBipUser.error(errorMsg, e);
			// TODO refactorer le code pour traiter l'exception
			throw new ExceptionTechnique(e);
		}

		finally {
			try {
				if (conn != null && !conn.isClosed()) {
					conn.close();
				}
			} catch (SQLException e) {
				BipAction.logBipUser.error("Erreur durant la fermeture de la connexion", e);
			}
		}
	}

	// private static String generateInPreparedStatement(int inNumberOfElements) {
	//
	// StringBuilder inClauseBuilder = new StringBuilder("IN (");
	// for (int i=0; i<inNumberOfElements; i++){
	// inClauseBuilder.append("?").append(",");
	// }
	// // we replace the last comma by a ending parenthesis
	// inClauseBuilder.setCharAt(inClauseBuilder.length()-1, ')');
	// return inClauseBuilder.toString();
	// }

	public static void supprimer_sr_si_existe(String Proc_Plsql, String p_pid, String p_userid) {

		Connection conn = null;
		try {
			conn = ConnectionManager.getInstance().getConnection();

			CallableStatement call = conn.prepareCall(" { call " + Proc_Plsql + " } ");

			// Déclaration des paramètres

			call.setString(1, p_pid);
			call.setString(2, p_userid);

			call.registerOutParameter(3, OracleTypes.VARCHAR);

			// //logBipUser.info("Chargement BIP Intranet : suppression de la SR de la ligne BIP "+p_pid);
			call.executeQuery();

			sErrValue = (String) call.getString(3);

			if (call != null)
				call.close();

			// Fermeture de la connexion
			if (conn != null) {
				conn.close();
			}

		} catch (BaseException e) {
			// logBipUser.info("Chargement BIP Intranet : fin anormale de la suppression de la SR de la ligne BIP "+p_pid+" - "+e.getMessage());
			BipAction.logBipUser.error("Error. Check the code", e);
		}

		catch (SQLException e) {
			// logBipUser.info("Chargement BIP Intranet : fin anormale de la suppression de la SR de la ligne BIP "+p_pid+" - "+e.getMessage());
			BipAction.logBipUser.error("Error. Check the code", e);
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			BipAction.logBipUser.error("Error. Check the code", e);
		} catch (InstantiationException e) {
			// TODO Auto-generated catch block
			BipAction.logBipUser.error("Error. Check the code", e);
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			BipAction.logBipUser.error("Error. Check the code", e);
		} finally {
			// Fermeture de la connexion
			try {
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				BipAction.logBipUser.error("Error. Check the code", e);
			}
		}

	}

	public static String inserer_bips(String proc, Vector vLignes, RBipFichier rFichier) {
		SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
		String RessBloq = "";
		String sAction = "";
		String sInfoUser = "";
		String sFileName = "";
		String sProv = "";
		String sLigne = "";
		if ("UNIX".equals(RBip_Jdbc.TOP)) {
			sAction = "creer";
			sInfoUser = RBip_Jdbc.USER_BIP_SERVER;
			sFileName = RBip_Jdbc.FILENAME_BIP_SERVER;
			sProv = "unix";
		} else {
			sAction = rFichier.getAction();
			sInfoUser = rFichier.getUserBip().getInfosUser();
			sFileName = rFichier.getFileName();
			sProv = "intra";
		}
		int i = 0;
		Connection conn = null;
		try {

			conn = ConnectionManager.getInstance().getConnection();

			ArrayDescriptor arrayBipsDesc = ArrayDescriptor.createDescriptor(ARRAY_TABLE_PLSQL_TYPE, conn);

			CallableStatement call = conn.prepareCall(" { call " + proc + " } ");

			// Déclaration des paramètres

			Iterator it = vLignes.iterator();
			int size = vLignes.size();

			Date now = new Date(System.currentTimeMillis());

			String sLignes[] = new String[vLignes.size()];

			while (it.hasNext()) {
				RBipData o = (RBipData) it.next();

				if (o.getNumLigne() > 1) {
					sLigne = getData(o, "LIGNEBIPCODE");
					sLigne = sLigne + getData(o, "LIGNEBIPCLE").toString();
					sLigne = sLigne + getData(o, "STRUCTUREACTION").toString();
					sLigne = sLigne + getData(o, "ETAPENUM").toString();
					sLigne = sLigne + getData(o, "ETAPETYPE").toString();
					sLigne = sLigne + getData(o, "ETAPELIBEL").toString();
					sLigne = sLigne + getData(o, "TACHENUM").toString();
					sLigne = sLigne + getData(o, "TACHELIBEL").toString();

					sLigne = sLigne + getData(o, "TACHEAXEMETIER").toString();

					sLigne = sLigne + getData(o, "STACHENUM").toString();
					sLigne = sLigne + getData(o, "STACHETYPE").toString();
					sLigne = sLigne + getData(o, "STACHELIBEL").toString();
					sLigne = sLigne + (o.getData("STACHEINITDEBDATE") != null ? formatter.format(o.getData("STACHEINITDEBDATE")) : "") + ";";

					sLigne = sLigne + (o.getData("STACHEINITFINDATE") != null ? formatter.format(o.getData("STACHEINITFINDATE")) : "") + ";";
					sLigne = sLigne + (o.getData("STACHEREVDEBDATE") != null ? formatter.format(o.getData("STACHEREVDEBDATE")) : "") + ";";
					sLigne = sLigne + (o.getData("STACHEREVFINDATE") != null ? formatter.format(o.getData("STACHEREVFINDATE")) : "") + ";";

					sLigne = sLigne + getData(o, "STACHESTATUT").toString();
					sLigne = sLigne + getData(o, "STACHEDUREE").toString();
					sLigne = sLigne + getData(o, "STACHEPARAMLOCAL").toString();
					sLigne = sLigne + getData(o, "RESSBIPCODE").toString();
					sLigne = sLigne + getData(o, "RESSBIPNOM").toString();

					sLigne = sLigne + (o.getData("CONSODEBDATE") != null ? formatter.format(o.getData("CONSODEBDATE")) : "") + ";";
					sLigne = sLigne + (o.getData("CONSOFINDATE") != null ? formatter.format(o.getData("CONSOFINDATE")) : "") + ";";

					sLigne = sLigne + getData(o, "CONSOQTE").toString();
					sLigne = sLigne + "intra;";
					sLigne = sLigne + ("controler".equals(sAction) ? "P4;" : getData(o, "PRIORITE").toString());

					sLigne = sLigne + sInfoUser.toString() + ";";
					sLigne = sLigne + now.toString() + ";";

					sLigne = sLigne + sFileName.toString();

					sLignes[i] = sLigne;
					i++;
				}

			}
			ARRAY arrayBips = new ARRAY(arrayBipsDesc, conn, sLignes);

			call.setArray(1, arrayBips);
			call.setObject(2, sProv);
			call.setObject(3, "controler".equals(sAction) ? "P4" : "");
			call.setObject(4, sInfoUser);
			call.setObject(5, now);
			call.setObject(6, sFileName);

			call.registerOutParameter(7, java.sql.Types.VARCHAR);
			call.executeQuery();

			sErrValue = (String) call.getString(7);

			if (call != null)
				call.close();

			// Fermeture de la connexion
			if (conn != null) {
				conn.close();
			}

			// if(RessBloq==RESSOURCE_BLOQUEE)
			// {
			// sErrValue = String.valueOf(i)+RESSOURCE_BLOQUEE;
			// }
			// else{
			// sErrValue = String.valueOf(i)+sErrValue;
			// }

			return sErrValue;

		} catch (BaseException e) {
			BipAction.logBipUser.error("Error. Check the code", e);
			sErrValue = e.getMessage();
			return sErrValue;
		}

		catch (SQLException e) {
			BipAction.logBipUser.error("Error. Check the code", e);
			sErrValue = sErrValue + " - " + e.getMessage();
			return sErrValue;
		} catch (ClassNotFoundException e) {
			BipAction.logBipUser.error("Error. Check the code", e);
			sErrValue = e.getMessage();
			return sErrValue;
		} catch (InstantiationException e) {
			BipAction.logBipUser.error("Error. Check the code", e);
			sErrValue = e.getMessage();
			return sErrValue;
		} catch (IllegalAccessException e) {
			BipAction.logBipUser.error("Error. Check the code", e);
			sErrValue = e.getMessage();
			return sErrValue;
		} finally {
			// Fermeture de la connexion
			try {
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				BipAction.logBipUser.error("Error. Check the code", e);
			}
		}

	}

	public static String verifier_tache_axe_metier(String procedure, String sTacheAxeMetier, String sPid) {

		// paramsession si l'utilisateur vient de l'écran paramètres session,
		// vide sinon

		Connection conn = null;

		try {

			conn = ConnectionManager.getInstance().getConnection();

			CallableStatement call = conn.prepareCall(" { call " + procedure + " } ");

			call.setObject(1, sTacheAxeMetier);
			call.setObject(2, sPid);

			call.registerOutParameter(3, java.sql.Types.VARCHAR);
			call.registerOutParameter(4, java.sql.Types.VARCHAR);
			call.registerOutParameter(5, java.sql.Types.VARCHAR);

			call.executeQuery();

			sErrValue = (String) call.getString(4);

			if (call != null)
				call.close();

			// Fermeture de la connexion
			if (conn != null) {
				conn.close();
			}

		} // try
		catch (BaseException e) {
			BipAction.logBipUser.error("Error. Check the code", e);
			return null;
		} catch (SQLException e) {
			BipAction.logBipUser.error("Error. Check the code", e);
			return null;
		} catch (Exception e) {
			BipAction.logBipUser.error("Error. Check the code", e);
		} finally {
			// Fermeture de la connexion
			try {
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				BipAction.logBipUser.error("Error. Check the code", e);
			}
		}

		return sErrValue;

	}

	public static List<List<String>> recup_param_bip_global(String procedure, String cAction) {

		// logBipUser.info("recup_param_bip_global");

		Vector vParamOut = new Vector();
		ParametreProc paramOut;
		String message = "";
		Object curseur = null;
		List<List<String>> listparams = new ArrayList<List<String>>();
		List<String> param;

		boolean defaut = false;

		Connection conn = null;
		try {

			conn = ConnectionManager.getInstance().getConnection();

			CallableStatement call = conn.prepareCall(" { call " + procedure + " } ");

			call.setObject(1, cAction);

			call.registerOutParameter(2, OracleTypes.CURSOR);
			call.registerOutParameter(3, Types.VARCHAR);

			call.execute();

			curseur = call.getObject(2);
			message = call.getString(3);

			// Hashtable hParams = new Hashtable();
			// //On récupère les contacts
			// hParams.put("codaction", cAction);

			// vParamOut = jdbc.getResult(
			// hParams, configProc, procedure);

			// // Récupération des résultats
			// for (Enumeration e = vParamOut.elements(); e.hasMoreElements();)
			// {
			// paramOut = (ParametreProc) e.nextElement();

			// récupérer le message
			// if (paramOut.getNom().equals("message")) {
			// message = (String) paramOut.getValeur();
			// }

			// if (paramOut.getNom().equals("curseur")) {
			// Récupération du Ref Cursor
			ResultSet rset = (ResultSet) curseur;

			try {
				while (rset.next()) {

					param = new ArrayList<String>();

					ResultSetMetaData rsmd = rset.getMetaData();
					int nbColonnes = rsmd.getColumnCount();
					int i = 1;
					while (i <= nbColonnes) {
						param.add(rset.getString(i));
						i++;

					}

					if ("DEFAUT".equals(rset.getString(2))) {
						defaut = true;
					}

					listparams.add(param);

				}

				if (call != null)
					call.close();

				// Fermeture de la connexion
				if (conn != null) {
					conn.close();
				}

			} catch (SQLException sqle) {
				if (call != null)
					call.close();

				// Fermeture de la connexion
				if (conn != null) {
					conn.close();
				}

			} finally {
				try {
					if (rset != null)
						rset.close();
				} catch (SQLException sqle) {
					if (call != null)
						call.close();

					// Fermeture de la connexion
					if (conn != null) {
						conn.close();
					}
				}
			}
			// } // if
			// } // for

		} // try
		catch (Exception e) {
			BipAction.logBipUser.error("Error. Check the code", e);
		} finally {
			// Fermeture de la connexion
			try {
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				BipAction.logBipUser.error("Error. Check the code", e);
			}
		}

		return listparams;

	}

	public static Map<String, ValidityLineInformation> findValidityInformationForIdLigneBip(String procedure, Set<String> idLignesBipSet) throws Exception {

		Connection conn = null;
		try {

			conn = ConnectionManager.getInstance().getConnection();
			// return executeCommonProcedureWithArrayInAndOut(procedure, idLignesBipSet, conn);
			String[] idBipArray = idLignesBipSet.toArray(new String[idLignesBipSet.size()]);
			CallableStatement statement = conn.prepareCall(" { call " + procedure + " } ");

			ArrayDescriptor arrayBipsDesc = ArrayDescriptor.createDescriptor(ARRAY_TABLE_PLSQL_TYPE, conn);
			ARRAY arrayIdLigneBips = new ARRAY(arrayBipsDesc, conn, idBipArray);

			statement.setArray(1, arrayIdLigneBips);
			statement.registerOutParameter(2, OracleTypes.ARRAY, ARRAY_TABLE_PLSQL_TYPE);
			statement.registerOutParameter(3, OracleTypes.ARRAY, ARRAY_DATE_PLSQL_TYPE);
			statement.registerOutParameter(4, OracleTypes.ARRAY, ARRAY_TABLE_PLSQL_TYPE);
			statement.execute();

			Array arraySqlIdLignesOut = ((OracleCallableStatement) statement).getArray(2);
			Array arraySqlDateStatutOut = ((OracleCallableStatement) statement).getArray(3);
			Array arraySqlTypeProjetOut = ((OracleCallableStatement) statement).getArray(4);

			//
			if (arraySqlIdLignesOut == null) {
				return new HashMap<String, ValidityLineInformation>();
			}

			Map<String, ValidityLineInformation> validityInformationsByIdLignesBip = new HashMap<String, ValidityLineInformation>();

			String[] idLignesBipOut = (String[]) (arraySqlIdLignesOut.getArray());
			java.util.Date[] datesStatutOut = (java.util.Date[]) (arraySqlDateStatutOut.getArray());
			String[] typesProjetOut = (String[]) (arraySqlTypeProjetOut.getArray());

			for (int i = 0; i < idLignesBipOut.length; i++) {
				String currentIdLigneBip = idLignesBipOut[i];
				LocalDate currentStatutDate = null;
				if (datesStatutOut[i] != null) {
					currentStatutDate = Instant.ofEpochMilli(datesStatutOut[i].getTime()).atZone(ZoneId.systemDefault()).toLocalDate();					
				}
				String currentTypeProjet = typesProjetOut[0];

				validityInformationsByIdLignesBip.put(currentIdLigneBip, new ValidityLineInformation(currentStatutDate, currentTypeProjet));
			}
			return validityInformationsByIdLignesBip;

		}

		finally {
			try {
				if (conn != null && !conn.isClosed()) {
					conn.close();
				}
			} catch (SQLException e) {
				BipAction.logBipUser.error("Erreur durant la fermeture de la connexion", e);
			}
		}

	}

	// FIXME encore utilisé par check bip mensuel. Next step : remplacer par un appel à getSetOfIdLignesBipQuiSontValides()
	public static boolean isValidPid(String procedure, String p_pid) {

		String message = "";

		Connection conn = null;
		try {

			conn = ConnectionManager.getInstance().getConnection();

			CallableStatement call = conn.prepareCall(" { call " + procedure + " } ");

			call.setObject(1, p_pid);

			call.registerOutParameter(2, Types.VARCHAR);

			call.execute();

			message = call.getString(2);

			if (call != null)
				call.close();

			// Fermeture de la connexion
			if (conn != null) {
				conn.close();
			}

		} catch (Exception e) {
			BipAction.logBipUser.error("Error. Check the code", e);
		} finally {
			// Fermeture de la connexion
			try {
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				BipAction.logBipUser.error("Error. Check the code", e);
			}
		}
		if (message != null && "REJET".equals(message)) {
			return false;
		}
		return true;
	}

	public static boolean isValidCle(String procedure, String p_pid, String p_cle) {

		String message = "";

		Connection conn = null;
		try {

			conn = ConnectionManager.getInstance().getConnection();

			CallableStatement call = conn.prepareCall(" { call " + procedure + " } ");

			call.setObject(1, p_pid);

			call.setObject(2, p_cle);

			call.registerOutParameter(3, Types.VARCHAR);

			call.execute();

			message = call.getString(3);

			if (call != null)
				call.close();

			// Fermeture de la connexion
			if (conn != null) {
				conn.close();
			}

		} catch (Exception e) {
			BipAction.logBipUser.error("Error. Check the code", e);
		} finally {
			// Fermeture de la connexion
			try {
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				BipAction.logBipUser.error("Error. Check the code", e);
			}
		}

		if (message != null && "REJET".equals(message)) {
			return false;
		}

		return true;
	}

	// public static Map<String, Boolean> getListOfIsValideCle(String procedure, Map<String, String> clesInputByIdLigneBip) {
	//
	//
	// Connection conn = null;
	// try {
	//
	// Set<String> idBipSet = clesInputByIdLigneBip.keySet();
	// conn = ConnectionManager.getInstance().getConnection();
	// String[] idBipArray = idBipSet.toArray(new String[idBipSet.size()]);
	// CallableStatement statement = conn.prepareCall(" { call " + procedure + " } ");
	//
	// ArrayDescriptor arrayBipsDesc = ArrayDescriptor.createDescriptor(ARRAY_TABLE_PLSQL_TYPE, conn);
	// ARRAY arrayIdLigneBips = new ARRAY(arrayBipsDesc, conn, idBipArray);
	//
	// statement.setArray(1, arrayIdLigneBips);
	//
	// statement.registerOutParameter(2, OracleTypes.ARRAY, ARRAY_TABLE_PLSQL_TYPE);
	// statement.registerOutParameter(3, OracleTypes.ARRAY, ARRAY_TABLE_PLSQL_TYPE);
	//
	// statement.execute();
	//
	// Array arraySqlOut = ((OracleCallableStatement) statement).getArray(2);
	// String[] idLignesBipOut = (String[]) (arraySqlOut.getArray());
	//
	// arraySqlOut = ((OracleCallableStatement) statement).getArray(3);
	// String[] clesOut = (String[]) (arraySqlOut.getArray());
	//
	// if (idLignesBipOut.length != clesOut.length) {
	// String msg = "idLignesBipOut.length(%s) != clesOut.length (%s) ";
	// msg = String.format(msg, idLignesBipOut.length, clesOut);
	// throw new ExceptionTechnique(msg);
	// }
	//
	// Map<String, Boolean> isValideCleByIdLigneBip = new HashMap<String, Boolean>();
	// for (int i = 0; i < idLignesBipOut.length; i++) {
	// String currentIdLigneBip = idLignesBipOut[i];
	// String currentCle = clesOut[i];
	// boolean statutReponse;
	// if (StringUtils.isEmpty(currentCle) || !clesInputByIdLigneBip.get(currentIdLigneBip).equals(currentCle)){
	// statutReponse = false;
	// }
	// else{
	// statutReponse = true;
	// }
	//
	//
	// isValideCleByIdLigneBip.put(currentIdLigneBip, statutReponse);
	// }
	// return isValideCleByIdLigneBip;
	//
	// } catch (Exception e) {
	// String errorMsg = String.format("exception dans getListOfIsValideCle() avec les paramètres : procedure=%s, clesInputByIdLigneBip=%s", procedure,
	// clesInputByIdLigneBip.toString());
	// BipAction.logBipUser.error(errorMsg, e);
	// // TODO refactorer le code pour traiter l'exception
	// throw new ExceptionTechnique(e);
	// }
	//
	// finally {
	// try {
	// if (conn != null && !conn.isClosed()) {
	// conn.close();
	// }
	// } catch (SQLException e) {
	// BipAction.logBipUser.error("Erreur durant la fermeture de la connexion", e);
	// }
	// }
	//
	// }

	public static boolean isValidActivite(String procedure, String p_pid, String p_etape, String p_tache, String p_sous_tache) {

		String message = "";

		Connection conn = null;
		try {

			conn = ConnectionManager.getInstance().getConnection();

			CallableStatement call = conn.prepareCall(" { call " + procedure + " } ");

			call.setObject(1, p_pid);

			call.setObject(2, p_etape);
			call.setObject(3, p_tache);
			call.setObject(4, p_sous_tache);

			call.registerOutParameter(5, Types.VARCHAR);

			call.execute();

			message = call.getString(5);

			if (call != null)
				call.close();

			// Fermeture de la connexion
			if (conn != null) {
				conn.close();
			}

		} catch (Exception e) {
			BipAction.logBipUser.error("Error. Check the code", e);
		} finally {
			// Fermeture de la connexion
			try {
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				BipAction.logBipUser.error("Error. Check the code", e);
			}
		}

		if (message != null && "REJET".equals(message)) {
			return false;
		}
		return true;
	}

	public static String isValidEtapeType(String procedure, String p_pid, String p_activite, String p_type_etape, String p_structureAction) {

		String message = "";

		Connection conn = null;
		try {

			conn = ConnectionManager.getInstance().getConnection();

			CallableStatement call = conn.prepareCall(" { call " + procedure + " } ");

			call.setObject(1, p_pid);
			call.setObject(2, p_activite);
			call.setObject(3, p_type_etape);
			call.setObject(4, p_structureAction);

			call.registerOutParameter(5, Types.VARCHAR);

			call.execute();

			message = call.getString(5);

			if (call != null)
				call.close();

			// Fermeture de la connexion
			if (conn != null) {
				conn.close();
			}

		} catch (Exception e) {
			BipAction.logBipUser.error("Error. Check the code", e);
		} finally {
			// Fermeture de la connexion
			try {
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				BipAction.logBipUser.error("Error. Check the code", e);
			}
		}

		return message;
	}

	public static Set<String> getSetOfIdLignesBipQuiSontDesStructures(String procedure, Set<String> idLignesBipSet) throws Exception {

		Connection conn = null;
		try {
			conn = ConnectionManager.getInstance().getConnection();
			return executeCommonProcedureWithArrayInAndOut(procedure, idLignesBipSet, conn);

		}
		// catch (Exception e) {
		// String errorMsg = String.format("exception dans getSetOfIdLignesBipQuiSontDesStructures() avec les paramètres : procedure=%s, idLignesBip=%s", procedure,
		// idLignesBipSet.toString());
		// BipAction.logBipUser.error(errorMsg, e);
		// // TODO refactorer le code pour traiter l'exception
		// throw new ExceptionTechnique(e);
		// }

		finally {
			try {
				if (conn != null && !conn.isClosed()) {
					conn.close();
				}
			} catch (SQLException e) {
				BipAction.logBipUser.error("Erreur durant la fermeture de la connexion", e);
			}
		}
	}

	private static Set<String> executeCommonProcedureWithArrayInAndOut(String procedure, Set<String> idLignesBipSet, Connection conn) throws SQLException {
		String[] idBipArray = idLignesBipSet.toArray(new String[idLignesBipSet.size()]);
		CallableStatement statement = conn.prepareCall(" { call " + procedure + " } ");

		ArrayDescriptor arrayBipsDesc = ArrayDescriptor.createDescriptor(ARRAY_TABLE_PLSQL_TYPE, conn);
		ARRAY arrayIdLigneBips = new ARRAY(arrayBipsDesc, conn, idBipArray);

		statement.setArray(1, arrayIdLigneBips);
		statement.registerOutParameter(2, OracleTypes.ARRAY, ARRAY_TABLE_PLSQL_TYPE);
		statement.execute();

		Array arraySqlOut = ((OracleCallableStatement) statement).getArray(2);
		return createSetIdLignesBip(arraySqlOut);
	}

	private static Set<String> createSetIdLignesBip(Array arraySqlOut) throws SQLException {
		if (arraySqlOut == null) {
			return new HashSet<String>();
		}
		String[] idLignesBipOut = (String[]) (arraySqlOut.getArray());

		Set<String> IdLignesBip = new HashSet<String>();
		for (int i = 0; i < idLignesBipOut.length; i++) {
			String currentIdLigneBip = idLignesBipOut[i];
			IdLignesBip.add(currentIdLigneBip);
		}
		return IdLignesBip;
	}

	public static boolean isStructSR(String procedure, String p_pid) {

		String message = "";
		Connection conn = null;
		try {

			conn = ConnectionManager.getInstance().getConnection();

			CallableStatement call = conn.prepareCall(" { call " + procedure + " } ");

			call.setObject(1, p_pid);

			call.registerOutParameter(2, Types.VARCHAR);

			call.execute();

			message = call.getString(2);

			if (call != null)
				call.close();

			// Fermeture de la connexion
			if (conn != null) {
				conn.close();
			}

		} catch (Exception e) {
			BipAction.logBipUser.error("Error. Check the code", e);
		}

		finally {
			// Fermeture de la connexion
			try {
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				BipAction.logBipUser.error("Error. Check the code", e);
			}
		}

		if (message != null && "REJET".equals(message)) {
			return false;
		}
		return true;

	}

	public static String getRejetStacheType(String procedure, String p_pid, String p_type_stache) {

		String message = "";
		Connection conn = null;
		try {

			conn = ConnectionManager.getInstance().getConnection();

			CallableStatement call = conn.prepareCall(" { call " + procedure + " } ");

			call.setObject(1, p_pid);
			call.setObject(2, p_type_stache);

			call.registerOutParameter(3, Types.VARCHAR);

			call.execute();

			message = call.getString(3);

			if (call != null)
				call.close();

			// Fermeture de la connexion
			if (conn != null) {
				conn.close();
			}

		} catch (Exception e) {
			BipAction.logBipUser.error("Error. Check the code", e);
		} finally {
			// Fermeture de la connexion
			try {
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				BipAction.logBipUser.error("Error. Check the code", e);
			}
		}

		return message;
	}

	public static String getRejetRessBipCode(String procedure, String p_ident, String p_dateDebConso, String p_dateFinConso) {

		String message = "";
		Connection conn = null;
		try {

			conn = ConnectionManager.getInstance().getConnection();

			CallableStatement call = conn.prepareCall(" { call " + procedure + " } ");

			call.setObject(1, p_ident);
			call.setObject(2, p_dateDebConso);
			call.setObject(3, p_dateFinConso);

			call.registerOutParameter(4, Types.VARCHAR);

			call.execute();

			message = call.getString(4);

			if (call != null)
				call.close();

			// Fermeture de la connexion
			if (conn != null) {
				conn.close();
			}

		} catch (Exception e) {
			BipAction.logBipUser.error("Error. Check the code", e);
		} finally {
			// Fermeture de la connexion
			try {
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				BipAction.logBipUser.error("Error. Check the code", e);
			}
		}

		return message;
	}

	public static boolean isValidRessBipNom(String procedure, String p_ident, String p_ressBipNom) {

		String message = "";
		Connection conn = null;
		try {

			conn = ConnectionManager.getInstance().getConnection();

			CallableStatement call = conn.prepareCall(" { call " + procedure + " } ");

			call.setObject(1, p_ident);
			call.setObject(2, p_ressBipNom);

			call.registerOutParameter(3, Types.VARCHAR);

			call.execute();

			message = call.getString(3);

			if (call != null)
				call.close();

			// Fermeture de la connexion
			if (conn != null) {
				conn.close();
			}

		} catch (Exception e) {
			BipAction.logBipUser.error("Error. Check the code", e);
		} finally {
			// Fermeture de la connexion
			try {
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				BipAction.logBipUser.error("Error. Check the code", e);
			}
		}

		if (message != null && "REJET".equals(message)) {
			return false;
		}

		return true;
	}

	// FAD PPM 64368 : Purge de la table temporaire
	public static boolean purgeConsommationTmp(String procedure, int numSeq) {

		String message = "";
		Connection conn = null;
		try {

			conn = ConnectionManager.getInstance().getConnection();

			CallableStatement call = conn.prepareCall(" { call " + procedure + " } ");

			call.setObject(1, numSeq);

			// call.registerOutParameter(2, Types.VARCHAR);

			call.execute();

			// message = call.getString(2);

			if (call != null)
				call.close();

			// Fermeture de la connexion
			if (conn != null) {
				conn.close();
			}

		} catch (Exception e) {
			BipAction.logBipUser.error("Error. Check the code", e);
		} finally {
			// Fermeture de la connexion
			try {
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				BipAction.logBipUser.error("Error. Check the code", e);
			}
		}

		if (message != null && "REJET".equals(message)) {
			return false;
		}

		return true;
	}

	// FAD PPM 64368 : Récupération d'un id unique pour le traitement en cours
	public static String getNumSeq(String procedure) {
		String numSeq = null;
		Connection conn = null;
		try {

			conn = ConnectionManager.getInstance().getConnection();

			CallableStatement call = conn.prepareCall(" { call " + procedure + " } ");

			call.registerOutParameter(1, Types.INTEGER);

			call.execute();

			numSeq = call.getString(1);

			if (call != null)
				call.close();

			// Fermeture de la connexion
			if (conn != null) {
				conn.close();
			}

		} catch (Exception e) {
			BipAction.logBipUser.error("Error. Check the code", e);
		} finally {
			// Fermeture de la connexion
			try {
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				BipAction.logBipUser.error("Error. Check the code", e);
			}
		}

		return numSeq;
	}

	// FAD PPM 64368 : Insertion de la ligne en cours dans une table temporaire
	public static boolean insererConsommationTmp(String procedure, int numSeq, String sPid, String structAction, Integer etapeNum, Integer tacheNum, Integer stacheNum,
			String sDate_deb_conso, String sConsoFinDate, Integer ressBip, Float fConsoQte) {

		String message = "";
		Connection conn = null;
		try {

			conn = ConnectionManager.getInstance().getConnection();

			CallableStatement call = conn.prepareCall(" { call " + procedure + " } ");

			call.setObject(1, numSeq);
			call.setObject(2, sPid);
			call.setObject(3, structAction);
			call.setObject(4, etapeNum);
			call.setObject(5, tacheNum);
			call.setObject(6, stacheNum);
			call.setObject(7, sDate_deb_conso);
			call.setObject(8, sConsoFinDate);
			call.setObject(9, ressBip);
			call.setObject(10, fConsoQte);

			call.registerOutParameter(11, Types.VARCHAR);

			call.execute();

			message = call.getString(11);

			if (call != null)
				call.close();

			// Fermeture de la connexion
			if (conn != null) {
				conn.close();
			}

		} catch (Exception e) {
			BipAction.logBipUser.error("Error. Check the code", e);
		} finally {
			// Fermeture de la connexion
			try {
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				BipAction.logBipUser.error("Error. Check the code", e);
			}
		}

		if (message != null && "REJET".equals(message)) {
			return false;
		}

		return true;
	}

	// FAD PPM 64368 : Verification consomation du mois et de l'année
	public static boolean consoMoisAnnee(String procedure, int numSeq, String sPid, String structAction, Integer etapeNum, Integer tacheNum, Integer stacheNum,
			String sDate_deb_conso, String sConsoFinDate, Integer ressBip, Float fConsoQte) {

		String message = "";
		Connection conn = null;
		try {

			conn = ConnectionManager.getInstance().getConnection();

			CallableStatement call = conn.prepareCall(" { call " + procedure + " } ");

			call.setObject(1, numSeq);
			call.setObject(2, sPid);
			call.setObject(3, structAction);
			call.setObject(4, etapeNum);
			call.setObject(5, tacheNum);
			call.setObject(6, stacheNum);
			call.setObject(7, sDate_deb_conso);
			call.setObject(8, sConsoFinDate);
			call.setObject(9, ressBip);
			call.setObject(10, fConsoQte);

			call.registerOutParameter(11, Types.VARCHAR);

			call.execute();

			message = call.getString(11);

			if (call != null)
				call.close();

			// Fermeture de la connexion
			if (conn != null) {
				conn.close();
			}

		} catch (Exception e) {
			BipAction.logBipUser.error("Error. Check the code", e);
		} finally {
			// Fermeture de la connexion
			try {
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				BipAction.logBipUser.error("Error. Check the code", e);
			}
		}

		if (message != null && "REJET".equals(message)) {
			return false;
		}

		return true;
	}
	// FAD PPM 64368 : Fin

	public static boolean isLigneProductive(String procedure, String p_pid) {

		String result = "";
		Connection conn = null;
		try {

			conn = ConnectionManager.getInstance().getConnection();

			CallableStatement call = conn.prepareCall(" { call " + procedure + " } ");

			call.setObject(1, p_pid);

			call.registerOutParameter(2, Types.VARCHAR);

			call.execute();

			result = call.getString(2);

			// FIXME DHA ne pas fermer deux fois
			if (call != null && !call.isClosed())
				call.close();

			// FIXME DHA ne pas fermer deux fois
			// Fermeture de la connexion
			if (conn != null && !conn.isClosed()) {
				conn.close();
			}

		} catch (Exception e) {
			BipAction.logBipUser.error("Error. Check the code", e);
		} finally {
			// Fermeture de la connexion
			try {
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				BipAction.logBipUser.error("Error. Check the code", e);
			}
		}

		if (result != null && "FALSE".equals(result)) {
			return false;
		}
		return true;
	}

	public static boolean isPeriodeAnterieureAnneeFonct(String procedure, String p_dateDebConso) {

		String result = "";
		Connection conn = null;
		try {

			conn = ConnectionManager.getInstance().getConnection();

			CallableStatement call = conn.prepareCall(" { call " + procedure + " } ");

			call.setObject(1, p_dateDebConso);

			call.registerOutParameter(2, Types.VARCHAR);

			call.execute();

			result = call.getString(2);

			if (call != null)
				call.close();

			// Fermeture de la connexion
			if (conn != null) {
				conn.close();
			}

		} catch (Exception e) {
			BipAction.logBipUser.error("Error. Check the code", e);
		} finally {
			// Fermeture de la connexion
			try {
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				BipAction.logBipUser.error("Error. Check the code", e);
			}
		}

		if (result != null && "REJET".equals(result)) {
			return true;
		}
		return false;
	}

	public static String isPeriodeUlterieureMoisFonct(String procedure, String p_dateDebConso, String p_pid) {

		String result = "";
		Connection conn = null;
		try {

			conn = ConnectionManager.getInstance().getConnection();

			CallableStatement call = conn.prepareCall(" { call " + procedure + " } ");

			call.setObject(1, p_dateDebConso);
			call.setObject(2, p_pid);

			call.registerOutParameter(3, Types.VARCHAR);

			call.execute();

			result = call.getString(3);

			if (call != null)
				call.close();

			// Fermeture de la connexion
			if (conn != null) {
				conn.close();
			}

		} catch (Exception e) {
			BipAction.logBipUser.error("Error. Check the code", e);
		} finally {
			// Fermeture de la connexion
			try {
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				BipAction.logBipUser.error("Error. Check the code", e);
			}
		}

		return result;
	}

	public static String isPeriodeUlterieureAnneeFonct(String procedure, String p_dateDebConso, String p_pid) {

		String result = "";
		Connection conn = null;
		try {

			conn = ConnectionManager.getInstance().getConnection();

			CallableStatement call = conn.prepareCall(" { call " + procedure + " } ");

			call.setObject(1, p_dateDebConso);
			call.setObject(2, p_pid);

			call.registerOutParameter(3, Types.VARCHAR);

			call.execute();

			result = call.getString(3);

			if (call != null)
				call.close();

			// Fermeture de la connexion
			if (conn != null) {
				conn.close();
			}

		} catch (Exception e) {
			BipAction.logBipUser.error("Error. Check the code", e);
		} finally {
			// Fermeture de la connexion
			try {
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				BipAction.logBipUser.error("Error. Check the code", e);
			}
		}

		return result;
	}

	public static Vector listPmwBips(String procedure) {

		String listeCp = "";
		HttpSession session;
		Vector<RBipData> vRbipData = new Vector<RBipData>();
		RBipData rbipdata;
		String message = "";
		Object curseur = null;

		Connection conn = null;

		try {

			conn = ConnectionManager.getInstance().getConnection();

			CallableStatement call = conn.prepareCall(" { call " + procedure + " } ");

			call.setObject(1, UserBip.ID_PERSONNE);

			call.registerOutParameter(2, OracleTypes.CURSOR);
			call.registerOutParameter(3, Types.VARCHAR);

			call.execute();

			curseur = call.getObject(2);
			message = call.getString(3);

			ResultSet rset = (ResultSet) curseur;

			try {
				int j = 2;
				while (rset.next()) {

					rbipdata = new RBipData("BIPS_GLOBAL", j);

					ResultSetMetaData rsmd = rset.getMetaData();
					int nbColonnes = rsmd.getColumnCount();
					int i = 1;
					while (i <= nbColonnes) {
						rbipdata.put(COLONNES_BIPS[i - 1], rset.getString(i));
						i++;

					}

					vRbipData.add(rbipdata);
					j++;

				}

				if (call != null)
					call.close();

				// Fermeture de la connexion
				if (conn != null) {
					conn.close();
				}

			} catch (SQLException sqle) {
				if (call != null)
					call.close();

				// Fermeture de la connexion
				if (conn != null) {
					conn.close();
				}

			} finally {
				try {
					if (rset != null)
						rset.close();
				} catch (SQLException sqle) {
					if (call != null)
						call.close();

					// Fermeture de la connexion
					if (conn != null) {
						conn.close();
					}
				}
			}
			// } // if
			// } // for

		} // try
		catch (Exception e) {
			BipAction.logBipUser.error("Error. Check the code", e);
		} finally {
			// Fermeture de la connexion
			try {
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				BipAction.logBipUser.error("Error. Check the code", e);
			}
		}

		return vRbipData;
	}

	// SEL QC 1811
	public static String[] verifier_tache_axe_metier_bips(String sTacheAxeMetier, String sPid, String procedure) {

		String[] tRetour = { "", "" };
		Connection conn = null;

		try {

			conn = ConnectionManager.getInstance().getConnection();

			CallableStatement call = conn.prepareCall(" { call " + procedure + " } ");

			call.setObject(1, sTacheAxeMetier);
			call.setObject(2, sPid);

			call.registerOutParameter(3, java.sql.Types.VARCHAR);
			call.registerOutParameter(4, java.sql.Types.VARCHAR);

			call.executeQuery();

			tRetour[0] = (String) call.getString(3);
			tRetour[1] = (String) call.getString(4);

			if (call != null)
				call.close();

			// Fermeture de la connexion
			if (conn != null) {
				conn.close();
			}

		} // try
		catch (BaseException e) {
			BipAction.logBipUser.error("Error. Check the code", e);
			return null;
		} catch (SQLException e) {
			BipAction.logBipUser.error("Error. Check the code", e);
			return null;
		} catch (Exception e) {
			// TODO Auto-generated catch block
			BipAction.logBipUser.error("Error. Check the code", e);
		} finally {
			// Fermeture de la connexion
			try {
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				BipAction.logBipUser.error("Error. Check the code", e);
			}
		}

		return tRetour;

	}
	//Added for BIP-7 to do DMP check at ligne level
			public static String[] verifier_ligne_axe_metier_bips(
					String sPid, String procedure) {

				String[] tRetour = { "", "" };
				Connection conn = null;

				try {

					conn = ConnectionManager.getInstance().getConnection();

					CallableStatement call = conn.prepareCall(" { call " + procedure + " } ");

					call = conn.prepareCall(" { call " + procedure + " } ");


					call.setObject(1, sPid);

					call.registerOutParameter(2, java.sql.Types.VARCHAR);
					call.registerOutParameter(3, java.sql.Types.CHAR);

					call.executeQuery();

					tRetour[0] = (String) call.getString(2);
					tRetour[1] = (String) call.getString(3);

					if (call != null)
						call.close();

					// Fermeture de la connexion
					if (conn != null) {
						conn.close();
					}

				} // try
				catch (BaseException be) {
					be.printStackTrace();
					return null;

				} catch (SQLException e) {
					e.printStackTrace();
					return null;
				} catch (ClassNotFoundException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (InstantiationException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (IllegalAccessException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} finally {
					// Fermeture de la connexion
					try {
						if (conn != null) {
							conn.close();
						}
					} catch (SQLException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}

				return tRetour;

			}

	public static void inserer_erreur_bips(RBipErreur rBipErreur, String sPid, String sRess, String sActivite, String sDeb, String sConso, String procedure) {

		SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
		String RessBloq = "";
		int i = 0;
		String sRetour = "";

		Connection conn = null;
		try {
			conn = ConnectionManager.getInstance().getConnection();

			CallableStatement call = conn.prepareCall(" { call " + procedure + " } ");

			call.setObject(1, rBipErreur.getLibelle());
			call.setObject(2, sPid);
			call.setObject(3, sRess);
			call.setObject(4, sActivite);
			call.setObject(5, sDeb);
			call.setObject(6, ("".equals(sConso) ? "" : Float.parseFloat(sConso)));
			call.setObject(7, rBipErreur.getsTag());
			call.setObject(8, rBipErreur.getCode());

			call.registerOutParameter(9, java.sql.Types.VARCHAR);
			call.executeQuery();

			sRetour = (String) call.getString(9);

			if (call != null)
				call.close();

			// Fermeture de la connexion
			if (conn != null) {
				conn.close();
			}

		} catch (BaseException e) {
			BipAction.logBipUser.error("Error. Check the code", e);
		}

		catch (SQLException e) {
			BipAction.logBipUser.error("Error. Check the code", e);
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			BipAction.logBipUser.error("Error. Check the code", e);
		} catch (InstantiationException e) {
			// TODO Auto-generated catch block
			BipAction.logBipUser.error("Error. Check the code", e);
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			BipAction.logBipUser.error("Error. Check the code", e);
		} finally {
			// Fermeture de la connexion
			try {
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				BipAction.logBipUser.error("Error. Check the code", e);
			}
		}

	}

	public static void deleteRejetMensuelleBips(String sVar, String procedure) {

		String sRetour = "";

		Connection conn = null;
		try {
			conn = ConnectionManager.getInstance().getConnection();

			CallableStatement call = conn.prepareCall(" { call " + procedure + " } ");

			call.setObject(1, sVar);

			call.registerOutParameter(2, java.sql.Types.VARCHAR);
			call.executeQuery();

			sRetour = (String) call.getString(2);

			if (call != null)
				call.close();

			// Fermeture de la connexion
			if (conn != null) {
				conn.close();
			}

		} catch (BaseException e) {
			BipAction.logBipUser.error("Error. Check the code", e);
		}

		catch (SQLException e) {
			BipAction.logBipUser.error("Error. Check the code", e);
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			BipAction.logBipUser.error("Error. Check the code", e);
		} catch (InstantiationException e) {
			// TODO Auto-generated catch block
			BipAction.logBipUser.error("Error. Check the code", e);
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			BipAction.logBipUser.error("Error. Check the code", e);
		} finally {
			// Fermeture de la connexion
			try {
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				BipAction.logBipUser.error("Error. Check the code", e);
			}
		}

	}

	public static String getData(RBipData sData, String sChamp) {
		return (sData.getData(sChamp) == null ? "" : sData.getData(sChamp).toString()) + ";";
	}

	public static boolean isClientBBRF03(String clicode, String procedure) {

		int retour = 0;
		Connection conn = null;

		try {

			conn = ConnectionManager.getInstance().getConnection();

			CallableStatement call = conn.prepareCall(" { call " + procedure + " } ");

			call.setObject(1, clicode);

			call.registerOutParameter(2, java.sql.Types.INTEGER);

			call.executeQuery();

			retour = Integer.parseInt(call.getString(2));

			if (call != null)
				call.close();

			// Fermeture de la connexion
			if (conn != null) {
				conn.close();
			}

		} // try
		catch (Exception e) {
			BipAction.logBipUser.error("Error. Check the code", e);
		} finally {
			// Fermeture de la connexion
			try {
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				BipAction.logBipUser.error("Error. Check the code", e);
			}
		}

		if (retour == 1) {
			return true;
		} else {
			return false;
		}

	}

	public static String recup_dpcopi_du_proj(String sProjet, String procedure) {

		String retour = "";
		Connection conn = null;

		try {

			conn = ConnectionManager.getInstance().getConnection();

			CallableStatement call = conn.prepareCall(" { call " + procedure + " } ");

			call.setObject(1, sProjet);

			call.registerOutParameter(2, java.sql.Types.VARCHAR);

			call.executeQuery();

			retour = (String) call.getString(2);

			if (call != null)
				call.close();

			// Fermeture de la connexion
			if (conn != null) {
				conn.close();
			}

		} // try
		catch (Exception e) {
			BipAction.logBipUser.error("Error. Check the code", e);
		} finally {
			// Fermeture de la connexion
			try {
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				BipAction.logBipUser.error("Error. Check the code", e);
			}
		}

		return retour;

	}

	public static MonthAndYearFunctional findMoisFonctionnel() throws Exception {

		Connection conn = null;

		try {

			conn = ConnectionManager.getInstance().getConnection();
			String sql = "SELECT cmensuelle FROM datdebex";
			PreparedStatement ps = conn.prepareStatement(sql);
			ResultSet resultSet = ps.executeQuery();
			if (resultSet.next()) {
				Date monthDateOldAPI = resultSet.getDate(1);
				LocalDate monthDate = Instant.ofEpochMilli(monthDateOldAPI.getTime()).atZone(ZoneId.systemDefault()).toLocalDate();
				return new MonthAndYearFunctional(monthDate.getYear(), monthDate.getMonthValue());
			}
			throw new ExceptionTechnique("cmensuelle not found in the table.");

		}
		// catch (Exception e) {
		// String errorMsg = String.format("exception dans findMoisFonctionnel()");
		// BipAction.logBipUser.error(errorMsg, e);
		// // TODO refactorer le code pour traiter l'exception
		// throw new ExceptionTechnique(e);
		// }

		finally {
			try {
				if (conn != null && !conn.isClosed()) {
					conn.close();
				}
			} catch (SQLException e) {
				BipAction.logBipUser.error("Erreur durant la fermeture de la connexion", e);
			}
		}
	}

	
	/*BIP-355 Outsourcing not allowed for non-productive BIP Line- STARTS*/
	public static Map<String, Set<String>> getOutSourcedData(Map<String, Set<String>> validFFbyLigneBipId) {

		String procedure = null;
		Connection conn = null;
		Object[] arrayObject = new Object[validFFbyLigneBipId.entrySet().size()];
		
		try {
			procedure = storedProcProperties.getValueOrThrowException("rbip.get.eligible.outsourced.data.proc");
			//procedure = "PACK_REMONTEE.GET_ELIGIBLE_OUTSOURCED_DATA(?,?)";
			conn = ConnectionManager.getInstance().getConnection();
			CallableStatement statement = conn.prepareCall(" { call " + procedure + " } ");
			ArrayDescriptor bipsOutSourceTab = ArrayDescriptor.createDescriptor(ARRAY_BIPS_OUTSRC_TYPE, conn);
			StructDescriptor bipsOutSourceRec = StructDescriptor.createDescriptor(ARRAY_BIPS_OUTSRC_REC_TYPE, conn);
			ArrayDescriptor arrayBips = ArrayDescriptor.createDescriptor(ARRAY_TABLE_PLSQL_TYPE, conn);
			
			int i = 0;
			for (Entry<String, Set<String>> entry : validFFbyLigneBipId.entrySet())
			{
				String[] idBipArray = entry.getValue().toArray(new String[entry.getValue().size()]);
				ARRAY arrayIdLigneBips = new ARRAY(arrayBips, conn, idBipArray);
			    Object[] obj = {entry.getKey().toString(),arrayIdLigneBips};
				STRUCT structObj = new STRUCT(bipsOutSourceRec, conn, obj);
				arrayObject[i] = structObj;
				i++;
			}
			
			ARRAY arrayIn = new ARRAY(bipsOutSourceTab, conn, arrayObject);
			statement.setArray(1, arrayIn);
			statement.registerOutParameter(2, OracleTypes.ARRAY, ARRAY_BIPS_OUTSRC_TYPE);
			statement.execute();

			Array arraySqlOut = ((OracleCallableStatement) statement).getArray(2);		
			if (arraySqlOut == null) {
				return new HashMap<String, Set<String>>();
			}			
			Object[] arraySqlOutObj = (Object[]) (arraySqlOut.getArray());			
			validFFbyLigneBipId = new HashMap<String, Set<String>>();
			
			for(Object obj : arraySqlOutObj){
				STRUCT structObj = (STRUCT) obj;
				Object [] arrayOut = structObj.getAttributes();
				Set<String> stacheTypeSet = createSetIdLignesBip((Array) arrayOut[1]);
				validFFbyLigneBipId.put((String) arrayOut[0], stacheTypeSet);
			}

			return validFFbyLigneBipId;

		} catch (Exception e) {
			String errorMsg = String.format("Exception in getOutSourcedData() with parameters : procedure=%s, idLignesBip=%s", procedure,
					validFFbyLigneBipId.toString());
			BipAction.logBipUser.error(errorMsg, e);
			throw new ExceptionTechnique(e);
		}

		finally {
			try {
				if (conn != null && !conn.isClosed()) {
					conn.close();
				}
			} catch (SQLException e) {
				BipAction.logBipUser.error("Erreur durant la fermeture de la connexion", e);
			}
		}		
	}
	/*BIP-355 Outsourcing not allowed for non-productive BIP Line- ENDS*/

	public static Map<String, Set<java.util.Date>> checkRetroApplicativeParam(Map<String, Set<java.util.Date>> uniqueIdentMap) {

		String procedure = null;
		Connection conn = null;
		
		Set<String> uniqueIdent = uniqueIdentMap.keySet();
		
		try {
			procedure = storedProcProperties.getValueOrThrowException("rbip.get.retro.data");
			//procedure = "PACK_REMONTEE.SP_FIND_RETRO(?,?)";
			conn = ConnectionManager.getInstance().getConnection();
			String[] identArray = uniqueIdent.toArray(new String[uniqueIdent.size()]);
			ArrayDescriptor arrayDesc = ArrayDescriptor.createDescriptor(ARRAY_TABLE_PLSQL_TYPE, conn);
			ARRAY arrayIdent = new ARRAY(arrayDesc, conn, identArray);
			CallableStatement statement = conn.prepareCall(" { call " + procedure + " } ");
						
			statement.setArray(1, arrayIdent);
			statement.registerOutParameter(2, OracleTypes.ARRAY, ARRAY_TABLE_PLSQL_TYPE);
			statement.execute();

			Array arraySqlOut = ((OracleCallableStatement) statement).getArray(2);
			
			uniqueIdent = new HashSet<String>();
			
			uniqueIdent = createSetIdLignesBip(arraySqlOut);
			
			for (String key : new ArrayList<String>(uniqueIdentMap.keySet())) {
				if (!uniqueIdent.contains(key)){
					uniqueIdentMap.remove(key);
				}
			}
			  			
			return uniqueIdentMap;
			
		} catch (Exception e) {
			String errorMsg = String.format("Exception in checkRetroApplicativeParam() with parameters : procedure=%s, idUser=%s", procedure,
					uniqueIdent.toArray(new String[uniqueIdent.size()]));
			BipAction.logBipUser.error(errorMsg, e);
			throw new ExceptionTechnique(e);
		}
		finally {
			try {
				if (conn != null && !conn.isClosed()) {
					conn.close();
				}
			} catch (SQLException e) {
				BipAction.logBipUser.error("Erreur durant la fermeture de la connexion", e);
			}
		}		
	}
	
	/**
	 * Method to get the hierarchy data from databas
	 * @param choice 
	 * @param loggedUser 
	 * @return
	 * @throws SQLException
	 * @throws ClassNotFoundException
	 */
	public static Map<Integer, List<ResultHierarchy>> getHierarchyReportdata(
			String ident, String choice, String loggedUser, String orderBy) {

		String procedure = null;
		Connection conn = null;
		Map<Integer, List<ResultHierarchy>> resultMap = new HashMap<Integer, List<ResultHierarchy>>();
		try {

			 procedure = storedProcProperties.getValueOrThrowException("hier.get.details");
			 BipAction.logBipUser.debug(procedure);
			//procedure = "PACK_POPULATE_HIERARCHY.SP_GET_HIERARCHY(?,?,?,?)";
			conn = ConnectionManager.getInstance().getConnection();

			CallableStatement statement = conn.prepareCall(" { call "
					+ procedure + " } ");

			statement.setString(1, ident);
			statement.setString(2, choice);
			statement.setString(3, orderBy);
			statement.registerOutParameter(4, OracleTypes.CURSOR);
			statement.registerOutParameter(5, OracleTypes.NUMBER);
			statement.registerOutParameter(6, OracleTypes.VARCHAR);
			statement.execute();

			if (0 == statement.getInt(5)) {

				Object cursor = statement.getObject(4);
				ResultSet rset = (ResultSet) cursor;

				while (rset.next()) {
					List<ResultHierarchy> resultList = new ArrayList<ResultHierarchy>();
					ResultHierarchy result = new ResultHierarchy();
					result.setIdent(rset.getInt(1));
					result.setCpIdent(rset.getInt(2));
					result.setName(rset.getString(3));
					result.setLigneCnt(rset.getInt(4));
					result.setActInd(rset.getString(5));
					result.setManInd(rset.getString(6));
					result.setSelInd(rset.getString(8));

					if (resultMap.containsKey(rset.getInt(7))) {
						List<ResultHierarchy> oldList = resultMap.get(rset
								.getInt(7));
						oldList.add(result);
						resultMap.put(rset.getInt(7), oldList);
					} else {
						resultList.add(result);
						resultMap.put(rset.getInt(7), resultList);
					}
				}
			} else {				
				throw new SQLException(statement.getInt(5) + " "
						+ statement.getString(6));
			}
		} catch (Exception e) {
			String errorMsg = String.format("Exception in getHierarchyReportdata() with parameters : procedure=%s, ident=%s", procedure,
					ident);
			try {
				conn = ConnectionManager.getInstance().getConnection();
				String sql = "UPDATE TRAIT_ASYNCHRONE SET STATUT   = '-1'  WHERE USERID = :1  AND STATUT   = '0' AND REPORTID = 'xHierarchy1'";
				PreparedStatement ps = conn.prepareStatement(sql);
				ps.setString(1, loggedUser);
				ps.executeUpdate();
				conn.commit();
				
			} catch (Exception e1) {
				BipAction.logBipUser.error(e1);
				throw new ExceptionTechnique(e1);
			}
			
			BipAction.logBipUser.debug("Sataus updated for wrong data");
			BipAction.logBipUser.error(errorMsg, e);
			throw new ExceptionTechnique(e);
		}

		finally {
			try {
				if (conn != null && !conn.isClosed()) {
					conn.close();
				}
			} catch (SQLException e) {
				BipAction.logBipUser.error("Erreur durant la fermeture de la connexion", e);
			}
		}
		return resultMap;
	}

	public static String getIdentHierarchy(String rtfe) {

		String procedure = null;
		Connection conn = null;
		String ident;
		try {

			 procedure = storedProcProperties.getValueOrThrowException("hier.get.ident");
			//procedure = "PACK_POPULATE_HIERARCHY.SP_GET_IDENT(?,?)";
			 BipAction.logBipUser.debug(procedure);
			conn = ConnectionManager.getInstance().getConnection();

			CallableStatement statement = conn.prepareCall(" { call "
					+ procedure + " } ");

			statement.setString(1, rtfe);
			statement.registerOutParameter(2, OracleTypes.VARCHAR);
			statement.execute();

			ident = statement.getString(2);
		} catch (Exception e) {
			String errorMsg = String.format("Exception in getIdentHierarchy() with parameters : procedure=%s, rtfe=%s", procedure,
					rtfe);
			BipAction.logBipUser.error(errorMsg, e);
			throw new ExceptionTechnique(e);
		}

		finally {
			try {
				if (conn != null && !conn.isClosed()) {
					conn.close();
				}
			} catch (SQLException e) {
				BipAction.logBipUser.error("Erreur durant la fermeture de la connexion", e);
			}
		}
		return ident;
	}

	public static String getChefProj(String rtfe, String loggedUser) {

		String procedure = null;
		Connection conn = null;
		String chefProj;
		try {

			 procedure = storedProcProperties.getValueOrThrowException("hier.get.chef");
			//procedure = "PACK_POPULATE_HIERARCHY.SP_GET_CHEF_PROJ(?,?)";
			 BipAction.logBipUser.debug(procedure);
			conn = ConnectionManager.getInstance().getConnection();

			CallableStatement statement = conn.prepareCall(" { call "
					+ procedure + " } ");

			statement.setString(1, rtfe);
			statement.registerOutParameter(2, OracleTypes.VARCHAR);
			statement.execute();

			chefProj = statement.getString(2);
		} catch (Exception e) {
			String errorMsg = String.format("Exception in getIdentHierarchy() with parameters : procedure=%s, rtfe=%s", procedure,
					rtfe);
			try {
				conn = ConnectionManager.getInstance().getConnection();
				String sql = "UPDATE TRAIT_ASYNCHRONE SET STATUT   = '-1'  WHERE USERID = :1  AND STATUT   = '0' AND REPORTID = 'xHierarchy1'";
				PreparedStatement ps = conn.prepareStatement(sql);
				ps.setString(1, loggedUser);
				ps.executeUpdate();
				conn.commit();
				
			} catch (Exception e1) {
				BipAction.logBipUser.error(e1);
				throw new ExceptionTechnique(e1);
			}
			
			BipAction.logBipUser.debug("Sataus updated for wrong data");
			BipAction.logBipUser.error(errorMsg, e);
			throw new ExceptionTechnique(e);
		}

		finally {
			try {
				if (conn != null && !conn.isClosed()) {
					conn.close();
				}
			} catch (SQLException e) {
				BipAction.logBipUser.error("Erreur durant la fermeture de la connexion", e);
			}
		}
		return chefProj;
	}
}
