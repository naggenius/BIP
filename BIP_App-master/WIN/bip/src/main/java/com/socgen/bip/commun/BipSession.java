/*
 * Créé le 13 déc. 04
 */
package com.socgen.bip.commun;

import javax.servlet.http.HttpSession;

/**
 * Permet de passer au dessus des problèmes liés aux différénces entre weblogic et tomcat
 * Chacun des deux serveur d'application utilise une classe propre quand ils manipulent des session
 * Cette classe permet en toute circonstance manipuler l'objet de session sans soucis.
 * @author x039435
 */
public class BipSession
{
	HttpSession session;
	
	public BipSession(HttpSession session)
	{
		this.session = session;
	}
	/**
	 * @return
	 */
	public HttpSession getSession()
	{
		return session;
	}

	/**
	 * @param session
	 */
	public void setSession(HttpSession session)
	{
		this.session = session;
	}

}
