<!DOCTYPE html>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%@ page language="java" import="org.owasp.esapi.ESAPI,java.util.Hashtable,java.util.ArrayList,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,com.socgen.bip.metier.Favori,com.socgen.bip.user.UserBip"    errorPage="../jsp/erreur.jsp"  %>
<html:html locale="true">
<jsp:useBean id="listeFavorisForm" scope="request" class="com.socgen.bip.form.ListeFavorisForm" />

<head>

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<title>Page BIP</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<bip:VerifUser page="/listeFavoris.do"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<!-- <link rel="stylesheet" href="../css/base_style.css" type="text/css"> -->
<script language="JavaScript">
var vLien;
<% 

String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String id="";
session = request.getSession(false);

	if (session == null || session.getAttribute("UserBip") == null) {
		response.sendRedirect("/frameAccueil.jsp?redirect=O");
	}
 	else {
		com.socgen.bip.user.UserBip user = (com.socgen.bip.user.UserBip)session.getAttribute("UserBip") ;
    	com.socgen.bip.menu.item.BipItemMenu menu = user.getCurrentMenu();
    	
    	if (menu==null) {
    		response.sendRedirect("/frameAccueil.jsp?redirect=O");
    	
    		}
    	else {
    		id =menu.getId();	
    		
    	}	
	}

   Hashtable hMenu = new Hashtable();
   hMenu.put("DIR",      "Administration");
   hMenu.put("ME",       "Responsable d'études");
   hMenu.put("MO",       "Menu Client");
   hMenu.put("ISACM",    "Saisie des réalisés");
   hMenu.put("INV",      "Suivi des investissements");
   hMenu.put("ACH",      "Ordonnancement");
   hMenu.put("REF",      "Suivi par Référentiel");
   hMenu.put("ORE",      "Outil de Réestimé par Ressources");
   hMenu.put("SUIVIACT", "Suivi d'activité");
   hMenu.put("RBIP",     "Remontée Bip Intranet");
   hMenu.put("GENERAL",   "General");
   
   String menuCourant = ((UserBip) session.getAttribute("UserBip")).getCurrentMenu().getId();
   String lienFavori  = "vide";
   if (((UserBip) session.getAttribute("UserBip")).getLienFavori()!= null)
   		lienFavori = ((UserBip) session.getAttribute("UserBip")).getLienFavori();
%>

var lienFavori = "<%= lienFavori %>";
if (lienFavori != "vide") {
	top.location = "/frameset.jsp";
}

function ouvrirAide()
{
	var pageAide; 
	var param;
	
	param = "<%=ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")))%>";
	if ((param=="null")||(param==""))
	{
		pageAide = "<%= com.socgen.bip.menu.BipMenuManager.getInstance().getMenuPageAide(id)%>";
    }
    else
    	pageAide = param;

	if (pageAide.substr(0,1) != "/")
    {
    	//alert("vide "+pageAide);
    	pageAide = "/"+pageAide;
	    
   	}
	//alert("vide>"+pageAide);
	window.open(pageAide, 'Aide', 'toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=500, height=400') ;
	
	return ;
}

var blnVerification = true;

function MessageInitial() {
   var Message = "";
   var Focus = "";
   if (Message != "") {
      alert(Message);
   }
}

function Supprimer(form, p_type, p_ordre, p_menu) {
   form.type.value = p_type;
   form.ordre.value = p_ordre;
   form.menu.value = p_menu;
   form.action.value = "supprimer";
   form.submit();
}

function ModifierOrdre(form, p_sens, p_type, p_ordre, p_menu) {
   form.type.value = p_type;
   form.ordre.value = p_ordre;
   form.menu.value = p_menu;
   form.sens.value = p_sens;
   form.action.value = "modifier";
   form.submit();
}

function goToFavori(form, p_lien, p_menu) {
   document.listeFavorisForm.lien.value  = p_lien;
   document.listeFavorisForm.menu.value   = p_menu;
   document.listeFavorisForm.action.value = "goToFavori";
   
   document.listeFavorisForm.submit();
}

//ABN - HP PPM 63875
function goToFavoriTrait(idLien, p_menu) {
   document.listeFavorisForm.lien.value  = document.getElementById(idLien).value;
   document.listeFavorisForm.menu.value   = p_menu;
   document.listeFavorisForm.action.value = "goToFavori";
   document.listeFavorisForm.submit();
}

