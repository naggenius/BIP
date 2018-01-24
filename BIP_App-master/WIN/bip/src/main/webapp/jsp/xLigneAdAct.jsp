<!DOCTYPE html>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*, org.owasp.esapi.ESAPI"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="extractionForm" scope="request" class="com.socgen.bip.commun.form.ExtractionForm" />
<html:html locale="true">
<!-- #EndEditable --> 

<head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<!-- #BeginEditable "doctitle" --> 
<title>Extraction</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!-- #BeginEditable "fichier" -->
<bip:VerifUser page="jsp/xLigneAdAct.jsp"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<!-- <link rel="stylesheet" href="../css/base_style.css" type="text/css"> -->
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
var tabVerif = new Object();
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));

	com.socgen.bip.user.UserBip user = (com.socgen.bip.user.UserBip)session.getAttribute("UserBip") ;
	com.socgen.bip.menu.item.BipItemMenu menu = user.getCurrentMenu();
	String menuId = menu.getId();
%>
var pageAide = "<%= sPageAide %>";
<%
	String sTitre;
	String sInitial;
	String sJobId;
%>


function MessageInitial()
{
	<%
		sJobId = "xLigneAdAct";
	
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
	//KRA PPM 61346
	tabVerif["p_param9"] = "Ctrl_dpg_generique(document.extractionForm.p_param9)";
	var Message="<bean:write filter="false"  name="extractionForm"  property="msgErreur" />";
	var Focus = "<bean:write name="extractionForm"  property="focus" />";

   
   if (Message != "") {
      alert(Message);
   }
   else {
		if (Focus != "") {
			if (eval( "document.forms[0]."+Focus )){
				(eval( "document.forms[0]."+Focus )).focus();
			}
		}
		
		document.extractionForm.p_param9.value = "*******";
	}
	//FIN KRA PPM 61346
	
}

function Verifier(form, flag)
{
  MAJTypeExtract(form)
  blnVerification = flag;
}

function ValiderEcran(form) {
		//KRA PPM 61346
	if ( !VerifFormat(null) ) return false;	
	// Le DPG est obligatoire
	if (!ChampObligatoire(form.p_param9, "un code DPG")) return false;
	//Fin KRA PPM 61346	
//  PPR le 14/02/2005 : On ne demande plus de confirmation
//	if ( !confirm("Confirmez-vous la demande d'extraction ?") ) return false;
	document.extractionForm.submit.disabled = true;

	return true;
}

function MAJTypeExtract(form){
	
	// Cas d'un lancement par le menu habilitation par référentiel
	if (form.p_param8.value == "REF") {
		if (form.p_param6.value == ".CSV") {
			form.listeReports.value="6";
		}
		else {	
			form.listeReports.value="5";
		}
	}
	// Cas d'un lancement par les autres menus
	else {
		if ((form.p_param6.value == ".CSV") && (form.p_param7.value == "FOUR")){
			form.listeReports.value="2";
		}
		else if ((form.p_param6.value == ".TXT") && (form.p_param7.value == "FOUR_CLI")){
			form.listeReports.value="3";
		}
		else if ((form.p_param6.value == ".CSV") && (form.p_param7.value == "FOUR_CLI")){
			form.listeReports.value="4";
		}
		else form.listeReports.value="1";
	}
	return true;
}

//KRA PPM 61346
function rechercheDPG()
{
	window.open("/recupDPG.do?action=initialiser&nomChampDestinataire=p_param9&windowTitle=Recherche Code DPG&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
}
//Fin KRA PPM 61346

</script>

<!-- #EndEditable --> 


</head>

<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
<div id="mainContainer">
<div id="topContainer" style="min-height:98%;">
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
        <tr> 
<!--           <td background="../images/ligne.gif"></td> -->
        </tr>
        <tr> 
          <td height="20" class="TitrePage"><%=sTitre%></td>
        </tr>
        <tr> 
<!--           <td background="../images/ligne.gif"></td> -->
        </tr>
        <tr> 
          <td> 
            
          </td>
        </tr>
        <tr> 
          <td>
		  <html:form action="/extract"  onsubmit="return ValiderEcran(this);">
			<!-- #BeginEditable "debut_hidden" -->	
            
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<input type="hidden" name="jobId" value="<%=sJobId%>">
            <input type="hidden" name="initial" value="<%= sInitial %>">
            <input type="hidden" name="pageAide" value="<%= sPageAide %>">
            <input type="hidden" name="p_param8" value="<%= menuId %>">
            
			<!--           Debut HMI PPM : 63999 -->
            <input type="hidden" name="listeReports" value="2">
            <!--           Fin HMI PPM : 63999 -->
            
			<!-- #EndEditable -->

            <table width="100%" border="0">
            <tr><td height="20"></td></tr>
                <tr> 
                  <td> 
                    <div align="center">
                      <!-- #BeginEditable "contenu" -->
					<table border=0 cellspacing=5 cellpadding=0 class="tableBleu" >
					<!-- KRA PPM 61346 -->
					<tr><td colspan=5 align="center">&nbsp;</td></tr>
					<tr align="left">
							<td colspan=1 class="texte" align=right><B>Code DPG :</B></td>
							<td class="texte" colspan=1 align=left><html:text property="p_param9" styleClass="input"  size="7" maxlength="7" onchange="return VerifFormat(this.name);"/>
							&nbsp;<a href="javascript:rechercheDPG();" ><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code DPG" title="Rechercher Code DPG" style="vertical-align : middle;"></a>   
					                    </td>
					</tr>	
					<!-- Fin KRA PPM 61346 -->					
					<tr>
                        <td colspan=2 align="center">&nbsp;</td>
                    </tr>
					<tr align="left">
						<td colspan=1 class="texte" align=right><b>Extension du fichier :</b>&nbsp;</td>
						<td colspan=1 >
                          <select name="p_param6" class="input" onChange="return MAJTypeExtract(this.form)">
							<option value=".CSV" SELECTED>.CSV</option>
							<option value=".TXT">.TXT</option>
                          </select>
						</td>
                    </tr>
                    <tr>
                        <td colspan=2 align="center">&nbsp;</td>
                    </tr>
					<tr align="left">
					<%
						// On n'affiche pas le choix client / fournisseur si on est sur le menu référentiel
						if ( !menuId.equals("REF") )
						{
					%>						
						<td colspan=1 class="texte" align=right><b>Lignes Retournées :</b>&nbsp;</td>
						<td colspan=1>
                          <select name="p_param7" class="input" onChange="return MAJTypeExtract(this.form)">
							<option value="FOUR" SELECTED>Fournisseurs</option>
							<option value="FOUR_CLI">Clients et Fournisseurs</option>
                          </select>
						</td>
					<%
						}
					%>						
						
                    </tr>
			   		</table>
					
					  <!-- #EndEditable -->
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
				  <html:submit value="Extraire" styleClass="input" onclick="Verifier(this.form, true);"/>

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

