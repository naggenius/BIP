<!DOCTYPE html>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="extractionForm" scope="request" class="com.socgen.bip.commun.form.ExtractionForm" />
<html:html locale="true">
<!-- #EndEditable --> 

<head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<!-- #BeginEditable "doctitle" --> 
<title>Extraction</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!-- #BeginEditable "fichier" -->
<bip:VerifUser page="jsp/xLigneRfAct.jsp"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<!-- <link rel="stylesheet" href="../css/base_style.css" type="text/css"> -->
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
var tabVerif = new Object();
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	
	com.socgen.bip.user.UserBip user = (com.socgen.bip.user.UserBip)session.getAttribute("UserBip") ;
	com.socgen.bip.menu.item.BipItemMenu menu = user.getCurrentMenu();
	String menuId = menu.getId();
	
	java.util.Hashtable hP = new java.util.Hashtable();
	hP.put("userid", user.getInfosUser());
	
	java.util.ArrayList dossProj = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("dprojet_limitation_ref",hP); 
	pageContext.setAttribute("choixDProjet", dossProj);
	
	java.util.ArrayList projet = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("projet_limitation_ref",hP); 
	pageContext.setAttribute("choixProjet", projet);
	
	java.util.ArrayList appli = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("appli_limitation_ref",hP); 
	pageContext.setAttribute("choixAppli", appli);
%>
var pageAide = "<%= sPageAide %>";
<%
	String sTitre;
	String sInitial;
	String sJobId;
%>


