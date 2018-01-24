package com.socgen.bip.db;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Clob;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Vector;

import com.socgen.bip.commun.parametre.ParametreManager;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.cap.fwk.ServiceManager;
import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.cap.fwk.jdbc.JDBCWrapper;
import com.socgen.cap.fwk.log.Log;

/**
 * @author N.BACCAM
 * 
 * encapsule l'accès à la base de données
 */
public class JdbcBip {

	public final String DATASOURCE_WORK = "JDBCWrapper.jdbc.datasource";

	public final String DATASOURCE_REMONTEE = "JDBCWrapper.jdbc.datasource.remontee";

	public final String DATASOURCE_ACTU = "JDBCWrapper.jdbc.datasource.actualite";

	public final String DATASOURCE_HISTO = "JDBCWrapper.jdbc.datasource.histo";

	private static Log logJdbc = ServiceManager.getInstance().getLogManager()
			.getLogJdbc();

	public JDBCUpdaterOracle jdbc;

	/**
	 * Constructor for jdbc
	 */
	public JdbcBip() {
		
		jdbc = new JDBCUpdaterOracle();
		jdbc.setDataSourceName(DATASOURCE_WORK);
		
	}

	public Clob stringToClob(final String chaine) throws BaseException {
		try {
			return jdbc.stringToClob(chaine);
		} catch (SQLException e) {
			logJdbc.debug("stringToClob --> Exception :" + e);
			throw new BaseException(BaseException.BASE_READ_RS,
					e);
		} catch (IOException e) {
			logJdbc.debug("stringToClob --> Exception :" + e);
			throw new BaseException(BaseException.BASE_READ_RS,
					e);
		} catch (BaseException e) {
			logJdbc.debug("stringToClob --> Exception :" + e);
			throw e;
		}
	}
	
	/**
	 * récupère une connexion Oracle et appel une procédure stockée
	 */
	public Vector getResult(Hashtable paramProc,
			Config configProc, String cleProc) throws BaseException {

		String signatureMethode = "JdbcBip-getResult()";
		logJdbc.entry(signatureMethode);

		if (configProc == null || paramProc == null || cleProc == null
				|| cleProc.length() == 0) {
			logJdbc
					.debug("!!! l'un des args est null dans "
							+ signatureMethode);
			logJdbc.debug("!!!  paraProc = "
					+ paramProc + ";  configProc = " + configProc
					+ ";  cleProc = " + cleProc);
			logJdbc.exit(signatureMethode);
			return null;
		}

		String positionIn;
		String positionOut;
		Vector vParamOut = new Vector();
		Vector vParamIn = new Vector();
		Hashtable paramOut = new Hashtable();
		
		String procPLSQL;

		positionIn = cleProc + ".in";
		positionOut = cleProc + ".out";
		procPLSQL = configProc.getString(cleProc);

		

		// Stocker les paramètres in dans un Vector
		vParamIn = (new ParametreManager()).recupererParamIn(configProc, positionIn,
				paramProc);
		// Stocker les paramètres out dans un Vector
		vParamOut = (new ParametreManager()).recupererParamOut(configProc, positionOut);

		try {
			// on appelle la procédure stockée
			int ret = jdbc.callProcStoc(procPLSQL, vParamIn, vParamOut, false);
			// logJdbc.debug("getResult --> TRACE DAVID
			// JDBCBIP:"+jdbc.toString());
			if (ret == -1) {
				return null;
			}
		} catch (BaseException e) {
			logJdbc.debug("getResult --> Exception :" + e);
			throw e;
		}
		/*
		 * finally { //fermeture de la connexion logJdbc.debug("getResult
		 * --> TRACE DAVID JdbcBip Finally:"+jdbc.toString()); //jdbc.close();
		 * 
		 * /*jdbc=new JDBCUpdaterOracle(); jdbc.setDataSourceName(sDataSource);
		 * jdbc.toto(); }
		 */
		logJdbc.exit(signatureMethode);
		return vParamOut;

	}

	
	public void closeJDBC() {
		// logJdbc.debug("Entrée dans CloseJDBC");
		try {
			if (jdbc != null) {
				jdbc.close();
				jdbc = null;
			}
		} catch (BaseException be) {
			logJdbc.debug(" jdbc.closeJDBC --> Close JDBC BaseException:"
					+ be);
		}
	}

	/**
	 * Encapsule la récupération des résultats de la procédure pour l'action
	 * créer Récupère le message d'erreur
	 */
	public  String recupererResult(Vector vParamOut, String mode)
			throws BaseException {
		String message = "";
		// Récupération des résultats

		for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
			ParametreProc paramOut = (ParametreProc) e.nextElement();

			// cas de la création
			if (mode.equals("creer")) {
				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();

					try {
						if (rset.next()) {
							message = "Entité déjà existante";
						} // if
						if (rset != null)
							rset.close();
					}// try
					catch (SQLException sqle) {
						throw new BaseException(BaseException.BASE_READ_RS,
								sqle);
					}// catch

				}// if
			}
			
			// cas de la création
			
			// cas de la validation
			if (mode.equals("valider")) {
				// on récupère le message d'erreur applicative P_MESSAGE
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();
				}
			}
		}// for
		// jdbc.close();
		return message;
	}// RecupererResultCreer

	/**
	 * Encapsule la récupération du libellé du champ INFO pour affichage sur le
	 * menu Libellé du DPG ou numéro du centre de frais
	 */
	public String recupererInfo(String requete) throws BaseException {
		String libelle = null;
		try {
			JDBCWrapper jdbcWrapper = ServiceManager.getInstance()
					.getJdbcManager().getWriter();
			try {
				jdbcWrapper.execute(requete);

				while (jdbcWrapper.next()) {
					libelle = jdbcWrapper.getString(1);
				}
			}// try
			catch (BaseException be) {
				throw new BaseException(BaseException.BASE_EXEC_SQL, be);
			}// catch
			finally {
				// fermeture de la connexion
				jdbcWrapper.close();
			}// finally
		}// try
		catch (BaseException e) {
			throw new BaseException(BaseException.BASE_FACT_WRAP, e);
		}// catch
		return libelle;
	}// recupererInfo

	public  void alimCLOB(String sDataSource, String sTable,
			String sChampAUpdater, String sClause, Vector vLignes2Update)
			throws BaseException {
		JDBCUpdaterOracle jdbc = new JDBCUpdaterOracle();
		jdbc.setDataSourceName(sDataSource);
		jdbc.alimCLOB(sTable, sChampAUpdater, sClause, vLignes2Update);
		jdbc.close();
	}

	public  void alimBLOB(String sDataSource, String sTable,
			String sChampAUpdater, String sClause, InputStream data)
			throws BaseException {
		JDBCUpdaterOracle jdbc = new JDBCUpdaterOracle();
		jdbc.setDataSourceName(sDataSource);
		jdbc.alimBLOB(sTable, sChampAUpdater, sClause, data);
		jdbc.close();
	}
	
	
}// class
