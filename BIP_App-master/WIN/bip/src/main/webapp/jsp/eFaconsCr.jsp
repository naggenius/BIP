
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,com.socgen.bip.user.UserBip"    errorPage="../jsp/erreur.jsp"  %>
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
<bip:VerifUser page="jsp/eFaconsCr.jsp"/>
<jsp:useBean id="UserBip" scope="session" class="com.socgen.bip.user.UserBip" />
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var pageAide = "aide/hvide.htm";
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
	String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";

var blnVerifFormat  = true;
var tabVerif        = new Object();

<%
	String menuCourant = ((UserBip) session.getAttribute("UserBip")).getCurrentMenu().getId();
	String sTitre;
	String sInitial;
	String sJobId="e_pefacons";
    
	// si menu Ordonnancement controle different jobid = e_pefacons_ord
	if ("ACH".equals(menuCourant)) {
		sJobId="e_pefacons_ord";
	} else {
		sJobId="e_pefacons";
	}
    
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
	
	tabVerif["p_param6"] = "Ctrl_dpg_generique(document.editionForm.p_param6)";
	
	var Message="<bean:write filter="false"  name="editionForm"  property="msgErreur" />";
	var Focus = "<bean:write name="editionForm"  property="focus" />";
	
	if (Message != "") {
		alert(Message);
	}
	else {
		document.editionForm.p_param6.value = Replace_DoubleZero_by_DoubleEtoile( "<bean:write name="UserBip"  property="dpg_Defaut" />" );
	}
	if (Focus != "") (eval( "document.editionForm."+Focus )).focus();
	else {
		document.editionForm.p_param6.focus();
	}
}

function Verifier(form, bouton, flag)
{
  blnVerification = flag;
  //form.BOUTON.value = bouton;
}

function majListe()
{
	sListe = "";
	if (document.editionForm.p_param7[0].checked)
	{
		//alert("N");
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
	}
	else	//N1
	{
		//alert("N1");
		if (document.ckF.ck1.checked)
		{
			sListe="5";
		}
		
		if (document.ckF.ck2.checked)
		{
			if (sListe == "")
				sListe="6";
			else
				sListe = sListe + ";6";
		}
		
		if (document.ckF.ck3.checked)
		{
			if (sListe == "")
				sListe="7";
			else
				sListe = sListe + ";7";
		}
		
		if (document.ckF.ck4.checked)
		{
			if (sListe == "")
				sListe="8";
			else
				sListe = sListe + ";8";
		}
	}
	//alert(sListe);
	document.editionForm.listeReports.value = sListe;
}

function ValiderEcran(form)
{
	if (blnVerification)
	{
		if ( !VerifFormat(null) ) return false;
		if (!ChampObligatoire(form.p_param6, "un code DPG")) return false;
		if (form.p_param6.value=='******')
		{
			alert('Entrez un autre code DPG');
			form.p_param6.value='';
			form.p_param6.focus();
			return false;
		}
		
		if (form.listeReports.value == "")
		{
			alert("Vous devez cocher au moins une case") ;
			return false;
		}
	}

	//form.VerifExecJS.value = 1;
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
				<table border=0 cellspacing=5 cellpadding=0 width=570>
					<tr>
						<td class="lib" nowrap><B>FACONS :</B></td>
						<td class="lib">Non rapprochement BIP (Hors derni&egrave;re mensuelle)</td>
						<td><input type="checkbox" name="ck1" value="1" onChange="majListe();"></td>
					</tr>
					<tr><td class="lib" nowrap><B>FACONS2 :</B></td>
						<td class="lib">Rapprochement BIP (Factur&eacute; = Consomm&eacute;) (Hors derni&egrave;re mensuelle)</td>
						<td><input type="checkbox" name="ck2" value="2" onChange="majListe();"></td>
					</tr>
					<tr><td class="lib" nowrap><B>FACONS :</B></td>
						<td class="lib">Non rapprochement BIP Annuel</td>
						<td><input type="checkbox" name="ck3" value="3" onChange="majListe();"></td>
					</tr>
					<tr><td class="lib" nowrap><B>FACONS2 :</B></td>
						<td class="lib">Rapprochement BIP (Facturé = Consommé ) Annuel</td>
						<td><input type="checkbox" name="ck4" value="4" onChange="majListe();"></td>
					</tr>
				</table>
			</table>
		</form>
		</div>
		</td>
	</tr>
	</table>
		<html:form action="/edition"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable -->
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
					<tr>
						<td/>
						<td colspan=2 align=middle class="lib"><b>Ann&eacute;e courante<input type="radio" name="p_param7" value="N" checked onChange="majListe();"></b></td>
						<td colspan=2 align=middle class="lib"><b>Ann&eacute;e pr&eacute;c&eacute;dente<input type="radio" name="p_param7" value="N1" onChange="majListe();"></b></td>
					</tr>
					<tr>
						<!--<td>&nbsp;</td>-->
						<td class="lib"><B>Code DPG :</B></td>
						<td><html:text property="p_param6" styleClass="input"  size="7" maxlength="7" onchange="return VerifFormat(this.name);"/></td>
					</tr>

					  <tr>
                        <td colspan=5 align="center">&nbsp;</td>
                      </tr>
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