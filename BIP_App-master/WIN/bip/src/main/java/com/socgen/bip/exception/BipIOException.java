package com.socgen.bip.exception;

import java.io.IOException;

public class BipIOException extends Exception {
	protected String msg=null;
	private String classe = null;
	private String exception = null;
	/**
	 * Construit une BipIOException � partir d'un message
	 * @param message Le message de l'exception
	 */
	public BipIOException(String message) {
		msg = message;
	}
	
	/**
	 * Construit une BipIOException � partir d'une exception et du nom de la classe qui appelle 
	 * ce constructeur
	 * @param nomClass Le nom de la classe appelant
	 * @param e L'exception � g�rer
	 */
	public BipIOException(String nomClass, IOException e) {
		classe = nomClass;
		exception= e.getMessage();
	}
	
	/**
	 * R�cup�re le message de cette exception
	 */
	public String getMessage() {
		return msg;	
	}

	public String getClasse() {
		return classe;
	}


	public String getException() {
		return exception;
	}

}
