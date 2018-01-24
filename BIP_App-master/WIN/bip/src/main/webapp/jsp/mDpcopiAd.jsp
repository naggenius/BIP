<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,com.socgen.bip.commun.liste.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="dpcopiForm" scope="request" class="com.socgen.bip.form.DpcopiForm" />
<html:html locale="true">
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --><head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>


<!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fmDpcopiAd.jsp"/>

<%
	java.util.ArrayList list2 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("domaine_npsi_actif",dpcopiForm.getHParams()); 
	pageContext.setAttribute("choixDomaineActif", list2);
	
	java.util.ArrayList list3= new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("copiaxesstrategiques",dpcopiForm.getHParams());
	pageContext.setAttribute("listeAxesStrategiques", list3);
	
	java.util.ArrayList list4= new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("copietapes",dpcopiForm.getHParams());
	pageContext.setAttribute("listeEtapes", list4);

	java.util.ArrayList list5= new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("copitypefinancement",dpcopiForm.getHParams());
	pageContext.setAttribute("listeTypeFinancement", list5);
%>

<script language="JavaScript" src="../js/function.cjs"></script>
<script language="JavaScript" src="../js/jquery.js"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	if (dpcopiForm.getAction().equals("creer"))
	{
		dpcopiForm.setDomaine("0");
		dpcopiForm.setAxe_strategique("10");
		dpcopiForm.setEtape("4");
		dpcopiForm.setTypeFinancement("0");
		dpcopiForm.setQuote_part("1,00");
	}
%>
var pageAide = "<%= sPageAide %>";


function MessageInitial()
{
   var Message="<bean:write filter="false"  name="dpcopiForm"  property="msgErreur" />";
   var Focus = "<bean:write name="dpcopiForm"  property="focus" />"
   if (Message != "") {
	   alert(Message);
   }
   
  
 
}

function Verifier(form, action, mode, flag)
{
   blnVerification = flag;
   form.action.value = action;

} 



function ValiderEcran(form) {
  if (blnVerification == true) {
  	
     if (!ChampObligatoire(document.forms[0].axe_strategique, "l'enveloppe budgétaire du Dossier Projet COPI")) return false;
     if (!ChampObligatoire(document.forms[0].etape, "l'étape du Dossier Projet COPI")) return false;
     if (!ChampObligatoire(document.forms[0].quote_part, "la quote-part du Dossier Projet COPI")) return false;
    
     if (form.mode.value == 'update') {
        if (!confirm("Voulez-vous modifier ce Dossier projet COPI?")) return false;
     }
   
      if (form.mode.value == 'delete') {
        if (!confirm("Voulez-vous supprimer ce Dossier projet COPI?")) return false;
     }
     
      if (form.mode.value == 'insert' || form.mode.value == 'update')
    	  {
    	  return verifierAxe(form.dp_copi.value,form.dpcopiaxemetier.value, form.clicode.value); // MCH : QC1811
    	  }
  }

   return true;
}

//MCH : PPM 61919 chapitre 6.7
function verifierDpcopiAxe(p_dpcopi,p_dpcopiaxemetier,p_clicode){
	// Appel ajax de la méthode de l'action 
	ajaxCallRemotePage('/dpcopi.do?action=verifierDpcopiAxe&dp_copi='+p_dpcopi+'&dpcopiaxemetier='+p_dpcopiaxemetier+'&clicode='+p_clicode);
	// Si la réponse ajax est non vide :
	var ajaxres = document.getElementById("ajaxResponse").innerHTML;
	return ajaxres;	
}

function mettreAvide(p_type,p_param_id){
	<% String userid = ((UserBip)request.getSession().getAttribute("UserBip")).getIdUser(); %>
	// Appel ajax de la méthode de l'action 
	ajaxCallRemotePage('/dpcopi.do?action=mettreAvide&type='+p_type+'&param_id='+p_param_id+'&userid='+'<%=userid%>');
	// Si la réponse ajax est non vide :
	var ajaxres = document.getElementById("ajaxResponse").innerHTML;
	return ajaxres;	
}
// MCH : QC1811
function verifierAxe(p_dpcopi,p_dpcopiaxemetier,p_clicode)
{
	var result = verifierDpcopiAxe(p_dpcopi,p_dpcopiaxemetier, p_clicode );
    var tab = result.split(';');
    var type = tab[0];
    var param_id = tab[1];
    var message = tab[2];
    if(message =='valid')
    {
    	return true;
    }
    else if(message!="" && message.substring(0,9).toUpperCase() == 'ATTENTION')
    {
    	if(confirm(message))
    	{
  			mettreAvide(type,param_id);
  			return verifierAxe(p_dpcopi,p_dpcopiaxemetier,p_clicode);
  		}
  		else 
  		{
  			document.forms[0].dpcopiaxemetier.focus();
  			return false;
  		}	
    }
    else 
    {
  		alert(message);
  	  	document.forms[0].dpcopiaxemetier.focus();
		return false;
    }
}

