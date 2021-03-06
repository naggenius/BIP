<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="extractionForm" scope="request" class="com.socgen.bip.commun.form.ExtractionForm" />
<html:html locale="true">
<!-- #EndEditable --> 

<!-- #BeginTemplate "/Templates/Page_edition.dwt" --><head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<!-- #BeginEditable "doctitle" --> 
<title>Extraction</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/xHistBud.jsp"/>
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
var tabVerif		= new Object();

<%
	String sTitre;
	String sInitial;
	String sJobId="xHisBudCons";
%>

function MessageInitial()
{
	<%
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
	
	var Message="<bean:write filter="false"  name="extractionForm"  property="msgErreur" />";
	var Focus = "<bean:write name="extractionForm"  property="focus" />";
	
	tabVerif["p_param6"]  = "Ctrl_dpg_generique(document.extractionForm.p_param6)";
	tabVerif["p_param7"]  = "VerifierAlphanum(document.extractionForm.p_param7)";
	
	if (Message != "") {
		alert(Message);
	}

	if (Focus != "")
		(eval( "document.extractionForm."+Focus )).focus();
	else {
		document.extractionForm.p_param6.focus();
	}
}

function Verifier(form, bouton, flag)
{
	if (form.p_param7.value.length>0) {
		form.p_param7.value = form.p_param7.value.toUpperCase();
	} else {
		form.p_param7.value = "";
	}
    blnVerification = flag;
    //form.BOUTON.value = bouton;
}

function ValiderEcran(form)
{
	if (blnVerification)
	{
		if ( !VerifFormat(null) ) return false;
		if ( (form.p_param6.value=="") && (form.p_param7.value=="") )
		{
			alert("Veuillez saisir au moins un crit�re.");
			return false;
		}
		if ( !confirm("Confirmez-vous la demande d'extraction ?") ) return false;
	}
	//form.VerifExecJS.value = 1;
	document.extractionForm.submit.disabled = true;
	return true;
}

function rechercheDPG(){
	window.open("/recupDPG.do?action=initialiser&nomChampDestinataire=p_param6&windowTitle=Recherche Code DPG Fournisseur&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
}

function rechercheCodeAIRT(){
	window.open("/recupAppli.do?action=initialiser&nomChampDestinataire=p_param7&windowTitle=Recherche Code Application&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
}

function nextFocusDPG(){
	document.forms[0].p_param7.focus();
}

function nextFocusCodeAIRT(){
	document.forms[0].p_param6.focus();
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
		  <!-- #BeginEditable "debut_form" --><html:form action="/extract.do"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable -->
			<!-- #BeginEditable "debut_hidden" -->
		  		
            
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<input type="hidden" name="jobId" value="<%=sJobId%>">
            <input type="hidden" name="initial" value="<%= sInitial %>">
			<!-- #EndEditable -->
            <table width="100%" border="0">
              
                <tr> 
                  <td> 
                    <div align="center">
					<table border=0 cellspacing=2 cellpadding=2 class="tableBleu">
					<!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>">
					<tr><td colspan=5 align=center>&nbsp;</td></tr><tr>
					<tr>
						<td class="lib"><b>Code DPG :</b></td>
						<td><html:text property="p_param6" styleClass="input"  size="7" maxlength="7" onchange="return VerifFormat(this.name);"/>
						    &nbsp;&nbsp;<a href="javascript:rechercheDPG();" onFocus="javascript:nextFocusDPG();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code DPG" title="Rechercher Code DPG" align="absbottom"></a>
						</td>
					</tr>
					<tr>
						<td class="lib"><b>Code application :</b></td>
						<td><html:text property="p_param7" styleClass="input"  size="5" maxlength="5" onchange="return VerifFormat(this.name);"/>
						    &nbsp;&nbsp;<a href="javascript:rechercheCodeAIRT();" onFocus="javascript:nextFocusCodeAIRT();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code DPG" title="Rechercher Code DPG" align="absbottom"></a>
						</td>
					</tr>
					<tr><td colspan=5 align=center>&nbsp;</td></tr><tr>

					<!-- #EndEditable -->
			   		</table>
					</div>
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

<!-- #EndTemplate -->