<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="codeCpForm" scope="request" class="com.socgen.bip.form.CodeCpForm" />

<html:html locale="true">
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/mCodeCpAd.jsp"/> 

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

function MessageInitial()
{
   var Message="<bean:write filter="false"  name="codeCpForm"  property="msgErreur" />";
   var Focus = "<bean:write name="codeCpForm"  property="focus" />";
   
   if (Message != "") {
      alert(Message);
   }      
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else {
	  document.forms[0].codsg.focus();	  
   }
   
}

function Verifier(form, action, mode, flag)
{
   blnVerification = flag;
   form.mode.value = mode;
   form.action.value = action;   
}

function ValiderEcran(form)
{
   if (blnVerification) {
   	if (form.codsg && !ChampObligatoire(form.codsg, "le dpg")) return false;
	if (form.pcpi && !ChampObligatoire(form.pcpi, "le code chef de projet")) return false;	
	if (form.nouveau_pcpi && !ChampObligatoire(form.nouveau_pcpi, "le nouveau code chef de projet")) return false;
	
	if (!confirm("Voulez-vous modifier les codes chef de projets des lignes et ressources ?")){
	 return false;
	}	
   }
   
   return true;
}

function rechercheDPG() {
	window.open("/recupDPG.do?action=initialiser&nomChampDestinataire=codsg&windowTitle=Recherche Code DPG&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
}

function nextFocusPCPI() {
	document.forms[0].pcpi.focus();
}

function rechercheID(pcpi){
	window.open("/recupIdPersonneType.do?action=initialiser&rtype=R&nomChampDestinataire="+pcpi+"&windowTitle=Recherche Identifiant Chef de projet&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
}  

function nextFocusCP(){
document.forms[0].nouveau_pcpi.focus();
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Modification des codes chef de projet
          <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> </td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/codecp"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <table width="100%" border="0">
               
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
				<input type="hidden" name="pageAide" value="<%= sPageAide %>"> 
				  <html:hidden property="action"/>
				<html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
				<html:hidden property="flaglock"/>
				  
                    <table width="60%" cellspacing="2" cellpadding="2" class="tableBleu">
                      <tr> 
                        <td colspan="2">&nbsp;</td>
                      </tr>    
                                        
                     
	                <tr>      
	                <td colspan="7">
	                  
	                  <b>Attention: </b>vous allez modifier les codes
	                  chef de projets des lignes et des ressources.
	                 
	                  </td>
	                </tr>  
			<tr> 
                        	<td>&nbsp;</td>
                        	<td>&nbsp;</td>
                        <tr>                
	                <tr> 
	                  <td class="lib" width="38%"><b>Entrez un  DPG :</b></td>
	                  <td>                    
	                  	<html:text property="codsg" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,7,0);"/>  
	                  	<a href="javascript:rechercheDPG();" onFocus="javascript:nextFocusPCPI();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code DPG" title="Rechercher Code DPG" align="absbottom"></a>
	                  </td>                  
	                </tr>                 
	                <tr>
	                  <td class=lib><b>Ancien code CP :</b></td>
	                  <td>
	                    <html:text property="pcpi" styleClass="input" size="5" maxlength="5" onchange="return VerifierNum(this,5,0);"/>                   
	                     &nbsp;&nbsp;&nbsp;<a href="javascript:rechercheID('pcpi');" onFocus="javascript:nextFocusCP();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Identifiant" title="Rechercher Identifiant" align="absbottom"></a>	
	                  </td>                   
	                </tr>
	                <tr>
	                  <td class=lib><b>Nouveau code CP :</b></td>
	                  <td>
	                  <html:text property="nouveau_pcpi" styleClass="input" size="5" maxlength="5" onchange="return VerifierNum(this,5,0);"/>                   
	                  &nbsp;&nbsp;&nbsp;<a href="javascript:rechercheID('nouveau_pcpi');" onFocus="javascript:nextFocusCP();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Identifiant" title="Rechercher Identifiant" align="absbottom"></a>
	                  </td>                   
	                </tr>                
                      <tr> 
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      <tr> 
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      <tr> 
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                    </table>
                    <table width="100%" border="0">
                      <tr> 
                        <td width="25%" colspan="2">&nbsp;</td>
                        <td width="25%"> 
                          <div align="center"> 
                          	<html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', 'update',true);"/>
                          </div>
                        </td>                        
                        <td width="25%">&nbsp;</td>
                      </tr>
                    </table>
                    <!-- #EndEditable --></div>
                </td>
              </tr>
            </table>
            <!-- #BeginEditable "fin_form" --></html:form><!-- #EndEditable --> 
          </td>
        </tr>
        <tr> 
          <td>&nbsp; </td>
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
<% 
Integer id_webo_page = new Integer("5002"); 
com.socgen.bip.commun.form.AutomateForm formWebo = codeCpForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
