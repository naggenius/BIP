
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="editionForm" scope="request" class="com.socgen.bip.commun.form.EditionForm" />
<html:html locale="true">
<!-- #EndEditable --> 

<!-- #BeginTemplate "/Templates/Page_edition.dwt" --><head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<!-- #BeginEditable "doctitle" --> 
<title>Edition</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/eAmortAd.jsp"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var pageAide = "aide/dhamo_01.htm";
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";

var sListe = "";

<%
	String sTitre;
	String sInitial;
	String sJobId="eAmortAd";
%>

function MessageInitial()
{
	<%
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
	
	var Message="<bean:write filter="false"  name="editionForm"  property="msgErreur" />";
	var Focus = "<bean:write name="editionForm"  property="focus" />";
	
	if (Message != "") {
		alert(Message);
	}
}

function Verifier(form, flag)
{
  blnVerification = flag;
}

function majListe()
{
	sListe = "";	
	if (document.ckF.ck1.checked)
	{
		sListe="1";
	}
	
	if (document.ckF.ck2.checked)
	{
		if (sListe == "")
			sListe="2";
		else
			sListe = sListe + ";2";
	}
	
	if (document.ckF.ck3.checked)
	{
		if (sListe == "")
			sListe="3";
		else
			sListe = sListe + ";3";
	}
	
	if (document.ckF.ck4.checked)
	{
		if (sListe == "")
			sListe="4";
		else
			sListe = sListe + ";4";
	}
	
	// 11/2003 IAS : amtlis13 est retire
	//if (document.ckF.ck5.checked)
	//{
	//	if (sListe == "")
	//		sListe="5";
	//	else
	//		sListe = sListe + ";5";
	//}
	
	if (document.ckF.ck6.checked)
	{
		if (sListe == "")
			sListe="6";
		else
			sListe = sListe + ";6";
	}
	
	document.editionForm.listeReports.value = sListe;
}

function ValiderEcran(form)
{
	if (blnVerification == true)
	{
		if (form.listeReports.value == "")
		{
			alert("Vous devez cocher au moins une case") ;
			return false;
		}
	}
	document.editionForm.submit.disabled = true;
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" --><%=sTitre%><!-- #EndEditable --></td>
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
	<table width="100%" border="0">                
	<tr> 
		<td> 
		<div align="center">
		<form name ="ckF" action="" method="POST">
			<table border=0 cellspacing=5 cellpadding=0 class="tableBleu">
				<table border=0 cellspacing=5 cellpadding=0 width=498>
					<tr>
						<td class="lib" nowrap><B>AMTLIS01 :</B></td>
						<td class="lib">Alimentation du compte Immo. en cours</td>
						<td><input type="checkbox" name="ck1" value="1" onChange="majListe();"></td>
					</tr>
					<tr><td class="lib" nowrap><B>AMTLIS02 :</B></td>
						<td class="lib">Transfert d'immo. en cours en immo. d&eacute;finitives</td>
						<td><input type="checkbox" name="ck2" value="2" onChange="majListe();"></td>
					</tr>
					<tr><td class="lib" nowrap><B>AMTLIS03 :</B></td>
						<td class="lib">Transfert en charge (abandonn&eacute;)</td>
						<td><input type="checkbox" name="ck3" value="3" onChange="majListe();"></td>
					</tr>
					<tr><td class="lib" nowrap><B>AMTLIS04 :</B></td>
						<td class="lib">Transfert en charge (non amortis)</td>
						<td><input type="checkbox" name="ck4" value="4" onChange="majListe();"></td>
					</tr>
					<!-- IAS : amtlis13 est retire
					<tr><td class="lib" nowrap><B>AMTLIS13 :</B></td>
						<td class="lib">Idem AMTLIS01 avec toutes les dates de statuts</td>
						<td><input type="checkbox" name="ck5" value="4" onChange="majListe();"></td>
					</tr>
					-->
					<tr><td class="lib" nowrap><B>AMTCDP01 :</B></td>
						<td class="lib">Alimentation du compte Immo. en cours</td>
						<td><input type="checkbox" name="ck6" value="4" onChange="majListe();"></td>
					</tr>
				</table>
			</table>
		</form>
		</div>
		</td>
	</tr>
	</table>

	<html:form action="/edition" onsubmit="return ValiderEcran(this);"><!-- #EndEditable -->
			<!-- #BeginEditable "debut_hidden" -->
		  		
            
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<input type="hidden" name="jobId" value="<%=sJobId%>">
			<input type="hidden" name="listeReports">
			<input type="hidden" name="initial" value="<%= sInitial %>">
			<!-- #EndEditable -->
            <table width="100%" border="0">
              
                <tr> 
                  <td> 
                    <div align="center">
					<table border=0 cellspacing=2 cellpadding=2 class="tableBleu">
					<!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>">
					
					

					<!-- #EndEditable -->
			   		</table>
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
				  <html:submit value="Liste" styleClass="input" onclick="Verifier(this.form, 'liste', true);"/>
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

<!-- #EndTemplate -->