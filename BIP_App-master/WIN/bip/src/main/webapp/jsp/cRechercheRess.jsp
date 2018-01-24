<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,com.socgen.bip.commun.liste.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="personneForm" scope="request" class="com.socgen.bip.form.PersonneForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Recherche identifiant d'une ressource</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/bPersonneAd.jsp"/> 
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
	String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
    String Rtype = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("rtype")));

	java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("selectressigg",personneForm.getHParams()); 
	pageContext.setAttribute("choix1", list1);  

	String sRtype="";
	
	if(Rtype.equals("A"))
	   sRtype = " Creer un agent SG : Donn�es Urbann";
	else if(Rtype.equals("P"))
	   sRtype = " Creer une prestation : Donn�es Urbann "; 
	
%>
var pageAide = "<%= sPageAide %>";


function MessageInitial()
{
   if(blnVerification){
	   	var Message="<bean:write filter="false"  name="personneForm"  property="msgErreur" />";
	   	if(Message != "") {
	      	alert(Message);}
	    if(document.forms[0].id_personne_col.selectedIndex==-1){
		 	document.forms[0].id_personne_col.selectedIndex=0;}
	}else{
		document.forms[0].id_personne_col.selectedIndex=-1;
	}
}

function Verifier(form, action, mode,flag,etape)
{
   blnVerification = flag;
   form.mode.value = mode;
   form.action.value = action;
   form.etape.value = etape;
}

function ValiderEcran(form)
{
   var index = form.id_personne_col.selectedIndex;

   if (blnVerification) {
	if (index==-1) {
	   alert("Choisissez une ressource");
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
	<tr><td><div align="center">
              <%ToolBar tb = new com.socgen.ich.ihm.ToolBar("bip_ihm",false,false,true,false,false,false,false,false,false,request) ;%>
              <%=tb.printHtml()%>
         	</div></td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td background="../images/ligne.gif"></td></tr>
	<tr><td height="20" class="TitrePage"><%= sRtype %></td></tr>
	<tr><td background="../images/ligne.gif"></td></tr>
</table>

<html:form action="/personne"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 

	<input type="hidden" name="pageAide" value="<%= sPageAide %>">
	<html:hidden property="action"/>
	<html:hidden property="mode"/>
	<html:hidden property="arborescence" value="<%= arborescence %>"/>
	<html:hidden property="igg" /> 
	<html:hidden property="matricule" /> 
	<html:hidden property="debnom" /> 
	<html:hidden property="nomcont" />
	<html:hidden property="count"/>	
	<input type="hidden" name="rtype" value="<%= Rtype %>">
	<html:hidden property="soccode"/>
	<html:hidden property="etape"/>
	
			 <% if (list1.size() > 0) { %>
			<table cellspacing="2" cellpadding="2" class="tableBleu" border="0" width="50%" align="center">
				<tr><td >&nbsp;</td></tr>
				<tr><td >&nbsp;</td></tr>
				<tr align="center">
					<td class="lib"><b>
					<span STYLE="position: relative; z-index: 1; right : 177px ">Civilit�</span>
					<span STYLE="position: relative; z-index: 1; right : 169px">Nom</span>	
					<span STYLE="position: relative; z-index: 1; left : 22px">Pr�nom</span>
					<span STYLE="position: relative; z-index: 1; left : 88px">Matricule</span>
					<span STYLE="position: relative; z-index: 1; left : 100px">IGG</span>	
				    </b></td> 		
			    </tr>
				<tr align="center">
			       <td style="align:center; height:25px;">
			        	<html:select property="id_personne_col" styleClass="Multicol" size="15">
							<bip:options collection="choix1"/>
						</html:select>
			       </td>
			     </tr>
			</table>
<%} else {%>
			<table cellspacing="2" cellpadding="2" class="tableBleu" border="0" width="50%" align="center">
				<tr><td align="center">Aucun r�sultat</td></tr>
			</table>
<%} %>
			</br>
			</br>
			<table width="100%" border="0">
		
                <tr> 
                  <td width=10%>&nbsp;</td>
                  <% if (list1.size() > 0) { %>
				  <td width="20%" align="center"> 
     			  <html:submit property="boutonModifier" value="S�lectionner" styleClass="input" onclick="Verifier(this.form, 'suite1', 'insert', true, '');"/>
                  </td>
                  <%} %>
				  <td width="20%" align="center">  
				  <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', '', false, '');"/>
                  </td>
                  <td width="20%" align="center">  
				  <html:submit property="boutonCreer" value="Cr&#233er � vide" styleClass="input" onclick="Verifier(this.form, 'suite1', 'insert' ,true, 'vide');"/>
                  </td>
                  <td width=10%>&nbsp;</td>
                  
                </tr>
            
            </table>
		 
</html:form>
 
<table>      
	<tr><td><div align="center"><html:errors/><!-- #BeginEditable "barre_bas" --><!-- #EndEditable --></div></td></tr>
</table>

</body>
</html:html>
<!-- #EndTemplate -->
