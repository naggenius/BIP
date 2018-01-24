<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,com.socgen.bip.commun.liste.ListeOption,java.io.*,java.util.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="saisieConsoForm" scope="request" class="com.socgen.bip.form.SaisieConsoForm" />
<jsp:useBean id="listeDynamique" scope="request" class="com.socgen.bip.commun.liste.ListeDynamique" />
<html:html locale="true"> 
 
<head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<title>Page BIP</title>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<bip:VerifUser page="/saisieConso.do"/> 
<%  
	ArrayList list1 = listeDynamique.getListeDynamique("isac_resscons",saisieConsoForm.getHParams());
	ArrayList listFav = listeDynamique.getListeDynamique("isac_ressfavcons",saisieConsoForm.getHParams());
	boolean erreur = false;
	
    pageContext.setAttribute("choixRess", list1);
    pageContext.setAttribute("choixRessFav", listFav);

    if(session.getAttribute("IDENT") != null)
    {	
        int pos = Integer.parseInt((String)session.getAttribute("POSITION"));
       try
        {
   	   		if ( "1".equals(session.getAttribute("CHOIXRESS")) ) {
  				saisieConsoForm.getHParams().put("ident", ""+((ListeOption)list1.get(pos+1)).getCle());

   	   		} else {
   	   		saisieConsoForm.getHParams().put("ident", ""+((ListeOption)listFav.get(pos+1)).getCle());

   	   		}
    	
       }
        catch(java.lang.IndexOutOfBoundsException e)
        {
        	if ( "1".equals(session.getAttribute("CHOIXRESS")) ) {
        		if (list1.size() == 1) {  // PPM 59243
				saisieConsoForm.getHParams().put("ident", ""+((ListeOption)list1.get(0)).getCle());
				saisieConsoForm.setIdent(((ListeOption)list1.get(0)).getCle());
				saisieConsoForm.setFocus(((ListeOption)list1.get(0)).getCle());
				erreur = true;
				}
        		else
        		{
        			try{
        			saisieConsoForm.getHParams().put("ident", ""+((ListeOption)list1.get(pos)).getCle());
        			
        			}catch(java.lang.IndexOutOfBoundsException eee){
        				
        				saisieConsoForm.getHParams().put("ident", ""+((ListeOption)list1.get(0)).getCle());
        				saisieConsoForm.setIdent(((ListeOption)list1.get(0)).getCle());
        				session.setAttribute("POSITION",-1);
        				
        			}
        		}

        	} else {
        		if ( listFav.size() == 0 ) {
        			saisieConsoForm.getHParams().put("ident", ""+((ListeOption)list1.get(0)).getCle());

        		} else {
        			try {
        				if (listFav.size() == 1) {  // PPM 59243
						saisieConsoForm.getHParams().put("ident", ""+((ListeOption)listFav.get(0)).getCle());
						saisieConsoForm.setIdent(((ListeOption)listFav.get(0)).getCle());
						saisieConsoForm.setFocus(((ListeOption)listFav.get(0)).getCle());
						erreur = true;
						} 
        				else saisieConsoForm.getHParams().put("ident", ""+((ListeOption)listFav.get(pos)).getCle());
        			}
        			catch(java.lang.IndexOutOfBoundsException e2)
        	        {
        				saisieConsoForm.getHParams().put("ident", ""+((ListeOption)listFav.get(1)).getCle());
        				session.setAttribute("POSITION",-1);

        	        }
        		}
        		
        	}
        }
    }
 // ABN - HP PPM 63556
    else {
    	try {
	        saisieConsoForm.getHParams().put("ident", ""+((ListeOption)list1.get(0)).getCle());
    	} catch(java.lang.IndexOutOfBoundsException e2) {
        	saisieConsoForm.setMsgErreur("Compte-tenu de vos habilitations, aucune ressource active ne peut vous être proposée à la saisie");
        }

    }
    
    ArrayList list2 = listeDynamique.getListeDynamique("isac_dpg",saisieConsoForm.getHParams());
	pageContext.setAttribute("choixDpg", list2);

  %>

<script type="text/javascript" src="../js/jquery.js"></script>
<script type="text/javascript" src="../js/jquery.dimensions.js"></script>
<script type="text/javascript" src="../js/jqueryMultiSelect.js"></script>

