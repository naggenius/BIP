/*
 * Créé le 7 déc. 04
 *
 */
package com.socgen.bip.menu;

import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.util.Hashtable;
import java.util.Vector;

import javax.swing.tree.DefaultMutableTreeNode;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.ErrorHandler;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

import utils.system;

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.Tools;
import com.socgen.bip.commun.bd.ParametreBD;
import com.socgen.bip.menu.filtre.FiltreMenu;
import com.socgen.bip.menu.filtre.FiltreOK;
import com.socgen.bip.menu.filtre.FiltreXML;
import com.socgen.bip.menu.item.BipItem;
import com.socgen.bip.menu.item.BipItemMenu;
import com.socgen.bip.menu.item.BipMenuInfoItem;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * Permet de passer du fichier XML en structures de données exploitées par BipMenuManager
 * @author x039435
 */
public class BipMenuXML implements BipConstantes
{
	public static final String TAG_BIPMENU = "BipMenu";
	
	public static final String TAG_MENUS = "menus";
	public static final String TAG_MENU = "menu";
	public static final String TAG_MENU_ITEM = "menuItem";
	public static final String TAG_MENU_INFO = "menuInfo";
	
	public static final String TAG_INFOS = "infos";
	public static final String TAG_INFO = "info";
	
	public static final String TAG_ITEMS = "items";
	public static final String TAG_ITEM = "item";
	
	public static final String TAG_FILTERS = "filters";
	public static final String TAG_FILTER = "filter";
	
	public static final String TAG_ID = "id";
	public static final String TAG_BACKGROUND_COLOR = "backGroundColor";
	public static final String TAG_LABEL = "label";
	public static final String TAG_ALT_LABEL = "altLabel";
	public static final String TAG_HELP_PAGE = "helpPage";
	public static final String TAG_LINK = "link";
	public static final String TAG_LINK_OPTIONS = "linkOptions";
	public static final String TAG_FILTER_ID = "filterId";
	public static final String TAG_DEFAULT_HELP_PAGE = "defaultHelpPage";
	public static final String TAG_DEFAULT_FILTER_ID = "defaultFilterId";
	public static final String TAG_DEFAULT_CLASS_NAME = "defaultClassName";
	public static final String TAG_DEFAULT_BACKGROUND_COLOR = "defaultBackGroundColor";
	public static final String TAG_CLASS_NAME = "className";
	public static final String TAG_FUNCTION_NAME = "functionName";
	
	public static final String TAG_FILTER_FIELD = "filter_field";
	
	private String sDefaultBackGroundColor;
	private String sDefaultHelpPage;
	
	Hashtable hFilters;
	Hashtable hInfos;
	Hashtable hItems;
	Hashtable hPagesMenus;

	/**
	 * La structure de donnée brute du fichier XML
	 */	
	Document document;
	
	/**
	 * A partir d'un flux de donnée correspondant au fichier XML on construit 'document', structure arborescente.<br>
	 * Une fois recupéré, on parcours l'arbre de document pour extraire les infos des menus 
	 * @param iStream flux d'entrée sur le fichier XML
	 * @throws MenuException si un problème apparaît
	 */
	public BipMenuXML(InputStream iStream) throws MenuException
	{
		// Get a JAXP parser factory object
		javax.xml.parsers.DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		// Tell the factory what kind of parser we want 
		dbf.setValidating(true);
		dbf.setNamespaceAware(true);
		// Use the factory to get a JAXP parser object
		javax.xml.parsers.DocumentBuilder parser;
		
		try
		{
			parser = dbf.newDocumentBuilder();
		}
		catch (ParserConfigurationException pCE)
		{
			throw new MenuException("", pCE);
		}
		

		// Tell the parser how to handle errors.  Note that in the JAXP API,
		// DOM parsers rely on the SAX API for error handling
		parser.setErrorHandler(new ErrorHandler()
		{
			public void warning(SAXParseException e)
			{
				logService.error("WARNING", e);				
				//System.err.println("WARNING: " + e.getMessage());
			}
			public void error(SAXParseException e) throws SAXException
			{
				logService.error("ERROR :" + e.getMessage());
				//System.err.println("ERROR: " + e.getMessage());
				throw e;
			}
			public void fatalError(SAXParseException e)	throws SAXException 
			{
				logService.error("FATAL :" + e.getMessage());
				//System.err.println("FATAL: " + e.getMessage());
				throw e;   // re-throw the error
			}
		} );

		// Finally, use the JAXP parser to parse the file.  This call returns
		// A Document object.  Now that we have this object, the rest of this
		// class uses the DOM API to work with it; JAXP is no longer required.
		try
		{
			document = parser.parse(iStream);
		}
		catch (IOException iOE)
		{
			throw new MenuException("", iOE);
		}
		catch (SAXException sE)
		{
			throw new MenuException("", sE);
		}
	}
	
