<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="majStatForm" scope="request" class="com.socgen.bip.form.MajStatForm" />
<html:html locale="true"> <!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> <bip:VerifUser page="jsp/fMajstatAd.jsp"/> 
<%
  java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("astatut", majStatForm.getHParams()); 
  java.util.ArrayList list2 = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("topImmo"); 
  
  pageContext.setAttribute("choixAstatut", list1);
  pageContext.setAttribute("choixTopFer", list2);
  
    
%>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
String initAstatut = majStatForm.getAstatut();

%>
var pageAide = "<%= sPageAide %>";

var blnVerifFormat  = true;
var tabVerif = new Object();
var tmpValue = {};
tmpValue.preValue = "<%=initAstatut%>";
function MessageInitial()
{
  var Message="<bean:write filter="false"  name="majStatForm"  property="msgErreur" />";
   var Focus = "<bean:write name="majStatForm"  property="focus" />";
   if (Message != "") {
  	   alert(Message);
   }
   if (Message == " La date saisie est antérieure au dernier bilan" ){
   		if (!confirm(" Etes-vous sûr de vouloir effectuer la modification ? " )) 
	 	return false;
		else
		document.forms[0].mode.value ="confirm";		
		document.forms[0].boutonValider.click();
	}
if (document.forms[0].topfer.value == "O") 
	{document.forms[0].top[0].checked = true;}
else {document.forms[0].top[1].checked = true;}

}

function Verifier(form, action,mode, flag)
{
   blnVerification = flag;
   form.action.value = action;
   form.mode.value = mode;
   
   if (document.forms[0].top[0].checked == true)
	{document.forms[0].topfer.value = "O";}
	else {document.forms[0].topfer.value = "N";}
   
}
function checkValue(){

var initVal= "<%=initAstatut %>";
tmpValue.postValue = document.forms[0].astatut.value;

if(tmpValue.postValue == 'C'){

if(initVal =='D' || initVal =='' || initVal =='A' || initVal =='N'  ){
				alert("Modification impossible, interdiction de passer de vide à C, ou de D à C, ou de A à C ou de N à C ");
				document.forms[0].astatut.value=initVal;
				return false;
		}
	if(tmpValue.preValue =='D' || tmpValue.preValue =='' || tmpValue.preValue =='A' || tmpValue.preValue =='N' ){
				alert("Modification impossible, interdiction de passer de vide à C, ou de D à C, ou de A à C ou de N à C ");
				document.forms[0].astatut.value=tmpValue.preValue;
				return false;
		}
							}
else{
tmpValue.preValue=tmpValue.postValue;
}

		}
		
