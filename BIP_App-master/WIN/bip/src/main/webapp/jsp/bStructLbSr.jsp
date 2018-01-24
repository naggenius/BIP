<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,java.lang.Integer, 
com.socgen.bip.metier.StructLbEtape, com.socgen.bip.metier.StructLbTache, com.socgen.bip.metier.StructLbSsTache, com.socgen.bip.form.StructLbForm,
org.apache.commons.lang.StringUtils"    errorPage="../jsp/erreur.jsp"  %><html:html locale="true"> 
<jsp:useBean id="structLbForm" scope="request" class="com.socgen.bip.form.StructLbForm" />
<jsp:useBean id="etapeForm" scope="request" class="com.socgen.bip.form.EtapeForm" />
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --><head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="/structLb.do"/> 
<%
  java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("isac_pid_modif",structLbForm.getHParams());
  pageContext.setAttribute("choixPid", list1);
  
  String sLigne="";
  if (session.getAttribute("PID")!=null) {
  	sLigne=(String)session.getAttribute("PID")+" - "+(String)session.getAttribute("PNOM");
  }


%>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<style type="text/css">
#mainContainer {width:1000px; margin:auto; text-align:left; height:100%;}
</style>
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));

// Hauteur max du div contenant l'arborescence
int maxHeightContenuArbo = 300;

// Seuil de longueur de chaine de la colonne 1, pour réduction de la police
int seuilLongueurCol1 = 45; 

// Déclaration des variables
String idEtape;
String idTache;
String idSsTache;
String numeroEtape;
String numeroTache;
String numeroSsTache;

String btRadioStructure = structLbForm.getBtRadioStructure();
String btRadioStructureNotNull;
// Si un id bouton radio est dans la request
if (btRadioStructure == null) {
	btRadioStructureNotNull = "";
}
else {
	btRadioStructureNotNull = btRadioStructure;
}

%>
var pageAide = "<%= sPageAide %>";

function TraitementInitial() {
document.getElementById("wait").style.display = "none";
	//HMI - PPM 60709 : $5.3 15/09/2015
	   var Message="<bean:write filter="false"  name="etapeForm"  property="msgErreur" />";
	 	if (Message != "") {
	      //alert(Message);
	   }
	MessageInitial();
	
	<!-- Si une ligne BIP est sélectionnée -->
		<logic:notEmpty scope="session" name="PID">
			<!-- Si aucune structure n'existe pour la ligne sélectionnée -->
			<logic:notEmpty name="structLbForm" property="structLb">
				traitementChargementStructure();
			</logic:notEmpty>
		</logic:notEmpty>
}

function MessageInitial()
{
	//HMI - PPM 60709 - $5.3 - QC: 1774
	 var result = verifierParametrageDefaut();
	 if(result != "") {
		 alert(result);
	 }
	// FIN HMI - PPM 60709 - $5.3 - QC: 1774
	
   var Message="<bean:write filter="false"  name="structLbForm"  property="msgErreur" />";
   var Focus = "<bean:write name="structLbForm"  property="focus" />";
   if (Message != "") {
	 //FAD PPM 63773 : Ajout du retour chariot si le message est celui de l'existence d'un consommé 
	   if (Message == "Suppression interdite car il existe du consommé attaché à cette ligne BIP.Il faut d'abord supprimer ce consommé.")
		   Message = "Suppression interdite car il existe du consommé attaché à cette ligne BIP.\nIl faut d'abord supprimer ce consommé.";
      alert(Message);
   }
   document.forms[0].pid.value="<%=session.getAttribute("PID")%>";
 
}

//HMI - PPM 60709 - $5.3 - QC: 1774
function verifierParametrageDefaut(){
	// Appel ajax de la méthode de l'action 
	ajaxCallRemotePage('/structLb.do?action=verifierParametrageDefaut');
	// Si la réponse ajax est non vide :
	var ajaxres = document.getElementById("ajaxResponse").innerHTML;
	return ajaxres;
	
}
// FIN HMI - PPM 60709 - $5.3 - QC: 1774

function AjusterHauteurArbo() {
	if (document.getElementById("contenuArbo")) {
		// Si max-height non reconnu (ou si ie6)
		if (document.getElementById("contenuArbo").style.maxHeight == null) {
			// Si la taille dépasse la taille max
			if ((document.getElementById("contenuArbo").offsetHeight) >= <%= maxHeightContenuArbo %>) {
				document.getElementById("contenuArbo").style.height = '<%= maxHeightContenuArbo %>px';
			}
			else {
				document.getElementById("contenuArbo").style.height = '';
			}
		}
	}
	//
}

