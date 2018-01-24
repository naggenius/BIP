 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"   errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="projetForm" scope="request" class="com.socgen.bip.form.ProjetForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_filtre_maj.dwt" --><head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>



<!-- #BeginEditable "doctitle" --> 
<title>Filtre Maj</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fmProjetAd.jsp"/> 
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
   var Message="<bean:write filter="false"  name="projetForm"  property="msgErreur" />";
<!--   var Focus = "<bean:write name="projetForm"  property="focus" />"; -->
   var Focus = "icpi" ; 
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else {
	  document.forms[0].icpi.focus();
   }
}

function Verifier(form, action, duplic, flag)
{
  blnVerification = flag;
  form.action.value =action;
  form.duplic.value =duplic;
}

function ValiderEcran(form)
{
   if (blnVerification==true) 
   {
   	if (!ChampObligatoire(form.icpi, "un code projet informatique")) return false;
   	form.icpi.value = form.icpi.value.toUpperCase();
   }  
   return true;
}

function rechercheIdProjet(){
	window.open("/recupIdProjet.do?action=initialiser&nomChampDestinataire=icpi&windowTitle=Recherche du Code Projet&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450");
	return ;
}
function nextFocusCreer(){document.forms[0].boutonCreer.focus();}

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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Gestion des Projets informatiques<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td>
		  <!-- #BeginEditable "debut_form" --><html:form action="/projet"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable -->
		  <div align="center"><!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>">
            
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<html:hidden property="action" value="creer"/>
            <html:hidden property="duplic" value="NON"/>
              <table border=0  cellpadding=2 cellspacing=2 class="tableBleu">
                <tr> 
                  <td align=center colspan=2>&nbsp;</td>
                </tr>
                <tr> 
                  <td align=center colspan=2>&nbsp;</td>
                </tr>
                <tr> 
                  <td align=center  ><b>Code projet informatique :</b></td>
                  <td> 
                  	<html:text property="icpi" styleClass="input" size="6" maxlength="5" onchange="this.value = this.value.toUpperCase();return VerifierAlphaMax(this);"/>&nbsp;
					<a href="javascript:rechercheIdProjet();" onFocus="javascript:nextFocusCreer();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code Projet" title="Rechercher Code Projet" align="absbottom"></a>
                  </td>
                </tr>
                <tr> 
                  <td align=center colspan=2>&nbsp;</td>
                </tr>
                <tr> 
                  <td align=center colspan=2>&nbsp;</td>
                </tr>
                <tr> 
                  <td align=center colspan=2>&nbsp;</td>
                </tr>
              </table>
              <!-- #EndEditable --></div>
            
		</td>
		</tr>
		<tr>
		<td align="center">

			<table width="100%" border="0">
				<tr> 
            		<td width="25%" align="right">  
                		<html:submit property="boutonCreer" value="Cr&#233er" styleClass="input" onclick="Verifier(this.form, 'creer','NON', true);"/>
                	</td>
            		<td width="25%" align="center">  
                		<html:submit property="boutonDupliquer" value="Créer à partir de" styleClass="input" onclick="Verifier(this.form, 'modifier', 'OUI',true);"/>
                	</td>                	
					<td width="25%" align="center">  
     					<html:submit property="boutonModifier" value="Modifier" styleClass="input" onclick="Verifier(this.form, 'modifier', 'NON', true);"/>
                	</td>
					<td width="25%" align="left">  
						<html:submit property="boutonSupprimer" value="Supprimer" styleClass="input" onclick="Verifier(this.form, 'supprimer', 'NON', true);"/>
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