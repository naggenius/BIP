 <%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<!-- Imports --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="modifieLoupeForm"  scope="request" class="com.socgen.bip.form.ModifieLoupeForm"  />

<html:html locale="true">
<!-- #BeginTemplate "/Templates/Page_bip.dwt" -->

<head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

  
<title>Page BIP</title>
 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

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
   var Message="<bean:write filter="false"  name="modifieLoupeForm"  property="msgErreur" />";
   
   
   // Placer le focus la zone de recherche
   document.forms[0].libelle.focus();
   
   if (Message != "") 
   {
      alert(Message);
   }
   
   
   <% if (modifieLoupeForm.getMajTermine()!= null &&  modifieLoupeForm.getMajTermine().equals("MAJ_OK")){%> 
	 	rafraichir(window.opener.document.forms[0]);
	 	window.close();   
   <%}%> 
   
   
   
}

 
 

function Quitter()
{
	window.close();
}
    


function Verifier()
{
	document.forms[0].action.value = "valider"; 
	document.forms[0].mode.value = "update"; 	 
    if(document.forms[0].libelle.value != "")
    {  
       	document.forms[0].submit();
    	return true; 
    }else{
 	    alert("Veuillez saisir un libellé !") ; 
       	return false;	
    }            
}



</script>

</head>

<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
 <tr> 
   <td> 
     <table width="100%" border="0" cellspacing="0" cellpadding="0">
          
		       <tr> 
		          <td>&nbsp;</td>
		        </tr>
		        <tr > 
		         
		        </tr>        
		         <tr> 
		          <td>&nbsp;</td>
		        </tr>
		        <tr> 
		          <td background="../images/ligne.gif"></td>
		        </tr>
		        <tr> 
		          <td height="20" class="TitrePage"><bean:write name="modifieLoupeForm" property="windowTitle" /></td>
		        </tr>
		        <tr> 
		          <td background="../images/ligne.gif"></td>
		        </tr>
		        <tr> 
		          <td>&nbsp;</td>
		        </tr>
		   
		        <tr> 
		          <td>
				       <html:form action="/modifieLoupeAction" >
				                    <html:hidden name="modifieLoupeForm" property="action" value="valider"/>
				                    <html:hidden name="modifieLoupeForm" property="mode" value="update"/> 
            				        <html:hidden name="modifieLoupeForm" property="code" /> 	
               				        <html:hidden name="modifieLoupeForm" property="majTermine" /> 
            				        <html:hidden name="modifieLoupeForm" property="updateProcedure" /> 
            				        <html:hidden name="modifieLoupeForm" property="windowTitle" />
            				        
<html:hidden property="arborescence" value="<%= arborescence %>"/> 
            				        
               				        	
            				        			                      
						            <table  width="100%" border="0" align ="center">
										         <tr>   
										              <td>										                      										               										              
   										                  <table>
   										                     <tr>
   										                        <td width="5%">&nbsp;</td> 
															    <td class="lib">Veuillez saisir le nouveau libellé :</td>
															    <td></td>
															    <td><html:text styleClass="input"  name="modifieLoupeForm" property="libelle" size="50" maxlength="50" onchange="return VerifierAlphanumExclusionEtCommercial(this);"/></td>												     																							   													 			                            				    
															    <td width="5%">&nbsp;</td> 
															  </tr>  
														    </table>
													   </td>	    														
										  	     </tr>      
										  	     <tr>
					 							     <td colspan="4">&nbsp;</td>
					 						     </tr>
					 						     <tr> 
					 						          <td>
					 						             <table>
					 						                 <tr>
								 						          <td width="45%"></td> 	              			 		      		     
							                				      <td align="left"><html:button property="boutonValider" value="Valider" styleClass="input" onclick="Verifier();"/></td>
							                	  			      <td width="20%"></td>              	                  	  
							                	  			      <td align="right"><html:button property="annuler" value="annuler" styleClass="input" onclick="Quitter();"/></td>	 
							                	  			      <td></td>
							                	  			  </tr>    
				                	  			      	 </table>
				                	  			      </td> 	              			 		      		     
				            					 </tr>
						  			 </table>
				       </html:form> 
		         </td>
		       </tr>  
		       <tr> 
		          <td>&nbsp;</td>
		       </tr>  
      </table>
    </td>
   </tr>      
</body>
</html:html>       