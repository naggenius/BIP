<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"   errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="fournisseurEbisForm" scope="request" class="com.socgen.bip.form.FournisseurEbisForm" />

<html:html locale="true">
<!-- #EndEditable --><!-- #BeginTemplate "/Templates/Page_filtre_maj.dwt" --><head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>



<!-- #BeginEditable "doctitle" --> 
<title>Filtre Maj</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/bSocieteAd.jsp"/>
<%
  fournisseurEbisForm.getHParams().put("keyList0",fournisseurEbisForm.getSoccode());
  java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("fournisseurEbis",fournisseurEbisForm.getHParams()); 
  pageContext.setAttribute("choixFournisseur", list1);

  
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
   var Message="<bean:write filter="false"  name="fournisseurEbisForm"  property="msgErreur" />";
   
   if (Message != "") {
      alert(Message);
   }
   document.forms[0].fournebis.selectedIndex = 0;
}

function Verifier(form, action, flag)
{
  blnVerification = flag;
  form.action.value = action;

}
function ValiderEcran(form)
{
   var index = form.fournebis.selectedIndex;

   if (blnVerification==true) {
	if ( (index==-1) && (form.action.value != 'creer') ) {
	   alert("Choisissez un fournisseur");
	   return false;
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Mise à jour d'un fournisseur Expense<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td>
		  <!-- #BeginEditable "debut_form" --><html:form action="/fournisseurebis"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable -->
		  <div align="center"><!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>">
		  	<html:hidden property="action"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
	   	    <html:hidden property="keyList0"/>
		    <table cellspacing="2" cellpadding="2" class="tableBleu" >
                <tr>
                  <td >&nbsp;</td>
                  <td  bgcolor="#FFFFFF" >&nbsp;</td>
                </tr>
                <tr> 
                  <td >&nbsp;</td>
                  <td  bgcolor="#FFFFFF" >&nbsp;</td>
                </tr>
                <tr> 
                  <td ><b>Code société :</b></td>
                  <td > 
                    <div align="left"><b> <bean:write name="fournisseurEbisForm"  property="soccode" /></b>
                    <html:hidden property="soccode"/>
                    </div>
                  </td>
                </tr>
                <tr> 
                  <td  colspan="2" >&nbsp;</td>
                </tr>
              </table>
                
              <table class="tableBleu">
			    <tr align=center ><td class="lib">
				<b>Fournisseurs</b> 
				</td>
				</tr>
                <tr> 
                  <td  colspan=3> 
                    <div align="center"> 
                    	<html:select property="fournebis" styleClass="input" size="5"> 
   						<html:options collection="choixFournisseur" property="cle" labelProperty="libelle" />
						</html:select>
                    </div>
                  </td>
               
              </table>
              <!-- #EndEditable --></div>
            
		</td>
		</tr>
		<tr> 
                        <td>&nbsp; </td>
                      </tr>
                      <tr> 
                        <td>&nbsp; </td>
                      </tr>
                      <tr> 
                        <td>&nbsp; </td>
                      </tr>
		<tr>
		<td align="center">

		<table width="80%" border="0" align="center">
		
                <tr> 
                  <td width="25%" align="center">  
                	 <html:submit property="boutonCreer" value="Cr&#233er" styleClass="input" onclick="Verifier(this.form, 'creer', true);"/>
                  </td>
				   <td width="25%" align="center">  
     				 <html:submit property="boutonModifier" value="Modifier" styleClass="input" onclick="Verifier(this.form, 'modifier', true);"/>
                  </td>
				   <td width="25%" align="center">  
					<html:submit property="boutonSupprimer" value="Supprimer" styleClass="input" onclick="Verifier(this.form, 'supprimer', true);"/>
                  </td>
                  <td width="25%" align="center">  
					<html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler',  false);"/>
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