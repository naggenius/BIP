<!DOCTYPE html>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,java.util.Vector,com.socgen.bip.commun.BIPActionMapping,com.socgen.bip.commun.BipConstantes,com.socgen.bip.commun.form.BipForm,com.socgen.bip.log4j.BipUsersAppender,com.socgen.bip.user.UserBip,com.socgen.cap.fwk.ServiceManager,com.socgen.cap.fwk.log.Log"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="extractionForm" scope="request" class="com.socgen.bip.commun.form.ExtractionForm" />
<%@page import="org.owasp.esapi.ESAPI,org.apache.commons.lang.StringUtils"%>
<html:html locale="true">
<!-- #EndEditable --> 

<head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<!-- #BeginEditable "doctitle" --> 
<title>Extraction</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!-- #BeginEditable "fichier" -->
<bip:VerifUser page="jsp/xRessmoisAd.jsp"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<!-- <link rel="stylesheet" href="../css/base_style.css" type="text/css"> -->
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
var blnVerifFormat  = true;
var tabVerif		= new Object();
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
	String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	
	com.socgen.bip.user.UserBip userbip = (com.socgen.bip.user.UserBip)session.getAttribute("UserBip") ;
	com.socgen.bip.menu.item.BipItemMenu menu = userbip.getCurrentMenu();
	String menuId = menu.getId();
	
	String sLogCat = "BipUser";
	Log logBipUser = ServiceManager.getInstance().getLogManager().getLogInstance(sLogCat);
	
	
	// Gestion des listes deroulantes
	java.util.Hashtable hP = new java.util.Hashtable();
	java.util.Hashtable hP1 = new java.util.Hashtable();
	java.util.Hashtable hP2 = new java.util.Hashtable();
	java.util.Hashtable hP_ca_payeur = new java.util.Hashtable();
	
	String ca_payeur = "";
	String ca_da = "";
	String ca_fi = "";
	Vector v2 = new Vector();

	v2 = userbip.getCADA();
	if ((v2 != null) && (!v2.isEmpty())) {
		for (int i = 0; i < v2.size(); i++) {
			ca_da += (String) v2.elementAt(i);
			if (i != (v2.size() - 1))
		ca_da += ",";
		}
	}

	if (!StringUtils.isEmpty(userbip.getCAFI())) {
		ca_fi = userbip.getCAFI();
	}

	if (userbip.getCAPayeur() != null) {
		ca_payeur = userbip.getCAPayeur();
	}
	
	hP.put("userid", userbip.getInfosUser());
	hP_ca_payeur.put("ca_payeur", ca_payeur);
	hP1.put("ca_payeur", ca_da);
	hP2.put("ca_payeur", ca_fi);

	java.util.ArrayList dossProj = new com.socgen.bip.commun.liste.ListeDynamique()
			.getListeDynamique("dprojet_limitation_ref", hP);
	pageContext.setAttribute("choixDProjet", dossProj);

	java.util.ArrayList projet = new com.socgen.bip.commun.liste.ListeDynamique()
			.getListeDynamique("projet_limitation_ref", hP);
	pageContext.setAttribute("choixProjet", projet);

	java.util.ArrayList appli = new com.socgen.bip.commun.liste.ListeDynamique()
	.getListeDynamique("appli_limitation_ref", hP);
	pageContext.setAttribute("choixAppli", appli);

	java.util.ArrayList liste = new com.socgen.bip.commun.liste.ListeDynamique()
			.getListeDynamique("ca_utilisateur_rtfe_ref", hP1);
	pageContext.setAttribute("choixCA", liste);

	java.util.ArrayList liste2 = new com.socgen.bip.commun.liste.ListeDynamique()
			.getListeDynamique("ca_utilisateur_rtfe_ref", hP2);
	pageContext.setAttribute("choixCAFI", liste2);	

	java.util.ArrayList liste_ca_payeur = new com.socgen.bip.commun.liste.ListeDynamique()
	.getListeDynamique("ca_utilisateur_rtfe_ref", hP_ca_payeur);
	pageContext.setAttribute("choixCa_payeur", liste_ca_payeur);

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
		if ( menuId.equals("REF") ) {
			sJobId = "xRessmoisRef";
		} else {
			sJobId = "xRessmoisAd";
		}
		
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

	tabVerif["p_param7"] = "Ctrl_dpg_generique(document.extractionForm.p_param7)";

	var Message="<bean:write filter="false"  name="extractionForm"  property="msgErreur" />";
	var Focus = "<bean:write name="extractionForm"  property="focus" />";

   
   if (Message != "") {
      alert(Message);
   }
   else
   {
	document.extractionForm.p_param7.value = Replace_DoubleZero_by_DoubleEtoile( "<bean:write name="UserBip"  property="dpg_Defaut" />" );   
<%
	// On met le focus sur le DPG on est sur le menu référentiel
	if ( !menuId.equals("REF") )
	{
%>						
		if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
		else {document.forms[0].p_param7.focus();}
<%
	}
%>						
	} // END ELSE

