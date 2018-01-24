<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="investissementForm" scope="request" class="com.socgen.bip.form.InvestissementForm" />
<jsp:useBean id="listedyn" scope="request" class="com.socgen.bip.commun.liste.ListeDynamique" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fmInvAd.jsp"/> 
<%
  java.util.ArrayList list1 = com.socgen.bip.commun.liste.ListeGlobale.getListeGlobale("natureInvestissments");  
  java.util.ArrayList list2 = com.socgen.bip.commun.liste.ListeGlobale.getListeGlobale("posteInvestissments");
  
  pageContext.setAttribute("choixNature", list1);
  pageContext.setAttribute("choixPoste", list2);

  /************ Liste Type investissements *****************/  
  java.util.ArrayList listeType = listedyn.getListeDynamique("type.investissements",investissementForm.getHParams());     
  pageContext.setAttribute("choixType", listeType);  
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


function MessageInitial()
{
   var Message="<bean:write filter="false"  name="investissementForm"  property="msgErreur" />";
   var Focus = "<bean:write name="investissementForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else if (document.forms[0].mode.value!='delete'){
	   document.forms[0].lib_type.focus();
   }
}

function Verifier(form, action, mode,flag)
{
   blnVerification = flag;
   form.action.value = action;
}

function ValiderEcran(form)
{
  if (blnVerification == true) {
     if (form.mode.value != 'delete') {	     
	if (!ChampObligatoire(form.lib_type, "le libellé du type d'investissement")) return false;
	form.lib_type.focus();	
     }
   

     if (form.mode.value == 'update') {
        if (!confirm("Voulez-vous modifier ce type d'investissement?")) return false;
     }
     if (form.mode.value == 'delete') {
        if (!confirm("Voulez-vous supprimer ce type d'investissement?")) return false;
     }
  }

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
          <bean:write name="investissementForm" property="titrePage"/> un type d'investissement<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/investissement"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
		<input type="hidden" name="pageAide" value="<%= sPageAide %>">
		  <html:hidden property="titrePage"/>
			<html:hidden property="action"/>
			<html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
			<html:hidden property="flaglock"/>
		<table cellspacing="2" cellpadding="2" class="tableBleu">
		<tr> 
                  <td >&nbsp;</td>
                  <td  >&nbsp;</td>
                </tr>
                <tr> 
                  <td >&nbsp;</td>
                  <td  >&nbsp; </td>
                </tr>
                <tr> 
                  <td class="lib"><b>Code du type d'investissement:</b></td>
                  <td> 
                    <bean:write name="investissementForm" property="type"/>
                    <html:hidden property="type"/> 
                  </td>
                </tr>
                <tr> 
                  <td class="lib"><b>Poste :</b></td>
                  <td> 
                  <logic:notEqual parameter="action" value="supprimer"> 
                    <html:select property="poste" styleClass="input"> 
	                    <html:options collection="choixPoste" property="cle" labelProperty="libelle" /> 
	                    </html:select> 
                    </logic:notEqual> 
                    <logic:equal parameter="action" value="supprimer"> 
                    <bean:write name="investissementForm" property="lib_poste"/>
                    <html:hidden property="poste"/> 
                    </logic:equal> </td>
                </tr>
                <tr> 
                  <td class="lib"><b>Nature :</b></td>
                  <td> 
                  <logic:notEqual parameter="action" value="supprimer"> 
                    <html:select property="nature" styleClass="input"> 
                    	<html:options collection="choixNature" property="cle" labelProperty="libelle" /> 
                    </html:select> 
                    </logic:notEqual> 
                    <logic:equal parameter="action" value="supprimer"> 
                    	<bean:write name="investissementForm" property="lib_nature"/>
                    	<html:hidden property="nature"/> 
                    </logic:equal> </td>
                </tr>                        
                <tr> 
                  <td class="lib"><b>Libell&eacute; du type :</b></td>
                  <td> <logic:notEqual parameter="action" value="supprimer"> 
                    <html:text property="lib_type" styleClass="input" size="32" maxlength="64" onchange="return VerifierAlphanum(this);"/>
                    </logic:notEqual> 
                    <logic:equal parameter="action" value="supprimer"> 
                    	<bean:write name="investissementForm" property="lib_type"/> 
                    	<html:hidden property="lib_type"/>                    
                    </logic:equal> 
                   </td>                   
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
              </table>
			  <!-- #EndEditable --></div>
          </td>
        </tr>
        <tr> 
          <td align="center"> 
            <table width="100%" border="0">
              <tr> 
                <td width="25%">&nbsp;</td>
                <td width="25%"> 
                  <div align="center"> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', this.form.mode.value,true);"/> 
                  </div>
                </td>
                <td width="25%"> 
                  <div align="center"> <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', null, false);"/> 
                  </div>
                </td>
                <td width="25%">&nbsp;</td>
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
Integer id_webo_page = new Integer("1019"); 
com.socgen.bip.commun.form.AutomateForm formWebo = investissementForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
