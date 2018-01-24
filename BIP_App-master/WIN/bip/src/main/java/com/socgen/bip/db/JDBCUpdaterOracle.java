package com.socgen.bip.db;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.StringReader;
import java.io.Writer;
import java.sql.Array;
import java.sql.Blob;
import java.sql.CallableStatement;
import java.sql.Clob;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Vector;

import oracle.jdbc.driver.OracleTypes;
import oracle.jdbc.oracore.OracleTypeCOLLECTION;
import oracle.sql.CLOB;

import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.metier.CentreActivite;
import com.socgen.cap.fwk.ServiceManager;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.cap.fwk.jdbc.JDBCUpdater;
import com.socgen.cap.fwk.log.Log;

/**
 * @author N.BACCAM recupererListeGlobaleCentreActivite : S Lallier Classe
 *         d'encapsulation des mises à jour de la base de données via l'API JDBC
 *         Utilisation des types ORACLE
 */
public class JDBCUpdaterOracle extends JDBCUpdater {

	/** CallableStatement */
	protected CallableStatement call;
	private static String str_27="27";

	// Initialise la variable config à pointer sur le fichier properties sql

	private static Log logJdbc = ServiceManager.getInstance().getLogManager()
			.getLogJdbc();

	/**
	 * Constructor for JDBCUpdaterOracle.
	 */
	public JDBCUpdaterOracle() {
		super();
	}

	/**
	 * Cette fonction permet de transformer un objet String en un objet CLOB
	 * (objet Oracle)
	 * 
	 * @param chaine : la chaine de caracteres a transformer
	 * @param conn : la connexion a la base de donnees Oracle
	 * @return Clob : l'objet oracle correspondant a l'objet String
	 * @throws SQLException sqlex
	 * @throws IOException ioex
	 * @throws BaseException 
	 */
	public Clob stringToClob(final String chaine)
			throws SQLException, IOException, BaseException
	{
		CLOB tempclob = null;

		tempclob = CLOB.createTemporary(getConnection(), true, CLOB.DURATION_SESSION);
		tempclob.open(CLOB.MODE_READWRITE); // mode d'ouverture
		final Writer tempClobWriter = tempclob.getCharacterOutputStream();
		tempClobWriter.write(chaine);
		tempClobWriter.flush();
		tempClobWriter.close();
		tempclob.close();

		return tempclob;
	}
	// public Connection getJdbcConnection() throws BaseException { return
	// getConnection(); }

