<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,com.socgen.bip.commun.liste.*"    errorPage="../jsp/erreur.jsp"  %>
	<jsp:useBean id="personneForm" scope="request" class="com.socgen.bip.form.PersonneForm" />
	<jsp:useBean id="listeRechercheId" scope="session"	class="com.socgen.ich.ihm.menu.PaginationVector" />
	
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
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

	java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("selectressdoublon",personneForm.getHParams()); 
	pageContext.setAttribute("choix1", list1);  

	String Titre="Gestion des Agents SG";
	
    if(Rtype.equals("A"))
    	Titre="Creer un agent SG";
    else if(Rtype.equals("P")) {
		   Titre = "Creer une prestation"; 
    }
    
	int nbligne = 0;
	
//	java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("nom_shell",personneForm.getHParams());   
//	pageContext.setAttribute("ListeDoublon", list1);
	

%>
var pageAide = "<%= sPageAide %>";
var rtype= "<%= Rtype %>";


function MessageInitial()
{
   var Message="<bean:write filter="false"  name="personneForm"  property="msgErreur" />";
   var Focus = "<bean:write name="personneForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
}

function Verifier(form, action, mode,flag,etape)
{
   blnVerification = flag;
   form.action.value = action;
   form.etape.value = etape;
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
	<tr><td height="20" class="TitrePage"><bean:write name="personneForm" property="titrePage"/><%= Titre %></td></tr>
	<tr><td background="../images/ligne.gif"></td></tr>
</table>

<html:form action="/personne"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
<input type="hidden" name="pageAide" value="<%= sPageAide %>">
<html:hidden property="action"/>
<html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<html:hidden property="page" value="modifier"/>
<input type="hidden" name="index" value="modifier">
<input type="hidden" name="rtype" value="<%= Rtype %>">
<html:hidden property="soccode"/>
<html:hidden property="etape"/>


	<table cellspacing="2" cellpadding="2" class="tableBleu" border="0" width="50%" align="center">
		<tr><td >&nbsp;</td></tr>
		<tr><td >&nbsp;</td></tr>
		<tr align="center">
			<td class="lib"><b>
			<span STYLE="position: relative; z-index: 1; right : 197px ">Nom</span>
			<span STYLE="position: relative; z-index: 1; right : 5px">Prénom</span>	
			<span STYLE="position: relative; z-index: 1; left : 60px">Matricule</span>
			<span STYLE="position: relative; z-index: 1; left : 73px">IGG</span>
			<span STYLE="position: relative; z-index: 1; left : 128px">Identifiant</span>
			<span STYLE="position: relative; z-index: 1; left : 158px">DPG</span>	
			
		    </b></td> 		
	    </tr>
		<tr align="center">
	       <td style="align:center; height:25px;">
	        	<html:select property="id_personne_col" styleClass="Multicol" size="15">
					<bip:options collection="choix1"/>
				</html:select>
	       </td>
	     </tr>
	     
	     	<tr><td>
			<br>
			<table width="100%" border="0" class="tableBleu">
              <tr>
            	<td colspan=4 align="center">
            		<b>Cette personne existe déjà.</b><br>
            		<b>Voulez vous créer un homonyme ? </b>
            	</td>
              </tr>
              <tr><td>&nbsp;</td></tr>
              <tr> 
                <td width="25%">&nbsp;</td>
                <td width="25%"> 
                  <div align="center"> <html:submit property="boutonCreer" value="Valider" styleClass="input" onclick="Verifier(this.form, 'suite1', 'insert', true,'vide');"/> 
                  </div>
                </td>
                <td width="25%"> 
                  <div align="center"> <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', null, false,'');"/> 
                  </div>
                </td>
               
                <td width="25%">&nbsp;</td>
              </tr>
            </table>
	</td></tr>
	</table>


			 
</html:form>
 
<table>      
	<tr><td><div align="center"><html:errors/><!-- #BeginEditable "barre_bas" --><!-- #EndEditable --></div></td></tr>
</table>

</body>
<% 
Integer id_webo_page = new Integer("1001"); 
com.socgen.bip.commun.form.AutomateForm formWebo = personneForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
