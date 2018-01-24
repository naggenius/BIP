package com.socgen.bip.extension;

import com.socgen.cap.fwk.config.Config;

/**
 * DHA Wrapper class of the cap fwk in order to add new methods
 *
 */
public class MyConfig {

	private Config config;

	public MyConfig(Config config) {
		this.config = config;
	}

	public boolean getBoolean(String cle) {
		return config.getBoolean(cle);
	}

	/**
	 * to prevent the show*** properties that logs too much
	 * 
	 * @param cle
	 * @return
	 */
	public boolean getBooleanOrDefaultValue(String cle, boolean defaultValue) {
		String value = getStringOrNull(cle);
		if (value != null && !value.trim().equals("")) {
			return Boolean.valueOf(value);
		}
		return defaultValue;
	}

	public int getInt(String cle) {
		return config.getInt(cle);
	}

	public String getString(String cle) {
		return config.getString(cle);
	}

	public String getObject(String cle) {
		Object object = config.getConfig().getObject(cle);
		if (object != null) {
			return object.toString();
		}
		return null;
	}

	private String getStringOrNull(String cle) {
		try {
			return config.getConfig().getString(cle);			
		} catch (Exception e) {
			return null;
		}
	}
}
