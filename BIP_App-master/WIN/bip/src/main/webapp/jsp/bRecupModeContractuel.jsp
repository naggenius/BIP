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
	String rafraichir = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("rafraichir")));
	try {	
		if (recupModeContractuelForm.getRtype().equals("P") || recupModeContractuelForm.getRtype().equals("L")) 
		{	
			Hashtable hKeyList= new Hashtable();
			hKeyList.put("userid", ""+((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
	    	hKeyList.put("rtype", ""+recupModeContractuelForm.getRtype());
	    	hKeyList.put("typfact", ""+recupModeContractuelForm.getTypfact());
	   		
		    ArrayList listeModeContractuel = listeDynamique.getListeDynamique("modeContractuelContrat", hKeyList);
		    listeModeContractuel.add(0, new ListeOption(" ", " " )); 
		    pageContext.setAttribute("choixModeContractuel", listeModeContractuel);
		        	      	        
		
	
		}
	}
	catch (Exception e) {
	    pageContext.setAttribute("choixModeContractuel", new ArrayList());
	}
	
%>
var pageAide = "<%= sPageAide %>";
var rtype = "<%= recupModeContractuelForm.getRtype() %>";


function MessageInitial()
{
   var Message="<bean:write filter="false"  name="recupModeContractuelForm"  property="msgErreur" />";
   var Focus = "<bean:write name="recupModeContractuelForm"  property="focus" />";

   if (Message != "") {
      alert(Message);
   }
   
    if ((rtype != 'P')  &&  (rtype != 'L')) 
    { 
    	document.forms[0].typeforfait[0].checked=true;
  	}
}


function Verifier(form)
{
	form.action.value="suite";
    if (form.typeforfait[0].checked)
	{
	   form.typeforfait.value = "F";
	   form.submit();
       return true; 
	}
	else if (form.typeForfait[1].checked)
	{
		form.typeforfait.value = "E";
	    form.submit();
    	return true; 
	}else{
 		alert("Veuillez saisir un frais d'environnement!"); 
       	return false;	
    }     
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->
            <bean:write name="recupModeContractuelForm" property="titrePage"/> Mode Contractuel <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td></td>
        </tr>
        <BR>
        <tr> 
          <td><html:form action="/recupModeContractuel">
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
                     <html:hidden property="action"/>
                     <html:hidden property="mode"/>
                     
<html:hidden property="arborescence" value="<%= arborescence %>"/>
                     <html:hidden property="localisation"/>
                     <html:hidden name="recupModeContractuelForm" property="nomChampDestinataire1"/>
                     <html:hidden name="recupModeContractuelForm" property="nomChampDestinataire2"/>
                     <html:hidden name="recupModeContractuelForm" property="rtype"/>
                     <html:hidden name="recupModeContractuelForm" property="windowTitle"/>
                     <html:hidden name="recupModeContractuelForm" property="habilitationPage"/>  
                     <input type="hidden" name="rafraichir" value="<%= rafraichir %>">
                    
                    <%if (recupModeContractuelForm.getRtype().equals("P") || recupModeContractuelForm.getRtype().equals("L")) 
                	{ %>
                	 <table align="center">	
	                   	  	<tr>
	                   			 <td class="lib">Mode contractuel indicatif :</td>
			                     <td>
			                   	 <html:select styleId="listeContractuel" property="modeContractuelInd" styleClass="input" onchange="ChangeModeContractuel(this);"> 
			   						<bip:options collection="choixModeContractuel" />
								 </html:select></td>
	                        </tr>
	                   	    <tr>
		                   		<td colspan="5">&nbsp;</td>
	                   	    </tr>
		   			 </table>
                	<%} else {%>
                	<html:hidden name="recupModeContractuelForm" property="modeContractuelInd"/>
                   <table border=0 cellspacing=2 cellpadding=2 class="TableBleu" align="center">    
   
      
                 <tr>
		        <td class="lib" colspan=5 align="center"><b>Frais d'environnement</td>
		     </tr>
	        <tr> 
          		<td colspan=5> &nbsp;</td>
        				</tr>
	                   	  	<tr>
	                   			<td><html:radio property="typeforfait" value="F">AVEC</html:radio></td>
	                   			<td>&nbsp;</td>
	                          	<td><html:radio property="typeforfait" value="E">SANS</html:radio></td>
	                          	<td>&nbsp;</td>
	                          	<td><html:submit property="boutonValider" value="Suite" styleClass="input" onclick="Verifier(this.form, 'suite1', this.form.mode.value,true);"/> 
	                          	</td>
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
 