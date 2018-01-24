package com.socgen.bip.util;

import java.util.ResourceBundle;

import org.apache.commons.lang.StringUtils;

public class PropertiesResourceImpl implements PropertiesResource {

	private ResourceBundle bundle;
	private String filenameWithoutExtention;

	public PropertiesResourceImpl(String filenameWithoutExtention) {
		this.filenameWithoutExtention = filenameWithoutExtention;
		bundle = ResourceBundle.getBundle(filenameWithoutExtention);
	}

	@Override
	public String getValueOrThrowException(String key) {
		String value = bundle.getString(key);
		if (StringUtils.isEmpty(key)) {
			throw new IllegalArgumentException("The key " + key + " is not referenced is the resource bundle " + filenameWithoutExtention);
		}
		return value;

	}

}
