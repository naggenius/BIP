<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,java.lang.*,java.util.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,com.socgen.bip.commun.liste.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="exceptionCopiForm" scope="request" class="com.socgen.bip.form.ExceptionCopiForm" />
<jsp:useBean id="listeDynamique" scope="request" class="com.socgen.bip.commun.liste.ListeDynamique" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/mExceptionCopiAd.jsp"/> 
<%

	java.util.Hashtable hP = new java.util.Hashtable();
	hP.put("userid", ((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
 	java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("codpspe",hP);
	//java.util.ArrayList list2 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("codpspe",hP);
	//java.util.ArrayList list3 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("codpspe",hP);
//	java.util.ArrayList list4 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("codpspe",hP);
	//java.util.ArrayList list5 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("codpspe",hP);
	list1.add(0, new ListeOption("---", "          " ));     
	pageContext.setAttribute("choixCdepspe1", list1);
	pageContext.setAttribute("choixCdepspe2", list1);
	pageContext.setAttribute("choixCdepspe3", list1);
	pageContext.setAttribute("choixCdepspe4", list1);
	pageContext.setAttribute("choixCdepspe5", list1);
    

  
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
   var Message="<bean:write filter="false"  name="exceptionCopiForm"  property="msgErreur" />";
   var Focus = "<bean:write name="exceptionCopiForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
}

function Verifier(form, action, mode,flag)
{
   blnVerification = flag;
   form.action.value = action;
   
}

function ValiderEcran(form)
{
	if ((document.forms[0].dpcode1.value.length == 0) && 
	(document.forms[0].dpcode2.value.length == 0) &&
	(document.forms[0].dpcode3.value.length == 0) &&
	(document.forms[0].dpcode4.value.length == 0) &&
	(document.forms[0].dpcode5.value.length == 0) &&
	(document.forms[0].icpi1.value.length == 0) &&
	(document.forms[0].icpi2.value.length == 0) &&
	(document.forms[0].icpi3.value.length == 0) &&
	(document.forms[0].icpi4.value.length == 0) &&
	(document.forms[0].icpi5.value.length == 0) &&
	(document.forms[0].airt1.value.length == 0) &&
	(document.forms[0].airt2.value.length == 0) &&
	(document.forms[0].airt3.value.length == 0) &&
	(document.forms[0].airt4.value.length == 0) &&
	(document.forms[0].airt5.value.length == 0) &&
	(document.forms[0].clicode1.value.length == 0) &&
	(document.forms[0].clicode2.value.length == 0) &&
	(document.forms[0].clicode3.value.length == 0) &&
	(document.forms[0].clicode4.value.length == 0) &&
	(document.forms[0].clicode5.value.length == 0) &&
	(document.forms[0].codsg1.value.length == 0) &&
	(document.forms[0].codsg2.value.length == 0) &&
	(document.forms[0].codsg3.value.length == 0) &&
	(document.forms[0].codsg4.value.length == 0) &&
	(document.forms[0].codsg5.value.length == 0) &&
	(document.forms[0].codpspe1.value == '---') &&
	(document.forms[0].codpspe2.value == '---') &&
	(document.forms[0].codpspe3.value == '---') &&
	(document.forms[0].codpspe4.value == '---') &&
	(document.forms[0].codpspe5.value == '---'))
	{
	alert('Veuillez renseigner au moins un champ');
	return false;
	}
	else{
	if (form.action.value == 'supprimer') {
	   if (!confirm("Voulez-vous supprimer cette(s) exception(s)?")) return false;
	}
	return true;}
	
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
          Exception COPI<!-- #EndEditable -->
            </td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/ExceptionCopi"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
			<input type="hidden" name="pageAide" value="<%= sPageAide %>">
						  
	
			  <html:hidden property="titrePage"/>
              <html:hidden property="action" value="valider"/>
              <html:hidden property="mode"/>
              
<html:hidden property="arborescence" value="<%= arborescence %>"/>
              <table cellspacing="2" cellpadding="2" class="tableBleu">
			    <tr> 
                  <td >&nbsp;</td>
                  <td  >&nbsp;</td>
                </tr>
                <tr> 
                  <td >&nbsp;</td>
                  <td  >&nbsp; </td>
                </tr>
                 <tr> 
                  <td  class="lib" ><b>Code dossier projet :</b></td>
                  <td> 
                    <html:text property="dpcode1"  styleClass="input" size="5" maxlength="5" onchange="return VerifierNum(this,5,0);"/> 
   				 </td>
   				 <td> 
                    <html:text property="dpcode2" styleClass="input" size="5" maxlength="5" onchange="return VerifierNum(this,5,0);"/> 
   				 </td>
   				 <td> 
                    <html:text property="dpcode3" styleClass="input" size="5" maxlength="5" onchange="return VerifierNum(this,5,0);"/> 
   				 </td>
   				 <td> 
                    <html:text property="dpcode4" styleClass="input" size="5" maxlength="5" onchange="return VerifierNum(this,5,0);"/> 
   				 </td>
   				 <td> 
                    <html:text property="dpcode5" styleClass="input" size="5" maxlength="5" onchange="return VerifierNum(this,5,0);"/> 
   				 </td>
                </tr>
                <tr> 
                  <td  class="lib" ><b>Code projet :</b></td>
                  <td> 
                    <html:text property="icpi1"  styleClass="input" size="5" maxlength="5" onchange="this.value = this.value.toUpperCase();return VerifierAlphaMax(this);"/> 
   				 </td>
   				 <td> 
                    <html:text property="icpi2" styleClass="input" size="5" maxlength="5" onchange="this.value = this.value.toUpperCase();return VerifierAlphaMax(this);"/> 
   				 </td>
   				 <td> 
                    <html:text property="icpi3" styleClass="input" size="5" maxlength="5" onchange="this.value = this.value.toUpperCase();return VerifierAlphaMax(this);"/> 
   				 </td>
   				 <td> 
                    <html:text property="icpi4" styleClass="input" size="5" maxlength="5" onchange="this.value = this.value.toUpperCase();return VerifierAlphaMax(this);"/> 
   				 </td>
   				 <td> 
                    <html:text property="icpi5" styleClass="input" size="5" maxlength="5" onchange="this.value = this.value.toUpperCase();return VerifierAlphaMax(this);"/> 
   				 </td>
                </tr>
                <tr> 
                  <td  class="lib" ><b>Code application :</b></td>
                  <td> 
                    <html:text property="airt1"  styleClass="input" size="5" maxlength="5" onchange="this.value = this.value.toUpperCase();return VerifierAlphaMax(this);"/> 
   				 </td>
   				 <td> 
                    <html:text property="airt2" styleClass="input" size="5" maxlength="5" onchange="this.value = this.value.toUpperCase();return VerifierAlphaMax(this);"/> 
   				 </td>
   				 <td> 
                    <html:text property="airt3" styleClass="input" size="5" maxlength="5" onchange="this.value = this.value.toUpperCase();return VerifierAlphaMax(this);"/> 
   				 </td>
   				 <td> 
                    <html:text property="airt4" styleClass="input" size="5" maxlength="5" onchange="this.value = this.value.toUpperCase();return VerifierAlphaMax(this);"/> 
   				 </td>
   				 <td> 
                    <html:text property="airt5" styleClass="input" size="5" maxlength="5" onchange="this.value = this.value.toUpperCase();return VerifierAlphaMax(this);"/> 
   				 </td>
                </tr>
                <tr> 
                  <td  class="lib" ><b>Code client :</b></td>
                  <td> 
                    <html:text property="clicode1"  styleClass="input" size="5" maxlength="5" onchange="this.value = this.value.toUpperCase();"/> 
   				 </td>
   				 <td> 
                    <html:text property="clicode2" styleClass="input" size="5" maxlength="5" onchange="this.value = this.value.toUpperCase();"/> 
   				 </td>
   				 <td> 
                    <html:text property="clicode3" styleClass="input" size="5" maxlength="5" onchange="this.value = this.value.toUpperCase();"/> 
   				 </td>
   				 <td> 
                    <html:text property="clicode4" styleClass="input" size="5" maxlength="5" onchange="this.value = this.value.toUpperCase();"/> 
   				 </td>
   				 <td> 
                    <html:text property="clicode5" styleClass="input" size="5" maxlength="5" onchange="this.value = this.value.toUpperCase();"/> 
   				 </td>
                </tr>
                <tr> 
                  <td  class="lib" ><b>Code dpg :</b></td>
                  <td> 
                    <html:text property="codsg1"  styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,7,0);"/> 
   				 </td>
   				 <td> 
                    <html:text property="codsg2" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,7,0);"/> 
   				 </td>
   				 <td> 
                    <html:text property="codsg3" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,7,0);"/> 
   				 </td>
   				 <td> 
                    <html:text property="codsg4" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,7,0);"/> 
   				 </td>
   				 <td> 
                    <html:text property="codsg5" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,7,0);"/> 
   				 </td>
                </tr>
             	 <tr> 
                  <td  class="lib" ><b>Code projet spécial :</b></td>
                  <td> 
                  	 <html:select property="codpspe1" styleClass="input"> 
   						<html:options collection="choixCdepspe1" property="cle" labelProperty="libelle" />
						</html:select>	
				  </td>
				  <td> 
                  	 <html:select property="codpspe2" styleClass="input"> 
   						<html:options collection="choixCdepspe2" property="cle" labelProperty="libelle" />
						</html:select>	
				  </td>
				  <td> 
                  	 <html:select property="codpspe3" styleClass="input"> 
   						<html:options collection="choixCdepspe3" property="cle" labelProperty="libelle" />
						</html:select>	
				  </td>
				  <td> 
                  	 <html:select property="codpspe4" styleClass="input"> 
   						<html:options collection="choixCdepspe4" property="cle" labelProperty="libelle" />
						</html:select>	
				  </td>
				  <td> 
                  	 <html:select property="codpspe5" styleClass="input"> 
   						<html:options collection="choixCdepspe5" property="cle" labelProperty="libelle" />
						</html:select>	
				  </td>
                </tr>
                
                
              </table>
			  <!-- #EndEditable --></div>
          </td>
        </tr>
      <tr> 
			                  <td align=center >&nbsp;</td>
			                  <td >&nbsp;</td>
		     	</tr>  
		        <tr> 
			                  <td align=center >&nbsp;</td>
			                  <td >&nbsp;</td>
		     	</tr>
		     	<tr> 
			                  <td align=center >&nbsp;</td>
			                  <td >&nbsp;</td>
		     	</tr>
        <tr> 
          <td align="center"> 
          	<table width="100%" border="0">
			 <tr> 
	                <td width="25%">&nbsp;</td>
	                <td width="25%"> 
	                  <div align="center"> <input type="submit" name="boutonValider" value="Cr&#233er" onclick="Verifier(this.form, 'creer',true);" class="input"> 
	                  </div>
	                </td>
	                <td width="25%"> 
	                  <div align="center"> <input type="submit" name="boutonAnnuler" value="Supprimer" onclick="Verifier(this.form, 'supprimer', true);" class="input"> 
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
</body>
<% 
Integer id_webo_page = new Integer("1001"); 
com.socgen.bip.commun.form.AutomateForm formWebo = exceptionCopiForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
