 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/ajaxtags.tld" prefix="ajax"%>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"   errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="applicationForm" scope="request" class="com.socgen.bip.form.ApplicationForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_filtre_maj.dwt" --><head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
<jsp:include page="ajax.jsp" flush="true" />



<!-- #BeginEditable "doctitle" --> 
<title>Filtre Maj</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fmApplicationAd.jsp"/> 
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href=""../css/base_style.css" type="text/css">
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
    var Message="<bean:write filter="false"  name="applicationForm"  property="msgErreur" />";
   var Focus = "<bean:write name="applicationForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
  if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else {
	  document.forms[0].airt.focus();
   }
}

function Verifier(form, action, flag)
{
  blnVerification = flag;
  form.action.value =action;
}
function ValiderEcran(form)
{
   if (blnVerification==true) {
	if (!ChampObligatoire(form.airt, "un identifiant application")) return false;
/*if ((document.forms[0].airt.value.substr(0,1) != "A") || (document.forms[0].airt.value.length > 5)) 
	{
		alert("Mauvais code Application, syntaxe: Axxxx");
		return false;
	}*/
   }
   return true;
}

function rechercheAppli(){
	window.open("/recupAppli.do?action=initialiser&nomChampDestinataire=airt&windowTitle=Recherche Code Application&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
}
function nextFocusAppli(){	
	document.forms[0].boutonCreer.focus();
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Gestion des applications<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td>
		  <!-- #BeginEditable "debut_form" --><html:form action="/application"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable -->
		  <div align="center"><!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>">
            
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<html:hidden property="action" value="creer"/>
              <table border=0  cellpadding=2 cellspacing=2 class="tableBleu">
                <tr> 
                  <td align=center colspan=2>&nbsp;</td>
                </tr>
                <tr> 
                  <td align=center colspan=2>&nbsp;</td>
                </tr>
                <tr> 
                  <td align=center  ><b>Code application ou libellé :</b></td>
                  <td> 
                  <html:text property="airt" styleClass="input" size="6" maxlength="5" onchange="return VerifierAlphaMax(this);"/>
                   <span
								id="indicator3" style="display:none;"><img
								src="../images/indicator.gif" alt="" /></span>
                   
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
                  <td width="33%" align="right">  
                	 <html:submit property="boutonCreer" value="Cr&#233er" styleClass="input" onclick="Verifier(this.form, 'creer', true);"/>
                  </td>
				   <td width="33%" align="center">  
     				 <html:submit property="boutonModifier" value="Modifier" styleClass="input" onclick="Verifier(this.form, 'modifier', true);"/>
                  </td>
				   <td width="33%" align="left">  
					<html:submit property="boutonSupprimer" value="Supprimer" styleClass="input" onclick="Verifier(this.form, 'supprimer', true);"/>
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
<ajax:autocomplete source="airt" target="airt"
	parameters="libelle={airt}" baseUrl="/autocompleteAppli.do"
	className="autocomplete" indicator="indicator3" minimumCharacters="1" />

<!-- #EndTemplate -->