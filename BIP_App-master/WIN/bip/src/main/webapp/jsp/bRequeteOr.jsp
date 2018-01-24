<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/ajaxtags.tld" prefix="ajax" %>


<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<html:html locale="true"> 
<jsp:useBean id="requeteForm" scope="request" class="com.socgen.bip.form.RequeteForm" />
<jsp:useBean id="listeRechercheId" scope="session"	class="com.socgen.ich.ihm.menu.PaginationVector" />
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
<script type="text/javascript" src="../js/ajax/prototype.js"></script>
<script type="text/javascript" src="../js/ajax/scriptaculous/scriptaculous.js"></script>
<script type="text/javascript" src="../js/ajax/overlibmws/overlibmws.js"></script>
<script type="text/javascript" src="../js/ajax/overlibmws/overlibmws_crossframe.js"></script>
<script type="text/javascript" src="../js/ajax/overlibmws/overlibmws_iframe.js"></script>
<script type="text/javascript" src="../js/ajax/overlibmws/overlibmws_hide.js"></script>
<script type="text/javascript" src="../js/ajax/overlibmws/overlibmws_shadow.js"></script>
<script type="text/javascript" src="../js/ajax/ajaxtags.js"></script>
<script type="text/javascript" src="../js/ajax/ajaxtags_controls.js"></script>
<script type="text/javascript" src="../js/ajax/ajaxtags_parser.js"></script>
 
<link rel="stylesheet" type="text/css" href="../css/ajax/ajaxtags_bRequeteOr.css" />
<link rel="stylesheet" type="text/css" href="../css/ajax/displaytag.css" />

<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/bRequeteOr.jsp"/> 
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">


<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	String sPerim = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("perim")));
	int nbligne = 0;
%>
var pageAide = "<%= sPageAide %>";
var perim = "<%= sPerim %>";

var blnVerifFormat  = true;
var tabVerif = new Object();

function MessageInitial()
{
   var Message="<bean:write filter="false"  name="requeteForm"  property="msgErreur" />";
   var Focus = "<bean:write name="requeteForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }

}

function Verifier(form, action, mode,flag)
{
   blnVerification = flag;
   form.action.value = action;
}

function ValiderEcran(form)
{
   return true;
}

function paginer(page, index , action){
	document.forms[0].action.value = action;
	document.forms[0].page.value   = page;
    document.forms[0].index.value  = index;
    document.forms[0].submit();
}

