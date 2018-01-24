<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- FAD PPM 63988 : Création d'une nouvelle jsp pour remplacer les 6 écran de recherche par une seule. -->
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
<bip:VerifUser page="jsp/eRecherche.jsp"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<!-- <link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css"> -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">
var blnVerification = false;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
	String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";

<%
	String sTitre;
	String sInitial;
	String sJobId = "e_pealfdp";
%>

function MessageInitial()
{
	var Message="<bean:write filter="false" name="editionForm" property="msgErreur" />";

	var Focus = "<bean:write name="editionForm"  property="focus" />";
	
	if (Message != "") {
		alert(Message);
	}
	
	<%
	sTitre = "Référentiels - Recherche";
	//sTitre = com.socgen.bip.metier.Report.getTitre(sJobId);
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
}

function ViderlAutreChamp(form, name)
{
	if (name == "p_param8")
		form.p_param7.value = "";
	else
		form.p_param8.value = "";
	return true;
}

function Verifier(form, bouton, flag)
{
	blnVerification = flag;
	form.action.value = bouton;
}

function ValiderEcran(form)
{
	if (!blnVerification)
	{
		form.action.value = "annuler";
	}
	else
	{
		if (form.p_param8.value == "" && form.p_param7.value == "")
		{
			alert("Vous devez saisir des caractères dans un des champs.");
			return false;
		}
		if (document.getElementById('r1').checked)
		{
			if (form.p_param8.value != "")
			{
				form.jobId.value = "e_pealfdp";
				form.p_param6.value = form.p_param8.value;
			}
			else
			{
				if (form.p_param7.value != "")
				{
					form.jobId.value = "e_eLibdpAl";
					form.p_param6.value = form.p_param7.value;
				}
			}
		}
		else
		{
			if (document.getElementById('r2').checked)
			{
				if (form.p_param8.value != "")
				{
					form.jobId.value = "e_pealfp";
					form.p_param6.value = form.p_param8.value;
				}
				else
				{
					if (form.p_param7.value != "")
					{
						form.jobId.value = "e_eLibpAl";
						form.p_param6.value = form.p_param7.value;
					}
				}
			}
			else
			{
				if (document.getElementById('r3').checked)
				{
					if (form.p_param8.value != "")
					{
						form.jobId.value = "e_pealfa";
						form.p_param6.value = form.p_param8.value;
					}
					else
					{
						if (form.p_param7.value != "")
						{
							form.jobId.value = "e_eLibaAl";
							form.p_param6.value = form.p_param7.value;
						}
					}
				}
			}
		}
	}
	return true;
}

</script>
<!-- #EndEditable --> 


</head>

<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
	<div id="mainContainer">
		<div id="topContainer" style="min-height:98%;">
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
          						<td>
          							<div id="outils" align="center"><!-- #BeginEditable "barre_haut" -->
              							<%ToolBarNew tb = new com.socgen.ich.ihm.ToolBarNew("bip_ihm",false,false,true,true,false,false,false,false,false,request) ;%>
										<%=tb.printHtml()%><!-- #EndEditable -->
									</div>
								</td>
        					</tr>
        					<tr> 
          						<td height="20" class="TitrePage"><%=sTitre%></td>
        					</tr>
        					<tr> 
        				</tr>
    					<tr> 
          					<td align="center">
								<html:form action="/edition" onsubmit="return ValiderEcran(this);">
								<!-- #BeginEditable "p_param8_hidden" -->
								<html:hidden property="arborescence" value="<%= arborescence %>"/>
								<input type="hidden" name="jobId" value="<%= sJobId %>">
								<input type="hidden" name="p_param6" value="">
								<input type="hidden" name="initial" value="<%= sInitial %>">
								<html:hidden property="action"/>
								<!-- #EndEditable -->
            					<table width="100%" border="0">
									<tr> 
										<td> 
                    						<div align="center">
												<table border=0 cellspacing=2 cellpadding=2 class="tableBleu">
													<!-- #BeginEditable "contenu" -->
													<input type="hidden" name="pageAide" value="<%= sPageAide %>">
					  								<tr>
                        								<!-- <td colspan=5 align="center">&nbsp;</td> -->
                        								<td><input type="radio" name="p_param9" id="r1" value="1" checked></td>
														<td class=texte width="155" nowrap="nowrap"> Dossier projet </td>
														<td><input type="radio" name="p_param9" id="r2" value="2"></td>
														<td class=texte width="155" nowrap="nowrap"> Projet </td>
														<td><input type="radio" name="p_param9" id="r3" value="3"></td>
														<td class=texte width="155" nowrap="nowrap"> Application </td>
                      								</tr>
                      								<tr>
                        								<td colspan=5 align="center">&nbsp;</td>
                      								</tr>
                   								</table>
                   								<table border=0 cellspacing=2 cellpadding=2 class="tableBleu">
													<tr>
														<td colspan=2></td>
                      								</tr>
													<tr>
														<td class=texte width=120 nowrap="nowrap" valign="top" align="left">Début du libellé :</td>
														<td colspan=2><html:text property="p_param8" styleClass="input"  size="50" maxlength="50" onkeyUp="return ViderlAutreChamp(this.form, this.name);"/></td>
													</tr>
													<tr>
														<td class=texte width=120 nowrap="nowrap" valign="top" align="center"><B>OU</B></td>
                    								</tr>
                    								<tr>
														<td class=texte width=120 nowrap="nowrap" valign="top" align="left">Libellé contient :</td>
														<td colspan=2><html:text property="p_param7" styleClass="input"  size="50" maxlength="50" onkeyUp="return ViderlAutreChamp(this.form, this.name);"/></td>
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
										<td>&nbsp;</td>
									</tr>
									<tr> 
										<table width="50%" border="0">
											<tr>
												<td> &nbsp; </td>
												<td> &nbsp; </td>
												<td class=texte nowrap="nowrap" align="center"><html:submit property="boutonValider" value="  Liste  " styleClass="input" onclick="Verifier(this.form, 'liste' , true);"/> </td>
												<td> &nbsp; </td> 
												<td class=texte nowrap="nowrap" align="center"><html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', false);"/> </td>
												<td> &nbsp; </td>
												<td> &nbsp; </td>
											</tr>
										</table>
									</tr>
								</table>
								</html:form>
							</td>
						</tr>
						<tr> 
							<td>&nbsp;</td>
						</tr>
						<tr> 
							<td>&nbsp;</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		</div>
	</div>
</body>
</html:html>