function Verifier(form, action, flag)
{
  blnVerification = flag;
  form.action.value = action;
}

function ValiderEcran(form)
{  
	if (form.action.value === 'creerLigneProductiveHorsModeProjet' || form.action.value === 'creerLigneProductiveEnModeProjet' || form.action.value === 'creer') {
	document.getElementById("boutonCreaHorsModeProj").disabled = true;
	document.getElementById("boutonCreaEnModeProj").disabled = true;
	document.getElementById("boutonCreaManu").disabled = true;
	}
   form.keyList0.value = form.pid.value;
   document.getElementById("wait").style.display = "block";
   return true;
}

/**
Traitement initial de chargement de la structure
*/
function traitementChargementStructure() {
	var typeBtRadio = <%= structLbForm.getTypeBtRadioStructure() %>;
	
	if (typeBtRadio == "<%= StructLbForm.btRadioTypeAucun %>") {
		traitementAucun();
	}
	// Si structure complète
	else if (typeBtRadio == "<%= StructLbForm.btRadioTypeStructComplete %>") {	
		traitementStructureComplete();
	}
	else {
		// Si étape
		if (typeBtRadio == "<%= StructLbForm.btRadioTypeEtape %>") {
			traitementEtape("<%= structLbForm.getIdEtapeFromBtRadio() %>");
		}
		// Si tâche
		else if (typeBtRadio == "<%= StructLbForm.btRadioTypeTache %>") {
			traitementTache("<%= structLbForm.getIdDivTache() %>", true);
		}
		// Si sous-tâche
		else if (typeBtRadio == "<%= StructLbForm.btRadioTypeSsTache %>") {
			// Identifiant pour traitement tâche
			var idBtRadioTache = "<%= structLbForm.getIdDivTache() %>";
			 
			traitementTache(idBtRadioTache, false);
			traitementSsTache();
		}
	}
	
	cocherBtRadio("<%= btRadioStructureNotNull %>");
}

function cocherBtRadio(idBtRadioStructure) {
	if (idBtRadioStructure) {
		var btRadioStructure = document.getElementById(idBtRadioStructure);
		if (btRadioStructure) {
			btRadioStructure.checked = "checked";
		}
	}
}

/**
Gestion de l'affichage / masquage des boutons
*/
function gererAffichageDivBoutons(perimetre) {
	if (perimetre == "aucune" || perimetre == "complete") {
		// Masquage lds div BoutonsEtape, BoutonsTâche, BoutonsSsTâche
		setVisibility(document.getElementById("divBts"), false);
		// Affichage du div boutons Structure complète
		setVisibility(document.getElementById("divBtsStructCompleteOuAucun"), true);
	}
	else {
		// Affichage du div Boutons divBts, contenant BoutonsEtape, BoutonsTâche, BoutonsSsTâche
		setVisibility(document.getElementById("divBts"), true);
		
		// Masquage du div boutons Structure complète
		setVisibility(document.getElementById("divBtsStructCompleteOuAucun"), false);
		
		var visibilityDivBtsEtape = perimetre == "etape";
		var visibilityDivBtsTache = perimetre == "tache";
		var visibilityDivBtsSsTache = perimetre == "ssTache";
		
		// Affichage / masquage des div Boutons BoutonsEtape, BoutonsTâche, BoutonsSsTâche
		var divBtsEtape = document.getElementsByName("divBtsEtape");

		for (i=0 ; i < divBtsEtape.length ; i++) {
			setVisibility(divBtsEtape[i], visibilityDivBtsEtape);
		}
		
		var divBtsTache = document.getElementsByName("divBtsTache");
			
		for (i=0 ; i < divBtsTache.length ; i++) {
			setVisibility(divBtsTache[i], visibilityDivBtsTache);
		}

		// FAD PPM 63773: Activation / désactivation de toutes les instances du div divBtsSsTache
		var divBtsSsTache = document.getElementsByName("divBtsSsTache");

		for (i=0 ; i < divBtsSsTache.length ; i++) {
			setVisibility(divBtsSsTache[i], visibilityDivBtsSsTache);
		}

		//setVisibility(document.getElementById("divBtsSsTache"), visibilityDivBtsSsTache);
	}
}

/**
Affichage structure minimale - Aucun bouton radio coché
**/
function traitementAucun() {
	// Ajustement de la hauteur de l'arboresence
	AjusterHauteurArbo();
	gererAffichageDivBoutons("aucune");
}

/**
Affichage de toute la structure - Bouton radio structure complète
*/
function traitementStructureComplete() {
	// Affichage de l'ensemble de la structure
	setVisibilityStructureComplete(true);
	
	// Ajustement de la hauteur de l'arboresence
	AjusterHauteurArbo();
	
	gererAffichageDivBoutons("complete");
}

