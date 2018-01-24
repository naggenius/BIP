<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,java.lang.*,java.util.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,com.socgen.bip.commun.liste.*"    errorPage="../jsp/erreur.jsp"  %>

<jsp:useBean id="fourCopiForm" scope="request" class="com.socgen.bip.form.FourCopiForm" />
<html:html locale="true">
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fmFourCopiAd.jsp"/> 
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
   
   var Message="<bean:write filter="false"  name="fourCopiForm"  property="msgErreur" />";
   var Focus = "<bean:write name="fourCopiForm"  property="focus" />";
     
   if (Message != "") {
      alert(Message);
   }
   
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else if (document.forms[0].mode.value != 'delete')
     {
     if(document.forms[0].libelle){
	   document.forms[0].libelle.focus();
     }
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
	   if (!confirm("Voulez-vous supprimer ce fournisseur ?")) return false;
	}
    else {
    
     
	   if (!ListeObligatoire(form.libelle,"le libellé du fournisseur")) return false;
	       	  
            
	   if (form.mode.value == 'update') {
		   if (!confirm("Voulez-vous modifier ce fournisseur ?")) return false;
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
          <bean:write name="fourCopiForm" property="titrePage"/> un fournisseur COPI<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/FourCopi"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
			<input type="hidden" name="pageAide" value="<%= sPageAide %>">
			  <html:hidden property="titrePage"/>
              <html:hidden property="action"/>
              <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
              <table cellspacing="2" cellpadding="2" class="tableBleu"  >
                <tr> 
                  <td colspan=2 >&nbsp;</td>
                 
                </tr>
                <tr> 
                  <td colspan=2>&nbsp;</td>
                 
                </tr>
                <tr> 
                  <td class="lib"><b>Code Fournisseur :</b></td>
                  <td><b><bean:write name="fourCopiForm" property="code_four_copi"/></b>
  				  	<html:hidden property="code_four_copi"/>
  				  	</td>
                </tr>
          
                 <tr>
                 <td  class="lib" ><b>Libell&eacute;</b></td>
                  <td> 
                    <logic:notEqual parameter="action" value="supprimer">
                    	
						<html:text property="libelle" styleClass="input" size="50" maxlength="50" onchange="return VerifierAlphaMax(this);"/>
					
                   </logic:notEqual>
  					
  					 <logic:equal parameter="action" value="supprimer">
  						<bean:write name="fourCopiForm" property="libelle"/><html:hidden property="libelle"/>
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
