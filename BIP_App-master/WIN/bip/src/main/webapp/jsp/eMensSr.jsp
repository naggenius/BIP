
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
<bip:VerifUser page="jsp/eMensSr.jsp"/>
<%
	java.util.Hashtable hP = new java.util.Hashtable();
	hP.put("userid", ((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
	java.util.ArrayList listeCPIdent = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("isac_cpident", hP); 
	pageContext.setAttribute("choixCPIdent", listeCPIdent);
%>
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

var sListe = "";

<%
	String sTitre;
	String sInitial;
	String sJobId="eMensSr";
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
	if (Focus != "") (eval( "document.editionForm."+Focus )).focus();
	
	all = new Option("Tous", "Tous");
	if (document.editionForm.p_param7.length>1)
		document.editionForm.p_param7.options[document.editionForm.p_param7.length] = all;
}

function Verifier(form, bouton, flag)
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
	
	document.editionForm.listeReports.value = sListe;
}

function ValiderEcran(form)
{
	var compt = 0;
	if (blnVerification)
	{
		if (form.listeReports.value == "")
		{
			alert("Vous devez cocher au moins une case") ;
			return false;
		}		
		if ( !confirm("Confirmez-vous la demande d'édition ?") ) return false;
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
					<table border=0 cellspacing=5 cellpadding=0  class="tableBleu" width=498>
						<tr>
							<td class="lib" nowrap><B>D&eacute;tail des lignes BIP :</B></td>
							<td><input type="checkbox" name="ck1" value="1" onChange="majListe();"></td>
						</tr>
						<tr>
							<td class="lib" nowrap><B>Historique ressources par C.P :</B></td>
							<td><input type="checkbox" name="ck2" value="2" onChange="majListe();"></td>
						</tr>
						<tr>
							<td class="lib" nowrap><B>PCA4 avec sous-traitance :</B></td>
							<td><input type="checkbox" name="ck3" value="3" onChange="majListe();"></td>
						</tr>
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
						<td class="lib"><b>Chef de projet :</b></td>
						<td>
							<html:select property="p_param7" styleClass="input"> 
							<html:options collection="choixCPIdent" property="cle" labelProperty="libelle" />
							</html:select>
						</td>
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