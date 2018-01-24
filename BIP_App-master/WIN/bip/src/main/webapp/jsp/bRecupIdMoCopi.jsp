<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="RecupIdMoForm" scope="request" class="com.socgen.bip.form.RecupIdMoForm" />
<jsp:useBean id="listeRechercheIdMo" scope="session"	class="com.socgen.ich.ihm.menu.PaginationVector" />

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
   var Message="<bean:write filter="false"  name="RecupIdMoForm"  property="msgErreur" />";
   var Focus = "<bean:write name="RecupIdMoForm"  property="focus" />";
   
   // Placer le focus la zone de recherche
   document.forms[0].nomRecherche.focus();
   
   if (Message != "") {
      alert(Message);
   }
  if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else if (document.forms[0].bpmontme_1){
	  document.forms[0].bpmontme_1.focus();
   }
}


function ValiderEcran(form)
{
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
	    var cible = "<%=RecupIdMoForm.nomChampDestinataire%>";
	    var action = "<%=RecupIdMoForm.rafraichir%>";
	    
	    
		window.opener.document.forms[0].elements[cible].value = num;
		
		
		
		if(action == 'OUI')
		{
			window.opener.document.forms[0].focus.value = cible;
		   	rafraichir(window.opener.document.forms[0]);
		}
		window.close();
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
          <td height="20" class="TitrePage"><bean:write name="RecupIdMoForm" property="windowTitle" /></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td></td>
        </tr>
        <BR>
        <tr> 
          <td><html:form action="/recupIdMoCopi.do">
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
					 <input type="hidden" name="pageAide" value="<%= sPageAide %>">
                     
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<html:hidden property="action" value="modifier"/>
                     <html:hidden property="page" value="modifier"/>
                     <html:hidden name="RecupIdMoForm" property="nomChampDestinataire"/>
                     <html:hidden name="RecupIdMoForm" property="rafraichir"/>
                     <html:hidden name="RecupIdMoForm" property="windowTitle"/>
                     <html:hidden name="RecupIdMoForm" property="habilitationPage"/>  
                     <html:hidden name="RecupIdMoForm" property="emptyResult"/> 
                     
                     <input type="hidden" name="index" value="modifier">                                                          
                        <table align="center">					
				                     	  <tr>
				                     		<td class="lib">Libell&eacute; du client :&nbsp;<BR>
				                            (Veuillez saisir les premi&egrave;res lettres du libell&eacute; client)</td>
				                     		<td><html:text property="nomRecherche" size="20" maxlength="20"/></td>                 		                  		                     
				                     		</tr>                                            	  				                     		
                    	  <% int i =0;
                     	    String[] strTabCols = new String[] {  "fond1" , "fond2" }; 
                     	    %>   
         							</table>
         <table>            	
             
             <% if  	(listeRechercheIdMo.size() == 99){%>
            <tr><td colspan="3" class="contenu"><B>Le nombre de Code Client trouv&eacute;es est sup&eacute;rieur &agrave;100<BR>
            Veuillez saisir un libell&eacute; plus long afin de mieux limiter la recherche</B></td></tr>
            <tr><td >&nbsp;</td></tr>
            <%}%>
            
            
             
<logic:present name="listeRechercheIdMo">   
<% if  	(listeRechercheIdMo.size()>0){%>

<tr><td colspan ="4" class="contenu">Cliquez sur un Code client pour le s&eacute;lectionner</td></tr>
<BR>
 <tr>
 <td class="lib" width="30%">Code client</td>
 <td class="lib"width="30%">Sigle</td>
 <td class="lib"width="30%">Libell&eacute;</td>
</tr>
<logic:iterate id="element"  name="listeRechercheIdMo"  length="<%=listeRechercheIdMo.getCountInBlock()%>" 
          offset="<%=listeRechercheIdMo.getOffset(0)%>"
					type="com.socgen.bip.metier.InfosMo"
					indexId="index"> 
							<% if ( i == 0) i = 1; else i = 0;%>
				   <tr class="<%= strTabCols[i] %>">
							   <td class="contenu">
							   <bean:write name="element" property="lienHref" filter="false"/>
							   <bean:write name="element" property="id" />
							   </a></td>
							   <td class="contenu"><bean:write name="element" property="sigle" /></td>
							   <td class="contenu"><bean:write name="element" property="libelle" /></td>						  
				   </tr>
				   
</logic:iterate>       		


					<tr>
						<td align="center" colspan="4" class="contenu">
						<bip:pagination beanName="listeRechercheIdMo"/>
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
              
       