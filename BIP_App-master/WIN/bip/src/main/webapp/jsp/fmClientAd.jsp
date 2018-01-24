<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"   errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="clientForm" scope="request" class="com.socgen.bip.form.ClientForm" />
<html:html locale="true">
<!-- #EndEditable -->  <!-- #BeginTemplate "/Templates/Page_filtre_maj.dwt" --><head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>



<!-- #BeginEditable "doctitle" --> 
<title>Filtre Maj</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fmClientAd.jsp"/>
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

var blnVerifFormat  = true;
var tabVerif = new Object();

function MessageInitial()
{
   tabVerif["clicode"] = "VerifierAlphaMax(document.forms[0].clicode)";
   var Message="<bean:write filter="false"  name="clientForm"  property="msgErreur" />";
   var Focus = "<bean:write name="clientForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
    if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else {
	  document.forms[0].clicode.focus();
   }
   
 

}

function Verifier(form, action, flag)
{
   blnVerification = flag;
   form.action.value = action;
}
function ValiderEcran(form)
{
   if (blnVerification) {
	if ( !VerifFormat(null) ) return false;
	if (!ChampObligatoire(form.clicode, "un code client")) return false;

   }

   return true;
}


function rechercheID(){
	window.open("/recupIdMo.do?action=initialiser&nomChampDestinataire=clicode&windowTitle=Recherche Code Client&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Mise &agrave; jour des Clients<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td>
		  <!-- #BeginEditable "debut_form" --><html:form action="/client" onsubmit="return ValiderEcran(this);"><!-- #EndEditable -->
		  <div align="center"><!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>">
			<!--input type="hidden" name="action" value="creer"-->
			
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<html:hidden property="action" value="creer"/>
                    <table width="100%" border="0" cellpadding=2 cellspacing=2 class="tableBleu">
                      <tr> 
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp; </td>
                      </tr>
                      <tr> 
                        <td align="center"><b>Code Client</b> : 
                        <!--input type="text" size="6" maxlength="5" name="clicode" onChange="return VerifFormat(this.name);"-->
						<html:text property="clicode" styleClass="input" size="6" maxlength="5" onchange="return VerifFormat(this.name);"/>&nbsp;&nbsp;
						<a href="javascript:rechercheID();"><img border=0 src="/images/p_zoom_blue.gif"  alt="Rechercher Code Client" title="Rechercher Code Client"></a>
                        </td>
                    	<tr> 
                        <td>&nbsp; </td>
                      </tr>
                      <tr> 
                        <td>&nbsp; </td>
                      </tr>
                      <tr> 
                        <td>&nbsp; </td>
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

<!-- #EndTemplate -->