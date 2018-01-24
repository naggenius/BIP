<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,java.util.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="actualiteForm" scope="request" class="com.socgen.bip.form.ActualiteForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fActuAd.jsp"/> 
<%
java.util.ArrayList list1 = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("ouiNonouibipbloque"); 
pageContext.setAttribute("choix_derniere_minute", list1);
java.util.ArrayList list2 = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("ouiNon"); 
pageContext.setAttribute("choix_valide", list2);
java.util.ArrayList list3 = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("ouiNon"); 
pageContext.setAttribute("choix_alerte_actu", list3);
java.util.Hashtable hMenus = com.socgen.bip.menu.BipMenuManager.getInstance().getListeMenus();
java.util.ArrayList list4 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("lien_profil_actu",actualiteForm.getHParams()); ; 
%>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<style>
.cacher{display:none;}
.afficher{display:block;}
</style>
<script language="JavaScript">
	var blnVerification = true;
	<%
		String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	%>
	var pageAide = "<%= sPageAide %>";
	function MenuSelection(form,valeur)
	{
	for (CptMenu=0;CptMenu < <%=hMenus.size()%>;CptMenu++){
		  
		  eval(form.profil[CptMenu].checked=+valeur);
		  }
	
	}	
	function MessageInitial()
	{
	   var Message="<bean:write filter="false"  name="actualiteForm"  property="msgErreur" />";
	   var Focus = "<bean:write name="actualiteForm"  property="focus" />";	   
   if (document.forms[0].msgErreur.value != "") {
      alert(document.forms[0].msgErreur.value);
   }
	   	   
	}
	function BipBloque()
	{
	   valeur = 'A';
	   
	   for(i=0;i<document.getElementsByName("derniere_minute").length;i++){	   		
	   		if(document.getElementsByName("derniere_minute")[i].checked){
	   			if(document.getElementsByName("derniere_minute")[i].value == 'P'){
	   				valeur = 'P';
	   			}
	   		}
	   }
	   
	   if(valeur == 'P') {
			document.getElementById("divMenuAssocié").className='cacher';
			document.getElementById("trAlerte").className='cacher';
	   }else{
	   		document.getElementById("divMenuAssocié").className='afficher';
			document.getElementById("trAlerte").className='afficher';
	   }
	}
	function Verifier(form, action, mode, flag)
	{
	   blnVerification = flag;
	   form.action.value = action;
	}
	function ValiderEcran(form)
	{ 
	
		sProfils="";
	  
		for (CptMenu=0;CptMenu < <%=hMenus.size()%>;CptMenu++){
		if (form.profil[CptMenu].checked) 
		sProfils = sProfils + form.profil[CptMenu].value+',';}
		form.string_menus.value = sProfils;	   
		
	   	if (blnVerification) {
	   		if (form.mode.value != 'insert') {
	   			if (form.code_actu && !ChampObligatoire(form.code_actu, "le code actualite")) return false;
	   		}
			if (form.titre && !ChampObligatoire(form.titre, "le titre")) return false;
			if (form.date_affiche && !ChampObligatoire(form.date_affiche, "la date affichee")) return false;
			if (form.date_debut && !ChampObligatoire(form.date_debut, "la date de début")) return false;
			if (form.date_fin && !ChampObligatoire(form.date_fin, "la date de fin")) return false;

			form.texte.value=form.liste_objet.value;
	 		chaine="";
	 		for (Cpt=0; Cpt < form.texte.value.length; Cpt++ ) {
				//if ((escape(form.texte.value.charAt(Cpt))!="%0D")&&(escape(form.texte.value.charAt(Cpt))!="%0A")){
					chaine = chaine+form.texte.value.charAt(Cpt);
				//}
			 }
			 if (chaine.length==0) {
				alert("Entrez l'objet de la ligne BIP");
				form.liste_objet.focus();
				return false;
			 }				
			 if (chaine.length>500) {
				alert("Objet trop long");
				form.liste_objet.focus();
				return false;
			 }
			 //if ((form.fichier.value!='' || form.nom_fichier.value!='')&& form.url.value!='')
			 //{
			 //	alert("Saisir soit le fichier, soit le lien.");
			//	form.url.focus();
			//	return false;
			 //}
			 
			if (form.mode.value == 'update') {
			 if (!confirm("Voulez-vous modifier cette actualite ?")) return false;
			}
		   if (form.mode.value == 'delete') {
			 if (!confirm("Voulez-vous supprimer cette actualite ?")) return false;
			}
	   }
	 
	   return true;
	}