function ValiderEcran(form)
{ 
if (blnVerification == true) {
		if ((form.action.value!="valider")&&(form.action.value!="annuler"))
  			form.action.value ="valider";
		
		var Message="<bean:write filter="false"  name="majStatForm"  property="msgErreur" />";
		
		form.commentaire.value=form.liste_objet.value;
		
		if ((form.top[0].checked) && (form.astatut.value != "")){
		 	alert("Il n'est pas possible d'avoir le top fermeture à OUI avec un statut différent de Pas de statut.");
	  	 	return false;
		}
		
		if (!form.top[0].checked && !form.top[1].checked) {
        	alert("Choisissez Ouvert ou Fermé");
        	return false;
     	}
		
		if ((form.top[0].checked) && (form.typproj.value == 1)){
		    if (!confirm("Voulez-vous fermer une ligne de type 1 en cours ?")) return false;
		}
		
		if (Message != " La date saisie est antérieure au dernier bilan") {
     		if (!confirm("Voulez-vous modifier le statut de cette ligne BIP ?")) return false;
		}
		
	
   }
   return true;
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Modifier 
            le statut d'une ligne BIP<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> </td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/majStat"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>"> <html:hidden property="action"/> 
                    <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
 <html:hidden property="flaglock"/> 
                    <html:hidden property="valid"/> 
					<html:hidden property="topfer"/> 
					<html:hidden property="commentaire"/> 
                    <table cellspacing="2" cellpadding="2" class="tableBleu" >
                      <tr> 
                        <td colspan=2 >&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan=2>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td class="lib">Code ligne BIP :</td>
                        <td><bean:write name="majStatForm"  property="pid" /> 
                          <html:hidden property="pid"/> &nbsp;-&nbsp; <bean:write name="majStatForm"  property="pnom" /> 
                          <html:hidden property="pnom"/>&nbsp; 
                      </tr>
                      <tr> 
                        <td class="lib" >Filiale :</td>
                        <td > <bean:write name="majStatForm"  property="filsigle" /> 
                          <html:hidden property="filsigle"/> </td>
                      </tr>
                      <tr> 
                        <td class="lib" colspan=1><b>Type <bean:write name="majStatForm"  property="typproj" /> 
                          <html:hidden property="typproj"/></b> </td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td class=lib><b>Statut de la ligne BIP :</b></td>
                        <td> <html:select property="astatut" styleClass="input" onchange="checkValue()"> 
                          <html:options collection="choixAstatut" property="cle" labelProperty="libelle" /> 
                          </html:select> </td>
                      </tr>
                      <tr> 
                        <td class=lib><b>Top fermeture :</b></td>
                        <td> <logic:iterate id="element" name="choixTopFer"> <bean:define id="choix" name="element" property="cle"/> 
                          <html:radio property="top" value="<%=choix.toString()%>"/> 
                          <bean:write name="element" property="libelle"/> </logic:iterate> 
                        </td>
                        
                      </tr>
                      <tr> 
                        <td class=lib>Date :</td>
                        <td> <html:text property="adatestatut" styleClass="input" size="7" maxlength="7" onchange="return VerifierDate(this,'mm/aaaa');"/> 
                        </td>
                      </tr>
                      <tr> 
                        <td class=lib>Dossier Projet :</td>
                        <td> <bean:write name="majStatForm"  property="dpcode" /> &nbsp;-&nbsp; <bean:write name="majStatForm"  property="dplib" /> &nbsp;(&nbsp;
                        	Immobilisé le :<bean:write name="majStatForm"  property="datimmo" /> &nbsp;-&nbsp;Actif : <bean:write name="majStatForm"  property="actif" />)
                        <html:hidden property="dpcode"/>
                        <html:hidden property="dplib"/>
                        <html:hidden property="datimmo"/>
                        <html:hidden property="actif"/>
                       </td>
                        
                      </tr>
                      <tr> 
                        <td class=lib>Projet :</td>
                        <td> <bean:write name="majStatForm"  property="icpi" /> &nbsp;-&nbsp; <bean:write name="majStatForm"  property="ilibel" /> &nbsp;&nbsp;(&nbsp;
                        	Statut :<bean:write name="majStatForm"  property="libstatut" /> &nbsp;-&nbsp;au : <bean:write name="majStatForm"  property="datstatut" />) 
                        <html:hidden property="icpi"/>
                        <html:hidden property="ilibel"/>
                        <html:hidden property="libstatut"/>
                        <html:hidden property="datstatut"/>
                       
                        </td>
                      </tr>
                      <tr><td colspan=2>
                       <table cellspacing="2" cellpadding="2" class="tableBleu" width="100%">
                      <tr> 
                        <td width="40%"><HR></td>
                        <td align="center"><b>Audit</b></td>
                        <td width="40%"><HR></td>
                      </tr>
                      
                      </table>
                      </td></tr> 
                       <tr><td colspan=2>
                       <table cellspacing="2" cellpadding="2" class="tableBleu" width="100%">
                      <tr> 
                        <td class="lib">Date de la demande :</td>
                        <td> <html:text property="date_demande" styleClass="input" size="10" maxlength="10" onchange="return VerifierDate2(this,'jjmmaaaa');"/> 
                        </td>
                        <td class="lib">Demandeur :</td>
                        <td> <html:text property="demandeur" styleClass="input" size="22" maxlength="15" onchange="return VerifierAlphanum(this);"/> 
                        </td>	
                      </tr>
                      <tr> 
                        <td class=lib>Commentaire :</td>
                        <td colspan=3>    
    <script language="JavaScript">
	var obj = document.forms[0].commentaire.value;
	document.write("<textarea name=liste_objet class='input' rows=3 cols=50 wrap onchange='return VerifierAlphanum(this);' >" + obj +"</textarea>");
	</script>
                        </td>
                      </tr>
                      
                      </table>
                      </td></tr> 
                      <tr> 
                        <td colspan=2>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan=2>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan=2>&nbsp;</td>
                      </tr>
                    </table>
			
			<table width="100%" border="0">
              <tr> 
                <td width="25%">&nbsp;</td>
                <td width="25%"> 
                  <div align="center"> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', this.form.mode.value,true);"/> 
                  </div>
                </td>
                <td width="25%"> 
                  <div align="center"> <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', null, false);"/> 
                  </div>
                </td>
                <td width="25%">&nbsp;</td>
              </tr>
            </table>
                    <!-- #EndEditable --></div>
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
</body>
<% 
Integer id_webo_page = new Integer("1060"); 
com.socgen.bip.commun.form.AutomateForm formWebo = majStatForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
