 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"   errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="type1Form" scope="request" class="com.socgen.bip.form.Type1Form" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_filtre_maj.dwt" --><head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>



<!-- #BeginEditable "doctitle" --> 
<title>Filtre Maj</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fmType1Ad.jsp"/> 
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
   tabVerif["typproj"]	= "controleCarSpec(document.forms[0].typproj,'Code type 1')";
   var Message="<bean:write filter="false"  name="type1Form"  property="msgErreur" />";
  var Focus = "<bean:write name="type1Form"  property="focus" />";
   if (Message != "") {
      alert(Message);
      document.forms[0].typproj.focus();
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else if (document.forms[0].typproj){
	  document.forms[0].typproj.focus();
   }
}

function Verifier(form, action, flag)
{
  blnVerification = flag;
  form.action.value = action;
}

function ValiderEcran(form)
{
   if (blnVerification) {
	if ( !VerifFormat(null) ) return false;
	if (!ChampObligatoire(form.typproj,"un code type 1")) return false;

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
              <%=tb.printHtml()%> <!-- #EndEditable --></div>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Mise &agrave; jour de la Typologie des lignes BIP<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td>
		  <!-- #BeginEditable "debut_form" --><html:form action="/type1"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable -->
		  <div align="center"><!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>">
              
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<html:hidden property="action" value="creer"/>
              <table border=0  cellpadding=2 cellspacing=2 class="tableBleu">
                <tr> 
                  <td align=center colspan=2>&nbsp;</td>
                 
                </tr>
                <tr> 
                  <td align=center colspan=2>&nbsp;</td>
                  
                </tr>
                <tr> 
                  <td align=center  ><b>Code type 1 :</b></td>
                  <td>
                  <!-- PPM 60709 - ABE : modification de onchange par onblur -->
                  <html:text property="typproj" styleClass="input" size="2" maxlength="2" onblur="return VerifFormat(this.name);"/>
                  </td> 

                </tr>
                <tr> 
                  <td align=center colspan=2>&nbsp;</td>
                
                </tr>
                <tr> 
                  <td align=center colspan=2>&nbsp;</td>
               
                </tr>
                <tr> 
                  <td align=center colspan=2>&nbsp;</td>
                 
                </tr>
              </table>
              <!-- #EndEditable --></div>
            
		</td>
		</tr>
		<tr>
		<td align="center">

		<table width="100%" border="0">
		
                <tr> 
                  <td width="33%" align="right">  
                	 <html:submit property="boutonCreer" value="Cr&#233er" styleClass="input" onclick="Verifier(this.form, 'creer', true);"/>
                  </td>
				   <td width="33%" align="center">  
     				 <html:submit property="boutonModifier" value="Modifier" styleClass="input" onclick="Verifier(this.form, 'modifier', true);"/>
                  </td>
				   <td width="33%" align="left">  
					<html:submit property="boutonSupprimer" value="Supprimer" styleClass="input" onclick="Verifier(this.form, 'supprimer', true);"/>
                  </td>
                </tr>
            
            </table>
		
			  <!-- #BeginEditable "fin_form" --></html:form><!-- #EndEditable -->
          </td>
        </tr>
		<tr> 
          <td>&nbsp;  
          </td>
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
</html:html> 

<!-- #EndTemplate -->