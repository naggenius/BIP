<!DOCTYPE html>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="RecupPIDForm" scope="request" class="com.socgen.bip.form.RecupPIDForm" />
<jsp:useBean id="listeRecherchePID" scope="session"	class="com.socgen.ich.ihm.menu.PaginationVector" />

<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>


 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 

<!-- Page autorisée à tous les utilisateurs -->
<bip:VerifUser page="jsp/eMonProfilAd.jsp"/>

<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";


function MessageInitial()
{
   var Message="<bean:write filter="false"  name="RecupPIDForm"  property="msgErreur" />";
   var Focus = "<bean:write name="RecupPIDForm"  property="focus" />";
   var select = "<bean:write name="RecupPIDForm"  property="typeLigne" />";
   
   // Placer le focus la zone de recherche
   document.forms[0].nomRecherche.focus();
   
   if (Message != "") {
      alert(Message);
   }
  
  if(select == 'TOUTES')
     document.forms[0].typeLigne[1].checked=true;
  else
     document.forms[0].typeLigne[0].checked=true;   
  
}


function ValiderEcran(form)
{

   
	if (form.typeLigne[0].checked)
	{
	   form.typeLigne.value = "OUVERTES";
	}
	if (form.typeLigne[1].checked)
	{
	form.typeLigne.value = "TOUTES";
	}
	
   
    return true;
}

function paginer(page, index , action){
	document.forms[0].action.value =action;
	document.forms[0].page.value=page;
    document.forms[0].index.value=index;
    document.forms[0].submit();
}

function Verifier(form){
    form.action.value="modifier";
    if(form.nomRecherche.value != "")
    {     
       form.nomRecherche.value = form.nomRecherche.value.toUpperCase()
       form.submit();
       return true; 
       
    }else {
 			 alert("Veuillez saisir une lettre au moins !"); 
       return false;	
    }      
}


function Quitter(){
 		window.close();
	}
    



function fill(num) {
	    var cible = "<%=RecupPIDForm.nomChampDestinataire%>";
	   
		window.opener.document.forms[0].elements[cible].value = num;
				
		window.close();
	}


</script>
<!-- #EndEditable --> 
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();" background="../images/bg_page_popup.jpg">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td >&nbsp;</td>
        </tr>
        <tr > 
          <td> 
            &nbsp;</td>
        </tr>
        <tr> 
          <td>
<!--           <div id="outils" align="center">#BeginEditable "barre_haut" -->
<%--               <%ToolBarNew tb = new com.socgen.ich.ihm.ToolBarNew("bip_ihm",false,false,true,true,false,false,false,false,false,request) ;%> --%>
<%-- 				<%=tb.printHtml()%><!-- #EndEditable --> --%>
<!-- 		</div> -->
		</td>
        </tr>
<!--         <tr>  -->
<!--           <td background="../images/ligne.gif"></td> -->
<!--         </tr> -->
        <tr> 
          <td height="20" class="TitrePage"><bean:write name="RecupPIDForm" property="windowTitle" /></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td height="20"></td>
        </tr>
        <tr> 
          <td><html:form action="/recupPID.do">
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
					 <input type="hidden" name="pageAide" value="<%= sPageAide %>">
                     
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<html:hidden property="action" value="modifier"/>
                     <html:hidden property="page" value="modifier"/>
                     <html:hidden name="RecupPIDForm" property="nomChampDestinataire"/>
                     <html:hidden name="RecupPIDForm" property="windowTitle"/>
                     <html:hidden name="RecupPIDForm" property="emptyResult"/> 
                     
                     <input type="hidden" name="index" value="modifier">                                                          
                        <table align="center">					
				                     	  <tr align="left">
				                     		<td class="texte">Libell&eacute; de la ligne BIP :&nbsp;<BR>
				                            (Veuillez saisir une partie du libell&eacute; ligne BIP)</td>
				                     		<td class="texte"><html:text property="nomRecherche" size="20" maxlength="20"/></td>                 		                  		                     
				                     	  </tr>
				                     	  <tr>&nbsp;</tr>
				                     	  <tr align="left">
				                     		<td class="texte"><html:radio property="typeLigne" value="OUVERTES">Lignes ouvertes</html:radio></td>
				                            <td class="texte"><html:radio property="typeLigne" value="TOUTES">Toutes les lignes</html:radio></td>
				                          </tr>                                             	  				                     		
                    	  <% int i =0;
                     	    String[] strTabCols = new String[] {  "fond1" , "fond2" }; 
                     	    %>   
         							</table>
         <table align="center">            	
             
             <% if  	(listeRecherchePID.size() == 99){%>
            <tr align="left"><td colspan="2" class="contenu"><b>Le nombre de ligne bip trouv&eacute;es est sup&eacute;rieur &agrave;100<BR>
            Veuillez saisir un libell&eacute; plus long afin de mieux limiter la recherche</b></td></tr>
            <tr><td >&nbsp;</td></tr>
            <%}%>
            
            
             
<logic:present name="listeRecherchePID">   
<% if  	(listeRecherchePID.size()>0){%>

<tr align="left"><td colspan ="2" class="contenu">Cliquez sur un Code ligne bip pour le s&eacute;lectionner
</td></tr>
<tr align="left">
 <td class="lib" width="30%">Code ligne bip</td>
 <td class="lib" width="30%">Libell&eacute;</td>
</tr>
<logic:iterate id="element"  name="listeRecherchePID"  length="<%=listeRecherchePID.getCountInBlock()%>" 
          offset="<%=listeRecherchePID.getOffset(0)%>"
					type="com.socgen.bip.metier.InfosPID"
					indexId="index"> 
							<% if ( i == 0) i = 1; else i = 0;%>
				   <tr align="left" class="<%= strTabCols[i] %>">
							   <td class="contenu"><b>
							   <bean:write name="element" property="lienHref" filter="false"/>
							   <bean:write name="element" property="pid" />
							   </b></td>
							   <td class="contenu"><bean:write name="element" property="libelle" /></td>						  
				   </tr>
				   
</logic:iterate>       		


					<tr>
						<td align="center" colspan="2" class="contenu">
						<bip:pagination beanName="listeRecherchePID"/>
					</td>
					</tr>						
					
<%}%>				
</logic:present>    


          </table>    

                  
<table  width="100%" border="0" cellspacing="0" cellpadding="0">
			   	<tr>
						<td align="center" colspan="4" class="contenu">
						</td>					
					</tr>
					<tr>
						<td align="center" colspan="4" class="contenu">
						
						</td>
					</tr>
	 			<tr><td colspan="4">&nbsp;
	 			</tr>
	 			<tr>
              		<td width="25%">&nbsp;</td>
                	<td width="25%">
                	 <div align="center">
                	  <html:button property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form);"/>                	                  	  
                	 </div>
               		</td> 
               		<td width="25%"> 
                  	 <div align="center">
                	  <html:button property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Quitter();"/>
              		 </div>
                </td>
                <td width="25%">&nbsp;</td>
            	</tr>
     
				</table>
                    <!-- #EndEditable --></div>
                </td>
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
</html:html>
<!-- #EndTemplate -->
              
       