	public int callProcStoc(String sql, Vector vParamIn, Vector vParamOut,
			boolean retourne) throws BaseException {
		int res = 0;
		int index;
		int f;
		String type;
		ParametreProc paramIn;
		ParametreProc paramOut;
		Object oParamIn;
		

		
		logJdbc.info(sql);

		try {
			beforeExecute();
			if (retourne) {
				call = getConnection().prepareCall("{call " + sql + "}");
				f = 1;
			} else {
				call = getConnection().prepareCall("{call " + sql + "}");
				f = 0;
			}

			// On traite les paramètres IN stockés dans un Vector
			// On parcourt le vector pour alimenter la procédure
			for (Enumeration e = vParamIn.elements(); e.hasMoreElements();) {
				// On récupère les propriétés de l'objet ParametreIN
				paramIn = (ParametreProc) e.nextElement();
				index = new Integer(paramIn.getPosition()).intValue();
				type = paramIn.getType();
				int iType = new Integer(type).intValue();

				oParamIn = paramIn.getValeur();

				if (oParamIn == null
						&& (paramIn.getNom().equals("ident") || paramIn
								.getNom().equals("userid"))) {
					logJdbc.debug("!!! null value for: <" + paramIn.getNom()
							+ "> : pas besion d'aller dans la base");
					return -1;
				}
				if (oParamIn != null) {
					logJdbc.debug("" + iType);
					if (type.equals("1")) { // varchar2
						call.setString(index + f, (String) oParamIn);
						logJdbc.debug("call.setString " + index + f + ":"
								+ oParamIn);

					} else if (type.equals("96")) { // char
						call.setString(index + f, (String) oParamIn);
						logJdbc.debug("call.setString " + index + f + ":"
								+ oParamIn);

					} else if (type.equals("2")) { // number
						// call.setInt(index + f, ((Integer)
						// oParamIn).intValue());
						call.setInt(index + f, (new Integer((String) oParamIn))
								.intValue());

					} else if (type.equals("8")) { // long
						call.setLong(index + f, ((Long) oParamIn).longValue());

					} 
					//Type Array - BIP 335
					else if (type.equals(str_27)) { // long
						call.setArray(index + f, (Array)oParamIn);  
					}	
					else if (type.equals("12")) { // date
						call.setTimestamp(index + f, new java.sql.Timestamp(
								((java.util.Date) oParamIn).getTime()));

					} else if (iType == Types.CLOB) { // CLOB
						logJdbc.debug("CLOB : call.setCharacterStream " + index
								+ f + ":" + oParamIn);
						String str = (String) oParamIn;
						call.setCharacterStream(index + f,
								new StringReader(str), str.length());

					} else if (iType == 2007) { // CLOB nouveau
						logJdbc.debug("CLOB : call.setClob ");
						String str = (String) oParamIn;
						call.setClob(index + f,
								stringToClob(str));
						
					} else if (iType == Types.BOOLEAN) { // Boolean
						call.setBoolean(index + f, ((Boolean) oParamIn).booleanValue());
						logJdbc.debug("call.setBoolean " + index + f + ":"
								+ ((Boolean) oParamIn).booleanValue());
						
					} else if (iType == Types.LONGVARCHAR) { // LONG VARCHAR
						logJdbc.debug("LONGVARCHAR : call.setCharacterStream "
								+ index + f);// + ":" + oParamIn);
						// String str = ((String)oParamIn).substring(0,32000);
						String str = (String) oParamIn;
						// call.setCharacterStream(index+f, new
						// StringReader(str), str.length());
						call.setObject(index + f, str, Types.LONGVARCHAR, 0);
					} else { // cas
						// La classe d'un des paramètres n'est pas traitée ici
						logJdbc
								.debug(" La classe d'un des paramètres n'est pas traitée ici "
										+ index + "(" + iType + ")");
						throw new BaseException(BaseException.BASE_PARAM_PROC);
					}
				} else {
					call.setNull(index + f, Types.VARCHAR);
					logJdbc.debug("call.setNull for : " + paramIn.getNom());
				}
			}

			
			
			// On traite les paramètres OUT stockés dans un Vector
			// On parcourt le Vector pour enregistrer les types des paramètres
			// OUT
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				// On récupère les propriétés de l'objet ParametreOut
				paramOut = (ParametreProc) e.nextElement();
				index = new Integer(paramOut.getPosition()).intValue();

				type = paramOut.getType();
				int iType = new Integer(type).intValue();

				if (type.equals("1")) { // varchar2
					call.registerOutParameter(index + f, Types.VARCHAR);
					logJdbc.debug("Types.VARCHAR :" + index);
				} else if (type.equals("96")) { // char
					call.registerOutParameter(index + f, Types.CHAR);
					logJdbc.debug("Types.CHAR :" + index);
				} else if (iType == Types.NUMERIC) { // number
					call.registerOutParameter(index + f, Types.INTEGER);
					logJdbc.debug("Types.NUMERIC :" + index);
				} else if (iType == Types.DOUBLE) { // long
					call.registerOutParameter(index + f, Types.DOUBLE);
				} else if (type.equals("12")) { // date
					call.registerOutParameter(index + f, Types.DATE);
				} else if (type.equals("102")) { // ref cursor
					call.registerOutParameter(index + f, OracleTypes.CURSOR);
					logJdbc.debug(" OracleTypes.CURSOR :" + index);
				}//Type Array Out - BIP 335
				else if (type.equals(str_27)){
					call.registerOutParameter(index + f,OracleTypes.ARRAY,"ARRAY_TABLE");
					logJdbc.debug(" OracleTypes.ARRAY :" + index);
				} 			
				else if (iType == Types.LONGVARCHAR) { // -1
					call.registerOutParameter(index + f, Types.LONGVARCHAR);
					logJdbc.debug(" Types.LONGVARCHAR:" + index);
				} else if (iType == Types.CLOB) { // 2005
					call.registerOutParameter(index + f, Types.CLOB);
					logJdbc.debug(" Types.CLOB :" + index);
				} else if (iType == 2007) { // CLOB nouveau
					call.registerOutParameter(index + f, 2007);
					logJdbc.debug(" Types.CLOB :" + index);
				} else if (iType == Types.BOOLEAN) { // 16
					call.registerOutParameter(index + f, Types.BOOLEAN);
					logJdbc.debug(" Types.BOOLEAN :" + index);
				} else { // cas
					// La classe d'un des paramètres n'est pas traitée ici
					logJdbc
							.debug(" La classe d'un des paramètres in n'est pas traitée ici "
									+ index + "(" + iType + ")");
					throw new BaseException(BaseException.BASE_PARAM_PROC,
							new Exception("Type de paramètre d'entrée inconu"));
				}
			}
			logJdbc.debug(" call.executeQuery():");
			long start = System.currentTimeMillis();
			call.executeQuery();
			long end = System.currentTimeMillis();
			logJdbc.debug(" fin call.executeQuery()");
			logJdbc.debug(" time executed : " + (end - start) + " ms");

			// On remplit la hashtable qui contient les valeurs des paramètres
			// OUT
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();
				index = new Integer(paramOut.getPosition()).intValue();

				type = paramOut.getType();
				int iType = new Integer(type).intValue();

				if (type.equals("1")) { // varchar2
					paramOut.setValeur((String) call.getString(index + f));
				} else if (type.equals("96")) { // char
					paramOut.setValeur((String) call.getString(index + f));
				} else if (iType == Types.NUMERIC) { // number
					paramOut.setValeur(new Integer(call.getInt(index + f)));
				} else if (iType == Types.DOUBLE) { // long
					paramOut.setValeur(new Long(call.getLong(index + f)));
				} else if (type.equals("12")) { // date
					paramOut.setValeur(call.getDate(index + f));
				} else if (iType == 102) { // ref cursor
					paramOut.setValeur((ResultSet) call.getObject(index + f));
				}	//BIP 335 User story
				else if (type.equals(str_27)){
					//call.registerOutParameter(index + f,OracleTypes.ARRAY,"ARRAY_TABLE");
					paramOut.setValeur(call.getArray(index + f));
					logJdbc.debug(" OracleTypes.ARRAY :" + index);
				} 
				else if (iType == Types.LONGVARCHAR) { // long varchar
					paramOut.setValeur((ResultSet) call.getObject(index + f));
				} else if (iType == Types.CLOB) { // clob
					Object o = call.getObject(index + f);
					paramOut.setValeur((Clob)(o));
				} else if (iType == Types.BLOB) { // blob
					Object o = call.getObject(index + f);
					paramOut.setValeur((Blob)(o));
				} else if (iType == Types.BOOLEAN) { // BOOLEAN
					paramOut.setValeur(new Boolean(call.getBoolean(index + f)));
				
				} else { // cas
					// La classe d'un des paramètres n'est pas traitée ici
					logJdbc
							.debug(" La classe d'un des paramètres out n'est pas traitée ici "
									+ index + "(" + iType + ")");

					throw new BaseException(
							BaseException.BASE_PARAM_PROC,
							new Exception("Type de paramètre de sortie inconnu"));
				}
			}

