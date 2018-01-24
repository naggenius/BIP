<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.util.*,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,com.socgen.bip.commun.liste.*"    errorPage="../jsp/erreur.jsp"  %>
<html:html locale="true">
<!-- #EndEditable -->  <!-- #BeginTemplate "/Templates/Page_maj.dwt" --><head>
<jsp:useBean id="fournisseurForm" scope="request" class="com.socgen.bip.form.FournisseurForm" />


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>


<!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!-- #BeginEditable "fichier" -->
 <bip:VerifUser page="jsp/bSocieteAd.jsp"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));

	ArrayList listeType = new ArrayList();
	listeType.add(0,new ListeOption("O", "Oui"));
	listeType.add(1,new ListeOption("N", "Non"));
	pageContext.setAttribute("choixActif", listeType);
%>
var pageAide = "<%= sPageAide %>";


function MessageInitial()
{
  var Message="<bean:write filter="false"  name="fournisseurForm"  property="msgErreur" />";
   var Focus = "<bean:write name="fournisseurForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if ( document.forms[0].action.value == 'creer')
      document.forms[0].socfour.value = '9999999999';

   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else if (document.forms[0].mode.value!='delete'){
	  document.forms[0].socfour.focus();
   }
}

function Verifier(form, action, mode, flag)
{
   blnVerification =flag;
   form.action.value =action;

} 
function ValiderEcran(form)
{
  if (blnVerification == true) {
  	 if (!ChampObligatoire(form.socfour, "le code fournisseur")) return false;
     if (!ChampObligatoire(form.socflib, "le libelle fournisseur")) return false;
     if (!ChampObligatoire(form.fsiren, "le SIREN")) return false;
     if (!ChampObligatoire(form.frib1, "le code banque du RIB")) return false;
     if (!ChampObligatoire(form.frib2, "le code guichet du RIB")) return false;
     if (!ChampObligatoire(form.frib3, "le num de compte du RIB")) return false;
     if (!ChampObligatoire(form.frib4, "la clef du RIB")) return false;

  	
      if (form.mode.value == 'update' || form.mode.value == 'insert') {
        	//alert(' rib1: ' + document.forms[0].frib1.value + ' rib2: ' + document.forms[0].frib2.value + ' rib3: ' + document.forms[0].frib3.value + ' rib4: ' + document.forms[0].frib4.value );
 			document.forms[0].frib.value = document.forms[0].frib1.value + document.forms[0].frib2.value + document.forms[0].frib3.value + document.forms[0].frib4.value;
       		//alert(' RIB: ' + document.forms[0].frib.value);
       	}
      if (form.mode.value == 'update') {
        	if (!confirm("Voulez-vous modifier ce fournisseur ?")) return false;
       	}
      	if (form.mode.value == 'delete') {
        	if (!confirm("Voulez-vous supprimer ce fournisseur ?")) return false;
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" --><bean:write name="fournisseurForm" property="titrePage"/> un fournisseur <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td>
		  <!-- #BeginEditable "debut_form" --> <html:form action="/fournisseur"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable -->
		  <div align="center"><!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>">
		    <html:hidden property="action"/>
		    <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
		    <html:hidden property="keyList0"/>
		    <html:hidden property="flaglock"/>
			  <table cellspacing="2" cellpadding="2" class="tableBleu" width="400"  >
                <tr> 
                  <td  colspan=2>&nbsp;</td>
                </tr>
                <tr> 
                  <td   >&nbsp;</td>
                  <td >&nbsp;</td>
                </tr>
                <tr> 
                  <td   class="lib"><b>Code société :</b> </td>
                  <td ><bean:write name="fournisseurForm"  property="soccode" />
                    <html:hidden property="soccode"/>
                    
                  </td>
                </tr>
                <tr> 
                  <td  class="lib"><b>Code fournisseur :</b> </td>
                  <td  > 
                   <logic:notEqual parameter="action" value="supprimer">
                  		<html:text property="socfour" styleClass="input" size="14" maxlength="10" onchange="return VerifierAlphaMax(this);"/>
                   </logic:notEqual>
                   <logic:equal parameter="action" value="supprimer">
                  		<bean:write name="fournisseurForm"  property="socfour" />
                  		<html:hidden property="socfour"/>
                   </logic:equal>
                   <logic:equal parameter="action" value="modifier">	
                  		<input type="hidden" name="socfour_sav" value="<bean:write name="fournisseurForm"  property="socfour" />">  
                   </logic:equal>
                  </td>
                </tr>
                <tr> 
                  <td  class="lib"><b>Libellé fournisseur :</b> </td>
                  <td >
                    <logic:notEqual parameter="action" value="supprimer"> 
                    	<html:text property="socflib" styleClass="input" size="27" maxlength="25" onchange="return VerifierAlphanum(this);"/>
                     </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                  		<bean:write name="fournisseurForm"  property="socflib" />
                  		<html:hidden property="socflib"/>
                    </logic:equal>
                  </td>
                </tr>
                <tr> 
                  <td  class="lib"><b>Siren :</b> </td>
                  <td >
                    <logic:notEqual parameter="action" value="supprimer"> 
                    	<html:text property="fsiren" styleClass="input" size="10" maxlength="9" />
                     </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                  		<bean:write name="fournisseurForm"  property="fsiren" />
                  		<html:hidden property="fsiren"/>
                    </logic:equal>
                  </td>
                </tr>
                <tr>
                  <td  class="lib"><b>RIB :</b></td>
                  <td >
                    <logic:notEqual parameter="action" value="supprimer"> 
                    	<html:text property="frib1" styleClass="input" size="5" maxlength="5"/>
	                	<html:text property="frib2" styleClass="input" size="5" maxlength="5"/>
						<html:text property="frib3" styleClass="input" size="11" maxlength="11"/>
                    	<html:text property="frib4" styleClass="input" size="2" maxlength="2"/>
                    	<html:hidden property="frib"/>
                 	</logic:notEqual>
                     <!--<logic:equal parameter="action" value="creer">
                  		<html:hidden property="frib1"/>
                    	<html:hidden property="frib2"/>
               	        <html:hidden property="frib3"/>
               	        <html:hidden property="frib4"/>
                    </logic:equal>-->
                  
                    
                    <logic:equal parameter="action" value="supprimer">
                  		<bean:write name="fournisseurForm"  property="frib" />
                  		<html:hidden property="frib"/>
                    </logic:equal>
                  </td>
                </tr>
                <tr>
                  <td  class="lib"><b>Actif :</b> </td>
                  <td >
                    <logic:notEqual parameter="action" value="supprimer">
                  		   <html:select property="factif" styleClass="input" > 
								<bip:options collection="choixActif" />
                           </html:select>
                     </logic:notEqual>
                     <logic:equal parameter="action" value="supprimer">
                  		<bean:write name="fournisseurForm"  property="factif" />
                  		<html:hidden property="factif"/>                    
                    </logic:equal>
                  </td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> </tr>
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
				  	<div align="center">
                	 <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', this.form.mode.value,true);"/>
                  	</div>
				  </td>
				  <td width="25%">  
				  	<div align="center"> 
                	 <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', null, false);"/>
                  		</div>
				  </td>
				  <td width="25%">&nbsp;</td>
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
<% 
Integer id_webo_page = new Integer("1004"); 
com.socgen.bip.commun.form.AutomateForm formWebo = fournisseurForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html> 

<!-- #EndTemplate -->