function MessageInitial()
{
	<%
		sJobId = "xLigneRfAct";
	
		sTitre = com.socgen.bip.metier.Report.getTitre(sJobId);
		if (sTitre == null)
		{
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

	var Message="<bean:write filter="false"  name="extractionForm"  property="msgErreur" />";
	var Focus = "<bean:write name="extractionForm"  property="focus" />";

   
   if (Message != "") {
      alert(Message);
   }

	if (Focus != "") {
		if (eval( "document.forms[0]."+Focus )){
			(eval( "document.forms[0]."+Focus )).focus();
		}
	}
	
}

function Verifier(form, flag)
{
  MAJTypeExtract(form);
  blnVerification = flag;
}

// PPM 58162 - fonction pour empêcher le choix des valeurss --- Habil Directe --- ou --- Habil par DP ---
function selectHabil(){
 if(document.forms[0].p_param10.value == '--- Habil Directe ---' || 
	document.forms[0].p_param10.value == '--- Habil par DP ---' ){
	document.forms[0].p_param10.value = 'TOUS';
	return true;
	}
	return false;
}
// PPM 58162 - Modification de la fonction pour intégrer le contrôle selectHabil() et affichage du message d'erreur
function ValiderEcran(form) {
	if(selectHabil()){
	alert('les choix « --- Habil Directe --- » et « --- Habil par DP --- » ne sont pas des valeurs fonctionnelles. \n Merci de sélectionner un code projet');
		return false;
	}	
//  PPR le 14/02/2005 : On ne demande plus de confirmation
//	if ( !confirm("Confirmez-vous la demande d'extraction ?") ) return false;
	if(blnVerification==false)
		form.initial.value='annuler';
	return true;
}

function MAJTypeExtract(form){

	// Cas d'un lancement par le menu habilitation par référentiel
	if (form.p_param8.value == "REF") {
		if (form.p_param6.value == ".CSV") {
			form.listeReports.value="6";
		}
		else {	
			form.listeReports.value="5";
		}
	}
	// Cas d'un lancement par les autres menus
	else {
		if ((form.p_param6.value == ".CSV") && (form.p_param7.value == "FOUR")){
			form.listeReports.value="2";
		}
		else if ((form.p_param6.value == ".TXT") && (form.p_param7.value == "FOUR_CLI")){
			form.listeReports.value="3";
		}
		else if ((form.p_param6.value == ".CSV") && (form.p_param7.value == "FOUR_CLI")){
			form.listeReports.value="4";
		}
		else form.listeReports.value="1";
	}
	return true;
}
</script>

<!-- #EndEditable --> 


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
		  <html:form action="/extract"  onsubmit="return ValiderEcran(this);">
			<!-- #BeginEditable "debut_hidden" -->	
            
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<input type="hidden" name="jobId" value="<%=sJobId%>">
            <input type="hidden" name="initial" value="<%= sInitial %>">
            <input type="hidden" name="pageAide" value="<%= sPageAide %>">
            <input type="hidden" name="p_param8" value="<%= menuId %>">
            <input type="hidden" name="listeReports" value="1">
			<!-- #EndEditable -->

            <table width="100%" border="0">
                <tr> 
                  <td> 
                    <div align="center">
                      <!-- #BeginEditable "contenu" -->
					<table border=0 cellspacing=5 cellpadding=0 class="tableBleu">
					<tr align="left">
                        <td class="texte" colspan=3 align="left" height="30">Cette extraction prend en compte votre périmètre habilité sur les dossiers projets, projets et applications.<br/> Vous pouvez limiter la demande aux éléments ci-dessous : </td>
                    </tr>
					<tr>
                        <td colspan=3 align="center">&nbsp;</td>
                    </tr>
                    <tr>
                        <td colspan=3 align="center">&nbsp;</td>
                    </tr>
                    <tr align="left">
						<td class="texte" align=left width="130px"><b>Limitation à un dossier projet : </b></td>
						<td>
							<html:select property="p_param9" styleClass="input"> 
								<option value="TOUS" SELECTED>Tous</option>
								<option value="Pas de limitation">Pas de limitation</option>
								<html:options collection="choixDProjet" property="cle" labelProperty="libelle" />
							</html:select>
						</td>
						<td align="center" width="200px">
			        		<fieldset>
			        		<table>
			          		<tr align="left">
				          	<td class="lib" width="200px">
				          		<b>Explications sur les choix :</b></br></br>
				          		<i>Tous ou Toutes</i></br>
				          		indique que vous souhaitez</br>
				          		retenir toutes les valeurs </br>
				          		du périmètre RTFE concerné;</br></br>
				          		<i>Pas de limitation</i></br>
				          		indique que vous ne souhaitez</br>
				          		pas prendre en compte le</br>
				          		périmètre RTFE concerné.
				          	</td>
			          		</tr>
			        		</table>
			        		</fieldset>
			            </td>
					</tr>
					<tr>
                       	<td colspan=3 align="center">&nbsp;</td>
                   	</tr>
	     			<tr align="left">
                    	<td class="texte" align=left width="130px"><b>Limitation à un projet : </b></td>
						<td>
							<html:select property="p_param10" styleClass="input"> 
								<option value="TOUS" SELECTED>Tous</option>
								<option value="Pas de limitation">Pas de limitation</option>
								<html:options collection="choixProjet" property="cle" labelProperty="libelle"/>
							</html:select>
						</td>
	    			</tr>
                   	<tr>
                       	<td colspan=3 align="center">&nbsp;</td>
                   	</tr>
                   	<tr align="left">
                     	<td class="texte" align=left width="130px"><b>Limitation à une application : </b></td>
						<td>
							<html:select property="p_param11" styleClass="input"> 
								<option value="TOUS" SELECTED>Toutes</option>
								<option value="Pas de limitation">Pas de limitation</option>
								<html:options collection="choixAppli" property="cle" labelProperty="libelle" />
							</html:select>
						</td>
					</tr>
					<tr align="left">
						<td colspan=1 class="texte" align=left><b>Extension du fichier :</b>&nbsp;</td>
						<td colspan=1>
                          <select name="p_param6" class="input" onChange="return MAJTypeExtract(this.form)">
							<option value=".CSV" SELECTED>.CSV</option>
							<option value=".TXT">.TXT</option>
                          </select>
						</td>
                    </tr>
                    <tr>
                        <td colspan=2 align="center">&nbsp;</td>
                    </tr>
					<tr align="left">
					<%
						// On n'affiche pas le choix client / fournisseur si on est sur le menu référentiel
						if ( !menuId.equals("REF") )
						{
					%>						
						<td colspan=1 class="texte" align=right><b>Lignes Retournées :</b>&nbsp;</td>
						<td colspan=1>
                          <select name="p_param7" class="input" onChange="return MAJTypeExtract(this.form)">
							<option value="FOUR" SELECTED>Fournisseurs</option>
							<option value="FOUR_CLI">Clients et Fournisseurs</option>
                          </select>
						</td>
					<%
						}
					%>						
						
                    </tr>
			   		</table>
					
					  <!-- #EndEditable -->
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
				  <html:submit value="Extraire" styleClass="input" onclick="Verifier(this.form, true);"/>
				  <html:submit value="Annuler" styleClass="input" onclick="Verifier(this.form, false);"/>
                  </div>
                  </td>
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
</div>
	<div id="bottomContainer">
			<div>&nbsp;</div>
	</div>
</div>
</body>
</html:html>