
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
<bip:VerifUser page="jsp/eJhAd.jsp"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var pageAide = "aide/hvide.htm";
var blnVerification = true;
var blnVerifFormat  = true;
var tabVerif        = new Object();

<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";

var sListe = "";

<%
	String sTitre;
	String sInitial;
	String sJobId="e_dbjhedi";
	com.socgen.bip.user.UserBip user = (com.socgen.bip.user.UserBip)session.getAttribute("UserBip") ;
	String sDpg = user.getDpg_Defaut();
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
	
	//Affichage du DPG par défaut
	document.editionForm.p_param6.value = Replace_DoubleZero_by_DoubleEtoile( "<bean:write name="UserBip"  property="dpg_Defaut" />" );
	if (Focus != "") (eval( "document.editionForm."+Focus )).focus();
}

function Verifier(form, bouton, flag)
{
  blnVerification = flag;
  //form.BOUTON.value = bouton;
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

	document.editionForm.listeReports.value = sListe;
}

function ValiderEcran(form)
{
	if (blnVerification)
	{
		if (sListe == "")
		{
			alert("Vous devez cocher au moins une case");
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
		<form name ="ckF" action="">
			<table border=0 cellspacing=5 cellpadding=0 class="tableBleu">
				<table border=0 cellspacing=5 cellpadding=0 width=498>
					<tr>
						<td class="lib" nowrap><B>NOGIP :</B></td>
						<td class="lib">Agents BIP absents de la GIP</td>
						<td><input type="checkbox" name="ck1" value="1" onChange="majListe();"></td>
					</tr>
					<tr><td class="lib" nowrap><B>NOBIP :</B></td>
						<td class="lib">Agents GIP absents de la BIP</td>
						<td><input type="checkbox" name="ck2" value="2" onChange="majListe();"></td>
					</tr>
					<tr><td class="lib" nowrap><B>ANOMALIES :</B></td>
						<td class="lib">Liste des anomalies</td>
						<td><input type="checkbox" name="ck3" value="3" onChange="majListe();"></td>
					</tr>
					<tr><td class="lib" nowrap><B>VALIDATIONS :</B></td>
						<td class="lib">Listes des validations</td>
						<td><input type="checkbox" name="ck4" value="4" onChange="majListe();"></td>
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
					
					<tr>
                        <td colspan=5 align="center"></td>
                      </tr>
					<tr> 
						<td align=right><b>Code DPG : </b></td>
						<td> <html:text property="p_param6" styleClass="input" size="7" maxlength="7" onchange="return VerifFormat(this.name);"/> </td>
					</tr>
					  <tr>
                        <td colspan=5 align="center"></td>
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