</script>

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
           <td ><div id="outils" align="center"><!-- #BeginEditable "barre_haut" -->
              <%ToolBarNew tb = new com.socgen.ich.ihm.ToolBarNew("bip_ihm",false,false,true,true,false,false,false,false,false,request) ;%>
				<%=tb.printHtml()%><!-- #EndEditable -->
		</div></td>
        </tr>
        <tr> 
          <td height="20" class="TitrePage">Liste des favoris</td>
        </tr>
        <tr> 
          <td height="20"></td>
        </tr>
		
        <tr> 
          <td>
		    <!-- #BeginEditable "debut_form" -->
		  	<html:form action="/listeFavoris">
		  	<!-- #EndEditable -->
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
			  		<html:hidden property="titrePage"/>
              		<html:hidden property="action"/>
					<html:hidden property="arborescence" value="<%= arborescence %>"/>
              		<html:hidden property="type"/>
              		<html:hidden property="ordre"/>
              		<html:hidden property="menu"/>
              		<html:hidden property="sens"/>
              		<html:hidden property="lien"/>
					
		<table cellpadding=1 cellspacing=1 border="0" width="75%" >
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
          <td>&nbsp;</td>
        </tr>
			<tr>
				<td class="lib">
					<div align="center"><b>Traitements</b></div>
				</td>
			</tr>
			<tr >				
				<td width="680" colspan="2">
					<table class="tableBleu" cellspacing="0" border="0" width="100%">
<% String  sOldMenu = "";
   String  sMenuPrec = "";
   String  sTypePrec = "";
   String  sOrdrePrec = "";
   boolean bNewMenu = false;
 //ABN - HP PPM 63875
int iLien = 0;%>
<logic:iterate id="favori" name="listeFavorisForm" property="listeFavTrait" type="com.socgen.bip.metier.Favori" indexId="it">
<% Favori fav = (Favori) listeFavorisForm.getListeFavTrait().get(it.intValue());

   if (!sOldMenu.equals(fav.getMenu())) {
   		sOldMenu = fav.getMenu();
   		bNewMenu = true;
%>
						<tr height="3"><td colspan="5"></td></tr>
						<tr align="left" >
							<td class="lib" width="200" rowspan="<%= listeFavorisForm.getNbFavMenu("T", sOldMenu) %>">
								<b>Menu <%= hMenu.get(sOldMenu) %></b>
							</td>
<% } else { 
		bNewMenu = false;
%>
						<tr>
<% } %>
							<td width="420" align="left" class="linkFavoris"><b>
							<% // Si le lien se situe dans le même menu on accède directement à la page
							   if (menuCourant.equals(sOldMenu)) { %>
							    <a href="<bean:write name="favori" property="lien"/>" onmouseover="window.status='';return true"><bean:write name="favori" property="libelle"/></a>
							<% } else {//ABN - HP PPM 63875
								String vLien = fav.getLien();
							   // sinon on doit charger le nouveau menu
							//ABN - HP PPM 63875 %>
							<input type="hidden" value="<%=vLien%>" id="idLienTraitement<%=iLien %>">
							 
								<a href="javascript:goToFavoriTrait('idLienTraitement<%=iLien %>','<bean:write name="favori" property="menu"/>')" onmouseover="window.status='';return true"><bean:write name="favori" property="libelle"/></a>
							<% } %>
							</b>
							</td>	
							<td class="null" width="20" align="right">
							<logic:notEqual name="it" value="0">
							<% if (!bNewMenu) { %>
								<input type="image" src="/images/monter.png" border="0" alt="Monter" onclick="javascript:ModifierOrdre(this.form,-1,'<bean:write name="favori" property="type"/>','<bean:write name="favori" property="ordre"/>','<bean:write name="favori" property="menu"/>'); return false;" >
							<% } %>
							</logic:notEqual>
							<logic:equal name="it" value="0">
								&nbsp;
							</logic:equal>
							</td>
							<td class="null" width="20" align="right">
							<logic:notEqual name="it" value="<%= Integer.toString(listeFavorisForm.getListeFavTrait().size()-1) %>">
