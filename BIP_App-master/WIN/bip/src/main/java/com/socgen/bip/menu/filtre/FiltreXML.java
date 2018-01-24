/*
 * Créé le 4 févr. 05
 *
 */
package com.socgen.bip.menu.filtre;

import java.util.Hashtable;

import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.menu.MenuException;

/**
 * Classe permettant d'extraire les filtres d'un fichier XML
 *
 * @author X039435
 */
public class FiltreXML implements BipConstantes
{
	public static final String TAG_FILTRE_ET = "filter_and";
	public static final String TAG_FILTRE_OU = "filter_or";
	public static final String TAG_FILTRE_ID = "filter_id";
	public static final String TAG_FILTRE_AUTRE = "filter_other";
	public static final String TAG_FILTRE_CHAMP_USERBIP = "filter_field";
	
	public static final String[] LISTE_TAG_FILTRE = {	TAG_FILTRE_ET, TAG_FILTRE_OU, TAG_FILTRE_ID,
														TAG_FILTRE_AUTRE, TAG_FILTRE_CHAMP_USERBIP };
	public static final String FILTRE_NOT = "not";
	public static final String FILTRE_CHAMP_NOM = "fieldName";
	public static final String FILTRE_CHAMP_VALEURS = "validValues";
	public static final String FILTRE_CLASS = "className";
	public static final String FILTRE_FONCTION = "functionName";
	public static final String FILTRE_ID = "id";
	
	/**
	 * Fonction qui permet de construire un FiltreMenu à partir d'un noeud de document XML
	 * Si ce noeud comprend d'autres filtres, ceux si sont intégrés
	 * 
	 * @param n	noeud dans l'arbre XML, doit correspondre à un filtre
	 * @param hFiltres	liste des filtres identifiés par une clé
	 * @return un filtre construit à partir du noeud donné
	 * @throws MenuException
	 */
	public static FiltreMenu buildFiltre(Node n, Hashtable hFiltres) throws MenuException
	{
		String sTypeFiltre = n.getNodeName();
		boolean bNot;
		
		// Negation ?
		if ( (n.getAttributes().getNamedItem(FILTRE_NOT) == null) || (!"true".equals(n.getAttributes().getNamedItem(FILTRE_NOT).getNodeValue())) )
			bNot = false;
		else
			bNot = true;
		
		//suivant le type du filtre on appelle le 'constructeur' approprié
		if (TAG_FILTRE_ET.equals(sTypeFiltre))
		{
			return buildFiltreET(n, bNot, hFiltres);
		}
		else if (TAG_FILTRE_OU.equals(sTypeFiltre))
		{
			return buildFiltreOU(n, bNot, hFiltres);
		}
		else if (TAG_FILTRE_AUTRE.equals(sTypeFiltre))
		{
			return buildFiltreAutre(n, bNot);
		}
		else if (TAG_FILTRE_CHAMP_USERBIP.equals(sTypeFiltre))
		{
			return buildFiltreChampUserBip(n, bNot);
		}
		else if (TAG_FILTRE_ID.equals(sTypeFiltre))
		{
			String sId = n.getAttributes().getNamedItem(FILTRE_ID).getNodeValue();
			FiltreMenu fM = (FiltreMenu)hFiltres.get(sId);
			if (fM == null)
				throw new MenuException("Filter_id ["+sId+"] n'est pas définit"); 
			return  fM;
		}
		else
		{
			//pb, n c'est pas un node filtre connu
			logService.error("Filtre inconnu "+ sTypeFiltre);
			throw new MenuException("Filtre inconnu "+ sTypeFiltre);
		}
	}
	
	/**
	 * Construction d'un filtre de type FiltreET
	 * Comme pour FiltreOU, ce filtre est compsé d'un nombre indéterminé de filtres Fils
	 * Chacun des filtres fils est constuit via la fonction publique buildFiltre puis ajouté à la liste des filtres composant le filtreET / filtreOU
	 * Les filtres fils peuvent être de n'importe quel type
	 * Lors de l'évaluation (fonction FiltreET.eval), l'opérateur logique && est utilisé
	 * 
	 * @param n noeud dans l'arbre XML correspondant à un filtreET, cf TAG_FILTRE_ET
	 * @param bNot négation sur le résultat
	 * @param hFiltres liste des filtres identifiés par une clé
	 * @return un filtre construit à partir du noeud donné comprenant des filtres fils
	 * @throws MenuException
	 */
	private static FiltreET buildFiltreET(Node n, boolean bNot, Hashtable hFiltres) throws MenuException
	{
		FiltreET filtre= new FiltreET(bNot);
		
		NodeList listeItems = n.getChildNodes();
		for (int i=0; i<listeItems.getLength(); i++)
		{
			Node nCur = listeItems.item(i);
			
			if (!isTagFiltre(nCur.getNodeName()))
				continue;
			
			filtre.addFiltre(buildFiltre(nCur, hFiltres));
		}
		return filtre;
	}
	
