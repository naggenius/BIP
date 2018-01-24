
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
<bip:VerifUser page="jsp/eContOr.jsp"/>
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
	String sJobId="e_aecont";
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
	
	tabVerif["p_param7"]  = "VerifierAlphaMax(document.editionForm.p_param7)";
	tabVerif["p_param8"]  = "Ctrl_dpg_generique(document.editionForm.p_param8)";
	tabVerif["p_param9"]  = "VerifierNum(document.editionForm.p_param9,5,0)";
	tabVerif["p_param11"] = "VerifierDate2(document.editionForm.p_param11,'jjmmaaaa')";
	tabVerif["p_param12"] = "VerifierDate2(document.editionForm.p_param12,'jjmmaaaa')";
	tabVerif["p_param13"] = "VerifierNum(document.editionForm.p_param13,10,2)";
	
	var Message="<bean:write filter="false"  name="editionForm"  property="msgErreur" />";
	var Focus = "<bean:write name="editionForm"  property="focus" />";
	
	if (Message != "") {
		alert(Message);
	}
	if (Focus != "") (eval( "document.editionForm."+Focus )).focus();
	else {
		document.editionForm.p_param7.focus();
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
	}
	//form.VerifExecJS.value = 1;
	document.editionForm.submit.disabled = true;
	return true;
}

function rechercheSocieteID(){
	window.open("/recupIdSociete.do?action=initialiser&nomChampDestinataire=p_param7&windowTitle=Recherche Identifiant Societe&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
}  

function nextFocusLoupeSociete(){
	document.forms[0].p_param8.focus();
}

function rechercheCodeDPG(){
	window.open("/recupDPG.do?action=initialiser&nomChampDestinataire=p_param8&windowTitle=Recherche Code DPG&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
}  

function nextFocusLoupeCodeDPG(){
	document.forms[0].p_param9.focus();
}

function rechercheIdPersonne(){
	window.open("/recupIdPersonne.do?action=initialiser&nomChampDestinataire=p_param9&windowTitle=Recherche Identifiant Personne&habilitationPage=HabilitationRestime"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
}  

function nextFocusLoupeIdPersonne(){
document.forms[0].p_param11.focus();
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
			<input type="hidden" name="p_param6" value="inutilisé">
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
					<tr><td colspan=6><b>SELECTION :</b></td></tr>
					<tr>
						<td width=20>&nbsp;</td>
						<td colspan=2 class="lib">Code soci&eacute;t&eacute; :</td>
						<td><html:text property="p_param7" styleClass="input"  size="4" maxlength="4" onchange="return VerifFormat(this.name);"/>          <!-- SOCCONT -->
                            &nbsp;&nbsp;<a href="javascript:rechercheSocieteID();" onFocus="javascript:nextFocusLoupeSociete();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code Société" title="Rechercher Code Société"></a>
						</td>
						<td class="lib">Code DPG :</td>
						<td><html:text property="p_param8" styleClass="input"  size="7" maxlength="7" onchange="return VerifFormat(this.name);"/>          <!-- CODSG -->
                            &nbsp;&nbsp;<a href="javascript:rechercheCodeDPG();" onFocus="javascript:nextFocusLoupeCodeDPG();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code Société" title="Rechercher Code Société"></a>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td colspan=2 class="lib">Code ressource :</td>
						<td><html:text property="p_param9" styleClass="input"  size="5" maxlength="5" onchange="return VerifFormat(this.name);"/>             <!-- IDENT -->
                            &nbsp;&nbsp;<a href="javascript:rechercheIdPersonne();" onFocus="javascript:nextFocusLoupeIdPersonne();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code Société" title="Rechercher Code Société"></a>
						</td>
						<td class="lib">Type facturation :</td>
						<td>
							<select class="input" name="p_param10">
								<option value=" " SELECTED>&nbsp;</option>
								<option value="R">Régie</option>
								<option value="M">Maintenance</option>
								<option value="F">Forfait</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>&nbsp;      </td>
						<td colspan=5>P&eacute;riode d'enregistrement :      </td>
					</tr>
					<tr>
						<td>&nbsp;      </td>
						
						<td colspan=2 class="lib">Date de d&eacute;but :   </td>
						<td><html:text property="p_param11" styleClass="input"  size="10" maxlength="10" onchange="return VerifFormat(this.name);"/> <!-- CDATDEB -->
						
						<td class="lib">Date de fin :       </td>
						<td><html:text property="p_param12" styleClass="input"  size="10" maxlength="10" onchange="return VerifFormat(this.name);"/> <!-- CDATFIN -->
					</tr>
					<tr>
						<td>&nbsp;      </td>
						<td colspan=2 class="lib">Montant minimum :</td>
						<td colspan=3><html:text property="p_param13" styleClass="input"  size="13" maxlength="13" onchange="return VerifFormat(this.name);"/>    <!-- CCOUTHT -->
					</tr>
					
					<tr>
                        <td colspan=6><b>AFFICHAGE :</b></td>
                      </tr>
					
					<tr>
						<td>&nbsp;      </td>
						<td colspan=5 class="lib">
						<b>Pr&eacute;sentation de l'&eacute;tat :</b>
						<input type=radio name="listeReports" value="1" checked>lignes&nbsp;
						<input type=radio name="listeReports" value="2">
                          image compl&egrave;te
					</td>
					</tr>
					  <tr>
                        <td colspan=5 align="center">&nbsp;</td>
                      </tr>
					  </table>
					  <table>
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