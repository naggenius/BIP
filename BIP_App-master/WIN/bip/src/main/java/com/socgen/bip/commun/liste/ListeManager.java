package com.socgen.bip.commun.liste;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.StringTokenizer;
import java.util.Vector;

import com.socgen.bip.commun.action.BipAction;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.form.ConsulModifyForm;
import com.socgen.cap.fwk.ServiceManager;
import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.cap.fwk.jdbc.JDBCWrapper;
import com.socgen.cap.fwk.log.Log;

/**
 * @author user
 * 
 * Encapsule la gestion des listes
 * 
 */
public class ListeManager {
	// Initialise la variable config à pointer sur le fichier properties sql
	private static Config configSQL = ServiceManager.getInstance()
			.getConfigManager().getSQL();

	static Log logBipUser = BipAction.getLogBipUser();
	
	JdbcBip jdbc = new JdbcBip(); 

	/**
	 * Constructor for ListeManager.
	 */
	public ListeManager() {
		super();
	}

	/**
	 * Construit le tableau pour générer la liste statique
	 */
	public static ArrayList RecupererListeStatique(String chaine) {
		String cle;
		String libelle;
		StringTokenizer stko;
		String ligne;
		// On récupère les options de la liste
		StringTokenizer stk = new StringTokenizer(chaine, ";");
		ArrayList vueListe = new ArrayList();

		while (stk.hasMoreTokens()) {
			ligne = stk.nextToken();
			if (ligne.equals(":")) {
				cle = " ";
				libelle = " ";
			} else {
				stko = new StringTokenizer(ligne, ":");
				// récupérer la clé et le libellé de l'option
				cle = stko.nextToken();
				libelle = stko.nextToken();
			}
			vueListe.add(new ListeOption(cle, libelle));
		}
		return vueListe;
	}

	/**
	 * Construit le tableau pour générer la liste dynamique
	 */
	public ArrayList RecupererListeDynamique(String procPLSQL,
			Hashtable paramProc, Config configProc, String cleProc)
			throws BaseException {

		if (procPLSQL == null || procPLSQL.length() == 0 || paramProc == null
				|| configProc == null || cleProc == null
				|| cleProc.length() == 0) {
			logBipUser
					.debug("!!! l'un des parametres est null dans ListManager-RecupererListeDynamique() ");
			logBipUser
					.debug(" procPLSQL = " + procPLSQL + "; hParamKeyList = ["
							+ paramProc + "]" + "; configProc = " + configProc
							+ "; cleProc = " + cleProc);
		}

		ArrayList vueListe = new ArrayList();
		Vector vParamOut = new Vector();
		;
		String cle;
		String libelle;
		try {
			// Exécuter la procédure PL/SQL
			vParamOut = jdbc.getResult(
					paramProc, configProc, cleProc);

			if (vParamOut != null) {

				if(cleProc.equals("liste.resscopi")){
					vueListe = new ArrayList<Integer>();
					for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
						ParametreProc paramOut = (ParametreProc) e.nextElement();

						if (paramOut.getNom().equals("curseur")) {
							// Récupération du Ref Cursor
							ResultSet rset = (ResultSet) paramOut.getValeur();

							try {
								while (rset.next()) {

									cle = rset.getString(1);// cle
									
									
									vueListe.add(new ListeOption(cle,null));
								}
								if (rset != null)
									rset.close();
							}// try
							catch (Exception ex) {
								logBipUser.debug("Pb dans liste dynamique"
										+ ex.getMessage());
								throw new BaseException(BaseException.BASE_READ_RS,
										ex);
							}
						}// if
					} }else {
				
				// Récupération des résultats
				for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
					ParametreProc paramOut = (ParametreProc) e.nextElement();

					if (paramOut.getNom().equals("curseur")) {
						// Récupération du Ref Cursor
						ResultSet rset = (ResultSet) paramOut.getValeur();

						try {
							String str = "";
							while (rset.next()) {
								cle = rset.getString(1);// cle
								libelle = rset.getString(2);// libelle

								vueListe.add(new ListeOption(cle, libelle));
							}
							if (rset != null)
								rset.close();
						}
					// try
						catch (Exception ex) {
							logBipUser.debug("Pb dans liste dynamique"
									+ ex.getMessage());
							throw new BaseException(BaseException.BASE_READ_RS,
									ex);
						}
					}// if
				}}// for
			}// endif
		}// try
		catch (BaseException be) {
			logBipUser.debug("Pb PL-SQL dans liste dynamique : ", be);
			throw be;
		} finally {
			jdbc.closeJDBC();
		}
		return vueListe;
	}

	/**
	 * Construit le tableau pour générer la liste dynamique
	 */
	public ArrayList RecupererListeNiveauCentreActivite(String procPLSQL,
			Hashtable paramProc, Config configProc, String cleProc)
			throws BaseException {
		ArrayList vueListe = new ArrayList();
		Vector vParamOut = new Vector();
		;
		String cle;
		String libelle;
		try {
			// Exécuter la procédure PL/SQL
			vParamOut = jdbc.getResult(
					paramProc, configProc, cleProc);
			// Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				ParametreProc paramOut = (ParametreProc) e.nextElement();

				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();

					try {
						String str = "";
						if (rset.next()) {
							cle = rset.getString(1);// cle
							libelle = rset.getString(2);// libelle

							vueListe.add(new ListeOption(cle, libelle));
						}
						if (rset != null)
							rset.close();
					}// try
					catch (Exception ex) {
						throw new BaseException(BaseException.BASE_READ_RS, ex);
					}

				}// if
			}// for

		}// try
		catch (BaseException be) {
			throw new BaseException(BaseException.BASE_ERR_PROC, be);
		} finally {
			jdbc.closeJDBC();
		}
		return vueListe;
	}// RecupererListeNiveauCentreActivite

	/**
	 * Construit le tableau pour générer la liste globale dynamique
	 */
	public static ArrayList RecupererListeGlobale(String nomTable)
			throws BaseException {
		ArrayList vueListe = new ArrayList();
		String cle;
		String libelle;
		String requete;
		try {
			JDBCWrapper jdbcWrapper = ServiceManager.getInstance()
					.getJdbcManager().getWriter();
			// Construction de la requête
			requete = configSQL.getString("SQL.liste.globale.select") + " "
					+ nomTable + " "
					+ configSQL.getString("SQL.liste.globale.orderBy");

			try {
				// Exécution de la requête
				jdbcWrapper.execute(requete);

				while (jdbcWrapper.next()) {
					cle = jdbcWrapper.getString(1);
					libelle = cle + " " + jdbcWrapper.getString(2);

					vueListe.add(new ListeOption(cle, libelle));
				}

			} catch (BaseException be) {
				throw new BaseException(BaseException.BASE_EXEC_SQL, be);
			} finally {
				// fermeture de la connexion
				jdbcWrapper.close();
			}

		} catch (BaseException e) {
			throw new BaseException(BaseException.BASE_FACT_WRAP, e);
		}

		return vueListe;
	}// RecupererListeGlobale

	/**
	 * 
	 * @param cle
	 * @param list
	 * @return
	 */
	public static String recupereOption(String cle, ArrayList list) {
		if (list == null || list.size() == 0) {
			return null;
		}
		String libelle = null;
		ListeOption option = null;
		for (int i = 0; i < list.size(); i++) {
			option = (ListeOption) list.get(i);
			if (option != null && cle.equals(option.getCle())) {
				libelle = option.getLibelle();
				break;
			}
		}
		return libelle;
	}
}
