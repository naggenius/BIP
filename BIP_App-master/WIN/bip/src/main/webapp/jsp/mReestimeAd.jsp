<!DOCTYPE html>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="reestimeForm" scope="request" class="com.socgen.bip.form.ReestimeForm" />

<%@page import="com.socgen.bip.form.ReestimeForm"%>
<html:html locale="true"> <!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fReestimeAd.jsp"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<!-- <link rel="stylesheet" href="../css/base_style.css" type="text/css"> -->
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";

var blnVerifFormat  = true;
var tabVerif = new Object();

function MessageInitial()
{
   tabVerif["preesancou"]	= "VerifierNumNegatif(document.forms[0].preesancou,8,2)";

   var Message="<bean:write filter="false"  name="reestimeForm"  property="msgErreur" />";
   var Focus = "<bean:write name="reestimeForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
    else {
	   document.forms[0].preesancou.focus();
    }
}

function Verifier(form, action,mode,flag)
{
   blnVerification = flag;
   form.action.value = action;
   form.mode.value = "update";
}

function ValiderEcran(form)
{
   	if (blnVerification==true) {
		if ( !VerifFormat(null) ) {
			return false;
		}
		if (VerifierChampsComm()) {
			
			if (!confirm("Voulez-vous modifier le réestimé de l'année courante pour cette ligne BIP ?")) {
				return false;
			}
   		}
		else {
			
			return false;
		}
   }
   return true;
}

function VerifierChampsComm() {
	var elementErrone; 
	
// 	if (document.getElementById("reescomm") && ContientCarSpec(document.getElementById("reescomm"))) {
// 	PPM 63304
		if (ContientCarSpec(document.forms[0].reescomm)) {
		elementErrone = document.forms[0].reescomm; 
	}
	
	// Si un champ commentaire n'est pas valide
	if (elementErrone != null) {
		// Afficher une popup d'erreur
		alert("Vous avez saisi des caractères non autorisés, veuillez les enlever\n\nListe des caractères interdits : äëïöüÄË$%²\"&!?;@§/<>~+=#{[|`^]}°¤£µ¨\'");
		// Mettre le focus sur le champ erroné
		elementErrone.focus();
		return false;
	} else {
		return true;
	}
}

function ContientCarSpec(elementTextarea) {
	// Si l'élément existe
	if (elementTextarea != null) {
		// Expression régulière contenant l'ensemble des catactères spéciaux à interdire
		var exprCarSpec=new RegExp("\\ä|\\ë|\\ï|\\ö|\\ü|\\Ä|\\Ë|\\\$|\\%|\\²|\\\"|\\&|\\!|\\?|\\;|\\@|\\§|\\/|\\<|\\>|\\~|\\+|\\=|\\#|\\{|\\[|\\||\\`|\\^|\\]|\\}|\\°|\\¤|\\£|\\µ|\\¨|\\\\|\\'");
		
		// Si le champ correspond à l'expression régulière
		
		return exprCarSpec.test(elementTextarea.value);
	}
	else {
		return false;
	}
}



/**
	Traitement effectué après saisie d'un caractère dans un champ commentaire
*/
function TraiterComm(elementTextarea, divCompteur) {
	TraiterLongueurChaineComm(elementTextarea);
	AlimenterCompteurNbCarRestants(elementTextarea, divCompteur);
}

/**
	Tronquer chaine commentaire
*/
function TraiterLongueurChaineComm(elementTextarea) {
	// Si la taille max autorisée est dépassée
	if (parseInt(elementTextarea.value.length) > parseInt(<%= ReestimeForm.longueurMaxCommentaire %>)) {
		// Tronquer
		elementTextarea.value=elementTextarea.value.substring(0, parseInt(<%= ReestimeForm.longueurMaxCommentaire %>));
	}
}

/**
	MAJ du compteur de nombre de caractères restants
*/
function AlimenterCompteurNbCarRestants(elementTextarea, divCompteurNbCarRestants) {
	var compteur = 0;

	if (parseInt(elementTextarea.value.length) < parseInt(<%= ReestimeForm.longueurMaxCommentaire %>)) {
		compteur =  parseInt(<%= ReestimeForm.longueurMaxCommentaire %>) - parseInt(elementTextarea.value.length);
	}
	
	divCompteurNbCarRestants.innerHTML = compteur;
}

