<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,com.socgen.bip.commun.liste.*"    errorPage="../jsp/erreur.jsp"  %>
<html:html locale="true"> 
<jsp:useBean id="budCopiValidMasseForm" scope="request" class="com.socgen.bip.form.BudCopiValidMasseForm" />
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<title>Page BIP</title>
 
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="/budCopiValidMasse.do"/> 
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">


<script language="JavaScript">
var blnVerification = true;
<%
	
	com.socgen.bip.user.UserBip userbip = (com.socgen.bip.user.UserBip)	session.getAttribute("UserBip");
	com.socgen.bip.menu.item.BipItemMenu menuCourant =  userbip.getCurrentMenu();
	String menu = menuCourant.getId();
	String titre;
	
	
	
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	int nbligne = 0;
		
	java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("datescopi",budCopiValidMasseForm.getHParams());
	 list1.add(0,new ListeOption("---", "---   A RENSEIGNER     ---" ));
	pageContext.setAttribute("listeDatesCopi", list1);
	
	java.util.ArrayList list2 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("dpcopi",budCopiValidMasseForm.getHParams()); 
	 list2.add(0,new ListeOption("---", "---   A RENSEIGNER     ---" ));
	 list2.add(1,new ListeOption("TOUS", "---   TOUS     ---" ));
	pageContext.setAttribute("listeDpcopi", list2);
	
	
	
%>
var pageAide = "<%= sPageAide %>";

var blnVerifFormat  = true;
var tabVerif = new Object();

function MessageInitial()
{
   var Message="<bean:write filter="false"  name="budCopiValidMasseForm"  property="msgErreur" />";
   var Focus = "<bean:write name="budCopiValidMasseForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }

   
}

function Verifier(form, action, mode,flag)
{
   blnVerification = flag;
   form.action.value = action;
   
}

function ValiderEcran(form)
{
	
	
	
	if (form.action.value == 'modifier') {
	
	if (form.date_copi.value=="---") 
	{
		alert("Veuillez renseigner une date COPI");
		return false;
	}
	if (form.dpcopi.value=="---") 
	{
		alert("Veuillez renseigner un DP COPI");
		return false;
	}

	}
	

	
   return true;
}




</script>
<!-- #EndEditable --> 

</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr><td>&nbsp;</td></tr>
        <tr><td> 
            <div align="center"><!-- #BeginEditable "barre_haut" --> 
              <%ToolBar tb = new com.socgen.ich.ihm.ToolBar("bip_ihm",false,false,true,false,false,false,false,false,false,request) ;%>
              <%=tb.printHtml()%><!-- #EndEditable --></div>
          </td></tr>
        <tr><td>&nbsp;</td></tr>
        <tr><td background="../images/ligne.gif"></td></tr>
        <tr><td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Outil validation Décision COPI (en JH)- Validation en masse - Selection<!-- #EndEditable --></td></tr>
        <tr><td background="../images/ligne.gif"></td></tr>
    </table>
     
    <html:form action="/budCopiValidMasse"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
    <input type="hidden" name="pageAide" value="<%= sPageAide %>">
     
         <html:hidden property="action"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
	<html:hidden property="mode" value="update"/>
	<html:hidden property="page" value="modifier"/>
	<input type="hidden" name="index" value="modifier">
	
    <table width="50%" border="0" cellpadding=2 cellspacing=2 class="tableBleu" align="center">
    	<tr><td colspan=6>&nbsp; </td></tr>
        <tr><td colspan=6>&nbsp; </td></tr>
        <tr><td class="lib"><b>Date Copi : </b></td>
            <td><html:select property="date_copi" name="budCopiValidMasseForm" styleClass="input"> 
				<html:options collection="listeDatesCopi" property="cle" labelProperty="libelle" />
				</html:select>
			</td>
		</tr>
		<tr>			                    
            <td class="lib"><b>Dossier Projet COPI :</b></td>
            <td><html:select property="dpcopi" name="budCopiValidMasseForm" styleClass="input"> 
				 <html:options collection="listeDpcopi" property="cle" labelProperty="libelle" />
				 </html:select>
		     </td>
        </tr> 	
      
        <tr><td colspan=6>&nbsp; </td></tr>
        <tr><td colspan=6>&nbsp; </td></tr>
        <tr><td colspan=6>&nbsp; </td></tr>
   	</table>
   	
   

	<table  border="0" width=50% align="center">
		<tr><td  align="center" ><html:submit property="boutonConsulter" value="Valider" styleClass="input" onclick="Verifier(this.form, 'modifier', true);"/></td>
		    <td  align="center" ><html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', true);"/></td>
		</tr>
    </table>

            <!-- #BeginEditable "fin_form" -->
	<!-- #EndEditable --> 
         
    <table>
    	<tr><td> 
            <div align="center"><html:errors/><!-- #BeginEditable "barre_bas" --><!-- #EndEditable --></div>
          	</td></tr>
    </table>


</html:form>                              
</body><% 
Integer id_webo_page = new Integer("1001"); 
com.socgen.bip.commun.form.AutomateForm formWebo = budCopiValidMasseForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