	/** Construction d'un filtre de type FiltreOU
	 * Comme pour FiltreET, ce filtre est compsé d'un nombre indéterminé de filtres Fils
	 * Chacun des filtres fils est constuit via la fonction publique buildFiltre puis ajouté à la liste des filtres composant le filtreET / filtreOU
	 * Les filtres fils peuvent être de n'importe quel type
	 * Lors de l'évaluation (fonction FiltreOU.eval), l'opérateur logique || est utilisé
	 * 
	 * @param n noeud dans l'arbre XML correspondant à un filtreET, cf TAG_FILTRE_OU
	 * @param bNot négation sur le résultat ?
	 * @param hFiltres liste des filtres identifiés par une clé
	 * @return un filtre construit à partir du noeud donné comprenant des filtres fils
	 * @throws MenuException
	 * */
	private static FiltreOU buildFiltreOU(Node n, boolean bNot, Hashtable hFiltres) throws MenuException
	{
		FiltreOU filtre= new FiltreOU(bNot);
		
		NodeList listeItems = n.getChildNodes();
		for (int i=0; i<listeItems.getLength(); i++)
		{
			Node nCur = listeItems.item(i);
			
			if (!isTagFiltre(nCur.getNodeName()))
				continue;
			
			filtre.addFiltre(buildFiltre(nCur, hFiltres));
		}
		return filtre;
	}
	
	/**
	 * Construction d'un filtre de type FiltreAutre
	 * Ce filtre appelle la méthode spécifiée de la classe spécifiée.
	 * @param n noeud dans l'arbre XML correspondant à un filtreAutre, cf TAG_FILTRE_AUTRE
	 * @param bNot négation sur le résultat ?
	 * @return
	 */
	private static FiltreAutre buildFiltreAutre(Node n, boolean bNot)
	{
		String sClass = (n.getAttributes().getNamedItem(FILTRE_CLASS)).getNodeValue();
		String sFonction = (n.getAttributes().getNamedItem(FILTRE_FONCTION)).getNodeValue();
		
		FiltreAutre filtre = new FiltreAutre( bNot, sClass, sFonction );
		return filtre;
	}
	
	/**
	 * Construction d'un filtre de type FiltreChampUserBip
	 * Ce filtre appelle la méthode spécifiée de la classe spécifiée.
	 * @param n noeud dans l'arbre XML correspondant à un filtreChampUserBip, cf TAG_FILTRE_CHAMP_USERBIP
	 * @param bNot négation sur le résultat ?
	 * @return
	 */
	private static FiltreChampUserBip buildFiltreChampUserBip(Node n, boolean bNot) throws MenuException
	{
		String sChamp = (n.getAttributes().getNamedItem(FILTRE_CHAMP_NOM)).getNodeValue();
		String sValeurs = (n.getAttributes().getNamedItem(FILTRE_CHAMP_VALEURS)).getNodeValue();
		try
		{
			FiltreChampUserBip filtre = new FiltreChampUserBip( bNot, sChamp, sValeurs );
			return filtre;
		} catch (Exception nSME)
		{
			logService.error("pb sur filtreChamp " + sChamp, nSME);
			throw new MenuException("Filtre_champ [" + sChamp + "<>" + sValeurs + "]");
		}
	}
	
	/**
	 * Permet de savoir si un noeus correspond à un filtre
	 * @param sTag tag à tester
	 * @return true si le tag correspond à un filtre, false sinon
	 */
	public static boolean isTagFiltre(String sTag)
	{
		for (int i=0; i< LISTE_TAG_FILTRE.length; i++)
		{
			if (LISTE_TAG_FILTRE[i].equals(sTag))
				return true;
		}
		return false;
	}
}
