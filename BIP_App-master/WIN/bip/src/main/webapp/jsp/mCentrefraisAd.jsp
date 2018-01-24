<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,com.socgen.bip.commun.liste.ListeGlobale"    errorPage="../jsp/erreur.jsp"  %>
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
	
	ListeGlobale listeGlobale = new ListeGlobale();
    
    
	try{
	
	    java.util.ArrayList list1 = listeGlobale.getListeGlobale("filiale");
        pageContext.setAttribute("choixFiliale", list1);
    
	} catch (Exception e) {
        pageContext.setAttribute("choixCf", new java.util.ArrayList());
        %>alert("<%= listeGlobale.getErrorBaseMsg() %>");<%
   }
	
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
   else if (document.forms[0].mode.value!='delete'){
	  document.forms[0].libcfrais.focus();
   }
}

function Verifier(form, action, mode, flag)
{
   blnVerification = flag;
   if (action=="valider") {
     form.mode.value = mode;   
   }

   form.action.value = action;
} 
function ValiderEcran(form)
{
   
    var index = form.filcode.selectedIndex;

   if (blnVerification==true) {
      if ( index==-1 ) {
	   alert("Choisissez une filiale");
	   return false;
	 }

   }
   
   if (blnVerification) {
         if ( index==-1 ) {
	        alert("Choisissez une filiale");
	        return false;
	     }
         if ((form.action.value!="valider")&&(form.action.value!="annuler"))
  		form.action.value ="valider";
  
		if (form.libcfrais && !ChampObligatoire(form.libcfrais, "le libellé")) return false;
	
	 	if (form.mode.value == 'update') {
        	if (!confirm("Voulez-vous modifier ce centre de frais  ?")) return false;
     	}
      	if (form.mode.value == 'delete') {
        	if (!confirm("Voulez-vous supprimer ce centre de frais ?")) return false;
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
          <bean:write name="centrefraisForm" property="titrePage"/> un centre de frais
            <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/centrefrais" onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>">
              	<html:hidden property="action"/>
              	<html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
      
              <table cellspacing="2" cellpadding="2" class="tableBleu" >
                <tr> 
                  <td colspan=2 >&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan=2>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="lib">Centre de frais :</td>
                  <td> 
                  	<b><bean:write name="centrefraisForm"  property="codcfrais" /></b>
                    <html:hidden property="codcfrais"/>
                    
                  </td>
                </tr>
               
                
              <logic:equal parameter="mode" value="delete"> 
                <tr> 
                  <td class="lib" >Libell&eacute; :</td>
                  <td> 
                  	<b><bean:write name="centrefraisForm"  property="libcfrais" /></b>
  				    <html:hidden property="libcfrais"/>
                  </td>
                </tr>    
                <tr>
                  <td class="lib" >Filiale :</td>
                  <td> 
                  	<b><bean:write name="centrefraisForm"  property="filcode" /> - <bean:write name="centrefraisForm"  property="filsigle" /></b>
  				    <html:hidden property="filcode"/>
  				    <html:hidden property="filsigle"/>
                  </td> 
                </tr>
              </logic:equal>
                
                
             <logic:notEqual parameter="mode" value="delete"> 
                <tr> 
                  <td class="lib" >Libell&eacute; :</td>
                  <td><b> 
                  	<html:text property="libcfrais" styleClass="input" size="33" maxlength="30" onchange="return VerifierAlphanum(this);"/>
                  </b></td>
                </tr>    
                <tr>
                  <td class="lib" >Filiale :</td>
                  <td><b> 
                    	<html:select property="filcode" styleClass="input" > 
                		<html:options collection="choixFiliale" property="cle" labelProperty="libelle" />
						</html:select>
				  </b></td>
                </tr>
              </logic:notEqual>
                
                
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
Integer id_webo_page = new Integer("1016"); 
com.socgen.bip.commun.form.AutomateForm formWebo = centrefraisForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
