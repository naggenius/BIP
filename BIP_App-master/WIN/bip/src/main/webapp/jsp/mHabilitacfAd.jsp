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
<%
  if (!centrefraisForm.getHabilitation().equals("tout")) {
	  java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("dpgcfrais",centrefraisForm.getHParams()); 
	  pageContext.setAttribute("choixBddpg", list1);
  }
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
    var Message="<bean:write filter="false"  name="centrefraisForm"  property="msgErreur" />";
 	var Focus = "<bean:write name="centrefraisForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
    else {
       if(document.forms[0].habilitation.value=="tout" ) {
	    	document.forms[0].bddpg.focus();
	   }
    }
  
}

function Verifier(form, action, mode, flag)
{
   blnVerification = flag;
   form.action.value = action;
}

function ValiderEcran(form)
{
  var index = form.bddpg.selectedIndex;
	
  if (blnVerification==true) {

   	if  (form.habilitation!="tout" && index==-1)   {
		switch (form.habilitation.value) {
 		case 'br':	alert("Choisissez une branche");
	   			return false;
				break;

		case 'dir':	alert("Choisissez une direction");
	   			return false;
			  	break;
		case 'dpt':	alert("Choisissez un département");
	   			return false;
			  	break;
		case 'pole':	alert("Choisissez un pôle");
	   			return false;
			  	break;
   		}
	}
	else {


		 if (!ChampObligatoire(form.bddpg, "le code DPG")) return false;
		 if ((form.habilitation.value=="tout")&&(form.bddpg.value.length==6)){
		 	
		     form.bddpg.value = "0"+form.bddpg.value;
			
		}
		
	}
	 form.mode.value="bddpg";
  }
  else {
        //pour rediriger vers la bonne page lors de l'annulation
        	form.mode.value="ecran";

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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Habilitation 
            <!-- #EndEditable --></td>
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
				<html:hidden property="habilitation"/> 
              <table cellspacing="2" cellpadding="2" class="tableBleu" >
                <tr> 
                  <td colspan=2 >&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan=2>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="lib" height="26">Centre de frais :</td>
                  <td height="26"><b><bean:write name="centrefraisForm"  property="codcfrais" />
                    		<html:hidden property="codcfrais"/></b>
                  </td>
                </tr>
                <tr> 
                  <td class="lib" >Libell&eacute; :</td>
                  <td ><b><bean:write name="centrefraisForm"  property="libcfrais" />
                    	<html:hidden property="libcfrais"/></b>
                  </td>
                 </tr>
                 <tr>
                  <td class="lib" >Filiale :</td>
                  <td> 
                  	<b><bean:write name="centrefraisForm"  property="filcode" /> - <bean:write name="centrefraisForm"  property="filsigle" /></b>
  				    <html:hidden property="filcode"/>
  				    <html:hidden property="filsigle"/>
                 </td>
                <tr>
                 <tr> 
                  <td colspan=2>&nbsp;</td>
                </tr>
                 <logic:notEqual parameter="habilitation" value="tout">   
	                <tr>
	                  <td colspan=2 align="center"><b><u>Liste des <bean:write name="centrefraisForm" property="titrePage"/>: </u></b></td>
	                </tr>
	                <tr> 
	                  <td colspan=2 align="center"> 
	                   		<html:select property="bddpg"  size="5" styleClass="input"> 
	   						<html:options collection="choixBddpg" property="cle" labelProperty="libelle" />
							</html:select>
	                  </td>
	                </tr>
                 </logic:notEqual>
                 <logic:equal parameter="habilitation" value="tout">
	                <tr> 
	                  <td align="center" class="lib"><b>Code DPG : </b> </td>
	                  <td> 
	                     <html:text property="bddpg" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,7,0);"/>
	                  </td>
	                </tr>
                 </logic:equal> 
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
</body>
<% 
Integer id_webo_page = new Integer("1017"); 
com.socgen.bip.commun.form.AutomateForm formWebo = centrefraisForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
