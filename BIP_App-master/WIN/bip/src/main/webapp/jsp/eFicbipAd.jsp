<!DOCTYPE html>
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
<bip:VerifUser page="jsp/eFicbipAd.jsp"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<!-- <link rel="stylesheet" href="../css/base_style.css" type="text/css"> -->
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
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
	String sJobId="eFicbipAdSync";
%>

function MessageInitial()
{
	<%
		sTitre = com.socgen.bip.metier.Report.getTitre(sJobId);
		//sTitre = null;
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
	
	tabVerif["p_param6"]  = "Ctrl_dpg_generique(document.editionForm.p_param6)";
	tabVerif["p_param7"]  = "VerifierAlphaMax(document.editionForm.p_param7)";
	tabVerif["p_param8"]  = "VerifierAlphaMax(document.editionForm.p_param8)";
	tabVerif["p_param9"]  = "VerifierAlphaMax(document.editionForm.p_param9)";
	tabVerif["p_param10"] = "VerifierAlphaMax(document.editionForm.p_param10)";
	tabVerif["p_param11"] = "VerifierAlphaMax(document.editionForm.p_param11)";
	tabVerif["p_param12"] = "VerifierAlphaMax(document.editionForm.p_param12)";
	
	var Message="<bean:write filter="false"  name="editionForm"  property="msgErreur" />";
	var Focus = "<bean:write name="editionForm"  property="focus" />";
	
	if (Message != "") {
		alert(Message);
	}
	else
	{
		document.editionForm.p_param6.value = Replace_DoubleZero_by_DoubleEtoile( "<bean:write name="UserBip"  property="dpg_Defaut" />" );	
		if (Focus != "") (eval( "document.editionForm."+Focus )).focus();
		else {document.editionForm.p_param6.focus();}
	}
}

function Verifier(form, bouton, flag)
{
  blnVerification = flag;
}

function ValiderEcran(form)
{
	if (blnVerification)
	{
		if ( !VerifFormat(null) ) return false;
	}
	/*Added param 8,9,10,11,12 for BIP-36*/
	if ((form.p_param6.value == "") && (form.p_param7.value == "") && (form.p_param8.value == "") && (form.p_param9.value == "") && (form.p_param10.value == "")
	&& (form.p_param11.value == "") && (form.p_param12.value == ""))
	{
		alert("Entrez au moins une sélection (Projet ou Pôle)");
		return false;
	}
	
	form.jobId.value = (form.p_param6.value!="")?"eFicbipAdAsync":"eFicbipAdSync";
	document.editionForm.submit.disabled = true;
	return true;
}

