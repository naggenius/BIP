<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="clientForm" scope="request" class="com.socgen.bip.form.ClientForm" />
<html:html locale="true">
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --><head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>


<!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fmClientAd.jsp"/>
<%
  java.util.ArrayList list1 = com.socgen.bip.commun.liste.ListeGlobale.getListeGlobale("filiale");
  java.util.ArrayList list2 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("dirmo",clientForm.getHParams()); 
  java.util.ArrayList list3 = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("topFermeture"); 
  java.util.ArrayList list4 = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("topDivaMO");   
  pageContext.setAttribute("choixFiliale", list1);
  pageContext.setAttribute("choixDirmo", list2);
  pageContext.setAttribute("choixTopFermeture", list3);
  pageContext.setAttribute("choixTop_diva", list4);
  
  String top_diva = clientForm.getTop_diva();
%>
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

var blnVerifFormat  = true;
var tabVerif = new Object();

function MessageInitial()
{
   tabVerif["clilib"]	= "VerifierAlphanum(document.forms[0].clilib)";
   tabVerif["clisigle"]	= "VerifierAlphaMax(document.forms[0].clisigle)";

   var Message="<bean:write filter="false"  name="clientForm"  property="msgErreur" />";
   var Focus = "<bean:write name="clientForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else if (document.forms[0].mode.value!='delete'){
	  document.forms[0].cliDep.focus();
   }
   if  (document.forms[0].action.value=="creer") {
   //Initialiser le top fermeture à Ouvert
   	document.forms[0].clitopf[0].checked=true;
   }
  
}

function Verifier(form, action, mode, flag)
{
   blnVerification = flag;
   if (action=="valider") {
     form.mode.value = mode;
   }
   form.action.value = action;
} 

function ValiderEcran(form)
{ 
   if (blnVerification) {
   
	if ( !VerifFormat(null) ) return false;	

	if (!ChampObligatoire(form.clilib, "le libellé")) return false;
	if (!ChampObligatoire(form.clisigle, "le sigle")) return false;
	
	if (!ChampObligatoire(form.cliDep, "le département")) return false;
	if (!ChampObligatoire(form.cliPole, "le pôle")) return false;
	if (!ChampObligatoire(form.top_diva, "le top diva lignes")) return false;
	
	if (form.mode.value == 'update') {
	/* TD 720 afficher un message de confirmation de modification des tops diva*/ 
     	var top_diva = "<%= top_diva %>";
     	  if(top_diva != form.top_diva.value )
     	  	if(!confirm('Vous confirmer la modification du top envoi des lignes vers DIVA'))
     	  	 return false;
     
	   if (!confirm("Voulez-vous modifier ce client ?")) return false;
	}
    if (form.mode.value == "delete") {
		if (!confirm("Voulez-vous supprimer ce client ?")) return false;
	}
	else {
		if (!form.clitopf[0].checked && !form.clitopf[1].checked) {
	   		alert("Choisissez Ouvert ou Fermé");
         	return false;
		}
		
	
	}
  }
  
   return true;
}

function ChangeDep(form)
{
	var value;
	var RE;
	value = form.cliDep.value;
	if (VerifierNum(form.cliDep,3,0))
	{
		if (value.length == 2)
		{
			RE = /0[0-9]/;
			if ( value.match(RE) )
			{
				value = value.substring(1,2);
			}
		}
		else
		{
			RE = /00[0-9]/;
			if ( value.match(RE) )
			{
				value = value.substring(2,3);
			}
			else
			{
				RE = /0[0-9][0-9]/;
				if ( value.match(RE) )
				{
					value = value.substring(1,3);
				}		
			}
		}
		form.cliDep.value = value;
		
		if (form.cliDep.value=='0')
		{
			form.cliPole.value='0';
			alert('Si le département est égal à 0, le pôle doit également être égal à 0.\nLa valeur du pôle vient d\'être mise à jour.');
		}
		/*else
		{
			if (form.cliDep.value.length==1)
				form.cliDep.value='00'+form.cliDep.value;
			else if (form.cliDep.value.length==2)
				form.cliDep.value='0'+form.cliDep.value;
		}*/
		return true;
	}
	return false;	
}

function ChangePole(form)
{
	var RE;
	var value = form.cliPole.value;
	if (VerifierNum(form.cliPole,2,0))
	{	
		RE = /0[0-9]/;
		if ( value.match(RE) )
		{
			value = value.substring(1,2);
		}
		
		form.cliPole.value = value;
		return true;
	}
	return false;
}

