<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="RecupIdrubriqueForm" scope="request" class="com.socgen.bip.form.RecupIdrubriqueForm" />
<jsp:useBean id="listeRechercheIdCa" scope="session"	class="com.socgen.ich.ihm.menu.PaginationVector" />

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
   var Message="<bean:write filter="false"  name="RecupIdrubriqueForm"  property="msgErreur" />";
   var Focus = "<bean:write name="RecupIdrubriqueForm"  property="focus" />";
   
   // Placer le focus la zone de recherche
   document.forms[0].nomRecherche.focus();
   
   if (Message != "") {
      alert(Message);
   }
  if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else if (document.forms[0].nomRecherche){
	  document.forms[0].nomRecherche.focus();
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

function fill(num){
	  var cible = "<%=RecupIdrubriqueForm.nomChampDestinataire%>";
	  var action = "<%=RecupIdrubriqueForm.rafraichir%>";
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
          <td height="20" class="TitrePage"><bean:write name="RecupIdrubriqueForm" property="windowTitle" /></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td></td>
        </tr>
        <BR>
        <tr> 
          <td><html:form action="/recupIdrubrique.do">
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
					 <input type="hidden" name="pageAide" value="<%= sPageAide %>">
                     
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<html:hidden property="action" value="modifier"/>
                     <html:hidden property="page" value="modifier"/>
                     <html:hidden name="RecupIdrubriqueForm" property="nomChampDestinataire"/>
                     <html:hidden name="RecupIdrubriqueForm" property="rafraichir"/>
                     <html:hidden name="RecupIdrubriqueForm" property="windowTitle"/>
                     <html:hidden name="RecupIdrubriqueForm" property="habilitationPage"/>  
                     <html:hidden name="RecupIdrubriqueForm" property="emptyResult"/> 
                     
                     <input type="hidden" name="index" value="modifier">                                                          
                        <table align="center">					
				                     	  <tr>
				                     		<td class="lib">Nom du centre d'activité :&nbsp;<BR>
				                     	  (Veuillez saisir les premières lettres du nom)</td>
				                     		<td><html:text property="nomRecherche" size="20" maxlength="20"/></td>                 		                  		                     
				                     		</tr>                                            	  				                     		
                    	  <% int i =0;
                     	    String[] strTabCols = new String[] {  "fond1" , "fond2" }; 
                     	    %>   
         							</table>
         <table>            	
             
             <% if  	(listeRechercheIdCa.size() == 99){%>
            <tr><td colspan="3" class="contenu"><B>Le nombre de rubrique trouvées est supérieur à 100<BR>
            Veuillez saisir un nom plus long afin de mieux limiter la recherche</B></td></tr>
            <tr><td >&nbsp;</td></tr>
            <%}%>
            
            
             
<logic:present name="listeRechercheIdCa">   
<% if  	(listeRechercheIdCa.size()>0){%>





<tr><td colspan ="4" class="contenu">Cliquez sur un code rubrique pour le sélectionner</td></tr>
<BR>
 <tr>
 <td class="lib" width="10%">Code Rubrique</td>
 <td class="lib" width="40%">Libellé</td>
 <td class="lib" width="10%">CAFI</td>
 <td class="lib" width="30%">Libellé centre d'activité</td>
  
</tr>
<logic:iterate id="element"  name="listeRechercheIdCa"  length="<%=listeRechercheIdCa.getCountInBlock()%>" 
          offset="<%=listeRechercheIdCa.getOffset(0)%>"
					type="com.socgen.bip.metier.InfosRubrique"
					indexId="index"> 
							<% if ( i == 0) i = 1; else i = 0;%>
				   <tr class="<%= strTabCols[i] %>">
							   <td class="contenu">
							   <bean:write name="element" property="lienHref" filter="false"/>
							   <bean:write name="element" property="id" />
							   </a></td>
							   <td class="contenu"><bean:write name="element" property="libelle" /></td>
							   <td class="contenu"><bean:write name="element" property="cafi" /></td>	
							   <td class="contenu"><bean:write name="element" property="libcafi" /></td>							    
				   </tr>
				   
</logic:iterate>       		


					<tr>
						<td align="center" colspan="4" class="contenu">
						<bip:pagination beanName="listeRechercheIdCa"/>
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
              
       