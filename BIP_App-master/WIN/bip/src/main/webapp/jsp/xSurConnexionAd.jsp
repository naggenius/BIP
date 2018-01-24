 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="extractionForm" scope="request" class="com.socgen.bip.commun.form.ExtractionForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Page_extraction.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Extraction</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/xSurConnexionAd.jsp"/> 
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
	String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";
<%
	String sTitre;
	String sInitial;
	String sJobId;
%>


function MessageInitial()
{
	var Message="<bean:write filter="false"  name="extractionForm"  property="msgErreur" />";
	var Focus = "<bean:write name="extractionForm"  property="focus" />";


	<%
		sJobId = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("jobId")));
		
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
	
	if (Message != "") {
		if ( Message.substring(1,13) != "La date de d" ) {
			alert(Message);
		}

    }
    
    if (Focus != "") (eval( "document.extractionForm."+Focus )).focus();
	else {
		document.extractionForm.p_param6.focus();
	}	
}

function Verifier(form, bouton, flag)
{
  blnVerification = flag;

}

//Appel en ajaxx pour controler la date de debut saisie avec les traces presente
// + la presence de trace a afficher
function controleData(dateDebut, dateFin){
	ajaxCallRemotePage('/trace.do?action=existData&sParam6='+dateDebut+'&sParam7='+dateFin);
	if (document.getElementById("ajaxResponse").innerHTML!='') {
		alert(document.getElementById("ajaxResponse").innerHTML);
		return false;
	}
	return true;
}

//Appel en ajaxx pour controler la date de debut saisie avec les traces presente
// + la presence de trace a afficher
function controleDate(dateDebut){

	//ajaxCallRemotePage('/trace.do?action=ctrlDatel&sParam6='+dateDebut);
	ajaxCallRemotePage('/execute.do?sParam6='+dateDebut);
	//ajaxCallRemotePage('controle_trace?sParam6='+dateDebut);
	if (document.getElementById("ajaxResponse").innerHTML!='') {
		alert(document.getElementById("ajaxResponse").innerHTML);
		return false;
	}
	return true;
}

function ValiderEcran(form)
{

	if ( form.nomFichier.value == 'xAccesMenuAd' ) {
	
		if ( form.p_param6.value != ''  ) {

			//if (!controleDate(form.p_param6.value)) {
			//	return false;
			//}
		}
		
		if ( form.p_param6.value != '' && form.p_param7.value != '' ) {
		
			//if (!controleData(form.p_param6.value,form.p_param7.value)) {
			//	return false;
			//}				
		}

	}
  	
	form.jobId.value = form.nomFichier.value;
	form.listeReports.value="1";
	
	document.extractionForm.submit.disabled = true;
	return true;
}
</script>
<!-- #EndEditable --> 
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
<div style="display:none;" id="ajaxResponse"></div>

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
              <%=tb.printHtml()%><!-- #EndEditable --> </div>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td height="20" class="TitrePage">Surveillance des connexions</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> </td>
        </tr>
        <tr> 
          <td> <html:form action="/extract"  onsubmit="return ValiderEcran(this);"> 
            <!-- #BeginEditable "debut_hidden" --> 
            
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<input type="hidden" name="jobId" value="<%=sJobId%>">
<html:hidden property="p_param14"/>

            <input type="hidden" name="listeReports" value="<%=sJobId%>">
            <input type="hidden" name="initial" value="<%= sInitial %>">
            <!-- #EndEditable --> 
              <table width="80%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" --> 
                    <input type="hidden" name="pageAide" value="<%= sPageAide %>">
                    <!-- #EndEditable -->
                   </div>
                </td>
              </tr>
              <tr> 
                <td>&nbsp; </td>
                <td>&nbsp; </td>
              </tr>
              <tr> 
                <td>&nbsp; </td>
                <td>&nbsp; </td>
              </tr>
              <tr> 
                <td>&nbsp; </td>
                <td>&nbsp; </td>
              </tr>
              
             <tr>
             	<td>&nbsp; </td>
                <td>&nbsp; </td>
             	    <td class="lib"><B>Date de d&eacute;but (mm/aaaa) : </B></td>
					<td><html:text property="p_param6" styleClass="input"  size="7" maxlength="7" onchange="return VerifierDate(this,'mm/aaaa');"/></td>
			 </tr>
			 
			 <tr> 	
			 	<td>&nbsp; </td>
                <td>&nbsp; </td>
			       <td class="lib"><B>Date de fin (mm/aaaa) : </B></td>
			       <td><html:text property="p_param7" styleClass="input"  size="7" maxlength="7" onchange="return VerifierDate(this,'mm/aaaa');"/></td>
             </tr>             
              
              <tr>
              	<td>&nbsp; </td>
                <td>&nbsp; </td>
              	<td  class="lib" width="30%"><B>Choix de l'extraction : </B></td>
                 <td width="50%">	
              		<select name="nomFichier" size="1" class="input">
              	          <option value="xAccesMenuAd">Liste des accès aux menus</option>
              			  <option value="xConnexAd">Liste des utilisateurs qui se connectent</option>
              	          <option value="xInvConnexAd">Liste des utilisateurs qui ne se connectent pas</option>
              	    </select> 
              	        
              	   </td>     
              </tr>
             
              <tr> 
                <td>&nbsp; </td>
                <td>&nbsp; </td>
              </tr>
              
              <tr> 
                <td>&nbsp; </td>
                <td>&nbsp; </td>
              </tr>
              <tr> 
                <td>&nbsp; </td>
                <td>&nbsp; </td>
              </tr>
              
            </table>
            
             <table  border="0" width=100%>
                      
                 <tr> 
                  <td>  
                  <div align="center">
				  <html:submit value="Extraire" styleClass="input" onclick="Verifier(this.form, 'Extraire', true);"/> 
                  </div>
                  </td>
                </tr>
                     
            </table>
            
            <!-- #BeginEditable "fin_form" --></html:form><!-- #EndEditable --> 
          </td>
        </tr>
        <tr> 
          <td>&nbsp; </td>
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
</body></html:html>
<script>
	var Message="<bean:write filter="false"  name="extractionForm"  property="msgErreur" />";

	if ( Message.substring(1,13) == "La date de d" ) {
		if ( confirm(Message)) {
			
			document.extractionForm.p_param14.value = "1";
			document.extractionForm.jobId.value = document.extractionForm.nomFichier.value;
			document.extractionForm.listeReports.value="1";
			Verifier(document.extractionForm, 'Extraire', true);
			//ValiderEcran(document.extractionForm);
			
			document.extractionForm.submit();
		}
	}
</script>
<!-- #EndTemplate -->
