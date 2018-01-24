<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.util.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="suivInvExtractionForm" scope="request" class="com.socgen.bip.form.SuivInvExtractionForm" />
<jsp:useBean id="listeCA" scope="request" class="com.socgen.bip.commun.liste.ListeCentreActivite" />
<html:html locale="true">
<!-- #EndEditable --> 

<head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<!-- #BeginEditable "doctitle" --> 
<title>Extraction</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!-- #BeginEditable "fichier" -->
<bip:VerifUser page="jsp/xSuivInvLb.jsp"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
var tabVerif = new Object();
var anneeCourante = '<bip:value champ="to_char(datdebex, 'YYYY')" table="datdebex" clause1="1" clause2="1" />';
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";
<%
	String sTitre;
	String sInitial;
	String sJobId;
%>


function MessageInitial()
{
	<%
		sJobId = "xSuivInvLb";
	
		sTitre = com.socgen.bip.metier.Report.getTitre(sJobId);
		if (sTitre == null)
		{
			//redirect sur la page d'erreur
			//sTitre = "Pas de titre";
			sTitre =  "Demandes d'Extraction";
		}		
		sInitial=ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getQueryString()));
		if (sInitial == null)
			sInitial = request.getRequestURI();
		else
			sInitial = request.getRequestURI() + "?" + sInitial;
		sInitial = sInitial.substring(request.getContextPath().length());
	%>
	
	var Message="<bean:write filter="false"  name="suivInvExtractionForm"  property="msgErreur" />";
	var Focus = "<bean:write name="suivInvExtractionForm"  property="focus" />";
	

	if (Message != "") {
		alert(Message);
	}

	if (Focus != "") {
		if (eval( "document.forms[0]."+Focus )){
			(eval( "document.forms[0]."+Focus )).focus();
		}
	}
	
	document.forms[0].p_param8.value = anneeCourante;
	
}

function Verifier(form, flag)
{
  blnVerification = flag;
}

function ValiderEcran(form) {
	form.codcamo.value = form.p_param7.value;
	if ( !confirm("Confirmez-vous la demande d'extraction ?") ) return false;
	document.suivInvExtractionForm.submit.disabled = true;
	return true;
}


</script>

<!-- #EndEditable --> 


</head>

<%
  String annee = com.socgen.bip.commun.Tools.getStrDateAAAA(0);
  request.setAttribute("p_param7", annee);

  com.socgen.bip.user.UserBip userbip = (com.socgen.bip.user.UserBip)session.getAttribute("UserBip");  

	String ca_suivi="";
	Vector v = new Vector();
	v=userbip.getCa_suivi();

	for (Enumeration e = v.elements(); e.hasMoreElements();) {
		ca_suivi +=',' +(String) e.nextElement();
	}
	java.util.Hashtable hP = new java.util.Hashtable();
	hP.put("ca_suivi", ca_suivi);

  java.util.ArrayList liste = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("ca_inv_g",hP); 
  pageContext.setAttribute("choixCA", liste); 
%>

<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();ChargeCa('<%=userbip.getCodcamoCourant()%>','p_param7',document.forms[0])">
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
				<%=tb.printHtml()%><!-- #EndEditable -->
			</div>
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
            
          </td>
        </tr>
        <tr> 
          <td>
		  <html:form action="/suivinvextract"  onsubmit="return ValiderEcran(this);">
			<!-- #BeginEditable "debut_hidden" -->	
            
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<input type="hidden" name="jobId" value="<%=sJobId%>">
            <input type="hidden" name="initial" value="<%= sInitial %>">
            <input type="hidden" name="pageAide" value="<%= sPageAide %>">
            <input type="hidden" name="p_param6" value=".CSV">
			<!-- #EndEditable -->

            <table width="100%" border="0">
                <tr> 
                  <td> 
                    <div align="center">
                      <!-- #BeginEditable "contenu" -->
					<table border=0 cellspacing=2 cellpadding=2 class="tableBleu">
					<tr>
                        <td colspan=5 align="center">&nbsp;</td>
                    </tr>
                    <tr>
				<td class="lib"><b>Centre d'activit&eacute; :</b></td>
				<td> <html:select property="p_param7" styleClass="input"> 
				<html:options collection="choixCA" property="cle" labelProperty="libelle" />
				</html:select><html:hidden property="codcamo"/> 			      
				</td>
				<td colspan="2">&nbsp;</td>	
				<td class="lib" width="15%"><b>Exercice :</b></td>
				<td>                        	
				 <html:text property="p_param8" styleClass="input" size="4" maxlength="4" onchange="return VerifierDate(this,'aaaa');"/>                  			
				</td>
			</tr>
	
   		</table>
		
		  <!-- #EndEditable -->
		</div>
                  </td>
                </tr>
		<tr> 
			<td>&nbsp;</td>
		</tr>
                <tr> 
                  <td>  
                  <div align="center">
				  <html:submit value="Extraire" styleClass="input" onclick="Verifier(this.form, true);"/>
                  </div>
                  </td>
                </tr>
            
            </table>
			  <!-- #BeginEditable "fin_form" --></html:form><!-- #EndEditable -->
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

