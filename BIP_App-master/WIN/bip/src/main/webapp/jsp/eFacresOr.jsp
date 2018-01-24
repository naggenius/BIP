
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
<bip:VerifUser page="jsp/eFacresOr.jsp"/>
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
	String sTitre2;
	String sInitial;
	String sInitial2;
	String sJobId="e_aefacres";
	String sJobId2="e_ctrres";
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
		
		sTitre2 = com.socgen.bip.metier.Report.getTitre(sJobId2);
		if (sTitre2 == null)
		{
			//redirect sur la page d'erreur
			sTitre2 = "Pas de titre";
		}		
		sInitial2=ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getQueryString()));
		if (sInitial2 == null)
			sInitial2 = request.getRequestURI();
		else
			sInitial2 = request.getRequestURI() + "?" + sInitial2;
		sInitial2 = sInitial2.substring(request.getContextPath().length());
	%>
	
	tabVerif["p_param6"]  = "VerifierNum(document.editionForm.p_param6,5,0);";
	tabVerif["p_param7"]  = "VerifierDate(document.editionForm.p_param7,'jj/mm/aaaa');";
	tabVerif["p_param8"]  = "VerifierDate(document.editionForm.p_param8,'jj/mm/aaaa');";
	tabVerif["p_param10"]  = "VerifierNum(document.editionForm.p_param10,5,0);";
	
	var Message="<bean:write filter="false"  name="editionForm"  property="msgErreur" />";
	var Focus = "<bean:write name="editionForm"  property="focus" />";
	
	if (Message != "") {
		alert(Message);
	}
	if (Focus != "") (eval( "document.editionForm."+Focus )).focus();
	else
	{
		document.editionForm.p_param6.focus();
	}
}

function Verifier(form, bouton, flag)
{
  blnVerification = flag;
  //form.BOUTON.value = bouton;
}

function Verifier_contrats(form, flag)
{
  blnVerification = flag;
  form.jobId.value = "<%=sJobId2%>";
}

function ValiderEcran(form)
{
	if (blnVerification && form.jobId.value=="<%=sJobId%>")
	{
		if ( !VerifFormat(null) ) return false;
		if (!ChampObligatoire(form.p_param6,"un code ressource")) return false;
		if ((form.p_param7.value == "") && (form.p_param8.value != "")) 
		{
			alert("Entrez une date début");
			return false;
		}
	}
	
	if (blnVerification && form.jobId.value=="<%=sJobId2%>")
	{
		if ( !VerifFormat(null) ) return false;
		if (!ChampObligatoire(form.p_param10,"un code ressource")) return false;
	}
	
	//form.VerifExecJS.value = 1;
	//document.editionForm.submit.disabled = true;
	return true;
}


function rechercheID(i){
	window.open("/recupIdPersonne.do?action=initialiser&nomChampDestinataire=p_param"+i+"&windowTitle=Recherche Identifiant Personne&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
}  

function nextFocusLoupePersonne(){
document.forms[0].p_param7.focus();
}

</script>
<!-- #EndEditable --> 


</head>

<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
<!-- #BeginEditable "debut_form" -->
<html:form action="/edition"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable -->
<!-- #BeginEditable "debut_hidden" -->
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
            
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<input type="hidden" name="jobId" value="<%=sJobId%>">
			<input type="hidden" name = "p_param9" value="ACHMENU">
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
								<td class="lib"><B>Code ressource :</B></td>
								<td colspan=2><html:text property="p_param6" styleClass="input"  size="5" maxlength="5" onchange="return VerifFormat(this.name);"/>
							 		&nbsp;&nbsp;<a href="javascript:rechercheID(6);" onFocus="javascript:nextFocusLoupePersonne();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Identifiant" title="Rechercher Identifiant" align="absbottom"></a></td>
							</tr>
							<tr>
								<td class="lib"> Date de factures d&eacute;but  : </td>
								<td><html:text property="p_param7" styleClass="input"  size="10" maxlength="10" onchange="return VerifFormat(this.name);"/></td>
							</tr>
							<tr>
								<td class="lib"> Date de factures fin : </td>
								<td><html:text property="p_param8" styleClass="input"  size="10" maxlength="10" onchange="return VerifFormat(this.name);"/></td>
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
                  <td>  
	                  <div align="center">
					  	<html:submit value="Liste" styleClass="input" onclick="Verifier(this.form, 'liste', true);"/>
	                  </div>
                  </td>
                </tr>
            </table>
          </td>
        </tr>
        <tr> 
        	<td>&nbsp;</td>
        </tr>
        <tr> 
        	<td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
        	<td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" --><%=sTitre2%><!-- #EndEditable --></td>
        </tr>
        <tr> 
        	<td background="../images/ligne.gif"></td>
        </tr>
		<tr> 
        	<td>&nbsp;</td>
        </tr>
        <tr>
        	<td>
            	<table width="100%" border="0">
                	<tr> 
                  		<td> 
                    		<div align="center">
								<table border=0 cellspacing=2 cellpadding=2 class="tableBleu">
									<!-- #BeginEditable "contenu" -->
					  				<tr>
                        				<td colspan=5 align="center">&nbsp;</td>
                      				</tr>
									<tr>
										<td class="lib"><B>Code ressource :</B></td>
										<td colspan=2><html:text property="p_param10" styleClass="input"  size="5" maxlength="5" onchange="return VerifFormat(this.name);"/>
						 					&nbsp;&nbsp;<a href="javascript:rechercheID(10);" onFocus="javascript:nextFocusLoupePersonne();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Identifiant" title="Rechercher Identifiant" align="absbottom"></a></td>
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
                  		<td>  
                  			<div align="center">
				  				<html:submit value="Liste" styleClass="input" onclick="Verifier_contrats(this.form, true);"/>
                  			</div>
                  		</td>
                	</tr>
            	</table>
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
<!-- #BeginEditable "fin_form" -->
</html:form>
<!-- #EndEditable -->
</body>
</html:html>

<!-- #EndTemplate -->