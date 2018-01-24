package com.socgen.bip.listener;

import java.text.SimpleDateFormat;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Properties;
import java.util.Vector;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import com.socgen.bip.commun.BipConfigRTFE;
import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.BipStatistiquePage;
import com.socgen.bip.commun.Tools;
import com.socgen.bip.commun.action.BipAction;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.menu.BipMenuManager;
import com.socgen.bip.menu.MenuException;
import com.socgen.bip.rbip.intra.RBipFichier;
import com.socgen.cap.fwk.ServiceManager;
import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.config.ConfigManager;
import com.socgen.cap.fwk.exception.BaseException;

public class MyServletContextListener implements ServletContextListener {

	private static final String PACK_SELECT = "parametre.consulter_val.proc";
	private static String PROC_UPDATE_STATUT = "remontee.update_statut";


	@Override
	public void contextDestroyed(ServletContextEvent event) {
		BipAction.logBipUser.info("application stopped. event=" + event);
	}

	@Override
	public void contextInitialized(ServletContextEvent event) {
		ServletContext servletContext = event.getServletContext();

		// Initialisation du ServiceManager du Framework (Etape obligatoire une fois pour toute application)
		ServiceManager.getInstance().init(this);
		
		BipAction.logBipUser.info("application started. event=" + event);

		// premier passage, on initialise l'environnement
		if (BipMenuManager.getInstance() == null) {
			ServiceManager.getInstance().getLogManager().getLogService().debug(this.getClass().getName() + ".init Début");
			try {
				BipMenuManager.init(servletContext);
			} catch (MenuException be) {
				ServiceManager.getInstance().getLogManager().getLogModele().error("Erreur lors du chargement des menus", be);
				ServiceManager.getInstance().getLogManager().getLogService().error("Erreur lors du chargement des menus", be);

				throw new RuntimeException("Erreur lors du chargement des menus", be);
			}

			Tools.logEnv();
			ServiceManager.getInstance().getLogManager().getLogService().debug(this.getClass().getName() + ".init() BipMenuManager termine avec succes");
		}

		Hashtable hParamProc = new Hashtable();

		JdbcBip jdbc = new JdbcBip();
		// On charge le flag de l'activité des statistiques dans le ServletContext
		String flag_stat_page = (String) servletContext.getAttribute(BipConstantes.STATISTIQUE_PAGE);

		if (flag_stat_page == null) {
			Vector vParamOut = new Vector();
			String message = "";
			boolean msg = false;
			ParametreProc paramOut;
			hParamProc = new Hashtable();
			hParamProc.put("cle_param", BipConstantes.STATISTIQUE_PAGE);
			String flag = "";
			// Initialise la variablefconfig à pointer sur le fichier properties sql
			Config configProc = ConfigManager.getInstance(BipConstantes.BIP_PROC);
			// exécution de la procédure PL/SQL
			try {
				vParamOut = jdbc.getResult(hParamProc, configProc, PACK_SELECT);
				// Récupération des résultats
				for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
					paramOut = (ParametreProc) e.nextElement();

					// récupérer le message
					if (paramOut.getNom().equals("message")) {
						message = (String) paramOut.getValeur();
					}
					// récupérer le message
					if (paramOut.getNom().equals("valeur_param"))
						flag = (String) paramOut.getValeur();

				} // for
				if (msg) {
					// le Paramètre n'existe pas, on récupère le message
					ServiceManager.getInstance().getLogManager().getLogService().debug(this.getClass().getName() + ".init() Stat :" + message);
				}
			} // try
			catch (BaseException be) {
				ServiceManager.getInstance().getLogManager().getLogService().debug(this.getClass().getName() + ".init() --> BaseException :" + be);
				ServiceManager.getInstance().getLogManager().getLogService().debug(this.getClass().getName() + ".init() --> Exception :" + be.getInitialException().getMessage());
			} finally {
				if ((flag == null) || (flag.equals("")))
					flag = "BLOQUEE";
				servletContext.setAttribute(BipConstantes.STATISTIQUE_PAGE, flag);
				ServiceManager.getInstance().getLogManager().getLogService()
						.debug(this.getClass().getName() + ".init() Flag statistiques pages : " + servletContext.getAttribute(BipConstantes.STATISTIQUE_PAGE));
			}
		}