<%  Favori favSuivant = (Favori) listeFavorisForm.getListeFavTrait().get(it.intValue()+1);
	// si le favori suivant est dans le même menu on permet la modification de l'ordre
	if (sOldMenu.equals(favSuivant.getMenu())) {
%>
								<input type="image" src="/images/descendre.png" border="0" alt="Descendre" onclick="javascript:ModifierOrdre(this.form,1,'<bean:write name="favori" property="type"/>','<bean:write name="favori" property="ordre"/>','<bean:write name="favori" property="menu"/>'); return false;" >
<% 	} else { %>
								&nbsp;
<%  } %>
							</logic:notEqual>
							<logic:equal name="it" value="<%= Integer.toString(listeFavorisForm.getListeFavTrait().size()-1) %>">
								&nbsp;
							</logic:equal>
							</td>
							<td class="null" width="20" align="right">
								<input type="image" src="/images/imageKO.bmp" border="0" alt="Supprimer" onclick="javascript:Supprimer(this.form,'<bean:write name="favori" property="type"/>','<bean:write name="favori" property="ordre"/>','<bean:write name="favori" property="menu"/>')" >
							</td>
						</tr>
<%iLien++; //ABN - HP PPM 63875%>
</logic:iterate>						
					</table>
				</td>
			</tr>

			<tr>
				<td></td>
			</tr>
			<tr>
				<td height="15px">&nbsp;</td>
			</tr>
			<tr>
				<td class="lib">
					<div align="center"><b>Editions</b></div>
				</td>
			</tr>
			<tr>				
				<td width="680" colspan="2">
					<table class="tableBleu" cellspacing="0" border="0" width="100%">
<% sOldMenu = ""; %>
<logic:iterate id="favori" name="listeFavorisForm" property="listeFavEdit" type="com.socgen.bip.metier.Favori" indexId="it">
<% Favori fav = (Favori) listeFavorisForm.getListeFavEdit().get(it.intValue());
   if (!sOldMenu.equals(fav.getMenu())) {
   		sOldMenu = fav.getMenu();
   		bNewMenu = true;
%>
						<tr height="3"><td colspan="5"></td></tr>
						<tr>
							<td class="lib" align="left" width="200" rowspan="<%= listeFavorisForm.getNbFavMenu("E", sOldMenu) %>">
								<b>Menu <%= hMenu.get(sOldMenu) %></b>
							</td>
<% } else { 
		bNewMenu = false;
%>
						<tr>
<% } %>
							<td width="420" align="left" class="linkFavoris">
							<% // Si le lien se situe dans le même menu on accède directement à la page
							   if (menuCourant.equals(sOldMenu)) { %>
								<a href="<bean:write name="favori" property="lien"/>" onmouseover="window.status='';return true"><bean:write name="favori" property="libelle"/></a>
							<% } else { 
							   // sinon on doit charger le nouveau menu
							%>
								<a href="javascript:goToFavori(this.form,'<bean:write name="favori" property="lien"/>','<bean:write name="favori" property="menu"/>')" onmouseover="window.status='';return true"><bean:write name="favori" property="libelle"/></a>
							<% } %>
							</td>
							<td class="null" width="20" align="right">
							<logic:notEqual name="it" value="0">
							<% if (!bNewMenu) { %>
								<input type="image" src="/images/monter.png" border="0" alt="Monter" onclick="javascript:ModifierOrdre(this.form,-1,'<bean:write name="favori" property="type"/>','<bean:write name="favori" property="ordre"/>','<bean:write name="favori" property="menu"/>'); return false;" >
							<% } %>
							</logic:notEqual>
							<logic:equal name="it" value="0">
								&nbsp;
							</logic:equal>
							</td>
							<td class="null" width="20" align="right">
							<logic:notEqual name="it" value="<%= Integer.toString(listeFavorisForm.getListeFavEdit().size()-1) %>">
<%  Favori favSuivant = (Favori) listeFavorisForm.getListeFavEdit().get(it.intValue()+1);
	// si le favori suivant est dans le même menu on permet la modification de l'ordre
	if (sOldMenu.equals(favSuivant.getMenu())) {
%>
								<input type="image" src="/images/descendre.png" border="0" alt="Descendre" onclick="javascript:ModifierOrdre(this.form,1,'<bean:write name="favori" property="type"/>','<bean:write name="favori" property="ordre"/>','<bean:write name="favori" property="menu"/>'); return false;" >
<% 	} else { %>
								&nbsp;
<%  } %>
							</logic:notEqual>
							<logic:equal name="it" value="<%= Integer.toString(listeFavorisForm.getListeFavEdit().size()-1) %>">
								&nbsp;
							</logic:equal>
							</td>
							<td class="null" width="20" align="right">
								<input type="image" src="/images/imageKO.bmp" border="0" alt="Supprimer" onclick="javascript:Supprimer(this.form,'<bean:write name="favori" property="type"/>','<bean:write name="favori" property="ordre"/>','<bean:write name="favori" property="menu"/>')" >
							</td>
						</tr>
