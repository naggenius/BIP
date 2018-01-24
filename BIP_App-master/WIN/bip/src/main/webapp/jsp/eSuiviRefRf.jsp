<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="editionForm" scope="request" class="com.socgen.bip.commun.form.EditionForm" />
<html:html locale="true">
<head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>


<title>Edition</title>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<bip:VerifUser page="jsp/eSuiviRefRf.jsp"/>
<%
	java.util.Hashtable hP = new java.util.Hashtable();
	hP.put("userid", ((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
	
	java.util.ArrayList dossProj = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("dprojet_ref",hP); 
	pageContext.setAttribute("choixDProjet", dossProj);
	java.util.ArrayList projet = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("projet_ref",hP); 
	pageContext.setAttribute("choixProjet", projet);
	java.util.ArrayList appli = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("appli_ref",hP); 
	pageContext.setAttribute("choixAppli", appli);
%>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var pageAide = "aide/hvide.htm";
var choixEffectue = false;
var refChoisi = "";//PPM 58162
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";

<%
	String sTitre;
	String sInitial;
	String sJobId;
%>

function MessageInitial(){
	<%
		sJobId = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("jobId")));
		sTitre = com.socgen.bip.metier.Report.getTitre(sJobId);
		if (sTitre == null){
			//redirect sur la page d'erreur
			sTitre = "Pas de titre";
		}		
		sInitial=ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getQueryString()));
		if (sInitial == null)
			sInitial = request.getRequestURI();
		else
			sInitial = request.getRequestURI() + "?" + sInitial;
		sInitial = sInitial.substring(request.getContextPath().length());
	%>
	
	var Message="<bean:write filter="false"  name="editionForm"  property="msgErreur" />";
	var Focus = "<bean:write name="editionForm"  property="focus" />";
	
	if (Message != "") {
		alert(Message);
	}
}
// PPM 58162 : ajout de refChoisi pour indiquer le choix de référentiel effectué
function ChangeRef(newRef){
	document.forms[0].p_param7.style.display="none";
	document.forms[0].p_param8.style.display="none";
	document.forms[0].p_param9.style.display="none";
	if (newRef=="DP") {
	document.forms[0].p_param7.style.display="";
	refChoisi = "DP";
	}
	else if (newRef=="P") {
	document.forms[0].p_param8.style.display="";
	refChoisi = "P";
	}
	else if (newRef=="A") {
	document.forms[0].p_param9.style.display="";
	refChoisi = "A";
	}
	choixEffectue=true;
}

function Verifier(form, bouton, flag){
  
}
// PPM 58162 - fonction pour empêcher la génération du rapport si aucune valeur n'est sélectionnée
function aucuneOptionSelect(){
 if((refChoisi == "DP" && document.forms[0].p_param7.value == '') || (refChoisi == "P" && 
	document.forms[0].p_param8.value == '') || (refChoisi=="A" &&
	document.forms[0].p_param9.value == '')){
	return true;
	}
	return false;
}
// PPM 58162 - fonction pour empêcher le choix des valeurss --- Habil Directe --- ou --- Habil par DP ---
function selectHabil(){
 if(document.forms[0].p_param8.value != '' && (document.forms[0].p_param8.value == '--- Habil Directe ---' || 
	document.forms[0].p_param8.value == '--- Habil par DP ---') ){
	document.forms[0].p_param8.value = ' TOUS';
	return true;
	}
	return false;
}
// PPM 58162 - Modification de la fonction pour intégrer les deux contrôles précédents et affichage des messages d'erreur
function ValiderEcran(form){
	if (!choixEffectue) {
		alert("Effectuez un choix de référentiel");
		return false;
	}
	if(aucuneOptionSelect()){
	alert("Veuillez sélectionner une option");
	return false;
	}
	if(selectHabil()){
	alert('les choix « --- Habil Directe --- » et « --- Habil par DP --- » ne sont pas des valeurs fonctionnelles. \n Merci de sélectionner un code projet');
	return false;
	}
	document.editionForm.submit.disabled = true;
	return true;
}
</script>

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
          <td height="20" class="TitrePage"><%=sTitre%></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> 
            
          </td>
        </tr>
        <tr> 
          <td>
		  <html:form action="/edition"  onsubmit="return ValiderEcran(this);">
            
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<input type="hidden" name="jobId" value="<%=sJobId%>">
            <input type="hidden" name="initial" value="<%= sInitial %>">
            <table width="100%" border="0">
                <tr> 
                  <td> 
                    <div align="center">
					<table border=0 cellspacing=2 cellpadding=2 class="tableBleu">
					<input type="hidden" name="pageAide" value="<%= sPageAide %>">
					  <tr>
                        <td colspan=5 align="center">&nbsp;</td>
                      </tr>
					<tr>
						<td align=right width=5%> 
							<html:radio property="p_param6" styleClass="input" value="DP" onclick="ChangeRef(this.value);"/>
						</td>
						<td class="lib" align=right width=20%><b>Dossier Projet : </b></td>
						<td width=75%>
							<html:select property="p_param7" styleClass="input" style="display='none'"> 
								<html:options collection="choixDProjet" property="cle" labelProperty="libelle" />
							</html:select>
						</td>
					</tr>
					  <tr>
                        <td colspan=5 align="center">&nbsp;</td>
                      </tr>
                    <tr>
                    	<td align=right> 
                    		<html:radio property="p_param6" styleClass="input" value="P" onclick="ChangeRef(this.value);"/>
						</td>						
						<td class="lib"  align=right><b>Projet : </b></td>
						<td>
							<html:select property="p_param8" styleClass="input" style="display='none'"> 
								<html:options collection="choixProjet" property="cle" labelProperty="libelle"/>
							</html:select>
						</td>
					</tr>
					  <tr>
                        <td colspan=5 align="center">&nbsp;</td>
                      </tr>
                     <tr>
                     	<td align=right> 
                     		<html:radio property="p_param6" styleClass="input" value="A" onclick="ChangeRef(this.value);"/>
						</td>
						<td class="lib" align=right><b>Application : </b></td>
						<td>
							<html:select property="p_param9" styleClass="input" style="display='none'"> 
								<html:options collection="choixAppli" property="cle" labelProperty="libelle" />
							</html:select>
						</td>
					</tr>
					  <tr>
                        <td colspan=5 align="center">&nbsp;</td>
                      </tr>
			   		</table>
					</div>
                  </td>
                </tr>
				<tr> 
          		  <td>&nbsp;  
          		  </td>
        		</tr>
                <tr> 
                  <td>  
                  <div align="center">
				  <html:submit value="Edition" styleClass="input" onclick="Verifier(this.form, 'liste', true);"/>
                  </div>
                  </td>
                </tr>
            
            </table>
			</html:form>
          </td>
        </tr>
		<tr> 
          <td>&nbsp;  
          </td>
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
</body>
</html:html>