function effaceFichier(form)
{
	form.nom_fichier.value='';
	document.getElementById("trNom_fichier").className='cacher';
	document.getElementById("trFichier").className='afficher';
	}
	
function showTr()
{
	if (document.forms[0].nom_fichier.value =='')
	{
		document.getElementById("trNom_fichier").className='cacher';
		document.getElementById("trFichier").className='afficher';
	}
	else
	{
		if (document.forms[0].action.value=='creer')
		{
			document.getElementById("trNom_fichier").className='cacher';
			document.getElementById("trFichier").className='afficher';}
	
		if (document.forms[0].action.value=='modifier'){
			document.getElementById("trNom_fichier").className='afficher';
			document.getElementById("trFichier").className='cacher';}
		
		if (document.forms[0].action.value=='supprimer'){
			document.getElementById("trNom_fichier").className='afficher';
			document.getElementById("trFichier").className='cacher';}
		}
}
</script>
<!-- #EndEditable --> 
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();showTr();BipBloque();">
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
           <bean:write name="actualiteForm" property="titrePage"/> une actualité <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/actualite"  enctype="multipart/form-data" onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>">
           <html:hidden property="titrePage"/>
		  <html:hidden property="action"/>
		  <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
		  <html:hidden property="code_actu"/>
		  <html:hidden property="string_menus"/>
		  <html:hidden  property="msgErreur"/>
		  

              <table cellspacing="2" cellpadding="2" class="tableBleu">
              		<tr><td colspan="4">&nbsp;</td></tr>
              		<tr> 
                  		<td class=lib ><b>Titre :</b></td>
                  		<td colspan="3"><logic:notEqual name="actualiteForm" parameter="action" value="supprimer">
                   		<html:text property="titre" styleClass="input" size="52" maxlength="50" onchange="return VerifierAlphanum(this);"/> 
                     </logic:notEqual>
                    <logic:equal name="actualiteForm" parameter="action" value="supprimer">
                    	<bean:write name="actualiteForm"  property="titre" />
                   </logic:equal>
						</td>
                	</tr>
					<tr> 
                  		<td class=lib ><b>Dernière minute :</b></td>
                    	<td colspan="3"><logic:notEqual name="actualiteForm" parameter="action" value="supprimer">
				 		 <logic:iterate id="element" name="choix_derniere_minute">
							<bean:define id="choix" name="element" property="cle"/>
							<html:radio property="derniere_minute" value="<%=choix.toString()%>" onClick="BipBloque()"/>
			 				<bean:write name="element" property="libelle"/>
						</logic:iterate> 
					</logic:notEqual>
                    <logic:equal name="actualiteForm" parameter="action" value="supprimer">
                    	<bean:write name="actualiteForm"  property="derniere_minute" />
                   </logic:equal>
						</td>
                	</tr>
                <tr id="trAlerte"> 
                  		<td class=lib ><b>Alerte :</b></td>
                    	<td colspan="3"><logic:notEqual name="actualiteForm" parameter="action" value="supprimer">
				 		 <logic:iterate id="element" name="choix_alerte_actu">
							<bean:define id="choix" name="element" property="cle"/>
							<html:radio property="alerte_actu" value="<%=choix.toString()%>"/>
			 				<bean:write name="element" property="libelle"/>
						</logic:iterate> 
					</logic:notEqual>
                    <logic:equal name="actualiteForm" parameter="action" value="supprimer">
                    	<bean:write name="actualiteForm"  property="alerte_actu" />
                   </logic:equal>
						</td>
                	</tr>	
                </table>
              <table border=0 cellspacing="2" cellpadding="2" class="tableBleu" width="500" >
					                <tr> 
                  <td width=111> 
                    <hr>
                  </td>
                  <td   width="250"> <b> 
                    <center>
                      Objet (Maximum 500 caract&egrave;res) 
                    </center>
                    </b></td> 
                  <td width=118> 
                    <hr>
                  </td>
                </tr>
                             <tr> 
                  <td colspan="4" align="center"> 
                    <logic:notEqual name="actualiteForm" parameter="action" value="supprimer">
                    <html:hidden property="texte"/> 
                    <script language="JavaScript">
