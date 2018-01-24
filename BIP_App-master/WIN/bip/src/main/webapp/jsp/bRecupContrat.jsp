<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="RecupContratForm" scope="request" class="com.socgen.bip.form.RecupContratForm" />
<jsp:useBean id="listeRechercheContrat" scope="session"	class="com.socgen.ich.ihm.menu.PaginationVector" />

<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>


 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 

<!-- Page autorisÃ©e Ã  tous les utilisateurs -->
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
	String sTypeContrat = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("typeContrat")));
	String sType;
	
	if((sTypeContrat==null)||(sTypeContrat.equals("null")))
		 sType="contrat";
	else 
	     sType=sTypeContrat;
	      	    
	
	
	
	String sSoccont = request.getParameter("soccont");
	String sNomChampDestinataire =  ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("nomChampDestinataire")));
	String sNomChampDestinataire2 = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("nomChampDestinataire2")));
%>
var pageAide = "<%= sPageAide %>";


function MessageInitial()
{
   var Message="<bean:write filter="false"  name="RecupContratForm"  property="msgErreur" />";
   var Focus = "<bean:write name="RecupContratForm"  property="focus" />";
   var select = "<bean:write name="RecupContratForm"  property="contratEncours" />";

   // Placer le focus la zone de recherche
   document.forms[0].nomRecherche.focus();   
   
   if (Message != "") {
      alert(Message);
   }
  
  document.forms[0].nomRessource.focus();
  
  if(select == 'NON')
     document.forms[0].contratEncours[1].checked=true;
  else
     document.forms[0].contratEncours[0].checked=true;   
  
}


function ValiderEcran(form)
{

   
	if (form.contratEncours[0].checked)
	{
	   form.contratEncours.value = "OUI";
	}
	if (form.contratEncours[1].checked)
	{
	form.contratEncours.value = "NON";
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
    
    form.nomRecherche.value = form.nomRecherche.value.toUpperCase()
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
	    var cible = "<%=RecupContratForm.nomChampDestinataire%>";
	    var cible2 = "<%=RecupContratForm.nomChampDestinataire2%>";
	   
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
          <td height="20" class="TitrePage"><%= ESAPI.encoder().decodeFromURL(sWindowTitle) %></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td></td>
        </tr>
        <BR>
        <tr> 
          <td><html:form action="/recupContrat.do">
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
					 <input type="hidden" name="pageAide" value="<%= sPageAide %>">
					 <input type="hidden" name="typeContrat" value="<%= sTypeContrat %>">
					 <input type="hidden" name="soccont" value="<%= sSoccont %>">
                     
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
				                     		<td><%= sSoccont %></td>                 		                  		                     
				                     	  </tr>				
				                     	  <tr>
				                     		<td class="lib">Nom de la ressource :&nbsp;<BR>
				                            </td>
				                     		<td><html:text property="nomRessource" size="30" maxlength="30"/></td>                 		                  		                     
				                     	  </tr>
				                     	  <tr>
				                     		<td class="lib">Objet :&nbsp;<BR>
				                            (Veuillez saisir une partie de l'objet)</td>
				                     		<td><html:text property="nomRecherche" size="50" maxlength="50"/></td>                 		                  		                     
				                     	  </tr>
				                     	  <tr>&nbsp;</tr>
				                     	  <tr>
				                     		<td><html:radio property="contratEncours" value="OUI"><%= sType %>s en cours</html:radio></td>
				                            <td><html:radio property="contratEncours" value="NON">Tous les <%= sType %>s</html:radio></td>
				                          </tr>                                             	  				                     		
                    	  <% int i =0;
                     	    String[] strTabCols = new String[] {  "fond1" , "fond2" }; 
                     	    %>   
         							</table>
         <table>            	
             
             <% if  	(listeRechercheContrat.size() == 99){%>
            <tr><td colspan="3" class="contenu"><B>Le nombre de contrat trouv&eacute;es est sup&eacute;rieur &agrave;100<BR>
            Veuillez saisir un nom plus long afin de mieux limiter la recherche</B></td></tr>
            <tr><td >&nbsp;</td></tr>
            <%}%>
            
            
             
<logic:present name="listeRechercheContrat">   
<% if  	(listeRechercheContrat.size()>0){%>

<tr><td colspan ="4" class="contenu">Cliquez sur un N° du contrat pour le s&eacute;lectionner</td></tr>
<BR>
 <tr>
 <td class="lib" width="15%"><b>Contrat</b></td>
 <td class="lib" width="4%"><b>Avenant</b></td>
 <td class="lib" width="20%"><b>Nom ressource</b></td>
 <td class="lib" width="30%"><b>Objet</b></td>
 <td class="lib" width="10%"><b>Date début</b></td>
 <td class="lib" width="10%"><b>Date fin</b></td>
</tr>
<logic:iterate id="element"  name="listeRechercheContrat"  length="<%=listeRechercheContrat.getCountInBlock()%>" 
          offset="<%=listeRechercheContrat.getOffset(0)%>"
					type="com.socgen.bip.metier.InfosContrat"
					indexId="index"> 
							<% if ( i == 0) i = 1; else i = 0;%>
				   <tr class="<%= strTabCols[i] %>">
							   <td class="contenu">
							   <bean:write name="element" property="lienHref" filter="false"/>
							   <bean:write name="element" property="contrat" />
							   </a></td>
							   <td class="contenu"><bean:write name="element" property="avenant" /></td>
							   <td class="contenu"><bean:write name="element" property="nomRessource" /></td>
							   <td class="contenu"><bean:write name="element" property="objet" /></td>
							   <td class="contenu"><bean:write name="element" property="datedebut" /></td>
							   <td class="contenu"><bean:write name="element" property="datefin" /></td>						  
				   </tr>
				   
</logic:iterate>       		


					<tr>
						<td align="center" colspan="4" class="contenu">
						<bip:pagination beanName="listeRechercheContrat"/>
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
              
       