function ChangeCodeCAMO(form)
{
	//faire un raffichage du libelle du code CA de niveau 2 correspondant s'il existe
	if (!VerifierNum(form.codcamo,6,0))
	{
		return false;
	}
	rafraichir(form);
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" --> 
		  <bean:write name="clientForm" property="titrePage"/> un client<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td>
		  <!-- #BeginEditable "debut_form" --><html:form action="/client"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable -->
		  <div align="center"><!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>">
  				<html:hidden property="titrePage"/>
				<html:hidden property="action"/>
				<html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
				<html:hidden property="flaglock"/>
                <table border="0" cellspacing="2" cellpadding="2" class="tableBleu" >
                   	<tr>
					<td>&nbsp;</td>
					</tr>
					<tr>
					<td>&nbsp;</td>
					</tr>
					<tr>
	 				<td width=150 class="lib"><b>Code client :</b></td>
	 				<td colspan=2>
	 				<b> <bean:write name="clientForm" property="clicode"/><html:hidden property="clicode"/></b>
	 				</td>
					</tr>
     				<tr>
	 				<td class="lib"><b>Filiale :</b></td>
	 				<td colspan=2>
	 				<logic:notEqual parameter="action" value="supprimer">
	 					<html:select property="filcode" styleClass="input"> 
   						<html:options collection="choixFiliale" property="cle" labelProperty="libelle" />
						</html:select>
					</logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">
  						<bean:write name="clientForm" property="filcode"/><html:hidden property="filcode"/>
  					</logic:equal>
					</td>
					</tr>
     				<tr>
	 				<td class="lib"><b>Branche/Direction :</b></td>
	 				<td colspan=2>
	 				<logic:notEqual parameter="action" value="supprimer">
	 					<html:select property="cliDir" styleClass="input"> 
   						<html:options collection="choixDirmo" property="cle" labelProperty="libelle" />
						</html:select>
					</logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">
  						<bean:write name="clientForm" property="cliDir"/><html:hidden property="cliDir"/>
  					</logic:equal>
	 				</td></tr>
     				<tr>
					<td class="lib"><b>Département :</b></td>
					<td colspan=2>
					<logic:notEqual parameter="action" value="supprimer">
						<html:text property="cliDep" styleClass="input" size="4" maxlength="3" onchange="return ChangeDep(this.form);"/>
					</logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">	
  						<bean:write name="clientForm" property="cliDep"/><html:hidden property="cliDep"/>
  					</logic:equal>
					</td></tr>
					<tr>
					<td class="lib"><b>Pôle :</b></td>
					<td colspan=2>
					<logic:notEqual parameter="action" value="supprimer">
						<html:text property="cliPole" styleClass="input" size="3" maxlength="2" onchange="return ChangePole(this.form);"/>
					</logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">	
  						<bean:write name="clientForm" property="cliPole"/><html:hidden property="cliPole"/>
  					</logic:equal>
					</td></tr>
					<tr>
					<td class="lib"><b>Libellé :</b></td>
					<td colspan=2>
					<logic:notEqual parameter="action" value="supprimer">
						<html:text property="clilib" styleClass="input" size="27" maxlength="25" onchange="return VerifFormat(this.name);"/>
					</logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">	
  						<bean:write name="clientForm" property="clilib"/><html:hidden property="clilib"/>
  					</logic:equal>
					</td></tr>
					<tr>
					<td class="lib"><b>Sigle :</b></td>
					<td colspan=2 >
					<logic:notEqual parameter="action" value="supprimer">
						<html:text property="clisigle" styleClass="input" size="9" maxlength="8" onchange="return VerifFormat(this.name);"/>
					</logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">	
  						<bean:write name="clientForm" property="clisigle"/><html:hidden property="clisigle"/>
  					</logic:equal>
					</td></tr>
					<tr>
					<td class="lib"><b>Centre d'Activité MO :</b></td>
					<td colspan=2>
					<logic:notEqual parameter="action" value="supprimer">
						<html:text property="codcamo" styleClass="input" size="7" maxlength="6" onchange="ChangeCodeCAMO(this.form);"/>
					</logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">	
  						<bean:write name="clientForm" property="codcamo"/><html:hidden property="codcamo"/>
  					</logic:equal>
  					&nbsp;&nbsp;&nbsp;<bean:write name="clientForm" property="libCodeCAMO"/><html:hidden property="libCodeCAMO"/>
					</td>
					</tr>
				 	<tr>
				 	<td class="lib"><b>Top fermeture :</b></td>
				 	<td>
				 	<logic:notEqual parameter="action" value="supprimer">
				 		 <logic:iterate id="element" name="choixTopFermeture">
						<bean:define id="choix" name="element" property="cle"/>
						<html:radio property="clitopf" value="<%=choix.toString()%>"/>
			 			<bean:write name="element" property="libelle"/>
						</logic:iterate> 
					</logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">	
  						<bean:write name="clientForm" property="clitopf"/><html:hidden property="clitopf"/>
  					</logic:equal>
				 	</td>
				 	</tr>
     				<tr>
	 				<td class="lib"><b>Top DIVA lignes:</b></td>
	 				<td colspan=2>
	 				<logic:notEqual parameter="action" value="supprimer">
	 					<html:select property="top_diva" styleClass="input"> 
	 					<option value="" >A saisir</option>
   						<html:options collection="choixTop_diva" property="cle" labelProperty="libelle" />
						</html:select>
					</logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">
  						<bean:write name="clientForm" property="top_diva"/><html:hidden property="top_diva"/>
  					</logic:equal>
	 				</td></tr>
				 	<tr>
					<td >&nbsp;</td> 
					</tr>
					<tr>
					<td>&nbsp;</td>
					</tr>
			
             	</table><!-- #EndEditable --></div>
            
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
Integer id_webo_page = new Integer("1002"); 
com.socgen.bip.commun.form.AutomateForm formWebo = clientForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html> 

<!-- #EndTemplate -->