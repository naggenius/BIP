
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,com.socgen.bip.commun.liste.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="suiviCopiRefForm" scope="request" class="com.socgen.bip.form.SuiviCopiRefForm" />
<jsp:useBean id="listeDynamique" scope="request" class="com.socgen.bip.commun.liste.ListeDynamique" />



<% 
					if ((suiviCopiRefForm.getTypeSuiviCopi().equals("ExportExcelBud")) || (suiviCopiRefForm.getTypeSuiviCopi().equals("ExportExcelReal")) || (suiviCopiRefForm.getTypeSuiviCopi().equals("ExportExcelPorte")) || (suiviCopiRefForm.getTypeSuiviCopi().equals("ExportExcelDPCOPI"))|| (suiviCopiRefForm.getExtension().equals(".CSV"))) 
					{ %>
<jsp:useBean id="extractionForm" scope="request" class="com.socgen.bip.commun.form.ExtractionForm"/>	
					<%}
					else
					{%> 
<jsp:useBean id="editionForm" scope="request" class="com.socgen.bip.commun.form.EditionForm"/>	
					<% }%>




<html:html locale="true">


<head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<!-- #BeginEditable "doctitle" --> 
<title>Edition</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/feSuiviCopiRef.jsp"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var pageAide = "aide/hvide.htm";
var blnVerification = true;


 


