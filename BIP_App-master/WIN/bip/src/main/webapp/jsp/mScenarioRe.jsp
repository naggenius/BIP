<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="scenarioForm" scope="request" class="com.socgen.bip.form.ScenarioForm" />
<html:html locale="true"> 
 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 
<title>Outil de r&eacute;estim&eacute;</title>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<bip:VerifUser page="jsp/bScenarioRe.jsp"/>
<%

java.util.ArrayList list1 = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("ouiNon"); 
pageContext.setAttribute("choixOfficiel", list1);

java.util.ArrayList list2 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("scenarios",scenarioForm.getHParams()); 
pageContext.setAttribute("choixScenario", list2);

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
   var Message="<bean:write filter="false"  name="scenarioForm"  property="msgErreur" />";
   var Focus = "<bean:write name="scenarioForm"  property="focus" />";
   if (Message != "") 
   {
      alert(Message);
   }
   if (Focus != "")
   {
   		(eval( "document.forms[0]."+Focus )).focus();
   }
   else if (document.forms[0].mode.value!="delete")
   {
	   if (document.forms[0].mode.value=="update") document.forms[0].lib_scenario.focus(); 
       if (document.forms[0].mode.value=="insert") document.forms[0].code_scenario.focus(); 
   }    	
}

function Verifier(form, action, mode, flag)
{
   blnVerification = flag;
   form.action.value = action;
}

