<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,java.lang.*,java.util.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,com.socgen.bip.commun.liste.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="majDirectionsForm" scope="request" class="com.socgen.bip.form.DirectionsForm" />
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
<bip:VerifUser page="jsp/fmDirectionsAd.jsp"/> 
<%

  java.util.ArrayList list1 = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("listeTopMe"); 
  java.util.ArrayList list2 = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("listeSysCompta");
  java.util.ArrayList list3 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("branche",majDirectionsForm.getHParams());
  java.util.ArrayList list4 = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("listeReferentiel"); 
  java.util.ArrayList list5 = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("listePerimetre");
  pageContext.setAttribute("choixTopMe", list1);
  pageContext.setAttribute("choixSysCompta", list2);
  pageContext.setAttribute("choixCdeBr", list3);
  pageContext.setAttribute("choixReferentiel", list4);
  pageContext.setAttribute("choixPerimetre", list5);
  
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
   var Message="<bean:write filter="false"  name="majDirectionsForm"  property="msgErreur" />";
   var Focus = "<bean:write name="majDirectionsForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else if (document.forms[0].mode.value!='delete'){
	   document.forms[0].libdir.focus();
   }
}

function Verifier(form, action, mode,flag)
{
   blnVerification = flag;
   form.action.value = action;
}

function ValiderEcran(form)
{
  if (blnVerification == true) {
     if (form.mode.value != 'delete') {
	     if (!ChampObligatoire(form.syscompta, "le système comptable")) return false;
	     if (!ChampObligatoire(form.codref, "le code référentiel")) return false;
	     if (!ChampObligatoire(form.codperim, "le code périmètre (BU)")) return false;
	     if (!ChampObligatoire(form.codbr, "le code branche")) return false;
	     if (!ChampObligatoire(form.libdir, "le libellé de la direction")) return false;
	     if (!ChampObligatoire(form.topme, "le top ME")) return false;
     
     	 if (!form.topme[0].checked && !form.topme[1].checked) {
        	alert("Choisissez Oui ou Non");
        	return false;
     	 }
     }
   

     if (form.mode.value == 'update') {
        if (!confirm("Voulez-vous modifier cette direction ?")) return false;
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
          <bean:write name="majDirectionsForm" property="titrePage"/> une Direction<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/majDirections"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
			<input type="hidden" name="pageAide" value="<%= sPageAide %>">
			<html:hidden property="titrePage"/>
              <html:hidden property="action" value="creer"/>
              <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
              <html:hidden property="flaglock"/>
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
                  <td class="lib"><b>Code Direction :</b></td>
                  <td><b><bean:write name="majDirectionsForm"  property="coddir" /></b> 
                    <html:hidden property="coddir"/>
                    
                  </td>
                </tr>
                <tr> 
                  <td  class="lib" ><b>Libellé :</b></td>
                  <td> 
                    <html:text property="libdir" styleClass="input" size="30" maxlength="30" onchange="return VerifierAlphaMax(this);"/> 
   				 </td>
                </tr>
                <tr> 
                  <td  class="lib" ><b>Code branche :</b></td>
                  <td> 
                  	  <!--html:text property="codbr" styleClass="input" size="2" maxlength="2" onchange="return VerifierNum(this,2,0);"/-->
                  	 <html:select property="codbr" styleClass="input"> 
   						<html:options collection="choixCdeBr" property="cle" labelProperty="libelle" />
						</html:select>	
				  </td>
                </tr>
                <tr> 
                  <td  class="lib"><b>Top Me :</b></td>
                  <td >
                      <logic:iterate id="element" name="choixTopMe">
							<bean:define id="choix" name="element" property="cle"/>
								<html:radio property="topme" value="<%=choix.toString()%>"/>
			 				<bean:write name="element" property="libelle"/>
					  </logic:iterate> 
				  </td>
                </tr>
                <tr> 
                  <td class="lib"><b>Système comptable :</b></td>
                  <td>
                    <html:select property="syscompta" styleClass="input" > 
                		<html:options collection="choixSysCompta" property="cle" labelProperty="libelle" />
					</html:select>
                  </td>
                </tr>
                <tr> 
                  <td class="lib"><b>Code Référentiel :</b></td>
                  <td> 
                  	<html:select property="codref" styleClass="input" > 
                		<html:options collection="choixReferentiel" property="cle" labelProperty="libelle" />
					</html:select>
                		        
                  </td>
                </tr>                
               <tr>                                
                  <td class="lib"><b>Code Périmètre (BU) :</b></td>
                  <td>
                                    <html:select property="codperim" styleClass="input" > 
                		<html:options collection="choixPerimetre" property="cle" labelProperty="libelle" />
					</html:select>
                        
                  </td>
               </tr>
               
               
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
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
</body>
<% 
Integer id_webo_page = new Integer("1001"); 
com.socgen.bip.commun.form.AutomateForm formWebo = majDirectionsForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
