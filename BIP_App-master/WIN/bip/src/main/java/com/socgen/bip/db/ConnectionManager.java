package com.socgen.bip.db;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Types;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import com.socgen.bip.util.BipCrypto;
import com.socgen.cap.fwk.ServiceManager;
import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * G�re l'acc�s aux pool de connexions. Cette classe ne poss�de qu'une seule
 * instance effectuant les acc�s aux sources de donn�es du serveur.. PATTERN :
 * Singleton
 * 
 * @author RSRH/ICH/CAP
 */
public class ConnectionManager {
	/**
	 * L'instance unique de la classe.
	 */
	private static ConnectionManager instance;

	private MiniConnectionPoolManager poolManager;

	private DataSource jndiDatasource;

	/**
	 * Construit une nouvelle instance.
	 * 
	 * @throws BaseException
	 */
	private ConnectionManager() throws BaseException {
		super();
		try {
			if ("UNIX".equals(RBip_Jdbc.TOP)) {
				oracle.jdbc.pool.OracleConnectionPoolDataSource dataSource = new oracle.jdbc.pool.OracleConnectionPoolDataSource();
				dataSource.setURL(RBip_Jdbc.DB_URL);
				dataSource.setUser(RBip_Jdbc.DB_USER);
				dataSource.setPassword(BipCrypto.decrypter(RBip_Jdbc.DB_PASS));

				poolManager = new MiniConnectionPoolManager(dataSource, 5);
			} else {
				// Acc�s au fichier de propri�t�s
				Config configTech = ServiceManager.getInstance()
						.getConfigManager().getTechServer();

				// D�finition du nom de la source de donn�es
				String dataSourcePrefix = configTech
						.getString("JDBCWrapper.jndi.datasourceprefix");
				String dataSourceName = configTech
						.getString("JDBCWrapper.jdbc.datasource");

				// Nom du pool
				String poolName = dataSourcePrefix + dataSourceName;

				// Cr�ation du contexte de recherche JNDI
				Context ctx = new InitialContext();

				// R�cup�ration de la source de donn�es
				jndiDatasource = (DataSource) ctx.lookup(poolName);
			}
		} catch (SQLException e) {

			if ("UNIX".equals(RBip_Jdbc.TOP)) {
				throw new BaseException(BaseException.BASE_GET_CONN, e);
			} else {
				throw new BaseException(BaseException.BASE_CTX_JNDI, e);
			}
		} catch (NamingException ne) {
			if ("UNIX".equals(RBip_Jdbc.TOP)) {
				throw new BaseException(BaseException.BASE_GET_CONN, ne);
			} else {
				throw new BaseException(BaseException.BASE_CTX_JNDI, ne);
			}
		}
	}

	/**
	 * Renvoie l'instance unique de la classe ConnectionManager. Pattern :
	 * Singleton
	 * 
	 * @return l'instance unique de la classe ConnectionManager
	 * @throws BaseException
	 */
	public static ConnectionManager getInstance() throws BaseException {
		if (instance == null) {
			synchronized (ConnectionManager.class) {
				if (instance == null) {
					instance = new ConnectionManager();
				}
			}
		}

		return instance;
	}

	/**
	 * Cr�e une nouvelle connexion � la base.
	 * 
	 * @return la connexion cr��e.
	 * @throws ClassNotFoundException
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws SQLException
	 */
	public Connection getConnection() throws BaseException,
			ClassNotFoundException, InstantiationException,
			IllegalAccessException, SQLException {
		Connection conn = null;

		if ("UNIX".equals(RBip_Jdbc.TOP)) {

			conn = poolManager.getConnection();

		} else {

			conn = jndiDatasource.getConnection();
		}

		return conn;

	}

}
