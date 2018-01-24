<!DOCTYPE html>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.util.*,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"   errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="paramLigneBipForm" scope="request" class="com.socgen.bip.form.ParamLigneBipForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_filtre_maj.dwt" --><head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>



<!-- #BeginEditable "doctitle" --> 
<title>Paramétrage</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/xLigneBipAd.jsp"/> 
<script language="JavaScript" src="../js/function.cjs"></script>
<!-- <link rel="stylesheet" href="../css/base_style.css" type="text/css"> -->
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));

%>
var pageAide = "<%= sPageAide %>";


function MessageInitial()
{
   var Message="<bean:write filter="false"  name="paramLigneBipForm"  property="msgErreur" />";
   var Focus = "<bean:write name="paramLigneBipForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }

}

function Verifier(form, action, flag, type_action)
{
   blnVerification = flag;
   form.action.value = action;
   form.type_action.value = type_action;
   
} 

function ValiderEcran(form)
{
     return true;
}

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
            <div id="outils" align="center"><!-- #BeginEditable "barre_haut" -->
              <%ToolBarNew tb = new com.socgen.ich.ihm.ToolBarNew("bip_ihm",false,false,true,true,false,false,false,false,false,request) ;%>
				<%=tb.printHtml()%><!-- #EndEditable -->
		</div>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
<!--         <tr>  -->
<!--           <td background="../images/ligne.gif"></td> -->
<!--         </tr> -->
        <tr> 
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Paramétrage de l'édition Ligne BIP<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td>
		  <!-- #BeginEditable "debut_form" -->
		  <html:form action="/paramLigneBip.do" enctype="multipart/form-data" onsubmit="return ValiderEcran(this);">
		  <div align="center"><!-- #BeginEditable "contenu" -->
           <input type="hidden" name="pageAide" value="<%= sPageAide %>">
            
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<html:hidden property="action" value="creer"/>
			<html:hidden property="type_action" value="modifier"/>
                      

		<table width="100%" border="0">
		
		       
                <tr> 
                  <td height ="30" colspan="2">&nbsp;</td>
                </tr>
                 <tr> 
                  <td colspan="2">&nbsp;</td>
                </tr>
                 <tr> 
                  <td colspan="2">&nbsp;</td>
                </tr> <tr> 
                  <td colspan="2">&nbsp;</td>
                </tr>
                 <tr> 
                  <td colspan="2">&nbsp;</td>
                </tr>
                 <tr> 
                  <td colspan="2">&nbsp;</td>
                </tr>
                 <tr> 
                  <td colspan="2">&nbsp;</td>
                </tr>
		
		
		
		         <tr>
		         <td height="20" width="30%">&nbsp;</td> 
		         <td width="60%" align="left">  
		         <html:submit property="boutonModifier" value="          Sélection de champs          " styleClass="input" onclick="Verifier(this.form, 'modifier', true, 'modifier_selection');"/>
		         </td>
		         <td width="30%">&nbsp;</td> 
                 </tr>
                 
                 <tr><td height="20">&nbsp;</td></tr>
                 
                 <tr>
                 <td width="30%">&nbsp;</td> 
                 <td  width="60%" align="left">  
                 <html:submit property="boutonCreer" value="            Libellé de champs             " styleClass="input" onclick="Verifier(this.form, 'modifier', true, 'modifier_libelle');"/>
                 </td>
                 <td width="30%">&nbsp;</td> 
                 </tr>
                 
                 <tr><td height="20">&nbsp;</td></tr>
                 
                 <tr>
                 <td width="30%">&nbsp;</td> 
                 <td width="60%" align="left">  
                 <html:submit property="boutonSupprimer" value="                Type de lignes                " styleClass="input" onclick="Verifier(this.form, 'modifier', true, 'modifier_type');"/>
                 </td>
                 <td width="30%">&nbsp;</td> 
                 </tr>
                 
                 <tr><td height="20">&nbsp;</td></tr>
                 
                 <tr>
                 <td height="20" width="30%">&nbsp;</td> 
                 <td width="60%" align="left">  
                 <html:submit property="boutonAnnuler" value="                       Annuler                       " styleClass="input" onclick="Verifier(this.form, 'valider', true, 'defaut');"/>   	
                 </td>
                 <td width="30%">&nbsp;</td> 
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
