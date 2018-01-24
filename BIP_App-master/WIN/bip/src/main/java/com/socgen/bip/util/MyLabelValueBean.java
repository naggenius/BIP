package com.socgen.bip.util;

import org.apache.struts.util.LabelValueBean;

/**
 * 
 * @author X060314
 * JAL 14/04/2008 
 */
public  class MyLabelValueBean {
	
	public static LabelValueBean getLabelValueBean(String label,String value){
		return new LabelValueBean(label,value); 
	}
	
	

}