		// On charge l'identifiant Weborama dans le ServletContext
		String id_webo = (String) servletContext.getAttribute(BipConstantes.ID_WEBORAMA);
		if (id_webo == null) {
			Vector vParamOut = new Vector();
			String message = "";
			boolean msg = false;
			ParametreProc paramOut;
			hParamProc = new Hashtable();
			hParamProc.put("cle_param", BipConstantes.ID_WEBORAMA);
			String flag = "";
			// Initialise la variable config à pointer sur le fichier properties sql
			Config configProc = ConfigManager.getInstance(BipConstantes.BIP_PROC);
			// exécution de la procédure PL/SQL
			try {
				vParamOut = jdbc.getResult(hParamProc, configProc, PACK_SELECT);
				// Récupération des résultats
				for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
					paramOut = (ParametreProc) e.nextElement();

					// récupérer le message
					if (paramOut.getNom().equals("message")) {
						message = (String) paramOut.getValeur();
					}
					// récupérer le message
					if (paramOut.getNom().equals("valeur_param"))
						flag = (String) paramOut.getValeur();

				} // for
				if (msg) {
					// le Paramètre n'existe pas, on récupère le message
					ServiceManager.getInstance().getLogManager().getLogService().debug(this.getClass().getName() + ".init() Stat :" + message);
				}
			} // try
			catch (BaseException be) {
				ServiceManager.getInstance().getLogManager().getLogService().debug(this.getClass().getName() + ".init() --> BaseException :" + be);
				ServiceManager.getInstance().getLogManager().getLogService().debug(this.getClass().getName() + ".init() --> Exception :" + be.getInitialException().getMessage());
			} finally {
				if ((flag == null) || (flag.equals("")))
					flag = "";
				servletContext.setAttribute(BipConstantes.ID_WEBORAMA, flag);
				ServiceManager.getInstance().getLogManager().getLogService()
						.debug(this.getClass().getName() + ".init() Identifiant Weborama : " + servletContext.getAttribute(BipConstantes.STATISTIQUE_PAGE));
			}
		}

		// On charge l'identifiant zone groupe Weborama dans le ServletContext
		String webo_zone_groupe = (String) servletContext.getAttribute(BipConstantes.WEBO_ZONE_GROUPE);
		if (webo_zone_groupe == null) {
			Vector vParamOut = new Vector();
			String message = "";
			boolean msg = false;
			ParametreProc paramOut;
			hParamProc = new Hashtable();
			hParamProc.put("cle_param", BipConstantes.WEBO_ZONE_GROUPE);
			String flag = "";
			// Initialise la variable config à pointer sur le fichier properties sql
			Config configProc = ConfigManager.getInstance(BipConstantes.BIP_PROC);
			// exécution de la procédure PL/SQL
			try {
				vParamOut = jdbc.getResult(hParamProc, configProc, PACK_SELECT);
				// Récupération des résultats
				for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
					paramOut = (ParametreProc) e.nextElement();

					// récupérer le message
					if (paramOut.getNom().equals("message")) {
						message = (String) paramOut.getValeur();
					}
					// récupérer le message
					if (paramOut.getNom().equals("valeur_param"))
						flag = (String) paramOut.getValeur();

				} // for
				if (msg) {
					// le Paramètre n'existe pas, on récupère le message
					ServiceManager.getInstance().getLogManager().getLogService().debug(this.getClass().getName() + ".init() Stat :" + message);
				}
			} // try
			catch (BaseException be) {
				ServiceManager.getInstance().getLogManager().getLogService().debug(this.getClass().getName() + ".init() --> BaseException :" + be);
				ServiceManager.getInstance().getLogManager().getLogService().debug(this.getClass().getName() + ".init() --> Exception :" + be.getInitialException().getMessage());
			} finally {

				if ((flag == null) || (flag.equals("")))
					flag = "";
				servletContext.setAttribute(BipConstantes.WEBO_ZONE_GROUPE, flag);
				ServiceManager.getInstance().getLogManager().getLogService()
						.debug(this.getClass().getName() + ".init() Zone Groupe Weborama : " + servletContext.getAttribute(BipConstantes.WEBO_ZONE_GROUPE));
			}
		}

		// On charge l'activation des statistiques sur les pages dans le ServletContext
		if (BipStatistiquePage.getInstance() == null) {
			ServiceManager.getInstance().getLogManager().getLogService().debug(this.getClass().getName() + ".init() Début statistique page");
			BipStatistiquePage.init();
			ServiceManager.getInstance().getLogManager().getLogService().debug(this.getClass().getName() + ".init() BipStatistiquePage termine avec succes");
		}

		// On charge en mémoire le paramétrage BIP du RTFE
		ServiceManager.getInstance().getLogManager().getLogService().debug(this.getClass().getName() + ".init() Début chargement paramétrage RTFE");
		BipConfigRTFE.getInstance();
		ServiceManager.getInstance().getLogManager().getLogService().debug(this.getClass().getName() + ".init() Chargement du paramétrage RTFE fini avec succès");

		// On garde en méméoire la date et l'heure du lancement du serveur
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy à HH:mm:ss");
		servletContext.setAttribute(BipConstantes.TIME_START_SERVER, sdf.format(new java.util.Date()));
		ServiceManager.getInstance().getLogManager().getLogService()
				.debug(this.getClass().getName() + ".init() Heure de démarrage du serveur : " + servletContext.getAttribute(BipConstantes.TIME_START_SERVER));

		// Uniquement pour le debug
		Properties p = System.getProperties();
		for (Enumeration vE = p.keys(); vE.hasMoreElements();) {
			String cle = (String) vE.nextElement();
			String value = (String) p.get(cle);
			ServiceManager.getInstance().getLogManager().getLogService().debug(this.getClass().getName() + ".init() System : " + cle + " : " + value);
		}

		jdbc.closeJDBC();
		// RBipManager.getInstance();
		setTraitementsBipsEnCoursToProblemesBloquants();

	}

	private void setTraitementsBipsEnCoursToProblemesBloquants() {
		JdbcBip jdbc = new JdbcBip();

		// tous les enregistrements en etat 0 passent en -1 (no_data => erreur)
		try {
			Vector vRes;
			Hashtable hParam = new Hashtable();

			hParam.put("statut_in", "" + RBipFichier.STATUT_NON_CONTROLE);
			hParam.put("statut_out", "" + RBipFichier.STATUT_ERREUR);
			hParam.put("statut_info", "");

			vRes = jdbc.getResult(hParam, RBipFichier.cfgProc, PROC_UPDATE_STATUT);
		} catch (BaseException bE) {
			BipAction.logBipUser.error("setTraitementsBipsEnCoursToProblemesBloquants() : probleme dans la mise a jour du statut des fichiers NO_DATA de la base", bE);
		}

	}

}
