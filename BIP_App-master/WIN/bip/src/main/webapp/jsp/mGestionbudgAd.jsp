<!DOCTYPE html>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="gestBudgForm" scope="request" class="com.socgen.bip.form.GestBudgForm" />
	
<%@page import="com.socgen.bip.form.GestBudgForm"%>
<html:html locale="true"> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<title>Page BIP</title>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<bip:VerifUser page="jsp/bGestionbudgAd.jsp"/> 
<script language="JavaScript" src="../js/function.cjs"></script>
<!-- <link rel="stylesheet" href="../css/base_style.css" type="text/css"> -->
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	com.socgen.bip.user.UserBip user = (com.socgen.bip.user.UserBip)session.getAttribute("UserBip") ;
	com.socgen.bip.menu.item.BipItemMenu menu = user.getCurrentMenu();
	String menuId = menu.getId();
	String perimo = gestBudgForm.getPerimo();
	String perime = gestBudgForm.getPerime();

	// FAD PPM 63828 : Récupération du sous-menu courant
	String sousMenus = ((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getSousMenus().toLowerCase();
	Boolean disableC = false;
	String disableC2 = "";
	if (menuId.equals("ME"))
	{
		if (sousMenus.indexOf("ges") != -1)
		{
			disableC = false;
			disableC2 = "";
		}
		else
		{
			if ((sousMenus.indexOf("bud") != -1) || (sousMenus.indexOf("bubase") != -1) || (sousMenus.indexOf("pcm") != -1))
			{
				disableC = true;
				disableC2 = "disabled";
			}
		}
	}
	// FAD PPM 63828 : Fin
%>
var pageAide = "<%= sPageAide %>";


function MessageInitial()
{
	
   var Message="<bean:write filter="false"  name="gestBudgForm"  property="msgErreur" />";
   var Focus = "<bean:write name="gestBudgForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
    else {
	   document.forms[0].bud_prop.focus();
    }
}

  
function Verifier(form, action,mode, flag)
{
   blnVerification = flag;
   form.action.value = action;
   form.mode.value = mode;
 }


function ValiderEcran(form) {
  if (form.action.value == 'annuler' ) {
      if (!confirm("Voulez-vous annuler cette saisie ?")) return false;
  }
  else   {

	  if (blnVerification == true) {
		 if (form.mode.value == 'update') {
		 	if (VerifierChampsComm()) {
				if (!confirm("Voulez-vous modifier le budget de l'année " +form.annee.value+ " pour la ligne BIP " +form.pid.value+ "?")) return false;
			}
			else {
				return false;
			}
		 }
	  }
 }  
 return true;
}

/**
	Vérification de la validité des champs commentaire arbcom et reescom saisis (présence ou non de caractères spéciaux)
*/
function VerifierChampsComm() {
	var elementErrone;
	if (document.getElementById("arbcomm") && ContientCarSpec(document.getElementById("arbcomm"))) {
		elementErrone = document.getElementById("arbcomm"); 
	}
	else if (document.getElementById("reescomm") && ContientCarSpec(document.getElementById("reescomm"))) {
		elementErrone = document.getElementById("reescomm"); 
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
	if (elementTextarea) {
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
	if (parseInt(elementTextarea.value.length) > parseInt(<%= GestBudgForm.longueurMaxCommentaire %>)) {
		// Tronquer
		elementTextarea.value=elementTextarea.value.substring(0, parseInt(<%= GestBudgForm.longueurMaxCommentaire %>));
	}
}

/**
	MAJ du compteur de nombre de caractères restants
*/
function AlimenterCompteurNbCarRestants(elementTextarea, divCompteurNbCarRestants) {
	var compteur = 0;

	if (parseInt(elementTextarea.value.length) < parseInt(<%= GestBudgForm.longueurMaxCommentaire %>)) {
		compteur =  parseInt(<%= GestBudgForm.longueurMaxCommentaire %>) - parseInt(elementTextarea.value.length);
	}
	
	divCompteurNbCarRestants.innerHTML = compteur;
}
</script>

</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
<div id="mainContainer">
<div id="topContainer" >
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
          <td height="20" class="TitrePage">Modifier&nbsp;le budget d'une ann&eacute;e pour une ligne BIP</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <html:form action="/gestBudg"  onsubmit="return ValiderEcran(this);">
            <div align="center">
			 <input type="hidden" name="pageAide" value="<%= sPageAide %>">
			 <input type="hidden" name="menu" value="<%= menuId %>">
			 <html:hidden property="action"/>
	         <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
			 <html:hidden property="flaglock"/>
			 <html:hidden property="perime"/>
			 <html:hidden property="perimo"/>
		
			<table cellspacing="2" cellpadding="2" border="0" class="tableBleu"  >
                <tr> 
                  <td height="20" colspan=4>&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan=4>&nbsp;</td>
                </tr>
                <tr align="left"> 
                  <td class="texte">Ligne BIP :</td>
                  <td class="texte"><b><bean:write name="gestBudgForm"  property="pid" /><html:hidden property="pid"/></b></td>
                  <td class="texte" colspan=2><bean:write name="gestBudgForm"  property="pnom" /><html:hidden property="pnom"/></td>
                </tr>
                  <tr align="left"> 
                  <td class="texte">DPG :</td>
                  <td class="texte"><bean:write name="gestBudgForm"  property="codsg" /><html:hidden property="codsg"/></td>
                  <td class="texte" colspan=2><bean:write name="gestBudgForm"  property="libdsg" /><html:hidden property="libdsg"/></td>
                </tr>
                <tr align="left"> 
                  <td class="texte">Année :</td>
                  <td class="texte"><b> <bean:write name="gestBudgForm"  property="annee" /><html:hidden property="annee"/></b></td>
                  <td class=texte align=right>Statut :</td>
                  <td class="texte"><bean:write name="gestBudgForm"  property="astatut" />
                    	<html:hidden property="astatut"/></td>
                </tr>
                <tr> 
                	<td colspan=4 height="10px"></td>
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
                  <td class="texte">Proposé Fournisseur :</td>
                  <td class="texte" align="right">
                <% if (menuId.equals("ME") && !(perime.equals("1"))) {%>                                            
	                <bean:write name="gestBudgForm"  property="bud_prop" />
                    <html:hidden property="bud_prop"/>
                  <%} else { %>
				    <html:text 
				    	property="bud_prop" 
				    	styleClass="input" 
				    	size="15" 
				    	maxlength="15" 
				    	onchange="return VerifierNumNegatif(this,12,2);"/> 
                  <%} %>  	
				  </td>
				  <td class="texte" align="right" <% if (gestBudgForm.getBpdate() == null) {%>width='60px'<%}%>>
				  	<bean:write name="gestBudgForm"  property="bpdate" />
                    <html:hidden property="bpdate"/>
				  </td>
                  <td class="texte" align="right">
				    <bean:write name="gestBudgForm"  property="ubpmontme" />
                    <html:hidden property="ubpmontme"/>
				  </td>
                </tr>
                
                   <% if (menuId.equals("DIR")) {%>
	                  <tr align="left"> 
		                  <td class="texte">Proposé Client :</td>
		                  <td class="texte" align="right">
						    <html:text 
						    	property="bud_propmo" 
						    	styleClass="input" 
						    	size="15" 
						    	maxlength="15" 
						    	onchange="return VerifierNumNegatif(this,12,2);"/> 
						  </td>
						  <td class="texte" align="right">
						 	<bean:write name="gestBudgForm"  property="bpmedate" />
		                    <html:hidden property="bpmedate"/>
						  </td>
		                  <td class="texte" align="right">
						    <bean:write name="gestBudgForm"  property="ubpmontmo" />
		                    <html:hidden property="ubpmontmo"/>
						  </td>
                	  </tr>
				  <%} else if(menuId.equals("ME")){ %>
				  	  <tr align="left"> 
		                  <td class="texte">Proposé Client :</td>
<!-- 		                  <td class="Right"> -->
						   <% if ( perimo.equals("2") && perime.equals("1") ) {
							 
							   %>
						   <% // N'ouvrir le champ Proposé client en màj QUE SI le DPG de la ligne fait partie du Perim_ME ET le code client principal de la ligne fait partie du Perim_MO %>
						    <td class="Right">
						    <html:text 
						    	property="bud_propmo" 
						    	styleClass="input" 
						    	size="15" 
						    	maxlength="15" 
						    	onchange="return VerifierNumNegatif(this,12,2);"/> 
						    	</td>
						  <%} else {
							  
							  
							  %>
<!-- 							  PPM 63250 -->
							<td class="texte" align="center">
							   
	                		<bean:write name="gestBudgForm"  property="bud_propmo" />
                    		<html:hidden property="bud_propmo"/>
                    		</td>
                  		  <%} %>  
<!-- 						  </td> -->
						  <td class="texte" align="right">
						 	<bean:write name="gestBudgForm"  property="bpmedate" />
		                    <html:hidden property="bpmedate"/>
						  </td>
		                  <td class="texte" align="right">
						    <bean:write name="gestBudgForm"  property="ubpmontmo" />
		                    <html:hidden property="ubpmontmo"/>
						  </td>
                	  </tr>				  
                  <%} else {
                	  
                	  %>	              
                    <html:hidden property="bud_propmo"/> 
                  <%} %>

                  <tr align="left"> 
                  <td class="texte">Notifié :</td>
                  <td class="texte" align="right">
                  <% if ((menuId.equals("ME"))) {%>
				<bean:write name="gestBudgForm"  property="bud_not" />
				<html:hidden property="bud_not"/> 
			  <%} else { %>
			  		<html:text 
			  			property="bud_not" 
			  			styleClass="input" 
			  			size="15" 
			  			maxlength="15" 
			  			onchange="return VerifierNumNegatif(this,12,2);"/> 
			  <%} %>
			  </td>
			  <td class="texte" align="right">
			    	<bean:write name="gestBudgForm"  property="bndate" />
	                <html:hidden property="bndate"/>
			  </td>
			  <td class="texte" align="right">
			  		<bean:write name="gestBudgForm"  property="ubnmont" />
	                <html:hidden property="ubnmont"/>
			  </td>
		       </tr>
		       
		       <tr align="left"> 
                  <td class="texte">Arbitré :</td>
                  <td class="texte" align="right">
                  <% if ( (menuId.equals("ME")) ) {
                		// FAD PPM 63828 : Test sur la variable disableC
						if (!disableC)
                  		{
							if( !(perimo.equals("2")) ){
%>
								<bean:write name="gestBudgForm"  property="bud_arb" />
								<html:hidden property="bud_arb"/>
							<% }; %>
							<% if( (perimo.equals("2")) && (perime.equals("1")) ) {
%>
								<html:text
								property="bud_arb" 
				    			styleClass="input" 
				    			size="15" 
				    			maxlength="15" 
				    			onchange="return VerifierNumNegatif(this,12,2);"/> 
                    		<% }; %>
                    
                  		<%}
						// FAD PPM 63828 : désactivation du champs
						else
						{
							%>
							<bean:write name="gestBudgForm"  property="bud_arb" />
							<html:hidden property="bud_arb"/>
							<%
						}
                    } else { %> 
				    <html:text 
				    	property="bud_arb" 
				    	styleClass="input" 
				    	size="15" 
				    	maxlength="15" 
				    	onchange="return VerifierNumNegatif(this,12,2);"/> 
                  <%} %>	 
				  </td>
				  <td class="texte" align="right">
				  	<bean:write name="gestBudgForm"  property="bnadate" />
                    <html:hidden property="bnadate"/>
				  </td>
				  <td class="texte" align="right">
				    <bean:write name="gestBudgForm"  property="uanmont" />
                    <html:hidden property="uanmont"/>
				  </td>
                </tr>
                <tr> 
                  <td class="texte" colspan=4 style="padding-bottom:0px;" align="left">
				    <textarea id="arbcomm" name="arbcomm" rows="3" cols="53" <%= disableC2 %>
				    maxlength="<%= GestBudgForm.longueurMaxCommentaire %>" 
				    onkeyup="TraiterComm(this, document.getElementById('compteurNbCarRestantsArbcomm'))"><bean:write name="gestBudgForm" property="arbcomm"/></textarea>
				  </td>
                </tr>
                <tr> 
                  <td colspan=2></td>
                  <td class="texte" style="padding-top:0px;padding-bottom:0px;vertical-align:top;height:1px">
				  	<div id="compteurNbCarRestantsArbcomm">
				  		<bean:write name="gestBudgForm" property="obtenirNbCarRestantsArbcomm"/>
				  	</div>
				  </td>
				  <td></td>
                </tr>
                <tr> 
                	<td colspan=4 height="10px"></td>
                </tr>
                
                <!-- tr> 
                  <td class="lib">Réestimé :</td>
                  <td>
				    <%//if ((gestBudgForm.getBud_rees()).equals("OUI")) {%>
				     <html:text 
				     	property="bud_rst" 
				     	styleClass="input" 
				     	size="15" 
				     	maxlength="15" 
				     	onchange="return VerifierNumNegatif(this,12,2);"/> 
				     <%//}%>
				  </td>
				  <td align=center>
				    <bean:write name="gestBudgForm"  property="redate" />
                    <html:hidden property="redate"/>
				  </td>
				  <td align=center>
				  	<bean:write name="gestBudgForm"  property="ureestime" />
                    <html:hidden property="ureestime"/>
				  </td>
                </tr-->
                
                <tr align="left"> 
                  <td class="texte">Réestimé :</td>
                  <td class="texte" align="right">
				    <%if ((gestBudgForm.getBud_rees()).equals("OUI")) {%>
				    <% if ((menuId.equals("ME")) && !(perime.equals("1"))) {%>
				    <bean:write name="gestBudgForm"  property="bud_rst" />
	                <html:hidden property="bud_rst"/>
				     <%} else { %>			     	
				     <html:text 
				     	property="bud_rst" 
				     	styleClass="input" 
				     	size="15" 
				     	maxlength="15" 
				     	onchange="return VerifierNumNegatif(this,12,2);"/> 
				     <%} %>  	 
				     <%} else { %>
	                	<bean:write name="gestBudgForm"  property="bud_rst" />
                    	<html:hidden property="bud_rst"/>
                  	<%} %>  	
				  </td>
				  <td class="texte" align="right">
				    <bean:write name="gestBudgForm"  property="redate" />
                    <html:hidden property="redate"/>
				  </td>
				  <td class="texte" align="right">
				  	<bean:write name="gestBudgForm"  property="ureestime" />
                    <html:hidden property="ureestime"/>
				  </td>
                </tr>
                <%if ((gestBudgForm.getBud_rees()).equals("OUI")
                		&& (!menuId.equals("ME") || perime.equals("1"))) {%>
                <tr> 
                  <td class="texte" colspan=4 style="padding-bottom:0px;" align="left">
				    <textarea id="reescomm" name="reescomm" rows="3" cols="53" 
				    maxlength="<%= GestBudgForm.longueurMaxCommentaire %>" 
				    onkeyup="TraiterComm(this, document.getElementById('compteurNbCarRestantsReescomm'))"><bean:write name="gestBudgForm" property="reescomm" /></textarea>
				  </td>
                </tr>
                 <tr> 
                  <td colspan=2></td>
                  <td class="texte" style="padding-top:0px;padding-bottom:0px;vertical-align:top;height:1px">
				  	<div id="compteurNbCarRestantsReescomm">
				  		<bean:write name="gestBudgForm" property="nbCarRestantsReescomm"/>
				  	</div>
				  </td>
				  <td></td>
                </tr>
                <tr> 
                	<td colspan=4 height="10px"></td>
                </tr>
                <%} %>
                
                
                <!-- YNI FDT 892 -->
                <% if (menuId.equals("DIR")) {%>
                <tr align="left">
                  <td class="texte" colspan=1>R&eacute;serve :</b></td>
                  <td class="texte" align="right">
					<html:text property="reserve" styleClass="input" size="15" maxlength="15" onchange="return VerifierNumNegatif(this,12,2);"/>	
				  </td>
				   <td class="texte" align="right">
				    <bean:write name="gestBudgForm"  property="bresdate" />
                    <html:hidden property="bresdate"/>
				  </td>
				  <td class="texte" align="right">
				  	<bean:write name="gestBudgForm"  property="ureserve" />
                    <html:hidden property="ureserve"/>
				  </td> 
				</tr>
				<%} %>
                <!-- Fin YNI FDT 892 -->
                
                </table> 
                <table cellspacing="2" cellpadding="2" class="tableBleu" border="0" >
				<tr>
                <td colspan=4>&nbsp;</td>
				  </tr>
              </table>
              
			  </div>
          </td>
        </tr>
        <tr> 
          <td align="center"> 
            <table width="100%" border="0">
            
              <tr><td height="20"></td></tr>
              <tr> 
                <td width="25%">&nbsp;</td>
                <td width="25%"> 
                  <div align="center"> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', this.form.mode.value,true);"/> 
                  </div>
                </td>
                <td width="25%"> 
                  <div align="center"> <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler',this.form.mode.value, true);"/> 
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
Integer id_webo_page = new Integer("1052"); 
com.socgen.bip.commun.form.AutomateForm formWebo = gestBudgForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
