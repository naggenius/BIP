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
	 * Permet de r�cup�rer les valeurs type �tape - Utilis� dans le traitement : Remont�e BIP UNIX ReadConf() Permet de lire les fichiers de configuration qui sont � l'ext�rieur de
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
	 * Permet de r�cup�rer les valeurs type �tape - Utilis� dans le traitement : Remont�e BIP Intranet ReadPropFile() Permet de lire les fichiers de configuration qui sont �
	 * l'int�rieur du Bip.war (Ex: WEB-INF/Classes/sql.properties)
	 **/

	public static String ReadPropFile(String cle, String NameConf) {

		ResourceBundle bundle = ResourceBundle.getBundle(NameConf);
		String procName = bundle.getString(cle);
		return procName;
	}
	


}