	/**
	 * L'élément "items" dans l'arbre XML des menu comprend l'INTEGRALITE des noeud de l'arbre employés.<br>
	 * On parcours cette liste exaustive et on reférence tous les items dans la Hashtable hItems.<br>
	 * hItems sera utilisé pour construire l'arbre final des menus : la structure d'un menu est définie dans un tag <menu>
	 * @see buildTree() 
	 *
	 */
	private void buildItems() throws MenuException
	{
		hItems = new Hashtable();
		//on veut utiliser le 'document' pour construire l'arbre complet des menus
		//1) on construit une hashtable de tous les items
		Node node = document.getElementsByTagName(TAG_ITEMS).item(0);
		NamedNodeMap nMap = node.getAttributes();

		sDefaultHelpPage = nMap.getNamedItem(TAG_DEFAULT_HELP_PAGE).getNodeValue();
		
		NodeList listeItems = node.getChildNodes();
		for (int i=0; i<listeItems.getLength(); i++)
		{
			Node n = listeItems.item(i);
			if (!TAG_ITEM.equals(n.getNodeName()))
				continue;
				
			NamedNodeMap nodeMap = n.getAttributes();
			hItems.put(nodeMap.getNamedItem(TAG_ID).getNodeValue().toUpperCase(), buildBipItem(n));
		}
	}
	
	/**
	 * L'élément "filtres" dans l'arbre XML des menu comprend les différents filtre NOMMES.<br>
	 * Tous ces filtres nommés sont référencés dans la Hashtable hFiltres.<br>
	 * Les filtres de types 'filter_id' employés font référence à cette Hashtable.
	 * @throws MenuException
	 */
	private void buildFiltres() throws MenuException
	{
		hFilters = new Hashtable();
		//1) on construit une hashtable de tous les filtres
		Node node = document.getElementsByTagName(TAG_FILTERS).item(0);

		NodeList listeItems = node.getChildNodes();
		for (int i=0; i<listeItems.getLength(); i++)
		{
			Node n = listeItems.item(i);
		
			if (!TAG_FILTER.equals(n.getNodeName()))
				continue;
		
			NamedNodeMap nodeMap = n.getAttributes();
			String sId = nodeMap.getNamedItem(TAG_ID).getNodeValue();
			logService.info("Menus Filtres : " + sId);
			NodeList listeFils = n.getChildNodes();
			for (int j=0; j<listeFils.getLength(); j++)
			{
				Node nFils = listeFils.item(j);
				if (FiltreXML.isTagFiltre(nFils.getNodeName()))
				{
					logService.debug("\t\t"+sId + " - " + nFils.getNodeName());
					hFilters.put(sId, FiltreXML.buildFiltre(nFils, hFilters));
				}
			}
		}
	}
	
	/**
	 * L'élément "infos" dans l'arbre XML des menu comprend les différentes infos qui peuvent apparaitre dans les menus.<br>
	 * Les infos sont placés dans une Hashtable hInfos.<br>
	 * Quand on construit l'arborescence des menus et qu'un tag info est présent, on récupère dans hInfos l'objet identifié.
	 *
	 */
	private void buildInfos()
	{
		hInfos = new Hashtable();
		//1) on construit une hashtable de tous les infos
		Node node = document.getElementsByTagName(TAG_INFOS).item(0);

		NodeList listeItems = node.getChildNodes();
		for (int i=0; i<listeItems.getLength(); i++)
		{
			Node n = listeItems.item(i);
		
			if (!TAG_INFO.equals(n.getNodeName()))
				continue;
		
			NamedNodeMap nMap = n.getAttributes();
			
			BipMenuInfoItem bMI = new BipMenuInfoItem(	nMap.getNamedItem(TAG_ID).getNodeValue(),
														nMap.getNamedItem(TAG_CLASS_NAME).getNodeValue(),
														nMap.getNamedItem(TAG_FUNCTION_NAME).getNodeValue());

			hInfos.put(bMI.getId(), bMI);
		}
	}
	
