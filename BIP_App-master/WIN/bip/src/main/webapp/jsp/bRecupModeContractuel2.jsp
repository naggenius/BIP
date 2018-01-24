<!DOCTYPE html>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,java.util.*,javax.servlet.http.*,com.socgen.ich.ihm.*,com.socgen.bip.commun.liste.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="recupModeContractuelForm" scope="request" class="com.socgen.bip.form.RecupModeContractuelForm" />
<jsp:useBean id="listeDynamique" scope="request" class="com.socgen.bip.commun.liste.ListeDynamique" />
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
<!-- <link rel="stylesheet" href="../css/base_style.css" type="text/css"> -->
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	String sWindowTitle = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("windowTitle")));
	String rafraichir = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("rafraichir")));
	
	try {	
		if (recupModeContractuelForm.getRtype().equals("P") || recupModeContractuelForm.getRtype().equals("L")) 
		{	
			Hashtable hKeyList= new Hashtable();
			hKeyList.put("userid", ""+((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
	    	hKeyList.put("rtype", ""+recupModeContractuelForm.getRtype());
	    		   		
		    ArrayList listeModeContractuel = listeDynamique.getListeDynamique("modeContractuelLong", hKeyList);
		    listeModeContractuel.add(0, new ListeOption(" ", " " ));     
		    pageContext.setAttribute("choixModeContractuel", listeModeContractuel);
		        	      	        
			
		}
	}
	catch (Exception e) {
	    pageContext.setAttribute("choixModeContractuel", new ArrayList());
	}
	
%>
var pageAide = "<%= sPageAide %>";


function MessageInitial()
{
   var Message="<bean:write filter="false"  name="recupModeContractuelForm"  property="msgErreur" />";
   var Focus = "<bean:write name="recupModeContractuelForm"  property="focus" />";

   if (Message != "") {
      alert(Message);
   }
   
  
}


function Verifier(form)
{
    if (form.choix[0].checked)
	{
	   form.action.value="suite";
	   form.choix.value = "O";
	   form.submit();
       return true; 
	}
	else if (form.choix[1].checked)
	{
		form.choix.value = "N";
		fill1('???');
		window.close();
	}else{
 		alert("Vous devez cocher votre rê±¯nse à¡£ette question, avant de cliquer sur <Suite> Û avec un bouton Fermer"); 
       	return false;	
    } 
    return false; 
}

function Quitter(){
 	window.close();
}

function ChangeModeContractuel(form)
{
  fill1(document.forms[0].modeContractuelInd.value);
  window.close(); 
} 

function fill1(code)
{
	var cible1 = "<%=recupModeContractuelForm.nomChampDestinataire1%>";
	window.opener.document.forms[0].elements[cible1].value = code;
	action = document.forms[0].rafraichir.value;
		if(action == 'OUI')
		{
		window.opener.document.forms[0].focus.value = document.forms[0].nomChampDestinataire1.value;
		   	rafraichir(window.opener.document.forms[0]);
		}
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
          <td>&nbsp;</td>
        </tr>
        <tr > 
          <td> 
            &nbsp;
          </td>
        </tr>
        <tr> 
 <td>
<!-- <div id="outils" align="center">#BeginEditable "barre_haut" -->
<%--           <%ToolBarNew tb = new com.socgen.ich.ihm.ToolBarNew("bip_ihm",false,false,true,true,false,false,false,false,false,request) ;%> --%>
<%-- 				<%=tb.printHtml()%><!-- #EndEditable -->  --%>
<!-- 		</div> -->
</td> 
        </tr>
<!--         <tr>  -->
<!--           <td background="../images/ligne.gif"></td> -->
<!--         </tr> -->
        <tr> 
          <td class="TitrePage"><!-- #BeginEditable "titre_page" -->
            <bean:write name="recupModeContractuelForm" property="titrePage"/> Mode Contractuel <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td height="20"></td>
        </tr>
        <tr> 
          <td><html:form action="/recupModeContractuel2">
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
                     <html:hidden property="action"/>
                     <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
                     <html:hidden name="recupModeContractuelForm" property="nomChampDestinataire1"/>
                     <html:hidden name="recupModeContractuelForm" property="nomChampDestinataire2"/>
                     <html:hidden name="recupModeContractuelForm" property="rtype"/>
                     <html:hidden name="recupModeContractuelForm" property="windowTitle"/>
                     <html:hidden name="recupModeContractuelForm" property="habilitationPage"/>  
                     <input type="hidden" name="rafraichir" value="<%= rafraichir %>">
                   <%if (recupModeContractuelForm.getRtype().equals("P") || recupModeContractuelForm.getRtype().equals("L")) 
                	{ %>
                	 <table align="center">	
	                   	  	<tr align="left">
	                   			 <td class="texte">Mode contractuel indicatif :</td>
			                     <td>
			                   	 <html:select styleId="listeContractuel" name="recupModeContractuelForm" property="modeContractuelInd" styleClass="input" onchange="ChangeModeContractuel(this);"> 
			   						<bip:options collection="choixModeContractuel" />
								 </html:select></td>
	                        </tr>
	                   	    <tr>
		                   		<td colspan="5">&nbsp;</td>
	                   	    </tr>
		   			 </table>
                	<%} else {%>
                   <html:hidden name="recupModeContractuelForm" property="modeContractuelInd"/>
					<html:hidden name="recupModeContractuelForm" property="localisation"/>
					
		   			  <table border=0 cellspacing=2 cellpadding=2 class="TableBleu" align="center">    
   
      
                 <tr align="left">
		        <td class="texte" colspan=5 align="left"><b>Connaissez-vous le mode contractuel de la situation de cette ressource ?</b></td>
		     </tr>
	        <tr> 
          		<td colspan=5> &nbsp;</td>
        				</tr>
	                   	  	<tr align="left">
	                   	  	<td>&nbsp;</td>
	                   			<td  class="texte"><html:radio property="choix" value="O">OUI</html:radio></td>
	                   			<td class="texte"><html:radio property="choix" value="N">NON</html:radio></td>
	                          	
	                          	<td><html:submit property="boutonValider" value="Suite" styleClass="input" onclick=" return Verifier(this.form);"/> 
	                          	</td>
	                          	<td>&nbsp;</td>
	                        </tr>     
	                        
	                           <tr> 
          		<td colspan=5> &nbsp;</td>
        				</tr>                                        	  				                     		
		   			 </table>
        
                  
                </td>
              </tr>
            </table>
		   			 
		   			 	 <%}%>
		   			 <table align="center">	
        					<tr>
	                          	<td><html:submit property="boutonValider" value="Annuler" styleClass="input" onclick="Quitter();"/> 
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
 