			// Récupération de la valeur de retour
			if (retourne) {
				res = call.getInt(1);
			}

		} catch (BaseException be) {
			logJdbc.error("callProcStock() -->" + be.getMessage());
			throw be;
		} catch (Exception e) {
			// si erreur défini par programmation on loggue seulement au niveau
			// DEBUG
			if (e.getMessage().startsWith("ORA-20997"))
				logJdbc.debug(e.getMessage());
			else
				// sinon au niveau ERROR;
				logJdbc.error(e.getMessage());
			throw new BaseException(BaseException.BASE_ERR_PROC, e);
		}
		logJdbc.exit("callProcStock");

		return res;
	}

	/**
	 * Retourne la liste des centres activites fils et et pere si le niveau est <>
	 * O;
	 * 
	 * @param cle
	 *            codcamo du pere
	 * @param vueliste
	 *            liset des centres d'activites a retourner.
	 */
	public void recupererListeGlobaleCentreActivite(String cle,
			ArrayList vueliste) {
		if (vueliste == null) {
			vueliste = new ArrayList();
		}
		// niveau supérieur du père dans la hierarchie den centres.
		String niveau_pere = null;
		String codcamo = null;
		try {
			CentreActivite ca = null;
			call = getConnection()
					.prepareCall(
							"{ call PACK_SUIVI_INVESTISSEMENT.LISTE_GLOBALE_CA (?, ?, ?, ?) }");

			// Déclaration des neuf paramètres
			// call.setInt(1, Integer.parseInt(cle));
			call.setString(1, cle);
			call.registerOutParameter(2, OracleTypes.CURSOR);
			call.registerOutParameter(3, OracleTypes.VARCHAR);
			call.registerOutParameter(4, OracleTypes.VARCHAR);
			call.executeQuery();

			niveau_pere = (String) call.getString(3);
			ResultSet rs = (ResultSet) call.getObject(2);
			while (rs.next()) {
				ca = new CentreActivite();
				codcamo = rs.getString(1);
				ca.setCodcamo(codcamo);
				ca.setLibelleLong(codcamo + " - " + rs.getString(2));
				ca.setCodnivca(rs.getString(3));
				ca.setCodnivcaPere(niveau_pere);
				vueliste.add(ca);
			}
			if (rs != null)
				rs.close();
			if (call != null)
				call.close();

		} catch (BaseException e) {
			new BaseException(BaseException.BASE_FACT_WRAP, e);
		} catch (SQLException e) {
			new BaseException(BaseException.BASE_FACT_WRAP, e);
		}

	}// recupererListeGlobaleCentreActivite

	/**
	 * Retourne la liste des centres activites de niveau O
	 * 
	 * @param cle
	 *            codcamo du pere
	 * @param vueliste
	 *            liset des centres d'activites a retourner.
	 */
	public void recupererListeNiv0CentreActivite(String cle, ArrayList vueliste) {
		if (vueliste == null) {
			vueliste = new ArrayList();
		}
		String codcamo = null;
		try {
			CentreActivite ca = null;
			call = getConnection()
					.prepareCall(
							"{ call PACK_SUIVI_INVESTISSEMENT.LISTE_NIVEAU0_CA(?, ?, ?) }");

			// Déclaration des neuf paramètres
			call.setInt(1, Integer.parseInt(cle));
			call.registerOutParameter(2, OracleTypes.CURSOR);
			call.registerOutParameter(3, OracleTypes.VARCHAR);
			call.executeQuery();
			ResultSet rs = (ResultSet) call.getObject(2);
			while (rs.next()) {
				ca = new CentreActivite();
				codcamo = rs.getString(1);
				ca.setCodcamo(codcamo);
				ca.setLibelleLong(codcamo + " - " + rs.getString(2));
				ca.setCodnivca("0");
				ca.setCodnivcaPere(cle);
				vueliste.add(ca);
			}
			if (rs != null)
				rs.close();
			if (call != null)
				call.close();

		} catch (BaseException e) {
			new BaseException(BaseException.BASE_FACT_WRAP, e);
		} catch (SQLException e) {
			new BaseException(BaseException.BASE_FACT_WRAP, e);
		}

	} // recupererListeNiv0CentreActivite

	public void alimCLOB(String sTable, String sChampAUpdater, String sClause,
			Vector vLignes2Update) throws BaseException {
		Connection conn;
		String sSQL = null;
		Statement stmt = null;
		ResultSet rset = null;
		Writer wClob = null;
		Clob clob = null;

		try {
			conn = getConnection();
			conn.setAutoCommit(false);

			stmt = conn.createStatement();
			sSQL = "SELECT " + sChampAUpdater + " FROM " + sTable + " where "
					+ sClause + " FOR UPDATE";
			// System.out.println(sSQL);
			logJdbc.debug("SQL : " + sSQL);
			rset = stmt.executeQuery(sSQL);
			rset.next();
 			clob = (Clob) (rset.getObject(1));
			wClob = clob.setCharacterStream(1);

			for (int i = 0; i < vLignes2Update.size(); i++)
				wClob.write((String) vLignes2Update.elementAt(i) + "\n");

			wClob.flush();
			wClob.close();

			conn.commit();
			if (rset != null)
				rset.close();
		} catch (BaseException be) {
			logJdbc.debug("callProcStock() -->" + be.getMessage());
			throw be;
		} catch (Exception e) {
			logJdbc.debug(e.getMessage() + " : " + sSQL);
			throw new BaseException(BaseException.BASE_EXEC_SQL, e);
		}
	}

	public void alimBLOB(String sTable, String sChampAUpdater, String sClause,
			InputStream data) throws BaseException {
		String sSQL;
		Connection conn;
		Statement stmt = null;
		ResultSet rset = null;
		Blob blob;
		OutputStream oSBlob = null;

		try {
			conn = getConnection();
			conn.setAutoCommit(false);
		
			
			sSQL = "SELECT " + sChampAUpdater + " FROM " + sTable + " where "
			+ sClause + " FOR UPDATE";
			stmt = conn.createStatement();
			
			// System.out.println(sSQL);
			logJdbc.debug("SQL : " + sSQL);

			rset = stmt.executeQuery(sSQL);
			rset.next();
			blob =(Blob)rset.getObject(1);
		
			oSBlob = blob.setBinaryStream(1);
		

			byte[] buffer = new byte[8192];
			byte[] bufferVide = new byte[(int)blob.length()];

			oSBlob.write(bufferVide, 0, 0);
			int bytesRead = 0;

			while ((bytesRead = data.read(buffer, 0, 8192)) != -1) {
				oSBlob.write(buffer, 0, bytesRead);
			}

			oSBlob.flush();
			oSBlob.close();

			conn.commit();
			if (rset != null)
				rset.close();
		} catch (BaseException be) {
			logJdbc.debug("callProcStock() -->" + be.getMessage());
			throw be;
		} catch (Exception e) {
			logJdbc.debug(e.getMessage());
			throw new BaseException(BaseException.BASE_EXEC_SQL, e);
		}
	}
}