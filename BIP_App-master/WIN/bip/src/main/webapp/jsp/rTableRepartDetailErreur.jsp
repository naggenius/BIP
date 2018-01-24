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
<%	int p_codchr = rapportTableRepForm.getCodchr();
	int statut = rapportTableRepForm.getStatut(); 
	if ( (statut==1) || (statut==8) ) { %>
              R&eacute;capitulatif des donn&eacute;es charg&eacute;es
<%	} else { %>
              Liste des erreurs du chargement
<%	} %>
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
              		<html:hidden property="action" value="suite"/>
              		
<html:hidden property="arborescence" value="<%= arborescence %>"/>

					
		<table cellspacing="0" border="0" width="610" class="tableBleu">
			<tr>
				<td colspan="5">
				<div align="center">
				<html:submit property="boutonRetour" value="Retour" styleClass="input" />
				</div>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>				
				<td width="100" class="lib"><b>Code Table</b></td>
				<td width="60" class="lib"><b>Mois D&eacute;but</b></td>
				<td width="60" class="lib"><b>Mois Fin</b></td>
				<td width="180" class="lib"><b>Fichier</b></td>
				<td width="150" class="lib"><b>Statut</b></td>
				<td width="120" class="lib"><b>Date Statut</b></td>
			</tr>
			<tr>				
				<td width="100"><%=rapportTableRepForm.getCodrep()%></td>
				<td width="60"><%=rapportTableRepForm.getMoisrep()%></td>
				<td width="60"><%=rapportTableRepForm.getMoisfin()%></td>
				<td width="180"><%=rapportTableRepForm.getNomFichier()%></td>
				<td width="150">
<%			if (statut==0) { %>
				<img src="/images/imageENCOURS.bmp" border=0>&nbsp;Traitement en cours
<%			} else if (statut==1) { %>
				<img src="/images/imageOK.bmp" border=0>&nbsp;Fichier valide
<%			} else if (statut==9) { %>
				<img src="/images/imageKO.bmp" border=0>&nbsp;Fichier invalide
<%			} else { %>
				Statut inconnu
<%			} %>
				</td>
				<td width="120"><%=rapportTableRepForm.getDatechg()%></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td>&nbsp;</td></tr>
		</table>
					<!-- #EndEditable --></div>
                </td>
              </tr>
              
              
<%	if ( (rapportTableRepForm.getErrLigne()!=null) && (rapportTableRepForm.getErrLigne().size()>0) ) { %>
              <tr> 
                  
                <td> 
                    
                  <div align="center"><!-- #BeginEditable "contenu" -->
					
		<table cellspacing="0" border="0" width="680" class="tableBleu">
			<tr>				
				<td width="100" class="lib"><b>Ligne en erreur</b></td>
				<td width="580" class="lib">&nbsp;&nbsp;&nbsp;<b>Description de l'erreur</b></td>
			</tr>
			
<%		for (int ind=0; ind<rapportTableRepForm.getErrLigne().size(); ind++ ) {
			String num = rapportTableRepForm.getNumLigne(ind);
			String txt = rapportTableRepForm.getTxtLigne(ind);
			String err = rapportTableRepForm.getErrLigne(ind);
%>
			<tr>				
				<td colspan="2"><%=num%>&nbsp;:&nbsp;<%=txt%></td>
			</tr>
			<tr>				
				<td width="100">&nbsp;</td>
				<td width="570"><%=err%></td>
			</tr>
<%
		} //END FOR
%>
		</table>
					<!-- #EndEditable --></div>
                </td>
              </tr>

			<tr>
				<td colspan="5">
				<div align="center">
				<html:submit property="boutonRetour" value="Retour" styleClass="input" />
				</div>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
<%	} //END IF sur les erreurs %>


              <tr> 
                  
                <td> 
                    
                  <div align="center"><!-- #BeginEditable "contenu" -->
					
		<table cellspacing="0" border="0" width="680" class="tableBleu">
			<tr>				
				<td width="200" class="lib"><b>Libell&eacute;</b></td>
				<td width="80" class="lib"><b>Taux<br>R&eacute;part.</b></td>
				<td width="80" class="lib"><b>Ligne<br>BIP</b></td>
				<td width="270" class="lib"><b>Libell&eacute; ligne BIP</b></td>
				<td width="80" class="lib"><b>CA</b></td>
				<td width="200" class="lib"><b>Libell&eacute; CA</b></td>
			</tr>
			
<%	if (rapportTableRepForm.getPid()!=null) {
		for (int ind=0; ind<rapportTableRepForm.getPid().size(); ind++ ) {
			String pid    = rapportTableRepForm.getPid(ind);
			String libpid = rapportTableRepForm.getLibPID(ind);
			String taux   = rapportTableRepForm.getTauxrep(ind);
			String lib    = rapportTableRepForm.getLiblignerep(ind);
			String ca     = rapportTableRepForm.getCodcamo(ind);
			String libca  = rapportTableRepForm.getLibCodcamo(ind);
%>
			<tr>				
				<td width="200"><%=lib%></td>
				<td width="80"><%=taux%></td>
				<td width="80"><%=pid%></td>
				<td width="270"><%=libpid%></td>
				<td width="80"><%=ca%></td>
				<td width="200"><%=libca%></td>
			</tr>
<%
		} //END FOR
	} //END IF
%>
			<tr><td>&nbsp;</td></tr>
			<tr><td>&nbsp;</td></tr>
		</table>
					<!-- #EndEditable --></div>
                </td>
              </tr>
            
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td colspan="5">
				<div align="center">
				<html:submit property="boutonRetour" value="Retour" styleClass="input" />
				</div>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			
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
</body>
<% 
Integer id_webo_page = new Integer("1049"); 
com.socgen.bip.commun.form.AutomateForm formWebo = rapportTableRepForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
