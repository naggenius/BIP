
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.bip.metier.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="editionForm" scope="request" class="com.socgen.bip.commun.form.EditionForm" />
<html:html locale="true">
<!-- #EndEditable --> 
<!-- sContratRF.jsp -->

<!-- #BeginTemplate "/Templates/Page_edition.dwt" --><head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<!-- #BeginEditable "doctitle" --> 
<title>Edition</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!-- #BeginEditable "fichier" --> 
<%-- <bip:VerifUser page="jsp/sContratRF.jsp"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
--%>

<script language="JavaScript">
var blnVerification = true;
<%
String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));

String num_process_en_cours = String.valueOf((Integer) request.getAttribute("num_process_en_cours"));
%>
var pageAide = "<%= sPageAide %>";
var blnVerifFormat  = true;
var tabVerif        = new Object();

var racine = "";
var avenant = "";

<%
	String sTitre="Recherche Contrat / Ressource / Facture";
	String sInitial;
	String sJobId="e_aecontrf";
%>

function MessageInitial()
{
	<%
	
		sTitre = com.socgen.bip.metier.Report.getTitre(sJobId);
		if (sTitre == null)
		{
			//redirect sur la page d erreur
			sTitre = "Pas de titre";
		}		
	
		sInitial=ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getQueryString()));
		

		if (sInitial == null)
			sInitial = request.getRequestURI();
		else
			sInitial = request.getRequestURI() + "?" + sInitial;
		sInitial = sInitial.substring(request.getContextPath().length());
	%>
	
	var Message="<bean:write filter="false"  name="editionForm"  property="msgErreur" />";
	var Focus = "<bean:write name="editionForm"  property="focus" />";
	
	if (Message != "") {
		alert(Message);
	}
	if (Focus != "") (eval( "document.editionForm."+Focus )).focus();
	else {
		document.editionForm.p_param6.focus();
	}

	}


</script>
<!-- #EndEditable --> 
</head>


<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
		  <html:form action="/edition" ><!-- #EndEditable -->
			<!-- #BeginEditable "debut_hidden" -->
		  	<input type="hidden" name="pageAide" value="<%= sPageAide %>">
			<html:hidden property="action"/>
			<html:hidden property="mode"/>
			<html:hidden property="arborescence" value="<%= arborescence %>"/>
			<input type="hidden" name="jobId" value="<%=sJobId%>">
			<input type="hidden" name="initial" value="<%= sInitial %>">
			<html:hidden property="page" value="modifier"/>
			<input type="hidden" name="index" value="modifier">					
			<html:hidden property="p_param6" value="<%= num_process_en_cours %>"/> 
			<html:submit value="Valider" styleClass="input" style="visibility:hidden"/>
		</html:form>
			
 <script type="text/javascript">
   document.forms["editionForm"].submit();
  </script>
			
</body>

</html:html>

<!-- #EndTemplate -->