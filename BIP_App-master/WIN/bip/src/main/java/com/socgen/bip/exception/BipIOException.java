package com.socgen.bip.exception;

import java.io.IOException;

public class BipIOException extends Exception {
	protected String msg=null;
	private String classe = null;
	private String exception = null;
	/**
	 * Construit une BipIOException à partir d'un message
	 * @param message Le message de l'exception
	 */
	public BipIOException(String message) {
		msg = message;
	}
	
	/**
	 * Construit une BipIOException à partir d'une exception et du nom de la classe qui appelle 
	 * ce constructeur
	 * @param nomClass Le nom de la classe appelant
	 * @param e L'exception à gérer
	 */
	public BipIOException(String nomClass, IOException e) {
		classe = nomClass;
		exception= e.getMessage();
	}
	
	/**
	 * Récupère le message de cette exception
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