	/**
	 * Construit l'arbre du menu se trouvant au Node nodeMenu.<br>
	 * Cette fonction est appelée pour chacun des tag <menu> trouvé dans la structure des menus (tag <menus>).<br>
	 * @see getMenuChild
	 * @param nodeMenu node (dans structure XML) de type <menu>
	 * @return l'arborescence complète du menu (infos, filtres, pages ...)
	 * @throws MenuException Un problème dans la construction
	 */
	private DefaultMutableTreeNode buildMenu(Node nodeMenu) throws MenuException
	{
		String sId;
		String sLabel;
		BipItemMenu bIMenu;
		NodeList listeItems;
		NamedNodeMap nMap;
		DefaultMutableTreeNode menu;
		
		menu = new DefaultMutableTreeNode();
		nMap = nodeMenu.getAttributes();
		
		sId = nMap.getNamedItem(TAG_ID).getNodeValue();
		logService.debug("Ajout à la racine de " + sId);

		bIMenu = buildBipItemMenu(nodeMenu);
		if (bIMenu.getLien() != null)
		{
			addPageMenu(sId, bIMenu.getLien());
		}

		menu.setUserObject(bIMenu);		
		listeItems = nodeMenu.getChildNodes();
		for (int i=0; i<listeItems.getLength(); i++)
		{
			Node n = listeItems.item(i);
	
			if (!TAG_MENU_ITEM.equals(n.getNodeName()))
				continue;

			menu.add(getMenuChild(sId, n, bIMenu.getPageAide(),null));						
		}
		return menu;
	}
	
	private void addPageMenu(String sMenu, String sLien)
	{
		if (hPagesMenus == null)
			hPagesMenus = new Hashtable();
	
		if (hPagesMenus.get(sLien) == null)
		{
			hPagesMenus.put(sLien, sMenu.toUpperCase());
		}
		else
		{
			String sMenus = (String)hPagesMenus.get(sLien);
			if (sMenus.indexOf(sMenu.toUpperCase()) < 0)
				hPagesMenus.put(sLien, sMenus + "," + sMenu.toUpperCase());
		}
	}
	
	/**
	 * Construit un noeud racine auquel vont être ajouté tous les menus définis (tous les <menu> presents dans le <menus>.<br>
	 * @return
	 * @throws MenuException
	 */
	private DefaultMutableTreeNode buildRacine() throws MenuException
	{
		DefaultMutableTreeNode racine;
		Node node;
		NodeList listeItems;
		NamedNodeMap nMap;
		
		racine = new DefaultMutableTreeNode();
			
		node = document.getElementsByTagName(TAG_MENUS).item(0);
		nMap = node.getAttributes();
		
		String sParamCouleur;
		/* récupération depuis la variable système */
		try {
			sParamCouleur = Tools.getSysProperties().getProperty(MENU_COULEUR_FOND);
			logService.info("La couleur par défaut des menus est celle définie dans la variable système "+MENU_COULEUR_FOND+" : " + sParamCouleur);
			sDefaultBackGroundColor = sParamCouleur;
		} catch (Exception exp) {
			logService.error("Problème lors de la récupération de la couleur de fond par défaut des menus depuis la variable système", exp);
			sParamCouleur = null;
		}

		/* récupération depuis la base */
		if (sParamCouleur == null) {
			try
			{
				sParamCouleur = ParametreBD.getValeur(MENU_COULEUR_FOND);
			}
			catch (BaseException bE)
			{
				logService.error("Problème lors de la récupération de la couleur de fond par défaut des menus",bE);
				sParamCouleur = null;
			}
			if (sParamCouleur == null)
			{
				if (nMap.getNamedItem(TAG_DEFAULT_BACKGROUND_COLOR) != null)
				{				
					sDefaultBackGroundColor = (nMap.getNamedItem(TAG_DEFAULT_BACKGROUND_COLOR)).getNodeValue();
					logService.info("La couleur par défaut des menus est celle définie dans le tag "+TAG_DEFAULT_BACKGROUND_COLOR + " du fichier xml : " + sDefaultBackGroundColor);;
				}
				else
				{
					logService.info("Pas de couleur par défaut pour les menus ");
					sDefaultBackGroundColor = null;
				}
			}
			else
			{
				logService.info("La couleur par défaut des menus est celle définie dans la table PARAMETRE : " + sParamCouleur);
				sDefaultBackGroundColor = sParamCouleur;
			}
		}
		
				
		listeItems = node.getChildNodes();
		
		for (int i=0; i<listeItems.getLength(); i++)
		{
			Node n = listeItems.item(i);
			if (!TAG_MENU.equals(n.getNodeName()))
				continue;
			
			racine.add(buildMenu(n));
		}
		
		return racine;
	}
	
