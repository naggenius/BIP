 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="ressReesForm" scope="request" class="com.socgen.bip.form.RessReesForm" />
<jsp:useBean id="listeRessRees" scope="session"	class="com.socgen.ich.ihm.menu.PaginationVector" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>


 <!-- #BeginEditable "doctitle" --> 
<title>Outil de r&eacute;estim&eacute;</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/bRessourceRe.jsp"/> 

<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";


function MessageInitial()
{
   var Message="<bean:write filter="false"  name="ressReesForm"  property="msgErreur" />";
   
   if (Message != "") {
      alert(Message);
   }
   //var ident = "<bean:write name="ressReesForm"  property="ident"/>";
   //if (ident != "") {
     //document.forms[0].ident.value = ident;
   //}
   //else
   //{
   	//document.forms[0].ident_choisi.value = "";
   		//if(document.forms[0].ident_choisi[0])
   		//{
   			//document.forms[0].ident_choisi[0].checked=true;
   		//}
   //}
}


function Verifier(form, action)
{
  form.action.value = action;
}

function ChangeIdent(form, value)
{
  form.ident_choisi.value = value;
    
 }

function ValiderEcran(form)
{
	if (form.action.value == 'modifier') 
	{
      
        if (form.ident_choisi.value == null)
        { 
        	alert("Choisissez une ressource à modifier");
        	return false;
        }
    }
    
    if (form.action.value == 'supprimer') 
    {
		if (form.ident_choisi.value == null)
        { 
        	alert("Choisissez une ressource à supprimer");
        	return false;
        }
    }
    
    if (form.action.value =='initialiser') {
		if (!confirm('La liste va être initialisée.\nVoulez-vous continuer ?')) return false;
	}
     
    return true;
}

function init(form){
 form.action.value="initialiser";
 form.submit();
 return true;
}

