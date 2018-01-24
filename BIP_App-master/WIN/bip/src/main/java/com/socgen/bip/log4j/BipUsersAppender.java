package com.socgen.bip.log4j;

import java.io.IOException;
import java.util.Calendar;
import java.util.Enumeration;
import java.util.Hashtable;

import org.apache.log4j.Appender;
import org.apache.log4j.AppenderSkeleton;
import org.apache.log4j.FileAppender;
import org.apache.log4j.Logger;
import org.apache.log4j.MDC;
import org.apache.log4j.spi.LoggingEvent;

import com.socgen.cap.fwk.ServiceManager;
import com.socgen.cap.fwk.log.Log;

/**
 * @author RSRH/ICH/GMO Equipe Bip
 * @author E.GREVREND
 *
 * BipUserAppender permet de gerer les fichiers de traces pour chaque utilisateur et par jour
 * Pour spécifier le userId, il faut utiliser le MCD de log4j via la méthode statique setUserId(String)
 * Au moment de faire un log, s'il n'existe pas encore, un FileAppender
 * pour le fichier baseName.YYYYMMDD.userId.log est cree
 * L'appender est supprimé au moment de l'appel de removeUserId
 * 
 * Si setUserId(String) n'est pas utilisé, la propriété defaultUserId est utilisée
 * Si removeUserId n'est pas utilisé, l'Appender n'est pas ferme et le fichier reste ouvert,
 * Il est raisonnable de fermer proprement le fichier de log (via removeUserId donc)
 * dès que le traitement pour l'utilisateur est termine
 */
public class BipUsersAppender extends AppenderSkeleton
{
	private static final String USERID_KEY = "userId";
	
	protected Log logError= ServiceManager.getInstance().getLogManager().getLogService();
	protected Hashtable listeAppender = new Hashtable();
	
	private String defaultUserId = "undefined";
	private String baseName = "d:/J2EE/eclipse/trace/logFiles/";

	/**
	 * @see org.apache.log4j.AppenderSkeleton#doAppend(LoggingEvent)
	 */
	public void doAppend(LoggingEvent logEvent)
	{
		append(logEvent);
	}
	
	/**
	 * @see org.apache.log4j.AppenderSkeleton#append(LoggingEvent)
	 */
	protected void append(LoggingEvent logEvent)
	{
		String userId;
		String strDate;
		String fileName;
		Appender userApp;
		
		userId = getUserId();

		if (userId == null)
		{
			userId = defaultUserId;
			setUserId(userId);
		}
		
		strDate = getStrDateFichier();
		
		synchronized (this)
		{
			userApp = getAppender(userId);
			if (userApp == null)
			{
				try
				{	
					fileName = baseName + strDate  + "." + userId + ".log";
					userApp = new FileAppender(layout, fileName, true);
					userApp.setName(userId);
					addAppender(userApp);
				} catch (IOException e)
				{
					logError.error(this.getClass().getName() + ".append : Echec de la creation du FileAppender("+baseName + strDate + userId + ".log)");
					
					return;
				}
			}
		}
		
		userApp.doAppend(logEvent);
	}

	/**
	 * @see org.apache.log4j.Appender#requiresLayout()
	 */
	public boolean requiresLayout()
	{
		return true;
	}

	/**
	 * @see org.apache.log4j.Appender#close()
	 */
	public void close()
	{
		removeAllAppenders();
	}

	/**
	 * @see org.apache.log4j.spi.AppenderAttachable#addAppender(Appender)
	 */
	public void addAppender(Appender userApp)
	{
		//s'il existait deja, il est remplace
		if (userApp == null)
		{
			logError.error("Tentative d'ajout d'un Appender null");
		}
		else
			listeAppender.put(userApp.getName(), userApp);
	}

	/**
	 * @see org.apache.log4j.spi.AppenderAttachable#getAllAppenders()
	 */
	public Enumeration getAllAppenders()
	{
		return listeAppender.elements();
	}

