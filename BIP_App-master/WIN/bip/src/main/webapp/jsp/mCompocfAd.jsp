 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="centrefraisForm" scope="request" class="com.socgen.bip.form.CentrefraisForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/bCentrefraisAd.jsp"/> 
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
   var Message="<bean:write filter="false"  name="centrefraisForm"  property="msgErreur" />";

   if (Message != "") {
      alert(Message);
   }
  
}

function Verifier(form, action, mode, flag)
{
   blnVerification = flag;
   form.action.value = action;
}

function ValiderEcran(form)
{
  var index = form.habilitation.selectedIndex;


  if (blnVerification==true) {
	if ( (index==-1) && (form.action.value == 'valider') ) {
         alert("Choisissez un niveau d'habilitation");
	   return false;
	}
  
    form.keyList1.value=form.habilitation.value;
    form.mode.value="insert";
  }
  else { 
        //pour rediriger vers la bonne page lors de l'annulation
        	form.mode.value="initial";
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Niveau 
            d'habilitation <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/compocf"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>">
               	<html:hidden property="action"/>
               	<html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/> 
               	<html:hidden property="keyList0"/> <!--code centre frais -->
			 	<html:hidden property="keyList1"/> <!--habilitation -->
				
              <table cellspacing="2" cellpadding="2" class="tableBleu"  >
                <tr> 
                  <td colspan=2 >&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan=2>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="lib" >Centre de frais :</td>
                  <td > <b><bean:write name="centrefraisForm"  property="codcfrais" />
                    <html:hidden property="codcfrais"/></b>
                   
                  </td>
                </tr>
                <tr> 
                  <td class="lib" >Libell&eacute; :</td>
                  <td> <b><bean:write name="centrefraisForm"  property="libcfrais" /></b>
                    <html:hidden property="libcfrais"/>
                 
                  </td>
                </tr>
                  <td class="lib" >Filiale :</td>
                  <td> 
                  	<b><bean:write name="centrefraisForm"  property="filcode" /><html:hidden property="filcode"/> - <bean:write name="centrefraisForm"  property="filsigle" /><html:hidden property="filsigle"/></b>
  				     				    
                  </td>
                <tr>
                  <td colspan=2>&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan=2 align="center">
				  <select name="habilitation" class="input" size="5" width=150>
					<option value="br"> Branche  </option>
					<option value="dir"> Direction  </option>
					<option value="dpt"> D&eacute;partement  </option>
					<option value="pole"> P&ocirc;le  </option>
					<option value="tout"> Groupe  </option>
				</select> 	    
	             </td>
                </tr>
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
