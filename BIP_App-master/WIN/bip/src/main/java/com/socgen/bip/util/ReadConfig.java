package com.socgen.bip.util;

import java.io.FileInputStream;
import java.io.InputStream;
import java.util.Properties;
import java.util.ResourceBundle;

import com.socgen.bip.commun.action.BipAction;

public class ReadConfig {

	private static Properties configFile;
	String fileName;

	/**
	 * Permet de récupérer les valeurs type étape - Utilisé dans le traitement : Remontée BIP UNIX ReadConf() Permet de lire les fichiers de configuration qui sont à l'extérieur de
	 * RBip.jar
	 **/

	public ReadConfig(String NameConfig) {

		configFile = new java.util.Properties();

		try {

			fileName = "config/" + NameConfig + ".properties";
			InputStream is = new FileInputStream(fileName);
			configFile.load((is));

		} catch (Exception e) {
			BipAction.logBipUser.error("Error. Check the code", e);
		}

	}

	public String getProperty(String cle) {

		String value = ReadConfig.configFile.getProperty(cle);
		return value;

	}

	/**
	 * Permet de récupérer les valeurs type étape - Utilisé dans le traitement : Remontée BIP Intranet ReadPropFile() Permet de lire les fichiers de configuration qui sont à
	 * l'intérieur du Bip.war (Ex: WEB-INF/Classes/sql.properties)
	 **/

	public static String ReadPropFile(String cle, String NameConf) {

		ResourceBundle bundle = ResourceBundle.getBundle(NameConf);
		String procName = bundle.getString(cle);
		return procName;
	}
	


}
