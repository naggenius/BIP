<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="RecupIdDirectionForm" scope="request" class="com.socgen.bip.form.RecupIdDirectionForm" />
<jsp:useBean id="listeRechercheIdDirection" scope="session"	class="com.socgen.ich.ihm.menu.PaginationVector" />

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
	String sRtype = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("rtype")));
%>
var pageAide = "<%= sPageAide %>";


function MessageInitial()
{
   var Message="<bean:write filter="false"  name="RecupIdDirectionForm"  property="msgErreur" />";
   var Focus = "<bean:write name="RecupIdDirectionForm"  property="focus" />";
   
      
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
    
       form.submit();
    	 return true; 
         
      
}


function Quitter(){
 		window.close();
	}
    


function fill(num) {
	  var cible = "<%=RecupIdDirectionForm.nomChampDestinataire%>";
		window.opener.document.forms[0].elements[cible].value = num;
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
        
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td height="20" class="TitrePage"><bean:write name="RecupIdDirectionForm" property="windowTitle" /></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
      
        <tr> 
          <td align="center"><html:form action="/recupIdDirection.do">
            <table width="80%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
					 <input type="hidden" name="pageAide" value="<%= sPageAide %>">
					 <html:hidden property="arborescence" value="<%= arborescence %>"/>
					 <html:hidden property="action" value="modifier"/>
                     <html:hidden property="page" value="modifier"/>
                     <input type="hidden" name="rtype" value="<%= sRtype %>">
                     <html:hidden name="RecupIdDirectionForm" property="nomChampDestinataire"/>
                     <html:hidden name="RecupIdDirectionForm" property="windowTitle"/>
                     <html:hidden name="RecupIdDirectionForm" property="habilitationPage"/>  
                       
                     <input type="hidden" name="index" value="modifier">                                                          
                                               	  				                     		
                    	  <% int i =0;
                     	    String[] strTabCols = new String[] {  "fond1" , "fond2" }; 
                     	    %>   
         						
         <table>            	
                                  
            
             
<logic:present name="listeRechercheIdDirection">   
<% if  	(listeRechercheIdDirection.size()>0){%>

<tr><td colspan ="4" class="contenu">Cliquez sur un code d'une direction pour la sélectionner</td></tr>
<tr>
<td>&nbsp;</td>
</tr>
 <tr>
 <td class="lib" width="10%">Code Direction</td>
 <td class="lib"width="90%">Libellé</td>

</tr>
<logic:iterate id="element"  name="listeRechercheIdDirection"  length="<%=listeRechercheIdDirection.getCountInBlock()%>" 
          offset="<%=listeRechercheIdDirection.getOffset(0)%>"
					type="com.socgen.bip.metier.InfosDirection"
					indexId="index"> 
							<% if ( i == 0) i = 1; else i = 0;%>
				   <tr class="<%= strTabCols[i] %>">
							   <td class="contenu">
							   <bean:write name="element" property="lienHref" filter="false"/>
							   <bean:write name="element" property="coddir" />
							   </a></td>
							   <td class="contenu"><bean:write name="element" property="libdir" /></td>
							  					  
				   </tr>
				   
</logic:iterate>       		

					<tr>
						<td align="center" colspan="4" class="contenu">
						<bip:pagination beanName="listeRechercheIdDirection"/>
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
              		<td> 
                  	 <div align="center">
                	  <html:button property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Quitter();"/>
              		 </div>
                	</td>
                
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
              
       