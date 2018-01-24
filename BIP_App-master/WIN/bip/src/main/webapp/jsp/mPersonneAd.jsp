<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,java.lang.*,java.util.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,org.apache.struts.taglib.html.SelectTag,com.socgen.bip.commun.liste.ListeOption,com.socgen.bip.commun.Tools"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="personneForm" scope="request" class="com.socgen.bip.form.PersonneForm" />
<jsp:useBean id="listeDynamique" scope="request" class="com.socgen.bip.commun.liste.ListeDynamique" />
<%@page import="org.owasp.esapi.ESAPI,com.socgen.bip.form.PersonneForm"%>
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/bPersonneAd.jsp"/> 
<%
  java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("immeuble",personneForm.getHParams()); 
  //java.util.ArrayList list2 = com.socgen.bip.commun.liste.ListeGlobale.getListeGlobale("filiale");
  //pageContext.setAttribute("choixFiliale", list2);
  pageContext.setAttribute("choixImm", list1);
  
  Hashtable hKeyList= new Hashtable();
  hKeyList.put("userid", ""+((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
  hKeyList.put("rtype", ""+personneForm.getRtype());
  hKeyList.put("code_domaine", ""+personneForm.getCode_domaine());
  
  
 try {		
	    ArrayList listeDomaine = listeDynamique.getListeDynamique("domainetype", hKeyList);
	    pageContext.setAttribute("choixDomaine", listeDomaine);	
	}   
  	catch (Exception e) {
	    pageContext.setAttribute("choixDomaine", new ArrayList());
  	}
  
  	try {		
	    ArrayList listePrestation = listeDynamique.getListeDynamique("prestation", hKeyList);
	    pageContext.setAttribute("choixPrestation", listePrestation);
	}   
	catch (Exception e) {
		    pageContext.setAttribute("choixPrestation", new ArrayList());
	}
	
  
 %>
<script language="JavaScript" src="../js/function.cjs"></script>
<script language="JavaScript" src="../js/jquery.js"></script>
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">
	$(document).ready(function() {
		$( "input[type=text]" ).focus(function() {
			$(this).css('border-color','#EFD242');
		});
	
		$( "input[type=text]" ).blur(function() {
			$(this).css('border-color','');
		});
	
	});

	var blnVerification = true;
	<%
		String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
		String Rtype = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("rtype")));
		String confirm = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("confirm")));
		String homonyme = personneForm.getHomonyme();
		//YNI
		String verification="init";
		if(confirm !=null)
		{	
			verification = confirm;
		}
		String adminType = ((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getCurrentMenu().getLibelle(); 
		boolean statut = false;
		if(adminType.equals("Administration")){
			statut = false;
		}else{
			statut = true;
		}
		//fin YNI
		String sRtype="";
		
		if(Rtype.equals("A"))
		   sRtype = " un agent SG ";
		else if(Rtype.equals("P"))
		   sRtype = " une prestation ";   
	%>
	var pageAide = "<%= sPageAide %>";
	
	//YNI
	var adminType = "<%= adminType %>";
	var verification = "<%= verification %>";
	var statut = "<%= statut %>";
	var homonyme = "<%= homonyme %>";	
	//fin YNI
	
	var socode = "<bean:write name="personneForm"  property="soccode" />";
	
	var socode_sg = "SG..";
	
	var rtype= "<%= Rtype %>";
	   
	var coutObligatoire = (socode !== socode_sg);	   
	var rafraichiEnCours = false;
	
	function MessageInitial()
	{

	   var Message="<bean:write filter="false"  name="personneForm"  property="msgErreur" />";
	   var Focus = "<bean:write name="personneForm"  property="focus" />";
	   var verification = document.forms[0].confirm.value;
		   if (Message != "") {
		   
	   			if(verification == "oui"){
		   			if(confirm(Message)){
		   					document.forms[0].confirm.value="non";
				  			document.forms[0].submit();
			  		 }
			  	
	   			}else{
	   				alert(Message);
	   			}
		   		
		   }
		   else if (document.forms[0].mode.value=="insert"){
		   		
				document.forms[0].dispo.value="5,0";			
				if ( document.forms[0].rtel.value == "" ) {
					document.forms[0].rtel.value="0";
				}
				
				if(true == eval(coutObligatoire)){
					document.forms[0].cout.value=",00";
				}
		
		   } else if ( document.forms[0].mode.value=="enrichie" ) {
		  			document.forms[0].dispo.value="5,0";			
										
					if(true == eval(coutObligatoire)){
						document.forms[0].cout.value=",00";
					} 
		   }
		
	     if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
  			 else if (document.forms[0].mode.value=="insert"){
	 		 document.forms[0].codsg.focus();
	 		 }
	 		 else
	 		  document.forms[0].rnom.focus();	 		  		  
	      
	}

	function CtrlSociete(){
		var form = document.forms[0];
		
		if ( rtype == 'P' && form.soccode.value.toUpperCase() == 'SG..') {
			alert('La société doit être différent de SG.. pour une prestation');
			form.soccode.value = '';
			return false;
		}
		return true;
	}
		
	function Verifier(form, action, mode, flag)
	{

	   	blnVerification = flag;
	   	form.action.value = action;
	   	form.confirm.value = "";
	}

	function renverseStrDate(sIn) {
	  var sOut = "";
	  if(sIn!=""){
		  sOut = sIn.charAt(6) + sIn.charAt(7) + sIn.charAt(8)+ sIn.charAt(9) + "/" + sIn.charAt(3)+ sIn.charAt(4) + "/" + sIn.charAt(0)+ sIn.charAt(1)
	  }
	  return(sOut);
	}

	function CtrlDate(champ){
	
		var form = document.forms[0];
		
		if( form.datsitu.value != "" && form.datdep.value != "" ){
		
			var datesitu = renverseStrDate('01/' + document.forms[0].datsitu.value);
			var datedep = renverseStrDate(document.forms[0].datdep.value);
		  	if ( datesitu > datedep){
			  	  alert("La date de départ doit être supérieur ou égale à la date d'arrivée");
			  	  champ.value = '';
			  	  champ.focus();
			  	  return false;
		  	  }
			return true;		
		}	
	}

	function verif_igg_matricule(form) {

		if ( form.matricule && form.igg ) {
			if ( form.matricule.value == '' && form.igg.value == '' ) {
				alert('Vous devez renseigner au moins le matricule et/ou l\'IGG de cette ressource');
				return false;
			}
			if ( form.igg.value != '' ) {
				if ( VerifierNumMessage(form.igg,10,0,'Le code IGG doit être numérique !') == false ) {
					return false;
				}
				if ( form.igg.value.length != 10 ) {
					alert('Le code IGG doit être sur 10 caractères !');
					return false;
				}
				
			}
		}	
		
		if ( form.matricule.value.length != 7 &&  form.matricule.value != '' )
		{
					alert('Le code matricule doit être sur 7 caractères !');
					return false;
		}
		
		
		// Agent
		if ( rtype == 'A' ) {
			
			// igg et matricule renseigne
			if ( form.matricule && form.igg ) {
				
				if ( form.igg.value.substring(0,1) == '9' ) {
					alert("L'IGG et/ou le matricule est incorrect");
					return false;
				}	
			}
		// Prestataire
		} else {
			// igg et matricule renseigne
			if ( form.matricule && form.igg ) {
				
				if (  form.matricule.value.substring(0,1) == 'X' && form.igg.value.substring(0,1) == '9' ) {
					alert("L'IGG et/ou le matricule est incorrect");
					return false;
				}
				
				if (  form.matricule.value.substring(0,1) == 'Y' && form.igg.value.substring(0,1) == '1' ) {
					alert("L'IGG et/ou le matricule est incorrect");
					return false;
				}
							
			}		
		
		}
	
	}
	
	function ValiderEcran(form)
	{	
		
		 
	   	if (blnVerification) {
	   	
			if (form.rnom && !ChampObligatoire(form.rnom, "le nom")) return false;
			if (form.rprenom && !ChampObligatoire(form.rprenom, "le prénom")) return false;
			
			if (form.mode.value == 'insert') 
			{
			if (form.soccode && !ChampObligatoire(form.soccode, "la société")) return false;
			if (form.codsg && !ChampObligatoire(form.codsg, "le code Département/Pôle/Groupe")) return false;
			if (form.datsitu && !ChampObligatoire(form.datsitu, "la date d'arrivée")) return false;
			if (form.code_domaine && !ListeObligatoire(form.code_domaine, "le domaine")) return false;
			if (form.prestation && !ListeObligatoire(form.prestation, "la prestation")) return false;
			if (rtype!='A' && form.modeContractuel && !ListeObligatoire(form.modeContractuel, "le mode contractuel indicatif")) return false;
			if (form.cpident && !ChampObligatoire(form.cpident, " l'identifiant chef de projet")) return false;
			if (form.cout && !ChampObligatoire(form.cout, " le coût HT")) return false;

			// Controle si date depart > date arrive
			if ( form.datdep.value != '' ) {
				var datesitu = renverseStrDate('01/' + form.datsitu.value);
			  	var datedep = renverseStrDate(form.datdep.value);
	  	
				if ( datesitu > datedep){
					alert("Date de départ doit être supérieur ou égale à la date d'arrivée");
					form.datdep.value = '';
					return false;
				}
			}
			
			// Controle igg et matricule
			if ( verif_igg_matricule(form) == false ) {
				return false;
			}
			
			<%if ( "SLT".equals(personneForm.getPrestation()) ) { %>
	if (form.fident &&!ChampObligatoire(form.fident, "l'identifiant forfait")) return false;
	<%}%>
			// rendre le mci obligatoire
			// si le code prestation est different de IFO et SLT et que le dpg
			// est parametre obligatoire pour le MCI
			// alors le MCI doit etre different de vide, XXX, ???			
				if ( form.prestation.value != 'SLT' 
			    && form.prestation.value != 'IFO'
			    && form.mciObligatoire.value == 'O'
			    && form.rtype.value != 'A'
				&& ( form.modeContractuelInd.value == "" || form.modeContractuelInd.value == "XXX" || form.modeContractuelInd.value == "???" )
			   ) {
				alert('Un vrai MCI est obligatoire pour les ressources externes de votre entité, veuillez le saisir');
				form.modeContractuelInd.focus();
				return false;
			}
			
			//if (form.rmcomp && !ChampObligatoire(form.rmcomp, "le code poste")) return false;
			// PPR fiche 116 enlève le test sur matricule
			//if (form.matricule && !ChampObligatoire(form.matricule, "le matricule")) return false;
			if (form.dispo && !ChampObligatoire(form.dispo, "la disponibilité")) return false;
						
			}
			if (form.mode.value == 'update') {
			// Controle igg et matricule
				if ( verif_igg_matricule(form) == false ) {
				return false;
				}
			  if(rtype=='A')
			  {
                  if (!confirm("Voulez-vous modifier cet agent SG ?"))  return false;
              }    
              else
	     	  {
	     	     if (!confirm("Voulez-vous modifier cette prestation ?")) return false;
	     	  }			 
			}
			
		   if (form.mode.value == 'delete') {
			  if(rtype=='A')
			  {
                  if (!confirm("Voulez-vous supprimer cet agent SG ?")) return false;
              }
              else
              {
	     	     if (!confirm("Voulez-vous supprimer cette prestation ?")) return false;
	     	  }		
			}
			
	   }	 
	   return true;
	}
	function rechercheDPG()
	{
		window.open("/recupDPG.do?action=initialiser&nomChampDestinataire=codsg&rafraichir=OUI&windowTitle=Recherche Code DPG&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
		return ;
	}
	function rechercheID()
	{
		window.open("/recupIdPersonne.do?action=initialiser&nomChampDestinataire=cpident&rafraichir=OUI&windowTitle=Recherche Identifiant Chef de Projet&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
		return ;
	}
	
	function rechercheSocieteID(){
		window.open("/recupIdSociete.do?action=initialiser&nomChampDestinataire=soccode&rafraichir=OUI&windowTitle=Recherche Identifiant Societe&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
		return ;
	} 
	
function rechercheFIDENT(){
	window.open("/recupIdPersonneType.do?action=initialiser&rtype=F&nomChampDestinataire=fident&rafraichir=OUI&windowTitle=Recherche Identifiant Forfait&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
}
function nextFocusDatsitu(){
	document.forms[0].focus.value = 'datsitu';
      document.forms[0].datsitu.focus();
   }

   function nextFocusMatricule(){
     document.forms[0].matricule.focus();
   }
    
function nextFocusCpident(){
	document.forms[0].cpident.focus();
}
    
function nextFocusCout(){
     document.forms[0].cout.focus();
}
    
    function rechercheModeContractuel(){
    	if ( document.forms[0].mciCalcule.value != 'O' ) {
	        window.open("/recupModeContractuel2.do?action=initialiser&modeContractuelInd=<%= personneForm.getModeContractuelInd() %>&nomChampDestinataire1=modeContractuelInd&rtype="+rtype+"&rafraichir=OUI&windowTitle=Recherche Mode Contractuel&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=900, height=450") ;
		}		        
  }
    
function refresh(focus) {

	document.forms[0].focus.value = focus;
	
 if(!rafraichiEnCours)
	      {
		     rafraichir(document.forms[0]);
		     rafraichiEnCours = true;
	       }
}
	
</script>
<!-- #EndEditable --> 
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
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
          <td height="20" class="TitrePage"><div id="titre" ><!-- #BeginEditable "titre_page" -->
           <bean:write name="personneForm" property="titrePage"/> <%= sRtype %> <!-- #EndEditable --></div></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/personne"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div id="content">
			<div align="center"><!-- #BeginEditable "contenu" -->
		    <input type="hidden" name="pageAide" value="<%= sPageAide %>">
		    <html:hidden property="confirm"/>

           <html:hidden property="titrePage"/>
		  <html:hidden property="action"/>
		  <html:hidden property="mode"/>
		  <html:hidden property="arborescence" value="<%= arborescence %>"/>
		  <html:hidden property="focus"/> 
		  <html:hidden property="rtype"/>
		  <html:hidden property="flaglock"/>
		  <html:hidden property="isClone"/>
		  
<!--Creer--><logic:notEqual parameter="mode" value="update"> 
			<html:hidden property="ident"/>
			<html:hidden property="mciCalcule"/>
			<html:hidden property="mciObligatoire"/>
			
			
              <table cellspacing="2" cellpadding="2" class="tableBleu">
              		<tr><td>&nbsp;</td></tr>
              		<tr> 
                  		<td class="texte"><b>Nom :</b></td>
                    	<td><html:text property="rnom" name="personneForm" styleClass="input" size="32" maxlength="30" onchange="return VerifierAlphaMax(this);"/>
						</td>
                	</tr>
					<tr> 
                  		<td class="texte"><b>Pr&eacute;nom :</b></td>
                    	<td><html:text property="rprenom" name="personneForm" styleClass="input" size="15" maxlength="15" onchange="return VerifierAlphaMax(this);"/>
						</td>
                	</tr>
					<tr> 
                  		
                  		<td class="texte"><b>Soci&eacute;t&eacute; :</b></td>
                  		
						<logic:equal parameter="rtype" value="P">                        
                        <td class="texte"><html:text name="personneForm" property="soccode"  styleClass="input" size="4" maxlength="4" onchange="VerifierAlphaMax(this); if ( CtrlSociete() ) { refresh(this.name) } ;"/>
                        	&nbsp;&nbsp;<a href="javascript:rechercheSocieteID();" onFocus="javascript:nextFocusLoupeSociete();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code Société" title="Rechercher Code Société"></a>
                        
                        	<bean:write name="personneForm"  property="lib_soccode" />
                        	<html:hidden property="lib_soccode"/>
                        </td>
                        </logic:equal>
                        
                        <logic:equal parameter="rtype" value="A"> 
                        <td >
                         	<html:text property="soccode" name="personneForm" styleClass="input" size="4" maxlength="4" readonly="true"/>                         
                        	<!-- <bean:write name="personneForm"  property="soccode" /> -->
                        </td>
                        <td colspan=2></td>
                        </logic:equal>
                        
                	</tr>
               		
              </table>
			      <table cellspacing="2" cellpadding="2" class="tableBleu"> 
					 <tr> 
                  		<td colspan=4>&nbsp;</td>
                	</tr>
					<tr><td colspan=4 align=center class="texte"><u>Saisie obligatoire</u></td></tr>

					<tr>	
					    <td class="texteGras"><b>Départ/Pôle/Groupe :</b></td>
						<td>
							<html:text property="codsg" styleClass="input" size="7" maxlength="7" onchange="VerifierNum(this,7,0);refresh('datsitu');"/>&nbsp;
							<a href="javascript:rechercheDPG();" onFocus="javascript:nextFocusDatsitu();" ><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code DPG" title="Rechercher Code DPG" align="absbottom"></a>
						</td> 
									
						<td class="texteGras"><b>Date d'arrivée :</b></td>
						<td >
							<html:text property="datsitu" styleClass="input" size="8" maxlength="7" onchange="if ( VerifierDate(this,'mm/aaaa') && CtrlDate(this) ){refresh(this.name);};"/>
						</td>			
					</tr>	

					<tr>	
					    <td>&nbsp;</td>
						<td width="180">&nbsp;</td> 		
						<td class="texteGras"><b>Date de départ :</b></td>
						<td >
							<html:text property="datdep" styleClass="input" size="10" maxlength="10" onchange="if ( VerifierDate(this,'jj/mm/aaaa') && CtrlDate(this) ){refresh(this.name);};"/>
						</td>			
					</tr>	
						
				    <tr> 
                       <td  class="texteGras"><b>Domaine :</b> </td>
                       <td colspan=3 >
                       	<html:select property="code_domaine" styleClass="input" onchange="refresh(this.name);"> 
   						<bip:options collection="choixDomaine" />
						</html:select>
                     </td>
                    </tr>	
                    
                    <tr> 
                       <td  class="texteGras"><b>Prestation :</b> </td>
                       <td colspan=3 >
                       	<html:select property="prestation" styleClass="input" onchange="refresh(this.name);" > 
   						<bip:options collection="choixPrestation" />
						</html:select>
                     </td>
                     
                    </tr>
                    
                    <%if ( !(personneForm.getRtype().equals("A")) && !(personneForm.getRtype().equals("P") && personneForm.getSoccode().equals("SG..") ) ) { %>
                                      
                     <tr> 
                       <td class="texteGras"><b>Mode contractuel indicatif :</b></td>
                       <td>
							 <logic:notEqual parameter="action" value="supprimer"> 
								<% if ( "O".equals(personneForm.getMciCalcule()) ) { %>
									<bean:write name="personneForm" property="modeContractuelInd"/>
									<html:hidden property="modeContractuelInd"/>
								<% } else { %>
									<html:text property="modeContractuelInd" styleClass="input" size="3" maxlength="3" onchange="VerifierAlphaMaxCarSpecModeContractuel(this); refresh(this.name);"/>													
							 			&nbsp;&nbsp;							 			
							 			<a href="javascript:rechercheModeContractuel();" onFocus="javascript:nextFocusCpident();" >
							 				<img id="cpident_loupe" border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Mode Contractuel Indicatif" title="Rechercher Mode Contractuel Indicatif">
							 			</a>
							 	<% } %>
						</td>
						<td colspan="2" class="texte"><bean:write name="personneForm" property="lib_mci" /></td>
								<html:hidden property="lib_mci"/> 
								
							</logic:notEqual>
							
							<logic:equal parameter="action" value="supprimer">
							            	<bean:write name="personneForm"  property="modeContractuelInd" />
							            	<html:hidden property="modeContractuelInd"/>
							</logic:equal>
                  		</td>
                	</tr>
                    <%} %>
                    
					<%if ( "SLT".equals(personneForm.getPrestation()) ) { %>
					<tr>		
						<td class="texteGras"><b>Ident Forfait :</b></td>
						<td >
							<html:text property="fident" styleClass="input" size="5" maxlength="5" onchange="if ( VerifierNum(this,5,0) ){refresh(this.name);} ;"/>&nbsp;&nbsp;&nbsp;&nbsp;
							<a href="javascript:rechercheFIDENT();"><img border=0 src="/images/p_zoom_blue.gif"  alt="Rechercher Identifiant Forfait" title="Rechercher Identifiant Forfait" align="absbottom"></a>
						</td>			
					</tr>
						
				    <tr>	
					<%} %>	
																	
						<logic:notEqual parameter="soccode" value="SG..">
						
						 <td class="texteGras"><b>Ident chef de projet :</b></td>
						   <td>
							<html:text property="cpident" styleClass="input" size="5" maxlength="5" onchange="if ( VerifierNum(this,5,0) ){refresh(this.name);};"/>&nbsp;&nbsp;&nbsp;&nbsp;
							<a href="javascript:rechercheID();"  onFocus="javascript:nextFocusCout();"><img border=0 src="/images/p_zoom_blue.gif"  alt="Rechercher Identifiant Chef de Projet" title="Rechercher Identifiant Chef de Projet" align="absbottom"></a>
						   </td>
						
						 <td class="texteGras"><b>Coût HT (EUR) :</b></td>
						   <td>
								<html:text property="cout" styleClass="input" size="13" maxlength="13" onchange="return VerifierNum(this,12,2);"/>&nbsp;
						   </td>
						</logic:notEqual>
						
						<logic:equal parameter="soccode" value="SG..">
						<td class="texteGras"><b>Ident chef de projet :</b></td>
						   <td>
							<html:text property="cpident" styleClass="input" size="5" maxlength="5" onchange="if ( VerifierNum(this,5,0) ){refresh(this.name);};"/>&nbsp;&nbsp;&nbsp;&nbsp;
							<a href="javascript:rechercheID();"  onFocus="javascript:nextFocusMatricule();"><img border=0 src="/images/p_zoom_blue.gif"  alt="Rechercher Identifiant Chef de Projet" title="Rechercher Identifiant Chef de Projet" align="absbottom"></a>
						   </td>
						</logic:equal>
						
						
				    </tr>	

                   <tr>										 
					   <td class="texteGras"><b>Matricule :</b></td>
                       <td>
						   		<html:text property="matricule" styleClass="input" size="7" maxlength="7" onchange="return VerifierAlphaMax(this);"/>
					   </td>
					   
					   <html:hidden property="homonyme"/>

 					   <td class="texteGras"><b>Disponibilité :</b></td>
					   <td class="texte">
					   		<html:text property="dispo" styleClass="input" size="3" maxlength="3" onchange="return VerifierNum(this,2,1);"/>
					   		 &nbsp;(J/S)
					   </td>	
					</tr>
                   <tr>										 
					   <td class="texteGras"><b>IGG :</b></td>
                       <td>
						   		<html:text property="igg" styleClass="input" size="10" maxlength="10" onchange="return VerifierAlphaMax(this);"/>
					   </td>
	
					</tr>
														
				</table>
				
<!--Fin Creer--></logic:notEqual>
  								
<!--Modifier--><logic:equal parameter="mode" value="update">
				<html:hidden property="homonyme" value="true"/>
				<div id="content">
				<table cellspacing="2" cellpadding="2" class="tableBleu">
					<tr><td>&nbsp;</td></tr>
					<tr> 
						<td colspan=2 align=center class="texte"><b>Identifiant :&nbsp;&nbsp;&nbsp; 
							<bean:write name="personneForm"  property="ident" />
							<html:hidden property="ident"/></b>
						</td>
					</tr>
					<tr><td colspan=2>&nbsp;</td></tr>
					<tr> 
						<td align=center colspan=3 class="texte"><u>Saisie obligatoire</u></td>
					</tr>
					<tr align="left"> 
						<td class="texteGras"><b>Nom :</b></td>
						<td >
							<html:text property="rnom" styleClass="input" size="30" maxlength="30" onchange="this.form.homonyme.value='';return VerifierAlphaMax(this);"/> 
						</td>
					</tr> 
					<tr align="left">
						<td class="texteGras" ><b>Pr&eacute;nom :</b></td>
						<td>  
							<html:text property="rprenom" styleClass="input" size="15" maxlength="15" onchange="this.form.homonyme.value='';return VerifierAlphaMax(this);"/> 
						</td>
					</tr> 
					<tr align="left">
						<td class="texteGras"><b>Matricule :</b></td>
						<td >
                  	<logic:equal name="personneForm" property="rtype" value="P">
                  	
	                  	<logic:equal name="personneForm" property="isClone" value="oui">
	                        <bean:write name="personneForm"  property="matricule" />
	                    	<html:hidden property="matricule"/>
	                    </logic:equal>
                    	<logic:notEqual name="personneForm" property="isClone" value="oui">	
          <html:text property="matricule" styleClass="input" size="7" maxlength="7" onchange="return VerifierAlphaMax(this);"/>
           				</logic:notEqual>
           				                    
                   </logic:equal>
                   
                   <logic:notEqual name="personneForm" property="rtype" value="P"> 
			<html:text property="matricule" styleClass="input" size="7" maxlength="7" onchange="return VerifierAlphaMax(this);"/>                   
                   </logic:notEqual>
              
						</td>
					</tr>
					<tr align="left">
						<td class="texteGras"><b>IGG :</b></td>
						<td >
                  
                 <logic:equal name="personneForm" property="rtype" value="P">
                  	<logic:equal name="personneForm" property="isClone" value="oui">
                        <bean:write name="personneForm"  property="igg" />
                    	<html:hidden property="igg"/>
                    </logic:equal>
                    
                    <logic:notEqual name="personneForm" property="isClone" value="oui">                  
          <html:text property="igg" styleClass="input" size="10" maxlength="10" onchange="return VerifierAlphaMax(this);"/> 
                    </logic:notEqual>
                    
                 </logic:equal>
                 
                 <logic:notEqual name="personneForm" property="rtype" value="P">
          <html:text property="igg" styleClass="input" size="10" maxlength="10" onchange="return VerifierAlphaMax(this);"/>        
                 </logic:notEqual>
                 
						</td>
					</tr>
				</table>
<!--Fin Modifier--></logic:equal>
				 <table cellspacing="2" cellpadding="2" class="tableBleu">
					<tr><td>&nbsp;</td></tr>
					<tr> 
						<td align=center colspan=5 class="texte"><u>Saisie facultative</u></td>
					</tr>
					<tr align="left"> 
						<td class="texteGras">N&deg; t&eacute;l&eacute;phone (interne) :</td>
						<td colspan="2"> 
							<html:text property="rtel" styleClass="input" size="16" maxlength="16"/> 
						</td>
					</tr> 
					<tr align="left"> 
						<td class="texteGras">Immeuble :</td>
						<td colspan="2">
							<html:select property="icodimm" styleClass="input" size="1"> 
							<html:options collection="choixImm" property="cle" labelProperty="libelle" />
							</html:select> 
						</td>
					</tr>
					<tr align="left"> 
						<td colspan="2" class="texteGras">
							Zone  <html:text property="batiment" styleClass="input" size="1" maxlength="1" onchange="return VerifierAlphaMax(this);"/> 
							&nbsp;&nbsp;
							Etage   <html:text property="etage" styleClass="input" size="2" maxlength="2" onchange="return VerifierAlphaMax(this);"/> 
							&nbsp;&nbsp;
							Bureau   <html:text property="bureau" styleClass="input" size="3" maxlength="3" onchange="return VerifierAlphaMax(this);"/> 
						</td>
					</tr>
					<tr> 
						<td colspan="2">&nbsp;</td>
					</tr>  
					<tr> 
						<td align="center" colspan="2"> 
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
				</table>
				<!-- #EndEditable --></div></div>
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
<% if ( "O".equals(personneForm.getMciAlert()) ) { %>
<script>
	alert('MCI récupéré automatiquement du forfait lié, veuillez valider de nouveau ');
</script>	
<% } %>

</body>
<% 
Integer id_webo_page = new Integer("1028"); 
com.socgen.bip.commun.form.AutomateForm formWebo = personneForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
