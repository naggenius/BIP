<!DOCTYPE html>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,java.lang.Integer"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="multiCAForm" scope="request" class="com.socgen.bip.form.MultiCAForm" />
<jsp:useBean id="listeCALigneBIP" scope="session"	class="com.socgen.ich.ihm.menu.PaginationVector" />
<html:html locale="true"> 

<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<title>Page BIP</title>
 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<bip:VerifUser page="jsp/fMulticaAd.jsp"/> 
<script language="JavaScript" src="../js/function.cjs"></script>
<!-- <link rel="stylesheet" href="../css/base_style.css" type="text/css"> -->
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";


function MessageInitial()
{
   var Message="<bean:write filter="false"  name="multiCAForm"  property="msgErreur" />";
   var Focus = "<bean:write name="multiCAForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
  if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
}

function Verifier(form, action)
{
  form.action.value = action;
}
function VerifierAjout(form, action)
{
  if (!ChampObligatoire(form.datdeb, "une date de début")) return false;
  if (!ChampObligatoire(form.codcamo, "un code CA payeur")) return false;
  if (!ChampObligatoire(form.tauxrep, "un taux de répartition")) return false;
  if (!ChampObligatoire(form.clicode, "un code client")) return false;
  form.action.value = action;
}

function ValiderEcran(form)
{
    return true;
}
function paginer(page, index , action){
	document.forms[0].action.value =action;
	document.forms[0].page.value=page;
    document.forms[0].index.value=index;
    document.forms[0].submit();
}
</script>
 
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
<div id="mainContainer">
<div id="topContainer" style="min-height:98%;">
<div id="entete"></div>
<div id="logo">
		<div id="logo_sg"><img src="../images/logo_SG.gif" width="162" height="33" border="0" /></div>
		<div id="nomdusite"><img src="../images/bip_logo.png" width="78" height="46" border="0" /></div>
</div>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr > 
          <td> 
            &nbsp;
          </td>
        </tr>
        <tr> 
          <td><div id="outils" align="center"><!-- #BeginEditable "barre_haut" -->
              <%ToolBarNew tb = new com.socgen.ich.ihm.ToolBarNew("bip_ihm",false,false,true,true,false,false,false,false,false,request) ;%>
				<%=tb.printHtml()%><!-- #EndEditable -->
		</div></td>
        </tr>
<!--         <tr>  -->
<!--           <td background="../images/ligne.gif"></td> -->
<!--         </tr> -->
        <tr align="left"> 
          <td height="20" class="TitrePage">Saisie des CA rattachés à une ligne BIP</td>
        </tr>
