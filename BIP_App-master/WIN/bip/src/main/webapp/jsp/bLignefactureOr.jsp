 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,org.apache.commons.lang.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="ligneFactureForm" scope="request" class="com.socgen.bip.form.LigneFactureForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/bFactureOr.jsp"/> 
<%
  //Recuperation de la HashTable pour l'affichage des lignes factures
  java.util.ArrayList list1;
  if(session.getAttribute("hashTab")== null){
	  list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("lignesFacture",ligneFactureForm.getHParams());
  }else{
	  list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("lignesFacture",(java.util.Hashtable) session.getAttribute("hashTab"));
  }

  //java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("lignesFacture",ligneFactureForm.getHParams()); 
  pageContext.setAttribute("choixLignesFacture", list1);
%>

<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
var blnVerifFormat  = true;
var tabVerif        = new Object();
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";
function MessageInitial()
{

tabVerif["fmontht"] = "VerifierNum2(document.forms[0].fmontht,12,2)";
   tabVerif["ftva"]    = "VerifierNum2(document.forms[0].ftva,9,2)";
   var Message="<bean:write filter="false"  name="ligneFactureForm"  property="msgErreur" />";
   var Focus = "<bean:write name="ligneFactureForm"  property="focus" />";

   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else {
	  document.forms[0].fmontht.focus();
   }
}

function Verifier(form, action, mode, flag)
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
	if ( form.action.value == 'valider')  {
	   if (!ChampObligatoire(form.fmontht, "le montant total HT")) return false;
	   if (!ChampObligatoire(form.ftva, "le taux de TVA")) return false;
	}

	//if (form.LIGNES_FACT.length == 0) {
	  // nomOption = new Option(" ", "007",true,true);
	   //form.LIGNES_FACT.options[0] = nomOption;	}

	index = form.clelf.selectedIndex;
	if ( (index==-1) && (form.action.value != 'creer') && (form.action.value != 'valider') ) {
	   alert("Choisissez une ligne de facture");
	   return false;
	}
	
     form.keyList4.value = form.socfact.value;
	form.keyList5.value = form.cav.value;
	form.keyList6.value = form.numcont.value;
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Mise 
            &agrave; jour des lignes de facture<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> </td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/ligneFacture"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
            <input type="hidden" name="pageAide" value="<%= sPageAide %>">
			<html:hidden property="action" value="creer"/> 
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
			<html:hidden property="flaglock"/> 
			<input type="hidden" name="rapprochement" value="" >

   <table border=0 cellspacing=2 cellpadding=2 class="TableBleu">
	
	<tr>
	<td colspan=4>&nbsp;</td>
	</tr>
   <tr> 
                  <td class="lib" colspan="1">Code soci�t� :</td>
                  <td colspan=1><bean:write name="ligneFactureForm"  property="socfact" /> 
                    <html:hidden property="socfact"/>
                    </td>
       
                  <td class="lib" colspan="1">Soci�t� :</td>
                  <td colspan=1><bean:write name="ligneFactureForm"  property="soclib" /> 
                    <html:hidden property="soclib"/>
                  </td>
                </tr>
                <tr>
				
                  <td class="lib" colspan="1">N� de contrat :</td>
                  <td colspan=1> 
                    <bean:write name="ligneFactureForm"  property="numcont" /> 
                    <html:hidden property="numcont"/>
                  </td>
                  <td class="lib" colspan=1>N� d'avenant :</td>
                  <td colspan=1> 
                    <bean:write name="ligneFactureForm"  property="cav" /> 
                    <html:hidden property="cav"/>
                  </td>
                  
				  
                </tr>
                <tr> 
                  <td class="lib" colspan="1">N� de facture :</td>
                  <td colspan=1><bean:write name="ligneFactureForm"  property="numfact" /> 
                    <html:hidden property="numfact"/> 
                    </td>
                  <td class="lib" colspan=1>Type de facture :</td>
                  <td colspan=1><bean:write name="ligneFactureForm"  property="typfact" /> 
                    <html:hidden property="typfact"/> 
                  </td>
                </tr>
                <tr> 
                  <td class="lib" colspan="1">Date de facture :</td>
                  <td colspan=1><bean:write name="ligneFactureForm"  property="datfact" /> 
                    <html:hidden property="datfact"/>
                    </td>
                </tr>
   <tr>
	<td class="lib" colspan=1><b>Montant total HT :</b></td>
	
	<td colspan=1>
	<html:text  name="ligneFactureForm" property="fmontht" styleClass="input" size="13" maxlength="13" onchange="return VerifFormat(this.name);"/>
	</td>
	
	<td class="lib" colspan=1><b>Taux TVA :</b></td>
	<td colspan=1>
	<html:text name="ligneFactureForm" property="ftva" styleClass="input" size="5" maxlength="10" onchange="return VerifFormat(this.name);"/>
	</td>
   </tr>
 </table>
 <table border=0 cellspacing=2 cellpadding=2 class="TableBleu" width="440">
   <tr><td align=center colspan=5 >Liste des lignes de factures :</td></tr>

   <tr><td CLASS="lib" NOWRAP>
		
		<span STYLE="position: relative; left: 5px; z-index: 1;" >Ident</span>
		<span STYLE="position: relative; left: 20px; z-index: 1;">Nom</span>		
		<span STYLE="position: relative; left: 140px; z-index: 1;">Pr�nom</span>	
		<span STYLE="position: relative; left: 230px; z-index: 1;">Montant HT</span>	
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
<table  border="0" width=63%>
                      <tr> 
                        <td align="right" width=15%> <html:submit property="boutonCreer" value="Cr&#233er" styleClass="input" onclick="Verifier(this.form, 'creer','insert', true);"/> 
                        </td>
                        <td align="center" width="7%">&nbsp;</td>
                        <td align="center" width=15%> <html:submit property="boutonModifier" value="Modifier" styleClass="input" onclick="Verifier(this.form, 'modifier','update', true);"/> 
                        </td>
                        <td align="left" width=7%></td>
                        <td align="center" width=15%> <html:submit property="boutonSupprimer" value="Supprimer" styleClass="input" onclick="Verifier(this.form, 'supprimer','delete', true);"/> 
                        </td>
                        <td align="left" width="7%">&nbsp;</td>
                        <td align="left" width=15%> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider','majlig', true);"/> 
                        </td>
                        <td align="left" width="7%">&nbsp;</td>
                        <td align="left" width=15%> <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'valider', 'annuler', true);"/> 
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
