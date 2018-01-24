
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/ajaxtags.tld" prefix="ajax" %>

<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="editionForm" scope="request" class="com.socgen.bip.commun.form.EditionForm" />
<html:html locale="true">
<!-- #EndEditable --> 

<!-- #BeginTemplate "/Templates/Page_edition.dwt" --><head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
<script type="text/javascript" src="../js/ajax/prototype.js"></script>
<script type="text/javascript" src="../js/ajax/scriptaculous/scriptaculous.js"></script>
<script type="text/javascript" src="../js/ajax/overlibmws/overlibmws.js"></script>
<script type="text/javascript" src="../js/ajax/overlibmws/overlibmws_crossframe.js"></script>
<script type="text/javascript" src="../js/ajax/overlibmws/overlibmws_iframe.js"></script>
<script type="text/javascript" src="../js/ajax/overlibmws/overlibmws_hide.js"></script>
<script type="text/javascript" src="../js/ajax/overlibmws/overlibmws_shadow.js"></script>
<script type="text/javascript" src="../js/ajax/ajaxtags.js"></script>
<script type="text/javascript" src="../js/ajax/ajaxtags_controls.js"></script>
<script type="text/javascript" src="../js/ajax/ajaxtags_parser.js"></script>
 

<link rel="stylesheet" type="text/css" href="../css/ajax/displaytag.css" />

<title>Page BIP</title>
 <style type="text/css">
  .autocomplete {
	
	position: absolute;
	color: #333;
	background-color: #fff;
	border: 1px solid #666;
	font-family: Verdana;
	overflow-y: auto;
	height: 150px;
	
	
}

.autocomplete ul {
	padding: 0;
	margin: 0;
	list-style: none;
	overflow: hidden;
	width: 450px;
}

.autocomplete li {
	display: block;
	white-space: nowrap;
	cursor: pointer;
	margin: 0px;
	padding-left: 5px;
	padding-right: 5px;
	border: 1px solid #fff;
	text-align: justify;
	
}

.autocomplete li.selected {
	background-color: #ffb;
	border-top: 1px solid #9bc;
	border-bottom: 1px solid #9bc;
	font-weight:bold;
	
}
  </style>

<!-- #BeginEditable "doctitle" --> 
<title>Edition</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/xAuditImmoAd.jsp"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var pageAide = "aide/hvide.htm";
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";

var blnVerifFormat  = true;
var tabVerif        = new Object();

<%
	String sTitre;
	String sInitial;
	String sJobId;
%>

function MessageInitial()
{	
	<%
		sJobId = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("jobId")));
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
	%>
	
	tabVerif["p_param6"]  = "VerifierAlphaMax(document.editionForm.p_param6)";
		
	var Message="<bean:write filter="false"  name="editionForm"  property="msgErreur" />";
	var Focus = "<bean:write name="editionForm"  property="focus" />";
	
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else {
	  document.forms[0].p_param6.focus();
   }
}

function Verifier(form, bouton, flag)
{
	/* si pas de jobId => erreur */
	if (bouton == 'extraire') {
		form.elements['jobId'].value = 'xAuditImmoExtract';
		form.action = '/extract.do';
	} else {
		// bouton == 'liste'
		form.action = '/edition.do';
	}
	blnVerification = flag;
}

function ValiderEcran(form)
{
	if (blnVerification)
	{
		if ( !VerifFormat(null) ) return false;
		if (!ChampObligatoire(form.p_param6, "un code projet")) return false;
	}
	//form.VerifExecJS.value = 1;
	document.editionForm.submit.disabled = true;
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" --><%=sTitre%><!-- #EndEditable --></td>
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
		  <!-- #BeginEditable "debut_form" --><html:form action="/edition"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable -->
			<!-- #BeginEditable "debut_hidden" -->
		  	<input type="hidden" name="initial" value="<%= sInitial %>">
            
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<input type="hidden" name="jobId" value="<%=sJobId%>">
			<!-- #EndEditable -->
            <table width="100%" border="0">
              
                <tr> 
                  <td> 
                  
					<table border=0  cellspacing=2 cellpadding=2 class="tableBleu" align="center">
					<!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>">
					<tr><td colspan=6 align=center>&nbsp;</td></tr><tr>
					<tr>
						<td class="lib" nowrap><B>Code projet ou libellé :</B></td>
						<td><html:text property="p_param6" styleClass="input"  size="6" maxlength="5" onchange="return VerifFormat(this.name);"/>  </td>
						<td width="15%"><span id="indicator3" style="display:none;"><img src="../images/indicator.gif" /></span></td>
						<td width="15%">&nbsp;</td>
						<td class="lib"><B>Année :</B></td>
						<td><html:text property="p_param7" styleClass="input"  size="5" maxlength="4" onchange="return VerifierNum(this,4,0);"/>
						</td>
					</tr>
					<tr><td colspan=6 align=center>&nbsp;</td></tr><tr>
					<!-- #EndEditable -->
			   		</table>
				
                  </td>
                </tr>
				<tr> 
          		  <td>&nbsp;  
          		  </td>
        		</tr>
                <tr> 
                  <td>  
                  <div align="center">
				  <html:submit value="Liste" styleClass="input" onclick="Verifier(this.form, 'liste', true);"/>
				  &nbsp;
				  <html:submit value="Extraire" styleClass="input" onclick="Verifier(this.form, 'extraire', true);"/>
                  </div>
                  </td>
                </tr>
            
            </table>
			  <!-- #BeginEditable "fin_form" --></html:form><!-- #EndEditable -->
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

   	<ajax:autocomplete
								  source="p_param6"
  								  target="p_param6"
  								  parameters="libelle={p_param6}"
 								  baseUrl="/autocompleteProjAudit.do"
  								  className="autocomplete"
                                  indicator="indicator3"
                                  minimumCharacters="1"
                                 />

<!-- #EndTemplate -->