function AjusterLargeurDivComm(largeurMax) {
	AjusterLargeurDiv(largeurMax,"divReesComm");
}

function AjusterLargeurDiv(largeurMax, nomElementsDiv) {
	var elementsDiv = document.getElementsByTagName("div");
	if (elementsDiv) {
		var elementDiv;
		for (var i=0; i<elementsDiv.length; i++) {
			elementDiv = elementsDiv.item(i);
			if (elementDiv  && elementDiv.getAttribute("name") == nomElementsDiv) {
				// Si la largeur dépasse la largeur max
				if ((elementDiv.offsetWidth) > parseInt(largeurMax)) {
					elementDiv.style.width = largeurMax + 'px';
				}
			}
		}
	}
}

function TraitementInitial() {
	MessageInitial();
	AjusterLargeurDivComm('500');
}

</script>
<!-- #EndEditable --> 
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="TraitementInitial();">
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Modifier 
            le r&eacute;estim&eacute; de l'ann&eacute;e courante<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/reestime"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
			<input type="hidden" name="pageAide" value="<%= sPageAide %>"> 
			<html:hidden property="action"/> 
			<html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/> 
			<html:hidden property="flaglock"/> 
			<html:hidden property="flag"/>
			  
              <table border=0  cellpadding=2 cellspacing=2 class="tableBleu">
                <tr> 
                  <td height ="20" align=center >&nbsp;</td>
                  <td >&nbsp;</td>
                </tr>
                <tr> 
                  <td >&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr align="left"> 
                  <td class=texte>Code ligne BIP : &nbsp </td>
                  <td class=texte>  
                    <bean:write name="reestimeForm"  property="pid" />
                    	<html:hidden property="pid"/>
                  </td>
                </tr>
                <tr align="left"> 
                  <td class=texte>Libell&eacute; ligne BIP</td>
                  <td class=texte><bean:write name="reestimeForm"  property="pnom" />
                    	<html:hidden property="pnom"/>
                  </td>
                </tr>
                <tr align="left"> 
                  <td class=texte>D&eacute;partement/P&ocirc;le/Groupe :</td>
                  <td class=texte><bean:write name="reestimeForm"  property="codsg" />
                    	<html:hidden property="codsg"/>
                  </td>
                </tr>
                <tr align="left"> 
                  <td colspan=2 class="texte"> 
                    <hr>
                    Consomm&eacute; de l'ann&eacute;e courante :  
                    <bean:write name="reestimeForm"  property="xcusag0" />
                    	<html:hidden property="xcusag0"/>
                    <hr>
                  </td>
                </tr>
                <tr align="left"> 
                  <td class="texte" >Budget notifi&eacute; de l'ann&eacute;e courante 
                    :</td>
                  <td class="texte"><bean:write name="reestimeForm"  property="bnmont" />
                    	<html:hidden property="bnmont"/>
                  </td>
                </tr>
                <tr align="left"> 
                  <td rowspan=2 colspan=2 class="lib" align=center>BUDGET</td>
                  <td colspan=2 class="lib" align=center>
				    Derni&egrave;re mise &agrave; jour
				  </td>
                </tr>
                <tr align="left"> 
                  <td class="lib" align=center>
				    DATE
				  </td>
				  <td class="lib" align=center>
				    PAR
				  </td>
                </tr>
                <tr align="left"> 
                  <td class="texte" >R&eacute;estim&eacute; de l'ann&eacute;e courante 
                    : </td>
                  <td class="texte" align="right">
				  <html:text property="preesancou" styleClass="input" size="9" maxlength="9" onchange="return VerifFormat(this.name);"/>  
                  </td>
                  <td class="texte" align="right">
				   	<bean:write name="reestimeForm"  property="redate" />
                    <html:hidden property="redate"/>
				  </td>
                  <td class="texte" align="right">
                  	<bean:write name="reestimeForm"  property="ureestime" />
                    <html:hidden property="ureestime"/>
				  </td>
                </tr>
                <tr align="left"> 
                  <td class="texte" >Estimation pluriannuelle :</td>
                  <td class="texte" align="right">
				  <html:text property="estimpluran" styleClass="input" size="9" maxlength="9" onchange="return VerifierNum(this,8,2);"/>   
                  </td>
                </tr>
                <tr> 
                  <td colspan=4 style="padding-bottom:0px;" class="texte" align="left">
				    <textarea name="reescomm" style="width:500px;" rows="3" cols="53" 
				    maxlength="<%= ReestimeForm.longueurMaxCommentaire %>" 
				    onkeyup="TraiterComm(this, document.getElementById('compteurNbCarRestantsReescomm'))"><bean:write name="reestimeForm" property="reescomm" /></textarea>
				  </td>
                </tr>
                 <tr> 
                  <td colspan=2></td>
                  <td class="texte" style="padding-top:0px;padding-bottom:0px;vertical-align:top;height:1px">
				  	<div id="compteurNbCarRestantsReescomm">
				  		<bean:write name="reestimeForm" property="nbCarRestantsReescomm"/>
				  	</div>
				  </td>
				  <td></td>
                </tr>
                <tr> 
                  <td colspan=2>&nbsp;</td>
                </tr>
                
