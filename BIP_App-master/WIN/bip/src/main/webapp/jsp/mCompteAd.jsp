 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.util.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.bip.commun.liste.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="compteForm" scope="request" class="com.socgen.bip.form.CompteForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fmCompteAd.jsp"/> 
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	
	
	 ArrayList listeType = new ArrayList();
	 listeType.add(0,new ListeOption("C", "Crédit"));
	 listeType.add(1,new ListeOption("D", "Débit"));
	 pageContext.setAttribute("choixType", listeType);
	
%>
var pageAide = "<%= sPageAide %>";

var blnVerifFormat  = true;
var tabVerif = new Object();

function MessageInitial()
{
   
   var Message="<bean:write filter="false"  name="compteForm"  property="msgErreur" />";
   var Focus = "<bean:write name="compteForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else if (document.forms[0].libcompte){
	   document.forms[0].libcompte.focus();
   }
}

function Verifier(form, action, mode, flag)
{
   blnVerification = flag;
   form.action.value = action;
   form.mode.value = mode;
}

function ValiderEcran(form)
{
   if (blnVerification) {
   	if ((form.action.value!="valider")&&(form.action.value!="annuler"))
  		form.action.value ="valider";
  		
  	if (form.mode.value == 'delete') {
	   if (!confirm("Voulez-vous supprimer ce compte ?")) return false;
	}
    else {
	   if (form.libcompte) {
			if (!ChampObligatoireLibelle(form.libcompte)) return false;
		}
		if (form.mode.value == 'update') {
		   if (!confirm("Voulez-vous modifier ce compte ?")) return false;
		}
		
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
          <bean:write name="compteForm" property="titrePage"/> un compte<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/compte"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
			<input type="hidden" name="pageAide" value="<%= sPageAide %>">
			  <html:hidden property="titrePage"/>
              <html:hidden property="action"/>
              <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
              <html:hidden property="flaglock"/>
              <table cellspacing="2" cellpadding="2" class="tableBleu"  >
                <tr> 
                  <td colspan=2 >&nbsp;</td>
                 
                </tr>
                <tr> 
                  <td colspan=2>&nbsp;</td>
                 
                </tr>
                <tr> 
                  <td class="lib"><b>Code Compte :</b></td>
                  <td><b><bean:write name="compteForm" property="codcompte"/></b>
  				  	<html:hidden property="codcompte"/>
  				  	</td>
                </tr>
                <tr> 
                  <td class="lib"><b>Libell&eacute; du compte :</b></td>
                  <td> 
                    <logic:notEqual parameter="action" value="supprimer"> 
                  		<html:text property="libcompte" styleClass="input" size="50" maxlength="50" onchange="return VerifFormat(this.name);"/>
				    </logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">
  						<bean:write name="compteForm" property="libcompte"/>
  					</logic:equal>
				  </td>
                </tr>
                
                <tr>
                 <td  class="lib" ><b>Type du compte :</b></td>
                  <td> 
                    <logic:notEqual parameter="action" value="supprimer">
	 				    <html:select property="type" styleClass="input"> 
   						<bip:options collection="choixType" />
						</html:select>					
					</logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">
  						<bean:write name="compteForm" property="type"/><html:hidden property="type"/>
  					</logic:equal>
                  </td>
                 </tr> 
                  
                <tr> 
                  <td colspan=2>&nbsp;</td>
                 
                </tr>
                <tr> 
                  <td colspan=2>&nbsp;</td>
                  
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                   <td>&nbsp;</td> 
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
                  <div align="center"> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', this.form.mode.value,true);"/> 
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
</body></html:html>
<!-- #EndTemplate -->
