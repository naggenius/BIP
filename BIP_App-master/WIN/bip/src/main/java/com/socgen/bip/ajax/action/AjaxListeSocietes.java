package com.socgen.bip.ajax.action; 

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.action.BipAction;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.config.ConfigManager;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * 
 * Pour utiliser cette Cette Classe AJAX deux actions à effectuer :
 *  
 * ETAPE 1 : 
 * - Créer en BASE DE DONNEES un procédure de RECHERCHE RAMENANT UN CURSEUR (prendre exemple sur recherche sociétés)
 * - Copier Coller une action Ajax(AjaxListeSocietes par exemple)
 * 
 * ETAPE 2 : 
 *   Dans la nouvelle classe crée: 
 * 	 - redéclarer  PACK_RECHERCHE                  : pointe su la procédure SQL souhaitée     (issu du fichier bip_proc.properties) 
 * 	 - redéclarer  MAX_LIGNES_AFFICHEES_LISTE      : Nombre maxi lignes affichées de la liste résultats
 *   - redéclarer  NOM_CHAMP_FORMULAIRE_RECHERCHE  : nom du champ dans le formulaire pour la saisie/affichage AJAX
 *   
 *   - Modifier la méthode afficheListeAjax        :   Afin d'afficher une liste perosnnalisée , c'est du pur HTML qui doit obligatoirement créer
 *   												   une liste de type <ul> contenant des éléments de type <LI> , dans les lignes <LI>
 *   												   on peut utiliser des balises HTML de présentation du style <B> (texte gras) , 
 *   												   <U> (texte souligné) etc ....
 *   												    
 *   																			
 * 
 *   
 * JAL 05/09/2008   
 * @author X060314
 *
 */
public class AjaxListeSocietes  extends BipAction {
	
 
    
    //MAX LIGNES AFFICHEES DANS LA LISTE RESULTAT
    private int MAX_LIGNES_AFFICHEES_LISTE = 100 ;
    
    //PROCEDURE A APPELLER POUR RECHERCHER LES DONNEES
    public String PACK_RECHERCHE = "recup.id.societe.proc" ; 
    
    //NOM DU CHAMP DANS LA JSP APPELANTE QUI CONTIENT LA CHAINE DE RECHERCHE
    protected String NOM_CHAMP_FORMULAIRE_RECHERCHE = "code_societe" ; 
    
    
    
    
	protected static Config configProc = ConfigManager.getInstance(BIP_PROC) ;
	     