<!--  COMMENTAIRE A TRAITER -->                
               	<tr align="left"> 
		        	<td class="texte">
				    	<b><%= ReestimeForm.libelleHistorique %></b>
			        </td>
			        <!-- Si l'historique des Réestimés est inexistant ou vide -->
        			<logic:empty name="reestimeForm" property="reesHisto"> 
						<td class="texte" align="right">
							<%= ReestimeForm.valeurNeant %>
						</td>
						<td colspan=2>
						</td>
					</logic:empty>
					<!-- Si l'historique des Réestimés existe -->
					<logic:notEmpty name="reestimeForm" property="reesHisto"> 
						<td colspan=3 style="border-bottom:2px solid  #e7e7eb">&nbsp;
						</td>
					</logic:notEmpty>
				</tr>
				<!-- Si l'historique des Réestimés n'est pas vide -->
        		<logic:notEmpty name="reestimeForm" property="reesHisto"> 
				<% int compteurListeReesHisto = 0; %>
				<logic:iterate name="reestimeForm" property="reesHisto" id="listeReesHistoId">
					<% compteurListeReesHisto++; %>
				<tr align="left"> 
					<td class="texte">
					</td>
				    <td class="texte">
						<bean:write name="listeReesHistoId"  property="valeur" ignore="true"/>
					</td>
					<td class="texte">
						<bean:write name="listeReesHistoId"  property="dateModif" ignore="true"/>
					</td>
					<td class="texte">
						<bean:write name="listeReesHistoId"  property="matricule" ignore="true"/>
					</td>
				</tr>
				<!-- Si le commentaire Réestimés n'est pas vide -->
				<!-- -- ABN - PPM 64321 -->
       		 	<logic:notEmpty name="listeReesHistoId" property="commentaire"> 
					<tr> 
					  <td colspan=4 class="texte" style="border-bottom:2px solid #F0F0DF">
						<div name="divReesComm" align="justify">
							<bean:write name="listeReesHistoId" property="commentaire" ignore="true"/>
						</div>
					  </td>
					</tr>
				</logic:notEmpty>
			
				<!-- Conditionnement de l'espacement entre les blocs : si ce n'est pas le dernier élément -->
	            <% if (compteurListeReesHisto < reestimeForm.getReesHisto().size()) { %>
                <tr> 
                	<td colspan=4 height="10px"></td>
                </tr>
                <%} %>
			    </logic:iterate>
			    </logic:notEmpty>
<!--  COMMENTAIRE A TRAITER -->           
			             
              </table>
              <!-- #EndEditable --></div>
          </td>
        </tr>
        <tr> 
          <td align="center"> 
            <table width="100%" border="0">
            <tr><td height="20" ></td></tr>
              <tr> 
                <td width="25%">&nbsp;</td>
                <td width="25%"> 
                  <div align="center"> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', this.form.mode.value,true);"/> 
                  </div>
                </td>
                <td width="25%"> 
                  <div align="center"> <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', null, false);"/> 
                  </div>
                </td>
                <td width="25%">&nbsp;</td>
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
</div>
	<div id="bottomContainer">
			<div>&nbsp;</div>
	</div>
</div>
</body>
<% 
Integer id_webo_page = new Integer("1055"); 
com.socgen.bip.commun.form.AutomateForm formWebo = reestimeForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
