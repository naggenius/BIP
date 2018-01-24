<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="ligneRealisationForm" scope="request" class="com.socgen.bip.form.LigneRealisationForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/bLigneReaLb.jsp"/> 
<%
  java.util.ArrayList list1 = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("typeInvestissements"); 
  pageContext.setAttribute("choixTypeCommande", list1);  
  
  //out.println("arrayliste: " + list1);  
 
  java.text.NumberFormat numberFormat = java.text.NumberFormat.getInstance();
  numberFormat.setMinimumIntegerDigits(3);
  String newCodinv = numberFormat.format(Integer.parseInt(ligneRealisationForm.getCodinv()));
  pageContext.setAttribute("newCodinv", newCodinv);  
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
	
	function MessageInitial()
	{
	   var Message="<bean:write filter="false"  name="ligneRealisationForm"  property="msgErreur" />";
   	   var Focus = "<bean:write name="ligneRealisationForm"  property="focus" />";
	   if (Message != "") {
	      alert(Message);
	   }
	   
	   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();	   
	          
	   if (document.forms[0].mode.value=="insert"){       	
	   	document.forms[0].engage.value="0,0";
	   	document.forms[0].date_saisie.value='<bip:value champ="concat ('01/' , to_char(add_months(cmensuelle, -1),'MM/YYYY'))" table="datdebex" clause1="1" clause2="1" />';
	   	}   
	}
	
	function Verifier(form, action, mode, flag)
	{
	   blnVerification = flag;
	   form.mode.value = mode;
	   form.action.value = action;   
	}
	
	function ValiderEcran(form)
	{
	   if (blnVerification) {
		if (form.num_cmd && !ChampObligatoire(form.num_cmd, "le numéro de commande")) return false;
		if (form.type_eng && !ChampObligatoire(form.type_eng, "le type d'engagement")) return false;
		if (form.marque && !ChampObligatoire(form.marque, "la marque")) return false;
		if (form.modele && !ChampObligatoire(form.modele, "le modele")) return false;
		if (form.date_saisie && !ChampObligatoire(form.date_saisie, "la date de saisie")) return false;
		if (form.engage && !ChampObligatoire(form.engage, "le montant engagé")) return false;
		
		if(form.engage.value == "0,0"){
			alert("le champ montant " + document.forms[0].engage.name + " doit être non nul.");
			document.forms[0].engage.focus();
			return false;
		}
				//test commentaire alphanumérique. Ne pas effacer le texte.
		form.comrea.value=form.liste_objet.value;
	 	var restrict = '$";';
   		var Caractere;

   		for (Cpt=0; Cpt < form.comrea.value.length; Cpt++ ) {
			Caractere = form.comrea.value.charAt(Cpt);
			if (restrict.indexOf(Caractere) != -1) {
	   			alert( "Saisie invalide");
	   			form.liste_objet.focus();
	   			return false;
			}
  		}
   		return compteCar(document.forms[0].liste_objet);
		
	      if (form.mode.value == 'update') {
	         if (!confirm("Voulez-vous modifier la ligne de réalisation ?")) return false;
	      }
	      if (form.mode.value == 'delete') {
	         if (!confirm("Voulez-vous supprimer la ligne de réalisation?")) return false;
	      }
	   }
	   
	   return true;
	}
	function compteCar(elem)
	{nbCar = elem.value.length;

	if (nbCar >200) {
		alert("Le commentaire ne doit pas dépasser 200 caractères.");elem.value=document.forms[0].comrea.value;elem.focus;return false;}
	else
		document.forms[0].comrea.value= elem.value;

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
          	<bean:write name="ligneRealisationForm" property="titrePage"/> une ligne de réalisation<!-- #EndEditable -->
          </td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/lignerea"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            
                
                
                       
            <div align="center"><!-- #BeginEditable "contenu" -->
		<input type="hidden" name="pageAide" value="<%= sPageAide %>">
		<input type="hidden" name="menuId" value="<%= menuId %>">
		<html:hidden property="titrePage"/>
		<html:hidden property="action"/>
		<html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
		<html:hidden property="flaglock"/>
		<html:hidden property="keyList0"/>		
		    
              <table widht="100%" cellspacing="2" cellpadding="2" class="tableBleu">
              <tr> 
                  <td >&nbsp;</td>
              </tr>
              <tr>
              	<td align="center" colspan="4">
              		<b>Ligne Budg&eacute;taire :</b>
              	</td>
              </tr>
                <tr> 
                  <td>&nbsp;</td>
                </tr>
                <!-- LIGNE INV/REALISATION -->
                <tr> 
                  <td class="lib"><b>Ligne num&eacute;ro :</b></td>
                  <td><b><bean:write name="newCodinv"/> - <bean:write name="ligneRealisationForm" property="codrea"/></b>
                    	<html:hidden property="codinv"/>
                    	<html:hidden property="codrea"/>
                  </td>                   
                </tr>  
                 <!-- ANNEE EXERCICE + CA-->
                <tr>                                       
                  <td class="lib"><b>Exercice :</b></td>
                  <td colspan="2">
                        <bean:write name="ligneRealisationForm"  property="annee" />
			<b> &nbsp;&nbsp;CA&nbsp;&nbsp; </b>
			<bean:write name="ligneRealisationForm"  property="codcamo" />
			&nbsp;-&nbsp;
			<bean:write name="ligneRealisationForm"  property="libCa" />
                    	<html:hidden property="annee"/>
                    	<html:hidden property="codcamo"/>
                   </td>
                </tr>
                <!-- Type-->
                <tr>                                       
                  <td class="lib"><b>Type :</b></td>
                  <td colspan="4">
                        <bean:write name="ligneRealisationForm"  property="type_ligne" />
                   </td>
                </tr>
                <tr>                                       
                  <td class="lib"><b>Projet :</b></td>
                  <td colspan="4">
                        <bean:write name="ligneRealisationForm"  property="projet" />
                   </td>
                </tr>
                <tr>                                       
                  <td class="lib"><b>Dossier Projet :</b></td>
                  <td>
                        <bean:write name="ligneRealisationForm"  property="dossier_projet" />
                   </td>
                   
                   <td class="lib"><b>Disponible :</b></td>
                  <td>
                        <bean:write name="ligneRealisationForm"  property="disponible" /> K&euro; HT ( <bean:write name="ligneRealisationForm"  property="disponible_htr"/> K&euro; HTR) 
                   </td>
                </tr>
                <tr> 
                  <td >&nbsp;</td>
                </tr>      
                <tr>
              	<td align="center" colspan="4">
              		<b>Ligne de r&eacute;alisation :</b>
              	</td>
              </tr>
              <tr> 
                  <td >&nbsp;</td>
                </tr>
                <!-- Type et Numero de Commande -->	
               <tr> 
                  <td class="lib"><b>Type de commande :</b></td>                             
                  <td >
                  	<logic:notEqual parameter="action" value="supprimer">
	                  	<html:select property="type_cmd" styleClass="input"> 
	                          <html:options collection="choixTypeCommande" property="cle" labelProperty="libelle" /> 			
				 		</html:select>
			 		</logic:notEqual>
			 		<logic:equal parameter="action" value="supprimer">
                   		<bean:write name="ligneRealisationForm"  property="type_cmd" />
                   	</logic:equal>
		  			</td> 		           
					<td class="lib">
						<b>Num&eacute;ro :</b></td>
		  			<td>
		  			<logic:notEqual parameter="action" value="supprimer">
                   		<html:text property="num_cmd" styleClass="input" size="20" maxlength="15" onchange="return VerifierAlphanum(this);"/>                  
                   	</logic:notEqual>
			 		<logic:equal parameter="action" value="supprimer">
			 			<bean:write name="ligneRealisationForm"  property="num_cmd" />
			 		</logic:equal>
                  	</td>                  
                </tr>
                			
		<!-- Type d'engagement -->
                <tr> 
                  <td class="lib"><b>Type du produit :</b></td>
                  <td >
                  	<logic:notEqual parameter="action" value="supprimer">
                  		<html:text property="type_eng" styleClass="input" size="15" maxlength="15" onchange="return VerifierAlphanum(this);"/>
                  	</logic:notEqual>
			 		<logic:equal parameter="action" value="supprimer">
			 			<bean:write name="ligneRealisationForm"  property="type_eng" />
			 		</logic:equal>
                  </td>                  
                </tr>
                <!-- Marque -->
                <tr> 
                  <td class=lib><b>Marque :</b></td>
                  <td>
                  	<logic:notEqual parameter="action" value="supprimer">
                    	<html:text property="marque" styleClass="input" size="15" maxlength="15" onchange="return VerifierAlphanum(this);"/>                   
                    </logic:notEqual>
			 		<logic:equal parameter="action" value="supprimer">
			 			<bean:write name="ligneRealisationForm"  property="marque" />
			 		</logic:equal>
                  </td>                  
                </tr>
                <!-- Modele -->
                <tr> 
                  <td class="lib"><b>Mod&egrave;le :</b></td>
                  <td>  
                  	<logic:notEqual parameter="action" value="supprimer">
						<html:text property="modele" styleClass="input" size="15" maxlength="15" onchange="return VerifierAlphanum(this);"/>                             
					</logic:notEqual>
			 		<logic:equal parameter="action" value="supprimer">
			 			<bean:write name="ligneRealisationForm"  property="modele" />
			 		</logic:equal>
                  </td>                                  
                </tr>
                <!-- Commentaire, Date de saisie -->                
                <tr>
                  <td class=lib><b>Commentaire :</b></td>
                  <td colspan="3">
			<logic:notEqual parameter="action" value="supprimer">
                     
                      <html:hidden property="comrea"/> 
                    <script language="JavaScript">
			var obj = document.forms[0].comrea.value;
			document.write("<textarea name=liste_objet class='input' onkeyUp='return compteCar(this)' rows=3 cols=66 wrap>" + obj +"</textarea>");
			</script>
			          </logic:notEqual>
                   <logic:equal parameter="action" value="supprimer">
                   	 <bean:write name="ligneRealisationForm"  property="comrea" />
                   </logic:equal>
                  </td>  
                                 </tr>
                <!-- Montant engagé -->
                <tr>                   	
                  <td class=lib><b>Montant engag&eacute; :</b></td>
                  <td>                    
                  	<logic:notEqual parameter="action" value="supprimer">
                  		<html:text property="engage" styleClass="input" size="9" maxlength="9" onchange="return VerifierNum(this,8,2);"/> (K&euro; HT)                              
                  	</logic:notEqual>
			 		<logic:equal parameter="action" value="supprimer">
			 			<bean:write name="ligneRealisationForm"  property="engage" /> K&euro; HT
			 		</logic:equal>
                  </td>  
                  <td class="lib"><b>Date de saisie :</b></td>
                  <td>
                  	<logic:notEqual parameter="action" value="supprimer">
    				  <!-- Si on est superviseur des investissements on peut modifier la date -->
					<% if ( sousMenus.indexOf("ginv") >= 0 ) { %>                  		
          			<html:text property="date_saisie" styleClass="input" size="10" maxlength="10" onchange="return VerifierDate(this, 'jj/mm/aaaa');"/>
          			<% }
                    else { 
                    	%>
                 <logic:equal parameter="action" value="creer">
                 <bip:value champ="concat ('01/' , to_char(add_months(cmensuelle, -1),'MM/YYYY'))" table="datdebex" clause1="1" clause2="1" /></logic:equal>
                 <logic:equal parameter="action" value="modifier">
                 <bean:write name="ligneRealisationForm"  property="date_saisie" />
                 </logic:equal>
            	<html:hidden property="date_saisie" />
            <% } %>
                    </logic:notEqual>
			 		<logic:equal parameter="action" value="supprimer">
			 			<bean:write name="ligneRealisationForm"  property="date_saisie" />
			 		</logic:equal>
                  </td>                                
                </tr>                
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
                <td width="25%">                
                  <div align="center"> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', this.form.mode.value,true);"/> 
                  </div>
                </td>                
                <td width="25%">                
                  <div align="center">                  	
                  	<html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', 'suite', false);"/> 
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