/**
Affichage des tâches de l'étape - Bouton radio étape
*/
function traitementEtape(idEtape) {
	// Masquage de l'ensemble de la structure
	setVisibilityStructureComplete(false);

	if (idEtape) {
		var contenuEtape = document.getElementById("<%= StructLbForm.prefixeIdEtape %>" + idEtape);

		// Si le contenu existe
		if (contenuEtape) {
			// Liste des enfants
			var listeEnfants = contenuEtape.getElementsByTagName("DIV");
			// Si la liste existe
			if (listeEnfants) {
				var enfant;
				
				// Pour chaque enfant
				for(var i= 0; i < listeEnfants.length; i++)
				{
					enfant = listeEnfants[i];

					// Si l'enfant est une tâche (id préfixé par prefixeIdTache)
					if (enfant.id.indexOf("<%= StructLbForm.prefixeIdTache %>") == 0) {
						// Afficher le div tâche
						setVisibility(listeEnfants[i], true);
					}
				}
			}
		}
	}
	
	// Ajustement de la hauteur de l'arboresence
	AjusterHauteurArbo();
	
	gererAffichageDivBoutons("etape");
}

/**
Affichage de la tâche et de ses sous-tâches - Bouton tâche 
*/
function traitementTache(identifiant, gestionAffichageDivBoutons) {
	// Masquer l'ensemble de la structure
	setVisibilityStructureComplete(false);
	
	if (identifiant) {
		var indexEtape = identifiant.indexOf("<%= StructLbForm.prefixeIdEtape %>");
	
		// Id d'étape
		var idEtape = identifiant.substring(indexEtape + "<%= StructLbForm.prefixeIdEtape %>".length, identifiant.length);

		if (idEtape) {
			// Afficher toutes les tâches de l'étape
			setVisibilityTache(idEtape);
		}
		
		var indexTache = identifiant.indexOf("<%= StructLbForm.prefixeIdTache %>");
		
		// Id de tâche
		var idTache = identifiant.substring("<%= StructLbForm.prefixeIdTache %>".length, indexEtape);

		if (idTache) {
			var contenuTache = document.getElementById("<%= StructLbForm.prefixeIdTache %>" + idTache);

			// Si le contenu existe
			if (contenuTache) {
				// Afficher le div tâche
				setVisibility(contenuTache, true);			
				
				// Liste des enfants
				var listeEnfants = contenuTache.getElementsByTagName("DIV");
				// Si la liste existe
				if (listeEnfants) {
					var enfant;
					
					// Pour chaque enfant
					for(var i= 0; i < listeEnfants.length; i++)
					{
						enfant = listeEnfants[i];

						// Afficher le div sous-tâche
						setVisibility(enfant, true);
					}
				}
			}
		}
	}

	// Ajustement de la hauteur de l'arboresence
	AjusterHauteurArbo();
		
	if (gestionAffichageDivBoutons) {
		gererAffichageDivBoutons("tache");
	}
}

/**
Bouton radio sous-tâche
*/
function traitementSsTache() {
	gererAffichageDivBoutons("ssTache");
}

/**
 Affichage/masquage de la structure complète
*/
function setVisibilityStructureComplete(visible) {
	// Contenu de l'arboresence
	var contenuArbo = document.getElementById("contenuArbo");
	
	// Si le contenu existe
	if (contenuArbo) {
		// Liste des enfants
		var listeEnfants = contenuArbo.getElementsByTagName("DIV");
		// Si la liste existe
		if (listeEnfants) {
			// Pour chaque enfant
			for(var i= 0; i < listeEnfants.length; i++)
			{
				var enfant = listeEnfants[i];
				
				// S'il ne s'agit pas d'une étape
				if (enfant.id.indexOf("<%= StructLbForm.prefixeIdEtape %>") != 0) {
					// Afficher/masquer le div
					setVisibility(enfant, visible);
				}
			}
		}
	}
}

/**
 Affichage de toutes les tâches d'une étape
*/
function setVisibilityTache(idEtape) {
	// Contenu de l'étape
	var contenuEtape = document.getElementById("<%= StructLbForm.prefixeIdEtape %>" + idEtape);
	
	// Si le contenu existe
	if (contenuEtape) {
		// Liste des enfants
		var listeEnfants = contenuEtape.getElementsByTagName("DIV");
		// Si la liste existe
		if (listeEnfants) {
			// Pour chaque enfant
			for(var i= 0; i < listeEnfants.length; i++)
			{
				var enfant = listeEnfants[i];
				
				// S'il s'agit d'une tâche
				if (enfant.id.indexOf("<%= StructLbForm.prefixeIdTache %>") == 0) {
					// Afficher/masquer le div
					setVisibility(enfant, true);
				}
			}
		}
	}
}