	/**
	 * @see org.apache.log4j.spi.AppenderAttachable#getAppender(String)
	 */
	public Appender getAppender(String userId)
	{
		return (Appender)listeAppender.get(userId);
	}

	/**
	 * @see org.apache.log4j.spi.AppenderAttachable#isAttached(Appender)
	 */
	public boolean isAttached(Appender userApp)
	{
		//si pas dans la table => != null
		return (getAppender(userApp.getName()) != null);
	}

	public void activateOptions()
	{
	}

	/**
	 * @see org.apache.log4j.spi.AppenderAttachable#removeAllAppenders()
	 */
	public void removeAllAppenders()
	{
		Enumeration enums;
		
		enums = listeAppender.elements();
		while (enums.hasMoreElements())
		{
			removeAppender((Appender)enums.nextElement());
		}
	}

	/**
	 * @see org.apache.log4j.spi.AppenderAttachable#removeAppender(Appender)
	 */
	public void removeAppender(Appender userApp)
	{
		listeAppender.remove(userApp.getName());
		userApp.close();
	}

	/**
	 * @see org.apache.log4j.spi.AppenderAttachable#removeAppender(String)
	 */
	public void removeAppender(String userId)
	{		
		Appender userApp;
		userApp = (Appender)listeAppender.remove(userId);
		
		if (userApp != null)
			userApp.close();
	}

	/**
	 * Returns the baseName.
	 * @return String
	 */
	public String getBaseName()
	{
		return baseName;
	}

	/**
	 * Returns the defaultUserId.
	 * @return String
	 */
	public String getDefaultUserId()
	{
		return defaultUserId;
	}

	/**
	 * Sets the baseName.
	 * @param baseName The baseName to set
	 */
	public void setBaseName(String baseName)
	{
		this.baseName = baseName;
	}

	/**
	 * Sets the defaultUserId.
	 * @param defaultUserId The defaultUserId to set
	 */
	public void setDefaultUserId(String defaultUserId)
	{
		this.defaultUserId = defaultUserId;
	}

	/**
	 * Retourne la date du jour sous le forme YYYYMMDD
	 * @return String
	 */
	protected String getStrDateFichier()
	{
		//a refaire ...
		String strDate;
		Calendar c = Calendar.getInstance();
		
		strDate = "" + c.get(Calendar.YEAR);
		if ( (c.get(Calendar.MONTH)+1) < 10)
			strDate = strDate + "0" + (c.get(Calendar.MONTH)+1);
		else
			strDate = strDate + (c.get(Calendar.MONTH)+1);
		
		if (c.get(Calendar.DAY_OF_MONTH) < 10)
			strDate = strDate + "0" + c.get(Calendar.DAY_OF_MONTH);
		else
			strDate = strDate + c.get(Calendar.DAY_OF_MONTH);
			
		return strDate;
	}
	
	/**
	 * Mise à jour du userId
	 * @param userId le userId à placer dans le contexte
	 */
	public static void setUserId(String userId)
	{
		//MDC context par thread
		if (userId != null)
			MDC.put(USERID_KEY, userId);
	}
	
	/**
	 * Retourne le userId courant
	 * @return String
	 */
	public static String getUserId()
	{
		return (String)MDC.get(USERID_KEY);
	}
	
	/**
	 * Ferme l'Appender associé au userId courant puis retire du contexte le userId
	 */
	public static void removeUserId()
	{
		Object o;
		String userId = getUserId();
		//si userId est null c'est que :
		// (le userId n'a pas ete initialise) ET (qu'aucun log n'a ete effectue)
		if (userId == null)
			return;
			
		BipUsersAppender bipUA;
		Enumeration enums = Logger.getLogger("BipUser").getAllAppenders();
		
		while (enums.hasMoreElements())
		{
			o = enums.nextElement();
			if (o instanceof BipUsersAppender)
			{
				bipUA = (BipUsersAppender)o;
				
				bipUA.removeAppender(getUserId());
			}
		}
		
		MDC.remove(USERID_KEY);
	}
}