<%
	if ( "REF".equals(menuId))
	{
%>	
	document.extractionForm.p_param7.value = "*******";	
<% } %>
}

function Verifier(form, flag)
{
  blnVerification = flag;
}

// PPM 58162 - fonction pour empêcher le choix des valeurss --- Habil Directe --- ou --- Habil par DP ---
function selectHabil(){
 if( document.forms[0].p_param13.value == '--- Habil Directe ---' || 
	document.forms[0].p_param13.value == '--- Habil par DP ---' ){
	document.forms[0].p_param13.value = 'TOUS';
	return true;
	}
	return false;
}
// PPM 58162 - Modification de la fonction pour intégrer le contrôle selectHabil() et affichage du message d'erreur
function ValiderEcran(form) {	


	// Cas d'un lancement par le menu habilitation par référentiel
	if (form.p_param8.value == "REF") {
	
	if ( document.extractionForm.p_param12.value == 'Pas de limitation' 
		&& document.extractionForm.p_param13.value == 'Pas de limitation'
		&& document.extractionForm.p_param9.value == 'Pas de limitation'
		&& document.extractionForm.p_param10.value == 'Pas de limitation'
		&& document.extractionForm.p_param11.value == 'Pas de limitation'	
		&& document.extractionForm.p_param14.value == 'Pas de limitation'									
	) {
		alert('Choisir "Tous", "Toutes", ou un code pour au moins un des critères');
		return false;
	}		
	if(selectHabil()){
		alert('les choix « --- Habil Directe --- » et « --- Habil par DP --- » ne sont pas des valeurs fonctionnelles. \n Merci de sélectionner un code projet');
		return false;
	}
		// On lancera les reports d'indices 1 et 2
		if (form.p_param6.value == ".CSV") {
			form.listeReports.value="1";
		}
		else {	
			form.listeReports.value="2";
		}
			
	}
	// Cas d'un lancement par les autres menus
	else {
		// On lancera les reports d'indices 1 et 2
		if (form.p_param6.value == ".CSV") {
			form.listeReports.value="1";
		}
		else {	
			form.listeReports.value="2";
		}

		if ( !VerifFormat(null) ) return false;
		
		// Le DPG est obligatoire
		if (!ChampObligatoire(form.p_param7, "un code DPG")) return false;
	
		// on change les * dans le code DPG par des 0 car les * sont envoyés avec %suivi du caractère ascci
		//form.p_param7.value = Replace_DoubleEtoile_by_DoubleZero(form.p_param7.value);
	}
	
	// if ( !confirm("Confirmez-vous la demande d'extraction ?") ) return false;
	
	document.extractionForm.submit.disabled = true;
	return true;
}

function MAJTypeExtract(typeExtract){

	document.extractionForm.p_param6.value=typeExtract;
	return true;
}

//PPM 58375
function MAJAxeRecherche(typeAxe){

	document.extractionForm.p_param16.value=typeAxe;
	return true;
}

