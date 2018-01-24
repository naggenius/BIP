<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="camoForm" scope="request" class="com.socgen.bip.form.CamoForm" />
<html:html locale="true">
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --><head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>


<!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fmCamoAd.jsp"/>
<%
  java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("ctopact",camoForm.getHParams()); 
  pageContext.setAttribute("choixCtopact", list1);

  
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
   var Message="<bean:write filter="false"  name="camoForm"  property="msgErreur" />";
   var Focus = "<bean:write name="camoForm"  property="focus" />"
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else if (document.forms[0].clibca){
	  document.forms[0].clibca.focus();
   }
}

function Verifier(form, action, mode, flag)
{
   blnVerification = flag;
   form.action.value = action;

} 
function ValiderEcran(form) {
  if (blnVerification == true) {
     if (form.mode.value == 'update') {
        if (!confirm("Voulez-vous modifier ce centre d'activité MO ?")) return false;
     }
   
      if (form.mode.value == 'delete') {
        if (!confirm("Voulez-vous supprimer ce centre d'activité MO ?")) return false;
     }
  }

   return true;
}
</script>
<!-- #EndEditable -->  


</head>

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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" --><bean:write name="camoForm" property="titrePage"/> un centre d'activité MO<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td>
		  <!-- #BeginEditable "debut_form" --> <html:form action="/camo"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable -->
		  <div align="center"><!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>"> 
		    <html:hidden property="action"/>
		    <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
		    <html:hidden property="flaglock"/>
		    <html:hidden property="cdfain"/>
              <table cellspacing="2" cellpadding="2" class="tableBleu" >
                <tr> 
                  <td colspan=2>&nbsp;</td>
                </tr>
                <tr> 
                  <td  >&nbsp;</td>
                  <td >&nbsp;</td>
                </tr>
                <tr> 
                  <td   class="lib"><b> Code centre d'activité MO :</b> </td>
                  <td ><b> <bean:write name="camoForm"  property="codcamo" /></b> 
                    <html:hidden property="codcamo"/>
                  </td>
                </tr>
                <tr> 
                  <td   class="lib">Top CA : </td>
                  <td > 
                    <logic:notEqual parameter="action" value="supprimer">
                   		<html:select property="ctopact" styleClass="input"> 
   						<html:options collection="choixCtopact" property="cle" labelProperty="libelle" />
						</html:select>
                     </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="camoForm"  property="ctopact" />
                   </logic:equal>
                  </td>
                </tr>
                <tr> 
                  <td class="lib"> Libellé :</td>
                  <td >  
                    <logic:notEqual parameter="action" value="supprimer">
                  		<html:text property="clibca" styleClass="input" size="32" maxlength="30" onchange="return VerifierAlphanum(this);"/>
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                  		<bean:write name="camoForm"  property="clibca" />
                   </logic:equal>
                  </td>
                </tr>
                <tr> 
                  <td   class="lib">Libell&eacute; r&eacute;duit : </td>
                  <td >
                    <logic:notEqual parameter="action" value="supprimer">
                   		<html:text property="clibrca" styleClass="input" size="18" maxlength="16" onchange="return VerifierAlphanum(this);"/> 
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                  		<bean:write name="camoForm"  property="clibrca" />
                   </logic:equal>
                  </td>
                </tr>
<logic:notEqual parameter="action" value="creer">
                <tr> 
                  <td   class="lib">Date d'ouverture : </td>
                  <td>
                    <bean:write name="camoForm"  property="cdateouve" /> 
                    <html:hidden property="cdateouve"/>
                  </td>
                </tr>
                <tr> 
                  <td   class="lib">Date de fermeture : </td>
                  <td>
                    <bean:write name="camoForm"  property="cdateferm" /> 
                    <html:hidden property="cdateferm"/>
                  </td>
                </tr>
                <tr> 
                  <td   class="lib">Code de facturation : </td>
<% 
if (camoForm.getCdfain() != null ) {
%>                  
                  <td>
					<logic:equal name="camoForm" property="cdfain" value="0">
                   		0 - Entité soumise à toute facturation interne.
					</logic:equal>
					<logic:equal name="camoForm" property="cdfain" value="1">
                   		1 - Entité soumise à toute facturation interne.
					</logic:equal>
					<logic:equal name="camoForm" property="cdfain" value="2">
                   		2 - Entité exonérée de la F.I. Gestion de personnel.
					</logic:equal>
					<logic:equal name="camoForm" property="cdfain" value="3">
                   		3 - Entité exonérée de toute F.I.
					</logic:equal>
					<logic:equal name="camoForm" property="cdfain" value="4">
                   		4 - Entité exon. des F.I. Gest.Pers. & Taxe Pro.
					</logic:equal>
                  </td>
<%}else{%>                  
				  <td>Code de facturation interne non renseigné.</td>   			       
<%}%>
                </tr>
</logic:notEqual>
<logic:equal parameter="action" value="creer">
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                <tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                <tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                <tr>
</logic:equal>
                <tr> 
                  <td >&nbsp;</td>
                  <td >&nbsp;</td>
                </tr>
                <tr>
                  <td  >&nbsp;</td>
                  <td >&nbsp;</td>
                </tr>
                <tr> 
                  <td  >&nbsp;</td>
                  <td >&nbsp;</td>
                </tr>
                <tr> </tr>
              </table> 
			  <!-- #EndEditable --></div>
            
		</td>
		</tr>
		<tr>
		<td align="center">
		<table width="100%" border="0">
                <tr>
				<td width="25%">&nbsp;</td> 
                  <td width="25%">  
				  	<div align="center">
                	 <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', this.form.mode.value,true);"/>
                  	</div>
				  </td>
				  <td width="25%">  
				  	<div align="center"> 
                	 <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', null, false);"/>
                  		</div>
				  </td>
				  <td width="25%">&nbsp;</td>
				</tr>
         </table>
			  <!-- #BeginEditable "fin_form" --></html:form><!-- #EndEditable -->
          </td>
        </tr>
		<tr> 
          <td>&nbsp;  
          </td>
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
</body>
<% 
Integer id_webo_page = new Integer("1005"); 
com.socgen.bip.commun.form.AutomateForm formWebo = camoForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html> 

<!-- #EndTemplate -->