<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="affectationForm" scope="request" class="com.socgen.bip.form.AffectationForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_filtre.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="/affectation.do"/> 
<%  
	java.util.ArrayList list1;

	String choix_filtre = affectationForm.getChoix_filtre();
	if ( "".equals(choix_filtre) || choix_filtre == null || "1".equals(choix_filtre)) {
		choix_filtre = "1";
		list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("isac_resscons_aff",affectationForm.getHParams());
	} else {
		choix_filtre = "2";
		list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("ress_hab",affectationForm.getHParams());
	}
	
    pageContext.setAttribute("choixRess", list1);
    
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
   var Message="<bean:write filter="false"  name="affectationForm"  property="msgErreur" />";
   var Focus = "<bean:write name="affectationForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else {
	  document.forms[0].ident.focus();
   }
}

function Verifier(form, action, flag)
{
	if (form.choix[0].checked)
	{
	form.choix_filtre.value = "1";
	}
	if (form.choix[1].checked)
	{
	form.choix_filtre.value = "2";
	}
	
  blnVerification = flag;
  form.action.value = "supprimer";
}

function ValiderEcran(form)
{  if (blnVerification) {
	form.keyList0.value=form.ident.value;

   }
	
   return true;
}
function SelectChoix(form){

    form.keyList0.value = form.ident.value;
	
	if (form.choix[0].checked)
	{
	form.choix_filtre.value = "1";
	}
	if (form.choix[1].checked)
	{
	form.choix_filtre.value = "2";
	}

	form.action.value = "retour";
	form.submit();
	
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
		  <td height="20" class="TitrePage"><div id="titre" ><!-- #BeginEditable "titre_page" -->Les sous-t&acirc;ches d'une ressource<!-- #EndEditable --></div></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/affectation"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
             <div id="content">
			
            <input type="hidden" name="pageAide" value="<%= sPageAide %>">	
            
			<html:hidden property="action"/>
            <html:hidden property="mode"/>
            <html:hidden property="choix_filtre"/>
			<html:hidden property="arborescence" value="<%= arborescence %>"/>
            <html:hidden property="keyList0"/> <!--ident-->
				<div align="center"><!-- #BeginEditable "contenu" -->
			  <table border="0" class="TableBleu" cellpadding="2" cellspacing="2"  >
                <tr> 
                  <td>&nbsp;</td>
                </tr>

	             <tr><td colspan="2">   
		             
					 <table border="0" class="TableBleu" cellpadding="0" cellspacing="0">   
		                <tr>
		      						<td align="left">
		      							<input type="radio" name="choix" styleClass="input" value="1" <% if ( choix_filtre == "1") { %> checked <% } %> onclick="SelectChoix(this.form)"; >	
		      						</td>
		      						<td class="texteGras"><B>&nbsp;Ressources habilitées, affectées et actives&nbsp;</B></td>
		    					  </tr>
		    					  <tr><td>&nbsp;</td></tr>
		    					  <tr>
		      						<td>
		      							<input type="radio" name="choix" styleClass="input" value="2" <% if ( choix_filtre == "2") { %> checked <% } %> onclick="SelectChoix(this.form)"; >	
		      						</td>
		      						<td class="texteGras"><B>&nbsp;Ressources affectées sur vos lignes habilitées&nbsp;</B></td>
		    					  </tr>
		            </table>     
	            </td></tr>
            
            
                            
                <tr> 
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td class='texte'><b>Choisissez une ressource : </b> </td>
                  <td width="320"> 
                  	<html:select property="ident" size="1" styleClass="input">
                  	   <html:options collection="choixRess" property="cle" labelProperty="libelle"/>
                	</html:select>
                  </td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                </tr>
 				<tr> 
				  <td align="center" colspan="2"> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'suite', true);"/> 
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
	  
    </td>
  </tr>
</table>
</div>
	<div id="bottomContainer">
			<div>&nbsp;</div>
	</div>
</div>
</body></html:html>
<!-- #EndTemplate -->
