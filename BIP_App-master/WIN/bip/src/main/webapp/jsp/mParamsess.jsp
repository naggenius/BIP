<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,com.socgen.bip.commun.liste.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="paramsessionForm" scope="request" class="com.socgen.bip.form.ParamsessionForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_filtre.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="/paramsess.do"/> 


<%	

    com.socgen.bip.user.UserBip user = (com.socgen.bip.user.UserBip)session.getAttribute("UserBip");
    
%> 
 
<script language="JavaScript" src="../js/function.cjs"></script>
<script language="JavaScript" src="../js/menu.js"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
	String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	String sTest = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("test")));
	String sIndexMenu = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("indexMenu")));
	
%>
var pageAide = "<%= sPageAide %>";

function MessageInitial()
{
   var Message="<bean:write filter="false"  name="paramsessionForm"  property="msgErreur" />";
   var Focus = "<bean:write name="paramsessionForm"  property="focus" />";
   var erreurRTFE = "<bean:write name="paramsessionForm"  property="erreurRTFE" />" ;
   var tmpAction = "<bean:write name="paramsessionForm"  property="action" />" ;
   if (Message != "") {
      alert(Message);
      
   }
   
   if(erreurRTFE!=null && ""!=erreurRTFE){
   		window.open("/contacts.do?action=rtfe&type=paramsession"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=no, scrollbars=no, width=730, height=430") ;
   } else if(tmpAction == 'modifier') {
   	alert('Modification effectuée');
   	 document.forms[0].elements[5].focus();
   }
   
  if (Focus == "ok") {
     
      parent.frames.menu.location = "menu.jsp";
      parent.frames.main.location = "/paramsess.do?pageAide=<%= sPageAide %>&action=suite&mode=initial&test=ok&indexMenu="+<%=sIndexMenu%>;
      
   }
    test="<%=sTest%>";
 if (test=="ok") {//mise Ã  jour du menu
  		   parent.frames.menu.location="javascript:refreshMenu("+<%=sIndexMenu%>+")";
  }
}

function Verifier(form, action, flag)
{
  blnVerification = flag;
  form.action.value = action;
}
function ValiderEcran(form)
{
    return true;
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" --> 
            Modifier les param&egrave;tres de la session  <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/paramsess"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
            <input type="hidden" name="pageAide" value="<%= sPageAide %>">	
            <input type="hidden" name="indexMenu" value="<%= sIndexMenu %>">
            <html:hidden property="action"/>
			<html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
			 
			 
			    <table border=0 cellspacing=2 cellpadding=2 class="TableBleu">
                <tr> 
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                </tr>
                </table>
             <table border=0 cellspacing=2 cellpadding=2 class="TableBleu">
                <tr> 
                  <td>&nbsp;</td>
                </tr>
                
                                
                <tr> 
                  <td class="lib"><b>Menus :</b></td>
                  <td><html:text property="listeMenus" styleClass="input" size="60"/></td>                     
                </tr>
                <tr> 
                  <td class="lib"><b>Ss_Menus :</b></td>
                  <td><html:text property="sousMenus" styleClass="input" size="60"/></td>                     
                </tr>
                <tr> 
                  <td class="lib"><b>BDDPG_defaut</b> (7 caract&egrave;res):</td>
                   <td><html:text property="dpg_Defaut" styleClass="input" size="60"/></td>  
                </tr>
                 <tr> 
                  <td class="lib"><b>Perim_ME :</b></td>
                  <td><html:text property="perim_ME" styleClass="input" size="60"/></td>                     
                </tr>
                <tr> 
                  <td class="lib"><b>Perim_MO :</b></td>
                  <td><html:text property="perim_MO" styleClass="input" size="60"/></td>  
                </tr>
                <tr> 
                  <td class="lib"><b>Chef_Projet :</b></td>
                   <td><html:text property="chef_Projet" styleClass="input" size="60"/></td>  
                </tr>
                 <tr> 
                  <td class="lib"><b>MO_defaut :</b></td>
                  <td><html:text property="clicode_Defaut" styleClass="input" size="60"/></td>                     
                </tr>
                <tr> 
                  <td class="lib"><b>Perim_MCLI :</b></td>
                  <td><html:text property="perim_MCLI" styleClass="input" size="60"/></td>  
                </tr>
                <tr> 
                  <td class="lib"><b>Centre_Frais :</b></td>
                   <td><html:text property="liste_Centres_Frais" styleClass="input" size="60"/></td>  
                </tr>
                <tr> 
                  <td class="lib"><b>CA_Suivi :</b></td>
                  <td><html:text property="ca_suivi" styleClass="input" size="60"/></td>                     
                </tr>
                <tr> 
                  <td class="lib"><b>Projet :</b></td>
                  <td><html:text property="projet" styleClass="input" size="60"/></td>                     
                </tr>
                <tr> 
                  <td class="lib"><b>Appli :</b></td>
                   <td><html:text property="appli" styleClass="input" size="60"/></td>  
                </tr>
                 <tr> 
                  <td class="lib"><b>CA_FI :</b></td>
                   <td><html:text property="CAFI" styleClass="input" size="60"/></td>  
                </tr>
                 <tr> 
                  <td class="lib"><b>CA_Payeur :</b></td>
                   <td><html:text property="CAPayeur" styleClass="input" size="60"/></td>  
                </tr>
                 <tr> 
                  <td class="lib"><b>Doss_proj :</b></td>
                   <td><html:text property="dossProj" styleClass="input" size="60"/></td>  
                </tr>
                <tr> 
                  <td class="lib"><b>CA_DA :</b></td>
                   <td><html:text property="CADA" styleClass="input" size="60"/></td>  
                </tr>     
                <tr>
                  <td align=center>&nbsp;</td>
                </tr>
                <tr>
                  <td align=center>&nbsp;</td>
                </tr>
                <tr>
                  <td align=center>&nbsp;</td>
                </tr>
              </table>
              <!-- #EndEditable --></div>
          </td>
        </tr>
        <tr> 
          <td align="center"> 
            <table width="100%" border="0">
              <tr> 
                <td align="center"> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'modifier', true);"/> 
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
Integer id_webo_page = new Integer("1064"); 
com.socgen.bip.commun.form.AutomateForm formWebo = paramsessionForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
