<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.util.*,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"   errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="editionForm" scope="request" class="com.socgen.bip.commun.form.EditionForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_filtre_maj.dwt" --><head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>



<!-- #BeginEditable "doctitle" --> 
<title>Log des paramètres Bip</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/eLogsParamBipAd.jsp"/> 
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var pageAide = "aide/hvide.htm";
var blnVerification = true;
<%	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide"))); %>
var pageAide = "<%= sPageAide %>";

var blnVerifFormat  = true;
var tabVerif		= new Object();

<%
	String sTitre;
	String sInitial;
%>

function MessageInitial()
{
	<%
		sTitre = com.socgen.bip.metier.Report.getTitre("eLogsParamBipAd");
		if (sTitre == null)	sTitre = "Pas de titre";

		sInitial=ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getQueryString()));
		if (sInitial == null) sInitial = request.getRequestURI();
		else sInitial = request.getRequestURI() + "?" + sInitial;
		sInitial = sInitial.substring(request.getContextPath().length());
	%>
	var Message="<bean:write filter="false"  name="editionForm"  property="msgErreur" />";
	var Focus = "<bean:write name="editionForm"  property="focus" />";
	
	if (Message != "") {
		alert(Message);
	}
	
	if (Focus != "")
		(eval( "document.editionForm."+Focus )).focus();
	else {
		document.editionForm.p_param6.focus();
	}
}

function Verifier(form, bouton, flag) {
	form.action.value=bouton;
}

function ValiderEcran(form) {

	if (!ChampObligatoire(form.p_param6, "le code action de début")) return false;
	if (!ChampObligatoire(form.p_param8, "le code action de fin")) return false;
	if(form.p_param9.value=='=' && form.p_param7.value==''){
		alert("Valeur '=' interdite si le code version de début est vide");
		return false;	
	}
	//p_param9 égal = alors que p_param7 est vide
	return true;
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
              <%=tb.printHtml()%> <!-- #EndEditable --></div>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td height="20" class="TitrePage"><%=sTitre%></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td>
		  <!-- #BeginEditable "debut_form" -->
		  <html:form action="/edition" onsubmit="return ValiderEcran(this);">
		  <div align="center"><!-- #BeginEditable "contenu" -->
            <input type="hidden" name="jobId" value="eLogsParamBipAd">
            <input type="hidden" name="initial" value="<%= sInitial %>">
			<html:hidden property="arborescence" value="<%= arborescence %>"/>
			<html:hidden property="action" value="refresh"/>
            <input type="hidden" name="pageAide" value="<%= sPageAide %>">

			<table border=0  cellpadding=2 cellspacing=2 class="tableBleu">
                
                <tr> 
                  <td colspan="2">&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="2">&nbsp;</td>
                </tr>
                <tr> 
                  <td class="lib">DE&nbsp;&nbsp;&nbsp;Code action :</td>
                  <td> 
					<html:text property="p_param6" styleClass="input"  size="27" maxlength="25"/>
				  </td>
                </tr>
                <tr> 
                  <td class="lib">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Code version :</td>
                  <td> 
					<html:text property="p_param7" styleClass="input"  size="10" maxlength="8"/>
				  </td>
                </tr>
                <tr> 
                  <td colspan="2">&nbsp;</td>
                </tr>
                 <tr> 
                  <td class="lib">A&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Code action :</td>
                  <td> 
					<html:text property="p_param8" styleClass="input"  size="27" maxlength="25"/>
				  </td>
				  <td>
				  	&nbsp;&nbsp;&nbsp;= si identique
				  </td>
                </tr>
                <tr> 
                  <td class="lib">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Code version :</td>
                  <td> 
					<html:text property="p_param9" styleClass="input"  size="10" maxlength="8"/>
				  </td>
				  <td>
				  	&nbsp;&nbsp;&nbsp;= si identique
				  </td>
                </tr>
                <tr> 
                  <td colspan="2">&nbsp;</td>
                </tr>
                <tr> 
                  <td class="lib">Date de début :</td>
                  <td> 
					<html:text property="p_param10" styleClass="input"  size="12" maxlength="10" onchange="return VerifierDate(this,'jj/mm/aaaa');"/>
				  </td>
                </tr>
                <tr> 
                  <td colspan="2">&nbsp;</td>
                </tr>
                <tr> 
                  <td class="lib">Date de fin :</td>
                  <td> 
					<html:text property="p_param11" styleClass="input"  size="12" maxlength="10" onchange="return VerifierDate(this,'jj/mm/aaaa');"/>
				  </td>
                </tr>
                <tr> 
                  <td colspan="2">&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="2">&nbsp;</td>
                </tr>
              </table>
			  <!-- #EndEditable --></div>
            
			</td>
		</tr>
		<tr>
		<td align="center">

		<table width="100%" border="0">
		
              <tr> 
                <td align="center"> 
                	<html:submit value="Liste" styleClass="input" onclick="Verifier(this.form, 'liste', true);"/> 
                </td>
              </tr>
            
            </table>
		
			  <!-- #BeginEditable "fin_form" -->
			  </html:form>
			  <!-- #EndEditable -->
			  
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