function rechercheDPG()
{
	window.open("/recupDPG.do?action=initialiser&nomChampDestinataire=p_param7&windowTitle=Recherche Code DPG&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
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
<!--           <td background="../images/ligne.gif"></td> -->
        </tr>
        <tr> 
          <td height="20" class="TitrePage"><%=sTitre%></td>
        </tr>
        <tr> 
<!--           <td background="../images/ligne.gif"></td> -->
        </tr>
        <tr> 
          <td height="20"> 
            
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
            <input type="hidden" name="p_param6" value=".CSV">
 		    <input type="hidden" name="listeReports" value="1">
 		    
			<!-- #EndEditable -->

<% if ("REF".equals(menuId)) { %>
	<table width="80%" border="0" cellspacing="0" cellpadding="0" class="tableBleu" align="center">
		<tr>
			<td align="center">&nbsp;</td>
		</tr>
		<tr align="left">
			<td align="left" class="texte"><b>Cette extraction prend en compte
			votre périmètre Dossier projet, projet, application, CAFI, CA payeur et CADA.
			</td>
		</tr> 
		<tr>
			<td align="center">&nbsp;</td>
		</tr>
		<tr align="left">
			<td align="left" class="texte">
			Vous pouvez limiter la demande aux éléments ci-dessous :
			</td>
		</tr>
		<tr>
			<td align="center">&nbsp;</td>
		</tr>
	</table>

	<table border=0 class="tableBleu" width="90%" cellspacing="1" align="center" cellpadding="1">
		<input type="hidden" name="pageAide" value="<%= sPageAide %>">
		<tr align="left">
			<td width="20%" class="texte" align=left><b>Limitation à un Dossier Projet :</b></td>
			<td width="50%"><html:select property="p_param14" styleClass="input">
				<option value="TOUS" SELECTED>Tous</option>
				<option value="Pas de limitation">Pas de limitation</option>
				<html:options collection="choixDProjet" property="cle"
					labelProperty="libelle" />
			</html:select></td>
			<td align="center" width="30%" rowspan=7>
			<!-- fildset -->
			<fieldset>
					<table cellspacing="1" cellpadding="1">
						<tr align="left" >
							<td class="texte" width="200px"><b>&nbsp;Explications
							sur les choix :</b><br> <br> <i>&nbsp;Tous
							ou Toutes</i><br> &nbsp;indique que vous souhaitez<br>
							&nbsp;retenir toutes les valeurs<br> &nbsp;du
							périmètre RTFE concerné;<br> <br> <i>&nbsp;Pas
							de limitation</i><br> &nbsp;indique que vous ne
							souhaitez<br> &nbsp;pas prendre en compte le<br>
							&nbsp;périmètre RTFE concerné.<br> &nbsp;</td>
						</tr>
					</table>
			</fieldset>			
		</td>
		</tr>
		<tr>
			<td colspan=2 align="center">&nbsp;</td>
		</tr>
		<tr align="left">
			<td class="texte" align=left ><b>Limitation à un Projet :</b></td>
			<td ><html:select property="p_param13" styleClass="input" >
				<option value="TOUS" SELECTED>Tous</option>
				<option value="Pas de limitation">Pas de limitation</option>
				<html:options collection="choixProjet" property="cle"
					labelProperty="libelle" />
			</html:select></td>
		
		</tr>
		<tr>
			<td colspan=2 align="center">&nbsp;</td>
		</tr>
		<tr align="left">
			<td class="texte" align=left width="25%"><b>Limitation à une application : </b></td>
			<td><html:select property="p_param9" styleClass="input">
				<option value="TOUS" SELECTED>Toutes</option>
				<option value="Pas de limitation">Pas de limitation</option>
				<html:options collection="choixAppli" property="cle" labelProperty="libelle" />
			</html:select></td>
		</tr>
		<tr>
			<td colspan=2 align="center">&nbsp;</td>
		</tr>		
		<tr align="left">
			<td class="texte" align=left><b>Limitation à un CAFI :</b></br>
			(les niveaux inférieurs sont pris en compte)</td>
			<td><html:select property="p_param10" styleClass="input">
				<option value="TOUS" SELECTED>Tous</option>
				<option value="Pas de limitation">Pas de limitation</option>
				<html:options collection="choixCAFI" property="cle"
					labelProperty="libelle" />
			</html:select></td>
			
		</tr>
		<tr>
			<td colspan=2 align="center">&nbsp;</td>
		</tr>
		<tr align="left">
			<td class="texte" align=left width="25%"><b>Limitation à un CA Payeur :</b></br>
			(les niveaux inférieurs sont pris en compte)</td>
			<td><html:select property="p_param11" styleClass="input">
				<option value="TOUS" SELECTED>Tous</option>
				<option value="Pas de limitation">Pas de limitation</option>
				<html:options collection="choixCa_payeur" property="cle" labelProperty="libelle" />
			</html:select></td>

		</tr>
		<tr>
			<td colspan=2 align="center">&nbsp;</td>
		</tr>
		<tr align="left">
			<td class="texte" align=left><b>Limitation à un CADA :</b></br>
			(les niveaux inférieurs sont pris en compte)</td>
			<td><html:select property="p_param12" styleClass="input">
				<option value="TOUS" SELECTED>Tous</option>
				<option value="Pas de limitation">Pas de limitation</option>
				<html:options collection="choixCA" property="cle"
					labelProperty="libelle" />
			</html:select></td>
		</tr>
		<tr>
			<td colspan=3 align="center">&nbsp;</td>
		</tr>
		<tr align="left">
			<td class="texte" align="left"><b>Extension du fichier :</b>&nbsp;</td>
			<td colspan=2>
				<select name="choixReports" class="input" onChange="return MAJTypeExtract(this.value)">
					<option value=".TXT">.TXT</option>
					<option value=".CSV" SELECTED>.CSV</option>
				</select>
			</td>
		</tr>		
	</table>

	<input type="hidden" name="p_param7" value="*******">
<!-- fin d affichage conditionne par le menu REF -->
	
<% } else { %>	

<!-- Menu different de REF -->

    <!-- #BeginEditable "contenu" -->
	<table width="100%" border="0">
		<tr> 
			<td> 
				<div align="center">
					<table border=0 cellspacing=2 cellpadding=2 class="tableBleu">
						<tr><td colspan=5 align="center">&nbsp;</td></tr>
						<tr align="left">
							<td colspan=1 class="texte" align="left"><B>Code DPG :</B></td>
							<td class="texte" colspan=1 align=left><html:text property="p_param7" styleClass="input"  size="7" maxlength="7" onchange="return VerifFormat(this.name);"/>
							&nbsp;<a href="javascript:rechercheDPG();" ><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code DPG" title="Rechercher Code DPG" style="vertical-align : middle;"></a>   
					                    </td>
						</tr>
						<tr><td colspan=5 align="center">&nbsp;</td></tr>
						<tr align="left">
							<td colspan=1 class="texte" align=left><b>Axe de recherche :</b>&nbsp;</td>
							<td colspan=1>
								<select name="p_param16" class="input" onChange="return MAJAxeRecherche(this.value)">
									<option value="Tous" SELECTED>Tous</option>
									<option value="DPG de ressource">DPG de ressource</option>
									<option value="DPG de ligne">DPG de ligne</option>
								</select>
							</td>
						</tr>
						<tr><td colspan=5 align="center">&nbsp;</td></tr>
						<tr align="left">
							<td colspan=1 class="texte" align=right><b>Extension du fichier :</b>&nbsp;</td>
							<td colspan=1>
								<select name="choixReports" class="input" onChange="return MAJTypeExtract(this.value)">
									<option value=".CSV" SELECTED>.CSV</option>
									<option value=".TXT">.TXT</option>
								</select>
							</td>
						</tr>
				  	</table>
				</div>
			</td>
		</tr>
	</table>				  		
	  	<!-- #EndEditable -->

<% } %>
<!-- Fin condition sur Menu -->
	
	
            <table width="100%" border="0">
            	<tr>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
                <tr> 
                  <td>  
                  <div align="center">
				  <html:submit value="Extraire" styleClass="input" onclick="Verifier(this.form, true);"/>
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