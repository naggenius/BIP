<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="extractionForm" scope="request" class="com.socgen.bip.commun.form.ExtractionForm" />
<html:html locale="true">
<!-- #EndEditable --> 

<head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<!-- #BeginEditable "doctitle" --> 
<title>Extraction</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!-- #BeginEditable "fichier" -->
<bip:VerifUser page="jsp/xLigneFactAd.jsp"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
var tabVerif = new Object();
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	
	com.socgen.bip.user.UserBip user = (com.socgen.bip.user.UserBip)session.getAttribute("UserBip") ;
	com.socgen.bip.menu.item.BipItemMenu menu = user.getCurrentMenu();
	String menuId = menu.getId();
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
		sJobId = "xLigneFactAd";
	
		sTitre = com.socgen.bip.metier.Report.getTitre(sJobId);
		if (sTitre == null)
		{
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

	var Message="<bean:write filter="false"  name="extractionForm"  property="msgErreur" />";
	var Focus = "<bean:write name="extractionForm"  property="focus" />";
   
   if (Message != "") {
      alert(Message);
   }

	if (Focus != "") {
		if (eval( "document.forms[0]."+Focus )){
			(eval( "document.forms[0]."+Focus )).focus();
		}
	}	
}

function Verifier(form, flag)
{
//MAJTypeExtract(form)
  blnVerification = flag;
}

function ValiderEcran(form) {
	document.extractionForm.submit.disabled = true;
	return true;
}

function rechercheDPG(){
	window.open("/recupDPG.do?action=initialiser&nomChampDestinataire=p_param11&windowTitle=Recherche Code DPG Fournisseur&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
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
		  <html:form action="/extract"  onsubmit="return ValiderEcran(this);">
			<!-- #BeginEditable "debut_hidden" -->	
            
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<input type="hidden" name="jobId" value="<%=sJobId%>">
            <input type="hidden" name="initial" value="<%= sInitial %>">
            <input type="hidden" name="pageAide" value="<%= sPageAide %>">
            <input type="hidden" name="p_param12" value="<%= menuId %>">
            <input type="hidden" name="listeReports" value="1">
			<!-- #EndEditable -->

            <table width="100%" border="0">
                <tr> 
                  <td> 
                    <div align="center">
                      <!-- #BeginEditable "contenu" -->
					<table border=0 cellspacing=5 cellpadding=0 class="tableBleu">
						<tr>
                        	<td colspan=2 align="center">&nbsp;</td>
                    	</tr>
						<tr>
                  			<td class=lib>
                  				<b>Date d'enregistrement comptable sup�rieure � :</b>
                  			</td>
                  			<td>
                  				<html:text property="p_param7" styleClass="input" size="11" maxlength="10" onchange="return VerifierDate( this, 'jj/mm/aaaa' );"/> 
                  			</td>
                    	</tr>
						<tr>
                  			<td class=lib>
                  				<b>Date d'enregistrement comptable inf�rieure � :</b>
                  			</td>
                  			<td>
                  				<html:text property="p_param8" styleClass="input" size="11" maxlength="10" onchange="return VerifierDate( this, 'jj/mm/aaaa' );"/> 
                  			</td>
                    	</tr>
                    	<tr>
                        	<td colspan=2 align="center">&nbsp;</td>
                    	</tr>
						<tr>
                  			<td class=lib>
                  				<b>Date de prestation sup�rieure � :</b>
                  			</td>
                  			<td>
                  				<html:text property="p_param9" styleClass="input" size="11" maxlength="10" onchange="return VerifierDate( this, 'jj/mm/aaaa' );"/> 
                  			</td>
                    	</tr>
						<tr>
                  			<td class=lib>
                  				<b>Date de prestation inf�rieure � :</b>
                  			</td>
                  			<td>
                  				<html:text property="p_param10" styleClass="input" size="11" maxlength="10" onchange="return VerifierDate( this, 'jj/mm/aaaa' );"/> 
                  			</td>
                    	</tr>                    	
                    	<tr>
                        	<td colspan=2 align="center">&nbsp;</td>
                    	</tr>
                    	<tr>
                  			<td class=lib >
                  				<b>Code DPG du contrat :</b>
                  			</td>
                  			<td>
                  				<html:text property="p_param11" styleClass="input" size="8" maxlength="7" onchange="return Ctrl_dpg_generique(this);"/>
                  				<a href="javascript:rechercheDPG();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code DPG" title="Rechercher Code DPG" align="absbottom"></a>
                  			</td>
                    	<tr>
                        	<td colspan=2 align="center">&nbsp;</td>
                    	</tr>
			   		</table>
					
					  <!-- #EndEditable -->
					</div>
                  </td>
                </tr>
				<tr> 
          		  <td>&nbsp;  
          		  </td>
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