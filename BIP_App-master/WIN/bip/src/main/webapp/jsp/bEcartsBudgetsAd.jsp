<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="ecartsBudgetsForm" scope="request" class="com.socgen.bip.form.EcartsBudgetsForm" />
<html:html locale="true">

<head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>


<title>Edition</title>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<bip:VerifUser page="/ecartsbudgets.do"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var pageAide = "aide/hvide.htm";
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	String sIndexMenu = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("indexMenu")));
	
		
%>
var pageAide = "<%= sPageAide %>";

var blnVerifFormat  = true;
var tabVerif        = new Object();




function MessageInitial()
{
	
	var Message="<bean:write filter="false"  name="ecartsBudgetsForm"  property="msgErreur" />";
	var Focus = "<bean:write name="ecartsBudgetsForm"  property="focus" />";
	
	if (Message != "") {
		alert(Message);
		document.ecartsBudgetsForm.action.value = 'annuler';
        document.ecartsBudgetsForm.submit();
	}
	else
	{
		document.ecartsBudgetsForm.codsg.value = Replace_DoubleZero_by_DoubleEtoile( "<bean:write name="UserBip" property="dpg_Defaut" />" );
		if (Focus != "")
		{ 
			(eval( "document.ecartsBudgetsForm."+Focus )).focus();
		}
   		else 
   		{
	  		document.ecartsBudgetsForm.codsg.focus();
   		}
	}
	
}

function Verifier(form, action, flag)
{
  blnVerification = flag;
  form.action.value = action;
}

function ValiderEcran(form)
{
   if (blnVerification) {
        if (!ChampObligatoire(form.codsg, "Code DPG")) return false;
   }
   return true;
}


function VerifierCODSG(form)
{
   if(Ctrl_dpg_generique(form))
   {
   return true;
   
   }
    
   
   else
   {
   
   document.ecartsBudgetsForm.action.value = 'annuler';
   document.ecartsBudgetsForm.submit();
   return false;
   }
   

}


</script>

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
          <td height="20" class="TitrePage">Lister les Ecarts Budg&eacute;taires<bean:write name="ecartsBudgetsForm"  property="msgtrait" /></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> 
            
          </td>
        </tr>
        <tr> 
          <td>
		  <html:form action="/ecartsbudgets.do"  onsubmit="return ValiderEcran(this);" target="_top">
		  		
             <input type="hidden" name="pageAide">
             <input type="hidden" name="indexMenu" value="<%= sIndexMenu %>">
             <html:hidden property="action"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
             <input type="hidden" name="indexMenu" value="<%= sIndexMenu %>">
		           
             
             <html:hidden property="numtrait"/>             				
             <html:hidden property="msgtrait"/>
             <html:hidden property="nexttrait"/>	    
                              
            <table width="100%" border="0">
              
                <tr> 
                  <td> 
                    <div align="center">
					<table border=0 cellspacing=2 cellpadding=2 class="tableBleu">
						<input type="hidden" name="pageAide" value="<%= sPageAide %>">
					  <tr>
                        <td colspan=5 align="center">&nbsp;</td>
                      </tr>
                  <tr> 
                     <td>&nbsp;</td>
                     <td>&nbsp;</td>
                  </tr>
                      
                  <tr> 
                     <td>&nbsp;</td>
                     <td>&nbsp;</td>
                  </tr>
                  
                  <tr> 
                     <td>&nbsp;</td>
                     <td>&nbsp;</td>
                  </tr>    
                      
                      
					<tr>
						<td class="lib"><B>Code DPG :</B></td>
						<td><html:text property="codsg" styleClass="input"  size="7" maxlength="7" onchange="return VerifierCODSG(this);"/></td>
					</tr>
					
					<tr> 
                     <td>&nbsp;</td>
                     <td>&nbsp;</td>
                    </tr>
					
					<tr>
<!--						<td>&nbsp;</td>
						<td>&nbsp;</td>
-->					<td class="lib"><B>Types d'&eacute;carts :</B></td>
					   <td align=left>
                    	   <select name="type" size="1" class="input">
                    		   <option value="TOUS">Tous les Types</option>
                               <option value="REE-CON">Estimé < Consommé</option>
                    		   <option value="REE>ARB">Estimé > Arbitré</option>
                               <option value="CONS-BUD">Consommation sans budget</option>
                           </select>	
					   </td>
					</tr>
					
					 <tr>
                        <td colspan=5 align="center">&nbsp;</td>
                      </tr>
			   		</table>
					</div>
                  </td>
                </tr>
				<tr> 
          		  <td>&nbsp;  
          		  </td>
        		</tr>
                           
            </table>
             <table  border="0" width=100%>
                      <tr> 
                        <td align="right" width=33%> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'suite', true);"/> 
                        </td>
                        <td align="center" width=10%>&nbsp;</td>
                        <td align="left" width=33%> <html:submit property="boutonModifier" value="Message" styleClass="input" onclick="Verifier(this.form, 'modifier', true);"/> 
                        </td>
                       </tr>
            </table>
            
			  </html:form>
          </td>
        </tr>
		<tr> 
          <td>&nbsp;  
          </td>
        </tr>
        <tr> 
          <td> 
            <div align="center"><html:errors/></div>
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