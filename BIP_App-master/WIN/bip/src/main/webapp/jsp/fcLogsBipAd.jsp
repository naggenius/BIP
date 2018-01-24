 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@page import="org.owasp.esapi.ESAPI,java.util.GregorianCalendar" %>
<%@page import="org.owasp.esapi.ESAPI,java.text.SimpleDateFormat" %>

<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"   errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="consultLogsBipForm" scope="request" class="com.socgen.bip.form.ConsultLogsBipForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_filtre_maj.dwt" --><head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>



<!-- #BeginEditable "doctitle" --> 
<title>Filtre LogsBip</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fcLogsBipAd.jsp"/> 
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
		
%>
<%! 
	GregorianCalendar cal;
	SimpleDateFormat  dateFormat;
%>
<% 

	cal = new java.util.GregorianCalendar(); 
	dateFormat = new SimpleDateFormat("dd/MM/yyyy");

%>
var pageAide = "<%= sPageAide %>";
function MessageInitial()
{
   var Message="<bean:write filter="false"  name="consultLogsBipForm"  property="msgErreur" />";
   var Focus = "<bean:write name="consultLogsBipForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
 
}
function Verifier(form, action, flag)
{
   blnVerification = flag;
   form.action.value = action;

} 
function ValiderEcran(form)
{
   if (blnVerification==true) {
	if (form.datedebut && !ChampObligatoire(form.datedebut,"la date de d�but")) return false;
	if (form.datefin && !ChampObligatoire(form.datefin,"la date de fin")) return false;
   }
   
 
   return true;
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
              <%=tb.printHtml()%> <!-- #EndEditable --></div>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Logs Application BIP<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td>
		  <!-- #BeginEditable "debut_form" -->
		  <html:form action="/LogsBip"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable -->
		  <div align="center"><!-- #BeginEditable "contenu" -->
           <input type="hidden" name="pageAide" value="<%= sPageAide %>">
           
<html:hidden property="arborescence" value="<%= arborescence %>"/>
           
              <html:hidden property="action" />
			<table border=0  cellpadding=2 cellspacing=2 class="tableBleu">
                
                <tr> 
                  <td align=center >&nbsp;</td>
                  <td >&nbsp;</td>
                </tr>
                <tr> 
                  <td >&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td align=right><b>Date Debut Traitement
                    : &nbsp </b></td>
                  <td> 
                  	<%cal.add(cal.DATE, -1 ); %>
                     <html:text property="datedeb" styleClass="input" size="10" maxlength="10" value="<%= dateFormat.format(cal.getTime()) %>" onchange="return VerifierDate(this,'jj/mm/aaaa');"/>
                      
				</td>
                </tr>
                <tr> 
                  <td align=right><b>Date Fin Traitement
                    : &nbsp </b></td>
                  <td> 
                 
                  	<%cal.add(cal.DATE, 1 ); %>
                      <html:text property="datefin" styleClass="input" size="10" maxlength="10" value="<%= dateFormat.format(cal.getTime()) %>" onchange="return VerifierDate(this,'jj/mm/aaaa');"/>
                      
				</td>
                </tr>
                <tr> 
                  <td align=center>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td align=center>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td align=center>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
              </table>
			  <!-- #EndEditable --></div>
          	
		</td>
		</tr>
		<tr>
		<td align="center">

		<table width="100%" border="0">
		
                <tr> 
                  <td width="33%" align="center">  
                	 <html:submit property="boutonConsulter" value="Consulter" styleClass="input" onclick="Verifier(this.form, 'suite', true);"/>
                  </td>
				</tr>
            
            </table>
		</html:form>
			  <!-- #BeginEditable "fin_form" -->
	
		<!-- #EndEditable -->
          </td>
        </tr>
		<tr> 
          <td>&nbsp;  
          </td>
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