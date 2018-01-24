<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"   errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="parametreForm" scope="request" class="com.socgen.bip.form.ParametreForm" />
<html:html locale="true"> 
<head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>


<title>Filtre Maj</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<bip:VerifUser page="jsp/fmParametreAd.jsp"/> 
<%
  java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("parametre",new java.util.Hashtable());

  pageContext.setAttribute("choixParametre", list1);
%>
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

var pageAide = "aide/hvide.htm";

function MessageInitial()
{
   var Message="<bean:write filter="false"  name="parametreForm"  property="msgErreur" />";
   var Focus = "<bean:write name="parametreForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
    if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
}

function Verifier(form, action, flag)
{
  blnVerification = flag;
  form.action.value = action;
}

function ValiderEcran(form) 
{
   var index = form.cle_param.selectedIndex;
   if (blnVerification==true) {
	if (index==-1) {
         alert("Choisissez un bloc applicatif");
	   return false;
	}
	 else form.mode.value='update';
   }
   return true;
} 
</script>


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
          <td height="20" class="TitrePage">Tables - Mise &agrave; jour de l'état de la BIP</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td>
		  <html:form action="/parametre"  onsubmit="return ValiderEcran(this);">
		  <div align="center">
			  <input type="hidden" name="pageAide" value="<%= sPageAide %>">
              <html:hidden property="action" value="modifier"/>
              <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
              <table cellspacing="2" cellpadding="2" class="tableBleu"   >
                <tr> 
                  <td colspan=2>&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan=2 align="center">D&eacute;marrage du serveur le : <b><%= application.getAttribute(com.socgen.bip.commun.BipConstantes.TIME_START_SERVER) %></b></td>
                </tr>
                <tr> 
                  <td colspan=2>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="lib" colspan=2 align=center><b>Variable</b></td>
                </tr>
                <tr> 
                  <td  colspan="2" align="center">
                  	<html:select property="cle_param" styleClass="input" size="5"> 
   						<html:options collection="choixParametre" property="cle" labelProperty="libelle" />
					</html:select>
				  </td>
				</tr>
                <tr> 
                  <td  colspan="2" align="center" >&nbsp;</td>
                </tr>
                <tr> 
                  <td  colspan="2" align="center" >&nbsp;</td>
                </tr>
                <tr> 
                  <td  colspan="2" align="center" >&nbsp;</td>
                </tr>
              </table>
              </div>
            
		</td>
		</tr>
		<tr>
		<td align="center">

		<table width="100%" border="0">
		
                <tr> 
				   <td width="100%" align="center">  
     				 <html:submit property="boutonModifier" value="Modifier" styleClass="input" onclick="Verifier(this.form, 'modifier', true);"/>
                  </td>
                </tr>
            
            </table>
		
			  </html:form>
          </td>
        </tr>
		<tr> 
          <td>&nbsp;  
          </td>
        </tr>
        <tr> 
          <td> 
            <div align="center"><html:errors/></div>
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