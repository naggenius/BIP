<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="extractParamForm" scope="request" class="com.socgen.bip.form.ExtractParamForm" />
<html:html locale="true"> <!-- #EndEditable --> 
<!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/bAuditAd.jsp"/>
<%
	java.util.Hashtable hP = new java.util.Hashtable();
	hP.put("userid", ((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
	java.util.ArrayList listExtract = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("extraction", hP); 
	pageContext.setAttribute("choixExtract", listExtract);
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

   var Message="<bean:write filter="false"  name="extractParamForm"  property="msgErreur" />";

   if (Message != "") {
      alert(Message);
   }

}

function Verifier(form, action, flag)
{
  blnVerification = flag;
  form.action.value = action;

}

function ValiderEcran(form)
{
   
    var nb = form.nbData.value;
    tab = form.data.value.split(";");
    
    form.choix.value="";
    form.data.value="";
    for (i=1;i<=nb;i++) {
    	if (form.colonne[i-1].checked)
			{
				
				if ((i==1)||(form.choix.value=="")) {
					form.choix.value =  i;
					form.data.value=tab[i-1];
				}
				else {
					form.choix.value = form.choix.value +";"+ i;
					form.data.value=form.data.value+";"+tab[i-1];
					
				}
			}
			
	}
	//alert("form.data.value:"+form.data.value);
    //alert(form.choix.value);
 
    if (form.choix.value=="")
	{
		alert("Il faut sélectionner au moins une colonne.");
		return false;
	}
	if (form.en_tete.checked)
		form.enTete.value=true;
	else
		form.enTete.value=false;
   

	document.extractParamForm.submit.disabled = true;
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Audit - Sélection des données
            <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> </td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/extractParam"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>"> 
			<html:hidden property="action"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
			<html:hidden property="titre"/>
			<html:hidden property="nomFichier"/>
			<html:hidden property="data"/>
			<html:hidden property="nbData"/>
			<html:hidden property="filtreSql"/>
			<html:hidden property="choix"/>
			<html:hidden property="enTete"/>
			
                    <table cellspacing="0" cellpadding="0" class="tableBleu">
                      <tr> 
                        <td >&nbsp;</td>
                      </tr>
                      
                      <tr> 
                        <td align=\"center\"><b><u><bean:write name="extractParamForm"  property="titre" /></u></b></td>
                      </tr>
                      <tr> 
                        <td >&nbsp;</td>
                      </tr>
                      <tr> 
                      <tr><td><input type="checkbox" name="en_tete" value="enTete" CHECKED>Avec en-tête</td></tr>
					  <tr> 
                        <td ><HR></td>
                      </tr>
	<bip:colonneRequete/>
	

         			<tr> 
                        <td >&nbsp;</td>
                        <td >&nbsp;</td>
                      <tr> 
                        <td >&nbsp;</td>
                        <td >&nbsp;</td>
                    </table>
                    <table  border="0" width=100%>
                      <tr> 
                        <td  width=100% align=center> <html:submit value="Extraction" styleClass="input" onclick="Verifier(this.form, 'creer', true);"/> 
                        </td>
                      </tr>
                    </table>
                    </div>
                </td>
              </tr>
            </table>
           </html:form>
          </td>
        </tr>
        <tr> 
          <td>&nbsp; </td>
        </tr>
        <tr> 
          <td> 
            <div align="center"><html:errors/></div>
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


