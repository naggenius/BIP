<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="budActJhForm" scope="request" class="com.socgen.bip.form.BudActJhForm" />
<jsp:useBean id="listeBudDossProjDep" scope="session"	class="com.socgen.ich.ihm.menu.PaginationVector" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>


 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/bBudActJhAd.jsp"/>
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
   var Message="<bean:write filter="false"  name="budActJhForm"  property="msgErreur" />";
   var Focus = "<bean:write name="budActJhForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
  if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else if (document.forms[0].budgethtr){
	  document.forms[0].budgethtr.focus();
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
          <td height="20" class="TitrePage">Saisie des budgets - activités JH - en Kilo€uros</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> </td>
        </tr>
        <tr> 
          <td><html:form action="/budActJh"  onsubmit="return ValiderEcran(this);">
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
					 <input type="hidden" name="pageAide" value="<%= sPageAide %>">
                     <html:hidden property="action"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
                     <html:hidden property="page" value="modifier"/>
                     <input type="hidden" name="index" value="modifier">
                     
				    <table border=0 cellspacing=2 cellpadding=2 class="TableBleu">
                      <tr>
                        <td  class="lib" >Année choisie :</td>
                        <td colspan=3 >
                        	<bean:write name="budActJhForm" property="annee"/>
                        	<html:hidden property="annee"/>
                        </td>
                      </tr>
                      <tr>
                        <td class="lib">Structure cliente :
                        <td colspan=3 ><bean:write name="budActJhForm" property="libClicode"/>
                          <html:hidden property="libClicode"/>
                          <html:hidden property="clicode"/>
                        </td>
                      </tr>
                      <tr>
                        <td colspan=6>&nbsp;</td>
                      </tr>
                      </table>
                      <table border=0 cellspacing=0 cellpadding=2 class="TableBleu">
                      <tr class="titreTableau">
                        <td class="lib"><B>Dossier Projet</B></td>
                        <td class="lib">&nbsp;</td>
                        <td class="lib"><B>Budget en K€uros HTR</B></td>
                      </tr>
             <%int i = 0;
			   int nbligne = 0;
			   String dpcode="";
			   String budgetHtr="";
			   String[] strTabCols = new String[] {  "fond1" , "fond2" }; %>
			<logic:iterate id="element" name="listeBudDossProjDep" length="<%=  listeBudDossProjDep.getCountInBlock()  %>" 
            			offset="<%=  listeBudDossProjDep.getOffset(0) %>"
						type="com.socgen.bip.metier.BudActJh"
						indexId="index"> 
			<% if ( i == 0) i = 1; else i = 0;
			   nbligne ++;
			   dpcode="dpcode_"+nbligne;
			   budgetHtr="budgetHtr_"+nbligne;
			 %>
						<tr class="<%= strTabCols[i] %>">
    			  		<td class="contenu"><bean:write name="element" property="dpcode" /></td>
    			  		<input type="hidden" name="<%=dpcode%>" value="<bean:write name="element" property="dpcode" />">
    			  		<td class="contenu"><bean:write name="element" property="dplib" /></td>					
						
    			  		<td class="contenu" align="right">
    			  		<input type="text" class="input" size="9" maxlength="9" name="<%=budgetHtr%>" value="<bean:write name="element" property="budgetHtr"/>" onchange="return VerifierNumNegatif(this,10,2);"/>
    			  		</td>
    			  		</tr>
             </logic:iterate>      
                      
                   
               	</table>
             
             	<table  width="100%" border="0" cellspacing="0" cellpadding="0">
			   	<tr>
					<td align="center" colspan="4" class="contenu">
						<bip:pagination beanName="listeBudDossProjDep"/>
					</td>
				</tr>
	 			<tr><td colspan="4">&nbsp;
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
</body>
<% 
Integer id_webo_page = new Integer("1056"); 
com.socgen.bip.commun.form.AutomateForm formWebo = budActJhForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
