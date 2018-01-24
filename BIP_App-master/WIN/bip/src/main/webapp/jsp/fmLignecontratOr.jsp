 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"   errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="ligneContratForm" scope="request" class="com.socgen.bip.form.LigneContratForm" />
<jsp:useBean id="listeDynamique" scope="request" class="com.socgen.bip.commun.liste.ListeDynamique" />
<jsp:useBean id="contratAveForm" scope="request" class="com.socgen.bip.form.ContratAveForm" />
<html:html locale="true"> <!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_filtre_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Filtre Maj</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/bContrataveOr.jsp"/>
<%
java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("lignesContrat",ligneContratForm.getHParams()); 
  pageContext.setAttribute("choixLignesContrat", list1);
%>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
var blnVerifFormat  = true;
var tabVerif        = new Object();
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";

function MessageInitial()
{
   var Message="<bean:write filter="false"  name="ligneContratForm"  property="msgErreur" />";
   var Focus = "<bean:write name="ligneContratForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (document.forms[0].lcnum.selectedIndex == -1) {
	   document.forms[0].lcnum.selectedIndex = 0;
   }
   
  
}

function Verifier(form, action,flag)
{
  blnVerification = flag;
  form.action.value =action;
  
}

function ValiderEcran(form)
{
   var index = form.lcnum.selectedIndex;

	if (form.action.value == 'creer') {
		ajaxCallRemotePage('/ligneContrat.do?action=testLContratPeriode&cav='+form.cav.value+'&lcnum='+form.lcnum.value+'&mode=creer&numcont='+form.numcont.value);
		if (document.getElementById("ajaxResponse").innerHTML!='') {
			alert(document.getElementById("ajaxResponse").innerHTML);
			return false;
		}
		return true;
	}   

	if (form.action.value == 'modifier' || form.action.value == 'supprimer') {
		ajaxCallRemotePage('/ligneContrat.do?action=testLContratPeriode&cav='+form.cav.value+'&lcnum='+form.lcnum.value+'&mode=modifier&numcont='+form.numcont.value);
		if (document.getElementById("ajaxResponse").innerHTML!='') {
			alert(document.getElementById("ajaxResponse").innerHTML);
			return false;
		}
		return true;
	}
		
   if (blnVerification) {
	if ( !VerifFormat(null) ) return false;
	index = form.lcnum.selectedIndex;
	if ( (index==-1) && (form.action.value != 'creer') ) {
	   alert("Choisissez une ligne de contrat");
	   return false;
	}
	//if (form.action.value != 'creer') {
	form.keyList3.value = form.soclib.value;
	form.keyList0.value = form.soccont.value;
   	form.keyList1.value = form.numcont.value;
    form.keyList2.value = form.cav.value;
	//return true;
	//}
   }
   return true;
}

function quitter()
{

}

