package com.socgen.bip.util;



import org.apache.commons.lang.StringUtils;

public class BipNumberUtil {

	public static boolean isNumeric(String str) {
		
		return StringUtils.isNumericSpace(str)	;
	}


	public static String getPoint(double dbl ) throws NumberFormatException {
		return BipStringUtil.replaceFirst(String.valueOf(dbl), ".", ",");
	}
	public static String setPoint(String dbl ) throws NumberFormatException {
		return BipStringUtil.replaceFirst(dbl, ",", ".");
	}
		
	public static String addLeftZeroToNumber(String str, int longueur)
	{
		return StringUtils.leftPad(str,longueur, "0");
	}
}