	/**
	 * Construit à partir d'un noeud de la structure XML, un objet de type BipItem correspondant.<br>
	 * @param n le noeud à transformer
	 * @return une instance de BipItem correspondant à n
	 * @throws MenuException
	 */
	private BipItem buildBipItem(Node n) throws MenuException
	{
		String sItemId;
		String sAltLib;		
		String sHelpPage;
		String sFilterId;
		String sFilterClass;
		String sFilterFunction;
		String sFilterMenu;
		String sLink;
		String sLinkOptions;
		String sNivSousMenu = "";

		NamedNodeMap nMap;
		NamedNodeMap nMapItem;
		NamedNodeMap nMapFilter;
		DefaultMutableTreeNode noeud = new DefaultMutableTreeNode();

		nMapItem = n.getAttributes();
		sItemId = nMapItem.getNamedItem(TAG_ID).getNodeValue().toUpperCase();
		//logService.debug(sItemId);

		// A partir du MenuId on recupere les infos
		if (nMapItem.getNamedItem(TAG_ALT_LABEL) != null)
			sAltLib = nMapItem.getNamedItem(TAG_ALT_LABEL).getNodeValue();
		else
			sAltLib = nMapItem.getNamedItem(TAG_LABEL).getNodeValue();

		if (nMapItem.getNamedItem(TAG_HELP_PAGE) != null)
			sHelpPage = nMapItem.getNamedItem(TAG_HELP_PAGE).getNodeValue();
		else
			sHelpPage = null;

		if (nMapItem.getNamedItem(TAG_LINK) != null)
			sLink = nMapItem.getNamedItem(TAG_LINK).getNodeValue();
		else
			sLink = null;

		// JMA 03/03/06 : ajout de alt_label en paramètre pour utiliser comme titre de page dans les favoris
		// JMA 06/03/06 : ajout de l'action Strut en paramètre pour l'utiliser comme lien dans la page des favoris
		// car sinon on ne peut récupérer que la page JSP donc on ne passe pas dans les action initialiser,etc..
		String lienFav = "";
		if (sLink!=null) {
			if ( !sLink.toLowerCase().startsWith("/") ) lienFav = URLEncoder.encode("/" + sLink);
			else lienFav = URLEncoder.encode(sLink);
		}
		if (nMapItem.getNamedItem(TAG_LINK_OPTIONS) != null)
			sLinkOptions = nMapItem.getNamedItem(TAG_LINK_OPTIONS).getNodeValue() + "&titlePage=" + URLEncoder.encode(sAltLib) + "&lienFav=" + lienFav;
		else
			sLinkOptions = "titlePage=" + URLEncoder.encode(sAltLib) + "&lienFav=" + lienFav;

		BipItem bItem = new BipItem(	sItemId,
										nMapItem.getNamedItem(TAG_LABEL).getNodeValue(),
										sAltLib,
										sHelpPage,
										null,
										sLink,
										sLinkOptions,
										sNivSousMenu);
		return bItem;
	}
	
