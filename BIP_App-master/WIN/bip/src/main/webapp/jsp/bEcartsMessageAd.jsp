<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<!-- "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,java.util.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,java.lang.reflect.InvocationTargetException"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="ecartsForm" scope="request" class="com.socgen.bip.form.EcartsForm" />
<!-- l'ID du bean PaginationVector doit être le même que celui défini dans BipConstantes -->
<jsp:useBean id="listeEcartPole" scope="session" class="com.socgen.ich.ihm.menu.PaginationVector" />
<html:html locale="true"> 

<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>


 <!-- #BeginEditable "doctitle" --> 
<title>Application BIP</title>


<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<bip:VerifUser page="/ecarts.do"/>
<% 	int i = 0;
   	
  	String[] strTabCols = new String[] {  "fond1" , "fond2" };
	
%>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
	
var blnVerification = true;
var allCodeActivite = new Array();
var numtrait = "<bean:write name="ecartsForm"  property="numtrait" />";
var msgtrait = "<bean:write name="ecartsForm"  property="msgtrait" />";
var nexttrait = "<bean:write name="ecartsForm"  property="nexttrait"/>";

<%

    String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	String sIndexMenu = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("indexMenu")));

%>

function MessageInitial()
{
	var Message="<bean:write filter="false"  name="ecartsForm"  property="msgErreur" />";
	var Focus = "<bean:write name="ecartsForm"  property="focus" />";
	if (Message != "") {
    	alert(Message);
    	<% ecartsForm.setMsgErreur(""); %>
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


function paginer(page, index , action){
	document.forms[0].action.value = action;
	document.forms[0].page.value   = page;
    document.forms[0].index.value  = index;
    document.forms[0].submit();
}

function envoiMessage(rcodsg,rnom){

window.open("/ecarts.do?action=creer&codsg="+rcodsg+"&gnom="+rnom+"&numtrait="+numtrait+"&msgtrait="+msgtrait+"&nexttrait="+nexttrait ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width='95%', height='95%'") ;
  
  
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
          <td height="20" class="TitrePage">Liste des Ecarts avec Message<bean:write name="ecartsForm"  property="msgtrait" /></td>
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
            <!-- #BeginEditable "debut_form" -->
            <html:form action="/ecarts"  onsubmit="return ValiderEcran(this);">
            <!-- #EndEditable --> 
            <table width="100%" border="0">
            
              <tr><td>&nbsp;</td></tr>
              <tr><td>&nbsp;</td></tr>
              
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
				                                    	
                    <input type="hidden" name="pageAide">
                    <input type="hidden" name="indexMenu" value="<%= sIndexMenu %>">
                    <html:hidden property="action"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
                 	<html:hidden property="page" value="modifier"/>
             		<input type="hidden" name="index" value="modifier">
             	    <input type="hidden" name="indexMenu" value="<%= sIndexMenu %>">
             	    
             	    <html:hidden property="numtrait"/>             				
                    <html:hidden property="msgtrait"/>
                    <html:hidden property="nexttrait"/>	
                    	
				    <!-- Tableau des écarts -->
                    <table width="70%" border="0" cellspacing="0" cellpadding="2" >
                            <tr class="titreTableau">
                              <td align="center" width="5%" class="lib"><b>Envoi message</b></td>
					          <td align="center" width="8%" class="lib"><b>Dpg</b></td>
					          <td align="left" width="22%" class="lib"><b>Responsable</b></td>
					          <td align="left" width="18%" class="lib"><b>Libell&eacute; DPG</b></td>
					          <td align="center" width="5%" class="lib"><b>Nombre Ecarts</b></td>
					          					          
					        </tr>
      		<logic:iterate id="element" name="listeEcartPole" length="<%= listeEcartPole.getCountInBlock() %>" 
            		offset="<%= listeEcartPole.getOffset(0) %>" type="com.socgen.bip.metier.EcartPole" indexId="index"> 
			<% if ( i == 0) i = 1; else i = 0;
			 								  		
			 %>
			        <tr class="<%= strTabCols[i] %>">
						<td class="contenuCenter"><a href="javascript:envoiMessage('<bean:write name="element" property="codsg" />','<bean:write name="element" property="gnom" />');"><img border=0 src="/images/message.jpg" alt="Envoi message au chef de groupe" title="Envoi message au chef de groupe"></a></td>                    	
						<td class="contenuCenter"><bean:write name="element" property="codsg" /></td>
						<td class="contenu"><bean:write name="element" property="gnom" /></td>
						<td class="contenu"><bean:write name="element" property="libdsg"/></td>
						<td class="contenuCenter"><bean:write name="element" property="nombre"/></td>
											
    			  	</tr>
				  
                              
                           		
			</logic:iterate> 
                                                              
                              
                                               
                          </table>
             
             	          <table width="100%" border="0" cellspacing="0" cellpadding="0">
			   	            <tr>
					          <td align="center" colspan="4" class="contenu">
						        <bip:pagination beanName="listeEcartPole"/>
					          </td>
				            </tr>
	 			            <tr><td colspan="4">&nbsp;</td></tr>
	 			            <tr>
              		          <td width="25%">&nbsp;</td>
                	          
               		          <td width="25%"> 
                  	            <div align="center"> 
                	               <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', false);"/>
              		           </div>
                              </td>
                              <td width="25%">&nbsp;</td>
            	            </tr>
     
				          </table>
				        </td>
            	      </tr>
     
				    </table>
				  </table>

                  </div>
                </td>
              </tr>
            </table>
            
            </html:form>
            
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
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
<% 
Integer id_webo_page = new Integer("1036"); 
com.socgen.bip.commun.form.AutomateForm formWebo = ecartsForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
