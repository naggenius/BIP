<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*, com.socgen.ich.ihm.*, com.socgen.bip.form.EditerProfilsForm" errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="editerProfilsForm" scope="request" class="com.socgen.bip.form.EditerProfilsForm" />
<html:html locale="true">
<!-- #EndEditable --> 

<!-- #BeginTemplate "/Templates/Page_edition.dwt" --><head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<!-- #BeginEditable "doctitle" --> 
<title>Edition des profils pour une liste de ressources</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/eProfilsListeRessourcesNewAd.jsp"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">

var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
	String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
// Variable utilisée pour l'affichage de la popup d'aide
var pageAide = "<%= sPageAide %>";

<%
	// Titre défini dans le bandeau supérieur de la page
	String sTitre;
	String sInitial;
	String sJobId="eProfilsListeRessAd";
%>

function MessageInitial()
{
	<%
		sTitre = com.socgen.bip.metier.Report.getTitre(sJobId);
		//sTitre =  null;
		if (sTitre == null)
		{
			//redirect sur la page d'erreur
			sTitre = "Pas de titre";
		}		
		sInitial=ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getQueryString()));
		if (sInitial == null)
			sInitial = request.getRequestURI();
		else
			sInitial = request.getRequestURI() + "?" + sInitial;
		sInitial = sInitial.substring(request.getContextPath().length());
	%>
	
	var Message="<bean:write filter="false"  name="editerProfilsForm"  property="msgErreur" />";
	var Focus = "<bean:write name="editerProfilsForm"  property="focus" />";
	
	if (Message != "") {
		alert(Message);
	}
}

function AjusterTaille() {
	if (document.getElementById("divEnrErronesDonnees") != null) {
		// Si max-height non reconnu (ou si ie6)
		if (document.getElementById("divEnrErronesDonnees").style.maxHeight == null) {
			// Si la taille dépasse la taille max
			if ((document.getElementById("divEnrErronesDonnees").offsetHeight) > 100) {
				document.getElementById("divEnrErronesDonnees").style.height = '100px';
			}
		}
		
		// Ajustement de la taille du premier tableau
		//document.getElementById("tabEnrErronesTitres").setAttribute("width", parseInt(document.getElementById("tabEnrErronesDonnees").offsetWidth));
	}
}

function TraitementInitial() {
	MessageInitial();
	AjusterTaille();
}

function Verifier(form, bouton, flag)
{
  blnVerification = flag;
}

/* Envoie du fichier choisi au serveur */
function EnvoyerAuServeur()
{
	document.getElementsByName("boutonEnvoyerAuServeur")[0].disabled = true;
	document.editerProfilsForm.action.value = "envoyerAuServeur";
	document.editerProfilsForm.submit();
}

function LancerEdition()
{
	document.getElementsByName("boutonValider")[0].disabled = true;
	document.editerProfilsForm.action.value = "lancerEdition";
	document.editerProfilsForm.submit();
}

/* UPLOAD : verification EXTENSION */
function VerifierExtension(champInputFile, extensionsok) {
	var valeur = champInputFile.value.toLowerCase(); // en minuscule
	var chainearray = valeur.split('.');
	var chaineext = chainearray[chainearray.length-1]; // extension du fichier
	if(extensionsok.indexOf(chaineext)==-1) { // extension non valide
		alert('Ce fichier n\'est pas valide.\nExtension acceptée : ' + extensionsok + '.');
		// Désactivation du bouton "Envoyer au Serveur"
		document.getElementsByName("boutonEnvoyerAuServeur")[0].disabled = true;
		// Réinitialisation du formulaire
		document.editerProfilsForm.reset();
		// Réinitialisation de l'écran ou désactivation du bouton Valider si présent 
		// afin de ne pas permettre l'édition de rapports si le champ file n'est pas valide
	}
	else {
		// Activation du bouton "Envoyer au Serveur"
		document.getElementsByName("boutonEnvoyerAuServeur")[0].disabled = false;
	}
};

</script>
<!-- #EndEditable --> 


</head>

<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
<div id="mainContainer">
<div id="topContainer" style="min-height:98%;">
<div id="entete"></div>
<div id="logo">
		<div id="logo_sg"><img src="../images/logo_SG.gif" width="162" height="33" border="0" /></div>
		<div id="nomdusite"><img src="../images/bip_logo.png" width="78" height="46" border="0" /></div>
