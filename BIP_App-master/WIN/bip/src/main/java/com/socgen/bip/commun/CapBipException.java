package com.socgen.bip.commun;

/**
 * Exception de base pour toutes les exceptions de l'application.
 * @author user
 */
public class CapBipException extends Exception
{
//	/**
//	 * L'origine du problème.
//	 */
//	private Throwable cause ;

	/**
	 * Construit une nouvelle exception.
	 */
	public CapBipException()
	{
		super() ;
	}

	/**
	 * Construit une nouvelle exception.
	 * @param message le message d'erreur
	 */
	public CapBipException(String message)
	{
		super(message) ;
	}

	/**
	 * Construit une nouvelle exception.
	 * @param cause l'origine du problème
	 */
	public CapBipException(Throwable cause)
	{
		super(cause) ;		
	}

	/**
	 * Construit une nouvelle exception.
	 * @param message le message d'erreur
	 * @param cause l'origine du problème
	 */
	public CapBipException(String message, Throwable cause)
	{
		super(message, cause) ;		
	}




}
