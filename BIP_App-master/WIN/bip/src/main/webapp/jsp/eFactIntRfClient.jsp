<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,java.util.Vector,java.util.StringTokenizer"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="editionForm" scope="request" class="com.socgen.bip.commun.form.EditionForm" />
<jsp:useBean id="listeCA" scope="request" class="com.socgen.bip.commun.liste.ListeCentreActivite" />
<html:html locale="true">
<head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>


<title>Edition</title>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<bip:VerifUser page="jsp/eFactIntRfClient.jsp"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var pageAide = "aide/hvide.htm";
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";

<%
	com.socgen.bip.user.UserBip userbip = (com.socgen.bip.user.UserBip)session.getAttribute("UserBip"); 
	java.util.Hashtable hP = new java.util.Hashtable();
	String ca_payeur = "";
	if(userbip.getCAPayeur() != null){
		ca_payeur = userbip.getCAPayeur();
	}		
	hP.put("ca_payeur", ca_payeur);
	java.util.ArrayList liste = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("ca_utilisateur_rtfe_ref",hP);
	pageContext.setAttribute("choixCA", liste); 
%>

<%
	String sTitre;
	String sInitial;
	String sJobId="eFactIntRfClient";
%>

function MessageInitial(){
	<%
		sTitre = com.socgen.bip.metier.Report.getTitre(sJobId);
		if (sTitre == null){
			//redirect sur la page d'erreur
			sTitre = "Pas de titre";
		}		
		sInitial=ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getQueryString()));
		if (sInitial == null)
			sInitial = request.getRequestURI();
		else
			sInitial = request.getRequestURI() + "?" + sInitial;
		sInitial = sInitial.substring(request.getContextPath().length());
	%>
	
	var Message="<bean:write filter="false"  name="editionForm"  property="msgErreur" />";
	var Focus = "<bean:write name="editionForm"  property="focus" />";
	
	if (Message != "") {
		alert(Message);
	}
}

function Verifier(form, bouton, flag){
  
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
          <td height="20" class="TitrePage"><%=sTitre%></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> 
            <tr> 
          	<td>
			  <html:form action="/edition"  onsubmit="return ValiderEcran(this);">
	            
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<input type="hidden" name="jobId" value="<%=sJobId%>">
	            <input type="hidden" name="initial" value="<%= sInitial %>">
            	<table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" --> 
                    <input type="hidden" name="pageAide" value="<%= sPageAide %>">
                    <!-- #EndEditable -->
                   </div>
                </td>
              </tr>
              <tr> 
                  <td> 
                    <div align="center">
                      <!-- #BeginEditable "contenu" -->
					<table border=0 cellspacing=5 cellpadding=0 class="tableBleu">
					<tr>
                        <td colspan=2 align="center">&nbsp;</td>
                    </tr>
                    <tr>
                        <td colspan=2 align="center"><b>Cet état prend en compte votre périmètre clients, et peut aussi se limiter à certains CA payeurs</b></td>
                    </tr>
					<tr>
                        <td colspan=2 align="center">&nbsp;</td>
                    </tr>
                    <tr>
	                    <td colspan=1 class="lib" align=left><b>Limitation à des CA payeurs :</b>
		            	<br>(les niveaux inférieurs sont pris en compte)</td>
		                <td colspan=1> 
		                	<html:select property="p_param6" styleClass="input">
		                		<option value="Pas de limitation" SELECTED>Pas de limitation</option>
		                		<option value="Tous">Tous</option>
		                		<html:options collection="choixCA" property="cle" labelProperty="libelle" />
		                    </html:select>			      
		                </td>
                	</tr>
                </table>
                </div>
                </td>
              </tr>
              <tr> 
                <td>&nbsp; </td>
              </tr>
              <tr> 
                  <td>  
                  <div align="center">
				  <html:submit value="Edition" styleClass="input" onclick="Verifier(this.form, 'liste', true);"/>
                  </div>
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