function init(){
	document.forms[0].ident.value = '';
	document.forms[0].nom.value='';
	document.forms[0].num_contrat.value='';
	document.forms[0].fournisseur.value='';
	document.forms[0].siren.value='';

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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Recherche de contrat dans la BIP<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> </td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/requete"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
             <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
				   <input type="hidden" name="pageAide" value="<%= sPageAide %>">
				   <input type="hidden" name="perim" value="<%= sPerim %>">
                  	<html:hidden property="action"/>
					<html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
					<html:hidden property="page" value="modifier"/>
					<input type="hidden" name="index" value="modifier">
                  
                      
                  <table width="100%" border="0" cellpadding=2 cellspacing=2 class="tableBleu">
                      <tr> 
                        <td>&nbsp; </td>
                        <td>&nbsp; </td>
                        <td>&nbsp; </td>
                        <td>&nbsp; </td>
                      </tr>
                      <tr> 
                        <td align="center" colspan=4><b>Veuillez saisir un critère de recherche : </b></td>
                      </tr>
                      <tr> 
                        <td>&nbsp; </td>
                        <td>&nbsp; </td>
                        <td>&nbsp; </td>
                        <td>&nbsp; </td>
                      </tr>
                     </table> 
                     <table width="100%" border="0" cellpadding=2 cellspacing=2 class="tableBleu"> 
                      <tr>
                       <td align="right">Nom ressource: </td>
                       <td align="left">
                       <html:text property="nom" styleClass="input" size="30" maxlength="30" onclick="init();"/>
                       <html:hidden property="ident" styleClass="input" size="10" maxlength="10" />
                        <span id="indicator1" style="display:none;"><img src="../images/indicator.gif" /></span>
                       </td>
                       <td align="right" >SIREN: </td>
                       <td align="left">
                       <html:text property="siren" styleClass="input" size="20" maxlength="9" onclick="init();"/>
                        <span id="indicator3" style="display:none;"><img src="../images/indicator.gif" /></span>
                        </td>
                        <td width="20%">&nbsp; </td>
                       </tr>
                       <tr>
                       <td align="right">Numéro de contrat: </td>
                       <td align="left">
                       <html:text property="num_contrat" styleClass="input" size="30" maxlength="27" onclick="init();"/>
                        <span id="indicator2" style="display:none;"><img src="../images/indicator.gif" /></span>
						 
                        </td>
                        <td align="right">Fournisseur: </td>
                       <td align="left">
                       <html:text property="fournisseur" styleClass="input" size="20" maxlength="25" onclick="init();" />
                        <span id="indicator4" style="display:none;"><img src="../images/indicator.gif" /></span>
                        </td>
                        <td >&nbsp; </td>

                       </tr>
                       <tr> 
                        <td>&nbsp; </td>
                        <td>&nbsp; </td>
                        <td>&nbsp; </td>
                        <td>&nbsp; </td>
                        <td>&nbsp; </td>
                      </tr>
                     
                      </table>
<ajax:autocomplete
								  source="nom"
  								  target="ident"
  								  parameters="libelle={nom}"
 								  baseUrl="/autocompleteNom.do"
  								  className="autocomplete"
                                  indicator="indicator1"
                                  minimumCharacters="2"/>				 
<ajax:autocomplete
								  source="siren"
  								  target="siren"
  								  parameters="libelle={siren}"
 								  baseUrl="/autocompleteSiren.do"
  								  className="autocomplete"
                                  indicator="indicator3"
                                  minimumCharacters="2"/>	
                                  
<ajax:autocomplete
								  source="num_contrat"
  								  target="num_contrat"
  								  parameters="libelle={num_contrat}"
 								  baseUrl="/autocompleteContrat.do"
  								  className="autocomplete"
                                  indicator="indicator2"
                                  minimumCharacters="2"/>                                   
                                  
<ajax:autocomplete
								  source="fournisseur"
  								  target="siren"
  								  parameters="libelle={fournisseur}"
 								  baseUrl="/autocompleteFournisseur.do"
  								  className="autocomplete"
                                  indicator="indicator4"
                                  minimumCharacters="2"/>
                                  		  
			 <table  border="0" width=85%>
              <tr> 
                <td  align="center" width="25%"><html:submit property="boutonConsulter" value="Consulter" styleClass="input" onclick="Verifier(this.form, 'refresh', true);"/></td>
              </tr>
			  </table>
<!-- ######################################## RESULTAT ##################################################### -->

<% 

try
{
if (listeRechercheId.getCount()==0 && ( !requeteForm.getIdent().equals(null) || !requeteForm.getSiren().equals(null) || !requeteForm.getNum_contrat().equals(null)) ) {%><!--  IF -->
<table width="100%" border="0" cellpadding=2 cellspacing=2 class="tableBleu">
   <tr> 
      <td>&nbsp; </td>
   </tr>
   <tr> 
       <td align="center"><b>Votre recherche ne ramène aucun résultat</b></td>
    </tr>
</table>
<% } else {%><!--  ELSE -->
			<table cellspacing="2" cellpadding="2" class="tableBleu" WIDTH="95%" align="center">
				<tr><td >&nbsp;</td><td  >&nbsp;</td></tr>
				<tr><td >&nbsp;</td><td  >&nbsp;</td></tr>
				<tr align="center" >
						<%//if("true".equals(sPerim)) { QC 1623 (PPM 50441)%>
						<td class="lib" nowrap><b>Code sté</b></td>
						<%//} QC 1623 (PPM 50441)%>
						<td class="lib" nowrap><b>Nom du fournisseur</b></td>
                  		<td class="lib" nowrap><b>SIREN</b></td>
                  		<td class="lib" nowrap><b>Nom prestataire</b></td>
                  		<td class="lib" nowrap><b>Prénom prestataire</b></td>
                  		<td class="lib" nowrap><b>Ident BIP</b></td>
                  		<td class="lib" nowrap><b>N° contrat</b></td>
                  		<td class="lib" nowrap><b>CAV</b></td>
                  		<td class="lib" nowrap><b>DPG</b></td>
                  		<td class="lib" nowrap><b>date début</b></td>
                  		<td class="lib" nowrap><b>date fin</b></td>
    			</tr>
<% int i =0;
    String[] strTabCols = new String[] {  "fond1" , "fond2" };
    String[] extension = new String[] { "Violet.bmp" , ".bmp" };
%>     
    <logic:iterate id="element"  name="listeRechercheId"  length="<%=listeRechercheId.getCountInBlock()%>" 
          					offset="<%=listeRechercheId.getOffset(0)%>" type="com.socgen.bip.metier.Requete" indexId="index"> 
							<% if ( i == 0) i = 1; else i = 0; nbligne ++; 	%>
			<tr class="contenu" align="center" >
										<%//if("true".equals(sPerim)) { QC 1623 (PPM 50441)%>
										<td class="<%= strTabCols[i] %>" nowrap><bean:write name="element" property="code" /></td>
										<%//} QC 1623 (PPM 50441)%>
										<td class="<%= strTabCols[i] %>" nowrap><bean:write name="element" property="fournisseur" /></td>
										<td class="<%= strTabCols[i] %>" nowrap><bean:write name="element" property="siren" /></td>
										<td class="<%= strTabCols[i] %>" nowrap><bean:write name="element" property="nom" /></td>
										<td class="<%= strTabCols[i] %>" nowrap><bean:write name="element" property="prenom" /></td>
										<td class="<%= strTabCols[i] %>" nowrap><bean:write name="element" property="ident" /></td>
										<td class="<%= strTabCols[i] %>" nowrap><bean:write name="element" property="num_contrat" /></td>
										<td class="<%= strTabCols[i] %>" nowrap><bean:write name="element" property="cav" /></td>
										<td class="<%= strTabCols[i] %>" nowrap><bean:write name="element" property="lib_dpg" /></td>
										<td class="<%= strTabCols[i] %>" nowrap><bean:write name="element" property="datdeb" /></td>
										<td class="<%= strTabCols[i] %>" nowrap><bean:write name="element" property="datfin" /></td>
			</tr>							
	</logic:iterate>
	<tr>
		<td align="center" colspan="7" class="contenu"><bip:pagination beanName="listeRechercheId"/></td>
	</tr>
</table>
<% } 

}
 catch (Exception e) 
 { }
 %><!-- FIN ELSEIF -->
<!-- ######################################## FIN RESULTAT ##################################################### --> 
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


                                  
                                  
</body><% 
Integer id_webo_page = new Integer("1001"); 
com.socgen.bip.commun.form.AutomateForm formWebo = requeteForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
