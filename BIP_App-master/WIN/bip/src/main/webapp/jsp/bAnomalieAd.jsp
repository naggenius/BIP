 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="anomalieForm" scope="request" class="com.socgen.bip.form.AnomalieForm" />
<html:html locale="true"> <!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/bAnomalieAd.jsp"/>

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
var tabVerif        = new Object();

function MessageInitial()
{
   tabVerif["codsg"]	= "VerifierRegExp(document.forms[0].codsg,'[0-9]{7}|[0-9]{5}\\\\*{2}|[0-9]{3}\\\\*{4}','Saisie invalide')";
   tabVerif["ident"]   = "VerifierNum(document.forms[0].ident,5,0)";

   var Message="<bean:write filter="false"  name="anomalieForm"  property="msgErreur" />";
   var Focus = "<bean:write name="anomalieForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else {
	  document.forms[0].ident.focus();
   }
   
   	//Affichage du DPG par défaut
	//document.anomalieForm.codsg.value = Replace_DoubleZero_by_DoubleEtoile( "<bean:write name="UserBip"  property="dpg_Defaut" />" );
}

function Verifier(form, action, flag)
{
  blnVerification = flag;
  form.action.value = action;
 //form.mode.value = mode;
}

function ValiderEcran(form)
{
   if (blnVerification == true) {
		if (form.matricule.value==""&&form.ident.value==""&&form.codsg.value=="")
		{alert("Entrez un code");
		return false;}
				
	if (((form.matricule.value!="")&&(form.ident.value!="")&&(form.codsg.value!=""))||
		((form.matricule.value!="")&&(form.ident.value!=""))||
		((form.matricule.value!="")&&(form.codsg.value!=""))||
		((form.codsg.value!="")&&(form.ident.value!="")))
		{ alert("Une seule sélection possible");
		form.matricule.value="";
		form.ident.value="";
		form.codsg.value="";
		form.matricule.focus();
		return false;}

		
	if(!Ctrl_dpg_generique(form.codsg))
	{

		return false;
	} 

	if (form.ident.value!=""||form.matricule.value!="")
	{form.mode.value="ress";
		form.keyList0.value=form.matricule.value;
		//form.matricule.value;
		form.keyList1.value=form.ident.value;
		return true;}
	if (form.codsg.value!="")
	{form.mode.value="dpg";
	form.keyList0.value=form.codsg.value;
		return true;}
		
   }
   return true;
}

function rechercheDPG()
{
	window.open("/recupDPG.do?action=initialiser&nomChampDestinataire=codsg&windowTitle=Recherche Code DPG&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
}

function nextFocusCodeDPG(){
	document.forms[0].codsg.focus();
}

function rechercheID(){
	window.open("/recupIdPersonne.do?action=initialiser&nomChampDestinataire=ident&windowTitle=Recherche Identifiant Personne&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Bouclage 
            Jour/Homme - Validation des erreurs<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> </td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/anomalie"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>"> 
			<html:hidden property="action"/>
			<html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/> 
			<html:hidden property="keyList0"/>
			<html:hidden property="keyList1"/>
                    <table cellspacing="2" cellpadding="2" class="tableBleu">
                      <tr> 
                        <td colspan=5>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan=5>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="5" align=center><b> S&eacute;lection des 
                          ressources &agrave; pointer </b></td>
                      </tr>
                      <tr> 
                        <td colspan="5" align=center>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td class=lib>Matricule :</td>
                        <td colspan="3">
						<html:text property="matricule" styleClass="input" size="8" maxlength="7" onchange="return VerifierAlphaMax(this);"/>  
                        </td>
                      <tr> 
                        <td><u>OU</u></td>
                        <td class=lib>Code ressource BIP :</td>
                        <td>
						<html:text property="ident" styleClass="input" size="5" maxlength="5" onchange="return VerifFormat(this);"/>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:rechercheID();" onFocus="javascript:nextFocusCodeDPG();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Identifiant" title="Rechercher Identifiant" align="absbottom"></a></td>
                      <tr> 
                        <td><u>OU</u></td>
                        <td class=lib>Code DPG :</td>
                        <td colspan="3">
						<html:text property="codsg" styleClass="input" size="7" maxlength="7" onchange="return Ctrl_dpg_generique(this);return VerifFormat(this);"/>
						&nbsp;&nbsp;<a href="javascript:rechercheDPG();" onFocus="javascript:nextFocusCodeDPG();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code DPG" title="Rechercher Code DPG" align="absbottom"></a>   
                        </td>
                      </tr>
                      <tr> 
                        <td colspan="2">&nbsp;</td>
                        <td colspan="3">&nbsp;</td>
                      <tr> 
                        <td colspan="2">&nbsp;</td>
                        <td colspan="3">&nbsp;</td>
                      <tr> 
                        <td colspan="2">&nbsp;</td>
                        <td colspan="3">&nbsp;</td>
                    </table>
                    <table  border="0" width=100%>
                      <tr> 
                        <td  width=100% align=center> <html:submit property="boutonSelectionner" value="S&eacute;lectionner" styleClass="input" onclick="Verifier(this.form, 'suite', true);"/> 
                        </td>
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
</body></html:html>
<!-- #EndTemplate -->