function paginer(page, index , action){
	document.forms[0].action.value =action;
	document.forms[0].page.value=page;
    document.forms[0].index.value=index;
    document.forms[0].submit();
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
          <td height="20" class="TitrePage">Liste des ressources</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" -->
          	<html:form action="/ressRees" onsubmit="return ValiderEcran(this);" >
          		<!-- #EndEditable --> 
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
					 <input type="hidden" name="pageAide" value="<%= sPageAide %>">
                     <html:hidden property="action"/>
                     <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
                     <html:hidden property="page" value="creer"/>
                     <input type="hidden" name="index" value="creer">
                   	                    
                     	
                     	<%
    			  		if(ressReesForm.getIdent() != null)
    			  		{
    			  	%>
    			  		<html:hidden property="ident"/>
    			  	<%
    			  		}
    			  	%>
    			  	  	
                                          
				    <table border=0 cellspacing=2 cellpadding=2 class="TableBleu">
                      <tr>
                        <td  class="lib"><b>Code D&eacute;partement/P&ocirc;le/Groupe : </b></td>
                        <td colspan=3 >
                        	<b><bean:write name="ressReesForm" property="codsg"/></b>
                        	<html:hidden property="codsg"/>
                        </td>
                        <td align="right">
                        	<html:submit property="boutonInitialiser" value="Initialiser" styleClass="input" onclick="init(this.form);"/>
                        </td>
                      </tr>
                      <tr>
                        <td colspan=6>&nbsp;</td>
                      </tr>
                    </table>
                <table border=0 cellspacing=0 cellpadding=2 class="TableBleu">
                      <tr class="titreTableau">
                      	<td class="lib">&nbsp;</td>
                        <td class="lib">&nbsp;</td>
                        <td class="lib">&nbsp;</td>
                        <td class="lib"><B>Code DPG</B></td>
                        <td class="lib">&nbsp;</td>
                        <td class="lib"><B>Ident</B></td>
                        <td class="lib">&nbsp;</td>
                        <td class="lib"><B>Type</B></td>
                        <td class="lib">&nbsp;</td>
                        <td class="lib"><B>Nom</B></td>
                        <td class="lib">&nbsp;</td>
                        <td class="lib"><B>Prenom</B></td>
                        <td class="lib">&nbsp;</td>
                        <td class="lib"><B>Date d'arriv&eacute;e</B></td>
                        <td class="lib">&nbsp;</td>
                        <td class="lib"><B>Date de départ</B></td>
                        <td class="lib">&nbsp;</td>
                      </tr>
             <% int i = 0;
			   String[] strTabCols = new String[] {  "fond1" , "fond2" }; %>
			<logic:iterate id="element" name="listeRessRees" length="<%=  listeRessRees.getCountInBlock()  %>" 
            			offset="<%=  listeRessRees.getOffset(0) %>"
						type="com.socgen.bip.metier.RessRees"
						indexId="index"> 
			<% 
			if ( i == 0) i = 1; else i = 0;
			 %>
					<tr class="<%= strTabCols[i] %>">
						<td>&nbsp;</td>
    			  		<td class="contenu" align="right">
    			  			<%
    			  			if(element.getIdent().equals(ressReesForm.getIdent()))
    			  			{
    			  			%>
    			  				<input type="radio" name="ident_choisi" onclick="return ChangeIdent(this.form, this.value);" value="<bean:write name="element" property="ident"/>" checked>
    			  			<%
    			  			}
    			  			else
    			  			{
    			  			%>
    			  				<input type="radio" name="ident_choisi" onclick="return ChangeIdent(this.form, this.value);" value="<bean:write name="element" property="ident"/>">
    			  			<%
    			  			}
    			  			%>
    			  			
    			  		</td>
    			  		<td>&nbsp;</td>
						<td class="contenu"><bean:write name="element" property="codsg" /></td>
    			  		<td>&nbsp;</td>
						<td class="contenu"><bean:write name="element" property="code_ress" /></td>
    			  		<td>&nbsp;</td>
    			  		<td class="contenu"><bean:write name="element" property="type" /></td>
    			  		<td>&nbsp;</td>
    			  		<td class="contenu"><bean:write name="element" property="rnom" /></td>
    			  		<td>&nbsp;</td>
    			  		<td class="contenu"><bean:write name="element" property="rprenom" /></td>
    			  		<td>&nbsp;</td>
    			  		<td class="contenu"><bean:write name="element" property="datarrivee" /></td>
    			  		<td>&nbsp;</td>
    			  		<td class="contenu"><bean:write name="element" property="datdep" /></td>
    			  		<td>&nbsp;</td>
    			  	</tr>
             </logic:iterate> 
             </table>
             
             	<table  width="100%" border="0" cellspacing="0" cellpadding="0">
			   	<tr>
					<td align="center" colspan="4" class="contenu">
						<bip:pagination beanName="listeRessRees"/>
					</td>
				</tr>
	 			<tr><td colspan="4">&nbsp;
	 			</tr>
	 			<tr>
              		<td width="25%">
						<div align="center">
                	  <html:submit property="boutonCreer" value="Créer" styleClass="input" onclick="Verifier(this.form, 'creer');"/>
                	 </div>
					</td>
                	<td width="25%">
                	 <div align="center">
                	 	
                	  <html:submit property="boutonModifier" value="Modifier" styleClass="input" onclick="Verifier(this.form, 'modifier');"/>
                	  
                	 </div>
               		</td> 
               		<td width="25%">
                	 <div align="center">
                	  <html:submit property="boutonSupprimer" value="Supprimer" styleClass="input" onclick="Verifier(this.form, 'supprimer');"/>
                	 </div>
               		</td> 
               		<td width="25%"> 
                  	 <div align="center"> 
                	  <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler');"/>
              		 </div>
                	</td>
            	</tr>
     
				</table>
                    <!-- #EndEditable --></div>
                </td>
              </tr>
            </table>
            <!-- #BeginEditable "fin_form" --></html:form><!-- #EndEditable --> 
          </td>
        </tr>
        <tr> 
          <td>&nbsp; </td>
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
</body></html:html>
<!-- #EndTemplate -->
