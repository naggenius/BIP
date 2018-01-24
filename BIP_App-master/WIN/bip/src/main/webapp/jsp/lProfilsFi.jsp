<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,com.socgen.bip.commun.liste.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="profilsfiForm" scope="request" class="com.socgen.bip.form.ProfilsFIForm" />
<%@page import="com.socgen.bip.form.ProfilsFIForm"%>
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Liste des Profils et dates d'effet</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fmProfilsFIAd.jsp"/>
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
	String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	
	java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("selectprofilfi",profilsfiForm.getHParams()); 
	pageContext.setAttribute("choix1", list1);
	
	String filtre_ini =	profilsfiForm.getFiltre_lst_fi();
	if(filtre_ini == null || "".equals(filtre_ini)){
		profilsfiForm.getHParams().put("filtre_lst_fi", ""+((ListeOption)list1.get(0)).getCle());
	}

	java.util.ArrayList list2 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("detailsprofilfi",profilsfiForm.getHParams()); 	
	pageContext.setAttribute("choix2", list2); 

	
%>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
var rafraichiEnCours = false;

var pageAide = "<%= sPageAide %>";


function MessageInitial()
{
   if(blnVerification){
	   	var Message="<bean:write filter="false"  name="profilsfiForm"  property="msgErreur" />";
	   	if(Message != "") {
	      	alert(Message);
	    }

	    if(document.forms[0].filtre_lst_fi.selectedIndex==-1){
	    	
		 	document.forms[0].filtre_lst_fi.selectedIndex=0;
		 	document.forms[0].lst_date_effet.selectedIndex=-1;
		 	document.forms[0].filtre_lst_fi.focus();
		 }
	}else{
			document.forms[0].filtre_lst_fi.selectedIndex=-1;
			document.forms[0].lst_date_effet.selectedIndex=-1;
	}
}

function Verifier(form, action, flag)
{
  blnVerification = flag;
  form.action.value =action;
 
}

function ValiderEcran(form)
{
   var index = form.filtre_lst_fi.selectedIndex;
   var index2 = form.lst_date_effet.selectedIndex;

   if (blnVerification) {
	 
	if (form.action.value != 'creer') {
		if (index2==-1) {
	   		alert("Choisissez une date effet");
	   		return false;
		}
	}
   }
   
   return true;
}

function SetFocus()
{
document.forms[0].filtre_lst_fi.focus();
}

function refresh(obj) {
		     	
 if(!rafraichiEnCours)
	       {
		     rafraichir(document.forms[0]); 
		     rafraichiEnCours = true;
		     
	       }
	
}

</script>


<!-- #EndEditable --> 
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial(); SetFocus();">


<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr><td>&nbsp;</td></tr>
	<tr><td><div align="center">
              <%ToolBar tb = new com.socgen.ich.ihm.ToolBar("bip_ihm",false,false,true,false,false,false,false,false,false,request) ;%>
              <%=tb.printHtml()%>
         	</div></td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td background="../images/ligne.gif"></td></tr>
	<tr><td height="20" class="TitrePage">Gestion des Profils de FI : Liste des Profils et Dates d'effet</td></tr>
	<tr><td background="../images/ligne.gif"></td></tr>
</table>

<html:form action="/listprofilsfi"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
<input type="hidden" name="pageAide" value="<%= sPageAide %>">
<html:hidden property="action"/>
<html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<html:hidden property="filtre_date" />
<html:hidden property="filtre_fi" />

			<table cellspacing="2" cellpadding="2" class="tableBleu" border="0" width="50%" align="center">
				<tr><td >&nbsp;</td></tr>
				<tr><td >&nbsp;</td></tr>
				<tr align="center">
					<td class="lib"><b>
				    <span STYLE="position: relative; z-index: 1; right : 335px ">Profil de FI:</span>
					<span STYLE="position: relative; z-index: 1; right : 275px">Libellé:</span>	
				    </b></td> 		
			    </tr>
				<tr align="center">
			       <td style="align:center; height:25px;">
			        	<html:select property="filtre_lst_fi" styleClass="Multicol" size="5"  onchange="refresh(this.form.filtre_lst_fi.options[this.form.filtre_lst_fi.selectedIndex].value);" >
							<bip:options collection="choix1"/>
						</html:select>
			       </td>
			     </tr>
			</table>

			 		<table cellspacing="2" cellpadding="2" class="tableBleu" border="0" width="50%" align="center">
						<tr>
							<td>&nbsp;</td>
						</tr>	
						<tr>
							<td class="lib" align="center">
								<b>
									<span STYLE="position: relative; left: -160px; z-index: 1;">Date Effet</span> 
									<span STYLE="position: relative; left: -140px; z-index: 1;">Actif </span> 
									<span STYLE="position: relative; left: -110px; z-index: 1;">Coût</span>
									<span STYLE="position: relative; left: -80px; z-index: 1;">Direction</span> 
									<span STYLE="position: relative; left: -60px; z-index: 1;">=/# Presta(début)</span>
									<span STYLE="position: relative; left: 60px; z-index: 1;">=/# Localisation(début)</span> 
								</b>
							</td>
						</tr>
						<tr>
							<td style="align:center; height:25px;" align="center">
							<html:select property="lst_date_effet" styleClass="Multicol" size="6" >
								<bip:options collection="choix2" />
							</html:select>
							</td>
						</tr>
							
						<tr>
							<td>&nbsp;</td>
						</tr>	
					</table> 

			<table width="50%" border="0" align="center">
		
                <tr> 
                 
				  <td align="left" width="20%">  
     			  <html:submit property="boutonCreer" value="Cr&#233er" styleClass="input" onclick="Verifier(this.form, 'creer', true);"/>
                  </td>
                  <td width="20%">&nbsp;</td>
				  <td align="left" width="20%">  
     			  <html:submit property="boutonModifier" value="Modifier" styleClass="input" onclick="Verifier(this.form, 'modifier', true);"/>
                  </td>
                  <td width="20%">&nbsp;</td>
				  <td align="left">  
     			  <html:submit property="boutonSupprimer" value="Supprimer" styleClass="input" onclick="Verifier(this.form, 'supprimer', true);"/>
                  </td>                  
				  <td width="20%">&nbsp;</td> 
				  <td width="20%" align="left"> 
				  <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', false);"/>
                  </td>
                  
                </tr>
            
            </table>
		 
</html:form>
 
<table>      
	<tr><td><div align="center"><html:errors/><!-- #BeginEditable "barre_bas" --><!-- #EndEditable --></div></td></tr>
</table>

</body>
</html:html>
<!-- #EndTemplate -->
