package com.socgen.bip.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.commons.lang.StringUtils;

public class BipDateUtil {
	
	/**
	 * <p>Titre : dateToString</p>
	 * <p>Description : fonction qui convertit une chaîne de caractère
	 * au format DD/mm/yyyy ou mm/DD/yyyy en date</p>
	 * @param dateStr
	 * @param myResources
	 * @return Date
	 * @throws ParseException
	 */
	public static String dateToString(Date date, String format) {
		SimpleDateFormat df = new SimpleDateFormat(format);
		
		if (date != null) {
			return df.format(date);
		} else {
			return "";
		}
	}
	
	public static Date parseDate(String date, String format) throws ParseException {
		SimpleDateFormat df = new SimpleDateFormat(format);
		if ((date != null)&&(!(StringUtils.containsOnly(date.trim(),"0")))) {
			return df.parse(date.trim());
		} else {
			return null;
		}
	}
	/**
	 * <p>Titre : stringToDate</p>
	 * <p>Description : fonction qui convertit une chaîne de caractère
	 * au format DD/mm/yyyy ou mm/DD/yyyy en date</p>
	 * @param dateStr
	 * @param myResources
	 * @return Date
	 * @throws ParseException
	 */
	public static Date stringToDate(String dateStr, String format)
		throws ParseException {
		SimpleDateFormat df = new SimpleDateFormat(format);

		if (dateStr != null && dateStr.length() > 0) {
			return df.parse(dateStr.trim());
		} else {
			return null;
		}
	}
	/**
	 * <p>Méthode: conversionFormat
	 * <br>Méthode qui convertit une date d'une format à une autre</p>
	 * @author DJF
	 * @param String oldDate
	 * @param Locale oldLocale
	 * @param Locale newLocale
	 * @return String
	 * @since 
	 */
	public static String conversionFormat(String oldDate, String oldFormat, String newFormat)
	{	
		try {

			Date date = stringToDate(oldDate.trim(), oldFormat);
			return dateToString(date, newFormat);
		} catch (Exception e) {
			return "";
		}
	}

}
