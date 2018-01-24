<!DOCTYPE html>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,java.lang.reflect.InvocationTargetException,com.socgen.bip.metier.Libelle"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="paramLigneBipForm" scope="request" class="com.socgen.bip.form.ParamLigneBipForm" />
<jsp:useBean id="paramlignebip" scope="session"	class="com.socgen.ich.ihm.menu.PaginationVector" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/xLigneBipAd.jsp"/> 
<script language="JavaScript" src="../js/function.cjs"></script>
<!-- <link rel="stylesheet" href="../css/base_style.css" type="text/css"> -->
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	
%>
var pageAide = "<%= sPageAide %>";


function MessageInitial()
{
   var Message="<bean:write filter="false"  name="paramLigneBipForm"  property="msgErreur" />";
   var Focus = "<bean:write name="paramLigneBipForm"  property="focus" />";
   
   if (Message != "") {
      alert(Message);
   }
  
   
  }

function Verifier(form, action, flag, type_action)
{
   
         
   blnVerification = flag;
   form.action.value = action;
   form.type_action.value = type_action;
   
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


function CalculerTotMois(Obj,EF)
{
 if (!CalculerTotaux(Obj,EF)) { 
 EF.focus;
 return false;
 }
 return true; 
}



</script>
<!-- #EndEditable --> 
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
<div id="mainContainer">
<div id="topContainer" style="height:125%;">
<div id="entete"></div>
<div id="logo">
		<div id="logo_sg"><img src="../images/logo_SG.gif" width="162" height="33" border="0" /></div>
		<div id="nomdusite"><img src="../images/bip_logo.png" width="78" height="46" border="0" /></div>
</div>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr > 
          <td> 
            <div id="outils" align="center"><!-- #BeginEditable "barre_haut" -->
              <%ToolBarNew tb = new com.socgen.ich.ihm.ToolBarNew("bip_ihm",false,false,true,true,false,false,false,false,false,request) ;%>
				<%=tb.printHtml()%><!-- #EndEditable -->
		</div>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
<!--         <tr>  -->
<!--           <td background="../images/ligne.gif"></td> -->
<!--         </tr> -->
        <tr> 
          <td height="20" class="TitrePage">Paramétrage des libellés de champs</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td height="20"> </td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/paramLigneBip.do"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
					<input type="hidden" name="pageAide" value="<%= sPageAide %>">
                    <html:hidden property="action"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
                    <html:hidden property="page" value="modifier"/>
                    <input type="hidden" name="index" value="modifier">
		            <html:hidden property="type_action" value="modifier"/>
        		     
				    <table border=0 cellspacing=2 cellpadding=2 class="TableBleu">
                     

                      <tr>
                        <td colspan=6>&nbsp;</td>
                      </tr>
                    </table>
                    <table border=0 cellspacing=2 cellpadding=2 class="TableBleu">
                      <tr>
                        <td class=TitrePage><B>Champ</B></td>
                        <td class=TitrePage><B>Libellé</B></td>
                      
                      </tr>
                      	<% int i = 0;
                      	
                      	   Object oCle=null;
                      	   Object oLibelle=null;
                      	   
                      	   String cle="";
                      	   String libelle="";
                      	
						   int nbligne = 0;
						   Class[] parameterString = {};
				           Object[] param1 = {};
				           Object[] param2 = {};
				           
						   String[] strTabCols = new String[] {  "fond1" , "fond2" }; %>
						   
						<logic:iterate id="element" name="paramlignebip" length="<%=  paramlignebip.getCountInBlock()  %>" 
			            			offset="<%=  paramlignebip.getOffset(0) %>"
									type="com.socgen.bip.metier.Libelle"
									indexId="index"> 
						<% if ( i == 0) i = 1; else i = 0;
						   nbligne ++;
						   
						   cle="";
                      	   libelle="";
						   
						  
						    oCle= element.getClass().getDeclaredMethod("getCle",parameterString).invoke((Object) element, param1);
                        	if (oCle!=null) cle=oCle.toString();
                            else cle="";
                            /*
                            oLibelle= element.getClass().getDeclaredMethod("getLibelle",parameterString).invoke((Object) element, param2);
                        	if (oLibelle!=null) libelle=oLibelle.toString();
                            else libelle="";*/
						   
						 %>
						 
						
						<tr align="left">
						<td class="texte">
						<b><bean:write name="element" property="champ"/></b>
    			  	    </td>
    			  	    
						<td>
						<input class="input" type="text"  size="50" maxlength="50" name="<bean:write name="element" property="cle"/>" value="<bean:write name="element" property="libelle"/>">
    			  	    </td>
						</tr>
						
						
			 			 </logic:iterate> 
			 			 
			 			
			 			 
			  	
			  		</table>
					<table  width="100%" border="0" cellspacing="0" cellpadding="0">
					   
					   	
					   	<tr>
							<td align="center" colspan="4" class="contenu">
								<bip:pagination beanName="paramlignebip"/>
							</td>
						</tr>
			 			<tr><td colspan="4" height="15">&nbsp;</td>
			 			</tr>
			 			<tr>
		              		<td width="20%">&nbsp;</td>
		                	<td width="30%">
		                	 <div align="center">
		                	  <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', true, 'valider_libelle');"/>
		                	 </div>
		               		</td> 
		               		
		               		<td width="30%"> 
		                  	 <div align="center"> 
		                	  <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', false);"/>
		              		 </div>
		                </td>
		                <td width="20%">&nbsp;</td>
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
</div>
	<div id="bottomContainer">
			<div>&nbsp;</div>
	</div>
</div>
</body>

</html:html>
<!-- #EndTemplate -->