var obj = document.forms[0].texte.value;
document.write("<textarea name=liste_objet class='input' rows=4 cols=63 wrap onchange='return VerifierAlphanum(this);'>" + obj +"</textarea>");
</script> </logic:notEqual>
                    <logic:equal name="actualiteForm" parameter="action" value="supprimer">
                    	<bean:write name="actualiteForm"  property="texte" />
                   </logic:equal>
             </td>
                </tr>
                </table>
              <table border=0 cellspacing="2" cellpadding="2" class="tableBleu" width="500" >
                <tr> 
                  		<td class=lib ><b>Date affichée :</b></td>
                  		<td ><logic:notEqual name="actualiteForm"  parameter="action" value="supprimer">
                   		<html:text property="date_affiche" styleClass="input" size="11" maxlength="10" onchange="return VerifierDate( this, 'jj/mm/aaaa');"/> 
                     </logic:notEqual>
                    <logic:equal name="actualiteForm" parameter="action" value="supprimer">
                    	<bean:write name="actualiteForm"  property="date_affiche" />
                   </logic:equal>
						</td>
					<td class=lib ><b>Valide :</b></td>
                    	<td><logic:notEqual name="actualiteForm"  parameter="action" value="supprimer"><logic:iterate id="element" name="choix_valide"><bean:define id="choix" name="element" property="cle"/><html:radio property="valide" value="<%=choix.toString()%>"/><bean:write name="element" property="libelle"/></logic:iterate></logic:notEqual><logic:equal name="actualiteForm"  parameter="action" value="supprimer"><bean:write name="actualiteForm"  property="valide" /></logic:equal>
						</td>
                	</tr>
                	 <tr> 
                  		<td class=lib ><b>Date de début d'affichage :</b></td>
                  		<td ><logic:notEqual name="actualiteForm" parameter="action" value="supprimer">
                   		<html:text property="date_debut" styleClass="input" size="11" maxlength="10" onchange="return VerifierDate( this, 'jj/mm/aaaa');"/> 
                     </logic:notEqual>
                    <logic:equal name="actualiteForm" parameter="action" value="supprimer">
                    	<bean:write name="actualiteForm"  property="date_debut" />
                   </logic:equal>
						</td>
					<td class=lib ><b>Date de fin d'affichage :</b></td>
                    	<td ><logic:notEqual name="actualiteForm" parameter="action" value="supprimer">
                   		<html:text property="date_fin" styleClass="input" size="11" maxlength="10" onchange="return VerifierDate( this, 'jj/mm/aaaa');"/> 
                     </logic:notEqual>
                    <logic:equal name="actualiteForm" parameter="action" value="supprimer">
                    	<bean:write name="actualiteForm"  property="date_fin" />
                   </logic:equal>
						</td>
                	</tr>
                	<tr><td width=111><hr></td>
                  <td   width="250"> <b><center>Liens</center></b></td>
                  <td width=130><hr></td></tr>
                	</table>
              <table border=0 cellspacing="2" cellpadding="2" class="tableBleu" width="500" ><tr> 
                  		<td class=lib ><b>Lien (saisi en dur) :</b></td>
                  		<td colspan="3"><logic:notEqual name="actualiteForm" parameter="action" value="supprimer">
                   		<html:text property="url" styleClass="input" size="52" maxlength="100" onchange="return VerifierAlphanum(this);"/> 
                     </logic:notEqual>
                    <logic:equal name="actualiteForm" parameter="action" value="supprimer">
                    	<bean:write name="actualiteForm"  property="url" />
                   </logic:equal></td>
                	</tr>
					<tr> 
                  <td  colspan="4"><b>ou </b></td> <html:hidden property="nom_fichier" name="actualiteForm"/> </tr>
                 <tr id="trNom_fichier"> 
                  <td class="lib" colspan="1"><b>Fichier téléchargé</b></td>
                  <td colspan="3">
                  	<a href="/downloadfile.do?action=modifier&mode=download&code_actu=<bean:write name="actualiteForm"  property="code_actu" />"
                      target="_blank">
				   <bean:write property="nom_fichier" name="actualiteForm"/>
					</a>&nbsp; <logic:notEqual name="actualiteForm" parameter="action" value="supprimer"><img id="imgNom_fichier" src="../images/b_corbeille.gif" onClick="effaceFichier(document.forms[0])"> </logic:notEqual>
                  </td>
                </tr>                   
                <tr id="trFichier"> 
                  <td class="lib" colspan="1"><b>Télécharger un fichier :</b></td>
                  <td colspan="3"><logic:notEqual name="actualiteForm" parameter="action" value="supprimer"><html:file property="fichier"  size="52"/> </logic:notEqual></td>
                </tr> 
                                            	
			<tr><td>&nbsp;</td></tr>
