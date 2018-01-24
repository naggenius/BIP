<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,java.util.Hashtable"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="ressReesForm" scope="request" class="com.socgen.bip.form.RessReesForm" />

<html:html locale="true"> 
 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 
<title>Outil de r&eacute;estim&eacute;</title>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<bip:VerifUser page="jsp/bRessourceRe.jsp"/>
<%
  java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("ressgroupe",ressReesForm.getHParams()); 
  pageContext.setAttribute("choixRess", list1);
  
  java.util.ArrayList list2 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("ressfict",ressReesForm.getHParams()); 
  pageContext.setAttribute("choixRessFict", list2);
   
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

var blnVerifFormat  = true;
var tabVerif        = new Object();
function MessageInitial()
{
   tabVerif["datdep"] = "VerifierDate2(document.forms[0].datdep,'jjmmaaaa')";
   tabVerif["datarrivee"] = "VerifierDate2(document.forms[0].datarrivee,'jjmmaaaa')";

   var Message="<bean:write filter="false"  name="ressReesForm"  property="msgErreur" />";
   var Focus = "<bean:write name="ressReesForm"  property="focus" />";
   if (Message != "") 
   {
      alert(Message);
   }
   if (Focus != "")
   {
   		(eval( "document.forms[0]."+Focus )).focus();
   }

}

function Verifier(form, action, mode, flag)
{
   blnVerification = flag;
   form.action.value = action;
}





function ValiderEcran(form) {
  
      if (blnVerification == true) {

      if (form.mode.value== "update") {
		 if ( !VerifFormat(null) ) return false;
		 retComp = compareDate(form.datarrivee, form.datdep);
		 if (retComp < 1) {
		 	 alert("La date de départ doit être supérieure à la date d'arrivée.");
		 	 return false;
		 }
		 if (retComp == 999 ) {
		 	 alert("Problème lors de la comparaison de la date de départ et la date d'arrivée. Contactez le responsable de l'application.");
		 	 return false;
		 }
		 	 
         if (!confirm("Voulez-vous modifier cette ressource ?")) return false;
       }
       
      if (form.mode.value== "delete") {
         if (!confirm("Voulez-vous supprimer cette ressource ?")) return false;
      }
      if (form.mode.value== "insert") {
		 if ( !VerifFormat(null) ) return false;
		 retComp = compareDate(form.datarrivee, form.datdep);
		 if (retComp < 1) {
		 	 alert("La date de départ doit être supérieure à la date d'arrivée.");
		 	 return false;
		 }
		 if (retComp == 999 ) {
		 	 alert("Problème lors de la comparaison de la date de départ et la date d'arrivée. Contactez le responsable de l'application.");
		 	 return false;
		 }
         if (!ChampObligatoire(form.rnom, "un nom")) return false;     	
      }
     }

   return true;
}




function chargerListe(choix) {
	if (choix=="f") {
	document.forms[0].type.value = "X";
	
	rafraichir(document.forms[0]);
	return true;
}
}

function ChangeIdentG()
{
	   document.forms[0].choix[0].checked=true;
	   rafraichir(document.forms[0]);
	   return true;
}

function ChangeIdentH()
{
		 document.forms[0].choix[1].checked=true;	   
	   document.forms[0].action.value="refresh";	   
     document.forms[0].submit();
}

function ChangeFict(form)
{
	if (form.ident_fict.value != -1) {
	if (!confirm("Voulez-vous remplacer cette ressource fictive dans tous les scenarii ?")) return false;
	}
	form.action.value = 'valider';
	form.mode.value = 'update';
	form.submit();
}