<%


	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));


	java.util.Hashtable hP = new java.util.Hashtable();
	hP.put("userid", ((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
	java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("clisigle",hP);
	list1.add(0, new ListeOption("---", "          " ));   
	pageContext.setAttribute("choixclisigle", list1);
	
%>
var pageAide = "<%= sPageAide %>";

var blnVerifFormat  = true;
var tabVerif        = new Object();

<%
	String sTitre;
	String sInitial;
	String sJobId=null;
	String extension=suiviCopiRefForm.getExtension();
	if (suiviCopiRefForm.getTypeSuiviCopi().equals("ExportExcelBud"))
		sJobId="ExportExcelBudCOPI";
	if (suiviCopiRefForm.getTypeSuiviCopi().equals("ExportExcelReal"))
		sJobId="ExportExcelRealCOPI";
	if (suiviCopiRefForm.getTypeSuiviCopi().equals("ExportExcelPorte"))
		sJobId="ExportExcelPorteCOPI";
	if (suiviCopiRefForm.getTypeSuiviCopi().equals("ExportExcelDPCOPI"))
		sJobId="ExportExcelDPCOPI";
	if (suiviCopiRefForm.getTypeSuiviCopi().equals("SynthGlobal"))
		if (suiviCopiRefForm.getExtension().equals(".CSV"))
			sJobId="ExtractSynthGlobalCOPI";
		else
			sJobId="SynthGlobalCOPI";
	if (suiviCopiRefForm.getTypeSuiviCopi().equals("EtatClient"))
		if (suiviCopiRefForm.getExtension().equals(".CSV"))
			sJobId="ExtractEtatClientCOPI";
		else
			sJobId="EtatClientCOPI";
	if (suiviCopiRefForm.getTypeSuiviCopi().equals("EtatSuivi"))
		if (suiviCopiRefForm.getExtension().equals(".CSV"))
			sJobId="ExtractEtatSuiviCOPI";
		else
			sJobId="EtatSuiviCOPI";
		
	
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
	
	<% 
	if ((suiviCopiRefForm.getTypeSuiviCopi().equals("ExportExcelBud")) || (suiviCopiRefForm.getTypeSuiviCopi().equals("ExportExcelReal")) || (suiviCopiRefForm.getTypeSuiviCopi().equals("ExportExcelPorte"))  || (suiviCopiRefForm.getTypeSuiviCopi().equals("ExportExcelDPCOPI"))|| (suiviCopiRefForm.getExtension().equals(".CSV")))
					{ %>
var Message="<bean:write filter="false"  name="extractionForm"  property="msgErreur" />";
	var Focus = "<bean:write name="extractionForm"  property="focus" />";	
					<%}
					else
					{ %> 
var Message="<bean:write filter="false"  name="editionForm"  property="msgErreur" />";
	var Focus = "<bean:write name="editionForm"  property="focus" />";	
					<% }%>

	if (Message != "") {
		alert(Message);
		
	
	}
}
function Verifier(form, bouton, flag)
{
  blnVerification = flag;
  
  
}

function ValiderEcran(form)
{
	//Verification existence dossier projet
	if (form.p_param8.value != '') {
		ajaxCallRemotePageCopiRef('/suiviCopi.do?action=controleDP&p_param8='+form.p_param8.value);
		if(document.getElementById("ajaxResponse").innerHTML.length < 30){
			return false;
		}
	}
	//Verification coherence DP/DP COPI
	if (form.p_param8 != null && form.p_param8.value != '' && form.p_param7.value != '' && (parseInt(form.p_param8.value) != parseInt(form.p_param7.value.substring(0,form.p_param7.value.length-1), 10))) {
		alert('Document Projet et Document projet COPI incompatibles');
		return false;
	}
	
	if  (form.jobId.value=="ExportExcelPorteCOPI")	
	{
	  if (!ChampObligatoire(form.p_param6, "la date COPI")) return false;
	}  
	return true;
}

function rechercheID(){
	window.open("/recupDPCopi.do?action=initialiser&type=creation&nomChampDestinataire=p_param7&windowTitle=Recherche Code Dossier Projet COPI"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
}

function rechercheDP(){
	window.open("/recupCodeDosProj.do?action=initialiser&nomChampDestinataire=p_param8&windowTitle=Recherche Code dossier projet"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->
      Suivi des budgets COPI - JH/K&euro; Export - Editions<!-- #EndEditable --></td>
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
          
          <%
          String action;
				
          if ((suiviCopiRefForm.getTypeSuiviCopi().equals("ExportExcelBud")) || (suiviCopiRefForm.getTypeSuiviCopi().equals("ExportExcelReal")) || (suiviCopiRefForm.getTypeSuiviCopi().equals("ExportExcelPorte")) || (suiviCopiRefForm.getTypeSuiviCopi().equals("ExportExcelDPCOPI"))|| (suiviCopiRefForm.getExtension().equals(".CSV")))
		action = "/extract";
	else
		action = "/edition";
	
%>
          
          	
         
      
 <!-- #BeginEditable "debut_form" --><html:form action="<%=action%>"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable -->
			<!-- #BeginEditable "debut_hidden" -->

		 
		  		
            
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<input type="hidden" name="jobId" value="<%=sJobId%>">
            <input type="hidden" name="initial" value="<%= sInitial %>">
			
            <table width="100%" border="0">
              
                <tr> 
                  <td> 
                    <div align="center">
					<table border=0 cellspacing=2 cellpadding=2 class="tableBleu">
					<!-- #BeginEditable "contenu" -->
					<input type="hidden" name="pageAide" value="<%= sPageAide %>">
										
					  <tr>
                        <td colspan=3 align="center">&nbsp;</td>
                      </tr>
					
					<% 
					if (suiviCopiRefForm.getTypeSuiviCopi().equals("ExportExcelBud") || suiviCopiRefForm.getTypeSuiviCopi().equals("ExportExcelReal")) 
					{ %>
					<tr>
						<td colspan=3 class="lib"><b>Annee : </b></td>
						<td> 
                   			<input type="text" name="p_param6" maxlength="4" size="4" onchange="return VerifierDate(this,'aaaa');"/>
   				 		</td>
					</tr>
					<tr>
						<td colspan=3 class="lib"><b>Code Dossier projet :</b></td>
						 <td> 
                   		 <input type="text" name="p_param8" maxlength="5" size="5"  onchange="return VerifierNum(this,5,0);"/>&nbsp;&nbsp;
                         <a href="javascript:rechercheDP();"><img border=0 src="/images/p_zoom_blue.gif"  alt="Rechercher Identifiant" title="Rechercher Identifiant"></a>   				 		
   				 		</td>
					</tr>
					<tr>
						<td colspan=3 class="lib"><b>Code Dossier projet COPI :</b></td>
						 <td> 
                   		 <input type="text" name="p_param7" maxlength="6" size="6" onchange="return VerifierAlphanum(this);"/>&nbsp;&nbsp;
                       <a href="javascript:rechercheID();"><img border=0 src="/images/p_zoom_blue.gif"  alt="Rechercher Identifiant" title="Rechercher Identifiant"></a> 
   				 		</td>
					</tr>
					
					
					<%}
					if (suiviCopiRefForm.getTypeSuiviCopi().equals("ExportExcelPorte"))
					{%>					
					 <tr>
						<td colspan=3 class="lib"><b>Date COPI : </b></td>
						<td> 
                   			<input type="text" name="p_param6" maxlength="10" size="11" onchange="return VerifierDate(this,'jj/mm/aaaa');"/>
   				 		</td>
					</tr>
					<%} 
					if (suiviCopiRefForm.getTypeSuiviCopi().equals("SynthGlobal"))
					{%>					
					 <tr>
						<td colspan=3 class="lib"><b>Annee : </b></td>
						<td> 
                   			<input type="text" name="p_param6" maxlength="4" size="4" onchange="return VerifierDate(this,'aaaa');"/>
   				 		</td>
					</tr>
					<%} 
					
					if (suiviCopiRefForm.getTypeSuiviCopi().equals("EtatClient"))
					{ %>
					<tr>
						<td colspan=3 class="lib"><b>Annee : </b></td>
						<td> 
                   			<input type="text" name="p_param6" maxlength="4" size="4" onchange="return VerifierDate(this,'aaaa');"/>
   				 		</td>
					</tr>
					<tr>
						<td colspan=3 class="lib"><b>Client :</b></td>
						 <td> 
						<html:select property="p_param7" styleClass="input" > 
								<html:options collection="choixclisigle" property="cle" labelProperty="libelle" />
						</html:select> 
						 
                   		</td>
					</tr>
					
					
					<%}
					 
					if (suiviCopiRefForm.getTypeSuiviCopi().equals("EtatSuivi"))
					{ %>
					<tr>
						<td colspan=3 class="lib"><b>Annee : </b></td>
						<td> 
                   			<input type="text" name="p_param6" maxlength="4" size="4" onchange="return VerifierDate(this,'aaaa');"/>
   				 		</td>
					</tr>
					<tr>
						<td colspan=3 class="lib"><b>Code Dossier projet COPI :</b></td>
						 <td> 
                   		 <input type="text" name="p_param7" maxlength="6" size="6" onchange="return VerifierAlphanum(this);"/>&nbsp;&nbsp;
                       <a href="javascript:rechercheID();"><img border=0 src="/images/p_zoom_blue.gif"  alt="Rechercher Identifiant" title="Rechercher Identifiant"></a> 
   				 		</td>
					</tr>
					
					
					<%}%>
					
					  <tr>
                        <td colspan=3 align="center">&nbsp;</td>
                      </tr>
					  </table>
					  <table>
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