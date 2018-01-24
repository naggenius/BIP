<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="copieStructureForm" scope="request" class="com.socgen.bip.form.CopieStructureForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_filtre.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" -->
<bip:VerifUser page="jsp/fCopieStructureSr.jsp"/> 
<%  java.util.Hashtable hP = new java.util.Hashtable();
	hP.put("userid", ((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
	java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("isac_copie_pid1",hP);
	java.util.ArrayList list2 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("isac_copie_pid2",hP);

    pageContext.setAttribute("choixPid1", list1);
    pageContext.setAttribute("choixPid2", list2);
   
%> 
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));  
%>
var pageAide = "<%= sPageAide %>";

function MessageInitial()
{
   var Message="<bean:write filter="false"  name="copieStructureForm"  property="msgErreur" />";
   var Focus = "<bean:write name="copieStructureForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }

}

function Verifier(form, action, flag)
{
  blnVerification = flag;
  form.action.value = "valider";
}
function ValiderEcran(form)
{  if (blnVerification) {
	form.mode.value = "insert";
	if (!confirm("Voulez-vous copier la structure de la ligne "+form.pid1.value+" sur la ligne "+form.pid2.value+"?")) return false;
	
	form.affecter.value = "NON";
	if (document.forms[0].affecter[0].checked)
	{
	form.affecter.value = "NON";
	}
	if (document.forms[0].affecter[1].checked)
	{
	form.affecter.value = "OUI";
	}
	if (document.forms[0].affecter[2].checked)
	{
	form.affecter.value = "AVEC";
	}
	
	
   }
	

   return true;
}

function toggleMois(){
	if(document.forms[0].affecter!=null && document.forms[0].affecter[2].checked){
		document.getElementById("selectMois").style.visibility="visible";
	}else{
		document.getElementById("selectMois").style.visibility="hidden";
	}
}
</script>
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
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr > 
          <td> 
            <div id="outils" align="center"><!-- #BeginEditable "barre_haut" -->
              <%ToolBarNew tb = new com.socgen.ich.ihm.ToolBarNew("bip_ihm",false,false,true,true,false,false,false,false,false,request) ;%>
				<%=tb.printHtml()%><!-- #EndEditable -->
			</div>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td height="20" class="TitrePage"><div id="titre" ><!-- #BeginEditable "titre_page" -->Copie de structure<!-- #EndEditable --></div></td>
        </tr>
        <tr> 
          <td>
			<div id="content">	
		  <!-- #BeginEditable "debut_form" --><html:form action="/copieStructure"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
            <input type="hidden" name="pageAide" value="<%= sPageAide %>">
            <html:hidden property="action"/>
            <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
			
              <table border="0" class="TableBleu" cellpadding="2" cellspacing="2"  >
                <tr> 
                  <td colspan="2" >&nbsp; </td>
                </tr>
                <tr> 
                  <td colspan="2" >&nbsp; </td>
                </tr>
                <tr> 
                  <td class="texteGras"><b>Copier la structure de la ligne:</b> </td>
                  <td > 
                  	<html:select property="pid1" size="1" styleClass="input">
                  	   <html:options collection="choixPid1" property="cle" labelProperty="libelle"/>
                	</html:select>
                  </td>
                </tr>
                <tr>
                  <td colspan="2">&nbsp;</td>
                </tr>
                <tr> 
                  <td class="texteGras"><b>Dans la ligne : </b> </td>
                  <td> 
                  	<html:select property="pid2" size="1" styleClass="input">
                  	   <html:options collection="choixPid2" property="cle" labelProperty="libelle"/>
                	</html:select>
                  </td>
                </tr>
                <tr>
                  <td colspan="2">&nbsp;</td>
                </tr>
                <tr>
						<td colspan=1 class="texteGras"><b>Affectation des ressources et<br/> déplacement des consommés :</b></td>
						<td colspan=1 class="texte">
									<input type=radio name="affecter" value="NON" onClick="toggleMois()" checked>Non<br/>
						        	<input type=radio name="affecter" value="OUI" onClick="toggleMois()" >Oui, SANS déplacement des consommés<br/>
						        	<input type=radio name="affecter" value="AVEC" onClick="toggleMois()" >Oui, AVEC déplacement des consommés<br/> &nbsp;&nbsp;&nbsp;&nbsp;à compter du mois : 
						        	<span id="selectMois" style="visibility:hidden;">
							        	<html:select property="mois" styleClass="input">
							        		<%for(int i=1;i<13;i++){ %>
												<html:option value="<%=String.valueOf(i)%>"><%=i%></html:option>
											<% }%>
							        	</html:select>
						        	</span>
						</td>
				</tr>
				<tr>
                  <td colspan="2">&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="2">&nbsp;</td>
                </tr>
				<tr> 
					<td align="center" colspan="2"> 
						<html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'suite', true);"/> 
						<!-- #BeginEditable "fin_form" --></html:form><!-- #EndEditable --> 
					</td>

					</tr>
				</table>
		  
		   <!-- #EndEditable --></div>
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
	  </div>
    </td>
  </tr>
</table>
</body>
</div>
	<div id="bottomContainer">
			<div>&nbsp;</div>
	</div>
</div>
<% 
Integer id_webo_page = new Integer("6004"); 
com.socgen.bip.commun.form.AutomateForm formWebo = copieStructureForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