<script language="JavaScript" src="../js/function.cjs"></script>

<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<link rel="stylesheet" href="../css/jqueryMultiSelect.css" type="text/css" />

<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
	String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));  
	String sIndexMenu = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("indexMenu")));
%>
var pageAide = "<%= sPageAide %>";

function MessageInitial()
{

   var Message="<bean:write filter="false"  name="saisieConsoForm"  property="msgErreur" />";
   var Focus = "<bean:write name="saisieConsoForm"  property="focus" />";
   var position ="<%=session.getAttribute("POSITION")%>";

   var choixRess ="<%=session.getAttribute("CHOIXRESS")%>";
   var objBouton = document.getElementById("boutonValider");
   
   /*BIP 184 - Giving the drop down value as 50 on load of the page*/
   var position_blocksize = "<%=session.getAttribute("POSITION_BLOCKSIZE")%>";
   if(<%=session.getAttribute("POSITION_BLOCKSIZE")%> === null ||  position_blocksize === undefined) {
   	position_blocksize='4';
   }
   
   /*BIP 184 - to keep the dropdown selected value by user*/
		document.forms[0].blocksize.selectedIndex=parseInt(position_blocksize);
		
		//document.forms[0].blocksize.selectedIndex=parseInt(4);
    // alert("after session get"+position_blocksize);
   var vordre_tri = "<%=session.getAttribute("ORDRE_TRI")%>";
   
   var objRes = document.getElementById("res");
   // ABN - HP PPM 63556
   if (Message != "") {
	      alert(Message);
	      if (Message == "Compte-tenu de vos habilitations, aucune ressource active ne peut vous être proposée à la saisie") {
	    	  window.location.href='/listeFavoris.do?arborescence=Menu Client/Favoris&sousMenu=&pageAide=/jsp/aide/Guide_Menu_Client.doc&addFav=no&action=initialiser&titlePage=Liste+des+favoris&lienFav=%2FlisteFavoris.do';
	      }
   }

   if ( choixRess == "1" || choixRess == "2" ) {
   
   		objRes.style.display='block';
   		objBouton.style.display='block';
   		
		if ( choixRess == "1" ) {

			document.getElementById("ra1").checked=true ;
			AfficheRess("ress");
		}
		if ( choixRess == "2" ) {

			document.getElementById("ra2").checked=true ;
			AfficheRess("ressFav");
		}
		   		
		if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
		else {
		Focus='ident';
		(eval( "document.forms[0]."+Focus )).focus();
		//document.forms[0].ident.focus();
		}
		  
		if (document.forms[0].ident.length-1!=parseInt(position))
		   document.forms[0].ident.selectedIndex=parseInt(position)+1;
		else
		   document.forms[0].ident.selectedIndex=parseInt(position);   
		
					
		if(vordre_tri == '2')
		   document.forms[0].ordre_tri[1].checked=true;
		else
		   document.forms[0].ordre_tri[0].checked=true;
				
	}
	 
}


function AfficheRess(choix)
{
	var objRes = document.getElementById("optRess");
	var objBouton = document.getElementById("boutonValider");
	var objDivRes = document.getElementById("res");
	var objDivMess = document.getElementById("mess");
    var strMess;
    
	if(objBouton) {objBouton.style.display='none' } ;
	if(objDivRes) {objDivRes.style.display='none' } ;
    if(objDivMess) {objDivMess.style.display='none' } ;
	    	
	if (choix=="ressFav") {
		<%
		
		if(listFav.size() == 0) { 
		%>
		//alert("Votre liste de ressources favorites est vide ! Veuillez l'editer au menu suivant :\nParamétrage-Ressources favorites ");
		strMess = '<table border="1"  cellpadding="5" cellspacing="2" class="TableBleu" align="center" style="border-collapse:collapse;border-color:black;"><tr><td>';
		strMess = strMess + "Votre liste de ressources favorites n'est pas intialisée.<br>";
		strMess = strMess + "Vous pouvez la créer par l'intermédiaire du menu suivant :<br>";
		strMess = strMess + "Paramétrage/Ressources favorites.</td></tr></table>"; 
		objDivMess.innerHTML = strMess ; 
		objDivMess.style.display='block';
		<%
	    } else {
		%>
			objBouton.style.display='block';
			objDivRes.style.display='block';
		
			objRes.innerHTML = document.getElementById("ressFav").innerHTML;
		<%
		} 
		%>
				
	} else {
			objBouton.style.display='block';
			objDivRes.style.display='block';
			objRes.innerHTML = document.getElementById("ress").innerHTML;
	}
	
<% if (erreur) { %>
$(document).ready(function() {
		$('select[name="listeCodsg"]').multiSelect({
		selectAll: true,
		selectAllText: 'Tout sélectionner',
		noneSelected: 'Tous',
		oneOrMoreSelected: '*'
	});
});
<%  }%>
	
	

}

