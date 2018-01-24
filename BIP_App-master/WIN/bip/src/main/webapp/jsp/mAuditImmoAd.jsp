<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"   errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="auditImmoForm" scope="request" class="com.socgen.bip.form.AuditImmoForm" />
<jsp:useBean id="extractionForm" scope="request" class="com.socgen.bip.commun.form.ExtractionForm" />
<html:html locale="true">
<!-- #EndEditable -->  <!-- #BeginTemplate "/Templates/Page_filtre_maj.dwt" --><head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>



<!-- #BeginEditable "doctitle" --> 
<title>Filtre Maj</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/mAuditImmoAd.jsp"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	String sJobId = "xConsultSituImmo";
	String sInitial;
%>
var pageAide = "<%= sPageAide %>";


function MessageInitial()
{
   var Message="<bean:write filter="false"  name="auditImmoForm"  property="msgErreur" />";
   var Focus = "<bean:write name="auditImmoForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
  if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else {
	  document.forms[0].p_param6.focus();
   }
   
   	<%
	sInitial=ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getQueryString()));
		if (sInitial == null)
			sInitial = request.getRequestURI();
		else
			sInitial = request.getRequestURI() + "?" + sInitial;
		sInitial = sInitial.substring(request.getContextPath().length());
	%>

}

function Verifier(form, action, flag)
{
   
   blnVerification = flag;
   form.action.value = action;
}

function Verifier2(form, action, flag)
{
   blnVerification = flag;
   form.action.value = action;
}

function ValiderEcran(form)
{
   if (blnVerification) {
	

	if (!ChampObligatoire(form.p_param6, "une année")) return false;
	if ((form.p_param7.value == "" ) && (form.p_param8.value== ""))
	{
		alert("Entrez minimum un des deux projets");
		return false;
	}
	

   }

   return true;
}

function ValiderEcran2(form)
{
   if (blnVerification) {
	

	if (!ChampObligatoire(form.annee, "une année")) return false;
	if (!ChampObligatoire(form.pid, "une ligne bip")) return false;
	if (!ChampObligatoire(form.icpi, "un projet")) return false;

   }

   return true;
}
</script>
<!-- #EndEditable -->  


</head>

<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td> 
            <div align="center"><!-- #BeginEditable "barre_haut" --> 
              <%ToolBar tb = new com.socgen.ich.ihm.ToolBar("bip_ihm",false,false,true,false,false,false,false,false,false,request) ;%>
              <%=tb.printHtml()%> <!-- #EndEditable --></div>
   		</td>
     </tr>
     <tr><td>&nbsp;</td></tr>
     <tr><td background="../images/ligne.gif"></td></tr>
     <tr><td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Mise &agrave; jour immobilisation<!-- #EndEditable --></td></tr>
     <tr><td background="../images/ligne.gif"></td></tr>
 </table>
 	<table border=0  cellpadding=2 cellspacing=2 class="tableBleu" align="center">
	<tr><td colspan="3">&nbsp;</td></tr>
	<tr><td width=161><hr></td>
        <td width="250"><b><center>Consultation de situation</center></b></td>
        <td width=161><hr></td>
     </tr>
     </table>
<!-- #################### DEBUT CONSULTATION #################################"" -->
<html:form action="/extract" onsubmit="return ValiderEcran(this);"><!-- #EndEditable -->
<div align="center"><!-- #BeginEditable "contenu" -->
	<input type="hidden" name="jobId" value="<%=sJobId%>">
    <input type="hidden" name="initial" value="<%= sInitial %>">
    <input type="hidden" name="pageAide" value="<%= sPageAide %>">
    <html:hidden property="arborescence" value="<%= arborescence %>"/>
	<table border=0 cellpadding=2 cellspacing=2 class="tableBleu">
	

    	
    	<tr>
    		<td align="left"><b>Année :</b></td>
			<td><html:text property="p_param6" styleClass="input" size="5" maxlength="4" onchange="return VerifierNum(this,4,0);"/></td>
    		
    	</tr>
    	<tr>
    		<td align="left"><b>Projet n :  </b></td>
        	<td><html:text property="p_param7" styleClass="input" size="6" maxlength="5" onchange="return VerifierAlphaMax(this);"/> </td>
    		
    	</tr>
    	<tr>
    		<td align="left"><b>Projet actuel :  </b></td>
    		<td><html:text property="p_param8" styleClass="input" size="6" maxlength="5" onchange="return VerifierAlphaMax(this);"/></td>
			
    	</tr>
    	<tr><td colspan="4">&nbsp;</td> </tr>
  	</table>
<!-- #EndEditable -->
</div>
<table width="100%" border="0">
	<tr><td>
	
    	<div align="center"> <html:submit value="Extraire" styleClass="input" onclick="Verifier(this.form, 'Extraire', true);"/> 
    </div>
	</td></tr>
</table>
<!-- #BeginEditable "fin_form" -->
</html:form><!-- #EndEditable -->
<!-- #################### FIN CONSULTATION #################################"" -->	  
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr><td>&nbsp;</td></tr>
</table>

<!-- #################### DEBUT MISE A JOUR IMMO #################################"" -->
<html:form action="/auditImmo"  onsubmit="return ValiderEcran2(this);"><!-- #EndEditable -->
<div align="center"><!-- #BeginEditable "contenu" -->
	<input type="hidden" name="pageAide" value="<%= sPageAide %>"> 
	<html:hidden property="arborescence" value="<%= arborescence %>"/> 
	<html:hidden property="action" value="creer"/>
	<table border=0  cellpadding=2 cellspacing=2 class="tableBleu">
	
	<tr><td width=161><hr></td>
        <td width="161" colspan="2"><b><center>Mise à jour</center></b></td>
        <td width=157><hr></td>
     </tr>

    	<tr><td colspan="4">&nbsp;</td> </tr>
    	<tr><td>&nbsp;</td>
    		<td align="left"><b>Année :</b></td>
			<td><html:text property="annee" styleClass="input" size="5" maxlength="4" onchange="return VerifierNum(this,4,0);"/></td>
    		<td>&nbsp;</td>
    	</tr>
    	<tr><td>&nbsp;</td>
    		<td align="left"><b>Code ligne :  </b></td>
        	<td><html:text property="pid" styleClass="input" size="5" maxlength="4" onchange="return VerifierAlphaMax(this);"/> </td>
    		<td>&nbsp;</td>
    	</tr>
    	<tr><td>&nbsp;</td>
    		<td align="left"><b>Projet :  </b></td>
    		<td><html:text property="icpi" styleClass="input" size="6" maxlength="5" onchange="return VerifierAlphaMax(this);"/></td>
			<td>&nbsp;</td>
    	</tr>
    	<tr><td colspan="4">&nbsp;</td> </tr>
  	</table>

<!-- #EndEditable -->
</div>
<table width="100%" border="0">
	<tr><td>
	<div align="center">
    	<html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier2(this.form, 'valider', true);"/>
    </div>
	</td></tr>
</table>
<!-- #BeginEditable "fin_form" -->
</html:form><!-- #EndEditable -->
 <!-- #################### FIN MISE A JOUR IMMO #################################"" -->

<table width="100%">
<tr><td> 
    <div align="center"><html:errors/><!-- #BeginEditable "barre_bas" --><!-- #EndEditable --></div>
</td></tr>
</table>

   
</body>
</html:html> 

<!-- #EndTemplate -->