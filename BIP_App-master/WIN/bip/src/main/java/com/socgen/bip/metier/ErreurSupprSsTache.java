package com.socgen.bip.metier;

public class ErreurSupprSsTache {
	private static String retourCharriotUnicode = "\\u000D";
	public static String messagePrefixe = "Votre demande de Suppression sur ligne ";
	public static String messagePrefixeSsTache = ", sous-tâche n° ";
	private static String messageAutresSsTaches = "... (d'autres sous-tâches sont concernées)";
	// FAD PPM 65123 : MAJ de l'erreur de suppression de la sous-tache.
	public static String messageSuffixe = " ne peut pas être prise en compte car il y a encore du consommé dans l'année sur au moins 1 des ressources affectées : veuillez corriger puis éventuellement attendre la prochaine mensuelle";
	
	private String pid;
	private String numEtape;
	private String numTache;
	private String numSsTache;
	
	public ErreurSupprSsTache(String pid, String numEtape, String numTache, String numSsTache) {
		this.pid = pid;
		this.numEtape = numEtape;
		this.numTache = numTache;
		this.numSsTache = numSsTache;
	}
	
	public String getPid() {
		return pid;
	}
	public void setPid(String pid) {
		this.pid = pid;
	}
	
	public static String getMessagePrefixe() {
		return messagePrefixe;
	}

	public static void setMessagePrefixe(String messagePrefixe) {
		ErreurSupprSsTache.messagePrefixe = messagePrefixe;
	}

	public static String getMessageSuffixe() {
		return messageSuffixe;
	}

	public static void setMessageSuffixe(String messageSuffixe) {
		ErreurSupprSsTache.messageSuffixe = messageSuffixe;
	}

	public String getNumEtape() {
		return numEtape;
	}

	public void setNumEtape(String numEtape) {
		this.numEtape = numEtape;
	}

	public String getNumTache() {
		return numTache;
	}

	public void setNumTache(String numTache) {
		this.numTache = numTache;
	}

	public String getNumSsTache() {
		return numSsTache;
	}

	public void setNumSsTache(String numSsTache) {
		this.numSsTache = numSsTache;
	}

	public static String getMessage(java.util.ArrayList<ErreurSupprSsTache> erreurs) {
		String message = null;
		
		if (erreurs!= null && !erreurs.isEmpty()) {
			message = messagePrefixe;
			
			// Obtention du 1er élément
			ErreurSupprSsTache erreur = erreurs.get(0);
			
			message += erreur.getPid() + messagePrefixeSsTache 
			+ erreur.getNumEtape() 
			+ "/"
			+ erreur.getNumTache()
			+ "/"
			+ erreur.getNumSsTache();
			
			if (erreurs.size() > 1) {
				message += messageAutresSsTaches;
			}
			
			message += messageSuffixe;
		}
		
		return message;
	}
}