function Verifier(form, action, flag)
{
  blnVerification = flag;
  form.action.value = "modifier";
}

function ChangeIdent(form){

    form.keyList0.value = form.ident.value;
	form.position.value =form.ident.selectedIndex-1; 

	form.position_blocksize.value =form.blocksize.selectedIndex; 
	//form.blocksize.value =form.blocksize.selectedIndex;
	form.ordre_tri.value = "1";
	if (form.ordre_tri[0].checked)
	{
	form.ordre_tri.value = "1";
	}
	if (form.ordre_tri[1].checked)
	{
	form.ordre_tri.value = "2";
	}

//	form.action.value="annuler";
	//form.submit();
	
}

function ValiderEcran(form)
{
	form.keyList0.value = form.ident.value;
	form.position.value =form.ident.selectedIndex; 
	form.position_blocksize.value =form.blocksize.selectedIndex; 
	form.ordre_tri.value = "1";
	if (form.ordre_tri[0].checked)
	{
	form.ordre_tri.value = "1";
	}
	if (form.ordre_tri[1].checked)
	{
	form.ordre_tri.value = "2";
	}
	
	
   return true;
}

$(document).ready(function() {
	MessageInitial();
	
	$('select[name="listeCodsg"]').multiSelect({
		selectAll: true,
		selectAllText: 'Tout sélectionner',
		noneSelected: 'Tous',
		oneOrMoreSelected: '*'
	});
});
//SEL - PPM 63897 - QC_1916
function rechercheID(){
	window.open("/recupIdPersonneSaisie.do?action=initialiser&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=561") ;
	return ;
}
</script>

</head>
<div id="mainContainer">
<div id="topContainer">
<div id="entete"></div>
<div id="logo">
		<div id="logo_sg"><img src="../images/logo_SG.gif" width="162" height="33" border="0" /></div>
		<div id="nomdusite"><img src="../images/bip_logo.png" width="78" height="46" border="0" /></div>
</div>

