<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*, com.socgen.ich.ihm.*, com.socgen.bip.form.BUploadAdForm" errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="bUploadAdForm" scope="request" class="com.socgen.bip.form.BUploadAdForm" />
<html:html locale="true">
<!-- #EndEditable --> 

<!-- #BeginTemplate "/Templates/Page_edition.dwt" --><head>

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<!-- #BeginEditable "doctitle" --> 
<title>UPLOAD fichiers métiers</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/bUploadAd.jsp"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
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
	String sInitial;
	String sTitre;
	java.util.ArrayList listRep = com.socgen.bip.commun.liste.ListeStatique.getListeStatiqueUpload("repertoires");
	pageContext.setAttribute("choixRep", listRep);
	
	
%>

function MessageInitial()
{
	<%
		sTitre = "UPLOAD fichiers métiers";
			
		sInitial=ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getQueryString()));
		if (sInitial == null)
			sInitial = request.getRequestURI();
		else
			sInitial = request.getRequestURI() + "?" + sInitial;
		sInitial = sInitial.substring(request.getContextPath().length());
	%>
	
	var Message="<bean:write filter="false"  name="bUploadAdForm"  property="msgErreur" />";
	var Focus = "<bean:write name="bUploadAdForm"  property="focus" />";
	
	if (Message != "") {
		alert(Message);
	}
}


function TraitementInitial() {
	MessageInitial();
}

function Verifier(form, bouton, flag)
{
  blnVerification = flag;
}

/* Envoie du fichier choisi au serveur */
function EnvoyerAuServeur()
{
	
	if (confirm("Confirmez-vous l'upload de ce fichier (opération non réversible)?")) {
		document.getElementsByName("boutonEnvoyerAuServeur")[0].disabled = true;
		document.bUploadAdForm.action.value = "bipPerform";
		document.bUploadAdForm.submit();
		alert("Fichier " + document.getElementsByName("fichier")[0].value + " uploadé dans le répertoire " + document.getElementsByName("repDest")[0].value);
	}
}

function ActiverBouton(){
	if(document.getElementsByName("fichier")[0].value != null && document.getElementsByName("fichier")[0].value != '' 
		&& document.getElementsByName("repDest")[0].value != null && document.getElementsByName("repDest")[0].value != 0)
		document.getElementsByName("boutonEnvoyerAuServeur")[0].disabled = false;
	else
		document.getElementsByName("boutonEnvoyerAuServeur")[0].disabled = true;
}

</script>
<!-- #EndEditable --> 


</head>

<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="TraitementInitial();">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
       <tr> 
          <td>&nbsp;</td>
        </tr>
		<tr> 
		  <td> 
            <div align="center"><!-- #BeginEditable "barre_haut" -->
              <%ToolBar tb = new com.socgen.ich.ihm.ToolBar("bip_ihm",false,false,true,false,false,false,false,false,false,request) ;%>
				<%=tb.printHtml()%><!-- #EndEditable --></div>
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
		  	<!-- #BeginEditable "debut_form" --><html:form action="/uploadFicMetiers" enctype="multipart/form-data"><!-- #EndEditable -->
			<!-- #BeginEditable "debut_hidden" -->
				<html:hidden property="initial" value="<%= sInitial %>"/>
				<html:hidden property="arborescence" value="<%= arborescence %>"/>
				<html:hidden property="pageAide" value="<%= sPageAide %>"/>
				<!-- html:hidden property="action"/-->
				
				
			<!-- #EndEditable -->
            <table align="center" border="0">
            	<tr>
            		<td>&nbsp;</td>
            	</tr>
           		<tr>
          			<td><p><b>ATTENTION : </b></p></td><td><p>La suppression n'est actuellement pas implémentée</p></td>          			
        		</tr>
        		<tr>
        			<td>&nbsp;</td><td><p>En cas de doute contacter la ME</p></td>
        		</tr>
        		<tr>
          			<td>&nbsp;  
          			</td>
        		</tr>
           		<tr>
           			<td class="lib">
           				Fichier :
           			</td>
          			<td>  
					  	<html:file onkeydown="blur()" property="fichier" onchange="ActiverBouton()" size="40"/>
                 	</td>
                 	<td>
						
					</td>
                </tr>
                <tr> 
                	<td class="lib">
                		Répertoire cible :
                	</td>
          			<td>  
					  	<html:select property="repDest" styleClass="input" onchange="ActiverBouton()"> 
					      <html:options collection="choixRep"  property="cle" labelProperty="libelle"/>
					  	</html:select>
                 	</td>
                 	<td>
						&nbsp;
					</td>
                </tr>
                <tr>
          			<td>&nbsp;  
          			</td>
        		</tr>
        		<tr>
        			<td>
        				<html:button property="boutonEnvoyerAuServeur" value="Envoyer au Serveur" disabled="true" styleClass="input" onclick="EnvoyerAuServeur();"/>
        			</td>
        			<td>
        				<html:button property="boutonAnnuler" value="Annuler" styleClass="input" onclick="window.location.href='/listeFavoris.do?arborescence=Menu Client/Favoris&sousMenu=&pageAide=/jsp/aide/Guide_Menu_Client.doc&addFav=no&action=initialiser&titlePage=Liste+des+favoris&lienFav=%2FlisteFavoris.do'"/>
        			</td>
        		</tr>               
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
</body>
</html:html>

<!-- #EndTemplate -->