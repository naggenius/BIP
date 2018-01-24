<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="RecupFactureForm" scope="request" class="com.socgen.bip.form.RecupFactureForm" />
<jsp:useBean id="listeRechercheFacture" scope="session"	class="com.socgen.ich.ihm.menu.PaginationVector" />

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
	String sWindowTitle = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("windowTitle")));
	String sTypeFacture = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("typeFacture")));
	String sType;
	String sLib="";
	
	
	
	if((sTypeFacture==null)||(sTypeFacture.equals("null")))
		 sType="facture";
	else if (sTypeFacture.equals("F"))
	{
	     sType="Facture";
	     sLib="Toutes les Factures";
	}
	else 
	{    
	    sType="Avoir";
	    sLib="Tous les avoirs";
	}
	      	 
	   
	
	
	
	String sSocfact = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("socfact")));
	String sNomChampDestinataire = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("nomChampDestinataire")));
	String sNomChampDestinataire2 = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("nomChampDestinataire2")));
%>
var pageAide = "<%= sPageAide %>";


function MessageInitial()
{
   var Message="<bean:write filter="false"  name="RecupFactureForm"  property="msgErreur" />";
   var Focus = "<bean:write name="RecupFactureForm"  property="focus" />";
   var select = "<bean:write name="RecupFactureForm"  property="factureEncours" />";
   
   // Placer le focus la zone de recherche
   document.forms[0].nomRessource.focus();
   
   if (Message != "") {
      alert(Message);
   }
  
  if(select == 'NON')
     document.forms[0].factureEncours[1].checked=true;
  else
     document.forms[0].factureEncours[0].checked=true;   
  
}


function ValiderEcran(form)
{

   
	if (form.factureEncours[0].checked)
	{
	   form.factureEncours.value = "OUI";
	}
	if (form.factureEncours[1].checked)
	{
	form.factureEncours.value = "NON";
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
    
    form.nomRessource.value = form.nomRessource.value.toUpperCase()
       form.submit();
        return true; 
    
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
    



function fill(num, num2) {
	    var cible = "<%=RecupFactureForm.nomChampDestinataire%>";
	    var cible2 = "<%=RecupFactureForm.nomChampDestinataire2%>";
	   
		window.opener.document.forms[0].elements[cible].value = num;
		window.opener.document.forms[0].elements[cible2].value = num2;
				
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
          <td height="20" class="TitrePage">Recherche <%= sType %></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td></td>
        </tr>
        <BR>
        <tr> 
          <td><html:form action="/recupFacture.do">
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
					 <input type="hidden" name="pageAide" value="<%= sPageAide %>">
					 <input type="hidden" name="typeFacture" value="<%= sTypeFacture %>">
					 <input type="hidden" name="socfact" value="<%= sSocfact %>">
					 <html:hidden property="arborescence" value="<%= arborescence %>"/>
					 <html:hidden property="action" value="modifier"/>
                     <html:hidden property="page" value="modifier"/>
                     <input type="hidden" name="nomChampDestinataire" value="<%= sNomChampDestinataire %>">
                     <input type="hidden" name="nomChampDestinataire2" value="<%= sNomChampDestinataire2 %>">
                     <input type="hidden" name="windowTitle" value="<%= sWindowTitle %>">
                   
                    
                     
                     <input type="hidden" name="index" value="modifier">                                                          
                        <table align="center">	
                                          <tr>
				                     		<td class="lib">Code société :&nbsp;<BR>
				                            </td>
				                     		<td><%= sSocfact %></td>                 		                  		                     
				                     	  </tr>				
				                     	  <tr>
				                     		<td class="lib">Nom de la ressource :&nbsp;<BR>
				                            </td>
				                     		<td><html:text property="nomRessource" size="30" maxlength="30"/></td>                 		                  		                     
				                     	  </tr>
				                     	  <tr>
				                     		<td class="lib">N° Contrat :&nbsp;<BR>
				                            </td>
				                     		<td><html:text property="contrat" size="30" maxlength="27"/></td>                 		                  		                     
				                     	  </tr>
				                     	  <tr>&nbsp;</tr>
				                     	  <tr>
				                     		<td><html:radio property="factureEncours" value="OUI"><%= sType %>s de l'année en cours</html:radio></td>
				                            <td><html:radio property="factureEncours" value="NON"><%= sLib %></html:radio></td>
				                          </tr>                                             	  				                     		
                    	  <% int i =0;
                     	    String[] strTabCols = new String[] {  "fond1" , "fond2" }; 
                     	    %>   
         							</table>
         <table>            	
             
             <% if  	(listeRechercheFacture.size() == 99){%>
            <tr><td colspan="3" class="contenu"><B>Le nombre de facture trouv&eacute;es est sup&eacute;rieur &agrave; 100<BR>
            Veuillez saisir un nom plus long afin de mieux limiter la recherche</B></td></tr>
            <tr><td >&nbsp;</td></tr>
            <%}%>
            
            
             
<logic:present name="listeRechercheFacture">   
<% if  	(listeRechercheFacture.size()>0){%>

<tr><td colspan ="4" class="contenu">Cliquez sur un N° de la facture pour le s&eacute;lectionner</td></tr>
<BR>
 <tr>
 <td class="lib" width="15%"><b>N° Facture</b></td>
 <td class="lib" width="15%"><b>Date de la facture</b></td>
 <td class="lib" width="20%"><b>Nom ressource</b></td>
 <td class="lib" width="15%"><b>Prénom</b></td>
 <td class="lib" width="15%"><b>N° Contrat</b></td>
</tr>
<logic:iterate id="element"  name="listeRechercheFacture"  length="<%=listeRechercheFacture.getCountInBlock()%>" 
          offset="<%=listeRechercheFacture.getOffset(0)%>"
					type="com.socgen.bip.metier.InfosFacture"
					indexId="index"> 
							<% if ( i == 0) i = 1; else i = 0;%>
				   <tr class="<%= strTabCols[i] %>">
							   <td class="contenu">
							   <bean:write name="element" property="lienHref" filter="false"/>
							   <bean:write name="element" property="facture" />
							   </a></td>
							   <td class="contenu"><bean:write name="element" property="datfact" /></td>
							   <td class="contenu"><bean:write name="element" property="nomRessource" /></td>
							   <td class="contenu"><bean:write name="element" property="prenomRessource" /></td>
							   <td class="contenu"><bean:write name="element" property="contrat" /></td>
							 					  
				   </tr>
				   
</logic:iterate>       		


					<tr>
						<td align="center" colspan="4" class="contenu">
						<bip:pagination beanName="listeRechercheFacture"/>
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
              
       