/**
Affichage/masquage d'un div
*/
function setVisibility(div, visible) {
  if (div) {
  	div.className = visible ? "" : "hidden";
  }
}

// FAD PPM 63773 : Ajout d'une fonction pour confirmation de suppression
function ConfirmSuppressionSR(form, action, flag)
{
	var e = document.getElementById("pid");
	var str = e.options[e.selectedIndex].text;

	if(!confirm("Suppression de la structure complète de la ligne :\n" + str + "\nConfirmez votre demande"))
		return false;
	else
		Verifier(form, action, flag);
}

</script>

<!-- #EndEditable --> 


</head>

<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="TraitementInitial();">
<div id="wait" class="tableBleuStr"><img src="../images/indicator.gif"/> Veuillez patienter...</div>
<div style="display:none;" id="ajaxResponse"></div>
<div id="mainContainer">
<div id="topContainer">
<div id="entete"></div>
<div id="logo">
		<div id="logo_sg"><img src="../images/logo_SG.gif" width="162" height="33" border="0" /></div>
		<div id="nomdusite"><img src="../images/bip_logo.png" width="78" height="46" border="0" /></div>
</div>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
 		<tr > 




		  <td> 
            <div id="outils" align="center"><!-- #BeginEditable "barre_haut" -->
              <%ToolBarNew tb = new com.socgen.ich.ihm.ToolBarNew("bip_ihm",false,false,true,true,false,false,false,false,false,request) ;%>
				<%=tb.printHtml()%><!-- #EndEditable -->
			</div>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td height="20" class="TitrePage"><div id="titre" ><!-- #BeginEditable "titre_page" -->Structure d'une ligne BIP<!-- #EndEditable --></div></td>

        </tr>

        <tr> 
          <td>
		  <div id="content">
		  <!-- #BeginEditable "debut_form" --><html:form action="/structLb"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable -->
            <html:hidden property="action"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
            <html:hidden property="mode" value="suite"/>
            <html:hidden property="lib" value="<%=sLigne%>"/>
            <html:hidden property="keyList0"/>
		    <html:hidden property="direction"/>
		    <html:hidden property="typproj"/>
            <table width="100%" border="0">
                <tr> 
                  <td> 
                    <div align="center"><!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>">

		<table border="0" cellpadding="0" cellspacing="0" class="tableBleu" >
	 	<tr> 
          <td>&nbsp;</td>
        </tr>
		<tr>
                <td align="center">
	
				<table border=2 cellspacing=0 cellpadding=10 class="TableBleu" bordercolor="#2E2E2E">
					<tr>
                        <td align="center" class="texte"> <b>Ligne BIP active : <%=sLigne%> </b> </td>
                    </tr>
				</table>
                	</td>
		</tr>	
		<tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
            <tr>
                	<td class="texte"><b>Choisir une autre ligne BIP : </b>
						<html:select property="pid" styleClass="input" onchange="Verifier(this.form,'suite',true);submit();"> 
   						<html:options collection="choixPid" property="cle" labelProperty="libelle" />
						</html:select>
                	</td>



            </tr>	
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		
        </table>
		
		<!-- Si une ligne BIP est sélectionnée -->
		<logic:notEmpty scope="session" name="PID">
			<!-- Si aucune structure n'existe pour la ligne sélectionnée -->
			<logic:empty name="structLbForm" property="structLb">
				<!-- Affichage d'un message en gras encadré -->
				<table border="1" cellspacing="0" cellpadding="10" bordercolor="#2E2E2E">
					<tr>
                        <td><b>La ligne ne poss&egrave;de pas de structure</b></td>
                    </tr>
				</table>
				<!-- Retours chariots -->
				<br><br><br><br><br>
				<!-- Affichage tableau de boutons de création de structure -->
				<table border="0" cellpadding="0" cellspacing="0">
					<logic:equal name="structLbForm" property="typproj" value="7">
						<tr>
		                	<td align="center">
								<html:submit property="boutonCreaManu" value="Cr&eacute;ation manuelle" styleClass="input" onclick="return Verifier(this.form,'creer',true);"/>
		                	</td>
		                	<td width="60">&nbsp;</td>
		                	<td align="center">
		                		<html:submit property="boutonCreaAuto" value="Cr&eacute;ation automatique" styleClass="input" onclick="return Verifier(this.form,'creerLigneAbsence',true);"/> 
		                    </td>
			            </tr>
		            </logic:equal>
		            <logic:notEqual name="structLbForm" property="typproj" value="7">
		            	<tr>
		                	<td align="center">
								<html:submit property="boutonCreaManu" value="Cr&eacute;ation&#10manuelle" styleClass="input" onclick="return Verifier(this.form,'creer',true);"/>
		                	</td>