    protected  int compteur ; 
    
    
    /**
     * CREATION LISTE RESULTATS
     * @param response
     * @param rset
     * @param servOut
     * @throws IOException
     * @throws SQLException
     */
    protected void afficheListeAjax(HttpServletResponse response, ResultSet rset,  ServletOutputStream servOut) throws IOException, SQLException {    	
        
    	//CREATION DEBUT LISTE 
		servOut.print("<UL STYLE='border: 1px solid #110011;'>") ;				
	 
		String libSociete ;  
		String libSiren ; 
		String libCodeSociete ;
		String libSocieteGroupe;
		
		this.compteur = 0;			
		while (rset.next() && compteur < MAX_LIGNES_AFFICHEES_LISTE + 1 ) { 	 
				if(rset.getString(1)!=null)
				{
					libCodeSociete =  rset.getString(1) ;										
				}else{
					libCodeSociete =  "    " ; 	
				}
			
				if(rset.getString(2)!=null)
				{
					if(rset.getString(2).length()>30){
					 libSociete = " - " + rset.getString(2).substring(0,29);
					}else{
					  libSociete = " - " +  rset.getString(2) ; 
					}
				}else{
					libSociete = " " ; 	
				}
				
				if(rset.getString(3)!=null)
				{
					libSiren = " - SIREN: <U>" + rset.getString(3);									
				}else{
					libSiren = "<U>"; 
				}
				
				if(rset.getString(7)!=null)
				{					
					libSocieteGroupe = " - " + rset.getString(7);
				}else{
					libSocieteGroupe = "";	
				}
				
				
				
				servOut.print("<li><B><U>" + libCodeSociete  + "</U>"+ libSocieteGroupe+ "</B>"+ libSociete + libSiren  + "</U></li>");
				
			this.compteur += 1 ;
		}//FIN BOUCLE WHILE
			    
		//FERMETURE LISTE
		servOut.print("</ul>") ;
	}
    
    
    
    
    
    
    
    
    
 
  	/**
  	 * 
  	 */
    public ActionForward bipPerform(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response,Hashtable hParamProc) throws IOException, ServletException{
		 
   	 
		// LOGS 
		String signatureMethode = this.getClass().getName()
		+ " - bipPerform(mapping, form , request,  response,  hParamProc )";
		logBipUser.entry("AJAX: "+ signatureMethode);

		
				//RECUPERE SAISIE UTILISATEUR  
				String  searchString = request.getParameter(NOM_CHAMP_FORMULAIRE_RECHERCHE);	
				 
				if (searchString!=null)
				{
					    //RECUPERE LE FLUX DE SORTIE POUR ENVOYER LISTE SUR PAGE APPEL A AJAX 
					    ServletOutputStream servOut =  response.getOutputStream(); 
					    
						//INITIALISATION CLASSIQUE ACCES BASE DE DONNEES 
						hParamProc.put("nomRecherche",searchString);	
						JdbcBip jdbc = new JdbcBip(); 
						Vector vParamOut = new Vector();
						ParametreProc paramOut;
						
						//APPEL ACCES EN BASE ET CONSTRUCTION LISTE
						return rechercheResultats(response, hParamProc, signatureMethode, servOut, jdbc);
						
				//SI PROBLEME : SAISIE UTILISATEUR NON RECUPEREE : SORTIE PROCEDURE
				}else{
						logBipUser.debug("AJAX : ERREUR : saisie utilisateur non récupérée ") ;							
						logBipUser.exit(signatureMethode);
						return null;
				}
	}
    
   
    /**
     * ACCES EN BASE 
     * 
     * @param response
     * @param hParamProc
     * @param signatureMethode
     * @param servOut
     * @param jdbc
     * @return
     * @throws IOException
     */
    protected ActionForward rechercheResultats(HttpServletResponse response, Hashtable hParamProc, String signatureMethode, ServletOutputStream servOut, JdbcBip jdbc) throws IOException {		 	
		Vector vParamOut;
		ParametreProc paramOut;
		try 
		{  
			vParamOut = jdbc.getResult(hParamProc, configProc,PACK_RECHERCHE) ; 
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) 
			{
				paramOut = (ParametreProc) e.nextElement();
				if (paramOut.getNom().equals("curseur")) 
				{			  
					ResultSet rset = (ResultSet) paramOut.getValeur();
					try 
					{ 
						//METHODE A SRUCHARGER 					 
						afficheListeAjax(response, rset,servOut);			
						
						if (rset != null) rset.close(); 
						
					}// try
					catch (SQLException sqle) {		
						    logBipUser.debug("AJAX : Erreur de traitement (SQLException) ") ;	
						    logBipUser.exit(signatureMethode);
						    jdbc.closeJDBC(); 
						    return null;
					}
				}// if
			}// for
		}// try
		catch (BaseException be) {
			logBipUser.debug("AJAX : Erreur de traitement (BaseException) ") ;							
			logBipUser.exit(signatureMethode);
			jdbc.closeJDBC();
			return null;

		} 
		
		//TRAITEMENT AJAX TERMINE CORRECTEMENT
		logBipUser.exit(signatureMethode); 
		jdbc.closeJDBC(); 
		//C'EST AJAX : ON NE RETOURNE PAS DE FORWARD SUR UNE JSP
		return null;
	}
    
    
     
     
    
   
}
 