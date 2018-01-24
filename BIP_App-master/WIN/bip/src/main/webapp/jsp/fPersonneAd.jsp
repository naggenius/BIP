<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="personneForm" scope="request" class="com.socgen.bip.form.PersonneForm" />
<html:html locale="true">
<!-- #EndEditable --> 
 
<!-- #BeginTemplate "/Templates/Page_edition.dwt" --><head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<!-- #BeginEditable "doctitle" --> 
<title>Edition</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!-- #BeginEditable "fichier" --> 
  
<bip:VerifUser page="jsp/consultationRess.jsp"/>

<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">

<script language="JavaScript">
var pageAide = "aide/hvide.htm";
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
	String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
   
    String Rtype = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("rtype")));
	String Titre="";
		
    if(Rtype.equals("A"))
    	Titre="Gestion des Agents SG : recherche";
    else if(Rtype.equals("P")) {
		   Titre = "Gestion des Prestations : recherche"; 
    }
    
%>
var pageAide = "<%= sPageAide %>";


function MessageInitial()
{	
	var Message="<bean:write filter="false"  name="personneForm"  property="msgErreur" />";
		
	if (Message != "") {
		alert(Message);
	}
	setFocusOnInput(document.getElementsByName('igg')[0]);	
}

/**
 * Sets the focus on an input element.
 */
function setFocusOnInput(elt) {
	elt.focus();
}

function Verifier(form, action, mode,flag,etape)
{
   blnVerification = flag;
   form.mode.value = mode;
   form.action.value = action;
   form.etape.value = etape;
}

function ValiderEcran(form)
{
	if(blnVerification){
 
		if( (document.forms[0].igg.value == "" && document.forms[0].matricule.value == "") 
	    	&& (document.forms[0].debnom.value == "" && document.forms[0].nomcont.value == "")
	      )
	    {
			
			alert("Vous devez saisir SOIT un identifiant, SOIT un matricule, SOIT début de nom, SOIT un extrait de nom");
			document.forms[0].igg.value = "";
			document.forms[0].matricule.value = "";
			document.forms[0].nomcont.value = "";
			document.forms[0].debnom.value = "";
			
			document.forms[0].igg.focus();
			
			return false;
		}
		if ( document.forms[0].igg.value != "" ) {
			if ( isNumeric( document.forms[0].igg.value ) == false ) {
				alert('Le code IGG est invalide');
				return false;
			}
			if ( document.forms[0].igg.value.length != 10 ) {
				alert('Le code IGG est invalide');
				return false;			
			}
		}
		
		return true;
	}
}


//Insertion du code permettant de verifier l'heure
function isNumeric(sText)
{
	var ValidChars = "0123456789";
	var IsNumber=true;
	var Char;
	
	for (i = 0; i < sText.length && IsNumber == true; i++)
	{
	Char = sText.charAt(i);
	if (ValidChars.indexOf(Char) == -1)
	{
	IsNumber = false;
	}
	}
	return IsNumber;
}

</script>
<!-- #EndEditable --> 


</head>

<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
       <tr> 
          <td>&nbsp;</td>
        </tr>
		<tr > 
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" --><%= Titre %><!-- #EndEditable --></td>
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
		  <!-- #BeginEditable "debut_form" -->
		  <html:form action="/personne" onsubmit="return ValiderEcran(this);"><!-- #EndEditable -->
			<!-- #BeginEditable "debut_hidden" -->
		  	<input type="hidden" name="pageAide" value="<%= sPageAide %>">
			<html:hidden property="action"/>
			<html:hidden property="mode"/>
			<html:hidden property="arborescence" value="<%= arborescence %>"/>
			<html:hidden property="page" value="modifier"/>
			<input type="hidden" name="index" value="modifier">		
			<input type="hidden" name="rtype" value="<%= Rtype %>">
			<html:hidden property="soccode"/>
			<html:hidden property="etape"/>
						
			<!-- #EndEditable -->
            <table width="100%" border="0">
                <tr> 
                  <td> 
                    <div align="center">
					<table border=0 cellspacing=2 cellpadding=2 class="tableBleu">
					<!-- #BeginEditable "contenu" -->
						
						<tr>
	                    	<td colspan=5 align="center">&nbsp;</td>
	                    </tr>
						<tr>
							<td class="lib">Identifiant IGG :</td>
							<td><html:text styleClass="input" property="igg" size="20"/></td>
						</tr> 
					    <tr>
							<td class="lib">Matricule Arpège  :</td>
							<td><html:text styleClass="input" property="matricule" size="20"/></td>
						</tr>
					    <tr>
							<td class="lib">Début du nom  :</td>
							<td><html:text styleClass="input" property="debnom" size="20"/></td>
						</tr>						
					    <tr>
							<td class="lib">Nom contient :</td>
							<td><html:text styleClass="input" property="nomcont" size="20"/></td>
						</tr>
												
					</table>
					<table>
					<!-- #EndEditable -->
			   		</table>
					</div>
                  </td>
                </tr>
				<tr> 
          		  <td>&nbsp;  
          		  </td>
        		</tr>
                <tr> 
	                <td> 
	                <div align="center">
					<table border=0 cellspacing=2 cellpadding=2 class="tableBleu">
					<tr>
					<td>	
	                  <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'suite1', 'insert',true, 'recherche2');"/> 
	                </td>
	                <td>&nbsp;&nbsp;  
          		  	</td>
	                <td>
	                  <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler',this.form.mode.value, false, '');"/> 
	                </td>
	                </tr>
	                </table>
	                </div>
	                </td>
                </tr>
            
            </table>
			  <!-- #BeginEditable "fin_form" -->
			  </html:form>
			  <!-- #EndEditable -->
          </td>
        </tr>
		
        <tr> 
          <td> 
            <div align="center"><html:errors/><!-- #BeginEditable "barre_bas" --><!-- #EndEditable --></div>
          </td>
        </tr>
        
      </table>
    </td>
  </tr>
</table>
</body>
</html:html>
<% 
Integer id_webo_page = new Integer("1003"); 
com.socgen.bip.commun.form.AutomateForm formWebo = personneForm ;
%>
<%@ include file="/incWebo.jsp" %>
<!-- #EndTemplate -->