<!-- PPM 63411 -->
		                	<td width="30">&nbsp;</td>
		                	<td align="center">
		                		<html:submit property="boutonCreaHorsModeProj" value="Cr&eacute;ation&#10minimale" styleClass="input" onclick="return Verifier(this.form,'creerLigneProductiveHorsModeProjet',true);"/> 
		                    </td>
		                    <td width="30">&nbsp;</td>
		                    <td align="center" >
		                		<html:submit property="boutonCreaEnModeProj" value="Cr&eacute;ation automatique&#10normalis&eacute;e" styleClass="input" onclick="return Verifier(this.form,'creerLigneProductiveEnModeProjet',true);"/> 
		                    </td>
 <!-- 	FIN PPM 63411 -->
			            </tr>
		            </logic:notEqual>
		        </table>
			</logic:empty>
			<!-- Si une structure existe pour la ligne sélectionnée -->
			<logic:notEmpty name="structLbForm" property="structLb">
			
			<!--Debut HMI PPM : 63989 Alignement de la structure-->
				<% 
					// Largeurs de colonnes fixes
					int largeurCol1 = 340; 
					int largeurCol2 = 200;
					int largeurCol3 = 100;
					int largeurCol4 = 200;
					%>
				<!-- Affichage tableau structure -->
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<!-- Bouton radio "Structure complète" -->
					<tr>
	                	<td align="left" colspan="8" class="texte"><input type="radio" name="btRadioStructure" id="<%= StructLbForm.idBtRadioStructureComplete %>" value="<%= StructLbForm.idBtRadioStructureComplete %>" onclick="traitementStructureComplete()">Structure compl&egrave;te</td>
	                </tr>
	                <!-- Ligne vide -->
	                <tr><td colspan="8">&nbsp;</td></tr>
	                <!-- Tableau d'en-têtes -->
	                <tr>
	                	<td class="texte" colspan="3" style="color:#FFFFFF; background-color:#5B677D" align="left" width="42%">&Eacute;tape</td>
	                	<td class="texte" colspan="2" style="color:#FFFFFF; background-color:#5B677D" align="left" width="22%">T&acirc;che</td>
	                    <td class="texte" colspan="1" style="color:#FFFFFF; background-color:#5B677D" align="left" width="15%">Ref_demande</td>
	                    <td class="texte" colspan="2" style="color:#FFFFFF; background-color:#5B677D" align="left" width="20%">Sous-t&acirc;che</td>
		            </tr>
	                <!-- Si la structure contient des étapes -->
	                <logic:notEmpty name="structLbForm" property="structLb.etapes"> 
		                <bean:size name="structLbForm" property="structLb.etapesValues" id="nbEtapes"/>
						<!-- Tableau de contenu de l'arborescence -->
		                <tr>
		                	<td colspan="8">
								<!--TODO éventuel : ajouter border-bottom:1px solid #5B677D; -->
		                		<div id="contenuArbo" style="max-height:<%= maxHeightContenuArbo %>px; overflow-y:auto;">
			                		<table border="0" cellpadding="0" cellspacing="0" width="100%">
				                		<% 
										// Déclaration des variables
										StructLbEtape etapeCouranteCast;
										String typeEtapeCast;
										String libelleTypeEtapeCast;
										StructLbTache tacheCouranteCast;
										StructLbSsTache ssTacheCouranteCast;
										
										int longueurChaineCol1;
										String chaineCol1;
										String styleChaineCol1;
										int paddingCol1 = 20;
										%>
										<!-- Ligne vide -->
										<tr><td>&nbsp;</td></tr>
										<tr><td>
											<!-- Pour chaque étape de la ligne BIP sélectionnée -->
											<logic:iterate name="structLbForm" property="structLb.etapesValues" id="etapeCourante" indexId="indexEtape">
												<% 
												etapeCouranteCast = (StructLbEtape) etapeCourante;
												idEtape = etapeCouranteCast.getIdEtape();
												numeroEtape = etapeCouranteCast.getNumeroEtape();
												
												// Construction de la chaine de la colonne 1
												chaineCol1 = numeroEtape;
												typeEtapeCast = etapeCouranteCast.getTypeEtape();
												if (typeEtapeCast != null) {
													chaineCol1 += "  " + typeEtapeCast + " - ";
												}
												libelleTypeEtapeCast = etapeCouranteCast.getLibelleTypeEtape();
												if (libelleTypeEtapeCast != null) {
													chaineCol1 += libelleTypeEtapeCast;
												}
												
												longueurChaineCol1 = chaineCol1.length();
												
												
												// Style de la colonne 1 : 
												// - réduction de la taille de caractères à 13px si chaine trop longue
												// - marge intérieure
												styleChaineCol1 = "style=\"padding-right:20px; width:" + (largeurCol1 - paddingCol1) + "px;" ;
												
												if (longueurChaineCol1 > seuilLongueurCol1) {
													styleChaineCol1 += " font-size:10px;";
												}
												else {
													styleChaineCol1 += " font-size:12px;";
												}
												
												styleChaineCol1 += "\"";
												%>
												<div id="<%= StructLbForm.prefixeIdEtape %><%= idEtape %>">
													<table border="0" cellpadding="0" cellspacing="0" width="100%" >
														<tr align="left">
															<td class="texte" width="5%" valign="top">
																<input type="radio" name="btRadioStructure" style="vertical-align: top;"
																id="<%= StructLbForm.prefixeBtRadioStructure %><%= StructLbForm.prefixeIdEtape %><%= idEtape %>" 
																value="<%= StructLbForm.prefixeBtRadioStructure %><%= StructLbForm.prefixeIdEtape %><%= idEtape %>" 
																onclick="traitementEtape('<%= idEtape %>')">
																<bean:write name="etapeCourante" property="numeroEtape" ignore="true" />
																</td>
													<td class="texte" width="15%" valign="top">
																<logic:notEmpty name="etapeCourante" property="typeEtape">
																<bean:write name="etapeCourante" property="typeEtape" ignore="true"/>&nbsp;-&nbsp;</logic:notEmpty>
																<bean:write name="etapeCourante" property="libelleTypeEtape" ignore="true"/>
															</td>&nbsp;&nbsp;