</table>
<div id="divMenuAssocié">
              <table border=0 cellspacing="2" cellpadding="2" class="tableBleu" width="500" >
                <tr> 
                  <td width=111> 
                    <hr>
                  </td>
                  <td   width="250"><b> 
                    <center>
                      Menus associés 
                    </center>
                    </b></td>
                  <td width=118> 
                    <hr>
                  </td>
                </tr>
              </table>
             <table border=0 cellspacing=2  cellpadding=2  class="tableBleu" width=500>
                <logic:notEqual name="actualiteForm" parameter="action" value="supprimer"><tr><td align="center" colspan="4"><input type="button" name="boutonTous" value="Tous" onclick="return MenuSelection(this.form,true);" class="input"> <input type="button" name="boutonAucun" value="Aucun" onclick="return MenuSelection(this.form,false);" class="input"></td></tr>
                </logic:notEqual>
                <%

                //ArrayList list4 = null;
		String sIdM; //id du menu courant
		String sLibM;	//lib du menu courant
		String sChecked = "";//menu courant checked ?
		
		java.util.Enumeration enumMenus = hMenus.keys();
		
		int k=0;
		while (enumMenus.hasMoreElements())
		{
				//	com.socgen.bip.commun.BipConstantes.logService.debug(".");
			sChecked = "";
			
			sIdM = (String)enumMenus.nextElement();
			com.socgen.bip.menu.item.BipItemMenu mItem = (com.socgen.bip.menu.item.BipItemMenu)hMenus.get(sIdM);
			sLibM = mItem.getLibelle();
			for (int i=0; i< list4.size(); i++)
			{
				String sCle = ((com.socgen.bip.commun.liste.ListeOption)(list4.get(i)) ).getCle();
				if (sIdM.compareToIgnoreCase(sCle) == 0)
				{
					sChecked = "checked";
				}
			}
			if (k == 0)
			{ %>
			<tr>
			<%	} %>
			<td class=lib colspan="1"> <b><%=sLibM %> :</b> </td>
			<td colspan="1" >
				<input type="checkbox" name="profil" class="input"  value="<%=sIdM %>" <%= sChecked %> />
			</td>
			<%
			if (k == 0)
				k++;
			else {
				k=0; %>
				</tr>  <%
			}
		}
                %>
                	
                                       
              </table>
          </div>
          </div>
          </td>
        </tr>
        <tr> 
          <td align="center"> 
            <table width="100%" border="0">
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
</body>
<% 
Integer id_webo_page = new Integer("1067"); 
com.socgen.bip.commun.form.AutomateForm formWebo = actualiteForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