	/**
	 * Contruit à partir d'un noeud de la structure XML un objet BipItemMenu correspondant.<br>
	 * Correspond à la racine d'un des différénts de menus de la BIP.<br>
	 * Cette objet contient donc des infos qu'il faut également récupérer.
	 * @param n le noeud correspondant à un <menu>
	 * @return une instance de BipMenuItem correspondant à n
	 * @throws MenuException
	 */
	private BipItemMenu buildBipItemMenu(Node n) throws MenuException
	{
		NamedNodeMap nMap;
		BipItem bItem;
		String sItemId;
		
		nMap = n.getAttributes();
		sItemId = nMap.getNamedItem(TAG_ID).getNodeValue().toUpperCase();		
		bItem = (BipItem)hItems.get(sItemId);
		
		if (bItem == null)
		{
			throw new MenuException(" Le menuItem.id [ " + sItemId + " ] n'existe pas !!!");
		}
		bItem = new BipItem(bItem);
		
		/*
		 * Gestion des INFOS !!!
		 */
		Vector vInfos = new Vector();
		String sCouleurFond = null;
		
		if (nMap.getNamedItem(TAG_BACKGROUND_COLOR) != null)
		{
			sCouleurFond = nMap.getNamedItem(TAG_BACKGROUND_COLOR).getNodeValue();
		}
		else
		{
			sCouleurFond = sDefaultBackGroundColor;
		}
		
		NodeList listeInfos = n.getChildNodes();
		for (int i=0; i<listeInfos.getLength(); i++)
		{
			Node nFils = listeInfos.item(i);	
			if (!TAG_MENU_INFO.equals(nFils.getNodeName()))
				continue;

			NamedNodeMap nMapInfo = nFils.getAttributes();
			String sInfoId = nMapInfo.getNamedItem(TAG_ID).getNodeValue();
			
			BipMenuInfoItem bMI = (BipMenuInfoItem)hInfos.get(sInfoId);
			vInfos.add(bMI);
		}
		
		BipItemMenu bIMenu = new BipItemMenu(bItem, vInfos, sCouleurFond);
		if (bIMenu.getPageAide() == null)
			bIMenu.setPageAide(sDefaultHelpPage);

		return bIMenu;
	}
	
