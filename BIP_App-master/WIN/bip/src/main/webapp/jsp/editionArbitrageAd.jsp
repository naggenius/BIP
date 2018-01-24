<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="editionForm" scope="request" class="com.socgen.bip.commun.form.EditionForm" />
<jsp:useBean id="arbitrageForm" scope="request" class="com.socgen.bip.form.ArbitrageForm" />
<html:html locale="true">
<!-- #EndEditable --> 

<!-- #BeginTemplate "/Templates/Page_edition.dwt" --><head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<!-- #BeginEditable "doctitle" --> 
<title>Edition</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/editionSansParam.jsp"/>
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

<%
	String sTitre;
	String sInitial;
	String sJobId;
	String sParam6;
	String sParam7;
%>

var liste_pid = "<bean:write name="arbitrageForm"  property="liste_pid" />";

function MessageInitial(editionForm)
{
	<%
		sJobId="xArbitrage";
	
		sTitre = com.socgen.bip.metier.Report.getTitre(sJobId);
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
		
		sParam7 = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("p_param7")));
	%>
	
	var Message="<bean:write filter="false"  name="editionForm"  property="msgErreur" />";
	var Focus = "<bean:write name="editionForm"  property="focus" />";


	if (Message != "") {
		alert(Message);
	}

}

function Verifier(form, bouton, flag)
{
  blnVerification = flag;
}

function ValiderEcran(form)
{	
	document.editionForm.submit.disabled = true;
	return true;
}
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial(this.form);">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
       <tr> 
          <td>&nbsp;</td>
        </tr>
		<tr > 
		  <td> 
            <div align="center">
              <%ToolBar tb = new com.socgen.ich.ihm.ToolBar("bip_ihm",false,false,true,false,false,false,false,false,false,request) ;%>
				<%=tb.printHtml()%>
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
          <td height="20" class="TitrePage">
          	<%=sTitre%>
          </td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td>
			<html:form action="/extract"  onsubmit="return ValiderEcran(this);">	  		
            	
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<input type="hidden" name="jobId" value="<%=sJobId%>">
            	<input type="hidden" name="initial" value="<%= sInitial %>">
            	<input type="hidden" name="p_param6" value="">
            	<input type="hidden" name="p_param7" value="<%= sParam7 %>">
            <table width="100%" border="0">
                <tr> 
                  <td> 
                    <div align="center">
						<table border=0 cellspacing=2 cellpadding=2 class="tableBleu">
							<input type="hidden" name="pageAide" value="<%= sPageAide %>">
							<tr>
								<td colspan=5 align=center>&nbsp;</td>
							</tr>
							<tr>
								<td colspan=5 class="lib" align=center>Extraction excel en cours de génération... </td>
							</tr>
							<tr>
								<td colspan=5 align=center>&nbsp;</td>
							</tr>
			   			</table>
					</div>
                  </td>
                </tr>
                <tr> 
          		  <td>
          		   <div align="center">
          		   <% editionForm.isEtatNonDiffere(sJobId);%>
       					<bean:write name="editionForm" property="libelleTypeEtat" filter="true"/>
          		  </div>
          		  <BR>          		  
          		  </td>
        		</tr>
<!-- LANCEMENT DE L'EDITION SANS CLIQUER SUR LE BOUTON -->
	<script language="JavaScript">
		document.forms[0].p_param6.value=liste_pid;
		document.forms[0].submit();
	</script>
<!-- LANCEMENT DE L'EDITION SANS CLIQUER SUR LE BOUTON -->
                <tr> 
                  <td>  
                  <div align="center">
				  <html:submit value="Liste" styleClass="input" onclick="Verifier(this.form, 'liste', true);"/>
                  </div>
                  </td>
                </tr>
            </table>
			</html:form>
          </td>
        </tr>
		<tr> 
          <td>&nbsp;  
          </td>
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
</html:html>