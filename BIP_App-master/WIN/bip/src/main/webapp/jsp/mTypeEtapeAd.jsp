<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-nested.tld" prefix="nested" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,java.lang.*,java.util.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,com.socgen.bip.commun.liste.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="typeetapeForm" scope="session" class="com.socgen.bip.form.TypeEtapeForm" />

<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 
<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="/type_etape.do"/> 
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
document.onkeypress = VerifEntree;
function VerifEntree() {

	if (window.event.type == "keypress" & window.event.keyCode == 13 & !hasFocusBoutonAnnuler) {
		
			(document.getElementsByName('boutonValider')[0]).click();
	}
			
}
var blnVerification = true;
var formradio = false;
var hasFocusBoutonAnnuler = false;

function HaveFocus() {
	hasFocusBoutonAnnuler = true;
}

function LoseFocus() {
	hasFocusBoutonAnnuler = false;
}

<%
	
	Hashtable hKeyList= new Hashtable();
	hKeyList.put("userid", ""+((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());

	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
	String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	java.util.ArrayList top_immo = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("ouiNon"); 
	//java.util.ArrayList topActif = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("topActif");
	pageContext.setAttribute("choixTopImmo", top_immo);
	
	int nbre_jeu =  typeetapeForm.getJeu_associe().size();
	
%>
var pageAide = "<%= sPageAide %>";
var nbre_jeu = "<%= nbre_jeu %>";



function MessageInitial()
{
   var Message="<bean:write filter="false"  name="typeetapeForm"  property="msgErreur" />";
   var Focus = "<bean:write name="typeetapeForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   
   if (document.forms[0].mode.value == 'insert') {
   		document.forms[0].top_immo[1].checked=true;
   }
   
   // en cas d'erreur sur la chronologie la base nous renvoie le focus suivant chrono[index en erreur]
   // on separe donc le focus chrono et l'index pour traitement du veritable focus
   if ('chrono' == Focus.substring(0,6))
   {
  	 focus_chrono = "jeu_associe["+Focus.substring(6,Focus.length)+"].chronologie";
  	(eval( 'document.forms[0].elements["'+focus_chrono+'"]')).focus();
   }
   else
   {  
   	if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   	else if (document.forms[0].mode.value!='delete'){
	   document.forms[0].libelle.focus();
   	}
   }
}

function Verifier(form, action, mode,flag)
{
   blnVerification = flag;
   form.action.value = action;
}

function ValiderEcran(form)
{

var top= "<bean:write name="typeetapeForm"  property="top_immo" />";
 
  if (blnVerification == true) {
  	  		 
     if (form.mode.value == 'delete') {
     	if (!confirm("Etes-vous sûr de vouloir supprimer ce type d'étape et avez-vous vérifié qu'il n'est pas déjà utilisé ?")) return false;
	 }
	 else {
	     if (!ChampObligatoire(form.libelle, "le libelle")) return false;
	      var LesRadios = document.getElementsByName("top_immo");	
		 for (i=0; i<LesRadios.length; i++){
			 if (LesRadios[i].checked) {
			  var top1=LesRadios[i].value;
			 	formradio = true;
			 	break;
			 }
		 }
		 if (!formradio) {
		 	alert("Saisir le Top immobilisable");
		 	return false;
		 }
		 //alert('Avant type');
		if(!TypeLigneVerif()) {
			document.forms[0].typeLigne.focus();
			return false;
		}
		// alert('apres type');
		 if (form.mode.value == 'insert')
		 {
		 	temp = 0;
		 	for (i=0; i<nbre_jeu; i++)
		 	{
		 		champ= "jeu_associe["+i+"].chronologie";
  				if ((eval( 'document.forms[0].elements["'+champ+'"]')).value == "" || (eval( 'document.forms[0].elements["'+champ+'"]')).value == " " )
  				{
  					valeur = 0;
  				}
  				else
  				{
  				 	valeur = parseInt((eval( 'document.forms[0].elements["'+champ+'"]')).value,10);
  				}
  				temp = temp + valeur;			
  			} 
  			if (temp == 0)
  				{
  					alert("Vous devez saisir au moins un n° chronologique non nul");
  					return false;
  				} 
   		 }
		
		 if (form.mode.value == 'update') {
	     	if (top != top1)
	     	{
	     		if (!confirm("Confirmez-vous la modification du Top immobilisable ?")) return false;
	     	}
	        if (!confirm("Voulez-vous modifier ce type d'étape ?")) return false;
	     }
     }
   }
  //alert('apres 2 type');
  document.forms[0].submit();
}

//PPM 60709 : HMI : contrôle de typeLigne format et typologie
//PPM 60709 : KRA ajout de encodeURIComponent pour garder l'espace à la fin de l'url
function TypeLigneVerif() {
	ajaxCallRemotePage('/type_etape.do?action=TypeLigneVerifVal&typeLigne=' + encodeURIComponent(document.forms[0].typeLigne.value));
	var respAjax = document.getElementById("ajaxResponse").innerHTML;
	var respAjaxSplit = '';
	var mesgRetour = '';
	
	var respAjaxSplitFin = '';
	var mesgFin = '';
	
	if (document.getElementById("ajaxResponse").innerHTML != '') {
		respAjaxSplit = respAjax.split("\\n");
		for (var i = 0; i < respAjaxSplit.length; i++) {
			mesgRetour = mesgRetour + respAjaxSplit[i] + "\n";
		}
		
		respAjaxSplitFin = mesgRetour.split("\\t");
		for (var i = 0; i < respAjaxSplitFin.length; i++) {
			mesgFin = mesgFin + respAjaxSplitFin[i] + "\t";
		}
		alert(mesgFin);
	 	return false;
	}
	
	
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
          <bean:write name="typeetapeForm" property="titrePage"/> un type d'étape<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/type_etape" ><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
			<input type="hidden" name="pageAide" value="<%= sPageAide %>">
			  <html:hidden property="titrePage"/>
              <html:hidden property="action" value="creer"/>
              <html:hidden property="mode"/>
              <html:hidden property="flaglock"/>
              <html:hidden property="arborescence" value="<%= arborescence %>"/>
			  <table cellspacing="2" cellpadding="2" class="tableBleu" border="0">
			    <tr> 
                  <td colspan="4" >&nbsp;</td>
                </tr>
                <tr> 
                  <td class="lib"><b>Code type d'étape :</b></td>
                  <td colspan="2"><b><bean:write name="typeetapeForm"  property="type_etape" /></b> 
                    <html:hidden property="type_etape"/>
                  </td>
				  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="lib"><b>Libelle :</b></td>
                  <td colspan="2"> 
                    <logic:notEqual parameter="action" value="supprimer">
 						<html:text property="libelle" styleClass="input" size="60" maxlength="60"  onchange="return  VerifAlphaMaxCarSpecSansEff(this,'Libellé');"/>
					</logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">
  						<bean:write name="typeetapeForm"  property="libelle" />
                    	<html:hidden property="libelle"/>
  					</logic:equal>
                  </td>
				  <td >&nbsp;</td>
                </tr>
                <tr> 
                  <td class="lib"><b>Top immobilisable :</b></td>
                  <td colspan="2"> 
                    <logic:notEqual parameter="action" value="supprimer">
				 		 <logic:iterate id="element" name="choixTopImmo">
							<bean:define id="choix" name="element" property="cle"/>
								<html:radio property="top_immo" value="<%=choix.toString()%>"/>
			 				<bean:write name="element" property="libelle"/>
						</logic:iterate> 
					</logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">	
  					<% if (typeetapeForm.getTop_immo().equals("N"))
  						   typeetapeForm.setTop_immo("Non");
  						else
  							typeetapeForm.setTop_immo("Oui");
  						%>
  						<bean:write name="typeetapeForm" property="top_immo"/>
  					</logic:equal>
                    </td>
					<td >&nbsp;</td>
                </tr>
                
                
                 <tr> 
                  <td class="lib"><b>Types de lignes Bip autorisées :</b></td>
                  <td colspan="2"> 
                    <logic:notEqual parameter="action" value="supprimer">
 						<html:text property="typeLigne" styleClass="input" size="60" maxlength="209"  onchange="return  VerifAlphaMaxCarSpecSansEff(this,'typeLigne');"/>
					</logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">
  					<!-- PPM 60709 : KRA ajout des espaces après la virgule pour ne pas déformer la tableau en cas d'une chaine très longue -->
  					<% 
  						String txt = typeetapeForm.getTypeLigne();
  						String typLigne = "";
  						if(txt != null && !"".equals(txt)) 
  							typLigne = txt.replace("," , ", ");
  					%>
  						<%=typLigne%>
                    	<html:hidden property="typeLigne"/>
  					</logic:equal>
                 </td>
                 <td>
                <font color="red"> Si vide : toutes les lignes productives peuvent utiliser ce type d'étape </font>
                   </td>
                </tr>
                
                
                <tr> 
                  <td colspan="4" >&nbsp;</td>
                </tr>
               <tr> 
                  <td ><b>Jeux associés</b></td>
                   <td><b>N° chronologique</b></td>
                   <td rowspan="4">0 ==> non associé à ce jeu <br><br>
                   Conseils : <br>
                   &nbsp; * commencer la numérotation à 10 <br>
                   &nbsp; * laisser un intervalle de 5 entre les <br>
                   &nbsp; codes types d'étapes
                   </td>
				   <td>&nbsp;</td>
                </tr>
              <%int index = 0; %>
                <nested:iterate name="typeetapeForm" property="jeu_associe" >
                <%index++; %>
                <tr>
                   <td><nested:write property="jeu" /></td>
					 
					<td>
					<logic:notEqual parameter="action" value="supprimer">
						<nested:text property="chronologie" styleClass="input" size="2" maxlength="2"  onchange="return VerifierNum(this,2,0);"/>
					</logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">
  						<nested:write property="chronologie" />
  					</logic:equal>
  					</td>
  					<%if (index > 3) { %>
  					 <td >&nbsp;</td>
  					 <%} %>
					<td>&nbsp;</td>
				</tr>     
                </nested:iterate>    
                 <tr> 
                  <td colspan="4" >&nbsp;</td>
                </tr> 
               </table>
			  <!-- #EndEditable --></div>
          </td>
        </tr>
        <tr> 
          <td align="center"> 
            <table width="100%" border="0">
              <tr> 
                <td width="25%">&nbsp;</td>
                <td width="25%"> 
                  <div align="center"> <html:button property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', this.form.mode.value,true);ValiderEcran(this.form);"/> 
                  </div>
                </td>
                <td width="25%"> 
                  <div align="center"> <html:button property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', null, false);ValiderEcran(this.form);" onfocus="HaveFocus();" onblur="LoseFocus();" /> 
                  </div>
                </td>
                <td width="25%">&nbsp;</td>
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
</body>
<% 
Integer id_webo_page = new Integer("1001"); 
com.socgen.bip.commun.form.AutomateForm formWebo = typeetapeForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
