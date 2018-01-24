
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
<bip:VerifUser page="jsp/eFacrecOr.jsp"/>
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
	String sTitre;
	String sInitial;
	String sJobId="e_aefacrec";
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
	
	tabVerif["p_param6"] = "VerifierAlphaMax(document.editionForm.p_param6)";
	tabVerif["p_param7"] = "VerifierAlphaMaxCarSpec(document.editionForm.p_param7)";
	tabVerif["p_param9"] = "VerifierDate2(document.editionForm.p_param9,'jjmmaaaa')";
	
	
	if(document.forms[0].p_param8[0].checked == true)
         document.forms[0].p_param8[0].checked = true;
   else
        document.forms[0].p_param8[1].checked = true;
	
	var Message="<bean:write filter="false"  name="editionForm"  property="msgErreur" />";
	var Focus = "<bean:write name="editionForm"  property="focus" />";
	
	if (Message != "") {
		alert(Message);
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

function ValiderEcran(form)
{
	if (blnVerification)
	{
	if(form.p_param10.value == "") {
	
		if ( !VerifFormat(null) ) return false;
		if (!ChampObligatoire(form.p_param6, "un code société")) return false;
		if (!ChampObligatoire(form.p_param7, "un numéro de facturation")) return false;
		if (!ChampObligatoire(form.p_param9, "une date de facturation")) return false;
	
	}
	}
	//form.VerifExecJS.value = 1;
	//document.editionForm.submit.disabled = true;
	return true;
}

function rechercheSocieteID(){
	window.open("/recupIdSociete.do?action=initialiser&nomChampDestinataire=p_param6&windowTitle=Recherche Identifiant Societe&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
}  

function nextFocusNumfact(){
	document.forms[0].p_param7.focus();
}


function rechercheFacture(){

   var typeFacture;
   
   if (document.forms[0].p_param6.value == '')  {
      alert("Veuillez saisir le code de la société");
      document.forms[0].p_param6.focus();
   }
   else
   {
   
   		if(document.forms[0].p_param8[0].checked == true)
      		typeFacture = "F";
   		else  
      		typeFacture = "A";
      		
      	
		window.open("/recupFacture.do?action=initialiser&socfact="+document.forms[0].p_param6.value+"&typeFacture="+typeFacture+"&nomChampDestinataire=p_param7&nomChampDestinataire2=p_param9&windowTitle=Recherche &habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=700, height=600") ;
	}
}  

function nextFocusDatfact(){
	document.forms[0].p_param9.focus();
}


/** Pour vider les champs  */
function viderChamps(elt) {
	
	if (elt.value != '') {
		if (elt.name == 'p_param10') {
			document.getElementsByName('p_param6')[0].value = '';
			document.getElementsByName('p_param7')[0].value = '';
			document.getElementsByName('p_param9')[0].value = '';
			
		}
		else if (elt.name == 'p_param6' || elt.name == 'p_param7' || elt.name == 'p_param9') {
			document.getElementsByName('p_param10')[0].value = '';
		}		
	}	
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
			<input type="hidden" name="p_param5" value="<bean:write name="UserBip"  property="centre_Frais" />">
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
                        <td colspan=5 align="center">&nbsp;</td>
                      </tr>
					<tr>
						<td class="lib"><b>Code soci&eacute;t&eacute; :</b></td>
						<td colspan=2><html:text property="p_param6" styleClass="input"  size="4" maxlength="4" onkeyUp="viderChamps(this);" onblur="viderChamps(this);" onchange="return VerifFormat(this.name);"/>
						&nbsp;&nbsp;<a href="javascript:rechercheSocieteID();" onFocus="javascript:nextFocusNumfact();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code Société" title="Rechercher Code Société" align="absbottom"></a>  
						</td>   
					</tr>
					
					<tr>
						<td class="lib"><b>Type de facture :</b></td>
						<td><input type="radio" name="p_param8" value="F" checked>
                          Facture 
                          <input type="radio" name="p_param8" value="A">Avoir</td>
					</tr>
					
					<tr>
						<td class="lib"><b>N&deg; de facture :</b></td>
						<td colspan=2><html:text property="p_param7" styleClass="input"  size="15" maxlength="15" onkeyUp="viderChamps(this);" onblur="viderChamps(this);" onchange="return VerifFormat(this.name);"/>
						 &nbsp;&nbsp;<a href="javascript:rechercheFacture();" onFocus="javascript:nextFocusDatfact();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Facture" title="Rechercher Facture" align="absbottom"></a>           
	                    </td> 				
					</tr>
					
					<tr>
						<td class="lib"><b>Date de facture :</b></td>
						<td colspan=2><html:text property="p_param9" styleClass="input"  size="10" maxlength="10" onkeyUp="viderChamps(this);" onblur="viderChamps(this);" onchange="return VerifFormat(this.name);"/></td>
					</tr>
					
					 <tr>
                        <td colspan=5 align="center">&nbsp;</td>
                     </tr>
		            <tr> 
    	              <td align=center><u><b>OU</b></u></td>
	                </tr>
					 
					 <tr>
                        <td colspan=5 align="center">&nbsp;</td>
                     </tr>
                     					
					<tr>
						<td class="lib"><b>N&deg; Expense :</b></td>
						<td colspan=2><html:text property="p_param10" styleClass="input"  size="9" maxlength="8" onkeyUp="viderChamps(this);" onblur="viderChamps(this);" onchange="return VerifFormat(this.name);"/></td>
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