<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,java.lang.*,java.util.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,com.socgen.bip.commun.liste.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="dateCopiForm" scope="request" class="com.socgen.bip.form.DateCopiForm" />
<jsp:useBean id="listeDynamique" scope="request" class="com.socgen.bip.commun.liste.ListeDynamique" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/mDateCopiAd.jsp"/> 
<%
	java.util.Hashtable hP = new java.util.Hashtable();
	hP.put("userid", ((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
 	java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("datescopi",hP);
	pageContext.setAttribute("choixDateCopi", list1);
%>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	
%>
var pageAide = "<%= sPageAide %>";


function MessageInitial()
{
   var Message="<bean:write filter="false"  name="dateCopiForm"  property="msgErreur" />";
   var Focus = "<bean:write name="dateCopiForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
}

function Verifier(form, action, flag)
{
   blnVerification = flag;
   form.action.value = action;

} 

function ValiderEcran(form)
{
if (blnVerification == true) {   
	if (form.action.value == 'supprimer') {
	   if ( !ChampObligatoire(document.forms[0].datecopisuppr ,"la Date COPI")) { 
		 	return false;
		} 
		else{
			if (!confirm("Voulez-vous supprimer cette date ?")) return false;
		}
	}
   if (form.action.value == 'creer') {
      if ( !ChampObligatoire(document.forms[0].datecopicreer ,"la Date COPI")) { 
		 	return false;
	 }  
   }
	}	
		
	return true;
	
}



 



</script>


<!-- #EndEditable --> 
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">

      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr > 
          <td> 
            <div align="center"><!-- #BeginEditable "barre_haut" --> 
              <%ToolBar tb = new com.socgen.ich.ihm.ToolBar("bip_ihm",false,false,true,false,false,false,false,false,false,request) ;%>
              <%=tb.printHtml()%><!-- #EndEditable --></div>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->
          Date COPI<!-- #EndEditable -->
            </td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
 </table>
 
         
        <html:form action="/DateCopi"  onsubmit="return ValiderEcran(this);">
           
			<input type="hidden" name="pageAide" value="<%= sPageAide %>">
						  
	
			  <html:hidden property="titrePage"/>
              <html:hidden property="action" value="creer"/>
              <html:hidden property="mode"/>
              
<html:hidden property="arborescence" value="<%= arborescence %>"/>
              
   <table cellspacing="0" cellpadding="2" class="tableBleu" width="25%" align="center" border="0">
			  
                 <tr> 
                  <td  class="lib" align="center" width="30%"><b>Date COPI<br>Enregistrées :</b></td>
                  <td width="70%" align="center"> 
                  	 <html:select property="datecopisuppr" styleClass="input" size="12"> 
   						<html:options collection="choixDateCopi" property="cle" labelProperty="libelle" />
						</html:select>	
				  </td>
                 </tr>
                  <tr> 
                  <td >&nbsp;</td>
                  <td  >&nbsp; </td>
                </tr>
                 <tr>
                 	<td class="lib" align="center" width="30%"><b>Saisir Date :</b></td>
                 	<td align="center" width="70%"><html:text name="dateCopiForm" property="datecopicreer" styleClass="input" size="10" maxlength="10" onchange="return VerifierDate(this,'jj/mm/aaaa');"/></td>
                 </tr>
                  <tr> 
                  <td >&nbsp;</td>
                  <td  >&nbsp; </td>
                </tr>
                <tr>
          </table>
                
                	<table width="100%" border="0">
			 		<tr> 
	                <td width="25%">&nbsp;</td>
	                <td width="25%"> 
	                  <div align="center"> <html:submit property="boutonValider" value="Cr&#233er" onclick="Verifier(this.form, 'creer',true);" styleClass="input"/> 
	                   </div>
	                </td>
	                <td width="25%"> 
	                  <div align="center"> <html:submit property="boutonAnnuler" value="Supprimer" onclick="Verifier(this.form, 'supprimer', true);" styleClass="input" /> 
	                  </div>
	                </td>
	                <td width="25%">&nbsp;</td>
              </tr>
            </table>
                
			  </html:form>
     <table witdh="100%" align="center">
        <tr> 
          <td align="center" class="contenu">Pour supprimer une date veuillez d'abord la selectionner dans la liste et cliquez ensuite sur le bouton supprimer&nbsp; </td>
        </tr>
        <tr> 
          <td> 
            <div align="center"><html:errors/></div>
          </td>
        </tr>
            </table>
   

</body>
<% 
Integer id_webo_page = new Integer("1001"); 
com.socgen.bip.commun.form.AutomateForm formWebo = dateCopiForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