//fin MCH : PPM 61919 chapitre 6.7

function rechercheDP(){
	window.open("/recupCodeDosProj.do?action=initialiser&nomChampDestinataire=dpcode&windowTitle=Recherche Code Dossier Projet"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
}  
function rechercheIDMO(){
	window.open("/recupIdMoCopi.do?action=initialiser&nomChampDestinataire=clicode&windowTitle=Recherche Code Client MO"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
}  

function VerifPlage()
{
	
	if ( parseFloat(document.forms[0].quote_part.value.replace(',','.')) > 1 || parseFloat(document.forms[0].quote_part.value.replace(',','.')) < 0 || document.forms[0].quote_part.value=="")
	{
		alert("La quote-part doit être comprise entre 0 et 1");
		document.forms[0].quote_part.value = "";
		document.forms[0].quote_part.focus;
	}
	
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" --><bean:write name="dpcopiForm" property="titrePage"/> Un dossier projet COPI<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td>
		  <!-- #BeginEditable "debut_form" --> <html:form action="/dpcopi"
								onsubmit="return ValiderEcran(this);">
								<!-- #EndEditable -->
								<div align="center">
									<!-- #BeginEditable "contenu" -->
									<input type="hidden" name="pageAide" value="<%= sPageAide %>">
									<html:hidden property="action" />
									<html:hidden property="mode" />
									<html:hidden property="arborescence"
										value="<%= arborescence %>" />
									<html:hidden property="flaglock" />
									<table cellspacing="2" cellpadding="2" class="tableBleu">
										<tr>
											<td colspan=2>&nbsp;</td>
										</tr>
										<tr>
											<td>&nbsp;</td>
											<td>&nbsp;</td>
										</tr>
										<tr>
											<td class="lib"><b> Code dossier projet COPI :</b></td>
											<td><b> <bean:write name="dpcopiForm"
														property="dp_copi" /> <html:hidden property="dp_copi" />
											</b></td>
										</tr>
										<tr>
											<td class="lib">Libelle :</td>
											<td><logic:notEqual parameter="action"
													value="supprimer">
													<html:text property="libelle" styleClass="input" size="50"
														maxlength="50" onchange="return VerifierAlphanum(this);" />
												</logic:notEqual> <logic:equal parameter="action" value="supprimer">
													<bean:write name="dpcopiForm" property="libelle" />
												</logic:equal></td>
										</tr>
										<tr>
											<td class="lib">Code dossier projet :</td>
											<td><logic:notEqual parameter="action"
													value="supprimer">
													<html:text property="dpcode" styleClass="input" size="6"
														maxlength="6" onchange="return VerifierNum(this,5,0);" />
													<a href="javascript:rechercheDP();"><img border=0
														src="/images/p_zoom_blue.gif" alt="Rechercher Identifiant"
														title="Rechercher Identifiant">
													</a>
												</logic:notEqual> <logic:equal parameter="action" value="supprimer">
													<bean:write name="dpcopiForm" property="dpcode" />
												</logic:equal></td>
										</tr>
										<tr>
											<td class="lib">Code client MO :</td>
											<td><logic:notEqual parameter="action"
													value="supprimer">
													<html:text property="clicode" styleClass="input" size="6"
														maxlength="6" onchange="return VerifierNum(this,5,0);" />
													<a href="javascript:rechercheIDMO();"><img border=0
														src="/images/p_zoom_blue.gif" alt="Rechercher Identifiant"
														title="Rechercher Identifiant">
													</a>
												</logic:notEqual> <logic:equal parameter="action" value="supprimer">
													<bean:write name="dpcopiForm" property="clicode" />
												</logic:equal></td>
										</tr>
										<tr>
											<td class="lib"><b>Lien NPSI (Domaine) :</b>
											</td>
											<td><logic:notEqual parameter="action" value="supprimer">

													<html:select property="domaine" styleClass="input">
														<html:options collection="choixDomaineActif"
															property="cle" labelProperty="libelle" />
													</html:select>
												</logic:notEqual> <logic:equal parameter="action" value="supprimer">
													<bean:write name="dpcopiForm" property="domaine_lib" />
													<html:hidden property="libelle" />
												</logic:equal></td>
										</tr>
										<tr>
											<td class="lib"><b>Enveloppe budgétaire :</b>
											</td>
											<td><logic:notEqual parameter="action" value="supprimer">

													<html:select property="axe_strategique" styleClass="input">
														<html:options collection="listeAxesStrategiques"
															property="cle" labelProperty="libelle" />
													</html:select>
												</logic:notEqual> <logic:equal parameter="action" value="supprimer">
													<html:select property="axe_strategique" styleClass="input"
														disabled="true">
														<html:options collection="listeAxesStrategiques"
															property="cle" labelProperty="libelle" />
													</html:select>
												</logic:equal></td>
										</tr>
										<tr>
											<td class="lib"><b>Etape :</b>
											</td>
											<td><logic:notEqual parameter="action" value="supprimer">

													<html:select property="etape" styleClass="input">
														<html:options collection="listeEtapes" property="cle"
															labelProperty="libelle" />
													</html:select>
												</logic:notEqual> <logic:equal parameter="action" value="supprimer">
													<html:select property="etape" styleClass="input"
														disabled="true">
														<html:options collection="listeEtapes" property="cle"
															labelProperty="libelle" />
													</html:select>
												</logic:equal></td>
										</tr>
										<tr>
											<td class="lib"><b>Type financement :</b>
											</td>
											<td><logic:notEqual parameter="action" value="supprimer">

													<html:select property="typeFinancement" styleClass="input">
														<html:options collection="listeTypeFinancement"
															property="cle" labelProperty="libelle" />
													</html:select>
												</logic:notEqual> <logic:equal parameter="action" value="supprimer">
													<html:select property="typeFinancement" styleClass="input"
														disabled="true">
														<html:options collection="listeTypeFinancement"
															property="cle" labelProperty="libelle" />
													</html:select>
												</logic:equal></td>
										</tr>

										<tr>
											<td class="lib"><b>Quote-part COPI : 
											</td>
											<td><logic:notEqual parameter="action"
													value="supprimer">
													<html:text property="quote_part" styleClass="input"
														size="4" maxlength="4"
														onchange="VerifierNum(this,3,2);VerifPlage();" />
												</logic:notEqual> <logic:equal parameter="action" value="supprimer">
													<bean:write name="dpcopiForm" property="quote_part" />
												</logic:equal></td>
										</tr>
										<tr>
											<!--   MCH : PPM 61919 chapitre 6.7 -->
											<td class="lib">Ref_demande :</td>
											<td><logic:notEqual parameter="action"
													value="supprimer">
													<html:text property="dpcopiaxemetier" styleClass="input"
														size="12" maxlength="12"
														onchange="return VerifierAlphanum(this);" />
												</logic:notEqual> <logic:equal parameter="action" value="supprimer">
													<bean:write name="dpcopiForm" property="dpcopiaxemetier" />
												</logic:equal></td>
										</tr>
										<tr>
											<td>&nbsp;</td>
											<td>&nbsp;</td>
										</tr>
										<tr>
											<td>&nbsp;</td>
											<td>&nbsp;</td>
										</tr>
										<tr>
											<td>&nbsp;</td>
											<td>&nbsp;</td>
										</tr>
										<tr>
										</tr>
									</table>
									<!-- #EndEditable -->
								</div>
						</td>
		</tr>
		<tr>
		<td align="center">
		<table width="100%" border="0">
                <tr>
				<td width="25%">&nbsp;</td> 
                  <td width="25%">  
				  	<div align="center">
                	 <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', this.form.mode.value,true);"/>
                  	</div>
				  </td>
				  <td width="25%">  
				  	<div align="center"> 
                	 <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', null, false);"/>
                  		</div>
				  </td>
				  <td width="25%">&nbsp;</td>
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
<% 
Integer id_webo_page = new Integer("1005"); 
com.socgen.bip.commun.form.AutomateForm formWebo = dpcopiForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html> 

<!-- #EndTemplate -->