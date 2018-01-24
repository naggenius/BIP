 <%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" -->
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="ligneInvestissementForm" scope="request" class="com.socgen.bip.form.LigneInvestissementForm" />
<jsp:useBean id="listedyn" scope="request" class="com.socgen.bip.commun.liste.ListeDynamique" />
<jsp:useBean id="db" scope="request" class="com.socgen.bip.db.JdbcBip" />

<html:html locale="true">
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" -->
<head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" -->
<title>Page BIP</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" -->
<bip:VerifUser page="jsp/bLigneInvLb.jsp"/>


<%
  /************ Liste Type investissements *****************/
  java.util.ArrayList listeType = listedyn.getListeDynamique("type.investissements",ligneInvestissementForm.getHParams());
  pageContext.setAttribute("choixType", listeType);

  /************ Liste Projet *****************/
  java.util.ArrayList listeProjet = listedyn.getListeDynamique("projet_alpha",ligneInvestissementForm.getHParams());
  pageContext.setAttribute("choixProjet", listeProjet);

  /************ Liste Doosier Projets *****************/
  java.util.ArrayList listeDossierProjet = listedyn.getListeDynamique("dprojet_alpha",ligneInvestissementForm.getHParams());
  pageContext.setAttribute("choixDossierProjet", listeDossierProjet);
  /**************liste Recurrent/Projet*****************/
  java.util.ArrayList listerp = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("toprp"); 
  pageContext.setAttribute("choixRecurentProjet", listerp);
  // On récupère le menu courant	
	com.socgen.bip.user.UserBip user = (com.socgen.bip.user.UserBip)session.getAttribute("UserBip") ;
	com.socgen.bip.menu.item.BipItemMenu menu = user.getCurrentMenu();
	String menuId = menu.getId();
	String sousMenus = user.getSousMenus(); 
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
var nbCar;

function compteCar(elem)
{nbCar = elem.value.length;

if (nbCar >200) {
alert("Le commentaire ne doit pas dépasser 200 caractères.");elem.value=document.forms[0].cominv.value;elem.focus;return false;}
else
document.forms[0].cominv.value= elem.value;

}
function MessageInitial()
{
   var Message="<bean:write filter="false"  name="ligneInvestissementForm"  property="msgErreur" />";
   var Focus = "<bean:write name="ligneInvestissementForm"  property="focus" />";

   if (Message != "") {
      alert(Message);
   }

   if (document.forms[0].mode.value=="insert"){
      	document.forms[0].quantite.value="1";
     	document.forms[0].demande.value="0,00";
   }

   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else if (document.forms[0].mode.value=="insert"){
	  document.forms[0].demande.focus();

   }
   else if (document.forms[0].mode.value=="update"){;
	  document.forms[0].re_estime.focus();
   }

}

function Verifier(form, action, mode, flag)
{
   blnVerification   = flag;
   form.mode.value   = mode;
   form.action.value = action;
}