</div>
<div style="display:none;" id="ajaxResponse"></div>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
       <tr> 
          <td>&nbsp;</td>
        </tr>
		<tr> 
		  <td> 
             <div id="outils" align="center"><!-- #BeginEditable "barre_haut" --> 
             <%ToolBarNew tb = new com.socgen.ich.ihm.ToolBarNew("bip_ihm",false,false,true,true,false,false,false,false,false,request) ;%>
				<%=tb.printHtml()%><!-- #EndEditable -->
				</div>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" --><%=sTitre%><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> 
            
          </td>
        </tr>
        <tr> 
          <td>
		  	<!-- #BeginEditable "debut_form" --><html:form action="/editerProfilsNew" enctype="multipart/form-data"><!-- #EndEditable -->
			<!-- #BeginEditable "debut_hidden" -->
				<html:hidden property="arborescence" value="<%= arborescence %>"/>
				<html:hidden property="jobId" value="<%= sJobId %>"/>
				<html:hidden property="pageAide" value="<%= sPageAide %>"/>
				<html:hidden property="initial" value="<%= sInitial %>"/>
				<html:hidden property="action"/>
				<input type="hidden" name="nomAttributSessionIdRessValides" value="<bean:write name="editerProfilsForm"  property="nomAttributSessionIdRessValides" />"/>
				
			<!-- #EndEditable -->
            <table align="center" border="0">
           		<tr>
          			<td>&nbsp;  
          			</td>
        		</tr>
           		<tr> 
          			<td>  
					  	<html:file onkeydown="blur()" property="fichierCsv" accept="csv" size="47" onchange="VerifierExtension(this,'csv')"/>
                 	</td>
                 	<td>
						<html:button property="boutonEnvoyerAuServeur" value="Envoyer au Serveur" disabled="true" styleClass="input" onclick="EnvoyerAuServeur();"/>
					</td>
                </tr>
                <tr>
          			<td>&nbsp;  
          			</td>
        		</tr>
                <tr> 
                  <td colspan=2> 
                     <div align="center">
						<table border="0" cellspacing="0" cellpadding="2" class="tableBleu" style="border:solid 1px solid">
							<tr>
		                    	<td colspan="2" align="left" class="lib"><b>Bilan :</b></td>
		                    </tr>
		                    <!-- Si un envoi au serveur a été effectué -->
						  	<logic:notEmpty name="editerProfilsForm" property="statut"> 
							  	<tr>
			                       <td align="left" class="texte">Format et contenu du fichier :</td>
			                       <td class="texte"><bean:write name="editerProfilsForm"  property="statut" /></td>
			                    </tr>
			                    <tr>
			                       <td align="left" class="texte">Nombre d'enregistrements lus au total :</td>
			                       <td class="texte"><bean:write name="editerProfilsForm"  property="nbEnregistrementsLus" /></td>
			                    </tr>
			                    <tr>
			                       <td align="left" class="texte">Identifi&eacute;s Bip :</td>
			                       <td class="texte"><bean:write name="editerProfilsForm"  property="nbEnregistrementsIdentifiesBip" /></td>
			                    </tr>
			                    <tr>
			                       <td align="left" class="texte">
				                       <logic:notEmpty name="editerProfilsForm" property="enregistrementsErrones"> 
					                       <b>
					                   </logic:notEmpty>
					                   Non identifi&eacute;s Bip :
					                   <logic:notEmpty name="editerProfilsForm" property="enregistrementsErrones"> 
					                       </b>
				                       </logic:notEmpty>
			                       </td>
			                       <td class="texte">
			                       		<logic:notEmpty name="editerProfilsForm" property="enregistrementsErrones"> 
					                       <b>
					                    </logic:notEmpty>
			                       		<bean:write name="editerProfilsForm"  property="nbEnregistrementsNonIdentifiesBip" />
			                       		<logic:notEmpty name="editerProfilsForm" property="enregistrementsErrones"> 
					                       </b>
				                       </logic:notEmpty>
			                       </td>
			                    </tr>
		                    </logic:notEmpty>
				   		</table>
					 </div>
                  </td>
                </tr>
                <tr>
          			<td colspan=2>&nbsp;  
          			</td>
        		</tr>
        		<!-- Si des enregistrements sont erronés : zone des erreurs -->
        		<logic:notEmpty name="editerProfilsForm" property="enregistrementsErrones"> 
	        		<tr> 
		                <td colspan=2> 
		                    <div align="center">
			        			<table border=0 cellspacing=0 cellpadding=2 class="tableBleu" style="border:solid 1px solid">
				        			<tr align="center">
				                    	<td align="center" style="padding-right : 10px;" class="texte"><b>ID_RESSBIP</b></td>
				                    	<td align="center" style="padding-left : 10px;" class="texte"><b>ID_RTFE</b></td>
				                    	<% 
				                    	int nbColonnesTabEnrErr = 2;
				                    	// Si le nombre d'enregistrements erronés > 6 (S'il y a une barre de défilement verticale)
				                    	// NB : 6 dépend de la valeur de max-height
				                    	if (editerProfilsForm.getEnregistrementsErrones().size() > 6) {
				                    		nbColonnesTabEnrErr = 3;
				                    	%>
				                    	<td style="width:18px" class="texte"></td>
				                    	<% 
				                    	} 
				                    	%>
				                    </tr>
				                    <tr>
										<td colspan=<%= nbColonnesTabEnrErr %>>
											<div id="divEnrErronesDonnees" style="max-height:100px; overflow-y:auto;">
							        			<table id="tabEnrErroneDonnees" border=0 cellspacing=0 cellpadding=2 class="tableBleu">
								        			<logic:iterate name="editerProfilsForm" property="enregistrementsErrones" id="listeEnregErrId">
								        				<tr align="center">
								                    		<td style="padding-right : 10px;" width="80">
								                    			<bean:write name="listeEnregErrId" property="idRessourceBip" ignore="true"/>
								                    		</td>
								                    		<td style="padding-left : 10px;" width="80">
								        						<bean:write name="listeEnregErrId" property="idRtfe" ignore="true"/>
								                    		</td>
								                    	</tr>
								        			</logic:iterate>	
								        		</table>	
								        	</div>
					                    </td>
									</tr>
				        		</table>
				        	</div>
                  		</td>
                	</tr>
                	<tr>
	          			<td colspan=2>&nbsp;  
	          			</td>
	        		</tr>
        		</logic:notEmpty>
        		<div align="center">
	        		<!-- Si statut OK -->
	        		<logic:equal name="editerProfilsForm" property="statut" value="<%= EditerProfilsForm.statutOk %>"> 
	        		<tr>&nbsp;</tr>
	        		<tr>&nbsp;</tr>
		        		<tr align="center">
		          			<td colspan=2 class="texte">
		          				<b><font size="3">Lancement de l'&eacute;dition des Profils Bip ?</font></b>
		          			</td>
		        		</tr>
		        		<tr>&nbsp;</tr>
		        		<tr>&nbsp;</tr>
		        		<tr>
	          				<td colspan=2>&nbsp;  
	          				</td>
	        			</tr>
		        	</logic:equal>
	        		<tr align="center">
	        			<td colspan=2>
		        			<logic:equal name="editerProfilsForm" property="statut" value="<%= EditerProfilsForm.statutOk %>"> 
			          			<html:button property="boutonValider" value="Valider" styleClass="input" onclick="LancerEdition();"/>
		          			</logic:equal>
	          				<html:button property="boutonAnnuler" value="Annuler" styleClass="input" onclick="window.location.href='/listeFavoris.do?arborescence=Menu Client/Favoris&sousMenu=&pageAide=/jsp/aide/Guide_Menu_Client.doc&addFav=no&action=initialiser&titlePage=Liste+des+favoris&lienFav=%2FlisteFavoris.do'"/>
	          			</td>
	        		</tr>
        		</div>
            </table>
			  <!-- #BeginEditable "fin_form" --></html:form><!-- #EndEditable -->
          </td>
        </tr>
		<tr> 
          <td>&nbsp;  
          </td>
        </tr>
        <tr> 
          <td> 
            <div align="center"><html:errors/><!-- #BeginEditable "barre_bas" --><!-- #EndEditable --></div>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</div>
</div>
</body>
</html:html>

<!-- #EndTemplate -->