<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-nested.tld" prefix="nested" %>

<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.util.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,com.socgen.bip.commun.liste.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="favoriRessourceForm" scope="session" class="com.socgen.bip.form.FavoriRessourceForm" />
<bean:size id="taille" name="favoriRessourceForm" property="listeFavori"/>
<html:html locale="true"> 

<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<title>Page BIP</title>
 
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fSoustachecopierSr.jsp"/> 
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">


<script language="JavaScript">
var blnVerification = true;
<%

	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
int nbligne = 0;
	  String[] strTabCols = new String[] {  "fond1" , "fond2" };
	  
	   int i =0; 

	  
	  
%>
var pageAide = "<%= sPageAide %>";

var blnVerifFormat  = true;
var tabVerif = new Object();

function MessageInitial()
{
   var Message="<bean:write filter="false"  name="favoriRessourceForm"  property="msgErreur" />";
   var Focus = "<bean:write name="favoriRessourceForm"  property="focus" />";
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

function Select_all(obj) {

	var oForm = document.getElementById("favoriRessourceForm");
	
	for ( i = 0 ; i < oForm.elements.length ; i++ ) {
		oElement = oForm.elements[i] ;
		// tagName permet de connaître le nom de l'élément
		// Je ne m'intéresse qu'aux <input> de type checkbox
		// Les .toLowerCase( ) me permettent d'être insensible à la casse
		if ( oElement.tagName.toLowerCase( ) == "input" ) {
			if ( oElement.type.toLowerCase( ) == "checkbox" ) {
			// decalage par rapport a l evenement souris et le changement de valeur
				if ( obj.checked == true ) {
					oElement.checked = true;
				} else {
					oElement.checked = false;
				}
			}
		}
	}
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
<div id="mainContainer">
<div id="topContainer">
<div id="entete"></div>
<div id="logo">
		<div id="logo_sg"><img src="../images/logo_SG.gif" width="162" height="33" border="0" /></div>
		<div id="nomdusite"><img src="../images/bip_logo.png" width="78" height="46" border="0" /></div>
</div>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr><td> 
           <div id="outils" align="center"><!-- #BeginEditable "barre_haut" -->
              <%ToolBarNew tb = new com.socgen.ich.ihm.ToolBarNew("bip_ihm",false,false,true,true,false,false,false,false,false,request) ;%>
				<%=tb.printHtml()%><!-- #EndEditable -->
			</div>
          </td></tr>
        <tr><td>&nbsp;</td></tr>
        <tr><td height="20" class="TitrePage"><div id="titre" ><!-- #BeginEditable "titre_page" -->Gestion des ressources favorites<!-- #EndEditable --></div></td></tr>
    </table>
     
    <html:form action="/favoriRessource"  onsubmit="return ValiderEcran(this);" style="display:inline;"><!-- #EndEditable --> 
    <input type="hidden" name="pageAide" value="<%= sPageAide %>">
    <html:hidden property="action"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
	<html:hidden property="mode" value="update"/>
	<html:hidden property="page" value="modifier"/>
	<input type="hidden" name="index" value="modifier">
		
<br><br>

<div id="content">
<table  width="95%" >
<tr><td>
<div  id="tableContainer" class="tableContainer" align="center"    <% if (taille > 20)  {%>  style="overflow: scroll;"  <%} %>>
   	<table  width="100%" cellspacing=0 class="tableBleu1" align="center">
	<thead class="fixedHeader" id="fixedHeader">
   		<tr class="texteGras">
   		<th><input type="checkbox" id="c_all" onclick="Select_all(this);" /> Favori</th>
   		<th>Ratt. Direct</th>
   		<th>Code</th>
   		<th>&nbsp;</th>
   		<th>Nom</th>
   		<th>Prénom</th>
   		<th>Type</th>
   		
   	</tr>
   	</thead>
   	<tbody >

   	<logic:iterate id="favoriRessource" name="favoriRessourceForm" property="listeFavori" indexId="id" > 
    <% if ( i == 0) i = 1; else i = 0; nbligne ++;%>
	<tr class="contenu">

			<td class="<%= strTabCols[i] %>" width="10%" align="center" >
				<html:checkbox name="favoriRessource" property="favori" indexed="true" value="1"/>
			</td>
			<td class="<%= strTabCols[i] %>" width="10%" align="center"><bean:write name="favoriRessource" property="rattachementDirect" /></td>
			<td class="<%= strTabCols[i] %>" align="right" width="7%"><bean:write name="favoriRessource" property="ident" /></td>
			<td class="<%= strTabCols[i] %>" width="3%">&nbsp;</td>
			<td class="<%= strTabCols[i] %>" align="left" width="33%"><bean:write name="favoriRessource" property="nom" /></td>
			<td class="<%= strTabCols[i] %>" align="left" width="20%"><bean:write name="favoriRessource" property="prenom" /></td>
			<td class="<%= strTabCols[i] %>" align="left" width="17%"><bean:write name="favoriRessource" property="type" /></td>			
	</tr>
	</logic:iterate>	
   	</tbody>
 </table>
   </div>
</td></tr></table>
<br>
	<table  border="0" width=50% align="center">
		<tr><td  align="center" ><html:submit property="boutonConsulter" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', true);"/></td>
		    <td  align="center" ><html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', true);"/></td>
		</tr>
	
    </table>
</div>
            <!-- #BeginEditable "fin_form" -->
	<!-- #EndEditable --> 
         
    <table>
    	<tr><td> 
            <div align="center"><html:errors/><!-- #BeginEditable "barre_bas" --><!-- #EndEditable --></div>
          	</td></tr>
    </table>


</html:form>     
</div>
	<div id="bottomContainer">
			<div>&nbsp;</div>
	</div>
</div>                         
</body>
<% 
Integer id_webo_page = new Integer("6004"); 
com.socgen.bip.commun.form.AutomateForm formWebo = favoriRessourceForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
