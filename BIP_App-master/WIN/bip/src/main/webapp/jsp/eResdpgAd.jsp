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
<bip:VerifUser page="jsp/eResdpgAd.jsp"/>
<jsp:useBean id="UserBip" scope="session" class="com.socgen.bip.user.UserBip" />
<script language="JavaScript" src="../js/function.cjs"></script>
	
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
	String sJobId="e_deresdpg";
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
	
	var Message="<bean:write filter="false"  name="editionForm"  property="msgErreur" />";
	var Focus = "<bean:write name="editionForm"  property="focus" />";
	
	tabVerif["p_param6"] = "Ctrl_dpg_generique(document.editionForm.p_param6)";
	
	if (Message != "") {
		alert(Message);
	}
	else
	{
		document.editionForm.p_param6.value = Replace_DoubleZero_by_DoubleEtoile( "<bean:write name="UserBip"  property="dpg_Defaut" />" );
	}
}

function Verifier(form, bouton, flag)
{
  blnVerification = flag;
  //form.BOUTON.value = bouton;
}

function majListe()
{
	sListe = "3";
	if (document.editionForm.listeReports[0].checked)
	{
	sListe="1";
	}
	if (document.editionForm.listeReports[1].checked)
	{
	sListe="2";
	}
	if (document.editionForm.listeReports[2].checked)
	{
	sListe="3";
	}
	document.editionForm.p_param7.value = sListe;
	
}

function ValiderEcran(form)
{
	var RE = new RegExp('[0-9]{6}');
	
	if (blnVerification)
	{
		if ( !VerifFormat(null) ) return false;
		if (!ChampObligatoire(form.p_param6, "un code DPG")) return false;
			
	}
	//form.VerifExecJS.value = 1;
	document.editionForm.submit.disabled = true;
	return true;
}


function rechercheDPG()
{
	window.open("/recupDPG.do?action=initialiser&nomChampDestinataire=p_param6&windowTitle=Recherche Code DPG&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
}

function nextFocusCodeDPG(){
	document.forms[0].p_param6.focus();
}

function majcheckbox1()
{
	p_param8='';
	if (document.editionForm.typeressource[0].checked)
	{
	document.editionForm.typeressource[1].checked = false;
	document.editionForm.typeressource[2].checked = false;
	document.editionForm.typeressource[3].checked = false;
	document.editionForm.typeressource[4].checked = false;
	document.editionForm.typeressource[5].checked = false;
	}
	p_param8 = 'TOUS';
	document.editionForm.p_param8.value = p_param8;
	
}
function majcheckbox2()
{
	p_param8='';
	if (document.editionForm.typeressource[1].checked ||
	document.editionForm.typeressource[2].checked ||
	document.editionForm.typeressource[3].checked ||
	document.editionForm.typeressource[4].checked ||
	document.editionForm.typeressource[5].checked )
	{
	document.editionForm.typeressource[0].checked = false;
	}
	
	if (document.editionForm.typeressource[1].checked)
	{
		p_param8 = p_param8+"/"+document.editionForm.typeressource[1].value+"/,";
	}
	if (document.editionForm.typeressource[2].checked)
	{
		p_param8 = p_param8+"/"+document.editionForm.typeressource[2].value+"/,";
	}
	if (document.editionForm.typeressource[3].checked)
	{
		p_param8 = p_param8+"/"+document.editionForm.typeressource[3].value+"/,";
	}
	if (document.editionForm.typeressource[4].checked)
	{
		p_param8 = p_param8+"/"+document.editionForm.typeressource[4].value+"/,";
	}
	if (document.editionForm.typeressource[5].checked)
	{
		p_param8 = p_param8+"/"+document.editionForm.typeressource[5].value+"/,";
	}
	document.editionForm.p_param8.value = p_param8;
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
		<tr > 
		  <td> 
            <div id="outils" align="center"><!-- #BeginEditable "barre_haut" -->
              <%ToolBarNew tb = new com.socgen.ich.ihm.ToolBarNew("bip_ihm",false,false,true,true,false,false,false,false,false,request) ;%>
				<%=tb.printHtml()%><!-- #EndEditable -->
			</div>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td height="20" class="TitrePage"><div id="titre" ><!-- #BeginEditable "titre_page" --><%=sTitre%><!-- #EndEditable --></div></td>
        </tr>
        <tr> 
          <td> 
            
          </td>
        </tr>
        <tr> 
          <td>
          <div id="content">
		  <!-- #BeginEditable "debut_form" --><html:form action="/edition"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable -->
			<!-- #BeginEditable "debut_hidden" -->
			<input type="hidden" name="p_param9" value="">
			<input type="hidden" name="p_param8" value="TOUS">
			<input type="hidden" name="p_param7" value="">
			
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
                        <td align="center">&nbsp;</td>
                      </tr>
                   
					  <tr>
                        <td class="texte" colspan=4><b>Entrez le code DPG de l'entit&eacute; dont vous voulez la liste des ressources :</b></td>
                      </tr>
					  <tr align="left">
						<td class="texte"><B>Code DPG :</B></td>
                        <td align=left><html:text property="p_param6" styleClass="input"  size="7" maxlength="7" onchange="return VerifFormat(this.name);"/>
                        &nbsp;&nbsp;<a href="javascript:rechercheDPG();" onFocus="javascript:nextFocusCodeDPG();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code DPG" title="Rechercher Code DPG" align="absbottom"></a>   
                        </td>
                      </tr>
					  <tr align="left">
						<td class="texte" ><b>D&eacute;tail :</b></td>
                          <td class="texte"><input type=radio name="listeReports" value="1" onChange="majListe();">
                          par d&eacute;partement</td>
                          
                          <td class="texte"><input type=radio name="listeReports" value="2" onChange="majListe();">
                          par p&ocirc;le</td>
                          
                          <td class="texte"><input type=radio name="listeReports" value="3" checked onChange="majListe();">
                          par groupe</td>
                      </tr>
                      <tr align="left">
   						 <td rowspan=5 class="texte"><b>Type des ressources : </td>
   						 <td rowspan=5 class="texte"><input type=checkbox name="typeressource" value="TOUS" checked onClick="majcheckbox1();" > Tous</td>
   						 <td rowspan=5 class="texte"><b>ou </td>
    						<td class="texte"><input type=checkbox name="typeressource" value="A" onClick="majcheckbox2();"> Agents SG ou assimilés</td>
   					 </TR>
                     <TR align="left">
                       <TD class="texte"><input type=checkbox name="typeressource" value="P" onClick="majcheckbox2();"> Prestataires au temps passé</TD> 
                     </TR>
                        <TR align="left">
                              <TD class="texte"><input type=checkbox name="typeressource" value="E" onClick="majcheckbox2();"> Forfaits sans frais d'environnement</TD>
                      </TR>
                        <TR align="left">
                              <TD class="texte"><input type=checkbox name="typeressource" value="F" onClick="majcheckbox2();"> Forfaits avec frais d'environnement</TD>
                      </TR>
                        <TR align="left">
                              <TD class="texte"><input type=checkbox name="typeressource" value="L"  onClick="majcheckbox2();"> Logiciels</TD>
                      </TR>
					  <tr>
                        <td align="center">&nbsp;</td>
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
			  </div>
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