<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,com.socgen.bip.commun.liste.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="consultLogsBipForm" scope="request" class="com.socgen.bip.form.ConsultLogsBipForm" />
<jsp:useBean id="listeRechercheId" scope="session"	class="com.socgen.ich.ihm.menu.PaginationVector" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Logs BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="/LogsBip.do"/> 
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	int nbligne = 0;
	
	java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("nom_shell",consultLogsBipForm.getHParams()); 
	  
	  pageContext.setAttribute("choixNomShell", list1);
	

%>
var pageAide = "<%= sPageAide %>";


function MessageInitial()
{
   var Message="<bean:write filter="false"  name="consultLogsBipForm"  property="msgErreur" />";
   var Focus = "<bean:write name="consultLogsBipForm"  property="focus" />";
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

function paginer(page, index , action){
	document.forms[0].action.value = action;
	document.forms[0].page.value   = page;
    document.forms[0].index.value  = index;
    document.forms[0].submit();
}
function clicMenu(num) { 

  // Booléen reconnaissant le navigateur (vu en partie 2)
  isIE = (document.all) 
  isNN6 = (!isIE) && (document.getElementById)

  // Compatibilité : l'objet menu est détecté selon le navigateur
  if (isIE) menu = document.all['description' + num];
  if (isNN6) menu = document.getElementById('description' + num);

  // On ouvre ou ferme
  if (menu.style.display == "none"){
    // Cas ou le tableau est caché
    menu.style.display = ""
  } else {
    // On le cache
    menu.style.display = "none"
   }
}
</script>


<!-- #EndEditable --> 
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">


<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr><td>&nbsp;</td></tr>
	<tr><td><div align="center">
              <%ToolBar tb = new com.socgen.ich.ihm.ToolBar("bip_ihm",false,false,true,false,false,false,false,false,false,request) ;%>
              <%=tb.printHtml()%>
         	</div></td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td background="../images/ligne.gif"></td></tr>
	<tr><td height="20" class="TitrePage"><bean:write name="consultLogsBipForm" property="titrePage"/> Logs BIP</td></tr>
	<tr><td background="../images/ligne.gif"></td></tr>
</table>

<html:form action="/LogsBip"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
<input type="hidden" name="pageAide" value="<%= sPageAide %>">
<html:hidden property="action"/>
<html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<html:hidden property="page" value="modifier"/>
<input type="hidden" name="index" value="modifier">

<table border=0  cellpadding=2 cellspacing=2 class="tableBleu" align="center" width="40%">
	<tr><td colspan="4" align="center"><b>Filtres</b></td></tr>
	<tr><td align="center" width="25%"><b>Début :</b>&nbsp;<html:text property="datedeb" styleClass="input" size="10" maxlength="11" onchange="return VerifierDate(this,'jj/mm/aaaa');"/></td>
        <td align="center" width="25%"><b>Fin :</b>&nbsp;<html:text property="datefin" styleClass="input" size="10" maxlength="11"  onchange="return VerifierDate(this,'jj/mm/aaaa');"/></td>
    	<td align="center" width="25%"><b>Shell :</b>&nbsp;
                                
                   <html:select property="nom_shell" styleClass="input"> 
   					<html:options collection="choixNomShell" property="cle" labelProperty="libelle" />
					</html:select>	
                  </td>
    	
    	<td  align="center" width="25%"><html:submit property="boutonConsulter" value="Consulter" styleClass="input" onclick="Verifier(this.form, 'refresh', true);"/></td>
    </tr>
</table>


				 
<table cellspacing="2" cellpadding="2" class="tableBleu" WIDTH="75%" align="center">
	<tr><td >&nbsp;</td><td  >&nbsp;</td></tr>
	<tr><td >&nbsp;</td><td  >&nbsp;</td></tr>
	<tr align="center" ><td class="lib"><b>Nom du Shell</b></td>
                  		<td class="lib"><b>Date début</b></td>
                  		<td class="lib"><b>Heure début</b></td>
                  		<td class="lib"><b>Date fin</b></td>
                  		<td class="lib"><b>Heure Fin</b></td>
                  		<td class="lib"><b>Statut</b></td>
    </tr>
<% int i =0;
    String[] strTabCols = new String[] {  "fond1" , "fond2" };
    String[] extension = new String[] { "Violet.bmp" , ".bmp" };
%>     
    <logic:iterate id="element"  name="listeRechercheId"  length="<%=listeRechercheId.getCountInBlock()%>" 
          					offset="<%=listeRechercheId.getOffset(0)%>" type="com.socgen.bip.metier.ConsultLogsBip" indexId="index"> 
							<% if ( i == 0) i = 1; else i = 0; nbligne ++; 	%>
	<tr class="contenu" align="center" ><td class="<%= strTabCols[i] %>"><bean:write name="element" property="nom_batch" /></td>
										<td class="<%= strTabCols[i] %>"><bean:write name="element" property="datedeb" /></td>
										<td class="<%= strTabCols[i] %>"><bean:write name="element" property="heure_deb" /></td>
										<td class="<%= strTabCols[i] %>"><bean:write name="element" property="datefin" /></td>
										<td class="<%= strTabCols[i] %>"><bean:write name="element" property="heure_fin" /></td>
										<td class="<%= strTabCols[i] %>">
										<logic:notEqual name="element" property="statut" value="OK">
											<IMG SRC="../images/imageKO<%= extension[i] %>" ALT="Erreur" onClick="clicMenu(<%= nbligne %>)">
										</logic:notEqual>
  										<logic:equal name="element" property="statut" value="OK">
  											<logic:notEqual name="element" property="libelleora" value="" >	
  												<IMG SRC="../images/imageOK<%= extension[i] %>" ALT="Réussi" onClick="clicMenu(<%= nbligne %>)">
  											</logic:notEqual>
  											<logic:equal name="element" property="libelleora" value="" >	
  												<IMG SRC="../images/imageOK<%= extension[i] %>" ALT="Réussi" >
  											</logic:equal>
  										</logic:equal>
  										</td>
										<td>
										<logic:notEqual name="element" property="libelleora" value="" >	
  											<IMG SRC="../images/message.bmp" ALT="Message" onClick="clicMenu(<%= nbligne %>)">
  										</logic:notEqual>
										</td>							   	
	</tr>
	<tr style="display:none" id="description<%= nbligne %>" class="contenu">
	   							<td COLSPAN="7"><bean:write name="element" property="libelleora" filter="false"/></td>
	</tr>	   
	</logic:iterate>
	<tr><td align="center" colspan="7" class="contenu"><bip:pagination beanName="listeRechercheId"/></td></tr>
</table>
			 
</html:form>
 
<table>      
	<tr><td><div align="center"><html:errors/><!-- #BeginEditable "barre_bas" --><!-- #EndEditable --></div></td></tr>
</table>

</body>
<% 
Integer id_webo_page = new Integer("1001"); 
com.socgen.bip.commun.form.AutomateForm formWebo = consultLogsBipForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
