<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>

<jsp:useBean id="listeActus" scope="session"	class="com.socgen.ich.ihm.menu.PaginationVector" />

<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>


 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fActuAd.jsp"/> 
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
{var Message="";
var Focus ="";

}


function Verifier(form, action, flag)
{
  blnVerification = flag;
  form.action.value = action;
}
function ValiderEcran(form)
{if (form.action.value == 'creer') {form.code_actu.value='';
									form.valide.value='N';
									form.derniere_minute.value='N';}

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
          <td height="20" class="TitrePage">Liste des actualités</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> </td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/actualite"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
					 <input type="hidden" name="pageAide" value="<%= sPageAide %>">
                     <html:hidden property="action"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
                     <html:hidden property="page" value="modifier"/>
                     <input type="hidden" name="index" value="modifier">
                     <html:hidden property="msgErreur" />
                      <table border=0 cellspacing=0 cellpadding=2 class="TableBleu">
                      <tr class="titreTableau">
                        <td class="lib"><B>DM</B></td>
  <td class="lib"><B>Titre</B></td>
  <td class="lib"><B>Date d'affichage</B></td>
  <td class="lib"><B>Valide</B></td>
  <td class="lib"><B>Début</B></td>
  <td class="lib"><B>Fin</B></td>
  <td class="lib"><B>Options</B></td>
                      </tr>
             <% int i = 0;
			   int nbligne = 0;
			    String[] strTabCols = new String[] {  "fond1" , "fond2" }; 
			    %>
			
			
				<logic:iterate id="element" name="listeActus" length="<%=  listeActus.getCountInBlock()  %>" 
            			offset="<%=  listeActus.getOffset(0) %>"
						type="com.socgen.bip.metier.Actualite"
						indexId="index"> 
			<% if ( i == 0) i = 1; else i = 0;
			   nbligne ++;
			 %>
						<tr class="<%= strTabCols[i] %>">
    			  	 <td class="contenu"><bean:write name="element" property="derniere_minute"/></td> 
  <td class="contenu"><bean:write name="element" property="titre"/></td>      
  <td class="contenu"><bean:write name="element" property="date_affiche"/></td>
  <td class="contenu"><bean:write name="element" property="valide"/></td>     
  <td class="contenu"><bean:write name="element" property="date_debut"/></td>  
  <td class="contenu"><bean:write name="element" property="date_fin"/></td>    
  <td class="contenu">	<input type="submit" name="boutonModifier_<bean:write name="element" property="code_actu"/>" value="Modifier" onclick="this.form.code_actu.value=<bean:write name="element" property="code_actu"/>;Verifier(this.form, 'modifier', true);" class="input">
  						<input type="submit" name="boutonSupprimer_<bean:write name="element" property="code_actu"/>" value="Supprimer" onclick="this.form.code_actu.value=<bean:write name="element" property="code_actu"/>;Verifier(this.form, 'supprimer', true);" class="input"></td>  
						</tr>
                  </logic:iterate>    
                      
                   <html:hidden name="element" property="code_actu"/>
                   <html:hidden name="element" property="derniere_minute"/>
                   <html:hidden name="element" property="valide"/> 
               	</table>
             
             	<table  width="100%" border="0" cellspacing="0" cellpadding="0">
			   	<tr>
					<td align="center" colspan="4" class="contenu">
						<bip:pagination beanName="listeActus"/>
					</td>
				</tr>
	 			<tr><td colspan="4">&nbsp;
	 			</tr>
	 			<tr>
              		<td width="25%">&nbsp;</td>
                	<td width="25%">
                	 <div align="center">
                	  <html:submit property="boutonCreer" value="Creer" styleClass="input" onclick="Verifier(this.form, 'creer', true);"/>
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
Integer id_webo_page = new Integer("1068"); 
com.socgen.bip.commun.form.AutomateForm formWebo = null ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