<%--															<td class="texte" width="<%= largeurCol2 + largeurCol3 + largeurCol4 %>" colspan="3"> --%>
													<td  class="texte" width="20%" valign="top" >
															&nbsp;&nbsp;	<bean:write name="etapeCourante" property="libelleEtape" ignore="true"/>&nbsp;
														</td>
														<td class="texte" >&nbsp;</td>		
													
															
														

															</tr>
													
													
														<!-- Ligne vide -->
														<tr><td colspan="4" >&nbsp;</td></tr>
														<!-- Masquer au chargement de la page -->
														<!-- Si l'étape contient des tâches -->
														<logic:notEmpty name="etapeCourante" property="tachesValues"> 
															<bean:size name="etapeCourante" property="tachesValues" id="nbTaches"/>
															<tr>
															<td colspan="3" width="40%">&nbsp;</td>
															<td>
																<!-- Sous chaque étape, pour chaque tâche de l'étape -->
																<logic:iterate name="etapeCourante" property="tachesValues" id="tacheCourante" indexId="indexTache">
																	<% 
																	tacheCouranteCast = (StructLbTache) tacheCourante;
																	idTache = tacheCouranteCast.getIdTache();
																	numeroTache = tacheCouranteCast.getNumeroTache(); 
																	%>
																	<div id="<%= StructLbForm.prefixeIdTache %><%= idTache %>" class="hidden">
																		<table border="0" cellpadding="0" cellspacing="0" width="100%">
																			<tr align="left">
																				<td class="texte" width="10%" style="vertical-align: top;">
																					<input type="radio" name="btRadioStructure" style="vertical-align: top;" 
																					id="<%= StructLbForm.prefixeBtRadioStructure %><%= StructLbForm.prefixeIdTache %><%= idTache %><%= StructLbForm.prefixeIdEtape %><%= idEtape %>" 
																					value="<%= StructLbForm.prefixeBtRadioStructure %><%= StructLbForm.prefixeIdTache %><%= idTache %><%= StructLbForm.prefixeIdEtape %><%= idEtape %>" 
																					onclick="traitementTache('<%= StructLbForm.prefixeIdTache %><%= idTache %><%= StructLbForm.prefixeIdEtape %><%= idEtape %>', true)">
																					<bean:write name="tacheCourante" property="numeroTache" ignore="true"/>
																					</td>
																					<td class="texte" width="30%" style="vertical-align: top;">
																					<bean:write name="tacheCourante" property="libelleTache" ignore="true"/>
																				</td>
																				<logic:notEmpty name="tacheCourante" property="tacheAxeMetier"> 
																				<td  class="texte" width="20%" style="vertical-align: top;" >
																				&nbsp; <bean:write name="tacheCourante" property="tacheAxeMetier" ignore="true"/>	
																				</td>
																				</logic:notEmpty>
																				
																				<logic:empty name="tacheCourante" property="tacheAxeMetier"> 
																				<td  class="texte" width="20%" >
																				&nbsp;&nbsp;
																				</td>
																				</logic:empty>
																				
																				<td width="40%">&nbsp;</td>
																			</tr>
																			<!-- Ligne vide -->
																			<tr><td colspan="4" >&nbsp;</td></tr>
																			<!-- Si la tâche contient des sous-tâches -->
																			<logic:notEmpty name="tacheCourante" property="ssTachesValues"> 
																				<bean:size name="tacheCourante" property="ssTachesValues" id="nbSsTaches"/>
																				<tr>
																				<td colspan="3" width="60%">&nbsp;</td>
																				<td width="40%" style="vertical-align: top;">
																					<!-- Sous chaque tâche, pour chaque sous-tâche de la tâche -->
																					<logic:iterate name="tacheCourante" property="ssTachesValues" id="ssTacheCourante" indexId="indexSsTache">
																						<% 
																						ssTacheCouranteCast = (StructLbSsTache) ssTacheCourante;
																						idSsTache = ssTacheCouranteCast.getIdSsTache();
																						numeroSsTache = ssTacheCouranteCast.getNumeroSsTache();
																						%>
																						<div id="<%= StructLbForm.prefixeIdSsTache %><%= idSsTache %>" class="hidden">
																							<table  cellpadding="0" cellspacing="0" width="100%">
																								<tr align="left">
																									<td  class="texte" width="20%" style="vertical-align: top;">
																										<input type="radio" name="btRadioStructure" style="vertical-align: top;"
																										id="<%= StructLbForm.prefixeBtRadioStructure %><%= StructLbForm.prefixeIdSsTache %><%= idSsTache %><%= StructLbForm.prefixeIdTache %><%= idTache %><%= StructLbForm.prefixeIdEtape %><%= idEtape %>"
																										value="<%= StructLbForm.prefixeBtRadioStructure %><%= StructLbForm.prefixeIdSsTache %><%= idSsTache %><%= StructLbForm.prefixeIdTache %><%= idTache %><%= StructLbForm.prefixeIdEtape %><%= idEtape %>" 
																										onclick="traitementSsTache()">
																										<bean:write name="ssTacheCourante" property="numeroSsTache" ignore="true"/>
																										</td>
																										<td  class="texte" width="80%" style="vertical-align: top;">
																										<bean:write name="ssTacheCourante" property="libelleSsTache" ignore="true"/>
																									</td>
																								</tr>
																								<!-- S'il s'agit de la dernière sous-tâche d'une tâche différente de la dernière tâche de la dernière étape -->
																								<% if ( !(nbEtapes.intValue() - 1 == indexEtape && nbTaches.intValue() - 1 == indexTache)
																									&& nbSsTaches.intValue() - 1 == indexSsTache) { %>
																									<!-- Ligne vide -->
																									<tr><td colspan="2">&nbsp;</td></tr>
																								<% } %>
																							</table>
																						</div>
																					</logic:iterate>
																				</td></tr>
																			</logic:notEmpty>
																		</table>
																	</div>
																</logic:iterate>
															</td></tr>
														</logic:notEmpty>
													</table>
												</div>
											</logic:iterate>
										</td></tr>
					        		</table>
					        	</div>
		                	</td>
		                </tr>
		             </logic:notEmpty>
				</table>
				<!--FIN HMI PPM : 63989 Alignement de la structure-->
				<br>
				<!-- Tableau de boutons « Créer une étape » et « Annuler » - Si aucun radio bouton ou "Structure complète" coché -->
				<div id="divBtsStructCompleteOuAucun" class="hidden">
					<table border="0" cellpadding="0" cellspacing="0" width="<%= largeurCol1 + largeurCol2 + largeurCol3 + largeurCol4 %>px">
						<!-- Ligne contenant un trait continu noir -->
						<tr>
							<td colspan="4">
								<hr size="1" color="#5B677D"/> 
							</td>
						</tr>
						<tr><td colspan="4">&nbsp;</td></tr>
						<tr>
							<td width="180">&nbsp;</td>
							<td align="center">
								<html:submit property="boutonCreaEtape" value="Cr&eacute;er une &eacute;tape" styleClass="input" onclick="return Verifier(this.form, 'creer', true);"/>
							</td>
							<td align="center">
								<html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="return Verifier(this.form,'annuler',true);"/>
							</td>
							<!-- FAD PPM 63773: Ajout du bouton "Supprimer structure complète" -->
							<td align="center">
								<html:submit property="boutonSupprimerStr" value="Supprimer structure complète" styleClass="input" onclick="return ConfirmSuppressionSR(this.form, 'supprimerStr', true);"/>
							</td>
							<!-- <td width="180">&nbsp;</td> -->
						</tr>
					</table>
				</div>
				<!-- Tableau de boutons « Créer une étape / tâche / sous-tâche » et « Annuler » - Si un radio bouton autre que "Structure complète" -->
				<div id="divBts" class="hidden">
					<table border="0" cellpadding="0" cellspacing="0" width="<%= largeurCol1 + largeurCol2 + largeurCol3 + largeurCol4 %>px">
						<!-- Ligne contenant un trait continu noir -->
						<tr>
							<td colspan="3">
								<hr size="1" color="#5B677D"/> 
							</td>
						</tr>
						<!-- Ligne contenant le libellé "Etape", respectivement "Tâche", respectivement "Sous-tâche"
						en gras, aligné à gauche -->
						<tr>
							<td colspan="3" class="texteGras">
								<div id="divBtsEtape" class="hidden">
									<!-- Si une étape est cochée -->
									&Eacute;tape
								</div>
								<div id="divBtsTache" class="hidden">
									<!-- Si une tâche est cochée -->
									T&acirc;che
								</div>
								<div id="divBtsSsTache" class="hidden">
									<!-- Si une sous-tâche est cochée -->
									Sous-t&acirc;che
								</div>
							</td>
						</tr>
						<tr><td colspan="3">&nbsp;</td></tr>
						<tr>
							<td align="left" width="100px">
								<html:submit property="boutonModif" value="Modifier" styleClass="input" onclick="return Verifier(this.form, 'modifier', true);"/>
							</td>
							<td align="center">
								<html:submit property="boutonSuppr" value="Supprimer" styleClass="input" onclick="return Verifier(this.form, 'supprimer', true);"/>
							</td>
							<td align="right" width="100px">
								<html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="return Verifier(this.form,'annuler',true);"/>
							</td>
						</tr>
						<tr><td colspan="3">&nbsp;</td></tr>
						<!-- Ligne contenant un trait continu noir - Si bouton radio autre que sous tâche est coché -->
						<tr>
							<td colspan="3">
								<hr size="1" color="#5B677D"/> 
							</td>
						</tr>
						<tr><td colspan="3">&nbsp;</td></tr>
					</table>
					<table border="0" cellpadding="0" cellspacing="0" width="<%= largeurCol1 + largeurCol2 + largeurCol3 + largeurCol4 %>px">
						<tr>
							<td align="center" colspan="3">
							<div id="divBtsEtape" class="hidden">
								
								<!-- Si bouton radio étape coché -->
								<html:submit property="boutonCreaTache" value="Cr&eacute;er une t&acirc;che" styleClass="input" onclick="return Verifier(this.form, 'creer', true);"/>
								<!-- FAD PPM 63773: Ajout du bouton "Supprimer structure complète" -->
								<html:submit property="boutonSupprimerStr" value="Supprimer structure complète" styleClass="input" onclick="return ConfirmSuppressionSR(this.form, 'supprimerStr', true);"/>
							</div>
							<div id="divBtsTache" class="hidden">
								<!-- Si bouton radio tâche coché -->
								<html:submit property="boutonCreaSsTache" value="Cr&eacute;er une sous-t&acirc;che" styleClass="input" onclick="return Verifier(this.form, 'creer', true);"/>
								<!-- FAD PPM 63773: Ajout du bouton "Supprimer structure complète" -->
								<html:submit property="boutonSupprimerStr" value="Supprimer structure complète" styleClass="input" onclick="return ConfirmSuppressionSR(this.form, 'supprimerStr', true);"/>
							</div>
							<div id="divBtsSsTache" class="hidden">
								<!-- FAD PPM 63773: Ajout du bouton "Supprimer structure complète" -->
								<html:submit property="boutonSupprimerStr" value="Supprimer structure complète" styleClass="input" onclick="return ConfirmSuppressionSR(this.form, 'supprimerStr', true);"/>
							</div>
							</td>
						</tr>
					</table>
				</div>
			</logic:notEmpty>
			<br>
		</logic:notEmpty>
                  <!-- #EndEditable --></div>
                  </td>
                </tr>
            
            </table>
			  <!-- #BeginEditable "fin_form" --></html:form><!-- #EndEditable -->
			</div>
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

<!-- #EndTemplate -->