function recherchePID(champs){
	window.open("/recupPID.do?action=initialiser&nomChampDestinataire="+champs+"&windowTitle=Recherche Code Ligne BIP"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
} 

function nextFocusCodeDPG(champs){
	document.forms[0].elements[champs].focus();
}

function rechercheDPG()
{
	window.open("/recupDPG.do?action=initialiser&nomChampDestinataire=p_param6&windowTitle=Recherche Code DPG&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
}

function VerifDPG()
{
	if (null != document.editionForm.p_param6.value)
	{
			document.editionForm.p_param6.value = "";
	}
}

function VerifLigneBip()
{

	if (null != document.editionForm.p_param7.value || null != document.editionForm.p_param8.value || null != document.editionForm.p_param9.value ||
		null != document.editionForm.p_param10.value || null != document.editionForm.p_param11.value || null != document.editionForm.p_param12.value)
	{
			document.editionForm.p_param7.value = "";
			document.editionForm.p_param8.value = "";
			document.editionForm.p_param9.value = "";
			document.editionForm.p_param10.value = "";
			document.editionForm.p_param11.value = "";
			document.editionForm.p_param12.value = "";
	}

}


</script>
<!-- #EndEditable --> 


</head>

<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
<div id="mainContainer">
<div id="topContainer">
<div id="entete"></div>
<div id="logo">
		<div id="logo_sg"><img src="../images/logo_SG.gif" width="162" height="33" border="0" /></div>
		<div id="nomdusite"><img src="../images/bip_logo.png" width="78" height="46" border="0" /></div>
</div>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
       <tr> 
          <td>&nbsp;</td>
        </tr>
		<tr > 
		  <td> 
            &nbsp;
          </td>
        </tr>
        <tr> 
          <td><div id="outils" align="center"><!-- #BeginEditable "barre_haut" -->
              <%ToolBarNew tb = new com.socgen.ich.ihm.ToolBarNew("bip_ihm",false,false,true,true,false,false,false,false,false,request) ;%>
				<%=tb.printHtml()%><!-- #EndEditable -->
		</div></td>
        </tr>
<!--         <tr>  -->
<!--           <td background="../images/ligne.gif"></td> -->
<!--         </tr> -->
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
		  		
            
<input type="hidden" name="jobId">
				
            <input type="hidden" name="initial" value="<%= sInitial %>">
			<!-- #EndEditable -->
            <table width="100%" border="0">
              
                <tr> 
                  <td> 
                    <div align="center">
					<table border=0 cellspacing=2 cellpadding=2 class="tableBleu">
					<!-- #BeginEditable "contenu" -->
					<input type="hidden" name="pageAide" value="<%= sPageAide %>">
					<html:hidden property="arborescence" value="<%= arborescence %>"/>
					  <tr>
                        <td colspan=5 align="center" height="20">&nbsp;</td>
                      </tr>
					<tr align="left">
						<td width=30 >&nbsp;</td>
						<td colspan=2 class="texte">Code DPG :</td>
						<td class="texte" colspan=4><html:text property="p_param6" styleClass="input"  size="7" maxlength="7" onchange="return VerifFormat(this.name);"
						onblur="VerifLigneBip();" onchange="VerifLigneBip();"/>                      <!-- SOCCONT -->
						&nbsp;<a href="javascript:rechercheDPG();" ><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code DPG" title="Rechercher Code DPG" style="vertical-align : middle;"></a>   
                        </td>
					</tr>
					<tr align="left">
                        <td width=30 class="texte"><U><b>OU</b></U></td>
						<td class="texte" colspan=6> Codes lignes BIP :</td></tr>
					<tr align="left">
						<td width=30>&nbsp;</td>
						<td width=30>&nbsp;</td>
						<td class="texte">Ligne BIP n&deg;1 : </td>
						<td class="texte"><html:text property="p_param7" styleClass="input"  size="4" maxlength="4" onchange="return VerifFormat(this.name);"
						onblur="VerifDPG();" onchange="VerifDPG();"/>
						&nbsp;<a href="javascript:recherchePID('p_param7');" ><img border=0 src="/images/p_zoom_blue.gif"  alt="Rechercher Code Ligne BIP" title="Rechercher Code Ligne BIP" style="vertical-align : middle;"></a>
                        </td> <!-- FENRCOMPTA1 -->
						<td width=30>&nbsp;</td>
						<td class="texte">Ligne BIP n&deg;2 :</td>
						<td class="texte"><html:text property="p_param8" styleClass="input"  size="4" maxlength="4" onchange="return VerifFormat(this.name);"
						onblur="VerifDPG();" onchange="VerifDPG();"/>
						&nbsp;<a href="javascript:recherchePID('p_param8');" ><img border=0 src="/images/p_zoom_blue.gif"  alt="Rechercher Code Ligne BIP" title="Rechercher Code Ligne BIP" style="vertical-align : middle;"></a>
                        </td> <!-- FENRCOMPTA1 -->
					</tr>
					<tr align="left">
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td class="texte">Ligne BIP n&deg;3 :</td>
						<td class="texte"><html:text property="p_param9" styleClass="input"  size="4" maxlength="4" onchange="return VerifFormat(this.name);"
						onblur="VerifDPG();" onchange="VerifDPG();"/>
						&nbsp;<a href="javascript:recherchePID('p_param9');" ><img border=0 src="/images/p_zoom_blue.gif"  alt="Rechercher Code Ligne BIP" title="Rechercher Code Ligne BIP" style="vertical-align : middle;"></a>
                        </td> <!-- FENRCOMPTA1 -->
						<td>&nbsp;</td>
						<td class="texte">Ligne BIP n&deg;4 :</td>
						<td class="texte"><html:text property="p_param10" styleClass="input"  size="4" maxlength="4" onchange="return VerifFormat(this.name);"
						onblur="VerifDPG();" onchange="VerifDPG();"/>
						&nbsp;<a href="javascript:recherchePID('p_param10');" ><img border=0 src="/images/p_zoom_blue.gif"  alt="Rechercher Code Ligne BIP" title="Rechercher Code Ligne BIP" style="vertical-align : middle;"></a>
                        </td>       <!-- FENRCOMPTA1 -->
					</tr>
					<tr align="left">
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td class="texte">Ligne BIP n&deg;5 :</td>
						<td class="texte"><html:text property="p_param11" styleClass="input"  size="4" maxlength="4" onchange="return VerifFormat(this.name);"
						onblur="VerifDPG();" onchange="VerifDPG();"/>
						&nbsp;<a href="javascript:recherchePID('p_param11');" ><img border=0 src="/images/p_zoom_blue.gif"  alt="Rechercher Code Ligne BIP" title="Rechercher Code Ligne BIP" style="vertical-align : middle;"></a>
                        </td>       <!-- FENRCOMPTA1 -->
						<td>&nbsp;</td>
						<td class="texte">Ligne BIP n&deg;6 :</td>
						<td class="texte"><html:text property="p_param12" styleClass="input"  size="4" maxlength="4" onchange="return VerifFormat(this.name);"
						onblur="VerifDPG();" onchange="VerifDPG();"/>
						&nbsp;<a href="javascript:recherchePID('p_param12');" ><img border=0 src="/images/p_zoom_blue.gif"  alt="Rechercher Code Ligne BIP" title="Rechercher Code Ligne BIP" style="vertical-align : middle;"></a>
                        </td>       <!-- FENRCOMPTA1 -->
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
</div>
	<div id="bottomContainer">
			<div>&nbsp;</div>
	</div>
</div>
</body>
</html:html>

<!-- #EndTemplate -->