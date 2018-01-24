<!DOCTYPE html>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,java.util.Calendar"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="calendrierListeForm" scope="request" class="com.socgen.bip.form.CalendrierListeForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_filtre.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="/calendrierShow.do"/> 
<script language="JavaScript" src="../js/function.cjs"></script>
<!-- <link rel="stylesheet" href="../css/base_style.css" type="text/css"> -->
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
   var Message="<bean:write filter="false"  name="calendrierListeForm"  property="msgErreur" />";
   var Focus = "<bean:write name="calendrierListeForm"  property="focus" />";
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
   if (blnVerification==true) {
   }
   return true;
}

</script>

</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
<div id="mainContainer">
<div id="topContainer" style="min-height:98%;">
<div id="entete"></div>
<div id="logo">
		<div id="logo_sg"><img src="../images/logo_SG.gif" width="162" height="33" border="0" /></div>
		<div id="nomdusite"><img src="../images/bip_logo.png" width="78" height="46" border="0" /></div>
</div>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr id="noPrintZone"> 
          <td>&nbsp;</td>
        </tr>
        <tr id="noPrintZone"> 
          <td> 
            <div id="outils" align="center"><!-- #BeginEditable "barre_haut" -->
              <%ToolBarNew tb = new com.socgen.ich.ihm.ToolBarNew("bip_ihm",false,false,true,true,false,false,false,false,false,request) ;%>
				<%=tb.printHtml()%><!-- #EndEditable -->
		</div><!-- #EndEditable -->
          </td>
        </tr>
        <tr id="noPrintZone"> 
          <td>&nbsp;</td>
        </tr>
<!--         <tr id="noPrintZone">  -->
<!--           <td background="../images/ligne.gif"></td> -->
<!--         </tr> -->
        <tr id="noPrintZone"> 
          <td height="20" class="TitrePage">Calendrier</td>
        </tr>
<!--         <tr id="noPrintZone">  -->
<!--           <td background="../images/ligne.gif"></td> -->
<!--         </tr> -->
        <tr> 
          <td>
            <html:form action="/calendrierShow" onsubmit="return ValiderEcran(this);">
            <div align="center">
              <input type="hidden" name="pageAide" value="<%= sPageAide %>">
              <input type="hidden" name="action" value="suite">
              
<html:hidden property="arborescence" value="<%= arborescence %>"/>
           
              <table border="0" cellspacing="2" cellpadding="2" class="TableBleu">
				  <tr id="noPrintZone"><td>&nbsp;<html:errors/></td></tr>
                  <tr align="left" id="noPrintZone">
					<td align="center" class="texte" align="left">
					  <B>Année du calendrier : </B>
					  <html:text property="annee" size="5" maxlength="4" styleClass="input"/>
					  <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'suite', true);"/>
					  <input class="input" type="button" value="Imprimer" onClick="javascript:window.print()">
					</td>
                  </tr>
				  <tr id="noPrintZone"><td>&nbsp;</td></tr>
				  <tr align="left" class="titreTableau">
				    <td class="texte" align="center"><b>Calendrier des traitements <bean:write name="calendrierListeForm" property="annee" /> </b></td>
				 </tr>
				  <tr><td>&nbsp;</td></tr>

				  <%
				  if (calendrierListeForm.getListMois().size()>1) {
					  int anneeDef = 0;
					  String moisDef = ((com.socgen.bip.metier.InfosCalendrier) calendrierListeForm.getListMois().get(0) ).getLibMois();
					  String mensDef = ((com.socgen.bip.metier.InfosCalendrier) calendrierListeForm.getListMois().get(0) ).getMensuelle();
					  String cloture = ((com.socgen.bip.metier.InfosCalendrier) calendrierListeForm.getListMois().get(1) ).getCcloture();
					  try {
					  	String s_annee = calendrierListeForm.getAnnee();
					    anneeDef = Integer.parseInt(s_annee);
					    anneeDef--;
					  } catch (NumberFormatException nfe) { }
				  %>
				  <tr align="left">
				    <td align="left" class="texte">
				      <ul>
				        <li>D&eacute;finitif <%=anneeDef%> = Traitement de <%=moisDef%> <%=anneeDef%> le <%=mensDef%></li>
				        <li>Cl&ocirc;ture <%=anneeDef%> le <%=cloture%></li>
				      </ul>
				    </td>
				  </tr>
				  <tr><td>&nbsp;</td></tr>
				  <%
				  }
				  %>

				  <tr align="left">
				    <td align="center" >
				      <table class="tableBleu" border="1" cellspacing="1" cellpadding="1" >
					    <tr align="center" class="lib">
					      <td class="texte" width="18%">Traitement du mois de</td>
					      <td class="texte" width="23%">Pr&eacute;-mensuelle</td>
					      <td class="texte" width="23%">R&eacute;gularisation</td>
					      <td class="texte" width="23%">Mensuelle</td>
					      <td class="texte" width="13%">Jours ouvr&eacute;s</td>
					    </tr>
					    <logic:iterate id="mois" name="calendrierListeForm" property="listMois" type="com.socgen.bip.metier.InfosCalendrier">
					    <tr align="left">
					      <td width="18%" class="<bean:write name="mois" property="css_mensuelle" /> texte">
					        <bean:write name="mois" property="libMois" />
					      </td>
					      <td width="23%" class="<bean:write name="mois" property="css_premens1" /> texte">
					      	<bean:write name="mois" property="premens1" />
					      </td>
					      <td width="23%" class="<bean:write name="mois" property="css_premens2" /> texte">
					        <bean:write name="mois" property="premens2" />
					      </td>
					      <td width="23%" class="<bean:write name="mois" property="css_mensuelle" /> texte">
					        <bean:write name="mois" property="mensuelle" />
					      </td>
					      <td width="13%" align="center" class="<bean:write name="mois" property="css_mensuelle" /> texte">
					        <bean:write name="mois" property="cjours" />
					      </td>
					    </tr>
					    </logic:iterate>
				      </table>
				    </td>
				  </tr>
				  
				  <tr><td>&nbsp;</td></tr>
				  <tr align="left">
				    <td align="center" class="texte" style="color:red;">&nbsp;
		    		  <logic:iterate id="ligne" name="calendrierListeForm" property="entete" type="java.lang.String">
				          <b><bean:write name="ligne" /></b><hr/>
		    		  </logic:iterate>
			        </td>
			      </tr>

				  <tr><td>&nbsp;</td></tr>
			  </table>
            
            </div>
			
			</html:form>
          
          </td>
        </tr>
      </table>

	</td>
  </tr>
</table>
</div>
	<div id="bottomContainer">
			<div>&nbsp;</div>
	</div>
</div>
</body>
<% 
Integer id_webo_page = new Integer("2002"); 
com.socgen.bip.commun.form.AutomateForm formWebo = calendrierListeForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
