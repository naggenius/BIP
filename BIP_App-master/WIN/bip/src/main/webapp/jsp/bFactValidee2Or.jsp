 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="factValideeForm" scope="request" class="com.socgen.bip.form.FactValideeForm" />
<html:html locale="true"> <!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fFactValideeOr.jsp"/>
<%
java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("lignesFacture",factValideeForm.getHParams()); 
  pageContext.setAttribute("choixLignesFacture", list1);
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
var blnVerifFormat  = true;
var tabVerif        = new Object();

function MessageInitial()
{
   tabVerif["numcont"]  = "VerifierAlphaMaxCarSpecContrat(document.forms[0].numcont)";
   tabVerif["cav"]      = "VerifierAlphaMaxCarSpec(document.forms[0].cav)";
   tabVerif["fdeppole"] = "VerifierNum(document.forms[0].fdeppole,7,0)";

   var Message="<bean:write filter="false"  name="factValideeForm"  property="msgErreur" />";
   var Focus = "<bean:write name="factValideeForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else {
	  document.forms[0].numcont.focus();
   }

}

function Verifier(form, action,mode, flag)
{
  blnVerification = flag;
  form.action.value = action;
  form.mode.value = mode;
}

function ValiderEcran(form)
{
   var index = form.clelf.selectedIndex;

   if (blnVerification==true) {

	if ( !VerifFormat(null) ) return false;
	if (!ChampObligatoire(form.numcont, "un numéro de contrat")) return false;
	if (!ChampObligatoire(form.cav, "un numéro d'avenant")) return false;
	if (!ChampObligatoire(form.fdeppole, "un code Département/Pôle/Groupe")) return false;

	
	if (form.action.value == 'valider') {
	   form.clelf.selectedIndex = 0;
	   if (!confirm("Voulez-vous modifier cette facture validée par SEGL ?")) return false;
	}

	
	if  (form.action.value == 'modifier') {
		if ( index==-1 ) {
	   alert("Choisissez une ligne de facture");
	   return false;
		}
	}
	
   }
   return true;
}


function rechercheContrat(){

	window.open("/recupContrat.do?action=initialiser&soccont="+document.forms[0].socfact.value+"&nomChampDestinataire=numcont&nomChampDestinataire2=cav&windowTitle=Recherche Contrat&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=700, height=600") ;
	
}  

function nextFocusFdeppole(){
	document.forms[0].fdeppole.focus();
}


function rechercheDPG()
{
	window.open("/recupDPG.do?action=initialiser&nomChampDestinataire=fdeppole&windowTitle=Recherche Code DPG&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Correction 
            d'une facture valid&eacute;e par SEGL<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> </td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/factValidee"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
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
                  <html:hidden property="keyList2"/>
			<html:hidden property="keyList3"/> 
                  <html:hidden property="keyList4"/>
			<html:hidden property="keyList5"/> 
                  <html:hidden property="keyList6"/>
			<html:hidden property="keyList7"/> 
			<html:hidden property="test" value="lignes"/>
			<html:hidden property="msg_info"/>
					<html:hidden property="flaglock"/> 
<html:hidden property="fsocfour"/>
<html:hidden property="fmoiacompta"/> 

                    <table border=0 cellspacing=2 cellpadding=2 class="TableBleu">
                      <tr> 
                        <td colspan=6>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td class="lib">Code société :</td>
                        <td>
				<bean:write name="factValideeForm"  property="socfact" /> <html:hidden property="socfact"/>
                        </td>
                        <td class="lib">Société :</td>
                        <td colspan=3><bean:write name="factValideeForm"  property="soclib" /> <html:hidden property="soclib"/>
                        </td>
                      </tr>
                      <tr> 
                        <td class="lib"><b>N° de contrat :</b></td>
                        <td >
                        <html:text property="numcont" styleClass="input" size="15" maxlength="15" onchange="return VerifFormat(this.name);"/> 
                        <a href="javascript:rechercheContrat();" onFocus="javascript:nextFocusFdeppole();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Contrat" title="Rechercher Contrat" align="absbottom"></a>  
           				</td>
                        <td class="lib"><b>N° d'avenant :</b></td>
                        <td colspan=3> 
                          <html:text property="cav" styleClass="input" size="2" maxlength="2" onchange="return VerifFormat(this.name);"/> 
                        </td>
                      </tr>
                      <tr> 
                        <td class="lib">N° de facture :</td>
                        <td ><bean:write name="factValideeForm"  property="numfact" /> <html:hidden property="numfact"/>
                        </td>
                        <td class="lib">Type de facture :</td>
                        <td colspan=3><bean:write name="factValideeForm"  property="typfact" /> <html:hidden property="typfact"/>                        				</td>
                      </tr>
                      <tr> 
                        <td class="lib">Date de facture :</td>
                        <td>
					<bean:write name="factValideeForm"  property="datfact" /> <html:hidden property="datfact"/>                        					</td>
                      
                        <td class="lib"><b>Code DPG :</b></td>
                        <td colspan=3> 
                          <html:text property="fdeppole" styleClass="input" size="7" maxlength="7" onchange="return VerifFormat(this.name);"/>
                          <a href="javascript:rechercheDPG();" onFocus="javascript:nextFocusFdeppole();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code DPG" title="Rechercher Code DPG" align="absbottom"></a> 
                        </td>
                      </tr>
                      <tr> 
                        <td class="lib">Montant total HT :</td>
                        <td><bean:write name="factValideeForm"  property="fmontht" /> <html:hidden property="fmontht"/>                        </td>
                        
                        <td class="lib">Taux TVA :</td>
                        <td><bean:write name="factValideeForm"  property="ftva" /> <html:hidden property="ftva"/>                        </td>
         
                        <td class="lib">Montant total TTC :</td>
                        <td ><bean:write name="factValideeForm"  property="fmontttc" /> <html:hidden property="fmontttc"/>
                                                  </td>
                      </tr>
                     <tr> 
                        <td colspan=6>&nbsp;</td>
                      </tr>
                      	
</table>
<table border=0 cellspacing=2 cellpadding=2 class="TableBleu">

                      <tr> 
                        <td align=center colspan=5>Liste des lignes de factures 
                          :</td>
                      </tr>
                      <tr><td CLASS="lib" NOWRAP>
		
		<span STYLE="position: relative; left: 50px; z-index: 1;" >Ident</span>
		<span STYLE="position: relative; left: 70px; z-index: 1;">Nom</span>		
		<span STYLE="position: relative; left: 140px; z-index: 1;">Prénom</span>	
		<span STYLE="position: relative; left: 200px; z-index: 1;">Montant HT</span>	
	</td>
   </tr>

   <tr> 
                  <td> 
                  	<html:select property="clelf" styleClass="Multicol" size="5">
						  <bip:options collection="choixLignesFacture"/>
					 </html:select>
                 </td>
                </tr>
         
                    </table>
                    <table width="100%" border="0">
                      <tr> 
                        <td width="20%">&nbsp;</td>
                        <td width="20%"> 
                          <div align="center"> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', 'update',true);"/> 
                          </div>
                        </td>
                       <td width="20%" align="center"> <a href="/factValidee.do?action=annuler&mode=null"> 
                          <img src="../images/exit.gif" border=0 width=25 height=29 alt="Retour"></a></td>
                        <td width="20%"> 
                          <div align="center"> <html:submit property="boutonModifier" value="Modifier" styleClass="input" onclick="Verifier(this.form, 'modifier', null, true);"/> 
                          </div>
                        </td>
                        <td width="20%">&nbsp;</td>
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
