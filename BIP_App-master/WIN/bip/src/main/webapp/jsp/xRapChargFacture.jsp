<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ page language="java" import="org.owasp.esapi.ESAPI,com.socgen.ich.ihm.*"   errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="rapportDemFactureForm" scope="request" class="com.socgen.bip.form.RapportDemFactureForm" />
<jsp:useBean id="listeRechercheId" scope="session"	class="com.socgen.ich.ihm.menu.PaginationVector" />
<html:html locale="true"> 



<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<title><bean:message key="bip.ihm.rapport.charge.facture.titre"  /></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<bip:VerifUser page="/rapportDematFactures.do"/> 
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";

function MessageInitial()
{
   var Message="<bean:write filter="false"  name="rapportDemFactureForm"  property="msgErreur" />";
   var Focus = "<bean:write name="rapportDemFactureForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
}
function submitForm(action,numCharg,type){
		this.document.forms[0].action.value = action;
		this.document.forms[0].submit();
	}
function popUpPage(numRelWidth, numRelHeight, strURL, strName){
	var numWidth = screen.Width*numRelWidth;
	var numHeight = screen.Height*numRelHeight;
	var numLeft = (screen.Width - numWidth)/2;
	var numTop = (screen.Height - numHeight)/2;
	var strParams = "menubar=0,location=0,directories=0, status=0,"
		+ "toolbar=0, resizable=1, scrollbars=1,"
		+ "height=" + numHeight + ", width=" + numWidth 
		+ ",left=" + numLeft + " ,top="+ numTop;

	var objWnd = window.open(strURL, strName, strParams);
	objWnd.focus(); 
}

function exporterLigne(numcharg,action) {
			popUpPage(0.50, 0.50, "<html:rewrite page="/exportExcellTraceChargFact.do"/>?numlot="+ numcharg+"&action="+action);       
}
function paginer(page, index , action){
	document.forms[0].action.value =action;
	document.forms[0].page.value=page;
    document.forms[0].index.value=index;
    document.forms[0].submit();
}
</script>
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" --><bean:message key="bip.ihm.rapport.charge.facture.titre"  /><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td>
		  <!-- #BeginEditable "debut_form" -->
		  <html:form action="/rapportDematFactures" enctype="multipart/form-data" onsubmit="return ValiderEcran(this);">
		  <div align="center"><!-- #BeginEditable "contenu" -->
           <input type="hidden" name="pageAide" value="<%= sPageAide %>">
            <html:hidden property="action" value="initialiser"/>
            <html:hidden property="page" value="modifier"/>
            
<html:hidden property="arborescence" value="<%= arborescence %>"/>
            <input type="hidden" name="index" value="modifier">
            <html:hidden property="numcharg" value=""/>
            
            <% int i =0;
                	String[] strTabCols = new String[] {  "fond1" , "fond2" }; 
            %> 
			<table id="my_table" width=80%>            	
             	<logic:present name="listeRechercheId">   
				<% if  	(listeRechercheId.size()>0){%>
					<tr>
						<td class="lib" width="10%" ><b><bean:message key="bip.ihm.rapport.charge.facture.entete.num"  /></b></td>
						<td class="lib" width="20%" ><b><bean:message key="bip.ihm.rapport.charge.facture.entete.fichier"  /></b></td>
 						<td class="lib" width="15%" ><b><bean:message key="bip.ihm.rapport.charge.facture.entete.date"  /></b></td>
 						<td class="lib" width="15%" ><b><bean:message key="bip.ihm.rapport.charge.facture.entete.user"  /></b></td>
 						<td class="lib" width="10%" ><b><bean:message key="bip.ihm.rapport.charge.facture.entete.factinteg"  /></b></td>
 						<td class="lib" width="10%" ><b><bean:message key="bip.ihm.rapport.charge.facture.entete.factrejet"  /></b></td>
 						<td class="lib" width="10" ><b><bean:message key="bip.ihm.rapport.charge.facture.entete.nbreenreg"  /></b></td>
 						<td class="lib" width="5" >
 						<td class="lib" width="5" >
 						
					</tr>
					<logic:iterate id="element"  name="listeRechercheId"  length="<%=listeRechercheId.getCountInBlock()%>" 
          					offset="<%=listeRechercheId.getOffset(0)%>"
							type="com.socgen.bip.metier.InfosTraitFacture"
							indexId="index"> 
							<% if ( i == 0) i = 1; else i = 0;%>
				   			<tr class="<%= strTabCols[i] %>">
								   	<td class="contenu" ><bean:write name="element" property="numfacture" /></td>
								   	<td class="contenu" ><bean:write name="element" property="nomFichier" /></td>
								   	<td class="contenu" ><bean:write name="element" property="dateChargement" /></td>
								   	<td class="contenu" ><bean:write name="element" property="utilisateur" /></td>
								   	<td class="contenu" ><bean:write name="element" property="nbreFactInteg" /></td>
								   	<td class="contenu" ><bean:write name="element" property="nbreFactRejet" /></td>								   	
								   	<td class="contenu" ><bean:write name="element" property="nbreEnreg" /></td>
								   	
								   	<% 
							  	    if ( new Integer(((com.socgen.bip.metier.InfosTraitFacture)element).getNbreFactInteg()) > 0) {%>
								   	<td class="contenu" >
 								   	    <input type="button"    name="boutonTraceInteg" value="Integ" onclick="javascript:exporterLigne('<bean:write name="element" property="numfacture" />','modifier');"/>
 								   	    </td>
								   	<%} else {%>	<td class="contenu" /><%} %>
								   	<% 
								   	if ( new Integer(((com.socgen.bip.metier.InfosTraitFacture)element).getNbreFactRejet()) > 0) {%>
								   	<td class="contenu"  >
 								   	    <input type="button"    name="boutonRejet" value="Rejet"  onclick="javascript:exporterLigne('<bean:write name="element" property="numfacture" />','creer');"/>
 								   	    </td>
								   	<%} else {%>	<td class="contenu" /><%} %>
	   						</tr>	   
					</logic:iterate>
					<tr>
						<td align="center" colspan="4" class="contenu">
							<bip:pagination beanName="listeRechercheId"/>
						</td>
					</tr>						
				<%}%>				
				</logic:present>                                           	                   
          	</table>  
			  <!-- #EndEditable --></div>
            </html:form>
			</td>
		</tr>
		<tr> 
          <td> 
            <div align="center"><html:errors/></div>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
 </body>
<% 
Integer id_webo_page = new Integer("1048"); 
com.socgen.bip.commun.form.AutomateForm formWebo = rapportDemFactureForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html> 