function rechercheID(){
	window.open("/recupIdPersonne.do?action=initialiser&nomChampDestinataire=ident_hors&windowTitle=Recherche Identifiant Personne&habilitationPage=HabilitationRestime"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
}  


function nextFocusLoupePersonne(){
document.forms[0].boutonValider.focus();
}


</script>
 
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
          <td height="20" class="TitrePage">
           <bean:write name="ressReesForm" property="titrePage"/> une ressource</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> 
          	<html:form action="/ressRees"  onsubmit="return ValiderEcran(document.forms[0]);"> 
            <div align="center">
			<input type="hidden" name="pageAide" value="<%= sPageAide %>">
            <html:hidden property="action"/>
		    <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
		    <html:hidden property="type"/>
		    <table cellspacing="2" cellpadding="2" class="tableBleu">
                <tr> 
                  <td>&nbsp;</td>
                </tr>
                <tr>
                	<td></td> 
                  <td class="lib" ><b>Code D&eacute;partement/P&ocirc;le/Groupe : </b></td>
                  <td colspan="4">
                    <b><bean:write name="ressReesForm" property="codsg"/></b> 
                    <html:hidden property="codsg"/>
                 
                  </td>
                </tr>
                <tr> 
                  <td >&nbsp;</td>
                </tr>
                <logic:notEqual parameter="action" value="creer">
                	<logic:equal parameter="action" value="refresh">
						<logic:equal parameter="type" value="X">
                		<tr></tr>
						  <html:hidden property="choix" value="f"/>
						</logic:equal>
					</logic:equal>
					<logic:equal parameter="action" value="refresh">
						<logic:notEqual parameter="type" value="X">
                		<tr> 
                  		<td></td>
                  		<td class="lib" ><b>Identifiant de la ressource : </b></td>
                  		<td colspan="4" >
                       	<bean:write name="ressReesForm"  property="code_ress"/>
                    	<html:hidden property="code_ress"/>
                  		</td>
                 		</tr>
						</logic:notEqual>
					</logic:equal>
                 <logic:notEqual parameter="action" value="refresh">  	
                <tr> 
                  <td></td>
                  <td class="lib" ><b>Identifiant de la ressource : </b></td>
                  <td colspan="4" >
                    
                    	<bean:write name="ressReesForm"  property="code_ress"/>
                    	<html:hidden property="code_ress"/>
                  </td>
                 </tr>
                 </logic:notEqual>
                 </logic:notEqual>
                 
                 <logic:equal parameter="action" value="creer">
                 
               <tr> 
                  <td><input type=radio name="choix" value="g" onClick="chargerListe('g');"></td>
                  <td class="lib" ><b>Ressource du groupe : </b></td>
                  <td colspan="4" >
                   		<html:select property="code_ress" size="1" styleClass="input" onchange="return ChangeIdentG();">
							<html:options collection="choixRess" property="cle" labelProperty="libelle" />
                		</html:select>
                   </td>
                </tr>
                <tr> 
                  <td><input type=radio name="choix" value="h" onClick="chargerListe('h');"></td>
                  <td class="lib" ><b>Autre ressource : </b></td>
                  <td colspan="3" >
                   	<html:text property="ident_hors" styleClass="input" size="5" maxlength="5" />                   	 
                  </td>
                  <td><a href="javascript:rechercheID();" onFocus="javascript:nextFocusLoupePersonne();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Identifiant" title="Rechercher Identifiant"></a></td>
                </tr>
                <tr> 
                  <td><input type=radio name="choix" value="f" onClick="chargerListe('f');"></td>
                  <td class="lib" ><b>Ressource fictive : </b></td>
                  <td colspan="4" >

                  </td>
                </tr>

               
                <tr> 
                  <td >&nbsp;</td>
                </tr>
                </logic:equal>
    
	            
                <tr>
                	<td></td> 
                  <logic:notEqual parameter="action" value="creer">
                  	<td class="lib" ><b>Nom : </b></td>
                  	
                  		
                  <td colspan="4" >
                  	<%	if(!"X".equals(ressReesForm.getType()) ){
					%> 		
                    	<b><bean:write name="ressReesForm"  property="rnom"/><b>
                    	<html:hidden property="rnom"/>
                    <%}%>
                  	<%	if("X".equals(ressReesForm.getType()) ){
					%>
                  		<logic:equal parameter="action" value="supprimer">
	                   		<bean:write name="ressReesForm"  property="rnom"/>
    	                	<html:hidden property="rnom"/>
                   		</logic:equal>
        	           	<logic:notEqual parameter="action" value="supprimer">
            	       		<html:text property="rnom" styleClass="input" size="30" maxlength="30" onchange="return VerifierAlphanum(this);"/>
                   		</logic:notEqual>
                    
                    <%}%>
                  </td>
                </tr>
                <tr> 
                	<td></td>
                  <td class="lib" ><b>Prénom : </b></td>
                  <td colspan="4" >
                    <%	if(!"X".equals(ressReesForm.getType()) ){
					%> 		
                    	<b><bean:write name="ressReesForm"  property="rprenom"/><b>
                    	<html:hidden property="rprenom"/>
                    <%}%>
                  	<%	if("X".equals(ressReesForm.getType()) ){
					%>
                  		<logic:equal parameter="action" value="supprimer">
	                   		<bean:write name="ressReesForm"  property="rprenom"/>
    	                	<html:hidden property="rprenom"/>
                   		</logic:equal>
        	           	<logic:notEqual parameter="action" value="supprimer">
            	       		<html:text property="rprenom" styleClass="input" size="30" maxlength="30" onchange="return VerifierAlphanum(this);"/>
                   		</logic:notEqual>
                    
                    <%}%>
                  </td>
                </tr>
                <tr> 
                	<td></td>
                  <td class="lib" ><b>Date d'arriv&eacute;e : </b></td>
                  <td colspan="4" >
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="ressReesForm"  property="datarrivee"/>
                    	<html:hidden property="datarrivee"/>
                    </logic:equal>
                  	<logic:notEqual parameter="action" value="supprimer">
                   		<html:text property="datarrivee" styleClass="input" size="12" maxlength="12"/>
                    </logic:notEqual>
                  </td>
                </tr>
                <tr> 
                	<td></td>
                  <td class="lib" ><b>Date de départ : </b></td>
                  <td colspan="4" >
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="ressReesForm"  property="datdep"/>
                    	<html:hidden property="datdep"/>
                    </logic:equal>
                  	<logic:notEqual parameter="action" value="supprimer">
                   		<html:text property="datdep" styleClass="input" size="12" maxlength="12"/>
                    </logic:notEqual>
                  </td>
                </tr>
             </logic:notEqual>
                
                	<logic:equal parameter="action" value="modifier">
                		<%	if(!"X".equals(ressReesForm.getType()) ){
						%>
                <tr> 
                  <td></td>	
                  <td class="lib" ><b>Ressource fictive à remplacer : </b></td>
                  <td colspan="4" >
                   		<html:select property="ident_fict" size="1" styleClass="input" onchange="return ChangeFict(document.forms[0]);">
							<html:options collection="choixRessFict" property="cle" labelProperty="libelle" />
                		</html:select>
                   </td>
                </tr>
                <%}%>
                   </logic:equal>
                
                <tr> 
                  <td >&nbsp;</td>
                </tr>
                <tr> 
                  <td >&nbsp;</td>
                </tr>
              </table>
             </div>
          </td>
        </tr>
        <tr> 
          <td align="center"> 
            <table width="100%" border="0">
              <tr> 
                <td width="25%">&nbsp;</td>
                
				<logic:notEqual parameter="action" value="creer">
                <td width="25%"> 
                  <div align="center"> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(document.forms[0], 'valider', document.forms[0].mode.value,true);"/> 
                  </div>
                </td>
        </logic:notEqual>	
        
        <logic:equal parameter="action" value="creer">
                <td width="25%"> 
                  <div align="center"> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="ChangeIdentH();"/> 
                  </div>
                </td>
        </logic:equal>	
        
                
                <td width="25%"> 
                  <div align="center"> <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'suite', null, false);"/> 
                  </div>
                </td>
                <td width="25%">&nbsp;</td>
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
</body>
<% 
Integer id_webo_page = new Integer("4003"); 
com.socgen.bip.commun.form.AutomateForm formWebo = ressReesForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>