	/**
	 * !! Fonction récursive !!<br>
	 * 
	 * On met à jour la Hashtable hPagesMenus. Cette Hashtable liste pour l'ensemble des urls traitées les menus dans lesquels elles apparaissent.<br>
	 * Le mécanisme de d'habilitation repose entièrement sur cette table : <br>
	 * 		un utilisateur (identifié) essaye d'aller sur une page donnée
	 * 		on récupère via hPagesMenu la liste des menus dans lesquels l'url est définie
	 * 		si la liste des menus de l'utilisateurs et cette liste n'ont rien en commun, c'est que l'utilisateur n'a pas à pouvoir consulter cette url
	 * 
	 * @param sId identifiant du menu auquel est attaché l'éléments courant
	 * @param n noeud de l'élément courant, peut être une feuille
	 * @param sPageAide page d'aide utilisée si elle n'est pas définie, correspond à celle du noeud parent
	 * @return un TreeNode correspond au noeud courant ET AUX NOEUDS FILS, qui ont étés construits et ajoutés via appels récursif de cette méthode
	 * @throws MenuException
	 */
	private DefaultMutableTreeNode getMenuChild(String sId, Node n, String sPageAide,String sNiveauMenu) throws MenuException
	{
		DefaultMutableTreeNode noeud = new DefaultMutableTreeNode();
		
		NamedNodeMap nMap = n.getAttributes();
		String sMenuItemId = nMap.getNamedItem(TAG_ID).getNodeValue().toUpperCase();		
		BipItem bItem = (BipItem)hItems.get(sMenuItemId);
		String sSousmenu = "";
		
		if (bItem == null)
		{
			throw new MenuException(" Le menuItem.id [ " + sMenuItemId + " ] n'existe pas !!!");
		}
		bItem = new BipItem(bItem);

		noeud.setUserObject(bItem);
		
		//System.out.println("##########"+bItem.getId());

		
		//on reference la page pour le menu dans la hashtable hPagesMenus
		//cette hashtable va servir au test d'habilitaion : la page est'elle autorisee pour tel utilisateur
		//(ie. apparait dans un des menus auquel l'utilisateur est habilité)
		if (bItem.getLien() != null)
		{
			addPageMenu(sId, bItem.getLien());
		}
		if (bItem.getPageAide() == null)
			bItem.setPageAide(sPageAide);
		

		
		NodeList listeItems = n.getChildNodes();
		bItem.setFiltre(new FiltreOK());
		
		// recherche presence filtre pour ce niveau
		for (int i=0; i<listeItems.getLength(); i++)
		{
			Node nFils = listeItems.item(i);

			if (FiltreXML.isTagFiltre(nFils.getNodeName()))
			{
				if (nFils.getAttributes().getNamedItem("validValues") != null ) 
				{
					sSousmenu = nFils.getAttributes().getNamedItem("validValues").getNodeValue();	
					//System.out.println("##########"+bItem.getId());
					//System.out.println("*****"+ sSousmenu );
				}
			}
		}
		
		// On recupere en priorite celui du parent puis celui de l'item courant
		if (bItem.getNivSousMenu() == null) {
			if ( sNiveauMenu != "") {
			bItem.setNivSousMenu(sNiveauMenu);
			} else {
				bItem.setNivSousMenu(sSousmenu);
			}
		}
		
		for (int i=0; i<listeItems.getLength(); i++)
		{
			Node nFils = listeItems.item(i);
			
			// Construction du filtre associé
			//if (bItem.getFiltre() != null) logService.debug(bItem.getFiltre().toString());
			//logService.debug("childcnt == 0");
			if (FiltreXML.isTagFiltre(nFils.getNodeName()))
			{
				//if (bItem.getFiltre() != null) logService.debug(bItem.getFiltre().toString());
				logService.debug("Ajout d'un Filtre pour "+bItem.getId()+" "+ nFils.getNodeName());
				FiltreMenu fM = FiltreXML.buildFiltre(nFils, hFilters); 
				bItem.setFiltre(fM);
				//bItem.setNivSousMenu(nFils.getAttributes().getNamedItem("validValues").getNodeName());
				//bItem.setNivSousMenu(nFils.getAttributes().get .getNamedItem("validValues").getNodeName() );
				if (nFils.getAttributes().getNamedItem("validValues") != null ) 
				{
					bItem.setNivSousMenu(nFils.getAttributes().getNamedItem("validValues").getNodeValue());
					//System.out.println("*****"+ nFils.getAttributes().getNamedItem("validValues").getNodeValue() );
				}

			}
				
			if (!TAG_MENU_ITEM.equals(nFils.getNodeName()))
				continue;
	
			noeud.add(getMenuChild(sId, nFils, bItem.getPageAide(),bItem.getNivSousMenu() ) );	
		}
		
		return noeud;
	}
	
	/**
	 * 
	 * @return
	 */
	public Hashtable getPagesMenus()
	{
		return hPagesMenus;
	}
	
	/**
	 * 
	 * @return
	 */
	public Hashtable getItems()
	{
		return hItems;
	}

	/**
	 * Extraction de l'arbre XML de tous les éléments.<br>
	 * Contruction hNodeItems, hFiltres et hInfos.<br>
	 * Contruction de l'arbre des menus en utilisant les différéntes Hashtables précédemment construites.
	 * @return La structure complète des menus de la BIP
	 * @throws MenuException
	 */
	public DefaultMutableTreeNode buildTree() throws MenuException
	{
		buildItems();
		buildFiltres();
		buildInfos();
		return buildRacine();		
	}
	
	/**
	 * Fonction de debug.<br>
	 * Permet d'avoir un visuel de la structure d'un noeud
	 * @param n le noeud à afficher
	 */
	private void lireNoeud(Node n)
	{
		if (n.getNodeType() != 1)
			return;
		System.out.println(n.getNodeName());
		NamedNodeMap nMap = n.getAttributes();
		if (nMap != null)
		{
			for (int i=0; i<nMap.getLength(); i++)
				System.out.println("\t"+nMap.item(i).getNodeName() + " " + nMap.item(i).getNodeValue());
		}
		NodeList nL = n.getChildNodes();
		for (int i=0; i<nL.getLength(); i++)
			lireNoeud(nL.item(i));
	}
}
