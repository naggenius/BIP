
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="editionForm" scope="request" class="com.socgen.bip.commun.form.EditionForm" />
<html:html locale="true">
<!-- #EndEditable --> 

<!-- #BeginTemplate "/Templates/Page_edition.dwt" --><head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<!-- #BeginEditable "doctitle" --> 
<title>Edition</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/eConrecOr.jsp"/>
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
	String sJobId="e_aeconrec";
%>

function MessageInitial()
{
	<%
		//sJobId = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("jobId");
		sTitre = com.socgen.bip.metier.Report.getTitre(sJobId);
		if (sTitre == null)
		{
			//redirect sur la page d'erreur
			sTitre = "Pas de titre";
		}		
		sInitial=request.getQueryString();
		if (sInitial == null)
			sInitial = request.getRequestURI();
		else
			sInitial = request.getRequestURI() + "?" + sInitial;
		sInitial = sInitial.substring(request.getContextPath().length());
	%>
	
	tabVerif["p_param6"] = "VerifierAlphaMax(document.editionForm.p_param6)";
	tabVerif["p_param7"] = "VerifierAlphaMaxCarSpecContrat(document.editionForm.p_param7)";
	tabVerif["p_param8"] = "VerifierAlphaMax(document.editionForm.p_param8)";
	
	var Message="<bean:write filter="false"  name="editionForm"  property="msgErreur" />";
	var Focus = "<bean:write name="editionForm"  property="focus" />";
	
	if (Message != "") {
		alert(Message);
	}
	if (Focus != "") (eval( "document.editionForm."+Focus )).focus();
	else
	{
		document.editionForm.p_param6.focus();
	}
}

function Verifier(form, bouton, flag)
{
  blnVerification = flag;
  //form.BOUTON.value = bouton;
}

function ValiderEcran(form)
{
	if (blnVerification)
	{
		if ( !VerifFormat(null) ) return false;
		if (!ChampObligatoire(form.p_param6, "un code société")) return false;
		if (!ChampObligatoire(form.p_param7, "un numéro de contrat")) return false;
		
	}
	
	//form.VerifExecJS.value = 1;
	document.editionForm.submit.disabled = true;
	return true;
}


function rechercheSocieteID(){
	window.open("/recupIdSociete.do?action=initialiser&nomChampDestinataire=p_param6&windowTitle=Recherche Identifiant Societe&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
}  

function nextFocusLoupeSociete(){
	document.forms[0].p_param7.focus();
}


function rechercheContrat(){

   var typeContrat;
   
   if (document.forms[0].p_param6.value == '')  {
      alert("Veuillez saisir le code de la société");
      document.forms[0].p_param6.focus();
   }
   else
   {    		
		window.open("/recupContrat.do?action=initialiser&soccont="+document.forms[0].p_param6.value+"&nomChampDestinataire=p_param7&nomChampDestinataire2=p_param8&windowTitle=Recherche Contrat&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=700, height=600") ;
	}
}  

function nextFocusCav(){
	document.forms[0].p_param8.focus();
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
					  <tr>
                        <td colspan=5 align="center">&nbsp;</td>
                      </tr>
					<tr>
						<td class="lib"><b>Code soci&eacute;t&eacute; :</b></td>
						<td><html:text property="p_param6" styleClass="input"  size="4" maxlength="4" onchange="return VerifFormat(this.name);"/>
						&nbsp;&nbsp;<a href="javascript:rechercheSocieteID();" onFocus="javascript:nextFocusLoupeSociete();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code Société" title="Rechercher Code Société" align="absbottom"></a> 
						</td>
						
					</tr>
					<tr>
						<td class="lib"><b>N&deg; de contrat :</b></td>
						<td><html:text property="p_param7" styleClass="input"  size="30" maxlength="27" onchange="return VerifFormat(this.name);"/>
						&nbsp;&nbsp;<a href="javascript:rechercheContrat();" onFocus="javascript:nextFocusCav();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Contrat" title="Rechercher Contrat" align="absbottom"></a>
						</td>
					</tr>
					<tr>
						<td class="lib">N&deg; d'avenant :</td>
						<td><html:text property="p_param8" styleClass="input"  size="3" maxlength="3" onchange="return VerifFormat(this.name);"/></td>
					</tr>
					  <tr>
                        <td colspan=5 align="center">&nbsp;</td>
                      </tr>
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