function ValiderEcran(form)
{
var chaine="";
 if (blnVerification == true) {
     if (form.mode.value== 'delete') {
        if (!confirm("Voulez-vous supprimer ce scénario ?")) return false;
     }
     else {		
		 if (!ChampObligatoire(form.code_scenario, "le code scénario")) return false;
	
		 if (!ChampObligatoire(form.lib_scenario, "le libellé du scénario")) return false;
	
		 // Traitement de la récupération du commentaire
		 Cpt=0;
		 form.commentaire.value=document.forms[0].liste_objet.value;
		 if (document.forms[0].commentaire) {
			 for (Cpt=0; Cpt < form.commentaire.value.length; Cpt++ ) {
				if ((form.commentaire.value.charAt(Cpt)!=" ")&&(escape(form.commentaire.value.charAt(Cpt))!="%0D")&&(escape(form.commentaire.value.charAt(Cpt))!="%0A")){
					chaine = chaine+form.commentaire.value.charAt(Cpt);
				}
			 }
		 }
		 	 				
		 if (chaine.length>=500) {
			alert("Commentaire trop long");
			form.liste_objet.focus();
			return false;
		 }

		 if (form.mode.value== 'update') {
		 	if (form.init_scenario.value != "" &&  form.init_scenario.value != form.code_scenario.value) {
				if (!confirm("Tous les réestimés du scénario vont être réinitialisés - Etes-vous sûr ?")) return false;
		 	}
		 	else {
		 	if (form.action.value== 'modifier') form.action.value= 'valider';
			if (!confirm("Voulez-vous modifier ce scénario ?")) return false;
			}
		 }
      }
   }
 
   return true;
}
</script>
 
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
          <td height="20" class="TitrePage">
           <bean:write name="scenarioForm" property="titrePage"/> un Sc&eacute;nario</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> 
          	<html:form action="/scenario"  onsubmit="return ValiderEcran(this);"> 
            <div align="center">
			<input type="hidden" name="pageAide" value="<%= sPageAide %>">
            <html:hidden property="action"/>
		    <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
		    <table cellspacing="2" cellpadding="2" class="tableBleu">
                <tr> 
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="lib" ><b>Code D&eacute;partement/P&ocirc;le/Groupe : </b></td>
                  <td colspan="4">
                    <b><bean:write name="scenarioForm" property="codsg"/></b> 
                    <html:hidden property="codsg"/>
                 
                  </td>
                </tr>
                <tr> 
                  <td >&nbsp;</td>
                </tr>
                <tr> 
                  <td class="lib" ><b>Code du Sc&eacute;nario : </b></td>
                  <td colspan="4" >
                    <logic:notEqual parameter="action" value="creer">
                    	<b><bean:write name="scenarioForm"  property="code_scenario"/><b>
                    	<html:hidden property="code_scenario"/>
                    </logic:notEqual>
                  	<logic:equal parameter="action" value="creer">
                   		<html:text property="code_scenario" styleClass="input" size="12" maxlength="12" onchange="return VerifierAlphaMaxCarSpecScenario(this);"/>
                    </logic:equal>
                  </td>
                </tr>
                <tr> 
                  <td >&nbsp;</td>
                </tr>
                <tr> 
                  <td class="lib"><b>Libell&eacute; du Sc&eacute;nario : <b></td>
                  <td colspan="4" > 
                    <logic:notEqual parameter="action" value="supprimer">
                   		<html:text property="lib_scenario" styleClass="input" size="60" maxlength="60" onchange="return VerifierAlphanum(this);"/>
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="scenarioForm"  property="lib_scenario" />
                    </logic:equal> 
                
                  </td>
                </tr>
                <tr> 
                  <td >&nbsp;</td>
                </tr>
                <tr> 
                  <td class="lib"><b>Initialiser à partir de : <b></td>
                  <td colspan="4" > 
                    <logic:notEqual parameter="action" value="supprimer">
                    	<html:select property="init_scenario" styleClass="input">
                    		<option value="" selected="selected"> </option> 
                  			<html:options collection="choixScenario" property="cle" labelProperty="libelle" />
						</html:select>
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	&nbsp;
                    </logic:equal>                 
                  </td>
                </tr>
                <tr> 
                  <td >&nbsp;</td>
                </tr>
                <tr> 
                  <td class="lib"><b>Officiel : <b></td>
                  <td colspan="4" > 
                    <logic:notEqual parameter="action" value="supprimer">
                    	<html:select property="officiel" styleClass="input"> 
                  			<html:options collection="choixOfficiel" property="cle" labelProperty="libelle" />
						</html:select>
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="scenarioForm"  property="officiel" />
                    </logic:equal> 
                
                  </td>
                </tr>
                <tr> 
                  <td >&nbsp;</td>
                </tr>
                <tr> 
                  <td class="lib"><b>Commentaire : <b></td>
                </tr>
              </table> 
             </div>
              
              <table width="100%" border="0">
              
                <tr> 
                  <td> 
                    <logic:notEqual parameter="action" value="supprimer">
                        <div align="center"><html:hidden property="commentaire"/> 
                    	<script language="JavaScript">
							var obj = document.forms[0].commentaire.value;
							document.write("<textarea name=liste_objet class='input' rows=7 cols=69 wrap onchange='return VerifierAlphanum(this);'>" + obj +"</textarea>");
						</script>
                    	</div>
                    
                    
                    
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<div align="center">
                    	<bean:write name="scenarioForm"  property="commentaire" />
                 		</div>
                    </logic:equal> 
                                  
                  </td>
                </tr>
              </table>
          </td>
        </tr>
        <tr> 
          <td align="center"> 
            <table width="100%" border="0">
              <tr> 
                <td width="25%">&nbsp;</td>
                <td width="25%"> 
                  <div align="center"> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', this.form.mode.value,true);"/> 
                  </div>
                </td>
                <td width="25%"> 
                  <div align="center"> <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'suite', null, false);"/> 
                  </div>
                </td>
                <td width="25%">&nbsp;</td>
              </tr>
            </table>
    		</html:form>
          </td>
        </tr>
        <tr> 
          <td>&nbsp; </td>
        </tr>
        <tr> 
          <td> 
            <div align="center"><html:errors/></div>
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
Integer id_webo_page = new Integer("4005"); 
com.socgen.bip.commun.form.AutomateForm formWebo = scenarioForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>