<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="ebisFactRejetForm" scope="request" class="com.socgen.bip.form.EbisFactRejetForm" />
<jsp:useBean id="listeRechercheId" scope="session"	class="com.socgen.ich.ihm.menu.PaginationVector" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fmEbisFactRejetOr.jsp"/> 
<% 	
	int nbligne = 0;
	String libTopEtat="";
	String libNumEnr="";
%>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;

<%
	String libFiliale=new String();
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	java.util.ArrayList list1 = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("topetat"); 
	pageContext.setAttribute("choixTopEtat", list1);
                     	 
%>
var pageAide = "<%= sPageAide %>";
var rafraichiEnCours = false;

function MessageInitial()
{
   var Message="<bean:write filter="false"  name="ebisFactRejetForm"  property="msgErreur" />";
   var Focus = "<bean:write name="ebisFactRejetForm"  property="focus" />";

   if (Message != "") {
      alert(Message);
   }
}
function Verifier(form, action, flag)
{
  blnVerification = flag;
  form.action.value = action;
}
function ValiderEcran(form)
{
	if (blnVerification==true){
	     if ((form.action.value!="valider")&&(form.action.value!="annuler"))
  		form.action.value ="valider";
  				
   		 if (form.mode.value == 'update') {
	        	if (!confirm("Valider modification")) return false;
	     	}
	  
   	}
 
   return true;
}

function raffraichiListe(){
	if(!rafraichiEnCours)
	{
	    
		rafraichir(document.forms[0]);
		rafraichiEnCours = true;
	}
}


function paginer(page, index , action){
	document.forms[0].action.value = action;
	document.forms[0].page.value   = page;
    document.forms[0].index.value  = index;
    document.forms[0].submit();
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
          <bean:write name="ebisFactRejetForm" property="titrePage"/> Facture expense rejetée
            <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/EbisFactRejet"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>">
             	<html:hidden property="action"/>
             	<html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
             	<html:hidden property="page" value="modifier"/>
             	<input type="hidden" name="index" value="modifier">
             	<html:hidden property="flaglock"/>
              <table cellspacing="2" cellpadding="2" class="tableBleu" width="95%">
                <tr> 
                  <td >&nbsp;</td>
                </tr>
                <tr> 
                  <td >&nbsp;</td>
                </tr>
                <tr> 
                 
                  <td class="lib" width="5%" ><b> Num enr </b></td>
                  <td class="lib" width="13%" ><b> Num contrat </b></td>
                  <td class="lib" width="5%" ><b> Num avenant </b></td>
                  <td class="lib" width="13%" ><b> Num fact </b></td>
                  <td class="lib" width="7%" ><b> Ressource </b></td>
                  <td class="lib" width="7%" ><b> Num expense </b></td>
                  <td class="lib" width="40%" ><b> Motif rejet </b></td>
                  <td class="lib" width="10%" ><b> Etat </b></td>
                </tr>

                <% int i =0;
                	String[] strTabCols = new String[] {  "fond1" , "fond2" }; 
          		%>     
               
               		<logic:iterate id="element"  name="listeRechercheId"  length="<%=listeRechercheId.getCountInBlock()%>" 
          					offset="<%=listeRechercheId.getOffset(0)%>" type="com.socgen.bip.metier.EbisFactRejet" indexId="index"> 
							<% if ( i == 0) i = 1; else i = 0;
							
							nbligne ++;
							libNumEnr="lib_numenr_"+nbligne;
							libTopEtat="lib_topetat_"+nbligne;
							
							%>
				   			<tr class="<%= strTabCols[i] %>">
								<td class="contenu" ><bean:write name="element" property="numenr" /></td>
								<input type="hidden" name="<%=libNumEnr%>" value="<bean:write name="element" property="numenr"/>" />
								<td class="contenu" ><bean:write name="element" property="numcont" /></td>
								<td class="contenu" ><bean:write name="element" property="cav" /></td>
								<td class="contenu" ><bean:write name="element" property="numfact" /></td>
								<td class="contenu" ><bean:write name="element" property="ident" /></td>
								<td class="contenu" ><bean:write name="element" property="num_expense" /></td>
								<td class="contenu" ><bean:write name="element" property="motif_rejet" /></td>
								<td>											
								<select name="<%=libTopEtat%>" class="input">																					 								 
								 
								 <logic:equal name="element" property="topetat" value="AT">
												<option value="AT" selected="selected">A traiter</option>							 
								 </logic:equal>
								 <logic:notEqual name="element" property="topetat" value="AT">
												<option value="AT" >A traiter</option>							 
								 </logic:notEqual>
								 
								  <logic:equal name="element" property="topetat" value="TR">
												<option value="TR" selected="selected">Traitée</option>							 
								 </logic:equal>
								 <logic:notEqual name="element" property="topetat" value="TR">
												<option value="TR" >Traitée</option>						 
								 </logic:notEqual>
								 
								 <logic:equal name="element" property="topetat" value="EA">
												<option value="EA" selected="selected">En attente</option>							 
								 </logic:equal>
								 <logic:notEqual name="element" property="topetat" value="EA">
												<option value="EA" >En attente</option>						 
								 </logic:notEqual>
								 

                           </select>	
                  				</td>	
	   						</tr>	   
					</logic:iterate>
               
              </table>
              <!-- #EndEditable --></div>
          </td>
        </tr>
        <tr> 
          <td align="center"> 
            <table width="100%" border="0">
              <tr>
					<td align="center" colspan="4" class="contenu">
					<bip:pagination beanName="listeRechercheId"/>
					 </td>
			  </tr>
              <tr> 
                <td width="25%">
                <div align="center">
                	 <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', true);"/>
                </div>
               	</td> 
               	<td width="25%"> 
                <div align="center"> 
                	 <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', false);"/>
              	</div>
                </td>
              </tr>
            </table>
            <!-- #BeginEditable "fin_form" --></html:form><!-- #EndEditable --> 
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<% 
Integer id_webo_page = new Integer("1018"); 
com.socgen.bip.commun.form.AutomateForm formWebo = ebisFactRejetForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
