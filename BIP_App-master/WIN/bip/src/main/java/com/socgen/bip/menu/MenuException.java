package com.socgen.bip.menu;

import com.socgen.bip.commun.CapBipException;

/**
 * Cette classe définit une exception relative à la manipulation des menus de l'application.
 * Cette exception est principalement utilisée par l'instance unique de la classe MenuManager.
 * @author RSRH/ICH/CAP
 */
public class MenuException extends CapBipException
{

	/**
	 * Construit une nouvelle exception.
	 */
	public MenuException()
	{
		super();
	}

	/**
	 * Construit une nouvelle exception.
	 * @param message message indiquant la nature du problème.
	 */
	public MenuException(String message)
	{
		super(message);
	}

	/**
	 * Construit une nouvelle exception.
	 * @param cause la cause du problème.
	 */
	public MenuException(Throwable cause)
	{
		super(cause);
	}

	/**
	 * Construit une nouvelle exception.
	 * @param message message indiquant la nature du problème.
	 * @param cause la cause du problème.
	 */
	public MenuException(String message, Throwable cause)
	{
		super(message, cause);
	}

}