<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0">

	<div id="ress" style="position:relative;top:0;left:0;display:none;">
		<select name="ident" onchange="ChangeIdent(this.form);" class="input">
			<logic:iterate name="choixRess" id="element">
				<option value="<bean:write name="element" property="cle" />"><bean:write name="element" property="libelle" /></option>
			</logic:iterate>
		</select>
	</div>

	<div id="ressFav" style="position:relative;top:0;left:0;display:none;">
		<select name="ident" onchange="ChangeIdent(this.form);" class="input">
			<logic:iterate name="choixRessFav" id="element">
				<option value="<bean:write name="element" property="cle" />"><bean:write name="element" property="libelle" /></option>
			</logic:iterate>
		</select>
	</div>
		
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr> 
		<td> 
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr> 
					<td> 
						<div id="outils" align="center"><!-- #BeginEditable "barre_haut" -->
						  <%ToolBarNew tb = new com.socgen.ich.ihm.ToolBarNew("bip_ihm",false,false,true,true,false,false,false,false,false,request) ;%>
							<%=tb.printHtml()%><!-- #EndEditable -->
						</div>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr> 
					<td height="20" class="TitrePage"><div id="titre" >Saisie des consomm&eacute;s</td></td>
				</tr>
				<tr> 
					<td>
						<div id="content">
						<html:form action="/saisieConso"  onsubmit="return ValiderEcran(this);" target="_top"><!-- #EndEditable --> 
						<div align="center">
						<input type="hidden" name="pageAide" value="<%= sPageAide %>">
						<input type="hidden" name="indexMenu" value="<%= sIndexMenu %>">
						<html:hidden property="action"/>
						<html:hidden property="mode"/>
						<html:hidden property="arborescence" value="<%= arborescence %>"/>
						<html:hidden property="keyList0"/> <!--ident-->
						<html:hidden property="position"  /> <!--position de la ressource dans la liste-->
						<html:hidden property="position_blocksize"/> <!--position de la ressource dans la liste-->
						
						<table  border="0"  cellpadding="2" cellspacing="2" >
							<tr align="left">
								<td>
									<table border="0"  cellpadding="2" cellspacing="2" class="TableBleu" >
										<tr><td>&nbsp;</td></tr>
										<tr><td>&nbsp;</td></tr>
										<tr>
											<td class="texteGras"><b>Liste des ressources :</b></td>
											<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
											<td class="texte">Toutes les ress. habilitées :  
												<input type="radio" name="choix_ress" id="ra1" value="1" <% if ( session.getAttribute("CHOIXRESS") == "1") { %> checked <% } %> onclick="AfficheRess('ress');ChangeIdent(this.form);" />
											</td>
											<td class="texte">Seulement les favorites :  
												<input type="radio" name="choix_ress" id="ra2"  value="2" <% if ( session.getAttribute("CHOIXRESS") == "2") { %> checked  <% } %> onclick="AfficheRess('ressFav');ChangeIdent(this.form);" />
											</td>
										</tr>
										<tr><td>&nbsp;</td></tr>
									</table>

									<div id="mess" style="position:relative;top:0;left:0;display:none;"></div>	
									<div id="res" style="position:relative;top:0;left:0;display:none;">
									
									<table border="0"  cellpadding="2" cellspacing="2" class="TableBleu">	
										<tr>
											<td class="texteGras"><b>Choisissez une ressource : </b></td>		
											<td>							
													<div id="optRess"></div> 
														   
											</td>
											<td>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:rechercheID();" ><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Identifiant" title="Rechercher Identifiant" align="absbottom"></a>
					   </td>		
										</tr>             		
										<tr>
											<td class="texteGras"><b>Choisissez un ou plusieurs DPG : </b></td>
											<td>
												<html:select property="listeCodsg" multiple="true" size="1" styleClass="input">
													<html:options collection="choixDpg" property="cle" labelProperty="libelle"/>
												</html:select>
											</td>
										</tr>
										<tr>
											<td class="texteGras"><b>Liste des sous-t&acirc;ches : </b></td>
											<td class="texte"><html:radio property="listeSousTaches" value="1" />Toutes les affect&eacute;es</td>
										</tr>
										<tr>
											<td></td>
											<td class="texte"><html:radio property="listeSousTaches" value="2" />Seulement les favorites</td>
										</tr>
										<tr>
											<td></td>
											<td class="texte"><html:radio property="listeSousTaches" value="3" />Seulement avec consommé</td>
										</tr>
										<tr> 
											<td class="texteGras"><b>Nombre de lignes par page :</b></td>
											<td> 
												<html:select property="blocksize" size="1" styleClass="input">
													<option value="10">10</option>
													<option value="20">20</option>
													<option value="30">30</option>
													<option value="40">40</option>
													<option value="50">50</option>
													<option value="60">60</option>
													<option value="70">70</option>
													<option value="80">80</option>
													<option value="90">90</option>
													<option value="100">100</option>
												</html:select>
											</td>
										</tr>
										<tr>
											<td class="texteGras"><b>Ordre de tri par :</b></td>
											<td class="texte"><input type=radio name="ordre_tri" value="1" checked="true">Code de la ligne BIP</td>
										</tr>
										<tr>		
											<td></td>
											<td class="texte"><input type=radio name="ordre_tri" value="2" >Libell&eacute; de l'application</td>
										</tr>
										<tr><td>&nbsp;</td></tr>
										<tr><td>&nbsp;</td></tr>
									</table>
								
									<table align="center">
										<tr> 
											<td align="center"> <input type="submit" name="boutonValider" id="boutonValider" value="Valider" display="none" class="input" onclick="Verifier(this.form, 'suite', true);"/> </td>
										</tr>
									</table>
									</div>
									<!--  Fin div res --> 							
								</td>
							</tr>
						</table>
						</div></div>
					</td>
				</tr>
				</html:form>
				<tr> 
					<td>&nbsp; </td>
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
</div>
	<div id="bottomContainer">
			<div>&nbsp;</div>
	</div>
</div>
</body>
</html:html>
