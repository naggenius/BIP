<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="type2Form" scope="request" class="com.socgen.bip.form.Type2Form" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="/type2.do"/>
<%
  java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("type1",type2Form.getHParams()); 
  java.util.ArrayList list2 = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("topFer"); 
  pageContext.setAttribute("choixTypproj", list1);
  pageContext.setAttribute("choixTopFer", list2);
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

var pageAide = "aide/hvide.htm";

function MessageInitial()
{
   var Message="<bean:write filter="false"  name="type2Form"  property="msgErreur" />";
   var Focus = "<bean:write name="type2Form"  property="focus" />"
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else if (document.forms[0].libarc) {
   	 
	  document.forms[0].libarc.focus();
    }
    
    // On initailise la liste des Types 1
    if (document.forms[0].lst_Type1){
	    var listeTypes1 = document.forms[0].listeType1.value;
	    for (i=1; i < document.forms[0].lst_Type1.length; i++){
			if (listeTypes1.indexOf(document.forms[0].lst_Type1.options[i].value + ";") >= 0){
				document.forms[0].lst_Type1.options[i].selected=true;
			}
		}
	}
}

function Verifier(form, action, mode, flag)
{
   blnVerification = flag;
   form.action.value = action;
   form.mode.value = mode;
}

// Fonction qui transfert les résultats de la liste déroulante
// Dans le champ listeType1
function MAJ_Types1(lst_type1){
	document.forms[0].listeType1.value="";
	for (i=1; i < lst_type1.length; i++){
		if (lst_type1.options[i].selected){
			document.forms[0].listeType1.value += lst_type1.options[i].value + ";";
		}
	}
}

function ValiderEcran(form)
{
  if (blnVerification == true) {
     if ((form.action.value!="valider")&&(form.action.value!="annuler"))
  		form.action.value ="valider";
  		
     if (form.arctype) {
     	if (!ChampObligatoire(form.arctype, "la typologie secondaire projet")) return false;
     }
     if (form.libarc) {
     	if (!ChampObligatoire(form.libarc, "le libellé de typologie secondaire projet")) return false;
     }
     if (form.mode.value == 'update') {
     	if (!confirm("Voulez-vous modifier cette typologie secondaire projet?")) return false;
     }
     if (form.mode.value == 'delete') {
     	if (!confirm("Voulez-vous supprimer cette typologie secondaire ?")) return false;
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->
          <bean:write name="type2Form" property="titrePage"/> une typologie secondaire projet<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/type2"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
			<input type="hidden" name="pageAide" value="<%= sPageAide %>">
			  <html:hidden property="titrePage"/>
              <html:hidden property="action"/>
              <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
              <html:hidden property="flaglock"/>
              <html:hidden property="listeType1"/>
              <table cellspacing="2" cellpadding="2" class="tableBleu"  >
                <tr> 
                  <td colspan=2 >&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan=2>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="lib"><b>Typologie secondaire :</b></td>
                  <td> 
                    <logic:equal parameter="mode" value="insert">
                    	<html:text property="arctype" styleClass="input" size="4" maxlength="3" /> 
                    </logic:equal>
                     <logic:notEqual parameter="mode" value="insert"> 
                   		<bean:write name="type2Form"  property="arctype" />
                   		<html:hidden property="arctype"/>
                    </logic:notEqual>
                    
                  </td>
                </tr>
                <tr> 
                  <td class="lib"><b>Libellé :</b></td>
                  <td>
                    <logic:notEqual parameter="action" value="supprimer">
                    	<html:text property="libarc" styleClass="input" size="35" maxlength="30" onchange="return VerifierAlphanum(this);"/>  
 					</logic:notEqual>
 					 <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="type2Form"  property="libarc" />
                    </logic:equal>
                  </td>
                </tr>
                <tr> 
                  <td class="lib"><b>Top actif :</b></td>
                  <td>
                    <logic:notEqual parameter="action" value="supprimer">
				 		 <logic:iterate id="element" name="choixTopFer">
							<bean:define id="choix" name="element" property="cle"/>
							<html:radio property="topActif" value="<%=choix.toString()%>"/>
			 				<bean:write name="element" property="libelle"/>
						</logic:iterate> 
					</logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">	
  						<bean:write name="type2Form" property="topActif"/>
  					</logic:equal>
                  </td>
                </tr>
              <logic:notEqual parameter="action" value="supprimer">
                <tr> 
                  <td class="lib"><b>Liaisons avec les types 1 :</b></td>
                  <td>
                  	  <html:select property="lst_Type1" styleClass="input" size="9" multiple="true" onchange="MAJ_Types1(this);"> 
   						<html:options collection="choixTypproj" property="cle" labelProperty="libelle" />
					  </html:select>
                  </td>
                </tr>
  			  </logic:notEqual>
                <tr>
                  <td colspan=2>&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan=2>&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan=2>&nbsp;</td>
                </tr>
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
                  <div align="center"> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="return controleCarSpec(this.form.arctype,'Code type 2');Verifier(this.form, 'valider', this.form.mode.value,true);"/> 
                  </div>
                </td>
                <td width="25%"> 
                  <div align="center"> <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', null, false);"/> 
                  </div>
                </td>
                <td width="25%">&nbsp;</td>
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
</body>
<% 
Integer id_webo_page = new Integer("1010"); 
com.socgen.bip.commun.form.AutomateForm formWebo = type2Form ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
