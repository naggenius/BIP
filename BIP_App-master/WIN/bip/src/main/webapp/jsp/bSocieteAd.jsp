 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/ajaxtags.tld" prefix="ajax" %>


<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<html:html locale="true"> 
<jsp:useBean id="societeForm" scope="request" class="com.socgen.bip.form.SocieteForm" />
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
<jsp:include page="ajax.jsp" flush="true" />

<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/bSocieteAd.jsp"/> 
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

var blnVerifFormat  = true;
var tabVerif = new Object();




function MessageInitial()
{
  tabVerif["soccode"] = "VerifierAlphaMax(document.forms[0].soccode)";
   var Message="<bean:write filter="false"  name="societeForm"  property="msgErreur" />";
   var Focus = "<bean:write name="societeForm"  property="focus" />";
   if (Message != "") {
   	  // Gestion du cas du char & dans le nom de société
   	  while(Message.indexOf("&amp;") > 0){
   		 Message = Message.replace("&amp;", "&");
   	  }
      alert(Message);
   }

}


function Verifier(form, action, mode, flag)
{
 

   blnVerification = flag;

   form.action.value = action;
   form.mode.value=mode;
   

   	
    
   if (action=="suite") {
    	form.keyList0.value=form.soccode.value;
   }
}

function ValiderEcran(form)
{
   if (blnVerification) {

	if (!ChampObligatoire(form.soccode, "un code société")) return false;
    if ( (form.action.value=="creer") && 
         ( (form.soccode.value.length != 4) || form.soccode.value.indexOf(' ') > -1) )
   	{
   		alert("Le code societe doit être sur 4 caractères ou sans espace");
   		return false;
   	}
    	   
    if ( !VerifFormat(null) ) return false;

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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Mise &agrave; jour des sociétés<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> </td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/societe"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
             <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
				   <input type="hidden" name="pageAide" value="<%= sPageAide %>">
                  <html:hidden property="action" value="creer"/> 
                  <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
                  <html:hidden property="keyList0"/>
                      
                  <table width="100%" border="0" cellpadding=2 cellspacing=2 class="tableBleu">
                      <tr> 
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp; </td>
                      </tr>
                      <tr> 
                      <td align="center"><b>Veuillez saisir un code société ou un code groupe ou un libellé : </b></td>
                      </tr>
                      <tr> 
                        <td>&nbsp; </td>
                      </tr>
                      <tr>
                       <td align="center">
                       <html:text property="soccode" styleClass="input" size="10" maxlength="10" />
                        <span id="indicator" style="display:none;"><img src="../images/indicator.gif" /></span>
						 <ajax:autocomplete
								  source="soccode"
  								  target="soccode"
  								  parameters="libelle={soccode}"
 								  baseUrl="${pageContext.request.contextPath}/autocompleteSociete.do"
  								  className="autocomplete"
                                  indicator="indicator"
                                  minimumCharacters="1"/>
                       </td>
                       </tr>
                      <tr> 
                        <td>&nbsp; </td>
                      </tr>
                       <tr> 
                        <td>&nbsp; </td>
                      </tr>
                     
                      </table>
				 
			  
			 <table  border="0" width=85%>
              <tr> 
                <td align="right" width=13%> 
                 <html:submit property="boutonCreer" value="Créer" styleClass="input" onclick="Verifier(this.form, 'creer', 'select', true);"/>
                </td>
                <td align="center" width="5%">&nbsp;</td>
                <td align="center" width=13%> 
               <html:submit property="boutonModifier" value="Modifier" styleClass="input" onclick="Verifier(this.form, 'modifier', 'update', true);"/>          
                </td>
                <td align="left" width=5%></td>
                <td align="center" width=13%>
              <html:submit property="boutonSupprimer" value="Supprimer" styleClass="input" onclick="Verifier(this.form, 'supprimer', 'delete',true);"/>
                </td>
                <td align="left" width="5%">&nbsp;</td>
                <td align="left" width=13%> 
                <html:submit property="boutonFournisseur" value="Fournisseurs" styleClass="input" onclick="Verifier(this.form, 'suite', null, true);"/>
                </td>
                <td align="left" width="5%">&nbsp;</td>
                <td align="left" width=13%> 
                <html:submit property="boutonFournisseurEbis" value="Fournisseurs Expense" styleClass="input" onclick="Verifier(this.form, 'suite1', null, true);"/>
                </td>
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


                                  
                                  
</body></html:html>