<!--         <tr>  -->
<!--           <td background="../images/ligne.gif"></td> -->
<!--         </tr> -->
        <tr> 
          <td height="20"> </td>
        </tr>
        <tr> 
          <td>
          	<html:form action="/multiCA"  onsubmit="return ValiderEcran(this);"> 
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center">
					<input type="hidden" name="pageAide" value="<%= sPageAide %>">
                    <html:hidden property="action"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
                    <html:hidden property="page" value="listeCALigneBIP"/>
                    <html:hidden property="anneeExercice"/>
                    <input type="hidden" name="index">
				    <table border=0 cellspacing=2 cellpadding=2 class="TableBleu">
				      <tr>
                        <td colspan=4>&nbsp;</td>
                      </tr>
                      <tr align="left">
                        <td class="texte">Code Ligne BIP :</td>
                        <td colspan=3 class="texte">
                        	<bean:write name="multiCAForm" property="pid"/> <bean:write name="multiCAForm" property="pnom"/>
                        	<html:hidden property="pid"/><html:hidden property="pnom"/>
                        </td>
                      </tr>
                     
                      <tr>
                        <td colspan=4 height="15">&nbsp;</td>
                      </tr>
                      <tr align="left">
                      	<td class="texte"><b>Date de début :</b></td>
                      	<td>
                      		<html:text property="datdeb" styleClass="input" size="7" maxlength="7" onchange="return VerifierDate(this,'mm/aaaa');"/>
                      	</td>
                      	<td class="texte"><b>CA Payeur :</b></td>
                      	<td>
                      		<html:text property="codcamo" styleClass="input" size="6" maxlength="6" onchange="return VerifierNum(this,6,0);"/>
                      	</td>
                      </tr>
                      <tr align="left">
                      	<td class="texte"><b>Taux de répartition :</b></td>
                      	<td>
                      		<html:text property="tauxrep" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,5,2);"/>
                      	</td>
                      	<td class="texte"><b>Code client :</td>
                      	<td>
                      		<html:text property="clicode" styleClass="input" size="5" maxlength="5" onchange="return VerifierAlphaMax(this);"/>
                      	</td>
                      </tr>
                      <tr>
                        <td colspan=4 height="15" >&nbsp;</td>
                      </tr>
                      <tr align="left">
                        <td colspan=4>
                        	<html:submit property="boutonValider" value="          Ajouter à la liste des clients facturés          " styleClass="input" onclick="return VerifierAjout(this.form, 'refresh');"/>
                        </td>
                      </tr>
                      <tr>
                        <td colspan=4 height="15">&nbsp;</td>
                      </tr>
                    </table>
                    <table border=0 cellspacing=0 cellpadding=2 class="TableBleu">
                      <tr align="left">
                        <td class="lib"><B>Date de début</B></td>
                        <td class="lib"><B>CA Payeur</B></td>
                        <td class="lib"><B>Client</B></td>
                        <td class="lib"><B>Taux de répartition</B></td>
                      </tr>
                      	<% int i = 0;
						   int nbligne = 0;
						   String libPid="";
						   String libDatdeb="";
						   String libCodcamo="";
						   String libLibCodcamo="";
						   String libClicode="";
						   String libClilib="";
						   String libTauxrep="";
						   String[] strTabCols = new String[] {  "fond1" , "fond2" }; %>
						<logic:iterate id="element" name="listeCALigneBIP" length="<%=  listeCALigneBIP.getCountInBlock()  %>" 
			            			offset="<%=  listeCALigneBIP.getOffset(0) %>"
									type="com.socgen.bip.metier.MultiCA"
									indexId="index"> 
						<% if ( i == 0) i = 1; else i = 0;
						   nbligne ++;
						   libPid="pid_"+nbligne;
						   libDatdeb="datdeb_"+nbligne;
						   libCodcamo="codcamo_"+nbligne;
						   libLibCodcamo="libCodcamo_"+nbligne;
						   libClicode="clicode_"+nbligne;
						   libClilib="clilib_"+nbligne;
						   libTauxrep="tauxrep_"+nbligne;
						 %>
						<tr class="<%= strTabCols[i] %>">
						<td align="left" class="contenu">
							<bean:write name="element" property="datdeb" />
							<input type="hidden" name="<%=libPid%>" value="<bean:write name="element" property="pid" />">
							<input type="hidden" name="<%=libDatdeb%>" value="<bean:write name="element" property="datdeb" />">
						</td>
						<td align="left" class="contenu">
							<bean:write name="element" property="codcamo"/> <bean:write name="element" property="libCodcamo"/>
							<input type="hidden" name="<%=libCodcamo%>" value="<bean:write name="element" property="codcamo" />">
							<input type="hidden" name="<%=libLibCodcamo%>" value="<bean:write name="element" property="libCodcamo" />">
						</td>
						<td class="contenu">
							<bean:write name="element" property="clicode"/> <bean:write name="element" property="clilib"/>
							<input type="hidden" name="<%=libClicode%>" value="<bean:write name="element" property="clicode" />">
							<input type="hidden" name="<%=libClilib%>" value="<bean:write name="element" property="clilib" />">
						</td>
	   			  		<td class="contenu" align="right">
	   			  			<!-- Si on est dans l'année de FI courante, on autorise les modifs -->
	   			  			<% if ((Integer.parseInt(multiCAForm.getAnneeExercice()) <= Integer.parseInt((element.getDatdeb()).substring(3))) || (("12/" + (Integer.parseInt(multiCAForm.getAnneeExercice())-1)).equals(element.getDatdeb()))) {%>
    			  				<input type="text" class="input" size="9" maxlength="9" name="<%=libTauxrep%>" value="<bean:write name="element" property="tauxrep"/>"  onchange="return VerifierNum(this,5,2);">
    			  			<%} else {%>
    			  				<bean:write name="element" property="tauxrep"/>
								<input type="hidden" name="<%=libTauxrep%>" value="<bean:write name="element" property="tauxrep" />">
    			  			<%}%>
    			  		</td>
						</tr>
			 			 </logic:iterate> 
			  		</table>
					<table  width="100%" border="0" cellspacing="0" cellpadding="0">
					   	<tr align="left">
							<td align="center" colspan="4" class="contenu">
								<bip:pagination beanName="listeCALigneBIP"/>
							</td>
						</tr>
						<tr><td colspan="4" align="center" class="contenu">Un taux de 0% supprime la facturation pour le CA
			 			</tr>
			 			<tr><td colspan="4" height="20">&nbsp;
			 			</tr>
			 			<tr>
		              		<td width="25%">&nbsp;</td>
		                	<td width="25%">
		                	 <div align="center">
		                	  <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider');"/>
		                	 </div>
		               		</td> 
		               		<td width="25%"> 
		                  	 <div align="center"> 
		                	  <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler');"/>
		              		 </div>
		                </td>
		                <td width="25%">&nbsp;</td>
		            	</tr>
     
					</table>
                  </div>
                </td>
              </tr>
            </table>
            </html:form>
          </td>
        </tr>
        <tr> 
          <td>&nbsp; </td>
        </tr>
        <tr> 
          <td> 
            <div align="center"><html:errors/></div>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</div>
	<div id="bottomContainer">
			<div>&nbsp;</div>
	</div>
</div>
</body>
<% 
Integer id_webo_page = new Integer("1039"); 
com.socgen.bip.commun.form.AutomateForm formWebo = multiCAForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>