<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-nested.tld" prefix="nested" %>

<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.util.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,com.socgen.bip.commun.liste.*"    errorPage="../jsp/erreur.jsp"  %>
<html:html locale="true"> 
<jsp:useBean id="budCopiValidMasseForm" scope="request" class="com.socgen.bip.form.BudCopiValidMasseForm" />

<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<title>Page BIP</title>
 
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="/budCopiMasse.do"/> 
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">


<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
int nbligne = 0;
	  String[] strTabCols = new String[] {  "fond1" , "fond2" };
	  
	   int i =0; 
	

	   Vector liste = new Vector();
	   liste =  (Vector) session.getAttribute("listeBudgetCopi");
	   int taille = liste.size();
	 
	  
		com.socgen.bip.user.UserBip userbip = (com.socgen.bip.user.UserBip)	session.getAttribute("UserBip");
		com.socgen.bip.menu.item.BipItemMenu menuCourant =  userbip.getCurrentMenu();
		String menu = menuCourant.getId();
		
		
		
	
%>
var pageAide = "<%= sPageAide %>";

var blnVerifFormat  = true;
var tabVerif = new Object();
var taille = "<%= taille %>";

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
	

	
   return true;
}



</script>
<style type="text/css">

div.tableContainer {

	clear: both;
	display:block;
	height: 400px;
	text-align: left;

	
}


.tableBleu1{
	font: normal 7pt Verdana,Arial,Helvetica,sans-serif;
	color: #000066;
	
}


body { 
  text-align: center; /* pour corriger le bug de centrage IE */ 
}



/* set table header to a fixed position. WinIE 6.x only                                       */
/* In WinIE 6.x, any element with a position property set to relative and is a child of       */
/* an element that has an overflow property set, the relative value translates into fixed.    */
/* Ex: parent element DIV with a class of tableContainer has an overflow property set to auto */
thead.fixedHeader tr {
	position: relative;
	top: expression(document.getElementById("tableContainer").scrollTop);
}



/* make the TH elements pretty */
thead.fixedHeader th {
	background: #DDDDFF;
	text-align: center
}


</style>

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
        <tr><td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Outil validation Décision COPI (en JH)- Validation en masse<!-- #EndEditable --></td></tr>
        <tr><td background="../images/ligne.gif"></td></tr>
    </table>
     
    <html:form action="/budCopiValidMasse"  onsubmit="return ValiderEcran(this);" style="display:inline;"><!-- #EndEditable --> 
    <input type="hidden" name="pageAide" value="<%= sPageAide %>">
    <html:hidden property="action"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
	<html:hidden property="mode" value="update"/>
	<html:hidden property="page" value="modifier"/>
	<input type="hidden" name="index" value="modifier">
		
    <table width="50%" border="0"  cellspacing=0 class="tableBleu" align="center">
    	<tr>
      <td>&nbsp;</td>
      </tr>
        <tr><td class="lib"><b>Date Copi : </b></td>
            <td><bean:write name="budCopiValidMasseForm"  property="date_copi" />
            	<html:hidden property="date_copi"/>
			</td>
				                    
            <td class="lib"><b>Dossier Projet COPI :</b></td>
            <td><bean:write name="budCopiValidMasseForm"  property="dpcopi" />
            <html:hidden property="dpcopi"/>
		    </td>
       </tr>
      <tr>
      <td>&nbsp;</td>
      </tr>
       </table>

<table width="98%">
<tr>
<td>
<div id="tableContainer" class="tableContainer" align="center"    <% if (taille > 15)  {%>  style="overflow: scroll;"  <%} %>>
   	<table  width="100%" cellspacing=0 class="tableBleu1" align="center">
<thead class="fixedHeader" id="fixedHeader">
   		<tr align="center" class="lib">
   		<th>Date COPI</th>
   		<th>DP COPI</th>
   		<th>Année</th>
   		<th>Métier</th>
   		<th>Fournisseur</th>
   		<th>Type Demande</th>
   		<th width="8%" >Demandé</th>
   		<th width="8%" >Décidé</th>
   		<th width="8%" >Cantonné Demandé</th>
   		<th width="8%" >Cantonné Décidé</th>
   		<th width="8%" >Prévisionnel Demandé</th>
   		<th width="8%" >Prévisionnel Décidé</th>
   		
   	</tr>
   	</thead>
   	<tbody >
   		<%
   		Object obudgetCopi=null;
		Class[] parameterString = {};
		String libBudget;
		String budgetCopi="";
   		%> <logic:iterate id="element" name="listeBudgetCopi" type="com.socgen.bip.metier.BudCopiValidMasse" > 
    <% if ( i == 0) i = 1; else i = 0; nbligne ++;%>
	<tr class="contenu" align="center" >
	<html:hidden name="element" property="code_four_copi"/>
	<html:hidden name="element" property="code_type_demande"/>
			<td class="<%= strTabCols[i] %>"><bean:write name="element" property="date_copi" /></td>
			<td class="<%= strTabCols[i] %>"><bean:write name="element" property="dpcopi" /></td>
			<td class="<%= strTabCols[i] %>"><bean:write name="element" property="annee" /></td>
			<td class="<%= strTabCols[i] %>"><bean:write name="element" property="metier" /></td>
			<td class="<%= strTabCols[i] %>"><bean:write name="element" property="four_copi" /></td>
			<td class="<%= strTabCols[i] %>"><bean:write name="element" property="type_demande" /></td>
								<%
							for(int k=1;k<7;k++) {
								
								libBudget="budgetCopi_"+nbligne+"_"+k;
				                Object[] param1 = {};
				         
				                obudgetCopi= element.getClass().getDeclaredMethod("getBudgetCopi_"+k,parameterString).invoke((Object) element, param1);
				            	   if (obudgetCopi!=null) budgetCopi=obudgetCopi.toString();
				            	   else budgetCopi="";%>			
		<td class="<%= strTabCols[i] %>" width="8%"><input class=input type='text' size="6" maxlength="6"   name="<%=libBudget%>" value="<%=budgetCopi%>" onchange="return VerifierNumNegatif(this,5,0);" ></td>
	<%} %></tr>
	</logic:iterate>	
   	</tbody>
 </table>
   </div>
</td>
</tr>
</table>
<br>
	<table  border="0" width=50% align="center">
		<tr><td  align="center" ><html:submit property="boutonConsulter" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', true);"/></td>
		    <td  align="center" ><html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'initialiser', true);"/></td>
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
