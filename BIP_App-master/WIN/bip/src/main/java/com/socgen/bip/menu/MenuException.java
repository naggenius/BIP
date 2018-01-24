package com.socgen.bip.menu;

import com.socgen.bip.commun.CapBipException;

/**
 * Cette classe d�finit une exception relative � la manipulation des menus de l'application.
 * Cette exception est principalement utilis�e par l'instance unique de la classe MenuManager.
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
	 * @param message message indiquant la nature du probl�me.
	 */
	public MenuException(String message)
	{
		super(message);
	}

	/**
	 * Construit une nouvelle exception.
	 * @param cause la cause du probl�me.
	 */
	public MenuException(Throwable cause)
	{
		super(cause);
	}

	/**
	 * Construit une nouvelle exception.
	 * @param message message indiquant la nature du probl�me.
	 * @param cause la cause du probl�me.
	 */
	public MenuException(String message, Throwable cause)
	{
		super(message, cause);
	}

}