</script>
<!-- #EndEditable --> 
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
<div style="display:none;" id="ajaxResponse"></div>
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Mise 
            &agrave; jour des lignes de contrat<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/ligneContrat"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
             	<input type="hidden" name="pageAide" value="<%= sPageAide %>">
			 	<html:hidden property="action" /> 
            	<html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
      		   	<html:hidden property="keyList0"/> 
              	<html:hidden property="keyList1"/>
			   	<html:hidden property="keyList2"/> 
			   	<html:hidden property="keyList3"/>
			   	
			   	 <logic:equal parameter="action" value="suite">
			   		<html:hidden name="contratAveForm" property="cdatdeb"/>
            		<html:hidden name="contratAveForm" property="cdatfin"/>
            	 </logic:equal>
				 <logic:notEqual parameter="action" value="suite">
				  	<html:hidden name="ligneContratForm" property="cdatdeb"/>
            		<html:hidden name="ligneContratForm" property="cdatfin"/>
            	 </logic:notEqual>
			   	
              	<table border=0 cellspacing=2 cellpadding=2 class="TableBleu">
                <tr> 
                  <td>&nbsp;</td>
                </tr>
                
              </table>
              <table border=0 cellspacing=2 cellpadding=2 class="TableBleu">
                <tr> 
                  <td class="lib">Code société :</td>
                  <td ><b><bean:write name="ligneContratForm"  property="soccont" /></b>
                    <html:hidden property="soccont"/>
                  </td>
 					 <td>&nbsp;</td>
                  <td  class="lib">Société :</td>
                  <td>
				  <logic:equal parameter="action" value="suite">
				  <bean:write name="contratAveForm"  property="soclib" /><html:hidden name="contratAveForm" property="soclib"/><html:hidden name="contratAveForm" property="ctypfact"/>
				  </logic:equal>
				  <logic:notEqual parameter="action" value="suite">
				  <bean:write name="ligneContratForm"  property="soclib" /><html:hidden property="soclib"/><html:hidden property="ctypfact"/>
				  </logic:notEqual>
                  </td>
                </tr>
                <tr> 
                  <td class="lib">N° de contrat :</td>
                  <td><b><bean:write name="ligneContratForm"  property="numcont" /></b><html:hidden property="numcont"/>
                  </td>
                  <td>&nbsp;</td>
                  <td class="lib">N° d'avenant :</td>
                  <td>
				  	<logic:equal parameter="action" value="suite">
				  	<bean:write name="contratAveForm"  property="cav" /><html:hidden name="contratAveForm"  property="cav"/>
				  </logic:equal>
				  <logic:notEqual parameter="action" value="suite">
				  	<bean:write name="ligneContratForm"  property="cav" /><html:hidden property="cav"/>
				  </logic:notEqual>
                  </td>
                  
                </tr>
                <tr>
                  <td colspan=4>&nbsp;</td>
                </tr>
              </table>
              <table border=0 cellspacing=2 cellpadding=2 class="TableBleu" width="440">
                <tr> 
                  <td align=center><b>Liste des lignes de contrat :</b></td>
                </tr>
                <tr> 
                  <td CLASS="lib" NOWRAP> <span STYLE="position: relative; left: 12px;  z-index: 11;">Ident</span> 
                    <span STYLE="position: relative; left: 26px;  z-index: 1;">Nom</span>	
                    <span STYLE="position: relative; left: 149px; z-index: 1;">Prénom</span>	
                    <span STYLE="position: relative; left: 257px; z-index: 1;">Coût 
                    HT</span> </td>
                </tr>
                <tr> 
                  <td> 
                  	<html:select property="lcnum" styleClass="Multicol" size="5">
						  <bip:options collection="choixLignesContrat"/>
					 </html:select>
                  </td>
                </tr>
          
                <tr> 
                <td  align="center"> <a href="/contratAve.do?action=annuler&numcont=<%= ligneContratForm.getNumcont() %>&soccont=<%= ligneContratForm.getSoccont() %>&cav=<%= ligneContratForm.getCav() %>"> 
                          <img src="../images/exit.gif" border=0 width=25 height=29 alt="Retour"></a></td>
                </tr>
              </table>
              <!-- #EndEditable --></div>
          </td>
        </tr>
        <tr> 
          <td align="center"> 
            <table width="100%" border="0">
              <tr> 
                <td width="33%" align="right"> <html:submit property="boutonCreer" value="Cr&#233er" styleClass="input" onclick="Verifier(this.form, 'creer', true);"/> 
                </td>
                <td width="33%" align="center"> <html:submit property="boutonModifier" value="Modifier" styleClass="input" onclick="Verifier(this.form, 'modifier', true);"/> 
                </td>
                <td width="33%" align="left"> <html:submit property="boutonSupprimer" value="Supprimer" styleClass="input" onclick="Verifier(this.form, 'supprimer', true);"/> 
                </td>
              </tr>
            </table>
            <!-- #BeginEditable "fin_form" --></html:form><!-- #EndEditable --> 
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
    </td>
  </tr>
</table>
</body></html:html>
<!-- #EndTemplate -->
