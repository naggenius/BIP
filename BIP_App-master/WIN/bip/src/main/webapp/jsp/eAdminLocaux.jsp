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
<title>Extraction</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/eAdminLocaux.jsp"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var pageAide = "aide/hvide.htm";
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
	String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	
	com.socgen.bip.user.UserBip userbip = (com.socgen.bip.user.UserBip)session.getAttribute("UserBip") ;
	com.socgen.bip.menu.item.BipItemMenu menu = userbip.getCurrentMenu();
	String menuId = menu.getId();
	
%>
var pageAide = "<%= sPageAide %>";

var blnVerifFormat  = true;
var tabVerif		= new Object();

<%
	String sTitre;
	String sInitial;
	String sJobId;
%>

function MessageInitial()
{
	<%
	
		if ( menuId.equals("DIR") ) {
			sJobId = "eAdmLoc";
		} else {
			sJobId = "eAdmLoc_me";
		}
	
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
	
	if ( document.editionForm.p_param7.value == "") {
		document.editionForm.p_param7.value = "3";
	}
	
	document.editionForm.p_param6.focus();
	
}

function verif_nb_mois() {

	if ( document.editionForm.p_param7.value != "" ) {	
		if ( !verif_numeric(document.editionForm.p_param7.value) ) {
			alert('Le nombre de mois doit être numérique.');
			document.editionForm.p_param7.focus();
			return false;
		}
		
		if ( document.editionForm.p_param7.value < 1 || document.editionForm.p_param7.value > 13 ) {
			alert('Le nombre de mois doit être compris entre 1 et 13 - veuillez corriger.');
			document.editionForm.p_param7.focus();
			return false;
			
		}
	}
	
	return true;
	
}

function Ctrl_dpg() {

	var RE = new RegExp('[0-9]{7}|[0-9]{6}\\*{1}|[0-9]{5}\\*{2}|[0-9]{4}\\*{3}|[0-9]{3}\\*{4}|[0-9]{2}\\*{5}|[0-9]{1}\\*{6}|\\*{7}');
   if ( !RE.test(document.editionForm.p_param6.value) ) {
	alert('Saisie invalide - Attention le code DPG est sur 7 caractères ( N******, ... , NNNNNN* , NNNNNNN )');
	document.editionForm.p_param6.focus();
	return false;
   }
   return true;
   
}

function ValiderEcran(form)
{
	if (blnVerification)
	{
		if ( !VerifFormat(null) ) return false;
		
		if ( form.p_param6.value=="" )
		{
			alert("Veuillez saisir le DPG.");
			document.editionForm.p_param6.focus();
			return false;
		}

		if ( document.editionForm.p_param7.value == "" )
		{
			alert("Veuillez saisir le nombre de mois.");
			document.editionForm.p_param7.focus();
			return false;
			
		} 
		
		if ( !Ctrl_dpg() ) {
			return false;
		}
				
		if ( !verif_nb_mois() ) {
			return false;
		}
			
		if ( !confirm("Confirmez-vous la demande d'extraction ?") ) return false;
	}

	return true;
}

function rechercheDPG(){
	window.open("/recupDPG.do?action=initialiser&nomChampDestinataire=p_param6&windowTitle=Recherche Code DPG Fournisseur&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
}

function nextFocusDPG(){
	document.forms[0].p_param7.focus();
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
		  <!-- #BeginEditable "debut_form" --><html:form action="/edition"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable -->
			<!-- #BeginEditable "debut_hidden" -->
		  		
            
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<input type="hidden" name="jobId" value="<%=sJobId%>">
            <input type="hidden" name="initial" value="<%= sInitial %>">
			<!-- #EndEditable -->
            <table width="100%" border="0">
              
                <tr> 
                  <td> 
                    <div align="center">
					<table border=0 cellspacing=2 cellpadding=2 class="tableBleu">
					<!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>">
					<tr><td colspan=5 align=center>&nbsp;</td></tr><tr>
					<tr>
						<td class="lib"><b>Code DPG :</b></td>
						<td><html:text property="p_param6" styleClass="input"  size="7" maxlength="7"/>
						    &nbsp;&nbsp;<a href="javascript:rechercheDPG();" onFocus="javascript:nextFocusDPG();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code DPG" title="Rechercher Code DPG" align="absbottom"></a>
						</td>
						<td>&nbsp;</td>
						<td>Code DPG existant,<br> 
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;éventuellement générique par 1 ou plusieurs * à la fin.
					</tr>
					
					<tr><td colspan="4">&nbsp;</td>
											
					</tr>
					<tr>
						<td class="lib"><b>Nb de mois du passé :</b></td>
						<td><html:text property="p_param7" styleClass="input"  size="5" maxlength="5"/>						    
						</td>
						<td>&nbsp;</td>
						<td>Nb de mois à rechercher dans le passé, à compter de ce jour.<br> 
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Saisir un nombre entre 1 et 13.

					</tr>
					<tr><td colspan=5 align=center>&nbsp;</td></tr><tr>

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
				  <html:submit value="Valider" styleClass="input"/>
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