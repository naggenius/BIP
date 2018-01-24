<!DOCTYPE html>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="budgMassForm" scope="request" class="com.socgen.bip.form.BudgMassForm" />
<jsp:useBean id="listeProposes" scope="session"	class="com.socgen.ich.ihm.menu.PaginationVector" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>


 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fPropoMassMOAd.jsp"/> 
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
   var Message="<bean:write filter="false"  name="budgMassForm"  property="msgErreur" />";
   var Focus = "<bean:write name="budgMassForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
  if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else if (document.forms[0].bpmontmo_1){
	  document.forms[0].bpmontmo_1.focus();
   }
}


function Verifier(form, action, flag)
{
  blnVerification = flag;
  form.action.value = action;
}
function ValiderEcran(form)
{
    return true;
}

function paginer(page, index , action){
	document.forms[0].action.value =action;
	document.forms[0].page.value=page;
    document.forms[0].index.value=index;
    document.forms[0].submit();
}
</script>
<!-- #EndEditable --> 
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
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr > 
          <td> 
            &nbsp;
          </td>
        </tr>
        <tr> 
          <td><div id="outils" align="center"><!-- #BeginEditable "barre_haut" -->
              <%ToolBarNew tb = new com.socgen.ich.ihm.ToolBarNew("bip_ihm",false,false,true,true,false,false,false,false,false,request) ;%>
				<%=tb.printHtml()%><!-- #EndEditable -->
		</div></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td height="20" class="TitrePage">Saisie en masse des propos&eacute;s pour un code client</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td height="20"> </td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/propoMassMO"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
					 <input type="hidden" name="pageAide" value="<%= sPageAide %>">
                     <html:hidden property="action"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
                     <html:hidden property="page" value="modifier"/>
                     <html:hidden property="perime"/>
					 <html:hidden property="perimo"/>                    
                     <input type="hidden" name="save" value="NON">
                     <input type="hidden" name="index" value="modifier">

				    <table border=0 cellspacing=2 cellpadding=2 class="TableBleu">
                      <tr align="left">
                        <td  class="texte" >Client :</td>
                        <td class="texte"colspan=3 >
                        	<bean:write name="budgMassForm" property="libclicode"/>
                        	<html:hidden property="clicode"/>
                            <html:hidden property="libclicode"/>
                        </td>
                      </tr>
                      <tr align="left">
                        <td class="texte">Année de proposition :</td>
                        <td colspan=3 class="texte" ><bean:write name="budgMassForm" property="annee"/>
                          <html:hidden property="annee"/>
                        </td>
                      </tr>
                      <tr>
                        <td colspan=6>&nbsp;</td>
                      </tr>
                      </table>
                      <table border=0 cellspacing=0 cellpadding=2 class="TableBleu">
                      <tr align="left" class="lib">
                        <td class="texte" align="center"><B>Direct</B></td>
                        <td class="texte" align="center"><B>Ligne</B></td>
                        <td class="texte" align="center"><B>Libellé</B></td>
                        <td class="texte" align="center"><B>DPG</B></td>
                        <td class="texte" align="center"><B>Proposé client</B></td>
                        <td class="texte" align="center"><B>Proposé <br> fournisseur</B></td>
                        <!-- YNI -->
                        <td class="texte" align="center"><B>Date Derniere <br> modification</B></td>
                        <td class="texte" align="center"><B>Identifiant</B></td>
                        <!-- Fin YNI -->
                      </tr>
             <% int i = 0;
			   int nbligne = 0;
			   String libClicode="";
			   String libPid="";
			   String libFlaglock="";
			   String libPropose="";
			   String[] strTabCols = new String[] {  "fond1" , "fond2" }; %>
			<logic:iterate id="element" name="listeProposes" length="<%=  listeProposes.getCountInBlock()  %>" 
            			offset="<%=  listeProposes.getOffset(0) %>"
						type="com.socgen.bip.metier.Propose"
						indexId="index"> 
			<% if ( i == 0) i = 1; else i = 0;
			   nbligne ++;
			   libPid="pid_"+nbligne;
			   libFlaglock="flaglock_"+nbligne;
			   libPropose="bpmontmo_"+nbligne;
			 %>
						<tr align="left" class="<%= strTabCols[i] %>">
    			  		<td class="contenu" align="center"><bean:write name="element" property="clicode"/></td>
						
						<td class="contenu"><bean:write name="element" property="pid" />
							<input type="hidden" name="<%=libPid%>" value="<bean:write name="element" property="pid" />">
							<input type="hidden" name="<%=libFlaglock%>" value="<bean:write name="element" property="flaglock" />">
						</td>
						
    			  		<td class="contenu"><bean:write name="element" property="pnom" /></td>
    			  		<td class="contenu" align="center"><bean:write name="element" property="libCodsg" /></td>
    			  		
    			  		<td class="contenu" align="right">
    			  		
						<% // N'ouvrir le champ Proposé client en màj QUE SI le DPG de la ligne fait partie du Perim_ME ET le code client principal de la ligne fait partie du Perim_MO %>
						<logic:equal name="element" property="isPerimMo" value="O"> 
							<logic:equal name="element" property="isPerimMe" value="O">
								<input type="text" class="input" size="9" maxlength="9" name="<%=libPropose%>" value="<bean:write name="element" property="bpmontmo"/>" onchange="return VerifierNumNegatif(this,8,2);"/>
							</logic:equal>
							<logic:notEqual name="element" property="isPerimMe" value="O">
								<bean:write name="element" property="bpmontmo"/>
							</logic:notEqual> 
						</logic:equal>
    			  		<%// } else { %>
    			  		<logic:notEqual name="element" property="isPerimMo" value="O"> 
				      		<bean:write name="element" property="bpmontmo"/>
						</logic:notEqual>

    			  		</td>

						<td class="contenu" align="right"><bean:write name="element" property="bpmontme" /></td>
						<!-- YNI -->
						<td class="contenu" align="center"><bean:write name="element" property="bpmedate" /></td>
						<td class="contenu"><bean:write name="element" property="ubpmontmo" /></td>
						<!-- Fin YNI -->
						</tr>
                  </logic:iterate>      
                      
                   
               	</table>
             
             	<table  width="100%" border="0" cellspacing="0" cellpadding="0">
			   	<tr>
					<td align="center" colspan="4" class="contenu">
						<bip:pagination beanName="listeProposes"/>
					</td>
				</tr>
	 			<tr><td colspan="4" height="20">&nbsp;
	 			</tr>
	 			<tr>
              		<td width="25%">&nbsp;</td>
                	<td width="25%">
                	 <div align="center">
                	  <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', true);"/>
                	 </div>
               		</td> 
               		<td width="25%"> 
                  	 <div align="center"> 
                	  <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', false);"/>
              		 </div>
                </td>
                <td width="25%">&nbsp;</td>
            	</tr>
     
				</table>
                    <!-- #EndEditable --></div>
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
</div>
	<div id="bottomContainer">
			<div>&nbsp;</div>
	</div>
</div>
</body>
<% 
Integer id_webo_page = new Integer("1059"); 
com.socgen.bip.commun.form.AutomateForm formWebo = budgMassForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
