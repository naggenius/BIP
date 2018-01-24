
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
<bip:VerifUser page="jsp/eFactOr.jsp"/>
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
	String sJobId="e_aefact";
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
	tabVerif["p_param7"] = "VerifierDate2(document.editionForm.p_param7,'jjmmaaaa')";
	tabVerif["p_param8"] = "VerifierDate2(document.editionForm.p_param8,'jjmmaaaa')";
	tabVerif["p_param9"] = "VerifierDate2(document.editionForm.p_param9,'jjmmaaaa')";
	tabVerif["p_param10"] = "VerifierDate2(document.editionForm.p_param10,'jjmmaaaa')";
	tabVerif["p_param11"] = "VerifierNum(document.editionForm.p_param11,7,0)";
	tabVerif["p_param13"] = "VerifierAlphaMax(document.editionForm.p_param13)";
	tabVerif["p_param14"] = "VerifierNum(document.editionForm.p_param14,6,0)";
	tabVerif["p_param15"] = "VerifierAlphaMax(document.editionForm.p_param15)";
	
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
   if (blnVerification) {
        if ( !VerifFormat(null) ) return false;
   }
   //form.VerifExecJS.value = 1;
	document.editionForm.submit.disabled = true;
   return true;
}


function rechercheSocieteID(){
	window.open("/recupIdSociete.do?action=initialiser&nomChampDestinataire=p_param6&windowTitle=Recherche Identifiant Societe&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
}  

function nextFocusLoupeSociete(){
	document.forms[0].p_param7.focus();
}


function rechercheCodeComptable(){
	window.open("/recupCodeCompta.do?action=initialiser&nomChampDestinataire=p_param13&windowTitle=Recherche Code Comptable&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=600") ;
}  

function nextFocusCodeCompta(){
	document.forms[0].p_param14.focus();
}

function rechercheDPG()
{
	window.open("/recupDPG.do?action=initialiser&nomChampDestinataire=p_param11&windowTitle=Recherche Code DPG&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
}

function nextFocusCodeDPG(){
	document.forms[0].p_param11.focus();
}

function resetAutreChamp(){
	document.forms[0].p_param6.value="";
	document.forms[0].p_param7.value="";
	document.forms[0].p_param8.value="";
	document.forms[0].p_param9.value="";
	document.forms[0].p_param10.value="";
	document.forms[0].p_param11.value="";
	document.forms[0].p_param12.value="";
	document.forms[0].p_param13.value="";
	document.forms[0].p_param14.value="";
	
}

function resetNumExpense(){
	document.forms[0].p_param15.value="";
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
					  <tr>
                        <td colspan=5 align="center">&nbsp;</td>
                      </tr>
					<tr>
						<td class="lib">Code soci&eacute;t&eacute; :</td>
						<td colspan=5><html:text property="p_param6" styleClass="input"  size="4" maxlength="4" onchange="resetNumExpense();return VerifFormat(this.name);"/>
						<a href="javascript:rechercheSocieteID();" onFocus="javascript:nextFocusLoupeSociete();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code Société" title="Rechercher Code Société" align="absbottom"></a> 
                        </td>                       <!-- SOCCONT -->
					</tr>
					<tr>
						<td colspan=2 class="lib">Dates d'enregistrement comptable :</td>
						<td class="lib">D&eacute;but :</td>
						<td><html:text property="p_param7" styleClass="input"  size="10" maxlength="10" onchange="resetNumExpense();return VerifFormat(this.name);"/></td>       <!-- FENRCOMPTA1 -->
					
						<td class="lib">Fin :</td>
						<td><html:text property="p_param8" styleClass="input"  size="10" maxlength="10" onchange="resetNumExpense();return VerifFormat(this.name);"/></td>       <!-- FENRCOMPTA2 -->
					</tr>
					<tr>
						<td colspan=2 class="lib">P&eacute;riode de prestation :</td>
						<td class="lib">D&eacute;but :</td>
						<td><html:text property="p_param9" styleClass="input"  size="10" maxlength="10" onchange="resetNumExpense();return VerifFormat(this.name);"/></td>       <!-- LMOISPREST1 -->
					
						<td class="lib">Fin :</td>
						<td><html:text property="p_param10" styleClass="input"  size="10" maxlength="10" onchange="resetNumExpense();return VerifFormat(this.name);"/></td>     <!-- LMOISPREST2 -->
					</tr>
					<tr>
						<td class="lib">Code DPG :</td>
						<td><html:text property="p_param11" styleClass="input"  size="7" maxlength="7" onchange="resetNumExpense();return VerifFormat(this.name);"/> 
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:rechercheDPG();" onFocus="javascript:nextFocusCodeDPG();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code DPG" title="Rechercher Code DPG" align="absbottom"></a>   
                        </td>                       <!-- FDEPPOLE -->
					
						<td colspan=2 class="lib">R&eacute;f&eacute;renc&eacute;es :</td>
						<td colspan=2>
							<select name="p_param12" class="input" size=1 onchange="resetNumExpense();">                      <!-- SOCNAT -->
								<option value="O">Oui</option>
								<option value="N">Non</option>
								<option value=" " selected>&nbsp;</option>
							</select>
						</td>
					</tr>
					<tr>
						<td width=110 class="lib">Code comptable :</td>
						<td><html:text property="p_param13" styleClass="input"  size="11" maxlength="11" onchange="resetNumExpense();return VerifFormat(this.name);"/>
						<a href="javascript:rechercheCodeComptable();" onFocus="javascript:nextFocusCodeCompta();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code Comptable" title="Rechercher Code Comptable" align="absbottom"></a> 
						</td>             <!-- LCODCOMPTA -->
					
						<td colspan=2 class="lib">Montant HT minimum :</td>
						<td colspan=2><html:text property="p_param14" styleClass="input"  size="6" maxlength="6" onchange="resetNumExpense();return VerifFormat(this.name);"/></td>                     <!-- FMONTHT -->
					</tr>
					  <tr>
                        <td colspan=5 align="center">&nbsp;</td>
                      </tr>
                       <tr>
                        <td colspan=5 align="center"><b>OU</b></td>
                      </tr>
                       <tr>
                        <td colspan=5 align="center">&nbsp;</td>
                      </tr>
                      <tr> 
                       <td>&nbsp;</td>
                        <td class="lib">N° Expense :</td>
                        <td colspan=2> 
                        <html:text property="p_param15" styleClass="input"  size="8" maxlength="8" onchange="resetAutreChamp();return VerifFormat(this.name);" /></td>                    
					 <td>&nbsp;</td>
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