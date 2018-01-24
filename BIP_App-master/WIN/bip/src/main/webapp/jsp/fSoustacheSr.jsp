 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="sousTacheForm" scope="request" class="com.socgen.bip.form.SousTacheForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_filtre.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="/structLb.do"/>
<%  java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("isac_tachelb",sousTacheForm.getHParams());
    pageContext.setAttribute("choixTache", list1);

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
   var Message="<bean:write filter="false"  name="sousTacheForm"  property="msgErreur" />";
   var Focus = "<bean:write name="sousTacheForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
  if (document.forms[0].etapeTache.options[0].value==" ") {
 	document.forms[0].boutonValider.disabled=true;
 }
}

function Verifier(form, action, flag)
{
  blnVerification = flag;
  form.action.value = action;
}

function ValiderEcran(form)
{ 
   var tabIdent=new Object();	
 
    if (blnVerification) {
	if (form.etapeTache.selectedIndex==-1) {
		alert('Choisissez une tâche');
		return (false);
	}
  	 tabIdent = form.etapeTache.value.split("-");
  	form.etape.value=tabIdent[0];
  	form.tache.value=tabIdent[1];
	form.keyList1.value=form.etape.value;
	form.keyList2.value=form.tache.value;
	
	form.mode.value = 'tache';
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Gestion 
            des sous-t&acirc;ches d'une ligne BIP<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/sousTache"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
            <input type="hidden" name="pageAide" value="<%= sPageAide %>">
            <html:hidden property="action"/>
            <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
            <html:hidden property="keyList0"/> <!--pid-->
             <html:hidden property="keyList1"/> <!--n°etape-->
             <html:hidden property="keyList2"/> <!--n°tache-->
             <html:hidden property="keyList3"/> <!--ECET - LIBETAPE-->
             <html:hidden property="keyList4"/> <!--ACTA - LIBTACHE-->
             <html:hidden property="etape"/>
             <html:hidden property="tache"/>
            <html:hidden property="pid"/>
             <table border="0" cellpadding="0" cellspacing="0"   width="100%" class="tableBleu" >
	   		<tr>
				<td>&nbsp;</td>
    	   </tr>
		    <tr>
				<td>&nbsp;</td>
    	   </tr>
    	   </table>
    	   	<table border=2 cellspacing=0 cellpadding=10  class="TableBleu" bordercolor="#B980BF">
            <tr>
				<td align="center" height="10" > <b>Ligne BIP </b>:<b> <bean:write name="sousTacheForm"  property="lib" /><html:hidden property="lib"/></b>   
                </td>
            </tr> 
            </table>
            <table border="0" cellpadding="2" cellspacing="0" class="tableBleu" >
                <tr>
				<td>&nbsp;</td>
    	   		</tr>
		   	     <tr>
				<td>&nbsp;</td>
    	   		</tr>
                <tr> 
                  <td><b>Sélectionnez une tâche :</b> </td>
                </tr>
                <tr> 
                  <td class="texteGras" colspan="2">
                        <span STYLE="position: relative; left:  4px; z-index: 1;">Etape</span>
						<span STYLE="position: relative; left: 210px; z-index: 1;">Tâche</span>
                  </td>
                </tr>
                <tr> 
                  <td  align="center"> 
                     <html:select property="etapeTache" styleClass="Multicol" size="5">
						  <bip:options collection="choixTache"/>
					 </html:select> 
                  </td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                </tr>
                <tr> 
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
                <td width="25%" align="center"> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'suite', true);"/> 
                </td>
			    <td width="25%" align="center"><html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'retour', false);"/>
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
</body></html:html>
<!-- #EndTemplate -->
