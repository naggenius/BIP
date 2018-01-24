<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="parametreForm" scope="request" class="com.socgen.bip.form.ParametreForm" />
<html:html locale="true"> 

<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<title>Page BIP</title>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<bip:VerifUser page="jsp/fmParametreAd.jsp"/> 
<%
	boolean bListe = true;
  
	java.util.Vector vValeurs = com.socgen.bip.commun.bd.ParametreBD.getListeValeurs(ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("cle_param"))));
	if (vValeurs == null)
	{
		bListe = false;
	}
	else
	{
		pageContext.setAttribute("vValeurs", vValeurs);
	}
	
 %>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";


function MessageInitial()
{
   var Message="<bean:write filter="false"  name="parametreForm"  property="msgErreur" />";
   var Focus = "<bean:write name="parametreForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
}

function Verifier(form, action, mode,flag)
{
   blnVerification = flag;
   form.action.value = action;
}

function ValiderEcran(form)
{
  if (blnVerification == true) {
	   for(i=0;i<document.getElementsByName("valeur_param").length;i++){	   		
	   		if(document.getElementsByName("valeur_param")[i].checked){
	   			if(document.getElementsByName("valeur_param")[i].value == 'BLOQUEE'){
	   				if (!confirm("		           RAPPEL :\n\nil faut créer une actualité de type Dernière minute pour Bip bloquée,\n                de préférence avant de bloquer l'application.\n\n     Etes-vous sûr de vouloir bloquer la Bip tout de suite?")) return false;
	   			}else{
	   				if (!confirm("Etes-vous sûr de vouloir effecuer cette mise à jour?")) return false;
	   			}
	   		}
	   }
  }
   return true;
}
</script>
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
          <td height="20" class="TitrePage">Modifier un état de la BIP</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> 
          	<html:form action="/parametre"  onsubmit="return ValiderEcran(this);">
            <div align="center">
			<input type="hidden" name="pageAide" value="<%= sPageAide %>">
		  	<html:hidden property="titrePage"/>
			<html:hidden property="action"/>
			<html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
			<html:hidden property="listeValeurs"/>
			<html:hidden property="libelle"/>
		<table cellspacing="2" cellpadding="2" class="tableBleu">
		<tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp; </td>
                </tr>
                <tr>
                	<td colspan="2">
                		<b><bean:write name="parametreForm" property="libelle"/></b>
                	</td>
                </tr>
                <tr> 
                  <td class="lib"><b>Variable à modifier</b></td>
                  <td> 
                    <bean:write name="parametreForm" property="cle_param"/>
                    <html:hidden property="cle_param"/> 
                  </td>
                </tr>
                <tr> 
                  <td class="lib"><b>Valeur de la variable</b></td>
                  <td>
					<% if (bListe == false)
					{ %>
                  		<html:text property="valeur_param" styleClass="input" size="20" maxlength="256"/>
					<%
					}
					else
					{ %>
						<table>					
						<logic:iterate id="element" name="vValeurs" scope="page">
							<tr><td><html:radio property="valeur_param" value="<%=element.toString()%>"/> <bean:write name="element"/></td></tr>
						</logic:iterate>
						</table>
					<%
					} %>
                  </td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
              </table>
			  </div>
          </td>
        </tr>
        <tr> 
          <td align="center"> 
            <table width="100%" border="0">
              <tr> 
                <td width="25%">&nbsp;</td>
                <td width="25%"> 
                  <div align="center"> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', this.form.mode.value,true);"/> 
                  </div>
                </td>
                <td width="25%"> 
                  <div align="center"> <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', null, false);"/> 
                  </div>
                </td>
                <td width="25%">&nbsp;</td>
              </tr>
            </table>
            </html:form>
          </td>
        </tr>
        <tr> 
          <td>&nbsp; </td>
        </tr>
        <tr> 
          <td> 
            <div align="center"><html:errors/></div>
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
<% 
Integer id_webo_page = new Integer("1062"); 
com.socgen.bip.commun.form.AutomateForm formWebo = parametreForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>