</logic:iterate>						
					</table>
				</td>
			</tr>

			<tr>
				<td height="15px"></td>
			</tr>
			<tr>
				<td class="lib">
					<div align="center"><b>Extractions</b></div>
				</td>
			</tr>
			<tr align="left">				
				<td width="680" colspan="2">
					<table class="tableBleu" cellspacing="0" border="0" width="100%">
<% sOldMenu = ""; %>
<logic:iterate id="favori" name="listeFavorisForm" property="listeFavExtract" type="com.socgen.bip.metier.Favori" indexId="it">
<% Favori fav = (Favori) listeFavorisForm.getListeFavExtract().get(it.intValue());
   if (!sOldMenu.equals(fav.getMenu())) {
   		sOldMenu = fav.getMenu();
   		bNewMenu = true;
%>
						<tr height="3"><td colspan="5"></td></tr>
						<tr>
							<td class="lib" align="left" width="200" rowspan="<%= listeFavorisForm.getNbFavMenu("X", sOldMenu) %>">
								<b>Menu <%= hMenu.get(sOldMenu) %></b>
							</td>
<% } else { 
		bNewMenu = false;
%>
						<tr>
<% } %>
							<td  width="420" align="left" class="linkFavoris">
							<% // Si le lien se situe dans le même menu on accède directement à la page
							   if (menuCourant.equals(sOldMenu)) { %>
								<a href="<bean:write name="favori" property="lien"/>" onmouseover="window.status='';return true"><bean:write name="favori" property="libelle"/></a>
							<% } else { 
							   // sinon on doit charger le nouveau menu
							%>
								<a href="javascript:goToFavori(this.form,'<bean:write name="favori" property="lien"/>','<bean:write name="favori" property="menu"/>')" onmouseover="window.status='';return true"><bean:write name="favori" property="libelle"/></a>
							<% } %>
							</td>
							<td class="null" width="20" align="right">
							<logic:notEqual name="it" value="0">
							<% if (!bNewMenu) { %>
								<input type="image" src="/images/monter.png" border="0" alt="Monter" onclick="javascript:ModifierOrdre(this.form,-1,'<bean:write name="favori" property="type"/>','<bean:write name="favori" property="ordre"/>','<bean:write name="favori" property="menu"/>'); return false;" >
							<% } %>
							</logic:notEqual>
							<logic:equal name="it" value="0">
								&nbsp;
							</logic:equal>
							</td>
							<td class="null" width="20" align="right">
							<logic:notEqual name="it" value="<%= Integer.toString(listeFavorisForm.getListeFavExtract().size()-1) %>">
<%  Favori favSuivant = (Favori) listeFavorisForm.getListeFavExtract().get(it.intValue()+1);
	// si le favori suivant est dans le même menu on permet la modification de l'ordre
	if (sOldMenu.equals(favSuivant.getMenu())) {
%>
								<input type="image" src="/images/descendre.png" border="0" alt="Descendre" onclick="javascript:ModifierOrdre(this.form,1,'<bean:write name="favori" property="type"/>','<bean:write name="favori" property="ordre"/>','<bean:write name="favori" property="menu"/>'); return false;" >
<% 	} else { %>
								&nbsp;
<%  } %>
							</logic:notEqual>
							<logic:equal name="it" value="<%= Integer.toString(listeFavorisForm.getListeFavExtract().size()-1) %>">
								&nbsp;
							</logic:equal>
							</td>
							<td class="null" width="20" align="right">
								<input type="image" src="/images/imageKO.bmp" border="0" alt="Supprimer" onclick="javascript:Supprimer(this.form,'<bean:write name="favori" property="type"/>','<bean:write name="favori" property="ordre"/>','<bean:write name="favori" property="menu"/>')" >
							</td>
						</tr>
</logic:iterate>						
					</table>
				</td>
			</tr>
		</table>
					<!-- #EndEditable --></div>
                </td>
              </tr>
            
            </table>
            </html:form>
          </td>
        </tr>
		<tr><td>&nbsp;</td></tr>
        <tr> 
          <td> 
            <div align="center"><html:errors/></div>
          </td>
        </tr>
		<tr><td>&nbsp;</td></tr>
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
Integer id_webo_page = new Integer("1070"); 
com.socgen.bip.commun.form.AutomateForm formWebo = listeFavorisForm;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
