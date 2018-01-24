<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-nested.tld" prefix="nested" %>

<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="selectloupesimulimmoform" scope="session" class="com.socgen.bip.form.SelectLoupeSimulImmoForm" />

<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>


 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 

<!-- Page autorisÃ©e Ã  tous les utilisateurs -->
<bip:VerifUser page="jsp/eMonProfilAd.jsp"/>

<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
		
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
	String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	String sWindowTitle = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("windowTitle")));
	String rafraichir = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("rafraichir")));
	
	int i=0; 
	int nbligne=0;
	String[] strTabCols = new String[] {  "fond1" , "fond2" };
	
	selectloupesimulimmoform.setContexte(request.getParameter("contexte"));

	%>
var pageAide = "<%= sPageAide %>";




function MessageInitial()
{
   var Message="<bean:write filter="false"  name="selectloupesimulimmoform"  property="msgErreur" />";
   var Focus = "<bean:write name="selectloupesimulimmoform"  property="focus" />";
    
   if (Message != "") {
      alert(Message);
   }
  
  
 
}


function ValiderEcran(form)
{
     var action = "<%=rafraichir%>";
	 if(action == 'OUI')
	  {
	  	rafraichir(window.opener.document.forms[0]);
	  	window.opener.document.getElementById("extraire").style.visibility = "hidden";
	  	window.opener.document.getElementById("wait").style.display = "block";
	   }
	  window.close();
	return true;
}



function Verifier(form,action){
  
  form.action.value = action;
  return true;
 
}


function Quitter(){
 		window.close();
	}
    
    
function Select_all(obj) {

	var oForm = document.getElementById("selectloupesimulimmoform");
	
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
	<% if ("AXE".equals(selectloupesimulimmoform.getContexte())) {%>
	height: 400px;
	<%} else { %>
	height: 200px;
	<%} %>
	text-align: left;

	
}


.tableBleu1{
	font: normal 7pt Verdana,Arial,Helvetica,sans-serif;
	color: #000066;
	
}


body { 
  text-align: center; /* pour corriger le bug de centrage IE */ 
}


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
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr><td background="../images/ligne.gif"></td></tr>
        <tr><td height="20" class="TitrePage"><%= ESAPI.encoder().decodeFromURL(sWindowTitle) %></td></tr>
        <tr><td background="../images/ligne.gif"></td></tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
  </table>    
     
   <html:form action="/selectloupesimulimmo.do" onsubmit="return ValiderEcran(this);" style="display:inline;">
   	 <input type="hidden" name="pageAide" value="<%= sPageAide %>">
					 <html:hidden property="arborescence" value="<%= arborescence %>"/>
					 <html:hidden property="action" value="modifier"/>
                     <html:hidden property="page" value="modifier"/>
                     <html:hidden property="contexte"/>
                     <input type="hidden" name="windowTitle" value="<%= sWindowTitle %>">
                     
 <table width="75%" border="0">
              <tr><td> 
 <div  id="tableContainer" class="tableContainer" align="center" 
  <% 
  int limit;
  if ("AXE".equals(selectloupesimulimmoform.getContexte()))
	  limit = 17;
  else
	limit = 6;	
 
 if (selectloupesimulimmoform.getValeur_loupe().size() > limit)  {%>  style="overflow: scroll;"  <%} %>>
                     
                        	<table  width="100%" cellspacing=0 class="tableBleu1" align="center">
                        	<thead class="fixedHeader" id="fixedHeader">
   								<tr class="lib">
   									<th><input type="checkbox" id="c_all" onclick="Select_all(this);" /> Tous</th>
   									  <logic:equal parameter="contexte" value="AXE">   									
	   									<th>Enveloppe Budgétaire</th>
	   									</logic:equal> 
	   								<logic:notEqual parameter="contexte"value="AXE">
	   								 	<th>Type Financement</th> 
	   								</logic:notEqual>
   								</tr>
   							</thead>
   							<tbody>
   						  <%int index = 0; %>	 
                      	   <nested:iterate name="selectloupesimulimmoform" property="valeur_loupe" >
                      	    <% 
                      	    if ( i == 0) i = 1; else i = 0; nbligne ++;%>
   							  <tr class="contenu">
                             
               					    <td class="<%= strTabCols[i] %>" align="center">
               					
               					    <nested:checkbox property="select" value="1" />
               					   
               					                					    </td>
					 				<td class="<%= strTabCols[i] %>"><nested:write property="libelle" /></td>
					 				 <nested:hidden property="numero"/>
					 			</tr>     
					 			<% index++; %>	 
                			</nested:iterate>    
                			 </tbody>                    
                        </table>
                       
</div>
</table>
                  
<table  width="100%" border="0" cellspacing="0" cellpadding="0">
			   
	 			<tr><td colspan="4">&nbsp;
	 			</tr>
	 			<tr>
              		<td width="25%">&nbsp;</td>
                	<td width="25%">
                	 <div align="center">
                	  <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form,'valider');"/>                	                  	  
                	 </div>
               		</td> 
               		<td width="25%"> 
                  	 <div align="center">
                	  <html:button property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Quitter();"/>
              		 </div>
                </td>
                <td width="25%">&nbsp;</td>
            	</tr>
     
				</table>
               
           </html:form>
       
        <table>
        <tr> 
          <td> 
            <div align="center"><html:errors/><!-- #BeginEditable "barre_bas" --><!-- #EndEditable --></div>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
      </table>

</body>
</html:html>
<!-- #EndTemplate -->
              
       