function ValiderEcran(form)
{
	if (blnVerification) {
		if (form.quantite && !ChampObligatoire(form.quantite, "la quantité")) return false;
		if (form.demande && !ChampObligatoire(form.demande, "le demandé")) return false;
		if (form.re_estime && !ChampObligatoire(form.re_estime, "le ré-estimé")) return false;

		if (form.quantite && form.quantite.value=="0"){
			alert("la quantité doit être non nulle");
			form.quantite.focus();
			return false;
		}
		if (form.dpcode && !ListeObligatoire(form.dpcode, "le dossier projet")) return false;
		if (form.pcode && !ListeObligatoire(form.pcode, "le projet")) return false;
		//test commentaire alphanumérique. Ne pas effacer le texte.
		form.cominv.value=form.liste_objet.value;
	 	var restrict = '$";';
   		var Caractere;

   		for (Cpt=0; Cpt < form.cominv.value.length; Cpt++ ) {
			Caractere = form.cominv.value.charAt(Cpt);
			if (restrict.indexOf(Caractere) != -1) {
	   			alert( "Saisie invalide");
	   			form.liste_objet.focus();
	   			return false;
			}
  		}
   		return compteCar(document.forms[0].liste_objet);
   		
		if (form.mode.value == "insert") {
			form.re_estime.value = form.demande.value;
			form.notifie.value = "0,00";
		}
		if (form.mode.value == "update") {
		         if (!confirm("Voulez-vous modifier la ligne d'investissement ?")) return false;
		}
		if (form.mode.value == "delete") {
			if (!confirm("Voulez-vous supprimer la ligne d'investissement ?")) return false;
		}
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->
	<logic:equal parameter="mode" value="check">
	<% ligneInvestissementForm.setTitrePage("Consulter"); %>
	</logic:equal>
	 <bean:write name="ligneInvestissementForm" property="titrePage"/> une ligne budgétaire<!-- #EndEditable --></td>

        </tr>
        <tr>
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr>
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/ligneinv"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable -->



            <div align="center"><!-- #BeginEditable "contenu" -->
		<input type="hidden" name="pageAide" value="<%= sPageAide %>">
		<html:hidden property="titrePage"/>
		<html:hidden property="action"/>
		<html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
		<html:hidden property="flaglock"/>
		
              <table width="100%" cellspacing="2" cellpadding="2" class="tableBleu">
              <tr>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td >&nbsp;</td>
                </tr>
                <!-- LIGNE et ANNEE EXERCICE + CA-->
                <tr>
                  <td class="lib">
                  <b>Ligne num&eacute;ro:</b></td>
                  <td><b><bean:write name="ligneInvestissementForm"  property="codinv"/></b>
                    	<html:hidden property="codinv"/>
                  </td>
                </tr>
                <tr>
                  <td class="lib"><b>Exercice :</b></td>
                  <td>
                        <bean:write name="ligneInvestissementForm"  property="annee" />
						<b>&nbsp;&nbsp;CA&nbsp;&nbsp;</b>
						<bean:write name="ligneInvestissementForm"  property="codcamo" />
						&nbsp;-&nbsp;
						<bean:write name="ligneInvestissementForm"  property="libCa" />
                    	<html:hidden property="annee"/>
                    	<html:hidden property="codcamo"/>
                    </td>
                </tr>
		<!-- TYPE INVESTISSEMENT -->
                <tr>
                  <td class="lib"><b>Type :</b></td>
                  <td >
                    <logic:notEqual parameter="action" value="supprimer">
                   	  <% if (!ligneInvestissementForm.getIsNotifiee()) { %>
                  		<html:select property="type" styleClass="input">
						  <html:options collection="choixType" property="cle" labelProperty="libelle" />
						</html:select>
					  <% } 
					  else { %>
						<bean:write name="ligneInvestissementForm" property="libType"/>
                   		<html:hidden property="type"/>
                   	  <% } %>
                   </logic:notEqual>
                   <logic:equal parameter="action" value="supprimer">
                   	  <bean:write name="ligneInvestissementForm" property="libType"/>
                   	  <html:hidden property="type"/>
                   </logic:equal>

                  </td>
                </tr>

                <!-- DOSSIER PROJET -->
                <tr>
                  <td class="lib"><b>Dossier projet :</b></td>
                  <td>
                    <logic:notEqual parameter="action" value="supprimer">
                      <% if (!ligneInvestissementForm.getIsNotifiee()) { %>
                  		<html:select property="dpcode" styleClass="input" onchange="rafraichir(document.forms[0]);">
						  <html:options collection="choixDossierProjet" property="cle" labelProperty="libelle" />
						</html:select>
					  <% } 
					  else { %>
					  	<bean:write name="ligneInvestissementForm" property="libDossierProjet"/>
                   	  	<html:hidden property="dpcode"/>
                   	  <% } %>
                   </logic:notEqual>
                   <logic:equal parameter="action" value="supprimer">
                   	 <bean:write name="ligneInvestissementForm" property="libDossierProjet"/>
                   	 <html:hidden property="dpcode"/>
                   </logic:equal>
                  </td>
                </tr>

                <!-- PROJET -->
                <tr>
                  <td class=lib><b>Projet</b> : </td>
                  <td>
                    <logic:notEqual parameter="action" value="supprimer">
                      <% if (!ligneInvestissementForm.getIsNotifiee()) { %>
                  		<html:select property="pcode" styleClass="input">
						  <html:options collection="choixProjet" property="cle" labelProperty="libelle" />
						</html:select>
					  <% } 
					  else { %>
						<bean:write name="ligneInvestissementForm" property="libProjet"/>
                   		<html:hidden property="pcode"/>
                   	  <% } %>
                   </logic:notEqual>
                   <logic:equal parameter="action" value="supprimer">
                   	  <bean:write name="ligneInvestissementForm" property="libProjet"/>
                   	  <html:hidden property="pcode"/>
                   </logic:equal>
                  </td>
                </tr>                
            <%-- Alignement des champs de saisies --%>
            <logic:notEqual parameter="action" value="supprimer">
           		</table>
           		</div>
           		<div align="center">
           		<table width="100%" cellspacing="2" cellpadding="2" class="tableBleu">
            </logic:notEqual>
            <%-- Fin Alignement des champs de saisies --%>
                <!-- LIBELLE -->
                <tr>
                  <td class=lib width="22%"><b>Libellé :</b></td>
                  <td>
                    <logic:notEqual parameter="action" value="supprimer">
                      <% if (!ligneInvestissementForm.getIsNotifiee()) { %>
                  		<html:text property="libelle" styleClass="input" size="30" maxlength="25"/>
                  	  <% } 
                  	  else { %>
						<bean:write name="ligneInvestissementForm"  property="libelle" />
						<html:hidden property="libelle"/>
					  <% } %>
                   </logic:notEqual>
                   <logic:equal parameter="action" value="supprimer">
                   	 <bean:write name="ligneInvestissementForm"  property="libelle" />
                   </logic:equal>
                  </td>
                </tr>
                <!-- QUANTITE -->
                <tr>
                  <td class=lib><b>Quantité :</b></td>
                  <td>
                    <logic:notEqual parameter="action" value="supprimer">
                      <% if (!ligneInvestissementForm.getIsNotifiee()) { %>
                  		<html:text property="quantite" styleClass="input" size="3" maxlength="3" onchange="return VerifierNum(this,3,0);"/>
                  	  <% } 
                  	  else { %>
						<bean:write name="ligneInvestissementForm"  property="quantite" />
						<html:hidden property="quantite"/>
					  <% } %>
                   </logic:notEqual>
                   <logic:equal parameter="action" value="supprimer">
                   	  <bean:write name="ligneInvestissementForm"  property="quantite" />
                   </logic:equal>
                  </td>
                 </tr>
                 <!-- Demandé et Réalisé -->
                 <tr>
                  <td class="lib"><b>Demand&eacute; :</b></td>
                  <td>
                    <logic:notEqual parameter="action" value="supprimer">
                      <% if (!ligneInvestissementForm.getIsNotifiee()) { %>
                  		<html:text property="demande" styleClass="input" size="9" maxlength="9" onchange="if (VerifierNum(this,8,2)==true)this.form.re_estime.value=this.form.demande.value;"/> (K&euro; HT)
                  	  <% } 
                  	  else { %>
						<bean:write name="ligneInvestissementForm"  property="demande" /> K&euro; HT
						<html:hidden property="demande"/>
					  <% } %>
                   </logic:notEqual>
                   <logic:equal parameter="action" value="supprimer">
                   	 <bean:write name="ligneInvestissementForm"  property="demande" /> K&euro; HT
                   </logic:equal>
                  </td>
                  <logic:notEqual parameter="mode" value="insert">
                  	<td class="lib"><b>R&eacute;alis&eacute; :</b></td>
					<td><bean:write name="ligneInvestissementForm"  property="engage" /> K&euro; HT</td>
                  </logic:notEqual>
                </tr>
                <!-- NOTIFIE et RE_ESTIME -->
                <tr>
                <!-- NOTIFIE : Menu supervision et action = modifier -->
                
		
			<logic:equal parameter="action" value="supprimer">
				<td class="lib"><b>Notifi&eacute; :</b></td>
				<td><bean:write name="ligneInvestissementForm"  property="notifie" /> K&euro; HT</td>
			</logic:equal>
			<logic:equal parameter="mode" value="update">
				  <!-- Si on est superviseur des investissements on peut modifier le notifié -->
				<% if ( sousMenus.indexOf("ginv") >= 0 ) { %>
				  <td class="lib"><b>Notifi&eacute; :</b></td>
				  <td>
				  	<html:text property="notifie" styleClass="input" size="9" maxlength="9" onchange="return VerifierNum(this,8,2);"/> (K&euro; HT)</td>
				<% }
				else {%>
				  <td class="lib"><b>Notifi&eacute; :</b></td>
				  <td><bean:write name="ligneInvestissementForm"  property="notifie" /> K&euro; HT</td>
				  <html:hidden property="notifie"/>
				<% } %>
			</logic:equal>

                 <!-- Fin Menu supervision -->

		<logic:notEqual parameter="action" value="supprimer">
			<logic:notEqual parameter="mode" value="insert">
			  <td class="lib"><b>R&eacute;-estim&eacute; :</b></td>
			  <td>
				<html:text property="re_estime" styleClass="input" size="9" maxlength="9" onchange="return VerifierNum(this,8,2);"/> (K&euro; HT)
			  </td>
			</logic:notEqual>
			<logic:equal parameter="mode" value="insert">
			  <html:hidden property="re_estime" value="-1"/>
			</logic:equal>
		</logic:notEqual>
		<logic:equal parameter="action" value="supprimer">
			<td class="lib"><b>R&eacute;-estim&eacute; :</b></td>
			<td>
			  <bean:write name="ligneInvestissementForm"  property="re_estime" /> K&euro; HT
			</td>
		</logic:equal>

                </tr>
                <!--début commentaires -->
                 <tr>
                  <td class=lib width="22%"><b>Commentaires :</b></td>
                  <td colspan=3>
                    <logic:notEqual parameter="action" value="supprimer">
                     
                      <html:hidden property="cominv"/> 
                    <script language="JavaScript">
			var obj = document.forms[0].cominv.value;
			document.write("<textarea name=liste_objet class='input' onkeyUp='return compteCar(this)' rows=3 cols=66 wrap>" + obj +"</textarea>");
			</script>
			          </logic:notEqual>
                   <logic:equal parameter="action" value="supprimer">
                   	 <bean:write name="ligneInvestissementForm"  property="cominv" />
                   </logic:equal>
                  </td>
                </tr>
                 <tr>
                  <td class="lib"><b><u>R</u>écurrent/<u>P</u>rojet :</b></td>
                  <td >
                    <logic:notEqual parameter="action" value="supprimer">
                  		<html:select property="toprp" styleClass="input"> 
				<html:options collection="choixRecurentProjet" property="cle" labelProperty="libelle" />
				</html:select>
					 </logic:notEqual>
                   <logic:equal parameter="action" value="supprimer">
                   	  <bean:write name="ligneInvestissementForm" property="toprp"/>
                   	  <html:hidden property="toprp"/>
                   </logic:equal>

                  </td>
                </tr>
                 <!--fin commentaires -->
                 <tr>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td >&nbsp;</td>
                </tr>
              </table>
              <!-- fin template -->
              <!-- #EndEditable --></div>
          </td>
        </tr>
        <tr>
          <td align="center">
            <table width="100%" border="0">
              <tr>
                <td width="25%">&nbsp;</td>
                  <logic:notEqual parameter="mode" value="check">
					<logic:equal parameter="action" value="supprimer">
 				 	
 				 	 <!-- Si on n'est pas superviseur des investissements et que la ligne est notifiée , on ne peut pas valider -->
                	  <% if (sousMenus.indexOf("ginv")< 0 && ligneInvestissementForm.getIsNotifiee()) {
	                  }
					  else {%>
						<td width="25%">
                  		  <div align="center"> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', this.form.mode.value, true);"/>
                  		  </div>
                		</td>
					  <% } %>
                	</logic:equal>
					<logic:notEqual parameter="action" value="supprimer">
					  <td width="25%">
                  		<div align="center"> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', this.form.mode.value, true);"/>
                  		</div>
                	  </td>
					</logic:notEqual>
				  </logic:notEqual>
                <td width="25%">
                  <div align="center">
                  	<logic:notEqual parameter="mode" value="check">
                  	  <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', null, false);"/>
                  	</logic:notEqual>
                  	<logic:equal parameter="mode" value="check">
                  	  <html:submit property="boutonAnnuler" value="Retour" styleClass="input" onclick="Verifier(this.form, 'annuler', 'check', false);"/>
                  	</logic:equal>
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
</body></html:html>
<!-- #EndTemplate -->
