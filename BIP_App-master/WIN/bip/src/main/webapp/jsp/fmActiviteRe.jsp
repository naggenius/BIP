 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="activiteForm" scope="request" class="com.socgen.bip.form.ActiviteForm" />
<jsp:useBean id="listeActivites" scope="session"	class="com.socgen.ich.ihm.menu.PaginationVector" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>


 <!-- #BeginEditable "doctitle" --> 
<title>Outil de r&eacute;estim&eacute;</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/bActiviteRe.jsp"/> 
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
   var Message="<bean:write filter="false"  name="activiteForm"  property="msgErreur" />";
   if (Message != "") {
      alert(Message);
   }
   //var code_activite = "<bean:write name="activiteForm"  property="code_activite"/>";
   //if (code_activite != "") {
     //document.forms[0].code_activite.value = code_activite;
   //}
   //else
   //{
   	//	document.forms[0].code_activite_choisi.value = "";
   	//	if(document.forms[0].code_activite_choisi[0])
   	//	{
   	//		document.forms[0].code_activite_choisi[0].checked=true;
   	//	}
   //}
}


function Verifier(form, action)
{
  form.action.value = action;
}

function ChangeCodeAct(form, value)
{
	form.code_activite_choisi.value = value;
}

function ValiderEcran(form)
{
	if (form.action.value == 'modifier') 
	{
	    
        if (form.code_activite_choisi.value == null)
        { 
        	alert("Choisissez une activité à modifier");
        	return false;
        }
    }
    
    if (form.action.value == 'supprimer') 
    {
        
     	if (form.code_activite_choisi.value == null)
        { 
        	alert("Choisissez une activité à supprimer");
        	return false;
        }
    }
     
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
          <td height="20" class="TitrePage">Liste des activit&eacute;s</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> </td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/activite" onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
					 <input type="hidden" name="pageAide" value="<%= sPageAide %>">
                     <html:hidden property="action"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
                     <html:hidden property="page" value="creer"/>
                     <input type="hidden" name="index" value="creer">
                     <%
    			  		if(activiteForm.getCode_activite() != null)
    			  		{
    			  	%>
    			  		<html:hidden name="activiteForm" property="code_activite"/>
    			  	<%
    			  		}
    			  	%>
    			  	
    			  	
                     
				    <table border=0 cellspacing=2 cellpadding=2 class="TableBleu">
                      <tr>
                        <td  class="lib"><b>Code D&eacute;partement/P&ocirc;le/Groupe : </b></td>
                        <td colspan=3 >
                        	<b><bean:write name="activiteForm" property="codsg"/></b>
                        	<html:hidden property="codsg"/>
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
                        <td class="lib"><B>Activit&eacute;</B></td>
                        <td class="lib">&nbsp;</td>
                        <td class="lib"><B>Libellé</B></td>
                        <td class="lib">&nbsp;</td>
                      </tr>
             <% 
				int i = 0;
			   String[] strTabCols = new String[] {  "fond1" , "fond2" }; %>
			<logic:iterate id="element" name="listeActivites" length="<%=  listeActivites.getCountInBlock()  %>" 
            			offset="<%=  listeActivites.getOffset(0) %>"
						type="com.socgen.bip.metier.Activite"
						indexId="index"> 
			<% 
			 if ( i == 0) i = 1; else i = 0;
			 	%>
					<tr class="<%= strTabCols[i] %>">
						<td>&nbsp;</td>
    			  		<td class="contenu" align="right">
    			  			<%
    			  			if(element.getCode_activite().equals(activiteForm.getCode_activite())
    			  				|| listeActivites.getCountInBlock().equals("1"))
    			  			{
    			  			%>
    			  				<input type="radio" name="code_activite_choisi" value="<bean:write name="element" property="code_activite"/>" checked>
    			  			<%
    			  			}
    			  			else
    			  			{
    			  			%>
    			  				<input type="radio" name="code_activite_choisi"  value="<bean:write name="element" property="code_activite"/>" onclick="ChangeCodeAct(this.form, this.value);" >
    			  			<%
    			  			} 
    			  			%>
    			  			
    			  		</td>
    			  		<td>&nbsp;</td>
						<td class="contenu"><bean:write name="element" property="code_activite" /></td>
    			  		<td>&nbsp;</td>
    			  		<td class="contenu"><bean:write name="element" property="lib_activite" /></td>
    			  		<td>&nbsp;</td>
    			  	</tr>
             </logic:iterate>         
               	</table>
             
             	<table  width="100%" border="0" cellspacing="0" cellpadding="0">
			   	<tr>
					<td align="center" colspan="4" class="contenu">
						<bip:pagination beanName="listeActivites"/>
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
