<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,java.util.Hashtable,java.util.ArrayList,javax.servlet.http.*,com.socgen.ich.ihm.*,com.socgen.bip.commun.liste.*"    errorPage="../jsp/erreur.jsp"  %>
<html:html locale="true">
<!-- #EndEditable -->  <!-- #BeginTemplate "/Templates/Page_maj.dwt" --><head>
<jsp:useBean id="fournisseurEbisForm" scope="request" class="com.socgen.bip.form.FournisseurEbisForm" />
<jsp:useBean id="listeDynamique" scope="request" class="com.socgen.bip.commun.liste.ListeDynamique" />



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
  var Message="<bean:write filter="false"  name="fournisseurEbisForm"  property="msgErreur" />";
   var Focus = "<bean:write name="fournisseurEbisForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
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
 	 if (!ChampObligatoire(form.fsiren, "le siren")) return false;  
  	 if (!ChampObligatoire(form.perimetre, "le code périmètre")) return false;
     if (!ChampObligatoire(form.referentiel, "le code référentiel")) return false;
     if (!ChampObligatoire(form.fournebis, "le code fournisseur Expense Bis")) return false;
     if ( form.fournebis.value.length!=10 ) 
     		{
     		alert('Le code fournisseur Expense Bis doit être sur 10 chiffres')
     		return false;
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" --><bean:write name="fournisseurEbisForm" property="titrePage"/> un fournisseur Expense<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td>
		  <!-- #BeginEditable "debut_form" --> <html:form action="/fournisseurebis"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable -->
		  <div align="center"><!-- #BeginEditable "contenu" -->
            <input type="hidden" name="pageAide" value="<%= sPageAide %>">
		    <html:hidden property="action"/>
		    <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
		    <html:hidden property="keyList0"/>
		    <html:hidden property="flaglock"/>

            <html:hidden property="fsiren_sav"/>
            <html:hidden property="perimetre_sav"/>
            <html:hidden property="referentiel_sav"/>
            <html:hidden property="fournebis_sav"/>       
                  
			  <table cellspacing="2" cellpadding="2" class="tableBleu" width="400"  >
                <tr> 
                  <td  colspan=2>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td   class="lib"><b>Code société :</b> </td>
                  <td ><bean:write name="fournisseurEbisForm"  property="soccode" />
                    <html:hidden property="soccode"/>
                  </td>
                <tr> 
                  <td  class="lib"><b>Siren :</b> </td>
                  <td >
                  
                    <logic:notEqual parameter="action" value="supprimer"> 
                        
                        
                    
                    	<!-- <html:text property="fsiren" styleClass="input" size="10" maxlength="9" /> -->
                    	
                    	<%
				                Hashtable hKeyList= new Hashtable();
				                try { 
				                	hKeyList.put("soccode", ""+fournisseurEbisForm.getSoccode());
				                	java.util.ArrayList listeActivite = listeDynamique.getListeDynamique("siren_expense", hKeyList);
				                	request.setAttribute("listeSiren", listeActivite);
				                	} catch (Exception e) {
				                		 %>alert("<%= listeDynamique.getErrorBaseMsg()%>");<%
				                         request.setAttribute("listeSiren", new ArrayList());
				                      
				                     }                	
                 		%>
                 			
                    	<html:select property="fsiren" styleClass="input" size="1"> 
                    		<html:options collection="listeSiren" property="cle" labelProperty="libelle" />                     		
                      	</html:select>  
                    	   
                     </logic:notEqual>
                     
                    <logic:equal parameter="action" value="supprimer">
                  		<bean:write name="fournisseurEbisForm"  property="fsiren" />
                  		<html:hidden property="fsiren"/>
                    </logic:equal>
                  </td>
                </tr>
                
                <tr> 
                  <td  class="lib"><b>Code Périmètre :</b> </td>
                  <td  > 
                   <logic:notEqual parameter="action" value="supprimer">
                  		<html:text property="perimetre" styleClass="input" size="6" maxlength="5" onchange="return VerifierAlphaMax(this);"/>
                   </logic:notEqual>
                   <logic:equal parameter="action" value="supprimer">
                  		<bean:write name="fournisseurEbisForm"  property="perimetre" />
                  		<html:hidden property="perimetre"/>
                   </logic:equal>                 
                  </td>
                </tr>
                <tr> 
                  <td  class="lib"><b>Code Référentiel :</b> </td>
                  <td  > 
                   <logic:notEqual parameter="action" value="supprimer">
                  		<html:text property="referentiel" styleClass="input" size="6" maxlength="5" onchange="return VerifierAlphaMax(this);"/>
                   </logic:notEqual>
                   <logic:equal parameter="action" value="supprimer">
                  		<bean:write name="fournisseurEbisForm"  property="referentiel" />
                  		<html:hidden property="referentiel"/>
                   </logic:equal>
                   
                  </td>
                </tr>
                <tr> 
                  <td  class="lib"><b>Code fournisseur Expense :</b> </td>
                  <td >
                    <logic:notEqual parameter="action" value="supprimer"> 
                    	<html:text property="fournebis" styleClass="input" size="11" maxlength="10" onchange="return VerifierAlphanum(this);"/>
                     </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                  		<bean:write name="fournisseurEbisForm"  property="fournebis" />
                  		<html:hidden property="fournebis"/>
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
com.socgen.bip.commun.form.AutomateForm formWebo = fournisseurEbisForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html> 

<!-- #EndTemplate -->