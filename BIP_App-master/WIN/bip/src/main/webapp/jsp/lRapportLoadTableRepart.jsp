
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %><html:html locale="true">
<jsp:useBean id="rapportTableRepForm" scope="request" class="com.socgen.bip.form.RapportTableRepartForm" />
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" -->
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="/rapportTabRepartJH.do"/>
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
   var Message = "";
   var Focus = "";
   if (Message != "") {
      alert(Message);
   }
}

function Valider(form, action, p_codchr)
{
   form.codchr.value = p_codchr;
   form.action.value = action;
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
          <td height="20" class="TitrePage">
              Rapport sur les chargements des tables de r&eacute;partition JH
		  </td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> 
            
          </td>
        </tr>
		<tr><td>&nbsp;</td></tr>
        <tr> 
          <td>
		    <!-- #BeginEditable "debut_form" -->
		  	<html:form action="/rapportTabRepartJH">
		  	<!-- #EndEditable -->
            <table width="100%" border="0">
              
                
              <tr> 
                  
                <td> 
                    
                  <div align="center"><!-- #BeginEditable "contenu" -->
					<input type="hidden" name="pageAide" value="<%= sPageAide %>">
					<input type="hidden" name="codchr" value="">
			  		<html:hidden property="titrePage"/>
              		<html:hidden property="action"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>

					
		<table cellspacing="0" border="0" width="680" class="tableBleu">
			<tr>
				<td colspan="6">
				<div align="center">
				<html:submit value="Rafraîchir" styleClass="input" onclick="Valider(this.form, 'refresh', '');"/>
				&nbsp;&nbsp;&nbsp;&nbsp;
				<html:submit value="Purger" styleClass="input" onclick="Valider(this.form, 'purger', '');"/></div>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>				
				<td width="100" class="lib"><b>Code Table</b></td>
				<td width="60" class="lib"><b>Mois</b></td>
				<td width="180" class="lib"><b>Fichier</b></td>
				<td width="150" class="lib"><b>Statut</b></td>
				<td width="120" class="lib"><b>Date Statut</b></td>
				<td width="70" class="lib"><b>Supprimer</b></td>
			</tr>
<%		for (int ind=0; ind<rapportTableRepForm.getListeChg().size(); ind++ ) {
			int    codchr  = rapportTableRepForm.getCodchr(ind);
			String codrep  = rapportTableRepForm.getCodrep(ind);
			String moisrep = rapportTableRepForm.getMoisrep(ind);
			String fichier = rapportTableRepForm.getNomFichier(ind);
			int    statut  = rapportTableRepForm.getStatut(ind);
			String datechg = rapportTableRepForm.getDatechg(ind);
%>
			<tr>				
				<td width="100"><%=codrep%></td>
				<td width="60"><%=moisrep%></td>
				<td width="180">
<%			if (statut>0) { %>
					<a href="/rapportTabRepartJH.do?action=detail&codchr=<%=codchr%>&codrep=<%=codrep%>&moisrep=<%=moisrep%>" onmouseover="window.status='';return true">
						<%=fichier%>
					</a>
<%			} else { %>
					<%=fichier%>
<%			} %>
				</td>
				<td width="150">
<%			if (statut==0) { %>
				<img src="/images/imageENCOURS.bmp" border=0>&nbsp;Traitement en cours
<%			} else if (statut==1) { %>
				<img src="/images/imageOK.bmp" border=0>&nbsp;Fichier valide
<%			} else if (statut==8) { %>
				<img src="/images/imageOK.bmp" border=0>&nbsp;Valide avec messages
<%			} else if (statut==9) { %>
				<img src="/images/imageKO.bmp" border=0>&nbsp;Fichier invalide
<%			} else { %>
				Statut inconnu
<%			} %>
				</td>
				<td width="120"><%=datechg%></td>
				<td width="70">
<%			if (statut==0) { %>
					&nbsp;
<%			} else { %>
					<input type="submit" value="Supprimer" onclick="Valider(this.form, 'supprimer', '<%=codchr%>');" class="input">
<%			} %>
				</td>
			</tr>
<%
		}
%>
			<tr><td>&nbsp;</td></tr>
			<tr><td>&nbsp;</td></tr>
		</table>
					<!-- #EndEditable --></div>
                </td>
              </tr>
            
            </table>
            <!-- #BeginEditable "fin_form" --></html:form><!-- #EndEditable -->
          </td>
        </tr>
		<tr><td>&nbsp;</td></tr>
        <tr> 
          <td> 
            <div align="center"><html:errors/><!-- #BeginEditable "barre_bas" --><!-- #EndEditable --></div>
          </td>
        </tr>
		<tr><td>&nbsp;</td></tr>
      </table>
    </td>
  </tr>
</table>
</body></html:html>

<!-- #EndTemplate -->
