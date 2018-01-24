package com.socgen.bip.commun;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Vector;

import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.config.ConfigManager;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * 
 * @author X054232
 */
public class BipStatistiquePage implements BipConstantes {

	private static BipStatistiquePage instance = null;

	private Hashtable hLibelle;

	private Hashtable hTrace;

	private Hashtable hTraceAction;

	private static String PACK_SELECT = "statpage.consulter.proc";
	
	

	public BipStatistiquePage() {
		hLibelle = new Hashtable();
		hTrace = new Hashtable();
		hTraceAction = new Hashtable();
		loadTable();
	}

	public static void init() {
		instance = new BipStatistiquePage();
	}

	public static BipStatistiquePage getInstance() {
		return instance;
	}

	public void loadTable() {
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;
		Hashtable hParamProc = new Hashtable();
		// Initialise la variable config à pointer sur le fichier properties sql
		Config configProc = ConfigManager.getInstance(BipConstantes.BIP_PROC);
		
		JdbcBip jdbc = new JdbcBip(); 
		
		// exécution de la procédure PL/SQL
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT);
			// Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();
				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();
					try {
						logService.error(this.getClass().getName()
								+ "  --> TRACE DAVID BIPSTAT :"
								+ (String) rset.getStatement().getConnection()
										.toString());
					} catch (SQLException sqle) {
						logService.error(this.getClass().getName()
								+ " ERREUR TRACE DAVID BIPSTAT 2 ");
					}
					try {
						while (rset.next()) {
							// On alimente le Bean et on stocke lezs données
							// dans un vector
							hLibelle.put(new Integer(rset.getInt(1)), rset
									.getString(2));
							hTrace.put(new Integer(rset.getInt(1)), rset
									.getString(3));
							hTraceAction.put(new Integer(rset.getInt(1)), rset
									.getString(4));
						}
						if (rset != null)
							rset.close();

					} // try
					catch (SQLException sqle) {
						logService.error(this.getClass().getName()
								+ ".loadTable() --> SQLException :" + sqle);
					}
				} // if
			} // for
		} // try
		catch (BaseException be) {
			logService.error(this.getClass().getName()
					+ ".loadTable() --> BaseException :" + be);
			logService.error(this.getClass().getName()
					+ ".loadTable() --> Exception :"
					+ be.getInitialException().getMessage());
		} finally {
			jdbc.closeJDBC();
			logService.debug(this.getClass().getName()
					+ "-LoadTable-Close Connection.");
		}// finally
	}

	public static String getFlagTrace(String id) {
		String flag = "N";

		try {
			flag = (String) getInstance().getHTrace().get(new Integer(id));
		} catch (Exception e) {
			flag = "N";
		}

		return flag;
	}

	/**
	 * @return
	 */
	public Hashtable getHLibelle() {
		return hLibelle;
	}

	public String getHLibelle(Integer id) {
		return (String) getHLibelle().get(id);
	}

	/**
	 * @return
	 */
	public Hashtable getHTrace() {
		return hTrace;
	}

	public String getHTrace(Integer id) {
		return (String) getHTrace().get(id);
	}

	/**
	 * @return
	 */
	public Hashtable getHTraceAction() {
		return hTraceAction;
	}

	public String getHTraceAction(Integer id) {
		return (String) getHTraceAction().get(id);
	}

}
