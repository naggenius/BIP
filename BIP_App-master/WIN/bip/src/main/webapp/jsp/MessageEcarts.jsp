 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<!-- "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,java.util.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,java.lang.reflect.InvocationTargetException"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="ecartsForm" scope="request" class="com.socgen.bip.form.EcartsForm" />
<!-- l'ID du bean PaginationVector doit être le même que celui défini dans BipConstantes -->
<jsp:useBean id="messageEcarts" scope="session" class="com.socgen.bip.metier.MessageEcarts" />


<html:html locale="true"> 

<head>
 


 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>


 <!-- #BeginEditable "doctitle" --> 
<title>Application BIP</title>


<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<bip:VerifUser page="/ecarts.do"/>

<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
	
var blnVerification = true;
var allCodeActivite = new Array();

<%

    String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	String sIndexMenu = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("indexMenu")));
   
    Vector msg =  messageEcarts.getMessage();

%>




var codsg = "<%= messageEcarts.getCodsg() %>";
var gnom = "<%= messageEcarts.getGnom() %>";

var message;

  message = "   Bonjour,%0a%0a%0a    Voici la liste des &eacute;carts de saisie qui con&ccedil;ernent les ressources de votre groupe "+codsg+" : %0a";

<%

    String ligne = "";

    for (Enumeration e = msg.elements(); e.hasMoreElements();) 
    {
   		ligne = (String)e.nextElement();
   		%>message = message + "%0a      " + "<%= ligne %>";
   		 <%             
   		             
    }		             
	   	    	
 	

%>

  message = message + "%0a%0a=====> <%= ecartsForm.getNexttrait() %>";

  message = message + "%0a%0a%0a   Cordialement";
	
  message = "mailto:" + gnom + "?subject=Liste des &eacute;carts BIP<%= ecartsForm.getMsgtrait() %>" + "&body=" + message;	
  
 
 if(message.length < 2000)
 {
     document.location.href = message;
     Quitter();
 }
  
function Quitter(){
 		window.close();
	}

</script>
<!-- #EndEditable -->  
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" >
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
          <td height="20" class="TitrePage">Liste des Ecarts du groupe <%= messageEcarts.getCodsg() %> <%= ecartsForm.getMsgtrait() %></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> 
            
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr ><td align="left" width="70%" class="lib"><b> D&eacute;sol&eacute; le message ne peut pas s'ouvrir avec le logiciel de messagerie car la taille du message est tr&egrave;s grande.
        	                        <br>Veuillez le faire manuellement.
                                    <br>Vous trouverez ci-dessous le nom du responsable du groupe ainsi que le message contenant la liste des &eacute;carts. 	
        	 </b></td></tr>
        	 
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>	
        
        <tr> 
          <td align="left" width="10%" class="fond2"><b>Le responsable du groupe :</b><%= messageEcarts.getGnom() %></td>
        </tr>
         
        <tr> 
          <td>&nbsp;</td>
        </tr>
         
        <tr> 
          <td align="left" width="10%" class="fond2"><b>L'objet :</b> Liste des &eacute;carts BIP<%= ecartsForm.getMsgtrait() %></td>
        </tr>
         
         <tr> 
          <td>&nbsp;</td>
        </tr>
         
        <tr> 
          <td align="left" width="10%" class="fond2"><b>Le corps du message :</b></td>
        </tr>
         
        <tr> 
          <td>&nbsp;</td>
        </tr>
                 
        <tr> 
          <td>
          	&nbsp;&nbsp;Bonjour,
          	<br>&nbsp;&nbsp;&nbsp;Voici la liste des &eacute;carts de saisie qui concernent les ressources de votre groupe <%= messageEcarts.getCodsg() %> :
          	<br>
           
           <%
           
                      

           for (Enumeration e = msg.elements(); e.hasMoreElements();) 
           {
   		       ligne = (String)e.nextElement();
   		       %>
   		             &nbsp;&nbsp;&nbsp;&nbsp;<%= ligne %><br>
   		       <%             
   		             
               }		  
           
           
           %>
          
          <br><br>
         <font color=red><b>&nbsp;=====> <%= ecartsForm.getNexttrait() %></b></font>
      
          <br><br>
          &nbsp;&nbsp;&nbsp;Cordialement
            
          </td>
        </tr>
        
        
        <tr> 
          <td>&nbsp;</td>
        </tr>
        
        <tr> 
             <td align="center"><html:button property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Quitter();"/></td>
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
</body></html:html>